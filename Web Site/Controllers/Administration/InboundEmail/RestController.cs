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
using System.Data;
using System.Data.Common;
using System.Text;
using System.Collections.Generic;
using System.Threading;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authorization;

using MimeKit;
using MailKit;
using MailKit.Net.Pop3;
using MailKit.Net.Imap;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;

using Spring.Social.Office365;

namespace SplendidCRM.Controllers.Administration.InboundEmail
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/InboundEmail/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "Import";
		private HttpContext          Context            ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private PopUtils             PopUtils           ;
		private ImapUtils            ImapUtils          ;
		private EmailUtils           EmailUtils         ;
		private MimeUtils            MimeUtils          ;
		private XmlUtil              XmlUtil            ;
		private ActiveDirectory      ActiveDirectory    ;
		private SyncError            SyncError          ;
		private Crm.Modules          Modules            ;
		private Crm.NoteAttachments  NoteAttachments    ;
		private Office365Sync        Office365Sync      ;
		private GoogleApps           GoogleApps         ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private ExchangeUtils        ExchangeUtils      ;
		private ExchangeSync         ExchangeSync       ;

		public RestController (HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, PopUtils PopUtils, ImapUtils ImapUtils, EmailUtils EmailUtils, MimeUtils MimeUtils, XmlUtil XmlUtil, ActiveDirectory ActiveDirectory, SyncError SyncError, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, Office365Sync Office365Sync, GoogleApps GoogleApps, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, ExchangeSync ExchangeSync)
		{
			this.Context             = this.HttpContext   ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.PopUtils            = PopUtils           ;
			this.ImapUtils           = ImapUtils          ;
			this.EmailUtils          = EmailUtils         ;
			this.MimeUtils           = MimeUtils          ;
			this.XmlUtil             = XmlUtil            ;
			this.ActiveDirectory     = ActiveDirectory    ;
			this.SyncError           = SyncError          ;
			this.Modules             = Modules            ;
			this.NoteAttachments     = NoteAttachments    ;
			this.Office365Sync       = Office365Sync      ;
			this.GoogleApps          = GoogleApps         ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.ExchangeUtils       = ExchangeUtils      ;
			this.ExchangeSync        = ExchangeSync       ;
		}

		private DataRow GetRecord(Guid gID)
		{
			DataRow rdr = null;
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				string sSQL ;
				sSQL = "select *                " + ControlChars.CrLf
				     + "  from vwINBOUND_EMAILS " + ControlChars.CrLf
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

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string CheckMailbox([FromBody] Dictionary<string, object> dict)
		{
			string sStatus = String.Empty;
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				Guid gINBOUND_EMAIL_KEY = Sql.ToGuid(Application["CONFIG.InboundEmailKey"]);
				Guid gINBOUND_EMAIL_IV  = Sql.ToGuid(Application["CONFIG.InboundEmailIV" ]);
				string sSERVICE        = String.Empty;
				string sSERVER_URL     = String.Empty;
				int    nPORT           = 0;
				bool   bMAILBOX_SSL    = false;
				string sEMAIL_USER     = String.Empty;
				string sEMAIL_PASSWORD = String.Empty;
				string sMAILBOX        = String.Empty;
				string sENCRYPTED_EMAIL_PASSWORD = String.Empty;
				Guid gID = Sql.ToGuid(Request.Query["ID"]);
				if ( !Sql.IsEmptyGuid(gID) )
				{
					DataRow rdr = GetRecord(gID);
					if ( rdr != null )
					{
						sSERVICE        = Sql.ToString (rdr["SERVICE"       ]);
						sSERVER_URL     = Sql.ToString (rdr["SERVER_URL"    ]);
						nPORT           = Sql.ToInteger(rdr["PORT"          ]);
						bMAILBOX_SSL    = Sql.ToBoolean(rdr["MAILBOX_SSL"   ]);
						sEMAIL_USER     = Sql.ToString (rdr["EMAIL_USER"    ]);
						sEMAIL_PASSWORD = Sql.ToString (rdr["EMAIL_PASSWORD"]);
						sMAILBOX        = Sql.ToString (rdr["MAILBOX"       ]);
						sENCRYPTED_EMAIL_PASSWORD = sEMAIL_PASSWORD;
						if ( !Sql.IsEmptyString(sENCRYPTED_EMAIL_PASSWORD) )
						{
							sEMAIL_PASSWORD = Security.DecryptPassword(sENCRYPTED_EMAIL_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
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
						case "SERVICE"       :  sSERVICE        = Sql.ToString (dict[sColumnName]);  break;
						case "SERVER_URL"    :  sSERVER_URL     = Sql.ToString (dict[sColumnName]);  break;
						case "PORT"          :  nPORT           = Sql.ToInteger(dict[sColumnName]);  break;
						case "MAILBOX_SSL"   :  bMAILBOX_SSL    = Sql.ToBoolean(dict[sColumnName]);  break;
						case "MAILBOX"       :  sMAILBOX        = Sql.ToString (dict[sColumnName]);  break;
						case "EMAIL_USER"    :  sEMAIL_USER     = Sql.ToString (dict[sColumnName]);  break;
						case "EMAIL_PASSWORD":
						{
							sEMAIL_PASSWORD     = Sql.ToString (dict[sColumnName]);
						
							if ( !(Sql.IsEmptyString(sEMAIL_PASSWORD) || sEMAIL_PASSWORD == Sql.sEMPTY_PASSWORD) )
							{
								sENCRYPTED_EMAIL_PASSWORD = Security.EncryptPassword(sEMAIL_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
							}
			
							break;
						}
					}
				}
				StringBuilder sbErrors = new StringBuilder();
				if ( String.Compare(sSERVICE, "pop3", true) == 0 )
				{
					PopUtils.Validate(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD, sbErrors);
					sStatus = sbErrors.ToString();
				}
				else if ( String.Compare(sSERVICE, "imap", true) == 0 )
				{
					ImapUtils.Validate(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD, sMAILBOX, sbErrors);
					sStatus = sbErrors.ToString();
				}
				// 01/31/2017 Paul.  Add support for Exchange using Username/Password. 
				else if ( String.Compare(sSERVICE, "Exchange-Password", true) == 0 )
				{
					sENCRYPTED_EMAIL_PASSWORD = Security.EncryptPassword(sEMAIL_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
					string sIMPERSONATED_TYPE        = Sql.ToString (Application["CONFIG.Exchange.ImpersonatedType" ]);
					sSERVER_URL = Sql.ToString (Application["CONFIG.Exchange.ServerURL"]);
					// 12/13/2017 Paul.  Allow version to be changed. 
					string sEXCHANGE_VERSION = Sql.ToString(Application["CONFIG.Exchange.Version"]);
					ExchangeUtils.ValidateExchange(sSERVER_URL, sEMAIL_USER, sENCRYPTED_EMAIL_PASSWORD, true, sIMPERSONATED_TYPE, sEXCHANGE_VERSION, sbErrors);
					sStatus = sbErrors.ToString();
				}
				else
				{
					throw(new Exception("This is not the correct button to test this service: " + sSERVICE));
				}
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			return sStatus;
		}

		[DotNetLegacyData]
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
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
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
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				SqlProcs.spOAUTH_TOKENS_Delete(gID, "GoogleApps");
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string GoogleApps_Test([FromBody] Dictionary<string, object> dict)
		{
			string sStatus            = String.Empty;
			Guid   gID                = Sql.ToGuid(Request.Query["ID"]);
			string sMAILBOX           = String.Empty;
			string sFROM_NAME         = String.Empty;
			if ( !Sql.IsEmptyGuid(gID) )
			{
				DataRow rdr = GetRecord(gID);
				if ( rdr != null )
				{
					sMAILBOX = Sql.ToString (rdr["MAILBOX"]);
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
					case "MAILBOX":
						if ( !Sql.IsEmptyString(dict[sColumnName]) )
							sMAILBOX = Sql.ToString (dict[sColumnName]);
						break;
				}
			}
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				StringBuilder sbErrors = new StringBuilder();
				GoogleApps.TestMailbox(gID, sMAILBOX, sbErrors);
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
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				GoogleApps.RefreshAccessToken(gID, true);
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

		[DotNetLegacyData]
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
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				if ( !Sql.IsEmptyString(sCode) )
				{
					string sOAuthClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
					string sOAuthClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
					// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
					string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
					// 11/09/2019 Paul.  Pass the RedirectURL so that we can call from the React client. 
					Office365AccessToken token = Office365Sync.Office365AcquireAccessToken(Request, sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, gID, sCode, sRedirectURL);
					
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
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				SqlProcs.spOAUTH_TOKENS_Delete(gID, "Office365");
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Office365_Test([FromBody] Dictionary<string, object> dict)
		{
			Guid   gID      = Sql.ToGuid(Request.Query["ID"]);
			string sMAILBOX = String.Empty;
			if ( !Sql.IsEmptyGuid(gID) )
			{
				DataRow rdr = GetRecord(gID);
				if ( rdr != null )
				{
					sMAILBOX = Sql.ToString (rdr["MAILBOX"]);
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
					case "MAILBOX":
						if ( !Sql.IsEmptyString(dict[sColumnName]) )
							sMAILBOX = Sql.ToString (dict[sColumnName]);
						break;
				}
			}

			string sStatus = String.Empty;
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				StringBuilder sbErrors = new StringBuilder();
				string sOAuthClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
				string sOAuthClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				// 12/13/2020 Paul.  Move Office365 methods to Office365utils. 
				Office365Utils Office365Utils = new Office365Utils(Session, Security, Sql, SqlProcs, SplendidError, MimeUtils, ActiveDirectory, SyncError, NoteAttachments, Office365Sync);
				Office365Utils.ValidateExchange(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, gID, sMAILBOX, sbErrors);
#if DEBUG
				Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, gID, false);
				// 02/09/2017 Paul.  Use Microsoft Graph REST API to get email. 
				MicrosoftGraphProfile profile = ActiveDirectory.GetProfile(token.AccessToken);
				if ( profile != null )
					Debug.WriteLine(Sql.ToString(profile.EmailAddress));
#endif
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
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
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

		[HttpPost("[action]")]
		public void CheckBounce([FromBody] Dictionary<string, object> dict)
		{
			Guid   gID     = Sql.ToGuid(Request.Query["ID"]);
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				EmailUtils.CheckInbound(gID, true);
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

		[HttpPost("[action]")]
		public void CheckInbound([FromBody] Dictionary<string, object> dict)
		{
			Guid   gID     = Sql.ToGuid(Request.Query["ID"]);
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				EmailUtils.CheckInbound(gID, false);
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

		[HttpPost("[action]")]
		public Dictionary<string, object> GetMail([FromBody] Dictionary<string, object> dict)
		{
			Guid      gID       = Sql.ToGuid(Request.Query["ID"]);
			Guid      gTIMEZONE = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone  T10n      = TimeZone.CreateTimeZone(gTIMEZONE);
			DataTable dtMain    = new DataTable();
			if ( Security.AdminUserAccess("InboundEmail", "edit") >= 0 )
			{
				Guid gINBOUND_EMAIL_KEY = Sql.ToGuid(Application["CONFIG.InboundEmailKey"]);
				Guid gINBOUND_EMAIL_IV  = Sql.ToGuid(Application["CONFIG.InboundEmailIV" ]);
				string sSERVICE                  = String.Empty;
				string sSERVER_URL               = String.Empty;
				int    nPORT                     = 0;
				bool   bMAILBOX_SSL              = false;
				string sEMAIL_USER               = String.Empty;
				string sEMAIL_PASSWORD           = String.Empty;
				string sMAILBOX                  = String.Empty;
				bool   bOFFICE365_OAUTH_ENABLED  = false;
				bool   bGOOGLEAPPS_OAUTH_ENABLED = false;
				if ( !Sql.IsEmptyGuid(gID) )
				{
					DataRow rdr = GetRecord(gID);
					if ( rdr != null )
					{
						sSERVICE                  = Sql.ToString (rdr["SERVICE"                 ]);
						sSERVER_URL               = Sql.ToString (rdr["SERVER_URL"              ]);
						nPORT                     = Sql.ToInteger(rdr["PORT"                    ]);
						bMAILBOX_SSL              = Sql.ToBoolean(rdr["MAILBOX_SSL"             ]);
						sEMAIL_USER               = Sql.ToString (rdr["EMAIL_USER"              ]);
						sEMAIL_PASSWORD           = Sql.ToString (rdr["EMAIL_PASSWORD"          ]);
						sMAILBOX                  = Sql.ToString (rdr["MAILBOX"                 ]);
						bOFFICE365_OAUTH_ENABLED  = Sql.ToBoolean(rdr["OFFICE365_OAUTH_ENABLED" ]);
						bGOOGLEAPPS_OAUTH_ENABLED = Sql.ToBoolean(rdr["GOOGLEAPPS_OAUTH_ENABLED"]);
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

				dtMain.Columns.Add("From"        , typeof(System.String  ));
				dtMain.Columns.Add("Sender"      , typeof(System.String  ));
				dtMain.Columns.Add("ReplyTo"     , typeof(System.String  ));
				dtMain.Columns.Add("To"          , typeof(System.String  ));
				dtMain.Columns.Add("CC"          , typeof(System.String  ));
				dtMain.Columns.Add("Bcc"         , typeof(System.String  ));
				dtMain.Columns.Add("Subject"     , typeof(System.String  ));
				dtMain.Columns.Add("DeliveryDate", typeof(System.DateTime));
				dtMain.Columns.Add("Priority"    , typeof(System.String  ));
				dtMain.Columns.Add("Size"        , typeof(System.Int32   ));
				dtMain.Columns.Add("ContentID"   , typeof(System.String  ));
				dtMain.Columns.Add("MessageID"   , typeof(System.String  ));
				dtMain.Columns.Add("Headers"     , typeof(System.String  ));

				// 01/16/2017 Paul.  Add support for Office 365 OAuth. 
				if ( bOFFICE365_OAUTH_ENABLED )
				{
					// 12/13/2020 Paul.  Move Office365 methods to Office365utils. 
					Office365Utils Office365Utils = new Office365Utils(Session, Security, Sql, SqlProcs, SplendidError, MimeUtils, ActiveDirectory, SyncError, NoteAttachments, Office365Sync);
					Spring.Social.Office365.Office365Sync.UserSync User = new Spring.Social.Office365.Office365Sync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, ExchangeSecurity, SyncError, Modules, NoteAttachments, Office365Sync, String.Empty, String.Empty, String.Empty, String.Empty, gID, false, bOFFICE365_OAUTH_ENABLED);
					string sFOLDER_ID = Office365Utils.GetFolderId(String.Empty, String.Empty, gID, sMAILBOX);
					if ( Sql.IsEmptyString(sFOLDER_ID) )
						throw(new Exception("Could not find folder " + sMAILBOX));
						
					DataTable dt = Office365Utils.GetFolderMessages(User, sFOLDER_ID, 200, 0, "DATE_START", "desc");
					foreach ( DataRow row in dt.Rows )
					{
						DataRow rowMain = dtMain.NewRow();
						dtMain.Rows.Add(rowMain);
						rowMain["From"        ] = row["FROM"            ];
						rowMain["Sender"      ] = String.Empty;
						rowMain["ReplyTo"     ] = String.Empty;
						rowMain["To"          ] = row["TO_ADDRS"        ];
						rowMain["CC"          ] = row["CC_ADDRS"        ];
						rowMain["Bcc"         ] = String.Empty;
						rowMain["Subject"     ] = row["NAME"            ];
						rowMain["DeliveryDate"] = row["DATE_START"      ];
						rowMain["Priority"    ] = String.Empty;
						rowMain["Size"        ] = row["SIZE"            ];
						rowMain["ContentID"   ] = row["UNIQUE_ID"       ];
						rowMain["MessageID"   ] = row["MESSAGE_ID"      ];
						rowMain["Headers"     ] = row["INTERNET_HEADERS"];
					}
				}
				// 01/31/2017 Paul.  Add support for Exchange using Username/Password. 
				else if ( String.Compare(sSERVICE, "Exchange-Password", true) == 0 )
				{
					try
					{
						ExchangeSync.UserSync User = new ExchangeSync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, XmlUtil, SyncError, ExchangeSecurity, ExchangeUtils, ExchangeSync, String.Empty, String.Empty, sEMAIL_USER, sEMAIL_PASSWORD, Guid.Empty, String.Empty, false, false);
						string sFOLDER_ID = ExchangeUtils.GetFolderId(sEMAIL_USER, sEMAIL_PASSWORD, Guid.Empty, sMAILBOX);
						if ( Sql.IsEmptyString(sFOLDER_ID) )
							throw(new Exception("Could not find folder " + sMAILBOX));
						
						DataTable dt = ExchangeUtils.GetFolderMessages(User, sFOLDER_ID, 200, 0, "DATE_START", "desc");
						foreach ( DataRow row in dt.Rows )
						{
							DataRow rowMain = dtMain.NewRow();
							dtMain.Rows.Add(rowMain);
							rowMain["From"        ] = row["FROM"            ];
							rowMain["Sender"      ] = String.Empty;
							rowMain["ReplyTo"     ] = String.Empty;
							rowMain["To"          ] = row["TO_ADDRS"        ];
							rowMain["CC"          ] = row["CC_ADDRS"        ];
							rowMain["Bcc"         ] = String.Empty;
							rowMain["Subject"     ] = row["NAME"            ];
							rowMain["DeliveryDate"] = row["DATE_START"      ];
							rowMain["Priority"    ] = String.Empty;
							rowMain["Size"        ] = row["SIZE"            ];
							rowMain["ContentID"   ] = row["UNIQUE_ID"       ];
							rowMain["MessageID"   ] = row["MESSAGE_ID"      ];
							rowMain["Headers"     ] = row["INTERNET_HEADERS"];
						}
					}
					catch(Exception ex)
					{
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
						throw;
					}
				}
				else if ( bGOOGLEAPPS_OAUTH_ENABLED )
				{
					DataTable dt = GoogleApps.GetFolderMessages(gID, sMAILBOX, false, 0, 200);
					foreach ( DataRow row in dt.Rows )
					{
						DataRow rowMain = dtMain.NewRow();
						dtMain.Rows.Add(rowMain);
						rowMain["From"        ] = row["FROM"            ];
						rowMain["Sender"      ] = String.Empty;
						rowMain["ReplyTo"     ] = String.Empty;
						rowMain["To"          ] = row["TO_ADDRS"        ];
						rowMain["CC"          ] = row["CC_ADDRS"        ];
						rowMain["Bcc"         ] = String.Empty;
						rowMain["Subject"     ] = row["NAME"            ];
						rowMain["DeliveryDate"] = row["DATE_START"      ];
						rowMain["Priority"    ] = String.Empty;
						rowMain["Size"        ] = row["SIZE"            ];
						rowMain["ContentID"   ] = row["UNIQUE_ID"       ];
						rowMain["MessageID"   ] = row["MESSAGE_ID"      ];
						rowMain["Headers"     ] = row["INTERNET_HEADERS"];
					}
				}
				// 10/28/2010 Paul.  Add support for IMAP. 
				else if ( String.Compare(sSERVICE, "imap", true) == 0 )
				{
					// 01/08/2008 Paul.  Decrypt at the last minute to ensure that an unencrypted password is never sent to the browser. 
					sEMAIL_PASSWORD = Security.DecryptPassword(sEMAIL_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
					try
					{
						if ( Sql.IsEmptyString(sMAILBOX) )
							sMAILBOX = "INBOX";
						//using ( ImapConnect connection = new ImapConnect(sSERVER_URL, nPORT, bMAILBOX_SSL) )
						using ( ImapClient imap = new ImapClient() )
						{
							imap.Connect(sSERVER_URL, nPORT, (bMAILBOX_SSL ? MailKit.Security.SecureSocketOptions.SslOnConnect : MailKit.Security.SecureSocketOptions.Auto));
							imap.AuthenticationMechanisms.Remove ("XOAUTH2");
							// 01/22/2017 Paul.  There is a bug with NTLM. 
							// http://stackoverflow.com/questions/39573233/mailkit-authenticate-to-imap-fails
							imap.AuthenticationMechanisms.Remove ("NTLM");
							imap.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
							IMailFolder mailbox = imap.GetFolder(sMAILBOX);
							if ( mailbox != null )
							{
								mailbox.Open(FolderAccess.ReadOnly);
								// 01/21/2017 Paul.  Limit the messages to 200 to prevent a huge loop. 
								int nStartIndex = Math.Max(mailbox.Count - 200, 0);
								// All is a macro for Envelope, Flags, InternalDate, and MessageSize. 
								IList<IMessageSummary> lstMessages = mailbox.Fetch(nStartIndex, -1, MessageSummaryItems.All | MessageSummaryItems.UniqueId);
								for ( int i = 0; i < lstMessages.Count ; i++ )
								{
									IMessageSummary summary = lstMessages[i];
									string sHeaders = String.Empty;
									if ( summary.Headers != null )
									{
										using ( MemoryStream mem = new MemoryStream() )
										{
											summary.Headers.WriteTo(mem);
											mem.Position = 0;
											using ( StreamReader rdr = new StreamReader(mem) )
											{
												sHeaders = rdr.ReadToEnd();
											}
										}
									}
										
									DataRow row = dtMain.NewRow();
									dtMain.Rows.Add(row);
									row["From"        ] = WebUtility.HtmlEncode(summary.Envelope.From    != null ? summary.Envelope.From   .ToString() : String.Empty);
									row["Sender"      ] = WebUtility.HtmlEncode(summary.Envelope.Sender  != null ? summary.Envelope.Sender .ToString() : String.Empty);
									row["ReplyTo"     ] = WebUtility.HtmlEncode(summary.Envelope.ReplyTo != null ? summary.Envelope.ReplyTo.ToString() : String.Empty);
									row["To"          ] = WebUtility.HtmlEncode(summary.Envelope.To      != null ? summary.Envelope.To     .ToString() : String.Empty);
									row["CC"          ] = WebUtility.HtmlEncode(summary.Envelope.Cc      != null ? summary.Envelope.Cc     .ToString() : String.Empty);
									row["Bcc"         ] = WebUtility.HtmlEncode(summary.Envelope.Bcc     != null ? summary.Envelope.Bcc    .ToString() : String.Empty);
									row["Subject"     ] = WebUtility.HtmlEncode(summary.Envelope.Subject);
									// 01/23/2008 Paul.  DateTime in the email is in universal time. 
									row["DeliveryDate"] = summary.Date.DateTime.ToLocalTime();
									row["Priority"    ] = DBNull.Value;
									if ( summary.Size.HasValue )
										row["Size"    ] = summary.Size;
									row["ContentId"   ] = DBNull.Value;
									row["MessageId"   ] = summary.Envelope.MessageId;
									row["Headers"     ] = "<pre>" + WebUtility.HtmlEncode(sHeaders) + "</pre>";
								}
							}
						}
					}
					catch(Exception ex)
					{
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
						throw;
					}
				}
				else if ( String.Compare(sSERVICE, "pop3", true) == 0 )
				{
					// 01/08/2008 Paul.  Decrypt at the last minute to ensure that an unencrypted password is never sent to the browser. 
					sEMAIL_PASSWORD = Security.DecryptPassword(sEMAIL_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
						
					//Pop3.Pop3MimeClient pop = new Pop3.Pop3MimeClient(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD);
					try
					{
						using ( Pop3Client pop = new Pop3Client() )
						{
							pop.Timeout = 60 * 1000; //give pop server 60 seconds to answer
							pop.Connect(sSERVER_URL, nPORT, (bMAILBOX_SSL ? MailKit.Security.SecureSocketOptions.SslOnConnect : MailKit.Security.SecureSocketOptions.Auto));
							pop.AuthenticationMechanisms.Remove ("XOAUTH2");
							pop.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
								
							int nTotalEmails = pop.Count;
							int nStartIndex  = nTotalEmails - 200;
							if ( nStartIndex < 0 )
								nStartIndex = 0;
							IList<int> lstMessageSizes = pop.GetMessageSizes();
							// 01/22/2017 Paul.  Get headers only. 
							IList<Stream> lstHeaders = pop.GetStreams(nStartIndex, nTotalEmails - nStartIndex, true);
							for ( int i = 0; i < lstHeaders.Count; i++ )
							{
								string sRawContent = String.Empty;
								MimeMessage mm = MimeMessage.Load(lstHeaders[i]);
								using ( MemoryStream mem = new MemoryStream() )
								{
									mm.WriteTo(mem);
									mem.Position = 0;
									using ( StreamReader rdr = new StreamReader(mem) )
									{
										sRawContent = rdr.ReadToEnd();
									}
								}
									
								DataRow row = dtMain.NewRow();
								dtMain.Rows.Add(row);
								if ( mm.From    != null ) row["From"        ] =WebUtility.HtmlEncode(mm.From   .ToString());
								if ( mm.Sender  != null ) row["Sender"      ] =WebUtility.HtmlEncode(mm.Sender .ToString());
								if ( mm.ReplyTo != null ) row["ReplyTo"     ] =WebUtility.HtmlEncode(mm.ReplyTo.ToString());
								if ( mm.To      != null ) row["To"          ] =WebUtility.HtmlEncode(mm.To     .ToString());
								if ( mm.Cc      != null ) row["CC"          ] =WebUtility.HtmlEncode(mm.Cc     .ToString());
								if ( mm.Bcc     != null ) row["Bcc"         ] =WebUtility.HtmlEncode(mm.Bcc    .ToString());
								if ( mm.Subject != null ) row["Subject"     ] =WebUtility.HtmlEncode(mm.Subject);
								// 04/30/2023 Paul.  email.Date cannot be null. 
								if ( mm.Date    != DateTimeOffset.MinValue ) row["DeliveryDate"] = T10n.FromUniversalTime(mm.Date.DateTime);
								row["Priority"    ] = mm.Priority.ToString();
								if ( nStartIndex + i < lstMessageSizes.Count )
									row["Size"        ] = lstMessageSizes[nStartIndex + i];
								row["MessageId"   ] = mm.MessageId   ;
								row["Headers"     ] = "<pre>" + WebUtility.HtmlEncode(sRawContent) + "</pre>";
								//row["ContentId"   ] = mm.ContentId   ;
								//row["Body"        ] = mm.Body        ;
							}
						}
					}
					catch(Exception ex)
					{
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
						throw;
					}
				}
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			string sBaseURI = Request.Scheme + "://" + Request.Host + Request.Path.Value;
			
			int lTotalCount = dtMain.Rows.Count;
			// 04/01/2020 Paul.  Move json utils to RestUtil. 
			Dictionary<string, object> dictResponse = RestUtil.ToJson(sBaseURI, String.Empty, dtMain, T10n);
			dictResponse.Add("__total", lTotalCount);
			return dictResponse;
		}
	}
}
