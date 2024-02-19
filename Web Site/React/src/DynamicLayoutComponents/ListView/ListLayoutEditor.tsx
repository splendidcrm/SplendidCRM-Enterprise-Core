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
import { FontAwesomeIcon }                          from '@fortawesome/react-fontawesome'     ;
// 3. Scripts. 
import Sql                                          from '../../scripts/Sql'                ;
import L10n                                         from '../../scripts/L10n'               ;
import Security                                     from '../../scripts/Security'           ;
import Credentials                                  from '../../scripts/Credentials'        ;
import SplendidCache                                from '../../scripts/SplendidCache'      ;
import { StartsWith, uuidFast }                     from '../../scripts/utility'            ;
import { CreateSplendidRequest, GetSplendidResult } from '../../scripts/SplendidRequest'    ;
// 4. Components and Views. 
import PopupView                                    from '../../views/PopupView'            ;
import ListPropertiesEditor                         from './ListPropertiesEditor'           ;
import SourceTemplateColumn                         from './SourceTemplateColumn'           ;
import DraggableItem                                from './DraggableItem'                  ;
import DraggableRow                                 from '../Shared/DraggableRow'           ;
import DraggableCell                                from '../Shared/DraggableCell'          ;
import DraggableRemove                              from '../Shared/DraggableRemove'        ;
import SourceItem                                   from '../Shared/SouceItem'              ;

interface IListLayoutEditorProps
{
	LayoutType      : string;
	ModuleName      : string;
	ViewName        : string;
	onEditComplete  : Function;
}

interface IListLayoutEditorState
{
	layoutName        : string;
	moduleFields      : Array<any>;
	rows              : Array<{ key: string, columns: Array<string[]> }>;
	activeFields      : Record<string, any>;
	layoutFields      : Array<any>;
	layoutProperties  : any;
	draggingId        : string;
	selectedId        : string;
	error?            : string;
	MODULE_TERMINOLOGY: string[];
	showName          : boolean;
	popupOpen         : boolean;
}

export default class ListLayoutEditor extends React.Component<IListLayoutEditorProps, IListLayoutEditorState>
{
	private _isMounted = false;

	constructor(props: IListLayoutEditorProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor', props);
		let MODULE_TERMINOLOGY: string[] = SplendidCache.BuildModuleTerminology(props.ModuleName);
		this.state =
		{
			layoutName        : props.ViewName,
			moduleFields      : [],
			rows              :
			[
				{
					key    : uuidFast(),
					columns: []
				}
			],
			activeFields      : {},
			layoutFields      : [],
			layoutProperties  : null,
			draggingId        : '',
			selectedId        : null,
			MODULE_TERMINOLOGY,
			showName          : false,
			popupOpen         : false,
		};
	}

	async componentDidMount()
	{
		this._isMounted = true;
		try
		{
			await this.loadLayout(false);
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			this.setState({ error: error.message });
		}
	}

