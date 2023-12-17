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
import Sql              from '../scripts/Sql'    ;
// 4. Components and Views. 

interface ICheckBoxProps
{
	row   : any;
	layout: any;
}

export default class CheckBox extends React.PureComponent<ICheckBoxProps>
{
	constructor(props: ICheckBoxProps)
	{
		super(props);
	}

	public render()
	{
		const { layout, row } = this.props;
		let DATA_FIELD = Sql.ToString(layout.DATA_FIELD);
		if ( layout == null )
		{
			return (<div>layout prop is null</div>);
		}
		else if ( Sql.IsEmptyString(DATA_FIELD) )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render', layout, row);
			return (<div>DATA_FIELD is empty for FIELD_INDEX {layout.FIELD_INDEX}</div>);
		}
		else
		{
			let bVALUE: boolean = (row ? Sql.ToBoolean(row[DATA_FIELD]) : false);
			if ( bVALUE )
				return (<input type="checkbox" checked={ true } disabled={ true } />);
			else
				return null;
		}
	}
}

