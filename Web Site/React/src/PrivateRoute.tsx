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
import { Redirect, Route, RouteComponentProps, RouteProps, withRouter } from 'react-router-dom';
import { observer }                           from 'mobx-react'             ;
// 2. Store and Types. 
// 3. Scripts. 
import { AuthenticatedMethod, LoginRedirect } from './scripts/Login'        ;
import { StartsWith }                         from './scripts/utility'      ;
// 4. Components and Views. 

type Props =
{
	computedMatch?: any
} & RouteProps & RouteComponentProps<any>;

@observer
class PrivateRoute extends React.Component<Props>
{
	constructor(props: Props)
	{
		super(props);
	}

	async componentDidMount()
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', this.props.location.pathname + this.props.location.search);
		try
		{
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
			if ( status == 0 && !StartsWith(this.props.location.pathname, '/Reload') )
			{
				LoginRedirect(this.props.history, this.constructor.name + '.componentDidMount');
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
		}
	}

	public render()
	{
		const { component: Component, ...rest } = this.props;
		const match = this.props.computedMatch
		/*
		if ( match && match.params['MODULE_NAME'] )
		{
			if ( match.params['MODULE_NAME'] != 'Reload' && match.params['MODULE_NAME'] != 'Reset' )
				localStorage.setItem('ReactLastActiveModule', match.params['MODULE_NAME']);
		}
		else
		{
			localStorage.removeItem('ReactLastActiveModule');
		}
		*/
		// 05/30/2019 Paul.  Experiment with returning to the same location, no matter how deep. 
		localStorage.setItem('ReactLastActiveModule', this.props.location.pathname);
		return <Route {...rest} render={() => <Component {...this.props} {...match.params} />} />
	}
}

export default withRouter(PrivateRoute);
