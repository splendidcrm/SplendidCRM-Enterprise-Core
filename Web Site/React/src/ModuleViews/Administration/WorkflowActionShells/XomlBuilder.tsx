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
import moment from 'moment';
import * as XMLParser                                    from 'fast-xml-parser'                     ;
import DateTime                                          from 'react-datetime'                      ;
import 'react-datetime/css/react-datetime.css';
// 2. Store and Types. 
// 3. Scripts. 
import Sql                                               from '../../../scripts/Sql'                ;
import L10n                                              from '../../../scripts/L10n'               ;
import Security                                          from '../../../scripts/Security'           ;
import Credentials                                       from '../../../scripts/Credentials'        ;
import SplendidCache                                     from '../../../scripts/SplendidCache'      ;
import { formatDate, FromJsonDate }                      from '../../../scripts/Formatting'         ;
import { Crm_Config, Crm_Modules }                       from '../../../scripts/Crm'                ;
import { dumpObj, uuidFast, Trim, StartsWith, EndsWith } from '../../../scripts/utility'            ;
import { CreateSplendidRequest, GetSplendidResult }      from '../../../scripts/SplendidRequest'    ;
import { ValidateDateParts }                             from '../../../scripts/utility'            ;
import { EditView_LoadLayout, EditView_FindField }       from '../../../scripts/EditView'           ;
// 4. Components and Views. 
import ErrorComponent                                    from '../../../components/ErrorComponent'  ;
import DynamicPopupView                                  from '../../../views/DynamicPopupView'     ;
import DumpXOML                                          from '../../../components/DumpXOML'        ;

let bDebug: boolean = false;

interface IXomlBuilderProps
{
	row                         : any         ;
	DATA_FIELD                  : string      ;
	PARENT_ID                   : string      ;
	onChanged                   : (DATA_FIELD: string, DATA_VALUE: any, DISPLAY_FIELD?: string, DISPLAY_VALUE?: any) => void;
	bReportDesignerWorkflowMode?: boolean     ;
	Modules?                    : string      ;
	UseSQLParameters?           : boolean     ;
	UserSpecific?               : boolean     ;
	PrimaryKeyOnly?             : boolean     ;
	DesignChart?                : boolean     ;
	DesignWorkflow?             : boolean     ;
	ShowRelated?                : boolean     ;
	ShowModule?                 : boolean     ;
	DisplayColumns?             : string[]    ;
	onComponentComplete?        : (MODULE_NAME, RELATED_MODULE, LAYOUT_NAME, vwMain) => void;
}

interface IQueryBuilderState
{
	oPreviewSQL                : string      ;
	oPreviewXOML               : string      ;
	// 07/04/2016 Paul.  Special case when not showing selected fields. 
	error?                     : any         ;
	REPORT_NAME                : string      ;
	MODULE                     : string      ;
	RELATED                    : string      ;
	SHOW_XOML                 : boolean     ;
	reportXml                  : any         ;
	reportXmlJson              : string      ;
	relatedModuleXml           : any         ;
	relatedModuleXmlJson       : any         ;
	relationshipXml            : any         ;
	relationshipXmlJson        : any         ;
	filterXml                  : any         ;
	filterXmlJson              : any         ;
	filterXmlEditIndex         : number      ;
	popupOpen                  : boolean     ;
	MODULES_LIST               : any[]       ;
	RELATED_LIST               : any[]       ;
	FILTER_COLUMN_SOURCE_LIST  : any[]       ;
	FILTER_COLUMN_LIST         : any[]       ;
	FILTER_COLUMN_LIST_NAMES   : any         ;
	FILTER_OPERATOR_LIST       : any[]       ;
	FILTER_SEARCH_LIST_NAME    : string      ;
	FILTER_SEARCH_DROPDOWN_LIST: any[]       ;
	FILTER_SEARCH_LISTBOX_LIST : any[]       ;
	FILTER_SEARCH_DROPDOWN     : string      ;
	FILTER_SEARCH_LISTBOX      : string[]    ;
	FILTER_ID                  : string      ;
	FILTER_COLUMN_SOURCE       : string      ;
	FILTER_COLUMN              : string      ;
	FILTER_OPERATOR            : string      ;
	FILTER_OPERATOR_TYPE       : string      ;
	FILTER_SEARCH_ID           : string      ;
	FILTER_SEARCH_DATA_TYPE    : string      ;
	FILTER_SEARCH_TEXT         : string      ;
	FILTER_SEARCH_TEXT2        : string      ;
	FILTER_SEARCH_START_DATE   : string      ;
	FILTER_SEARCH_END_DATE     : string      ;
	FILTER_SEARCH_MODULE_TYPE  : string      ;
	FILTER_SEARCH_MODE         : string      ;

	ACTION_TYPE_LIST           : any[]       ;
	ACTION_TYPE                : string      ;
	CUSTOM_ACTIVITY_NAME       : string      ;
	CUSTOM_COLUMN_NAME         : string      ;
}

export default class XomlBuilder extends React.Component<IXomlBuilderProps, IQueryBuilderState>
{
	private _isMounted    : boolean = false;
	private themeURL      : string;
	private DATE_FORMAT   : string;
	private FILTER_COLUMN_LIST_CACHE: any = {};

	public get data(): any
	{
		const { ACTION_TYPE, RELATED, filterXml, relatedModuleXml, relationshipXml } = this.state;
		let row: any = { ACTION_TYPE, RELATED, filterXml, relatedModuleXml, relationshipXml };
		return row;
	}

	public validate(): boolean
	{
		let bValid: boolean = true;
		return bValid;
	}

	public error(): any
	{
		return this.state.error;
	}

