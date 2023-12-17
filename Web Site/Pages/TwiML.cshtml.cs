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
using System.Threading.Tasks;
using System.Collections.Specialized;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;

namespace SplendidCRM.Pages
{
	[IgnoreAntiforgeryToken]
	public class TwiMLModel : PageModel
	{
		private HttpContext          Context            ;
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCRM.Crm.Modules          Modules          ;
		private TwilioManager        TwilioManager      ;

		public TwiMLModel(IHttpContextAccessor httpContextAccessor, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCRM.Crm.Modules Modules, TwilioManager TwilioManager)
		{
			this.Context             = httpContextAccessor.HttpContext;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.Modules             = Modules            ;
			this.TwilioManager       = TwilioManager      ;
		}

		public async Task OnGetAsync()
		{
#if DEBUG
			Debug.WriteLine("TwiML.QueryString: " + Request.QueryString);
#endif
			try
			{
				Guid   gID          = Sql.ToGuid  (Request.Query["ID"         ]);
				string sAccountSid  = Sql.ToString(Request.Query["AccountSid" ]);
				string sSmsStatus   = Sql.ToString(Request.Query["SmsStatus"  ]);
				string sApiVersion  = Sql.ToString(Request.Query["ApiVersion" ]);
				string sSUBJECT     = Sql.ToString(Request.Query["Body"       ]);
				string sMESSAGE_SID = Sql.ToString(Request.Query["SmsSid"     ]);
				string sTO_NUMBER   = Sql.ToString(Request.Query["To"         ]);
				string sFROM_NUMBER = Sql.ToString(Request.Query["From"       ]);
				// 09/29/2013 Paul.  Received messages have more data. 
				string sToCity      = Sql.ToString(Request.Query["ToCity"     ]);
				string sToState     = Sql.ToString(Request.Query["ToState"    ]);
				string sToZip       = Sql.ToString(Request.Query["ToZip"      ]);
				string sToCountry   = Sql.ToString(Request.Query["ToCountry"  ]);
				string sFromCity    = Sql.ToString(Request.Query["FromCity"   ]);
				string sFromState   = Sql.ToString(Request.Query["FromState"  ]);
				string sFromZip     = Sql.ToString(Request.Query["FromZip"    ]);
				string sFromCountry = Sql.ToString(Request.Query["FromCountry"]);

				// 09/26/2013 Paul.  In order to ensure the integrity of the post, the submitted ID must match the configuration value. 
				if ( sAccountSid == Sql.ToString(Application["CONFIG.Twilio.AccountSID"]) )
				{
					if ( !Sql.IsEmptyGuid(gID) )
					{
						SqlProcs.spSMS_MESSAGES_UpdateStatus(gID, sSmsStatus, sMESSAGE_SID);
					}
					else if ( sSmsStatus == "received" )
					{
						// 11/27/2022 Paul.  If SignalR is disabled, we need to manually initialize twilio manager. 
						await TwilioManager.NewSmsMessage(sMESSAGE_SID, sFROM_NUMBER, sTO_NUMBER, sSUBJECT, String.Empty, String.Empty);
					}
				}
				else
				{
					var requestFeature = Context.Features.Get<IHttpRequestFeature>();
					SplendidError.SystemWarning(new StackTrace(true).GetFrame(0), "Unknown Twilio event: " + requestFeature.RawTarget);
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
			}
		}

		public async Task<IActionResult> OnPostAsync()
		{
			string sFormBody = String.Empty;
			if ( Request.Method == "POST" )
			{
				// AccountSid=ACd956f8185bce3b8c1178ff2b23459197&SmsStatus=sent&Body=Sent+from+your+Twilio+trial+account+-+PayTrace+logo&SmsSid=SMc6f69d092635f5e83adb39869d303aae&To=%2B19196041258&From=%2B19032252332&ApiVersion=2010-04-01
				using ( StreamReader rdr = new StreamReader(Request.Body) )
				{
					sFormBody = await rdr.ReadToEndAsync();
				}
			}
#if DEBUG
			if ( !Sql.IsEmptyString(sFormBody) )
				Debug.WriteLine("TwiML.Body: " + sFormBody);
#endif
			try
			{
				NameValueCollection parameters = System.Web.HttpUtility.ParseQueryString(sFormBody);
				Guid   gID          = Sql.ToGuid  (parameters["ID"         ]);
				string sAccountSid  = Sql.ToString(parameters["AccountSid" ]);
				string sSmsStatus   = Sql.ToString(parameters["SmsStatus"  ]);
				string sApiVersion  = Sql.ToString(parameters["ApiVersion" ]);
				string sSUBJECT     = Sql.ToString(parameters["Body"       ]);
				string sMESSAGE_SID = Sql.ToString(parameters["SmsSid"     ]);
				string sTO_NUMBER   = Sql.ToString(parameters["To"         ]);
				string sFROM_NUMBER = Sql.ToString(parameters["From"       ]);
				// 09/29/2013 Paul.  Received messages have more data. 
				string sToCity      = Sql.ToString(parameters["ToCity"     ]);
				string sToState     = Sql.ToString(parameters["ToState"    ]);
				string sToZip       = Sql.ToString(parameters["ToZip"      ]);
				string sToCountry   = Sql.ToString(parameters["ToCountry"  ]);
				string sFromCity    = Sql.ToString(parameters["FromCity"   ]);
				string sFromState   = Sql.ToString(parameters["FromState"  ]);
				string sFromZip     = Sql.ToString(parameters["FromZip"    ]);
				string sFromCountry = Sql.ToString(parameters["FromCountry"]);

				// 09/26/2013 Paul.  In order to ensure the integrity of the post, the submitted ID must match the configuration value. 
				if ( sAccountSid == Sql.ToString(Application["CONFIG.Twilio.AccountSID"]) )
				{
					if ( !Sql.IsEmptyGuid(gID) )
					{
						SqlProcs.spSMS_MESSAGES_UpdateStatus(gID, sSmsStatus, sMESSAGE_SID);
					}
					else if ( sSmsStatus == "received" )
					{
						// 11/27/2022 Paul.  If SignalR is disabled, we need to manually initialize twilio manager. 
						await TwilioManager.NewSmsMessage(sMESSAGE_SID, sFROM_NUMBER, sTO_NUMBER, sSUBJECT, String.Empty, String.Empty);
					}
				}
				else
				{
					var requestFeature = Context.Features.Get<IHttpRequestFeature>();
					SplendidError.SystemWarning(new StackTrace(true).GetFrame(0), "Unknown Twilio event: " + requestFeature.RawTarget + ControlChars.CrLf + sFormBody);
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
			}
			return Page();
		}
	}
}
