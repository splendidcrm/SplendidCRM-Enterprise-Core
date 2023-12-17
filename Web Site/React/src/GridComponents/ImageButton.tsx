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
import { FontAwesomeIcon }  from '@fortawesome/react-fontawesome';
// 2. Store and Types. 
// 3. Scripts. 
import Sql                  from '../scripts/Sql'          ;
import L10n                 from '../scripts/L10n'         ;
import Credentials          from '../scripts/Credentials'  ;
import SplendidCache        from '../scripts/SplendidCache';
// 4. Components and Views. 

interface IImageButtonProps
{
	row          : any;
	layout       : any;
	Page_Command?: Function;
}

interface IImageButtonState
{
	DISPLAY_NAME: string;
}

class ImageButton extends React.PureComponent<IImageButtonProps, IImageButtonState>
{
	constructor(props: IImageButtonProps)
	{
		super(props);
		const { layout, row } = this.props;
	}

	private _onClick = (e) =>
	{
		const { row, layout, Page_Command } = this.props;
		let URL_FORMAT: string = Sql.ToString(layout.URL_FORMAT);
		//console.log((new Date()).toISOString() + ' ' + this.constructor.name + '._onClick ' + URL_FORMAT, row.ID);
		if ( Page_Command != null )
		{
			Page_Command(URL_FORMAT, row.ID);
		}
	}

	public render()
	{
		const { layout, row } = this.props;
		let URL_FIELD : string = Sql.ToString(layout.URL_FIELD );
		let URL_FORMAT: string = Sql.ToString(layout.URL_FORMAT);
		let TITLE     : string = L10n.Term('.LBL_' + URL_FORMAT.toUpperCase());
		let themeURL  : string = Credentials.RemoteServer + 'App_Themes/' + SplendidCache.UserTheme + '/';
		if ( layout == null )
		{
			return (<div>layout prop is null</div>);
		}
		else if ( Sql.IsEmptyString(URL_FIELD) )
		{
			return (<div>URL_FIELD is empty for FIELD_INDEX {layout.FIELD_INDEX}</div>);
		}
		else
		{
			return (<span style={ {cursor: 'pointer'} } onClick={ this._onClick }>
				{ URL_FORMAT == 'Preview'
				? <FontAwesomeIcon icon={ {prefix: 'far', iconName: 'eye'} } title={ TITLE } />
				: <img src={ themeURL + 'images/' + URL_FORMAT + '.gif' } alt={ TITLE } style={ {height: '16px', width: '16px', borderWidth: '0px'} } />
				}
			</span>);
		}
	}
}

export default ImageButton;
