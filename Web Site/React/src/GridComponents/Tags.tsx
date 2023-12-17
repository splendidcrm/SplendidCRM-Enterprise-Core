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
import Sql from '../scripts/Sql';
import { escapeHTML } from '../scripts/utility';
// 4. Components and Views. 

interface ITagsProps
{
	row   : any;
	layout: any;
}

class Tags extends React.PureComponent<ITagsProps>
{
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
			return (<div>DATA_FIELD is empty for FIELD_INDEX { layout.FIELD_INDEX }</div>);
		}
		else
		{
			let DATA_VALUE = '';
			if ( row )
			{
				DATA_VALUE = '';
				let sDATA = row[DATA_FIELD];
				if ( !Sql.IsEmptyString(sDATA) )
				{
					let divTagsChildren = [];
					let divTags = React.createElement('div', { }, divTagsChildren);
					let arrTAGS = sDATA.split(',');
					for ( let iTag = 0; iTag < arrTAGS.length; iTag++ )
					{
						// 11/03/2018 Paul.  Keys only need to be unique within siblings.  Not globally. 
						// https://reactjs.org/docs/lists-and-keys.html#keys
						let spnTag = React.createElement('span', { key: arrTAGS[iTag], className: 'Tags' }, escapeHTML(arrTAGS[iTag]));
						divTagsChildren.push(spnTag);
					}
					return divTags;
				}
			}
			return (<div>{ DATA_VALUE }</div>);
		}
	}
}

export default Tags;
