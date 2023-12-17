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
using System.Text;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authorization;

using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;

using Spring.Social.Office365;

namespace SplendidCRM.Controllers.Administration.EmailMan
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/EmailMan/Rest.svc")]
	public class RestController : ControllerBase
	{
		private HttpContext          Context            ;
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private EmailUtils           EmailUtils         ;
		private MimeUtils            MimeUtils          ;
		private ActiveDirectory      ActiveDirectory    ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private SyncError            SyncError          ;
		private Crm.Modules          Modules            ;
		private Crm.NoteAttachments  NoteAttachments    ;
		private Office365Sync        Office365Sync      ;
		private GoogleApps           GoogleApps         ;
		private ExchangeUtils        ExchangeUtils      ;
		private IBackgroundTaskQueue taskQueue          ;

		public RestController(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, EmailUtils EmailUtils, MimeUtils MimeUtils, ActiveDirectory ActiveDirectory, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, Office365Sync Office365Sync, GoogleApps GoogleApps, ExchangeUtils ExchangeUtils, IBackgroundTaskQueue taskQueue)
		{
			this.Context             = this.HttpContext   ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.EmailUtils          = EmailUtils         ;
			this.MimeUtils           = MimeUtils          ;
			this.ActiveDirectory     = ActiveDirectory    ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
			this.Modules             = Modules            ;
			this.NoteAttachments     = NoteAttachments    ;
			this.Office365Sync       = Office365Sync      ;
			this.GoogleApps          = GoogleApps         ;
			this.ExchangeUtils       = ExchangeUtils      ;
			this.taskQueue           = taskQueue          ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string SendTestMessage([FromBody] Dictionary<string, object> dict)
		{
			string sFROM_ADDR         = Sql.ToString (Application["CONFIG.from_addr"        ]);
			string sFROM_NAME         = Sql.ToString (Application["CONFIG.from_name"        ]);
			string sMAIL_SENDTYPE     = Sql.ToString (Application["CONFIG.mail_sendtype"    ]);
			string sMAIL_SMTPUSER     = Sql.ToString (Application["CONFIG.mail_smtpuser"    ]);
			string sMAIL_SMTPPASS     = Sql.ToString (Application["CONFIG.mail_smtppass"    ]);
			string sMAIL_SMTPSERVER   = Sql.ToString (Application["CONFIG.mail_smtpserver"  ]);
			int    nMAIL_SMTPPORT     = Sql.ToInteger(Application["CONFIG.mail_smtpport"    ]);
			bool   bMAIL_SMTPAUTH_REQ = Sql.ToBoolean(Application["CONFIG.mail_smtpauth_req"]);
			bool   bMAIL_SMTPSSL      = Sql.ToBoolean(Application["CONFIG.mail_smtpssl"     ]);
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "from_addr"        :  sFROM_ADDR         = Sql.ToString (dict[sColumnName]);  break;
					case "from_name"        :  sFROM_NAME         = Sql.ToString (dict[sColumnName]);  break;
					case "mail_sendtype"    :  sMAIL_SENDTYPE     = Sql.ToString (dict[sColumnName]);  break;
					case "mail_smtpuser"    :  sMAIL_SMTPUSER     = Sql.ToString (dict[sColumnName]);  break;
					case "mail_smtppass"    :  sMAIL_SMTPPASS     = Sql.ToString (dict[sColumnName]);  break;
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

			string sENCRYPTED_EMAIL_PASSWORD = String.Empty;
			Guid gINBOUND_EMAIL_KEY = Sql.ToGuid(Application["CONFIG.InboundEmailKey"]);
			Guid gINBOUND_EMAIL_IV  = Sql.ToGuid(Application["CONFIG.InboundEmailIV" ]);
			if ( Sql.IsEmptyString(sMAIL_SMTPPASS) || sMAIL_SMTPPASS == Sql.sEMPTY_PASSWORD )
			{
				sENCRYPTED_EMAIL_PASSWORD = Sql.ToString(Application["CONFIG.smtppass"]);
			}
			else if ( !Sql.IsEmptyString(sMAIL_SMTPPASS) )
			{
				sENCRYPTED_EMAIL_PASSWORD = Security.EncryptPassword(sMAIL_SMTPPASS, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
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
			else
			{
				throw(new Exception(sMAIL_SENDTYPE + " is not supported in this area."));
			}
			return sStatus;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string GoogleApps_Authorize([FromBody] Dictionary<string, object> dict)
		{
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
			if ( Security.AdminUserAccess("EmailMan", "edit") >= 0 )
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
					string sUserID = Security.USER_ID.ToString();
					// 09/25/2015 Paul.  Redirect URL must match those allowed in Google Developer Console. https://console.developers.google.com/project/_/apiui/credential
					/*Google.Apis.Auth.OAuth2.Responses.TokenResponse*/var token = flow.ExchangeCodeForTokenAsync(sUserID, sCode, sRedirectURL, CancellationToken.None).Result;
					// 02/03/2017 Paul.  IE11 is getting stuck due to Protected Mode for Security / Internet service. window.opener === undefined after return from Google URL. 
					string OAUTH_ACCESS_TOKEN      = token.AccessToken           ;
					string sTokenType              = token.TokenType             ;
					string OAUTH_REFRESH_TOKEN     = token.RefreshToken          ;
					string OAUTH_EXPIRES_IN        = token.ExpiresInSeconds.Value.ToString();

					DateTime dtOAUTH_EXPIRES_AT = DateTime.Now.AddSeconds(Sql.ToInteger(OAUTH_EXPIRES_IN));
					SqlProcs.spOAUTH_TOKENS_Update(EmailUtils.CAMPAIGN_MANAGER_ID, "GoogleApps", OAUTH_ACCESS_TOKEN, String.Empty, dtOAUTH_EXPIRES_AT, OAUTH_REFRESH_TOKEN);
					Application["CONFIG.GoogleApps." + EmailUtils.CAMPAIGN_MANAGER_ID.ToString() + ".OAuthAccessToken" ] = OAUTH_ACCESS_TOKEN;
					Application["CONFIG.GoogleApps." + EmailUtils.CAMPAIGN_MANAGER_ID.ToString() + ".OAuthRefreshToken"] = OAUTH_REFRESH_TOKEN;
					Application["CONFIG.GoogleApps." + EmailUtils.CAMPAIGN_MANAGER_ID.ToString() + ".OAuthExpiresAt"   ] = dtOAUTH_EXPIRES_AT.ToShortDateString() + " " + dtOAUTH_EXPIRES_AT.ToShortTimeString();
					// 01/19/2017 Paul.  We want an OUTBOUND_EMAILS mapping to the office365 OAuth record. 
					// 02/04/2017 Paul.  OutboundEmail NAME will be system when Gmail is the primary send type.  Otherwise this is just an older-style GoogleApps sync. 
					Guid gOUTBOUND_EMAIL_ID = Guid.Empty;
					SqlProcs.spOUTBOUND_EMAILS_Update(ref gOUTBOUND_EMAIL_ID, "system", "system-override", EmailUtils.CAMPAIGN_MANAGER_ID, "GoogleApps", null, null, 0, null, null, false, 0, null, null, Guid.Empty, null);
					//lblGoogleAuthorizedStatus.Text = L10n.Term("OAuth.LBL_TEST_SUCCESSFUL");
					//btnGoogleAppsAuthorize   .Visible = false;
					//btnGoogleAppsDelete      .Visible = true ;
					//btnGoogleAppsTest        .Visible = true ;
					//btnGoogleAppsRefreshToken.Visible = true && bDebug;
					//lblGoogleAppsAuthorized  .Visible = true ;
					// 02/09/2017 Paul.  Update the email address. 
					StringBuilder sbErrors = new StringBuilder();
					// 07/14/2020 Paul.  If email not accessible, just ignore as we have a valid token. 
					sEMAIL1 = GoogleApps.GetEmailAddress(EmailUtils.CAMPAIGN_MANAGER_ID, sbErrors);
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
			if ( Security.AdminUserAccess("EmailMan", "edit") >= 0 )
			{
				SqlProcs.spOAUTH_TOKENS_Delete(EmailUtils.CAMPAIGN_MANAGER_ID, "GoogleApps");
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
			string sStatus = String.Empty;
			if ( Security.AdminUserAccess("EmailMan", "edit") >= 0 )
			{
				StringBuilder sbErrors = new StringBuilder();
				GoogleApps.TestAccessToken(EmailUtils.CAMPAIGN_MANAGER_ID, sbErrors);
				sStatus = sbErrors.ToString();
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
			if ( Security.AdminUserAccess("EmailMan", "edit") >= 0 )
			{
				GoogleApps.RefreshAccessToken(EmailUtils.CAMPAIGN_MANAGER_ID, true);
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
			if ( Security.AdminUserAccess("EmailMan", "edit") >= 0 )
			{
				if ( !Sql.IsEmptyString(sCode) )
				{
					string sOAuthClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
					string sOAuthClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
					// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
					string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
					// 11/09/2019 Paul.  Pass the RedirectURL so that we can call from the React client. 
					Office365AccessToken token = Office365Sync.Office365AcquireAccessToken(Request, sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, EmailUtils.CAMPAIGN_MANAGER_ID, sCode, sRedirectURL);
					// 01/19/2017 Paul.  We want an OUTBOUND_EMAILS mapping to the office365 OAuth record. 
					// 02/04/2017 Paul.  OutboundEmail NAME is "system" as it will be the primary email for the user. 
					Guid gOUTBOUND_EMAIL_ID = Guid.Empty;
					SqlProcs.spOUTBOUND_EMAILS_Update(ref gOUTBOUND_EMAIL_ID, "system", "system-override", EmailUtils.CAMPAIGN_MANAGER_ID, "Office365", null, null, 0, null, null, false, 0, null, null, Guid.Empty, null);
					
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
			if ( Security.AdminUserAccess("EmailMan", "edit") >= 0 )
			{
				SqlProcs.spOAUTH_TOKENS_Delete(EmailUtils.CAMPAIGN_MANAGER_ID, "Office365");
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
			string sFROM_ADDR = Sql.ToString(Application["CONFIG.fromaddress"]);
			string sFROM_NAME = Sql.ToString(Application["CONFIG.fromname"  ]);
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "fromname"   :  sFROM_NAME = Sql.ToString (dict[sColumnName]);  break;
					case "fromaddress":  sFROM_ADDR = Sql.ToString (dict[sColumnName]);  break;
				}
			}
			if ( Sql.IsEmptyString(sFROM_NAME) )
				sFROM_NAME = Sql.ToString(Application["CONFIG.fromname"  ]);
			if ( Sql.IsEmptyString(sFROM_ADDR) )
				sFROM_ADDR = Sql.ToString(Application["CONFIG.fromaddress"]);

			string sStatus = String.Empty;
			if ( Security.AdminUserAccess("EmailMain", "edit") >= 0 )
			{
				StringBuilder sbErrors = new StringBuilder();
				string sOAuthClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
				string sOAuthClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365Sync.Office365TestAccessToken(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, EmailUtils.CAMPAIGN_MANAGER_ID, sbErrors);

				// 12/13/2020 Paul.  Move Office365 methods to Office365utils. 
				Office365Utils Office365Utils = new Office365Utils(Session, Security, Sql, SqlProcs, SplendidError, MimeUtils, ActiveDirectory, SyncError, NoteAttachments, Office365Sync);
				Office365Utils.SendTestMessage(EmailUtils.CAMPAIGN_MANAGER_ID, sFROM_ADDR, sFROM_NAME, sFROM_ADDR, sFROM_NAME);
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
			string sEMAIL1 = String.Empty;
			if ( Security.AdminUserAccess("EmailMan", "edit") >= 0 )
			{
				string sOAuthClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
				string sOAuthClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, EmailUtils.CAMPAIGN_MANAGER_ID, true);
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetStatus()
		{
			if ( Security.AdminUserAccess("EmailMan", "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			
			string sMAIL_SENDTYPE = Sql.ToString(Application["CONFIG.mail_sendtype"]);
			bool bOFFICE365_OAUTH_ENABLED  = sMAIL_SENDTYPE == "Office365"  && !Sql.IsEmptyString(Application["CONFIG.Office365." + EmailUtils.CAMPAIGN_MANAGER_ID.ToString() + ".OAuthAccessToken" ]);
			bool bGOOGLEAPPS_OAUTH_ENABLED = sMAIL_SENDTYPE == "GoogleApps" && !Sql.IsEmptyString(Application["CONFIG.GoogleApps." + EmailUtils.CAMPAIGN_MANAGER_ID.ToString() + ".OAuthAccessToken" ]);

			Dictionary<string, object> dict = new Dictionary<string, object>();
			dict.Add("OFFICE365_OAUTH_ENABLED" , bOFFICE365_OAUTH_ENABLED );
			dict.Add("GOOGLEAPPS_OAUTH_ENABLED", bGOOGLEAPPS_OAUTH_ENABLED);
			return dict;
		}

		[HttpPost("[action]")]
		public void SendQueued([FromBody] Dictionary<string, object> dict)
		{
			if ( Security.AdminUserAccess("EmailMan", "edit") >= 0 )
			{
				// 12/20/2007 Paul.  Send all queued emails, regardless of send date. 
				// 02/22/2015 Paul.  SendQueued can timeout, so wrap in a background thread. 
#if DEBUG
				EmailUtils.SendQueued(Guid.Empty, Guid.Empty, true);
#else
				EmailUtils.CampaignModule campaign = new EmailUtils.CampaignModule(EmailUtils);
				taskQueue.QueueBackgroundWorkItemAsync(campaign.QueueStart);
				throw(new Exception(L10n.Term("Campaigns.LBL_SENDING_IN_BACKGROUND")));
#endif
			}
			else
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
		}

	}
}
