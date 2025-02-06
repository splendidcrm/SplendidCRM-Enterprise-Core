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
// 3. Scripts. 
import Sql            from '../scripts/Sql'          ;
import { Crm_Config } from '../scripts/Crm'          ;

export class AsteriskServerCore
{
	// 01/15/2024 Paul.  Updated history package. 
	history            : H.History;
	hub                : signalR.HubConnection;
	started            : boolean;
	sUSER_EXTENSION    : string;

	constructor(history: H.History, hub: signalR.HubConnection, sUSER_EXTENSION: string)
	{
		this.history             = history            ;
		this.hub                 = hub                ;
		this.sUSER_EXTENSION     = sUSER_EXTENSION    ;
	}

	public static enabled()
	{
		let bAsteriskEnabled: boolean = !Sql.IsEmptyString(Crm_Config.ToString('Asterisk.Host'));
		return bAsteriskEnabled;
	}

	public shouldJoin(): boolean
	{
		if ( AsteriskServerCore.enabled() && !Sql.IsEmptyString(this.sUSER_EXTENSION) )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldJoin', sUSER_EXTENSION);
			return true;
		}
		return false;
	}

	public joinGroup()
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.joinGroup', this.sUSER_EXTENSION);
		this.hub.invoke('JoinGroup', this.sUSER_EXTENSION).then( (data: string) =>
		{
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.joinGroup', data);
		});
	}

	public createCall(sUniqueId: string)
	{
		return this.hub.invoke("CreateCall", sUniqueId);
	}

	public originateCall(sUSER_EXTENSION: string, sUSER_FULL_NAME: string, sUSER_PHONE_WORK: string, sPHONE: string, sPARENT_ID: string, sPARENT_TYPE: string)
	{
		return this.hub.invoke("OriginateCall", sUSER_EXTENSION, sUSER_FULL_NAME, sUSER_PHONE_WORK, sPHONE, sPARENT_ID, sPARENT_TYPE);
	}

	public shutdown()
	{
		if ( this.started )
		{
			this.hub.off('newState'          );
			this.hub.off('outgoingCall'      );
			this.hub.off('incomingCall'      );
			this.hub.off('outgoingComplete'  );
			this.hub.off('incomingComplete'  );
			this.hub.off('outgoingIncomplete');
			this.hub.off('incomingIncomplete');
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
		this.hub.on('newState', (Status) =>
		{
			let oCommandArguments: any = { Status };
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.newState', oCommandArguments);
		});
		this.hub.on('outgoingCall', (UniqueId, ConnectedLineName, CallerID, CALL_ID) =>
		{
			let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID };
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.outgoingCall', oCommandArguments);
		});
		this.hub.on('incomingCall', (UniqueId, ConnectedLineName, CallerID, CALL_ID) =>
		{
			let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID };
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.incomingCall', oCommandArguments);
		});
		this.hub.on('outgoingComplete', (UniqueId, ConnectedLineName, CallerID, CALL_ID, DURATION_HOURS, DURATION_MINUTES) =>
		{
			let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID, DURATION_HOURS, DURATION_MINUTES };
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.outgoingComplete', oCommandArguments);
		});
		this.hub.on('incomingComplete', (UniqueId, ConnectedLineName, CallerID, CALL_ID, DURATION_HOURS, DURATION_MINUTES) =>
		{
			let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID, DURATION_HOURS, DURATION_MINUTES };
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.incomingComplete', oCommandArguments);
		});
		this.hub.on('outgoingIncomplete', (UniqueId, ConnectedLineName, CallerID, CALL_ID, Error) =>
		{
			let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID, Error };
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.outgoingIncomplete', oCommandArguments);
		});
		this.hub.on('incomingIncomplete', (UniqueId, ConnectedLineName, CallerID, CALL_ID) =>
		{
			let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID };
			console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.incomingIncomplete', oCommandArguments);
		});

		this.hub.start()
		.catch( (e) =>
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.start', e);
		})
		.then( () =>
		{
			// 12/01/2024 Paul.  Set started flag. 
			this.started = true;
			console.log('AsteriskHub connection started');
			this.joinGroup();
		});
	}
}

export function AsteriskCreateHub(history: H.History, sUSER_EXTENSION: string): AsteriskServerCore
{
	const hub: signalR.HubConnection = new signalR.HubConnectionBuilder()
		.withUrl("/signalr_asteriskhub")
		//.configureLogging(signalR.LogLevel.Debug)  // https://learn.microsoft.com/en-us/aspnet/core/signalr/diagnostics?view=aspnetcore-5.0
		.withAutomaticReconnect()
		.build();
	let manager: AsteriskServerCore = new AsteriskServerCore(history, hub, sUSER_EXTENSION);
	if ( manager.shouldJoin() )
	{
		manager.startup();
	}
	return manager;
}