	constructor(props: IXomlBuilderProps)
	{
		super(props);
		this.themeURL = Credentials.RemoteServer + 'App_Themes/' + SplendidCache.UserTheme + '/';
		this.DATE_FORMAT = Security.USER_DATE_FORMAT();
		let error: any = 'Loading modules.';
		this.state =
		{
			oPreviewSQL                : null,
			oPreviewXOML               : null,
			error                      ,
			REPORT_NAME                : null,
			MODULE                     : null,
			RELATED                    : null,
			SHOW_XOML                 : Sql.ToBoolean(localStorage.getItem('XomlBuilder.SHOW_XOML')),
			reportXml                  : {},
			reportXmlJson              : null,
			relatedModuleXml           : null,
			relatedModuleXmlJson       : null,
			relationshipXml            : null,
			relationshipXmlJson        : null,
			filterXml                  : null,
			filterXmlJson              : null,
			filterXmlEditIndex         : -1,
			popupOpen                  : false,
			MODULES_LIST               : [],
			RELATED_LIST               : [],
			FILTER_COLUMN_SOURCE_LIST  : [],
			FILTER_COLUMN_LIST         : [],
			FILTER_COLUMN_LIST_NAMES   : {},
			FILTER_OPERATOR_LIST       : [],
			FILTER_SEARCH_LIST_NAME    : null,
			FILTER_SEARCH_DROPDOWN_LIST: [],
			FILTER_SEARCH_LISTBOX_LIST : [],
			FILTER_SEARCH_DROPDOWN     : null,
			FILTER_SEARCH_LISTBOX      : [],
			FILTER_ID                  : null,
			FILTER_COLUMN_SOURCE       : null,
			FILTER_COLUMN              : null,
			FILTER_OPERATOR            : null,
			FILTER_OPERATOR_TYPE       : null,
			FILTER_SEARCH_ID           : null,
			FILTER_SEARCH_DATA_TYPE    : null,
			FILTER_SEARCH_TEXT         : null,
			FILTER_SEARCH_TEXT2        : null,
			FILTER_SEARCH_START_DATE   : null,
			FILTER_SEARCH_END_DATE     : null,
			FILTER_SEARCH_MODULE_TYPE  : null,
			FILTER_SEARCH_MODE         : null,
			ACTION_TYPE_LIST           : [],
			ACTION_TYPE                : null,
			CUSTOM_ACTIVITY_NAME       : null,
			CUSTOM_COLUMN_NAME         : null,
		};
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	// As soon as the render method has been executed the componentDidMount function is called. 
	async componentDidMount()
	{
		const { row, DATA_FIELD, PARENT_ID, DisplayColumns } = this.props;
		this._isMounted = true;
		try
		{
			let options: any = 
			{
				attributeNamePrefix: ''     ,
				textNodeName       : 'Value',
				ignoreAttributes   : false  ,
				ignoreNameSpace    : true   ,
				parseAttributeValue: true   ,
				trimValues         : false  ,
			};

			let REPORT_NAME          : string  = null;
			let MODULE               : string  = (row ? row['BASE_MODULE'] : null);
			let RELATED              : string  = null;
			let reportXml            : any     = null;
			let reportXmlJson        : string  = null;
			let relatedModuleXml     : any     = null;
			let relatedModuleXmlJson : any     = null;
			let relationshipXml      : any     = null;
			let relationshipXmlJson  : any     = null;
			let filterXml            : any     = null;
			let filterXmlJson        : any     = null;
			if ( !Sql.IsEmptyString(row[DATA_FIELD]) )
			{
				reportXml     = XMLParser.parse(row[DATA_FIELD], options);
				// 05/20/2020 Paul.  A single record will not come in as an array, so convert to an array. 
				if ( reportXml.Filters && reportXml.Filters.Filter && !Array.isArray(reportXml.Filters.Filter) )
				{
					let table1: any = reportXml.Filters.Filter;
					reportXml.Filters.Filter = [];
					reportXml.Filters.Filter.push(table1);
				}
				if ( reportXml.Report && reportXml.Report.CustomProperties && Array.isArray(reportXml.Report.CustomProperties.CustomProperty) )
				{
					let arrCustomProperty: any[] = reportXml.Report.CustomProperties.CustomProperty;
					for ( let i: number = 0; i < arrCustomProperty.length; i++ )
					{
						let prop: any = arrCustomProperty[i];
						let sName : string = prop.Name;
						let sValue: string = prop.Value;
						switch ( sName )
						{
							case 'crm:ReportName'    :  REPORT_NAME      = sValue;  break;
							case 'crm:Module'        :  MODULE           = sValue;  break;
							case 'crm:Related'       :  RELATED          = sValue;  break;
							case 'crm:RelatedModules':
								// 05/15/2021 Paul.  Ignore data from file and just use latest QueryBuilderState. 
								//sValue = this.decodeHTML(sValue);
								//relatedModuleXml = XMLParser.parse(sValue, options);
								//// 05/14/2021 Paul.  If there is only one, convert to an array. 
								//if ( relatedModuleXml.Relationships && relatedModuleXml.Relationships.Relationship && !Array.isArray(relatedModuleXml.Relationships.Relationship) )
								//{
								//	let relationship1: any = relatedModuleXml.Relationships.Relationship;
								//	relatedModuleXml.Relationships.Relationship = [];
								//	relatedModuleXml.Relationships.Relationship.push(relationship1);
								//}
								//relatedModuleXmlJson = dumpObj(relatedModuleXml, 'relatedModuleXml').replace(/\n/g, '<br />\n').replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
								break;
							case 'crm:Relationships' :
								// 05/15/2021 Paul.  Ignore data from file and just use latest QueryBuilderState. 
								//sValue = this.decodeHTML(sValue);
								//relationshipXml  = XMLParser.parse(sValue, options);
								//// 05/14/2021 Paul.  If there is only one, convert to an array. 
								//if ( relationshipXml.Relationships && relationshipXml.Relationships.Relationship && !Array.isArray(relationshipXml.Relationships.Relationship) )
								//{
								//	let relationship1: any = relationshipXml.Relationships.Relationship;
								//	relationshipXml.Relationships.Relationship = [];
								//	relationshipXml.Relationships.Relationship.push(relationship1);
								//}
								//relationshipXmlJson = dumpObj(relationshipXml, 'relationshipXml').replace(/\n/g, '<br />\n').replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
								break;
							case 'crm:Filters'       :
								sValue = this.decodeHTML(sValue);
								filterXml        = XMLParser.parse(sValue, options);
								// 05/14/2021 Paul.  If there is only one, convert to an array. 
								if ( filterXml.Filters && filterXml.Filters.Filter && !Array.isArray(filterXml.Filters.Filter) )
								{
									let Filter1: any = filterXml.Filters.Filter;
									filterXml.Filters.Filter = [];
									filterXml.Filters.Filter.push(Filter1);
								}
								filterXmlJson = dumpObj(filterXml, 'filterXml').replace(/\n/g, '<br />\n').replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
								break;
						}
					}
				}
				reportXmlJson = dumpObj(reportXml, 'reportXml').replace(/\n/g, '<br />\n').replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
			}
			let ACTION_TYPE_LIST         : any[] = [];
			let ACTION_TYPE              : string = 'update';
			ACTION_TYPE_LIST.push({ NAME: 'update'          , DISPLAY_NAME: L10n.Term("WorkflowActionShells.LBL_ACTION_TYPE_UPDATE"          ).replace('{0}', L10n.ListTerm('moduleList', MODULE)) });
			ACTION_TYPE_LIST.push({ NAME: 'update_rel'      , DISPLAY_NAME: L10n.Term("WorkflowActionShells.LBL_ACTION_TYPE_UPDATE_REL"      ) });
			ACTION_TYPE_LIST.push({ NAME: 'new'             , DISPLAY_NAME: L10n.Term("WorkflowActionShells.LBL_ACTION_TYPE_NEW"             ) });
			// 11/01/2010 Paul.  Add Custom Activity Action Type. 
			// 11/07/2010 Paul.  Add Custom Method and Custom Property. 
			ACTION_TYPE_LIST.push({ NAME: 'custom_prop'     , DISPLAY_NAME: L10n.Term("WorkflowActionShells.LBL_ACTION_TYPE_CUSTOM_PROPERTY" ) });
			ACTION_TYPE_LIST.push({ NAME: 'custom_method'   , DISPLAY_NAME: L10n.Term("WorkflowActionShells.LBL_ACTION_TYPE_CUSTOM_METHOD"   ) });
			// 08/03/2012 Paul.  Add Custom Stored Procedure. 
			ACTION_TYPE_LIST.push({ NAME: 'custom_procedure', DISPLAY_NAME: L10n.Term("WorkflowActionShells.LBL_ACTION_TYPE_CUSTOM_PROCEDURE") });

			let results: any = await this.getQueryBuilderState(this.props.Modules, MODULE, null, this.constructor.name + '.componentDidMount');
			let MODULES_LIST             : any[]  = results.MODULES_LIST             ;
			let RELATED_LIST             : any[]  = results.RELATED_LIST             ;
			let FILTER_COLUMN_SOURCE_LIST: any[]  = results.FILTER_COLUMN_SOURCE_LIST;
			let FILTER_COLUMN_LIST       : any[]  = results.FILTER_COLUMN_LIST       ;
			let FILTER_COLUMN_LIST_NAMES : any    = results.FILTER_COLUMN_LIST_NAMES ;
			let sRelatedModules          : string = results.RelatedModules           ;
			let sRelationships           : string = results.Relationships            ;
			if ( !Sql.IsEmptyString(sRelatedModules) )
			{
				relatedModuleXml = XMLParser.parse(sRelatedModules, options);
				// 05/14/2021 Paul.  If there is only one, convert to an array. 
				if ( relatedModuleXml.Relationships && relatedModuleXml.Relationships.Relationship && !Array.isArray(relatedModuleXml.Relationships.Relationship) )
				{
					let relationship1: any = relatedModuleXml.Relationships.Relationship;
					relatedModuleXml.Relationships.Relationship = [];
					relatedModuleXml.Relationships.Relationship.push(relationship1);
				}
				relatedModuleXmlJson = dumpObj(relatedModuleXml, 'relatedModuleXml').replace(/\n/g, '<br />\n').replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
			}
			if ( !Sql.IsEmptyString(sRelationships) )
			{
				relationshipXml  = XMLParser.parse(sRelationships, options);
				// 05/14/2021 Paul.  If there is only one, convert to an array. 
				if ( relationshipXml.Relationships && relationshipXml.Relationships.Relationship && !Array.isArray(relationshipXml.Relationships.Relationship) )
				{
					let relationship1: any = relationshipXml.Relationships.Relationship;
					relationshipXml.Relationships.Relationship = [];
					relationshipXml.Relationships.Relationship.push(relationship1);
				}
				relationshipXmlJson = dumpObj(relationshipXml, 'relationshipXml').replace(/\n/g, '<br />\n').replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
			}

			let FILTER_COLUMN_SOURCE: string = '';
			let FILTER_COLUMN       : string = '';
			if ( FILTER_COLUMN_SOURCE_LIST != null && FILTER_COLUMN_SOURCE_LIST.length > 0 )
			{
				FILTER_COLUMN_SOURCE = FILTER_COLUMN_SOURCE_LIST[0].MODULE_NAME;
				// 05/15/2021 Paul.  Cache the FILTER_COLUMN_LIST. 
				this.FILTER_COLUMN_LIST_CACHE[FILTER_COLUMN_SOURCE] = FILTER_COLUMN_LIST;
			}
			if ( FILTER_COLUMN_LIST != null && FILTER_COLUMN_LIST.length > 0 )
			{
				FILTER_COLUMN = FILTER_COLUMN_LIST[0].NAME;
			}

			let oPreviewSQL : string = await this.getReportSQL(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml, DisplayColumns);
			// 03/04/2022 Paul.  We don't want an error during precompile. 
			let oPreviewXOML: string = null;
			if ( PARENT_ID != null )
				oPreviewXOML = await this.getWorkflowXOML(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml);
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', this.designerModules);
			this.setState(
			{
				oPreviewSQL              ,
				oPreviewXOML             ,
				error                    : null,
				REPORT_NAME              ,
				MODULE                   ,
				RELATED                  ,
				reportXml                ,
				reportXmlJson            ,
				relatedModuleXml         ,
				relatedModuleXmlJson     ,
				relationshipXml          ,
				relationshipXmlJson      ,
				filterXml                ,
				filterXmlJson            ,
				MODULES_LIST             ,
				RELATED_LIST             ,
				FILTER_COLUMN_SOURCE_LIST,
				FILTER_COLUMN_LIST       ,
				FILTER_COLUMN_LIST_NAMES ,
				FILTER_ID                : '',
				FILTER_COLUMN_SOURCE     ,
				FILTER_COLUMN            ,
				FILTER_OPERATOR          : '',
				FILTER_OPERATOR_TYPE     : '',
				FILTER_SEARCH_ID         : '',
				FILTER_SEARCH_DATA_TYPE  : '',
				FILTER_SEARCH_TEXT       : '',
				ACTION_TYPE_LIST         ,
				ACTION_TYPE              ,
				filterXmlEditIndex       : -1,
			}, () =>
			{
				this.filterColumnChanged(FILTER_COLUMN_SOURCE, FILTER_COLUMN);
				this.props.onChanged('filterXml'       , filterXml       , null, null);
				this.props.onChanged('relatedModuleXml', relatedModuleXml, null, null);
				this.props.onChanged('relationshipXml' , relationshipXml , null, null);
			});
			if ( oPreviewSQL && !Sql.IsEmptyString(oPreviewSQL) )
			{
				this.props.onChanged(this.props.DATA_FIELD, oPreviewSQL, null, null);
			}
			if ( this.props.onComponentComplete )
			{
				this.props.onComponentComplete(null, null, null, null);
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			this.setState({ error });
		}
	}

	shouldComponentUpdate(nextProps: IXomlBuilderProps, nextState: IQueryBuilderState)
	{
		if ( this.props.row != null && nextProps.row != null )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate', this.props.row, nextProps.row);
			if ( this.props.row['BASE_MODULE'] != nextProps.row['BASE_MODULE'] && nextProps.row['BASE_MODULE'] != this.state.MODULE )
			{
				let MODULE: string = nextProps.row['BASE_MODULE'];
				this.moduleChanged(nextProps.Modules, MODULE, '', true);
			}
			else if ( this.props.DesignWorkflow && this.props.row['TYPE'] != nextProps.row['TYPE'] )
			{
				let MODULE: string = nextProps.row['BASE_MODULE'];
				this.moduleChanged(nextProps.Modules, MODULE, '', true);
			}
			else if ( JSON.stringify(this.props.DisplayColumns) != JSON.stringify(nextProps.DisplayColumns) )
			{
				let { MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml } = this.state;
				this.getReportSQL(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml, nextProps.DisplayColumns).then((oPreviewSQL: string) =>
				{
					this.getWorkflowXOML(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml).then((oPreviewXOML: string) =>
					{
						this.setState(
						{
							oPreviewSQL ,
							oPreviewXOML,
						});
					});
				})
				.catch((error) =>
				{
					console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate', error);
				});
			}
		}
		return true;
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}

	private moduleChanged = async (Modules: string, MODULE: string, RELATED: string, bClearFilters: boolean) =>
	{
		const { DisplayColumns } = this.props;
		const { relatedModuleXml, relationshipXml } = this.state
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.moduleChanged ' + MODULE, RELATED);
		let { filterXml, filterXmlJson, filterXmlEditIndex } = this.state;
		try
		{
			let results: any = await this.getQueryBuilderState(Modules, MODULE, RELATED, this.constructor.name + '.moduleChanged');
			let MODULES_LIST             : any[] = results.MODULES_LIST             ;
			let RELATED_LIST             : any[] = results.RELATED_LIST             ;
			let FILTER_COLUMN_SOURCE_LIST: any[] = results.FILTER_COLUMN_SOURCE_LIST;
			let FILTER_COLUMN_LIST       : any[] = results.FILTER_COLUMN_LIST       ;
			let FILTER_COLUMN_SOURCE     : string = null;
			let FILTER_COLUMN            : string = null;
			if ( FILTER_COLUMN_SOURCE_LIST != null && FILTER_COLUMN_SOURCE_LIST.length > 0 )
			{
				FILTER_COLUMN_SOURCE = FILTER_COLUMN_SOURCE_LIST[0].MODULE_NAME;
				// 05/15/2021 Paul.  Cache the FILTER_COLUMN_LIST. 
				this.FILTER_COLUMN_LIST_CACHE[FILTER_COLUMN_SOURCE] = FILTER_COLUMN_LIST;
			}
			// 06/04/2021 Paul.  Must update column when list changes. 
			if ( FILTER_COLUMN_LIST != null && FILTER_COLUMN_LIST.length > 0 )
			{
				FILTER_COLUMN = FILTER_COLUMN_LIST[0].NAME;
			}
			if ( bClearFilters )
			{
				filterXml          = null;
				filterXmlJson      = '';
				filterXmlEditIndex = -1;
			}
			// 05/15/2021 Paul.  Cache the FILTER_COLUMN_LIST. 
			this.FILTER_COLUMN_LIST_CACHE[FILTER_COLUMN_SOURCE_LIST[0].MODULE_NAME] = FILTER_COLUMN_LIST;
			let oPreviewSQL : string = await this.getReportSQL(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml, DisplayColumns);
			let oPreviewXOML: string = await this.getWorkflowXOML(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml);
			this.setState(
			{
				MODULE                   ,
				RELATED                  ,
				MODULES_LIST             ,
				RELATED_LIST             ,
				FILTER_COLUMN_SOURCE_LIST,
				FILTER_COLUMN_SOURCE     ,
				FILTER_COLUMN_LIST       ,
				FILTER_COLUMN            ,
				filterXml                ,
				filterXmlJson            ,
				filterXmlEditIndex       ,
				oPreviewSQL              ,
				oPreviewXOML             ,
			}, () =>
			{
				this.filterColumnChanged(null, null);
				this.props.onChanged('filterXml'       , filterXml       , null, null);
			});
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.moduleChanged', error);
			this.setState({ error });
		}
	}

	private getQueryBuilderState = async (Modules: string, MODULE: string, RELATED: string, caller?: string) =>
	{
		const { DesignWorkflow } = this.props;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.getQueryBuilderState ' + MODULE + ', ' + RELATED, caller);
		try
		{
			let TYPE: string = Sql.ToString(this.props.row['TYPE']);
			let url : string = (DesignWorkflow ? 'Administration/Workflows' : 'Reports');
			let res  = await CreateSplendidRequest(url + '/Rest.svc/GetQueryBuilderState?Modules=' + Sql.ToString(Modules) + '&MODULE_NAME=' + Sql.ToString(MODULE) + '&RELATED=' + Sql.ToString(RELATED) + '&TYPE=' + Sql.ToString(TYPE), 'GET');
			let json = await GetSplendidResult(res);
			return json.d;
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.getQueryBuilderState', error);
			this.setState({ error });
		}
		return null;
	}

	private getReportingFilterColumns = async (MODULE_NAME: string, TABLE_ALIAS: string) =>
	{
		const { DesignWorkflow } = this.props;
		try
		{
			let url : string = (DesignWorkflow ? 'Administration/Workflows/Rest.svc/GetWorkflowFilterColumns' : 'Reports/Rest.svc/GetReportingFilterColumns');
			let res  = await CreateSplendidRequest(url + '?MODULE_NAME=' + MODULE_NAME + '&TABLE_ALIAS=' + TABLE_ALIAS, 'GET');
			let json = await GetSplendidResult(res);
			let obj: any = json.d;
			return obj.results;
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.getReportingFilterColumns', error);
			this.setState({ error });
		}
		return null;
	}

	private getReportSQL = async (MODULE: string, RELATED: string, filterXml: any, relatedModuleXml: any, relationshipXml: any, DisplayColumns: string[]) =>
	{
		const { DesignWorkflow, row } = this.props;
		let PrimaryKeyOnly   = Sql.ToBoolean(this.props.PrimaryKeyOnly  );
		let UseSQLParameters = Sql.ToBoolean(this.props.UseSQLParameters);
		let DesignChart      = Sql.ToBoolean(this.props.DesignChart     );
		let UserSpecific     = Sql.ToBoolean(this.props.UserSpecific    );

		let oPreviewSQL: string = null;
		try
		{
			let obj: any =
			{
				// 06/05/2021 Paul.  Keep using MODULE to match Reports. 
				MODULE          ,
				RELATED         ,
				PrimaryKeyOnly  ,
				UseSQLParameters,
				DesignChart     ,
				UserSpecific    ,
				filterXml       ,
				relatedModuleXml,
				relationshipXml ,
			};
			if ( DesignWorkflow && row )
			{
				obj.TYPE = row.TYPE;
			}
			if ( Array.isArray(DisplayColumns) )
			{
				let displayColumnsXml: any = {};
				displayColumnsXml.DisplayColumns = {};
				displayColumnsXml.DisplayColumns.DisplayColumn = [];
				for ( let i: number = 0; i < DisplayColumns.length; i++ )
				{
					if ( !Sql.IsEmptyString(DisplayColumns[i]) )
					{
						let displayColumn: any = {};
						displayColumn.Label = DisplayColumns[i];
						displayColumn.Field = DisplayColumns[i];
					
						let arrField: string[] = DisplayColumns[i].split('.');
						if ( arrField.length == 2 )
						{
							displayColumn.Label = L10n.TableColumnName(arrField[0], arrField[1]);
						}
						displayColumnsXml.DisplayColumns.DisplayColumn.push(displayColumn);
					}
				}
				obj.displayColumnsXml = displayColumnsXml;
			}
			// 11/09/2019 Paul.  We cannot use ADAL because we are using the response_type=code style of authentication (confidential) that ADAL does not support. 
			let sBody: string = JSON.stringify(obj);
			let url : string = (DesignWorkflow ? 'Administration/Workflows' : 'Reports');
			let res  = await CreateSplendidRequest(url + '/Rest.svc/BuildReportSQL', 'POST', 'application/octet-stream', sBody);
			let json = await GetSplendidResult(res);
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.getReportSQL', json);
			oPreviewSQL = json.d;
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.getReportSQL', error);
			this.setState({ error });
		}
		return oPreviewSQL;
	}

	private getWorkflowXOML = async (MODULE: string, RELATED: string, filterXml: any, relatedModuleXml: any, relationshipXml: any) =>
	{
		const { PARENT_ID, row } = this.props;
		let oPreviewXOML: string = null;
		try
		{
			let obj: any =
			{
				// 06/05/2021 Paul.  Keep using MODULE to match Reports. 
				MODULE          ,
				RELATED         ,
				PARENT_ID       ,
				filterXml       ,
				relatedModuleXml,
				relationshipXml ,
			};
			let sBody: string = JSON.stringify(obj);
			let url  : string = 'Administration/WorkflowActionShells';
			let res  = await CreateSplendidRequest(url + '/Rest.svc/BuildActionXOML', 'POST', 'application/octet-stream', sBody);
			let json = await GetSplendidResult(res);
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.getWorkflowXOML', json);
			oPreviewXOML = json.d;
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.getWorkflowXOML', error);
			this.setState({ error });
		}
		return oPreviewXOML;
	}

	private decodeHTML = (html) =>
	{
		var txt = document.createElement('textarea');
		txt.innerHTML = html;
		return txt.value;
	}

	private _onChange_SHOW_XOML = (ev: React.ChangeEvent<HTMLInputElement>) =>
	{
		let SHOW_XOML = ev.target.checked;
		localStorage.setItem('XomlBuilder.SHOW_XOML', SHOW_XOML ? 'true' : 'false');
		this.setState({ SHOW_XOML });
	}

	private ResetSearchText = () =>
	{
		const { ACTION_TYPE, FILTER_COLUMN_SOURCE_LIST, RELATED_LIST } = this.state;
		let { FILTER_COLUMN_LIST } = this.state;
		let RELATED                : string = '';
		let FILTER_COLUMN_SOURCE   : string = '';
		let FILTER_COLUMN          : string = '';
		let FILTER_OPERATOR        : string = '';
		let FILTER_OPERATOR_TYPE   : string = '';
		let FILTER_SEARCH_DATA_TYPE: string = '';
		let FILTER_OPERATOR_LIST   : string[] = null;
		let CUSTOM_ACTIVITY_NAME   : string = '';
		let CUSTOM_COLUMN_NAME     : string = '';
		if ( StartsWith(ACTION_TYPE, 'custom') )
		{
			FILTER_OPERATOR_TYPE    = 'string';
			// 06/12/2021 Paul.  Only custom properties has a search text value. 
			if ( StartsWith(ACTION_TYPE, 'custom_prop') )
				FILTER_SEARCH_DATA_TYPE = 'string';
			FILTER_OPERATOR_LIST    = L10n.GetList('string_operator_dom');
			FILTER_OPERATOR         = FILTER_OPERATOR_LIST[0];
		}
		else
		{
			if ( ACTION_TYPE == 'update_rel' || ACTION_TYPE == 'new' )
			{
				if ( RELATED_LIST != null && RELATED_LIST.length > 0 )
				{
					RELATED = RELATED_LIST[0].MODULE_NAME;
					FILTER_COLUMN_LIST = this.FILTER_COLUMN_LIST_CACHE[RELATED];
				}
			}
			if ( FILTER_COLUMN_SOURCE_LIST != null && FILTER_COLUMN_SOURCE_LIST.length > 0 )
			{
				FILTER_COLUMN_SOURCE = FILTER_COLUMN_SOURCE_LIST[0].MODULE_NAME;
			}
			if ( FILTER_COLUMN_LIST != null && FILTER_COLUMN_LIST.length > 0 )
			{
				FILTER_COLUMN = FILTER_COLUMN_LIST[0].NAME;
			}
			if ( FILTER_OPERATOR_LIST != null && FILTER_OPERATOR_LIST.length > 0 )
			{
				FILTER_OPERATOR = FILTER_OPERATOR_LIST[0];
			}

			let row: any = this.getFilterColumn(FILTER_COLUMN_SOURCE, FILTER_COLUMN);
			if ( row != null )
			{
				FILTER_OPERATOR_TYPE    = row['CsType'].toLowerCase();
				FILTER_SEARCH_DATA_TYPE = row['CsType'].toLowerCase();
				FILTER_OPERATOR         = '';
				if ( StartsWith(ACTION_TYPE, 'custom') )
				{
					FILTER_OPERATOR_TYPE    = 'string';
					FILTER_OPERATOR_LIST    = L10n.GetList('string_operator_dom');
				}
				else if ( FILTER_OPERATOR_TYPE == 'enum' )
				{
					FILTER_OPERATOR_LIST    = L10n.GetList('custom_enum_operator_dom');
				}
				else
				{
					FILTER_OPERATOR_LIST    = L10n.GetList(FILTER_OPERATOR_TYPE + '_operator_dom');
				}
				if ( this.props.DesignWorkflow && !Sql.IsEmptyString(FILTER_COLUMN) && FILTER_COLUMN.indexOf('_AUDIT_OLD.') >= 0 )
				{
					FILTER_OPERATOR_LIST = ['changed', 'unchanged', 'increased', 'decreased', ...FILTER_OPERATOR_LIST];
				}
				if ( FILTER_OPERATOR_LIST && FILTER_OPERATOR_LIST.length > 0 )
				{
					FILTER_OPERATOR = FILTER_OPERATOR_LIST[0];
				}
			}
		}
		// 06/16/2021 Paul.  Must reset all search values. 
		this.setState(
		{
			RELATED                  ,
			FILTER_ID                : '',
			FILTER_COLUMN_LIST       ,
			FILTER_COLUMN_SOURCE     ,
			FILTER_COLUMN            ,
			FILTER_OPERATOR_LIST     ,
			FILTER_OPERATOR          ,
			FILTER_OPERATOR_TYPE     ,
			FILTER_SEARCH_DATA_TYPE  ,
			FILTER_SEARCH_ID         : '',
			FILTER_SEARCH_TEXT       : '',
			FILTER_SEARCH_TEXT2      : '',
			FILTER_SEARCH_START_DATE : '',
			FILTER_SEARCH_END_DATE   : '',
			FILTER_SEARCH_MODULE_TYPE: '',
			FILTER_SEARCH_DROPDOWN   : '',
			FILTER_SEARCH_LISTBOX    : [],
			ACTION_TYPE              ,
			CUSTOM_ACTIVITY_NAME     ,
			CUSTOM_COLUMN_NAME       ,
			filterXmlEditIndex       : -1   ,
			error                    : null ,
		}, () =>
		{
			this.BindSearchText();
		});
	}

	private getFilterColumn = (FILTER_COLUMN_SOURCE: string, FILTER_COLUMN: string) =>
	{
		const { FILTER_COLUMN_SOURCE_LIST, FILTER_COLUMN_LIST } = this.state;
		if ( Sql.IsEmptyString(FILTER_COLUMN_SOURCE) )
		{
			if ( FILTER_COLUMN_SOURCE_LIST.length > 0 )
			{
				FILTER_COLUMN_SOURCE = FILTER_COLUMN_SOURCE_LIST[0].MODULE_NAME;
			}
		}
		if ( Sql.IsEmptyString(FILTER_COLUMN) )
		{
			if ( FILTER_COLUMN_LIST.length > 0 )
			{
				FILTER_COLUMN = FILTER_COLUMN_LIST[0].NAME;
			}
		}
		let sColumnName: string = Sql.ToString(FILTER_COLUMN).split('.')[1];
		if ( FILTER_COLUMN_LIST.length > 0 )
		{
			for ( let i: number = 0; i < FILTER_COLUMN_LIST.length; i++ )
			{
				let row: any = FILTER_COLUMN_LIST[i];
				if ( row['ColumnName'] == sColumnName )
				{
					return row;
				}
			}
		}
		return null;
	}

	private filterRelatedChanged = async (RELATED: string) =>
	{
		let arrModule         : string[] = RELATED.split(' ');
		let sModule           : string   = arrModule[0];
		let sTableAlias       : string   = arrModule[1];
		let FILTER_COLUMN_LIST: any[]    = null;
		// 05/15/2021 Paul.  Cache the FILTER_COLUMN_LIST. 
		FILTER_COLUMN_LIST = this.FILTER_COLUMN_LIST_CACHE[RELATED];
		if ( FILTER_COLUMN_LIST == null )
		{
			FILTER_COLUMN_LIST = await this.getReportingFilterColumns(sModule, sTableAlias);
			this.FILTER_COLUMN_LIST_CACHE[RELATED] = FILTER_COLUMN_LIST;
		}
		if ( FILTER_COLUMN_LIST!= null && FILTER_COLUMN_LIST.length > 0 )
		{
			let row: any = FILTER_COLUMN_LIST[0];
			let FILTER_COLUMN          : string = row['NAME'];
			let FILTER_OPERATOR_TYPE   : string = row['CsType'].toLowerCase();
			let FILTER_SEARCH_DATA_TYPE: string = row['CsType'].toLowerCase();
			let FILTER_OPERATOR        : string = '';
			let FILTER_OPERATOR_LIST   : string[] = L10n.GetList(FILTER_OPERATOR_TYPE + '_operator_dom');
			if ( this.props.DesignWorkflow && !Sql.IsEmptyString(FILTER_COLUMN) && FILTER_COLUMN.indexOf('_AUDIT_OLD.') >= 0 )
			{
				FILTER_OPERATOR_LIST = ['changed', 'unchanged', 'increased', 'decreased', ...FILTER_OPERATOR_LIST];
			}
			if ( FILTER_OPERATOR_LIST && FILTER_OPERATOR_LIST.length > 0 )
			{
				FILTER_OPERATOR = FILTER_OPERATOR_LIST[0];
			}
			this.setState(
			{
				FILTER_COLUMN_LIST     ,
				FILTER_COLUMN          ,
				FILTER_OPERATOR_LIST   ,
				FILTER_OPERATOR        ,
				FILTER_OPERATOR_TYPE   ,
				FILTER_SEARCH_DATA_TYPE,
			}, () =>
			{
				this.BindSearchText();
			});
		}
	}

	private filterColumnSourceChanged = async (FILTER_COLUMN_SOURCE: string) =>
	{
		let arrModule         : string[] = FILTER_COLUMN_SOURCE.split(' ');
		let sModule           : string   = arrModule[0];
		let sTableAlias       : string   = arrModule[1];
		let FILTER_COLUMN_LIST: any[]    = null;
		// 05/15/2021 Paul.  Cache the FILTER_COLUMN_LIST. 
		FILTER_COLUMN_LIST = this.FILTER_COLUMN_LIST_CACHE[FILTER_COLUMN_SOURCE];
		if ( FILTER_COLUMN_LIST == null )
		{
			FILTER_COLUMN_LIST = await this.getReportingFilterColumns(sModule, sTableAlias);
			this.FILTER_COLUMN_LIST_CACHE[FILTER_COLUMN_SOURCE] = FILTER_COLUMN_LIST;
		}
		if ( FILTER_COLUMN_LIST!= null && FILTER_COLUMN_LIST.length > 0 )
		{
			let row: any = FILTER_COLUMN_LIST[0];
			let FILTER_COLUMN          : string = row['NAME'];
			let FILTER_OPERATOR_TYPE   : string = row['CsType'].toLowerCase();
			let FILTER_SEARCH_DATA_TYPE: string = row['CsType'].toLowerCase();
			let FILTER_OPERATOR        : string = '';
			let FILTER_OPERATOR_LIST   : string[] = L10n.GetList(FILTER_OPERATOR_TYPE + '_operator_dom');
			if ( this.props.DesignWorkflow && !Sql.IsEmptyString(FILTER_COLUMN) && FILTER_COLUMN.indexOf('_AUDIT_OLD.') >= 0 )
			{
				FILTER_OPERATOR_LIST = ['changed', 'unchanged', 'increased', 'decreased', ...FILTER_OPERATOR_LIST];
			}
			if ( FILTER_OPERATOR_LIST && FILTER_OPERATOR_LIST.length > 0 )
			{
				FILTER_OPERATOR = FILTER_OPERATOR_LIST[0];
			}
			this.setState(
			{
				FILTER_COLUMN_LIST     ,
				FILTER_COLUMN          ,
				FILTER_OPERATOR_LIST   ,
				FILTER_OPERATOR        ,
				FILTER_OPERATOR_TYPE   ,
				FILTER_SEARCH_DATA_TYPE,
			}, () =>
			{
				this.BindSearchText();
			});
		}
	}

	private filterColumnChanged = (FILTER_COLUMN_SOURCE: string, FILTER_COLUMN: string) =>
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.filterColumnChanged ' + FILTER_COLUMN_SOURCE + ' ' + FILTER_COLUMN);
		let row: any = this.getFilterColumn(FILTER_COLUMN_SOURCE, FILTER_COLUMN);
		if ( row != null )
		{
			let FILTER_OPERATOR_TYPE   : string = row['CsType'].toLowerCase();
			let FILTER_SEARCH_DATA_TYPE: string = row['CsType'].toLowerCase();
			let FILTER_OPERATOR        : string = '';
			let FILTER_OPERATOR_LIST   : string[] = L10n.GetList(FILTER_OPERATOR_TYPE + '_operator_dom');
			if ( this.props.DesignWorkflow && !Sql.IsEmptyString(FILTER_COLUMN) && FILTER_COLUMN.indexOf('_AUDIT_OLD.') >= 0 )
			{
				FILTER_OPERATOR_LIST = ['changed', 'unchanged', 'increased', 'decreased', ...FILTER_OPERATOR_LIST];
			}
			if ( FILTER_OPERATOR_LIST && FILTER_OPERATOR_LIST.length > 0 )
			{
				FILTER_OPERATOR = FILTER_OPERATOR_LIST[0];
			}
			this.setState(
			{
				FILTER_OPERATOR_LIST     ,
				FILTER_OPERATOR          ,
				FILTER_OPERATOR_TYPE     ,
				FILTER_SEARCH_DATA_TYPE  ,
				FILTER_SEARCH_DROPDOWN   : null,
				FILTER_SEARCH_LISTBOX    : null,
				FILTER_SEARCH_ID         : null,
				FILTER_SEARCH_TEXT       : null,
				FILTER_SEARCH_TEXT2      : null,
				FILTER_SEARCH_START_DATE : null,
				FILTER_SEARCH_END_DATE   : null,
				FILTER_SEARCH_MODULE_TYPE: null,
			}, () =>
			{
				this.BindSearchText();
			});
		}
	}

