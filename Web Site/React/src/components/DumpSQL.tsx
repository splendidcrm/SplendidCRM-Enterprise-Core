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
// 2. Store and Types. 
// 3. Scripts. 
import { Crm_Config }          from '../scripts/Crm'  ;
// 4. Components and Views. 

interface IDumpSQLProps
{
	SQL: string;
}

interface IDumpSQLState
{
	show_sql           : boolean;
	expand_sql         : boolean;
}

export default class DumpSQL extends React.Component<IDumpSQLProps, IDumpSQLState>
{
	constructor(props: IDumpSQLProps)
	{
		super(props);
		this.state =
		{
			show_sql          : Crm_Config.ToBoolean('show_sql'),
			expand_sql        : false,
		};
	}

	private onToggleSql = () =>
	{
		this.setState({ expand_sql: !this.state.expand_sql });
	}

	public render()
	{
		const { SQL } = this.props;
		const { show_sql, expand_sql } = this.state;
		// 04/19/2021 Paul.  Turn overflow off. 
		let cssSql: any = { height: '1em', cursor: 'pointer', marginBottom: 0, overflowX: 'hidden' };
		if ( expand_sql )
		{
			cssSql = { cursor: 'pointer', marginBottom: 0 };
		}
		// 04/14/2022 Paul.  Don't show if SQL is null, such as during new record creation. 
		if ( show_sql && SQL != null )
		{
			return (<pre onClick={ this.onToggleSql } style={ cssSql }>{ SQL }</pre>);
		}
		else
		{
			return null;
		}
	}
}

