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
import { RouteComponentProps, withRouter }             from 'react-router-dom'                         ;
import { observer }                                    from 'mobx-react'                               ;
import { FontAwesomeIcon }                             from '@fortawesome/react-fontawesome'           ;
// 2. Store and Types. 
import { EditComponent }                               from '../../../types/EditComponent'             ;
import { HeaderButtons }                               from '../../../types/HeaderButtons'             ;
// 3. Scripts. 
import L10n                                            from '../../../scripts/L10n'                    ;
import Sql                                             from '../../../scripts/Sql'                     ;
import Security                                        from '../../../scripts/Security'                ;
import Credentials                                     from '../../../scripts/Credentials'             ;
import SplendidCache                                   from '../../../scripts/SplendidCache'           ;
import { Admin_GetReactState }                         from '../../../scripts/Application'             ;
import { AuthenticatedMethod, LoginRedirect, Version } from '../../../scripts/Login'                   ;
import SplendidDynamic_EditView                        from '../../../scripts/SplendidDynamic_EditView';
import { EditView_LoadLayout }                         from '../../../scripts/EditView'                ;
import { ListView_LoadTable }                          from '../../../scripts/ListView'                ;
import { UpdateAdminConfig }                           from '../../../scripts/ModuleUpdate'            ;
import { CreateSplendidRequest, GetSplendidResult }    from '../../../scripts/SplendidRequest'         ;
import { AdminProcedure }                              from '../../../scripts/ModuleUpdate'            ;
// 4. Components and Views. 
import HeaderButtonsFactory                            from '../../../ThemeComponents/HeaderButtonsFactory';

interface IAdminConfigViewProps extends RouteComponentProps<any>
{
	MODULE_NAME       : string;
	ID?               : string;
	LAYOUT_NAME?      : string;
	MODULE_TITLE?     : string;
	callback?         : Function;
	rowDefaultSearch? : any;
	onLayoutLoaded?   : Function;
	onSubmit?         : Function;
	// 04/10/2021 Paul.  Create framework to allow pre-compile of all modules. 
	isPrecompile?       : boolean;
	onComponentComplete?: (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, data) => void;
}

interface IAdminConfigViewState
{
	item              : any;
	layout            : any;
	MODULE_NAME       : string;
	EDIT_NAME         : string;
	BUTTON_NAME       : string;
	MODULE_TITLE      : string;
	DUPLICATE         : boolean;
	LAST_DATE_MODIFIED: Date;
	editedItem        : any;
	dependents        : Record<string, Array<any>>;
	error?            : any;
	SplendidVersion   : string;
	vwMain            : any;
}

@observer
class UpdaterConfigView extends React.Component<IAdminConfigViewProps, IAdminConfigViewState>
{
	private _isMounted = false;
	private refMap: Record<string, React.RefObject<EditComponent<any, any>>>;
	private headerButtons = React.createRef<HeaderButtons>();

