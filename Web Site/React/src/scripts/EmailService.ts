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
import Credentials from '../scripts/Credentials';
import { CreateSplendidRequest, GetSplendidResult } from '../scripts/SplendidRequest';

export async function EmailService_ParseEmail(request): Promise<any>
{
	if (!Credentials.ValidateCredentials)
	{
		throw new Error('Invalid connection information.');
	}
	else
	{
		var sBody = '{"EmailHeaders": ' + JSON.stringify(request) + '}';
		let res = await CreateSplendidRequest('BrowserExtensions/EmailService.svc/ParseEmail', 'POST', 'application/json; charset=utf-8', sBody);
		let json = await GetSplendidResult(res);
		return json.d;
	}
}

export async function EmailService_ArchiveEmail(request): Promise<any>
{
	if (!Credentials.ValidateCredentials)
	{
		throw new Error('Invalid connection information.');
	}
	else
	{
		let res = await CreateSplendidRequest('BrowserExtensions/EmailService.svc/ArchiveEmail', 'POST', 'application/octet-stream', JSON.stringify(request));
		let json = await GetSplendidResult(res);
		return json.d;
	}
}

export async function EmailService_SetEmailRelationships(sID, arrSelection): Promise<any>
{
	if (!Credentials.ValidateCredentials)
	{
		throw new Error('Invalid connection information.');
	}
	else
	{
		var sBody = '{"ID": ' + JSON.stringify(sID) + ', "Selection": ' + JSON.stringify(arrSelection) + '}';
		let res = await CreateSplendidRequest('BrowserExtensions/EmailService.svc/SetEmailRelationships', 'POST', 'application/json; charset=utf-8', sBody);
		let json = await GetSplendidResult(res);
		return json.d;
	}
}

