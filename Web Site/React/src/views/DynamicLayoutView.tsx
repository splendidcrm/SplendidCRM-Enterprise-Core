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
import { RouteComponentProps, withRouter }            from '../Router5'              ;
import { FontAwesomeIcon }                            from '@fortawesome/react-fontawesome';
import { observer }                                   from 'mobx-react'                    ;
// 2. Store and Types. 
// 3. Scripts. 
import SplendidCache                                  from '../scripts/SplendidCache'      ;
import Credentials                                    from '../scripts/Credentials'        ;
import { DynamicLayout_Module }                       from '../scripts/DynamicLayout'      ;
import { AuthenticatedMethod, LoginRedirect }         from '../scripts/Login'              ;
import { DetailView_LoadItem, DetailView_LoadLayout } from '../scripts/DetailView'         ;
import { EditView_LoadItem, EditView_LoadLayout }     from '../scripts/EditView'           ;
import { ListView_LoadLayout }                        from '../scripts/ListView'           ;
// 4. Components and Views. 
import ErrorComponent                                 from '../components/ErrorComponent'  ;
import DetailView                                     from './DetailView'                  ;
import EditView                                       from './EditView'                    ;
import ListView                                       from './ListView'                    ;
import ReloadView                                     from './ReloadView'                  ;

interface IDynamicLayoutViewProps extends RouteComponentProps<any>
{
	MODULE_NAME        : string;
	ID                 : string;
	VIEW_NAME          : string;  // The view name does not include the module. 
	// 01/26/2021 Paul.  Now that the search view can be customized, we need to make sure it does not set the mode. 
	isSearchView?      : boolean;
	isUpdatePanel?     : boolean;
	isQuickCreate?     : boolean;
	// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
	isPrecompile?       : boolean;
	onComponentComplete?: (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, data) => void;
}

interface IDynamicLayoutViewState
{
	LAYOUT_NAME: string;
	customView?: any;
	error?     : any;
}

@observer
class DynamicLayoutView extends React.Component<IDynamicLayoutViewProps, IDynamicLayoutViewState>
{
	private _isMounted = false;

	constructor(props: IDynamicLayoutViewProps)
	{
		super(props);
		this.state = 
		{
			LAYOUT_NAME: (props.MODULE_NAME + '.' + props.VIEW_NAME)
		};
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidMount()
	{
		const { MODULE_NAME, ID, VIEW_NAME } = this.props;
		let { LAYOUT_NAME } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount ' + this.props.MODULE_NAME + ' ' + this.props.ID, LAYOUT_NAME);
		this._isMounted = true;
		try
		{
			// 01/21/2024 Paul.  LAYOUT_NAME is being set to undefined.undefined in constructor. 
			LAYOUT_NAME = (MODULE_NAME + '.' + VIEW_NAME);
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
			if ( status == 1 )
			{
				let customView = await DynamicLayout_Module(MODULE_NAME, null, VIEW_NAME);
				if ( customView == null )
				{
					// 08/16/2019 Paul.  Need to check for a valid ID as ArchiveView exists for ListViews and DetailViews. 
					// We should try not to do that again.  Unique view names make things easier. 
					if ( ID !== undefined )
					{
						// 02/02/2020 Paul.  Ignore missing during DynamicLayout. 
						let layout = DetailView_LoadLayout(LAYOUT_NAME, true);
						if ( layout != null )
						{
							customView = DetailView;
								Credentials.SetViewMode('DetailView');
						}
						else
						{
							// 02/02/2020 Paul.  Ignore missing during DynamicLayout. 
							layout = EditView_LoadLayout(LAYOUT_NAME, true);
							if ( layout != null )
							{
								customView = EditView;
								// 01/26/2021 Paul.  Now that the search view can be customized, we need to make sure it does not set the mode. 
								if ( !this.props.isSearchView && !this.props.isUpdatePanel && !this.props.isQuickCreate )
								{
									Credentials.SetViewMode('EditView');
								}
							}
							// 01/24/2024 Paul.  ReloadView is following through, so just use.
							else if ( MODULE_NAME === 'Reload' )
							{
								customView = ReloadView;
							}
						}
					}
					else
					{
						// 02/02/2020 Paul.  Ignore missing during DynamicLayout. 
						let layout = EditView_LoadLayout(LAYOUT_NAME, true);
						if ( layout != null )
						{
							customView = EditView;
							// 01/26/2021 Paul.  Now that the search view can be customized, we need to make sure it does not set the mode. 
							if ( !this.props.isSearchView && !this.props.isUpdatePanel && !this.props.isQuickCreate )
							{
								Credentials.SetViewMode('EditView');
							}
						}
						else
						{
							// 02/02/2020 Paul.  Ignore missing during DynamicLayout. 
							layout = ListView_LoadLayout(LAYOUT_NAME, true);
							if ( layout != null )
							{
								customView = ListView;
								Credentials.SetViewMode('ListView');
							}
							// 01/24/2024 Paul.  ReloadView is following through, so just use.
							else if ( MODULE_NAME === 'Reload' )
							{
								customView = ReloadView;
							}
						}
					}
				}
				// 05/26/2019 Paul.  The component may be unmounted by the time the custom view is generated. 
				if ( this._isMounted )
				{
					this.setState({ LAYOUT_NAME, customView });
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

	componentDidUpdate(prevProps: IDynamicLayoutViewProps)
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
		const { MODULE_NAME } = this.props;
		const { LAYOUT_NAME, customView, error } = this.state;
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
			return React.createElement(customView, { LAYOUT_NAME, ...this.props });
		}
		else if ( SplendidCache.IsInitialized && Credentials.bIsAuthenticated )
		{
			return <span>Layout not found for { LAYOUT_NAME } params: { JSON.stringify(this.props.params) }</span>;
		}
		else
		{
			return null;
		}
	}
}

export default withRouter(DynamicLayoutView);