	public get data (): any
	{
		let row: any = {};
		// 08/27/2019 Paul.  Move build code to shared object. 
		let nInvalidFields: number = SplendidDynamic_EditView.BuildDataRow(row, this.refMap);
		if ( nInvalidFields == 0 )
		{
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

	constructor(props: IAdminConfigViewProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor');
		// 02/24/2021 Paul.  This view may be hard-coded in the routes table, so we may need to pull the MODULE_NAME from the URL. 
		let MODULE_NAME: string = props.MODULE_NAME;
		if ( Sql.IsEmptyString(MODULE_NAME) )
		{
			let arrPathname: string[] = props.location.pathname.split('/');
			// 02/24/2021 Paul.  We need two passes as the React State may not be loaded and MODULES cache may be empty. 
			for ( let i: number = 0; i < arrPathname.length; i++ )
			{
				if ( i > 0 && arrPathname[i - 1].toLowerCase() == 'administration' )
				{
					MODULE_NAME = arrPathname[i];
					break;
				}
			}
			if ( SplendidCache.IsInitialized && SplendidCache.AdminMenu )
			{
				// 02/24/2021 Paul.  Start at the end and work backwards for deeper sub module. 
				for ( let i: number = arrPathname.length - 1; i >= 0; i-- )
				{
					if ( !Sql.IsEmptyString(arrPathname[i]) )
					{
						let MODULE = SplendidCache.Module(arrPathname[i], this.constructor.name + '.constructor');
						if ( MODULE != null )
						{
							MODULE_NAME = arrPathname[i];
							break;
						}
					}
				}
			}
		}

		let EDIT_NAME   : string = 'Updater.EditView';
		let BUTTON_NAME : string = 'Config.EditView';
		let MODULE_TITLE: string = L10n.Term('Administration.LBL_CONFIGURE_UPDATER');
		Credentials.SetViewMode('AdminConfigView');
		this.state =
		{
			item              : (props.rowDefaultSearch ? props.rowDefaultSearch : null),
			layout            : null,
			MODULE_NAME       ,
			EDIT_NAME         ,
			BUTTON_NAME       ,
			MODULE_TITLE      ,
			DUPLICATE         : false,
			LAST_DATE_MODIFIED: null,
			editedItem        : null,
			dependents        : {},
			error             : null,
			SplendidVersion   : null,
			vwMain            : null,
		};
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidMount()
	{
		const { MODULE_NAME, EDIT_NAME } = this.state;
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
				// 11/01/2019 Paul.  If the admin menu was not loaded, then we need to re-check the buttons. 
				// 08/17/2021 Paul.  Buttons still missing when reload browser, so always correct buttons. 
				let BUTTON_NAME: string = MODULE_NAME + '.ConfigView';
				let layoutButtons = SplendidCache.DynamicButtons(BUTTON_NAME);
				if ( layoutButtons == null )
				{
					// 02/24/2021 Paul.  Neither may exist if React State has not been loaded, so only fallback if found. 
					if ( SplendidCache.DynamicButtons(MODULE_NAME + '.EditView') )
						BUTTON_NAME = MODULE_NAME + '.EditView';
				}
				if ( BUTTON_NAME != this.state.BUTTON_NAME )
				{
					this.setState({ BUTTON_NAME })
				}
				if ( !Credentials.ADMIN_MODE )
				{
					Credentials.SetADMIN_MODE(true);
				}
				document.title = L10n.Term('Administration.LBL_CONFIGURE_UPDATER');
				window.scroll(0, 0);
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

	async componentDidUpdate(prevProps: IAdminConfigViewProps)
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
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onComponentComplete ' + DETAIL_NAME, item);
				if ( layout != null && error == null )
				{
					if ( item != null )
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
		const { rowDefaultSearch } = this.props;
		const { MODULE_NAME, EDIT_NAME } = this.state;
		try
		{
			const layout = EditView_LoadLayout(EDIT_NAME);
			if ( this._isMounted )
			{
				// 06/19/2018 Paul.  Always clear the item when setting the layout. 
				this.setState(
				{
					layout: layout,
					item: (rowDefaultSearch ? rowDefaultSearch : null),
					editedItem: null
				}, () =>
				{
					if ( this.props.onLayoutLoaded )
					{
						this.props.onLayoutLoaded();
					}
				});
				await this.LoadItem(layout);
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.load', error);
			this.setState({ error });
		}
	}

	private EditViewFields = (layout: any) =>
	{
		var arrSelectFields = new Array();
		if ( layout != null && layout.length > 0 )
		{
			for ( let nLayoutIndex = 0; nLayoutIndex < layout.length; nLayoutIndex++ )
			{
				var lay = layout[nLayoutIndex];
				// 04/15/2021 Paul.  Ignore non-data field types, such as Header. 
				if ( lay.DATA_FIELD != null )
				{
					let DATA_FIELD = lay.DATA_FIELD;
					arrSelectFields.push('\'' + DATA_FIELD + '\'');
				}
			}
		}
		return arrSelectFields.join(',');
	}

	private LoadItem = async (layout: any) =>
	{
		try
		{
			let sFILTER = 'NAME in (' + this.EditViewFields(layout) + ')';
			let rows = await ListView_LoadTable('CONFIG', 'NAME', 'asc', 'NAME,VALUE', sFILTER, null, true);
			let item = {};
			if ( rows.results )
			{
				for ( let i = 0; i < rows.results.length; i++ )
				{
					let row = rows.results[i];
					item[row.NAME] = row.VALUE;
				}
			}
			sFILTER = 'JOB = \'function::CheckVersion\'';
			rows = await ListView_LoadTable('SCHEDULERS', 'JOB', 'asc', 'JOB,STATUS', sFILTER, null, true);
			if ( rows.results )
			{
				if ( rows.results.length > 0 )
				{
					let row = rows.results[0];
					item['check_for_updates'] = (row['STATUS'] == 'Active');
				}
			}
			let SplendidVersion: string = await Version();
			if ( this._isMounted )
			{
				this.setState({ item, SplendidVersion });
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.LoadItem', error);
			this.setState({ error });
		}
	}

	private _onChange = (DATA_FIELD: string, DATA_VALUE: any, DISPLAY_FIELD?: string, DISPLAY_VALUE?: any): void =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onChange()' + DATA_FIELD, DATA_VALUE);
		let item = this.state.editedItem;
		if ( item == null )
			item = {};
		item[DATA_FIELD] = DATA_VALUE;
		this.setState({ editedItem: item });
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
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onUpdate()' + PARENT_FIELD, DATA_VALUE);
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
		const { history } = this.props;
		const { MODULE_NAME } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, sCommandArguments, this.refMap)
		// This sets the local state, which is then passed to DynamicButtons
		try
		{
			let row;
			switch (sCommandName)
			{
				case 'Save':
				{
					row = {};
					// 08/27/2019 Paul.  Keep the old to handle password issues. 
					//let nInvalidFields: number = SplendidDynamic_EditView.BuildDataRow(row, this.refMap);
					Object.keys(this.refMap).map((key) =>
					{
						let ref = this.refMap[key];
						let data = ref.current.data;
						// 07/05/2019 Paul.  Data may be an array of key/value pairs.  This is true of TeamSelect and UserSelect. 
						if ( data )
						{
							if ( Array.isArray(data) )
							{
								for ( let i = 0; i < data.length; i++  )
								{
									if ( data[i].key )
									{
										row[data[i].key] = data[i].value;
									}
								}
							}
							else if ( data.key )
							{
								// 04/08/2019 Paul.  Password fields that have not been modified will not be sent. 
								if ( data.value != Sql.sEMPTY_PASSWORD )
								{
									row[data.key] = data.value;
								}
								if ( data.files && Array.isArray(data.files) )
								{
									if ( row.Files === undefined )
									{
										row.Files = new Array();
									}
									for ( let i = 0; i < data.files.length; i++ )
									{
										row.Files.push(data.files[i]);
									}
								}
							}
						}
					});
					try
					{
						let CHECK_UPDATES: boolean = Sql.ToBoolean(row['check_for_updates']);
						delete row['check_for_updates'];
						if ( this.headerButtons.current != null )
						{
							this.headerButtons.current.Busy();
						}
						await UpdateAdminConfig(row);
						
						let data: any =
						{
							JOB   : 'function::CheckVersion',
							STATUS: (CHECK_UPDATES ? 'Active' : 'Inactive'),
						};
						let d: any = await AdminProcedure('spSCHEDULERS_UpdateStatus', data);
						
						history.push(`/Reset/Administration`);
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
							this.setState({ error });
						}
					}
					break;
				}
				case 'Cancel':
				{
					history.push(`/Reset/Administration`);
					break;
				}
				case 'Test':
				{
					let sBody: string = JSON.stringify(this.data);
					CreateSplendidRequest('Administration/' + MODULE_NAME + '/Rest.svc/Test', 'POST', 'application/octet-stream', sBody).then((res) =>
					{
						GetSplendidResult(res).then((json) =>
						{
							//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.AdminTest', json);
							this.setState( {error: json.d} );
						})
						.catch((error) =>
						{
							this.setState({ error });
						});
					})
					.catch((error) =>
					{
						this.setState({ error });
					});
					break;
				}
				default:
				{
					this.setState( {error: 'Unknown command: ' + sCommandName} );
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

	private _onCheckNow = async () =>
	{
		try
		{
			let row: any = {};
			Object.keys(this.refMap).map((key) =>
			{
				let ref = this.refMap[key];
				let data = ref.current.data;
				if ( data && data.key )
				{
					row[data.key] = data.value;
				}
			});
			let res = await CreateSplendidRequest('Administration/Rest.svc/CheckVersion?CHECK_UPDATES=' + Sql.ToBoolean(row['check_for_updates']), 'GET');
			let json = await GetSplendidResult(res);
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.CheckNow', json);
			if ( json.d && json.d.results )
			{
				this.setState({ vwMain: json.d.results });
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.CheckNow', error);
			this.setState({ error });
		}
	}

	public render()
	{
		const { callback } = this.props;
		const { item, layout, MODULE_NAME, EDIT_NAME, BUTTON_NAME, MODULE_TITLE, error, SplendidVersion, vwMain } = this.state;
		// 05/04/2019 Paul.  Reference obserable IsInitialized so that terminology update will cause refresh. 
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render: ' + EDIT_NAME + ' ' + BUTTON_NAME, layout, item);
		if ( layout == null || item == null )
		{
			return null;
		}
		this.refMap = {};
		let onSubmit = (this.props.onSubmit ? this._onSubmit : null);
		if ( SplendidCache.IsInitialized && SplendidCache.AdminMenu && layout && BUTTON_NAME )
		{
			// 12/04/2019 Paul.  After authentication, we need to make sure that the app gets updated. 
			Credentials.sUSER_THEME;
			let headerButtons = HeaderButtonsFactory(SplendidCache.UserTheme);
			return (
			<div>
				{ !callback && headerButtons
				? React.createElement(headerButtons, { MODULE_NAME, MODULE_TITLE, error, showRequired: true, enableHelp: true, helpName: 'EditView', ButtonStyle: 'EditHeader', VIEW_NAME: BUTTON_NAME, row: item, Page_Command: this.Page_Command, showButtons: true, history: this.props.history, location: this.props.location, match: this.props.match, ref: this.headerButtons })
				: null
				}
				<div id={!!callback ? null : "content"}>
					<br />
					<h4>{ L10n.Term("Administration.LBL_SPLENDIDCRM_UPDATE_TITLE") }</h4>
					{ SplendidDynamic_EditView.AppendEditViewFields(item, layout, this.refMap, callback, this._createDependency, null, this._onChange, this._onUpdate, onSubmit, 'tabForm', this.Page_Command) }
					<table cellPadding={ 4 } style={ {border: 'none'} }>
						<tr>
							<td className="dataField">
								<input type="submit" value={ "  " + L10n.Term("Administration.LBL_CHECK_NOW_LABEL") + "  "} title="Check Now" className="buttonOn" onClick={ this._onCheckNow } />
								&nbsp;&nbsp;
								<b>Version { SplendidVersion }</b>
							</td>
						</tr>
					</table>
					<br />
					{ vwMain && vwMain.length == 0
					? <h4>{ L10n.Term('Administration.LBL_UPTODATE') }</h4>
					: null
					}
					{ vwMain && vwMain.length > 0
					? <table className="listView" cellSpacing={ 1 } cellPadding={ 3 } id="grdMain" style={ {width: '100%', border: 'none'} }>
						<tr className="listViewThS1">
							<td style={ {whiteSpace: 'nowrap'} }>Build</td>
							<td style={ {whiteSpace: 'nowrap'} }>Date</td>
							<td style={ {whiteSpace: 'nowrap'} }>Description</td>
							<td style={ {whiteSpace: 'nowrap'} }>&nbsp;</td>
						</tr>
						{ vwMain.map((item, index) => 
							{
							return (
								<tr className={ index % 2 ? 'evenListRowS1' : 'oddListRowS1' }>
									<td style={ {width: '15%', whiteSpace: 'nowrap'} }>{ item['Build'] }</td>
									<td style={ {width: '15%', whiteSpace: 'nowrap'} }>{ item['Data' ] }</td>
									<td style={ {width: '60%'} }>{ item['Description'] }</td>
									<td style={ {width: '1%'} }>
										<a href={ item['URL'] } target='SplendidCRMDownloadLatestBuild' style={ {display: 'inline-block', borderWidth: '0px', height: '16px', width: '16px'} }>
											<FontAwesomeIcon icon="save" size="lg" />
										</a>
									</td>
								</tr>
								);
							})
						}
					</table>
					: null
					}
				</div>
			</div>
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

export default withRouter(UpdaterConfigView);

