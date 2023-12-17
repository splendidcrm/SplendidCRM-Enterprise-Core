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
import { formatCurrency } from '../scripts/Formatting';
import Sql  from '../scripts/Sql' ;
import C10n from '../scripts/C10n';
// 4. Components and Views. 

interface ICurrencyProps
{
	row         : any;
	layout      : any;
	numberFormat: any;
}

class Currency extends React.PureComponent<ICurrencyProps>
{
	public render()
	{
		const { layout, row, numberFormat } = this.props;
		let DATA_FIELD = Sql.ToString(layout.DATA_FIELD);
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
			let DATA_VALUE = '';
			if ( row )
			{
				// 10/16/2021 Paul.  Add support for user currency. 
				let dConvertedValue = C10n.ToCurrency(Sql.ToDecimal(row[DATA_FIELD]));
				DATA_VALUE = formatCurrency(dConvertedValue, numberFormat);
			}
			return (<div>{ DATA_VALUE }</div>);
		}
	}
}

export default Currency;
