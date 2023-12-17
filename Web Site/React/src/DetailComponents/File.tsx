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
// 2. Store and Types. 
import { IDetailComponentProps, IDetailComponentState, DetailComponent } from '../types/DetailComponent';
// 3. Scripts. 
import Sql                   from '../scripts/Sql'                ;
import Credentials           from '../scripts/Credentials'        ;
import { Crm_Modules }       from '../scripts/Crm'                ;
// 4. Components and Views. 

interface IFileState
{
	ID          : string;
	FIELD_INDEX : number;
	DATA_FIELD  : string;
	DATA_VALUE  : string;
	DISPLAY_NAME: string;
	URL         : string;
	CSS_CLASS?  : string;
}

export default class SplendidFile extends React.Component<IDetailComponentProps, IFileState>
{
	public updateDependancy(PARENT_FIELD: string, DATA_VALUE: any, PROPERTY_NAME?: string, item?: any): void
	{
		if ( PROPERTY_NAME == 'class' )
		{
			this.setState({ CSS_CLASS: DATA_VALUE });
		}
	}

	constructor(props: IDetailComponentProps)
	{
		super(props);
		let FIELD_INDEX      : number = 0;
		let DATA_FIELD       : string = '';
		let DATA_VALUE       : string = '';
		let URL              : string = '';

		let ID: string = null;
		try
		{
			const { baseId, layout, row } = this.props;
			if ( layout != null )
			{
				FIELD_INDEX       = Sql.ToInteger(layout.FIELD_INDEX);
				DATA_FIELD        = Sql.ToString (layout.DATA_FIELD );
				// 12/24/2012 Paul.  Use regex global replace flag. 
				ID = baseId + '_' + DATA_FIELD.replace(/\s/g, '_');
				
				if ( row != null )
				{
					DATA_VALUE = Sql.ToString(row[DATA_FIELD]);
					if ( !Sql.IsEmptyString(DATA_VALUE) )
					{
						URL = Credentials.RemoteServer + 'Images/Image.aspx?ID=' + DATA_VALUE;
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
			DISPLAY_NAME: DATA_VALUE,
			URL         ,
		};
	}

	async componentDidMount()
	{
		const { DATA_FIELD, DATA_VALUE } = this.state;
		try
		{
			// 08/09/2019 Paul.  No need to get the name if the value is null. 
			if ( !Sql.IsEmptyString(DATA_VALUE) )
			{
				let value = await Crm_Modules.ItemName('Images', DATA_VALUE);
				this.setState({ DISPLAY_NAME: value });
			}
			if ( this.props.fieldDidMount )
			{
				this.props.fieldDidMount(DATA_FIELD, this);
			}
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			// 05/20/2018 Paul.  When an error is encountered, we display the error in the name. 
			// 11/17/2021 Paul.  Must use message text and not error object. 
			this.setState({ DISPLAY_NAME: error.message });
		}
	}

	shouldComponentUpdate(nextProps: IDetailComponentProps, nextState: IFileState)
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
			//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.shouldComponentUpdate ' + DATA_FIELD, DATA_VALUE, nextProps, nextState);
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
		const { ID, FIELD_INDEX, DATA_FIELD, DATA_VALUE, DISPLAY_NAME, URL, CSS_CLASS } = this.state;
		if ( layout == null )
		{
			return (<span>layout prop is null</span>);
		}
		else if ( Sql.IsEmptyString(DATA_FIELD) )
		{
			return (<span>DATA_FIELD is empty for Button FIELD_INDEX { FIELD_INDEX }</span>);
		}
		else if ( row == null )
		{
			return (<span>row is null for Button DATA_FIELD { DATA_FIELD }</span>);
		}
		// 11/02/2019 Paul.  Hidden property is used to dynamically hide and show layout fields. 
		else if ( layout.hidden )
		{
			return (<span></span>);
		}
		else if ( !Sql.IsEmptyString(DATA_VALUE) )
		{
			return (<a id={ ID } key={ ID } href={ URL } className={ CSS_CLASS }>{ DISPLAY_NAME }</a>);
		}
		else
		{
			return null;
		}
	}
}

