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

// 1. React and fabric. 
// 2. Store and Types. 
// 3. Scripts. 

export default interface FIELDS_META_DATA
{
	ID                            : string ;  // uniqueidentifier
	NAME                          : string ;  // nvarchar
	LABEL                         : string ;  // nvarchar
	CUSTOM_MODULE                 : string ;  // nvarchar
	DATA_TYPE                     : string ;  // nvarchar
	MAX_SIZE                      : number ;  // int
	REQUIRED_OPTION               : string ;  // nvarchar
	AUDITED                       : boolean;  // bit
	DEFAULT_VALUE                 : string ;  // nvarchar
	EXT1                          : string ;  // nvarchar
	EXT2                          : string ;  // nvarchar
	EXT3                          : string ;  // nvarchar
	MASS_UPDATE                   : boolean;  // bit
}

