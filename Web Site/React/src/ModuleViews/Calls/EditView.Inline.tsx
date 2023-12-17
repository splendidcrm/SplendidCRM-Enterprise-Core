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
import * as qs from 'query-string';
import { RouteComponentProps }                from 'react-router-dom'                          ;
import moment                                 from 'moment'                                    ;
import { observer }                           from 'mobx-react'                                ;
import { FontAwesomeIcon }                    from '@fortawesome/react-fontawesome'            ;
// 2. Store and Types. 
import { EditComponent }                      from '../../types/EditComponent'                 ;
import { HeaderButtons }                      from '../../types/HeaderButtons'                 ;
// 3. Scripts. 
import Sql                                    from '../../scripts/Sql'                         ;
import L10n                                   from '../../scripts/L10n'                        ;
import Security                               from '../../scripts/Security'                    ;
import Credentials                            from '../../scripts/Credentials'                 ;
import SplendidCache                          from '../../scripts/SplendidCache'               ;
import SplendidDynamic_EditView               from '../../scripts/SplendidDynamic_EditView'    ;
import { Crm_Config, Crm_Modules }            from '../../scripts/Crm'                         ;
import { ToJsonDate }                         from '../../scripts/Formatting'                  ;
import { AuthenticatedMethod, LoginRedirect } from '../../scripts/Login'                       ;
import { sPLATFORM_LAYOUT }                   from '../../scripts/SplendidInitUI'              ;
import { EditView_LoadItem, EditView_LoadLayout, EditView_ConvertItem, EditView_UpdateREPEAT_TYPE } from '../../scripts/EditView';
import { UpdateModule }                       from '../../scripts/ModuleUpdate'                ;
import { jsonReactState }                     from '../../scripts/Application'                 ;
// 4. Components and Views. 
import ErrorComponent                         from '../../components/ErrorComponent'           ;
import DumpSQL                                from '../../components/DumpSQL'                  ;
import HeaderButtonsFactory                   from '../../ThemeComponents/HeaderButtonsFactory';

interface IEditViewProps extends RouteComponentProps<any>
{
	MODULE_NAME        : string;
	ID?                : string;
	LAYOUT_NAME        : string;
	callback?          : any;
	rowDefaultSearch?  : any;
	onLayoutLoaded?    : any;
	onSubmit?          : any;
	isSearchView?      : boolean;
	isUpdatePanel?     : boolean;
	DuplicateID?       : string;
	ConvertModule?     : string;
	ConvertID?         : string;
}

interface IEditViewState
{
	__total            : number;
	__sql              : string;
	item               : any;
	layout             : any;
	EDIT_NAME          : string;
	DUPLICATE          : boolean;
	LAST_DATE_MODIFIED : Date;
	SUB_TITLE          : any;
	editedItem         : any;
	dependents         : Record<string, Array<any>>;
	error              : any;
}

// 09/18/2019 Paul.  Give class a unique name so that it can be debugged.  Without the unique name, Chrome gets confused.
@observer
export default class CallsEditViewInline extends React.Component<IEditViewProps, IEditViewState>
{
	private _isMounted   : boolean = false;
	private refMap       : Record<string, React.RefObject<EditComponent<any, any>>>;
	private headerButtons = React.createRef<HeaderButtons>();
	private PARENT_ID    : string = null;
	private PARENT_TYPE  : string = null;

	public get data (): any
	{
		let row: any = {};
		// 08/27/2019 Paul.  Move build code to shared object. 
		let nInvalidFields: number = SplendidDynamic_EditView.BuildDataRow(row, this.refMap);
		// 08/26/2019 Paul.  There does not seem to be a need to save date in DATE_TIME field here as this is used for search views. 
		if ( nInvalidFields == 0 )
		{
			// 08/26/2019 Paul.  The layout field is DATE_START, but the stored procedure field is DATE_TIME.  Correct here. 
			row['DATE_TIME'] = row['DATE_START'];
			// 08/09/2020 Paul.  rowDefaultSearch will prepopulated with parent values. 
			if ( this.props.rowDefaultSearch )
			{
				row['PARENT_ID'  ] = this.props.rowDefaultSearch['PARENT_ID'  ];
				row['PARENT_NAME'] = this.props.rowDefaultSearch['PARENT_NAME'];
				row['PARENT_TYPE'] = this.props.rowDefaultSearch['PARENT_TYPE'];
			}
		}
		return row;
	}

