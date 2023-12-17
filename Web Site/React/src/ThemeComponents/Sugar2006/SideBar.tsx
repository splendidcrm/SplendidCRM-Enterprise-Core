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
import { RouteComponentProps, withRouter } from 'react-router-dom'                 ;
// 2. Store and Types. 
// 3. Scripts. 
import Credentials                         from '../../scripts/Credentials'        ;
import SplendidCache                       from '../../scripts/SplendidCache'      ;
// 4. Components and Views. 
import Sugar2006Actions                    from './Actions'                        ;

interface ISideBarProps extends RouteComponentProps<any>
{
}

interface ISideBarState
{
	showLeftCol: boolean;
}

class Sugar2006SideBar extends React.Component<ISideBarProps, ISideBarState>
{
	constructor(props: ISideBarProps)
	{
		super(props);
		this.state =
		{
			showLeftCol: Credentials.showLeftCol,
		};
	}

	private toggleSideBar = (e) =>
	{
		Credentials.showLeftCol = !Credentials.showLeftCol;
		// 01/12/2020 Paul.  Save the state. 
		localStorage.setItem('showLeftCol', Credentials.showLeftCol.toString());
		this.setState({ showLeftCol: Credentials.showLeftCol });
	}

	public render()
	{
		const { showLeftCol } = this.state;
		//console.log((new Date()).toISOString() + ' ' + 'Sugar2006SideBar.render');
		// 08/08/2021 Paul.  height 100% is not working, but 100vh does work. 
		let themeUrl: string = Credentials.RemoteServer + 'App_Themes/' + SplendidCache.UserTheme + '/images/';
		return (
			<table cellPadding='0' cellSpacing='0' style={ {paddingTop: '10px', paddingLeft: '10px'} }>
				<tr>
					<td style={ {width: '8px', paddingTop: '6px', verticalAlign: 'top'} }>
						<img onClick={ this.toggleSideBar} style={ {cursor: 'pointer', width: '8px', height: '24px'} } src={ themeUrl + (showLeftCol ? 'hide.gif' : 'show.gif') } />
					</td>
					{ showLeftCol
					? <td className='lastViewPanel' style={ {width: '100vh', paddingTop: '6px', verticalAlign: 'top'} }>
						<Sugar2006Actions />
					</td>
					: null
					}
				</tr>
			</table>
		);
	}
}

export default withRouter(Sugar2006SideBar);
