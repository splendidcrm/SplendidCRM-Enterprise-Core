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
import React from 'react';
import qs from 'query-string';
import { RouteComponentProps, withRouter }            from '../Router5'                     ;
import { observer }                                   from 'mobx-react'                           ;
import { FontAwesomeIcon }                            from '@fortawesome/react-fontawesome'       ;
// 2. Store and Types. 
import { HeaderButtons }                              from '../types/HeaderButtons'               ;
// 3. Scripts. 
import Sql                                            from '../scripts/Sql'                       ;
import L10n                                           from '../scripts/L10n'                      ;
import Credentials                                    from '../scripts/Credentials'               ;
import SplendidCache                                  from '../scripts/SplendidCache'             ;
import { AuthenticatedMethod, LoginRedirect }         from '../scripts/Login'                     ;
import { DetailView_LoadItem }                        from '../scripts/DetailView'                ;
import { DeleteModuleItem }                           from '../scripts/ModuleUpdate'              ;
import { CreateSplendidRequest, GetSplendidResult }   from '../scripts/SplendidRequest'           ;
import { jsonReactState }                             from '../scripts/Application'               ;
import withScreenSizeHook                             from '../scripts/ScreenSizeHook'            ;
// 4. Components and Views. 
import ErrorComponent                                 from '../components/ErrorComponent'         ;
import DumpSQL                                        from '../components/DumpSQL'                ;
import HeaderButtonsFactory                           from '../ThemeComponents/HeaderButtonsFactory';

let MODULE_NAME: string = 'Reports';

interface IReportAttachmentViewProps extends RouteComponentProps<any>
{
	ID?           : string;
	NAME?         : string;
	PARENT_NAME?  : string;
	PARENT_ID?    : string;
	ReportDesign? : any;
	screenSize?   : any;
}

interface IReportAttachmentViewState
{
	__sql           : string;
	item            : any;
	SUB_TITLE       : any;
	error           : any;
}

export default class ReportAttachmentView extends React.Component<IReportAttachmentViewProps, IReportAttachmentViewState>
{
	private _isMounted     : boolean = false;

	constructor(props: IReportAttachmentViewProps)
	{
		super(props);
		this.state =
		{
			__sql           : null,
			item            : null,
			SUB_TITLE       : null,
			error           : null,
		};
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidMount()
	{
		const { ID } = this.props;
		this._isMounted = true;
		try
		{
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
			if ( status == 1 )
			{
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

	async componentDidUpdate(prevProps: IReportAttachmentViewProps)
	{
		// 04/28/2019 Paul.  Include pathname in filter to prevent double-bounce when state changes. 
		if ( this.props.location.pathname != prevProps.location.pathname )
		{
			// 04/26/2019 Paul.  Bounce through ResetView so that layout gets completely reloaded. 
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
		const { ID } = this.props;
		try
		{
			let queryParams: any = qs.parse(location.search);
			queryParams.ID = ID;

			let sBody: string = JSON.stringify(queryParams);
			let sUrl : string = 'ReportDesigner/Rest.svc/SendAsAttachment';
			let res = await CreateSplendidRequest(sUrl, 'POST', 'application/octet-stream', sBody);
			let json = await GetSplendidResult(res);
			let sNOTE_ID: string = json.d;
			this.props.history.push(`/Reset/Emails/Edit?NOTE_ID=` + sNOTE_ID + '&PARENT_ID=' + this.props.PARENT_ID);
		}
		catch(error)
		{
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.load', error);
			this.setState({ error });
		}
	}

	public render()
	{
		const { error } = this.state;
		if ( error )
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