	private filterOperatorListName = (item, FILTER_OPERATOR_TYPE) =>
	{
		let sListName: string = FILTER_OPERATOR_TYPE + '_operator_dom';
		if ( item == 'changed' || item == 'unchanged' || item == 'increased' || item == 'decreased' )
		{
			sListName = 'workflow_operator_dom';
		}
		return sListName;
	}

	private BindSearchText = () =>
	{
		const { RELATED, FILTER_COLUMN_LIST_NAMES, FILTER_COLUMN_SOURCE, FILTER_COLUMN, FILTER_SEARCH_DATA_TYPE } = this.state;
		let { FILTER_OPERATOR, FILTER_SEARCH_DROPDOWN, FILTER_SEARCH_LISTBOX } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.BindSearchText');
		let FILTER_SEARCH_MODE         : string = null;
		let FILTER_SEARCH_LIST_NAME    : string = null;
		let FILTER_SEARCH_DROPDOWN_LIST: any[]  = null;
		let FILTER_SEARCH_LISTBOX_LIST : any[]  = null;
		let FILTER_SEARCH_MODULE_TYPE  : string = null;
		// 07/06/2007 Paul.  ansistring is treated the same as string. 
		let sCOMMON_DATA_TYPE: string = FILTER_SEARCH_DATA_TYPE;
		if ( sCOMMON_DATA_TYPE == "ansistring" )
			sCOMMON_DATA_TYPE = "string";
		switch ( sCOMMON_DATA_TYPE )
		{
			case "string":
			{
				switch ( FILTER_OPERATOR )
				{
					case "equals"        :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "contains"      :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "starts_with"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "ends_with"     :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "not_equals_str":  FILTER_SEARCH_MODE = 'text' ;  break;
					case "empty"         :  break;
					case "not_empty"     :  break;
					case "changed"       :  break;
					case "unchanged"     :  break;
					case "increased"     :  break;
					case "decreased"     :  break;
					// 08/25/2011 Paul.  A customer wants more use of NOT in string filters. 
					case "not_contains"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "not_starts_with":  FILTER_SEARCH_MODE = 'text' ;  break;
					case "not_ends_with"  :  FILTER_SEARCH_MODE = 'text' ;  break;
					// 02/14/2013 Paul.  A customer wants to use like in string filters. 
					case "like"           :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "not_like"       :  FILTER_SEARCH_MODE = 'text' ;  break;
					// 07/23/2013 Paul.  Add greater and less than conditions. 
					case "less"          :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "less_equal"    :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "greater"       :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "greater_equal" :  FILTER_SEARCH_MODE = 'text' ;  break;
				}
				break;
			}
			case "datetime":
			{
				/*
				switch ( FILTER_OPERATOR )
				{
					case "on"               :  FILTER_SEARCH_MODE = 'date' ;  break;
					case "before"           :  FILTER_SEARCH_MODE = 'date' ;  break;
					case "after"            :  FILTER_SEARCH_MODE = 'date' ;  break;
					case "between_dates"    :  FILTER_SEARCH_MODE = 'date2';  break;
					case "not_equals_str"   :  FILTER_SEARCH_MODE = 'date' ;  break;
					case "empty"            :  break;
					case "not_empty"        :  break;
					case "is_before"        :  break;
					case "is_after"         :  break;
					case "tp_yesterday"     :  break;
					case "tp_today"         :  break;
					case "tp_tomorrow"      :  break;
					case "tp_last_7_days"   :  break;
					case "tp_next_7_days"   :  break;
					case "tp_last_month"    :  break;
					case "tp_this_month"    :  break;
					case "tp_next_month"    :  break;
					case "tp_last_30_days"  :  break;
					case "tp_next_30_days"  :  break;
					case "tp_last_year"     :  break;
					case "tp_this_year"     :  break;
					case "tp_next_year"     :  break;
					case "changed"          :  break;
					case "unchanged"        :  break;
					case "increased"        :  break;
					case "decreased"        :  break;
					case "tp_minutes_after" :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_hours_after"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_days_after"    :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_weeks_after"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_months_after"  :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_years_after"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_minutes_before":  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_hours_before"  :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_days_before"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_weeks_before"  :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_months_before" :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_years_before"  :  FILTER_SEARCH_MODE = 'text' ;  break;
					// 12/04/2008 Paul.  We need to be able to do an an equals. 
					case "tp_days_old"      :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_weeks_old"     :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_months_old"    :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "tp_years_old"     :  FILTER_SEARCH_MODE = 'text' ;  break;
				}
				*/
				// 05/04/2009 Paul.  Use the text field instead of the date field to allow for activity binding. 
				FILTER_SEARCH_MODE = 'text' ;  break;
				break;
			}
			case "int32":
			{
				switch ( FILTER_OPERATOR )
				{
					case "equals"    :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "less"      :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "greater"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "between"   :  FILTER_SEARCH_MODE = 'text2';  break;
					case "not_equals":  FILTER_SEARCH_MODE = 'text' ;  break;
					case "empty"     :  break;
					case "not_empty" :  break;
					case "changed"   :  break;
					case "unchanged" :  break;
					case "increased" :  break;
					case "decreased" :  break;
					// 07/23/2013 Paul.  Add greater and less than conditions. 
					case "less_equal"    :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "greater_equal" :  FILTER_SEARCH_MODE = 'text' ;  break;
				}
				break;
			}
			case "decimal":
			{
				switch ( FILTER_OPERATOR )
				{
					case "equals"    :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "less"      :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "greater"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "between"   :  FILTER_SEARCH_MODE = 'text2';  break;
					case "not_equals":  FILTER_SEARCH_MODE = 'text' ;  break;
					case "empty"     :  break;
					case "not_empty" :  break;
					case "changed"   :  break;
					case "unchanged" :  break;
					case "increased" :  break;
					case "decreased" :  break;
					// 07/23/2013 Paul.  Add greater and less than conditions. 
					case "less_equal"    :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "greater_equal" :  FILTER_SEARCH_MODE = 'text' ;  break;
				}
				break;
			}
			case "float":
			{
				switch ( FILTER_OPERATOR )
				{
					case "equals"    :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "less"      :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "greater"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "between"   :  FILTER_SEARCH_MODE = 'text2';  break;
					case "not_equals":  FILTER_SEARCH_MODE = 'text' ;  break;
					case "empty"     :  break;
					case "not_empty" :  break;
					case "changed"   :  break;
					case "unchanged" :  break;
					case "increased" :  break;
					case "decreased" :  break;
					// 07/23/2013 Paul.  Add greater and less than conditions. 
					case "less_equal"    :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "greater_equal" :  FILTER_SEARCH_MODE = 'text' ;  break;
				}
				break;
			}
			case "bool":
			{
				switch ( FILTER_OPERATOR )
				{
					case "equals"    :
						// 12/20/2006 Paul.  We need to populate the dropdown for booleans with 1 and 0. 
						FILTER_SEARCH_MODE = 'dropdown';
						FILTER_SEARCH_LIST_NAME     = 'yesno_dom';
						FILTER_SEARCH_DROPDOWN_LIST = L10n.GetList(FILTER_SEARCH_LIST_NAME);
						if ( FILTER_SEARCH_DROPDOWN_LIST != null && FILTER_SEARCH_DROPDOWN_LIST.length > 0 )
							FILTER_SEARCH_DROPDOWN = FILTER_SEARCH_DROPDOWN_LIST[0];
						break;
					case "empty"     :  break;
					case "not_empty" :  break;
					case "changed"   :  break;
					case "unchanged" :  break;
					case "increased" :  break;
					case "decreased" :  break;
				}
				break;
			}
			case "guid":
			{
				// 11/17/2008 Paul.  Since we don't enable the filter operator, we need to default to equals 
				// so that the edit field is enabled. 
				if ( FILTER_OPERATOR == 'is' )
					FILTER_OPERATOR = 'equals';
				switch ( FILTER_OPERATOR )
				{
					// 05/05/2010 Paul.  The Select button was not being made visible. 
					case "is"            :
					{
						let arrModule: string[] = [];
						if ( Sql.IsEmptyString(RELATED) )
							arrModule = FILTER_COLUMN_SOURCE.split(' ');
						else
							arrModule = RELATED.split(' ');

						let sModule    : string   = arrModule[0];
						let arrColumn  : string[] = FILTER_COLUMN.split('.');
						let sColumnName: string   = arrColumn[0];
						if ( arrColumn.length > 1 )
							sColumnName = arrColumn[1];
							
						switch ( sColumnName )
						{
							case "ID"              :  FILTER_SEARCH_MODULE_TYPE = sModule;  break;
							case "CREATED_BY_ID"   :  FILTER_SEARCH_MODULE_TYPE = "Users";  break;
							case "MODIFIED_USER_ID":  FILTER_SEARCH_MODULE_TYPE = "Users";  break;
							case "ASSIGNED_USER_ID":  FILTER_SEARCH_MODULE_TYPE = "Users";  break;
							case "TEAM_ID"         :  FILTER_SEARCH_MODULE_TYPE = "Teams";  break;
							default:
							{
								let layout = EditView_LoadLayout(sModule + '.EditView');
								if ( layout != null )
								{
									let lay = EditView_FindField(layout, sColumnName);
									FILTER_SEARCH_MODULE_TYPE = lay.MODULE_TYPE;
								}
								break;
							}
						}
						if ( !Sql.IsEmptyString(FILTER_SEARCH_MODULE_TYPE) )
							FILTER_SEARCH_MODE = 'select';
						break;
					}
					case "equals"        :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "contains"      :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "starts_with"   :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "ends_with"     :  FILTER_SEARCH_MODE = 'text' ;  break;
					case "not_equals_str":  FILTER_SEARCH_MODE = 'text' ;  break;
					case "empty"         :  break;
					case "not_empty"     :  break;
					case "changed"       :  break;
					case "unchanged"     :  break;
					case "increased"     :  break;
					case "decreased"     :  break;
				}
				break;
			}
			case "enum":
			{
				// 02/09/2007 Paul.  If this is an enum, then populate the listbox with list names pulled from EDITVIEWS_FIELDS.
				let arrModule: string[] = [];
				if ( Sql.IsEmptyString(RELATED) )
					arrModule = FILTER_COLUMN_SOURCE.split(' ');
				else
					arrModule = RELATED.split(' ');
				let sModule  : string   = arrModule[0];
					
				let arrColumn  : string[] = FILTER_COLUMN.split('.');
				let sColumnName: string   = arrColumn[0];
				if ( arrColumn.length > 1 )
					sColumnName = arrColumn[1];
				
				let sMODULE_TABLE: string = Crm_Modules.TableName(sModule);
				FILTER_SEARCH_LIST_NAME = FILTER_COLUMN_LIST_NAMES[sMODULE_TABLE + '.' + sColumnName];
				if ( Sql.IsEmptyString(FILTER_SEARCH_LIST_NAME) )
				{
					FILTER_SEARCH_DROPDOWN_LIST = null;
					FILTER_SEARCH_LISTBOX_LIST  = null;
				}
				else
				{
					FILTER_SEARCH_DROPDOWN_LIST = L10n.GetList(FILTER_SEARCH_LIST_NAME);
					FILTER_SEARCH_LISTBOX_LIST  = FILTER_SEARCH_DROPDOWN_LIST;
					switch ( FILTER_OPERATOR )
					{
						case "is"            :
							FILTER_SEARCH_MODE = 'dropdown';
							if ( FILTER_SEARCH_DROPDOWN == null && FILTER_SEARCH_DROPDOWN_LIST != null && FILTER_SEARCH_DROPDOWN_LIST.length > 0 )
							{
								FILTER_SEARCH_DROPDOWN = FILTER_SEARCH_DROPDOWN_LIST[0];
							}
							break;
						case "one_of"        :
							FILTER_SEARCH_MODE = 'listbox' ;
							if ( FILTER_SEARCH_LISTBOX == null && FILTER_SEARCH_LISTBOX_LIST != null && FILTER_SEARCH_LISTBOX_LIST.length > 0 )
							{
								FILTER_SEARCH_LISTBOX = FILTER_SEARCH_LISTBOX_LIST[0];
							}
							break;
						case "empty"         :  break;
						case "not_empty"     :  break;
						case "changed"       :  break;
						case "unchanged"     :  break;
						case "increased"     :  break;
						case "decreased"     :  break;
					}
				}
				// 09/13/2011 Paul.  The operator within a Workflow Action is disabled because we can only do an assignment here. 
				// An exception is the Enum as we want to allow an ActivityBind. 
				if ( FILTER_OPERATOR == 'custom' )
				{
					FILTER_SEARCH_MODE = 'text';
				}
				break;
			}
		}
		this.setState(
		{
			FILTER_OPERATOR            ,
			FILTER_SEARCH_MODE         ,
			FILTER_SEARCH_LIST_NAME    ,
			FILTER_SEARCH_DROPDOWN_LIST,
			FILTER_SEARCH_LISTBOX_LIST ,
			FILTER_SEARCH_MODULE_TYPE  ,
			FILTER_SEARCH_DROPDOWN     ,
			FILTER_SEARCH_LISTBOX      ,
		});
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.BindSearchText', FILTER_SEARCH_MODE);
	}

