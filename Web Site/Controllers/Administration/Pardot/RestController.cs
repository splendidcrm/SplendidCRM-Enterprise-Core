/*
 * Copyright (C) 2019-2023 SplendidCRM Software, Inc. All Rights Reserved. 
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
using Spring.Social.ConstantContact;

namespace SplendidCRM.Controllers.Administration.Pardot
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/Pardot/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "Pardot";
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private Spring.Social.Pardot.PardotSync PardotSync;
		private IBackgroundTaskQueue taskQueue          ;

		public RestController(HttpSessionState Session, Security Security, SplendidError SplendidError, Spring.Social.Pardot.PardotSync PardotSync, IBackgroundTaskQueue taskQueue)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = new Sql(Session, Security);
			this.SplendidError       = SplendidError      ;
			this.PardotSync          = PardotSync         ;
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
				
				string sAPI_USER_KEY = String.Empty;
				string sAPI_USERNAME = String.Empty;
				string sPASSWORD     = String.Empty;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "Pardot.ApiUserKey" :  sAPI_USER_KEY = Sql.ToString (dict[sKey]);  break;
						case "Pardot.ApiUsername":  sAPI_USERNAME = Sql.ToString (dict[sKey]);  break;
						case "Pardot.ApiPassword":  sPASSWORD     = Sql.ToString (dict[sKey]);  break;
					}
				}
				// 03/10/2021 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
				if ( Sql.IsEmptyString(sPASSWORD) || sPASSWORD == Sql.sEMPTY_PASSWORD )
				{
					sPASSWORD = Sql.ToString (Application["CONFIG.Pardot.ApiPassword"]);
				}
				else
				{
					Guid gCREDIT_CARD_KEY = Sql.ToGuid(Application["CONFIG.CreditCardKey"]);
					Guid gCREDIT_CARD_IV  = Sql.ToGuid(Application["CONFIG.CreditCardIV" ]);
					string sENCRYPTED_EMAIL_PASSWORD = Security.EncryptPassword(sPASSWORD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
					if ( Security.DecryptPassword(sENCRYPTED_EMAIL_PASSWORD, gCREDIT_CARD_KEY, gCREDIT_CARD_IV) != sPASSWORD )
						throw(new Exception("Decryption failed"));
					sPASSWORD = sENCRYPTED_EMAIL_PASSWORD;
				}
				PardotSync.ValidatePardot(sAPI_USER_KEY, sAPI_USERNAME, sPASSWORD, sbErrors);
				if ( sbErrors.Length == 0 )
				{
					sbErrors.Append(L10n.Term("Pardot.LBL_TEST_SUCCESSFUL"));
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

		[HttpPut("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
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
				PardotSync.Sync();
#else
				await taskQueue.QueueBackgroundWorkItemAsync(PardotSync.Sync);
				sbErrors.Append(L10n.Term("Pardot.LBL_SYNC_BACKGROUND"));
#endif
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[HttpPut("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
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
				PardotSync.SyncAll();
#else
				await taskQueue.QueueBackgroundWorkItemAsync(PardotSync.SyncAll);
				sbErrors.Append(L10n.Term("Pardot.LBL_SYNC_BACKGROUND"));
#endif
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

	}
}
