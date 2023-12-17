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
import * as H         from 'history'       ;
// 2. Store and Types. 
// 3. Scripts. 
import Sql            from '../scripts/Sql';
import { Crm_Config } from '../scripts/Crm';

const hubName = 'AvayaManagerHub';

export class AvayaServer
{
	avayaManager: SignalR.Hub.Proxy;

	constructor(avayaManager: SignalR.Hub.Proxy)
	{
		this.avayaManager = avayaManager;
	}

	public static enabled()
	{
		let bAvayaEnabled: boolean = !Sql.IsEmptyString(Crm_Config.ToString('Avaya.Host'));
		if ( Crm_Config.ToString('service_level') == 'Professional' || Crm_Config.ToString('service_level') == 'Community' )
		{
			bAvayaEnabled = false;
		}
		return bAvayaEnabled;
	}

	public shouldJoin(sUSER_EXTENSION: string): boolean
	{
		if ( AvayaServer.enabled() && !Sql.IsEmptyString(sUSER_EXTENSION) )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldJoin', sUSER_EXTENSION);
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
		return this.avayaManager.invoke.apply(this.avayaManager, $.merge(["JoinGroup"], $.makeArray(arguments)));
	}

	public createCall(sUniqueId: string)
	{
		/// <summary>Calls the CreateCall method on the server-side AvayaManagerHub hub.&#10;Returns a jQuery.Deferred() promise.</summary>
		/// <param name=\"sUniqueId\" type=\"String\">Server side type is System.String</param>
		return this.avayaManager.invoke.apply(this.avayaManager, $.merge(["CreateCall"], $.makeArray(arguments)));
	}

	public originateCall(sUSER_EXTENSION: string, sUSER_FULL_NAME: string, sUSER_PHONE_WORK: string, sPHONE: string, sPARENT_ID: string, sPARENT_TYPE: string)
	{
		/// <summary>Calls the OriginateCall method on the server-side AvayaManagerHub hub.&#10;Returns a jQuery.Deferred() promise.</summary>
		/// <param name=\"sUSER_EXTENSION\" type=\"String\">Server side type is System.String</param>
		/// <param name=\"sUSER_FULL_NAME\" type=\"String\">Server side type is System.String</param>
		/// <param name=\"sUSER_PHONE_WORK\" type=\"String\">Server side type is System.String</param>
		/// <param name=\"sPHONE\" type=\"String\">Server side type is System.String</param>
		/// <param name=\"sPARENT_ID\" type=\"String\">Server side type is System.String</param>
		/// <param name=\"sPARENT_TYPE\" type=\"String\">Server side type is System.String</param>
		return this.avayaManager.invoke.apply(this.avayaManager, $.merge(["OriginateCall"], $.makeArray(arguments)));
	}
}

export function AvayaCreateHub(signalR: SignalR, history: H.History<H.LocationState>)
{
	let manager: any = signalR.hub.createHubProxy(hubName);
	manager.server = new AvayaServer(manager);
	manager.Shutdown = function()
	{
		if ( manager.hasSubscriptions() )
		{
			manager.off('newState'          );
			manager.off('outgoingCall'      );
			manager.off('incomingCall'      );
			manager.off('outgoingComplete'  );
			manager.off('incomingComplete'  );
			manager.off('outgoingIncomplete');
			manager.off('incomingIncomplete');
		}
	};
	manager.on('newState', (Status) =>
	{
		let oCommandArguments: any = { Status };
		console.log((new Date()).toISOString() + ' ' + hubName + '.newState', oCommandArguments);
	});
	manager.on('outgoingCall', (UniqueId, ConnectedLineName, CallerID, CALL_ID) =>
	{
		let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID };
		console.log((new Date()).toISOString() + ' ' + hubName + '.outgoingCall', oCommandArguments);
	});
	manager.on('incomingCall', (UniqueId, ConnectedLineName, CallerID, CALL_ID) =>
	{
		let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID };
		console.log((new Date()).toISOString() + ' ' + hubName + '.incomingCall', oCommandArguments);
	});
	manager.on('outgoingComplete', (UniqueId, ConnectedLineName, CallerID, CALL_ID, DURATION_HOURS, DURATION_MINUTES) =>
	{
		let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID, DURATION_HOURS, DURATION_MINUTES };
		console.log((new Date()).toISOString() + ' ' + hubName + '.outgoingComplete', oCommandArguments);
	});
	manager.on('incomingComplete', (UniqueId, ConnectedLineName, CallerID, CALL_ID, DURATION_HOURS, DURATION_MINUTES) =>
	{
		let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID, DURATION_HOURS, DURATION_MINUTES };
		console.log((new Date()).toISOString() + ' ' + hubName + '.incomingComplete', oCommandArguments);
	});
	manager.on('outgoingIncomplete', (UniqueId, ConnectedLineName, CallerID, CALL_ID, Error) =>
	{
		let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID, Error };
		console.log((new Date()).toISOString() + ' ' + hubName + '.outgoingIncomplete', oCommandArguments);
	});
	manager.on('incomingIncomplete', (UniqueId, ConnectedLineName, CallerID, CALL_ID) =>
	{
		let oCommandArguments: any = { UniqueId, ConnectedLineName, CallerID, CALL_ID };
		console.log((new Date()).toISOString() + ' ' + hubName + '.incomingIncomplete', oCommandArguments);
	});
	return manager;
}

