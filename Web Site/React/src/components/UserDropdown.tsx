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
import { RouteComponentProps, withRouter } from 'react-router-dom';
import { Modal, Alert }                    from 'react-bootstrap';
import { observer } from 'mobx-react';
// 2. Store and Types. 
// 3. Scripts. 
import Credentials from '../scripts/Credentials';
import SplendidCache from '../scripts/SplendidCache';
import { Logout } from '../scripts/Login';
import L10n from '../scripts/L10n'
// 4. Components and Views. 

const icon = require('../assets/img/SplendidCRM_Icon.gif');

interface IUserDropdownProps extends RouteComponentProps<any>
{
}

type State =
{
}

@observer
class UserDropdown extends React.Component<IUserDropdownProps, State>
{
	constructor(props: IUserDropdownProps)
	{
		super(props);
		this.state =
		{
		};
	}
	
	private AdminMode = () =>
	{
		this.props.history.push(`/Reset/Administration`);
	}

	private UserMode = () =>
	{
		Credentials.SetADMIN_MODE(false);
		this.props.history.push('/Home');
	}

	public render()
	{
		if ( SplendidCache.IsInitialized )
		{
			const menuIconProps =
			{
				className: "fas fas-image",
				src: Credentials.sPICTURE || icon
			};
			
			let menuProps =
			{
				shouldFocusOnMount: true,
				items:
				[
				]
			};
			if ( Credentials.ADMIN_MODE )
			{
				menuProps.items[menuProps.items.length] = 
				{
					key: 'usernmode',
					name: L10n.Term('Home.LBL_LIST_FORM_TITLE'),
					onClick: () => { this.UserMode(); }
				};
			}
			if ( Credentials.bIS_ADMIN || Credentials.bIS_ADMIN_DELEGATE )
			{
				menuProps.items[menuProps.items.length] = 
				{
					key: 'adminmode',
					name: L10n.Term('.LBL_ADMIN'),
					onClick: () => { this.AdminMode(); }
				};
			}
			menuProps.items[menuProps.items.length] = 
			{
				key: 'logout',
				name: 'logout',
				onClick: Logout
			};

			return (
				<div>
					<div style={{ flexGrow: 1 }} />
				</div>
			);
		}
		return null;
	}
}

export default withRouter(UserDropdown);
