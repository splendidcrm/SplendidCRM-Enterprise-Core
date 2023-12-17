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

function SurveyQuestion_Hidden(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

SurveyQuestion_Hidden.prototype.InitSample = function()
{
}

SurveyQuestion_Hidden.prototype.Value = function()
{
	var arrValue = new Array();
	arrValue.push(this.row.ANSWER_CHOICES);
	return arrValue;
}

SurveyQuestion_Hidden.prototype.Validate = function(divQuestionError)
{
	return true;
}

SurveyQuestion_Hidden.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		/*
		if ( bDisable )
		{
			var div = document.createElement('div');
			div.className = 'SurveyAnswerPlainText';
			div.innerHTML = this.row.DESCRIPTION;
			divQuestionBody.appendChild(div);
		}
		*/
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Hidden.Render: ' + e.message);
	}
}

SurveyQuestion_Hidden.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Hidden.Report: ' + e.message);
	}
}

SurveyQuestion_Hidden.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
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
		throw new Error('SurveyQuestion_Hidden.Summary: ' + e.message);
	}
}

