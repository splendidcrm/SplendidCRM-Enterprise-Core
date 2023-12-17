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
import { Alert } from 'react-bootstrap';
// 2. Store and Types. 
// 3. Scripts. 
// 4. Components and Views. 
interface IErrorComponentProps
{
	error?: any;
}

class ErrorComponent extends React.Component<IErrorComponentProps>
{
	constructor(props: IErrorComponentProps)
	{
		super(props);
	}

	public render()
	{
		const { error } = this.props;
		if ( error != undefined && error != null )
		{
			//console.error((new Date()).toISOString() + ' ' + this.constructor.name + '.render', error);
			if (error)
			{
				let sError = error;
				if ( error.message !== undefined )
				{
					sError = error.message;
				}
				else if ( typeof(error) == 'string' )
				{
					sError = error;
				}
				else if ( typeof(error) == 'object' )
				{
					sError = JSON.stringify(error);
				}
				return <Alert variant='danger'>{sError}</Alert>;
			}
			return null;
		}
		else
		{
			return null;
		}
	}
}

export default ErrorComponent;
