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
import { RouteComponentProps, withRouter }  from 'react-router-dom'                   ;
import { observer }                         from 'mobx-react'                         ;
// 2. Store and Types. 
import SHORTCUT                             from '../../types/SHORTCUT'               ;
// 3. Scripts. 
import Sql                                  from '../../scripts/Sql'                  ;
import L10n                                 from '../../scripts/L10n'                 ;
import SplendidCache                        from '../../scripts/SplendidCache'        ;
import Credentials                          from '../../scripts/Credentials'          ;
import { Crm_Modules }                      from '../../scripts/Crm'                  ;
import { StartsWith, ActiveModuleFromPath } from '../../scripts/utility'              ;
// 4. Components and Views.

interface IActionsProps extends RouteComponentProps<any>
{
}

interface IActionsState
{
	bIsAuthenticated   : boolean;
	activeModule       : string;
}

@observer
class Sugar2006Actions extends React.Component<IActionsProps, IActionsState>
{
	constructor(props: IActionsProps)
	{
		super(props);
		let activeModule: string = ActiveModuleFromPath(this.props.location.pathname, this.constructor.name + '.constructor');
		this.state =
		{
			bIsAuthenticated   : false,
			activeModule       ,
		};
	}

	async componentDidMount()
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount');
		// 05/28/2019 Paul.  Use a passive IsAuthenticated check (instead of active server query), so that we do not have multiple simultaneous requests. 
		let bAuthenticated: boolean = Credentials.bIsAuthenticated;
		if ( !bAuthenticated )
		{
			// 05/02/2019 Paul.  Each view will be responsible for checking authenticated. 
		}
		else
		{
			// 05/29/2019 Paul.  We can't get these values in the constructor as the user may not be authenticated and therefore would not exist. 
			this.setState({ bIsAuthenticated: bAuthenticated });
		}
	}

	async componentDidUpdate(prevProps: IActionsProps)
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidUpdate', this.props.location.pathname, prevProps.location.pathname, txtQuickSearch);
		// 12/10/2019 Paul.  With a deep link, the cache will not be loaded, so the activeModule will not be set. 
		if ( this.props.location.pathname != prevProps.location.pathname || Sql.IsEmptyString(this.state.activeModule) )
		{
			let activeModule: string = ActiveModuleFromPath(this.props.location.pathname, this.constructor.name + '.componentDidUpdate');
			if ( activeModule != this.state.activeModule )
			{
				this.setState({ activeModule });
			}
		}
	}

	/*
	shouldComponentUpdate(nextProps: IActionsProps, nextState: IActionsState)
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate');
		return true;
	}
	*/

	// 04/29/2019 Paul.  componentWillReact?  Should be componentWillUpdate. 
	async componentWillUpdate(nextProps: IActionsProps)
	{
		const { bIsAuthenticated } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentWillUpdate', this.props.location.pathname, nextProps.location.pathname, txtQuickSearch);
		// 05/28/2019 Paul.  Use a passive IsAuthenticated check (instead of active server query), so that we do not have multiple simultaneous requests. 
		// 05/28/2019 Paul.  Track the authentication change so that we an clear the menus appropriately. 
		let bAuthenticated: boolean = Credentials.bIsAuthenticated;
		if ( bIsAuthenticated != bAuthenticated )
		{
			this.setState({ bIsAuthenticated: bAuthenticated });
		}
	}

	private _onAction = (item) =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onAction', item);
		this.props.history.push('/Reset/' + item.key);
	}

	public render()
	{
		const { bIsAuthenticated, activeModule } = this.state;
	
		//03/06/2019. Chase. Referencing ADMIN_MODE triggers re-renders when it's updated;
		Credentials.ADMIN_MODE;
		// 04/29/2019 Paul.  When FAVORITES, LAST_VIEWED or SAVED_SEARCH changes, increment this number.  It is watched in the Actions. 
		SplendidCache.NAV_MENU_CHANGE;

		let links = [];
		let bLoading = StartsWith(this.props.location.pathname, '/Reload');
		if ( SplendidCache.IsInitialized && bIsAuthenticated && !bLoading )
		{
			let shortcuts: SHORTCUT[] = SplendidCache.Shortcuts(activeModule);
			if ( shortcuts != null )
			{
				for ( let i = 0; i < shortcuts.length; i++ )
				{
					let shortcut: SHORTCUT = shortcuts[i];
					if ( shortcut.SHORTCUT_ACLTYPE == 'archive' )
					{
						// 09/26/2017 Paul.  If the module does not have an archive table, then hide the link. 
						let bArchiveEnabled: boolean = Crm_Modules.ArchiveEnabled(shortcut.MODULE_NAME);
						if ( !bArchiveEnabled )
							continue;
					}
					let nSHORTCUT_ACLTYPE = SplendidCache.GetUserAccess(shortcut.MODULE_NAME, shortcut.SHORTCUT_ACLTYPE, this.constructor.name + '.Actions');
					if ( nSHORTCUT_ACLTYPE >= 0 )
					{
						let sDISPLAY_NAME : string = L10n.Term(shortcut.DISPLAY_NAME);
						let sRELATIVE_PATH: string = shortcut.RELATIVE_PATH;
						sRELATIVE_PATH = sRELATIVE_PATH.replace('~/'                         , ''            );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/default.aspx?ArchiveView=1', '/ArchiveView');
						sRELATIVE_PATH = sRELATIVE_PATH.replace('~/Users/reassign.aspx'      , '/Administration/Users/Reassign');
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/default.aspx'              , '/List'       );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/edit.aspx'                 , '/Edit'       );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/import.aspx'               , '/Import'     );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/stream.aspx'               , '/Stream'     );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/sequence.aspx'             , '/Sequence'   );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/statistics.aspx'           , '/Statistics' );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/config.aspx'               , '/Config'     );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/Drafts.aspx'               , '/Drafts'     );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/MyFeeds.aspx'              , '/MyFeeds'    );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('/ByUser.aspx'               , '/ByUser'     );
						sRELATIVE_PATH = sRELATIVE_PATH.replace('.aspx'                      , ''            );
						let lnk =
						{
							label      : sDISPLAY_NAME       ,
							key        : sRELATIVE_PATH      ,
							MODULE_NAME: shortcut.MODULE_NAME,
							IMAGE_NAME : shortcut.IMAGE_NAME ,
							command    : this._onAction      ,
						};
						links.push(lnk);
					}
				}
			}
		}
		if ( SplendidCache.IsInitialized )
		{
			let themeUrl: string = Credentials.RemoteServer + 'App_Themes/' + SplendidCache.UserTheme + '/images/';
			return (<div>
				<table className='leftColumnModuleHead' cellSpacing='1' cellPadding='0' style={ {width: '100%', border: '0'} }>
					<tbody>
						<tr>
							<th style={ {width: '5px'} }><img src={ themeUrl + 'moduleTab_left.gif' } style={ {borderWidth: '0px', height: '23px', width: '5px'} } /></th>
							<th className='moduleTab_middle' style={{ width: '100%'} }>{ L10n.Term('.LBL_SHORTCUTS') }</th>
							<th style={ {width: '9px'} }><img src={ themeUrl + 'moduleTab_right.gif' } style={ {borderWidth: '0px', height: '23px', width: '7px'} } /></th>
						</tr>
					</tbody>
				</table>
				{
					links && links.map((item) => 
					(
						<table className='subMenu' cellPadding='0' cellSpacing='0' style={ {width: '100%', border: '0'} }>
							<tbody>
								<tr>
									<td className='subMenuTDIcon' style={ {width: '16px'} }>
										<a href='#' className='subMenuLink' onClick={ (e) => { e.preventDefault(); this._onAction(item); } }>
											<img src={ themeUrl + item.IMAGE_NAME } height='16' width='16' />
										</a>
									</td>
									<td id='Leads.LNK_LEAD_LIST' className='subMenuTD' onClick={ (e) => { e.preventDefault(); this._onAction(item); } } style={ {cursor: 'auto'} }>&nbsp;
										<a href='#' className='subMenuLink' onClick={ (e) => { e.preventDefault(); this._onAction(item); } }>{ item.label }</a>
									</td>
								</tr>
							</tbody>
						</table>
					))
				}
			<img src={ themeUrl + 'spacer.gif' } style={ {height: '1px', width: '180px'} } /><br />
			</div>);
		}
		return null;
	}
}

export default withRouter(Sugar2006Actions);

