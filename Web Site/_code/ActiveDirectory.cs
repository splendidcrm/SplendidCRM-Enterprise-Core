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
using System.Net;
using System.Xml;
using System.Web;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;

using Microsoft.Exchange.WebServices.Data;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;

using System.ServiceModel;
/*
using System.IdentityModel.Tokens;
using System.IdentityModel.Selectors;
using System.IdentityModel.Services;
using System.IdentityModel.Protocols.WSTrust;
using System.ServiceModel.Channels;
using System.ServiceModel.Security;
using System.ServiceModel.Security.Tokens;
// Install-Package System.IdentityModel.Tokens.Jwt -Version 4.0.3.308261200
using System.IdentityModel.Metadata;
*/
using System.Security.Cryptography.X509Certificates;
using System.Linq;
// Install-Package System.IdentityModel.Tokens.ValidatingIssuerNameRegistry
// ValidatingIssuerNameRegistry
// http://www.cloudidentity.com/blog/2013/02/08/multitenant-sts-and-token-validation-4/

using Microsoft.AspNetCore.Http;

using Spring.Social.Office365;

namespace SplendidCRM
{
	[DataContract]
	public class Office365AccessToken
	{
		[DataMember] public string token_type    { get; set; }
		[DataMember] public string scope         { get; set; }
		[DataMember] public string expires_in    { get; set; }
		[DataMember] public string expires_on    { get; set; }
		[DataMember] public string access_token  { get; set; }
		[DataMember] public string refresh_token { get; set; }

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

	// https://graph.microsoft.io/en-us/docs
	[DataContract]
	public class MicrosoftGraphProfile
	{
		[DataMember] public string id                { get; set; }
		[DataMember] public string userPrincipalName { get; set; }
		[DataMember] public string displayName       { get; set; }
		[DataMember] public string givenName         { get; set; }
		[DataMember] public string surname           { get; set; }
		[DataMember] public string jobTitle          { get; set; }
		[DataMember] public string mail              { get; set; }
		[DataMember] public string officeLocation    { get; set; }
		[DataMember] public string preferredLanguage { get; set; }
		[DataMember] public string mobilePhone       { get; set; }
		[DataMember] public string[] businessPhones  { get; set; }

		public string Name
		{
			get { return displayName; }
			set { displayName = value; }
		}
		public string FirstName
		{
			get { return givenName; }
			set { givenName = value; }
		}
		public string LastName
		{
			get { return surname; }
			set { surname = value; }
		}
		public string UserName
		{
			get { return userPrincipalName; }
			set { userPrincipalName = value; }
		}
		public string EmailAddress
		{
			get { return mail; }
			set { mail = value; }
		}
	}

	public class ActiveDirectory
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpContext          Context            ;
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidInit         SplendidInit       ;
		private Office365Sync        Office365Sync      ;

