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

import * as React from 'react';
import { NavDropdown, NavDropdownProps, Dropdown } from 'react-bootstrap';
import { ReplaceProps } from 'react-bootstrap/helpers';

interface INavItemState
{
	show: boolean;
}

class NavItem extends React.Component<ReplaceProps<typeof Dropdown, NavDropdownProps>, INavItemState>
{
	state =
	{
		show: false
	};

	render()
	{
		const { show } = this.state;
		const {  onMouseEnter, onMouseLeave  } = this.props;
		return (
			<NavDropdown {...this.props}
				show={show}
				onMouseEnter={ () => this.setState({ show: true  }) }
				onMouseLeave={ () => this.setState({ show: false }) }
				>
				{ this.props.children }
			</NavDropdown>
		)
	}
}

export default NavItem;
