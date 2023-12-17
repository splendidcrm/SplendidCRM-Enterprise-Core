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
import { sPLATFORM_LAYOUT, bDESKTOP_LAYOUT } from '../scripts/SplendidInitUI';
import { EndsWith } from '../scripts/utility';

export default class SplendidDynamic
{
	// 06/18/2015 Paul.  Add support for Seven theme. 
	static StackedLayout(sTheme: string, sViewName?: string): boolean
	{
		if (sViewName === undefined || sViewName == null)
			sViewName = '';
		// 04/02/2022 Paul.  Pacific uses stacked action menus. 
		return (sTheme === 'Seven' || sTheme === 'Pacific') && !EndsWith(sViewName, '.Preview');
	}

	// 04/08/2017 Paul.  Use Bootstrap for responsive design.
	static BootstrapLayout(): boolean
	{
		// 06/24/2017 Paul.  We need a way to turn off bootstrap for BPMN, ReportDesigner and ChatDashboard. 
		return !bDESKTOP_LAYOUT && sPLATFORM_LAYOUT != '.OfficeAddin';
	}
}

