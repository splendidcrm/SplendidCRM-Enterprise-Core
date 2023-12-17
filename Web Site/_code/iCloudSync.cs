/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
using System;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text.RegularExpressions;
using System.Diagnostics;

using iCloud;
using iCloud.Contacts;
using iCloud.Calendar;
using System.IdentityModel.Tokens;
using System.Security.Cryptography;
using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
using System.Threading;

namespace SplendidCRM
{
	[DataContract]
	public class AppleKey
	{
		[DataMember] public string kty { get; set; }
		[DataMember] public string kid { get; set; }
		[DataMember] public string use { get; set; }
		[DataMember] public string alg { get; set; }
		[DataMember] public string n   { get; set; }
		[DataMember] public string e   { get; set; }
	}

	[DataContract]
	public class AppleKeys
	{
		[DataMember] public AppleKey[] keys;
	}
	
	[DataContract]
	public class AppleAccessToken
	{
		[DataMember] public string token_type    { get; set; }
		[DataMember] public string expires_in    { get; set; }
		[DataMember] public string access_token  { get; set; }
		[DataMember] public string refresh_token { get; set; }
		[DataMember] public string id_token      { get; set; }

		public string AccessToken
		{
			get { return access_token;  }
			set { access_token = value; }
		}
		public string RefreshToken
		{
			get { return refresh_token;  }
			set { refresh_token = value; }
		}
		public Int64 ExpiresInSeconds
		{
			get { return Sql.ToInt64(expires_in);  }
			set { expires_in = Sql.ToString(value); }
		}
		public string TokenType
		{
			get { return token_type;  }
			set { token_type = value; }
		}
	}

	public class iCloudSync
	{
		private DbProviderFactories   DbProviderFactories  = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState  Application          = new HttpApplicationState();
		private HttpContext           Context              ;
		private Security              Security             ;
		private Sql                   Sql                  ;
		private SqlProcs              SqlProcs             ;
		private SplendidError         SplendidError        ;
		private Crm.Modules           Modules              ;
		private SyncError             SyncError            ;
		private ExchangeSecurity      ExchangeSecurity     ;

		// 04/23/2010 Paul.  Make the inside flag public so that we can access from the SystemCheck. 
		public static bool bInsideSyncAll = false;
		private static List<Guid>                 arrProcessing = new List<Guid>();
		// 01/22/2012 Paul.  Keep track of the last time we synced to prevent it from being too frequent. 
		private static Dictionary<Guid, DateTime> dictLastSync  = new Dictionary<Guid,DateTime>();

		public iCloudSync(IHttpContextAccessor httpContextAccessor, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, Crm.Modules Modules, SyncError SyncError, ExchangeSecurity ExchangeSecurity)
		{
			this.Context               = httpContextAccessor.HttpContext;
			this.Security              = Security             ;
			this.Sql                   = Sql                  ;
			this.SqlProcs              = SqlProcs             ;
			this.SplendidError         = SplendidError        ;
			this.Modules               = Modules              ;
			this.SyncError             = SyncError            ;
			this.ExchangeSecurity      = ExchangeSecurity     ;
		}

		public string BuildFormattedAddress(StructuredPostalAddress adr)
		{
			StringBuilder sb = new StringBuilder();
			if ( !Sql.IsEmptyString(adr.Street) )
			{
				if( adr.Street.EndsWith("\n") )
					sb.Append(adr.Street);
				else
					sb.AppendLine(adr.Street);
			}
			if ( !Sql.IsEmptyString(adr.City) || !Sql.IsEmptyString(adr.Region) || !Sql.IsEmptyString(adr.Postcode) )
			{
				sb.Append(adr.City);
				if ( !Sql.IsEmptyString(adr.City) && (!Sql.IsEmptyString(adr.Region) || !Sql.IsEmptyString(adr.Postcode)) )
					sb.Append(", ");
				sb.Append(adr.Region);
				if ( !Sql.IsEmptyString(adr.Postcode) && (!Sql.IsEmptyString(adr.City) || !Sql.IsEmptyString(adr.Region)) )
					sb.Append(" ");
				sb.Append(adr.Postcode);
				sb.AppendLine();
			}
			if ( !Sql.IsEmptyString(adr.Country) )
			{
				sb.AppendLine(adr.Country);
			}
			return sb.ToString();
		}

		public void GetUserCredentials(HttpApplicationState Application, Guid gUSER_ID, ref string sICLOUD_USERNAME, ref string sICLOUD_PASSWORD, ref string sICLOUD_CTAG_CONTACTS, ref string sICLOUD_CTAG_CALENDAR)
		{
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				sSQL = "select ICLOUD_SYNC_CONTACTS" + ControlChars.CrLf
				     + "     , ICLOUD_SYNC_CALENDAR" + ControlChars.CrLf
				     + "     , ICLOUD_USERNAME     " + ControlChars.CrLf
				     + "     , ICLOUD_PASSWORD     " + ControlChars.CrLf
				     + "     , ICLOUD_CTAG_CONTACTS" + ControlChars.CrLf
				     + "     , ICLOUD_CTAG_CALENDAR" + ControlChars.CrLf
				     + "  from vwICLOUD_USERS      " + ControlChars.CrLf
				     + " where USER_ID = @USER_ID  " + ControlChars.CrLf
				     + " order by ICLOUD_USERNAME  " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							sICLOUD_USERNAME      = Sql.ToString(rdr["ICLOUD_USERNAME"     ]);
							sICLOUD_PASSWORD      = Sql.ToString(rdr["ICLOUD_PASSWORD"     ]);
							sICLOUD_CTAG_CONTACTS = Sql.ToString(rdr["ICLOUD_CTAG_CONTACTS"]);
							sICLOUD_CTAG_CALENDAR = Sql.ToString(rdr["ICLOUD_CTAG_CALENDAR"]);
							
							Guid gINBOUND_EMAIL_KEY = Sql.ToGuid(Application["CONFIG.InboundEmailKey"]);
							Guid gINBOUND_EMAIL_IV  = Sql.ToGuid(Application["CONFIG.InboundEmailIV" ]);
							if ( !Sql.IsEmptyString(sICLOUD_PASSWORD) )
								sICLOUD_PASSWORD = Security.DecryptPassword(sICLOUD_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
						}
					}
				}
			}
		}

		public DataTable CreateContactsTable(HttpApplicationState Application, ref IDbCommand spCONTACTS_Update)
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("UID"             , typeof(String  ));
			dt.Columns.Add("NAME"            , typeof(String  ));
			dt.Columns.Add("DATE_ENTERED"    , typeof(DateTime));
			dt.Columns.Add("DATE_MODIFIED"   , typeof(DateTime));
			dt.Columns.Add("ASSIGNED_TO_NAME", typeof(String  ));
			dt.Columns.Add("CREATED_BY_NAME" , typeof(String  ));
			dt.Columns.Add("MODIFIED_BY_NAME", typeof(String  ));
			dt.Columns.Add("TEAM_NAME"       , typeof(String  ));
			dt.Columns.Add("TEAM_SET_NAME"   , typeof(String  ));
			dt.Columns.Add("SYNC_CONTACT"    , typeof(bool    ));
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				spCONTACTS_Update = SqlProcs.Factory(con, "spCONTACTS_Update");
				foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
				{
					// 02/28/2012 Paul.  Parameters need to be initialized to DBNull.Value. 
					par.Value = DBNull.Value;
					string sParameterName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
					if ( dt.Columns.Contains(sParameterName) )
						continue;
					switch ( par.DbType )
					{
						case DbType.Guid    : dt.Columns.Add(sParameterName, typeof(Guid    ));  break;
						case DbType.Int16   : dt.Columns.Add(sParameterName, typeof(Int16   ));  break;
						case DbType.Int32   : dt.Columns.Add(sParameterName, typeof(Int32   ));  break;
						case DbType.Int64   : dt.Columns.Add(sParameterName, typeof(Int64   ));  break;
						case DbType.Double  : dt.Columns.Add(sParameterName, typeof(Double  ));  break;
						case DbType.Decimal : dt.Columns.Add(sParameterName, typeof(Decimal ));  break;
						case DbType.Byte    : dt.Columns.Add(sParameterName, typeof(Byte    ));  break;
						case DbType.Boolean : dt.Columns.Add(sParameterName, typeof(bool    ));  break;
						case DbType.DateTime: dt.Columns.Add(sParameterName, typeof(DateTime));  break;
						default             : dt.Columns.Add(sParameterName, typeof(String  ));  break;
					}
				}
			}
			return dt;
		}

		public DataTable CreateAppointmentsTable(HttpApplicationState Application, ref IDbCommand spAPPOINTMENTS_Update)
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("UID"             , typeof(String  ));
			dt.Columns.Add("NAME"            , typeof(String  ));
			dt.Columns.Add("DATE_ENTERED"    , typeof(DateTime));
			dt.Columns.Add("DATE_MODIFIED"   , typeof(DateTime));
			dt.Columns.Add("ASSIGNED_TO_NAME", typeof(String  ));
			dt.Columns.Add("CREATED_BY_NAME" , typeof(String  ));
			dt.Columns.Add("MODIFIED_BY_NAME", typeof(String  ));
			dt.Columns.Add("TEAM_NAME"       , typeof(String  ));
			dt.Columns.Add("TEAM_SET_NAME"   , typeof(String  ));
			dt.Columns.Add("SYNC_CONTACT"    , typeof(bool    ));
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				spAPPOINTMENTS_Update = SqlProcs.Factory(con, "spAPPOINTMENTS_Update");
				foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
				{
					// 02/28/2012 Paul.  Parameters need to be initialized to DBNull.Value. 
					par.Value = DBNull.Value;
					string sParameterName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
					if ( dt.Columns.Contains(sParameterName) )
						continue;
					switch ( par.DbType )
					{
						case DbType.Guid    : dt.Columns.Add(sParameterName, typeof(Guid    ));  break;
						case DbType.Int16   : dt.Columns.Add(sParameterName, typeof(Int16   ));  break;
						case DbType.Int32   : dt.Columns.Add(sParameterName, typeof(Int32   ));  break;
						case DbType.Int64   : dt.Columns.Add(sParameterName, typeof(Int64   ));  break;
						case DbType.Double  : dt.Columns.Add(sParameterName, typeof(Double  ));  break;
						case DbType.Decimal : dt.Columns.Add(sParameterName, typeof(Decimal ));  break;
						case DbType.Byte    : dt.Columns.Add(sParameterName, typeof(Byte    ));  break;
						case DbType.Boolean : dt.Columns.Add(sParameterName, typeof(bool    ));  break;
						case DbType.DateTime: dt.Columns.Add(sParameterName, typeof(DateTime));  break;
						default             : dt.Columns.Add(sParameterName, typeof(String  ));  break;
					}
				}
			}
			return dt;
		}

		public DataTable CreateParticipantsTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("ICLOUD_ID"    , typeof(String));
			dt.Columns.Add("NAME"         , typeof(String));
			dt.Columns.Add("EMAIL1"       , typeof(String));
			dt.Columns.Add("REL"          , typeof(String));
			dt.Columns.Add("PREFIX"       , typeof(String));
			dt.Columns.Add("ACCEPT_STATUS", typeof(String));
			dt.Columns.Add("TYPE"         , typeof(String));
			dt.Columns.Add("REQUIRED"     , typeof(bool  ));
			return dt;
		}

		public bool Validate_iCloud(string sICLOUD_USERNAME, string sICLOUD_PASSWORD, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				ContactsService service = new ContactsService(Application);
				// 01/20/2012 Paul.  Use the SplendidCRM unique key as the iCloud MmeDeviceID. 
				service.setUserCredentials(sICLOUD_USERNAME, sICLOUD_PASSWORD, String.Empty, String.Empty, Sql.ToString(Application["CONFIG.unique_key"]));
				service.QueryClientLoginToken(true);
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

#pragma warning disable CA1416
		// https://accedia.com/blog/dotnetifying-sign-in-with-apple/
		// https://www.scottbrady91.com/c-sharp/jwt-signing-using-ecdsa-in-dotnet-core
		public string GenerateAppleClientSecret(HttpApplicationState Application)
		{
			string privateKey = Sql.ToString(Application["CONFIG.iCloud.PrivateKey"]);
			string keyId      = Sql.ToString(Application["CONFIG.iCloud.KeyID"     ]); //The 10-character key identifier from the portal.
			string clientId   = Sql.ToString(Application["CONFIG.iCloud.ClientID"  ]);
			string teamId     = Sql.ToString(Application["CONFIG.iCloud.TeamID"    ]);
			// Put here the content of the .p8 file (without -----BEGIN PRIVATE KEY----- and -----END PRIVATE KEY-----)
			privateKey = privateKey.Replace("-----BEGIN PRIVATE KEY-----", "");
			privateKey = privateKey.Replace("-----END PRIVATE KEY-----", "");
			privateKey = privateKey.Trim();
			
			// Import the key using a Pkcs8PrivateBlob.
			// https://referencesource.microsoft.com/#system.core/System/Security/Cryptography/CngKey.cs
			// 02/15/2022 Paul.  In order for this to succeed, you must enable "Load User Profile" in the IIS Application Pool, under Process Module. 
			CngKey cngKey = CngKey.Import(Convert.FromBase64String(privateKey), CngKeyBlobFormat.Pkcs8PrivateBlob, CngProvider.MicrosoftSoftwareKeyStorageProvider);
			
			// 11/11/2023 Paul.  ECDsaCng is only supported on Windows platform. 
			// Create new ECDsaCng object with the imported key.
			using ( ECDsaCng ecDsaCng = new ECDsaCng(cngKey) )
			{
				ecDsaCng.HashAlgorithm = CngAlgorithm.ECDsaP256;
			
				// Create new SigningCredentials instance which will be used for signing the token.
				// https://dotnetfiddle.net/ictKZS
				// https://www.nuget.org/packages/Microsoft.IdentityModel.Tokens/
				Microsoft.IdentityModel.Tokens.SigningCredentials signingCredentials = new Microsoft.IdentityModel.Tokens.SigningCredentials(new Microsoft.IdentityModel.Tokens.ECDsaSecurityKey(ecDsaCng), Microsoft.IdentityModel.Tokens.SecurityAlgorithms.EcdsaSha256);
			
				DateTime now = DateTime.UtcNow;
				// Create new list with the required claims.
				var claims = new List<Claim>
				{
					new Claim("iss", teamId),
					new Claim("iat", Microsoft.IdentityModel.Tokens.EpochTime.GetIntDate(now).ToString(), ClaimValueTypes.Integer64),
					new Claim("exp", Microsoft.IdentityModel.Tokens.EpochTime.GetIntDate(now.AddMinutes(5)).ToString(), ClaimValueTypes.Integer64),
					new Claim("aud", "https://appleid.apple.com"),
					new Claim("sub", clientId)
				};
			
				// Create the JSON Web Token object.
				// https://www.nuget.org/packages/System.IdentityModel.Tokens.Jwt/
				System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler tokenHandler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
				System.IdentityModel.Tokens.Jwt.JwtSecurityToken token = new System.IdentityModel.Tokens.Jwt.JwtSecurityToken
				(
					issuer: teamId,
					claims: claims,
					expires: now.AddMinutes(5),
					signingCredentials: signingCredentials
				);
				token.Header.Add("kid", keyId);
				return tokenHandler.WriteToken(token);
			}
		}
#pragma warning restore CA1416

		public void AcquireAccessToken(Guid gUSER_ID, string sCode, string sIdToken, StringBuilder sbErrors)
		{
			HttpRequest          Request     = Context.Request;
			string sOAuthAccessToken  = String.Empty;
			string sOAuthRefreshToken = String.Empty;
			string sOAuthExpiresAt    = String.Empty;
			try
			{
				//var state    = '60e1d424-6345-4910-b15e-43ad1a0d70c7';
				//var code     = 'c143173d86d364560bb82f011ddd67c8b.0.mwzz.iMxoC3QDtTMesBvbkwIYpQ';
				//var id_token = 'eyJraWQiOiJXNldjT0tCIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLnNwbGVuZGlkY3JtLmRldmVsb3BlcjExLnNwbGVuZGlkY3JtNiIsImV4cCI6MTY0NDkxODQ1NywiaWF0IjoxNjQ0ODMyMDU3LCJzdWIiOiIwMDA2OTkuMTlkNjRlNGFmODg3NDhkMjhmZjA5ZDFjZDhkYmY4MjUuMDc0MyIsImNfaGFzaCI6IkZlSXV3aGVWYUtnNFg2Nmt5RU5KTEEiLCJlbWFpbCI6InBhdWxAc3BsZW5kaWRjcm0uY29tIiwiZW1haWxfdmVyaWZpZWQiOiJ0cnVlIiwiYXV0aF90aW1lIjoxNjQ0ODMyMDU3LCJub25jZV9zdXBwb3J0ZWQiOnRydWV9.DjQo34BuQ5zIIG8eVn_PS1nAXeo8XKc8NHEfZ46IVgg7GLCkDq0pwL7umUGEXf7SqrjGwrsutqsHxjflQccbMtYr8joXO-cvr3V43-FE-usPEHurffOzPDoFRgi_-DRGOfu92oSmbFnomcDPzdHpyLX91oCwcg6zHzY03osb-eFJFOeXetILOqte0RxKqSSIje3uoPfrLMaA22aCtsdtY4etilKsKXH04AQGUORtN9YuHfPsK0sZ4amNotYzh-wHeC__Arj-Of53MNxkj_Fgrwm-4772zxnb-CoD8Q3295RJyGpSgJiiWfSC5eUk909tHauWBpj7F_YVD3OjPiegdQ';
				//var error    = '';
				DataContractJsonSerializer serializer = null;
				List<Microsoft.IdentityModel.Tokens.SecurityKey> signingTokens = Application["Apple.iCloud.Keys"] as List<Microsoft.IdentityModel.Tokens.SecurityKey>;
				// https://geeksqa.com/json-web-token-validity-verification-passed-on-net-core-but-failed-on-net-4-6-1
				if ( signingTokens == null )
				{
						signingTokens = new List<Microsoft.IdentityModel.Tokens.SecurityKey>();
						WebRequest webRequest = (WebRequest) WebRequest.Create("https://appleid.apple.com/auth/keys");
						webRequest.PreAuthenticate   = true ;
						webRequest.Timeout           = 10000;  //10 seconds
						webRequest.Method            = "GET";
						using ( WebResponse webResponse = webRequest.GetResponse() )
						{
							serializer = new DataContractJsonSerializer(typeof(AppleKeys));
							AppleKeys jsonKeys = (AppleKeys) serializer.ReadObject(webResponse.GetResponseStream());
							foreach (AppleKey webKey in jsonKeys.keys)
							{
								byte[] e = Microsoft.IdentityModel.Tokens.Base64UrlEncoder.DecodeBytes(webKey.e);
								byte[] n = Microsoft.IdentityModel.Tokens.Base64UrlEncoder.DecodeBytes(webKey.n);
								RSAParameters param = new RSAParameters { Exponent = e, Modulus = n };
								RSA rsa = RSA.Create(param);
								Microsoft.IdentityModel.Tokens.RsaSecurityKey key = new Microsoft.IdentityModel.Tokens.RsaSecurityKey(rsa);
								signingTokens.Add(key);
							}
							Application["Apple.iCloud.Keys"] = signingTokens;
						}
				}
				// https://github.com/Accedia/appleauth-net/blob/master/Cryptography/TokenGenerator.cs
				string sClientID = Sql.ToString(Application["CONFIG.iCloud.ClientID"]);
				System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler tokenHandler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
				Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
				{
					ValidIssuer         = "https://appleid.apple.com",
					//IssuerSigningKey    = signingKey,
					IssuerSigningKeyResolver = (token, securityToken, kid, parameters) => signingTokens,
					ValidAudience       = sClientID
				};

				Microsoft.IdentityModel.Tokens.SecurityToken validatedToken = null;
				// Throws an Exception as the token is invalid (expired, invalid-formatted, etc.)
				System.Security.Claims.ClaimsPrincipal identity = tokenHandler.ValidateToken(sIdToken, validationParameters, out validatedToken);
				if ( identity != null )
				{
					string sUSER_NAME  = String.Empty;
					string sLAST_NAME  = String.Empty;
					string sFIRST_NAME = String.Empty;
					string sEMAIL1     = String.Empty;
					foreach ( System.Security.Claims.Claim claim in identity.Claims )
					{
						//Debug.WriteLine(claim.Type + " = " + claim.Value);
						// iss = https://appleid.apple.com
						// aud = com.splendidcrm.developer11.splendidcrm6
						// exp = 1644950697
						// iat = 1644864297
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier = 000699.19d64e4af88748d28ff09d1cd8dbf825.0743
						// c_hash = -ybN_r_1KLwdFCpehhD-YA
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress = paul@splendidcrm.com
						// email_verified = true
						// http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationinstant = 1644864297
						// nonce_supported = true
						switch ( claim.Type )
						{
							// 12/25/2018 Paul.  Remove live.com# prefix. 
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"          :  sUSER_NAME  = claim.Value;  break;
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"       :  sLAST_NAME  = claim.Value;  break;
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"     :  sFIRST_NAME = claim.Value;  break;
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"  :  sEMAIL1     = claim.Value;  break;
						}
					}
					if ( Sql.IsEmptyString(sEMAIL1) && sUSER_NAME.Contains("@") )
						sEMAIL1 = sUSER_NAME;
					
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						AppleAccessToken token = null;
						try
						{
							// https://developer.apple.com/documentation/sign_in_with_apple/generate_and_validate_tokens
							// https://www.scottbrady91.com/openid-connect/implementing-sign-in-with-apple-in-aspnet-core
							HttpWebRequest webRequest = (HttpWebRequest) WebRequest.Create("https://appleid.apple.com/auth/token");
							webRequest.UserAgent   = "Auth0";
							webRequest.ContentType = "application/x-www-form-urlencoded";
							webRequest.Method      = "POST";
							webRequest.Accept      = "application/json";
							string sRequestBody = String.Empty;
							sRequestBody += "grant_type=authorization_code";
							sRequestBody += "&client_id="     + HttpUtility.UrlEncode(Sql.ToString(Application["CONFIG.iCloud.ClientID"]));
							sRequestBody += "&code="          + HttpUtility.UrlEncode(sCode);
							sRequestBody += "&redirect_uri="  + HttpUtility.UrlEncode("https://" + Request.Host.Host + Sql.ToString(Application["rootURL"]) + "OAuth/iCloudLanding.aspx");
							sRequestBody += "&client_secret=" + HttpUtility.UrlEncode(GenerateAppleClientSecret(Application));
							byte[] bytes = System.Text.Encoding.ASCII.GetBytes(sRequestBody);
							webRequest.ContentLength = bytes.Length;
							using ( Stream outputStream = webRequest.GetRequestStream() )
							{
								outputStream.Write(bytes, 0, bytes.Length);
							}
							using ( WebResponse webResponse = webRequest.GetResponse() )
							{
								serializer = new DataContractJsonSerializer(typeof(AppleAccessToken));
								token = (AppleAccessToken) serializer.ReadObject(webResponse.GetResponseStream());
							}
						}
						catch
						{
							// 01/16/2017 Paul.  If the refresh fails, delete the database record so that we will not retry the sync. 
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spOAUTH_TOKENS_Delete(gUSER_ID, "iCloud", trn);
									trn.Commit();
								}
								catch
								{
									trn.Rollback();
								}
							}
							throw;
						}
						sOAuthAccessToken  = token.AccessToken ;
						sOAuthRefreshToken = token.RefreshToken;
						DateTime dtOAuthExpiresAt   = DateTime.Now.AddSeconds(token.ExpiresInSeconds);
						sOAuthExpiresAt    = dtOAuthExpiresAt.ToShortDateString() + " " + dtOAuthExpiresAt.ToShortTimeString();
						Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
						Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
						Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spOAUTH_TOKENS_Update(gUSER_ID, "iCloud", sOAuthAccessToken, String.Empty, dtOAuthExpiresAt, sOAuthRefreshToken, trn);
								trn.Commit();
							}
							catch
							{
								trn.Rollback();
								throw;
							}
						}
					}
				}
				else
				{
					sbErrors.Append("Apple security token failed validation.");
				}
			}
			catch(Exception ex)
			{
				sbErrors.Append(ex.Message);
			}
		}

		public AppleAccessToken RefreshAccessToken(Guid gUSER_ID, bool bForceRefresh)
		{
			HttpRequest          Request     = Context.Request;
			string sOAuthAccessToken  = Sql.ToString(Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthAccessToken" ]);
			string sOAuthRefreshToken = Sql.ToString(Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthRefreshToken"]);
			string sOAuthExpiresAt    = Sql.ToString(Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ]);
			AppleAccessToken token = null;
			try
			{
				DateTime dtOAuthExpiresAt = Sql.ToDateTime(sOAuthExpiresAt);
				if ( Sql.IsEmptyString(sOAuthAccessToken) || dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now.AddMinutes(15) > dtOAuthExpiresAt || bForceRefresh )
				{
					Application.Remove("CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthAccessToken" );
					Application.Remove("CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthRefreshToken");
					Application.Remove("CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthExpiresAt"   );
					
					sOAuthAccessToken = String.Empty;
					dtOAuthExpiresAt  = DateTime.MinValue;
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						if ( Sql.IsEmptyString(sOAuthAccessToken) )
						{
							string sSQL = String.Empty;
							sSQL = "select TOKEN                               " + ControlChars.CrLf
							     + "     , TOKEN_EXPIRES_AT                    " + ControlChars.CrLf
							     + "     , REFRESH_TOKEN                       " + ControlChars.CrLf
							     + "  from vwOAUTH_TOKENS                      " + ControlChars.CrLf
							     + " where NAME             = @NAME            " + ControlChars.CrLf
							     + "   and ASSIGNED_USER_ID = @ASSIGNED_USER_ID" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@NAME"            , "iCloud");
								Sql.AddParameter(cmd, "@ASSIGNED_USER_ID", gUSER_ID);
								using ( IDataReader rdr = cmd.ExecuteReader() )
								{
									if ( rdr.Read() )
									{
										sOAuthAccessToken  = Sql.ToString  (rdr["TOKEN"           ]);
										sOAuthRefreshToken = Sql.ToString  (rdr["REFRESH_TOKEN"   ]);
										dtOAuthExpiresAt   = Sql.ToDateTime(rdr["TOKEN_EXPIRES_AT"]);
										sOAuthExpiresAt    = dtOAuthExpiresAt.ToShortDateString() + " " + dtOAuthExpiresAt.ToShortTimeString();
									}
								}
							}
						}
						if ( Sql.IsEmptyString(sOAuthAccessToken) )
						{
							throw(new Exception("Apple iCloud Access Token does not exist for user " + gUSER_ID.ToString()));
						}
						else if ( Sql.IsEmptyString(sOAuthRefreshToken) )
						{
							throw(new Exception("Apple iCloud Refresh Token does not exist for user " + gUSER_ID.ToString()));
						}
						else if ( dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now.AddMinutes(15) > dtOAuthExpiresAt || bForceRefresh )
						{
							try
							{
								// https://developer.apple.com/documentation/sign_in_with_apple/generate_and_validate_tokens
								// https://www.scottbrady91.com/openid-connect/implementing-sign-in-with-apple-in-aspnet-core
								HttpWebRequest webRequest = (HttpWebRequest) WebRequest.Create("https://appleid.apple.com/auth/token");
								webRequest.UserAgent   = "Auth0";
								webRequest.ContentType = "application/x-www-form-urlencoded";
								webRequest.Method      = "POST";
								webRequest.Accept      = "application/json";
								string sRequestBody = String.Empty;
								sRequestBody += "grant_type=refresh_token";
								sRequestBody += "&client_id="     + HttpUtility.UrlEncode(Sql.ToString(Application["CONFIG.iCloud.ClientID"]));
								sRequestBody += "&refresh_token=" + HttpUtility.UrlEncode(sOAuthRefreshToken);
								//sRequestBody += "&redirect_uri="  + HttpUtility.UrlEncode("https://" + Request.Host.Host + Sql.ToString(Application["rootURL"]) + "OAuth/iCloudLanding.aspx");
								sRequestBody += "&client_secret=" + HttpUtility.UrlEncode(GenerateAppleClientSecret(Application));
								byte[] bytes = System.Text.Encoding.ASCII.GetBytes(sRequestBody);
								webRequest.ContentLength = bytes.Length;
								using ( Stream outputStream = webRequest.GetRequestStream() )
								{
									outputStream.Write(bytes, 0, bytes.Length);
								}
								using ( WebResponse webResponse = webRequest.GetResponse() )
								{
									DataContractJsonSerializer serializer = null;
									serializer = new DataContractJsonSerializer(typeof(AppleKeys));
									serializer = new DataContractJsonSerializer(typeof(AppleAccessToken));
									token = (AppleAccessToken) serializer.ReadObject(webResponse.GetResponseStream());
								}
							}
							catch
							{
								// 02/15/2022 Paul.  If the refresh fails, delete the database record so that we will not retry the sync. 
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
										Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
										Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
										// 01/16/2017 Paul.  This method needed to be called within the transaction. 
										SqlProcs.spOAUTH_TOKENS_Delete(gUSER_ID, "iCloud", trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
									}
								}
								throw;
							}
							
							sOAuthAccessToken  = token.AccessToken ;
							sOAuthRefreshToken = token.RefreshToken;
							dtOAuthExpiresAt   = DateTime.Now.AddSeconds(token.ExpiresInSeconds);
							sOAuthExpiresAt    = dtOAuthExpiresAt.ToShortDateString() + " " + dtOAuthExpiresAt.ToShortTimeString();
							Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
							Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
							Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spOAUTH_TOKENS_Update(gUSER_ID, "iCloud", sOAuthAccessToken, String.Empty, dtOAuthExpiresAt, sOAuthRefreshToken, trn);
									trn.Commit();
								}
								catch
								{
									trn.Rollback();
									throw;
								}
							}
						}
						else
						{
							Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
							Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
							Application["CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
							token = new AppleAccessToken();
							token.AccessToken      = sOAuthAccessToken ;
							token.RefreshToken     = sOAuthRefreshToken;
							token.ExpiresInSeconds = Convert.ToInt64((dtOAuthExpiresAt - DateTime.Now).TotalSeconds);
							token.TokenType        = "Bearer";
						}
					}
				}
				else
				{
					token = new AppleAccessToken();
					token.AccessToken      = sOAuthAccessToken ;
					token.RefreshToken     = sOAuthRefreshToken;
					token.ExpiresInSeconds = Convert.ToInt64((dtOAuthExpiresAt - DateTime.Now).TotalSeconds);
					token.TokenType        = "Bearer";
				}
			}
			catch
			{
				Application.Remove("CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthAccessToken" );
				Application.Remove("CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthRefreshToken");
				Application.Remove("CONFIG.iCloud." + gUSER_ID.ToString() + ".OAuthExpiresAt"   );
				throw;
			}
			return token;
		}

