/*
 * Copyright (C) 2019-2020 SplendidCRM Software, Inc. All Rights Reserved. 
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
using System.Net;
using System.Web;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Administration.Marketo
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/Marketo/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "Marketo";
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private Spring.Social.Marketo.MarketoSync MarketoSync;
		private IBackgroundTaskQueue taskQueue          ;

		public RestController(HttpSessionState Session, Security Security, SplendidError SplendidError, Spring.Social.Marketo.MarketoSync MarketoSync, IBackgroundTaskQueue taskQueue)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = new Sql(Session, Security);
			this.SplendidError       = SplendidError      ;
			this.MarketoSync         = MarketoSync        ;
			this.taskQueue           = taskQueue          ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Test([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				string sOAUTH_ENDPOINT_URL   = String.Empty;
				string sOAUTH_IDENTITY_URL   = String.Empty;
				string sOAUTH_CLIENT_ID      = String.Empty;
				string sOAUTH_CLIENT_SECRET  = String.Empty;
				string sOAUTH_ACCESS_TOKEN   = String.Empty;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "Marketo.EndpointURL"     :  sOAUTH_ENDPOINT_URL  = Sql.ToString (dict[sKey]);  break;
						case "Marketo.IdentityURL"     :  sOAUTH_IDENTITY_URL  = Sql.ToString (dict[sKey]);  break;
						case "Marketo.ClientID"        :  sOAUTH_CLIENT_ID     = Sql.ToString (dict[sKey]);  break;
						case "Marketo.ClientSecret"    :  sOAUTH_CLIENT_SECRET = Sql.ToString (dict[sKey]);  break;
						case "Marketo.OAuthAccessToken":  sOAUTH_ACCESS_TOKEN  = Sql.ToString (dict[sKey]);  break;
					}
				}
				// 03/10/2021 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
				if ( Sql.IsEmptyString(sOAUTH_CLIENT_ID) || sOAUTH_CLIENT_ID == Sql.sEMPTY_PASSWORD )
				{
					sOAUTH_CLIENT_ID = Sql.ToString(Application["CONFIG.Marketo.ClientID"]);
				}
				if ( Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) || sOAUTH_CLIENT_SECRET == Sql.sEMPTY_PASSWORD )
				{
					sOAUTH_CLIENT_SECRET = Sql.ToString(Application["CONFIG.Marketo.ClientSecret"]);
				}
				if ( Sql.IsEmptyString(sOAUTH_ACCESS_TOKEN) || sOAUTH_ACCESS_TOKEN == Sql.sEMPTY_PASSWORD )
				{
					sOAUTH_ACCESS_TOKEN = Sql.ToString(Application["CONFIG.Marketo.OAuthAccessToken"]);
				}
				MarketoSync.ValidateMarketo(sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, sOAUTH_ENDPOINT_URL, sOAUTH_IDENTITY_URL, sOAUTH_ACCESS_TOKEN, sbErrors);
				if ( sbErrors.Length == 0 )
				{
					sbErrors.Append(L10n.Term("Marketo.LBL_TEST_SUCCESSFUL"));
				}
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public async Task<string> Sync([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
#if false
				MarketoSync.Sync();
#else
				await taskQueue.QueueBackgroundWorkItemAsync(MarketoSync.Sync);
				sbErrors.Append(L10n.Term("Marketo.LBL_SYNC_BACKGROUND"));
#endif
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[HttpPost("[action]")]
		public async Task<string> SyncAll([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
#if false
				MarketoSync.SyncAll();
#else
				await taskQueue.QueueBackgroundWorkItemAsync(MarketoSync.SyncAll);
				sbErrors.Append(L10n.Term("Marketo.LBL_SYNC_BACKGROUND"));
#endif
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		public class MarketoToken
		{
			public string access_token;
			public string expires_in  ;
			public string scope       ;
		}

		[HttpPost("[action]")]
		public Dictionary<string, object> Authorize([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			MarketoToken token = new MarketoToken();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				string sOAUTH_ENDPOINT_URL   = String.Empty;
				string sOAUTH_IDENTITY_URL   = String.Empty;
				string sOAUTH_CLIENT_ID      = String.Empty;
				string sOAUTH_CLIENT_SECRET  = String.Empty;
				string sOAUTH_ACCESS_TOKEN   = String.Empty;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "Marketo.EndpointURL"     :  sOAUTH_ENDPOINT_URL  = Sql.ToString (dict[sKey]);  break;
						case "Marketo.IdentityURL"     :  sOAUTH_IDENTITY_URL  = Sql.ToString (dict[sKey]);  break;
						case "Marketo.ClientID"        :  sOAUTH_CLIENT_ID     = Sql.ToString (dict[sKey]);  break;
						case "Marketo.ClientSecret"    :  sOAUTH_CLIENT_SECRET = Sql.ToString (dict[sKey]);  break;
						case "Marketo.OAuthAccessToken":  sOAUTH_ACCESS_TOKEN  = Sql.ToString (dict[sKey]);  break;
					}
				}
				// 03/10/2021 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
				if ( Sql.IsEmptyString(sOAUTH_CLIENT_ID) || sOAUTH_CLIENT_ID == Sql.sEMPTY_PASSWORD )
				{
					sOAUTH_CLIENT_ID = Sql.ToString(Application["CONFIG.Marketo.ClientID"]);
				}
				if ( Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) || sOAUTH_CLIENT_SECRET == Sql.sEMPTY_PASSWORD )
				{
					sOAUTH_CLIENT_SECRET = Sql.ToString(Application["CONFIG.Marketo.ClientSecret"]);
				}
				if ( Sql.IsEmptyString(sOAUTH_ACCESS_TOKEN) || sOAUTH_ACCESS_TOKEN == Sql.sEMPTY_PASSWORD )
				{
					sOAUTH_ACCESS_TOKEN = Sql.ToString(Application["CONFIG.Marketo.OAuthAccessToken"]);
				}
				string sACCESS_TOKEN = String.Empty;
				string sEXPIRES_AT   = String.Empty;
				string sSCOPE        = String.Empty;
				MarketoSync.AuthorizeMarketo(sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, sOAUTH_ENDPOINT_URL, sOAUTH_IDENTITY_URL, ref sACCESS_TOKEN, ref sEXPIRES_AT, ref sSCOPE, sbErrors);
				token.access_token = sACCESS_TOKEN;
				token.expires_in   = sEXPIRES_AT  ;
				token.scope        = sSCOPE       ;
				//sbErrors.Append(L10n.Term("Marketo.LBL_AUTHORIZE_SUCCESSFUL"));
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw( new Exception(ex.Message));
			}
			Dictionary<string, object> d = new Dictionary<string, object>();
			d.Add("d", token);
			return d;
		}
	}
}
