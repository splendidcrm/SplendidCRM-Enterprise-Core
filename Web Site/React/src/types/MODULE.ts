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

// 05/01/2019 Paul.  We need a flag so that the React client can determine if the module is Process enabled. 
// 07/31/2019 Paul.  DEFAULT_SORT is a new field for the React Client. 
// 08/12/2019 Paul.  ARCHIVED_ENBLED is needed for the dynamic buttons. 
// 12/03/2019 Paul.  Separate Archive View exists flag so that we can display information on DetailView. 
// 06/26/2021 Paul.  IS_ASSIGNED is available in vwMODULES_AppVars. 
export default interface MODULE
{
	ID                            : string ;  // uniqueidentifier
	NAME                          : string ;  // nvarchar
	MODULE_NAME                   : string ;  // nvarchar
	DISPLAY_NAME                  : string ;  // nvarchar
	RELATIVE_PATH                 : string ;  // nvarchar
	MODULE_ENABLED                : boolean;  // bit
	TAB_ENABLED                   : boolean;  // bit
	TAB_ORDER                     : number;   // int
	PORTAL_ENABLED                : boolean;  // bit
	CUSTOM_ENABLED                : boolean;  // bit
	IS_ADMIN                      : boolean;  // bit
	TABLE_NAME                    : string ;  // nvarchar
	REPORT_ENABLED                : boolean;  // bit
	IMPORT_ENABLED                : boolean;  // bit
	SYNC_ENABLED                  : boolean;  // bit
	MOBILE_ENABLED                : boolean;  // bit
	CUSTOM_PAGING                 : boolean;  // bit
	DATE_MODIFIED                 : Date   ;  // datetime
	DATE_MODIFIED_UTC             : Date   ;  // datetime
	MASS_UPDATE_ENABLED           : boolean;  // bit
	DEFAULT_SEARCH_ENABLED        : boolean;  // bit
	EXCHANGE_SYNC                 : boolean;  // bit
	EXCHANGE_FOLDERS              : boolean;  // bit
	EXCHANGE_CREATE_PARENT        : boolean;  // bit
	REST_ENABLED                  : boolean;  // bit
	DUPLICATE_CHECHING_ENABLED    : boolean;  // bit
	RECORD_LEVEL_SECURITY_ENABLED : boolean;  // bit
	PROCESS_ENABLED               : boolean;  // bit
	DEFAULT_SORT                  : string ;  // nvarchar
	ARCHIVED_ENBLED               : boolean;  // bit
	ARCHIVED_VIEW_EXISTS          : boolean;  // bit
	STREAM_ENBLED                 : boolean;  // bit
	IS_ASSIGNED                   : boolean;  // bit
}

