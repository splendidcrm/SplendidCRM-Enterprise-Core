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
import { IEditComponentProps, EditComponent } from '../types/EditComponent';
// 3. Scripts. 
// 4. Components and Views. 

export default class Separator extends React.PureComponent<IEditComponentProps>
{
	public get data(): any
	{
		return null;
	}

	public validate(): boolean
	{
		return true;
	}

	public updateDependancy(PARENT_FIELD: string, DATA_VALUE: any, PROPERTY_NAME?: string, item?: any): void
	{
	}

	public clear(): void
	{
	}

	constructor(props: IEditComponentProps)
	{
		super(props);
	}

	public render()
	{
		const { baseId, layout, row, onChanged } = this.props;
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '.render');
		return (<div>&nbsp;</div>);
	}
}

