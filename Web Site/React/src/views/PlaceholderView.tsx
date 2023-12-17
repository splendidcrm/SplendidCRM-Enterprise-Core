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
import { Link, RouteComponentProps, withRouter } from 'react-router-dom';
// 2. Store and Types. 
// 3. Scripts. 
// 4. Components and Views. 

interface IPlaceholderViewProps extends RouteComponentProps<any>
{
	MODULE_NAME: string;
	SUB_TITLE  : string;
	ID         : string;
}

class PlaceholderView extends React.Component<IPlaceholderViewProps>
{
	constructor(props: IPlaceholderViewProps)
	{
		super(props);
		this.state =
		{
		}
	}

	public render() {
		const { MODULE_NAME, SUB_TITLE, ID } = this.props;
		return (
			<div>
				Placeholder
			</div>
		);
	}
}

export default withRouter(PlaceholderView);
