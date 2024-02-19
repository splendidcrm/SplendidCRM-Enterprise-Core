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
import { RouteComponentProps }                from '../Router5'                      ;
import moment from 'moment';
import { observer }                           from 'mobx-react'                            ;
import { FontAwesomeIcon }                    from '@fortawesome/react-fontawesome'        ;
// 2. Store and Types. 
// 3. Scripts. 
import Sql                                    from '../../scripts/Sql'                     ;
import Security                               from '../../scripts/Security'                ;
import Credentials                            from '../../scripts/Credentials'             ;
import SplendidCache                          from '../../scripts/SplendidCache'           ;
import { AuthenticatedMethod, LoginRedirect } from '../../scripts/Login'                   ;
import { jsonReactState }                     from '../../scripts/Application'             ;
// 4. Components and Views. 
import EditView                               from './EditView'                            ;

interface IEditViewProps extends RouteComponentProps<any>
{
	MODULE_NAME        : string;
	ID?                : string;
	LAYOUT_NAME        : string;
	callback?          : any;
	rowDefaultSearch?  : any;
	onLayoutLoaded?    : any;
	onSubmit?          : any;
	isSearchView?      : boolean;
	isUpdatePanel?     : boolean;
	isQuickCreate?     : boolean;
	DuplicateID?       : string;
	ConvertModule?     : string;
	ConvertID?         : string;
}

// 09/18/2019 Paul.  Give class a unique name so that it can be debugged.  Without the unique name, Chrome gets confused.
@observer
export default class MyAccountEdit extends React.Component<IEditViewProps>
{
	constructor(props: IEditViewProps)
	{
		super(props);
	}

	async componentDidMount()
	{
		try
		{
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
			if ( status == 1 )
			{
				if ( jsonReactState == null )
				{
					//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount jsonReactState is null');
				}
				if ( Credentials.ADMIN_MODE )
				{
					Credentials.SetADMIN_MODE(false);
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

	public render()
	{
		let props: IEditViewProps = Object.assign({}, this.props);
		props.MODULE_NAME      = 'Users';
		props.ID               = Security.USER_ID();
		props.LAYOUT_NAME      = 'Users.EditView';
		props.callback         = null;
		props.rowDefaultSearch = null;
		props.onLayoutLoaded   = null;
		props.onSubmit         = null;
		props.isSearchView     = null;
		props.isUpdatePanel    = null;
		props.isQuickCreate    = null;
		props.DuplicateID      = null;
		props.ConvertModule    = null;
		props.ConvertID        = null;
		if ( SplendidCache.IsInitialized )
		{
			return (<EditView { ...props } MyAccount={ true } />);
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

// 07/18/2019 Paul.  We don't want to use withRouter() as it makes it difficult to get a reference. 

