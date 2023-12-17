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

function SurveyQuestion_Checkbox(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

// 10/08/2018 Paul.  Provide sample for question editor. 
SurveyQuestion_Checkbox.prototype.InitSample = function()
{
	this.row.ANSWER_CHOICES = 'China\r\nEurope\r\nMiddle East\r\nSouth America';
}

SurveyQuestion_Checkbox.prototype.Value = function()
{
	var bValid = false;
	var arrValue = new Array();
	try
	{
		var nSelected = 0;
		var nTotal    = 0;
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			nTotal = arrANSWER_CHOICES.length;
			for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
			{
				var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
				var chk = document.getElementById(this.ID + '_' + sANSWER_ID);
				if ( chk != null && chk.checked )
				{
					bValid = true;
					nSelected++;
					arrValue.push(chk.value);
				}
			}
		}
		if ( Sql.ToBoolean(this.row.OTHER_ENABLED) )
		{
			var sOtherText = '';
			var txtOtherText = document.getElementById(this.ID + '_OtherText');
			if ( txtOtherText != null )
				sOtherText = Trim(txtOtherText.value);
			if ( Sql.ToBoolean(this.row.OTHER_AS_CHOICE) )
			{
				var chkOther = document.getElementById(this.ID + '_Other');
				if ( chkOther != null && chkOther.checked )
				{
					if ( !Sql.IsEmptyString(sOtherText) )
					{
						arrValue.push(md5('Other') + ',' + sOtherText);
					}
				}
			}
			else if ( !Sql.IsEmptyString(sOtherText) )
			{
				arrValue.push(md5('Other') + ',' + sOtherText);
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Checkbox.Value: ' + e.message);
	}
	return arrValue;
}

SurveyQuestion_Checkbox.prototype.Validate = function(divQuestionError)
{
	var bValid = false;
	try
	{
		var sValue    = '';
		var nSelected = 0;
		var nTotal    = 0;
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			nTotal = arrANSWER_CHOICES.length;
			for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
			{
				var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
				var chk = document.getElementById(this.ID + '_' + sANSWER_ID);
				if ( chk != null && chk.checked )
				{
					bValid = true;
					nSelected++;
					if ( sValue.length > 0 )
						sValue += '|';
					sValue += chk.value;
				}
			}
		}
		if ( Sql.ToBoolean(this.row.OTHER_ENABLED) )
		{
			var sOtherText = '';
			var txtOtherText = document.getElementById(this.ID + '_OtherText');
			if ( txtOtherText != null )
				sOtherText = Trim(txtOtherText.value);
			if ( Sql.ToBoolean(this.row.OTHER_AS_CHOICE) )
			{
				var chkOther = document.getElementById(this.ID + '_Other');
				if ( chkOther != null && chkOther.checked )
				{
					if ( Sql.IsEmptyString(sOtherText) )
					{
						divQuestionError.innerHTML = this.row.OTHER_REQUIRED_MESSAGE;
						// 06/09/2013 Paul.  If Other selected but not provied, then display other required message by exiting early. 
						return false;
					}
					else
					{
						bValid = SurveyQuestion_Helper_OtherValidation(this.row, sOtherText);
						if ( !bValid )
						{
							divQuestionError.innerHTML = SurveyQuestion_Helper_OtherValidationMessage(this.row);
							return false;
						}
						if ( sValue.length > 0 )
							sValue += ',';
						sValue += sOtherText;
					}
				}
			}
			else if ( !Sql.IsEmptyString(sOtherText) )
			{
				bValid = SurveyQuestion_Helper_OtherValidation(this.row, sOtherText);
				if ( !bValid )
				{
					divQuestionError.innerHTML = SurveyQuestion_Helper_OtherValidationMessage(this.row);
					return false;
				}
				if ( sValue.length > 0 )
					sValue += ',';
				sValue += sOtherText;
			}
		}
		if ( Sql.ToBoolean(this.row.REQUIRED) )
		{
			// 06/09/2013 Paul.  If type is blank, then use existing bValid value. 
			if ( !Sql.IsEmptyString(this.row.REQUIRED_TYPE) )
			{
				bValid = SurveyQuestion_Helper_RequiredTypeValidation(this.row, nSelected, nTotal);
				if ( !bValid )
					divQuestionError.innerHTML = SurveyQuestion_Helper_RequiredTypeMessage(this.row, nTotal);
			}
			else if ( !bValid )
			{
				divQuestionError.innerHTML = this.row.REQUIRED_MESSAGE;
			}
		}
		else
		{
			bValid = true;
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Checkbox.Validate: ' + e.message);
		bValid = false;
	}
	return bValid;
}

SurveyQuestion_Checkbox.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		SurveyQuestion_Helper_RenderHeader(divQuestionHeading, this.row);
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			if ( arrANSWER_CHOICES.length > 0 )
			{
				var nColumns          = 1;
				var nCellWidth        = 100;
				var nChoices          = arrANSWER_CHOICES.length;
				if ( this.row.OTHER_ENABLED && this.row.OTHER_AS_CHOICE )
					nChoices++;
				var nChoicesPerColumn = Math.ceil(nChoices / nColumns);
				if ( this.row.DISPLAY_FORMAT == 'horizontal' )
				{
					nColumns          = nChoices;
					nCellWidth        = Math.floor(100 / nChoices);
					nChoicesPerColumn = 1;
				}
				else
				{
					nColumns = parseInt(this.row.DISPLAY_FORMAT);
					if ( isNaN(nColumns) )
						nColumns = 1;
					nCellWidth = Math.floor(100 / nColumns);
					nChoicesPerColumn = Math.ceil(nChoices / nColumns);
				}

				var tbl = document.createElement('table');
				tbl.cellSpacing = 0;
				tbl.cellPadding = 0;
				tbl.border      = 0;
				tbl.style.width = '100%';
				divQuestionBody.appendChild(tbl);
				var tbody = document.createElement('tbody');
				tbl.appendChild(tbody);
				var tr = document.createElement('tr');
				tbody.appendChild(tr);
				var td = null;
				
				var nCurrentColumn = 0;
				var bVerticalFill = Sql.ToBoolean(this.row.VERTICAL_FILL);
				if ( !bVerticalFill )
				{
					for ( var i = 0; i < nColumns; i++ )
					{
						td = document.createElement('td');
						td.vAlign      = 'top';
						td.style.width = nCellWidth.toString() + '%';
						tr.appendChild(td);
					}
				}
				for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
				{
					var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
					if ( bVerticalFill )
					{
						if ( td == null || (i % nChoicesPerColumn == 0) )
						{
							td = document.createElement('td');
							td.vAlign      = 'top';
							td.style.width = nCellWidth.toString() + '%';
							tr.appendChild(td);
						}
					}
					else
					{
						td = tr.cells[nCurrentColumn];
						nCurrentColumn++;
						if ( nCurrentColumn >= nColumns )
							nCurrentColumn = 0;
					}
					var div = document.createElement('div');
					div.className = 'SurveyAnswerChoice';
					td.appendChild(div);
					var chk = document.createElement('input');
					chk.id        = this.ID + '_' + sANSWER_ID;
					chk.type      = 'checkbox';
					chk.className = 'SurveyAnswerChoiceCheckbox';
					chk.value     = sANSWER_ID + ',' + arrANSWER_CHOICES[i];
					div.appendChild(chk);
					var lab = document.createElement('label');
					lab.setAttribute('for', chk.id);
					div.appendChild(lab);
					lab.innerHTML = arrANSWER_CHOICES[i];
					
					chk.disabled = Sql.ToBoolean(bDisable);
					if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
					{
						for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
						{
							if ( sANSWER_ID == rowQUESTION_RESULTS[j].ANSWER_ID )
							{
								chk.checked = true;
								break;
							}
						}
					}
				}
				var divOther = (bVerticalFill ? divQuestionBody : tr.cells[nCurrentColumn]);
				SurveyQuestion_Helper_RenderOther(this.row, divOther, this.ID, arrANSWER_CHOICES, null, rowQUESTION_RESULTS, bDisable);
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Checkbox.Render: ' + e.message);
	}
}

SurveyQuestion_Checkbox.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Checkbox.Report: ' + e.message);
	}
}

