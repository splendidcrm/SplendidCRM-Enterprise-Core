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

function SurveyQuestion_Range(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

// 10/08/2018 Paul.  Provide sample for question editor. 
SurveyQuestion_Range.prototype.InitSample = function()
{
	this.row.ANSWER_CHOICES = '0\r\n100\r\n10';
}

SurveyQuestion_Range.prototype.Value = function()
{
	var bValid = false;
	var arrValue = new Array();
	try
	{
		var sValue = '';
		var rng = document.getElementById(this.ID);
		if ( rng != null )
		{
			sValue = rng.value.toString();
			bValid = true;
			arrValue.push(sValue);
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Range.Value: ' + e.message);
	}
	return arrValue;
}

SurveyQuestion_Range.prototype.Validate = function(divQuestionError)
{
	var bValid = false;
	try
	{
		var rng = document.getElementById(this.ID);
		if ( rng != null )
		{
			bValid = true;
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
		throw new Error('SurveyQuestion_Range.Validate: ' + e.message);
		bValid = false;
	}
	return bValid;
}

SurveyQuestion_Range.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		SurveyQuestion_Helper_RenderHeader(divQuestionHeading, this.row);
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			var nRANGE_MIN  = Sql.ToInteger(arrANSWER_CHOICES[0]);
			var nRANGE_MAX  = 100;
			var nRANGE_STEP = 1;
			if ( arrANSWER_CHOICES.length > 0 )
				nRANGE_MAX  = Sql.ToInteger(arrANSWER_CHOICES[1]);
			if ( arrANSWER_CHOICES.length > 1 )
				nRANGE_STEP = Sql.ToInteger(arrANSWER_CHOICES[2]);

			// 12/30/2015 Paul.  Display min and max. 
			var spnMin = document.createElement('span');
			spnMin.className = 'SurveyAnswerChoice SurveyAnswerRange';
			// 03/14/2016 Paul.  Firefox does not support innerText. 
			spnMin.innerHTML = nRANGE_MIN.toString();
			spnMin.style.paddingRight = '4px';
			divQuestionBody.appendChild(spnMin);

			// http://www.w3schools.com/jsref/dom_obj_range.asp
			var rng = document.createElement('input');
			rng.id        = this.ID;
			rng.type      = 'range';
			rng.min       = nRANGE_MIN ;
			rng.max       = nRANGE_MAX ;
			rng.step      = nRANGE_STEP;
			rng.value     = 0;
			rng.className = 'SurveyAnswerChoice SurveyAnswerRange';
			if ( this.row.DISPLAY_FORMAT == 'vertical' )
			{
				rng.orient = 'vertical';
				rng.className += ' SurveyAnswerRangeVertical';
			}
			//if ( Sql.ToInteger(this.row.BOX_WIDTH ) > 0 ) rng.cols = this.row.BOX_WIDTH;
			divQuestionBody.appendChild(rng);
		
			// 12/30/2015 Paul.  Display min and max. 
			var spnMax = document.createElement('span');
			spnMax.className = 'SurveyAnswerChoice SurveyAnswerRange';
			// 03/14/2016 Paul.  Firefox does not support innerText. 
			spnMax.innerHTML = nRANGE_MAX.toString();
			spnMax.style.paddingLeft = '4px';
			divQuestionBody.appendChild(spnMax);

			rng.disabled = Sql.ToBoolean(bDisable);
			if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
			{
				for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
				{
					rng.value = Sql.ToInteger(rowQUESTION_RESULTS[j].ANSWER_TEXT);
					break;
				}
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Range.Render: ' + e.message);
	}
}

SurveyQuestion_Range.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Range.Report: ' + e.message);
	}
}

