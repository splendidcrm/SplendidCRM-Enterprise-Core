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
import { RouteComponentProps, withRouter } from 'react-router-dom';
// 2. Store and Types. 
import { IDetailComponentProps, IDetailComponentState, DetailComponent } from '../types/DetailComponent';
// 3. Scripts. 
import Sql                                 from '../scripts/Sql'                ;
import L10n                                from '../scripts/L10n'               ;
import { Crm_Modules }                     from '../scripts/Crm'                ;
import { StartsWith }                      from '../scripts/utility'            ;
// 4. Components and Views. 

interface IHyperLinkProps extends RouteComponentProps<any>
{
	baseId        : string;
	row           : any;
	layout        : any;
	ERASED_FIELDS : string[];
	Page_Command? : Function;
	fieldDidMount?: (DATA_FIELD: string, component: any) => void;
	// 11/02/2019 Paul.  Hidden property is used to dynamically hide and show layout fields. 
	bIsHidden?    : boolean;
}

interface IModuleLinkState
{
	ID           : string;
	FIELD_INDEX  : number;
	DATA_FIELD   : string;
	DATA_VALUE   : string;
	DATA_LABEL   : string;
	DATA_FORMAT  : string;
	URL_FORMAT   : string;
	URL_FIELD    : string;
	URL_VALUE    : string;
	MODULE_NAME  : string;
	URL          : string;
	DISPLAY_NAME : string;
	MODULE_TYPE  : string;
	ERASED       : boolean;
	CSS_CLASS?   : string;
}

class ModuleLink extends React.Component<IHyperLinkProps, IModuleLinkState>
{
	public updateDependancy(PARENT_FIELD: string, DATA_VALUE: any, PROPERTY_NAME?: string, item?: any): void
	{
		if ( Sql.IsEmptyString(PROPERTY_NAME) || PROPERTY_NAME == 'value' )
		{
			this.setState({ DATA_VALUE });
		}
		else if ( PROPERTY_NAME == 'class' )
		{
			this.setState({ CSS_CLASS: DATA_VALUE });
		}
	}

	constructor(props: IHyperLinkProps)
	{
		super(props);
		let FIELD_INDEX      : number = 0;
		let DATA_FIELD       : string = '';
		let DATA_VALUE       : string = '';
		let DATA_LABEL       : string = '';
		let DATA_FORMAT      : string = '';
		let URL_FORMAT       : string = '';
		let URL_FIELD        : string = '';
		let URL_VALUE        : string = '';
		let MODULE_NAME      : string = '';
		let URL              : string = '#';
		let DISPLAY_NAME     : string = '';
		let MODULE_TYPE      : string = '';
		let ERASED           : boolean = false;

		let ID: string = null;
		try
		{
			const { baseId, layout, row } = this.props;
			if ( layout != null )
			{
				FIELD_INDEX       = Sql.ToInteger(layout.FIELD_INDEX);
				DATA_FIELD        = Sql.ToString (layout.DATA_FIELD );
				DATA_LABEL        = Sql.ToString (layout.DATA_LABEL );
				DATA_FORMAT       = Sql.ToString (layout.DATA_FORMAT);
				URL_FORMAT        = Sql.ToString (layout.URL_FORMAT );
				URL_FIELD         = Sql.ToString (layout.URL_FIELD  );
				MODULE_NAME       = Sql.ToString (layout.MODULE_NAME);
				MODULE_TYPE       = Sql.ToString (layout.MODULE_TYPE);
				// 12/24/2012 Paul.  Use regex global replace flag. 
				ID = baseId + '_' + DATA_FIELD.replace(/\s/g, '_');
				
				if ( row != null )
				{
					// 06/18/2018 Paul.  Don't convert to string here as the old code is using undefined in its checks. 
					DATA_VALUE = row[DATA_FIELD];
					URL_VALUE = Sql.ToString(row[URL_FIELD]);
					if ( StartsWith(URL_FORMAT, 'mailto:') && !Sql.IsEmptyString(URL_VALUE) )
					{
						URL = URL_FORMAT.replace('{0}', URL_VALUE);
					}
					// 07/01/2018 Paul.  Value may have been erased. If so, replace with Erased Value message. 
					if ( DATA_VALUE == null && props.ERASED_FIELDS.indexOf(DATA_FIELD) >= 0 )
					{
						ERASED = true;
					}
					// 10/25/2012 Paul.  On the Surface, there are fields that we need to lookup, like ACCOUNT_NAME. 
					if ( !ERASED && (DATA_VALUE != null || DATA_VALUE === undefined) && MODULE_TYPE != null )
					{
						let a = null;
						if ( URL_FORMAT.substr(0, 2) == '~/' )
						{
							let URL_MODULE_NAME = MODULE_TYPE;
							if ( URL_MODULE_NAME == 'Parents' )
							{
								URL_MODULE_NAME = row[DATA_LABEL];
							}
							MODULE_NAME = URL_MODULE_NAME;
							// 01/30/2013 Paul.  We need to be able to execute code after loading a DetailView. 
							//oDetailViewUI.Load(sLayoutPanel, sActionsPanel, MODULE_NAME, ID, function(status, message)
							URL = '/' + URL_MODULE_NAME + '/View/' + URL_VALUE;
						}
					}
				}
			}
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor ' + DATA_FIELD, DATA_VALUE, row);
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.constructor', error);
		}
		this.state =
		{
			ID          ,
			FIELD_INDEX ,
			DATA_FIELD  ,
			DATA_VALUE  ,
			DATA_LABEL  ,
			DATA_FORMAT ,
			URL_FORMAT  ,
			URL_FIELD   ,
			URL_VALUE   ,
			MODULE_NAME ,
			URL         ,
			DISPLAY_NAME,
			MODULE_TYPE ,
			ERASED      ,
		};
	}

