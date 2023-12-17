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
import { Appear }                               from 'react-lifecycle-appear'       ;
// 2. Store and Types. 
import ISurveyQuestionProps                     from '../types/ISurveyQuestionProps';
import SurveyQuestion                           from './SurveyQuestion'             ;
// 3. Scripts. 
import Sql                                      from '../scripts/Sql'               ;
// 4. Components and Views. 

interface IPlainTextState
{
	ID               : string;
}

export default class PlainText extends SurveyQuestion<ISurveyQuestionProps, IPlainTextState>
{
	public get data(): any
	{
		return null;
	}

	public validate(): boolean
	{
		return true;
	}

	public setFocus(): void
	{
	}

	public isFocused(): boolean
	{
		return false;
	}

	constructor(props: ISurveyQuestionProps)
	{
		super(props);
		const { displayMode, row } = props;
		let ID: string = null;
		// 07/11/2021 Paul.  ID will be null in sample mode. 
		if ( row )
		{
			// 07/28/2021 Paul.  Allow Preview mode for dynamic updates while editing question. 
			ID = (row.ID ? row.ID.replace(/-/g, '_') : null);
		}
		this.state =
		{
			ID,
		};
	}

	public render()
	{
		const { displayMode } = this.props;
		if ( displayMode == 'Report' )
		{
			return this.Report();
		}
		else if ( displayMode == 'Summary' )
		{
			return this.Summary();
		}
		else
		{
			return this.RenderQuestion(false);
		}
	}

	public RenderQuestion = (bDisable: boolean) =>
	{
		const { displayMode, row } = this.props;
		const { ID } = this.state;
		if ( row != null )
		{
			let html = { __html: Sql.ToString(row.DESCRIPTION) };
			// 07/13/2021 Paul.  Show the header in sample mode. 
			return (
				<React.Fragment>
					{ displayMode == 'Sample'
					? this.RenderHeader()
					: null
					}
					<div id={ ID } key={ ID } className='SurveyAnswerPlainText' dangerouslySetInnerHTML={ html } />
				</React.Fragment>
			);
		}
		else
		{
			return null;
		}
	}

	public Report = () =>
	{
		return this.RenderQuestion(true);
	}

	public Summary = () =>
	{
		return null;
	}
}

