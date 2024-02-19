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
import { RouteComponentProps, withRouter, Navigate } from '../Router5'                    ;
import { observer }                                  from 'mobx-react'                    ;
// 2. Store and Types. 
// 3. Scripts. 
import Credentials                                   from '../scripts/Credentials'        ;
import SplendidCache                                 from '../scripts/SplendidCache'      ;
import { StartsWith }                                from '../scripts/utility'            ;
// 4. Components and Views. 
import MainContent                                   from '../ThemeComponents/MainContent';

interface IResetViewProps extends RouteComponentProps<any>
{
}

interface IResetViewPropsState
{
	sRedirectUrl: string | null;
	resetCount: number;
}

@observer
class ResetView extends React.Component<IResetViewProps, IResetViewPropsState>
{
	private timerID = null;

	constructor(props: IResetViewProps)
	{
		super(props);
		this.state =
		{
			sRedirectUrl: null,
			resetCount: 0,
		};
	}

	async componentDidMount()
	{
		const { history, location } = this.props;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', this.props);
		let sRedirectUrl: string = '';
		// 06/25/2019 Paul.  Remove the /Reset and continue along the path. 
		if ( location.pathname.length >= 6 )
		{
			// 10/11/2019 Paul.  Include the query parameters. 
			sRedirectUrl = location.pathname.substring(6) + location.search;
			if ( Credentials.bMOBILE_CLIENT )
			{
				if ( StartsWith(sRedirectUrl, '/android_asset/www') )
				{
					sRedirectUrl = sRedirectUrl.substring(18);
				}
				if ( sRedirectUrl == '/index.html' )
				{
					sRedirectUrl = '';
				}
			}
		}
		if ( sRedirectUrl == '' )
		{
			sRedirectUrl = '/Home';
		}
		// 02/10/2024 Paul.  PrivateRoute gets too many calls per click. 
		localStorage.setItem('ReactLastActiveModule', sRedirectUrl);
		// 01/21/2024 Paul.  replace not actually being followed. 
		history.replace(sRedirectUrl);
		// 02/02/2024 Paul.  Navigate component seems to work. 
		this.setState({ sRedirectUrl, resetCount: 1 });
		this.timerID = setInterval(this.ResetTimer, 1000);
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidUpdate(prevProps: IResetViewProps)
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidUpdate', prevProps);
		if ( (this.props.location && prevProps.location) && this.props.location.pathname != prevProps.location.pathname )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidUpdate pathname change', this.props.location.pathname, prevProps.location.pathname);
		}
	}

	componentWillUnmount()
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentWillUnmount');
		if ( this.timerID != null )
		{
			clearInterval(this.timerID);
		}
	}

	ResetTimer = () =>
	{
		const { history } = this.props;
		const { sRedirectUrl } = this.state;
		let { resetCount } = this.state;
		console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.ResetTimer', sRedirectUrl, resetCount);
		// 02/11/2024 Paul.  there seem to be times when Reset dies not navigate.  Keep trying. 
		resetCount++;
		this.setState({ resetCount });
		history.replace(sRedirectUrl);
	}


	public render()
	{
		const { history, location } = this.props;
		const { sRedirectUrl, resetCount } = this.state;
		
		// 02/10/2024 Paul.  observing IsInitialized is required, otherwise Reset gets stuck after login. 
		SplendidCache.IsInitialized;
		// 09/11/2019 Paul.  After authentication, we need to make sure that the app gets updated. 
		Credentials.sUSER_THEME;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render', this.props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render children', this.props.children);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render', sRedirectUrl, resetCount);
		return (<MainContent>
			<div style={ {fontSize: '20px', fontWeight: 'bold', padding: '20px'} }>
				Reset: { JSON.stringify(location) }
				{ sRedirectUrl
				? <Navigate to={ sRedirectUrl } replace={ true } />
				: null
				}
			</div>
		</MainContent>);
	}
}

export default withRouter(ResetView);
