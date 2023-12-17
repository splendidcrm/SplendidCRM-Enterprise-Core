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
import { Link, RouteComponentProps, withRouter } from 'react-router-dom';
// 2. Store and Types. 
// 3. Scripts. 
import L10n           from '../../scripts/L10n'       ;
import Credentials    from '../../scripts/Credentials';
import { Crm_Config } from '../../scripts/Crm'        ;
// 4. Components and Views. 

interface ITrainingPortalProps extends RouteComponentProps<any>
{
}

class TrainingPortal extends React.Component<ITrainingPortalProps>
{
	constructor(props: ITrainingPortalProps)
	{
		super(props);

		Credentials.SetViewMode('HomeView');
	}

	async componentDidMount()
	{
		try
		{
			document.title = L10n.Term('.LBL_BROWSER_TITLE');
		}
		catch(error)
		{
			this.setState({ error });
		}
	}

	public render()
	{
		let sugar_university: string = Crm_Config.ToString('sugar_university');
		let sugar_version   : string = Crm_Config.ToString('sugar_version'   );
		let url             : string = sugar_university.replace('{0}', sugar_version).replace('{1}', Credentials.sUSER_LANG.replace('-', '_'));
		return (<span className='body'>
			<iframe width="100%" height={ 800 } frameBorder={ 0 } src={ url }></iframe>
		</span>
		);
	}
}

export default withRouter(TrainingPortal);
