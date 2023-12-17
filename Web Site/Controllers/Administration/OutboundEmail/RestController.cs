/*
 * Copyright (C) 2021 SplendidCRM Software, Inc. All Rights Reserved. 
 *
 * Any use of the contents of this file are subject to the SplendidCRM Professional Source Code License 
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
 */
using System;
using System.IO;
using System.Xml;
using System.Web;
using System.Data;
using System.Data.Common;
using System.Text;
using System.Collections.Generic;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;
using System.Threading;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Authorization;

using Spring.Social.Office365;

namespace SplendidCRM.Controllers.Administration.OutboundEmail
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/OutboundEmail/Rest.svc")]
	public class RestController : ControllerBase
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SqlProcs             SqlProcs           ;
		private EmailUtils           EmailUtils         ;
		private ActiveDirectory      ActiveDirectory    ;
		private Office365Sync        Office365Sync      ;
		private GoogleApps           GoogleApps         ;
		private ExchangeUtils        ExchangeUtils      ;
		private Office365Utils       Office365Utils     ;

		public RestController(HttpSessionState Session, Security Security, EmailUtils EmailUtils, ActiveDirectory ActiveDirectory, Office365Sync Office365Sync, GoogleApps GoogleApps, ExchangeUtils ExchangeUtils, Office365Utils Office365Utils)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = new Sql(Session, Security);
			this.SqlProcs            = new SqlProcs(Security, Sql);
			this.EmailUtils          = EmailUtils         ;
			this.ActiveDirectory     = ActiveDirectory    ;
			this.Office365Sync       = Office365Sync      ;
			this.GoogleApps          = GoogleApps         ;
			this.ExchangeUtils       = ExchangeUtils      ;
			this.Office365Utils      = Office365Utils     ;
		}

		private DataRow GetRecord(Guid gID)
		{
			DataRow rdr = null;
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				string sSQL ;
				sSQL = "select *                " + ControlChars.CrLf
				     + "  from vwOUTBOUND_EMAILS" + ControlChars.CrLf
				     + " where ID = @ID         " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 03/31/2021 Paul.  The convention is to provide the @. 
					Sql.AddParameter(cmd, "@ID", gID);
					con.Open();

					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dtCurrent = new DataTable() )
						{
							da.Fill(dtCurrent);
							if ( dtCurrent.Rows.Count > 0 )
							{
								rdr = dtCurrent.Rows[0];
							}
						}
					}
				}
			}
			return rdr;
		}

		[HttpPost("[action]")]
		public string SendTestMessage([FromBody] Dictionary<string, object> dict)
		{
			Guid   gINBOUND_EMAIL_KEY = Sql.ToGuid(Application["CONFIG.InboundEmailKey"]);
			Guid   gINBOUND_EMAIL_IV  = Sql.ToGuid(Application["CONFIG.InboundEmailIV" ]);
			string sFROM_ADDR         = String.Empty;
			string sFROM_NAME         = String.Empty;
			string sMAIL_SENDTYPE     = String.Empty;
			string sMAIL_SMTPUSER     = String.Empty;
			string sMAIL_SMTPPASS     = String.Empty;
			string sMAIL_SMTPSERVER   = String.Empty;
			int    nMAIL_SMTPPORT     = 0;
			bool   bMAIL_SMTPAUTH_REQ = false;
			bool   bMAIL_SMTPSSL      = false;
			string sENCRYPTED_EMAIL_PASSWORD = String.Empty;
			Guid gID = Sql.ToGuid(Request.Query["ID"]);
			if ( !Sql.IsEmptyGuid(gID) )
			{
				DataRow rdr = GetRecord(gID);
				if ( rdr != null )
				{
					sFROM_ADDR         = Sql.ToString (rdr["FROM_ADDR"        ]);
					sFROM_NAME         = Sql.ToString (rdr["FROM_NAME"        ]);
					sMAIL_SENDTYPE     = Sql.ToString (rdr["MAIL_SENDTYPE"    ]);
					sMAIL_SMTPUSER     = Sql.ToString (rdr["MAIL_SMTPUSER"    ]);
					sMAIL_SMTPPASS     = Sql.ToString (rdr["MAIL_SMTPPASS"    ]);
					sMAIL_SMTPSERVER   = Sql.ToString (rdr["MAIL_SMTPSERVER"  ]);
					nMAIL_SMTPPORT     = Sql.ToInteger(rdr["MAIL_SMTPPORT"    ]);
					bMAIL_SMTPAUTH_REQ = Sql.ToBoolean(rdr["MAIL_SMTPAUTH_REQ"]);
					bMAIL_SMTPSSL      = Sql.ToBoolean(rdr["MAIL_SMTPSSL"     ]);
					sENCRYPTED_EMAIL_PASSWORD = sMAIL_SMTPPASS;
						if ( !Sql.IsEmptyString(sENCRYPTED_EMAIL_PASSWORD) )
						{
							sMAIL_SMTPPASS = Security.DecryptPassword(sENCRYPTED_EMAIL_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
						}
				}
				else
				{
					throw(new Exception("Record not found for ID " + gID.ToString()));
				}
			}
			else
			{
				throw(new Exception("missing ID"));
			}
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "from_addr"        :  sFROM_ADDR         = Sql.ToString (dict[sColumnName]);  break;
					case "from_name"        :  sFROM_NAME         = Sql.ToString (dict[sColumnName]);  break;
					case "mail_sendtype"    :  sMAIL_SENDTYPE     = Sql.ToString (dict[sColumnName]);  break;
					case "mail_smtpuser"    :  sMAIL_SMTPUSER     = Sql.ToString (dict[sColumnName]);  break;
					case "mail_smtppass"    :
					{
						sMAIL_SMTPPASS     = Sql.ToString (dict[sColumnName]);
						
						if ( !(Sql.IsEmptyString(sMAIL_SMTPPASS) || sMAIL_SMTPPASS == Sql.sEMPTY_PASSWORD) )
						{
							sENCRYPTED_EMAIL_PASSWORD = Security.EncryptPassword(sMAIL_SMTPPASS, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
						}
			
						break;
					}
					case "mail_smtpserver"  :  sMAIL_SMTPSERVER   = Sql.ToString (dict[sColumnName]);  break;
					case "mail_smtpport"    :  nMAIL_SMTPPORT     = Sql.ToInteger(dict[sColumnName]);  break;
					case "mail_smtpauth_req":  bMAIL_SMTPAUTH_REQ = Sql.ToBoolean(dict[sColumnName]);  break;
					case "mail_smtpssl"     :  bMAIL_SMTPSSL      = Sql.ToBoolean(dict[sColumnName]);  break;
				}
			}
			if ( Sql.IsEmptyString(sFROM_ADDR) )
			{
				throw(new Exception(L10n.Term("Users.ERR_EMAIL_REQUIRED_TO_TEST")));
			}

			string sStatus = String.Empty;
			if ( String.Compare(sMAIL_SENDTYPE, "smtp", true) == 0 )
			{
				// 02/02/2017 Paul.  Global values are only used if server left blank. 
				if ( Sql.IsEmptyString(sMAIL_SMTPSERVER) )
				{
					sMAIL_SMTPSERVER   = Sql.ToString (Application["CONFIG.smtpserver"  ]);
					nMAIL_SMTPPORT     = Sql.ToInteger(Application["CONFIG.smtpport"    ]);
					bMAIL_SMTPAUTH_REQ = Sql.ToBoolean(Application["CONFIG.smtpauth_req"]);
					bMAIL_SMTPSSL      = Sql.ToBoolean(Application["CONFIG.smtpssl"     ]);
				}
				EmailUtils.SendTestMessage(sMAIL_SMTPSERVER, nMAIL_SMTPPORT, bMAIL_SMTPAUTH_REQ, bMAIL_SMTPSSL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, sFROM_ADDR, sFROM_NAME, sFROM_ADDR, sFROM_NAME);
				sStatus = L10n.Term("Users.LBL_SEND_SUCCESSFUL");
			}
			// 01/31/2017 Paul.  Add support for Exchange using Username/Password. 
			else if ( String.Compare(sMAIL_SENDTYPE, "Exchange-Password", true) == 0 )
			{
				string sIMPERSONATED_TYPE        = Sql.ToString (Application["CONFIG.Exchange.ImpersonatedType"]);
				string sSERVER_URL               = Sql.ToString (Application["CONFIG.Exchange.ServerURL"       ]);
				ExchangeUtils.SendTestMessage(sSERVER_URL, sMAIL_SMTPUSER, sENCRYPTED_EMAIL_PASSWORD, sFROM_ADDR, sFROM_NAME, sFROM_ADDR, sFROM_NAME);
				sStatus = L10n.Term("Users.LBL_SEND_SUCCESSFUL");
			}
			return sStatus;
		}

		[HttpPost("[action]")]
		public string GoogleApps_Authorize([FromBody] Dictionary<string, object> dict)
		{
			Guid   gID            = Sql.ToGuid(Request.Query["ID"]);
			string sCode          = String.Empty;
			string sRedirectURL   = String.Empty;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "code"         :  sCode         = Sql.ToString (dict[sColumnName]);  break;
					case "redirect_url" :  sRedirectURL  = Sql.ToString (dict[sColumnName]);  break;
				}
			}
			string sEMAIL1 = String.Empty;
			if ( Security.AdminUserAccess("OutboundEmail", "edit") >= 0 )
			{
				if ( !Sql.IsEmptyString(sCode) )
				{
					string[] arrScopes = new string[]
					{
						"https://www.googleapis.com/auth/calendar",
						"https://www.googleapis.com/auth/tasks",
						"https://mail.google.com/",
						"https://www.google.com/m8/feeds"
					};
					string sOAuthClientID     = Sql.ToString(Application["CONFIG.GoogleApps.ClientID"    ]);
					string sOAuthClientSecret = Sql.ToString(Application["CONFIG.GoogleApps.ClientSecret"]);
					GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow(new GoogleAuthorizationCodeFlow.Initializer
					{
						//DataStore = new SessionDataStore(Session),
						ClientSecrets = new ClientSecrets
						{
							ClientId     = sOAuthClientID,
							ClientSecret = sOAuthClientSecret
						},
						Scopes = arrScopes
					});
					// 09/25/2015 Paul.  Redirect URL must match those allowed in Google Developer Console. https://console.developers.google.com/project/_/apiui/credential
					/*Google.Apis.Auth.OAuth2.Responses.TokenResponse*/var token = flow.ExchangeCodeForTokenAsync(gID.ToString(), sCode, sRedirectURL, CancellationToken.None).Result;
					string OAUTH_ACCESS_TOKEN      = token.AccessToken           ;
					string sTokenType              = token.TokenType             ;
					string OAUTH_REFRESH_TOKEN     = token.RefreshToken          ;
					string OAUTH_EXPIRES_IN        = token.ExpiresInSeconds.Value.ToString();

					DateTime dtOAUTH_EXPIRES_AT = DateTime.Now.AddSeconds(Sql.ToInteger(OAUTH_EXPIRES_IN));
					SqlProcs.spOAUTH_TOKENS_Update(gID, "GoogleApps", OAUTH_ACCESS_TOKEN, String.Empty, dtOAUTH_EXPIRES_AT, OAUTH_REFRESH_TOKEN);
					SqlProcs.spOAUTH_TOKENS_Update(gID, "GoogleApps", OAUTH_ACCESS_TOKEN, String.Empty, dtOAUTH_EXPIRES_AT, OAUTH_REFRESH_TOKEN);
					Application["CONFIG.GoogleApps." + gID.ToString() + ".OAuthAccessToken" ] = OAUTH_ACCESS_TOKEN ;
					Application["CONFIG.GoogleApps." + gID.ToString() + ".OAuthRefreshToken"] = OAUTH_REFRESH_TOKEN;
					Application["CONFIG.GoogleApps." + gID.ToString() + ".OAuthExpiresAt"   ] = dtOAUTH_EXPIRES_AT.ToShortDateString() + " " + dtOAUTH_EXPIRES_AT.ToShortTimeString();
					StringBuilder sbErrors = new StringBuilder();
					sEMAIL1 = GoogleApps.GetEmailAddress(gID, sbErrors);
					if ( sbErrors.Length > 0 )
						throw(new Exception(sbErrors.ToString()));
				}
				else
				{
					throw(new Exception("missing OAuth code"));
				}
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			return sEMAIL1;
		}

		[HttpPost("[action]")]
		public void GoogleApps_Delete([FromBody] Dictionary<string, object> dict)
		{
			Guid gID = Sql.ToGuid(Request.Query["ID"]);
			if ( Security.AdminUserAccess("OutboundEmail", "edit") >= 0 )
			{
				SqlProcs.spOAUTH_TOKENS_Delete(gID, "GoogleApps");
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

		[HttpPost("[action]")]
		public string GoogleApps_Test([FromBody] Dictionary<string, object> dict)
		{
			string sStatus            = String.Empty;
			Guid   gID                = Sql.ToGuid(Request.Query["ID"]);
			string sFROM_ADDR         = String.Empty;
			string sFROM_NAME         = String.Empty;
			if ( !Sql.IsEmptyGuid(gID) )
			{
				DataRow rdr = GetRecord(gID);
				if ( rdr != null )
				{
					sFROM_ADDR         = Sql.ToString (rdr["FROM_ADDR"        ]);
					sFROM_NAME         = Sql.ToString (rdr["FROM_NAME"        ]);
				}
				else
				{
					throw(new Exception("Record not found for ID " + gID.ToString()));
				}
			}
			else
			{
				throw(new Exception("missing ID"));
			}
			if ( Security.AdminUserAccess("OutboundEmail", "edit") >= 0 )
			{
				StringBuilder sbErrors = new StringBuilder();
				//SplendidCRM.GoogleApps.TestAccessToken(Application, gID, sbErrors);
				GoogleApps.SendTestMessage(gID, sFROM_ADDR, sFROM_NAME, sFROM_ADDR, sFROM_NAME);
				sStatus = sbErrors.ToString();
				if ( Sql.IsEmptyString(sStatus) )
					sStatus = L10n.Term("OAuth.LBL_TEST_SUCCESSFUL");
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			return sStatus;
		}

		[HttpPost("[action]")]
		public void GoogleApps_RefreshToken([FromBody] Dictionary<string, object> dict)
		{
			Guid gID = Sql.ToGuid(Request.Query["ID"]);
			if ( Security.AdminUserAccess("OutboundEmail", "edit") >= 0 )
			{
				GoogleApps.RefreshAccessToken(gID, true);
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

		[HttpPost("[action]")]
		public string Office365_Authorize([FromBody] Dictionary<string, object> dict)
		{
			Guid   gID            = Sql.ToGuid(Request.Query["ID"]);
			string sCode          = String.Empty;
			string sRedirectURL   = String.Empty;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "code"         :  sCode         = Sql.ToString (dict[sColumnName]);  break;
					case "redirect_url" :  sRedirectURL  = Sql.ToString (dict[sColumnName]);  break;
				}
			}
			string sEMAIL1 = String.Empty;
			if ( Security.AdminUserAccess("OutboundEmail", "edit") >= 0 )
			{
				if ( !Sql.IsEmptyString(sCode) )
				{
					string sOAuthClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
					string sOAuthClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
					// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
					string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
					// 11/09/2019 Paul.  Pass the RedirectURL so that we can call from the React client. 
					Office365AccessToken token = Office365Sync.Office365AcquireAccessToken(Request, sOAuthClientSecret, sOAuthClientID, sOAuthClientSecret, gID, sCode, sRedirectURL);
					
					// 02/09/2017 Paul.  Use Microsoft Graph REST API to get email. 
					MicrosoftGraphProfile profile = ActiveDirectory.GetProfile(token.AccessToken);
					if ( profile != null )
					{
						sEMAIL1 = Sql.ToString(profile.EmailAddress);
					}
				}
				else
				{
					throw(new Exception("missing OAuth code"));
				}
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			return sEMAIL1;
		}

		[HttpPost("[action]")]
		public void Office365_Delete([FromBody] Dictionary<string, object> dict)
		{
			Guid gID = Sql.ToGuid(Request.Query["ID"]);
			if ( Security.AdminUserAccess("OutboundEmail", "edit") >= 0 )
			{
				SqlProcs.spOAUTH_TOKENS_Delete(gID, "Office365");
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

		[HttpPost("[action]")]
		public string Office365_Test([FromBody] Dictionary<string, object> dict)
		{
			Guid   gID                = Sql.ToGuid(Request.Query["ID"]);
			string sFROM_ADDR         = String.Empty;
			string sFROM_NAME         = String.Empty;
			if ( !Sql.IsEmptyGuid(gID) )
			{
				DataRow rdr = GetRecord(gID);
				if ( rdr != null )
				{
					sFROM_ADDR         = Sql.ToString (rdr["FROM_ADDR"        ]);
					sFROM_NAME         = Sql.ToString (rdr["FROM_NAME"        ]);
				}
				else
				{
					throw(new Exception("Record not found for ID " + gID.ToString()));
				}
			}
			else
			{
				throw(new Exception("missing ID"));
			}
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "fromname"   :
						if ( !Sql.IsEmptyString(dict[sColumnName]) )
							sFROM_NAME = Sql.ToString (dict[sColumnName]);
						break;
					case "fromaddress":
						if ( !Sql.IsEmptyString(dict[sColumnName]) )
							sFROM_ADDR = Sql.ToString (dict[sColumnName]);
						break;
				}
			}

			string sStatus = String.Empty;
			if ( Security.AdminUserAccess("EmailMain", "edit") >= 0 )
			{
				StringBuilder sbErrors = new StringBuilder();
				string sOAuthClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
				string sOAuthClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365Sync.Office365TestAccessToken(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, gID, sbErrors);

				// 12/13/2020 Paul.  Move Office365 methods to Office365utils. 
				Office365Utils.SendTestMessage(gID, sFROM_ADDR, sFROM_NAME, sFROM_ADDR, sFROM_NAME);
				sStatus = sbErrors.ToString();
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			return sStatus;
		}

		[HttpPost("[action]")]
		public void Office365_RefreshToken([FromBody] Dictionary<string, object> dict)
		{
			Guid   gID     = Sql.ToGuid(Request.Query["ID"]);
			if ( Security.AdminUserAccess("OutboundEmail", "edit") >= 0 )
			{
				string sOAuthClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
				string sOAuthClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, gID, true);
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

	}
}
