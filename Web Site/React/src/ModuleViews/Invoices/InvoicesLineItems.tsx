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
import IOrdersLineItemsEditorProps from '../../types/IOrdersLineItemsEditorProps';
import IOrdersLineItemsEditorState from '../../types/IOrdersLineItemsEditorState';
import OrdersLineItemsEditor       from '../../types/OrdersLineItemsEditor'      ;
import EDITVIEWS_FIELD             from '../../types/EDITVIEWS_FIELD'            ;
// 3. Scripts. 
import { EditView_LoadLayout }     from '../../scripts/EditView'                 ;
// 4. Components and Views. 
import EditViewLineItems           from '../../views/EditViewLineItems'          ;

const MODULE_NAME: string = 'Invoices';

interface IInvoicesLineItemsState extends IOrdersLineItemsEditorState
{
	layout         : EDITVIEWS_FIELD[];
}

export default class InvoicesLineItems extends OrdersLineItemsEditor<IOrdersLineItemsEditorProps, IInvoicesLineItemsState>
{
	public get data (): any
	{
		let obj: any = null;
		if ( this.lineItems.current )
		{
			obj = this.lineItems.current.data;
			obj.CURRENCY_ID   = this.state.CURRENCY_ID  ;
			obj.EXCHANGE_RATE = this.state.EXCHANGE_RATE;
			obj.TAXRATE_ID    = this.state.TAXRATE_ID   ;
			obj.SHIPPER_ID    = this.state.SHIPPER_ID   ;
			// 06/21/2022 Paul.  Must manually include the shipping fees. 
			obj.SHIPPING      = this.state.SHIPPING     ;
		}
		return obj;
	}

	constructor(props: IOrdersLineItemsEditorProps)
	{
		super(props);
		this.state =
		{
			layout: null,
		};
	}

	async componentDidMount()
	{
		try
		{
			const layout: EDITVIEWS_FIELD[] = EditView_LoadLayout(MODULE_NAME + 'LineItems.LineItems');
			this.InitLayout(layout);
			this.setState({ layout });
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.load', error);
		}
	}

	public render()
	{
		const { ID, row } = this.props;
		const { layout } = this.state;
		if ( layout )
		{
			return (
				<div id='ctlEditLineItemsView'>
					{ this.RenderLineHeader(MODULE_NAME) }
					<EditViewLineItems
						MODULE_NAME={ MODULE_NAME }
						ID={ ID }
						row={ row }
						layout={ layout }
						onChanged={ this._onChange }
						onUpdate={ this._onUpdate }
						onFieldDidMount={ this._onFieldDidMount }
						FieldVisibility={ this.FieldVisibility }
						ConvertField={ this.ConvertField }
						ValidateLineItem={ this.ValidateLineItem }
						ref={ this.lineItems }
					/>
					{ this.RenderSummary(MODULE_NAME) }
				</div>
			);
		}
		else
		{
			return null;
		}
	}
}

