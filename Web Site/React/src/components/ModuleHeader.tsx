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
import { RouteComponentProps, withRouter, Link } from 'react-router-dom';
import { FontAwesomeIcon }                 from '@fortawesome/react-fontawesome';
// 2. Store and Types. 
import MODULE        from '../types/MODULE'         ;
// 3. Scripts. 
import L10n          from '../scripts/L10n'         ;
import Sql           from '../scripts/Sql'          ;
import Security      from '../scripts/Security'     ;
import SplendidCache from '../scripts/SplendidCache';
// 4. Components and Views. 

interface IModuleHeaderProps extends RouteComponentProps<any>
{
	MODULE_NAME  : string;
	MODULE_TITLE?: string;
	SUB_TITLE?   : string;
	ID?          : string;
}

class ModuleHeader extends React.Component<IModuleHeaderProps>
{
	constructor(props: IModuleHeaderProps)
	{
		super(props);
	}

	private _onClickModule = (e) =>
	{
		const { MODULE_NAME, SUB_TITLE, ID } = this.props;
		let admin = '';
		let module:MODULE = SplendidCache.Module(MODULE_NAME, this.constructor.name + '._onClickModule');
		if ( module.IS_ADMIN )
		{
			admin = '/Administration';
		}
		let sModuleUrl = `/Reset${admin}/${MODULE_NAME}/List`;
		this.props.history.push(sModuleUrl);
		return false;
	}

	private _onClickItem = (e) =>
	{
		const { MODULE_NAME, SUB_TITLE, ID } = this.props;
		let admin = '';
		let module:MODULE = SplendidCache.Module(MODULE_NAME, this.constructor.name + '._onClickItem');
		if ( module.IS_ADMIN )
		{
			admin = '/Administration';
		}
		let sModuleUrl = `/Reset${admin}/${MODULE_NAME}/View/${ID}`;
		this.props.history.push(sModuleUrl);
		return false;
	}

	public render()
	{
		const { MODULE_NAME, MODULE_TITLE, SUB_TITLE, ID } = this.props;
		let sMODULE_TITLE = !Sql.IsEmptyString(MODULE_TITLE) ? L10n.Term(MODULE_TITLE) : L10n.Term('.moduleList.' + MODULE_NAME);
		
		// 04/28/2019 Paul.  Can't use react-bootstrap Breadcrumb as it will reload the app is is therefore slow. 
		// 07/09/2019 Paul.  Use span instead of a tag to prevent navigation. 
		return (
			<h2>
				<span style={ {cursor: 'pointer'} } onClick={ this._onClickModule }>{ sMODULE_TITLE }</span>
				{ !Sql.IsEmptyString(ID)
				? <span>
					<span style={ {paddingLeft: '10px', paddingRight: '10px'} } ><FontAwesomeIcon icon="angle-double-right" /></span>
					{ Security.IS_ADMIN() || MODULE_NAME != 'Users'
					? <span style={ {cursor: 'pointer'} } onClick={ this._onClickItem }>
						{ SUB_TITLE }
					</span>
					: <span>{ SUB_TITLE }</span>
					}
				</span>
				: null
				}
			</h2>
		);
	}
}

export default withRouter(ModuleHeader);
