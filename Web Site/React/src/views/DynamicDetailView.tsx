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
import { RouteComponentProps, withRouter }    from 'react-router-dom'              ;
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
import DetailView                             from './DetailView'                  ;

interface IDynamicDetailViewProps extends RouteComponentProps<any>
{
	MODULE_NAME: string;
	ID         : string;
	// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
	isPrecompile?       : boolean;
	onComponentComplete?: (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, data) => void;
}

interface IDynamicDetailViewState
{
	customView?: any;
	error?     : any;
}

@observer
class DynamicDetailView extends React.Component<IDynamicDetailViewProps, IDynamicDetailViewState>
{
	private _isMounted = false;

	constructor(props: IDynamicDetailViewProps)
	{
		super(props);
		Credentials.SetViewMode('DetailView');
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
				// 07/05/2020 Paul.  We need to make sure that the Users module is treated as an admin module. 
				let module = SplendidCache.Module(this.props.MODULE_NAME, 'DynamicDetailView.componentDidMount');
				if ( module != null )
				{
					if ( module.IS_ADMIN )
					{
						// 01/23/2021 Paul.  Prevent /Administration/Administration. 
						if ( this.props.location.pathname.indexOf('/Administration') < 0 )
						{
							this.props.history.push('/Reload/Administration' + this.props.location.pathname + this.props.location.search);
							return;
						}
					}
				}
				
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

	componentDidUpdate(prevProps: IDynamicDetailViewProps)
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidUpdate', prevProps);
		// 01/19/2021 Paul.  A user may click the browser back button from one detail view to another.  Detect and reset so that the correct custom view is loaded. 
		if ( this.props.location.pathname != prevProps.location.pathname )
		{
			this.props.history.push('/Reset' + this.props.location.pathname + this.props.location.search);
		}
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}

	public render()
	{
		const { customView, error } = this.state;
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
			return React.createElement(customView, { ...this.props });
		}
		else if ( SplendidCache.IsInitialized && Credentials.bIsAuthenticated )
		{
			return <DetailView {...this.props} />;
		}
		else
		{
			return null;
		}
	}
}

export default withRouter(DynamicDetailView);
