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

function SurveyQuestion_CheckboxMatrix(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

// 10/08/2018 Paul.  Provide sample for question editor. 
SurveyQuestion_CheckboxMatrix.prototype.InitSample = function()
{
	this.row.ANSWER_CHOICES = 'Shorts\r\nPants\r\nSocks';
	this.row.COLUMN_CHOICES = 'Small\r\nMedium\r\nLarge';
}

SurveyQuestion_CheckboxMatrix.prototype.Value = function()
{
	var bValid = false;
	var arrValue = new Array();
	try
	{
		var nSelected = 0;
		var nTotal    = 0;
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) && !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			var arrCOLUMN_CHOICES = this.row.COLUMN_CHOICES.split('\r\n');
			if ( arrANSWER_CHOICES.length > 0 && arrCOLUMN_CHOICES.length > 0 )
			{
				nTotal = arrANSWER_CHOICES.length;
				for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
				{
					var nColumnsSelected = 0;
					var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
					for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
					{
						var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[j]);
						var chk = document.getElementById(this.ID + '_' + sANSWER_ID + '_' + sCOLUMN_ID);
						if ( chk != null && chk.checked )
						{
							nColumnsSelected++;
							arrValue.push(chk.value);
						}
					}
					// 06/09/2013 Paul.  Any column checked will count the row as selected. 
					if ( nColumnsSelected > 0 )
					{
						nSelected++;
						bValid = true;
					}
				}
			}
		}
		if ( !bValid && Sql.ToBoolean(this.row.OTHER_ENABLED) )
		{
			var sOtherText = '';
			var txtOtherText = document.getElementById(this.ID + '_OtherText');
			if ( txtOtherText != null )
				sOtherText = Trim(txtOtherText.value);
			if ( !Sql.IsEmptyString(sOtherText) )
			{
				arrValue.push(md5('Other') + ',' + sOtherText);
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_CheckboxMatrix.Value: ' + e.message);
	}
	return arrValue;
}

SurveyQuestion_CheckboxMatrix.prototype.Validate = function(divQuestionError)
{
	var bValid = false;
	try
	{
		var sValue    = '';
		var nSelected = 0;
		var nTotal    = 0;
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) && !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			var arrCOLUMN_CHOICES = this.row.COLUMN_CHOICES.split('\r\n');
			if ( arrANSWER_CHOICES.length > 0 && arrCOLUMN_CHOICES.length > 0 )
			{
				nTotal = arrANSWER_CHOICES.length;
				for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
				{
					var nColumnsSelected = 0;
					var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
					for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
					{
						var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[j]);
						var chk = document.getElementById(this.ID + '_' + sANSWER_ID + '_' + sCOLUMN_ID);
						if ( chk != null && chk.checked )
						{
							nColumnsSelected++;
							if ( sValue.length > 0 )
								sValue += '|';
							sValue += chk.value;
						}
					}
					// 06/09/2013 Paul.  Any column checked will count the row as selected. 
					if ( nColumnsSelected > 0 )
					{
						nSelected++;
						bValid = true;
					}
					// 09/10/2018 Paul.  Must be required in order for required type to apply. 
					if ( Sql.ToString(this.row.REQUIRED_TYPE) == 'All' && Sql.ToBoolean(this.row.REQUIRED) )
					{
						var spnRequiredMessage = document.getElementById(this.ID + '_' + sANSWER_ID + '_Error');
						if ( spnRequiredMessage != null )
						{
							spnRequiredMessage.style.display = ((nColumnsSelected == 0) ? 'inline' : 'none');
						}
					}
				}
			}
		}
		if ( !bValid && Sql.ToBoolean(this.row.OTHER_ENABLED) )
		{
			var sOtherText = '';
			var txtOtherText = document.getElementById(this.ID + '_OtherText');
			if ( txtOtherText != null )
				sOtherText = Trim(txtOtherText.value);
			if ( !Sql.IsEmptyString(sOtherText) )
			{
				bValid = SurveyQuestion_Helper_OtherValidation(this.row, sOtherText);
				if ( !bValid )
				{
					divQuestionError.innerHTML = SurveyQuestion_Helper_OtherValidationMessage(this.row);
					return false;
				}
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
		throw new Error('SurveyQuestion_CheckboxMatrix.Validate: ' + e.message);
		bValid = false;
	}
	return bValid;
}

