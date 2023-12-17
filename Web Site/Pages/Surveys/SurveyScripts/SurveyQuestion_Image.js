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

function SurveyQuestion_Image(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

// 10/08/2018 Paul.  Provide sample for question editor. 
SurveyQuestion_Image.prototype.InitSample = function()
{
	this.row.IMAGE_URL = '../Include/images/SplendidCRM_Logo.gif';
}

SurveyQuestion_Image.prototype.Value = function()
{
	return null;
}

SurveyQuestion_Image.prototype.Validate = function(divQuestionError)
{
	return true;
}

SurveyQuestion_Image.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		SurveyQuestion_Helper_RenderHeader(divQuestionHeading, this.row);
		if ( this.row.IMAGE_URL !== undefined && this.row.IMAGE_URL != null )
		{
			var img = document.createElement('img');
			img.className = 'SurveyAnswerImage';
			img.src = this.row.IMAGE_URL.replace('~/', sREMOTE_SERVER);
			divQuestionBody.appendChild(img);
		}
		// 11/24/2018 Paul.  Place image caption in ANSWER_CHOICES. 
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var div = document.createElement('div');
			div.className = 'SurveyAnswerPlainText';
			div.innerHTML = Sql.ToString(this.row.ANSWER_CHOICES);
			divQuestionBody.appendChild(div);
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Image.Render: ' + e.message);
	}
}

SurveyQuestion_Image.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Image.Report: ' + e.message);
	}
}

SurveyQuestion_Image.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
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
		throw new Error('SurveyQuestion_Image.Summary: ' + e.message);
	}
}

