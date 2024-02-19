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
import React from 'react';
import qs from 'query-string';
import { Link, RouteComponentProps, withRouter } from '../Router5';
// 2. Store and Types. 
// 3. Scripts. 
import Sql              from '../scripts/Sql'          ;
import Security         from '../scripts/Security'     ;
import SplendidCache    from '../scripts/SplendidCache';
import { Crm_Config }   from '../scripts/Crm'          ;
import { StartsWith }   from '../scripts/utility'      ;
// 4. Components and Views. 

interface IOffice365OAuthProps extends RouteComponentProps<any>
{
}

interface IOffice365OAuthState
{
	error?          : any;
}

class Office365OAuth extends React.Component<IOffice365OAuthProps, IOffice365OAuthState>
{
	constructor(props: IOffice365OAuthProps)
	{
		super(props);
		this.state =
		{
		};
	}

	async componentDidMount()
	{
		try
		{
			let queryParams: any    = qs.parse(location.search);
			let client_id  : string = Crm_Config.ToString('Exchange.ClientID')
			let code       : string = Sql.ToString(queryParams['code' ]);
			let error      : string = Sql.ToString(queryParams['error']);
			let state      : string = Sql.ToString(queryParams['state']);
			let url        : string = '/Reload';
			if ( !Sql.IsEmptyString(error) )
			{
				error = Sql.ToString(queryParams['error_description']);
			}
			if ( !Sql.IsEmptyGuid(state) && state.length == 36 && state != Security.USER_ID() && SplendidCache.AdminUserAccess('Users', 'edit') >= 0 )
			{
				url += '/Administration/Users/Edit/' + state;
			}
			// 03/14/2021 Paul.  New redirect to EmailMan. 
			else if ( state == 'EmailMan' )
			{
				url += '/Administration/EmailMan/ConfigView';
			}
			// 04/30/2021 Paul.  Instead of requiring /Administration/Exchange/ConfigView as a redirect, just bounce through Office365OAuth. 
			else if ( state == 'Exchange' )
			{
				url += '/Administration/Exchange/ConfigView';
			}
			// 03/23/2021 Paul.  New redirect to OutboundEmail. 
			else if ( StartsWith(state, 'OutboundEmail:') )
			{
				let ID: string = state.substr(14);
				url += '/Administration/OutboundEmail/Edit/' + ID;
			}
			// 03/23/2021 Paul.  New redirect to InboundEmail. 
			else if ( StartsWith(state, 'InboundEmail:') )
			{
				let ID: string = state.substr(13);
				url += '/Administration/InboundEmail/Edit/' + ID;
			}
			// 12/26/2022 Paul.  Add support for Microsoft Teams. 
			else if ( state == 'MicrosoftTeams' )
			{
				url += '/Administration/MicrosoftTeams/ConfigView';
			}
			else
			{
				url += '/Users/EditMyAccount';
			}
			url += '?oauth_host=Office365&code=' + encodeURIComponent(code) + '&error=' + encodeURIComponent(error)
			this.props.history.push(url);
		}
		catch(error)
		{
			this.setState({ error });
		}
	}

	public render()
	{
		return null;
	}
}

export default withRouter(Office365OAuth);
