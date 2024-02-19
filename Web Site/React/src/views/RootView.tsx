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
import { RouteComponentProps, withRouter }    from '../Router5'            ;
// 2. Store and Types. 
// 3. Scripts. 
import Sql                                    from '../scripts/Sql'              ;
import { Crm_Config }                         from '../scripts/Crm'              ;
import { AuthenticatedMethod, LoginRedirect } from '../scripts/Login'            ;
// 4. Components and Views. 
import ErrorComponent                         from '../components/ErrorComponent';

interface IRootViewProps extends RouteComponentProps<any>
{
}

interface IRootViewState
{
	error?: any;
}

class RootView extends React.Component<IRootViewProps, IRootViewState>
{
	constructor(props: IRootViewProps)
	{
		super(props);
		this.state = {};
	}

	async componentDidMount()
	{
		console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount');
		try
		{
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
			if ( status == 1 )
			{
				const { history } = this.props;
				let home: string = Crm_Config.ToString('default_module');
				if ( !Sql.IsEmptyString(home) && home != 'Home')
				{
					// 02/08/2021 Paul.  Should have a leading slash. 
					home = home.replace('~/', '');
					history.push('/' + home);
				}
				else
				{
					history.push('/Home');
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
		const { error } = this.state;
		if ( error )
		{
			return <ErrorComponent error={error} />;
		}
		else
		{
			return (<div>
			</div>);
		}
	}
}

export default withRouter(RootView);