		public ActiveDirectory(IHttpContextAccessor httpContextAccessor, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidInit SplendidInit, Office365Sync Office365Sync)
		{
			this.Context             = httpContextAccessor.HttpContext;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidInit        = SplendidInit       ;
			this.Office365Sync       = Office365Sync      ;
		}

/*
		// https://yorkporc.wordpress.com/2014/04/11/wcf-server-for-jwt-handlingvalidation/
		private static List<X509SecurityToken> ReadSigningCertsFromMetadata(System.IdentityModel.Metadata.EntityDescriptor entityDescriptor)
		{
			List<X509SecurityToken> stsSigningTokens = new List<X509SecurityToken>();
 			System.IdentityModel.Metadata.SecurityTokenServiceDescriptor stsd = entityDescriptor.RoleDescriptors.OfType<System.IdentityModel.Metadata.SecurityTokenServiceDescriptor>().First();
 			if ( stsd != null )
			{
				// read non-null X509Data keyInfo elements meant for Signing
				IEnumerable<X509RawDataKeyIdentifierClause> x509DataClauses = stsd.Keys.Where(key => key.KeyInfo != null && (key.Use == KeyType.Signing || key.Use == KeyType.Unspecified)).
					Select(key => key.KeyInfo.OfType<X509RawDataKeyIdentifierClause>().First());
 
				stsSigningTokens.AddRange(x509DataClauses.Select(token => new X509SecurityToken(new X509Certificate2(token.GetX509RawData()))));
			}
			else
			{
				throw new InvalidOperationException("There is no RoleDescriptor of type SecurityTokenServiceType in the metadata");
			}
			return stsSigningTokens;
		}

		public string AzureLogin()
		{
			HttpRequest Request = Context.Request;
			string sAadTenantDomain  = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.AadTenantDomain"]);
			string sRealm            = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.Realm"          ]);
			string sAuthority        = "https://login.microsoftonline.com/" + sAadTenantDomain + "/wsfed";
			//string sRedirectURL = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value + "/Users/Login.aspx";
			string sRedirectURL = "https://" + Request.Host.Host + Request.Path.Value + "/Users/Login.aspx";
			// 07/08/2017 Paul.  We cannot support the Redirect as it is unlikely that the full redirect URL will be added to the App registration. 
			//if ( !Sql.IsEmptyString(Request["Redirect"]) )
			//	sRedirectURL += "?Redirect=" + HttpUtility.UrlEncode(Request["Redirect"]);
			// https://login.microsoftonline.com/salessplendidcrm.onmicrosoft.com/wsfed?wa=wsignin1.0&wtrealm=https%3a%2f%2fsalessplendidcrm.onmicrosoft.com%2fSplendidCRM6_Azure&wreply=https%3a%2f%2flocalhost%2fSplendidCRM6_Azure%2fUsers%2fLogin.aspx
			SignInRequestMessage signinRequest = new System.IdentityModel.Services.SignInRequestMessage(new Uri(sAuthority), sRealm, sRedirectURL);
			string sRequestURL = signinRequest.RequestUrl;
			Debug.WriteLine(sRequestURL);
			return sRequestURL;
		}

		// 12/25/2018 Paul.  Logout should perform Azure or ADFS logout. 
		public string AzureLogout()
		{
			HttpRequest Request = Context.Request;
			string sAadTenantDomain  = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.AadTenantDomain"]);
			string sAuthority        = "https://login.microsoftonline.com/" + sAadTenantDomain + "/oauth2/logout";
			string sRedirectURL = "https://" + Request.Host.Host + Request.Path.Value + "/Users/Login.aspx?wa=wsignoutcleanup1.0";
			string sRequestURL = sAuthority + "?post_logout_redirect_uri=" + HttpUtility.UrlEncode(sRedirectURL);
			Debug.WriteLine(sRequestURL);
			return sRequestURL;
		}

		public Guid AzureValidate(HttpApplicationState Application, string sToken, ref string sError)
		{
			string sAadTenantDomain    = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.AadTenantDomain"   ]);
			string sRealm              = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.Realm"             ]);
			string sFederationMetadata = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.FederationMetadata"]);
			string sAuthority          = "https://login.microsoftonline.com/" + sAadTenantDomain + "/wsfed";
			// 12/05/2018 Paul.  Allow authorization by USER_NAME instead of by EMAIL1. 
			bool   bAuthByUserName     = Sql.ToBoolean(Application["CONFIG.Azure.SingleSignOn.AuthByUserName"]);
			Guid   gUSER_ID            = Guid.Empty;
			try
			{
				SignInResponseMessage signinResponse = new System.IdentityModel.Services.SignInResponseMessage(new Uri(sAuthority), sToken);
				// 01/08/2017 Paul.  How to grab serialized in http request claims in a code using WIF?
				// http://oocms.org/question/2822274/how-to-grab-serialized-in-http-request-claims-in-a-code-using-wif
				//var message = SignInResponseMessage.CreateFromFormPost(Request) as SignInResponseMessage;

				RequestSecurityTokenResponse rstr = new WSFederationSerializer().CreateResponse(signinResponse, new WSTrustSerializationContext(SecurityTokenHandlerCollectionManager.CreateDefaultSecurityTokenHandlerCollectionManager()));

				// 01/08/2017 Paul.  Consider using System.IdentityModel.Tokens.ValidatingIssuerNameRegistry. 
				// ValidatingIssuerNameRegistry issuers = new System.IdentityModel.Tokens.ValidatingIssuerNameRegistry();
				// https://www.nuget.org/packages/System.IdentityModel.Tokens.ValidatingIssuerNameRegistry/
				
				IssuingAuthority issuingAuthority = Application["Azure.IssuingAuthority"] as IssuingAuthority;
				if ( issuingAuthority == null )
				{
					issuingAuthority = ValidatingIssuerNameRegistry.GetIssuingAuthority(sFederationMetadata);
					Application["Azure.IssuingAuthority"] = issuingAuthority;
				}
				ValidatingIssuerNameRegistry issuers = new ValidatingIssuerNameRegistry(issuingAuthority);

				Saml2SecurityTokenHandler tokenHandler = new System.IdentityModel.Tokens.Saml2SecurityTokenHandler {CertificateValidator = X509CertificateValidator.None};
				SecurityTokenHandlerConfiguration config = new SecurityTokenHandlerConfiguration { CertificateValidator = X509CertificateValidator.None, IssuerNameRegistry = issuers };

				config.AudienceRestriction.AllowedAudienceUris.Add(new Uri(sRealm));
				tokenHandler.Configuration = config;
				using ( XmlReader reader = XmlReader.Create(new StringReader(rstr.RequestedSecurityToken.SecurityTokenXml.OuterXml)) )
				{
					SecurityToken samlSecurityToken = tokenHandler.ReadToken(reader);
					// 01/08/2017 Paul.  ID4175 will be thrown if the thumbprint is incorrect. It must come from ADFS. 
					// ID4175: The issuer of the security token was not recognized by the IssuerNameRegistry. To accept security tokens from this issuer, configure the IssuerNameRegistry to return a valid name for this issuer.
					ReadOnlyCollection<System.Security.Claims.ClaimsIdentity> claimsIdentity = tokenHandler.ValidateToken(samlSecurityToken);
					if ( claimsIdentity.Count > 0 )
					{
						string sUSER_NAME  = String.Empty;
						string sLAST_NAME  = String.Empty;
						string sFIRST_NAME = String.Empty;
						string sEMAIL1     = String.Empty;
						//bool   bIsAdmin   = false;
						List<string> roles = new List<string>();
						System.Security.Claims.ClaimsIdentity identity = claimsIdentity[0];
						foreach ( System.Security.Claims.Claim claim in identity.Claims )
						{
							Debug.WriteLine(claim.Type + " = " + claim.Value);
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname = Rony
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname = Paul
							// http://schemas.microsoft.com/identity/claims/displayname = Paul Rony
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress = sales@splendidcrm.com
							// http://schemas.microsoft.com/identity/claims/identityprovider = live.com

							// 01/15/2017 Paul.  Alternate Azure login. 
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name = paul@splendidcrm.onmicrosoft.com
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname = Rony
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname = Paul
							// http://schemas.microsoft.com/identity/claims/displayname = Paul Rony
							// http://schemas.microsoft.com/identity/claims/identityprovider = https://sts.windows.net/2378bf60-1010-4140-9b4a-2a7312df5779/
							switch ( claim.Type )
							{
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"          :  sUSER_NAME  = claim.Value;  break;
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"       :  sLAST_NAME  = claim.Value;  break;
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"     :  sFIRST_NAME = claim.Value;  break;
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"  :  sEMAIL1     = claim.Value;  break;
							}
						}
						if ( Sql.IsEmptyString(sEMAIL1) && sUSER_NAME.Contains("@") )
							sEMAIL1 = sUSER_NAME;
						//if ( roles.Contains("Domain Admins") || roles.Contains("Administrators") || roles.Contains("SplendidCRM Administrators") )
						//	bIsAdmin = true;
						if ( !Sql.IsEmptyString(sEMAIL1) )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								string sSQL;
								// 12/05/2018 Paul.  Allow authorization by USER_NAME instead of by EMAIL1. 
								if ( bAuthByUserName )
								{
									sSQL = "select ID                    " + ControlChars.CrLf
									     + "  from vwUSERS_Login         " + ControlChars.CrLf
									     + " where USER_NAME = @EMAIL1   " + ControlChars.CrLf;
								}
								else
								{
									sSQL = "select ID                    " + ControlChars.CrLf
									     + "  from vwUSERS_Login         " + ControlChars.CrLf
									     + " where EMAIL1 = @EMAIL1      " + ControlChars.CrLf;
								}
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									cmd.CommandTimeout = 0;
									Sql.AddParameter(cmd, "@EMAIL1", sEMAIL1);
									gUSER_ID = Sql.ToGuid(cmd.ExecuteScalar());
									if ( Sql.IsEmptyGuid(gUSER_ID) )
									{
										SplendidInit.LoginTracking(sUSER_NAME, false);
										sError = "SECURITY: failed attempted login for " + sEMAIL1 + " using Azure AD. ";
										SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
									}
								}
							}
						}
						else
						{
							sError = "SECURITY: Failed attempted login using Azure AD. Missing Email ID from Claim token.";
							SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
						}
					}
					else
					{
						sError = "SECURITY: failed attempted login using Azure AD. No SecurityToken identities found.";
						SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
					}
				}
			}
			catch(Exception ex)
			{
				sError = "SECURITY: failed attempted login using Azure AD. " + ex.Message;
				SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
			}
			return gUSER_ID;
		}
*/
		// 05/02/2017 Paul.  Need a separate flag for the mobile client. 
		public Guid AzureValidateJwt(string sToken, bool bMobileClient, ref string sError)
		{
			Guid gUSER_ID       = Guid.Empty;
			Guid gUSER_LOGIN_ID = Guid.Empty;
			try
			{
				//string sAadTenantDomain     = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.AadTenantDomain"   ]);
				string sAadClientId         = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.AadClientId"       ]);
				//string sRealm               = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.Realm"             ]);
				string sFederationMetadata  = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.FederationMetadata"]);
				//string stsDiscoveryEndpoint = "https://login.microsoftonline.com/" + sAadTenantDomain + "/.well-known/openid-configuration";
				// 05/03/2017 Paul.  Instead of validating against the resource, validate against the clientId as it is easier. 
				//string sResourceUrl = Request.Url.ToString();
				//sResourceUrl = sResourceUrl.Substring(0, sResourceUrl.Length - "Rest.svc/Login".Length);
				// 05/02/2017 Paul.  Need a separate flag for the mobile client. 
				// 12/05/2018 Paul.  Allow authorization by USER_NAME instead of by EMAIL1. 
				bool   bAuthByUserName     = Sql.ToBoolean(Application["CONFIG.Azure.SingleSignOn.AuthByUserName"]);
				if ( bMobileClient )
				{
					// 05/03/2017 Paul.  As we are using the MobileClientId to validate the token, we must also use it as the resourceUrl when acquiring the token. 
					sAadClientId   = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.MobileClientId"  ]);
				}

				// 02/14/2022 Paul.  Use the new metadata serializer. 
				// https://www.nuget.org/packages/Microsoft.IdentityModel.Protocols.WsFederation/
				Microsoft.IdentityModel.Protocols.WsFederation.WsFederationMetadataSerializer serializer = new Microsoft.IdentityModel.Protocols.WsFederation.WsFederationMetadataSerializer();
				Microsoft.IdentityModel.Protocols.WsFederation.WsFederationConfiguration metadata = Application["Azure.FederationMetadata"] as Microsoft.IdentityModel.Protocols.WsFederation.WsFederationConfiguration;
				if ( metadata == null )
				{
					metadata = serializer.ReadMetadata(XmlReader.Create(sFederationMetadata));
					Application["Azure.FederationMetadata"] = metadata;
				}
				
				// 02/14/2022 Paul.  Update System.IdentityModel.Tokens.Jwt to support Apple Signin. 
				// https://www.nuget.org/packages/System.IdentityModel.Tokens.Jwt/
				System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler tokenHandler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
				Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
				{
					ValidIssuer         = metadata.Issuer,
					IssuerSigningKeys   = metadata.SigningKeys,
					ValidAudience       = sAadClientId
				};

				Microsoft.IdentityModel.Tokens.SecurityToken validatedToken = null;
				// Throws an Exception as the token is invalid (expired, invalid-formatted, etc.)
				System.Security.Claims.ClaimsPrincipal identity = tokenHandler.ValidateToken(sToken, validationParameters, out validatedToken);
				if ( identity != null )
				{
					string sUSER_NAME  = String.Empty;
					string sLAST_NAME  = String.Empty;
					string sFIRST_NAME = String.Empty;
					string sEMAIL1     = String.Empty;
					foreach ( System.Security.Claims.Claim claim in identity.Claims )
					{
						Debug.WriteLine(claim.Type + " = " + claim.Value);
						// http://schemas.microsoft.com/claims/authnmethodsreferences = pwd
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress = paul@splendidcrm.com
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname = Rony
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname = Paul
						// http://schemas.microsoft.com/identity/claims/identityprovider = live.com
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name = live.com#paul@splendidcrm.com
						// iat = 1484136100
						// nbf = 1484136100
						// exp = 1484140000
						// name = Paul Rony
						// platf = 3
						// ver = 1.0

						// 01/15/2017 Paul.  Alternate login. 
						// http://schemas.microsoft.com/claims/authnmethodsreferences = pwd
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname = Rony
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname = Paul
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name = paul@splendidcrm.onmicrosoft.com
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn = paul@splendidcrm.onmicrosoft.com
						// iat = 1484512667
						// nbf = 1484512667
						// exp = 1484516567
						// name = Paul Rony
						// platf = 3
						// ver = 1.0
						switch ( claim.Type )
						{
							// 12/25/2018 Paul.  Remove live.com# prefix. 
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"          :  sUSER_NAME  = claim.Value.Replace("live.com#", "");  break;
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"       :  sLAST_NAME  = claim.Value;  break;
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"     :  sFIRST_NAME = claim.Value;  break;
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"  :  sEMAIL1     = claim.Value;  break;
						}
					}
					if ( Sql.IsEmptyString(sEMAIL1) && sUSER_NAME.Contains("@") )
						sEMAIL1 = sUSER_NAME;
					if ( !Sql.IsEmptyString(sEMAIL1) )
					{
						SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							// 12/05/2018 Paul.  Allow authorization by USER_NAME instead of by EMAIL1. 
							if ( bAuthByUserName )
							{
								sSQL = "select ID                    " + ControlChars.CrLf
								     + "  from vwUSERS_Login         " + ControlChars.CrLf
								     + " where USER_NAME = @EMAIL1   " + ControlChars.CrLf;
							}
							else
							{
								sSQL = "select ID                    " + ControlChars.CrLf
								     + "  from vwUSERS_Login         " + ControlChars.CrLf
								     + " where EMAIL1 = @EMAIL1      " + ControlChars.CrLf;
							}
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@EMAIL1", sEMAIL1.ToLower());
								gUSER_ID = Sql.ToGuid(cmd.ExecuteScalar());
								if ( Sql.IsEmptyGuid(gUSER_ID) )
								{
									// 01/13/2017 Paul.  Cannot log an unknown user. 
									//SqlProcs.spUSERS_LOGINS_InsertOnly(ref gUSER_LOGIN_ID, Guid.Empty, sEMAIL1, "Azure AD", "Failed", Session.SessionID, Request.UserHostName, Request.Host.Host, Request.Path, Request.AppRelativeCurrentExecutionFilePath, Request.UserAgent);
									// 01/13/2017 Paul.  Cannot lock-out an unknown user. 
									//SplendidInit.LoginTracking(sEMAIL1, false);
									sError = "SECURITY: failed attempted login for " + sEMAIL1 + " using Azure AD/REST API";
									SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
								}
							}
						}
					}
					else
					{
						sError = "SECURITY: Failed attempted login using ADFS. Missing Email ID from Claim token.";
						SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
					}
				}
				else
				{
					sError = "SECURITY: failed attempted login using Azure AD. No SecurityToken identities found.";
					SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
				}
			}
			catch(Exception ex)
			{
				string sUSER_NAME = "(Unknown Azure AD)";
				// 01/13/2017 Paul.  Cannot log an unknown user. 
				//SqlProcs.spUSERS_LOGINS_InsertOnly(ref gUSER_LOGIN_ID, Guid.Empty, sUSER_NAME, "Azure AD", "Failed", Session.SessionID, Request.UserHostName, Request.Host.Host, Request.Path, Request.AppRelativeCurrentExecutionFilePath, Request.UserAgent);
				// 01/13/2017 Paul.  Cannot lock-out an unknown user. 
				//SplendidInit.LoginTracking(sUSER_NAME, false);
				sError = "SECURITY: failed attempted login for " + sUSER_NAME + " using Azure AD/REST API. " + ex.Message;
				SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
			}
			return gUSER_ID;
		}
