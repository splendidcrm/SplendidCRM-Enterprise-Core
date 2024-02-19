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
import { RouteComponentProps, withRouter }           from '../Router5'              ;
import { FontAwesomeIcon }                           from '@fortawesome/react-fontawesome';
import { observer }                                  from 'mobx-react'                    ;
// 2. Store and Types. 
// 3. Scripts. 
import Sql                                           from '../scripts/Sql'                ;
import L10n                                          from '../scripts/L10n'               ;
import Credentials                                   from '../scripts/Credentials'        ;
import SplendidCache                                 from '../scripts/SplendidCache'      ;
import { Application_GetReactLoginState }            from '../scripts/Application'        ;
import { DynamicLayout_Module }                      from '../scripts/DynamicLayout'      ;
// 4. Components and Views. 
import { RouterStore }                               from 'mobx-react-router'             ;
import ErrorComponent                                from '../components/ErrorComponent'  ;
import LoginView                                     from './LoginView'                   ;

interface ILoginViewProps extends RouteComponentProps<any>
{
	routing?             : RouterStore;
	initState?           : any;
}

interface ILoginViewState
{
	customView?      : any;
	error?           : any;
}

// 12/07/2022 Paul.  Allow the LoginView to be customized. 
@observer
class DynamicLoginView extends React.Component<ILoginViewProps, ILoginViewState>
{
	private _isMounted = false;

	constructor(props: ILoginViewProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor');
		this.state = {};
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidMount()
	{
		this._isMounted = true;
		try
		{
			SplendidCache.Reset();
			if ( !Credentials.bMOBILE_CLIENT || !Sql.IsEmptyString(Credentials.RemoteServer) )
				await Application_GetReactLoginState();
			let customView = await DynamicLayout_Module('Home', 'EditViews', 'LoginView');
			if ( this._isMounted )
			{
				this.setState({ customView });
			}
		}
		catch(error)
		{
			this.setState({ error: error.message });
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
		}
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}

	public render()
	{
		const { customView, error } = this.state;
		if ( error )
		{
			return <ErrorComponent error={error} />;
		}
		else if ( customView === undefined )
		{
			return (
			<div id={ this.constructor.name + '_spinner' } style={ {textAlign: 'center'} }>
				<FontAwesomeIcon icon="spinner" spin={ true } size="5x" />
			</div>);
		}
		else if ( customView )
		{
			return React.createElement(customView, { ...this.props });
		}
		else
		{
			return <LoginView { ...this.props } />;
		}
	}
}

export default withRouter(DynamicLoginView);
