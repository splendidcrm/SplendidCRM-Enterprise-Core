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
import { RouteComponentProps, withRouter }            from '../Router5'                     ;
import { observer }                                   from 'mobx-react'                           ;
import { FontAwesomeIcon }                            from '@fortawesome/react-fontawesome'       ;
// 2. Store and Types. 
import { DetailComponent, IDetailViewProps }          from '../../../../types/DetailComponent'             ;
import { HeaderButtons }                              from '../../../../types/HeaderButtons'               ;
// 3. Scripts. 
import Sql                                            from '../../../../scripts/Sql'                       ;
import L10n                                           from '../../../../scripts/L10n'                      ;
import Security                                       from '../../../../scripts/Security'                  ;
import Credentials                                    from '../../../../scripts/Credentials'               ;
import SplendidCache                                  from '../../../../scripts/SplendidCache'             ;
import SplendidDynamic_DetailView                     from '../../../../scripts/SplendidDynamic_DetailView';
import { Crm_Config }                                 from '../../../../scripts/Crm'                       ;
import { DeleteModuleItem }                           from '../../../../scripts/ModuleUpdate'              ;
import { jsonReactState }                             from '../../../../scripts/Application'               ;
import { Admin_GetReactState }                        from '../../../../scripts/Application'               ;
import { AuthenticatedMethod, LoginRedirect }         from '../../../../scripts/Login'                     ;
import { DetailView_LoadLayout }                      from '../../../../scripts/DetailView'                ;
import { CreateSplendidRequest, GetSplendidResult }   from '../../../../scripts/SplendidRequest'           ;
// 4. Components and Views. 
import ErrorComponent                                 from '../../../../components/ErrorComponent'         ;
import DumpSQL                                        from '../../../../components/DumpSQL'                ;
import DetailViewRelationships                        from '../../../../views/DetailViewRelationships'     ;
import AuditView                                      from '../../../../views/AuditView'                   ;
import HeaderButtonsFactory                           from '../../../../ThemeComponents/HeaderButtonsFactory';

const MODULE_NAME: string = 'AuthorizeNet';

interface IAdminDetailViewState
{
	__total         : number;
	__sql           : string;
	item            : any;
	layout          : any;
	DETAIL_NAME     : string;
	SUB_TITLE       : any;
	auditOpen       : boolean;
	error           : any;
}

@observer
class AuthorizeNetDetailView extends React.Component<IDetailViewProps, IAdminDetailViewState>
{
	private _isMounted     : boolean = false;
	private refMap         : Record<string, React.RefObject<DetailComponent<any, any>>>;
	private auditView      = React.createRef<AuditView>();
	private headerButtons  = React.createRef<HeaderButtons>();