#pragma warning disable CS1998
		public async ValueTask SyncAllUsers(CancellationToken token)
		{
			SyncAllUsers();
		}
#pragma warning restore CS1998

		public void SyncAllUsers()
		{
			bool bICLOUDEnabled = Sql.ToBoolean(Application["CONFIG.iCloud.Enabled"]);
			if ( !bInsideSyncAll && bICLOUDEnabled )
			{
				bInsideSyncAll = true;
				try
				{
					using ( DataTable dt = new DataTable() )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select ICLOUD_SYNC_CONTACTS" + ControlChars.CrLf
							     + "     , ICLOUD_SYNC_CALENDAR" + ControlChars.CrLf
							     + "     , ICLOUD_USERNAME     " + ControlChars.CrLf
							     + "     , ICLOUD_PASSWORD     " + ControlChars.CrLf
							     + "     , ICLOUD_CTAG_CONTACTS" + ControlChars.CrLf
							     + "     , ICLOUD_CTAG_CALENDAR" + ControlChars.CrLf
							     + "     , USER_ID             " + ControlChars.CrLf
							     + "  from vwICLOUD_USERS      " + ControlChars.CrLf
							     + " order by ICLOUD_USERNAME  " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dt);
								}
							}
						}
						// 03/29/2010 Paul.  Process the users outside the connection scope. 
						foreach ( DataRow row in dt.Rows )
						{
							bool   bICLOUD_SYNC_CONTACTS = Sql.ToBoolean(row["ICLOUD_SYNC_CONTACTS"]);
							bool   bICLOUD_SYNC_CALENDAR = Sql.ToBoolean(row["ICLOUD_SYNC_CALENDAR"]);
							string sICLOUD_USERNAME      = Sql.ToString (row["ICLOUD_USERNAME"     ]);
							string sICLOUD_PASSWORD      = Sql.ToString (row["ICLOUD_PASSWORD"     ]);
							string sICLOUD_CTAG_CONTACTS = Sql.ToString (row["ICLOUD_CTAG_CONTACTS"]);
							string sICLOUD_CTAG_CALENDAR = Sql.ToString (row["ICLOUD_CTAG_CALENDAR"]);
							Guid   gUSER_ID              = Sql.ToGuid   (row["USER_ID"             ]);
							StringBuilder sbErrors = new StringBuilder();
							iCloudSync.UserSync User = new iCloudSync.UserSync(Security, Sql, SqlProcs, SplendidError, SyncError, ExchangeSecurity, this, bICLOUD_SYNC_CONTACTS, bICLOUD_SYNC_CALENDAR, sICLOUD_USERNAME, sICLOUD_PASSWORD, gUSER_ID, sICLOUD_CTAG_CONTACTS, sICLOUD_CTAG_CALENDAR, false);
							Sync(User, sbErrors);
						}
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
				finally
				{
					bInsideSyncAll = false;
				}
			}
		}

		// 01/22/2012 Paul.  The workflow engine will fire user sync events when a record changes. 
		public void SyncUser(Guid gUSER_ID)
		{
			bool bICLOUDEnabled = Sql.ToBoolean(Application["CONFIG.iCloud.Enabled"]);
			if ( bICLOUDEnabled )
			{
				try
				{
					using ( DataTable dt = new DataTable() )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select ICLOUD_SYNC_CONTACTS" + ControlChars.CrLf
							     + "     , ICLOUD_SYNC_CALENDAR" + ControlChars.CrLf
							     + "     , ICLOUD_USERNAME     " + ControlChars.CrLf
							     + "     , ICLOUD_PASSWORD     " + ControlChars.CrLf
							     + "     , ICLOUD_CTAG_CONTACTS" + ControlChars.CrLf
							     + "     , ICLOUD_CTAG_CALENDAR" + ControlChars.CrLf
							     + "     , USER_ID             " + ControlChars.CrLf
							     + "  from vwICLOUD_USERS      " + ControlChars.CrLf
							     + " where USER_ID = @USER_ID  " + ControlChars.CrLf
							     + " order by ICLOUD_USERNAME  " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dt);
								}
							}
						}
						// 03/29/2010 Paul.  Process the users outside the connection scope. 
						foreach ( DataRow row in dt.Rows )
						{
							bool   bICLOUD_SYNC_CONTACTS = Sql.ToBoolean(row["ICLOUD_SYNC_CONTACTS"]);
							bool   bICLOUD_SYNC_CALENDAR = Sql.ToBoolean(row["ICLOUD_SYNC_CALENDAR"]);
							string sICLOUD_USERNAME      = Sql.ToString (row["ICLOUD_USERNAME"     ]);
							string sICLOUD_PASSWORD      = Sql.ToString (row["ICLOUD_PASSWORD"     ]);
							string sICLOUD_CTAG_CONTACTS = Sql.ToString (row["ICLOUD_CTAG_CONTACTS"]);
							string sICLOUD_CTAG_CALENDAR = Sql.ToString (row["ICLOUD_CTAG_CALENDAR"]);
							StringBuilder sbErrors = new StringBuilder();
							iCloudSync.UserSync User = new iCloudSync.UserSync(Security, Sql, SqlProcs, SplendidError, SyncError, ExchangeSecurity, this, bICLOUD_SYNC_CONTACTS, bICLOUD_SYNC_CALENDAR, sICLOUD_USERNAME, sICLOUD_PASSWORD, gUSER_ID, sICLOUD_CTAG_CONTACTS, sICLOUD_CTAG_CALENDAR, false);
							Sync(User, sbErrors);
						}
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}
		}

		public class UserSync
		{
			private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			private HttpApplicationState Application        = new HttpApplicationState();
			private Security             Security           ;
			private Sql                  Sql                ;
			private SqlProcs             SqlProcs           ;
			private SplendidError        SplendidError      ;
			private SyncError            SyncError          ;
			private ExchangeSecurity     ExchangeSecurity   ;
			private iCloudSync           iCloudSync         ;

			public bool        ICLOUD_SYNC_CONTACTS;
			public bool        ICLOUD_SYNC_CALENDAR;
			public string      ICLOUD_USERNAME     ;
			public string      ICLOUD_PASSWORD     ;
			public Guid        USER_ID             ;
			public string      ICLOUD_CTAG_CONTACTS;
			public string      ICLOUD_CTAG_CALENDAR;
			public bool        SyncAll             ;

			public UserSync(Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SyncError SyncError, ExchangeSecurity ExchangeSecurity, iCloudSync iCloudSync, bool bICLOUD_SYNC_CONTACTS, bool bICLOUD_SYNC_CALENDAR, string sICLOUD_USERNAME, string sICLOUD_PASSWORD, Guid gUSER_ID, string sICLOUD_CTAG_CONTACTS, string sICLOUD_CTAG_CALENDAR, bool bSyncAll)
			{
				this.Security            = Security           ;
				this.Sql                 = Sql                ;
				this.SqlProcs            = SqlProcs           ;
				this.SplendidError       = SplendidError      ;
				this.SyncError           = SyncError          ;
				this.ExchangeSecurity    = ExchangeSecurity   ;
				this.iCloudSync          = iCloudSync         ;

				this.ICLOUD_SYNC_CONTACTS = bICLOUD_SYNC_CONTACTS;
				this.ICLOUD_SYNC_CALENDAR = bICLOUD_SYNC_CALENDAR;
				this.ICLOUD_USERNAME      = sICLOUD_USERNAME     ;
				this.ICLOUD_PASSWORD      = sICLOUD_PASSWORD     ;
				this.USER_ID              = gUSER_ID             ;
				this.ICLOUD_CTAG_CONTACTS = sICLOUD_CTAG_CONTACTS;
				this.ICLOUD_CTAG_CALENDAR = sICLOUD_CTAG_CALENDAR;
				this.SyncAll              = bSyncAll             ;
			}
			
			public void Start()
			{
				DateTime dtStart = DateTime.Now;
				bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.iCloud.VerboseStatus"]);
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  Begin " + ICLOUD_USERNAME + ", " + USER_ID.ToString() + " at " + dtStart.ToString());
				
				StringBuilder sbErrors = new StringBuilder();
				iCloudSync.Sync(this, sbErrors);
				
				DateTime dtEnd = DateTime.Now;
				TimeSpan ts = dtEnd - dtStart;
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  End "   + ICLOUD_USERNAME + ", " + USER_ID.ToString() + " at " + dtEnd.ToString() + ". Elapse time " + ts.Minutes.ToString() + " minutes " + ts.Seconds.ToString() + " seconds.");
			}

			public UserSync Create(Guid gUSER_ID, bool bSyncAll)
			{
				iCloudSync.UserSync User = null;
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select ICLOUD_SYNC_CONTACTS" + ControlChars.CrLf
					     + "     , ICLOUD_SYNC_CALENDAR" + ControlChars.CrLf
					     + "     , ICLOUD_USERNAME     " + ControlChars.CrLf
					     + "     , ICLOUD_PASSWORD     " + ControlChars.CrLf
					     + "     , ICLOUD_CTAG_CONTACTS" + ControlChars.CrLf
					     + "     , ICLOUD_CTAG_CALENDAR" + ControlChars.CrLf
					     + "     , USER_ID             " + ControlChars.CrLf
					     + "  from vwICLOUD_USERS      " + ControlChars.CrLf
					     + " where USER_ID  = @USER_ID " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
						using ( IDataReader row = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( row.Read() )
							{
								bool   bICLOUD_SYNC_CONTACTS = Sql.ToBoolean(row["ICLOUD_SYNC_CONTACTS"]);
								bool   bICLOUD_SYNC_CALENDAR = Sql.ToBoolean(row["ICLOUD_SYNC_CALENDAR"]);
								string sICLOUD_USERNAME      = Sql.ToString (row["ICLOUD_USERNAME"     ]);
								string sICLOUD_PASSWORD      = Sql.ToString (row["ICLOUD_PASSWORD"     ]);
								string sICLOUD_CTAG_CONTACTS = Sql.ToString (row["ICLOUD_CTAG_CONTACTS"]);
								string sICLOUD_CTAG_CALENDAR = Sql.ToString (row["ICLOUD_CTAG_CALENDAR"]);
								User = new iCloudSync.UserSync(Security, Sql, SqlProcs, SplendidError, SyncError, ExchangeSecurity, iCloudSync, bICLOUD_SYNC_CONTACTS, bICLOUD_SYNC_CALENDAR, sICLOUD_USERNAME, sICLOUD_PASSWORD, gUSER_ID, sICLOUD_CTAG_CONTACTS, sICLOUD_CTAG_CALENDAR, bSyncAll);
							}
						}
					}
				}
				return User;
			}
		}

		public void Sync(iCloudSync.UserSync User, StringBuilder sbErrors)
		{
			// 01/22/2012 Paul.  If the last sync was less than 15 seconds ago, then skip this request. 
			lock ( dictLastSync )
			{
				if ( dictLastSync.ContainsKey(User.USER_ID) )
				{
					DateTime dtLastSync = dictLastSync[User.USER_ID];
					if ( dtLastSync.AddSeconds(15) > DateTime.Now )
						return;
				}
			}
			// 03/29/2010 Paul.  We need to make sure that we only have one processing operation at a time. 
			if ( !arrProcessing.Contains(User.USER_ID) )
			{
				lock ( arrProcessing )
				{
					arrProcessing.Add(User.USER_ID);
					// 01/22/2012 Paul.  Keep track of the last time we synced to prevent it from being too frequent. 
					dictLastSync[User.USER_ID] = DateTime.Now;
				}
				try
				{
					ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
					
					Guid gINBOUND_EMAIL_KEY = Sql.ToGuid(Application["CONFIG.InboundEmailKey"]);
					Guid gINBOUND_EMAIL_IV  = Sql.ToGuid(Application["CONFIG.InboundEmailIV" ]);
					if ( !Sql.IsEmptyString(User.ICLOUD_PASSWORD) )
						User.ICLOUD_PASSWORD = Security.DecryptPassword(User.ICLOUD_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
					
					if ( User.ICLOUD_SYNC_CONTACTS )
					{
						ContactsService service = new ContactsService(Application);
						// 01/20/2012 Paul.  Use the SplendidCRM unique key as the iCloud MmeDeviceID. 
						service.setUserCredentials(User.ICLOUD_USERNAME, User.ICLOUD_PASSWORD, User.ICLOUD_CTAG_CONTACTS, User.ICLOUD_CTAG_CALENDAR, Sql.ToString(Application["CONFIG.unique_key"]));
						service.QueryClientLoginToken(false);
						
						this.SyncContacts(Session, service, User.ICLOUD_USERNAME, User.USER_ID, User.SyncAll, sbErrors);
					}
					if ( User.ICLOUD_SYNC_CALENDAR )
					{
						CalendarService service = new CalendarService(Application);
						// 01/20/2012 Paul.  Use the SplendidCRM unique key as the iCloud MmeDeviceID. 
						service.setUserCredentials(User.ICLOUD_USERNAME, User.ICLOUD_PASSWORD, User.ICLOUD_CTAG_CONTACTS, User.ICLOUD_CTAG_CALENDAR, Sql.ToString(Application["CONFIG.unique_key"]));
						service.QueryClientLoginToken(false);
						
						this.SyncAppointments(Session, service, User.ICLOUD_USERNAME, User.USER_ID, User.SyncAll, sbErrors);
					}
				}
				finally
				{
					lock ( arrProcessing )
					{
						arrProcessing.Remove(User.USER_ID);
					}
				}
			}
			else
			{
				string sError = "Sync:  Already busy processing " + User.ICLOUD_USERNAME + ", " + User.USER_ID.ToString();
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
				sbErrors.AppendLine(sError);
			}
		}

		#region Sync Contacts

		public bool SetiCloudContact(ContactEntry contact, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			// 01/24/2012 Paul.  Make sure to set the modified date. 
			contact.Updated = Sql.ToDateTime(row["DATE_MODIFIED"]);
			if ( contact.Updated == DateTime.MinValue )
				contact.Updated = DateTime.Now;
			string sFILE_AS = Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]);
			sFILE_AS = sFILE_AS.Trim();
			if ( Sql.IsEmptyString(sFILE_AS) )
				sFILE_AS = "(no name)";
			if ( contact.Name == null )
			{
				// 03/28/2010 Paul.  You must load or assign this property before you can read its value. 
				// So set all the fields to empty values. 
				//contact.Categories.Add("SplendidCRM");
				contact.Name            = new Name();
				contact.Name.GivenName  = Sql.ToString(row["FIRST_NAME"  ]);
				contact.Name.FamilyName = Sql.ToString(row["LAST_NAME"   ]);
				contact.Name.FullName   = sFILE_AS;
				contact.Title           = Sql.ToString(row["TITLE"       ]);
				contact.Organization    = Sql.ToString(row["ACCOUNT_NAME"]);
				contact.Department      = Sql.ToString(row["DEPARTMENT"  ]);
				
				if ( Sql.ToDateTime(row["BIRTHDATE"]) != DateTime.MinValue )
					contact.Birthday = Sql.ToDateTime(row["BIRTHDATE"]).ToString("yyyy-MM-dd");
				
				if ( !Sql.IsEmptyString(row["DESCRIPTION"]) )
				{
					contact.Content = Sql.ToString(row["DESCRIPTION"]);
				}
				
				if ( !Sql.IsEmptyString(row["EMAIL1"]) )
				{
					EMail eEMAIL1 = new EMail(Sql.ToString(row["EMAIL1"]));
					eEMAIL1.Type     = "WORK";
					eEMAIL1.Primary  = true;
					eEMAIL1.Internet = true;
					contact.Emails.Add(eEMAIL1);
				}
				if ( !Sql.IsEmptyString(row["EMAIL2"]) )
				{
					// 01/13/2012 Paul.  Work and Home seem appropriate for email types. 
					EMail eEMAIL2 = new EMail(Sql.ToString(row["EMAIL2"]));
					eEMAIL2.Type     = "HOME";
					eEMAIL2.Internet = true;
					contact.Emails.Add(eEMAIL2);
				}
				// 01/28/2012 Paul.  iCloud does not support Assistant Phone. 
				/*
				if ( !Sql.IsEmptyString(row["ASSISTANT"]) )
				{
					Relation relASSISTANT = new Relation();
					relASSISTANT.Type  = "ASSISTANT";
					relASSISTANT.Value = Sql.ToString(row["ASSISTANT"]);
					contact.Relations.Add(relASSISTANT);
				}
				
				if ( !Sql.IsEmptyString(row["ASSISTANT_PHONE"]) )
				{
					PhoneNumber phASSISTANT_PHONE = new PhoneNumber(Sql.ToString(row["ASSISTANT_PHONE"]));
					phASSISTANT_PHONE.Type  = "ASSISTANT";
					phASSISTANT_PHONE.Voice = true;
					contact.Phonenumbers.Add(phASSISTANT_PHONE);
				}
				*/
				if ( !Sql.IsEmptyString(row["PHONE_FAX"      ]) )
				{
					PhoneNumber phPHONE_FAX = new PhoneNumber(Sql.ToString(row["PHONE_FAX"]));
					phPHONE_FAX.Type = "WORK";
					phPHONE_FAX.Fax  = true;
					contact.Phonenumbers.Add(phPHONE_FAX);
				}
				if ( !Sql.IsEmptyString(row["PHONE_WORK"]) )
				{
					PhoneNumber phPHONE_WORK = new PhoneNumber(Sql.ToString(row["PHONE_WORK"]));
					phPHONE_WORK.Type  = "WORK";
					phPHONE_WORK.Voice = true;
					contact.Phonenumbers.Add(phPHONE_WORK);
				}
				if ( !Sql.IsEmptyString(row["PHONE_MOBILE"]) )
				{
					PhoneNumber phPHONE_MOBILE = new PhoneNumber(Sql.ToString(row["PHONE_MOBILE"]));
					phPHONE_MOBILE.Type  = "CELL";
					phPHONE_MOBILE.Voice = true;
					contact.Phonenumbers.Add(phPHONE_MOBILE);
				}
				if ( !Sql.IsEmptyString(row["PHONE_OTHER"]) )
				{
					PhoneNumber phPHONE_OTHER = new PhoneNumber(Sql.ToString(row["PHONE_OTHER"]));
					phPHONE_OTHER.Type  = "OTHER";
					phPHONE_OTHER.Voice = true;
					contact.Phonenumbers.Add(phPHONE_OTHER);
				}
				if ( !Sql.IsEmptyString(row["PHONE_HOME"]) )
				{
					PhoneNumber phPHONE_HOME = new PhoneNumber(Sql.ToString(row["PHONE_HOME"]));
					phPHONE_HOME.Type  = "HOME";
					phPHONE_HOME.Voice = true;
					contact.Phonenumbers.Add(phPHONE_HOME);
				}
				
				if ( !Sql.IsEmptyString(row["PRIMARY_ADDRESS_STREET"    ])
				  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_CITY"      ])
				  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_STATE"     ])
				  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_POSTALCODE"])
				  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_COUNTRY"   ])
				   )
				{
					StructuredPostalAddress adrPRIMARY_ADDRESS = new StructuredPostalAddress();
					adrPRIMARY_ADDRESS.Primary  = true;
					adrPRIMARY_ADDRESS.Type     = "WORK";
					adrPRIMARY_ADDRESS.Street   = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);
					adrPRIMARY_ADDRESS.City     = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);
					adrPRIMARY_ADDRESS.Region   = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);
					adrPRIMARY_ADDRESS.Postcode = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);
					adrPRIMARY_ADDRESS.Country  = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);
					// 03/26/2011 Paul.  iCloud is ignoring the parts and just using the formatted address. 
					adrPRIMARY_ADDRESS.FormattedAddress = BuildFormattedAddress(adrPRIMARY_ADDRESS);
					contact.PostalAddresses.Add(adrPRIMARY_ADDRESS);
				}
				
				if ( !Sql.IsEmptyString(row["ALT_ADDRESS_STREET"        ])
				  || !Sql.IsEmptyString(row["ALT_ADDRESS_CITY"          ])
				  || !Sql.IsEmptyString(row["ALT_ADDRESS_STATE"         ])
				  || !Sql.IsEmptyString(row["ALT_ADDRESS_POSTALCODE"    ])
				  || !Sql.IsEmptyString(row["ALT_ADDRESS_COUNTRY"       ])
				   )
				{
					StructuredPostalAddress adrALT_ADDRESS = new StructuredPostalAddress();
					adrALT_ADDRESS.Type     = "HOME";
					adrALT_ADDRESS.Street   = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);
					adrALT_ADDRESS.City     = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);
					adrALT_ADDRESS.Region   = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);
					adrALT_ADDRESS.Postcode = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);
					adrALT_ADDRESS.Country  = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);
					// 03/26/2011 Paul.  iCloud is ignoring the parts and just using the formatted address. 
					adrALT_ADDRESS.FormattedAddress = BuildFormattedAddress(adrALT_ADDRESS);
					contact.PostalAddresses.Add(adrALT_ADDRESS    );
				}
				bChanged = true;
			}
			else
			{
				// 01/11/2012 Paul.  Bug whereby we were converting to DateTime and not String. 
				if ( contact.Name == null || Sql.ToString(contact.Name.GivenName) != Sql.ToString(row["FIRST_NAME"]) || Sql.ToString(contact.Name.FamilyName) != Sql.ToString(row["LAST_NAME"]) )
				{
					if ( contact.Name != null || !Sql.IsEmptyString(row["FIRST_NAME"]) || !Sql.IsEmptyString(row["LAST_NAME"]) )
					{
						if ( contact.Name == null )
						{
							contact.Name = new Name();
						}
						if ( Sql.ToString(contact.Name.GivenName ) != Sql.ToString(row["FIRST_NAME"]) )
						{
							contact.Name.GivenName  = Sql.ToString(row["FIRST_NAME"]);
							bChanged = true;
							sbChanges.AppendLine("FIRST_NAME" + " changed.");
						}
						if ( Sql.ToString(contact.Name.FamilyName) != Sql.ToString(row["LAST_NAME"]) )
						{
							contact.Name.FamilyName = Sql.ToString(row["LAST_NAME"]);
							bChanged = true;
							sbChanges.AppendLine("LAST_NAME" + " changed.");
						}
					}
				}
				
				if ( contact.Birthday == null || Sql.ToDateTime(contact.Birthday) != Sql.ToDateTime(row["BIRTHDATE"]) )
				{
					if ( contact.Birthday != null || !Sql.IsEmptyString(row["BIRTHDATE"]) )
					{
						if ( Sql.ToDateTime(row["BIRTHDATE"]) == DateTime.MinValue )
							contact.Birthday = null;
						else
							contact.Birthday = Sql.ToDateTime(row["BIRTHDATE"]).ToString("yyyy-MM-dd");
						bChanged = true;
						sbChanges.AppendLine("BIRTHDATE" + " changed.");
					}
				}
				
				if ( contact.Content == null || Sql.ToString(contact.Content) != Sql.ToString(row["DESCRIPTION"]) )
				{
					if ( contact.Content != null || !Sql.IsEmptyString(row["DESCRIPTION"]) )
					{
						contact.Content = Sql.ToString(row["DESCRIPTION"]);
						if ( Sql.IsEmptyString(contact.Content) )
						{
							contact.Content = null;
						}
						bChanged = true;
						sbChanges.AppendLine("DESCRIPTION" + " changed.");
					}
				}
				
				EMail eEMAIL1 = null;
				EMail eEMAIL2 = null;
				foreach ( EMail e in contact.Emails )
				{
					// 01/13/2012 Paul.  Work and Home seem appropriate for email types. 
					if      ( e.Type == "WORK" && eEMAIL1 == null ) eEMAIL1 = e;
					else if ( e.Type == "HOME" && eEMAIL2 == null ) eEMAIL2 = e;
				}
				if ( eEMAIL1 == null || Sql.ToString(eEMAIL1.Address) != Sql.ToString(row["EMAIL1"]) )
				{
					if ( eEMAIL1 != null || !Sql.IsEmptyString(row["EMAIL1"]) )
					{
						if ( eEMAIL1 == null )
						{
							eEMAIL1 = new EMail();
							eEMAIL1.Type = "WORK";
							eEMAIL1.Internet = true;
							contact.Emails.Add(eEMAIL1);
						}
						eEMAIL1.Address = Sql.ToString(row["EMAIL1"]);
						if ( Sql.IsEmptyString(eEMAIL1.Address) )
						{
							contact.Emails.Remove(eEMAIL1);
						}
						bChanged = true;
						sbChanges.AppendLine("EMAIL1" + " changed.");
					}
				}
				if ( eEMAIL2 == null || Sql.ToString(eEMAIL2.Address) != Sql.ToString(row["EMAIL2"]) )
				{
					if ( eEMAIL2 != null || !Sql.IsEmptyString(row["EMAIL2"]) )
					{
						if ( eEMAIL2 == null )
						{
							eEMAIL2 = new EMail();
							eEMAIL2.Type = "HOME";
							eEMAIL2.Internet = true;
							contact.Emails.Add(eEMAIL2);
						}
						eEMAIL2.Address = Sql.ToString(row["EMAIL2"]);
						if ( Sql.IsEmptyString(eEMAIL2.Address) )
						{
							contact.Emails.Remove(eEMAIL2);
						}
						bChanged = true;
						sbChanges.AppendLine("EMAIL2" + " changed.");
					}
				}
				
				if ( Sql.ToString(contact.Organization) != Sql.ToString(row["ACCOUNT_NAME"]) )
				{
					contact.Organization = Sql.ToString(row["ACCOUNT_NAME"]);
					bChanged = true;
					sbChanges.AppendLine("ACCOUNT_NAME" + " changed.");
				}
				if ( Sql.ToString(contact.Department  ) != Sql.ToString(row["DEPARTMENT"]) )
				{
					contact.Department = Sql.ToString(row["DEPARTMENT"  ]);
					bChanged = true;
					sbChanges.AppendLine("DEPARTMENT" + " changed.");
				}
				if ( Sql.ToString(contact.Title) != Sql.ToString(row["TITLE"]) )
				{
					contact.Title = Sql.ToString(row["TITLE"]);
					bChanged = true;
					sbChanges.AppendLine("TITLE" + " changed.");
				}

				// 01/28/2012 Paul.  iCloud does not support Assistant Phone. 
				/*
				Relation relASSISTANT = null;
				foreach ( Relation rel in contact.Relations )
				{
					if ( rel.Type == "ASSISTANT" )
					{
						relASSISTANT = rel;
						break;
					}
				}
				if ( relASSISTANT == null || Sql.ToString(relASSISTANT.Value) != Sql.ToString(row["ASSISTANT"]) )
				{
					if ( relASSISTANT != null || !Sql.IsEmptyString(row["ASSISTANT"]) )
					{
						if ( relASSISTANT == null )
						{
							relASSISTANT = new Relation();
							relASSISTANT.Type = "ASSISTANT";
							contact.Relations.Add(relASSISTANT);
						}
						relASSISTANT.Value = Sql.ToString(row["ASSISTANT"]);
						if ( Sql.IsEmptyString(relASSISTANT.Value) )
						{
							contact.Relations.Remove(relASSISTANT);
						}
						bChanged = true;
						sbChanges.AppendLine("ASSISTANT" + " changed.");
					}
				}
				*/
				
				PhoneNumber phASSISTANT_PHONE = null;
				PhoneNumber phPHONE_FAX       = null;
				PhoneNumber phPHONE_WORK      = null;  // 01/24/2012 Paul.  Do not use the primary as the default work. 
				PhoneNumber phPHONE_MOBILE    = null;
				PhoneNumber phPHONE_OTHER     = null;
				PhoneNumber phPHONE_HOME      = null;
				foreach ( PhoneNumber phone in contact.Phonenumbers )
				{
					if      ( phone.Type == "ASSISTANT" && phASSISTANT_PHONE == null ) phASSISTANT_PHONE = phone;
					else if ( phone.Fax                 && phPHONE_FAX       == null ) phPHONE_FAX       = phone;
					else if ( phone.Type == "WORK"      && phPHONE_WORK      == null ) phPHONE_WORK      = phone;
					else if ( phone.Type == "CELL"      && phPHONE_MOBILE    == null ) phPHONE_MOBILE    = phone;
					else if ( phone.Type == "OTHER"     && phPHONE_OTHER     == null ) phPHONE_OTHER     = phone;
					else if ( phone.Type == "HOME"      && phPHONE_HOME      == null ) phPHONE_HOME      = phone;
				}
				
				// 01/24/2012 Paul.  iCloud is removing all special characters from phone.  When doing the comparison here, remove the special characters. 
				Regex r = new Regex(@"[^A-Za-z0-9]");
				// 01/28/2012 Paul.  iCloud does not support Assistant Phone. 
				/*
				if ( phASSISTANT_PHONE == null || r.Replace(Sql.ToString(phASSISTANT_PHONE.Value), "") != r.Replace(Sql.ToString(row["ASSISTANT_PHONE"]), "") )
				{
					if ( phASSISTANT_PHONE != null || !Sql.IsEmptyString(row["ASSISTANT_PHONE"]) )
					{
						if ( phASSISTANT_PHONE == null )
						{
							phASSISTANT_PHONE = new PhoneNumber();
							phASSISTANT_PHONE.Type  = "ASSISTANT";
							phASSISTANT_PHONE.Voice = true;
							contact.Phonenumbers.Add(phASSISTANT_PHONE);
						}
						phASSISTANT_PHONE.Value = Sql.ToString(row["ASSISTANT_PHONE"]);
						if ( Sql.IsEmptyString(phASSISTANT_PHONE.Value) )
						{
							contact.Phonenumbers.Remove(phASSISTANT_PHONE);
						}
						bChanged = true;
						sbChanges.AppendLine("ASSISTANT_PHONE" + " changed.");
					}
				}
				*/
				if ( phPHONE_FAX == null || r.Replace(Sql.ToString(phPHONE_FAX.Value), "") != r.Replace(Sql.ToString(row["PHONE_FAX"]), "") )
				{
					if ( phPHONE_FAX != null || !Sql.IsEmptyString(row["PHONE_FAX"]) )
					{
						if ( phPHONE_FAX == null )
						{
							phPHONE_FAX = new PhoneNumber();
							phPHONE_FAX.Type = "WORK";
							phPHONE_FAX.Fax  = true;
							contact.Phonenumbers.Add(phPHONE_FAX);
						}
						phPHONE_FAX.Value = Sql.ToString(row["PHONE_FAX"]);
						if ( Sql.IsEmptyString(phPHONE_FAX.Value) )
						{
							contact.Phonenumbers.Remove(phPHONE_FAX);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_FAX" + " changed.");
					}
				}
				if ( phPHONE_WORK == null || r.Replace(Sql.ToString(phPHONE_WORK.Value), "") != r.Replace(Sql.ToString(row["PHONE_WORK"]), "") )
				{
					if ( phPHONE_WORK != null || !Sql.IsEmptyString(row["PHONE_WORK"]) )
					{
						if ( phPHONE_WORK == null )
						{
							phPHONE_WORK = new PhoneNumber();
							phPHONE_WORK.Type  = "WORK";
							phPHONE_WORK.Voice = true;
							contact.Phonenumbers.Add(phPHONE_WORK);
						}
						phPHONE_WORK.Value = Sql.ToString(row["PHONE_WORK"]);
						if ( Sql.IsEmptyString(phPHONE_WORK.Value) )
						{
							contact.Phonenumbers.Remove(phPHONE_WORK);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_WORK" + " changed.");
					}
				}
				if ( phPHONE_MOBILE == null || r.Replace(Sql.ToString(phPHONE_MOBILE.Value), "") != r.Replace(Sql.ToString(row["PHONE_MOBILE"]), "") )
				{
					if ( phPHONE_MOBILE != null || !Sql.IsEmptyString(row["PHONE_MOBILE"]) )
					{
						if ( phPHONE_MOBILE == null )
						{
							phPHONE_MOBILE = new PhoneNumber();
							phPHONE_MOBILE.Type  = "CELL";
							phPHONE_MOBILE.Voice = true;
							contact.Phonenumbers.Add(phPHONE_MOBILE);
						}
						phPHONE_MOBILE.Value = Sql.ToString(row["PHONE_MOBILE"]);
						if ( Sql.IsEmptyString(phPHONE_MOBILE.Value) )
						{
							contact.Phonenumbers.Remove(phPHONE_MOBILE);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_MOBILE" + " changed.");
					}
				}
				if ( phPHONE_OTHER == null || r.Replace(Sql.ToString(phPHONE_OTHER.Value), "") != r.Replace(Sql.ToString(row["PHONE_OTHER"]), "") )
				{
					if ( phPHONE_OTHER != null || !Sql.IsEmptyString(row["PHONE_OTHER"]) )
					{
						if ( phPHONE_OTHER == null )
						{
							phPHONE_OTHER = new PhoneNumber();
							phPHONE_OTHER.Type  = "OTHER";
							phPHONE_OTHER.Voice = true;
							contact.Phonenumbers.Add(phPHONE_OTHER);
						}
						phPHONE_OTHER.Value = Sql.ToString(row["PHONE_OTHER"]);
						if ( Sql.IsEmptyString(phPHONE_OTHER.Value) )
						{
							contact.Phonenumbers.Remove(phPHONE_OTHER);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_OTHER" + " changed.");
					}
				}
				if ( phPHONE_HOME == null || r.Replace(Sql.ToString(phPHONE_HOME.Value), "") != r.Replace(Sql.ToString(row["PHONE_HOME"]), "") )
				{
					if ( phPHONE_HOME != null || !Sql.IsEmptyString(row["PHONE_HOME"]) )
					{
						if ( phPHONE_HOME == null )
						{
							phPHONE_HOME = new PhoneNumber();
							phPHONE_HOME.Type  = "HOME";
							phPHONE_HOME.Voice = true;
							contact.Phonenumbers.Add(phPHONE_HOME);
						}
						phPHONE_HOME.Value = Sql.ToString(row["PHONE_HOME"]);
						if ( Sql.IsEmptyString(phPHONE_HOME.Value) )
						{
							contact.Phonenumbers.Remove(phPHONE_HOME);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_HOME" + " changed.");
					}
				}
				
				StructuredPostalAddress adrPRIMARY_ADDRESS = null;
				StructuredPostalAddress adrALT_ADDRESS     = null;
				foreach ( StructuredPostalAddress adr in contact.PostalAddresses )
				{
					if      ( adr.Type == "WORK" && adrPRIMARY_ADDRESS == null ) adrPRIMARY_ADDRESS = adr;
					else if ( adr.Type == "HOME" && adrALT_ADDRESS     == null ) adrALT_ADDRESS     = adr;
				}
				
				if ( adrPRIMARY_ADDRESS == null 
				  || Sql.ToString(adrPRIMARY_ADDRESS.Street      ) != Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ])
				  || Sql.ToString(adrPRIMARY_ADDRESS.City        ) != Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ])
				  || Sql.ToString(adrPRIMARY_ADDRESS.Region      ) != Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ])
				  || Sql.ToString(adrPRIMARY_ADDRESS.Postcode    ) != Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"])
				  || Sql.ToString(adrPRIMARY_ADDRESS.Country     ) != Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ])
				   )
				{
					if ( adrPRIMARY_ADDRESS != null 
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_STREET"    ])
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_CITY"      ])
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_STATE"     ])
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_POSTALCODE"])
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_COUNTRY"   ])
					   )
					{
						if ( adrPRIMARY_ADDRESS == null )
						{
							adrPRIMARY_ADDRESS = new StructuredPostalAddress();
							adrPRIMARY_ADDRESS.Type    = "WORK";
							adrPRIMARY_ADDRESS.Primary = true;
							contact.PostalAddresses.Add(adrPRIMARY_ADDRESS);
						}
						if ( Sql.ToString(adrPRIMARY_ADDRESS.Street  ) != Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]) ) { adrPRIMARY_ADDRESS.Street   = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_STREET"     + " changed."); }
						if ( Sql.ToString(adrPRIMARY_ADDRESS.City    ) != Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]) ) { adrPRIMARY_ADDRESS.City     = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_CITY"       + " changed."); }
						if ( Sql.ToString(adrPRIMARY_ADDRESS.Region  ) != Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]) ) { adrPRIMARY_ADDRESS.Region   = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_STATE"      + " changed."); }
						if ( Sql.ToString(adrPRIMARY_ADDRESS.Postcode) != Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]) ) { adrPRIMARY_ADDRESS.Postcode = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_POSTALCODE" + " changed."); }
						if ( Sql.ToString(adrPRIMARY_ADDRESS.Country ) != Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]) ) { adrPRIMARY_ADDRESS.Country  = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_COUNTRY"    + " changed."); }
						
						if ( Sql.IsEmptyString(adrPRIMARY_ADDRESS.Street      ) 
						  && Sql.IsEmptyString(adrPRIMARY_ADDRESS.City        ) 
						  && Sql.IsEmptyString(adrPRIMARY_ADDRESS.Region      ) 
						  && Sql.IsEmptyString(adrPRIMARY_ADDRESS.Postcode    ) 
						  && Sql.IsEmptyString(adrPRIMARY_ADDRESS.Country     ) 
						   )
						{
							contact.PostalAddresses.Remove(adrPRIMARY_ADDRESS);
						}
						else
						{
							// 03/26/2011 Paul.  iCloud is ignoring the parts and just using the formatted address. 
							adrPRIMARY_ADDRESS.FormattedAddress = BuildFormattedAddress(adrPRIMARY_ADDRESS);
						}
					}
				}
				
				if ( adrALT_ADDRESS == null 
				  || Sql.ToString(adrALT_ADDRESS.Street      ) != Sql.ToString(row["ALT_ADDRESS_STREET"        ])
				  || Sql.ToString(adrALT_ADDRESS.City        ) != Sql.ToString(row["ALT_ADDRESS_CITY"          ])
				  || Sql.ToString(adrALT_ADDRESS.Region      ) != Sql.ToString(row["ALT_ADDRESS_STATE"         ])
				  || Sql.ToString(adrALT_ADDRESS.Postcode    ) != Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ])
				  || Sql.ToString(adrALT_ADDRESS.Country     ) != Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ])
				   )
				{
					if ( adrALT_ADDRESS != null 
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_STREET"        ])
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_CITY"          ])
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_STATE"         ])
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_POSTALCODE"    ])
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_COUNTRY"       ])
					   )
					{
						if ( adrALT_ADDRESS == null )
						{
							adrALT_ADDRESS = new StructuredPostalAddress();
							adrALT_ADDRESS.Type = "HOME";
							contact.PostalAddresses.Add(adrALT_ADDRESS);
						}
						if ( Sql.ToString(adrALT_ADDRESS.Street      ) != Sql.ToString(row["ALT_ADDRESS_STREET"        ]) ) { adrALT_ADDRESS.Street       = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_STREET"         + " changed."); }
						if ( Sql.ToString(adrALT_ADDRESS.City        ) != Sql.ToString(row["ALT_ADDRESS_CITY"          ]) ) { adrALT_ADDRESS.City         = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_CITY"           + " changed."); }
						if ( Sql.ToString(adrALT_ADDRESS.Region      ) != Sql.ToString(row["ALT_ADDRESS_STATE"         ]) ) { adrALT_ADDRESS.Region       = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_STATE"          + " changed."); }
						if ( Sql.ToString(adrALT_ADDRESS.Postcode    ) != Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]) ) { adrALT_ADDRESS.Postcode     = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_POSTALCODE"     + " changed."); }
						if ( Sql.ToString(adrALT_ADDRESS.Country     ) != Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]) ) { adrALT_ADDRESS.Country      = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_COUNTRY"        + " changed."); }
						
						if ( Sql.IsEmptyString(adrALT_ADDRESS.Street      ) 
						  && Sql.IsEmptyString(adrALT_ADDRESS.City        ) 
						  && Sql.IsEmptyString(adrALT_ADDRESS.Region      ) 
						  && Sql.IsEmptyString(adrALT_ADDRESS.Postcode    ) 
						  && Sql.IsEmptyString(adrALT_ADDRESS.Country     ) 
						   )
						{
							contact.PostalAddresses.Remove(adrALT_ADDRESS);
						}
						else
						{
							// 03/26/2011 Paul.  iCloud is ignoring the parts and just using the formatted address. 
							adrALT_ADDRESS.FormattedAddress = BuildFormattedAddress(adrALT_ADDRESS);
						}
					}
				}
			}
			return bChanged;
		}

		public void SyncContacts(ExchangeSession Session, ContactsService service, string sICLOUD_USERNAME, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.iCloud.VerboseStatus"]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + sICLOUD_USERNAME + " to " + gUSER_ID.ToString());
			
			//string sSPLENDIDCRM_GROUP_NAME = Sql.ToString(Application["CONFIG.iCloud.GroupName"]);
			string sCONFLICT_RESOLUTION    = Sql.ToString(Application["CONFIG.iCloud.ConflictResolution"]);
			Guid   gTEAM_ID                = Sql.ToGuid  (Session["TEAM_ID"]);
			//if ( Sql.IsEmptyString(sSPLENDIDCRM_GROUP_NAME) )
			//{
			//	sSPLENDIDCRM_GROUP_NAME = "SplendidCRM";
			//}
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				
				try
				{
					string sSQL = String.Empty;
					List<ContactEntry> fContactResults = service.SyncQuery(bSyncAll);
					if ( fContactResults.Count > 0 )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + fContactResults.Count.ToString() + " contacts to retrieve from " + sICLOUD_USERNAME);
					foreach ( ContactEntry contact in fContactResults )
					{
						// 01/24/2012 Paul.  We need to have a way to force an update as we cannot rely upon the iCloud embedded revision date. 
						// If the bSyncAll flag is not set, then the contact has changed remotely, regardless of the embedded date. 
						this.ImportContact(Session, service, con, sICLOUD_USERNAME, gUSER_ID, contact, sbErrors);
					}
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spICLOUD_USERS_ContactsCTAG(gUSER_ID, service.ContactsCTag, trn);
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
							throw;
						}
					}
					
					// 03/26/2010 Paul.  Join to vwCONTACTS_USERS so that we only get contacts that are marked as Sync. 
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					// 09/18/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
					sSQL = "select vwCONTACTS.*                                                               " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_ID                                                    " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_REMOTE_KEY                                            " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                               " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                              " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_RAW_CONTENT                                           " + ControlChars.CrLf
					     + "  from            vwCONTACTS                                                      " + ControlChars.CrLf
					     + "       inner join vwCONTACTS_USERS                                                " + ControlChars.CrLf
					     + "               on vwCONTACTS_USERS.CONTACT_ID           = vwCONTACTS.ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_USERS.USER_ID              = @SYNC_USER_ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_USERS.SERVICE_NAME is null                           " + ControlChars.CrLf
					     + "  left outer join vwCONTACTS_SYNC                                                 " + ControlChars.CrLf
					     + "               on vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'iCloud'               " + ControlChars.CrLf
					     + "              and vwCONTACTS_SYNC.SYNC_LOCAL_ID         = vwCONTACTS.ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_SYNC.SYNC_ASSIGNED_USER_ID = vwCONTACTS_USERS.USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SYNC_USER_ID", gUSER_ID);
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
						
						// 03/28/2010 Paul.  All that is important is that the current date is greater than the last sync date. 
						cmd.CommandText += "   and (vwCONTACTS_SYNC.ID is null or vwCONTACTS.DATE_MODIFIED_UTC > vwCONTACTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC)" + ControlChars.CrLf;
						cmd.CommandText += " order by vwCONTACTS.DATE_MODIFIED_UTC" + ControlChars.CrLf;
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + dt.Rows.Count.ToString() + " contacts to send to " + sICLOUD_USERNAME);
								foreach ( DataRow row in dt.Rows )
								{
									Guid     gID                             = Sql.ToGuid    (row["ID"                           ]);
									Guid     gASSIGNED_USER_ID               = Sql.ToGuid    (row["ASSIGNED_USER_ID"             ]);
									Guid     gSYNC_ID                        = Sql.ToGuid    (row["SYNC_ID"                      ]);
									string   sSYNC_REMOTE_KEY                = Sql.ToString  (row["SYNC_REMOTE_KEY"              ]);
									DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
									DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
									DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
									string   sSYNC_RAW_CONTENT               = Sql.ToString  (row["SYNC_RAW_CONTENT"             ]);
									string   sSYNC_ACTION                    = Sql.IsEmptyGuid(gSYNC_ID) ? "local new" : "local changed";
									if ( SplendidInit.bEnableACLFieldSecurity )
									{
										bool bApplyACL = false;
										foreach ( DataColumn col in dt.Columns )
										{
											Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Contacts", col.ColumnName, gASSIGNED_USER_ID);
											if ( !acl.IsReadable() )
											{
												row[col.ColumnName] = DBNull.Value;
												bApplyACL = true;
											}
										}
										if ( bApplyACL )
											dt.AcceptChanges();
									}
									StringBuilder sbChanges = new StringBuilder();
									try
									{
										ContactEntry contact = null;
										if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Sending new contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sICLOUD_USERNAME);
											contact = new ContactEntry();
											this.SetiCloudContact(contact, row, sbChanges);
											
											ContactEntry result = service.Insert(contact);
											sSYNC_REMOTE_KEY = result.UID;
										}
										else
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Binding contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sICLOUD_USERNAME);
											
											try
											{
												contact = service.Get(sSYNC_REMOTE_KEY) as ContactEntry;
												// 03/28/2010 Paul.  We need to double-check for conflicts. 
												// 03/26/2011 Paul.  Updated is in local time. 
												DateTime dtREMOTE_DATE_MODIFIED     = contact.Updated;
												DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
												// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
												if ( (dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) || sSYNC_RAW_CONTENT != contact.RawContent) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
												{
													if ( sCONFLICT_RESOLUTION == "remote" )
													{
														// 03/24/2010 Paul.  Remote is the winner of conflicts. 
														sSYNC_ACTION = "remote changed";
													}
													else if ( sCONFLICT_RESOLUTION == "local" )
													{
														// 03/24/2010 Paul.  Local is the winner of conflicts. 
														sSYNC_ACTION = "local changed";
													}
													// 03/26/2011 Paul.  The iCloud remote date can vary by 1 millisecond, so check for local change first. 
													else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "local changed";
													}
													else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "remote changed";
													}
													else
													{
														sSYNC_ACTION = "prompt change";
													}
												}
												if ( contact.Deleted )
												{
													sSYNC_ACTION = "remote deleted";
												}
											}
											catch(Exception ex)
											{
												string sError = "Error retrieving iCloud contact " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + "." + ControlChars.CrLf;
												sError += Utils.ExpandException(ex) + ControlChars.CrLf;
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
												sbErrors.AppendLine(sError);
												sSYNC_ACTION = "remote deleted";
											}
											if ( sSYNC_ACTION == "local changed" )
											{
												bool bChanged = this.SetiCloudContact(contact, row, sbChanges);
												if ( bChanged )
												{
													if ( bVERBOSE_STATUS )
														SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Sending contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sICLOUD_USERNAME);
													service.Update(contact);
												}
											}
										}
										if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
										{
											if ( contact != null )
											{
												// 03/25/2010 Paul.  Update the modified date after the save. 
												// 03/26/2011 Paul.  Updated is in local time. 
												DateTime dtREMOTE_DATE_MODIFIED     = contact.Updated;
												DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														// 03/26/2010 Paul.  Make sure to set the Sync flag. 
														// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
														// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
														// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
														SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sSYNC_REMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "iCloud", contact.RawContent, trn);
														trn.Commit();
													}
													catch
													{
														trn.Rollback();
														throw;
													}
												}
											}
										}
										else if ( sSYNC_ACTION == "remote deleted" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Unsyncing contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " for " + sICLOUD_USERNAME);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gID, sSYNC_REMOTE_KEY, "iCloud", trn);
													trn.Commit();
												}
												catch
												{
													trn.Rollback();
													throw;
												}
											}
										}
									}
									catch(Exception ex)
									{
										// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
										string sError = "Error creating iCloud contact " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + " for " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
										sError += sbChanges.ToString();
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
									}
								}
							}
						}
					}
					
					// 03/28/2011 Paul.  Contacts that have been unsync'd need to be removed from the SplendidCRM group. 
					// 03/28/2011 Paul.  Don't need this logic. 
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					//sSQL = "select vwCONTACTS.ID                                                              " + ControlChars.CrLf
					//     + "     , vwCONTACTS.FIRST_NAME                                                      " + ControlChars.CrLf
					//     + "     , vwCONTACTS.LAST_NAME                                                       " + ControlChars.CrLf
					//     + "     , vwCONTACTS_SYNC.SYNC_REMOTE_KEY                                            " + ControlChars.CrLf
					//     + "  from            vwCONTACTS                                                      " + ControlChars.CrLf
					//     + "       inner join CONTACTS_USERS                                                  " + ControlChars.CrLf
					//     + "               on CONTACTS_USERS.CONTACT_ID             = vwCONTACTS.ID           " + ControlChars.CrLf
					//     + "              and CONTACTS_USERS.USER_ID                = @SYNC_USER_ID           " + ControlChars.CrLf
					//     + "              and CONTACTS_USERS.DELETED                = 1                       " + ControlChars.CrLf
					//     + "       inner join vwCONTACTS_SYNC                                                 " + ControlChars.CrLf
					//     + "               on vwCONTACTS_SYNC.SYNC_LOCAL_ID         = vwCONTACTS.ID           " + ControlChars.CrLf
					//     + "              and vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'iCloud'               " + ControlChars.CrLf
					//     + "              and vwCONTACTS_SYNC.SYNC_ASSIGNED_USER_ID = CONTACTS_USERS.USER_ID" + ControlChars.CrLf;
					//using ( IDbCommand cmd = con.CreateCommand() )
					//{
					//	cmd.CommandText = sSQL;
					//	Sql.AddParameter(cmd, "@SYNC_USER_ID", gUSER_ID);
					//	ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
					//	
					//	// 03/28/2011 Paul.  In this case, we are looking for relationship records that were modified after the sync date. 
					//	// We don't want to use the Contact date because the contact will likely be edited many times after being unsync'd. 
					//	cmd.CommandText += "   and CONTACTS_USERS.DATE_MODIFIED_UTC > vwCONTACTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC" + ControlChars.CrLf;
					//	cmd.CommandText += " order by vwCONTACTS.DATE_MODIFIED_UTC" + ControlChars.CrLf;
					//	using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					//	{
					//		((IDbDataAdapter)da).SelectCommand = cmd;
					//		using ( DataTable dt = new DataTable() )
					//		{
					//			da.Fill(dt);
					//			if ( dt.Rows.Count > 0 )
					//				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + dt.Rows.Count.ToString() + " contacts to remove from group " + sICLOUD_USERNAME);
					//			foreach ( DataRow row in dt.Rows )
					//			{
					//				Guid   gSYNC_LOCAL_ID   = Sql.ToGuid  (row["ID"             ]);
					//				string sSYNC_REMOTE_KEY = Sql.ToString(row["SYNC_REMOTE_KEY"]);
					//				try
					//				{
					//					ContactEntry contact = service.Get(sSYNC_REMOTE_KEY) as ContactEntry;
					//					contact = contact.Update();
					//				}
					//				catch(Exception ex)
					//				{
					//					string sError = "Error clearing iCloud groups for contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " from " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
					//					sError += Utils.ExpandException(ex) + ControlChars.CrLf;
					//					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
					//					sbErrors.AppendLine(sError);
					//				}
					//				try
					//				{
					//					if ( bVERBOSE_STATUS )
					//						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Deleting sync contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " from " + sICLOUD_USERNAME);
					//					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					//					{
					//						try
					//						{
					//							// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					//							SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sSYNC_REMOTE_KEY, "iCloud", trn);
					//							trn.Commit();
					//						}
					//						catch
					//						{
					//							trn.Rollback();
					//							throw;
					//						}
					//					}
					//				}
					//				catch(Exception ex)
					//				{
					//					string sError = "Error deleting sync contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " from " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
					//					sError += Utils.ExpandException(ex) + ControlChars.CrLf;
					//					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
					//					sbErrors.AppendLine(sError);
					//				}
					//			}
					//		}
					//	}
					//}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					sbErrors.AppendLine(Utils.ExpandException(ex));
				}
			}
		}

		// 12/12/2011 Paul.  Move population logic to a static method. 
		// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
		public bool BuildCONTACTS_Update(HttpApplicationState Application, ExchangeSession Session, IDbCommand spCONTACTS_Update, DataRow row, ContactEntry contact, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, bool bCreateAccount, IDbTransaction trn)
		{
			bool bChanged = false;
			// 03/25/2010 Paul.  We start with the existing record values so that we can apply ACL Field Security rules. 
			if ( row != null && row.Table != null )
			{
				foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					// 03/28/2010 Paul.  We must assign a value to all parameters. 
					string sParameterName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
					if ( row.Table.Columns.Contains(sParameterName) )
						par.Value = row[sParameterName];
					else
						par.Value = DBNull.Value;
				}
			}
			else
			{
				bChanged = true;
				foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					string sParameterName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
					if ( sParameterName == "TEAM_ID" )
						par.Value = gTEAM_ID;
					else if ( sParameterName == "ASSIGNED_USER_ID" )
						par.Value = gUSER_ID;
					// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
					else if ( sParameterName == "MODIFIED_USER_ID" )
						par.Value = gUSER_ID;
					else
						par.Value = DBNull.Value;
				}
			}
			
			EMail eEMAIL1 = null;
			EMail eEMAIL2 = null;
			foreach ( EMail e in contact.Emails )
			{
				// 01/13/2012 Paul.  Work and Home seem appropriate for email types. 
				if      ( e.Type == "WORK" && eEMAIL1 == null ) eEMAIL1 = e;
				else if ( e.Type == "HOME" && eEMAIL2 == null ) eEMAIL2 = e;
			}
			
			// 01/28/2012 Paul.  iCloud does not support Assistant Phone. 
			/*
			Relation relASSISTANT = null;
			foreach ( Relation rel in contact.Relations )
			{
				if ( rel.Type == "ASSISTANT" )
				{
					relASSISTANT = rel;
					break;
				}
			}
			*/
			
			PhoneNumber phASSISTANT_PHONE = null;
			PhoneNumber phPHONE_FAX       = null;
			PhoneNumber phPHONE_WORK      = null;  // 01/24/2012 Paul.  Do not use the primary as the default work. 
			PhoneNumber phPHONE_MOBILE    = null;
			PhoneNumber phPHONE_OTHER     = null;
			PhoneNumber phPHONE_HOME      = null;
			foreach ( PhoneNumber phone in contact.Phonenumbers )
			{
				if      ( phone.Type == "ASSISTANT" && phASSISTANT_PHONE == null ) phASSISTANT_PHONE = phone;
				else if ( phone.Fax                 && phPHONE_FAX       == null ) phPHONE_FAX       = phone;
				else if ( phone.Type == "WORK"      && phPHONE_WORK      == null ) phPHONE_WORK      = phone;
				else if ( phone.Type == "CELL"      && phPHONE_MOBILE    == null ) phPHONE_MOBILE    = phone;
				else if ( phone.Type == "OTHER"     && phPHONE_OTHER     == null ) phPHONE_OTHER     = phone;
				else if ( phone.Type == "HOME"      && phPHONE_HOME      == null ) phPHONE_HOME      = phone;
			}
			
			// 08/26/2011 Paul.  Geocoding API V3 allows us to select long or short names. 
			bool bShortStateName   = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortStateName"  ]);
			bool bShortCountryName = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortCountryName"]);
			StructuredPostalAddress adrPRIMARY_ADDRESS = null;
			StructuredPostalAddress adrALT_ADDRESS     = null;
			foreach ( StructuredPostalAddress adr in contact.PostalAddresses )
			{
				if ( !Sql.IsEmptyString(adr.FormattedAddress) )
				{
					if ( Sql.IsEmptyString(adr.Street  )
					  && Sql.IsEmptyString(adr.City    )
					  && Sql.IsEmptyString(adr.Region  )
					  && Sql.IsEmptyString(adr.Postcode)
					  && Sql.IsEmptyString(adr.Country )
					   )
					{
						// 08/26/2011 Paul.  Geocoding API V3 does not require a key. 
						//string siCloudMapsKey = Sql.ToString(Application["CONFIG.iCloudMaps.Key"]);
						//if ( !Sql.IsEmptyString(siCloudMapsKey) )
						{
							AddressDetails info = new AddressDetails();
							// 04/16/2011 Paul.  We should consider caching the address with the FormattedAddress as the key. 
							// It may not be an issue as a change in the CRM would update iCloud andd it should split-out the addresses. 
							GoogleUtils.ConvertAddressV3(adr.FormattedAddress, bShortStateName, bShortCountryName, ref info);
							adr.Street   = info.ADDRESS_STREET    ;
							adr.City     = info.ADDRESS_CITY      ;
							adr.Region   = info.ADDRESS_STATE     ;
							adr.Postcode = info.ADDRESS_POSTALCODE;
							adr.Country  = info.ADDRESS_COUNTRY   ;
							// 04/16/2011 Paul.  We have noticed that iCloudMaps is not returning a valid address and city for a completely valid VA address. 
							// The Accuracy is being returned as 6, but the Street and City are blank.  In that case, store everything in the Street field. 
							// 08/26/2011 Paul.  The solution is to use the Geocoding API V3. 
							//if ( info.Accuracy >= 6 && Sql.IsEmptyString(info.ADDRESS_STREET) && Sql.IsEmptyString(info.ADDRESS_CITY) )
							//	adr.Street = adr.FormattedAddress;
						}
						//else
						//{
						//	// 04/16/2011 Paul.  If we are unable to use iCloudMaps, then place the formatted address in the Address field. 
						//	adr.Street = adr.FormattedAddress;
						//}
					}
				}
				if      ( adr.Type == "WORK" && adrPRIMARY_ADDRESS == null ) adrPRIMARY_ADDRESS = adr;
				else if ( adr.Type == "HOME" && adrALT_ADDRESS     == null ) adrALT_ADDRESS     = adr;
			}
			Regex r = new Regex(@"[^A-Za-z0-9]");
			foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Contacts", sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "BIRTHDATE"                 :  oValue = Sql.ToDBDateTime(contact.Birthday);  break;
							case "FIRST_NAME"                :  if ( contact.Name       != null ) oValue = Sql.ToDBString(contact.Name.GivenName      );  break;
							case "LAST_NAME"                 :  if ( contact.Name       != null ) oValue = Sql.ToDBString(contact.Name.FamilyName     );  break;
							case "DESCRIPTION"               :  oValue = Sql.ToDBString(contact.Content     );  break;
							// 01/28/2012 Paul.  ACCOUNT_NAME does not exist in the spCONTACTS_Update stored procedure.  It is a special case that requires a lookup. 
							//case "ACCOUNT_NAME"              :  oValue = Sql.ToDBString(contact.Organization);  break;
							case "DEPARTMENT"                :  oValue = Sql.ToDBString(contact.Department  );  break;
							case "TITLE"                     :  oValue = Sql.ToDBString(contact.Title       );  break;
							// 01/28/2012 Paul.  iCloud does not support Assistant Phone. 
							//case "ASSISTANT"                 :  oValue = (relASSISTANT       != null) ? Sql.ToDBString(relASSISTANT    .Value      ) : String.Empty;  break;
							case "EMAIL1"                    :  oValue = (eEMAIL1            != null) ? Sql.ToDBString(eEMAIL1           .Address  ) : String.Empty;  break;
							case "EMAIL2"                    :  oValue = (eEMAIL2            != null) ? Sql.ToDBString(eEMAIL2           .Address  ) : String.Empty;  break;
							// 01/28/2012 Paul.  iCloud does not support Assistant Phone. 
							//case "ASSISTANT_PHONE"           :  oValue = (phASSISTANT_PHONE  != null) ? Sql.ToDBString(phASSISTANT_PHONE .Value    ) : String.Empty;  break;
							case "PHONE_FAX"                 :  oValue = (phPHONE_FAX        != null) ? Sql.ToDBString(phPHONE_FAX       .Value    ) : String.Empty;  break;
							case "PHONE_WORK"                :  oValue = (phPHONE_WORK       != null) ? Sql.ToDBString(phPHONE_WORK      .Value    ) : String.Empty;  break;
							case "PHONE_MOBILE"              :  oValue = (phPHONE_MOBILE     != null) ? Sql.ToDBString(phPHONE_MOBILE    .Value    ) : String.Empty;  break;
							case "PHONE_OTHER"               :  oValue = (phPHONE_OTHER      != null) ? Sql.ToDBString(phPHONE_OTHER     .Value    ) : String.Empty;  break;
							case "PHONE_HOME"                :  oValue = (phPHONE_HOME       != null) ? Sql.ToDBString(phPHONE_HOME      .Value    ) : String.Empty;  break;
							case "PRIMARY_ADDRESS_STREET"    :  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.Street   ) : String.Empty;  break;
							case "PRIMARY_ADDRESS_CITY"      :  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.City     ) : String.Empty;  break;
							case "PRIMARY_ADDRESS_STATE"     :  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.Region   ) : String.Empty;  break;
							case "PRIMARY_ADDRESS_POSTALCODE":  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.Postcode ) : String.Empty;  break;
							case "PRIMARY_ADDRESS_COUNTRY"   :  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.Country  ) : String.Empty;  break;
							case "ALT_ADDRESS_STREET"        :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .Street   ) : String.Empty;  break;
							case "ALT_ADDRESS_CITY"          :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .City     ) : String.Empty;  break;
							case "ALT_ADDRESS_STATE"         :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .Region   ) : String.Empty;  break;
							case "ALT_ADDRESS_POSTALCODE"    :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .Postcode ) : String.Empty;  break;
							case "ALT_ADDRESS_COUNTRY"       :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .Country  ) : String.Empty;  break;
							// 03/26/2010 Paul.  We need to make sure to set the Sync flag. 
							case "SYNC_CONTACT"              :  oValue = true;  break;
							// 03/27/2010 Paul.  We need to set the Modified User ID in order to set the SYNC_CONTACT flag. 
							case "MODIFIED_USER_ID"          :  oValue = gUSER_ID;  break;
						}
						// 01/28/2012 Paul.  ACCOUNT_NAME does not exist in the spCONTACTS_Update stored procedure.  It is a special case that requires a lookup. 
						if ( sColumnName == "ACCOUNT_ID" )
						{
							Guid   gACCOUNT_ID   = Sql.ToGuid(par.Value);
							string sACCOUNT_NAME = String.Empty;
							if ( !Sql.IsEmptyGuid(gACCOUNT_ID) )
								sACCOUNT_NAME = Modules.ItemName("Accounts", gACCOUNT_ID);
							if ( String.Compare(sACCOUNT_NAME, Sql.ToString(contact.Organization), true) != 0 )
							{
								gACCOUNT_ID   = Guid.Empty;
								sACCOUNT_NAME = Sql.ToString(contact.Organization);
								if ( !Sql.IsEmptyString(sACCOUNT_NAME) )
								{
									IDbConnection con = spCONTACTS_Update.Connection;
									string sSQL ;
									sSQL = "select ID                   " + ControlChars.CrLf
									     + "  from vwACCOUNTS           " + ControlChars.CrLf
									     + " where NAME = @NAME         " + ControlChars.CrLf
									     + " order by DATE_MODIFIED desc" + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										if ( trn != null )
											cmd.Transaction = trn;
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@NAME", sACCOUNT_NAME);
										gACCOUNT_ID = Sql.ToGuid(cmd.ExecuteScalar());
										if ( Sql.IsEmptyGuid(gACCOUNT_ID) && bCreateAccount )
										{
											// 01/28/2012 Paul.  If the account does not exist, then create it. 
											SqlProcs.spACCOUNTS_Update
												( ref gACCOUNT_ID
												, gUSER_ID      // ASSIGNED_USER_ID
												, sACCOUNT_NAME
												, String.Empty  // ACCOUNT_TYPE
												, Guid.Empty    // PARENT_ID
												, String.Empty  // INDUSTRY
												, String.Empty  // ANNUAL_REVENUE
												, (phPHONE_FAX        != null) ? Sql.ToString(phPHONE_FAX       .Value    ) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.Street   ) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.City     ) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.Region   ) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.Postcode ) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.Country  ) : String.Empty
												, "Account created from iCloud contact " + (contact.Name != null ? Sql.ToString(contact.Name.FullName) : String.Empty)
												, String.Empty  // RATING
												, (phPHONE_WORK       != null) ? Sql.ToString(phPHONE_WORK      .Value    ) : String.Empty  // PHONE_OFFICE
												, String.Empty  // PHONE_ALTERNATE
												, (eEMAIL1            != null) ? Sql.ToString(eEMAIL1           .Address  ) : String.Empty
												, String.Empty  // EMAIL2
												, String.Empty  // WEBSITE
												, String.Empty  // OWNERSHIP
												, String.Empty  // EMPLOYEES
												, String.Empty  // SIC_CODE
												, String.Empty  // TICKER_SYMBOL
												, String.Empty  // SHIPPING_ADDRESS_STREET
												, String.Empty  // SHIPPING_ADDRESS_CITY
												, String.Empty  // SHIPPING_ADDRESS_STATE
												, String.Empty  // SHIPPING_ADDRESS_POSTALCODE
												, String.Empty  // SHIPPING_ADDRESS_COUNTRY
												, String.Empty  // ACCOUNT_NUMBER
												, gTEAM_ID      // TEAM_ID
												, String.Empty  // TEAM_SET_LIST
												, false         // EXCHANGE_FOLDER
												// 08/07/2015 Paul.  Add picture. 
												, String.Empty  // PICTURE
												// 05/12/2016 Paul.  Add Tags module. 
												, String.Empty  // TAG_SET_NAME
												// 06/07/2017 Paul.  Add NAICSCodes module. 
												, String.Empty  // NAICS_SET_NAME
												// 10/27/2017 Paul.  Add Accounts as email source. 
												, false         // DO_NOT_CALL
												, false         // EMAIL_OPT_OUT
												, false         // INVALID_EMAIL
												// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
												, String.Empty  // ASSIGNED_SET_LIST
												, trn
												);
										}
									}
								}
								par.Value = gACCOUNT_ID;
								bChanged = true;
							}
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						else if ( oValue != null )
						{
							if ( !bChanged )
							{
								switch ( par.DbType )
								{
									case DbType.Guid    :  if ( Sql.ToGuid    (par.Value) != Sql.ToGuid    (oValue) ) bChanged = true;  break;
									case DbType.Int16   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int32   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int64   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Double  :  if ( Sql.ToDouble  (par.Value) != Sql.ToDouble  (oValue) ) bChanged = true;  break;
									case DbType.Decimal :  if ( Sql.ToDecimal (par.Value) != Sql.ToDecimal (oValue) ) bChanged = true;  break;
									case DbType.Boolean :  if ( Sql.ToBoolean (par.Value) != Sql.ToBoolean (oValue) ) bChanged = true;  break;
									case DbType.DateTime:  if ( Sql.ToDateTime(par.Value) != Sql.ToDateTime(oValue) ) bChanged = true;  break;
									default             :
										if ( sColumnName.StartsWith("PHONE_") )
										{
											// 01/24/2012 Paul.  iCloud is removing all special characters from phone.  When doing the comparison here, remove the special characters. 
											if ( r.Replace(Sql.ToString(par.Value), "") != r.Replace(Sql.ToString(oValue), "") )
											{
												bChanged = true;
											}
										}
										else if ( Sql.ToString  (par.Value) != Sql.ToString  (oValue) )
										{
											bChanged = true;
										}
										break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
						// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}

		// 01/24/2012 Paul.  We need to have a way to force an update as we cannot rely upon the iCloud embedded revision date. 
		public void ImportContact(ExchangeSession Session, ContactsService service, IDbConnection con, string sICLOUD_USERNAME, Guid gUSER_ID, ContactEntry contact, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.ICLOUD.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.ICLOUD.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid   (Session["TEAM_ID"]);
			
			IDbCommand spCONTACTS_Update = SqlProcs.Factory(con, "spCONTACTS_Update");

			// 03/26/2011 Paul.  contact.Name is not always available, so use the AbsoluteUri instead. 
			string   sREMOTE_KEY  = contact.UID;
			string   sContactName = sREMOTE_KEY;
			if ( contact.Name != null && !Sql.IsEmptyString(contact.Name.FullName) )
			{
				sContactName = contact.Name.FullName;
			}
			// 03/26/2011 Paul.  Updated is in local time. 
			DateTime dtREMOTE_DATE_MODIFIED     = contact.Updated;
			DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();

			String sSQL = String.Empty;
			sSQL = "select SYNC_ID                                       " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_DATE_MODIFIED_UTC                  " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_DATE_MODIFIED_UTC                 " + ControlChars.CrLf
			     + "     , SYNC_CONTACT                                  " + ControlChars.CrLf
			     + "     , SYNC_RAW_CONTENT                              " + ControlChars.CrLf
			     + "     , ID                                            " + ControlChars.CrLf
			     + "     , DATE_MODIFIED_UTC                             " + ControlChars.CrLf
			     + "  from vwCONTACTS_SYNC                               " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'iCloud'             " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
			     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
				Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					string sSYNC_ACTION   = String.Empty;
					Guid   gID            = Guid.Empty;
					Guid   gSYNC_LOCAL_ID = Guid.Empty;
					using ( DataTable dt = new DataTable() )
					{
						da.Fill(dt);
						if ( dt.Rows.Count > 0 )
						{
							DataRow row = dt.Rows[0];
							gID                                      = Sql.ToGuid    (row["ID"                           ]);
							gSYNC_LOCAL_ID                           = Sql.ToGuid    (row["SYNC_LOCAL_ID"                ]);
							DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
							DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
							DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
							bool     bSYNC_CONTACT                   = Sql.ToBoolean (row["SYNC_CONTACT"                 ]);
							string   sSYNC_RAW_CONTENT               = Sql.ToString  (row["SYNC_RAW_CONTENT"             ]);
							// 03/28/2010 Paul.  If the ID is NULL and the LOCAL_ID is NOT NULL, then the local item must have been deleted. 
							// 03/29/2010 Paul.  If ID and LOCAL_ID are valid, but SYNC_CONTACT is not, then the user has stopped syncing the contact. 
							if ( (Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID)) || (!Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID) && !bSYNC_CONTACT) )
							{
								sSYNC_ACTION = "local deleted";
							}
							// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
							else if ( (dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) || sSYNC_RAW_CONTENT != contact.RawContent) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								if ( sCONFLICT_RESOLUTION == "remote" )
								{
									// 03/24/2010 Paul.  Remote is the winner of conflicts. 
									sSYNC_ACTION = "remote changed";
								}
								else if ( sCONFLICT_RESOLUTION == "local" )
								{
									// 03/24/2010 Paul.  Local is the winner of conflicts. 
									sSYNC_ACTION = "local changed";
								}
								// 03/26/2011 Paul.  The iCloud remote date can vary by 1 millisecond, so check for local change first. 
								else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "local changed";
								}
								// 01/24/2012 Paul.  We need to have a way to force an update as we cannot rely upon the iCloud embedded revision date. 
								// If the bSyncAll flag is not set, then the contact has changed remotely, regardless of the embedded date. 
								// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
								else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC || sSYNC_RAW_CONTENT != contact.RawContent )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "remote changed";
								}
								else
								{
									sSYNC_ACTION = "prompt change";
								}
								if ( contact.Deleted )
								{
									sSYNC_ACTION = "remote deleted";
								}
								
							}
							// 03/26/2011 Paul.  The iCloud remote date can vary by 1 millisecond, so check for local change first. 
							// 01/24/2012 Paul.  We need to have a way to force an update as we cannot rely upon the iCloud embedded revision date. 
							// If the bSyncAll flag is not set, then the contact has changed remotely, regardless of the embedded date. 
							// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) || sSYNC_RAW_CONTENT != contact.RawContent )
							{
								// 03/24/2010 Paul.  Remote Record has changed, but Local has not. 
								sSYNC_ACTION = "remote changed";
							}
							else if ( dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Local Record has changed, but Remote has not. 
								sSYNC_ACTION = "local changed";
							}
						}
						else if ( contact.Deleted )
						{
							sSYNC_ACTION = "remote deleted";
						}
						else
						{
							sSYNC_ACTION = "remote new";
							
							// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to iCloud. 
							// 03/28/2010 Paul.  We need to prevent duplicate iCloud entries from attaching to an existing mapped Contact ID. 
							// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
							cmd.Parameters.Clear();
							sSQL = "select vwCONTACTS.ID             " + ControlChars.CrLf
							     + "  from            vwCONTACTS     " + ControlChars.CrLf
							     + "  left outer join vwCONTACTS_SYNC" + ControlChars.CrLf
							     + "               on vwCONTACTS_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'iCloud'             " + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_LOCAL_ID         = vwCONTACTS.ID         " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
							iCloud.Contacts.EMail PrimaryEmail = null;
							foreach ( iCloud.Contacts.EMail email in contact.Emails )
							{
								if ( email.Primary )
								{
									PrimaryEmail = email;
									break;
								}
							}
							if ( PrimaryEmail == null && contact.Emails.Count > 0 )
								PrimaryEmail = contact.Emails[0];
							if ( PrimaryEmail != null && !Sql.IsEmptyString(PrimaryEmail.Address) )
							{
								Sql.AppendParameter(cmd, Sql.ToString(PrimaryEmail.Address), "EMAIL1");
							}
							else if ( contact.Name != null )
							{
								if ( Sql.IsEmptyString(contact.Name.GivenName) && Sql.IsEmptyString(contact.Name.FamilyName) )
								{
									Sql.AppendParameter(cmd, Sql.ToString(contact.Name.FullName), "NAME");
								}
								else
								{
									Sql.AppendParameter(cmd, Sql.ToString(contact.Name.GivenName ), "FIRST_NAME");
									Sql.AppendParameter(cmd, Sql.ToString(contact.Name.FamilyName), "LAST_NAME" );
								}
							}
							cmd.CommandText += "   and vwCONTACTS_SYNC.ID is null" + ControlChars.CrLf;
							gID = Sql.ToGuid(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyGuid(gID) )
							{
								// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to iCloud. 
								sSYNC_ACTION = "local new";
							}
						}
					}
					using ( DataTable dt = new DataTable() )
					{
						DataRow row = null;
						Guid gASSIGNED_USER_ID = Guid.Empty;
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" || sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new" )
						{
							if ( !Sql.IsEmptyGuid(gID) )
							{
								cmd.Parameters.Clear();
								sSQL = "select *         " + ControlChars.CrLf
								     + "  from vwCONTACTS" + ControlChars.CrLf
								     + " where ID = @ID  " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
								{
									row = dt.Rows[0];
									gASSIGNED_USER_ID = Sql.ToGuid(row["ASSIGNED_USER_ID"]);
								}
							}
						}
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" )
						{
#if false
							string sTempPath = Path.GetTempPath();
							// 01/31/2010 Paul.  Due to the 8 character dBase limitation, we should create our own folder. 
							sTempPath = Path.Combine(sTempPath, "Splendid");
							if ( !Directory.Exists(sTempPath) )
							{
								Directory.CreateDirectory(sTempPath);
							}
							using ( FileStream stm = File.Create(Path.Combine(sTempPath, contact.Name.FullName)) )
							{
								contact.SaveToXml(stm);
							}
							
#endif
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Retrieving contact " + sContactName + " from " + sICLOUD_USERNAME);
									
									spCONTACTS_Update.Transaction = trn;
									// 12/12/2011 Paul.  Move population logic to a static method. 
									// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
									// 01/28/2012 Paul.  The transaction is necessary so that an account can be created. 
									bool bChanged = BuildCONTACTS_Update(Application, Session, spCONTACTS_Update, row, contact, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID, true, trn);
									if ( bChanged )
									{
										Sql.Trace(spCONTACTS_Update);
										spCONTACTS_Update.ExecuteNonQuery();
										IDbDataParameter parID = Sql.FindParameter(spCONTACTS_Update, "@ID");
										gID = Sql.ToGuid(parID.Value);
									}
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
									SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "iCloud", contact.RawContent, trn);
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									// 02/20/2013 Paul.  Log inner error. 
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
									throw;
								}
							}
						}
						else if ( (sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new") && !Sql.IsEmptyGuid(gID) )
						{
							// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to iCloud. 
							if ( dt.Rows.Count > 0 )
							{
								row = dt.Rows[0];
								if ( SplendidInit.bEnableACLFieldSecurity )
								{
									bool bApplyACL = false;
									foreach ( DataColumn col in dt.Columns )
									{
										Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Contacts", col.ColumnName, gASSIGNED_USER_ID);
										if ( !acl.IsReadable() )
										{
											row[col.ColumnName] = DBNull.Value;
											bApplyACL = true;
										}
									}
									if ( bApplyACL )
										dt.AcceptChanges();
								}
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Syncing contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sICLOUD_USERNAME);
									bool bChanged = this.SetiCloudContact(contact, row, sbChanges);
									if ( bChanged )
									{
										service.Update(contact);
										//contact = service.Get(contact.UID) as ContactEntry;
									}
									// 03/25/2010 Paul.  Update the modified date after the save. 
									// 03/26/2011 Paul.  Updated is in local time. 
									dtREMOTE_DATE_MODIFIED     = contact.Updated;
									dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED_UTC.ToUniversalTime();
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 03/26/2010 Paul.  Make sure to set the Sync flag. 
											// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
											// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
											// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
											SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "iCloud", contact.RawContent, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								catch(Exception ex)
								{
									// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
									string sError = "Error saving " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + " to " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
									sError += sbChanges.ToString();
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
						else if ( sSYNC_ACTION == "local deleted" )
						{
							try
							{
								// 01/26/2012 Paul.  I don't think it makes sense to delete iCloud contacts. 
								// Doing so would make it difficult for users to remove Contacts that originated on the iPhone. 
								//service.Delete(contact);
							}
							catch(Exception ex)
							{
								string sError = "Error clearing iCloud groups for " + sContactName + " from " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							try
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Deleting " + sContactName + " from " + sICLOUD_USERNAME);
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
										SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sREMOTE_KEY, "iCloud", trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										throw;
									}
								}
							}
							catch(Exception ex)
							{
								string sError = "Error deleting " + sContactName + " from " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
						}
						else if ( sSYNC_ACTION == "remote deleted" && !Sql.IsEmptyGuid(gID) )
						{
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Unsyncing contact " + sContactName + " for " + sICLOUD_USERNAME);
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gID, sREMOTE_KEY, "iCloud", trn);
									trn.Commit();
								}
								catch
								{
									trn.Rollback();
									throw;
								}
							}
						}
					}
				}
			}
		}
		#endregion

		#region Sync Appointments
		public DataTable AppointmentEmails(HttpApplicationState Application, IDbConnection con, Guid gID, Guid gUSER_ID)
		{
			DataTable dtAppointmentEmails = new DataTable();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					string sSQL;
					// 01/10/2012 Paul.  The iCloud sync needs the contact name. 
					sSQL = "select EMAIL1               " + ControlChars.CrLf
					     + "     , NAME                 " + ControlChars.CrLf
					     + "     , REQUIRED             " + ControlChars.CrLf
					     + "     , ACCEPT_STATUS        " + ControlChars.CrLf
					     + "     , ASSIGNED_USER_ID     " + ControlChars.CrLf
					     + "  from vwAPPOINTMENTS_EMAIL1" + ControlChars.CrLf
					     + " where APPOINTMENT_ID = @ID " + ControlChars.CrLf;
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gID);
					
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dtAppointmentEmails);
					dtAppointmentEmails.Columns.Add("ICLOUD_ID", typeof(String));
					dtAppointmentEmails.Columns.Add("REL"      , typeof(String));
					dtAppointmentEmails.Columns.Add("PREFIX"   , typeof(String));
					dtAppointmentEmails.Columns.Add("TYPE"     , typeof(String));
					foreach ( DataRow row in dtAppointmentEmails.Rows )
					{
						row["REL"] = (gUSER_ID == Sql.ToGuid(row["ASSIGNED_USER_ID"])) ? "ORGANIZER" : "ATTENDEE" ;
					}
				}
			}
			return dtAppointmentEmails;
		}

		public bool SetiCloudAppointment(AppointmentEntry appointment, DataRow row, DataTable dtAppointmentEmails, string sICLOUD_USERNAME, StringBuilder sbChanges, bool bDISABLE_PARTICIPANTS)
		{
			bool bChanged = false;
			appointment.Created = Sql.ToDateTime(row["DATE_ENTERED" ]);
			appointment.Updated = Sql.ToDateTime(row["DATE_MODIFIED"]);
			if ( appointment.Created == DateTime.MinValue )
				appointment.Created = DateTime.Now;
			if ( appointment.Updated == DateTime.MinValue )
				appointment.Updated = DateTime.Now;
			if ( Sql.IsEmptyString(appointment.UID) )
			{
				// 03/28/2010 Paul.  You must load or assign this property before you can read its value. 
				// So set all the fields to empty values. 
				//appointment.Categories.Add("SplendidCRM");
				appointment.Title = Sql.ToString(row["NAME"]);
				
				if ( !Sql.IsEmptyString(row["LOCATION"]) )
				{
					string sLOCATION = Sql.ToString(row["LOCATION"]);
					Where wLOCATION = new Where(String.Empty, String.Empty, sLOCATION);
					appointment.Locations.Add(wLOCATION);
				}
				else if ( appointment.Locations != null )
				{
					appointment.Locations.Clear();
				}
				if ( !Sql.IsEmptyString(row["DESCRIPTION"]) )
				{
					appointment.Content = Sql.ToString(row["DESCRIPTION"]);
				}
				else
				{
					appointment.Content = null;
				}
				
				// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  iCloud stores the reminder in minutes. 
				int nREMINDER_MINUTES = Sql.ToInteger(row["REMINDER_TIME"]) / 60;
				// 02/20/2013 Paul.  Don't set the reminder for old appointments, but include appointments for today. 
				if ( nREMINDER_MINUTES > 0 && Sql.ToDateTime(row["DATE_START"]).AddHours(-12) >= DateTime.Now )
				{
					if ( appointment.Alarms.Count > 0 )
					{
						Alarm alarm = appointment.Alarms[0];
						alarm.Action          = "DISPLAY";
						alarm.Descripton      = "Event reminder";
						if ( nREMINDER_MINUTES / (24 * 60) > 0 )
							alarm.TriggerDuration = "-P" + nREMINDER_MINUTES / (24 * 60)  + "D";
						else if ( nREMINDER_MINUTES % 60 == 0 )
							alarm.TriggerDuration = "-PT" + nREMINDER_MINUTES / 60  + "H";
						else
							alarm.TriggerDuration = "-PT" + nREMINDER_MINUTES + "M";
					}
					else
					{
						Alarm alarm = new Alarm();
						alarm.Action          = "DISPLAY";
						alarm.Descripton      = "Event reminder";
						if ( nREMINDER_MINUTES / (24 * 60) > 0 )
							alarm.TriggerDuration = "-P" + nREMINDER_MINUTES / (24 * 60)  + "D";
						else if ( nREMINDER_MINUTES % 60 == 0 )
							alarm.TriggerDuration = "-PT" + nREMINDER_MINUTES / 60  + "H";
						else
							alarm.TriggerDuration = "-PT" + nREMINDER_MINUTES + "M";
						alarm.AlarmUID        = Guid.NewGuid().ToString();
						appointment.Alarms.Add(alarm);
					}
				}
				else if ( appointment.Alarms != null )
				{
					appointment.Alarms.Clear();
				}
				
				int nDURATION_HOURS   = Sql.ToInteger (row["DURATION_HOURS"  ]);
				int nDURATION_MINUTES = Sql.ToInteger (row["DURATION_MINUTES"]);
				DateTime dtDATE_START = Sql.ToDateTime(row["DATE_TIME"       ]);
				DateTime dtDATE_END   = dtDATE_START;
				dtDATE_END = dtDATE_END.AddHours  (nDURATION_HOURS  );
				dtDATE_END = dtDATE_END.AddMinutes(nDURATION_MINUTES);
				When eventTime = new When(dtDATE_START, dtDATE_END);
				// 04/02/2011 Paul.  Watch for an All-Day event. 
				// 03/10/2013 Paul.  Add ALL_DAY_EVENT. 
				eventTime.AllDay      = Sql.ToBoolean(row["ALL_DAY_EVENT"]);
				// 02/11/2012 Paul.  We create the first Times entry in the constructor, but just in case it does not exist, add it. 
				if ( appointment.Times.Count > 0 )
					appointment.Times[0] = eventTime;
				else
					appointment.Times.Add(eventTime);
				// 03/23/2013 Paul.  Add recurrence data. 
				if ( !Sql.IsEmptyString(row["REPEAT_TYPE"]) )
				{
					// http://www.ietf.org/rfc/rfc2445.txt
					string sRRULE = SplendidCRM.Utils.CalDAV_BuildRule(Sql.ToString(row["REPEAT_TYPE"]), Sql.ToInteger(row["REPEAT_INTERVAL"]), Sql.ToString(row["REPEAT_DOW"]), Sql.ToDateTime(row["REPEAT_UNTIL"]), Sql.ToInteger(row["REPEAT_COUNT"]));
					// 03/25/2013 Paul.  appointment should not include the key name in the value. 
					if ( sRRULE.StartsWith("RRULE:") )
						sRRULE = sRRULE.Replace("RRULE:", String.Empty);
					appointment.RRULE = sRRULE;
				}
				
				// 03/23/2013 Paul.  Add the ability to disable participants. 
				if ( !bDISABLE_PARTICIPANTS )
				{
					if ( dtAppointmentEmails != null && dtAppointmentEmails.Rows.Count > 0 )
					{
						foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
						{
							Who guest = new Who();
							guest.ID    = Sql.ToString(rowEmail["ICLOUD_ID"]);
							guest.Name  = Sql.ToString(rowEmail["NAME"     ]);
							guest.Email = Sql.ToString(rowEmail["EMAIL1"   ]);
							if ( rowEmail["REQUIRED"] != DBNull.Value )
							{
								guest.Attendee_Type = new Who.AttendeeType();
								if ( Sql.ToBoolean(rowEmail["REQUIRED"]) )
									guest.Attendee_Type.Value = Who.AttendeeType.EVENT_REQUIRED;
								else
									guest.Attendee_Type.Value = Who.AttendeeType.EVENT_OPTIONAL;
							}
							switch ( Sql.ToString(rowEmail["ACCEPT_STATUS"]) )
							{
								case "accept"   :  guest.Attendee_Status = new Who.AttendeeStatus(); guest.Attendee_Status.Value = Who.AttendeeStatus.EVENT_ACCEPTED ;  break;
								case "decline"  :  guest.Attendee_Status = new Who.AttendeeStatus(); guest.Attendee_Status.Value = Who.AttendeeStatus.EVENT_DECLINED ;  break;
								case "tentative":  guest.Attendee_Status = new Who.AttendeeStatus(); guest.Attendee_Status.Value = Who.AttendeeStatus.EVENT_TENTATIVE;  break;
								case "none"     :  guest.Attendee_Status = new Who.AttendeeStatus(); guest.Attendee_Status.Value = Who.AttendeeStatus.EVENT_INVITED  ;  break;
								case ""         :  guest.Attendee_Status = null;  break;
							}
							//if ( Sql.ToString(rowEmail["EMAIL1"]) == sICLOUD_USERNAME.ToLower() )
							if ( Sql.ToString(rowEmail["REL"]) == "ORGANIZER" )
								guest.Rel = Who.RelType.EVENT_ORGANIZER;
							else
								guest.Rel = Who.RelType.EVENT_ATTENDEE;
							appointment.Participants.Add(guest);
						}
					}
				}
				bChanged = true;
			}
			else
			{
				// 03/29/2010 Paul.  Lets not always add the SplendidCRM category, but only do it during creation. 
				// This should not be an issue as we currently do not lookup the Exchange user when creating a appointment that originated from the CRM. 
				//if ( !appointment.Categories.Contains("SplendidCRM") )
				//{
				//	appointment.Categories.Add("SplendidCRM");
				//	bChanged = true;
				//}

				if ( appointment.Content == null || Sql.ToString(appointment.Content) != Sql.ToString(row["DESCRIPTION"]) )
				{
					if ( appointment.Content != null || !Sql.IsEmptyString(row["DESCRIPTION"]) )
					{
						appointment.Content = Sql.ToString(row["DESCRIPTION"]);
						if ( Sql.IsEmptyString(appointment.Content) )
						{
							appointment.Content = null;
						}
						bChanged = true;
						sbChanges.AppendLine("DESCRIPTION" + " changed.");
					}
				}
				if ( Sql.ToString  (appointment.Title ) != Sql.ToString  (row["NAME"]) )
				{
					appointment.Title = Sql.ToString(row["NAME"]);
					bChanged = true;
					sbChanges.AppendLine("NAME" + " changed.");
				}
				
				Where wLOCATION = null;
				if ( appointment.Locations != null && appointment.Locations.Count > 0 )
				{
					wLOCATION = appointment.Locations[0];
				}
				if ( wLOCATION == null || Sql.ToString(wLOCATION.ValueString) != Sql.ToString(row["LOCATION"]) )
				{
					if ( wLOCATION != null || !Sql.IsEmptyString(row["LOCATION"]) )
					{
						if ( wLOCATION == null )
						{
							wLOCATION = new Where();
							appointment.Locations.Add(wLOCATION);
						}
						wLOCATION.ValueString = Sql.ToString(row["LOCATION"]);
						if ( Sql.IsEmptyString(wLOCATION.ValueString) )
						{
							// 04/16/2011 Paul.  iCloud is not clearing the location.  Not sure what else we can do. 
							appointment.Locations.Remove(wLOCATION);
						}
						bChanged = true;
						sbChanges.AppendLine("LOCATION" + " changed.");
					}
				}
				int nDURATION_HOURS   = Sql.ToInteger(row["DURATION_HOURS"  ]);
				int nDURATION_MINUTES = Sql.ToInteger(row["DURATION_MINUTES"]);
				DateTime dtDATE_START = Sql.ToDateTime(row["DATE_TIME"]);
				DateTime dtDATE_END   = dtDATE_START;
				dtDATE_END = dtDATE_END.AddHours  (nDURATION_HOURS  );
				dtDATE_END = dtDATE_END.AddMinutes(nDURATION_MINUTES);
				
				// 03/29/2010 Paul.  iCloud will use UTC. 
				When eventTime = appointment.Times[0];
				if ( Sql.ToDateTime(eventTime.StartTime) != dtDATE_START )
				{
					eventTime.StartTime = dtDATE_START ;
					bChanged = true;
					sbChanges.AppendLine("DATE_START" + " changed.");
				}
				if ( Sql.ToDateTime(eventTime.EndTime  ) != dtDATE_END   )
				{
					eventTime.EndTime = dtDATE_END;
					bChanged = true;
					sbChanges.AppendLine("DATE_END" + " changed.");
				}
				// 04/02/2011 Paul.  Watch for an All-Day event. 
				// 03/10/2013 Paul.  Add ALL_DAY_EVENT. 
				if ( eventTime.AllDay != Sql.ToBoolean(row["ALL_DAY_EVENT"]) )
				{
					eventTime.AllDay = Sql.ToBoolean(row["ALL_DAY_EVENT"]);
					bChanged = true;
					sbChanges.AppendLine("AllDay" + " changed.");
				}
				
				int nAlarmMinutes = 0;
				if ( appointment.Alarms.Count > 0 )
				{
					// http://www.ietf.org/rfc/rfc2445.txt
					// 4.3.6   Duration
					// dur-value  = (["+"] / "-") "P" (dur-date / dur-time / dur-week)
					// dur-date   = dur-day [dur-time]
					// dur-time   = "T" (dur-hour / dur-minute / dur-second)
					// dur-week   = 1*DIGIT "W"
					// dur-hour   = 1*DIGIT "H" [dur-minute]
					// dur-minute = 1*DIGIT "M" [dur-second]
					// dur-second = 1*DIGIT "S"
					// 02/13/2012 Paul.  Only sync alarms that have either minutes or hours. -PT5M
					string sDuration = appointment.Alarms[0].TriggerDuration;
					if ( sDuration.StartsWith("-PT") && (sDuration.EndsWith("M") || sDuration.EndsWith("H")) && sDuration.Length <= 7 )
					{
						int nDuration = Sql.ToInteger(sDuration.Substring(3, sDuration.Length - 4));
						if ( sDuration.EndsWith("M") )
							nAlarmMinutes = nDuration;
						else if ( sDuration.EndsWith("H") )
							nAlarmMinutes = 60 * nDuration;
					}
					else if ( sDuration.StartsWith("-P") && sDuration.EndsWith("D") && sDuration.Length <= 5 )
					{
						int nDuration = Sql.ToInteger(sDuration.Substring(2, sDuration.Length - 3));
						nAlarmMinutes = 24 * 60 * nDuration;
					}
					else
					{
						// 02/13/2012 Paul.  Unknown duration format. 
						nAlarmMinutes = -1;
					}
				}
				// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  iCloud stores the reminder in minutes. 
				int nREMINDER_MINUTES = Sql.ToInteger(row["REMINDER_TIME"]) / 60;
				if ( nREMINDER_MINUTES != nAlarmMinutes )
				{
					if ( nREMINDER_MINUTES > 0 )
					{
						if ( appointment.Alarms.Count > 0 )
						{
							Alarm alarm = appointment.Alarms[0];
							alarm.Action          = "DISPLAY";
							alarm.Descripton      = "Event reminder";
							if ( nREMINDER_MINUTES / (24 * 60) > 0 )
								alarm.TriggerDuration = "-P" + nREMINDER_MINUTES / (24 * 60)  + "D";
							else if ( nREMINDER_MINUTES % 60 == 0 )
								alarm.TriggerDuration = "-PT" + nREMINDER_MINUTES / 60  + "H";
							else
								alarm.TriggerDuration = "-PT" + nREMINDER_MINUTES + "M";
						}
						else
						{
							Alarm alarm = new Alarm();
							alarm.Action          = "DISPLAY";
							alarm.Descripton      = "Event reminder";
							if ( nREMINDER_MINUTES / (24 * 60) > 0 )
								alarm.TriggerDuration = "-P" + nREMINDER_MINUTES / (24 * 60)  + "D";
							else if ( nREMINDER_MINUTES % 60 == 0 )
								alarm.TriggerDuration = "-PT" + nREMINDER_MINUTES / 60  + "H";
							else
								alarm.TriggerDuration = "-PT" + nREMINDER_MINUTES + "M";
							alarm.AlarmUID        = Guid.NewGuid().ToString();
							appointment.Alarms.Add(alarm);
						}
						bChanged = true;
						sbChanges.AppendLine("REMINDER_TIME" + " changed.");
					}
					else if ( appointment.Alarms != null && appointment.Alarms.Count > 0 )
					{
						// 02/13/2012 Paul.  Don't clear the alarm if the format is unknown. 
						if ( nAlarmMinutes != -1 )
						{
							appointment.Alarms.Clear();
							bChanged = true;
							sbChanges.AppendLine("REMINDER_TIME" + " changed.");
						}
					}
				}
				// 03/23/2013 Paul.  Add recurrence data. 
				if ( !Sql.IsEmptyString(row["REPEAT_TYPE"]) )
				{
					// http://www.ietf.org/rfc/rfc2445.txt
					string sRRULE = SplendidCRM.Utils.CalDAV_BuildRule(Sql.ToString(row["REPEAT_TYPE"]), Sql.ToInteger(row["REPEAT_INTERVAL"]), Sql.ToString(row["REPEAT_DOW"]), Sql.ToDateTime(row["REPEAT_UNTIL"]), Sql.ToInteger(row["REPEAT_COUNT"]));
					if ( appointment.RRULE != sRRULE )
					{
						// 03/25/2013 Paul.  appointment should not include the key name in the value. 
						if ( sRRULE.StartsWith("RRULE:") )
							sRRULE = sRRULE.Replace("RRULE:", String.Empty);
						appointment.RRULE = sRRULE;
						bChanged = true;
						sbChanges.AppendLine("RRULE" + " changed.");
					}
				}
				else
				{
					appointment.RRULE = String.Empty;
				}
				
				// 03/23/2013 Paul.  Add the ability to disable participants. 
				if ( !bDISABLE_PARTICIPANTS )
				{
					if ( dtAppointmentEmails != null && dtAppointmentEmails.Rows.Count > 0 )
					{
						bool bParticipantsChanged = false;
						foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
						{
							bool bEmailFound = false;
							string sEmail = Sql.ToString(rowEmail["EMAIL1"]);
							foreach ( Who guest in appointment.Participants )
							{
								if ( sEmail == guest.Email )
								{
									bEmailFound = true;
									bool bREQUIRED = false;
									if ( guest.Attendee_Type != null )
									{
										if ( guest.Attendee_Type.Value == Who.AttendeeType.EVENT_REQUIRED )
											bREQUIRED = true;
									}
									if ( bREQUIRED != Sql.ToBoolean(rowEmail["REQUIRED"]) )
									{
										bParticipantsChanged = true;
										break;
									}
									string sACCEPT_STATUS = String.Empty;
									if ( guest.Attendee_Status != null )
									{
										switch ( guest.Attendee_Status.Value )
										{
											case Who.AttendeeStatus.EVENT_ACCEPTED :  sACCEPT_STATUS = "accept"   ;  break;
											case Who.AttendeeStatus.EVENT_DECLINED :  sACCEPT_STATUS = "decline"  ;  break;
											case Who.AttendeeStatus.EVENT_TENTATIVE:  sACCEPT_STATUS = "tentative";  break;
										}
									}
									if ( sACCEPT_STATUS != Sql.ToString(rowEmail["ACCEPT_STATUS"]) )
									{
										bParticipantsChanged = true;
										break;
									}
									break;
								}
							}
							if ( !bEmailFound )
							{
								bParticipantsChanged = true;
								break;
							}
						}
						foreach ( Who guest in appointment.Participants )
						{
							bool bEmailFound = false;
							foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
							{
								string sEmail = Sql.ToString(rowEmail["EMAIL1"]);
								if ( sEmail == guest.Email )
								{
									bEmailFound = true;
									break;
								}
							}
							if ( !bEmailFound )
							{
								bParticipantsChanged = true;
								break;
							}
						}
						if ( bParticipantsChanged )
						{
							appointment.Participants.Clear();
							foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
							{
								Who guest = new Who();
								string sEmail = Sql.ToString(rowEmail["EMAIL1"]);
								guest.Email = sEmail;
								if ( rowEmail["REQUIRED"] != DBNull.Value )
								{
									guest.Attendee_Type = new Who.AttendeeType();
									if ( Sql.ToBoolean(rowEmail["REQUIRED"]) )
										guest.Attendee_Type.Value = Who.AttendeeType.EVENT_REQUIRED;
									else
										guest.Attendee_Type.Value = Who.AttendeeType.EVENT_OPTIONAL;
								}
								switch ( Sql.ToString(rowEmail["ACCEPT_STATUS"]) )
								{
									case "accept"   :  guest.Attendee_Status = new Who.AttendeeStatus(); guest.Attendee_Status.Value = Who.AttendeeStatus.EVENT_ACCEPTED ;  break;
									case "decline"  :  guest.Attendee_Status = new Who.AttendeeStatus(); guest.Attendee_Status.Value = Who.AttendeeStatus.EVENT_DECLINED ;  break;
									case "tentative":  guest.Attendee_Status = new Who.AttendeeStatus(); guest.Attendee_Status.Value = Who.AttendeeStatus.EVENT_TENTATIVE;  break;
									case "none"     :  guest.Attendee_Status = new Who.AttendeeStatus(); guest.Attendee_Status.Value = Who.AttendeeStatus.EVENT_INVITED  ;  break;
									case ""         :  guest.Attendee_Status = null;  break;
								}
								if ( sEmail == sICLOUD_USERNAME.ToLower() )
									guest.Rel = Who.RelType.EVENT_ORGANIZER;
								else
									guest.Rel = Who.RelType.EVENT_ATTENDEE;
								appointment.Participants.Add(guest);
							}
							sbChanges.AppendLine("PARTICIPANTS" + " changed.");
						}
					}
					else
					{
						if ( appointment.Participants.Count > 0 )
						{
							appointment.Participants.Clear();
							sbChanges.AppendLine("PARTICIPANTS" + " changed.");
						}
					}
				}
			}
			return bChanged;
		}

		public void SyncAppointments(ExchangeSession Session, CalendarService service, string sICLOUD_USERNAME, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			// 03/23/2013 Paul.  Add the ability to disable participants. 
			bool bDISABLE_PARTICIPANTS = Sql.ToBoolean(Application["CONFIG.iCloud.DisableParticipants"]);
			bool bVERBOSE_STATUS       = Sql.ToBoolean(Application["CONFIG.iCloud.VerboseStatus"      ]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + sICLOUD_USERNAME + " to " + gUSER_ID.ToString());
			// 02/20/2013 Paul.  Reduced the number of days to go back. 
			int  nAPPOINTMENT_AGE_DAYS = Sql.ToInteger(Application["CONFIG.iCloud.AppointmentAgeDays"]);
			if ( nAPPOINTMENT_AGE_DAYS == 0 )
				nAPPOINTMENT_AGE_DAYS = 7;
			
			string sCONFLICT_RESOLUTION = Sql.ToString(Application["CONFIG.iCloud.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				
				try
				{
					string sSQL = String.Empty;
					List<AppointmentEntry> fEventResults = service.SyncQuery(Context, bSyncAll);
					if ( fEventResults.Count > 0 )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + fEventResults.Count.ToString() + " appointments to retrieve from " + sICLOUD_USERNAME);
					foreach (AppointmentEntry appointment in fEventResults )
					{
						// 01/24/2012 Paul.  We need to have a way to force an update as we cannot rely upon the iCloud embedded revision date. 
						// If the bSyncAll flag is not set, then the contact has changed remotely, regardless of the embedded date. 
						this.ImportAppointment(Session, service, con, sICLOUD_USERNAME, gUSER_ID, appointment, sbErrors);
					}
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spICLOUD_USERS_CalendarCTAG(gUSER_ID, service.CalendarCTag, trn);
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
							throw;
						}
					}
					
					// 03/26/2010 Paul.  Join to vwAPPOINTMENTS_USERS so that we only get appointments that are marked as Sync. 
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					// 01/07/2012 Paul.  We use DATE_TIME in SetiCloudAppointment. 
					sSQL = "select vwAPPOINTMENTS.*                                                                   " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS.DATE_START                         as DATE_TIME                     " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_ID                                                        " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_REMOTE_KEY                                                " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                   " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                  " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_RAW_CONTENT                                               " + ControlChars.CrLf
					     + "  from            vwAPPOINTMENTS                                                          " + ControlChars.CrLf
					     + "       inner join vwAPPOINTMENTS_USERS                                                    " + ControlChars.CrLf
					     + "               on vwAPPOINTMENTS_USERS.APPOINTMENT_ID       = vwAPPOINTMENTS.ID           " + ControlChars.CrLf
					     + "              and vwAPPOINTMENTS_USERS.USER_ID              = @SYNC_USER_ID               " + ControlChars.CrLf
					     + "  left outer join vwAPPOINTMENTS_SYNC                                                     " + ControlChars.CrLf
					     + "               on vwAPPOINTMENTS_SYNC.SYNC_SERVICE_NAME     = N'iCloud'                   " + ControlChars.CrLf
					     + "              and vwAPPOINTMENTS_SYNC.SYNC_LOCAL_ID         = vwAPPOINTMENTS.ID           " + ControlChars.CrLf
					     + "              and vwAPPOINTMENTS_SYNC.SYNC_ASSIGNED_USER_ID = vwAPPOINTMENTS_USERS.USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SYNC_USER_ID", gUSER_ID);
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Appointments", "view");
						
						// 03/28/2010 Paul.  All that is important is that the current date is greater than the last sync date. 
						// 03/29/2010 Paul.  We do not want to sync with old appointments, so place a 3-month limit. 
						// 05/09/2018 Paul.  System updates can modify the UTC date, so make sure that age is outside that filter. 
						cmd.CommandText += "   and (vwAPPOINTMENTS_SYNC.ID is null or vwAPPOINTMENTS.DATE_MODIFIED_UTC > vwAPPOINTMENTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC)" + ControlChars.CrLf;
						cmd.CommandText += "   and vwAPPOINTMENTS.DATE_MODIFIED > @DATE_MODIFIED" + ControlChars.CrLf;
						// 02/20/2013 Paul.  Reduced the number of days to go back. 
						Sql.AddParameter(cmd, "@DATE_MODIFIED", DateTime.Now.AddDays(-nAPPOINTMENT_AGE_DAYS));
						cmd.CommandText += " order by vwAPPOINTMENTS.DATE_MODIFIED_UTC" + ControlChars.CrLf;
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + dt.Rows.Count.ToString() + " appointments to send to " + sICLOUD_USERNAME);
								foreach ( DataRow row in dt.Rows )
								{
									Guid     gID                             = Sql.ToGuid    (row["ID"                           ]);
									Guid     gASSIGNED_USER_ID               = Sql.ToGuid    (row["ASSIGNED_USER_ID"             ]);
									Guid     gSYNC_ID                        = Sql.ToGuid    (row["SYNC_ID"                      ]);
									string   sSYNC_REMOTE_KEY                = Sql.ToString  (row["SYNC_REMOTE_KEY"              ]);
									DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
									DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
									DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
									string   sSYNC_RAW_CONTENT               = Sql.ToString  (row["SYNC_RAW_CONTENT"             ]);
									string   sSYNC_ACTION                    = Sql.IsEmptyGuid(gSYNC_ID) ? "local new" : "local changed";
									if ( SplendidInit.bEnableACLFieldSecurity )
									{
										bool bApplyACL = false;
										foreach ( DataColumn col in dt.Columns )
										{
											Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Appointments", col.ColumnName, gASSIGNED_USER_ID);
											if ( !acl.IsReadable() )
											{
												row[col.ColumnName] = DBNull.Value;
												bApplyACL = true;
											}
										}
										if ( bApplyACL )
											dt.AcceptChanges();
									}
									StringBuilder sbChanges = new StringBuilder();
									try
									{
										AppointmentEntry appointment = null;
										if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Sending new appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sICLOUD_USERNAME);
											appointment = new AppointmentEntry();
											DataTable dtAppointmentEmails = AppointmentEmails(Application, con, Sql.ToGuid(row["ID"]), gUSER_ID);
											// 03/23/2013 Paul.  Add the ability to disable participants. 
											this.SetiCloudAppointment(appointment, row, dtAppointmentEmails, sICLOUD_USERNAME, sbChanges, bDISABLE_PARTICIPANTS);
											
											AppointmentEntry result = service.Insert(Context, appointment);
											sSYNC_REMOTE_KEY = result.UID;
										}
										else
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Binding appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sICLOUD_USERNAME);
											
											try
											{
												appointment = service.Get(Context, sSYNC_REMOTE_KEY) as AppointmentEntry;
												// 03/28/2010 Paul.  We need to double-check for conflicts. 
												// 03/26/2011 Paul.  Updated is in local time. 
												DateTime dtREMOTE_DATE_MODIFIED     = appointment.Updated;
												DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
												// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
												if ( (dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) || sSYNC_RAW_CONTENT != appointment.RawContent) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
												{
													if ( sCONFLICT_RESOLUTION == "remote" )
													{
														// 03/24/2010 Paul.  Remote is the winner of conflicts. 
														sSYNC_ACTION = "remote changed";
													}
													else if ( sCONFLICT_RESOLUTION == "local" )
													{
														// 03/24/2010 Paul.  Local is the winner of conflicts. 
														sSYNC_ACTION = "local changed";
													}
													// 03/26/2011 Paul.  The iCloud remote date can vary by 1 millisecond, so check for local change first. 
													else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "local changed";
													}
													else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "remote changed";
													}
													else
													{
														sSYNC_ACTION = "prompt change";
													}
												}
												if ( appointment.Deleted )
												{
													sSYNC_ACTION = "remote deleted";
												}
											}
											catch(Exception ex)
											{
												string sError = "Error retrieving iCloud appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
												sError += Utils.ExpandException(ex) + ControlChars.CrLf;
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
												sbErrors.AppendLine(sError);
												sSYNC_ACTION = "remote deleted";
											}
											if ( sSYNC_ACTION == "local changed" )
											{
												// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
												// 07/18/2010 Paul.  Move iCloud Sync functions to a separate class. 
												DataTable dtAppointmentEmails = AppointmentEmails(Application, con, Sql.ToGuid(row["ID"]), gUSER_ID);
												// 03/23/2013 Paul.  Add the ability to disable participants. 
												bool bChanged = this.SetiCloudAppointment(appointment, row, dtAppointmentEmails, sICLOUD_USERNAME, sbChanges, bDISABLE_PARTICIPANTS);
												if ( bChanged )
												{
													if ( bVERBOSE_STATUS )
														SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Sending appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sICLOUD_USERNAME);
													service.Update(Context, appointment);
												}
											}
										}
										if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
										{
											if ( appointment != null )
											{
												// 03/25/2010 Paul.  Update the modified date after the save. 
												// 03/26/2011 Paul.  Updated is in local time. 
												DateTime dtREMOTE_DATE_MODIFIED     = appointment.Updated;
												DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														// 03/26/2010 Paul.  Make sure to set the Sync flag. 
														// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
														// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
														// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
														SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sSYNC_REMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "iCloud", appointment.RawContent, trn);
														trn.Commit();
													}
													catch
													{
														trn.Rollback();
														throw;
													}
												}
											}
										}
										else if ( sSYNC_ACTION == "remote deleted" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Unsyncing appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " for " + sICLOUD_USERNAME);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gID, sSYNC_REMOTE_KEY, "iCloud", trn);
													trn.Commit();
												}
												catch
												{
													trn.Rollback();
													throw;
												}
											}
										}
									}
									catch(Exception ex)
									{
										// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
										string sError = "Error creating iCloud appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " for " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
										sError += sbChanges.ToString();
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
									}
								}
							}
						}
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					sbErrors.AppendLine(Utils.ExpandException(ex));
				}
			}
		}

		// 12/26/2011 Paul.  Move population logic to a static method. 
		// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
		public bool BuildAPPOINTMENTS_Update(HttpApplicationState Application, ExchangeSession Session, IDbCommand spAPPOINTMENTS_Update, DataRow row, AppointmentEntry appointment, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID)
		{
			bool bChanged = false;
			// 03/25/2010 Paul.  We start with the existing record values so that we can apply ACL Field Security rules. 
			if ( row != null && row.Table != null )
			{
				foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					// 03/28/2010 Paul.  We must assign a value to all parameters. 
					string sParameterName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
					if ( row.Table.Columns.Contains(sParameterName) )
						par.Value = row[sParameterName];
					else
						par.Value = DBNull.Value;
				}
			}
			else
			{
				bChanged = true;
				foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					string sParameterName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
					if ( sParameterName == "TEAM_ID" )
						par.Value = gTEAM_ID;
					else if ( sParameterName == "ASSIGNED_USER_ID" )
						par.Value = gUSER_ID;
					// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
					else if ( sParameterName == "MODIFIED_USER_ID" )
						par.Value = gUSER_ID;
					else
						par.Value = DBNull.Value;
				}
			}
			if ( appointment != null )
			{
				TimeSpan tsDURATION = TimeSpan.Zero;
				if ( appointment.Times != null && appointment.Times.Count > 0 )
					tsDURATION = (appointment.Times[0].EndTime - appointment.Times[0].StartTime);
				string sRRULE = Sql.ToString(appointment.RRULE) + ";";  // Add the trailing separator to simplify parsing. 
				foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
				{
					Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					string sColumnName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
					if ( SplendidInit.bEnableACLFieldSecurity )
					{
						acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Appointments", sColumnName, gASSIGNED_USER_ID);
					}
					if ( acl.IsWriteable() )
					{
						try
						{
							// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
							object oValue = null;
							switch ( sColumnName )
							{
								case "NAME"                      :  oValue = Sql.ToDBString  (appointment.Title              )    ;  break;
								case "DATE_TIME"                 :  oValue = Sql.ToDBDateTime(appointment.Times[0].StartTime )    ;  break;
								case "DURATION_MINUTES"          :  oValue = appointment.Times[0].AllDay ?  0 : tsDURATION.Minutes;  break;
								case "DURATION_HOURS"            :  oValue = appointment.Times[0].AllDay ? 24 : tsDURATION.Hours  ;  break;
								// 03/10/2013 Paul.  Add ALL_DAY_EVENT. 
								case "ALL_DAY_EVENT"             :  oValue = appointment.Times[0].AllDay                          ;  break;
								case "DESCRIPTION"               :  oValue = Sql.ToDBString(appointment.Content);  break;
								case "LOCATION"                  :  oValue = (appointment.Locations != null && appointment.Locations.Count > 0) ? Sql.ToDBString  (appointment.Locations[0].ValueString) : String.Empty;  break;
								case "REMINDER_TIME"             :
								{
									if ( appointment.Alarms.Count > 0 )
									{
										// http://www.ietf.org/rfc/rfc2445.txt
										// 4.3.6   Duration
										// dur-value  = (["+"] / "-") "P" (dur-date / dur-time / dur-week)
										// dur-date   = dur-day [dur-time]
										// dur-time   = "T" (dur-hour / dur-minute / dur-second)
										// dur-week   = 1*DIGIT "W"
										// dur-hour   = 1*DIGIT "H" [dur-minute]
										// dur-minute = 1*DIGIT "M" [dur-second]
										// dur-second = 1*DIGIT "S"
										// 02/13/2012 Paul.  Only sync alarms that have either minutes or hours. -PT5M
										string sDuration = appointment.Alarms[0].TriggerDuration;
										if ( sDuration.StartsWith("-PT") && (sDuration.EndsWith("M") || sDuration.EndsWith("H")) && sDuration.Length <= 7 )
										{
											int nDuration = Sql.ToInteger(sDuration.Substring(3, sDuration.Length - 4));
											if ( sDuration.EndsWith("M") )
												oValue = 60 * nDuration;
											else if ( sDuration.EndsWith("H") )
												oValue = 60 * 60 * nDuration;
										}
										else if ( sDuration.StartsWith("-P") && sDuration.EndsWith("D") && sDuration.Length <= 5 )
										{
											int nDuration = Sql.ToInteger(sDuration.Substring(2, sDuration.Length - 3));
											oValue = 24 * 60 * 60 * nDuration;
										}
										else
										{
											// 02/13/2012 Paul.  If we do not understand the duration format, clear the CRM reminder value. 
											oValue = 0;
										}
									}
									break;
								}
								// 04/02/2011 Paul.  Watch for an All-Day event. 
								// 04/01/2011 Paul.  REMINDER_TIME is in seconds.  iCloud stores the reminder in minutes. 
								case "MODIFIED_USER_ID"          :  oValue = gUSER_ID;  break;
								case "STATUS"                    :
								{
									// Planned
									// Held
									// Not held
									if ( appointment.Status == AppointmentEntry.EventStatus_CANCELED )
										oValue = "Not held";
									else if ( appointment.Status == AppointmentEntry.EventStatus_CONFIRMED )
										oValue = "Planned";
									else if ( appointment.Status == AppointmentEntry.EventStatus_TENTATIVE )
										oValue = "Planned";
									break;
								}
								// 03/23/2013 Paul.  Add recurrence data. 
								case "REPEAT_TYPE":
								{
									oValue = String.Empty;
									if ( sRRULE.Contains("FREQ=DAILY") )
										oValue = "Daily";
									else if ( sRRULE.Contains("FREQ=WEEKLY") )
										oValue = "Weekly";
									else if ( sRRULE.Contains("FREQ=MONTHLY") )
										oValue = "Monthly";
									else if ( sRRULE.Contains("FREQ=YEARLY") )
										oValue = "Yearly";
									break;
								}
								case "REPEAT_INTERVAL":
								{
									oValue = 0;
									if ( sRRULE.Contains("INTERVAL=") )
									{
										int nStart = sRRULE.IndexOf("INTERVAL=") + "INTERVAL=".Length;
										int nEnd   = sRRULE.IndexOf(";", nStart);
										string sREPEAT_INTERVAL = sRRULE.Substring(nStart, nEnd - nStart);
										oValue = Sql.ToInteger(sREPEAT_INTERVAL);
									}
									break;
								}
								case "REPEAT_DOW":
								{
									oValue = String.Empty;
									if ( sRRULE.Contains("BYDAY=") )
									{
										int nStart = sRRULE.IndexOf("BYDAY=") + "BYDAY=".Length;
										int nEnd   = sRRULE.IndexOf(";", nStart);
										string sGOOGLE_DOW = sRRULE.Substring(nStart , nEnd - nStart);
										string sREPEAT_DOW = String.Empty;
										if ( sGOOGLE_DOW.Contains("SU") ) sREPEAT_DOW += "0";
										if ( sGOOGLE_DOW.Contains("MO") ) sREPEAT_DOW += "1";
										if ( sGOOGLE_DOW.Contains("TU") ) sREPEAT_DOW += "2";
										if ( sGOOGLE_DOW.Contains("WE") ) sREPEAT_DOW += "3";
										if ( sGOOGLE_DOW.Contains("TH") ) sREPEAT_DOW += "4";
										if ( sGOOGLE_DOW.Contains("FR") ) sREPEAT_DOW += "5";
										if ( sGOOGLE_DOW.Contains("SA") ) sREPEAT_DOW += "6";
										oValue = sREPEAT_DOW;
									}
									break;
								}
								case "REPEAT_UNTIL":
								{
									oValue = DBNull.Value;
									if ( sRRULE.Contains("UNTIL=") )
									{
										int nStart = sRRULE.IndexOf("UNTIL=") + "UNTIL=".Length;
										int nEnd   = sRRULE.IndexOf(";", nStart);
										oValue = Utils.CalDAV_ParseDate(sRRULE.Substring(nStart , nEnd - nStart));
									}
									break;
								}
								case "REPEAT_COUNT":
								{
									oValue = 0;
									if ( sRRULE.Contains("COUNT=") )
									{
										int nStart = sRRULE.IndexOf("COUNT=") + "COUNT=".Length;
										int nEnd   = sRRULE.IndexOf(";", nStart);
										string sREPEAT_COUNT = sRRULE.Substring(nStart, nEnd - nStart);
										oValue = Sql.ToInteger(sREPEAT_COUNT);
									}
									break;
								}
							}
							// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
							if ( oValue != null )
							{
								if ( !bChanged )
								{
									switch ( par.DbType )
									{
										case DbType.Guid    :  if ( Sql.ToGuid    (par.Value) != Sql.ToGuid    (oValue) ) bChanged = true;  break;
										case DbType.Int16   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
										case DbType.Int32   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
										case DbType.Int64   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
										case DbType.Double  :  if ( Sql.ToDouble  (par.Value) != Sql.ToDouble  (oValue) ) bChanged = true;  break;
										case DbType.Decimal :  if ( Sql.ToDecimal (par.Value) != Sql.ToDecimal (oValue) ) bChanged = true;  break;
										case DbType.Boolean :  if ( Sql.ToBoolean (par.Value) != Sql.ToBoolean (oValue) ) bChanged = true;  break;
										case DbType.DateTime:  if ( Sql.ToDateTime(par.Value) != Sql.ToDateTime(oValue) ) bChanged = true;  break;
										default             :  if ( Sql.ToString  (par.Value) != Sql.ToString  (oValue) ) bChanged = true;  break;
									}
								}
								par.Value = oValue;
							}
						}
						catch
						{
							// 04/01/2011 Paul.  Some fields are not available.  Lets just ignore them. 
						}
					}
				}
			}
			return bChanged;
		}

		// 01/24/2012 Paul.  We need to have a way to force an update as we cannot rely upon the iCloud embedded revision date. 
		public void ImportAppointment(ExchangeSession Session, CalendarService service, IDbConnection con, string sICLOUD_USERNAME, Guid gUSER_ID, AppointmentEntry appointment, StringBuilder sbErrors)
		{
			// 07/26/2012 James.  Add the ability to disable participants. 
			bool   bDISABLE_PARTICIPANTS = Sql.ToBoolean(Application["CONFIG.iCloud.DisableParticipants"]);
			bool   bVERBOSE_STATUS       = Sql.ToBoolean(Application["CONFIG.iCloud.VerboseStatus"      ]);
			string sCONFLICT_RESOLUTION  = Sql.ToString (Application["CONFIG.iCloud.ConflictResolution" ]);
			Guid   gTEAM_ID              = Sql.ToGuid   (Session["TEAM_ID"]);
			
			IDbCommand spAPPOINTMENTS_Update = SqlProcs.Factory(con, "spAPPOINTMENTS_Update");
			
			string   sREMOTE_KEY                = appointment.UID;
			// 03/26/2011 Paul.  Updated is in local time. 
			DateTime dtREMOTE_DATE_MODIFIED     = appointment.Updated;
			DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();

			String sSQL = String.Empty;
			// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
			sSQL = "select SYNC_ID                                       " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_DATE_MODIFIED_UTC                  " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_DATE_MODIFIED_UTC                 " + ControlChars.CrLf
			     + "     , SYNC_APPOINTMENT                              " + ControlChars.CrLf
			     + "     , SYNC_RAW_CONTENT                              " + ControlChars.CrLf
			     + "     , ID                                            " + ControlChars.CrLf
			     + "     , DATE_MODIFIED_UTC                             " + ControlChars.CrLf
			     + "  from vwAPPOINTMENTS_SYNC                           " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'iCloud'             " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
			     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
				Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					string sSYNC_ACTION   = String.Empty;
					Guid   gID            = Guid.Empty;
					Guid   gSYNC_LOCAL_ID = Guid.Empty;
					using ( DataTable dt = new DataTable() )
					{
						da.Fill(dt);
						if ( dt.Rows.Count > 0 )
						{
							DataRow row = dt.Rows[0];
							gID                                      = Sql.ToGuid    (row["ID"                           ]);
							gSYNC_LOCAL_ID                           = Sql.ToGuid    (row["SYNC_LOCAL_ID"                ]);
							DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
							DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
							DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
							bool     bSYNC_APPOINTMENT               = Sql.ToBoolean (row["SYNC_APPOINTMENT"             ]);
							string   sSYNC_RAW_CONTENT               = Sql.ToString  (row["SYNC_RAW_CONTENT"             ]);
							// 03/24/2010 Paul.  iCloud Record has already been mapped for this user. 
							// 03/28/2010 Paul.  If the ID is NULL and the LOCAL_ID is NOT NULL, then the local item must have been deleted. 
							// 03/29/2010 Paul.  If ID and LOCAL_ID are valid, but SYNC_APPOINTMENT is not, then the user has stopped syncing the contact. 
							if ( (Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID)) || (!Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID) && !bSYNC_APPOINTMENT) )
							{
								sSYNC_ACTION = "local deleted";
							}
							// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
							else if ( (dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) || sSYNC_RAW_CONTENT != appointment.RawContent) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								if ( sCONFLICT_RESOLUTION == "remote" )
								{
									// 03/24/2010 Paul.  Remote is the winner of conflicts. 
									sSYNC_ACTION = "remote changed";
								}
								else if ( sCONFLICT_RESOLUTION == "local" )
								{
									// 03/24/2010 Paul.  Local is the winner of conflicts. 
									sSYNC_ACTION = "local changed";
								}
								// 03/26/2011 Paul.  The iCloud remote date can vary by 1 millisecond, so check for local change first. 
								else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "local changed";
								}
								// 01/24/2012 Paul.  We need to have a way to force an update as we cannot rely upon the iCloud embedded revision date. 
								// If the bSyncAll flag is not set, then the contact has changed remotely, regardless of the embedded date. 
								// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
								else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC || sSYNC_RAW_CONTENT != appointment.RawContent )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "remote changed";
								}
								else
								{
									sSYNC_ACTION = "prompt change";
								}
								if ( appointment.Deleted )
								{
									sSYNC_ACTION = "remote deleted";
								}
							}
							// 01/24/2012 Paul.  We need to have a way to force an update as we cannot rely upon the iCloud embedded revision date. 
							// If the bSyncAll flag is not set, then the contact has changed remotely, regardless of the embedded date. 
							// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) || sSYNC_RAW_CONTENT != appointment.RawContent )
							{
								// 03/24/2010 Paul.  Remote Record has changed, but Local has not. 
								sSYNC_ACTION = "remote changed";
							}
							else if ( dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Local Record has changed, but Remote has not. 
								sSYNC_ACTION = "local changed";
							}
						}
						else if ( appointment.Deleted )
						{
							sSYNC_ACTION = "remote deleted";
						}
						else
						{
							sSYNC_ACTION = "remote new";
							
							// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to iCloud. 
							// 03/28/2010 Paul.  We need to prevent duplicate iCloud entries from attaching to an existing mapped Appointment ID. 
							// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
							cmd.Parameters.Clear();
							sSQL = "select vwAPPOINTMENTS.ID             " + ControlChars.CrLf
							     + "  from            vwAPPOINTMENTS     " + ControlChars.CrLf
							     + "  left outer join vwAPPOINTMENTS_SYNC" + ControlChars.CrLf
							     + "               on vwAPPOINTMENTS_SYNC.SYNC_SERVICE_NAME     = N'iCloud'             " + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_LOCAL_ID         = vwAPPOINTMENTS.ID     " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Appointments", "view");
							
							Sql.AppendParameter(cmd, Sql.ToString(appointment.Title), "NAME"      );
							Sql.AppendParameter(cmd, appointment.Times[0].StartTime      , "DATE_START");
							cmd.CommandText += "   and vwAPPOINTMENTS_SYNC.ID is null" + ControlChars.CrLf;
							gID = Sql.ToGuid(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyGuid(gID) )
							{
								// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to iCloud. 
								sSYNC_ACTION = "local new";
							}
						}
					}
					using ( DataTable dt = new DataTable() )
					{
						DataRow row = null;
						Guid   gASSIGNED_USER_ID = Guid.Empty;
						string sAPPOINTMENT_TYPE = String.Empty;
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" || sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new" )
						{
							if ( !Sql.IsEmptyGuid(gID) )
							{
								cmd.Parameters.Clear();
								// 03/25/2013 Paul.  We use DATE_TIME in SetiCloudAppointment. 
								sSQL = "select *                      " + ControlChars.CrLf
								     + "     , DATE_START as DATE_TIME" + ControlChars.CrLf
								     + "  from vwAPPOINTMENTS         " + ControlChars.CrLf
								     + " where ID = @ID               " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
								{
									row = dt.Rows[0];
									sAPPOINTMENT_TYPE = Sql.ToString(row["APPOINTMENT_TYPE"]);
									gASSIGNED_USER_ID = Sql.ToGuid  (row["ASSIGNED_USER_ID"]);
								}
							}
						}
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" )
						{
							// 03/30/2011 Paul.  We need to check for added or removed participants. 
							// 04/02/2012 Paul.  Add Calls/Leads relationship. 
							Dictionary<string, Guid> dictLeads       = new Dictionary<string,Guid>();
							Dictionary<string, Guid> dictContacts    = new Dictionary<string,Guid>();
							Dictionary<string, Guid> dictUsers       = new Dictionary<string,Guid>();
							List<string>             lstParticipants = new List<string>();
							DataTable dtUSERS = new DataTable();
							// 03/23/2013 Paul.  Add the ability to disable participants. 
							if ( !bDISABLE_PARTICIPANTS )
							{
								if ( appointment.Participants != null )
								{
									foreach ( Who guest in appointment.Participants )
									{
										lstParticipants.Add(guest.Email.ToLower());
									}
								}
								
								cmd.Parameters.Clear();
								sSQL = "select APPOINTMENT_ID         " + ControlChars.CrLf
								     + "     , APPOINTMENT_TYPE       " + ControlChars.CrLf
								     + "     , CONTACT_ID             " + ControlChars.CrLf
								     + "     , CONTACT_NAME           " + ControlChars.CrLf
								     + "     , EMAIL1                 " + ControlChars.CrLf
								     + "  from vwAPPOINTMENTS_CONTACTS" + ControlChars.CrLf
								     + " where APPOINTMENT_ID = @ID   " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtCONTACTS = new DataTable() )
								{
									da.Fill(dtCONTACTS);
									foreach ( DataRow rowContact in dtCONTACTS.Rows )
									{
										Guid   gAPPOINTMENT_CONTACT_ID = Sql.ToGuid  (rowContact["CONTACT_ID"]);
										string sAPPOINTMENT_EMAIL1     = Sql.ToString(rowContact["EMAIL1"    ]).ToLower();
										if ( !Sql.IsEmptyString(sAPPOINTMENT_EMAIL1) && !dictContacts.ContainsKey(sAPPOINTMENT_EMAIL1) )
											dictContacts.Add(sAPPOINTMENT_EMAIL1, gAPPOINTMENT_CONTACT_ID);
									}
								}
								
								// 04/02/2012 Paul.  Add Calls/Leads relationship. 
								cmd.Parameters.Clear();
								sSQL = "select APPOINTMENT_ID         " + ControlChars.CrLf
								     + "     , APPOINTMENT_TYPE       " + ControlChars.CrLf
								     + "     , LEAD_ID                " + ControlChars.CrLf
								     + "     , LEAD_NAME              " + ControlChars.CrLf
								     + "     , EMAIL1                 " + ControlChars.CrLf
								     + "  from vwAPPOINTMENTS_LEADS   " + ControlChars.CrLf
								     + " where APPOINTMENT_ID = @ID   " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtLEADS = new DataTable() )
								{
									da.Fill(dtLEADS);
									foreach ( DataRow rowLead in dtLEADS.Rows )
									{
										Guid   gAPPOINTMENT_LEAD_ID = Sql.ToGuid  (rowLead["LEAD_ID"]);
										string sAPPOINTMENT_EMAIL1  = Sql.ToString(rowLead["EMAIL1" ]).ToLower();
										if ( !Sql.IsEmptyString(sAPPOINTMENT_EMAIL1) && !dictLeads.ContainsKey(sAPPOINTMENT_EMAIL1) )
											dictLeads.Add(sAPPOINTMENT_EMAIL1, gAPPOINTMENT_LEAD_ID);
									}
								}
								
								cmd.Parameters.Clear();
								sSQL = "select vwAPPOINTMENTS_USERS.APPOINTMENT_ID      " + ControlChars.CrLf
								     + "     , vwAPPOINTMENTS_USERS.USER_ID             " + ControlChars.CrLf
								     + "     , vwICLOUD_USERS.EMAIL1                    " + ControlChars.CrLf
								     + "     , vwICLOUD_USERS.ICLOUD_USERNAME           " + ControlChars.CrLf
								     + "  from      vwAPPOINTMENTS_USERS                " + ControlChars.CrLf
								     + " inner join vwICLOUD_USERS                      " + ControlChars.CrLf
								     + "         on vwICLOUD_USERS.USER_ID = vwAPPOINTMENTS_USERS.USER_ID" + ControlChars.CrLf
								     + " where vwAPPOINTMENTS_USERS.APPOINTMENT_ID = @ID" + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dtUSERS);
								foreach ( DataRow rowUser in dtUSERS.Rows )
								{
									Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"        ]);
									string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EMAIL1"         ]).ToLower();
									string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["ICLOUD_USERNAME"]).ToLower();
									if ( !Sql.IsEmptyString(sAPPOINTMENT_EMAIL1) && !dictUsers.ContainsKey(sAPPOINTMENT_EMAIL1) )
										dictUsers.Add(sAPPOINTMENT_EMAIL1, gAPPOINTMENT_USER_ID);
									if ( !Sql.IsEmptyString(sAPPOINTMENT_USERNAME) && !dictUsers.ContainsKey(sAPPOINTMENT_USERNAME) )
										dictUsers.Add(sAPPOINTMENT_USERNAME, gAPPOINTMENT_USER_ID);
								}
							}
							
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Retrieving appointment " + Sql.ToString(appointment.Title) + " " + Sql.ToString(appointment.Times[0].StartTime) + " from " + sICLOUD_USERNAME);
									
									spAPPOINTMENTS_Update.Transaction = trn;
									// 12/26/2011 Paul.  Move population logic to a static method. 
									// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
									bool bChanged = BuildAPPOINTMENTS_Update(Application, Session, spAPPOINTMENTS_Update, row, appointment, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID);
									if ( !bChanged )
									{
										// 03/23/2013 Paul.  Add the ability to disable participants. 
										if ( !bDISABLE_PARTICIPANTS )
										{
											foreach ( string sEmail in lstParticipants )
											{
												// 04/02/2012 Paul.  Add Calls/Leads relationship. 
												if ( !dictContacts.ContainsKey(sEmail) && !dictLeads.ContainsKey(sEmail) )
													bChanged = true;
											}
											foreach ( string sEmail in dictContacts.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
													bChanged = true;
											}
											// 04/02/2012 Paul.  Add Calls/Leads relationship. 
											foreach ( string sEmail in dictLeads.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
													bChanged = true;
											}
											foreach ( DataRow rowUser in dtUSERS.Rows )
											{
												Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"        ]);
												string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EMAIL1"         ]).ToLower();
												string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["ICLOUD_USERNAME"]).ToLower();
												if ( gAPPOINTMENT_USER_ID != gUSER_ID && !lstParticipants.Contains(sAPPOINTMENT_EMAIL1) && !lstParticipants.Contains(sAPPOINTMENT_USERNAME) )
												{
													bChanged = true;
												}
											}
										}
									}
									if ( bChanged )
									{
										Sql.Trace(spAPPOINTMENTS_Update);
										spAPPOINTMENTS_Update.ExecuteNonQuery();
										IDbDataParameter parID = Sql.FindParameter(spAPPOINTMENTS_Update, "@ID");
										gID = Sql.ToGuid(parID.Value);
										
										// 03/23/2013 Paul.  Add the ability to disable participants. 
										if ( !bDISABLE_PARTICIPANTS )
										{
											// 01/14/2012 Paul.  We need to add the current user to the appointment so that the SYNC_APPOINTMENT will be true. 
											// If the end-user removes himself from the meeting, SYNC_APPOINTMENT will be false and the appointment will be treated as local deleted. 
											if ( sAPPOINTMENT_TYPE == "Meetings" || Sql.IsEmptyString(sAPPOINTMENT_TYPE) )
												SqlProcs.spMEETINGS_USERS_Update(gID, gUSER_ID, true, String.Empty, trn);
											else if ( sAPPOINTMENT_TYPE == "Calls" )
												SqlProcs.spCALLS_USERS_Update(gID, gUSER_ID, true, String.Empty, trn);
									
											if ( appointment.Participants != null )
											{
												foreach ( Who guest in appointment.Participants )
												{
													string sEmail         = guest.Email.ToLower();
													bool   bREQUIRED      = false;
													string sACCEPT_STATUS = String.Empty;
													if ( guest.Attendee_Status != null )
													{
														switch ( guest.Attendee_Status.Value )
														{
															case Who.AttendeeStatus.EVENT_ACCEPTED :  sACCEPT_STATUS = "accept"   ;  break;
															case Who.AttendeeStatus.EVENT_DECLINED :  sACCEPT_STATUS = "decline"  ;  break;
															case Who.AttendeeStatus.EVENT_TENTATIVE:  sACCEPT_STATUS = "tentative";  break;
															case Who.AttendeeStatus.EVENT_INVITED  :  sACCEPT_STATUS = "none"     ;  break;
														}
													}
													if ( guest.Attendee_Type != null )
													{
														if ( guest.Attendee_Type.Value == Who.AttendeeType.EVENT_REQUIRED )
															bREQUIRED = true;
													}
													// 01/10/2012 Paul.  iCloud can have contacts without an email. 
													Guid gCONTACT_ID = Guid.Empty;
													SqlProcs.spAPPOINTMENTS_RELATED_Update(gID, sEmail, bREQUIRED, sACCEPT_STATUS, guest.Name, ref gCONTACT_ID, trn);
													if ( Sql.IsEmptyGuid(gCONTACT_ID) )
													{
														string sNAME       = guest.Name;
														string sFIRST_NAME = String.Empty;
														string sLAST_NAME  = String.Empty;
														if ( Sql.IsEmptyString(sNAME) )
															sNAME = guest.Email;
														if ( sNAME.Contains("@") )
															sNAME = sNAME.Split('@')[0];
														sNAME = sNAME.Replace('.', ' ');
														sNAME = sNAME.Replace('_', ' ');
														sNAME = sNAME.Replace("  ", " ");
														sNAME = sNAME.Trim();
														string[] arrNAME = sNAME.Split(' ');
														if ( arrNAME.Length > 1 )
														{
															sFIRST_NAME = arrNAME[0];
															sLAST_NAME  = arrNAME[arrNAME.Length - 1];
														}
														else
														{
															sLAST_NAME = sNAME;
														}
														// 01/15/2012 Paul.  We can't use spCONTACTS_New because we need to set the Assigned User ID and the Team ID. 
														SqlProcs.spCONTACTS_Update
															( ref gCONTACT_ID
															, gASSIGNED_USER_ID
															, String.Empty
															, sFIRST_NAME
															, sLAST_NAME
															, Guid.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, Guid.Empty
															, DateTime.MinValue
															, false
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, guest.Email
															, String.Empty
															, String.Empty
															, String.Empty
															, false
															, !guest.Email.Contains("@")
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, String.Empty
															, Guid.Empty
															, false
															, gTEAM_ID
															, String.Empty
															// 09/27/2013 Paul.  SMS messages need to be opt-in. 
															, String.Empty  // SMS_OPT_IN
															// 10/22/2013 Paul.  Provide a way to map Tweets to a parent. 
															, String.Empty  // TWITTER_SCREEN_NAME
															// 08/07/2015 Paul.  Add picture. 
															, String.Empty  // PICTURE
															// 08/07/2015 Paul.  Add Leads/Contacts relationship. 
															, Guid.Empty    // LEAD_ID
															// 09/27/2015 Paul.  Separate SYNC_CONTACT and EXCHANGE_FOLDER. 
															, false         // EXCHANGE_FOLDER
															// 05/12/2016 Paul.  Add Tags module. 
															, String.Empty  // TAG_SET_NAME
															// 06/20/2017 Paul.  Add number fields to Contacts, Leads, Prospects, Opportunities and Campaigns. 
															, String.Empty  // CONTACT_NUMBER
															// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
															, String.Empty  // ASSIGNED_SET_LIST
															// 06/23/2018 Paul.  Add DP_BUSINESS_PURPOSE and DP_CONSENT_LAST_UPDATED for data privacy. 
															, String.Empty       // DP_BUSINESS_PURPOSE
															, DateTime.MinValue  // DP_CONSENT_LAST_UPDATED
															, trn
															);
														SqlProcs.spAPPOINTMENTS_RELATED_Update(gID, sEmail, bREQUIRED, sACCEPT_STATUS, guest.Name, ref gCONTACT_ID, trn);
													}
												}
											}
											foreach ( string sEmail in dictContacts.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
												{
													Guid gAPPOINTMENT_CONTACT_ID = dictContacts[sEmail];
													SqlProcs.spAPPOINTMENTS_CONTACTS_Delete(gID, gAPPOINTMENT_CONTACT_ID, trn);
												}
											}
											// 04/02/2012 Paul.  Add Calls/Leads relationship. 
											foreach ( string sEmail in dictLeads.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
												{
													Guid gAPPOINTMENT_LEAD_ID = dictLeads[sEmail];
													SqlProcs.spAPPOINTMENTS_LEADS_Delete(gID, gAPPOINTMENT_LEAD_ID, trn);
												}
											}
											foreach ( DataRow rowUser in dtUSERS.Rows )
											{
												Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"        ]);
												string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EMAIL1"         ]).ToLower();
												string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["ICLOUD_USERNAME"]).ToLower();
												// 01/14/2012 Paul.  Make sure not to remove this user. 
												if ( gAPPOINTMENT_USER_ID != gUSER_ID && !lstParticipants.Contains(sAPPOINTMENT_EMAIL1) && !lstParticipants.Contains(sAPPOINTMENT_USERNAME) )
												{
													SqlProcs.spAPPOINTMENTS_USERS_Delete(gID, gAPPOINTMENT_USER_ID, trn);
												}
											}
										}
									}
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
									SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "iCloud", appointment.RawContent, trn);
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									// 02/20/2013 Paul.  Log inner error. 
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
									throw;
								}
							}
						}
						else if ( (sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new") && !Sql.IsEmptyGuid(gID) )
						{
							// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to iCloud. 
							if ( dt.Rows.Count > 0 )
							{
								row = dt.Rows[0];
								if ( SplendidInit.bEnableACLFieldSecurity )
								{
									bool bApplyACL = false;
									foreach ( DataColumn col in dt.Columns )
									{
										Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Appointments", col.ColumnName, gASSIGNED_USER_ID);
										if ( !acl.IsReadable() )
										{
											row[col.ColumnName] = DBNull.Value;
											bApplyACL = true;
										}
									}
									if ( bApplyACL )
										dt.AcceptChanges();
								}
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Syncing appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sICLOUD_USERNAME);
									// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
									// 07/18/2010 Paul.  Move iCloud Sync functions to a separate class. 
									DataTable dtAppointmentEmails = AppointmentEmails(Application, con, Sql.ToGuid(row["ID"]), gUSER_ID);
									// 03/23/2013 Paul.  Add the ability to disable participants. 
									bool bChanged = this.SetiCloudAppointment(appointment, row, dtAppointmentEmails, sICLOUD_USERNAME, sbChanges, bDISABLE_PARTICIPANTS);
									if ( bChanged )
									{
										service.Update(Context, appointment);
									}
									// 03/25/2010 Paul.  Update the modified date after the save. 
									// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
									dtREMOTE_DATE_MODIFIED     = appointment.Updated;
									dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 03/26/2010 Paul.  Make sure to set the Sync flag. 
											// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
											// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
											// 01/25/2012 Paul.  Add RAW_CONTENT to better detect changes. 
											SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "iCloud", appointment.RawContent, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								catch(Exception ex)
								{
									// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
									string sError = "Error saving " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
									sError += sbChanges.ToString();
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
						else if ( sSYNC_ACTION == "local deleted" )
						{
							try
							{
								service.Delete(Context, appointment.UID);
							}
							catch(Exception ex)
							{
								// 03/24/2013 Paul.  row object might be null, so don't use it. 
								string sError = "Error deleting " + Sql.ToString(appointment.Title) + " " + Sql.ToString(appointment.Times[0].StartTime) + " from " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							try
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Deleting " + Sql.ToString(appointment.Title) + " " + Sql.ToString(appointment.Times[0].StartTime) + " from " + sICLOUD_USERNAME);
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
										SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sREMOTE_KEY, "iCloud", trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										throw;
									}
								}
							}
							catch(Exception ex)
							{
								string sError = "Error deleting " + Sql.ToString(appointment.Title) + " " + Sql.ToString(appointment.Times[0].StartTime) + " from " + sICLOUD_USERNAME + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
						}
					}
				}
			}
		}
		#endregion
	}
}
