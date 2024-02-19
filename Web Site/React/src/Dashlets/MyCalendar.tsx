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
import * as React from 'react';
import { RouteComponentProps, withRouter } from '../Router5'              ;
import { FontAwesomeIcon }                 from '@fortawesome/react-fontawesome';
import { Appear }                          from 'react-lifecycle-appear'        ;
// 2. Store and Types. 
import IDashletProps                       from '../types/IDashletProps'        ;
// 3. Scripts. 
import Sql                                 from '../scripts/Sql'                ;
import L10n                                from '../scripts/L10n'               ;
// 4. Components and Views. 
import CalendarView                        from '../views/CalendarView'         ;

interface IMyCalendarProps extends IDashletProps
{
}

interface IMyCalendarState
{
	dashletVisible   : boolean;
}

export default class MyCalendar extends React.Component<IMyCalendarProps, IMyCalendarState>
{
	constructor(props: IMyCalendarProps)
	{
		super(props);
		this.state =
		{
			dashletVisible  : false,
		}
	}

	public render()
	{
		const { TITLE } = this.props;
		const { dashletVisible } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render ' + MODULE_NAME, SETTINGS_EDITVIEW, DEFAULT_SETTINGS);
		// 07/09/2019 Paul.  Use i instead of a tag to prevent navigation. 
		return (
		<div style={ {display: 'flex', flexGrow: 1} }>
			<div className="card" style={ {flexGrow: 1, margin: '.5em', overflowX: 'auto'} }>
				<Appear onAppearOnce={ (ioe) => this.setState({ dashletVisible: true }) }>
					<div className="card-body DashletHeader">
						<h3 style={ {float: 'left'} }>{ L10n.Term(TITLE) }</h3>
					</div>
				</Appear>
				{ dashletVisible
				? <div style={ {clear: 'both'} }>
					<hr />
					<CalendarView
						disableModuleHeader={ true }
					/>
				</div>
				: null
				}
			</div>
		</div>);
	}
}
