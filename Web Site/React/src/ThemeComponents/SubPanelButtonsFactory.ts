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
// 4. Components and Views. 
// 04/01/2022 Paul.  Add Pacific theme, derived from Arctic.
import PacificSubPanelHeaderButtons   from './Pacific/SubPanelHeaderButtons'  ;
import ArcticSubPanelHeaderButtons    from './Arctic/SubPanelHeaderButtons'   ;
import AtlanticSubPanelHeaderButtons  from './Atlantic/SubPanelHeaderButtons' ;
import SevenSubPanelHeaderButtons     from './Seven/SubPanelHeaderButtons'    ;
import SixSubPanelHeaderButtons       from './Six/SubPanelHeaderButtons'      ;
import SugarSubPanelHeaderButtons     from './Sugar/SubPanelHeaderButtons'    ;
import Sugar2006SubPanelHeaderButtons from './Sugar2006/SubPanelHeaderButtons';

export default function SubPanelButtonsFactory(sTHEME: string)
{
	let ctl: any = null;
	switch ( sTHEME )
	{
		// 04/01/2022 Paul.  Add Pacific theme, derived from Arctic.
		case 'Pacific'  :  ctl = PacificSubPanelHeaderButtons  ;  break;
		case 'Arctic'   :  ctl = ArcticSubPanelHeaderButtons   ;  break;
		case 'Atlantic' :  ctl = AtlanticSubPanelHeaderButtons ;  break;
		case 'Mobile'   :  ctl = null                          ;  break;
		case 'Seven'    :  ctl = SevenSubPanelHeaderButtons    ;  break;
		case 'Six'      :  ctl = SixSubPanelHeaderButtons      ;  break;
		case 'Sugar'    :  ctl = SugarSubPanelHeaderButtons    ;  break;
		case 'Sugar2006':  ctl = Sugar2006SubPanelHeaderButtons;  break;
	}
	if ( ctl )
	{
		//console.log((new Date()).toISOString() + ' ' + 'SubPanelButtonsFactory found ' + sTHEME);
	}
	else
	{
		// 04/01/2022 Paul.  Add Pacific theme, derived from Arctic.
		ctl = PacificSubPanelHeaderButtons;
		//console.log((new Date()).toISOString() + ' ' + 'SubPanelButtonsFactory not found ' + sTHEME + ', using Arctic');
	}
	return ctl;
}