SurveyQuestion_Range.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
{
	try
	{
		if ( this.SUMMARY_VISIBLE === undefined )
			this.SUMMARY_VISIBLE = true;
		else
			return;
		
		var nRANGE_MIN  = 0  ;
		var nRANGE_MAX  = 100;
		var nRANGE_STEP = 1  ;
		this.ANSWER_CHOICES_SUMMARY = new Array();
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			nRANGE_MIN  = Sql.ToInteger(arrANSWER_CHOICES[0]);
			nRANGE_MAX  = 100;
			nRANGE_STEP = 1;
			if ( arrANSWER_CHOICES.length > 0 )
				nRANGE_MAX  = Sql.ToInteger(arrANSWER_CHOICES[1]);
			if ( arrANSWER_CHOICES.length > 1 )
				nRANGE_STEP = Sql.ToInteger(arrANSWER_CHOICES[2]);
			if ( nRANGE_STEP == 0 )
				nRANGE_STEP = 1;
			// 12/26/2015 Paul.  We will have a loop creating summary rows, so we need to make sure the values are valid. 
			if ( nRANGE_STEP > 0 )
			{
				if ( nRANGE_MIN > nRANGE_MAX )
				{
					nRANGE_MIN  = 0  ;
					nRANGE_MAX  = 100;
				}
			}
			else
			{
				if ( nRANGE_MIN < nRANGE_MAX )
				{
					nRANGE_MIN  = 0  ;
					nRANGE_MAX  = 100;
				}
			}
		}
		
		var sTABLE_NAME     = 'SURVEY_QUESTIONS_RESULTS';
		var sSORT_FIELD     = 'DATE_ENTERED';
		var sSORT_DIRECTION = 'desc';
		var sSELECT         = 'SURVEY_RESULT_ID, DATE_ENTERED, ANSWER_ID, ANSWER_TEXT';
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
					for ( var i = 0; i < rows.length; i++ )
					{
						var row = rows[i];
						if ( row['ANSWER_TEXT'] != null )
						{
							var bFound = false;
							for ( var j = 0; j < this.ANSWER_CHOICES_SUMMARY.length; j++ )
							{
								var oANSWER_CHOICES_SUMMARY = this.ANSWER_CHOICES_SUMMARY[j];
								if ( oANSWER_CHOICES_SUMMARY.ANSWER_TEXT == Sql.ToString(row['ANSWER_TEXT']) )
								{
									oANSWER_CHOICES_SUMMARY.ANSWERED.push(row);
									oANSWER_CHOICES_SUMMARY.TOTAL += Sql.ToFloat(row['ANSWER_TEXT']);
									if ( oANSWERED[row['SURVEY_RESULT_ID']] === undefined )
									{
										oANSWERED[row['SURVEY_RESULT_ID']] = true;
										nANSWERED++;
									}
									bFound = true;
								}
							}
							if ( !bFound )
							{
								var oSUMMARY = new Object();
								oSUMMARY.ANSWER_TEXT = Sql.ToString(row['ANSWER_TEXT']);
								oSUMMARY.ANSWER_ID   = '';
								oSUMMARY.ANSWERED    = new Array();
								oSUMMARY.SKIPPED     = new Array();
								oSUMMARY.TOTAL       = Sql.ToFloat(row['ANSWER_TEXT']);
								oSUMMARY.ANSWERED.push(row);
								this.ANSWER_CHOICES_SUMMARY.push(oSUMMARY);
								if ( oANSWERED[row['SURVEY_RESULT_ID']] === undefined )
								{
									oANSWERED[row['SURVEY_RESULT_ID']] = true;
									nANSWERED++;
								}
							}
						}
						else
						{
							if ( oSKIPPED[row['SURVEY_RESULT_ID']] === undefined )
							{
								oSKIPPED[row['SURVEY_RESULT_ID']] = true;
								nSKIPPED++;
							}
						}
					}
					if ( this.ANSWER_CHOICES_SUMMARY.length > 0 )
					{
						this.ANSWER_CHOICES_SUMMARY.sort(function(a, b)
						{
							var al = Sql.ToFloat(a);
							var bl = Sql.ToFloat(b);
							return al == bl ? (a == b ? 0 : (a < b ? 1 : -1)) : (al < bl ? 1 : -1);
						});
					}
					SurveyQuestion_Helper_RenderAnswered(divQuestionHeading, nANSWERED, nSKIPPED);
					
					var tbl = document.createElement('table');
					tbl.id          = this.ID;
					tbl.className   = 'SurveyResultsRange';
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
					tdAnswer.width     = '55%';
					tdAnswer.innerHTML = L10n.Term('SurveyResults.LBL_ANSWER_CHOICES');
					tr.appendChild(tdAnswer);

					var tdAverage = document.createElement('td');
					tdAverage.className = 'SurveyResultsResponseHeader';
					tdAverage.align     = 'right';
					tdAverage.width     = '15%';
					tdAverage.innerHTML = L10n.Term('SurveyResults.LBL_AVERAGE');
					tr.appendChild(tdAverage);

					var tdTotal = document.createElement('td');
					tdTotal.className = 'SurveyResultsResponseHeader';
					tdTotal.align     = 'right';
					tdTotal.width     = '15%';
					tdTotal.innerHTML = L10n.Term('SurveyResults.LBL_TOTAL');
					tr.appendChild(tdTotal);

					var tdResponse = document.createElement('td');
					tdResponse.className = 'SurveyResultsResponseHeader';
					tdResponse.align     = 'right';
					tdResponse.width     = '15%';
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
						tdAnswer.width     = '55%';
						tr.appendChild(tdAnswer);
						var divAnswerLeft = document.createElement('div');
						divAnswerLeft.style.float = 'left';
						divAnswerLeft.innerHTML = oANSWER_CHOICES_SUMMARY.ANSWER_TEXT;
						tdAnswer.appendChild(divAnswerLeft);
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
						BindArguments(SurveyQuestion_ResultsPaginateResponses, divResponses, oANSWER_CHOICES_SUMMARY.ANSWERED, 'DATE_ENTERED', 'ANSWER_TEXT')();
						
						var fAverage = (oANSWER_CHOICES_SUMMARY.TOTAL / nANSWERED).toFixed(2);
						var series = new Array();
						data.unshift(series);
						var values = new Array();
						values.push(fAverage);
						values.push(oANSWER_CHOICES_SUMMARY.ANSWER_TEXT)
						series.push(values);
						
						tdAverage = document.createElement('td');
						tdAverage.className = 'SurveyResultsResponseBody';
						tdAverage.width     = '15%';
						tdAverage.align     = 'right';
						tr.appendChild(tdAverage);
						tdAverage.innerHTML = fAverage.toString();
						
						tdTotal = document.createElement('td');
						tdTotal.className = 'SurveyResultsResponseBody';
						tdTotal.width     = '15%';
						tdTotal.align     = 'right';
						tr.appendChild(tdTotal);
						tdTotal.innerHTML = Math.floor(oANSWER_CHOICES_SUMMARY.TOTAL).toString();
						
						tdResponse = document.createElement('td');
						tdResponse.className = 'SurveyResultsResponseBody';
						tdResponse.width     = '15%';
						tdResponse.align     = 'right';
						tr.appendChild(tdResponse);
						tdResponse.innerHTML = oANSWER_CHOICES_SUMMARY.ANSWERED.length;
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
							{ xaxis: { show: true , autoscale: true, min: nRANGE_MIN, max: nRANGE_MAX, pad: 3, numberTicks: ((nRANGE_MAX - nRANGE_MIN)/nRANGE_STEP + 1) }
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
		throw new Error('SurveyQuestion_Range.Summary: ' + e.message);
	}
}

