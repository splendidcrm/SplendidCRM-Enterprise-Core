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
import { RouteComponentProps } from 'react-router-dom';
// 2. Store and Types. 

export default interface IDashletProps extends RouteComponentProps<any>
{
	ID               : string;
	TITLE            : string;
	SETTINGS_EDITVIEW: any;
	DEFAULT_SETTINGS : any;
	COLUMN_WIDTH     : number  ; // bootstrap 1 to 12. 
}

