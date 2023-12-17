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
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Diagnostics;

using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Authorization;

using Twilio.Base;
using Twilio.Clients;
using Twilio.Rest.Api.V2010.Account;

namespace SplendidCRM
{
	public interface ITwilioServer
	{
		string JoinGroup(string sConnectionId, string sGroupName);
		Guid CreateSmsMessage(string sMESSAGE_SID, string sFROM_NUMBER, string sTO_NUMBER, string sSUBJECT);
	}

	public interface ITwilioClient
	{
		void incomingMessage(string sMESSAGE_SID, string sFROM_NUMBER, string sTO_NUMBER, string sSUBJECT, object sSMS_MESSAGE_ID);
	}

	/// <summary>
	/// Summary description for TwilioManagerHub.
	/// </summary>
	public class TwilioManagerHub : Hub<ITwilioServer>
	{
		private TwilioManager _twilioManager;

		public TwilioManagerHub(TwilioManager twilioManager)
		{
			this._twilioManager = twilioManager;
		}

		public async Task<string> JoinGroup(string sGroupName)
		{
			if ( !Sql.IsEmptyString(sGroupName) )
			{
				sGroupName = Utils.NormalizePhone(TwilioManager.RemoveCountryCode(sGroupName));
				await Groups.AddToGroupAsync(Context.ConnectionId, sGroupName);
				return Context.ConnectionId + " joined " + sGroupName;
			}
			return "Group not specified.";
		}

		public async Task<Guid> CreateSmsMessage(string sMESSAGE_SID, string sFROM_NUMBER, string sTO_NUMBER, string sSUBJECT)
		{
			return await _twilioManager.CreateSmsMessage(sMESSAGE_SID, sFROM_NUMBER, sTO_NUMBER, sSUBJECT, String.Empty, String.Empty);
		}
	}
}

