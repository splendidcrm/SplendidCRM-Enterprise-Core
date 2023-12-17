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
import ISurveyQuestionProps                     from '../types/ISurveyQuestionProps';
import SurveyQuestion                           from './SurveyQuestion'             ;
// 3. Scripts. 
import Sql                                      from '../scripts/Sql'               ;
import Credentials                              from '../scripts/Credentials'       ;
// 4. Components and Views. 

interface IPlainTextState
{
	ID               : string;
	IMAGE_URL        : string;
	ANSWER_CHOICES   : string;
}

export default class Image extends SurveyQuestion<ISurveyQuestionProps, IPlainTextState>
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
		const { row, displayMode } = props;
		let ID            : string = null;
		let IMAGE_URL     : string = null;
		let ANSWER_CHOICES: string = null;
		if ( row )
		{
			// 07/11/2021 Paul.  ID will be null in sample mode. 
			// 07/28/2021 Paul.  Allow Preview mode for dynamic updates while editing question. 
			ID = (row.ID ? row.ID.replace(/-/g, '_') : null);
			ANSWER_CHOICES = row.ANSWER_CHOICES;
			IMAGE_URL      = Sql.ToString(row.IMAGE_URL);
			if ( displayMode == 'Sample' && Sql.IsEmptyString(IMAGE_URL) )
			{
				IMAGE_URL = '~/Include/images/SplendidCRM_Logo.gif';
			}
			IMAGE_URL = Sql.ToString(IMAGE_URL).replace('~/', Credentials.RemoteServer);
		}
		this.state =
		{
			ID            ,
			IMAGE_URL     ,
			ANSWER_CHOICES,
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
		const { ID, IMAGE_URL, ANSWER_CHOICES } = this.state;
		// 11/24/2018 Paul.  Place image caption in ANSWER_CHOICES. 
		if ( row )
		{
			let html = { __html: Sql.ToString(ANSWER_CHOICES) };
			// 07/13/2021 Paul.  Show the header in sample mode. 
			return (
				<React.Fragment>
					{ displayMode == 'Sample'
					? this.RenderHeader()
					: null
					}
					{ !Sql.IsEmptyString(IMAGE_URL)
					? <img id={ ID } key={ ID } className='SurveyAnswerImage' src={ IMAGE_URL } />
					: null
					}
					{ html
					? <div id={ ID + '_caption' } key={ ID + '_caption' } className='SurveyAnswerPlainText' dangerouslySetInnerHTML={ html } />
					: null
					}
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