SurveyQuestion_Checkbox.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
{
	try
	{
		if ( this.SUMMARY_VISIBLE === undefined )
			this.SUMMARY_VISIBLE = true;
		else
			return;
		
		this.ANSWER_CHOICES_SUMMARY = new Array();
		this.OTHER_SUMMARY = new Array();
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
			{
				var oSUMMARY = new Object();
				oSUMMARY.ANSWER_TEXT   = arrANSWER_CHOICES[i];
				oSUMMARY.ANSWER_ID     = md5(arrANSWER_CHOICES[i]);
				oSUMMARY.ANSWERED      = new Array();
				oSUMMARY.SKIPPED       = new Array();
				oSUMMARY.OTHER_SUMMARY = new Array();
				this.ANSWER_CHOICES_SUMMARY.push(oSUMMARY);
			}
		}
		var sOTHER_ID = md5('Other');
		var bOTHER_ENABLED   = false;
		var bOTHER_AS_CHOICE = false;
		if ( Sql.ToBoolean(this.row.OTHER_ENABLED) )
		{
			bOTHER_ENABLED = true;
			if ( Sql.ToBoolean(this.row.OTHER_AS_CHOICE) )
			{
				bOTHER_AS_CHOICE = true;
				var oSUMMARY = new Object();
				oSUMMARY.ANSWER_TEXT   = 'Other';
				oSUMMARY.ANSWER_ID     = sOTHER_ID;
				oSUMMARY.ANSWERED      = new Array();
				oSUMMARY.SKIPPED       = new Array();
				oSUMMARY.OTHER_SUMMARY = new Array();
				this.ANSWER_CHOICES_SUMMARY.push(oSUMMARY);
			}
		}
		
		var sTABLE_NAME     = 'SURVEY_QUESTIONS_RESULTS';
		var sSORT_FIELD     = 'DATE_ENTERED';
		var sSORT_DIRECTION = 'desc';
		var sSELECT         = 'SURVEY_RESULT_ID, DATE_ENTERED, ANSWER_ID, ANSWER_TEXT, OTHER_TEXT';
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
					var oANSWERED = new Object();
					var oSKIPPED  = new Object();
					for ( var i = rows.length - 1; i >= 0; i-- )
					{
						var row = rows[i];
						if ( row['ANSWER_ID'] == null )
						{
							// 08/15/2013 Paul.  Other can still be specified even if no answer is selected. 
							if ( bOTHER_ENABLED && !bOTHER_AS_CHOICE && row['OTHER_TEXT'] != null )
							{
								this.OTHER_SUMMARY.push(row);
							}
							else if ( oSKIPPED[row['SURVEY_RESULT_ID']] === undefined )
							{
								oSKIPPED[row['SURVEY_RESULT_ID']] = true;
								nSKIPPED++;
							}
						}
						else
						{
							row['ANSWER_ID'] = Sql.ToString(row['ANSWER_ID']).replace(/-/g, '');
							for ( var j = 0; j < this.ANSWER_CHOICES_SUMMARY.length; j++ )
							{
								var oANSWER_CHOICES_SUMMARY = this.ANSWER_CHOICES_SUMMARY[j];
								if ( oANSWER_CHOICES_SUMMARY.ANSWER_ID == row['ANSWER_ID'] )
								{
									if ( row['ANSWER_TEXT'] != null )
									{
										oANSWER_CHOICES_SUMMARY.ANSWERED.push(row);
										if ( oANSWERED[row['SURVEY_RESULT_ID']] === undefined )
										{
											oANSWERED[row['SURVEY_RESULT_ID']] = true;
											nANSWERED++;
										}
									}
									else
									{
										oANSWER_CHOICES_SUMMARY.SKIPPED.push(row);
										if ( oSKIPPED[row['SURVEY_RESULT_ID']] === undefined )
										{
											oSKIPPED[row['SURVEY_RESULT_ID']] = true;
											nSKIPPED++;
										}
									}
									if ( bOTHER_AS_CHOICE && sOTHER_ID == row['ANSWER_ID'] )
									{
										oANSWER_CHOICES_SUMMARY.OTHER_SUMMARY.push(row);
									}
								}
								if ( bOTHER_ENABLED && !bOTHER_AS_CHOICE && sOTHER_ID == row['ANSWER_ID'] )
								{
									if ( row['ANSWER_TEXT'] != null )
									{
										this.OTHER_SUMMARY.push(row);
									}
								}
							}
						}
					}
					SurveyQuestion_Helper_RenderAnswered(divQuestionHeading, nANSWERED, nSKIPPED);
					
					var tbl = document.createElement('table');
					tbl.id          = this.ID;
					tbl.className   = 'SurveyResultsCheckbox';
					tbl.cellPadding = 4;
					tbl.cellSpacing = 0;
					tbl.border      = 0;
					divQuestionBody.appendChild(tbl);
					var tbody = document.createElement('tbody');
					tbl.appendChild(tbody);
					
					var tr = document.createElement('tr');
					tbody.appendChild(tr);
					var tdAnswer = document.createElement('td');
					tdAnswer.className = 'SurveyResultsAnswerHeader';
					tdAnswer.width     = '65%';
					tdAnswer.innerHTML = L10n.Term('SurveyResults.LBL_ANSWER_CHOICES');
					tr.appendChild(tdAnswer);
					var tdResponse = document.createElement('td');
					tdResponse.className = 'SurveyResultsResponseHeader';
					tdResponse.width     = '35%';
					tdResponse.innerHTML = L10n.Term('SurveyResults.LBL_RESPONSES');
					tr.appendChild(tdResponse);
					
					var data = new Array();
					for ( var j = 0; j < this.ANSWER_CHOICES_SUMMARY.length; j++ )
					{
						var oANSWER_CHOICES_SUMMARY = this.ANSWER_CHOICES_SUMMARY[j];
						tr = document.createElement('tr');
						tbody.appendChild(tr);
						tdAnswer = document.createElement('td');
						tdAnswer.className = 'SurveyResultsAnswerBody';
						tdAnswer.width     = '65%';
						tr.appendChild(tdAnswer);
						var divAnswerLeft = document.createElement('div');
						divAnswerLeft.style.float = 'left';
						divAnswerLeft.innerHTML = oANSWER_CHOICES_SUMMARY.ANSWER_TEXT;
						tdAnswer.appendChild(divAnswerLeft);
						if ( bOTHER_AS_CHOICE && oANSWER_CHOICES_SUMMARY.ANSWER_ID == sOTHER_ID )
						{
							var divAnswerRight = document.createElement('div');
							divAnswerRight.style.float = 'right';
							tdAnswer.appendChild(divAnswerRight);
						
							var aAnswerExpand = document.createElement('a');
							aAnswerExpand.href      = '#';
							aAnswerExpand.innerHTML = L10n.Term('SurveyResults.LBL_RESPONSES');
							divAnswerRight.appendChild(aAnswerExpand);
							//var divClear = document.createElement('div');
							//divClear.style.clear  = 'left';
							//tdAnswer.appendChild(divClear);
							var divResponses = document.createElement('div');
							divResponses.id            = this.ID + '_' + oANSWER_CHOICES_SUMMARY.ANSWER_ID;
							divResponses.className     = 'SurveyResultsAllResponses';
							divResponses.style.clear   = 'left';
							divResponses.style.display = 'none';
							tdAnswer.appendChild(divResponses);
							aAnswerExpand.onclick = BindArguments(function(divResponses)
							{
								divResponses.style.display = (divResponses.style.display == 'none' ? 'inline' : 'none');
								return false;
							}, divResponses);
							BindArguments(SurveyQuestion_ResultsPaginateResponses, divResponses, oANSWER_CHOICES_SUMMARY.OTHER_SUMMARY, 'DATE_ENTERED', 'ANSWER_TEXT')();
						}
						
						var nPercentage = 0;
						if ( nANSWERED > 0 )
							nPercentage = Math.ceil(100 * oANSWER_CHOICES_SUMMARY.ANSWERED.length / nANSWERED);
						var series = new Array();
						data.unshift(series);
						var values = new Array();
						values.push(nPercentage);
						values.push(oANSWER_CHOICES_SUMMARY.ANSWER_TEXT)
						series.push(values);
						
						tdResponse = document.createElement('td');
						tdResponse.className = 'SurveyResultsResponseBody';
						tdResponse.width     = '35%';
						tr.appendChild(tdResponse);
						var divResponseLeft = document.createElement('div');
						divResponseLeft.style.float = 'left';
						divResponseLeft.innerHTML = nPercentage.toString() + '%';
						tdResponse.appendChild(divResponseLeft);
						
						var divResponseRight = document.createElement('div');
						divResponseRight.style.float = 'right';
						divResponseRight.innerHTML = oANSWER_CHOICES_SUMMARY.ANSWERED.length;
						tdResponse.appendChild(divResponseRight);
					}
					if ( bOTHER_ENABLED && !bOTHER_AS_CHOICE )
					{
						var divOther = document.createElement('div');
						divOther.className = 'SurveyResultsOther';
						divQuestionBody.appendChild(divOther);
						
						var aOtherExpand = document.createElement('a');
						aOtherExpand.href      = '#';
						aOtherExpand.innerHTML = this.row.OTHER_LABEL;
						divOther.appendChild(aOtherExpand);
						//var divClear = document.createElement('div');
						//divClear.style.clear  = 'left';
						//tdAnswer.appendChild(divClear);
						var divResponses = document.createElement('div');
						divResponses.className     = 'SurveyResultsAllResponses';
						divResponses.style.display = 'none';
						divOther.appendChild(divResponses);
						aOtherExpand.onclick = BindArguments(function(divResponses)
						{
							divResponses.style.display = (divResponses.style.display == 'none' ? 'inline' : 'none');
							return false;
						}, divResponses);
						BindArguments(SurveyQuestion_ResultsPaginateResponses, divResponses, this.OTHER_SUMMARY, 'DATE_ENTERED', 'OTHER_TEXT')();
					}
					
					try
					{
						var options = 
						{ seriesDefaults:
							{ renderer:        $.jqplot.BarRenderer
							, shadow:          false
							, pointLabels:     { show: true, location: 'e', edgeTolerance: -15 }
							, rendererOptions: { barDirection: 'horizontal', fillToZero: true, barWidth: 10, barPadding: 0, barMargin: 0 }
							}
						, series: [ { label: null } ]
						, axes:
							{ xaxis: { show: true , autoscale: true, tickOptions: { formatString: '%d%%' } }
							, yaxis: { show: false, renderer: $.jqplot.CategoryAxisRenderer }
							}
						};
						
						var divChartFrame = document.createElement('div');
						divChartFrame.className = 'SurveyResultsChart';
						divQuestionBody.appendChild(divChartFrame);
						var divChart = document.createElement('div');
						divChart.id        = this.ID + '_Chart';
						divChartFrame.appendChild(divChart);
						var plot1 = $.jqplot(divChart.id, data, options);
					}
					catch(e)
					{
						var div = document.createElement('div');
						div.className = 'SurveyQuestionError';
						div.innerHTML = e.message;
						divQuestionBody.appendChild(div);
					}
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
		throw new Error('SurveyQuestion_Checkbox.Summary: ' + e.message);
	}
}

