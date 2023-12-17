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

function SurveyQuestion_SingleDate(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

// 10/08/2018 Paul.  Provide sample for question editor. 
SurveyQuestion_SingleDate.prototype.InitSample = function()
{
}

SurveyQuestion_SingleDate.prototype.Value = function()
{
	var bValid = false;
	var arrValue = new Array();
	try
	{
		var sValue = '';
		var txt = document.getElementById(this.ID);
		if ( txt != null )
		{
			var dt = $('#' + this.ID).datepicker('getDate');
			if ( dt != null )
			{
				// 08/22/2018 Paul.  We should be sending the date as Json, though the server will accept plain text in server format. 
				sValue = ToJsonDate(dt);
			}
			bValid = (sValue.length > 0);
			// 06/19/2013 Paul.  Even if no values, log that the user saw the question. 
			//if ( sValue.length > 0 )
				arrValue.push(sValue);
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_SingleDate.Value: ' + e.message);
	}
	return arrValue;
}

SurveyQuestion_SingleDate.prototype.Validate = function(divQuestionError)
{
	var bValid = false;
	try
	{
		var sValue = '';
		var txt = document.getElementById(this.ID);
		if ( txt != null )
		{
			sValue = Trim(txt.value);
			bValid = (sValue.length > 0);
			if ( bValid )
			{
				bValid = Sql.IsDate(sValue);
				if ( !bValid )
				{
					divQuestionError.innerHTML = this.row.INVALID_DATE_MESSAGE;
					return false;
				}
			}
		}
		// 08/15/2013 Paul.  VALIDATION_TYPE is in row object. 
		if ( bValid && !Sql.IsEmptyString(this.row.VALIDATION_TYPE) )
		{
			bValid = SurveyQuestion_Helper_Validation(this.row, sValue);
			if ( !bValid )
			{
				divQuestionError.innerHTML = SurveyQuestion_Helper_ValidationMessage(this.row);
				return false;
			}
		}
		if ( !bValid && Sql.ToBoolean(this.row.REQUIRED) )
		{
			divQuestionError.innerHTML = this.row.REQUIRED_MESSAGE;
		}
		else
		{
			bValid = true;
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_SingleDate.Validate: ' + e.message);
		bValid = false;
	}
	return bValid;
}

SurveyQuestion_SingleDate.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		SurveyQuestion_Helper_RenderHeader(divQuestionHeading, this.row);
		var txt = document.createElement('input');
		txt.id        = this.ID;
		txt.type      = 'text';
		txt.className = 'SurveyAnswerChoice SurveyAnswerTextbox';
		// 12/31/2015 Paul.  Ignore margins on mobile device as they make the layout terrible. 
		if ( isMobileDevice() )
			txt.style.width = '100%';
		else if ( Sql.ToInteger(this.row.BOX_WIDTH ) > 0 )
			txt.cols = this.row.BOX_WIDTH;
		divQuestionBody.appendChild(txt);
		
		txt.disabled = Sql.ToBoolean(bDisable);
		if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
		{
			for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
			{
				// 09/18/2016 Paul.  Answer may be null. 
				if ( rowQUESTION_RESULTS[j].ANSWER_TEXT != null )
					txt.value = rowQUESTION_RESULTS[j].ANSWER_TEXT;
				break;
			}
		}
		if ( !Sql.ToBoolean(bDisable) )
		{
			// http://trentrichardson.com/examples/timepicker/
			// http://docs.jquery.com/UI/Datepicker/formatDate
			//$('#' + txt.id).datepicker( { dateFormat: sDATE_FORMAT } );
			//$('#' + txt.id).datetimepicker( { dateFormat: sDATE_FORMAT, timeFormat: sTIME_FORMAT, ampm: bAMPM } );
			if ( this.row.DISPLAY_FORMAT == 'DateTime' )
			{
				$('#' + txt.id).datetimepicker( { ampm: true } );
			}
			else if ( this.row.DISPLAY_FORMAT == 'Time' )
			{
				$('#' + txt.id).timepicker( { timeOnly: true, ampm: true } );
			}
			else //if ( this.row.DISPLAY_FORMAT == 'Date' )
			{
				// 06/16/2013 Paul.  Fall through to date so that it becomes the default. 
				$('#' + txt.id).datepicker();
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_SingleDate.Render: ' + e.message);
	}
}

SurveyQuestion_SingleDate.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_SingleDate.Report: ' + e.message);
	}
}

SurveyQuestion_SingleDate.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
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
					tbl.className   = 'SurveyResultsDate';
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
		throw new Error('SurveyQuestion_SingleDate.Summary: ' + e.message);
	}
}

