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

function SurveyQuestion_Ranking(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

// 10/08/2018 Paul.  Provide sample for question editor. 
SurveyQuestion_Ranking.prototype.InitSample = function()
{
	this.row.ANSWER_CHOICES = 'Small\r\nMedium\r\nLarge';
}

SurveyQuestion_Ranking.prototype.Value = function()
{
	var bValid = false;
	var arrValue = new Array();
	try
	{
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			if ( arrANSWER_CHOICES.length > 0 )
			{
				bValid = true;
				for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
				{
					var nColumnsSelected = 0;
					var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
					var sel = document.getElementById(this.ID + '_' + sANSWER_ID);
					if ( sel != null && sel.options.selectedIndex > 0 )
					{
						arrValue.push(sANSWER_ID + ',' + arrANSWER_CHOICES[i] + ',' + sel.options[sel.options.selectedIndex].value);
					}
				}
			}
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
		throw new Error('SurveyQuestion_Ranking.Value: ' + e.message);
	}
	return arrValue;
}

SurveyQuestion_Ranking.prototype.Validate = function(divQuestionError)
{
	var bValid = false;
	try
	{
		var sValue = '';
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			if ( arrANSWER_CHOICES.length > 0 )
			{
				bValid = true;
				for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
				{
					var nColumnsSelected = 0;
					var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
					var sel = document.getElementById(this.ID + '_' + sANSWER_ID);
					if ( sel != null && sel.options.selectedIndex > 0 )
					{
						if ( sValue.length > 0 )
							sValue += '|';
						sValue += sel.options[sel.options.selectedIndex].value;
					}
					else
					{
						// 06/09/2013 Paul.  If any one item is blank, then the whole question is invalid. 
						bValid = false;
						break;
					}
				}
			}
		}
		if ( Sql.ToBoolean(this.row.REQUIRED) )
		{
			if ( !bValid )
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
		throw new Error('SurveyQuestion_Ranking.Validate: ' + e.message);
		bValid = false;
	}
	return bValid;
}

SurveyQuestion_Ranking.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		SurveyQuestion_Helper_RenderHeader(divQuestionHeading, this.row);
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			if ( arrANSWER_CHOICES.length > 0 )
			{
				var ul = document.createElement('ul');
				ul.id        = this.ID;
				ul.className = 'SurveyAnswerChoiceRanking';
				divQuestionBody.appendChild(ul);
				for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
				{
					var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
					var sItemID = this.ID + '_' + sANSWER_ID;
					var li = document.createElement('li');
					li.id        = sItemID + '_li';
					li.className = 'SurveyAnswerChoiceRanking ui-state-default';
					ul.appendChild(li);
					
					var sel = document.createElement('select');
					sel.id        = sItemID;
					sel.className = 'SurveyAnswerChoiceRanking';
					li.appendChild(sel);
					var opt = document.createElement('option');
					opt.value = '';
					sel.appendChild(opt);
					for ( var j = 1; j <= arrANSWER_CHOICES.length; j++ )
					{
						opt = document.createElement('option');
						opt.value     = j.toString();
						opt.innerHTML = j.toString();
						sel.appendChild(opt);
					}
					if ( Sql.ToBoolean(this.row.NA_ENABLED) && !Sql.IsEmptyString(this.row.NA_LABEL) )
					{
						opt = document.createElement('option');
						opt.value     = 'N/A';
						opt.innerHTML = this.row.NA_LABEL;
						sel.appendChild(opt);
					}
					if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
					{
						for ( var m = 0; m < rowQUESTION_RESULTS.length; m++ )
						{
							if ( sANSWER_ID == rowQUESTION_RESULTS[m].ANSWER_ID )
							{
								for ( var n = 0; n < sel.options.length; n++ )
								{
									if ( sel.options[n].value == rowQUESTION_RESULTS[m].WEIGHT )
									{
										sel.options.selectedIndex = n;
										break;
									}
								}
							}
						}
					}
					sel.disabled = Sql.ToBoolean(bDisable);
					
					var lab = document.createElement('label');
					lab.className = 'SurveyAnswerChoiceRanking';
					lab.setAttribute('for', sel.id);
					li.appendChild(lab);
					lab.innerHTML = arrANSWER_CHOICES[i];
					if ( !Sql.ToBoolean(bDisable) )
						sel.onchange = BindArguments(SurveyQuestion_Helper_RankingChange, sItemID);
				}
				if ( !Sql.ToBoolean(bDisable) )
				{
					// http://jqueryui.com/sortable/
					// http://api.jqueryui.com/sortable/
					$('#' + this.ID).sortable(
					{ placeholder: 'ui-state-highlight SurveyAnswerChoiceRankingHighlight'
					, items      : 'li:not(.ui-state-disabled)'
					, update: function(event, ui)
						{
							try
							{
								var ul = ui.item[0].parentNode;
								var items = ul.getElementsByTagName('li');
								var sel = ui.item[0].firstChild;
								var nValue = 0;
								for ( var i = 0; i < items.length; i++ )
								{
									if ( items[i] == ui.item[0] )
									{
										nValue = i;
									}
								}
								nValue++;
								sel.options.selectedIndex = nValue;
								SurveyQuestion_Helper_RankingChange(sel.id);
							}
							catch(e)
							{
								alert('sortable.update: ' + e.message);
							}
						}
					});
					// 06/10/2013 Paul.  Disable selection so that disabled items will not get text selected instead. 
					$('#' + this.ID + ' li' ).disableSelection();
				}
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Ranking.Render: ' + e.message);
	}
}

