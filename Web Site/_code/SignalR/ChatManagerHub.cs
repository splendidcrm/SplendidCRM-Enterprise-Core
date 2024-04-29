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
using DocumentFormat.OpenXml.Wordprocessing;

namespace SplendidCRM
{
	public interface IChatServer
	{
		string JoinGroup(string sConnectionId, string sGroupName);
	}

	public interface IChatClient
	{
		void newMessage(Guid gCHAT_CHANNEL_ID, Guid gID, string sNAME, string sDESCRIPTION, string sDATE_ENTERED, Guid gPARENT_ID, string sPARENT_TYPE, string sPARENT_NAME, Guid gCREATED_BY_ID, string sCREATED_BY, string sCREATED_BY_PICTURE, Guid gNOTE_ATTACHMENT_ID, string sFILENAME, string sFILE_EXT, string sFILE_MIME_TYPE, long lFILE_SIZE, bool bATTACHMENT_READY);
	}

	/// <summary>
	/// Summary description for ChatManagerHub.
	/// </summary>
	public class ChatManagerHub : Hub<IChatServer>
	{
		private ChatManager _chatManager;

		public ChatManagerHub(ChatManager chatManager)
		{
			this._chatManager = chatManager;
		}

		public async Task<string> JoinGroup(string sGroupName)
		{
			if ( !Sql.IsEmptyString(sGroupName) )
			{
				string[] arrTracks = sGroupName.Split(',');
				foreach ( string sTrack in arrTracks )
				{
					await Groups.AddToGroupAsync(Context.ConnectionId, sTrack);
				}
				return Context.ConnectionId + " joined " + sGroupName;
			}
			return "Group not specified.";
		}
	}
}

