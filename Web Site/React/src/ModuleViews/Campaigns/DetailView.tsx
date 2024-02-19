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
import { RouteComponentProps, withRouter }            from '../Router5'                        ;
import { observer }                                   from 'mobx-react'                              ;
import { FontAwesomeIcon }                            from '@fortawesome/react-fontawesome'          ;
// 2. Store and Types. 
import { IDetailViewProps, DetailComponent }          from '../../types/DetailComponent'             ;
import { HeaderButtons }                              from '../../types/HeaderButtons'               ;
// 3. Scripts. 
import Sql                                            from '../../scripts/Sql'                       ;
import L10n                                           from '../../scripts/L10n'                      ;
import Credentials                                    from '../../scripts/Credentials'               ;
import SplendidCache                                  from '../../scripts/SplendidCache'             ;
import { DeleteModuleItem }                           from '../../scripts/ModuleUpdate'              ;
import SplendidDynamic_DetailView                     from '../../scripts/SplendidDynamic_DetailView';
import { Crm_Config }                                 from '../../scripts/Crm'                       ;
import { AuthenticatedMethod, LoginRedirect }         from '../../scripts/Login'                     ;
import { DetailView_LoadItem, DetailView_LoadLayout, DetailView_ActivateTab } from '../../scripts/DetailView'                ;
import { CreateSplendidRequest, GetSplendidResult }   from '../../scripts/SplendidRequest'           ;
// 4. Components and Views. 
import ErrorComponent                                 from '../../components/ErrorComponent'         ;
import DumpSQL                                        from '../../components/DumpSQL'                ;
import DetailViewRelationships                        from '../../views/DetailViewRelationships'     ;
import AuditView                                      from '../../views/AuditView'                   ;
import HeaderButtonsFactory                           from '../../ThemeComponents/HeaderButtonsFactory';
// 04/13/2022 Paul.  Add LayoutTabs to Pacific theme. 
import LayoutTabs                                     from '../../components/LayoutTabs'             ;

const MODULE_NAME: string = 'Campaigns';
const LAYOUT_NAME: string = 'DetailView';

interface IDetailViewState
{
	__total         : number;
	__sql           : string;
	item            : any;
	layout          : any;
	DETAIL_NAME     : string;
	SUB_TITLE       : any;
	auditOpen       : any;
	error           : any;
}

@observer
class CampaignDetailView extends React.Component<IDetailViewProps, IDetailViewState>
{
	private _isMounted     : boolean = false;
	private refMap         : Record<string, React.RefObject<DetailComponent<any, any>>>;
	private auditView        = React.createRef<AuditView>();
	private headerButtons    = React.createRef<HeaderButtons>();

