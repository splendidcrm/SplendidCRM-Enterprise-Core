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

export default interface GRIDVIEWS_COLUMN
{
	ID                            : string;  // uniqueidentifier
	DELETED                       : boolean; // bit
	GRID_NAME                     : string;  // nvarchar
	COLUMN_INDEX                  : number;  // int
	COLUMN_TYPE                   : string;  // nvarchar
	DEFAULT_VIEW                  : boolean; // bit
	HEADER_TEXT                   : string;  // nvarchar
	SORT_EXPRESSION               : string;  // nvarchar
	ITEMSTYLE_WIDTH               : string;  // nvarchar
	ITEMSTYLE_CSSCLASS            : string;  // nvarchar
	ITEMSTYLE_HORIZONTAL_ALIGN    : string;  // nvarchar
	ITEMSTYLE_VERTICAL_ALIGN      : string;  // nvarchar
	ITEMSTYLE_WRAP                : boolean; // bit
	DATA_FIELD                    : string;  // nvarchar
	DATA_FORMAT                   : string;  // nvarchar
	URL_FIELD                     : string;  // nvarchar
	URL_FORMAT                    : string;  // nvarchar
	URL_TARGET                    : string;  // nvarchar
	LIST_NAME                     : string;  // nvarchar
	URL_MODULE                    : string;  // nvarchar
	URL_ASSIGNED_FIELD            : string;  // nvarchar
	VIEW_NAME                     : string;  // nvarchar
	MODULE_NAME                   : string;  // nvarchar
	MODULE_TYPE                   : string;  // nvarchar
	PARENT_FIELD                  : string;  // nvarchar
	SCRIPT                        : string;  // nvarchar

}