	constructor(props: IDetailViewProps)
	{
		super(props);
		let sDETAIL_NAME = MODULE_NAME + '.CustomerProfiles.DetailView';
		this.state =
		{
			__total       : 0,
			__sql         : null,
			item          : null,
			layout        : null,
			DETAIL_NAME   : sDETAIL_NAME,
			SUB_TITLE     : null,
			auditOpen     : false,
			error         : null,
		};
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidMount()
	{
		this._isMounted = true;
		try
		{
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
			if ( status == 1 )
			{
				// 07/06/2020 Paul.  Admin_GetReactState will also generate an exception, but catch anyway. 
				if ( !(Security.IS_ADMIN() || SplendidCache.AdminUserAccess(MODULE_NAME, 'view') >= 0) )
				{
					throw(L10n.Term('.LBL_INSUFFICIENT_ACCESS'));
				}
				// 10/27/2019 Paul.  In case of single page refresh, we need to make sure that the AdminMenu has been loaded. 
				if ( SplendidCache.AdminMenu == null )
				{
					await Admin_GetReactState(this.constructor.name + '.componentDidMount');
				}
				if ( jsonReactState == null )
				{
					//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount jsonReactState is null');
				}
				this._isMounted = true;
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

	async componentDidUpdate(prevProps: IDetailViewProps)
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
				const { ID } = this.props;
				const { item, layout, DETAIL_NAME, error } = this.state;
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onComponentComplete ' + DETAIL_NAME, item);
				if ( layout != null && error == null )
				{
					if ( item != null && this._areRelationshipsComplete )
					{
						this.props.onComponentComplete(MODULE_NAME, null, DETAIL_NAME, item);
					}
				}
			}
		}
	}

	private _areRelationshipsComplete: boolean = false;

	
	private onRelationshipsComplete = (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, vwMain): void =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.onRelationshipsComplete ' + LAYOUT_NAME, vwMain);
		this._areRelationshipsComplete = true;
		if ( this.props.onComponentComplete )
		{
			const { MODULE_NAME, ID } = this.props;
			const { item, layout, DETAIL_NAME, error } = this.state;
			if ( layout != null && error == null )
			{
				if ( item != null && this._areRelationshipsComplete )
				{
					this.props.onComponentComplete(MODULE_NAME, null, DETAIL_NAME, item);
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
		const { ID } = this.props;
		const { DETAIL_NAME } = this.state;
		try
		{
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.load');
			if ( status == 1 )
			{
				const layout = DetailView_LoadLayout(DETAIL_NAME);
				// 06/19/2018 Paul.  Always clear the item when setting the layout. 
				this.setState({ layout: layout, item: null });
				await this.LoadItem(MODULE_NAME, ID);
			}
			else
			{
				LoginRedirect(this.props.history, this.constructor.name + '.componentDidMount');
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
		try
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.LoadItem ' + sMODULE_NAME + ' ' + sID);
			let res = await CreateSplendidRequest('Administration/AuthorizeNet/Rest.svc/GetCustomerProfile?ID=' + sID, 'GET');
			let json = await GetSplendidResult(res);
			json.d.__total = json.__total;
			json.d.__sql = json.__sql;
			let d: any = json.d;
			if ( this._isMounted )
			{
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.LoadItem', row);
				let item: any = d.results;
				Sql.SetPageTitle(sMODULE_NAME, item, 'NAME');
				let SUB_TITLE: any = Sql.DataPrivacyErasedField(item, 'NAME');
				this.setState({ item, SUB_TITLE, __sql: d.__sql });
				// 04/29/2019 Paul.  Manually add to the list so that we do not need to request an update. 
				if ( item != null )
				{
					let sNAME = Sql.ToString(item['NAME']);
					if ( !Sql.IsEmptyString(sNAME) )
						SplendidCache.AddLastViewed(sMODULE_NAME, sID, sNAME);
				}
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.LoadItem', error);
			this.setState({ error });
		}
	}

	private Page_Command = async (sCommandName, sCommandArguments) =>
	{
		const { ID, history } = this.props;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, sCommandArguments);
		switch ( sCommandName )
		{
			case 'Edit':
			{
				history.push(`/Reset/Administration/${MODULE_NAME}/CustomerProfiles/Edit/${ID}`);
				break;
			}
			case 'Duplicate':
			{
				history.push(`/Reset/Administration/${MODULE_NAME}/CustomerProfiles/Duplicate/${ID}`);
				break;
			}
			case 'Cancel':
			{
				history.push(`/Reset/Administration/${MODULE_NAME}/CustomerProfiles/List`);
				break;
			}
			case 'Delete':
			{
				try
				{
					// 11/23/2020 Paul.  Set admin flag. 
					await DeleteModuleItem(MODULE_NAME, ID, true);
					history.push(`/Reset/Administration/${MODULE_NAME}/CustomerProfiles/List`);
				}
				catch(error)
				{
					console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, error);
					this.setState({ error });
				}
				break;
			}
			case 'ViewLog':
			{
				if ( this.auditView.current != null )
				{
					await this.auditView.current.loadData();
					this.setState({ auditOpen: true });
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
	}

	private _onAuditClose = () =>
	{
		this.setState({ auditOpen: false });
	}

	public render()
	{
		const { ID } = this.props;
		const { item, layout, DETAIL_NAME, SUB_TITLE, auditOpen, error } = this.state;
		const { __total, __sql } = this.state;
		// 05/04/2019 Paul.  Reference obserable IsInitialized so that terminology update will cause refresh. 
		// 05/15/2018 Paul.  Defer process button logic. 
		// 06/26/2019 Paul.  Specify a key so that SplendidGrid will get componentDidMount when changing views. 
		this.refMap = {};
		if ( SplendidCache.IsInitialized && SplendidCache.AdminMenu && layout && item )
		{
			// 12/04/2019 Paul.  After authentication, we need to make sure that the app gets updated. 
			Credentials.sUSER_THEME;
			let headerButtons = HeaderButtonsFactory(SplendidCache.UserTheme);
			// 11/23/2020 Paul.  Only a few admin tables are audited. 
			// 01/05/2021 Paul.  Teams module is audited. 
			return (
			<React.Fragment>
				{ (MODULE_NAME == 'Contracts' || MODULE_NAME == 'ProductTemplates' || MODULE_NAME == 'Contracts' || MODULE_NAME == 'Users' || MODULE_NAME == 'Teams')
				? <AuditView
					isOpen={ auditOpen }
					callback={ this._onAuditClose }
					MODULE_NAME={ MODULE_NAME }
					NAME={ item.NAME }
					ID={ ID }
					ref={ this.auditView }
				/>
				: null
				}
				{ headerButtons
				? React.createElement(headerButtons, { MODULE_NAME, ID, SUB_TITLE, enableFavorites: true, error, enableHelp: true, helpName: 'DetailView', ButtonStyle: 'ModuleHeader', VIEW_NAME: DETAIL_NAME, row: item, Page_Command: this.Page_Command, showButtons: true, history: this.props.history, location: this.props.location, match: this.props.match, ref: this.headerButtons, showProcess: false })
				: null
				}
				<DumpSQL SQL={ __sql } />
				<div id="content">
					{ SplendidDynamic_DetailView.AppendDetailViewFields(item, layout, this.refMap, 'tabDetailView', null, this.Page_Command) }
					<br />
					<DetailViewRelationships key={ MODULE_NAME + '_DetailViewRelationships' } PARENT_TYPE={ MODULE_NAME } DETAIL_NAME={ DETAIL_NAME } row={ item } isPrecompile={ this.props.isPrecompile } onComponentComplete={ this.onRelationshipsComplete } />
				</div>
			</React.Fragment>
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

export default withRouter(AuthorizeNetDetailView);