	async componentDidUpdate(prevProps: IListLayoutEditorProps)
	{
		if ( prevProps.ViewName != this.props.ViewName )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate', nextProps.ViewName);
			
			let MODULE_TERMINOLOGY: string[] = SplendidCache.BuildModuleTerminology(this.props.ModuleName);
			this.setState(
			{
				layoutName        : this.props.ViewName,
				moduleFields      : [],
				rows              :
				[
					{
						key    : uuidFast(),
						columns: []
					}
				],
				activeFields      : {},
				layoutFields      : [],
				layoutProperties  : null,
				draggingId        : '',
				selectedId        : null,
				MODULE_TERMINOLOGY,
				showName          : false,
				popupOpen         : false,
				error             : null,
			}, () =>
			{
				this.loadLayout(false).then(() =>
				{
				})
				.catch((error) =>
				{
					console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidUpdate', error);
				});
			});
		}
	}

	private createItemFromSource = (item) =>
	{
		const { ModuleName } = this.props;
		let { activeFields } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.createItemFromSource', item);

		let id : string                = item.id          ;
		let obj: any                   = {}               ;
		obj.ID                         = null             ;
		obj.COLUMN_TYPE                = item.COLUMN_TYPE               ;
		obj.DATA_FORMAT                = item.DATA_FORMAT               ;
		obj.HEADER_TEXT                = item.HEADER_TEXT               ;
		obj.DATA_FIELD                 = item.DATA_FIELD                ;
		obj.SORT_EXPRESSION            = item.SORT_EXPRESSION           ;
		obj.ITEMSTYLE_WIDTH            = item.ITEMSTYLE_WIDTH           ;
		obj.ITEMSTYLE_CSSCLASS         = item.ITEMSTYLE_CSSCLASS        ;
		obj.ITEMSTYLE_HORIZONTAL_ALIGN = item.ITEMSTYLE_HORIZONTAL_ALIGN;
		obj.ITEMSTYLE_VERTICAL_ALIGN   = item.ITEMSTYLE_VERTICAL_ALIGN  ;
		obj.ITEMSTYLE_WRAP             = item.ITEMSTYLE_WRAP            ;
		obj.URL_FIELD                  = item.URL_FIELD                 ;
		obj.URL_FORMAT                 = item.URL_FORMAT                ;
		obj.URL_TARGET                 = item.URL_TARGET                ;
		obj.URL_MODULE                 = item.URL_MODULE                ;
		obj.URL_ASSIGNED_FIELD         = item.URL_ASSIGNED_FIELD        ;
		obj.MODULE_TYPE                = item.MODULE_TYPE               ;
		obj.LIST_NAME                  = item.LIST_NAME                 ;
		obj.PARENT_FIELD               = item.PARENT_FIELD              ;

		activeFields[id] = obj;
		if ( this._isMounted )
		{
			// 01/13/2024 Paul.  createItemFromSource is called during initial layout for all items, so we cannot start dragging. 
			this.setState({ activeFields, error: null });
		}
		return {
			id        : id,
			fieldIndex: -1,
			colIndex  : -1,
			rowIndex  : -1,
			origId    : id
		};
	}

	private handleEditClick = (id) =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.handleEditClick', id, this.state.activeFields[id]);
		if ( this._isMounted )
		{
			this.setState({ selectedId: id, error: null })
		}
	}

	private remove = (item: any, type: 'ITEM' | 'ROW') =>
	{
		let { rows, activeFields } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.remove ' + type, item);
		if ( type == 'ITEM' )
		{
			const { id, origId, colIndex, rowIndex } = item;
			let fields: string[] = rows[rowIndex].columns[colIndex];
			let i = fields.indexOf(id);
			if ( i >= 0 )
			{
				fields.splice(i, 1);
			}
			delete activeFields[id];
		}
		else if ( type == 'ROW' )
		{
			const { id, index } = item;
			for ( let colIndex = 0; colIndex < rows[index].columns.length; colIndex++ )
			{
				let fields: string[] = rows[index].columns[colIndex];
				for ( let i = 0; i < fields.length; i++ )
				{
					delete activeFields[fields[i]];
				}
			}
			rows.splice(index, 1);
		}
		else
		{
			return;
		}
		if ( this._isMounted )
		{
			// 01/11/2024 Paul.  Clear dragging. 
			this.setState({ rows, activeFields, draggingId: '', error: null });
		}
	}

	private setDragging = (id: string) =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.setDragging', id);
		if ( this._isMounted )
		{
			if ( this.state.draggingId != id )
			{
				this.setState({ draggingId: id, error: null });
			}
		}
	}

	private removeRow = (index: number) =>
	{
		let { rows, activeFields } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.removeRow', index);
		if ( index != -1 )
		{
			// 03/07/2020 Paul.  We need to remove the actiFields within the row being removed. 
			for ( let colIndex = 0; colIndex < rows[index].columns.length; colIndex++ )
			{
				let fields: string[] = rows[index].columns[colIndex];
				for ( let i = 0; i < fields.length; i++ )
				{
					delete activeFields[fields[i]];
				}
			}
			rows.splice(index, 1);
		}
		if ( this._isMounted )
		{
			this.setState({ rows, activeFields, error: null });
		}
	}

	private moveDraggableRow = (dragIndex: number, hoverIndex: number) =>
	{
		let { rows } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.moveDraggableRow', dragIndex, hoverIndex);
		const row = rows.splice(dragIndex, 1)[0];
		rows.splice(hoverIndex, 0, row);
		if ( this._isMounted )
		{
			this.setState({ rows, error: null });
		}
	}

	private findField = (id: string) =>
	{
		const { rows } = this.state
		for ( let rowIndex = 0; rowIndex < rows.length; rowIndex++ )
		{
			let row: any = rows[rowIndex];
			for ( let colIndex = 0; colIndex < row.columns.length; colIndex++ )
			{
				let col: string[] = row.columns[colIndex];
				if ( col != null )
				{
					for ( let fieldIndex = 0; fieldIndex < col.length; fieldIndex++ )
					{
						if ( col[fieldIndex] == id )
						{
							return { id, rowIndex, colIndex, fieldIndex };
						}
					}
				}
			}
		}
		return null;
	}

	private moveDraggableItem = (id: string, hoverColIndex: number, hoverRowIndex: number, didDrop: boolean) =>
	{
		const { activeFields } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.moveDraggableItem', id, hoverColIndex, hoverRowIndex, didDrop);
		let { rows } = this.state;
		let item: any = this.findField(id);
		if ( item )
		{
			let dragFieldIndex: number = item.fieldIndex;
			let dragColIndex  : number = item.colIndex  ;
			let dragRowIndex  : number = item.rowIndex  ;
			let fields: string[] = rows[dragRowIndex].columns[dragColIndex];
			//const id: string = fields[dragFieldIndex];
			fields.splice(dragFieldIndex, 1);
		
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.moveDraggableItem ' + id, dragFieldIndex, dragColIndex, dragRowIndex, hoverColIndex, hoverRowIndex);
			if ( rows[hoverRowIndex].columns.length == 0 )
			{
				rows[hoverRowIndex].columns.push([]);
			}
			fields = rows[hoverRowIndex].columns[hoverColIndex];
			// 03/15/2020 Paul.  A list column can only have one field, so remove any existing. 
			if ( didDrop && fields.length == 1 )
			{
				if ( activeFields[fields[0]] )
				{
					fields.pop();
					delete activeFields[fields[0]];
				}
			}
			fields.push(id);
			if ( this._isMounted )
			{
				this.setState({ rows, error: null });
			}
		}
		else
		{
			console.warn((new Date()).toISOString() + ' ' + this.constructor.name + '.moveDraggableItem not found ' + id);
		}
	}

	private addSourceItem = (id: string, hoverColIndex: number, hoverRowIndex: number) =>
	{
		const { activeFields } = this.state;
		let { rows } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.addSourceItem', id, hoverColIndex, hoverRowIndex);
		if ( rows[hoverRowIndex].columns.length == 0 )
		{
			rows[hoverRowIndex].columns.push([]);
		}
		let fields: string[] = rows[hoverRowIndex].columns[hoverColIndex];
		/*
		if ( fields.length == 1 )
		{
			if ( activeFields[fields[0]] )
			{
				fields.pop();
				delete activeFields[fields[0]];
			}
		}
		*/
		fields.push(id);
		if ( this._isMounted )
		{
			this.setState({ rows, error: null });
		}
	}

	private addSourceRow = (id: string, hoverIndex: number) =>
	{
		let { rows } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.addSourceRow', id, hoverIndex);
		const row =
		{
			key    : id,
			columns: []
		};
		rows.splice(hoverIndex, 0, row);
		if ( this._isMounted )
		{
			this.setState({ rows, error: null });
		}
	}

	private _onNameChange = (e) =>
	{
		let value = e.target.value;
		if ( this._isMounted )
		{
			this.setState({ layoutName: value, error: null });
		}
	}

	private loadLayout = async (DEFAULT_VIEW) =>
	{
		const { LayoutType, ModuleName, ViewName } = this.props;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.loadLayout');
		try
		{
			if ( this._isMounted )
			{
				let res  = await CreateSplendidRequest('Administration/Rest.svc/GetAdminLayoutModuleFields?ModuleName=' + ModuleName + '&LayoutType=' + LayoutType + '&LayoutName=' + ViewName, 'GET');
				let json = await GetSplendidResult(res);
				if ( this._isMounted )
				{
					let moduleFields: Array<any> = json.d;
					let TableName   : string = 'GRIDVIEWS_COLUMNS';
					let filter      : string = 'GRID_NAME eq \'' + ViewName + '\' and DEFAULT_VIEW eq \'' + DEFAULT_VIEW + '\'';
					res  = await CreateSplendidRequest('Administration/Rest.svc/GetAdminTable?TableName=' + TableName + '&$filter=' + encodeURIComponent(filter) , 'GET');
					json = await GetSplendidResult(res);
					if ( this._isMounted )
					{
						let layoutFields: any = json.d.results;
						TableName = 'GRIDVIEWS';
						filter    = 'NAME eq \'' + ViewName + '\'';
						res  = await CreateSplendidRequest('Administration/Rest.svc/GetAdminTable?TableName=' + TableName + '&$filter=' + encodeURIComponent(filter) , 'GET');
						json = await GetSplendidResult(res);
						if ( this._isMounted )
						{
							let layoutProperties: any = null;
							if ( json.d.results != null && json.d.results.length > 0 )
							{
								layoutProperties = json.d.results[0];
							}
							let rows        : any[]  = [];
							let activeFields: any    = {};
							let row         : any    = null;
							for ( let i = 0; i < layoutFields.length; i++ )
							{
								let field = layoutFields[i];
								let id = field.DATA_FIELD;
								if ( Sql.IsEmptyString(id) )
								{
									id = field.ID;
								}
								row = 
								{
									key    : uuidFast(),
									columns: []
								};
								row.columns.push([]);
								rows.push(row);
								row.columns[row.columns.length-1].push(id);
								activeFields[id] = field;
							}
							this.setState(
							{
								layoutName      : ViewName,
								rows            ,
								activeFields    ,
								moduleFields    ,
								layoutFields    ,
								layoutProperties,
							});
						}
					}
				}
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.loadLayout', error);
			this.setState({ error: error.message });
		}
	}

	private isFieldInUse(field: any)
	{
		const { rows, activeFields } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.isAppInUse', app);
		for ( let rowIndex = 0; rowIndex < rows.length; rowIndex++ )
		{
			for ( let colIndex = 0; colIndex < rows[rowIndex].columns.length; colIndex++ )
			{
				let fields: string[] = rows[rowIndex].columns[colIndex];
				for ( let i = 0; i < fields.length; i++ )
				{
					if ( activeFields[fields[i]] && activeFields[fields[i]].DATA_FIELD == field.DATA_FIELD )
					{
						return true;
					}
				}
			}
		}
		return false;
	}

	private _onSave = async (e) =>
	{
		const { layoutName, rows, activeFields, layoutProperties } = this.state;
		try
		{
			if ( this._isMounted )
			{
				let obj: any = new Object();
				obj.GRIDVIEWS                     = new Object();
				// 05/04/2016 Paul.  EDITVIEWS fields to allow for layout copy. 
				obj.GRIDVIEWS.MODULE_NAME         = layoutProperties.MODULE_NAME       ;
				obj.GRIDVIEWS.VIEW_NAME           = layoutProperties.VIEW_NAME         ;
				obj.GRIDVIEWS.PRE_LOAD_EVENT_ID   = layoutProperties.PRE_LOAD_EVENT_ID ;
				obj.GRIDVIEWS.POST_LOAD_EVENT_ID  = layoutProperties.POST_LOAD_EVENT_ID;
				obj.GRIDVIEWS.SCRIPT              = layoutProperties.SCRIPT            ;
				obj.GRIDVIEWS_COLUMNS = new Array();
				let nFieldIndex: number = 0;
				for ( let i = 0; i < rows.length; i++ )
				{
					let row: any = rows[i];
					for ( let j = 0; j < row.columns.length; j++ )
					{
						let fields: string[] = row.columns[j];
						let layoutField: any = new Object();
						for ( let k = 0; k < fields.length; k++ )
						{
							layoutField.COLUMN_INDEX = nFieldIndex;
							layoutField.ID                         = activeFields[fields[k]].ID                        ;
							layoutField.COLUMN_TYPE                = activeFields[fields[k]].COLUMN_TYPE               ;
							layoutField.DATA_FORMAT                = activeFields[fields[k]].DATA_FORMAT               ;
							layoutField.HEADER_TEXT                = activeFields[fields[k]].HEADER_TEXT               ;
							layoutField.DATA_FIELD                 = activeFields[fields[k]].DATA_FIELD                ;
							layoutField.SORT_EXPRESSION            = activeFields[fields[k]].SORT_EXPRESSION           ;
							layoutField.ITEMSTYLE_WIDTH            = activeFields[fields[k]].ITEMSTYLE_WIDTH           ;
							layoutField.ITEMSTYLE_CSSCLASS         = activeFields[fields[k]].ITEMSTYLE_CSSCLASS        ;
							layoutField.ITEMSTYLE_HORIZONTAL_ALIGN = activeFields[fields[k]].ITEMSTYLE_HORIZONTAL_ALIGN;
							layoutField.ITEMSTYLE_VERTICAL_ALIGN   = activeFields[fields[k]].ITEMSTYLE_VERTICAL_ALIGN  ;
							layoutField.ITEMSTYLE_WRAP             = activeFields[fields[k]].ITEMSTYLE_WRAP            ;
							layoutField.URL_FIELD                  = activeFields[fields[k]].URL_FIELD                 ;
							layoutField.URL_FORMAT                 = activeFields[fields[k]].URL_FORMAT                ;
							layoutField.URL_TARGET                 = activeFields[fields[k]].URL_TARGET                ;
							layoutField.URL_MODULE                 = activeFields[fields[k]].URL_MODULE                ;
							layoutField.URL_ASSIGNED_FIELD         = activeFields[fields[k]].URL_ASSIGNED_FIELD        ;
							layoutField.MODULE_TYPE                = activeFields[fields[k]].MODULE_TYPE               ;
							layoutField.LIST_NAME                  = activeFields[fields[k]].LIST_NAME                 ;
							layoutField.PARENT_FIELD               = activeFields[fields[k]].PARENT_FIELD              ;
							if ( k > 0 )
								layoutField.COLSPAN = -1;
							nFieldIndex++;
							obj.GRIDVIEWS_COLUMNS.push(layoutField);
						}
					}
				}
				let sBody: string = JSON.stringify(obj);
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onSave', obj);
				let res  = await CreateSplendidRequest('Administration/Rest.svc/UpdateAdminLayout?TableName=GRIDVIEWS_COLUMNS&ViewName=' + layoutName, 'POST', 'application/octet-stream', sBody);
				let json = await GetSplendidResult(res);
				//this.props.onEditComplete();
				if( this._isMounted )
				{
					this.setState({ error: L10n.Term('DynamicLayout.LBL_SAVE_COMPLETE') });
				}
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '._onSave', error);
			this.setState({ error: error.message });
		}
	}

	private _onCancel = (e) =>
	{
		if ( this._isMounted )
		{
			this.props.onEditComplete();
		}
	}

	private _onShowRolePopup = (e) =>
	{
		if ( this._isMounted )
		{
			this.setState({ popupOpen: true });
		}
	}

	private _onSelectRole = (value: { Action: string, ID: string, NAME: string, PROCESS_NOTES: string }) =>
	{
		if ( value.Action == 'SingleSelect' )
		{
			if ( this._isMounted )
			{
				let layoutName: string = this.props.ViewName + '.' + value.NAME;
				this.setState({ layoutName, popupOpen: false });
			}
		}
		else if ( value.Action == 'Close' )
		{
			this.setState({ popupOpen: false });
		}
	}

	private _onCopy = (e) =>
	{
		const { layoutName } = this.state;
		if ( this._isMounted )
		{
			// 06/15/2019 Paul.  Copy is the same as Save, but without the ID. 
			this.setState({ layoutName: layoutName + '.Copy', showName: true });
		}
	}

	private _onRestoreDefaults = async (e) =>
	{
		if ( this._isMounted )
		{
			await this.loadLayout(true);
		}
	}

	private _onExport = (e) =>
	{
		const { layoutName } = this.state;
		window.location.href = Credentials.RemoteServer + 'Administration/DynamicLayout/GridViews/export.aspx?NAME=' + layoutName;
	}

	private _onEditPropertiesComplete = (layoutField) =>
	{
		const { activeFields, selectedId } = this.state;
		if ( this._isMounted )
		{
			if ( layoutField && selectedId )
			{
				activeFields[selectedId] = layoutField;
				this.setState({ activeFields, selectedId: null, error: null });
			}
			else
			{
				this.setState({ selectedId: null, error: null });
			}
		}
	}

	public render()
	{
		const { LayoutType, ModuleName } = this.props;
		const { layoutName, moduleFields, rows, activeFields, draggingId, selectedId, layoutProperties, error, MODULE_TERMINOLOGY, showName, popupOpen } = this.state;
		return (
		<React.Fragment>
			<div style={ {flex: '2 2 0', flexDirection: 'column', margin: '0 .5em', border: '1px solid grey', position: 'relative'} }>
				<div style={ {height: '100%', overflowY: 'scroll'} }>
					<h2 style={{ padding: '.25em' }}>{ L10n.Term('DynamicLayout.LBL_TOOLBOX') }</h2>
					<div style={{ padding: '.5em' }}>
						<DraggableRemove remove={ this.remove } />
						<SourceTemplateColumn TITLE={ L10n.Term('DynamicLayout.LBL_NEW_TEMPLATE_COLUMN') } removeRow={ this.removeRow } />
						<br />
					</div>
					<div style={{ padding: '.5em' }}>
						{ moduleFields.map((field, index) => (
							<SourceItem
								ModuleName={ ModuleName }
								item={ field }
								key={ 'moduleField.' + field.ColumnName }
								isFieldInUse={ this.isFieldInUse(field) }
								createItemFromSource={ this.createItemFromSource }
								moveDraggableItem={ this.moveDraggableItem }
								remove={ this.remove }
							/>
						))
						}
					</div>
				</div>
			</div>
			<div style={{ flexDirection: 'column', flex: '8 8 0', margin: '0 .5em', border: '1px solid grey' }}>
				<div style={ {height: '100%', overflowY: 'scroll'} }>
					<h2 style={{ padding: '.25em' }}>{ L10n.Term('DynamicLayout.LBL_LAYOUT') + ' - ' + layoutName }</h2>
					<div style={{ padding: '.5em', whiteSpace: 'nowrap' }}>
						<button type="button" className='button' style={ {marginRight: '2px'} } onClick={ this._onSave           }>{ L10n.Term('.LBL_SAVE_BUTTON_LABEL'             ) }</button>
						<button type="button" className='button' style={ {marginRight: '2px'} } onClick={ this._onCancel         }>{ L10n.Term('.LBL_CANCEL_BUTTON_LABEL'           ) }</button>
						<button type="button" className='button' style={ {marginRight: '2px'} } onClick={ this._onCopy           }>{ L10n.Term('DynamicLayout.LBL_COPY_BUTTON_TITLE') }</button>
						<button type="button" className='button' style={ {marginRight: '2px'} } onClick={ this._onRestoreDefaults}>{ L10n.Term('.LBL_DEFAULTS_BUTTON_LABEL'         ) }</button>
						<button type="button" className='button' style={ {marginRight: '2px'} } onClick={ this._onExport         }>{ L10n.Term('.LBL_EXPORT_BUTTON_LABEL'           ) }</button>
					</div>
					{ showName
					? <div style={{ display: 'flex', marginBottom: '.2em', padding: '.5em' }}>
						<button type="button" className='button' style={ {marginRight: '2px'} } onClick={ this._onShowRolePopup }>{ L10n.Term('DynamicLayout.LBL_SELECT_ROLE'        ) }</button>
						<input
							value={ layoutName }
							onChange={ this._onNameChange }
							style={ {flexGrow: 2} }
						/>
						<PopupView
							isOpen={ popupOpen }
							callback={ this._onSelectRole }
							MODULE_NAME='ACLRoles'
							showProcessNotes={ true }
						/>
					</div>
					: null
					}
					<div className='error' style={ {paddingLeft: '10px'} }>{ error }</div>
					{ layoutProperties
					? <div style={{ padding: '.5em' }}>
						<table style={ {width: '100%', border: '1px solid black'} }>
						{ rows.map((row, rowIndex) => (
							<DraggableRow
								index={ rowIndex }
								id={ row.key }
								key={ row.key }
								moveDraggableRow={ this.moveDraggableRow }
								moveDraggableItem={ this.moveDraggableItem }
								addSourceItem={ this.addSourceItem }
								addSourceRow={ this.addSourceRow }
								removeRow={ this.removeRow } 
								length={ row.columns.length }>
								{ row.columns.map((fields, colIndex) =>
								( <DraggableCell
									width='95%'
									colIndex={ colIndex }
									rowIndex={ rowIndex }
									moveDraggableItem={ this.moveDraggableItem }
									addSourceItem={ this.addSourceItem }
									>
										{ fields.map((fieldId, fieldIndex) =>
										(
											<DraggableItem
												item={ activeFields[fieldId] }
												id={ fieldId }
												key={ fieldId }
												fieldIndex={ fieldIndex }
												colIndex={ colIndex }
												rowIndex={ rowIndex }
												moveDraggableItem={ this.moveDraggableItem }
												remove={ this.remove }
												setDragging={ this.setDragging }
												draggingId={ draggingId }
												rowTotal={ row.columns.length}
												onEditClick={ this.handleEditClick }
											/>
										))}
								</DraggableCell>
								))}
							</DraggableRow>
						))}
						</table>
					</div>
					: <div id={ this.constructor.name + '_spinner' } style={ {textAlign: 'center'} }>
						<FontAwesomeIcon icon="spinner" spin={ true } size="5x" />
					</div>
					}
				</div>
			</div>
			<div style={{ flex: '2 2 0', border: '1px solid grey', margin: '0 .5em' }}>
				<div style={ {height: '100%', overflowY: 'scroll'} }>
					<h2 style={{ padding: '.25em' }}>{ L10n.Term('DynamicLayout.LBL_PROPERTIES') }</h2>
					{ !Sql.IsEmptyString(selectedId)
					? <ListPropertiesEditor layoutField={ activeFields[selectedId] } moduleFields={ moduleFields } onEditComplete={ this._onEditPropertiesComplete } MODULE_TERMINOLOGY={ MODULE_TERMINOLOGY } />
					: null
					}
				</div>
			</div>
		</React.Fragment>
		);
	}
}


