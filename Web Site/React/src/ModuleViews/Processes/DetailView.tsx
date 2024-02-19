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
import ACL_ACCESS                                     from '../../types/ACL_ACCESS'                  ;
import { HeaderButtons }                              from '../../types/HeaderButtons'               ;
// 3. Scripts. 
import Sql                                            from '../../scripts/Sql'                       ;
import L10n                                           from '../../scripts/L10n'                      ;
import Security                                       from '../../scripts/Security'                  ;
import Credentials                                    from '../../scripts/Credentials'               ;
import SplendidCache                                  from '../../scripts/SplendidCache'             ;
import SplendidDynamic_DetailView                     from '../../scripts/SplendidDynamic_DetailView';
import { Crm_Config, Crm_Modules }                    from '../../scripts/Crm'                       ;
import { AuthenticatedMethod, LoginRedirect }         from '../../scripts/Login'                     ;
import { sPLATFORM_LAYOUT }                           from '../../scripts/SplendidInitUI'            ;
import { DetailView_LoadLayout }                      from '../../scripts/DetailView'                ;
import { ProcessButtons_LoadItem }                    from '../../scripts/ProcessButtons'            ;
import { jsonReactState }                             from '../../scripts/Application'               ;
// 4. Components and Views. 
import ErrorComponent                                 from '../../components/ErrorComponent'         ;
import DumpSQL                                        from '../../components/DumpSQL'                ;
import AuditView                                      from '../../views/AuditView'                   ;
import ActivitiesPopupView                            from '../../views/ActivitiesPopupView'         ;
import HeaderButtonsFactory                           from '../../ThemeComponents/HeaderButtonsFactory';

interface IDetailViewState
{
	__total         : number;
	__sql           : string;
	item            : any;
	layout          : any;
	summaryLayout   : any;
	MODULE_NAME     : string;  // 03/01/2019 Paul.  Parents module will be converted to actual module. 
	DETAIL_NAME     : string;
	SUB_TITLE       : any;
	auditOpen       : boolean;
	activitiesOpen  : boolean;
	error           : any;
}

@observer
class ProcessesDetailView extends React.Component<IDetailViewProps, IDetailViewState>
{
	private _isMounted     : boolean = false;
	private refMap         : Record<string, React.RefObject<DetailComponent<any, any>>>;
	private auditView      = React.createRef<AuditView>();
	private activitiesView = React.createRef<ActivitiesPopupView>();
	private headerButtons  = React.createRef<HeaderButtons>();

	constructor(props: IDetailViewProps)
	{
		super(props);
		let DETAIL_NAME: string = props.MODULE_NAME + '.DetailView' + sPLATFORM_LAYOUT;
		if ( !Sql.IsEmptyString(props.LAYOUT_NAME) )
		{
			DETAIL_NAME = props.LAYOUT_NAME;
		}
		this.state =
		{
			__total         : 0,
			__sql           : null,
			item            : null,
			layout          : null,
			summaryLayout   : null,
			MODULE_NAME     : props.MODULE_NAME,
			DETAIL_NAME     ,
			SUB_TITLE       : null,
			auditOpen       : false,
			activitiesOpen  : false,
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
				if ( jsonReactState == null )
				{
					//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount jsonReactState is null');
				}
				if ( Credentials.ADMIN_MODE )
				{
					Credentials.SetADMIN_MODE(false);
				}
				await this.preload();
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
				const { MODULE_NAME, ID } = this.props;
				const { item, layout, DETAIL_NAME, error } = this.state;
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onComponentComplete ' + DETAIL_NAME, item);
				if ( layout != null && error == null )
				{
					if ( item != null )
					{
						this.props.onComponentComplete(MODULE_NAME, null, DETAIL_NAME, item);
					}
				}
			}
		}
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}

	private preload = async () =>
	{
		const { ID } = this.props;
		const { MODULE_NAME } = this.state;
		// 01/19/2013 Paul.  A Parents module requires a lookup to get the module name. 
		try
		{
			let sMODULE_NAME = MODULE_NAME;
			await this.load(sMODULE_NAME, ID);
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.preload', error);
			this.setState({ error });
		}
	}

	private load = async (sMODULE_NAME: string, sID: string) =>
	{
		const { DETAIL_NAME } = this.state;
		try
		{
			const layout = DetailView_LoadLayout(DETAIL_NAME);
			// 06/19/2018 Paul.  Always clear the item when setting the layout. 
			if ( this._isMounted )
			{
				this.setState({ layout: layout, item: null, summaryLayout: null });
				await this.LoadItem(sMODULE_NAME, sID);
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
			const d = await ProcessButtons_LoadItem(sID);
			if ( this._isMounted )
			{
				let item: any = d.results;
				let SUB_TITLE: any = null;
				if ( item != null )
				{
					SUB_TITLE = item['PROCESS_NUMBER'];
					// 03/21/2020 Paul. They DynamicButtons code uses PENDING_PROCESS_ID to determine if ProcessButtons should be used. 
					item['PENDING_PROCESS_ID'] = item['ID'];
				}
				this.setState({ item, SUB_TITLE, __sql: d.__sql });
				if ( item != null )
				{
					let sNAME = Sql.ToString(item['PROCESS_NUMBER']);
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

	// 05/14/2018 Chase. This function will be passed to DynamicButtons to be called as Page_Command
	// Add additional params if you need access to the onClick event params.
	private Page_Command = async (sCommandName, sCommandArguments) =>
	{
		const { ID, history } = this.props;
		const { MODULE_NAME } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.Page_Command ' + sCommandName, sCommandArguments);
		switch ( sCommandName )
		{
			case 'Edit':
			{
				history.push(`/Reset/${MODULE_NAME}/Edit/${ID}`);
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

	private _onActivitiesClose = () =>
	{
		this.setState({ activitiesOpen: false });
	}

	public render()
	{
		const { ID } = this.props;
		const { item, layout, summaryLayout, MODULE_NAME, DETAIL_NAME, SUB_TITLE, auditOpen, activitiesOpen, error } = this.state;
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
				<ActivitiesPopupView
					isOpen={ activitiesOpen }
					callback={ this._onActivitiesClose }
					PARENT_TYPE={ MODULE_NAME }
					PARENT_ID={ ID }
					history={ this.props.history }
					location={ this.props.location }
					match={ this.props.match }
					ref={ this.activitiesView }
				/>
				{ headerButtons
				? React.createElement(headerButtons, { MODULE_NAME, ID, SUB_TITLE, enableFavorites: true, error, enableHelp: true, helpName: 'DetailView', ButtonStyle: 'ModuleHeader', VIEW_NAME: DETAIL_NAME, row: item, Page_Command: this.Page_Command, showButtons: true, showProcess: true, onLayoutLoaded: null, history: this.props.history, location: this.props.location, match: this.props.match, ref: this.headerButtons })
				: null
				}
				<DumpSQL SQL={ __sql } />
				<div id="content">
					{ SplendidDynamic_DetailView.AppendDetailViewFields(item, layout, this.refMap, 'tabDetailView', null, this.Page_Command) }
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

export default withRouter(ProcessesDetailView);
