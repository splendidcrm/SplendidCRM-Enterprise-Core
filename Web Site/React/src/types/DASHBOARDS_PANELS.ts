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

export default interface DASHBOARDS_PANELS
{
	ID                            : string  ; // uniqueidentifier
	PANEL_ORDER                   : number  ; // int
	ROW_INDEX                     : number  ; // int
	COLUMN_WIDTH                  : number  ; // int
	DASHBOARD_ID                  : string  ; // uniqueidentifier
	DASHBOARD_APP_ID              : string  ; // uniqueidentifier
	NAME                          : string  ; // nvarchar
	CATEGORY                      : string  ; // nvarchar
	MODULE_NAME                   : string  ; // nvarchar
	TITLE                         : string  ; // nvarchar
	SETTINGS_EDITVIEW             : string  ; // nvarchar
	IS_ADMIN                      : boolean ; // bit
	APP_ENABLED                   : boolean ; // bit
	SCRIPT_URL                    : string  ; // nvarchar
	DEFAULT_SETTINGS              : string  ; // nvarchar
	PANEL_TYPE?                   : string  ; // nvarchar
}

