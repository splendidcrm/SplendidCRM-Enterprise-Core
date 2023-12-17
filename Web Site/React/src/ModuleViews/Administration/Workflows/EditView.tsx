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
import { RouteComponentProps }                      from 'react-router-dom'                             ;
import { observer }                                 from 'mobx-react'                                   ;
import { FontAwesomeIcon }                          from '@fortawesome/react-fontawesome'               ;
// 2. Store and Types. 
import { EditComponent }                            from '../../../types/EditComponent'                 ;
import { HeaderButtons }                            from '../../../types/HeaderButtons'                 ;
// 3. Scripts. 
import Sql                                          from '../../../scripts/Sql'                         ;
import L10n                                         from '../../../scripts/L10n'                        ;
import Security                                     from '../../../scripts/Security'                    ;
import Credentials                                  from '../../../scripts/Credentials'                 ;
import SplendidCache                                from '../../../scripts/SplendidCache'               ;
import SplendidDynamic_EditView                     from '../../../scripts/SplendidDynamic_EditView'    ;
import { Admin_GetReactState }                      from '../../../scripts/Application'                 ;
import { AuthenticatedMethod, LoginRedirect }       from '../../../scripts/Login'                       ;
import { EditView_LoadItem, EditView_LoadLayout }   from '../../../scripts/EditView'                    ;
import { CreateSplendidRequest, GetSplendidResult } from '../../../scripts/SplendidRequest'             ;
// 4. Components and Views. 
import ErrorComponent                               from '../../../components/ErrorComponent'           ;
import DumpSQL                                      from '../../../components/DumpSQL'                  ;
import DynamicButtons                               from '../../../components/DynamicButtons'           ;
import HeaderButtonsFactory                         from '../../../ThemeComponents/HeaderButtonsFactory';
import QueryBuilder                                 from '../../../ReportDesigner/QueryBuilder'         ;

interface IAdminEditViewProps extends RouteComponentProps<any>
{
	MODULE_NAME       : string;
	ID                : string;
	LAYOUT_NAME?      : string;
	callback?         : any;
	rowDefaultSearch? : any;
	onLayoutLoaded?   : any;
	onSubmit?         : any;
	DuplicateID?      : string;
	// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
	isPrecompile?       : boolean;
	onComponentComplete?: (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, vwMain) => void;
}

interface IAdminEditViewState
{
	__total           : number;
	__sql             : string;
	item              : any;
	layout            : any;
	layoutRecord      : any;
	layoutTimed       : any;
	EDIT_NAME         : string;
	DUPLICATE         : boolean;
	LAST_DATE_MODIFIED: Date;
	SUB_TITLE         : any;
	editedItem        : any;
	dependents        : Record<string, Array<any>>;
	error?            : any;
}

@observer
export default class WorkflowsEditView extends React.Component<IAdminEditViewProps, IAdminEditViewState>
{
	private _isMounted           : boolean = false;
	private refMap               : Record<string, React.RefObject<EditComponent<any, any>>>;
	private headerButtons        = React.createRef<HeaderButtons>();
	private dynamicButtonsBottom = React.createRef<DynamicButtons>();
	private queryBuilder         = React.createRef<QueryBuilder>();

	public get data (): any
	{
		let row: any = {};
		// 08/27/2019 Paul.  Move build code to shared object. 
		SplendidDynamic_EditView.BuildDataRow(row, this.refMap);
		const currentItem = Object.assign({}, this.state.item, this.state.editedItem, row, this.queryBuilder.current.data);
		return currentItem;
	}

	public validate(): boolean
	{
		// 08/27/2019 Paul.  Move build code to shared object. 
		let nInvalidFields: number = SplendidDynamic_EditView.Validate(this.refMap);
		if ( this.queryBuilder.current != null && !this.queryBuilder.current.validate() )
		{
			this.setState({ error: this.queryBuilder.current.error() });
		}
		return (nInvalidFields == 0);
	}

	public clear(): void
	{
		// 08/27/2019 Paul.  Move build code to shared object. 
		SplendidDynamic_EditView.Clear(this.refMap);
		if ( this._isMounted )
		{
			this.setState({ editedItem: {} });
		}
	}

