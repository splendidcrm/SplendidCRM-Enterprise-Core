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
import React                                  from 'react'                             ;
import { observer }                           from 'mobx-react'                        ;
import { RouteComponentProps }                from '../Router5'                        ;
// 2. Store and Types. 
// 3. Scripts. 
import Credentials                            from '../scripts/Credentials'            ;
import SplendidCache                          from '../scripts/SplendidCache'          ;
import { Crm_Config }                         from '../scripts/Crm'                    ;
// 4. Components and Views. 
import { TopNavFactory, SideBarFactory }      from '../ThemeComponents'                ;
import TeamTree                               from '../components/TeamTree'            ;

interface IMainContentProps extends RouteComponentProps<any>
{
	children?: React.ReactNode;
}

@observer
export default class MainContent extends React.Component<IMainContentProps>
{
	constructor(props: IMainContentProps)
	{
		super(props);
	}

	async componentDidMount()
	{
	}

	componentWillUnmount()
	{
	}

	public render()
	{
		const { children } = this.props;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render', props);

		SplendidCache.IsInitialized;
		Credentials.sUSER_THEME;

		let userTheme: string = SplendidCache.UserTheme;
		let bEnableTeamManagement: boolean = Crm_Config.enable_team_management();
		let bEnableTeamHierarchy : boolean = Crm_Config.enable_team_hierarchy();

		let topNav  = TopNavFactory (userTheme);
		let sideBar = SideBarFactory(userTheme);
		// 10/26/2021 Paul.  Cleanup interface when in in AdminWizard or UserWizard. 
		let showTopNav  : boolean = Credentials.viewMode != 'AdminWizard' && Credentials.viewMode != 'UserWizard';
		let showSideBar : boolean = sideBar && SplendidCache.IsInitialized && Credentials.viewMode != 'AdministrationView' && Credentials.viewMode != 'UnifiedSearch' && (Credentials.viewMode != 'DashboardView' || SplendidCache.UserTheme == 'Sugar2006') && Credentials.viewMode != 'DashboardEditView' && Credentials.viewMode != 'AdminWizard' && Credentials.viewMode != 'UserWizard';
		let showTeamTree: boolean = bEnableTeamManagement && bEnableTeamHierarchy && SplendidCache.IsInitialized && (Credentials.viewMode == 'ListView' || Credentials.viewMode == 'DashboardView' || Credentials.viewMode == 'UnifiedSearch');
		// 04/03/2022 Paul.  Remove background-color white for Pacific theme. 
		let style: any = {display: 'flex', flexDirection: 'row', flexWrap: 'nowrap', height: '100%', width: '100%'};
		if ( userTheme != 'Pacific' )
			style.backgroundColor = 'white';
		return (<React.Fragment>
			{ showTopNav && topNav
			? React.createElement(topNav, {})
			: null
			}
			<div style={ style }>
				{ userTheme == 'Sugar2006'
				? <React.Fragment>
					<div id='divSideBar'>
					{ showSideBar
					? React.createElement(sideBar, {})
					: null
					}
					{ showTeamTree
					? <TeamTree />
					: null
					}
					</div>
				</React.Fragment>
				: <React.Fragment>
					{ showSideBar
					? React.createElement(sideBar, {})
					: null
					}
					{ showTeamTree
					? <TeamTree />
					: null
					}
				</React.Fragment>
				}
				<div id='appMainContent'>
					{ children }
				</div>
			</div>
			<br />
		</React.Fragment>);
	}
}