	private _onFiltersEdit = async (index: number) =>
	{
		let { filterXml } = this.state;

		let FILTER_ID                  : string  = '';
		let FILTER_COLUMN_SOURCE       : string  = '';
		let FILTER_COLUMN              : string  = '';
		let FILTER_OPERATOR            : string  = '';
		let FILTER_OPERATOR_TYPE       : string  = '';
		let FILTER_SEARCH_ID           : string  = '';
		let FILTER_SEARCH_DATA_TYPE    : string  = '';
		let FILTER_SEARCH_TEXT         : string  = '';
		let FILTER_SEARCH_TEXT2        : string  = '';
		let FILTER_SEARCH_START_DATE   : string  = '';
		let FILTER_SEARCH_END_DATE     : string  = '';
		let FILTER_SEARCH_DROPDOWN     : string  = '';
		let FILTER_SEARCH_LISTBOX      : string[] = [];
		let ACTION_TYPE                : string  = '';
		let RELATED                    : string  = '';
		let CUSTOM_ACTIVITY_NAME       : string  = '';
		let CUSTOM_COLUMN_NAME         : string  = '';
		if ( filterXml && filterXml.Filters && filterXml.Filters.Filter && index < filterXml.Filters.Filter.length )
		{
			let sFILTER_ID        : string   = '';
			let sACTION_TYPE      : string   = '';
			let sRELATIONSHIP_NAME: string   = '';
			let sMODULE_NAME      : string   = '';
			let sDATA_FIELD       : string   = '';
			let sDATA_TYPE        : string   = '';
			let sOPERATOR         : string   = '';
			let sSEARCH_TEXT1     : string   = '';
			let sSEARCH_TEXT2     : string   = '';
			let arrSEARCH_TEXT    : string[] = [];
			let SEARCH_TEXT_VALUES: any = null;

			sACTION_TYPE         = Sql.ToString(filterXml.Filters.Filter[index]['ACTION_TYPE'         ]);
			sRELATIONSHIP_NAME   = Sql.ToString(filterXml.Filters.Filter[index]['RELATIONSHIP_NAME'   ]);
			sFILTER_ID           = Sql.ToString(filterXml.Filters.Filter[index]['ID'                  ]);
			sMODULE_NAME         = Sql.ToString(filterXml.Filters.Filter[index]['MODULE_NAME'         ]);
			sDATA_FIELD          = Sql.ToString(filterXml.Filters.Filter[index]['DATA_FIELD'          ]);
			sDATA_TYPE           = Sql.ToString(filterXml.Filters.Filter[index]['DATA_TYPE'           ]);
			sOPERATOR            = Sql.ToString(filterXml.Filters.Filter[index]['OPERATOR'            ]);
			//sSEARCH_TEXT         = Sql.ToString(filterXml.Filters.Filter[index]['SEARCH_TEXT'         ]);
			SEARCH_TEXT_VALUES   = filterXml.Filters.Filter[index]['SEARCH_TEXT_VALUES'];
			if ( SEARCH_TEXT_VALUES != null )
			{
				if ( !Array.isArray(SEARCH_TEXT_VALUES) )
				{
					arrSEARCH_TEXT.push(SEARCH_TEXT_VALUES);
				}
				else
				{
					arrSEARCH_TEXT = SEARCH_TEXT_VALUES;
				}
			}
			if ( arrSEARCH_TEXT.length > 0 )
				sSEARCH_TEXT1 = arrSEARCH_TEXT[0];
			if ( arrSEARCH_TEXT.length > 1 )
				sSEARCH_TEXT2 = arrSEARCH_TEXT[1];


			ACTION_TYPE          = sACTION_TYPE;
			// 08/19/2010 Paul.  Check the list before assigning the value. 
			// 11/01/2010 Paul.  Add Custom Activity Action Type. 
			// 11/07/2010 Paul.  Add Custom Method and Custom Property. 
			if ( StartsWith(ACTION_TYPE, 'custom') )
				CUSTOM_ACTIVITY_NAME = sRELATIONSHIP_NAME;
			else
				RELATED = sRELATIONSHIP_NAME;

			// 08/19/2010 Paul.  Check the list before assigning the value. 
			// 11/01/2010 Paul.  Add Custom Activity Action Type. 
			// 11/07/2010 Paul.  Add Custom Method and Custom Property. 
			// 08/03/2012 Paul.  Add Custom Stored Procedure. 
			if ( ACTION_TYPE == 'custom_procedure' )
				CUSTOM_COLUMN_NAME   = sDATA_FIELD;
			else if ( StartsWith(ACTION_TYPE, 'custom') )
				CUSTOM_COLUMN_NAME   = sDATA_FIELD;
			else
				FILTER_COLUMN = sDATA_FIELD;

			// 07/06/2007 Paul.  ansistring is treated the same as string. 
			let sCOMMON_DATA_TYPE: string = sDATA_TYPE;
			if ( sCOMMON_DATA_TYPE == "ansistring" )
				sCOMMON_DATA_TYPE = "string";
			switch ( sCOMMON_DATA_TYPE )
			{
				case "string":
				{
					switch ( sOPERATOR )
					{
						case "equals"        :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "contains"      :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "starts_with"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "ends_with"     :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "not_equals_str":  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "empty"         :  break;
						case "not_empty"     :  break;
						case "changed"       :  break;
						case "unchanged"     :  break;
						case "increased"     :  break;
						case "decreased"     :  break;
						// 08/25/2011 Paul.  A customer wants more use of NOT in string filters. 
						case "not_contains"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "not_starts_with":  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "not_ends_with"  :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						// 02/14/2013 Paul.  A customer wants to use like in string filters. 
						case "like"           :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "not_like"       :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						// 07/23/2013 Paul.  Add greater and less than conditions. 
						case "less"           :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "less_equal"     :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "greater"        :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "greater_equal"  :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
					}
					break;
				}
				case "datetime":
				{
					/*
					if ( arrSEARCH_TEXT.length > 0 )
					{
						let dtSEARCH_TEXT1: any = null;
						let dtSEARCH_TEXT2: any = null;
						if ( !(EndsWith(sOPERATOR, "_after") || EndsWith(sOPERATOR, "_before") || EndsWith(sOPERATOR, "_old")) )
						{
							
							dtSEARCH_TEXT1 = formatDate(sSEARCH_TEXT1, this.DATE_FORMAT);
							dtSEARCH_TEXT2 = null;
							if ( arrSEARCH_TEXT.length > 1 )
								dtSEARCH_TEXT2 = formatDate(sSEARCH_TEXT2, this.DATE_FORMAT);
						}
						switch ( sOPERATOR )
						{
							case "on"               :  FILTER_SEARCH_START_DATE = dtSEARCH_TEXT1;  break;
							case "before"           :  FILTER_SEARCH_START_DATE = dtSEARCH_TEXT1;  break;
							case "after"            :  FILTER_SEARCH_START_DATE = dtSEARCH_TEXT1;  break;
							case "not_equals_str"   :  FILTER_SEARCH_START_DATE = dtSEARCH_TEXT1;  break;
							case "between_dates"    :
								FILTER_SEARCH_START_DATE = dtSEARCH_TEXT1;
								if ( arrSEARCH_TEXT.length > 1 )
									FILTER_SEARCH_END_DATE = dtSEARCH_TEXT2;
								break;
							case "empty"            :  break;
							case "not_empty"        :  break;
							case "is_before"        :  break;
							case "is_after"         :  break;
							case "tp_yesterday"     :  break;
							case "tp_today"         :  break;
							case "tp_tomorrow"      :  break;
							case "tp_last_7_days"   :  break;
							case "tp_next_7_days"   :  break;
							case "tp_last_month"    :  break;
							case "tp_this_month"    :  break;
							case "tp_next_month"    :  break;
							case "tp_last_30_days"  :  break;
							case "tp_next_30_days"  :  break;
							case "tp_last_year"     :  break;
							case "tp_this_year"     :  break;
							case "tp_next_year"     :  break;
							case "changed"          :  break;
							case "unchanged"        :  break;
							case "increased"        :  break;
							case "decreased"        :  break;
							// 11/16/2008 Paul.  Days old 
							case "tp_minutes_after" :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_hours_after"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_days_after"    :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_weeks_after"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_months_after"  :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_years_after"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_minutes_before":  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_hours_before"  :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_days_before"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_weeks_before"  :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_months_before" :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_years_before"  :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							// 12/04/2008 Paul.  We need to be able to do an an equals. 
							case "tp_days_old"      :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_weeks_old"     :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_months_old"    :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
							case "tp_years_old"     :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						}
					}
					*/
					break;
				}
				case "int32":
				{
					switch ( sOPERATOR )
					{
						case "equals"    :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "less"      :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "greater"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "between"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  FILTER_SEARCH_TEXT2 = sSEARCH_TEXT2;  break;
						case "not_equals":  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "empty"     :  break;
						case "not_empty" :  break;
						case "changed"   :  break;
						case "unchanged" :  break;
						case "increased" :  break;
						case "decreased" :  break;
						// 07/23/2013 Paul.  Add greater and less than conditions. 
						case "less_equal"     :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "greater_equal"  :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
					}
					break;
				}
				case "decimal":
				{
					switch ( sOPERATOR )
					{
						case "equals"    :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "less"      :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "greater"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "between"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  FILTER_SEARCH_TEXT2 = sSEARCH_TEXT2;  break;
						case "not_equals":  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "empty"     :  break;
						case "not_empty" :  break;
						case "changed"   :  break;
						case "unchanged" :  break;
						case "increased" :  break;
						case "decreased" :  break;
						// 07/23/2013 Paul.  Add greater and less than conditions. 
						case "less_equal"     :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "greater_equal"  :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
					}
					break;
				}
				case "float":
				{
					switch ( sOPERATOR )
					{
						case "equals"    :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "less"      :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "greater"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "between"   :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  FILTER_SEARCH_TEXT2 = sSEARCH_TEXT2;  break;
						case "not_equals":  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "empty"     :  break;
						case "not_empty" :  break;
						case "changed"   :  break;
						case "unchanged" :  break;
						case "increased" :  break;
						case "decreased" :  break;
						// 07/23/2013 Paul.  Add greater and less than conditions. 
						case "less_equal"     :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
						case "greater_equal"  :  FILTER_SEARCH_TEXT = sSEARCH_TEXT1;  break;
					}
					break;
				}
				case "bool":
				{
					switch ( sOPERATOR )
					{
						case "equals"    :
							try
							{
								// 12/20/2006 Paul.  Catch and ignore the exception. 
								// 08/19/2010 Paul.  Check the list before assigning the value. 
								//Utils.SetSelectedValue(lstFILTER_SEARCH_DROPDOWN, sSEARCH_TEXT1);
							}
							catch
							{
							}
							break;
						case "empty"     :  break;
						case "not_empty" :  break;
						case "changed"   :  break;
						case "unchanged" :  break;
						case "increased" :  break;
						case "decreased" :  break;
					}
					break;
				}
				case "guid":
				{
					switch ( sOPERATOR )
					{
						// 05/05/2010 Paul.  We store both the ID and the Name for a Guid IS. 
						case "is"            :  FILTER_SEARCH_ID    = sSEARCH_TEXT1;  FILTER_SEARCH_TEXT = sSEARCH_TEXT2;  break;
						case "equals"        :  FILTER_SEARCH_TEXT  = sSEARCH_TEXT1;  break;
						case "contains"      :  FILTER_SEARCH_TEXT  = sSEARCH_TEXT1;  break;
						case "starts_with"   :  FILTER_SEARCH_TEXT  = sSEARCH_TEXT1;  break;
						case "ends_with"     :  FILTER_SEARCH_TEXT  = sSEARCH_TEXT1;  break;
						case "not_equals_str":  FILTER_SEARCH_TEXT  = sSEARCH_TEXT1;  break;
						case "empty"         :  break;
						case "not_empty"     :  break;
						case "changed"       :  break;
						case "unchanged"     :  break;
						case "increased"     :  break;
						case "decreased"     :  break;
					}
					break;
				}
				case "enum":
				{
					switch ( sOPERATOR )
					{
						case "is"            :  FILTER_SEARCH_DROPDOWN = sSEARCH_TEXT1 ;  break;
						case "one_of"        :  FILTER_SEARCH_LISTBOX  = arrSEARCH_TEXT;  break;
						case "empty"         :  break;
						case "not_empty"     :  break;
						case "changed"       :  break;
						case "unchanged"     :  break;
						case "increased"     :  break;
						case "decreased"     :  break;
					}
					break;
				}
			}

			FILTER_ID               = sFILTER_ID  ;
			FILTER_COLUMN_SOURCE    = sMODULE_NAME;
			FILTER_COLUMN           = sDATA_FIELD ;
			FILTER_OPERATOR         = sOPERATOR   ;
			FILTER_OPERATOR_TYPE    = sDATA_TYPE  ;
			FILTER_SEARCH_DATA_TYPE = sDATA_TYPE  ;
		}
		let MODULE: string = '';
		if ( !Sql.IsEmptyString(RELATED) )
			MODULE = RELATED;
		else
			MODULE = FILTER_COLUMN_SOURCE;
		let arrModule         : string[] = MODULE.split(' ');
		let sModule           : string   = arrModule[0];
		let sTableAlias       : string   = arrModule[1];
		let FILTER_COLUMN_LIST: any[]    = null;
		FILTER_COLUMN_LIST = this.FILTER_COLUMN_LIST_CACHE[MODULE];
		if ( FILTER_COLUMN_LIST == null )
		{
			FILTER_COLUMN_LIST = await this.getReportingFilterColumns(sModule, sTableAlias);
			this.FILTER_COLUMN_LIST_CACHE[MODULE] = FILTER_COLUMN_LIST;
		}
		let FILTER_OPERATOR_LIST   : string[] = L10n.GetList(FILTER_OPERATOR_TYPE + '_operator_dom');
		if ( this.props.DesignWorkflow && !Sql.IsEmptyString(FILTER_COLUMN) && FILTER_COLUMN.indexOf('_AUDIT_OLD.') >= 0 )
		{
			FILTER_OPERATOR_LIST = ['changed', 'unchanged', 'increased', 'decreased', ...FILTER_OPERATOR_LIST];
		}
		this.setState(
		{
			FILTER_ID               ,
			FILTER_COLUMN_SOURCE    ,
			FILTER_COLUMN           ,
			FILTER_OPERATOR         ,
			FILTER_OPERATOR_TYPE    ,
			FILTER_SEARCH_ID        ,
			FILTER_SEARCH_DATA_TYPE ,
			FILTER_SEARCH_TEXT      ,
			FILTER_SEARCH_TEXT2     ,
			FILTER_SEARCH_START_DATE,
			FILTER_SEARCH_END_DATE  ,
			FILTER_SEARCH_LISTBOX   ,
			FILTER_SEARCH_DROPDOWN  ,
			ACTION_TYPE             ,
			RELATED                 ,
			CUSTOM_ACTIVITY_NAME    ,
			CUSTOM_COLUMN_NAME      ,
			filterXmlEditIndex      : index,
			FILTER_COLUMN_LIST      ,
			FILTER_OPERATOR_LIST    ,
		}, async () =>
		{
			this.BindSearchText();
		});
	}

