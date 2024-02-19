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
import { RouteComponentProps, withRouter }    from '../Router5'              ;
import { FontAwesomeIcon }                    from '@fortawesome/react-fontawesome';
import { observer }                           from 'mobx-react'                    ;
// 2. Store and Types. 
// 3. Scripts. 
import Credentials                            from '../scripts/Credentials'        ;
import SplendidCache                          from '../scripts/SplendidCache'      ;
import { DynamicLayout_Module }               from '../scripts/DynamicLayout'      ;
import { AuthenticatedMethod, LoginRedirect } from '../scripts/Login'              ;
// 4. Components and Views. 
import ErrorComponent                         from '../components/ErrorComponent'  ;
import AdminDetailView                        from './AdminDetailView'             ;

interface IDynamicAdminDetailViewProps extends RouteComponentProps<any>
{
	MODULE_NAME: string;
	ID         : string;
	// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
	isPrecompile?       : boolean;
	onComponentComplete?: (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, vwMain) => void;
}

interface IDynamicAdminDetailViewState
{
	customView?: any;
	error?     : any;
}

@observer
class DynamicAdminDetailView extends React.Component<IDynamicAdminDetailViewProps, IDynamicAdminDetailViewState>
{
	private _isMounted = false;

	constructor(props: IDynamicAdminDetailViewProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor', props);
		Credentials.SetViewMode('AdminDetailView');
		this.state = {};
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidMount()
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount ' + this.props.MODULE_NAME + ' ' + this.props.ID);
		this._isMounted = true;
		try
		{
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
			if ( status == 1 )
			{
				let sLAYOUT_NAME = 'DetailView';
				let customView = await DynamicLayout_Module(this.props.MODULE_NAME, 'DetailViews', sLAYOUT_NAME);
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor ' + (customView ? 'custom' : 'default') + ' view ' + this.props.MODULE_NAME + '.' + sLAYOUT_NAME);
				// 05/26/2019 Paul.  The component may be unmounted by the time the custom view is generated. 
				if ( this._isMounted )
				{
					this.setState({ customView });
				}
			}
			else
			{
				LoginRedirect(this.props.history, this.constructor.name + '.componentDidMount');
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			this.setState({ error });
		}
	}

	componentDidUpdate(prevProps: IDynamicAdminDetailViewProps)
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidUpdate ' + this.props.MODULE_NAME + ' ' + this.props.ID);
		// 01/19/2021 Paul.  A user may click the browser back button from one detail view to another.  Detect and reset so that the correct custom view is loaded. 
		if ( this.props.location.pathname != prevProps.location.pathname )
		{
			this.props.history.push('/Reset' + this.props.location.pathname + this.props.location.search);
		}
	}

	componentWillUnmount()
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentWillUnmount ' + this.props.MODULE_NAME + ' ' + this.props.ID);
		this._isMounted = false;
	}

	public render()
	{
		const { customView, error } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render ' + this.props.MODULE_NAME + ' ' + this.props.ID);
		// 06/27/2019 Paul.  Reference obserable IsInitialized so that terminology update will cause refresh. 
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
		else if ( SplendidCache.IsInitialized && customView )
		{
			// 06/26/2019 Paul.  Specify a key so that SplendidGrid will get componentDidMount when changing views. 
			return React.createElement(customView, { key: this.props.MODULE_NAME, ...this.props });
		}
		else if ( SplendidCache.IsInitialized && Credentials.bIsAuthenticated )
		{
			// 06/26/2019 Paul.  Specify a key so that SplendidGrid will get componentDidMount when changing views. 
			return <AdminDetailView key={ this.props.MODULE_NAME } {...this.props} />;
		}
		else
		{
			return null;
		}
	}
}

export default withRouter(DynamicAdminDetailView);
