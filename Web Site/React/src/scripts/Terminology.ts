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

// 05/26/2019 Paul.  Terminology is retrieved in Application_GetReactState. 
/*
export async function Terminology_LoadAllTerms(): Promise<any>
{
	let res = await SystemCacheRequestAll('GetAllTerminology');
	let json = await GetSplendidResult(res);
	SplendidCache.SetTERMINOLOGY(json.d.results);
	// 05/07/2013 Paul. Return the entire TERMINOLOGY table. 
	return ({ 'sUSER_LANG': Credentials.sUSER_LANG, 'TERMINOLOGY': SplendidCache.TERMINOLOGY, 'TERMINOLOGY_LISTS': SplendidCache.TERMINOLOGY_LISTS });
}
*/

// 05/26/2019 Paul.  Terminology Lists are retrieved in Application_GetReactState. 
/*
export async function Terminology_LoadAllLists(): Promise<any>
{
	let res = await SystemCacheRequestAll('GetAllTerminologyLists');
	let json = await GetSplendidResult(res);
	SplendidCache.SetTERMINOLOGY_LISTS(json.d.results);
	// 05/07/2013 Paul. Return the entire TERMINOLOGY table. 
	return ({ 'sUSER_LANG': Credentials.sUSER_LANG, 'TERMINOLOGY': SplendidCache.TERMINOLOGY, 'TERMINOLOGY_LISTS': SplendidCache.TERMINOLOGY_LISTS });
}
*/

export function Terminology_SetTerm(sMODULE_NAME, sNAME, sDISPLAY_NAME)
{
	SplendidCache.SetTerm(sMODULE_NAME, sNAME, sDISPLAY_NAME)
}

export function Terminology_SetListTerm(sLIST_NAME, sNAME, sDISPLAY_NAME)
{
	SplendidCache.SetListTerm(sLIST_NAME, sNAME, sDISPLAY_NAME);
}

// 05/26/2019 Paul.  Terminology is retrieved in Application_GetReactState. 
/*
export async function Terminology_LoadGlobal(): Promise<any>
{
	// 04/27/2019 Paul.  Instead of loaded flag, use specific term. 
	if (SplendidCache.TERMINOLOGY[Credentials.sUSER_LANG + '.LBL_BROWSER_TITLE'] == null)
	{
		// 09/05/2011 Paul.  Include LBL_NEW_FORM_TITLE for the tab menu. 
		// 06/11/2012 Paul.  Wrap Terminology requests for Cordova. 
		let res = await TerminologyRequest(null, null, 'NAME asc', Credentials.sUSER_LANG);
		//let res = await CreateSplendidRequest('Rest.svc/GetModuleTable?TableName=TERMINOLOGY&$orderby=NAME asc&$filter=' + encodeURIComponent('(LANG eq \'' + sUSER_LANG + '\' and (MODULE_NAME is null or MODULE_NAME eq \'Teams\' or NAME eq \'LBL_NEW_FORM_TITLE\'))'), 'GET');
		let json = await GetSplendidResult(res);
		for (let i = 0; i < json.d.results.length; i++)
		{
			var obj = json.d.results[i];
			if (obj['LIST_NAME'] == null)
				Terminology_SetTerm(obj['MODULE_NAME'], obj['NAME'], obj['DISPLAY_NAME']);
			else
				Terminology_SetListTerm(obj['LIST_NAME'], obj['NAME'], obj['DISPLAY_NAME']);
		}
		// 10/04/2011 Paul. Return the entire TERMINOLOGY table. 
		return ({ 'sUSER_LANG': Credentials.sUSER_LANG, 'TERMINOLOGY': SplendidCache.TERMINOLOGY, 'TERMINOLOGY_LISTS': SplendidCache.TERMINOLOGY_LISTS });
	}
	else
	{
		return { 'sUSER_LANG': Credentials.sUSER_LANG, 'TERMINOLOGY': SplendidCache.TERMINOLOGY, 'TERMINOLOGY_LISTS': SplendidCache.TERMINOLOGY_LISTS };
	}
}
*/

