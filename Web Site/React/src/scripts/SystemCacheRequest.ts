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
import { CreateSplendidRequest, GetSplendidResult } from '../scripts/SplendidRequest';

export async function AdminRequestAll(sMethodName: string): Promise<any>
{
	var sUrl = 'Administration/Rest.svc/' + sMethodName;
	var xhr = await CreateSplendidRequest(sUrl, "GET");
	return xhr;
}

export async function SystemCacheRequestAll(sMethodName: string): Promise<any>
{
	var sUrl = 'Rest.svc/' + sMethodName;
	var xhr = await CreateSplendidRequest(sUrl, "GET");
	return xhr;
}

// 06/11/2012 Paul.  Wrap System Cache requests for Cordova. 
export async function SystemCacheRequest(sTableName: string, sOrderBy: string, sSelectFields?: string, sFilterField?: string, sFilterValue?: string, bDefaultView?: boolean): Promise<any>
{
	var sUrl = 'Rest.svc/GetModuleTable?TableName=' + sTableName;
	if (sSelectFields !== undefined && sSelectFields != null)
	{
		sUrl += '&$select=' + sSelectFields;
	}
	if (sOrderBy !== undefined && sOrderBy != null)
	{
		sUrl += '&$orderby=' + sOrderBy;
	}
	if (sFilterField !== undefined && sFilterField != null && sFilterValue !== undefined && sFilterValue != null)
	{
		// 09/19/2016 Paul.  The entire filter string needs to be encoded. 
		var filter = '(' + sFilterField + ' eq \'' + sFilterValue + '\'';
		if (bDefaultView !== undefined && bDefaultView === true)
			filter += ' and DEFAULT_VIEW eq 0';
		filter += ')';
		sUrl += '&$filter=' + encodeURIComponent(filter);
	}
	var xhr = await CreateSplendidRequest(sUrl, "GET");
	return xhr;
}

// 06/11/2012 Paul.  Wrap Terminology requests for Cordova. 
export async function TerminologyRequest(sMODULE_NAME: string, sLIST_NAME: string, sOrderBy: string, sUSER_LANG: string): Promise<any>
{
	var sUrl = 'Rest.svc/GetModuleTable?TableName=TERMINOLOGY';
	if (sOrderBy !== undefined && sOrderBy != null)
	{
		sUrl += '&$orderby=' + sOrderBy;
	}
	if (sMODULE_NAME == null && sLIST_NAME == null)
	{
		sUrl += '&$filter=' + encodeURIComponent('(LANG eq \'' + sUSER_LANG + '\' and (MODULE_NAME is null or MODULE_NAME eq \'Teams\' or NAME eq \'LBL_NEW_FORM_TITLE\'))');
	}
	else
	{
		// 09/19/2016 Paul.  The entire filter string needs to be encoded. 
		var filter = '(LANG eq \'' + sUSER_LANG + '\'';
		if (sMODULE_NAME != null)
			filter += ' and MODULE_NAME eq \'' + sMODULE_NAME + '\'';
		else
			filter += ' and MODULE_NAME is null';
		if (sLIST_NAME != null)
			filter += ' and LIST_NAME eq \'' + sLIST_NAME + '\'';
		else
			filter += ' and LIST_NAME is null';
		filter += ')';
		sUrl += '&$filter=' + encodeURIComponent(filter);
	}
	var xhr = await CreateSplendidRequest(sUrl, "GET");
	return xhr;
}

export async function SystemSqlColumns(sMODULE_NAME: string, sMODE: string): Promise<any>
{
	var sUrl = 'Rest.svc/GetSqlColumns?ModuleName=' + sMODULE_NAME + '&Mode=' + sMODE;
	let res = await CreateSplendidRequest(sUrl, "GET");
	let json = await GetSplendidResult(res);
	return json.d;
}

