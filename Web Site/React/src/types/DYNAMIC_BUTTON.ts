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

export default interface DYNAMIC_BUTTON
{
	ID                            : string;  // uniqueidentifier
	VIEW_NAME                     : string;  // nvarchar
	CONTROL_INDEX                 : number;  // int
	CONTROL_TYPE                  : string;  // nvarchar
	DEFAULT_VIEW                  : boolean; // bit
	MODULE_NAME                   : string;  // nvarchar
	MODULE_ACCESS_TYPE            : string;  // nvarchar
	TARGET_NAME                   : string;  // nvarchar
	TARGET_ACCESS_TYPE            : string;  // nvarchar
	MOBILE_ONLY                   : boolean; // bit
	ADMIN_ONLY                    : boolean; // bit
	EXCLUDE_MOBILE                : boolean; // bit
	CONTROL_TEXT                  : string;  // nvarchar
	CONTROL_TOOLTIP               : string;  // nvarchar
	CONTROL_ACCESSKEY             : string;  // nvarchar
	CONTROL_CSSCLASS              : string;  // nvarchar
	TEXT_FIELD                    : string;  // nvarchar
	ARGUMENT_FIELD                : string;  // nvarchar
	COMMAND_NAME                  : string;  // nvarchar
	URL_FORMAT                    : string;  // nvarchar
	URL_TARGET                    : string;  // nvarchar
	ONCLICK_SCRIPT                : string;  // nvarchar
	HIDDEN                        : boolean; // bit
	BUSINESS_RULE                 : string;  // nvarchar
	BUSINESS_SCRIPT               : string;  // nvarchar
	MODULE_ACLACCESS              : string;
	TARGET_ACLACCESS              : string;
}