	private _onFiltersRemove = async (index: number) =>
	{
		const { DisplayColumns } = this.props;
		let { MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml } = this.state;
		if ( filterXml && filterXml.Filters && filterXml.Filters.Filter && index < filterXml.Filters.Filter.length )
		{
			filterXml.Filters.Filter.splice(index, 1);
			let filterXmlJson = dumpObj(filterXml, 'filterXml').replace(/\n/g, '<br />\n').replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
			this.ResetSearchText();
			let oPreviewSQL : string = await this.getReportSQL(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml, DisplayColumns);
			let oPreviewXOML: string = await this.getWorkflowXOML(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml);
			this.setState(
			{
				oPreviewSQL ,
				oPreviewXOML,
			});
		}
	}

	private _onFiltersUpdate = async () =>
	{
		const { DisplayColumns } = this.props;
		const { MODULE, RELATED, FILTER_COLUMN_SOURCE, FILTER_COLUMN, FILTER_OPERATOR, FILTER_OPERATOR_TYPE, FILTER_SEARCH_MODE, FILTER_SEARCH_ID, FILTER_SEARCH_TEXT, FILTER_SEARCH_TEXT2, FILTER_SEARCH_DROPDOWN, FILTER_SEARCH_LISTBOX, FILTER_SEARCH_START_DATE, FILTER_SEARCH_END_DATE } = this.state;
		const { ACTION_TYPE, CUSTOM_ACTIVITY_NAME, CUSTOM_COLUMN_NAME } = this.state;

		let { filterXml, relatedModuleXml, relationshipXml, filterXmlEditIndex } = this.state;
		try
		{
			if ( !filterXml )
			{
				filterXml = {};
			}
			if ( !filterXml.Filters )
			{
				filterXml.Filters = {};
			}
			if ( !filterXml.Filters.Filter || !Array.isArray(filterXml.Filters.Filter) )
			{
				filterXml.Filters.Filter = [];
			}
			if ( filterXmlEditIndex == -1 )
			{
				filterXmlEditIndex = filterXml.Filters.Filter.length;
				filterXml.Filters.Filter.push({});
			}
			if ( filterXml.Filters.Filter[filterXmlEditIndex] )
			{
				let SEARCH_TEXT       : string = null;
				let SEARCH_TEXT_VALUES: string[] = [];
				switch ( FILTER_SEARCH_MODE )
				{
					case 'text':
						SEARCH_TEXT        = FILTER_SEARCH_TEXT;
						SEARCH_TEXT_VALUES.push(SEARCH_TEXT);
						break;
					case 'text2':
						SEARCH_TEXT_VALUES.push(FILTER_SEARCH_TEXT);
						SEARCH_TEXT_VALUES.push(FILTER_SEARCH_TEXT2);
						SEARCH_TEXT        = SEARCH_TEXT_VALUES.join(', ');
						break;
					case 'date':
						SEARCH_TEXT        = formatDate(FILTER_SEARCH_START_DATE, this.DATE_FORMAT);
						SEARCH_TEXT_VALUES.push(SEARCH_TEXT);
						break;
					case 'date2':
						SEARCH_TEXT_VALUES.push(formatDate(FILTER_SEARCH_START_DATE, this.DATE_FORMAT));
						SEARCH_TEXT_VALUES.push(formatDate(FILTER_SEARCH_END_DATE  , this.DATE_FORMAT));
						SEARCH_TEXT        = SEARCH_TEXT_VALUES.join(', ');
						break;
					case 'select':
						SEARCH_TEXT        = FILTER_SEARCH_ID + ', ' + FILTER_SEARCH_TEXT;
						SEARCH_TEXT_VALUES.push(FILTER_SEARCH_ID);
						SEARCH_TEXT_VALUES.push(FILTER_SEARCH_TEXT);
						break;
					case 'dropdown':
						SEARCH_TEXT        = FILTER_SEARCH_DROPDOWN;
						SEARCH_TEXT_VALUES.push(FILTER_SEARCH_DROPDOWN);
						break;
					case 'listbox':
						SEARCH_TEXT        = FILTER_SEARCH_LISTBOX.join(', ');
						SEARCH_TEXT_VALUES = FILTER_SEARCH_LISTBOX;
						break;
				}
				
				if ( filterXml.Filters.Filter[filterXmlEditIndex]['ID'] === undefined )
				{
					filterXml.Filters.Filter[filterXmlEditIndex]['ID'] = uuidFast();
				}
				filterXml.Filters.Filter[filterXmlEditIndex]['ACTION_TYPE'       ] = Sql.ToString(ACTION_TYPE         );
				if ( !Sql.IsEmptyString(RELATED) )
					filterXml.Filters.Filter[filterXmlEditIndex]['MODULE_NAME'       ] = Sql.ToString(RELATED);
				else
					filterXml.Filters.Filter[filterXmlEditIndex]['MODULE_NAME'       ] = Sql.ToString(FILTER_COLUMN_SOURCE);
				if ( StartsWith(ACTION_TYPE, 'custom') )
				{
					filterXml.Filters.Filter[filterXmlEditIndex]['RELATIONSHIP_NAME' ] = Sql.ToString(CUSTOM_ACTIVITY_NAME);
					filterXml.Filters.Filter[filterXmlEditIndex]['DATA_FIELD'        ] = Sql.ToString(CUSTOM_COLUMN_NAME  );
				}
				else
				{
					filterXml.Filters.Filter[filterXmlEditIndex]['RELATIONSHIP_NAME' ] = Sql.ToString(RELATED             );
					filterXml.Filters.Filter[filterXmlEditIndex]['DATA_FIELD'        ] = Sql.ToString(FILTER_COLUMN       );
				}
				filterXml.Filters.Filter[filterXmlEditIndex]['DATA_TYPE'         ] = Sql.ToString(FILTER_OPERATOR_TYPE);
				filterXml.Filters.Filter[filterXmlEditIndex]['OPERATOR'          ] = Sql.ToString(FILTER_OPERATOR     );
				filterXml.Filters.Filter[filterXmlEditIndex]['SEARCH_TEXT'       ] = SEARCH_TEXT       ;
				filterXml.Filters.Filter[filterXmlEditIndex]['SEARCH_TEXT_VALUES'] = SEARCH_TEXT_VALUES;
		
				let filterXmlJson = dumpObj(filterXml, 'filterXml').replace(/\n/g, '<br />\n').replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
				this.setState(
				{
					filterXml              ,
					filterXmlJson          ,
					filterXmlEditIndex     : -1,
				}, async () =>
				{
					this.ResetSearchText();
					let oPreviewSQL : string = await this.getReportSQL(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml, DisplayColumns);
					let oPreviewXOML: string = await this.getWorkflowXOML(MODULE, RELATED, filterXml, relatedModuleXml, relationshipXml);
					this.setState(
					{
						oPreviewSQL ,
						oPreviewXOML,
					});
					this.props.onChanged('filterXml'       , filterXml       , null, null);
				});
			}
			else
			{
				console.error((new Date()).toISOString() + ' ' + this.constructor.name + '._onFiltersUpdate invalid filterXmlEditIndex', filterXmlEditIndex);
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '._onFiltersUpdate', error);
			this.setState({ error });
		}
	}

