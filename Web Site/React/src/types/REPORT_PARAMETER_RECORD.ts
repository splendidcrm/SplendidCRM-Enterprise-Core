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

export default interface REPORT_PARAMETER_RECORD
{
	NAME         : string;
	MODULE_NAME  : string;
	DATA_TYPE    : string;  // String, Boolean, DateTime, Integer, Float
	NULLABLE     : boolean;
	ALLOW_BLANK  : boolean;
	MULTI_VALUE  : boolean;
	HIDDEN       : boolean;
	PROMPT       : string;
	DEFAULT_VALUE: string;
	DATA_SET_NAME: string;
}