	constructor(props: IAdminEditViewProps)
	{
		super(props);
		let EDIT_NAME = props.MODULE_NAME + '.EditView';
		if ( !Sql.IsEmptyString(props.LAYOUT_NAME) )
		{
			EDIT_NAME = props.LAYOUT_NAME;
		}
		this.state =
		{
			__total           : 0,
			__sql             : null,
			item              : (props.rowDefaultSearch ? props.rowDefaultSearch : null),
			layout            : null,
			layoutRecord      : null,
			layoutTimed       : null,
			EDIT_NAME         ,
			DUPLICATE         : false,
			LAST_DATE_MODIFIED: null,
			SUB_TITLE         : null,
			editedItem        : null,
			dependents        : {},
			error             : null
		};
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidMount()
	{
		const { MODULE_NAME } = this.props;
		this._isMounted = true;
		try
		{
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
			if ( status == 1 )
			{
				// 07/06/2020 Paul.  Admin_GetReactState will also generate an exception, but catch anyway. 
				if ( !(Security.IS_ADMIN() || SplendidCache.AdminUserAccess(MODULE_NAME, 'edit') >= 0) )
				{
					throw(L10n.Term('.LBL_INSUFFICIENT_ACCESS'));
				}
				// 10/27/2019 Paul.  In case of single page refresh, we need to make sure that the AdminMenu has been loaded. 
				if ( SplendidCache.AdminMenu == null )
				{
					await Admin_GetReactState(this.constructor.name + '.componentDidMount');
				}
				if ( !Credentials.ADMIN_MODE )
				{
					Credentials.SetADMIN_MODE(true);
				}
				await this.load();
			}
			else
			{
				LoginRedirect(this.props.history, this.constructor.name + '.componentDidMount');
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			this.setState({ error });
		}
	}

	async componentDidUpdate(prevProps: IAdminEditViewProps)
	{
		// 04/28/2019 Paul.  Include pathname in filter to prevent double-bounce when state changes. 
		if ( this.props.location.pathname != prevProps.location.pathname )
		{
			// 04/26/2019 Paul.  Bounce through ResetView so that layout gets completely reloaded. 
			// 11/20/2019 Paul.  Include search parameters. 
			this.props.history.push('/Reset' + this.props.location.pathname + this.props.location.search);
		}
		// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
		else
		{
			if ( this.props.onComponentComplete )
			{
				const { MODULE_NAME, ID } = this.props;
				const { item, layout, EDIT_NAME, error } = this.state;
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onComponentComplete ' + EDIT_NAME, item);
				if ( layout != null && error == null )
				{
					if ( ID == null || item != null )
					{
						this.props.onComponentComplete(MODULE_NAME, null, EDIT_NAME, item);
					}
				}
			}
		}
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}
	
	private load = async () =>
	{
		const { MODULE_NAME, ID, DuplicateID } = this.props;
		const { EDIT_NAME } = this.state;
		try
		{
			const layoutRecord = EditView_LoadLayout(EDIT_NAME);
			const layoutTimed  = EditView_LoadLayout(EDIT_NAME + '.Timed');
			// 06/19/2018 Paul.  Always clear the item when setting the layout. 
			// 06/05/2021 Paul.  Must initialize rowDefaultSearch in order for QueryBuilder to get initial state. 
			let rowDefaultSearch: any = this.props.rowDefaultSearch;
			// 07/01/2021 Paul.  Don't initialize item if duplicate provided. 
			if ( Sql.IsEmptyGuid(ID) && Sql.IsEmptyGuid(DuplicateID) )
			{
				// 06/05/2021 Paul.  Must initialize rowDefaultSearch in order for QueryBuilder to get initial state. 
				// 06/06/2021 Paul.  Only initialize if new record, otherwise the EditView will not update with value from LoadItem. 
				rowDefaultSearch = {};
				let lstTYPE       : any[] = L10n.GetList('workflow_type_dom'       );
				let lstSTATUS     : any[] = L10n.GetList('workflow_status_dom'     );
				let lstBASE_MODULE: any[] = L10n.GetList('WorkflowModules'         );
				let lstRECORD_TYPE: any[] = L10n.GetList('workflow_record_type_dom');
				let lstFIRE_ORDER : any[] = L10n.GetList('workflow_fire_order_dom' );
				rowDefaultSearch.TYPE        = (lstTYPE       .length > 0 ? lstTYPE       [0] : null);
				rowDefaultSearch.STATUS      = (lstSTATUS     .length > 0 ? lstSTATUS     [0] : null);
				rowDefaultSearch.BASE_MODULE = (lstBASE_MODULE.length > 0 ? lstBASE_MODULE[0] : null);
				rowDefaultSearch.RECORD_TYPE = (lstRECORD_TYPE.length > 0 ? lstRECORD_TYPE[0] : null);
				rowDefaultSearch.FIRE_ORDER  = (lstFIRE_ORDER .length > 0 ? lstFIRE_ORDER [0] : null);
			}
			if ( this._isMounted )
			{
				this.setState(
				{
					layout      : layoutRecord,
					layoutRecord,
					layoutTimed ,
					item        : (rowDefaultSearch ? rowDefaultSearch : null),
					editedItem  : null,
				}, () =>
				{
					if ( this.props.onLayoutLoaded )
					{
						this.props.onLayoutLoaded();
					}
				});
				if ( !Sql.IsEmptyString(DuplicateID) )
				{
					await this.LoadItem(MODULE_NAME, DuplicateID);
				}
				else
				{
					await this.LoadItem(MODULE_NAME, ID);
				}
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.load', error);
			this.setState({ error });
		}
	}

	private LoadItem = async (sMODULE_NAME: string, sID: string) =>
	{
		let { layout } = this.state;
		if ( !Sql.IsEmptyString(sID) )
		{
			try
			{
				// 11/19/2019 Paul.  Change to allow return of SQL. 
				const d = await EditView_LoadItem(sMODULE_NAME, sID, true);
				let item: any = d.results;
				let LAST_DATE_MODIFIED: Date = null;
				// 03/16/2014 Paul.  LAST_DATE_MODIFIED is needed for concurrency test. 
				if ( item != null && item['DATE_MODIFIED'] !== undefined )
				{
					LAST_DATE_MODIFIED = item['DATE_MODIFIED'];
				}
				if ( item != null )
				{
					// 06/03/2021 Paul.  Must set the field use by QueryBuilder. 
					item['MODULE_NAME'] = item['BASE_MODULE'];
					// 06/04/2021 Paul.  workflow_status_dom uses True/False. 
					item['STATUS'     ] = (Sql.ToBoolean(item['STATUS']) ? 'True' : 'False');
					// 06/03/2021 Paul.  Default TYPE is normal, so hide frequency. 
					let bTimedWorkflow: boolean = (item['TYPE'] == 'time');
					layout = (bTimedWorkflow ? this.state.layoutTimed : this.state.layoutRecord);
				}
				if ( this._isMounted )
				{
					Sql.SetPageTitle(sMODULE_NAME, item, 'NAME');
					let SUB_TITLE: any = Sql.DataPrivacyErasedField(item, 'NAME');
					this.setState({ layout, item, SUB_TITLE, __sql: d.__sql, LAST_DATE_MODIFIED });
				}
			}
			catch(error)
			{
				console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.LoadItem', error);
				this.setState({ error });
			}
		}
	}

	private _onChange = (DATA_FIELD: string, DATA_VALUE: any, DISPLAY_FIELD?: string, DISPLAY_VALUE?: any): void =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onChange ' + DATA_FIELD, DATA_VALUE);
		let item = this.state.editedItem;
		if ( item == null )
			item = {};
		item[DATA_FIELD] = DATA_VALUE;
		// 06/03/2021 Paul.  Must set the field use by QueryBuilder. 
		if ( DATA_FIELD == 'BASE_MODULE' )
		{
			item['MODULE_NAME'] = DATA_VALUE;
		}
		if ( this._isMounted )
		{
			this.setState({ editedItem: item });
		}
	}

	private _createDependency = (DATA_FIELD: string, PARENT_FIELD: string, PROPERTY_NAME?: string): void =>
	{
		let { dependents } = this.state;
		if ( dependents[PARENT_FIELD] )
		{
			dependents[PARENT_FIELD].push( {DATA_FIELD, PROPERTY_NAME} );
		}
		else
		{
			dependents[PARENT_FIELD] = [ {DATA_FIELD, PROPERTY_NAME} ]
		}
		if ( this._isMounted )
		{
			this.setState({ dependents: dependents });
		}
	}

	private _onUpdate = (PARENT_FIELD: string, DATA_VALUE: any, item?: any): void =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onUpdate ' + PARENT_FIELD, DATA_VALUE);
		let { dependents, layout } = this.state;
		if ( dependents[PARENT_FIELD] )
		{
			let dependentIds = dependents[PARENT_FIELD];
			for ( let i = 0; i < dependentIds.length; i++ )
			{
				let ref = this.refMap[dependentIds[i].DATA_FIELD];
				if ( ref )
				{
					ref.current.updateDependancy(PARENT_FIELD, DATA_VALUE, dependentIds[i].PROPERTY_NAME, item);
				}
			}
		}
		if ( PARENT_FIELD == 'TYPE' )
		{
			// 06/03/2021 Paul.  Default TYPE is normal, so hide frequency. 
			let bTimedWorkflow: boolean = (DATA_VALUE == 'time');
			layout = (bTimedWorkflow ? this.state.layoutTimed : this.state.layoutRecord);
			this.setState({ layout });
		}
	}

	// 06/15/2018 Paul.  The SearchView will register for the onSubmit event. 
	private _onSubmit = (): void =>
	{
		try
		{
			if ( this.props.onSubmit )
			{
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onSubmit');
				this.props.onSubmit();
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '._onSubmit', error);
			this.setState({ error });
		}
	}

	private UpdateModule = async (row: any, sID: string) =>
	{
		if ( !Credentials.ValidateCredentials )
		{
			throw new Error('Invalid connection information.');
		}
		else if ( row == null )
		{
			throw new Error(this.constructor.name + '.UpdateModule: row is invalid.');
		}
		else
		{
			let sBody: string = JSON.stringify(row);
			let res = await CreateSplendidRequest('Administration/Workflows/Rest.svc/UpdateModule', 'POST', 'application/octet-stream', sBody);
			let json = await GetSplendidResult(res);
			sID = json.d;
		}
		return sID;
	}

	// 05/14/2018 Chase. This function will be passed to DynamicButtons to be called as Page_Command
	// Add additional params if you need access to the onClick event params.
	private Page_Command = async (sCommandName, sCommandArguments) =>
	{
		const { ID, MODULE_NAME, history, location } = this.props;
		const { LAST_DATE_MODIFIED } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, sCommandArguments, this.refMap)
		// This sets the local state, which is then passed to DynamicButtons
		try
		{
			let row;
			switch (sCommandName)
			{
				case 'Save':
				case 'SaveNew':
				case 'SaveDuplicate':
				case 'SaveConcurrency':
				{
					if ( this.validate() )
					{
						let isDuplicate = location.pathname.includes('Duplicate');
						row = this.data;
						row.ID = (isDuplicate ? null : ID);
						if ( LAST_DATE_MODIFIED != null )
						{
							row['LAST_DATE_MODIFIED'] = LAST_DATE_MODIFIED;
						}
						if ( sCommandName == 'SaveDuplicate' || sCommandName == 'SaveConcurrency' )
						{
							row[sCommandName] = true;
						}
						try
						{
							if ( this.headerButtons.current != null )
							{
								this.headerButtons.current.Busy();
							}
							row.ID = await this.UpdateModule(row, isDuplicate ? null : ID);
							// 02/22/2021 Paul.  A number of admin modules support SaveNew.
							if ( sCommandName == 'SaveNew' )
							{
								history.push(`/Reset/Administration/${MODULE_NAME}/Edit/`);
							}
							else
							{
								history.push(`/Reset/Administration/${MODULE_NAME}/View/` + row.ID);
							}
						}
						catch(error)
						{
							console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, error);
							if ( this.headerButtons.current != null )
							{
								this.headerButtons.current.NotBusy();
							}
							if ( this._isMounted )
							{
								if ( error.message.includes('.ERR_DUPLICATE_EXCEPTION') )
								{
									if ( this.headerButtons.current != null )
									{
										this.headerButtons.current.ShowButton('SaveDuplicate', true);
									}
									this.setState( {error: L10n.Term(error.message) } );
								}
								else if ( error.message.includes('.ERR_CONCURRENCY_OVERRIDE') )
								{
									if ( this.headerButtons.current != null )
									{
										this.headerButtons.current.ShowButton('SaveConcurrency', true);
									}
									this.setState( {error: L10n.Term(error.message) } );
								}
								else
								{
									this.setState({ error });
								}
							}
						}
					}
					break;
				}
				case 'Cancel':
				{
					if ( Sql.IsEmptyString(ID) )
						history.push(`/Reset/Administration/${MODULE_NAME}/List`);
					else
						history.push(`/Reset/Administration/${MODULE_NAME}/View/${ID}`);
					break;
				}
				default:
				{
					if ( this._isMounted )
					{
						this.setState( {error: sCommandName + ' is not supported at this time'} );
					}
					break;
				}
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, error);
			this.setState({ error });
		}
	}

	public render()
	{
		const { MODULE_NAME, ID, DuplicateID, callback } = this.props;
		const { item, layout, EDIT_NAME, SUB_TITLE, error } = this.state;
		const { __total, __sql } = this.state;
		// 05/04/2019 Paul.  Reference obserable IsInitialized so that terminology update will cause refresh. 
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render: ' + EDIT_NAME, layout, item);
		// 09/09/2019 Paul.  We need to wait until item is loaded, otherwise fields will not get populated. 
		if ( layout == null || (item == null && (!Sql.IsEmptyString(ID) || !Sql.IsEmptyString(DuplicateID))) )
		{
			if ( error )
			{
				return (<ErrorComponent error={error} />);
			}
			else
			{
				return null;
			}
		}
		this.refMap = {};
		let onSubmit = (this.props.onSubmit ? this._onSubmit : null);
		if ( SplendidCache.IsInitialized && SplendidCache.AdminMenu )
		{
			// 12/04/2019 Paul.  After authentication, we need to make sure that the app gets updated. 
			Credentials.sUSER_THEME;
			const currentItem = Object.assign({}, this.state.item, this.state.editedItem);
			// 06/05/2021 Paul.  QueryBuilder uses MODULE_NAME. 
			currentItem['MODULE_NAME'] = currentItem['BASE_MODULE'];
			let headerButtons = HeaderButtonsFactory(SplendidCache.UserTheme);
			return (
			<div>
				{ !callback && headerButtons
				? React.createElement(headerButtons, { MODULE_NAME, ID, SUB_TITLE, error, ButtonStyle: 'EditHeader', VIEW_NAME: EDIT_NAME, row: item, Page_Command: this.Page_Command, showButtons: true, history: this.props.history, location: this.props.location, match: this.props.match, ref: this.headerButtons })
				: null
				}
				<DumpSQL SQL={ __sql } />
				<div id={!!callback ? null : "content"}>
					{ SplendidDynamic_EditView.AppendEditViewFields(item, layout, this.refMap, callback, this._createDependency, null, this._onChange, this._onUpdate, onSubmit, 'tabForm', this.Page_Command) }
					<br />
				</div>
				
				<h4>{ L10n.Term('Workflows.LBL_FILTERS') }</h4>
				{ !Sql.IsEmptyString(currentItem['MODULE_NAME'])
				? <QueryBuilder
					row={ currentItem }
					Modules={ currentItem['BASE_MODULE'] }
					DATA_FIELD='FILTER_XML'
					DesignWorkflow={ true }
					PrimaryKeyOnly={ false }
					UseSQLParameters={ false }
					DesignChart={ false }
					ShowRelated={ true }
					ShowModule={ false }
					onChanged={ this._onChange }
					ref={ this.queryBuilder }
				/>
				: null
				}
				{ !callback && headerButtons
				? <DynamicButtons
					ButtonStyle="EditHeader"
					VIEW_NAME={ EDIT_NAME }
					row={ item }
					Page_Command={ this.Page_Command }
					history={ this.props.history }
					location={ this.props.location }
					match={ this.props.match }
					ref={ this.dynamicButtonsBottom }
				/>
				: null
				}
			</div>
			);
		}
		else if ( error )
		{
			return (<ErrorComponent error={error} />);
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

// 04/27/2020 Paul.  We don't want to use withRouter() as it makes it difficult to get a reference. 

