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
// 2. Store and Types. 
// 3. Scripts. 
import SplendidCache from '../scripts/SplendidCache';

export async function TabMenu_Load(): Promise<any>
{
	let layout = SplendidCache.TAB_MENU;
	if ( layout == null )
	{
		// 05/26/2019 Paul.  We will no longer lookup missing layout values if not in the cache. 
		//console.log((new Date()).toISOString() + ' Tab Menu is null');
		/*
		// 06/11/2012 Paul.  Wrap System Cache requests for Cordova. 
		let res = await SystemCacheRequest('TAB_MENUS', 'TAB_ORDER asc');
		//var xhr = await CreateSplendidRequest('Rest.svc/GetModuleTable?TableName=TAB_MENUS&$orderby=TAB_ORDER asc', 'GET');
		let json = await GetSplendidResult(res);
		SplendidCache.SetTAB_MENU(json.d.results);
		return (json.d.results);
		*/
	}
	return layout;
}

