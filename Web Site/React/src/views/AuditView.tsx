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
import { Modal }                     from 'react-bootstrap'               ;
import BootstrapTable                from 'react-bootstrap-table-next'    ;
import { FontAwesomeIcon }           from '@fortawesome/react-fontawesome';
// 2. Store and Types. 
// 3. Scripts. 
import Sql                           from '../scripts/Sql'                ;
import L10n                          from '../scripts/L10n'               ;
import SplendidCache                 from '../scripts/SplendidCache'      ;
import { ListView_LoadLayout }       from '../scripts/ListView'           ;
import { DetailView_LoadAudit }      from '../scripts/DetailView'         ;
import { AuthenticatedMethod }       from '../scripts/Login'              ;
import { Trim }                      from '../scripts/utility'            ;
// 4. Components and Views. 
import ErrorComponent                from '../components/ErrorComponent'  ;
import DumpSQL                       from '../components/DumpSQL'         ;
import DateTime                      from '../GridComponents/DateTime'    ;
import String                        from '../GridComponents/String'      ;

interface IAuditViewProps
{
	MODULE_NAME: string;
	NAME       : string;
	ID         : string;
	callback   : Function;
	isOpen     : boolean;
}

interface IAuditViewState
{
	layout : any;
	columns: any;
	vwMain : any;
	error  : any;
	__sql  : string;
}

export default class AuditView extends React.Component<IAuditViewProps, IAuditViewState>
{
	private _isMounted   = false;

	constructor(props: IAuditViewProps)
	{
		super(props);
		this.state =
		{
			layout : null,
			vwMain : null,
			columns: [],
			error  : null,
			__sql  : null,
		};
	}

	async componentDidMount()
	{
		const { MODULE_NAME, ID } = this.props;
		this._isMounted = true;
		// 03/11/2021 Paul.  Defer load until after open. 
		//await this.loadData();
	}

	shouldComponentUpdate(nextProps: IAuditViewProps, nextState: IAuditViewState)
	{
		// 03/11/2021 Paul.  Defer load until after open. 
		if ( this.props.isOpen != nextProps.isOpen )
		{
			if ( nextProps.isOpen && this.state.vwMain == null )
			{
				this.loadData();
			}
		}
		return true;
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}

	private createKeys = (results: Array<any>) =>
	{
		if ( results != null )
		{
			for ( let i = 0; i < results.length; i++ )
			{
				let row = results[i];
				row.ID_key = row.FIELD_NAME + '_' + i.toString();
			}
		}
	}

