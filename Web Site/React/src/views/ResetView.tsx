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
import { RouteComponentProps, withRouter } from 'react-router-dom'              ;
// 2. Store and Types. 
// 3. Scripts. 
import Credentials                         from '../scripts/Credentials'        ;
import { StartsWith }                      from '../scripts/utility'            ;
// 4. Components and Views. 

interface IResetViewProps extends RouteComponentProps<any>
{
}

class ResetView extends React.Component<IResetViewProps>
{
	async componentDidMount()
	{
		const { history, location } = this.props;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', location.pathname + location.search);
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
		// 08/05/2019 Paul.  Try and replace the /Reset so that the back button will work properly. 
		history.replace(sRedirectUrl);
	}

	public render()
	{
		const { history, location } = this.props;
		return (<div>{ location.pathname + location.search }</div>);
	}
}

export default withRouter(ResetView);