/*
		public string FederationServicesLogin()
		{
			HttpRequest Request = Context.Request;
			string sRealm       = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Realm"    ]);
			string sAuthority   = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Authority"]);
			if ( !sAuthority.EndsWith("/") )
				sAuthority += "/";
			sAuthority += "adfs/ls";
			//string sRedirectURL = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value + "/Users/Login.aspx";
			string sRedirectURL = "https://" + Request.Host.Host + Request.Path.Value + "/Users/Login.aspx";
			// 07/08/2017 Paul.  We cannot support the Redirect as it is unlikely that the full redirect URL will be added to the App registration. 
			//if ( !Sql.IsEmptyString(Request["Redirect"]) )
			//	sRedirectURL += "?Redirect=" + HttpUtility.UrlEncode(Request["Redirect"]);
			// https://adfs.splendidcrm.com/adfs/ls/?wa=wsignin1.0&wtrealm=https%3a%2f%2flocalhost%2fSplendidCRM6_Azure%2f&wreply=http%3a%2f%2flocalhost%2fSplendidCRM6_Azure%2fUsers%2fLogin.aspx
			SignInRequestMessage signinRequest = new System.IdentityModel.Services.SignInRequestMessage(new Uri(sAuthority), sRealm, sRedirectURL);
			string sRequestURL = signinRequest.RequestUrl;
			Debug.WriteLine(sRequestURL);
			return sRequestURL;
		}

		// 12/25/2018 Paul.  Logout should perform Azure or ADFS logout. 
		public string FederationServicesLogout()
		{
			HttpRequest Request = Context.Request;
			string sAuthority   = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Authority"]);
			if ( !sAuthority.EndsWith("/") )
				sAuthority += "/";
			sAuthority += "adfs/ls";
			string sRedirectURL = "https://" + Request.Host.Host + Request.Path.Value + "/Users/Login.aspx?wa=wsignoutcleanup1.0";
			string sRequestURL = sAuthority + "?wa=wsignout1.0&wreply=" + HttpUtility.UrlEncode(sRedirectURL);
			Debug.WriteLine(sRequestURL);
			return sRequestURL;
		}

		public Guid FederationServicesValidate(string sToken, ref string sError)
		{
			string sRealm              = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Realm"     ]);
			string sAuthority          = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Authority" ]);
			string sThumbprint         = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Thumbprint"]);
			// 12/20/2018 Paul.  Allow authorization by EMAIL1 instead of by USER_NAME. 
			bool   bAuthByEmail        = Sql.ToBoolean(Application["CONFIG.Azure.SingleSignOn.AuthByEmail"]);
			Guid   gUSER_ID            = Guid.Empty;
			if ( !sAuthority.EndsWith("/") )
				sAuthority += "/";
			try
			{
				SignInResponseMessage signinResponse = new System.IdentityModel.Services.SignInResponseMessage(new Uri(sAuthority), sToken);
				string sIssuerURL = sAuthority.Replace("https:", "http:") + "adfs/services/trust";
				// 01/08/2017 Paul.  How to grab serialized in http request claims in a code using WIF?
				// http://oocms.org/question/2822274/how-to-grab-serialized-in-http-request-claims-in-a-code-using-wif
				//var message = SignInResponseMessage.CreateFromFormPost(Request) as SignInResponseMessage;

				RequestSecurityTokenResponse rstr = new WSFederationSerializer().CreateResponse(signinResponse, new WSTrustSerializationContext(SecurityTokenHandlerCollectionManager.CreateDefaultSecurityTokenHandlerCollectionManager()));
				XmlNode xIssuer = rstr.RequestedSecurityToken.SecurityTokenXml.Attributes.GetNamedItem("Issuer");
				if ( xIssuer != null )
					sIssuerURL = xIssuer.InnerText;

				// 01/08/2017 Paul.  Consider using System.IdentityModel.Tokens.ValidatingIssuerNameRegistry. 
				// ValidatingIssuerNameRegistry issuers = new System.IdentityModel.Tokens.ValidatingIssuerNameRegistry();
				// https://www.nuget.org/packages/System.IdentityModel.Tokens.ValidatingIssuerNameRegistry/
				
				ConfigurationBasedIssuerNameRegistry issuers = new ConfigurationBasedIssuerNameRegistry();
				// 01/08/2017 Paul.  The thumbprint comes from ADFS.  Open AD FS 2.0 Management > Service > Certificates then right-click on the Primary Token-signing certificate and choose View certificate. 
				// 02/13/2019 Paul.  Another way to get the thumbprint is to use powershell Get-ADFSCertificate.  Use Token-Signing value. 
				// http://docs.sdl.com/LiveContent/content/en-US/SDL%20LiveContent%20full%20documentation-v1/GUID-0652296B-F1FF-4088-8258-3EAAE0CD2EEA
				issuers.AddTrustedIssuer(sThumbprint, sIssuerURL);

				SamlSecurityTokenHandler tokenHandler = new System.IdentityModel.Tokens.SamlSecurityTokenHandler {CertificateValidator = X509CertificateValidator.None};
				SecurityTokenHandlerConfiguration config = new SecurityTokenHandlerConfiguration { CertificateValidator = X509CertificateValidator.None, IssuerNameRegistry = issuers };

				config.AudienceRestriction.AllowedAudienceUris.Add(new Uri(sRealm));
				tokenHandler.Configuration = config;
				using ( XmlReader reader = XmlReader.Create(new StringReader(rstr.RequestedSecurityToken.SecurityTokenXml.OuterXml)) )
				{
					SecurityToken samlSecurityToken = tokenHandler.ReadToken(reader);
					// 01/08/2017 Paul.  ID4175 will be thrown if the thumbprint is incorrect. It must come from ADFS. 
					// ID4175: The issuer of the security token was not recognized by the IssuerNameRegistry. To accept security tokens from this issuer, configure the IssuerNameRegistry to return a valid name for this issuer.
					ReadOnlyCollection<System.Security.Claims.ClaimsIdentity> claimsIdentity = tokenHandler.ValidateToken(samlSecurityToken);
					if ( claimsIdentity.Count > 0 )
					{
						string sUSER_NAME  = String.Empty;
						string sLAST_NAME  = String.Empty;
						string sFIRST_NAME = String.Empty;
						string sEMAIL1     = String.Empty;
						//bool   bIsAdmin   = false;
						List<string> roles = new List<string>();
						System.Security.Claims.ClaimsIdentity identity = claimsIdentity[0];
						foreach ( System.Security.Claims.Claim claim in identity.Claims )
						{
							Debug.WriteLine(claim.Type + " = " + claim.Value);
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier = paulrony
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname = Rony
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress = Paul@splendidcrm.com
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname = Paul
							// http://schemas.microsoft.com/ws/2008/06/identity/claims/role = Domain Users
							// http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationmethod = http://schemas.microsoft.com/ws/2008/06/identity/authenticationmethod/windows
							// http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationinstant = 2017-01-08T13:19:38.747Z
							switch ( claim.Type )
							{
								// 01/08/2019 Paul.  Our instructions say to map SAM-Account-Name to Name ID, not name. 
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier":  sUSER_NAME  = claim.Value;  break;
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"       :  sLAST_NAME  = claim.Value;  break;
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"     :  sFIRST_NAME = claim.Value;  break;
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"  :  sEMAIL1     = claim.Value;  break;
								case "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"        :  roles.Add(claim.Value);  break;
								case "http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationmethod" :  break;
								case "http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationinstant":  break;
							}
						}
						if ( !Sql.IsEmptyString(sUSER_NAME) )
						{
							//if ( roles.Contains("Domain Admins") || roles.Contains("Administrators") || roles.Contains("SplendidCRM Administrators") )
							//	bIsAdmin = true;
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( IDbConnection con = dbf.CreateConnection() )
							{
								con.Open();
								string sSQL;
								sSQL = "select ID                    " + ControlChars.CrLf
								     + "  from vwUSERS_Login         " + ControlChars.CrLf
								     + " where USER_NAME = @USER_NAME" + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									cmd.CommandTimeout = 0;
									// 12/20/2018 Paul.  Allow authorization by EMAIL1 instead of by USER_NAME. 
									if ( bAuthByEmail )
										Sql.AddParameter(cmd, "@USER_NAME", sEMAIL1);
									else
										Sql.AddParameter(cmd, "@USER_NAME", sUSER_NAME);
									gUSER_ID = Sql.ToGuid(cmd.ExecuteScalar());
									if ( Sql.IsEmptyGuid(gUSER_ID) )
									{
										SplendidInit.LoginTracking(sUSER_NAME, false);
										sError = "SECURITY: Failed attempted login for " + sUSER_NAME + " using ADFS.";
										SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
									}
								}
							}
						}
						else
						{
							sError = "SECURITY: Failed attempted login using ADFS. Missing Username/Name ID from Claim token.";
							SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
						}
					}
					else
					{
						sError = "SECURITY: Failed attempted login using ADFS. No SecurityToken identities found.";
						SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
					}
				}
			}
			catch(Exception ex)
			{
				sError = "SECURITY: Failed attempted login using ADFS. " + ex.Message;
				SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
			}
			return gUSER_ID;
		}

		// 01/13/2017 Paul.  This method use an undesireable approach to manually passing the username and password.  It is required for ADFS 3.0 on Windows Server 2012 R2. 
		public Guid FederationServicesValidate(string sUSER_NAME, string sPASSWORD, ref string sError)
		{
			HttpRequest Request = Context.Request;
			Guid gUSER_ID       = Guid.Empty;
			Guid gUSER_LOGIN_ID = Guid.Empty;
			// WCF and Identity in .NET 4.5: External Authentication with WS-Trust
			// https://leastprivilege.com/2012/11/16/wcf-and-identity-in-net-4-5-external-authentication-with-ws-trust/
			// How to validate ADFS SAML token
			// http://stackoverflow.com/questions/18701681/how-to-validate-adfs-saml-token

			string sRealm      = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Realm"     ]);
			string sAuthority  = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Authority" ]);
			string sDoamin     = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Domain"    ]);
			string sThumbprint = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Thumbprint"]);
			// 12/20/2018 Paul.  Allow authorization by EMAIL1 instead of by USER_NAME. 
			bool   bAuthByEmail = Sql.ToBoolean(Application["CONFIG.Azure.SingleSignOn.AuthByEmail"]);
			if ( !sAuthority.EndsWith("/") )
				sAuthority += "/";
			string sIssuerURL  = sAuthority.Replace("https:", "http:") + "adfs/services/trust";
			using ( WSTrustChannelFactory factory = new WSTrustChannelFactory(new Microsoft.IdentityModel.Protocols.WSTrust.Bindings.UserNameWSTrustBinding(System.ServiceModel.SecurityMode.TransportWithMessageCredential), new EndpointAddress(sAuthority + "adfs/services/trust/2005/usernamemixed")) )
			{
				try
				{
					string[] arrUserName = sUSER_NAME.Split('\\');
					string sUSER_DOMAIN = String.Empty;
					if ( arrUserName.Length > 1 )
					{
						sUSER_DOMAIN = arrUserName[0];
						sUSER_NAME   = arrUserName[1];
					}
					else
					{
						sUSER_DOMAIN = sDoamin;
						sUSER_NAME   = arrUserName[0];
					}
					factory.TrustVersion = TrustVersion.WSTrustFeb2005;
					factory.Credentials.UserName.UserName  = sUSER_DOMAIN + "\\" + sUSER_NAME;
					factory.Credentials.UserName.Password  = sPASSWORD ;
					var rst = new RequestSecurityToken
					{
						RequestType = System.IdentityModel.Protocols.WSTrust.RequestTypes.Issue,
						AppliesTo = new EndpointReference(sRealm),
						KeyType = KeyTypes.Bearer
					};
					IWSTrustChannelContract channel = factory.CreateChannel();
					GenericXmlSecurityToken genericToken = channel.Issue(rst) as GenericXmlSecurityToken;
					XmlNode xIssuer = genericToken.TokenXml.Attributes.GetNamedItem("Issuer");
					if ( xIssuer != null )
						sIssuerURL = xIssuer.InnerText;
					
					ConfigurationBasedIssuerNameRegistry issuers = new ConfigurationBasedIssuerNameRegistry();
					// 01/08/2017 Paul.  The thumbprint comes from ADFS.  Open AD FS 2.0 Management > Service > Certificates then right-click on the Primary Token-signing certificate and choose View certificate. 
					// 02/13/2019 Paul.  Another way to get the thumbprint is to use powershell Get-ADFSCertificate.  Use Token-Signing value. 
					// http://docs.sdl.com/LiveContent/content/en-US/SDL%20LiveContent%20full%20documentation-v1/GUID-0652296B-F1FF-4088-8258-3EAAE0CD2EEA
					issuers.AddTrustedIssuer(sThumbprint, sIssuerURL);
					
					SamlSecurityTokenHandler tokenHandler = new System.IdentityModel.Tokens.SamlSecurityTokenHandler {CertificateValidator = X509CertificateValidator.None};
					SecurityTokenHandlerConfiguration config = new SecurityTokenHandlerConfiguration { CertificateValidator = X509CertificateValidator.None, IssuerNameRegistry = issuers };
					config.AudienceRestriction.AllowedAudienceUris.Add(new Uri(sRealm));
					tokenHandler.Configuration = config;
					using ( XmlReader reader = XmlReader.Create(new StringReader(genericToken.TokenXml.OuterXml)) )
					{
						SecurityToken samlSecurityToken = tokenHandler.ReadToken(reader);
						// 01/08/2017 Paul.  ID4175 will be thrown if the thumbprint is incorrect. It must come from ADFS. 
						// ID4175: The issuer of the security token was not recognized by the IssuerNameRegistry. To accept security tokens from this issuer, configure the IssuerNameRegistry to return a valid name for this issuer.
						ReadOnlyCollection<System.Security.Claims.ClaimsIdentity> claimsIdentity = tokenHandler.ValidateToken(samlSecurityToken);
						if ( claimsIdentity.Count > 0 )
						{
							string sLAST_NAME  = String.Empty;
							string sFIRST_NAME = String.Empty;
							string sEMAIL1     = String.Empty;
							//bool   bIsAdmin   = false;
							List<string> roles = new List<string>();
							System.Security.Claims.ClaimsIdentity identity = claimsIdentity[0];
							foreach ( System.Security.Claims.Claim claim in identity.Claims )
							{
								Debug.WriteLine(claim.Type + " = " + claim.Value);
								// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier = paulrony
								// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname = Rony
								// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress = Paul@splendidcrm.com
								// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname = Paul
								// http://schemas.microsoft.com/ws/2008/06/identity/claims/role = Domain Users
								// http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationmethod = http://schemas.microsoft.com/ws/2008/06/identity/authenticationmethod/windows
								// http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationinstant = 2017-01-08T13:19:38.747Z
								switch ( claim.Type )
								{
									// 01/08/2019 Paul.  Our instructions say to map SAM-Account-Name to Name ID, not name. 
									case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier":  sUSER_NAME  = claim.Value;  break;
									case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"       :  sLAST_NAME  = claim.Value;  break;
									case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"     :  sFIRST_NAME = claim.Value;  break;
									case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"  :  sEMAIL1     = claim.Value;  break;
									case "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"        :  roles.Add(claim.Value);  break;
									case "http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationmethod" :  break;
									case "http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationinstant":  break;
								}
							}
							//if ( roles.Contains("Domain Admins") || roles.Contains("Administrators") || roles.Contains("SplendidCRM Administrators") )
							//	bIsAdmin = true;
							if ( !Sql.IsEmptyString(sUSER_NAME) )
							{
								SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
								using ( IDbConnection con = dbf.CreateConnection() )
								{
									con.Open();
									string sSQL;
									sSQL = "select ID                    " + ControlChars.CrLf
									     + "  from vwUSERS_Login         " + ControlChars.CrLf
									     + " where USER_NAME = @USER_NAME" + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										// 12/20/2018 Paul.  Allow authorization by EMAIL1 instead of by USER_NAME. 
										if ( bAuthByEmail )
											Sql.AddParameter(cmd, "@USER_NAME", sEMAIL1);
										else
											Sql.AddParameter(cmd, "@USER_NAME", sUSER_NAME.ToLower());
										gUSER_ID = Sql.ToGuid(cmd.ExecuteScalar());
										if ( Sql.IsEmptyGuid(gUSER_ID) )
										{
											SqlProcs.spUSERS_LOGINS_InsertOnly(ref gUSER_LOGIN_ID, Guid.Empty, sUSER_NAME, "ADFS", "Failed", Session.SessionID, Request.UserHostName, Request.Host.Host, Request.Path, Request.AppRelativeCurrentExecutionFilePath, Request.UserAgent);
											SplendidInit.LoginTracking(sUSER_NAME, false);
											sError = "SECURITY: failed attempted login for " + sUSER_NAME + " using ADFS/REST API";
											SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
										}
									}
								}
							}
							else
							{
								sError = "SECURITY: failed attempted login using ADFS. Missing Username/Name ID from Claim token.";
								SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
							}
						}
						else
						{
							SqlProcs.spUSERS_LOGINS_InsertOnly(ref gUSER_LOGIN_ID, Guid.Empty, sUSER_NAME, "ADFS", "Failed", Session.SessionID, Request.UserHostName, Request.Host.Host, Request.Path, Request.AppRelativeCurrentExecutionFilePath, Request.UserAgent);
							SplendidInit.LoginTracking(sUSER_NAME, false);
							sError = "SECURITY: failed attempted login for " + sUSER_NAME + " using ADFS/REST API. No SecurityToken identities found.";
							SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
						}
					}
				}
				catch(Exception ex)
				{
					SqlProcs.spUSERS_LOGINS_InsertOnly(ref gUSER_LOGIN_ID, Guid.Empty, sUSER_NAME, "ADFS", "Failed", Session.SessionID, Request.UserHostName, Request.Host.Host, Request.Path, Request.AppRelativeCurrentExecutionFilePath, Request.UserAgent);
					SplendidInit.LoginTracking(sUSER_NAME, false);
					sError = "SECURITY: failed attempted login for " + sUSER_NAME + " using ADFS/REST API. " + ex.Message;
					SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
				}
			}
			return gUSER_ID;
		}
*/
		// 05/02/2017 Paul.  Need a separate flag for the mobile client. 
		public Guid FederationServicesValidateJwt(string sToken, bool bMobileClient, ref string sError)
		{
			Guid gUSER_ID       = Guid.Empty;
			Guid gUSER_LOGIN_ID = Guid.Empty;
			try
			{
				//string sRealm      = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Realm"     ]);
				string sAuthority  = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.Authority" ]);
				string sClientId   = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.ClientId"  ]);
				// 05/02/2017 Paul.  Need a separate flag for the mobile client. 
				//if ( bMobileClient )
				//	sClientId   = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.MobileClientId"  ]);
				// 01/08/2018 Paul.  ADFS 3.0 will require us to register both client and mobile as valid audiences. 
				string sMobileClientId = Sql.ToString(Application["CONFIG.ADFS.SingleSignOn.MobileClientId"  ]);
				if ( !sAuthority.EndsWith("/") )
					sAuthority += "/";
				string sFederationMetadata  = sAuthority + "FederationMetadata/2007-06/FederationMetadata.xml";

				// 02/14/2022 Paul.  Use the new metadata serializer. 
				// https://www.nuget.org/packages/Microsoft.IdentityModel.Protocols.WsFederation/
				Microsoft.IdentityModel.Protocols.WsFederation.WsFederationMetadataSerializer serializer = new Microsoft.IdentityModel.Protocols.WsFederation.WsFederationMetadataSerializer();
				Microsoft.IdentityModel.Protocols.WsFederation.WsFederationConfiguration metadata = Application["ADFS.FederationMetadata"] as Microsoft.IdentityModel.Protocols.WsFederation.WsFederationConfiguration;
				if ( metadata == null )
				{
					metadata = serializer.ReadMetadata(XmlReader.Create(sFederationMetadata));
					Application["ADFS.FederationMetadata"] = metadata;
				}

				// 12/25/2018 Paul.  Not sure why server is using http instead of https.  
				// IDX10205: Issuer validation failed. Issuer: 'http://adfs4.splendidcrm.com/adfs/services/trust'. Did not match: validationParameters.ValidIssuer: 'https://adfs4.splendidcrm.com/adfs/services/trust' or validationParameters.ValidIssuers: 'null'.
				// IDX10204: Unable to validate issuer. validationParameters.ValidIssuer is null or whitespace AND validationParameters.ValidIssuers is null.
				StringList arrValidIssuers = new StringList();
				arrValidIssuers.Add(sAuthority + "adfs");
				arrValidIssuers.Add(sAuthority + "adfs/services/trust");
				arrValidIssuers.Add(sAuthority.Replace("https:", "http:") + "adfs/services/trust");
				// IDX10214: Audience validation failed. Audiences: 'urn:microsoft:userinfo'. Did not match:  validationParameters.ValidAudience: 'microsoft:identityserver:86a54b29-a28e-4bcb-9477-07e25a41ee24' or validationParameters.ValidAudiences: 'null'
				StringList arrAudiences = new StringList();
				arrAudiences.Add(sClientId);
				arrAudiences.Add("microsoft:identityserver:" + sClientId);
				// 01/08/2018 Paul.  ADFS 3.0 will require us to register both client and mobile as valid audiences. 
				if ( sClientId != sMobileClientId && !Sql.IsEmptyString(sMobileClientId) )
				{
					arrAudiences.Add(sMobileClientId);
					arrAudiences.Add("microsoft:identityserver:" + sMobileClientId);
				}
				arrAudiences.Add("urn:microsoft:userinfo");
				// 02/14/2019 Paul.  Use Grant-AdfsApplicationPermission to grant the plug-in access to the resource. 
				// https://community.dynamics.com/crm/f/117/t/246239
				// Grant-AdfsApplicationPermission -ClientRoleIdentifier "0dff791c-21b4-49cd-b3be-e7c37d29d6c0" -ServerRoleIdentifier "https://SplendidPlugin"
				// 02/14/2019 Paul.  https://SplendidPlugin is hardcoded to the Outlook and Word plug-ins. 
				arrAudiences.Add("https://SplendidPlugin");
				// 02/14/2019 Paul.  Lets include survey and mobile. 
				arrAudiences.Add("https://SplendidMobile");
				arrAudiences.Add("https://auth.expo.io/@splendidcrm/splendidsurvey");
				// 02/14/2022 Paul.  Update System.IdentityModel.Tokens.Jwt to support Apple Signin. 
				// https://www.nuget.org/packages/System.IdentityModel.Tokens.Jwt/
				System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler tokenHandler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
				Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
				{
					//ValidIssuer         = sAuthority + "adfs",
					ValidIssuers        = arrValidIssuers,
					ValidAudiences      = arrAudiences,
					IssuerSigningKeys   = metadata.SigningKeys
				};

				Microsoft.IdentityModel.Tokens.SecurityToken validatedToken = null;
				//validatedToken = tokenHandler.ReadToken(sToken);
				// Throws an Exception as the token is invalid (expired, invalid-formatted, etc.)
				System.Security.Claims.ClaimsPrincipal identity = tokenHandler.ValidateToken(sToken, validationParameters, out validatedToken);
				if ( identity != null )
				{
					string sUSER_NAME  = String.Empty;
					string sFIRST_NAME = String.Empty;
					string sLAST_NAME  = String.Empty;
					string sEMAIL1     = String.Empty;
					foreach ( System.Security.Claims.Claim claim in identity.Claims )
					{
						//Debug.WriteLine(claim.Type + " = " + claim.Value);
						// http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationinstant = 1484346928
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier = zwkv1IHDGSe1FDyDrc6LO2+XxDD0LWfs1SL35ZdOxF0=
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn = paulrony@merchantware.local
						// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name = MERCHANTWARE\paulrony
						// aud = FD3ABD16-F96F-4BE7-98DB-D45C55DB0048
						// iss = https://adfs4.splendidcrm.com/adfs
						// iat = 1484346928
						// exp = 1484350528
						// nonce = 8f864f39-b44e-4d02-9cb2-38d5113643af
						switch ( claim.Type )
						{
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"          :  sUSER_NAME  = claim.Value;  break;
							// 01/08/2019 Paul.  Our instructions say to map SAM-Account-Name to Name ID, not name. 
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier":  sUSER_NAME  = claim.Value;  break;
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"       :  sLAST_NAME  = claim.Value;  break;
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"     :  sFIRST_NAME = claim.Value;  break;
							case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"  :  sEMAIL1     = claim.Value;  break;
						}
					}
					string[] arrUserName = sUSER_NAME.Split('\\');
					if ( arrUserName.Length > 1 )
						sUSER_NAME   = arrUserName[1];
					else
						sUSER_NAME   = arrUserName[0];
					if ( !Sql.IsEmptyString(sUSER_NAME) )
					{
						SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select ID                    " + ControlChars.CrLf
							     + "  from vwUSERS_Login         " + ControlChars.CrLf
							     + " where USER_NAME = @USER_NAME" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@USER_NAME", sUSER_NAME.ToLower());
								gUSER_ID = Sql.ToGuid(cmd.ExecuteScalar());
								if ( Sql.IsEmptyGuid(gUSER_ID) )
								{
									// 01/13/2017 Paul.  Cannot log an unknown user. 
									//SqlProcs.spUSERS_LOGINS_InsertOnly(ref gUSER_LOGIN_ID, Guid.Empty, sEMAIL1, "Azure AD", "Failed", Session.SessionID, Request.UserHostName, Request.Host.Host, Request.Path, Request.AppRelativeCurrentExecutionFilePath, Request.UserAgent);
									// 01/13/2017 Paul.  Cannot lock-out an unknown user. 
									//SplendidInit.LoginTracking(sEMAIL1, false);
									sError = "SECURITY: failed attempted login for " + sUSER_NAME + " using ADFS/REST API.";
									SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
								}
							}
						}
					}
					else
					{
						sError = "SECURITY: Failed attempted login using ADFS/REST API. Missing Username/Name ID from Claim token.";
						SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
					}
				}
				else
				{
					sError = "SECURITY: failed attempted login using ADFS/REST API. No SecurityToken identities found.";
					SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
				}
			}
			catch(Exception ex)
			{
				string sUSER_NAME = "(Unknown ADFS)";
				// 01/13/2017 Paul.  Cannot log an unknown user. 
				//SqlProcs.spUSERS_LOGINS_InsertOnly(ref gUSER_LOGIN_ID, Guid.Empty, sUSER_NAME, "Azure AD", "Failed", Session.SessionID, Request.UserHostName, Request.Host.Host, Request.Path, Request.AppRelativeCurrentExecutionFilePath, Request.UserAgent);
				// 01/13/2017 Paul.  Cannot lock-out an unknown user. 
				//SplendidInit.LoginTracking(sUSER_NAME, false);
				sError = "SECURITY: failed attempted login for " + sUSER_NAME + " using ADFS/REST API. " + ex.Message;
				SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
			}
			return gUSER_ID;
		}

		// 07/08/2023 Paul.  Move Office365AcquireAccessToken, Office365RefreshAccessToken and Office365TestAccessToken to Office365Sync to prevent circular references. 

		// 02/10/2017 Paul.  Cannot find the API to get the user profile, so extract from the AccessToken. 
		public MicrosoftGraphProfile GetProfile(string sToken)
		{
			MicrosoftGraphProfile profile = null;
			//string sAadTenantDomain    = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.AadTenantDomain"   ]);
			//string sRealm              = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.Realm"             ]);
			// 02/10/2017 Paul.  The FederationMetadata comes from the Azure Portal under the Application Registration / Endpoints. 
			string sFederationMetadata = Sql.ToString(Application["CONFIG.Azure.SingleSignOn.FederationMetadata"]);
			try
			{
				if ( !Sql.IsEmptyString(sFederationMetadata) )
				{
					// 02/14/2022 Paul.  Use the new metadata serializer. 
					// https://www.nuget.org/packages/Microsoft.IdentityModel.Protocols.WsFederation/
					Microsoft.IdentityModel.Protocols.WsFederation.WsFederationMetadataSerializer serializer = new Microsoft.IdentityModel.Protocols.WsFederation.WsFederationMetadataSerializer();
					Microsoft.IdentityModel.Protocols.WsFederation.WsFederationConfiguration metadata = Application["Azure.FederationMetadata"] as Microsoft.IdentityModel.Protocols.WsFederation.WsFederationConfiguration;
					if ( metadata == null )
					{
						metadata = serializer.ReadMetadata(XmlReader.Create(sFederationMetadata));
						Application["Azure.FederationMetadata"] = metadata;
					}

					// 02/14/2022 Paul.  Update System.IdentityModel.Tokens.Jwt to support Apple Signin. 
					// https://www.nuget.org/packages/System.IdentityModel.Tokens.Jwt/
					System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler tokenHandler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
					Microsoft.IdentityModel.Tokens.TokenValidationParameters validationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
					{
						ValidIssuer         = metadata.Issuer,
						IssuerSigningKeys   = metadata.SigningKeys,
						ValidAudience       = "https://outlook.office.com"
					};

					Microsoft.IdentityModel.Tokens.SecurityToken validatedToken = null;
					// Throws an Exception as the token is invalid (expired, invalid-formatted, etc.)
					System.Security.Claims.ClaimsPrincipal identity = tokenHandler.ValidateToken(sToken, validationParameters, out validatedToken);
					if ( identity != null )
					{
						string sUSER_NAME  = String.Empty;
						string sLAST_NAME  = String.Empty;
						string sFIRST_NAME = String.Empty;
						string sEMAIL1     = String.Empty;
						foreach ( System.Security.Claims.Claim claim in identity.Claims )
						{
							Debug.WriteLine(claim.Type + " = " + claim.Value);
							// http://schemas.microsoft.com/claims/authnmethodsreferences = pwd
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress = paul@splendidcrm.com
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname = Rony
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname = Paul
							// http://schemas.microsoft.com/identity/claims/identityprovider = live.com
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name = live.com#paul@splendidcrm.com
							// iat = 1484136100
							// nbf = 1484136100
							// exp = 1484140000
							// name = Paul Rony
							// platf = 3
							// ver = 1.0

							// 01/15/2017 Paul.  Alternate login. 
							// http://schemas.microsoft.com/claims/authnmethodsreferences = pwd
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname = Rony
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname = Paul
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name = paul@splendidcrm.onmicrosoft.com
							// http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn = paul@splendidcrm.onmicrosoft.com
							// iat = 1484512667
							// nbf = 1484512667
							// exp = 1484516567
							// name = Paul Rony
							// platf = 3
							// ver = 1.0
							switch ( claim.Type )
							{
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"          :  sUSER_NAME  = claim.Value;  break;
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"       :  sLAST_NAME  = claim.Value;  break;
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"     :  sFIRST_NAME = claim.Value;  break;
								case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"  :  sEMAIL1     = claim.Value;  break;
							}
						}
						if ( Sql.IsEmptyString(sEMAIL1) && sUSER_NAME.Contains("@") )
							sEMAIL1 = sUSER_NAME;
						profile = new MicrosoftGraphProfile();
						profile.FirstName    = sFIRST_NAME;
						profile.LastName     = sLAST_NAME ;
						profile.EmailAddress = sEMAIL1    ;
						profile.UserName     = sUSER_NAME ;
						profile.Name         = (sFIRST_NAME + " " + sLAST_NAME).Trim();
					}
				}
				else
				{
					Debug.WriteLine("FederationMetadata is empty.");
				}
			}
			catch(Exception ex)
			{
				Debug.WriteLine("Failed to get identity. " + ex.Message);
			}
			return profile;
		}

	}
}
