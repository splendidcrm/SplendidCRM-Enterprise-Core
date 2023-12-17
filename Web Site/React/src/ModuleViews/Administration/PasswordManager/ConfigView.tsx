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
import * as React from 'react';
// 2. Store and Types. 
// 3. Scripts. 
// 4. Components and Views. 
import AdminConfigView from '../../../views/AdminConfigView';

export default class AdminPasswordManager extends React.Component
{
	public render()
	{
		return (<AdminConfigView MODULE_NAME='Config' LAYOUT_NAME='PasswordManager.EditView' MODULE_TITLE='Administration.LBL_MANAGE_PASSWORD_TITLE' />);
	}
}

