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
import { RouteComponentProps, withRouter }    from '../Router5'                 ;
import { observer }                           from 'mobx-react'                       ;
import { FontAwesomeIcon }                    from '@fortawesome/react-fontawesome'   ;
// 2. Store and Types. 
// 3. Scripts. 
import Credentials                            from '../../scripts/Credentials'        ;
import SplendidCache                          from '../../scripts/SplendidCache'      ;
import { ListView_LoadTablePaginated }        from '../../scripts/ListView'           ;
// 4. Components and Views. 
import SplendidGrid                           from '../../components/SplendidGrid'    ;

interface ISubPanelViewProps extends RouteComponentProps<any>
{
	ID                  : string;
	isPrecompile?       : boolean;
	onComponentComplete?: (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, data) => void;
}

interface ISubPanelViewState
{
	PRIMARY_ID       : string;
	error            : any;
}

@observer
class PaymentsInvoices extends React.Component<ISubPanelViewProps, ISubPanelViewState>
{
	private _isMounted           = false;
	private splendidGrid         = React.createRef<SplendidGrid>();

	constructor(props: ISubPanelViewProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor ' + props);
		this.state =
		{
			PRIMARY_ID       : props.ID,
			error            : null,
		};
	}

	async componentDidMount()
	{
		this._isMounted = true;
		try
		{
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			this.setState({ error });
		}
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
	private _onComponentComplete = (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, data): void => 
	{
		const { error } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onComponentComplete ' + LAYOUT_NAME, data);
		if ( this.props.onComponentComplete )
		{
			if ( error == null )
			{
				this.props.onComponentComplete(MODULE_NAME, RELATED_MODULE, 'Payments.Invoices', data);
			}
		}
	}

	private Load = async (sMODULE_NAME, sSORT_FIELD, sSORT_DIRECTION, sSELECT, sFILTER, rowSEARCH_VALUES, nTOP, nSKIP, bADMIN_MODE?, archiveView?) =>
	{
		let d = await ListView_LoadTablePaginated('vwPAYMENTS_INVOICES', sSORT_FIELD, sSORT_DIRECTION, sSELECT, sFILTER, rowSEARCH_VALUES, nTOP, nSKIP, bADMIN_MODE, archiveView);
		if ( d.results )
		{
			// 05/07/2022 Paul.  The ID needs to be that of the Invoice, not the relationship record. 
			for ( let i: number = 0; i < d.results.length; i++ )
			{
				let row: any = d.results[i];
				row['PAYMENT_INVOICE_ID'] = row['ID'];
				row['ID'] = row['INVOICE_ID'];
			}
		}
		return d;
	}

	public render()
	{
		const { PRIMARY_ID } = this.state;
		if ( SplendidCache.IsInitialized  )
		{
			Credentials.sUSER_THEME;
			return (
				<SplendidGrid
					MODULE_NAME='Payments'
					RELATED_MODULE='Invoices'
					GRID_NAME='Payments.Invoices'
					TABLE_NAME='vwPAYMENTS_INVOICES'
					SORT_FIELD='DATE_ENTERED'
					SORT_DIRECTION='asc'
					PRIMARY_FIELD='PAYMENT_ID'
					PRIMARY_ID={ PRIMARY_ID }
					ADMIN_MODE={ false }
					deleteRelated={ false }
					archiveView={ false }
					deferLoad={ false }
					disableView={ false }
					disableEdit={ false }
					disableRemove={ true }
					disablePagination={ true }
					cbCustomLoad={ this.Load }
					onComponentComplete={ this._onComponentComplete }
					scrollable
					history={ this.props.history }
					location={ this.props.location }
					match={ this.props.match }
					ref={ this.splendidGrid }
				/>
			);
		}
		else
		{
			return (
			<div id={ this.constructor.name + '_spinner' } style={ {textAlign: 'center'} }>
				<FontAwesomeIcon icon="spinner" spin={ true } size="5x" />
			</div>);
		}
	}
}

export default withRouter(PaymentsInvoices);