SurveyQuestion_CheckboxMatrix.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		SurveyQuestion_Helper_RenderHeader(divQuestionHeading, this.row);
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) && !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			var arrCOLUMN_CHOICES = this.row.COLUMN_CHOICES.split('\r\n');
			if ( arrANSWER_CHOICES.length > 0 && arrCOLUMN_CHOICES.length > 0 )
			{
				var nLABEL_WIDTH = Sql.ToInteger(this.row.COLUMN_WIDTH);
				var nFIELD_WIDTH = 100 - nLABEL_WIDTH;
				var nColumns     = arrCOLUMN_CHOICES.length;
				var nCellWidth   = Math.floor(nFIELD_WIDTH / arrCOLUMN_CHOICES.length);

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
				var td = document.createElement('td');
				td.vAlign = 'top';
				td.style.width = nLABEL_WIDTH.toString() + '%';
				tr.appendChild(td);
				for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
				{
					td = document.createElement('td');
					td.vAlign = 'top';
					td.align  = 'center';
					td.style.width = nCellWidth.toString() + '%';
					tr.appendChild(td);
					
					var div = document.createElement('div');
					div.className = 'SurveyColumnChoice';
					td.appendChild(div);
					div.innerHTML = arrCOLUMN_CHOICES[j];
				}

				for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
				{
					var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
					tr = document.createElement('tr');
					if ( i % 2 == 0 )
						tr.className = 'SurveyColumnOddRow';
					else
						tr.className = 'SurveyColumnEvenRow';
					tbody.appendChild(tr);
					td = document.createElement('td');
					td.vAlign      = 'top';
					td.style.width = nLABEL_WIDTH.toString() + '%';
					tr.appendChild(td);
					var div = document.createElement('div');
					div.className = 'SurveyColumnChoice';
					td.appendChild(div);
					div.innerHTML = arrANSWER_CHOICES[i];
					if ( Sql.ToString(this.row.REQUIRED_TYPE) == 'All' )
					{
						var spnRequiredMessage = document.createElement('span');
						spnRequiredMessage.id                    = this.ID + '_' + sANSWER_ID + '_Error';
						spnRequiredMessage.className             = 'SurveyQuestionError';
						spnRequiredMessage.style.display         = 'none';
						spnRequiredMessage.style.marginLeft      = '10px';
						spnRequiredMessage.style.marginRight     = '10px';
						try
						{
							spnRequiredMessage.style.backgroundColor = 'inherit';
						}
						catch(e)
						{
							// 06/12/2013 Paul.  IE9 is throwing an "invalid property value" error on the Preview page only. 
						}
						spnRequiredMessage.innerHTML             = this.row.REQUIRED_MESSAGE;
						div.appendChild(spnRequiredMessage)
					}
					
					for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
					{
						var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[j]);
						td = document.createElement('td');
						td.vAlign = 'top';
						td.align  = 'center';
						td.style.width = nCellWidth.toString() + '%';
						tr.appendChild(td);
					
						div = document.createElement('div');
						div.className = 'SurveyColumnChoice';
						td.appendChild(div);
						var chk = document.createElement('input');
						chk.id        = this.ID + '_' + sANSWER_ID + '_' + sCOLUMN_ID;
						chk.type      = 'checkbox';
						chk.className = 'SurveyColumnChoiceCheckbox';
						chk.value     = sANSWER_ID + '_' + sCOLUMN_ID + ',' + arrANSWER_CHOICES[i] + ',' + arrCOLUMN_CHOICES[j];
						div.appendChild(chk);
						
						chk.disabled = Sql.ToBoolean(bDisable);
						if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
						{
							for ( var m = 0; m < rowQUESTION_RESULTS.length; m++ )
							{
								if ( sANSWER_ID == rowQUESTION_RESULTS[m].ANSWER_ID && sCOLUMN_ID == rowQUESTION_RESULTS[m].COLUMN_ID )
								{
									chk.checked = true;
									break;
								}
							}
						}
					}
				}
				SurveyQuestion_Helper_RenderOther(this.row, divQuestionBody, this.ID, arrANSWER_CHOICES, arrCOLUMN_CHOICES, rowQUESTION_RESULTS, bDisable);
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_CheckboxMatrix.Render: ' + e.message);
	}
}

SurveyQuestion_CheckboxMatrix.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_CheckboxMatrix.Report: ' + e.message);
	}
}

