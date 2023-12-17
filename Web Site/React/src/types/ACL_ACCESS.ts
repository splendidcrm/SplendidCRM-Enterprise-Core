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

export default class ACL_ACCESS
{
	// 09/26/2017 Paul.  Add Archive access right. 
	public static FULL_ACCESS: number = 100;
	public static ARCHIVE    : number = 91;
	public static VIEW       : number = 90;
	public static ALL        : number = 90;
	public static ENABLED    : number =  89;
	public static OWNER      : number =  75;
	public static DISABLED   : number = -98;
	public static NONE       : number = -99;

	public static GetName(access: string, value: number)
	{
		let name: string = 'NONE';
		switch ( value )
		{
			case ACL_ACCESS.FULL_ACCESS:  name = 'FULL_ACCESS';  break;
			case ACL_ACCESS.ARCHIVE    :  name = 'ARCHIVE'    ;  break;
			case ACL_ACCESS.VIEW       :  (access == 'archive' ? name = 'VIEW' : name = 'ALL');  break;
			case ACL_ACCESS.ENABLED    :  name = 'ENABLED'    ;  break;
			case ACL_ACCESS.OWNER      :  name = 'OWNER'      ;  break;
			case ACL_ACCESS.DISABLED   :  name = 'DISABLED'   ;  break;
			case ACL_ACCESS.NONE       :  name = 'NONE'       ;  break;
		}
		return name;
	}
}