	private BootstrapColumns = (sLIST_MODULE_NAME, layout, sPRIMARY_MODULE, sPRIMARY_ID) =>
	{
		let arrDataTableColumns = [];
		let objDataColumn: any = {};
		if ( layout != null )
		{
			for ( let nLayoutIndex = 0; layout != null && nLayoutIndex < layout.length; nLayoutIndex++ )
			{
				let lay = layout[nLayoutIndex];
				let COLUMN_TYPE                = lay.COLUMN_TYPE               ;
				let COLUMN_INDEX               = lay.COLUMN_INDEX              ;
				let HEADER_TEXT                = lay.HEADER_TEXT               ;
				let SORT_EXPRESSION            = lay.SORT_EXPRESSION           ;
				let ITEMSTYLE_WIDTH            = lay.ITEMSTYLE_WIDTH           ;
				let ITEMSTYLE_HORIZONTAL_ALIGN = lay.ITEMSTYLE_HORIZONTAL_ALIGN;
				let ITEMSTYLE_VERTICAL_ALIGN   = lay.ITEMSTYLE_VERTICAL_ALIGN  ;
				let DATA_FIELD                 = lay.DATA_FIELD                ;
				let DATA_FORMAT                = lay.DATA_FORMAT               ;
				let MODULE_NAME                = lay.MODULE_NAME               ;

				if (   COLUMN_TYPE == 'BoundColumn'
				  && ( DATA_FORMAT == 'Date'
					|| DATA_FORMAT == 'DateTime'
					|| DATA_FORMAT == 'Currency'
					|| DATA_FORMAT == 'Image'
					|| DATA_FORMAT == 'MultiLine'
					// 08/26/2014 Paul.  Ignore ImageButton. 
					|| DATA_FORMAT == 'ImageButton'
				   )
				)
				{
					COLUMN_TYPE = 'TemplateColumn';
				}
				if ( COLUMN_TYPE == 'TemplateColumn' )
				{
					// 04/20/2017 Paul.  Build DataTables columns. 
					objDataColumn =
					{
						key            : 'column' + nLayoutIndex,
						text           : (Sql.IsEmptyString(HEADER_TEXT) ? '' : L10n.Term(HEADER_TEXT)),
						dataField      : DATA_FIELD,
						classes        : '',
						formatter      : this.templateColumnFormatter,
						headerClasses  : 'listViewThS2',
						headerStyle    : {whiteSpace: 'nowrap'},
						sort           : (SORT_EXPRESSION != null),
						isDummyField   : false,
						formatExtraData:
						{
							data:
							{
								GRID_NAME   : sLIST_MODULE_NAME,
								DATA_FIELD  : DATA_FIELD,
								COLUMN_INDEX: COLUMN_INDEX,
								layout      : lay
							}
						}
					};
					// 04/05/2021 Paul.  Need to manually override the bootstrap header style. 
					// 04/24/2022 Paul.  Move Arctic style override to style.css. 
					if ( ITEMSTYLE_HORIZONTAL_ALIGN != null )
					{
						objDataColumn.classes += ' gridView' + ITEMSTYLE_HORIZONTAL_ALIGN;
					}
					if ( ITEMSTYLE_VERTICAL_ALIGN != null )
					{
						objDataColumn.classes += ' gridView' + ITEMSTYLE_VERTICAL_ALIGN;
					}
					if ( ITEMSTYLE_WIDTH != null )
					{
						objDataColumn.attrs = { width: ITEMSTYLE_WIDTH };
					}
					// 07/25/2017 Paul.  Try and force the NAME column to always be displayed on mobile portrait mode. 
					// https://datatables.net/extensions/responsive/classes
					if ( DATA_FIELD == "NAME" )
					{
						objDataColumn.classes = ' all';
					}
					objDataColumn.classes = Trim(objDataColumn.classes);

					arrDataTableColumns.push(objDataColumn);
				}
				else if ( COLUMN_TYPE == 'BoundColumn' )
				{
					// 04/20/2017 Paul.  Build DataTables columns. 
					objDataColumn =
					{
						key            : 'column' + nLayoutIndex,
						text           : (Sql.IsEmptyString(HEADER_TEXT) ? '' : L10n.Term(HEADER_TEXT)),
						dataField      : DATA_FIELD,
						classes        : '',
						formatter      : this.boundColumnFormatter,
						headerClasses  : 'listViewThS2',
						headerStyle    : {whiteSpace: 'nowrap'},
						sort           : (SORT_EXPRESSION != null),
						isDummyField   : false,
						formatExtraData: {
							data: {
								GRID_NAME   : sLIST_MODULE_NAME,
								DATA_FIELD  : DATA_FIELD,
								COLUMN_INDEX: COLUMN_INDEX,
								layout      : lay
							}
						}
					};
					// 04/05/2021 Paul.  Need to manually override the bootstrap header style. 
					// 04/24/2022 Paul.  Move Arctic style override to style.css. 
					if ( ITEMSTYLE_HORIZONTAL_ALIGN != null )
					{
						objDataColumn.classes += ' gridView' + ITEMSTYLE_HORIZONTAL_ALIGN;
					}
					if ( ITEMSTYLE_VERTICAL_ALIGN != null )
					{
						objDataColumn.classes += ' gridView' + ITEMSTYLE_VERTICAL_ALIGN;
					}
					if ( ITEMSTYLE_WIDTH != null )
					{
						objDataColumn.attrs = { width: ITEMSTYLE_WIDTH };
					}
					objDataColumn.classes = Trim(objDataColumn.classes);
					arrDataTableColumns.push(objDataColumn);
				}
			}
			// 05/17/2018 Paul.  Defer finalize. 
			//if ( this.BootstrapColumnsFinalize != null )
			//	arrDataTableColumns = this.BootstrapColumnsFinalize(sLIST_MODULE_NAME, arrDataTableColumns);
		}
		return arrDataTableColumns;
	}

	private boundColumnFormatter = (cell, row, rowIndex, formatExtraData) =>
	{
		// 05/27/2018 Paul.  We will need all the layout fields in the render function. 
		let lay = formatExtraData.data.layout;
		return React.createElement(String, { layout: lay, row: row, multiLine: false });
	}

