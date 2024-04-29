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
import * as signalR   from "@microsoft/signalr"      ;
// 2. Store and Types. 
import MODULE         from '../types/MODULE'         ;
// 3. Scripts. 
import Sql            from '../scripts/Sql'          ;
import SplendidCache  from '../scripts/SplendidCache';

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

export class ChatServerCore
{
	// 01/15/2024 Paul.  Updated history package. 
	history            : H.History;
	hub                : signalR.HubConnection;
	started            : boolean;
	sUSER_CHAT_CHANNELS: string;

	constructor(history: H.History, hub: signalR.HubConnection, sUSER_CHAT_CHANNELS: string)
	{
		this.history             = history            ;
		this.hub                 = hub                ;
		this.sUSER_CHAT_CHANNELS = sUSER_CHAT_CHANNELS;
	}

	public static enabled()
	{
		let module:MODULE = SplendidCache.Module('ChatDashboard', this.constructor.name + '.enabled');
		return true;
	}

	public shouldJoin(): boolean
	{
		if ( ChatServerCore.enabled() && !Sql.IsEmptyString(this.sUSER_CHAT_CHANNELS) )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldJoin', sUSER_CHAT_CHANNELS);
			return true;
		}
		return false;
	}

	public joinGroup()
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.joinGroup', this.sUSER_CHAT_CHANNELS);
		this.hub.invoke('JoinGroup', this.sUSER_CHAT_CHANNELS).then( (data: string) =>
		{
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.joinGroup', data);
		});
	}

	public shutdown()
	{
		if ( this.started )
		{
			this.hub.off('newMessage');
			try
			{
				this.hub.stop();
			}
			catch(e)
			{
				console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.shutdown', e);
			}
			this.started = false;
		}
	}

	public startup()
	{
		// 04/27/2024 Paul.  SignalR core does not support more than 10 parameters, so convert to dictionary. 
		// This code is just for debugging.  real events occur in ChatDashboardView.tsx. 
		this.hub.on('newMessage', (oCommandArguments: any) =>
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.newMessage', oCommandArguments);
			//if ( this.history != null )
			//{
			//	history.push('/Reset/ChatDashboard/' + CHAT_CHANNEL_ID);
			//}
		});

		this.hub.start()
		.catch( (e) =>
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.start', e);
		})
		.then( () =>
		{
			this.started = false;
			console.log('ChatHub connection started');
			this.joinGroup();
		});
	}
}

export function ChatCreateHub(history: H.History, sUSER_CHAT_CHANNELS: string): ChatServerCore
{
	const hub: signalR.HubConnection = new signalR.HubConnectionBuilder()
		.withUrl("/signalr_chathub")
		//.configureLogging(signalR.LogLevel.Debug)  // https://learn.microsoft.com/en-us/aspnet/core/signalr/diagnostics?view=aspnetcore-5.0
		.withAutomaticReconnect()
		.build();
	let manager: ChatServerCore = new ChatServerCore(history, hub, sUSER_CHAT_CHANNELS);
	if ( manager.shouldJoin() )
	{
		manager.startup();
	}
	return manager;
}

