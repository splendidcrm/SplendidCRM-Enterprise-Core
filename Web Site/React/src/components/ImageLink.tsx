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
import { RouteComponentProps, withRouter } from '../Router5';
import { observer } from 'mobx-react';
// 2. Store and Types. 
// 3. Scripts. 
import Credentials from '../scripts/Credentials';
import { Crm_Modules } from '../scripts/Crm';
// 4. Components and Views. 

interface IImageLinkProps extends RouteComponentProps<any>
{
	ID  : string;
}

interface IImageLinkState
{
	NAME: string;
}

@observer
class ImageLink extends React.Component<IImageLinkProps, IImageLinkState>
{
	constructor(props: IImageLinkProps)
	{
		super(props);
		this.state =
		{
			NAME: ''
		}
	}

	async componentDidMount()
	{
		const { ID } = this.props;
		try
		{
			let value = await Crm_Modules.ItemName('Images', ID);
			this.setState({ NAME: value });
		}
		catch(error)
		{
			// 05/20/2018 Paul.  When an error is encountered, we display the error in the name. 
			console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.componentDidMount', error);
			this.setState({ NAME: error });
		}
	}

	public render()
	{
		const { ID } = this.props;
		const { NAME } = this.state;
		// 06/23/2019 Paul.  The server should always end with a slash. 
		let sURL = Credentials.RemoteServer + 'Images/Image.aspx?ID=' + ID;
		return (
			<div>
				<a href={sURL}>{NAME}</a>
			</div>
		)
	}
}

export default withRouter(ImageLink);
