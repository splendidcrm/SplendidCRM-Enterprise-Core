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
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Administration.CurrencyLayer
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	//[Route("[controller]")]
	[Route("Administration/CurrencyLayer/Rest.svc")]
	//[Route("Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "CurrencyLayer";

		private HttpApplicationState Application        = new HttpApplicationState();
		private Security             Security           ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private CurrencyUtils        CurrencyUtils      ;

		public RestController(HttpSessionState Session, Security Security, SplendidError SplendidError, CurrencyUtils CurrencyUtils)
		{
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.SplendidError       = SplendidError      ;
			this.CurrencyUtils       = CurrencyUtils      ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Test([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if ( Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				string sACCESS_KEY = String.Empty;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "CurrencyLayer.AccessKey" :  sACCESS_KEY = Sql.ToString (dict[sKey]);  break;
					}
				}
				// 03/10/2021 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
				if ( Sql.IsEmptyString(sACCESS_KEY) || sACCESS_KEY == Sql.sEMPTY_PASSWORD )
				{
					sACCESS_KEY = Sql.ToString(Application["CONFIG.CurrencyLayer.AccessKey"]);
				}
				CurrencyUtils.GetCurrencyConversionRate(sACCESS_KEY, false, "USD", "EUR", sbErrors);
				if ( sbErrors.Length == 0 )
				{
					sbErrors.Append(L10n.Term("CurrencyLayer.LBL_TEST_SUCCESSFUL"));
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

		[HttpPost("[action]")]
		public void UpdateRate(string ISO4217)
		{
			try
			{
				if ( Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				if ( !Sql.IsEmptyString(Application["CONFIG.CurrencyLayer.AccessKey"]) )
				{
					StringBuilder sbErrors = new StringBuilder();
					float dRate = CurrencyUtils.GetCurrencyConversionRate(ISO4217, sbErrors);
				}
				else
				{
					throw(new Exception(L10n.Term("CurrencyLayer is not enabled, missing Access Key.")));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw(new Exception(ex.Message));
			}
		}

	}
}
