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
import PacificHeaderButtons           from './Pacific/HeaderButtons'          ;
import ArcticHeaderButtons            from './Arctic/HeaderButtons'           ;
import AtlanticHeaderButtons          from './Atlantic/HeaderButtons'         ;
import SevenHeaderButtons             from './Seven/HeaderButtons'            ;
import SixHeaderButtons               from './Six/HeaderButtons'              ;
import SugarHeaderButtons             from './Sugar/HeaderButtons'            ;
import Sugar2006HeaderButtons         from './Sugar2006/HeaderButtons'        ;

export default function HeaderButtonsFactory(sTHEME: string)
{
	let ctl: any = null;
	switch ( sTHEME )
	{
		// 04/01/2022 Paul.  Add Pacific theme, derived from Arctic.
		case 'Pacific'  :  ctl = PacificHeaderButtons  ;  break;
		case 'Arctic'   :  ctl = ArcticHeaderButtons   ;  break;
		case 'Atlantic' :  ctl = AtlanticHeaderButtons ;  break;
		case 'Mobile'   :  ctl = null                  ;  break;
		case 'Seven'    :  ctl = SevenHeaderButtons    ;  break;
		case 'Six'      :  ctl = SixHeaderButtons      ;  break;
		case 'Sugar'    :  ctl = SugarHeaderButtons    ;  break;
		case 'Sugar2006':  ctl = Sugar2006HeaderButtons;  break;
	}
	if ( ctl )
	{
		//console.log((new Date()).toISOString() + ' ' + 'HeaderButtonsFactory found ' + sTHEME);
	}
	else
	{
		// 04/01/2022 Paul.  Add Pacific theme, derived from Arctic.
		ctl = PacificHeaderButtons;
		//console.log((new Date()).toISOString() + ' ' + 'HeaderButtonsFactory not found ' + sTHEME + ', using Arctic');
	}
	return ctl;
}