function SurveyQuestion_Helper_RankingChange(sItemID)
{
	try
	{
		var li  = document.getElementById(sItemID + '_li');
		var sel = document.getElementById(sItemID);
		if ( li != null && sel != null )
		{
			var ul = li.parentNode;
			var sValue = sel.options[sel.options.selectedIndex].value;
			if ( sValue == 'N/A' )
			{
				$('#' + sItemID + '_li').addClass('ui-state-disabled');
				// 06/10/2013 Paul.  Move to the end. 
				li.parentNode.appendChild(li);
			}
			else
			{
				$('#' + sItemID + '_li').removeClass('ui-state-disabled');
				// 06/10/2013 Paul.  Value is 1 based, so subtract 1. 
				var nValue = Sql.ToInteger(sValue) - 1;
				var items = ul.getElementsByTagName('li');
				// 06/10/2013 Paul.  Place before any N/A cells. 
				while ( nValue > 0 && items[nValue].firstChild.options[items[nValue].firstChild.options.selectedIndex].value == 'N/A' )
				{
					nValue--;
				}
				ul.removeChild(li);
				items = ul.getElementsByTagName('li');
				if ( nValue >= items.length )
					ul.appendChild(li);
				else
					ul.insertBefore(li, items[nValue]);
			}
			// 06/10/2013 Paul.  If there are any items without a ranking, then fix them. 
			var items = ul.getElementsByTagName('li');
			for ( var j = 0; j < items.length; j++ )
			{
				sel = items[j].firstChild;
				sValue = sel.options[sel.options.selectedIndex].value;
				if ( sValue != 'N/A' )
				{
					sel.options.selectedIndex = j + 1;
				}
			}
			$('#' + this.ID).sortable('refresh');
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Helper_RankingChange: ' + e.message);
	}
}

SurveyQuestion_Ranking.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Ranking.Report: ' + e.message);
	}
}