	private _onFiltersCancel = () =>
	{
		this.ResetSearchText();
	}

	private _onRELATED_Change = async (event: React.ChangeEvent<HTMLSelectElement>) =>
	{
		const { MODULE } = this.state;
		let { filterXml } = this.state;
		let RELATED: string = event.target.value;
		this.setState(
		{
			RELATED,
		}, () =>
		{
			this.filterRelatedChanged(RELATED);
			this.props.onChanged('RELATED', RELATED, null, null);
			this.props.onChanged('filterXml'       , filterXml       , null, null);
		});
	}

	private _onACTION_TYPE_LIST_Change = (event: React.ChangeEvent<HTMLSelectElement>) =>
	{
		let ACTION_TYPE: string = event.target.value;
		this.setState(
		{
			ACTION_TYPE
		}, async () =>
		{
			this.ResetSearchText();
		});
	}

	private _onFILTER_COLUMN_SOURCE_LIST_Change = (event: React.ChangeEvent<HTMLSelectElement>) =>
	{
		let FILTER_COLUMN_SOURCE: string = event.target.value;
		this.setState({ FILTER_COLUMN_SOURCE });
		this.filterColumnSourceChanged(FILTER_COLUMN_SOURCE);
	}

	private _onFILTER_COLUMN_LIST_Change = (event: React.ChangeEvent<HTMLSelectElement>) =>
	{
		const { FILTER_COLUMN_SOURCE } = this.state;
		let FILTER_COLUMN: string = event.target.value;
		this.setState({ FILTER_COLUMN });
		this.filterColumnChanged(FILTER_COLUMN_SOURCE, FILTER_COLUMN);
	}

