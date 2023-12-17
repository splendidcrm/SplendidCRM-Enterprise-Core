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
import posed                                        from 'react-pose'                             ;
import { RouteComponentProps, withRouter }          from 'react-router-dom'                       ;
import { observer }                                 from 'mobx-react'                             ;
import { FontAwesomeIcon }                          from '@fortawesome/react-fontawesome'         ;
import { Appear }                                   from 'react-lifecycle-appear'                 ;
import TreeView                                     from 'react-treeview'                         ;
// 2. Store and Types. 
import DETAILVIEWS_RELATIONSHIP                     from '../../../types/DETAILVIEWS_RELATIONSHIP';
import { SubPanelHeaderButtons }                    from '../../../types/SubPanelHeaderButtons'   ;
// 3. Scripts. 
import Sql                                          from '../../../scripts/Sql'                   ;
import L10n                                         from '../../../scripts/L10n'                  ;
import Credentials                                  from '../../../scripts/Credentials'           ;
import SplendidCache                                from '../../../scripts/SplendidCache'         ;
import { Crm_Config, Crm_Modules }                  from '../../../scripts/Crm'                   ;
import { CreateSplendidRequest, GetSplendidResult } from '../../../scripts/SplendidRequest'       ;
// 4. Components and Views. 
import SubPanelButtonsFactory                       from '../../../ThemeComponents/SubPanelButtonsFactory';

const Content = posed.div(
{
	open:
	{
		height: '100%'
	},
	closed:
	{
		height: 0
	}
});

interface ISubPanelViewProps extends RouteComponentProps<any>
{
	PARENT_TYPE      : string;
	row              : any;
	layout           : DETAILVIEWS_RELATIONSHIP;
	CONTROL_VIEW_NAME: string;
	// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
	isPrecompile?       : boolean;
	onComponentComplete?: (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, data) => void;
}

interface ISubPanelViewState
{
	team?            : any;
	__sql?           : string;
	PARENT_ID        : string;
	error?           : any;
	open             : boolean;
	subPanelVisible  : boolean;
}

@observer
class TeamsHierarchy extends React.Component<ISubPanelViewProps, ISubPanelViewState>
{
	private _isMounted = false;

	private headerButtons        = React.createRef<SubPanelHeaderButtons>();

	constructor(props: ISubPanelViewProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor ' + props.PARENT_TYPE, props.layout);

		// 11/10/2020 Paul.  A customer wants to be able to have subpanels default to open. 
		let rawOpen        : string  = localStorage.getItem(props.CONTROL_VIEW_NAME);
		// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
		let open           : boolean = (rawOpen == 'true' || this.props.isPrecompile);
		if ( rawOpen == null && Crm_Config.ToBoolean('default_subpanel_open') )
		{
			open = true;
		}
		this.state =
		{
			PARENT_ID        : props.row.ID,
			error            : null,
			open             ,
			subPanelVisible  : Sql.ToBoolean(props.isPrecompile),  // 08/31/2021 Paul.  Must show sub panel during precompile to allow it to continue. 
		};
	}

	async componentDidMount()
	{
		const { PARENT_ID } = this.state;
		this._isMounted = true;
		try
		{
			let res = await CreateSplendidRequest('Administration/Rest.svc/GetTeamTree?ID=' + PARENT_ID, 'GET');
			let json = await GetSplendidResult(res);
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', json);
			this.setState(
			{
				team : json.d,
				__sql: json.__sql
			});
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			this.setState({ error });
		}
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidUpdate(prevProps: ISubPanelViewProps)
	{
		const { PARENT_TYPE, CONTROL_VIEW_NAME } = this.props;
		const { team, error } = this.state;
		// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
		if ( this.props.onComponentComplete )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onComponentComplete ' + DETAIL_NAME, item);
			if ( error == null && team != null )
			{
				this.props.onComponentComplete(PARENT_TYPE, null, CONTROL_VIEW_NAME, null);
			}
		}
	}

