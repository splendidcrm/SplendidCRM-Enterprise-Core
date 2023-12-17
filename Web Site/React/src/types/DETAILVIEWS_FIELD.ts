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

export default interface DETAILVIEWS_FIELD
{
	ID                            : string;  // uniqueidentifier
	DELETED                       : boolean; // bit
	DETAIL_NAME                   : string;  // nvarchar
	FIELD_INDEX                   : number;  // int
	FIELD_TYPE                    : string;  // nvarchar
	DEFAULT_VIEW                  : boolean; // bit
	DATA_LABEL                    : string;  // nvarchar
	DATA_FIELD                    : string;  // nvarchar
	DATA_FORMAT                   : string;  // nvarchar
	URL_FIELD                     : string;  // nvarchar
	URL_FORMAT                    : string;  // nvarchar
	URL_TARGET                    : string;  // nvarchar
	LIST_NAME                     : string;  // nvarchar
	COLSPAN                       : number;  // int
	LABEL_WIDTH                   : string;  // nvarchar
	FIELD_WIDTH                   : string;  // nvarchar
	DATA_COLUMNS                  : number;  // int
	VIEW_NAME                     : string;  // nvarchar
	MODULE_NAME                   : string;  // nvarchar
	TOOL_TIP                      : string;  // nvarchar
	MODULE_TYPE                   : string;  // nvarchar
	PARENT_FIELD                  : string;  // nvarchar
	SCRIPT                        : string;  // nvarchar
	hidden                        : boolean;
}

