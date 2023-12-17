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

function SurveyQuestion_PlainText(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

// 10/08/2018 Paul.  Provide sample for question editor. 
SurveyQuestion_PlainText.prototype.InitSample = function()
{
}

SurveyQuestion_PlainText.prototype.Value = function()
{
	return null;
}

SurveyQuestion_PlainText.prototype.Validate = function(divQuestionError)
{
	return true;
}

SurveyQuestion_PlainText.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		var div = document.createElement('div');
		div.className = 'SurveyAnswerPlainText';
		// 11/11/2018 Paul.  Description may be null. 
		div.innerHTML = Sql.ToString(this.row.DESCRIPTION);
		divQuestionBody.appendChild(div);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_PlainText.Render: ' + e.message);
	}
}

SurveyQuestion_PlainText.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_PlainText.Report: ' + e.message);
	}
}

SurveyQuestion_PlainText.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
{
	try
	{
		if ( this.SUMMARY_VISIBLE === undefined )
			this.SUMMARY_VISIBLE = true;
		else
			return;
		if ( callback !== undefined && callback != null )
			callback.call(context||this, 1, null);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_PlainText.Summary: ' + e.message);
	}
}