	async componentDidMount()
	{
		const { DATA_FIELD, DATA_VALUE, DATA_FORMAT, URL_FORMAT, URL_VALUE, MODULE_NAME, MODULE_TYPE, ERASED } = this.state;
		// 10/25/2012 Paul.  On the Surface, there are fields that we need to lookup, like ACCOUNT_NAME. 
		// 07/01/2018 Paul.  Value may have been erased. If so, replace with Erased Value message. 
		if ( !ERASED && (DATA_VALUE != null || DATA_VALUE === undefined) && !Sql.IsEmptyString(MODULE_TYPE) )
		{
			// 10/25/2012 Paul.  On the Surface, there are fields that we need to lookup, like ACCOUNT_NAME. 
			if ( DATA_VALUE === undefined && !Sql.IsEmptyString(URL_VALUE) )
			{
				try
				{
					let value = await Crm_Modules.ItemName(MODULE_NAME, URL_VALUE);
					let DISPLAY_NAME: string = '';
					if ( Sql.IsEmptyString(DATA_FORMAT) )
					{
						DISPLAY_NAME = value;
					}
					else
					{
						DISPLAY_NAME = DATA_FORMAT.replace('{0}', value);
					}
					this.setState({ DISPLAY_NAME });
				}
				catch(error)
				{
					console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
					// 05/20/2018 Paul.  When an error is encountered, we display the error in the name. 
					// 11/17/2021 Paul.  Must use message text and not error object. 
					this.setState({ DISPLAY_NAME: error.message });
				}
			}
			if ( this.props.fieldDidMount )
			{
				this.props.fieldDidMount(DATA_FIELD, this);
			}
		}
	}

	shouldComponentUpdate(nextProps: IHyperLinkProps, nextState: IModuleLinkState)
	{
		const { DATA_FIELD, DATA_VALUE, DISPLAY_NAME } = this.state;
		if ( nextProps.row != this.props.row )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, DATA_VALUE, nextProps, nextState);
			return true;
		}
		else if ( nextProps.layout != this.props.layout )
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, DATA_VALUE, nextProps, nextState);
			return true;
		}
		// 11/02/2019 Paul.  Hidden property is used to dynamically hide and show layout fields. 
		else if ( nextProps.bIsHidden != this.props.bIsHidden )
		{
			//console.log((new Date()).toISOString() + ' ' + 'TextBox.shouldComponentUpdate ' + DATA_FIELD, DATA_VALUE, nextProps, nextState);
			return true;
		}
		else if ( nextState.DATA_VALUE != this.state.DATA_VALUE)
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, DATA_VALUE, nextProps, nextState);
			return true;
		}
		else if ( nextState.DISPLAY_NAME != this.state.DISPLAY_NAME)
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, DISPLAY_NAME, nextProps, nextState);
			return true;
		}
		else if ( nextState.CSS_CLASS != this.state.CSS_CLASS)
		{
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, CSS_CLASS, nextProps, nextState);
			return true;
		}
		return false;
	}

	public render()
	{
		const { baseId, layout, row } = this.props;
		const { ID, FIELD_INDEX, DATA_FIELD, URL, DISPLAY_NAME, ERASED, CSS_CLASS } = this.state;
		
		if ( layout == null )
		{
			return (<span>layout prop is null</span>);
		}
		else if ( Sql.IsEmptyString(DATA_FIELD) )
		{
			return (<span>DATA_FIELD is empty for ModuleLink FIELD_INDEX { FIELD_INDEX }</span>);
		}
		else if ( row == null )
		{
			return (<span>row is null for ModuleLink DATA_FIELD { DATA_FIELD }</span>);
		}
		// 11/02/2019 Paul.  Hidden property is used to dynamically hide and show layout fields. 
		else if ( layout.hidden )
		{
			return (<span></span>);
		}
		else if ( ERASED )
		{
			return (<span className="Erased">{ L10n.Term('DataPrivacy.LBL_ERASED_VALUE') }</span>);
		}
		else
		{
			let url = URL;
			// 10/15/2021 Paul.  Correct StartsWith call. 
			if ( !StartsWith(URL, 'http') && !StartsWith(URL, '/') )
				url = '/' + url;
			if ( !StartsWith(URL, '/') )
			{
				return (
					<span>
						<a id={ ID } key={ ID } href={ url }>{ DISPLAY_NAME }</a>
					</span>
				);
			}
			else
			{
				// 07/09/2019 Paul.  Use span instead of a tag to prevent navigation. 
				return (
					<span id={ ID } key={ ID } onClick={ () => this.props.history.push(url) } className={ CSS_CLASS } style={ {cursor: 'pointer'} }>{ DISPLAY_NAME }</span>
				);
			}
		}
	}
}

export default withRouter(ModuleLink);
