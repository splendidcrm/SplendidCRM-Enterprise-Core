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

const hubName = 'TwitterManagerHub';

export class TwitterServer
{
	twitterManager: SignalR.Hub.Proxy;

	constructor(twitterManager: SignalR.Hub.Proxy)
	{
		this.twitterManager = twitterManager;
	}

	public static enabled()
	{
		let bTwitterEnabled: boolean = Crm_Config.ToBoolean('Twitter.EnableTracking') && !Sql.IsEmptyString(Crm_Config.ToString('Twitter.ConsumerKey'));
		return bTwitterEnabled;
	}

	public shouldJoin(sUSER_TWITTER_TRACKS: string): boolean
	{
		if ( TwitterServer.enabled() && !Sql.IsEmptyString(sUSER_TWITTER_TRACKS) )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldJoin', sUSER_TWITTER_TRACKS);
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
		return this.twitterManager.invoke.apply(this.twitterManager, $.merge(["JoinGroup"], $.makeArray(arguments)));
	}
}

// 01/15/2024 Paul.  Update History. 
export function TwitterCreateHub(signalR: SignalR, history: H.History)
{
	let manager: any = signalR.hub.createHubProxy(hubName);
	manager.server = new TwitterServer(manager);
	manager.Shutdown = function()
	{
		if ( manager.hasSubscriptions() )
		{
			manager.off('newMessage');
		}
	};
	manager.on('newTweet', (TRACK, NAME, DESCRIPTION, DATE_START, TWITTER_ID, TWITTER_USER_ID, TWITTER_FULL_NAME, TWITTER_SCREEN_NAME, TWITTER_AVATAR, TWITTER_MESSAGE_ID) =>
	{
		let oCommandArguments: any = { TRACK, NAME, DESCRIPTION, DATE_START, TWITTER_ID, TWITTER_USER_ID, TWITTER_FULL_NAME, TWITTER_SCREEN_NAME, TWITTER_AVATAR, TWITTER_MESSAGE_ID };
		console.log((new Date()).toISOString() + ' ' + hubName +'.newTweet', oCommandArguments);
	});
	return manager;
}

