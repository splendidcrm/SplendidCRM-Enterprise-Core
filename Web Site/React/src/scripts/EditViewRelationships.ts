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

// 05/26/2019 Paul.  EditViewRelationships are retrieved in Application_GetAllLayouts. 
/*
export async function EditViewRelationships_LoadAllLayouts(): Promise<any>
{
	let res = await SystemCacheRequestAll('GetAllEditViewsRelationships');
	let json = await GetSplendidResult(res);
	SplendidCache.SetEDITVIEWS_RELATIONSHIPS(json.d.results);
	return (json.d.results);
}
*/

export async function EditViewRelationships_LoadLayout(sEDIT_NAME): Promise<any>
{
	let layout = SplendidCache.EditViewRelationships(sEDIT_NAME);
	if ( layout == null )
	{
		// 05/26/2019 Paul.  We will no longer lookup missing layout values if not in the cache. 
		//console.log((new Date()).toISOString() + ' ' + sEDIT_NAME + ' not found in EditViewRelationships');
		/*
		// 06/11/2012 Paul.  Wrap System Cache requests for Cordova. 
		let res = await SystemCacheRequest('EDITVIEWS_RELATIONSHIPS', 'RELATIONSHIP_ORDER asc', null, 'EDIT_NAME', sEDIT_NAME);
		//var xhr = await CreateSplendidRequest('Rest.svc/GetModuleTable?TableName=EDITVIEWS_RELATIONSHIPS&$orderby=RELATIONSHIP_ORDER asc&$filter=' + encodeURIComponent('EDIT_NAME eq \'' + sEDIT_NAME + '\''), 'GET');
		let json = await GetSplendidResult(res);
		SplendidCache.SetEditViewRelationships(sEDIT_NAME, json.d.results);
		// 10/04/2011 Paul.  EditViewRelationships_LoadLayout returns the layout. 
		layout = SplendidCache.EditViewRelationships(sEDIT_NAME);
		return (json.d.results);
		*/
	}
	return layout;
}

