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

export async function AutoComplete_ModuleMethod(sMODULE_NAME, sMETHOD, sREQUEST)
{
	if ( !Credentials.ValidateCredentials )
	{
		throw new Error('Invalid connection information.');
	}
	else
	{
		if ( sMODULE_NAME == 'Teams' )
		{
			sMODULE_NAME = 'Administration/Teams';
		}
		else if (sMODULE_NAME == 'Tags')
		{
			sMODULE_NAME = 'Administration/Tags';
		}
		// 06/07/2017 Paul.  Add NAICSCodes module. 
		else if (sMODULE_NAME == 'NAICSCodes')
		{
			sMODULE_NAME = 'Administration/NAICSCodes';
		}
		// 06/05/2018 Paul.  sREQUEST has already been stringified. 
		var sBody = sREQUEST;
		let res = await CreateSplendidRequest(sMODULE_NAME + '/AutoComplete.asmx/' + sMETHOD, 'POST', 'application/json; charset=utf-8', sBody);
		let json = await GetSplendidResult(res);
		return json.d;
	}
}

