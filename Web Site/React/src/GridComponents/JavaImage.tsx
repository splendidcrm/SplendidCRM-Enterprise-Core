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
import ACL_FIELD_ACCESS from '../types/ACL_FIELD_ACCESS';
// 3. Scripts. 
import Sql              from '../scripts/Sql'           ;
import SplendidCache    from '../scripts/SplendidCache' ;
// 4. Components and Views. 

interface IJavaImageProps
{
	baseId: string;
	row   : any;
	layout: any;
}

interface IJavaImageState
{
	bIsReadable: boolean;
}

class JavaImage extends React.PureComponent<IJavaImageProps, IJavaImageState>
{
	constructor(props: IJavaImageProps)
	{
		super(props);
		const { layout } = this.props;
		let bIsReadable: boolean = true;
		if ( layout != null )
		{
			let DATA_FIELD  : string = Sql.ToString(layout.DATA_FIELD);
			let MODULE_NAME : string = SplendidCache.GetGridModule(layout);
			if ( SplendidCache.bEnableACLFieldSecurity && !Sql.IsEmptyString(DATA_FIELD) )
			{
				let gASSIGNED_USER_ID: string = null;
				let acl: ACL_FIELD_ACCESS = ACL_FIELD_ACCESS.GetUserFieldSecurity(MODULE_NAME, DATA_FIELD, gASSIGNED_USER_ID);
				bIsReadable  = acl.IsReadable();
			}
		}
		this.setState({ bIsReadable });
	}

	public render()
	{
		const { baseId, layout, row } = this.props;
		let DATA_FIELD = Sql.ToString(layout.DATA_FIELD);
		let sKEY = baseId + '_' + DATA_FIELD;
		if ( layout == null )
		{
			return (<div>layout prop is null</div>);
		}
		else if ( Sql.IsEmptyString(DATA_FIELD) )
		{
			return (<div>DATA_FIELD is empty for FIELD_INDEX {layout.FIELD_INDEX}</div>);
		}
		else
		{
			var sVALUE = (row ? Sql.ToString(row[DATA_FIELD]) : '');
			return (<div id={sKEY} key={sKEY}>{sVALUE}</div>);
		}
	}
}

export default JavaImage;
