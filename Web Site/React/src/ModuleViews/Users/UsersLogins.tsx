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
import { RouteComponentProps, withRouter } from '../Router5'                    ;
// 2. Store and Types. 
import DETAILVIEWS_RELATIONSHIP            from '../../types/DETAILVIEWS_RELATIONSHIP';
// 3. Scripts. 
// 4. Components and Views. 
import SubPanelView                        from '../../views/SubPanelView'            ;

interface IUsersLoginsProps extends RouteComponentProps<any>
{
	PARENT_TYPE      : string;
	row              : any;
	layout           : DETAILVIEWS_RELATIONSHIP;
}

class UsersLogins extends React.Component<IUsersLoginsProps>
{
	constructor(props: IUsersLoginsProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor ' + props.PARENT_TYPE, props.layout);
	}

	public render()
	{
		return <SubPanelView { ...this.props } disableView={ true } disableEdit={ true } disableRemove={ true } CONTROL_VIEW_NAME='Users.Logins' />;
	}
}

export default withRouter(UsersLogins);
