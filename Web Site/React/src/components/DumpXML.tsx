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
// 3. Scripts. 
import Sql        from '../scripts/Sql';
// 4. Components and Views. 

interface IDumpXMLProps
{
	XML       : string;
	default_xml: boolean;
}

interface IDumpXMLState
{
	expand_xml: boolean;
}

export default class DumpXML extends React.Component<IDumpXMLProps, IDumpXMLState>
{
	constructor(props: IDumpXMLProps)
	{
		super(props);
		this.state =
		{
			expand_xml: props.default_xml,
		};
	}

	private onToggleXml = () =>
	{
		this.setState({ expand_xml: !this.state.expand_xml });
	}

	private HtmlEncode = (s) =>
	{
		return s.replace(/&/g, '&amp;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/'/g, '&#39;')
		.replace(/"/g, '&#34;');
	}

	public render()
	{
		const { expand_xml } = this.state;
		let sXML: string = Sql.ToString(this.props.XML);
		sXML = this.HtmlEncode(sXML);
		sXML = sXML.replace(/\n/g, '<br />\n');
		sXML = sXML.replace(/\t/g, '&nbsp;&nbsp;&nbsp;');
		let cssSql: any = { height: '2em', cursor: 'pointer', marginBottom: 0, overflowX: 'hidden', width: '100%', border: '1px solid black', fontFamily: 'courier new', padding: '1px' };
		if ( expand_xml )
		{
			cssSql = { cursor: 'pointer', marginBottom: 0, width: '100%', border: '1px solid black', fontFamily: 'courier new', padding: '1px' };
		}
		return (<div style={ cssSql } onClick={ this.onToggleXml } >
			<div dangerouslySetInnerHTML={ { __html: sXML } }></div>
		</div>);
	}
}

