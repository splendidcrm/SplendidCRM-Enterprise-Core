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
import { FontAwesomeIcon }                 from '@fortawesome/react-fontawesome';
// 2. Store and Types. 
// 3. Scripts. 
import Sql                                 from '../../scripts/Sql' ;
import L10n                                from '../../scripts/L10n';

const style: React.CSSProperties =
{
	border         : '1px solid grey',
	backgroundColor: '#eeeeee',
	padding        : '2px',
	margin         : '2px',
	borderRadius   : '2px',
	width          : '100%',
};

interface IDraggableItemProps
{
	id                : string;
	item              : any;
	onEditClick       : (id: string) => void;
	onChangeEnabled   : Function;
}

export default class DraggableItem extends React.Component<IDraggableItemProps>
{
	constructor(props: IDraggableItemProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor', props);
	}

	private _onRELATIONSHIP_ENABLED_Change = (id: string, checked: boolean) =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onRELATIONSHIP_ENABLED_Change ' + id, checked);
		this.props.onChangeEnabled(id, checked);
	}

	public render()
	{
		const { item, id, onEditClick } = this.props;
		return ( item &&
			<table cellPadding={ 4 } cellSpacing={ 0 } style={ style }>
				<tr>
					<td style={ {width: '60%'} }>
						{ item.MODULE_NAME != item.CONTROL_NAME ? item.MODULE_NAME : item.MODULE_NAME + ' (' + item.CONTROL_NAME + ')' }
					</td>
					<td style={ {width: '39%'} }>
						<input 
							id={  'chk' + item.MODULE_NAME + '_' + item.CONTROL_NAME + '_RELATIONSHIP_ENABLED' }
							key={ 'chk' + item.MODULE_NAME + '_' + item.CONTROL_NAME + '_RELATIONSHIP_ENABLED' }
							type='checkbox'
							checked={ item.RELATIONSHIP_ENABLED }
							onChange={ (e) => this._onRELATIONSHIP_ENABLED_Change(item.ID, e.target.checked) }
						/>
						<label style={ {marginLeft: '2px', marginRight: '2px'} }>
						{ item.RELATIONSHIP_ENABLED
						? L10n.Term('DynamicLayout.LBL_ENABLED')
						: L10n.Term('DynamicLayout.LBL_DISABLED')
						}
						</label>
					</td>
					<td rowSpan={ 2 }>
						<span style={ {cursor: 'pointer'} } onClick={ () => onEditClick(id) }>
						<FontAwesomeIcon icon="edit" size="lg" />
					</span>
					</td>
				</tr>
				<tr>
					<td style={ {width: '60%'} }>
						{ L10n.Term(item.TITLE) }
					</td>
					<td style={ {width: '39%'} }>
						{ Sql.ToString(item.SORT_FIELD) + ' ' + Sql.ToString(item.SORT_DIRECTION) }
					</td>
				</tr>
			</table>
		);
	}
}