SurveyQuestion_Ranking.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
{
	try
	{
		if ( this.SUMMARY_VISIBLE === undefined )
			this.SUMMARY_VISIBLE = true;
		else
			return;
		
		this.ANSWER_CHOICES_SUMMARY = new Array();
		var arrCOLUMN_CHOICES  = null;
		var bNA_ENABLED        = Sql.ToBoolean(this.row.NA_ENABLED) && !Sql.IsEmptyString(this.row.NA_LABEL);
		var sNA_ID             = md5('N/A');
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			arrCOLUMN_CHOICES = new Array();
			for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
			{
				var oColumnChoice = new Object();
				oColumnChoice.Label  = (i + 1).toString();
				oColumnChoice.Weight = (i + 1);
				arrCOLUMN_CHOICES.push(oColumnChoice);
			}
			for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
			{
				var oSUMMARY = new Object();
				oSUMMARY.ANSWER_TEXT    = arrANSWER_CHOICES[i];
				oSUMMARY.ANSWER_ID      = md5(arrANSWER_CHOICES[i]);
				oSUMMARY.COLUMNS        = new Array();
				oSUMMARY.SKIPPED        = new Array();
				oSUMMARY.ANSWER_TOTAL   = 0;
				oSUMMARY.WEIGHT_TOTAL   = 0.0;
				this.ANSWER_CHOICES_SUMMARY.push(oSUMMARY);
				for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
				{
					var oCOLUMN = new Object();
					oCOLUMN.COLUMN_TEXT = arrCOLUMN_CHOICES[j].Label;
					oCOLUMN.COLUMN_ID   = md5(arrCOLUMN_CHOICES[j].Label);
					oCOLUMN.WEIGHT      = arrCOLUMN_CHOICES[j].Weight;
					oCOLUMN.ANSWERED    = new Array();
					oSUMMARY.COLUMNS.push(oCOLUMN);
				}
				if ( bNA_ENABLED )
				{
					var oCOLUMN = new Object();
					oCOLUMN.COLUMN_TEXT = L10n.Term('SurveyResults.LBL_NA');
					oCOLUMN.COLUMN_ID   = sNA_ID;
					oCOLUMN.WEIGHT      = 0;
					oCOLUMN.ANSWERED    = new Array();
					oSUMMARY.COLUMNS.push(oCOLUMN);
				}
			}
		}
		
		var sTABLE_NAME     = 'SURVEY_QUESTIONS_RESULTS';
		var sSORT_FIELD     = 'DATE_ENTERED';
		var sSORT_DIRECTION = 'desc';
		var sSELECT         = 'SURVEY_RESULT_ID, DATE_ENTERED, ANSWER_ID, ANSWER_TEXT, WEIGHT';
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
							if ( oSKIPPED[row['SURVEY_RESULT_ID']] === undefined )
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
										for ( var k = 0; k < oANSWER_CHOICES_SUMMARY.COLUMNS.length; k++ )
										{
											var oCOLUMN = oANSWER_CHOICES_SUMMARY.COLUMNS[k];
											if ( oCOLUMN.WEIGHT == row['WEIGHT'] )
											{
												if ( oANSWERED[row['SURVEY_RESULT_ID']] === undefined )
												{
													oANSWERED[row['SURVEY_RESULT_ID']] = true;
													nANSWERED++;
												}
												oCOLUMN.ANSWERED.push(row);
												oANSWER_CHOICES_SUMMARY.ANSWER_TOTAL++;
												oANSWER_CHOICES_SUMMARY.WEIGHT_TOTAL += Sql.ToFloat(row['WEIGHT']);
											}
										}
									}
								}
							}
						}
					}
					SurveyQuestion_Helper_RenderAnswered(divQuestionHeading, nANSWERED, nSKIPPED);
					
					var nCOLUMNS          = arrCOLUMN_CHOICES.length + (bNA_ENABLED ? 1 : 0);
					var nCOLUMN_WIDTH     = Math.ceil(100 / (nCOLUMNS + 3));
					
					var tbl = document.createElement('table');
					tbl.id          = this.ID;
					tbl.className   = 'SurveyResultsRatingScale';
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
						tdResponse.innerHTML = arrCOLUMN_CHOICES[k].Label;
						tr.appendChild(tdResponse);
					}
					if ( bNA_ENABLED )
					{
						var tdResponse = document.createElement('td');
						tdResponse.className = 'SurveyResultsResponseMatrixHeader';
						tdResponse.width     = nCOLUMN_WIDTH.toString() + '%';
						tdResponse.innerHTML = L10n.Term('SurveyResults.LBL_NA');
						tr.appendChild(tdResponse);
					}
					var tdTotal = document.createElement('td');
					tdTotal.className = 'SurveyResultsResponseMatrixHeaderTotal';
					tdTotal.width     = nCOLUMN_WIDTH.toString() + '%';
					tdTotal.innerHTML = L10n.Term('SurveyResults.LBL_RESPONSES');
					tr.appendChild(tdTotal);
					var tdAverage = document.createElement('td');
					tdAverage.className = 'SurveyResultsResponseMatrixHeaderTotal';
					tdAverage.width     = nCOLUMN_WIDTH.toString() + '%';
					tdAverage.innerHTML = L10n.Term('SurveyResults.LBL_AVERAGE_RATING');
					tr.appendChild(tdAverage);
					
					var data = new Array();
					for ( var k = 0; k < arrCOLUMN_CHOICES.length; k++ )
					{
						var series = new Array();
						data.push(series);
					}
					if ( bNA_ENABLED )
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
						var divAnswer = document.createElement('div');
						tdAnswer.appendChild(divAnswer);
						divAnswer.innerHTML = oANSWER_CHOICES_SUMMARY.ANSWER_TEXT;
						
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
						var tdAverage = document.createElement('td');
						tdAverage.className = 'SurveyResultsResponseMatrixTotal';
						tdAverage.width     = nCOLUMN_WIDTH.toString() + '%';
						if ( oANSWER_CHOICES_SUMMARY.ANSWER_TOTAL > 0 )
							tdAverage.innerHTML = (oANSWER_CHOICES_SUMMARY.WEIGHT_TOTAL / oANSWER_CHOICES_SUMMARY.ANSWER_TOTAL).toFixed(2);
						else
							tdAverage.innerHTML = '0.00';
						tr.appendChild(tdAverage);
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
							oSeries.label = arrCOLUMN_CHOICES[k].Label;
						}
						if ( bNA_ENABLED )
						{
							var oSeries = new Object();
							options.series.unshift(oSeries);
							oSeries.label = L10n.Term('SurveyResults.LBL_NA');
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
		throw new Error('SurveyQuestion_Ranking.Summary: ' + e.message);
	}
}