	private onToggleCollapse = (open) =>
	{
		const { CONTROL_VIEW_NAME } = this.props;
		this.setState({ open }, () =>
		{
			if ( open )
			{
				localStorage.setItem(CONTROL_VIEW_NAME, 'true');
			}
			else
			{
				// 11/10/2020 Paul.  Save false instead of remove so that config value default_subpanel_open will work properly. 
				//localStorage.removeItem(CONTROL_VIEW_NAME);
				localStorage.setItem(CONTROL_VIEW_NAME, 'false');
			}
		});
	}

	private _onClickTeam = async (team) =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onClickTeam', team);
		this.props.history.push('/Reset/Administration/Teams/View/' + team.ID);
	}

	private renderTeamTree = (TEAMS) =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.renderTeamTree', TEAMS);
		return TEAMS && TEAMS.map(team =>
		{
			const label = <a href='#' className='teamTreeItem' onClick={ (e) => { e.preventDefault(); this._onClickTeam(team); } }>{ team.NAME }</a>;
			if ( team.TEAMS == null )
			{
				return (
				<div className='tree-view_item teamTreeItem' style={ {paddingLeft: '22px', whiteSpace: 'nowrap'} }>
					{ label }
				</div>);
			}
			else
			{
				return (<TreeView nodeLabel={ label } key={ 'tree_' + team.ID } defaultCollapsed={ false } itemClassName='teamTreeItem'>
					{ team.TEAMS
					? this.renderTeamTree(team.TEAMS)
					: null
					}
				</TreeView>);
			}
		});
	}
	
	public render()
	{
		const { layout, CONTROL_VIEW_NAME } = this.props;
		const { team, error, open, subPanelVisible } = this.state;
		if ( SplendidCache.IsInitialized && team )
		{
			Credentials.sUSER_THEME;
			let headerButtons = SubPanelButtonsFactory(SplendidCache.UserTheme);
			let MODULE_TITLE     : string = L10n.Term(layout.TITLE);
			const label = <a href='#' className='teamTreeItem' onClick={ (e) => { e.preventDefault(); this._onClickTeam(team); } }>{ team.NAME }</a>;
			// 07/30/2021 Paul.  Load when the panel appears. 
			return (
				<React.Fragment>
					<Appear onAppearOnce={ (ioe) => this.setState({ subPanelVisible: true }) }>
						{ headerButtons
						? React.createElement(headerButtons, { ID: null, MODULE_TITLE, CONTROL_VIEW_NAME, error, ButtonStyle: 'ListHeader', VIEW_NAME: 'Teams.Hierarchy', onToggle: this.onToggleCollapse, isPrecompile: this.props.isPrecompile, history: this.props.history, location: this.props.location, match: this.props.match, ref: this.headerButtons })
						: null
						}
					</Appear>
					<Content pose={ open ? 'open' : 'closed' } style={ {overflow: (open ? 'visible' : 'hidden')} }>
						{ open && subPanelVisible
						? <React.Fragment>
							{ team.TEAMS == null
							? <div className='tree-view_item teamTreeItem' style={ {paddingLeft: '22px', whiteSpace: 'nowrap'} }>
								{ team.NAME }
							</div>
							: <TreeView nodeLabel={ label } key={ 'tree_' + team.ID } defaultCollapsed={ false } itemClassName='teamTreeItem'>
								{ team.TEAMS
								? this.renderTeamTree(team.TEAMS)
								: null
								}
							</TreeView>
							}
						</React.Fragment>
						: null
						}
					</Content>
				</React.Fragment>
			);
		}
		else
		{
			return (
			<div id={ this.constructor.name + '_spinner' } style={ {textAlign: 'center'} }>
				<FontAwesomeIcon icon="spinner" spin={ true } size="5x" />
			</div>);
		}
	}
}

export default withRouter(TeamsHierarchy);
