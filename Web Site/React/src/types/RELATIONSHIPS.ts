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

export default interface RELATIONSHIPS
{
	ID                            : string  ; // uniqueidentifier
	RELATIONSHIP_NAME             : string  ; // nvarchar
	LHS_MODULE                    : string  ; // nvarchar
	LHS_TABLE                     : string  ; // nvarchar
	LHS_KEY                       : string  ; // nvarchar
	RHS_MODULE                    : string  ; // nvarchar
	RHS_TABLE                     : string  ; // nvarchar
	RHS_KEY                       : string  ; // nvarchar
	JOIN_TABLE                    : string  ; // nvarchar
	JOIN_KEY_LHS                  : string  ; // nvarchar
	JOIN_KEY_RHS                  : string  ; // nvarchar
	RELATIONSHIP_TYPE             : string  ; // nvarchar
	RELATIONSHIP_ROLE_COLUMN      : string  ; // nvarchar
	RELATIONSHIP_ROLE_COLUMN_VALUE: string  ; // nvarchar
	REVERSE                       : boolean ; // bit
}

