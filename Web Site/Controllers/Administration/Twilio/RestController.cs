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
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Administration.Twilio
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/Twilio/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "Twilio";
		private HttpApplicationState Application        = new HttpApplicationState();
		private Security             Security           ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;

		public RestController(HttpSessionState Session, Security Security, SplendidError SplendidError)
		{
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Security            = Security           ;
			this.SplendidError       = SplendidError      ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Test([FromBody] Dictionary<string, object> dict)
		{
			string sResult = String.Empty;
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				string sACCOUNT_SID = String.Empty;
				string sAUTH_TOKEN  = String.Empty;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "Twilio.AccountSID":  sACCOUNT_SID = Sql.ToString (dict[sKey]);  break;
						case "Twilio.AuthToken" :  sAUTH_TOKEN  = Sql.ToString (dict[sKey]);  break;
					}
				}
				// 03/10/2021 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
				if ( Sql.IsEmptyString(sACCOUNT_SID) || sACCOUNT_SID == Sql.sEMPTY_PASSWORD )
				{
					sACCOUNT_SID = Sql.ToString(Application["CONFIG.Twilio.AccountSID"]);
				}
				if ( Sql.IsEmptyString(sAUTH_TOKEN) || sAUTH_TOKEN == Sql.sEMPTY_PASSWORD )
				{
					sAUTH_TOKEN = Sql.ToString(Application["CONFIG.Twilio.AuthToken"]);
				}
				sResult = TwilioManager.ValidateLogin(Application, sACCOUNT_SID, sAUTH_TOKEN);
				if ( Sql.IsEmptyString(sResult) )
				{
					sResult = L10n.Term("Twilio.LBL_TEST_SUCCESSFUL");
				}
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sResult = ex.Message;
			}
			return sResult;
		}

	}
}
