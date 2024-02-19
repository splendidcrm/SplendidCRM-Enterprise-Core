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
import { RouteComponentProps, withRouter }  from '../Router5'                   ;
import { observer }                         from 'mobx-react'                         ;
// 2. Store and Types. 
import MODULE                               from '../../types/MODULE'                 ;
// 3. Scripts. 
import Sql                                  from '../../scripts/Sql'                  ;
import L10n                                 from '../../scripts/L10n'                 ;
import SplendidCache                        from '../../scripts/SplendidCache'        ;
import Credentials                          from '../../scripts/Credentials'          ;
import { StartsWith, ActiveModuleFromPath } from '../../scripts/utility'              ;
// 4. Components and Views.

interface IFavoritesProps extends RouteComponentProps<any>
{
}

interface IFavoritesState
{
	bIsAuthenticated   : boolean;
	activeModule       : string;
}

@observer
class ArcticFavorites extends React.Component<IFavoritesProps, IFavoritesState>
{
	constructor(props: IFavoritesProps)
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

	async componentDidUpdate(prevProps: IFavoritesProps)
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

	async componentWillUpdate(nextProps: IFavoritesProps)
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

	private _onFavorite = (item) =>
	{
		const { activeModule } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onFavorite ' + sMODULE_NAME, item);
		let module:MODULE = SplendidCache.Module(activeModule, this.constructor.name + '._onFavorite');
		if ( module.IS_ADMIN )
		{
			this.props.history.push('/Reset/Administration/' + activeModule + '/View/' + item.ID)
		}
		else
		{
			this.props.history.push('/Reset/' + activeModule + '/View/' + item.ID)
		}
	}

	public render()
	{
		const { bIsAuthenticated, activeModule } = this.state;
	
		//03/06/2019. Chase. Referencing ADMIN_MODE triggers re-renders when it's updated;
		Credentials.ADMIN_MODE;
		// 04/29/2019 Paul.  When FAVORITES, LAST_VIEWED or SAVED_SEARCH changes, increment this number.  It is watched in the Favorites. 
		SplendidCache.NAV_MENU_CHANGE;

		let links = [];
		let bLoading = StartsWith(this.props.location.pathname, '/Reload');
		if ( SplendidCache.IsInitialized && bIsAuthenticated && !bLoading )
		{
			links = SplendidCache.Favorites(activeModule);
		}
		return SplendidCache.IsInitialized && (
			<div id='divFavorites' className='lastView' style={ {width: '100%'} }>
				<h1><span>{ L10n.Term('.LBL_FAVORITES') }</span></h1>
				{
					links && links.map((item) => 
					(
						<div className='lastViewRecentViewed' style={ {cursor: 'pointer'} } onClick={ (e) => this._onFavorite(item) }>
							<a key={ 'fav_' + item.key } href='#' title={ item.NAME } className='lastViewLink' onClick={ (e) => { e.preventDefault(); this._onFavorite(item); } }>{ item.NAME }</a>
						</div>
					))
				}
			</div>
		);
	}
}

export default withRouter(ArcticFavorites);

