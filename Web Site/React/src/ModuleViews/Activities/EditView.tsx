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
import { RouteComponentProps, withRouter } from '../Router5'               ;
// 2. Store and Types. 
// 3. Scripts. 
import Sql                                 from '../../scripts/Sql'              ;
import {  Crm_Modules }                    from '../../scripts/Crm'              ;
import { EditView_LoadItem }               from '../../scripts/EditView'         ;
// 4. Components and Views. 
import ErrorComponent                      from '../../components/ErrorComponent';

interface IEditViewProps extends RouteComponentProps<any>
{
	MODULE_NAME        : string;
	ID?                : string;
}

interface IEditViewState
{
	error              : any;
}

class ActivitiesEditView extends React.Component<IEditViewProps, IEditViewState>
{
	constructor(props: IEditViewProps)
	{
		super(props);
		this.state =
		{
			error           : null,
		};
	}

	async componentDidMount()
	{
		const { history, ID } = this.props;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', ID);
		try
		{
			const d = await EditView_LoadItem('Activities', ID, false);
			let item: any = d.results;
			
			let ACTIVITY_TYPE: string = item['ACTIVITY_TYPE'];
			if ( !Sql.IsEmptyString(ACTIVITY_TYPE) )
			{
				let sRedirectUrl: string = '/Reset/' + ACTIVITY_TYPE + '/Edit/' + ID;
				// 08/09/2019 Paul.  Try and replace the /Reset so that the back button will work properly. 
				history.replace(sRedirectUrl);
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
		const { history, location } = this.props;
		const { error } = this.state;
		if ( error )
		{
			return (<ErrorComponent error={error} />);
		}
		return (<div>{ location.pathname + location.search }</div>);
	}
}

export default withRouter(ActivitiesEditView);