	private _onFILTER_OPERATOR_LIST_Change = (event: React.ChangeEvent<HTMLSelectElement>) =>
	{
		let FILTER_OPERATOR: string = event.target.value;
		this.setState({ FILTER_OPERATOR }, () =>
		{
			this.BindSearchText();
		});
	}

	private _onFILTER_SEARCH_TEXT_Change = (event) =>
	{
		let FILTER_SEARCH_TEXT: string = event.target.value;
		this.setState({ FILTER_SEARCH_TEXT });
	}

	private _onCUSTOM_ACTIVITY_NAME_Change = (event: React.ChangeEvent<HTMLInputElement>) =>
	{
		let CUSTOM_ACTIVITY_NAME: string = event.target.value;
		this.setState({ CUSTOM_ACTIVITY_NAME });
	}

	private _onCUSTOM_COLUMN_NAME_Change = (event: React.ChangeEvent<HTMLInputElement>) =>
	{
		let CUSTOM_COLUMN_NAME: string = event.target.value;
		this.setState({ CUSTOM_COLUMN_NAME });
	}

	private _onFILTER_SEARCH_TEXT2_Change = (event: React.ChangeEvent<HTMLInputElement>) =>
	{
		let FILTER_SEARCH_TEXT2: string = event.target.value;
		this.setState({ FILTER_SEARCH_TEXT2 }), () =>
		{
			this.BindSearchText();
		};
	}

	private _onFILTER_SEARCH_DROPDOWN_Change = (event: React.ChangeEvent<HTMLSelectElement>) =>
	{
		let FILTER_SEARCH_DROPDOWN: string = event.target.value;
		this.setState({ FILTER_SEARCH_DROPDOWN }, () =>
		{
			this.BindSearchText();
		});
	}

	private _onFILTER_SEARCH_LISTBOX_Change = (event: React.ChangeEvent<HTMLSelectElement>) =>
	{
		let FILTER_SEARCH_LISTBOX: string[] = [];
		let selectedOptions = event.target.selectedOptions;
		for (let i = 0; i < selectedOptions.length; i++)
		{
			FILTER_SEARCH_LISTBOX.push(selectedOptions[i].value);
		}
		this.setState({ FILTER_SEARCH_LISTBOX }, () =>
		{
			this.BindSearchText();
		});
	}

	private _onFILTER_SEARCH_START_DATE_Change = (value: moment.Moment | string) =>
	{
		try
		{
			let mntValue: moment.Moment = null;
			if ( typeof(value) == 'string' )
			{
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onChange string ' + DATA_FIELD, value);
				if ( Sql.IsEmptyString(value) )
				{
					// 11/17/2019 Paul.  Increment the reset index as clearing the control causes a NaN situation. 
					this.setState({ FILTER_SEARCH_START_DATE: null, error: null });
				}
				else
				{
					let bValidDateParts: boolean = ValidateDateParts(value, this.DATE_FORMAT);
					// 08/05/2019 Paul.  A moment will be valid, even with a single numeric value.  So require 3 parts. 
					mntValue = moment(value, this.DATE_FORMAT);
					if ( bValidDateParts && mntValue.isValid() )
					{
						let DATA_VALUE: Date   = mntValue.toDate();
						this.setState({ FILTER_SEARCH_START_DATE: formatDate(DATA_VALUE, this.DATE_FORMAT), error: null });
					}
					else
					{
						this.setState({ error: L10n.Term('.ERR_INVALID_DATE') });
					}
				}
			}
			else if ( value instanceof moment )
			{
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onChange moment ' + DATA_FIELD, value);
				mntValue = moment(value);
				if ( mntValue.isValid() )
				{
					let DATA_VALUE: Date   = mntValue.toDate();
					this.setState({ FILTER_SEARCH_START_DATE: formatDate(DATA_VALUE, this.DATE_FORMAT), error: null });
				}
				else
				{
					this.setState({ error: L10n.Term('.ERR_INVALID_DATE') });
				}
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '._onChange', error);
		}
	}

	private _onFILTER_SEARCH_END_DATE_Change = (value: moment.Moment | string) =>
	{
		try
		{
			let mntValue: moment.Moment = null;
			if ( typeof(value) == 'string' )
			{
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onChange string ' + DATA_FIELD, value);
				if ( Sql.IsEmptyString(value) )
				{
					// 11/17/2019 Paul.  Increment the reset index as clearing the control causes a NaN situation. 
					this.setState({ FILTER_SEARCH_END_DATE: null, error: null });
				}
				else
				{
					let bValidDateParts: boolean = ValidateDateParts(value, this.DATE_FORMAT);
					// 08/05/2019 Paul.  A moment will be valid, even with a single numeric value.  So require 3 parts. 
					mntValue = moment(value, this.DATE_FORMAT);
					if ( bValidDateParts && mntValue.isValid() )
					{
						let DATA_VALUE: Date   = mntValue.toDate();
						this.setState({ FILTER_SEARCH_END_DATE: formatDate(DATA_VALUE, this.DATE_FORMAT), error: null });
					}
					else
					{
						this.setState({ error: L10n.Term('.ERR_INVALID_DATE') });
					}
				}
			}
			else if ( value instanceof moment )
			{
				//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onChange moment ' + DATA_FIELD, value);
				mntValue = moment(value);
				if ( mntValue.isValid() )
				{
					let DATA_VALUE: Date   = mntValue.toDate();
					this.setState({ FILTER_SEARCH_END_DATE: formatDate(DATA_VALUE, this.DATE_FORMAT), error: null });
				}
				else
				{
					this.setState({ error: L10n.Term('.ERR_INVALID_DATE') });
				}
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '._onChange', error);
		}
	}

	private _onSearchPopup = (): void =>
	{
		this.setState({ popupOpen: true });
	}

	private _onSelectChange = (value: { Action: string, ID: string, NAME: string }) =>
	{
		if ( value.Action == 'SingleSelect' )
		{
			try
			{
				this.setState({ popupOpen: false, FILTER_SEARCH_ID: value.ID, FILTER_SEARCH_TEXT: value.NAME });
			}
			catch(error)
			{
				console.error((new Date()).toISOString() + ' ' + this.constructor.name + '._onChange', error);
			}
		}
		else if (value.Action == 'Close')
		{
			this.setState({ popupOpen: false });
		}
	}

