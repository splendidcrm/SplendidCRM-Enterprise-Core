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

// 05/26/2019 Paul.  DetailViewRelationships are retrieved in Application_GetAllLayouts. 
/*
export async function DetailViewRelationships_LoadAllLayouts()
{
	let res = await SystemCacheRequestAll('GetAllDetailViewsRelationships');
	let json = await GetSplendidResult(res);
	SplendidCache.SetDETAILVIEWS_RELATIONSHIPS(json.d.results);
	return (json.d.results);
}
*/

export async function DetailViewRelationships_LoadLayout(sDETAIL_NAME): Promise<any>
{
	let layout = SplendidCache.DetailViewRelationships(sDETAIL_NAME);
	if ( layout == null )
	{
		// 05/26/2019 Paul.  We will no longer lookup missing layout values if not in the cache. 
		//console.log((new Date()).toISOString() + ' ' + sDETAIL_NAME + ' not found in DetailViewRelationships');
		/*
		// 06/11/2012 Paul.  Wrap System Cache requests for Cordova. 
		let res = await SystemCacheRequest('DETAILVIEWS_RELATIONSHIPS', 'RELATIONSHIP_ORDER asc', null, 'DETAIL_NAME', sDETAIL_NAME);
		//var xhr = await CreateSplendidRequest('Rest.svc/GetModuleTable?TableName=DETAILVIEWS_RELATIONSHIPS&$orderby=RELATIONSHIP_ORDER asc&$filter=' + encodeURIComponent('DETAIL_NAME eq \'' + sDETAIL_NAME + '\''), 'GET');
		let json = await GetSplendidResult(res);
		SplendidCache.SetDetailViewRelationships(sDETAIL_NAME, json.d.results);
		// 10/03/2011 Paul.  DetailView_LoadLayout returns the layout. 
		layout = SplendidCache.DetailViewRelationships(sDETAIL_NAME);
		return (json.d.results);
		*/
	}
	return layout;
}

