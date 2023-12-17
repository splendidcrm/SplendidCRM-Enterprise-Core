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
using System.Web;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;

using Google.Apis.Auth.OAuth2.Responses;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Authorization;

using SplendidCRM;

namespace SplendidCRM.Controllers.Administration.Google
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/Google/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "Google";
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private GoogleApps           GoogleApps         ;

		public RestController(HttpSessionState Session, Security Security, SplendidError SplendidError, GoogleApps GoogleApps)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = new Sql(Session, Security);
			this.SplendidError       = SplendidError      ;
			this.GoogleApps          = GoogleApps         ;
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
				/*
				bool   bENABLED               = false;
				bool   bVERBOSE_STATUS        = false;
				string sAPI_KEY               = String.Empty;
				string sOAUTH_CLIENT_ID       = String.Empty;
				string sOAUTH_CLIENT_SECRET   = String.Empty;
				bool   bPUSH_NOTIFICATIONS    = false;
				string sPUSH_NOTIFICATION_URL = String.Empty;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "GoogleApps.Enabled"            :  bENABLED               = Sql.ToBoolean(dict[sKey]);  break;
						case "GoogleApps.VerboseStatus"      :  bVERBOSE_STATUS        = Sql.ToBoolean(dict[sKey]);  break;
						case "GoogleApps.ApiKey"             :  sAPI_KEY               = Sql.ToString (dict[sKey]);  break;
						case "GoogleApps.ClientID"           :  sOAUTH_CLIENT_ID       = Sql.ToString (dict[sKey]);  break;
						case "GoogleApps.ClientSecret"       :  sOAUTH_CLIENT_SECRET   = Sql.ToString (dict[sKey]);  break;
						case "GoogleApps.PushNotifications"  :  bPUSH_NOTIFICATIONS    = Sql.ToBoolean(dict[sKey]);  break;
						case "GoogleApps.PushNotificationURL":  sPUSH_NOTIFICATION_URL = Sql.ToString (dict[sKey]);  break;
					}
				}
				if ( Sql.IsEmptyString(sAPI_KEY) || sAPI_KEY == Sql.sEMPTY_PASSWORD )
				{
					sAPI_KEY = Sql.ToString(Application["CONFIG.GoogleApps.ApiKey"]);
				}
				if ( Sql.IsEmptyString(sOAUTH_CLIENT_ID) || sOAUTH_CLIENT_ID == Sql.sEMPTY_PASSWORD )
				{
					sOAUTH_CLIENT_ID = Sql.ToString(Application["CONFIG.GoogleApps.ClientID"]);
				}
				if ( Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) || sOAUTH_CLIENT_SECRET == Sql.sEMPTY_PASSWORD )
				{
					sOAUTH_CLIENT_SECRET = Sql.ToString(Application["CONFIG.GoogleApps.ClientSecret"]);
				}
				*/
				bool bValid = GoogleApps.TestAccessToken(Security.USER_ID, sbErrors);
				if ( bValid )
					sbErrors.Append(L10n.Term("Google.LBL_TEST_SUCCESSFUL"));
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
		public TokenResponse RefreshToken()
		{
			TokenResponse token = null;
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				token = GoogleApps.RefreshAccessToken(Security.USER_ID, true);
				sbErrors.Append(L10n.Term("Google.LBL_TEST_SUCCESSFUL"));
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw(new Exception(ex.Message));
			}
			return token;
		}
	}
}