	public render()
	{
		const { ShowRelated, ShowModule } = this.props;
		const { oPreviewSQL, oPreviewXOML, error } = this.state;
		const { filterXml, filterXmlJson } = this.state;
		const { MODULE, RELATED, SHOW_XOML, MODULES_LIST, RELATED_LIST, FILTER_COLUMN_SOURCE_LIST, FILTER_COLUMN_LIST, FILTER_OPERATOR_LIST } = this.state;
		const { popupOpen, FILTER_COLUMN_SOURCE, FILTER_COLUMN, FILTER_OPERATOR, FILTER_OPERATOR_TYPE, FILTER_SEARCH_ID, FILTER_SEARCH_DATA_TYPE, FILTER_SEARCH_TEXT, FILTER_SEARCH_TEXT2, FILTER_SEARCH_START_DATE, FILTER_SEARCH_END_DATE, FILTER_SEARCH_MODULE_TYPE } = this.state;
		const { FILTER_SEARCH_LIST_NAME, FILTER_SEARCH_DROPDOWN_LIST, FILTER_SEARCH_LISTBOX_LIST, FILTER_SEARCH_DROPDOWN, FILTER_SEARCH_LISTBOX, FILTER_SEARCH_MODE, FILTER_ID } = this.state;
		const { ACTION_TYPE_LIST, ACTION_TYPE, CUSTOM_ACTIVITY_NAME, CUSTOM_COLUMN_NAME } = this.state;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render', oReportDesign);
		try
		{
			let inputProps: any =
			{
				type        : 'text', 
				autoComplete: 'off',
				style       : {flex: '2 0 70%', width: '100%', minWidth: '100px'},
				disabled    : false,
				className   : null,  /* 12/10/2019 Paul.  Prevent the default form-control. */
			};
			return (
<div id='divXomlBuilder'>
	<ErrorComponent error={error} />
	<DynamicPopupView
		isOpen={ popupOpen }
		isSearchView={ false }
		fromLayoutName={ '.PopupView' }
		callback={ this._onSelectChange }
		MODULE_NAME={ FILTER_SEARCH_MODULE_TYPE }
	/>
	<table className="tabForm" cellSpacing={ 1 } cellPadding={ 0 } style={ {width: '100%', borderWidth: '0px'} }>
		<tr>
			<td>
				<table cellSpacing={ 0 } cellPadding={ 0 } style={ {borderWidth: '0px', borderCollapse: 'collapse'} }>
					<tr>
						<td className="dataLabel" style={ {width: '15%'} }>
							{ L10n.Term("WorkflowActionShells.LBL_SHOW_XOML") }
						</td>
						<td className="dataField" style={ {width: '35%'} }>
							<span className="checkbox">
								<input id="ctlXomlBuilder_chkSHOW_XOML" type="checkbox" checked={ SHOW_XOML } onChange={ this._onChange_SHOW_XOML } />
							</span>
						</td>
						<td className="dataLabel" style={ {width: '15%'} }>
						</td>
						<td className="dataField" style={ {width: '35%'} }>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td style={{ paddingTop: '5px', paddingBottom: '5px'} }>
				<table id='ctlXomlBuilder_dgFilters' cellSpacing={ 0 } cellPadding={ 3 } style={ {borderCollapse: 'collapse', border: '1px solid black', width: '100%'} }>
					<tr>
						<td style={ {border: '1px solid black'} }>{ L10n.Term('WorkflowAlertShells.LBL_LIST_ACTION_TYPE'      ) }</td>
						<td style={ {border: '1px solid black'} }>{ L10n.Term('WorkflowAlertShells.LBL_LIST_RELATIONSHIP_NAME') }</td>
						<td style={ {border: '1px solid black'} }>{ L10n.Term('WorkflowAlertShells.LBL_LIST_MODULE_NAME'      ) }</td>
						<td style={ {border: '1px solid black'} }>{ L10n.Term('WorkflowAlertShells.LBL_LIST_DATA_FIELD'       ) }</td>
						<td style={ {border: '1px solid black'} }>{ L10n.Term('WorkflowAlertShells.LBL_LIST_DATA_TYPE'        ) }</td>
						<td style={ {border: '1px solid black'} }>{ L10n.Term('WorkflowAlertShells.LBL_LIST_OPERATOR'         ) }</td>
						<td style={ {border: '1px solid black'} }>{ L10n.Term('WorkflowAlertShells.LBL_LIST_SEARCH_TEXT'      ) }</td>
						<td style={ {border: '1px solid black'} }>&nbsp;</td>
					</tr>
				{ filterXml && filterXml.Filters && filterXml.Filters.Filter && Array.isArray(filterXml.Filters.Filter)
				? filterXml.Filters.Filter.map((item, index) => 
				{ return (
					<tr>
						<td style={ {border: '1px solid black'} }>{ Sql.ToString(item["ACTION_TYPE"      ]) }</td>
						<td style={ {border: '1px solid black'} }>{ Sql.ToString(item["RELATIONSHIP_NAME"]) }</td>
						<td style={ {border: '1px solid black'} }>{ Sql.ToString(item["MODULE_NAME"      ]) }</td>
						<td style={ {border: '1px solid black'} }>{ Sql.ToString(item["DATA_FIELD"       ]) }</td>
						<td style={ {border: '1px solid black'} }>{ Sql.ToString(item["DATA_TYPE"        ]) }</td>
						<td style={ {border: '1px solid black'} }>{ Sql.ToString(item["OPERATOR"         ]) }</td>
						<td style={ {border: '1px solid black'} }>{ Sql.ToString(item["SEARCH_TEXT"      ]) }</td>
						<td style={ {border: '1px solid black', width: '1%', whiteSpace: 'nowrap'} } align='left'>
							<input type='submit' className='button' value={ L10n.Term('.LBL_EDIT_BUTTON_LABEL'         ) } title={ L10n.Term('.LBL_EDIT_BUTTON_LABEL'         ) } onClick={ (e) => this._onFiltersEdit(index) } />
							&nbsp;
							<input type='submit' className='button' value={ L10n.Term('Reports.LBL_REMOVE_BUTTON_LABEL') } title={ L10n.Term('Reports.LBL_REMOVE_BUTTON_LABEL') } onClick={ (e) => this._onFiltersRemove(index) } />
						</td>
					</tr>);
				})
				: null
				}
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table className="tabEditView" style={ {borderWidth: '0px'} }>
					<tr>
						<td valign="top">
							<select
								id="ctlXomlBuilder_lstACTION_TYPE"
								tabIndex={ 10 }
								value={ ACTION_TYPE }
								onChange={ this._onACTION_TYPE_LIST_Change }
							>
							{ ACTION_TYPE_LIST
							? ACTION_TYPE_LIST.map((item, index) => 
							{ return (
								<option key={ 'ctlXomlBuilder_lstACTION_TYPE_' + item.NAME } value={ item.NAME }>{ item.DISPLAY_NAME }</option>);
							})
							: null
							}
							</select><br />
							<span id="ctlXomlBuilder_lblFILTER_COLUMN_SOURCE">{ FILTER_COLUMN_SOURCE }</span>
						</td>
						<td valign="top">
							{ !StartsWith(ACTION_TYPE, 'custom')
							? <select
								id="ctlQueryBuilder_lstRELATED"
								tabIndex={ 3 }
								value={ RELATED }
								onChange={ this._onRELATED_Change }
							>
							{ ACTION_TYPE == 'update'
							?	<option key='ctlQueryBuilder_lstRELATED_None' value=''>{ L10n.Term('.LBL_NONE') }</option>
							: null
							}
							{ RELATED_LIST && ACTION_TYPE != 'update'
							? RELATED_LIST.map((item, index) => 
							{ return (
								<option key={ 'ctlQueryBuilder_lstRELATED_' + item.MODULE_NAME } value={ item.MODULE_NAME }>{ item.DISPLAY_NAME }</option>);
							})
							: null
							}
							</select>
							: null
							}
							{ ACTION_TYPE == 'custom_prop' || ACTION_TYPE == 'custom_method'
							? <input type="text" id="ctlXomlBuilder_txtCUSTOM_ACTIVITY_NAME" value={ CUSTOM_ACTIVITY_NAME } onChange={ this._onCUSTOM_ACTIVITY_NAME_Change } />
							: null
							}
							<span id="ctlQueryBuilder_lblRELATED">{ RELATED }</span>
						</td>
						<td valign="top" style={ {display: 'none'} }>
							<select
								id="ctlXomlBuilder_lstFILTER_COLUMN_SOURCE"
								tabIndex={ 10 }
								value={ FILTER_COLUMN_SOURCE }
								onChange={ this._onFILTER_COLUMN_SOURCE_LIST_Change }
							>
							{ FILTER_COLUMN_SOURCE_LIST
							? FILTER_COLUMN_SOURCE_LIST.map((item, index) => 
							{ return (
								<option key={ 'ctlXomlBuilder_lstFILTER_COLUMN_SOURCE_' + item.MODULE_NAME } value={ item.MODULE_NAME }>{ item.DISPLAY_NAME }</option>);
							})
							: null
							}
							</select>
							<br />
							<span id="ctlXomlBuilder_lblFILTER_COLUMN_SOURCE">{ FILTER_COLUMN_SOURCE }</span>
						</td>
						<td valign="top">
							{ !StartsWith(ACTION_TYPE, 'custom')
							? <select
								id="ctlXomlBuilder_lstFILTER_COLUMN"
								tabIndex={ 11 }
								value={ FILTER_COLUMN }
								onChange={ this._onFILTER_COLUMN_LIST_Change }
							>
							{ FILTER_COLUMN_LIST
							? FILTER_COLUMN_LIST.map((item, index) => 
							{ return (
								<option key={ 'ctlXomlBuilder_lstFILTER_COLUMN_' + item.NAME } value={ item.NAME }>{ item.DISPLAY_NAME }</option>);
							})
							: null
							}
							</select>
							: null
							}
							{ StartsWith(ACTION_TYPE, 'custom')
							? <input type="text" id="ctlXomlBuilder_txtCUSTOM_COLUMN_NAME" value={ CUSTOM_COLUMN_NAME } onChange={ this._onCUSTOM_COLUMN_NAME_Change } />
							: null
							}
							<br />
							<span id="ctlXomlBuilder_lblFILTER_COLUMN">{ FILTER_COLUMN }</span>
						</td>
						<td valign="top">
							<select
								id="ctlXomlBuilder_lstFILTER_OPERATOR"
								tabIndex={ 12 }
								value={ FILTER_OPERATOR }
								onChange={ this._onFILTER_OPERATOR_LIST_Change }
								disabled={ FILTER_OPERATOR_TYPE != 'enum' }
							>
							{ FILTER_OPERATOR_LIST
							? FILTER_OPERATOR_LIST.map((item, index) => 
							{ return (
								<option key={ 'ctlXomlBuilder_lstFILTER_OPERATOR_' + item } value={ item }>{ L10n.ListTerm(this.filterOperatorListName(item, FILTER_OPERATOR_TYPE), item) }</option>);
							})
							: null
							}
							</select>
							<div>
								<span id="ctlXomlBuilder_lblFILTER_OPERATOR_TYPE">{ FILTER_OPERATOR_TYPE }</span>
								<img src={ this.themeURL + "images/spacer.gif" } style={ {borderWidth: '0px', width: '4px'} } />
								<span id="ctlXomlBuilder_lblFILTER_OPERATOR">{ FILTER_OPERATOR }</span>
							</div>
							{ FILTER_OPERATOR == 'enum'
							? <div>{ FILTER_SEARCH_LIST_NAME }</div>
							: null
							}
						</td>
						<td valign="top" style={ {whiteSpace: 'nowrap'} }>
							<table cellSpacing={ 0 } cellPadding={ 0 } style={ {borderWidth: '0px', borderCollapse: 'collapse'} }>
								<tr>
									<td valign="top">
										{ FILTER_SEARCH_MODE == 'text'
										? <textarea id="ctlXomlBuilder_txtFILTER_SEARCH_TEXTAREA" rows={ 2 } value={ FILTER_SEARCH_TEXT } onChange={ this._onFILTER_SEARCH_TEXT_Change } style={ {width: '200px'} } />
										: null
										}
										{ FILTER_SEARCH_MODE == 'text2' || FILTER_SEARCH_MODE == 'select'
										? <input type="text" id="ctlXomlBuilder_txtFILTER_SEARCH_TEXT" value={ FILTER_SEARCH_TEXT } readOnly={ FILTER_SEARCH_MODE == 'select' } onChange={ this._onFILTER_SEARCH_TEXT_Change } />
										: null
										}
										{ FILTER_SEARCH_MODE == 'dropdown'
										? <div>
											<select
												id="lstFILTER_SEARCH_DROPDOWN"
												value={ FILTER_SEARCH_DROPDOWN }
												onChange={ this._onFILTER_SEARCH_DROPDOWN_Change }
											>
											{ FILTER_SEARCH_DROPDOWN_LIST
											? FILTER_SEARCH_DROPDOWN_LIST.map((item, index) => 
											{ return (
												<option key={ 'ctlXomlBuilder_lstFILTER_SEARCH_DROPDOWN_' + item } value={ item }>{ L10n.ListTerm(FILTER_SEARCH_LIST_NAME, item) }</option>);
											})
											: null
											}
											</select><br />
											<div id="ctlXomlBuilder_lblFILTER_SEARCH_DROPDOWN">{ FILTER_SEARCH_DROPDOWN }</div>
										</div>
										: null
										}
										{ FILTER_SEARCH_MODE == 'listbox'
										? <div>
											<select
												id="lstFILTER_SEARCH_LISTBOX"
												multiple={ true }
												size={ 4 }
												value={ FILTER_SEARCH_LISTBOX }
												onChange={ this._onFILTER_SEARCH_LISTBOX_Change }
											>
											{ FILTER_SEARCH_LISTBOX_LIST
											? FILTER_SEARCH_LISTBOX_LIST.map((item, index) => 
											{ return (
												<option key={ 'ctlXomlBuilder_lstFILTER_SEARCH_LISTBOX_' + item } value={ item }>{ L10n.ListTerm(FILTER_SEARCH_LIST_NAME, item) }</option>);
											})
											: null
											}
											</select><br />
											<div id="ctlXomlBuilder_lblFILTER_SEARCH_LISTBOX">{ FILTER_SEARCH_LISTBOX }</div>
										</div>
										: null
										}
										{ FILTER_SEARCH_MODE == 'date' || FILTER_SEARCH_MODE == 'date2'
										? <DateTime
											value={ FILTER_SEARCH_START_DATE != null ? moment(FILTER_SEARCH_START_DATE) : null }
											viewDate={ FILTER_SEARCH_START_DATE != null ? moment(FILTER_SEARCH_START_DATE) : null }
											onChange={ this._onFILTER_SEARCH_START_DATE_Change }
											dateFormat={ this.DATE_FORMAT }
											timeFormat={ false }
											input={ true }
											closeOnSelect={ true }
											strictParsing={ true }
											inputProps={ inputProps }
											locale={ Security.USER_LANG().substring(0, 2) }
										/>
										: null
										}
									</td>
									{ FILTER_SEARCH_MODE == 'text2' || FILTER_SEARCH_MODE == 'date2'
									? <td valign="top">
										<span style={ {paddingLeft: '4px', paddingRight: '4px', paddingTop: '8px'} }>{ L10n.Term('Schedulers.LBL_AND') }</span>
									</td>
									: null
									}
									<td valign="top">
										{ FILTER_SEARCH_MODE == 'text2'
										? <input type="text" id="ctlXomlBuilder_txtFILTER_SEARCH_TEXT2" value={ FILTER_SEARCH_TEXT2 } onChange={ this._onFILTER_SEARCH_TEXT2_Change } />
										: null
										}
										{ FILTER_SEARCH_MODE == 'date2'
										? <DateTime
											value={ FILTER_SEARCH_END_DATE != null ? moment(FILTER_SEARCH_END_DATE) : null }
											viewDate={ FILTER_SEARCH_END_DATE != null ? moment(FILTER_SEARCH_END_DATE) : null }
											onChange={ this._onFILTER_SEARCH_END_DATE_Change }
											dateFormat={ this.DATE_FORMAT }
											timeFormat={ false }
											input={ true }
											closeOnSelect={ true }
											strictParsing={ true }
											inputProps={ inputProps }
											locale={ Security.USER_LANG().substring(0, 2) }
										/>
										: null
										}
										{ FILTER_SEARCH_MODE == 'select'
										? <input type='submit'
											className='button'
											value={ L10n.Term('.LBL_SELECT_BUTTON_LABEL') }
											title={ L10n.Term('.LBL_SELECT_BUTTON_TITLE') }
											onClick={ (e) => this._onSearchPopup() }
											style={ {marginLeft: '4px'} }
										/>
										: null
										}
									</td>
								</tr>
							</table>
							<div id="ctlXomlBuilder_lblFILTER_SEARCH_MODE">{ FILTER_SEARCH_MODE }</div>
							<div id="ctlXomlBuilder_lblFILTER_ID">{ FILTER_ID }</div>
						</td>
						<td valign="top">
							<input type='submit' value={ L10n.Term('.LBL_UPDATE_BUTTON_LABEL') } title={ L10n.Term('.LBL_UPDATE_BUTTON_TITLE') } className='button' onClick={ this._onFiltersUpdate } />
						</td>
						<td valign="top">
							<input type='submit' value={ L10n.Term('.LBL_CANCEL_BUTTON_LABEL') } title={ L10n.Term('.LBL_CANCEL_BUTTON_TITLE') } className='button' onClick={ this._onFiltersCancel } />
						</td>
						<td style={ {width: '80%'} }></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	{ SHOW_XOML
	? <React.Fragment>
		<br />
		<table cellPadding={ 3 } cellSpacing={ 0 } style={ {width: '100%', backgroundColor: 'LightGrey', border: '1px solid black', marginBottom: '4px'} }>
			<tr>
				<td>
					<pre style={ {whiteSpace: 'pre-wrap'} }><b>{ oPreviewSQL }</b></pre>
				</td>
			</tr>
		</table>
		<DumpXOML XOML={ oPreviewXOML} default_xoml={ true } />
	</React.Fragment>
	: null
	}
	{ bDebug && SHOW_XOML
	? <div>
		<div id='divFilterXmlDump' dangerouslySetInnerHTML={ {__html: filterXmlJson } } style={ {marginTop: '20px', border: '1px solid black'} }></div>
	</div>
	: null
	}
</div>
			);
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.render', error);
			return (<span>{ error.message }</span>);
		}
	}
}

