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

function SurveyPage(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
	// 12/27/2015 Paul.  MOBILE_ID is only defined when running on a mobile device. 
	if ( row.MOBILE_ID !== undefined )
	{
		this.ID += "_" + row.MOBILE_ID.replace(/-/g, '_');
	}
}

SurveyPage.prototype.Validate = function()
{
	var bValid = true;
	try
	{
		for ( var i = 0; i < this.row.SURVEY_QUESTIONS.length; i++ )
		{
			var rowQUESTION = this.row.SURVEY_QUESTIONS[i];
			if ( !SurveyQuestion_Validate(rowQUESTION) )
			{
				bValid = false;
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyPage.Validate: ' + e.message);
		bValid = false;
	}
	return bValid;
}

SurveyPage.prototype.Activate = function(bActivate)
{
	var divSurveyPage = document.getElementById(this.ID);
	divSurveyPage.style.display = (bActivate ? 'inline' : 'none');
}

SurveyPage.prototype.Render = function(divSurveyPages, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		//alert(dumpObj(this.row, 'Page row'));
		var divSurveyPage = document.createElement('div');
		divSurveyPage.id            = this.ID;
		divSurveyPage.className     = 'SurveyPage';
		divSurveyPage.style.display = 'none';
		divSurveyPages.appendChild(divSurveyPage);
		
		var divSurveyPageTitle = document.createElement('div');
		divSurveyPageTitle.id        = this.ID + '_Title';
		divSurveyPageTitle.className = 'SurveyPageTitle';
		divSurveyPage.appendChild(divSurveyPageTitle);
		//divSurveyPageTitle.innerHTML = this.row.PAGE_NUMBER.toString() + '. ' + this.row.NAME;
		if ( !Sql.IsEmptyString(this.row.NAME) )
			divSurveyPageTitle.innerHTML = this.row.NAME;
		
		if ( !Sql.IsEmptyString(this.row.DESCRIPTION) )
		{
			var divSurveyPageDescription = document.createElement('div');
			divSurveyPageDescription.id        = this.ID + '_Description';
			divSurveyPageDescription.className = 'SurveyPageDescription';
			divSurveyPage.appendChild(divSurveyPageDescription);
			divSurveyPageDescription.innerHTML = this.row.DESCRIPTION;
		}
		
		var tblSurveyPageBody = document.createElement('table');
		tblSurveyPageBody.className   = 'SurveyPageBody SurveyQuestionFrame';
		tblSurveyPageBody.cellPadding = 0;
		tblSurveyPageBody.cellSpacing = 0;
		tblSurveyPageBody.border      = 0;
		tblSurveyPageBody.width       = '100%';
		divSurveyPage.appendChild(tblSurveyPageBody);
		var tbodySurveyPageBody = document.createElement('tbody');
		tblSurveyPageBody.appendChild(tbodySurveyPageBody);
		var trSurveyPageBody = document.createElement('tr');
		tbodySurveyPageBody.appendChild(trSurveyPageBody);
		var tdSurveyPageBody = document.createElement('td');
		tdSurveyPageBody.vAlign = 'top';
		trSurveyPageBody.appendChild(tdSurveyPageBody);
		
		this.Randomize();
		for ( var i = 0; i < this.row.SURVEY_QUESTIONS.length; i++ )
		{
			//if ( i > 2 )
			//	continue;
			var rowQUESTION = this.row.SURVEY_QUESTIONS[i];
			// 11/23/2018 Paul.  Next to Previous does not apply when on a mobile device. 
			if ( isMobileDevice() || rowQUESTION.PLACEMENT == 'New Row' )
			{
				// 06/13/2013 Paul.  Only one item per cell, so if items exist, then create a new table so that we don't have to worry about column spans. 
				if ( tdSurveyPageBody.childNodes.length > 0 )
				{
					tblSurveyPageBody = document.createElement('table');
					tblSurveyPageBody.className   = 'SurveyPageBody SurveyQuestionFrame';
					tblSurveyPageBody.cellPadding = 0;
					tblSurveyPageBody.cellSpacing = 0;
					tblSurveyPageBody.border      = 0;
					tblSurveyPageBody.width       = '100%';
					divSurveyPage.appendChild(tblSurveyPageBody);
					tbodySurveyPageBody = document.createElement('tbody');
					tblSurveyPageBody.appendChild(tbodySurveyPageBody);
					trSurveyPageBody = document.createElement('tr');
					tbodySurveyPageBody.appendChild(trSurveyPageBody);
					tdSurveyPageBody = document.createElement('td');
					tdSurveyPageBody.vAlign = 'top';
					trSurveyPageBody.appendChild(tdSurveyPageBody);
				}
			}
			else if ( rowQUESTION.PLACEMENT == 'Next to Previous' )
			{
				// 06/13/2013 Paul.  Only one item per cell, so if items exist, then create a new column. 
				if ( tdSurveyPageBody.childNodes.length > 0 )
				{
					tdSurveyPageBody = document.createElement('td');
					tdSurveyPageBody.vAlign = 'top';
					trSurveyPageBody.appendChild(tdSurveyPageBody);
				}
				// 01/01/2016 Paul.  Size Width only makes sense on the page body cell sense when questions side-by-side. 
				if ( !Sql.IsEmptyString(rowQUESTION.SIZE_WIDTH ) )
					tdSurveyPageBody.style.width  = rowQUESTION.SIZE_WIDTH ;
			}
			var divQuestionFrame = document.createElement('div');
			divQuestionFrame.id        = rowQUESTION.ID + '_Frame';
			divQuestionFrame.className = 'SurveyQuestionFrame';
			tdSurveyPageBody.appendChild(divQuestionFrame);
			// 01/01/2016 Paul.  When using New Row placement, use the width to center. 
			if ( rowQUESTION.PLACEMENT == 'New Row' )
			{
				// 01/01/2016 Paul.  Do not use size as we are not now centering nav buttons on mobile. 
				if ( !Sql.IsEmptyString(rowQUESTION.SIZE_WIDTH ) && !isMobileDevice() )
				{
					divQuestionFrame.style.width  = rowQUESTION.SIZE_WIDTH ;
					// 01/01/2016 Paul.  The trick to centering a div tag is margin: 0 auto;
					divQuestionFrame.style.margin = '0 auto';
				}
			}
			if ( !Sql.IsEmptyString(rowQUESTION.SIZE_HEIGHT) )
				tdSurveyPageBody.style.height = rowQUESTION.SIZE_HEIGHT;
			SurveyQuestion_Render(rowQUESTION, divQuestionFrame, rowQUESTION_RESULTS, bDisable);
		}
	}
	catch(e)
	{
		throw new Error('SurveyPage.Render: ' + e.message);
	}
}

SurveyPage.prototype.Randomize = function()
{
	try
	{
		if ( this.row.RANDOMIZE_APPLIED === undefined )
			this.row.RANDOMIZE_APPLIED = false;
		if ( this.row.RANDOMIZE_COUNT === undefined )
			this.row.RANDOMIZE_COUNT = 0;
		if ( !this.row.RANDOMIZE_APPLIED )
		{
			if ( !Sql.IsEmptyString(this.row.QUESTION_RANDOMIZATION) && this.row.SURVEY_QUESTIONS.length > 0 )
			{
				if ( this.row.SURVEY_QUESTIONS.length > 1 )
				{
					if ( this.row.QUESTION_RANDOMIZATION == 'Randomize' )
					{
						// http://stackoverflow.com/questions/2450954/how-to-randomize-a-javascript-array
						for ( var i = this.row.SURVEY_QUESTIONS.length - 1; i > 0; i-- )
						{
							var j = Math.floor(Math.random() * (i + 1));
							var temp = this.row.SURVEY_QUESTIONS[i];
							this.row.SURVEY_QUESTIONS[i] = this.row.SURVEY_QUESTIONS[j];
							this.row.SURVEY_QUESTIONS[j] = temp;
						}
					}
					else if ( this.row.QUESTION_RANDOMIZATION == 'Flip' )
					{
						if ( Sql.ToInteger(this.row.RANDOMIZE_COUNT) % 2 == 0 )
						{
							this.row.SURVEY_QUESTIONS.reverse();
						}
					}
					else if ( this.row.QUESTION_RANDOMIZATION == 'Rotate' )
					{
						var nRotateCount = Sql.ToInteger(this.row.RANDOMIZE_COUNT) % this.row.SURVEY_QUESTIONS.length;
						for ( var i = 0; i < nRotateCount; i++ )
						{
							this.row.SURVEY_QUESTIONS.push(this.row.SURVEY_QUESTIONS.shift());
						}
					}
				}
			}
			this.row.RANDOMIZE_APPLIED = true;
		}
		this.RenumberQuestions();
	}
	catch(e)
	{
		throw new Error('SurveyPage.Randomize: ' + e.message);
	}
}

SurveyPage.prototype.RenumberQuestions = function()
{
	if ( this.row.RENUMBER_QUESTIONS === undefined )
		this.row.RENUMBER_QUESTIONS = true;
	if ( this.row.RENUMBER_QUESTIONS )
	{
		var nNON_QUESTIONS   = 0;
		var nQUESTION_OFFSET = this.row.QUESTION_OFFSET;
		for ( var i = 0; i < this.row.SURVEY_QUESTIONS.length; i++ )
		{
			var rowQUESTION = this.row.SURVEY_QUESTIONS[i];
			// 06/13/2013 Paul.  Plain Text and Images do not get question numbers. 
			// 11/10/2018 Paul.  Provide a way to get a hidden value for lead population. 
			if ( rowQUESTION.QUESTION_TYPE == 'Plain Text' || rowQUESTION.QUESTION_TYPE == 'Image' || rowQUESTION.QUESTION_TYPE == 'Hidden' )
			{
				nNON_QUESTIONS++;
				rowQUESTION.QUESTION_NUMBER = 0;
			}
			else
			{
				rowQUESTION.QUESTION_NUMBER = nQUESTION_OFFSET + i + 1 - nNON_QUESTIONS;
			}
		}
		this.row.RENUMBER_QUESTIONS = false;
	}
}

SurveyPage.prototype.Report = function(divSurveyPages, rowPAGE_RESULTS)
{
	try
	{
		//alert(dumpObj(rowRESULTS, 'rowRESULTS'));
		var divSurveyPage = document.createElement('div');
		divSurveyPage.id            = this.ID;
		divSurveyPage.className     = 'SurveyPage';
		divSurveyPages.appendChild(divSurveyPage);
		
		var divSurveyPageTitle = document.createElement('div');
		divSurveyPageTitle.id        = this.ID + '_Title';
		divSurveyPageTitle.className = 'SurveyPageTitle';
		divSurveyPage.appendChild(divSurveyPageTitle);
		//divSurveyPageTitle.innerHTML = this.row.PAGE_NUMBER.toString() + '. ' + this.row.NAME;
		if ( !Sql.IsEmptyString(this.row.NAME) )
			divSurveyPageTitle.innerHTML = this.row.NAME;
		
		if ( !Sql.IsEmptyString(this.row.DESCRIPTION) )
		{
			var divSurveyPageDescription = document.createElement('div');
			divSurveyPageDescription.id        = this.ID + '_Description';
			divSurveyPageDescription.className = 'SurveyPageDescription';
			divSurveyPage.appendChild(divSurveyPageDescription);
			divSurveyPageDescription.innerHTML = this.row.DESCRIPTION;
		}
		
		var tblSurveyPageBody = document.createElement('table');
		tblSurveyPageBody.className   = 'SurveyPageBody SurveyQuestionFrame';
		tblSurveyPageBody.cellPadding = 0;
		tblSurveyPageBody.cellSpacing = 0;
		tblSurveyPageBody.border      = 0;
		tblSurveyPageBody.width       = '100%';
		divSurveyPage.appendChild(tblSurveyPageBody);
		var tbodySurveyPageBody = document.createElement('tbody');
		tblSurveyPageBody.appendChild(tbodySurveyPageBody);
		var trSurveyPageBody = document.createElement('tr');
		tbodySurveyPageBody.appendChild(trSurveyPageBody);
		var tdSurveyPageBody = document.createElement('td');
		tdSurveyPageBody.vAlign = 'top';
		trSurveyPageBody.appendChild(tdSurveyPageBody);
		
		this.RenumberQuestions();
		for ( var i = 0; i < this.row.SURVEY_QUESTIONS.length; i++ )
		{
			//if ( i > 2 )
			//	continue;
			var rowQUESTION = this.row.SURVEY_QUESTIONS[i];
			// 09/10/2018 Paul.  Show image or text in report to show that it is working .
			// 11/10/2018 Paul.  Provide a way to get a hidden value for lead population. 
			//if ( rowQUESTION.QUESTION_TYPE == 'Plain Text' || rowQUESTION.QUESTION_TYPE == 'Image' || rowQUESTION.QUESTION_TYPE == 'Hidden' )
			//	continue;
			
			if ( rowQUESTION.PLACEMENT == 'New Row' )
			{
				// 06/13/2013 Paul.  Only one item per cell, so if items exist, then create a new table so that we don't have to worry about column spans. 
				if ( tdSurveyPageBody.childNodes.length > 0 )
				{
					tblSurveyPageBody = document.createElement('table');
					tblSurveyPageBody.className   = 'SurveyPageBody SurveyQuestionFrame';
					tblSurveyPageBody.cellPadding = 0;
					tblSurveyPageBody.cellSpacing = 0;
					tblSurveyPageBody.border      = 0;
					tblSurveyPageBody.width       = '100%';
					divSurveyPage.appendChild(tblSurveyPageBody);
					tbodySurveyPageBody = document.createElement('tbody');
					tblSurveyPageBody.appendChild(tbodySurveyPageBody);
					trSurveyPageBody = document.createElement('tr');
					tbodySurveyPageBody.appendChild(trSurveyPageBody);
					tdSurveyPageBody = document.createElement('td');
					tdSurveyPageBody.vAlign = 'top';
					trSurveyPageBody.appendChild(tdSurveyPageBody);
				}
			}
			else if ( rowQUESTION.PLACEMENT == 'Next to Previous' )
			{
				// 06/13/2013 Paul.  Only one item per cell, so if items exist, then create a new column. 
				if ( tdSurveyPageBody.childNodes.length > 0 )
				{
					tdSurveyPageBody = document.createElement('td');
					tdSurveyPageBody.vAlign = 'top';
					trSurveyPageBody.appendChild(tdSurveyPageBody);
				}
				// 01/01/2016 Paul.  Size Width only makes sense on the page body cell sense when questions side-by-side. 
				if ( !Sql.IsEmptyString(rowQUESTION.SIZE_WIDTH ) )
					tdSurveyPageBody.style.width  = rowQUESTION.SIZE_WIDTH ;
			}
			var divQuestionFrame = document.createElement('div');
			divQuestionFrame.id        = rowQUESTION.ID + '_Frame';
			divQuestionFrame.className = 'SurveyQuestionFrame';
			tdSurveyPageBody.appendChild(divQuestionFrame);
			// 01/01/2016 Paul.  When using New Row placement, use the width to center. 
			if ( rowQUESTION.PLACEMENT == 'New Row' )
			{
				// 01/01/2016 Paul.  Do not use size as we are not now centering nav buttons on mobile. 
				if ( !Sql.IsEmptyString(rowQUESTION.SIZE_WIDTH ) && !isMobileDevice() )
				{
					divQuestionFrame.style.width  = rowQUESTION.SIZE_WIDTH ;
					// 01/01/2016 Paul.  The trick to centering a div tag is margin: 0 auto;
					divQuestionFrame.style.margin = '0 auto';
				}
			}
			if ( !Sql.IsEmptyString(rowQUESTION.SIZE_HEIGHT) )
				tdSurveyPageBody.style.height = rowQUESTION.SIZE_HEIGHT;
			SurveyQuestion_Report(rowQUESTION, divQuestionFrame, rowPAGE_RESULTS);
		}
	}
	catch(e)
	{
		throw new Error('SurveyPage.Report: ' + e.message);
	}
}

SurveyPage.prototype.Summary = function(divSurveyPages)
{
	try
	{
		//alert(dumpObj(rowRESULTS, 'rowRESULTS'));
		var divSurveyPage = document.createElement('div');
		divSurveyPage.id            = this.ID;
		divSurveyPage.className     = 'SurveyPage';
		divSurveyPages.appendChild(divSurveyPage);
		
		var divSurveyPageTitle = document.createElement('div');
		divSurveyPageTitle.id        = this.ID + '_Title';
		divSurveyPageTitle.className = 'SurveyPageTitle';
		divSurveyPage.appendChild(divSurveyPageTitle);
		//divSurveyPageTitle.innerHTML = this.row.PAGE_NUMBER.toString() + '. ' + this.row.NAME;
		if ( !Sql.IsEmptyString(this.row.NAME) )
			divSurveyPageTitle.innerHTML = this.row.NAME;
		
		if ( !Sql.IsEmptyString(this.row.DESCRIPTION) )
		{
			var divSurveyPageDescription = document.createElement('div');
			divSurveyPageDescription.id        = this.ID + '_Description';
			divSurveyPageDescription.className = 'SurveyPageDescription';
			divSurveyPage.appendChild(divSurveyPageDescription);
			divSurveyPageDescription.innerHTML = this.row.DESCRIPTION;
		}
		
		var tblSurveyPageBody = document.createElement('table');
		tblSurveyPageBody.className   = 'SurveyPageBody SurveyQuestionFrame';
		tblSurveyPageBody.cellPadding = 0;
		tblSurveyPageBody.cellSpacing = 0;
		tblSurveyPageBody.border      = 0;
		tblSurveyPageBody.width       = '100%';
		divSurveyPage.appendChild(tblSurveyPageBody);
		var tbodySurveyPageBody = document.createElement('tbody');
		tblSurveyPageBody.appendChild(tbodySurveyPageBody);
		var trSurveyPageBody = document.createElement('tr');
		tbodySurveyPageBody.appendChild(trSurveyPageBody);
		var tdSurveyPageBody = document.createElement('td');
		tdSurveyPageBody.vAlign = 'top';
		trSurveyPageBody.appendChild(tdSurveyPageBody);
		
		this.RenumberQuestions();
		this.PENDING_QUESTIONS = new Array();
		for ( var i = 0; i < this.row.SURVEY_QUESTIONS.length; i++ )
		{
			//if ( i > 2 )
			//	continue;
			var rowQUESTION = this.row.SURVEY_QUESTIONS[i];
			// 11/10/2018 Paul.  Provide a way to get a hidden value for lead population. 
			if ( rowQUESTION.QUESTION_TYPE == 'Plain Text' || rowQUESTION.QUESTION_TYPE == 'Image' || rowQUESTION.QUESTION_TYPE == 'Hidden' )
				continue;
			
			if ( tdSurveyPageBody.childNodes.length > 0 )
			{
				tblSurveyPageBody = document.createElement('table');
				tblSurveyPageBody.className   = 'SurveyPageBody SurveyQuestionFrame';
				tblSurveyPageBody.cellPadding = 0;
				tblSurveyPageBody.cellSpacing = 0;
				tblSurveyPageBody.border      = 0;
				tblSurveyPageBody.width       = '100%';
				divSurveyPage.appendChild(tblSurveyPageBody);
				tbodySurveyPageBody = document.createElement('tbody');
				tblSurveyPageBody.appendChild(tbodySurveyPageBody);
				trSurveyPageBody = document.createElement('tr');
				tbodySurveyPageBody.appendChild(trSurveyPageBody);
				tdSurveyPageBody = document.createElement('td');
				tdSurveyPageBody.vAlign = 'top';
				trSurveyPageBody.appendChild(tdSurveyPageBody);
			}
			
			var divQuestionFrame = document.createElement('div');
			divQuestionFrame.id        = rowQUESTION.ID + '_Frame';
			divQuestionFrame.className = 'SurveyQuestionSummaryFrame';
			tdSurveyPageBody.appendChild(divQuestionFrame);
			//SurveyQuestion_Summary(rowQUESTION, divQuestionFrame);
			var oPending = new Object();
			oPending.rowQUESTION      = rowQUESTION;
			oPending.divQuestionFrame = divQuestionFrame;
			this.PENDING_QUESTIONS.push(oPending);
		}
		this.RenderNextQuestion();
	}
	catch(e)
	{
		throw new Error('SurveyPage.Summary: ' + e.message);
	}
}

SurveyPage.prototype.RenderNextQuestion = function()
{
	if ( this.PENDING_QUESTIONS.length > 0 )
	{
		var oPending = this.PENDING_QUESTIONS.shift();
		SurveyQuestion_Summary(oPending.rowQUESTION, oPending.divQuestionFrame, function(status, message)
		{
			this.RenderNextQuestion();
		}, this);
	}
}