SurveyQuestion_CheckboxMatrix.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
{
	try
	{
		if ( this.SUMMARY_VISIBLE === undefined )
			this.SUMMARY_VISIBLE = true;
		else
			return;
		
		this.ANSWER_CHOICES_SUMMARY = new Array();
		this.OTHER_SUMMARY = new Array();
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) && !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			var arrCOLUMN_CHOICES = this.row.COLUMN_CHOICES.split('\r\n');
			for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
			{
				var oSUMMARY = new Object();
				oSUMMARY.ANSWER_TEXT   = arrANSWER_CHOICES[i];
				oSUMMARY.ANSWER_ID     = md5(arrANSWER_CHOICES[i]);
				oSUMMARY.COLUMNS       = new Array();
				oSUMMARY.SKIPPED       = new Array();
				oSUMMARY.ANSWER_TOTAL  = 0;
				this.ANSWER_CHOICES_SUMMARY.push(oSUMMARY);
				for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
				{
					var oCOLUMN = new Object();
					oCOLUMN.COLUMN_TEXT = arrCOLUMN_CHOICES[j];
					oCOLUMN.COLUMN_ID   = md5(arrCOLUMN_CHOICES[j]);
					oCOLUMN.ANSWERED    = new Array();
					oSUMMARY.COLUMNS.push(oCOLUMN);
				}
			}
		}
		var sOTHER_ID = md5('Other');
		var bOTHER_ENABLED   = false;
		if ( Sql.ToBoolean(this.row.OTHER_ENABLED) )
		{
			bOTHER_ENABLED = true;
		}
		
		var sTABLE_NAME     = 'SURVEY_QUESTIONS_RESULTS';
		var sSORT_FIELD     = 'DATE_ENTERED';
		var sSORT_DIRECTION = 'desc';
		var sSELECT         = 'SURVEY_RESULT_ID, DATE_ENTERED, ANSWER_ID, ANSWER_TEXT, COLUMN_ID, COLUMN_TEXT, OTHER_TEXT';
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
						if ( row['ANSWER_ID'] == null || row['COLUMN_ID'] == null )
						{
							if ( oSKIPPED[row['SURVEY_RESULT_ID']] === undefined )
							{
								oSKIPPED[row['SURVEY_RESULT_ID']] = true;
								nSKIPPED++;
							}
							if ( bOTHER_ENABLED && sOTHER_ID == row['ANSWER_ID'] )
							{
								if ( row['OTHER_TEXT'] != null )
								{
									this.OTHER_SUMMARY.push(row);
								}
							}
						}
						else
						{
							row['ANSWER_ID'] = Sql.ToString(row['ANSWER_ID']).replace(/-/g, '');
							row['COLUMN_ID'] = Sql.ToString(row['COLUMN_ID']).replace(/-/g, '');
							for ( var j = 0; j < this.ANSWER_CHOICES_SUMMARY.length; j++ )
							{
								var oANSWER_CHOICES_SUMMARY = this.ANSWER_CHOICES_SUMMARY[j];
								if ( oANSWER_CHOICES_SUMMARY.ANSWER_ID == row['ANSWER_ID'] )
								{
									if ( row['ANSWER_TEXT'] != null )
									{
										for ( var k = 0; k < oANSWER_CHOICES_SUMMARY.COLUMNS.length; k++ )
										{
											var oCOLUMN = oANSWER_CHOICES_SUMMARY.COLUMNS[k];
											if ( oCOLUMN.COLUMN_ID == row['COLUMN_ID'] )
											{
												if ( row['COLUMN_TEXT'] != null )
												{
													oCOLUMN.ANSWERED.push(row);
													oANSWER_CHOICES_SUMMARY.ANSWER_TOTAL++;
													if ( oANSWERED[row['SURVEY_RESULT_ID']] === undefined )
													{
														oANSWERED[row['SURVEY_RESULT_ID']] = true;
														nANSWERED++;
													}
												}
											}
										}
									}
								}
							}
						}
					}
					SurveyQuestion_Helper_RenderAnswered(divQuestionHeading, nANSWERED, nSKIPPED);
					
					var arrCOLUMN_CHOICES = this.row.COLUMN_CHOICES.split('\r\n');
					var nCOLUMNS          = arrCOLUMN_CHOICES.length;
					var nCOLUMN_WIDTH     = Math.ceil(100 / (nCOLUMNS + 2));
					
					var tbl = document.createElement('table');
					tbl.id          = this.ID;
					tbl.className   = 'SurveyResultsRadioMatrix';
					tbl.cellPadding = 4;
					tbl.cellSpacing = 0;
					tbl.border      = 0;
					divQuestionBody.appendChild(tbl);
					var tbody = document.createElement('tbody');
					tbl.appendChild(tbody);
					
					var tr = document.createElement('tr');
					tbody.appendChild(tr);
					var tdAnswer = document.createElement('td');
					tdAnswer.className = 'SurveyResultsAnswerMatrixHeader';
					tdAnswer.width     = nCOLUMN_WIDTH.toString() + '%';
					tr.appendChild(tdAnswer);
					for ( var k = 0; k < arrCOLUMN_CHOICES.length; k++ )
					{
						var tdResponse = document.createElement('td');
						tdResponse.className = 'SurveyResultsResponseMatrixHeader';
						tdResponse.width     = nCOLUMN_WIDTH.toString() + '%';
						tdResponse.innerHTML = arrCOLUMN_CHOICES[k];
						tr.appendChild(tdResponse);
					}
					var tdTotal = document.createElement('td');
					tdTotal.className = 'SurveyResultsResponseMatrixHeaderTotal';
					tdTotal.width     = nCOLUMN_WIDTH.toString() + '%';
					tdTotal.innerHTML = L10n.Term('SurveyResults.LBL_RESPONSES');
					tr.appendChild(tdTotal);
					
					var data = new Array();
					for ( var k = 0; k < arrCOLUMN_CHOICES.length; k++ )
					{
						var series = new Array();
						data.push(series);
					}
					for ( var j = 0; j < this.ANSWER_CHOICES_SUMMARY.length; j++ )
					{
						var oANSWER_CHOICES_SUMMARY = this.ANSWER_CHOICES_SUMMARY[j];
						tr = document.createElement('tr');
						tbody.appendChild(tr);
						tdAnswer = document.createElement('td');
						tdAnswer.className = 'SurveyResultsAnswerMatrixBody';
						tdAnswer.width     = nCOLUMN_WIDTH.toString() + '%';
						tr.appendChild(tdAnswer);
						tdAnswer.innerHTML = oANSWER_CHOICES_SUMMARY.ANSWER_TEXT;
						
						for ( var k = 0; k < oANSWER_CHOICES_SUMMARY.COLUMNS.length; k++ )
						{
							var oCOLUMN = oANSWER_CHOICES_SUMMARY.COLUMNS[k];
							var tdResponse = document.createElement('td');
							tdResponse.className = 'SurveyResultsResponseBody';
							tdResponse.width     = nCOLUMN_WIDTH.toString() + '%';
							tr.appendChild(tdResponse);
							var divResponseLeft = document.createElement('div');
							divResponseLeft.style.float = 'left';
							
							var nPercentage = 0;
							if ( oANSWER_CHOICES_SUMMARY.ANSWER_TOTAL > 0 )
								nPercentage = Math.ceil(100 * oCOLUMN.ANSWERED.length / oANSWER_CHOICES_SUMMARY.ANSWER_TOTAL);
							
							var values = new Array();
							values.push(nPercentage);
							values.push(oANSWER_CHOICES_SUMMARY.ANSWER_TEXT)
							data[oANSWER_CHOICES_SUMMARY.COLUMNS.length - k - 1].unshift(values);
							
							divResponseLeft.innerHTML = nPercentage.toString() + '%';
							tdResponse.appendChild(divResponseLeft);
						
							var divResponseRight = document.createElement('div');
							divResponseRight.className   = 'SurveyResultsResponseMatrixBodyTotal';
							divResponseRight.style.float = 'right';
							divResponseRight.innerHTML = oCOLUMN.ANSWERED.length;
							tdResponse.appendChild(divResponseRight);
						}
						var tdTotal = document.createElement('td');
						tdTotal.className = 'SurveyResultsResponseMatrixTotal';
						tdTotal.width     = nCOLUMN_WIDTH.toString() + '%';
						tdTotal.innerHTML = oANSWER_CHOICES_SUMMARY.ANSWER_TOTAL.toString();
						tr.appendChild(tdTotal);
					}
					if ( bOTHER_ENABLED )
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
					
					//alert(dumpObj(data, 'data'));
					try
					{
						var options = 
						{ seriesDefaults:
							{ renderer:        $.jqplot.BarRenderer
							, shadow:          false
							//, pointLabels:     { show: true, location: 'e', edgeTolerance: -15 }
							, rendererOptions: { barDirection: 'horizontal' }
							}
						, series: null
						, legend: 
							{ show: true
							, renderer: $.jqplot.EnhancedLegendRenderer
							, location: 's'
							, yoffset: 30
							, rendererOptions: { numberRows: 1, seriesToggle: false, reverse: true }
							}
						, axes:
							{ xaxis: { show: true , autoscale: true, min: 0, max: 100, tickOptions: { formatString: '%d%%' } }
							, yaxis: { show: false, renderer: $.jqplot.CategoryAxisRenderer }
							}
						};
						options.series = new Array();
						for ( var k = 0; k < arrCOLUMN_CHOICES.length; k++ )
						{
							var oSeries = new Object();
							options.series.unshift(oSeries);
							oSeries.label = arrCOLUMN_CHOICES[k];
						}
						
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
		throw new Error('SurveyQuestion_CheckboxMatrix.Summary: ' + e.message);
	}
}

