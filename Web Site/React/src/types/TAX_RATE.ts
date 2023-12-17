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

export default interface TAX_RATE
{
	ID                            : string;  // uniqueidentifier
	NAME                          : string;  // nvarchar
	LIST_ORDER                    : number;  // int
	VALUE                         : number;  // money
	TEAM_ID                       : string;  // uniqueidentifier
	TEAM_NAME                     : string;  // nvarchar
	TEAM_SET_ID                   : string;  // uniqueidentifier
	TEAM_SET_NAME                 : string;  // nvarchar
	TEAM_SET_LIST                 : string;  // varchar
}

