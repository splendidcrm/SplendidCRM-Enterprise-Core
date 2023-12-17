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

export default interface DETAILVIEWS_RELATIONSHIP
{
	ID?                           : string;  // uniqueidentifier
	DETAIL_NAME?                  : string;  // nvarchar
	MODULE_NAME                   : string;  // nvarchar
	TITLE                         : string;  // nvarchar
	CONTROL_NAME                  : string;  // nvarchar
	RELATIONSHIP_ORDER?           : number;  // int
	TABLE_NAME                    : string;  // nvarchar
	PRIMARY_FIELD                 : string;  // nvarchar
	SORT_FIELD                    : string;  // nvarchar
	SORT_DIRECTION                : string;  // nvarchar
	// 03/31/2022 Paul.  Add Insight fields.
	INSIGHT_VIEW?                 : string;  // nvarchar
	INSIGHT_LABEL?                : string;  // nvarchar
	initialOpen?                  : boolean;
}

