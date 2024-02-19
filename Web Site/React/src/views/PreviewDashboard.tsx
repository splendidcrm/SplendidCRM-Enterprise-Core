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
import { XMLParser, XMLBuilder }           from 'fast-xml-parser'               ;
import { RouteComponentProps, withRouter } from '../Router5'                    ;
import { FontAwesomeIcon }                 from '@fortawesome/react-fontawesome';
// 2. Store and Types. 
// 3. Scripts. 
import L10n                                from '../scripts/L10n'               ;
import Credentials                         from '../scripts/Credentials'        ;
// 4. Components and Views. 
import Preview                             from '../components/Preview'         ;

interface IPreviewDashboardProps extends RouteComponentProps<any>
{
	MODULE_NAME: string;
	ID         : string;
}

interface IPreviewDashboardState
{
	showDashboard: boolean;
}

class PreviewDashboard extends React.Component<IPreviewDashboardProps, IPreviewDashboardState>
{
	constructor(props: IPreviewDashboardProps)
	{
		super(props);
		this.state =
		{
			showDashboard: false,
		};
	}

	shouldComponentUpdate(nextProps: IPreviewDashboardProps, nextState: IPreviewDashboardState)
	{
		if ( nextProps.ID != this.props.ID )
		{
			if ( !this.state.showDashboard && !nextState.showDashboard )
			{
				this.setState({ showDashboard: true });
			}
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate', nextProps);
			return true;
		}
		else if ( nextState.showDashboard != this.state.showDashboard )
		{
			return true;
		}
		return false;
	}

	private togglePreviewDashboard = (e) =>
	{
		this.setState({ showDashboard: !this.state.showDashboard });
	}

	public render()
	{
		const { MODULE_NAME, ID } = this.props;
		const { showDashboard } = this.state;
		// 10/05/2020 Paul.  The module abbreviation may not exist and it looks ugly to have the label. 
		let MODULE_ABBREVIATION: string = L10n.Term(MODULE_NAME + '.LBL_MODULE_ABBREVIATION');
		if ( MODULE_ABBREVIATION && MODULE_ABBREVIATION.indexOf('LBL_MODULE_ABBREVIATION') >= 0 )
		{
			MODULE_ABBREVIATION = '';
		}
		// 11/03/2020 Paul.  Preview panel only applies to Seven theme. 
		return (
			<React.Fragment>
				{ Credentials.sUSER_THEME == 'Seven'
				? <div style={ {width: '16px', paddingTop: '8px', paddingLeft: '4px'} }>
					<img onClick={ this.togglePreviewDashboard } style={ {cursor: 'pointer', width: '8px', height: '25px'} } src={ Credentials.RemoteServer + 'App_Themes/Seven/images/' + (showDashboard ? 'show.gif' : 'hide.gif') } />
				</div>
				: null
				}
				{ showDashboard
				? <div style={ {width: '24%', paddingLeft: '4px'} }>
					<table className='moduleTitle ModuleHeaderFrame' cellPadding={ 0 } cellSpacing={ 1 } style={ {width: '100%'} }>
						<tr>
							<td style={ {verticalAlign: 'top'} }>
								<span className={ 'ModuleHeaderModule ModuleHeaderModule' + MODULE_NAME }>{ MODULE_ABBREVIATION }</span>
							</td>
							<td style={ {width: '99%'} }>
								<h2><span>{ L10n.Term('.LBL_PREVIEW') }</span></h2>
							</td>
							<td style={ {textAlign: 'right', paddingRight: '5px'} }>
								<span onClick={ this.togglePreviewDashboard } style={ {cursor: 'pointer'} } >
									<FontAwesomeIcon icon='minus-circle' size='lg' />
								</span>
							</td>
						</tr>
					</table>
					<Preview MODULE_NAME={ MODULE_NAME } ID={ ID } LAYOUT_NAME='DetailView.Preview' />
				</div>
				: null
				}
			</React.Fragment>
		);
	}
}

export default withRouter(PreviewDashboard);