	private templateColumnFormatter = (cell, row, rowIndex, formatExtraData) =>
	{
		let lay = formatExtraData.data.layout;
		let DATA_FIELD                 = lay.DATA_FIELD;
		let DATA_FORMAT                = lay.DATA_FORMAT;

		let DATA_VALUE = '';
		if ( row[DATA_FIELD] != null || row[DATA_FIELD] === undefined )
		{
			try
			{
				if ( DATA_FORMAT == 'Date' )
				{
					return React.createElement(DateTime, { layout: lay, row: row, dateOnly: true });
				}
				else if ( DATA_FORMAT == 'DateTime' )
				{
					return React.createElement(DateTime, { layout: lay, row: row, dateOnly: false });
				}
				else if ( DATA_FORMAT == 'MultiLine' )
				{
					return React.createElement(String, { layout: lay, row: row, multiLine: true });
				}
				else
				{
					return React.createElement(String, { layout: lay, row: row, multiLine: false });
				}
			}
			catch(error)
			{
				console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.templateColumnFormatter', error);
				DATA_VALUE = error.message;
			}
		}
		return DATA_VALUE;
	}

	private _onClose = () =>
	{
		const { callback } = this.props;
		callback();
	}

	public loadData = async () =>
	{
		const { MODULE_NAME, ID } = this.props;
		try
		{
			if ( this.state.layout == null || this.state.vwMain == null )
			{
				let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
				if ( status == 1 )
				{
					let GRID_NAME = 'Audit.ListView';
					let layout : any = ListView_LoadLayout(GRID_NAME);
					let columns: any = this.BootstrapColumns(GRID_NAME, layout, MODULE_NAME, null);
					let d      : any = await DetailView_LoadAudit(MODULE_NAME, ID);
					this.createKeys(d.results);
					this.setState(
					{
						layout ,
						columns,
						vwMain : d.results,
						__sql  : d.__sql,
					});
				}
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			this.setState({ error });
		}
	}

	private rowClasses = (row, rowIndex) =>
	{
		return (rowIndex % 2 ? 'evenListRowS1' : 'oddListRowS1');
	}

	public render()
	{
		const { MODULE_NAME, NAME, isOpen } = this.props;
		const { columns, vwMain, error, __sql } = this.state;
		if ( SplendidCache.IsInitialized && columns && vwMain )
		{
			return (
			<Modal show={ isOpen } onHide={ this._onClose }>
				<Modal.Body style={ {minHeight: '80vh', minWidth: '80vw'} }>
					<ErrorComponent error={ error } />
					<h2>
						<span>{ L10n.Term('.moduleList.' + MODULE_NAME) }</span>
						<span style={ {paddingLeft: '10px', paddingRight: '10px'} } ><FontAwesomeIcon icon="angle-double-right" /></span>
						<span>{ NAME }</span>
					</h2>
					<div>
						<button
							key={ 'btnCancel_AuditView' }
							className='button'
							onClick={ this._onClose }
							style={ {marginBottom: '.2em', marginLeft: '.5em'} }>
							{ L10n.Term('.LBL_CLOSE_BUTTON_LABEL') }
						</button>
					</div>
					<DumpSQL SQL={ __sql } />
					<BootstrapTable
						keyField="ID_key"
						data={ vwMain }
						classes='listView'
						headerClasses='listViewThS1'
						bordered={ false }
						remote
						columns={ columns }
						bootstrap4 compact hover
						wrapperClasses={ 'bg-white' }
						rowClasses={ this.rowClasses }
					/>
				</Modal.Body>
				<Modal.Footer>
					<button className='button' onClick={ this._onClose }>{ L10n.Term('.LBL_CLOSE_BUTTON_LABEL') }</button>
				</Modal.Footer>
			</Modal>
			);
		}
		// 11/03/2019 Paul.  Make sure to only show spinner when open, otherwise it would always get displayed. 
		else if ( isOpen )
		{
			return (
			<div id={ this.constructor.name + '_spinner' } style={ {textAlign: 'center'} }>
				<FontAwesomeIcon icon="spinner" spin={ true } size="5x" />
			</div>);
		}
		else
		{
			// 11/03/2019 Paul.  Must return null, otherwise we getn an invariant error. 
			return null;
		}
	}
}

