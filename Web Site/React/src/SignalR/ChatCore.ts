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

export class ChatServerCore
{
	history            : H.History<H.LocationState>;
	hub                : signalR.HubConnection;
	started            : boolean;
	sUSER_CHAT_CHANNELS: string;

	constructor(history: H.History<H.LocationState>, hub: signalR.HubConnection, sUSER_CHAT_CHANNELS: string)
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
		this.hub.on('newMessage', (CHAT_CHANNEL_ID, ID, NAME, DESCRIPTION, DATE_ENTERED, PARENT_ID, PARENT_TYPE, PARENT_NAME, CREATED_BY_ID, CREATED_BY, CREATED_BY_PICTURE, NOTE_ATTACHMENT_ID, FILENAME, FILE_EXT, FILE_MIME_TYPE, FILE_SIZE, ATTACHMENT_READY) =>
		{
			let oCommandArguments: any = { CHAT_CHANNEL_ID, ID, NAME, DESCRIPTION, DATE_ENTERED, PARENT_ID, PARENT_TYPE, PARENT_NAME, CREATED_BY_ID, CREATED_BY, CREATED_BY_PICTURE, NOTE_ATTACHMENT_ID, FILENAME, FILE_EXT, FILE_MIME_TYPE, FILE_SIZE, ATTACHMENT_READY };
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.newMessage', oCommandArguments);
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

export function ChatCreateHub(history: H.History<H.LocationState>, sUSER_CHAT_CHANNELS: string): ChatServerCore
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