	constructor(props: IDetailViewProps)
	{
		super(props);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor');
		let archiveView: boolean = false;
		if ( props.location.pathname.indexOf('/ArchiveView') >= 0 )
		{
			archiveView = true;
		}
		let sDETAIL_NAME = MODULE_NAME + '.' + LAYOUT_NAME;
		this.state =
		{
			__total         : 0,
			__sql           : null,
			item            : null,
			layout          : null,
			DETAIL_NAME     : sDETAIL_NAME,
			SUB_TITLE         : null,
			auditOpen       : false,
			error           : null,
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
				if ( this._isMounted )
				{
					this.setState({ layout: layout, item: null });
					await this.LoadItem(MODULE_NAME, ID);
				}
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
			// 11/19/2019 Paul.  Change to allow return of SQL. 
			const d = await DetailView_LoadItem(sMODULE_NAME, sID, false, false);
			if ( this._isMounted )
			{
				let item: any = d.results;
				Sql.SetPageTitle(sMODULE_NAME, item, 'NAME');
				let SUB_TITLE: any = Sql.DataPrivacyErasedField(item, 'NAME');
				this.setState({ item, SUB_TITLE, __sql: d.__sql });
				// 04/29/2019 Paul.  Manually add to the list so that we do not need to request an update. 
				if ( item != null )
				{
					let sNAME = Sql.ToString(item['NAME']);
					if ( !Sql.IsEmptyString(sNAME) )
					{
						SplendidCache.AddLastViewed(sMODULE_NAME, sID, sNAME);
					}
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
				history.push(`/Reset/${MODULE_NAME}/Edit/${ID}`);
				break;
			}
			case 'Duplicate':
			{
				history.push(`/Reset/${MODULE_NAME}/Duplicate/${ID}`);
				break;
			}
			case 'Cancel':
			{
				history.push(`/Reset/${MODULE_NAME}/List`);
				break;
			}
			case 'Delete':
			{
				try
				{
					await DeleteModuleItem(MODULE_NAME, ID);
					history.push(`/Reset/${MODULE_NAME}/List`);
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
			case 'SendTest':
			{
				try
				{
					let res = await CreateSplendidRequest('Campaigns/Rest.svc/SendTest?ID=' + ID, 'POST', 'application/octet-stream', null);
					let json = await GetSplendidResult(res);
					//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, json);
					this.setState({ error: json.d });
				}
				catch(error)
				{
					console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, error);
					this.setState({ error });
				}
				break;
			}
			case 'SendEmail':
			{
				try
				{
					let res = await CreateSplendidRequest('Campaigns/Rest.svc/SendEmail?ID=' + ID, 'POST', 'application/octet-stream', null);
					let json = await GetSplendidResult(res);
					//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, json);
					this.setState({ error: json.d });
				}
				catch(error)
				{
					console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, error);
					this.setState({ error });
				}
				break;
			}
			case 'GenerateCalls':
			{
				try
				{
					let res = await CreateSplendidRequest('Campaigns/Rest.svc/GenerateCalls?ID=' + ID, 'POST', 'application/octet-stream', null);
					let json = await GetSplendidResult(res);
					//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, json);
					this.setState({ error: json.d });
				}
				catch(error)
				{
					console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, error);
					this.setState({ error });
				}
				break;
			}
			case 'MailMerge':
			{
				try
				{
					// 08/17/2022 Paul.  chkMain is not the correct way to pass ID. 
					history.push(`/Reset/MailMerge/Campaigns/` + ID);
				}
				catch(error)
				{
					console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, error);
					this.setState({ error });
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

	private _onButtonsLoaded = async () =>
	{
		const { item } = this.state;
		// 08/12/2019 Paul.  Here is where we can disable buttons immediately after they were loaded. 
		if ( this.headerButtons.current != null )
		{
			if ( item )
			{
				let sCAMPAIGN_TYPE: string = item['CAMPAIGN_TYPE'];
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onButtonsLoaded', sCAMPAIGN_TYPE);
				// 01/10/2010 Paul.  MailMerge is not supported at this time. 
				// 05/17/2011 Paul.  Enable support for Mail Merge. 
				this.headerButtons.current.ShowButton('SendTest'  , sCAMPAIGN_TYPE == 'Email');
				// 08/28/2012 Paul.  The correct button name is SendEmail, not SendEmails. 
				this.headerButtons.current.ShowButton('SendEmail' , sCAMPAIGN_TYPE == 'Email');
				this.headerButtons.current.ShowButton('MailMerge' , sCAMPAIGN_TYPE == 'Mail' || sCAMPAIGN_TYPE == 'NewsLetter');
				// 08/28/2012 Paul.  Add CallMarketing modules. 
				this.headerButtons.current.ShowButton('GenerateCalls', sCAMPAIGN_TYPE == 'Telesales');
			}
		}
	}

	// 04/13/2022 Paul.  Add LayoutTabs to Pacific theme. 
	private _onTabChange = (nActiveTabIndex) =>
	{
		let { layout } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onTabChange', nActiveTabIndex);
		DetailView_ActivateTab(layout, nActiveTabIndex);
		this.setState({ layout });
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
		if ( SplendidCache.IsInitialized && layout && item )
		{
			// 12/04/2019 Paul.  After authentication, we need to make sure that the app gets updated. 
			Credentials.sUSER_THEME;
			let headerButtons = HeaderButtonsFactory(SplendidCache.UserTheme);
			// 04/13/2022 Paul.  Add LayoutTabs to Pacific theme. 
			return (
			<React.Fragment>
				<AuditView
					isOpen={ auditOpen }
					callback={ this._onAuditClose }
					MODULE_NAME={ MODULE_NAME }
					NAME={ item.NAME }
					ID={ ID }
					ref={ this.auditView }
				/>
				{ headerButtons
				? React.createElement(headerButtons, { MODULE_NAME, ID, SUB_TITLE, enableFavorites: true, error, enableHelp: true, helpName: 'DetailView', ButtonStyle: 'ModuleHeader', VIEW_NAME: DETAIL_NAME, LINK_NAME: MODULE_NAME + '.LinkView', row: item, Page_Command: this.Page_Command, showButtons: true, showProcess: true, onLayoutLoaded: this._onButtonsLoaded, history: this.props.history, location: this.props.location, match: this.props.match, ref: this.headerButtons })
				: null
				}
				<DumpSQL SQL={ __sql } />
				<LayoutTabs layout={ layout } onTabChange={ this._onTabChange } />
				<div id='content'>
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
				<FontAwesomeIcon icon='spinner' spin={ true } size='5x' />
			</div>);
		}
	}
}

export default withRouter(CampaignDetailView);