	public validate(): boolean
	{
		// 08/27/2019 Paul.  Move build code to shared object. 
		let nInvalidFields: number = SplendidDynamic_EditView.Validate(this.refMap);
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

	constructor(props: IEditViewProps)
	{
		super(props);
		let item = (props.rowDefaultSearch ? props.rowDefaultSearch : null);
		let EDIT_NAME = props.MODULE_NAME + '.EditView' + sPLATFORM_LAYOUT;
		if ( !Sql.IsEmptyString(props.LAYOUT_NAME) )
		{
			EDIT_NAME = props.LAYOUT_NAME;
		}
		this.state =
		{
			__total           : 0,
			__sql             : null,
			item              ,
			layout            : null,
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
		const { isSearchView } = this.props;
		this._isMounted = true;
		try
		{
			// 05/29/2019 Paul.  In search mode, EditView will not redirect to login. 
			if ( Sql.ToBoolean(isSearchView) )
			{
				if ( jsonReactState == null )
				{
					//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount jsonReactState is null');
				}
				if ( Credentials.bIsAuthenticated )
				{
					await this.load();
				}
			}
			else
			{
				let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
				if ( status == 1 )
				{
					if ( jsonReactState == null )
					{
						//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount jsonReactState is null');
					}
					if ( Credentials.ADMIN_MODE )
					{
						Credentials.SetADMIN_MODE(false);
					}
					await this.load();
				}
				else
				{
					LoginRedirect(this.props.history, this.constructor.name + '.componentDidMount');
				}
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			this.setState({ error });
		}
	}

	async componentDidUpdate(prevProps: IEditViewProps)
	{
		// 04/28/2019 Paul.  Include pathname in filter to prevent double-bounce when state changes. 
		if ( this.props.location.pathname != prevProps.location.pathname )
		{
			// 04/26/2019 Paul.  Bounce through ResetView so that layout gets completely reloaded. 
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidUpdate Reset ' + this.state.EDIT_NAME, this.props.location,  prevProps.location);
			// 11/20/2019 Paul.  Include search parameters. 
			this.props.history.push('/Reset' + this.props.location.pathname + this.props.location.search);
		}
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}

	private load = async () =>
	{
		const { MODULE_NAME, ID, DuplicateID, ConvertModule, ConvertID } = this.props;
		const { EDIT_NAME } = this.state;
		try
		{
			// 10/12/2019 Paul.  Add support for parent assignment during creation. 
			let rowDefaultSearch: any = this.props.rowDefaultSearch;
			let queryParams: any = qs.parse(location.search);
			// 10/13/2020 Paul.  Correct parent found condition. 
			let bParentFound: boolean = (rowDefaultSearch !== undefined && rowDefaultSearch != null);
			if ( !Sql.IsEmptyGuid(queryParams['PARENT_ID']) )
			{
				this.PARENT_ID   = queryParams['PARENT_ID'];
				this.PARENT_TYPE = await Crm_Modules.ParentModule(this.PARENT_ID);
				if ( !Sql.IsEmptyString(this.PARENT_TYPE) )
				{
					rowDefaultSearch = await Crm_Modules.LoadParent(this.PARENT_TYPE, this.PARENT_ID);
					bParentFound = true;
				}
				else
				{
					this.setState( {error: 'Parent ID [' + this.PARENT_ID + '] was not found.'} );
				}
			}
			if ( Sql.IsEmptyGuid(ID) && Sql.IsEmptyGuid(DuplicateID) && Sql.IsEmptyGuid(ConvertID) )
			{
				// 03/19/2020 Paul.  If we initialize rowDefaultSearch, then we need to set assigned and team values. 
				// 10/13/2020 Paul.  Make the condition more explicit. 
				if ( rowDefaultSearch === undefined || rowDefaultSearch == null )
				{
					rowDefaultSearch = {};
				}
				// 08/10/2020 Paul.  Parent may not initialize user and team fields. 
				if ( !bParentFound || !Crm_Config.ToBoolean('inherit_assigned_user') )
				{
					rowDefaultSearch['ASSIGNED_SET_LIST'] = Security.USER_ID()  ;
					rowDefaultSearch['ASSIGNED_USER_ID' ] = Security.USER_ID()  ;
					rowDefaultSearch['ASSIGNED_TO'      ] = Security.USER_NAME();
					rowDefaultSearch['ASSIGNED_TO_NAME' ] = Security.FULL_NAME();
				}
				if ( !bParentFound || !Crm_Config.ToBoolean('inherit_team') )
				{
					rowDefaultSearch['TEAM_ID'          ] = Security.TEAM_ID()  ;
					rowDefaultSearch['TEAM_NAME'        ] = Security.TEAM_NAME();
					rowDefaultSearch['TEAM_SET_LIST'    ] = Security.TEAM_ID()  ;
					rowDefaultSearch['TEAM_SET_NAME'    ] = Security.TEAM_ID()  ;
				}
				// 06/03/2020 Paul.  Include self in invitee list. 
				rowDefaultSearch['INVITEE_LIST'    ] = Security.USER_ID()  ;
				// 06/03/2020 Paul.  Set start date to around now. 
				let dtNow: Date = new Date();
				dtNow.setMinutes(Math.floor(dtNow.getMinutes() / 15) * 15);
				dtNow.setSeconds(0);
				dtNow.setMilliseconds(0);
				rowDefaultSearch['DATE_START'      ] = ToJsonDate(dtNow);
				rowDefaultSearch['DURATION_MINUTES'] = 15;
				rowDefaultSearch['DURATION_HOURS'  ] = 0;
				if ( !Sql.IsEmptyString(queryParams['DATE_START']) )
				{
					let mntValue = moment(queryParams['DATE_START']);
					rowDefaultSearch['DATE_START'] = mntValue.toDate();
				}
				if ( !Sql.IsEmptyString(queryParams['DURATION_MINUTES']) )
				{
					let DURATION_MINUTES: number = parseInt(queryParams['DURATION_MINUTES']);
					if ( !isNaN(DURATION_MINUTES) )
					{
						rowDefaultSearch['DURATION_MINUTES'] = DURATION_MINUTES;
					}
				}
				if ( !Sql.IsEmptyString(queryParams['DURATION_HOURS']) )
				{
					let DURATION_HOURS: number = parseInt(queryParams['DURATION_HOURS']);
					if ( !isNaN(DURATION_HOURS) )
					{
						rowDefaultSearch['DURATION_HOURS'] = DURATION_HOURS;
					}
				}
				if ( !Sql.IsEmptyString(queryParams['DIRECTION']) )
				{
					rowDefaultSearch['DIRECTION'] = queryParams['DIRECTION'];
				}
				if ( !Sql.IsEmptyString(queryParams['STATUS']) )
				{
					rowDefaultSearch['STATUS'] = queryParams['STATUS'];
				}
				rowDefaultSearch['SHOULD_REMIND'] = true;
				// 08/09/2020 Paul.  rowDefaultSearch will prepopulated with parent values. 
				if ( this.props.rowDefaultSearch )
				{
					rowDefaultSearch['PARENT_ID'  ] = this.props.rowDefaultSearch['PARENT_ID'  ];
					rowDefaultSearch['PARENT_NAME'] = this.props.rowDefaultSearch['PARENT_NAME'];
					rowDefaultSearch['PARENT_TYPE'] = this.props.rowDefaultSearch['PARENT_TYPE'];
				}
			}
			let layout: any[] = EditView_LoadLayout(EDIT_NAME);
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.load', layout);
			// 06/19/2018 Paul.  Always clear the item when setting the layout. 
			if ( this._isMounted )
			{
				// 04/21/2020 Paul.  Show/Hide recurrence fields based on the type. 
				if ( rowDefaultSearch != null )
				{
					let REPEAT_TYPE: string = rowDefaultSearch['REPEAT_TYPE'];
					EditView_UpdateREPEAT_TYPE(layout, REPEAT_TYPE);
				}
				this.setState(
				{
					layout: layout,
					item: (rowDefaultSearch ? rowDefaultSearch : null),
					editedItem: null
				}, () =>
				{
					if ( this.props.onLayoutLoaded )
					{
						//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.load onLayoutLoaded');
						this.props.onLayoutLoaded();
					}
				});
				if ( !Sql.IsEmptyString(DuplicateID) )
				{
					await this.LoadItem(MODULE_NAME, DuplicateID);
				}
				else if ( !Sql.IsEmptyString(ConvertID) )
				{
					await this.ConvertItem(MODULE_NAME, ConvertModule, ConvertID);
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
		const { callback, isSearchView, isUpdatePanel } = this.props;
		let { layout } = this.state;
		if ( !Sql.IsEmptyString(sID) )
		{
			try
			{
				// 11/19/2019 Paul.  Change to allow return of SQL. 
				let d: any = await EditView_LoadItem(sMODULE_NAME, sID);
				let item: any = d.results;
				let LAST_DATE_MODIFIED: Date = null;
				if ( item != null )
				{
					// 03/16/2014 Paul.  LAST_DATE_MODIFIED is needed for concurrency test. 
					if ( item['DATE_MODIFIED'] !== undefined )
					{
						LAST_DATE_MODIFIED = item['DATE_MODIFIED'];
					}
				}
				if ( this._isMounted )
				{
					// 05/03/2020 Paul.  Force lower case. 
					let queryParams: any = qs.parse(location.search.toLowerCase());
					if ( item != null && queryParams['status'] == 'close' )
					{
						item['STATUS'] = 'Held';
					}
					Sql.SetPageTitle(sMODULE_NAME, item, 'NAME');
					let SUB_TITLE: any = Sql.DataPrivacyErasedField(item, 'NAME');
					// 03/18/2020 Paul.  Show/Hide recurrence fields based on the type. 
					let REPEAT_TYPE: string = (item ? item['REPEAT_TYPE'] : null);
					EditView_UpdateREPEAT_TYPE(layout, REPEAT_TYPE);
					this.setState(
					{
						item              ,
						layout            ,
						SUB_TITLE         ,
						__sql             : d.__sql,
						LAST_DATE_MODIFIED,
					});
				}
			}
			catch(error)
			{
				console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.LoadItem', error);
				this.setState({ error });
			}
		}
		else if ( !callback && !isSearchView && !isUpdatePanel )
		{
			Sql.SetPageTitle(sMODULE_NAME, null, null);
		}
	}

	private ConvertItem = async (sMODULE_NAME: string, sSOURCE_MODULE_NAME: string, sSOURCE_ID: string) =>
	{
		let { layout } = this.state;
		if ( !Sql.IsEmptyString(sSOURCE_ID) )
		{
			try
			{
				// 11/19/2019 Paul.  Change to allow return of SQL. 
				const d = await EditView_ConvertItem(sMODULE_NAME, sSOURCE_MODULE_NAME, sSOURCE_ID);
				let LAST_DATE_MODIFIED: Date = null;
				if ( this._isMounted )
				{
					let item: any = d.results;
					Sql.SetPageTitle(sMODULE_NAME, item, 'NAME');
					let SUB_TITLE: any = Sql.DataPrivacyErasedField(item, 'NAME');
					// 03/18/2020 Paul.  Show/Hide recurrence fields based on the type. 
					let REPEAT_TYPE: string = (item ? item['REPEAT_TYPE'] : null);
					EditView_UpdateREPEAT_TYPE(layout, REPEAT_TYPE);
					this.setState(
					{
						item              ,
						layout            ,
						SUB_TITLE         ,
						__sql: d.__sql    ,
						LAST_DATE_MODIFIED,
					});
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
		if ( this._isMounted )
		{
			if ( DATA_FIELD == 'ALL_DAY_EVENT' && DATA_VALUE )
			{
				item['DURATION_MINUTES'] = 0;
				item['DURATION_HOURS'  ] = 24;
			}
			else if ( DATA_FIELD == 'DURATION_MINUTES' || DATA_FIELD == 'DURATION_HOURS' )
			{
				item['ALL_DAY_EVENT'] = false;
			}
			// 03/18/2020 Paul.  Show/Hide recurrence fields based on the type. 
			if ( DATA_FIELD == 'REPEAT_TYPE' )
			{
				let { layout } = this.state;
				let REPEAT_TYPE: string = DATA_VALUE;
				// 04/21/2020 Paul.  Show/Hide recurrence fields based on the type. 
				EditView_UpdateREPEAT_TYPE(layout, REPEAT_TYPE);
				this.setState({ editedItem: item, layout });
			}
			else
			{
				this.setState({ editedItem: item });
			}
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
		let { dependents } = this.state;
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
			// 08/09/2020 Paul.  An inline module does not typically get the Page_Command events. 
			/*
			switch (sCommandName)
			{
				case 'Save':
				case 'SaveDuplicate':
				case 'SaveConcurrency':
				{
					let isDuplicate = location.pathname.includes('Duplicate');
					row = {
						ID: isDuplicate ? null : ID
					};
					// 08/27/2019 Paul.  Move build code to shared object. 
					let nInvalidFields: number = SplendidDynamic_EditView.BuildDataRow(row, this.refMap);
					if ( nInvalidFields == 0 )
					{
						// 08/26/2019 Paul.  The layout field is DATE_START, but the stored procedure field is DATE_TIME.  Correct here. 
						row['DATE_TIME'] = row['DATE_START'];
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
							row.ID = await UpdateModule(MODULE_NAME, row, isDuplicate ? null : ID);
							// 10/15/2019 Paul.  Redirect to parent if provided. 
							if ( !Sql.IsEmptyGuid(this.PARENT_ID) )
							{
								history.push(`/Reset/${this.PARENT_TYPE}/View/${this.PARENT_ID}`);
							}
							else
							{
								history.push(`/Reset/${MODULE_NAME}/View/` + row.ID);
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
					// 10/15/2019 Paul.  Redirect to parent if provided. 
					if ( !Sql.IsEmptyGuid(this.PARENT_ID) )
					{
						history.push(`/Reset/${this.PARENT_TYPE}/View/${this.PARENT_ID}`);
					}
					else if ( Sql.IsEmptyString(ID) )
					{
						history.push(`/Reset/${MODULE_NAME}/List`);
					}
					else
					{
						history.push(`/Reset/${MODULE_NAME}/View/${ID}`);
					}
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
			*/
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, error);
			this.setState({ error });
		}
	}

	public render()
	{
		const { MODULE_NAME, ID, DuplicateID, ConvertID, isSearchView, isUpdatePanel, callback } = this.props;
		const { item, layout, EDIT_NAME, SUB_TITLE, error } = this.state;
		const { __total, __sql } = this.state;
		// 05/04/2019 Paul.  Reference obserable IsInitialized so that terminology update will cause refresh. 
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render: ' + EDIT_NAME, layout, item);
		// 09/09/2019 Paul.  We need to wait until item is loaded, otherwise fields will not get populated. 
		// 09/18/2019 Paul.  Include ConvertID. 
		if ( layout == null || (item == null && (!Sql.IsEmptyString(ID) || !Sql.IsEmptyString(DuplicateID) || !Sql.IsEmptyString(ConvertID))) )
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
		const currentItem = Object.assign({}, this.state.item, this.state.editedItem);
		if ( SplendidCache.IsInitialized )
		{
			// 12/04/2019 Paul.  After authentication, we need to make sure that the app gets updated. 
			Credentials.sUSER_THEME;
			let headerButtons = HeaderButtonsFactory(SplendidCache.UserTheme);
			return (
			<React.Fragment>
				{ !callback && headerButtons
				? React.createElement(headerButtons, { MODULE_NAME, ID, SUB_TITLE, error, showRequired: true, enableHelp: true, helpName: 'EditView', ButtonStyle: 'EditHeader', VIEW_NAME: EDIT_NAME, row: item, Page_Command: this.Page_Command, showButtons: !isSearchView && !isUpdatePanel, history: this.props.history, location: this.props.location, match: this.props.match, ref: this.headerButtons })
				: null
				}
				<DumpSQL SQL={ __sql } />
				{ SplendidDynamic_EditView.AppendEditViewFields(item, layout, this.refMap, callback, this._createDependency, null, this._onChange, this._onUpdate, onSubmit, 'tabForm', this.Page_Command) }
			</React.Fragment>
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

// 07/18/2019 Paul.  We don't want to use withRouter() as it makes it difficult to get a reference. 

