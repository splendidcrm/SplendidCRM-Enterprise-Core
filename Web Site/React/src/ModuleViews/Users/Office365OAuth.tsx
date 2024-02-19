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
import Sql              from '../../scripts/Sql'          ;
import Security         from '../../scripts/Security'     ;
import SplendidCache    from '../../scripts/SplendidCache';
import { Crm_Config }   from '../../scripts/Crm'          ;
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
			let ID         : string = Sql.ToString(queryParams['state']);
			let url        : string = '/Reload';
			if ( !Sql.IsEmptyString(error) )
			{
				error = Sql.ToString(queryParams['error_description']);
			}
			if ( !Sql.IsEmptyGuid(ID) && ID.length == 36 && ID != Security.USER_ID() && SplendidCache.AdminUserAccess('Users', 'edit') >= 0 )
			{
				url += '/Administration/Users/Edit/' + ID;
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
