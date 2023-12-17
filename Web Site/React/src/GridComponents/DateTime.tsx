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
import Sql              from '../scripts/Sql';
import Security         from '../scripts/Security';
import { FromJsonDate } from '../scripts/Formatting';
// 4. Components and Views. 

interface IDateTimeProps
{
	row     : any;
	layout  : any;
	dateOnly: boolean;
}

class DateTime extends React.PureComponent<IDateTimeProps>
{
	public render()
	{
		const { layout, row, dateOnly } = this.props;
		let DATA_VALUE = '';
		let DATA_FIELD = Sql.ToString(layout.DATA_FIELD);
		if ( dateOnly )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.Render Date ' + DATA_FIELD, row);
		}
		else
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.Render DateTime ' + DATA_FIELD, row);
		}
		if ( layout == null )
		{
			return (<div>layout prop is null</div>);
		}
		else if ( Sql.IsEmptyString(DATA_FIELD) )
		{
			return (<div>DATA_FIELD is empty for FIELD_INDEX { layout.FIELD_INDEX }</div>);
		}
		else
		{
			let sVALUE = (row ? Sql.ToString(row[DATA_FIELD]) : '');
			if ( row )
			{
				DATA_VALUE = row[DATA_FIELD];
				if ( dateOnly )
				{
					DATA_VALUE = FromJsonDate(DATA_VALUE, Security.USER_DATE_FORMAT());
				}
				else
				{
					DATA_VALUE = FromJsonDate(DATA_VALUE, Security.USER_DATE_FORMAT() + ' ' + Security.USER_TIME_FORMAT());
				}
			}
			return (<div>{ DATA_VALUE }</div>);
		}
	}
}

export default DateTime;
