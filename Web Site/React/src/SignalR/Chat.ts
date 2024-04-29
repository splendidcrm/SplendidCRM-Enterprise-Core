/*
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 */

// 1. React and fabric. 
import * as H         from 'history'                 ;
// 2. Store and Types. 
import MODULE         from '../types/MODULE'         ;
// 3. Scripts. 
import Sql            from '../scripts/Sql'          ;
import SplendidCache  from '../scripts/SplendidCache';

const hubName = 'ChatManagerHub';

export interface ChatMessageProps
{
	CHAT_CHANNEL_ID     : string;
	ID                  : string;
	NAME                : string;
	DESCRIPTION         : string;
	DATE_ENTERED        : string;
	PARENT_ID           : string;
	PARENT_TYPE         : string;
	PARENT_NAME         : string;
	CREATED_BY_ID       : string;
	CREATED_BY          : string;
	CREATED_BY_PICTURE  : string;
	NOTE_ATTACHMENT_ID  : string;
	FILENAME            : string;
	FILE_EXT            : string;
	FILE_MIME_TYPE      : string;
	FILE_SIZE           : string;
	ATTACHMENT_READY    : number;
};

export class ChatServer
{
	chatManager: SignalR.Hub.Proxy;

	constructor(chatManager: SignalR.Hub.Proxy)
	{
		this.chatManager = chatManager;
	}

	public static enabled()
	{
		let module:MODULE = SplendidCache.Module('ChatDashboard', this.constructor.name + '.enabled');
		return true;
	}

	public shouldJoin(sUSER_CHAT_CHANNELS: string): boolean
	{
		if ( ChatServer.enabled() && !Sql.IsEmptyString(sUSER_CHAT_CHANNELS) )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldJoin', sUSER_CHAT_CHANNELS);
			return true;
		}
		return false;
	}

	public joinGroup(sConnectionId: string, sGroupName: string)
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.joinGroup', sGroupName);
		/// <summary>Calls the JoinGroup method on the server-side PhoneBurnerManagerHub hub.&#10;Returns a jQuery.Deferred() promise.</summary>
		/// <param name=\"sConnectionId\" type=\"String\">Server side type is System.String</param>
		/// <param name=\"sGroupName\" type=\"String\">Server side type is System.String</param>
		return this.chatManager.invoke.apply(this.chatManager, $.merge(["JoinGroup"], $.makeArray(arguments)));
	}
}

// 01/15/2024 Paul.  Update History. 
export function ChatCreateHub(signalR: SignalR, history: H.History)
{
	let manager: any = signalR.hub.createHubProxy(hubName);
	manager.server = new ChatServer(manager);
	manager.Shutdown = function()
	{
		if ( manager.hasSubscriptions() )
		{
			manager.off('newMessage');
		}
	};
	// 04/27/2024 Paul.  SignalR core does not support more than 10 parameters, so convert to dictionary. 
	// This code is just for debugging.  real events occur in ChatDashboardView.tsx. 
	manager.on('newMessage', (oCommandArguments: ChatMessageProps) =>
	{
		//console.log((new Date()).toISOString() + ' ' + hubName + '.newMessage', oCommandArguments);
		//if ( this.history != null )
		//{
		//	history.push('/Reset/ChatDashboard/' + CHAT_CHANNEL_ID);
		//}
	});
	return manager;
}