// 05/26/2019 Paul.  Terminology Lists are retrieved in Application_GetReactState. 
/*
export async function Terminology_LoadList(sLIST_NAME): Promise<any>
{
	// 06/11/2012 Paul.  Wrap Terminology requests for Cordova. 
	let res = await TerminologyRequest(null, sLIST_NAME, 'LIST_NAME asc', Credentials.sUSER_LANG);
	//let res = await CreateSplendidRequest('Rest.svc/GetModuleTable?TableName=TERMINOLOGY&$orderby=LIST_NAME asc, LIST_ORDER asc, NAME asc&$filter=' + encodeURIComponent('(LANG eq \'' + sUSER_LANG + '\' and MODULE_NAME is null and LIST_NAME eq \'' + sLIST_NAME + '\')'), 'GET');
	let json = await GetSplendidResult(res);
	for (let i = 0; i < json.d.results.length; i++)
	{
		var obj = json.d.results[i];
		Terminology_SetListTerm(sLIST_NAME, obj['NAME'], obj['DISPLAY_NAME']);
	}
	// 10/04/2011 Paul. Return the entire TERMINOLOGY table. 
	return ({ 'sUSER_LANG': Credentials.sUSER_LANG, 'TERMINOLOGY': SplendidCache.TERMINOLOGY, 'TERMINOLOGY_LISTS': SplendidCache.TERMINOLOGY_LISTS });
}
*/

// 05/26/2019 Paul.  Terminology Lists are retrieved in Application_GetReactState. 
/*
export async function Terminology_LoadCustomList(sLIST_NAME): Promise<any>
{
	let res = await CreateSplendidRequest('Rest.svc/GetCustomList?ListName=' + sLIST_NAME, 'GET');
	let json = await GetSplendidResult(res);
	for (let i = 0; i < json.d.results.length; i++)
	{
		var obj = json.d.results[i];
		Terminology_SetListTerm(sLIST_NAME, obj['NAME'], obj['DISPLAY_NAME']);
	}
	// 10/04/2011 Paul. Return the entire TERMINOLOGY table. 
	return ({ 'sUSER_LANG': Credentials.sUSER_LANG, 'TERMINOLOGY': SplendidCache.TERMINOLOGY, 'TERMINOLOGY_LISTS': SplendidCache.TERMINOLOGY_LISTS });
}
*/

// 05/26/2019 Paul.  Terminology is retrieved in Application_GetReactState. 
/*
export async function Terminology_LoadModule(sMODULE_NAME): Promise<any>
{
	// 04/27/2019 Paul.  Instead of loaded flag, use specific term.  Every module will now have LBL_NEW_FORM_TITLE. 
	if (SplendidCache.TERMINOLOGY[Credentials.sUSER_LANG + '.' + sMODULE_NAME + '.LBL_NEW_FORM_TITLE'] == null)
	{
		// 06/11/2012 Paul.  Wrap Terminology requests for Cordova. 
		let res = await TerminologyRequest(sMODULE_NAME, null, 'NAME asc', Credentials.sUSER_LANG);
		//let res = await CreateSplendidRequest('Rest.svc/GetModuleTable?TableName=TERMINOLOGY&$orderby=NAME asc&$filter=' + encodeURIComponent('(LANG eq \'' + sUSER_LANG + '\' and MODULE_NAME eq \'' + sMODULE_NAME + '\' and LIST_NAME is null)'), 'GET');
		let json = await GetSplendidResult(res);
		for (let i = 0; i < json.d.results.length; i++)
		{
			var obj = json.d.results[i];
			Terminology_SetTerm(sMODULE_NAME, obj['NAME'], obj['DISPLAY_NAME']);
		}
		// 10/04/2011 Paul. Return the entire TERMINOLOGY table. 
		return ({ 'sUSER_LANG': Credentials.sUSER_LANG, 'TERMINOLOGY': SplendidCache.TERMINOLOGY, 'TERMINOLOGY_LISTS': SplendidCache.TERMINOLOGY_LISTS });
	}
	else
	{
		return { 'sUSER_LANG': Credentials.sUSER_LANG, 'TERMINOLOGY': SplendidCache.TERMINOLOGY, 'TERMINOLOGY_LISTS': SplendidCache.TERMINOLOGY_LISTS };
	}
}
*/
