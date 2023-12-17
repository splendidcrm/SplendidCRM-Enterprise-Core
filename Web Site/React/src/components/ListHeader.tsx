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
import { RouteComponentProps, withRouter, Link }    from 'react-router-dom'              ;
import { FontAwesomeIcon }                          from '@fortawesome/react-fontawesome';
// 2. Store and Types. 
// 3. Scripts. 
import L10n                                         from '../scripts/L10n'               ;
import Credentials                                  from '../scripts/Credentials'        ;
import SplendidCache                                from '../scripts/SplendidCache'      ;
// 4. Components and Views. 

interface IListHeaderProps extends RouteComponentProps<any>
{
	MODULE_NAME?: string;
	TITLE?      : string;
}

class ListHeader extends React.Component<IListHeaderProps>
{
	constructor(props: IListHeaderProps)
	{
		super(props);
	}

	public render()
	{
		const { MODULE_NAME, TITLE } = this.props;
		let sMODULE_TITLE = L10n.Term(TITLE ? TITLE : MODULE_NAME + '.LBL_LIST_FORM_TITLE');
		// 10/29/2020 Paul.  Add the header arrow. 
		let themeURL = Credentials.RemoteServer + 'App_Themes/' + SplendidCache.UserTheme + '/';
		return (
			<table className='h3Row' cellSpacing={ 1 } cellPadding={ 0 } style={ {width: '100%', border: 'none', marginBottom: '2px'} }>
				<tr>
					<td style={ {whiteSpace: 'nowrap'} }>
						<h3>
							<FontAwesomeIcon icon='arrow-right' size='lg' style={ {marginRight: '.5em'} } transform={ {rotate: 45} } />
							&nbsp;<span>{ sMODULE_TITLE }</span>
						</h3>
					</td>
				</tr>
			</table>
		);
	}
}

export default withRouter(ListHeader);
