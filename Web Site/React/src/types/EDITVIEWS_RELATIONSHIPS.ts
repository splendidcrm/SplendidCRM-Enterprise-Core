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

export default interface EDITVIEWS_RELATIONSHIPS
{
	ID?                           : string  // uniqueidentifier
	EDIT_NAME?                    : string  // nvarchar
	MODULE_NAME                   : string  // nvarchar
	TITLE                         : string  // nvarchar
	CONTROL_NAME                  : string  // nvarchar
	RELATIONSHIP_ORDER?           : number  // int
	NEW_RECORD_ENABLED            : boolean // bit
	EXISTING_RECORD_ENABLED       : boolean // bit
	ALTERNATE_VIEW                : string  // nvarchar
	initialOpen?                  : boolean;
}

