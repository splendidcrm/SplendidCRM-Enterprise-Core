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

function SurveyQuestion_SingleCheckbox(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

SurveyQuestion_SingleCheckbox.prototype.InitSample = function()
{
	this.row.ANSWER_CHOICES = 'Yes?';
}

SurveyQuestion_SingleCheckbox.prototype.Value = function()
{
	var bValid = false;
	var arrValue = new Array();
	try
	{
		// 11/26/2018 Paul.  Define nSelected. 
		var nSelected = 0;
		var chk = document.getElementById(this.ID);
		if ( chk != null && chk.checked )
		{
			bValid = true;
			nSelected++;
			arrValue.push(chk.value);
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_SingleCheckbox.Value: ' + e.message);
	}
	return arrValue;
}

SurveyQuestion_SingleCheckbox.prototype.Validate = function(divQuestionError)
{
	var bValid = true;
	try
	{
		var chk = document.getElementById(this.ID);
		if ( chk != null && chk.checked )
		{
			bValid = true;
		}
		if ( Sql.ToBoolean(this.row.REQUIRED) )
		{
			if ( !bValid )
			{
				divQuestionError.innerHTML = this.row.REQUIRED_MESSAGE;
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_SingleCheckbox.Validate: ' + e.message);
	}
	return bValid;
}

SurveyQuestion_SingleCheckbox.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		SurveyQuestion_Helper_RenderHeader(divQuestionHeading, this.row);
		var chk = document.createElement('input');
		chk.id        = this.ID;
		chk.type      = 'checkbox';
		chk.className = 'SurveyAnswerChoice SurveyAnswerChoiceCheckbox';
		chk.value     = '1';
		// 12/31/2015 Paul.  Ignore margins on mobile device as they make the layout terrible. 
		if ( isMobileDevice() )
			chk.style.width = '100%';
		else if ( Sql.ToInteger(this.row.BOX_WIDTH ) > 0 )
			chk.cols = this.row.BOX_WIDTH;
		divQuestionBody.appendChild(chk);
		
		var lab = document.createElement('label');
		lab.setAttribute('for', chk.id);
		divQuestionBody.appendChild(lab);
		lab.innerHTML = this.row.ANSWER_CHOICES;
		
		chk.disabled = Sql.ToBoolean(bDisable);
		if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
		{
			for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
			{
				// 09/18/2016 Paul.  Answer may be null. 
				// 03/14/2019 Paul.  Correct field is checked, not checkbox. 
				chk.checked = Sql.ToBoolean(rowQUESTION_RESULTS[j].ANSWER_TEXT);
				break;
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_SingleCheckbox.Render: ' + e.message);
	}
}

SurveyQuestion_SingleCheckbox.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_SingleCheckbox.Report: ' + e.message);
	}
}

SurveyQuestion_SingleCheckbox.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
{
	try
	{
		if ( this.SUMMARY_VISIBLE === undefined )
			this.SUMMARY_VISIBLE = true;
		else
			return;
		
		var sTABLE_NAME     = 'SURVEY_QUESTIONS_RESULTS';
		var sSORT_FIELD     = 'DATE_ENTERED';
		var sSORT_DIRECTION = 'desc';
		var sSELECT         = 'SURVEY_RESULT_ID, DATE_ENTERED, ANSWER_TEXT';
		var sFILTER         = "SURVEY_ID eq '" + this.row.SURVEY_ID + "' and SURVEY_PAGE_ID eq '" + this.row.SURVEY_PAGE_ID + "' and SURVEY_QUESTION_ID eq '" + this.row.ID + "'";
		SurveyResults_LoadTable(sTABLE_NAME, sSORT_FIELD, sSORT_DIRECTION, sSELECT, sFILTER, function(status, message)
		{
			if ( status == 1 )
			{
				var rows = message;
				if ( rows != null && rows.length > 0 )
				{
					var nANSWERED = 0;
					var nSKIPPED  = 0;
					for ( var i = rows.length - 1; i >= 0; i-- )
					{
						var row = rows[i];
						if ( row['ANSWER_TEXT'] != null )
						{
							nANSWERED++;
						}
						else
						{
							nSKIPPED++;
							rows.splice(i, 1);
						}
					}
					SurveyQuestion_Helper_RenderAnswered(divQuestionHeading, nANSWERED, nSKIPPED);
					
					var tbl = document.createElement('table');
					tbl.id          = this.ID;
					tbl.className   = 'SurveyResultsTextbox';
					tbl.cellPadding = 2;
					tbl.cellSpacing = 0;
					tbl.border      = 0;
					divQuestionBody.appendChild(tbl);
					var tbody = document.createElement('tbody');
					tbl.appendChild(tbody);
					
					var tr = document.createElement('tr');
					tbody.appendChild(tr);
					var td = document.createElement('td');
					td.className = 'SurveyResultsPagination';
					td.colSpan = 3;
					tr.appendChild(td);
					var spnPagination = document.createElement('div');
					td.appendChild(spnPagination);
					spnPagination.id = this.ID + '_pagination';
					
					// http://www.xarg.org/2011/09/jquery-pagination-revised/
					$('#' + spnPagination.id).paging(rows.length, 
					{ onSelect: function(page)
						{
							while ( tbody.childNodes.length > 1 )
							{
								tbody.removeChild(tbody.lastChild);
							}
							for ( var i = this.slice[0]; i < this.slice[1]; i++ )
							{
								var tr = document.createElement('tr');
								tbody.appendChild(tr);
								var row = rows[i];
								var tdDate = document.createElement('td');
								tdDate.className = 'SurveyResultsTextboxDate';
								tr.appendChild(tdDate);
								tdDate.innerHTML = FromJsonDate(row['DATE_ENTERED'], Security.USER_DATE_FORMAT() + ' ' + Security.USER_TIME_FORMAT());
								var tdText = document.createElement('td');
								tdText.className = 'SurveyResultsTextboxText';
								tr.appendChild(tdText);
								if ( row['ANSWER_TEXT'] != null )
								{
									// 06/19/2013 Paul.  Use createTextNode to prevent user data hacks. 
									tdText.appendChild(document.createTextNode(row['ANSWER_TEXT']));
								}
								var tdView = document.createElement('td');
								tdView.className = 'SurveyResultsTextboxView';
								tr.appendChild(tdView);
								var aView = document.createElement('a');
								aView.href      = sREMOTE_SERVER + 'SurveyResults/view.aspx?ID=' + row['SURVEY_RESULT_ID'];
								aView.innerHTML = L10n.Term('Surveys.LBL_DETAILS');
								tdView.appendChild(aView);
							}
							return false;
						}
					, perpage : Crm.Config.ToInteger('list_max_entries_per_page')
					, format  : '< . >'
					, onFormat: SurveyQuestion_ResultsPaginationFormat
					});
				}
			}
			else
			{
				var div = document.createElement('div');
				div.className = 'SurveyQuestionError';
				div.innerHTML = message;
				divQuestionBody.appendChild(div);
			}
			if ( callback !== undefined && callback != null )
				callback.call(context||this, 1, null);
		}, this);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_SingleCheckbox.Summary: ' + e.message);
	}
}

