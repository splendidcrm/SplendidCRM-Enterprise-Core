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
import { RouteComponentProps, withRouter }    from '../Router5'              ;
import { FontAwesomeIcon }                    from '@fortawesome/react-fontawesome';
import { observer }                           from 'mobx-react'                    ;
// 2. Store and Types. 
// 3. Scripts. 
import Sql                                    from '../scripts/Sql'                ;
import L10n                                   from '../scripts/L10n'               ;
import Credentials                            from '../scripts/Credentials'        ;
import SplendidCache                          from '../scripts/SplendidCache'      ;
import { Crm_Modules }                        from '../scripts/Crm'                ;
import { AuthenticatedMethod, LoginRedirect } from '../scripts/Login'              ;
// 4. Components and Views. 
import ErrorComponent                         from '../components/ErrorComponent'  ;

interface IParentsViewProps extends RouteComponentProps<any>
{
	MODULE_NAME: string;
	ID         : string;
}

interface IParentsViewState
{
	error?     : any;
}

@observer
class ParentsView extends React.Component<IParentsViewProps, IParentsViewState>
{
	private _isMounted = false;

	constructor(props: IParentsViewProps)
	{
		super(props);
		Credentials.SetViewMode('ListView');
		this.state = {};
	}

	componentDidCatch(error, info)
	{
		console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidCatch', error, info);
	}

	async componentDidMount()
	{
		const { ID, history } = this.props;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', this.props.MODULE_NAME);
		this._isMounted = true;
		try
		{
			let status = await AuthenticatedMethod(this.props, this.constructor.name + '.componentDidMount');
			if ( status == 1 )
			{
				let PARENT_TYPE: string = await Crm_Modules.ParentModule(ID);
				if ( !Sql.IsEmptyGuid(PARENT_TYPE) )
				{
					// 07/05/2020 Paul.  We need to make sure that the Users module is treated as an admin module. 
					let module = SplendidCache.Module(PARENT_TYPE, 'ParentsView.componentDidMount');
					if ( module != null )
					{
						let sRedirectUrl: string = '/';
						if ( module.IS_ADMIN )
						{
							sRedirectUrl = 'Administration/';
						}
						sRedirectUrl += PARENT_TYPE + '/View/' + ID;
						// 08/06/2020 Paul.  Try and replace the /Parents so that the back button will work properly. 
						history.replace(sRedirectUrl);
					}
					else
					{
						this.setState({ error: 'Unknown module ' + PARENT_TYPE });
					}
				}
				else
				{
					this.setState({ error: L10n.Term('.LBL_INSUFFICIENT_ACCESS') });
				}
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

	componentDidUpdate(prevProps: IParentsViewProps)
	{
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidUpdate', this.props.MODULE_NAME);
	}

	componentWillUnmount()
	{
		this._isMounted = false;
	}

	public render()
	{
		const { error } = this.state;
		if ( error )
		{
			return <ErrorComponent error={error} />;
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

export default withRouter(ParentsView);
