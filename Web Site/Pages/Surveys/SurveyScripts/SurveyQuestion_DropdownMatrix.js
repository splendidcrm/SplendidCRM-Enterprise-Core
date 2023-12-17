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

function SurveyQuestion_DropdownMatrix(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

// 10/08/2018 Paul.  Provide sample for question editor. 
SurveyQuestion_DropdownMatrix.prototype.InitSample = function()
{
	this.row.ANSWER_CHOICES = 'Shirts\r\nPants\r\nTies';
	this.row.COLUMN_CHOICES = '<?xml version="1.0" encoding="UTF-8"?><Menus><Menu><Heading>Size</Heading><Options>Small\r\nMedium\r\nLarge</Options></Menu><Menu><Heading>Color</Heading><Options>Red\r\nGreen\r\nBlue</Options></Menu></Menus>';
}

SurveyQuestion_DropdownMatrix.prototype.Value = function()
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
			// <Menus><Menu><Heading></Heading><Options></Options></Menu></Menus>
			var arrCOLUMN_CHOICES = new Array();
			var xmlCOLUMN_CHOICES = $.parseXML(this.row.COLUMN_CHOICES);
			$(xmlCOLUMN_CHOICES).find('Menu').each(function()
			{
				var oColumnChoice = new Object();
				oColumnChoice.Heading = $(this).find('Heading').text();
				oColumnChoice.Options = $(this).find('Options').text();
				arrCOLUMN_CHOICES.push(oColumnChoice);
			});
			if ( arrANSWER_CHOICES.length > 0 && arrCOLUMN_CHOICES.length > 0 )
			{
				nTotal = arrANSWER_CHOICES.length;
				for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
				{
					var nColumnsSelected = 0;
					var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
					for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
					{
						var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[j].Heading);
						var sel = document.getElementById(this.ID + '_' + sANSWER_ID + '_' + sCOLUMN_ID);
						if ( sel != null && sel.options.selectedIndex > 0 )
						{
							nColumnsSelected++;
							arrValue.push(sel.options[sel.options.selectedIndex].value);
						}
					}
					// 06/09/2013 Paul.  Don't treat the row as selected unless all columns for the row are selected. 
					if ( nColumnsSelected == arrCOLUMN_CHOICES.length )
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
		throw new Error('SurveyQuestion_DropdownMatrix.Value: ' + e.message);
	}
	return arrValue;
}

SurveyQuestion_DropdownMatrix.prototype.Validate = function(divQuestionError)
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
			// <Menus><Menu><Heading></Heading><Options></Options></Menu></Menus>
			var arrCOLUMN_CHOICES = new Array();
			var xmlCOLUMN_CHOICES = $.parseXML(this.row.COLUMN_CHOICES);
			$(xmlCOLUMN_CHOICES).find('Menu').each(function()
			{
				var oColumnChoice = new Object();
				oColumnChoice.Heading = $(this).find('Heading').text();
				oColumnChoice.Options = $(this).find('Options').text();
				arrCOLUMN_CHOICES.push(oColumnChoice);
			});
			if ( arrANSWER_CHOICES.length > 0 && arrCOLUMN_CHOICES.length > 0 )
			{
				nTotal = arrANSWER_CHOICES.length;
				for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
				{
					var nColumnsSelected = 0;
					var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
					for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
					{
						var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[j].Heading);
						var sel = document.getElementById(this.ID + '_' + sANSWER_ID + '_' + sCOLUMN_ID);
						if ( sel != null && sel.options.selectedIndex > 0 )
						{
							nColumnsSelected++;
							if ( sValue.length > 0 )
								sValue += '|';
							sValue += sel.options[sel.options.selectedIndex].value;
						}
					}
					// 06/09/2013 Paul.  Don't treat the row as selected unless all columns for the row are selected. 
					if ( nColumnsSelected == arrCOLUMN_CHOICES.length )
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
							spnRequiredMessage.style.display = ((nColumnsSelected < arrCOLUMN_CHOICES.length) ? 'inline' : 'none');
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
		throw new Error('SurveyQuestion_DropdownMatrix.Validate: ' + e.message);
		bValid = false;
	}
	return bValid;
}

SurveyQuestion_DropdownMatrix.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		SurveyQuestion_Helper_RenderHeader(divQuestionHeading, this.row);
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) && !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			// <Menus><Menu><Heading></Heading><Options></Options></Menu></Menus>
			var arrCOLUMN_CHOICES = new Array();
			var xmlCOLUMN_CHOICES = $.parseXML(this.row.COLUMN_CHOICES);
			$(xmlCOLUMN_CHOICES).find('Menu').each(function()
			{
				var oColumnChoice = new Object();
				oColumnChoice.Heading = $(this).find('Heading').text();
				oColumnChoice.Options = $(this).find('Options').text();
				arrCOLUMN_CHOICES.push(oColumnChoice);
			});
			//alert(dumpObj(arrCOLUMN_CHOICES, 'arrCOLUMN_CHOICES'));
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
					div.innerHTML = arrCOLUMN_CHOICES[j].Heading;
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
						var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[j].Heading);
						td = document.createElement('td');
						td.vAlign = 'top';
						td.align  = 'center';
						td.style.width = nCellWidth.toString() + '%';
						tr.appendChild(td);
						
						div = document.createElement('div');
						div.className = 'SurveyColumnChoice';
						td.appendChild(div);
						
						var sel = document.createElement('select');
						sel.id        = this.ID + '_' + sANSWER_ID + '_' + sCOLUMN_ID;
						sel.className = 'SurveyColumnChoiceDropdown';
						div.appendChild(sel);
						var opt = document.createElement('option');
						opt.value = '';
						sel.appendChild(opt);
						
						var sOptions   = arrCOLUMN_CHOICES[j].Options;
						var arrOptions = sOptions.split('\n');
						for ( var k = 0; k < arrOptions.length; k++ )
						{
							var sMENU_ITEM_ID = md5(arrOptions[k]);
							opt = document.createElement('option');
							opt.value     = sANSWER_ID + '_' + sCOLUMN_ID + '_' + sMENU_ITEM_ID + ',' + arrANSWER_CHOICES[i] + ',' + arrCOLUMN_CHOICES[j].Heading + ',' + arrOptions[k];
							opt.innerHTML = arrOptions[k];
							sel.appendChild(opt);
							
							if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
							{
								for ( var m = 0; m < rowQUESTION_RESULTS.length; m++ )
								{
									if ( sANSWER_ID == rowQUESTION_RESULTS[m].ANSWER_ID && sCOLUMN_ID == rowQUESTION_RESULTS[m].COLUMN_ID && sMENU_ITEM_ID == rowQUESTION_RESULTS[m].MENU_ID )
									{
										// 06/16/2013 Paul.  Add 1 because of the first option is blank. 
										sel.options.selectedIndex = k + 1;
										break;
									}
								}
							}
						}
						sel.disabled = Sql.ToBoolean(bDisable);
					}
				}
				SurveyQuestion_Helper_RenderOther(this.row, divQuestionBody, this.ID, arrANSWER_CHOICES, arrCOLUMN_CHOICES, rowQUESTION_RESULTS, bDisable);
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_DropdownMatrix.Render: ' + e.message);
	}
}

SurveyQuestion_DropdownMatrix.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_DropdownMatrix.Report: ' + e.message);
	}
}

SurveyQuestion_DropdownMatrix.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
{
	try
	{
		if ( this.SUMMARY_VISIBLE === undefined )
			this.SUMMARY_VISIBLE = true;
		else
			return;
		
		this.ANSWER_CHOICES_SUMMARY = new Array();
		this.OTHER_SUMMARY          = new Array();
		var arrCOLUMN_CHOICES       = new Array();
		var nMENU_MAX               = 0;
		// 12/27/2015 Paul.  Layout is wrong.  The table does not display menu headers. 
		if ( !Sql.IsEmptyString(this.row.ANSWER_CHOICES) && !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			var arrANSWER_CHOICES = this.row.ANSWER_CHOICES.split('\r\n');
			// <Menus><Menu><Heading></Heading><Options></Options></Menu></Menus>
			var xmlCOLUMN_CHOICES = $.parseXML(this.row.COLUMN_CHOICES);
			$(xmlCOLUMN_CHOICES).find('Menu').each(function()
			{
				var oColumnChoice = new Object();
				oColumnChoice.Heading = $(this).find('Heading').text();
				oColumnChoice.Options = $(this).find('Options').text();
				oColumnChoice.OPTIONS = oColumnChoice.Options.split('\n');
				arrCOLUMN_CHOICES.push(oColumnChoice);
			});
			//alert(dumpObj(arrCOLUMN_CHOICES, 'arrCOLUMN_CHOICES'));
			for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
			{
				var oSUMMARY = new Object();
				oSUMMARY.ANSWER_TEXT   = arrANSWER_CHOICES[i];
				oSUMMARY.ANSWER_ID     = md5(oSUMMARY.ANSWER_TEXT);
				oSUMMARY.COLUMNS       = new Array();
				oSUMMARY.ANSWER_TOTAL  = 0;
				this.ANSWER_CHOICES_SUMMARY.push(oSUMMARY);
				for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
				{
					var oCOLUMN = new Object();
					oCOLUMN.COLUMN_TEXT = arrCOLUMN_CHOICES[j].Heading;
					oCOLUMN.COLUMN_ID   = md5(oCOLUMN.COLUMN_TEXT);
					oCOLUMN.ANSWERED    = new Array();
					oCOLUMN.SKIPPED     = new Array();
					oCOLUMN.OPTIONS     = arrCOLUMN_CHOICES[j].OPTIONS;
					oCOLUMN.MENUS       = new Array();
					oSUMMARY.COLUMNS.push(oCOLUMN);
					for ( var k = 0; k < oCOLUMN.OPTIONS.length; k++ )
					{
						var oMENU = new Object();
						oMENU.MENU_TEXT    = arrCOLUMN_CHOICES[j].OPTIONS[k];
						oMENU.MENU_ID      = md5(oMENU.MENU_TEXT);
						oMENU.ANSWERED     = new Array();
						oMENU.SKIPPED      = new Array();
						oMENU.ANSWER_TOTAL = 0;
						oCOLUMN.MENUS.push(oMENU);
					}
					nMENU_MAX = Math.max(nMENU_MAX, oCOLUMN.OPTIONS.length);
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
		var sSELECT         = 'SURVEY_RESULT_ID, DATE_ENTERED, ANSWER_ID, ANSWER_TEXT, COLUMN_ID, COLUMN_TEXT, MENU_ID, MENU_TEXT, OTHER_TEXT';
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
						if ( row['ANSWER_ID'] == null || row['COLUMN_ID'] == null || row['MENU_ID'] == null )
						{
							// 07/25/2021 Paul.  oCOLUMN is not defined yet, so must be wrong. 
							//oCOLUMN.SKIPPED.push(row);
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
							row['MENU_ID'  ] = Sql.ToString(row['MENU_ID'  ]).replace(/-/g, '');
							for ( var j = 0; j < this.ANSWER_CHOICES_SUMMARY.length; j++ )
							{
								var oSUMMARY = this.ANSWER_CHOICES_SUMMARY[j];
								if ( oSUMMARY.ANSWER_ID == row['ANSWER_ID'] )
								{
									if ( row['ANSWER_TEXT'] != null )
									{
										for ( var k = 0; k < oSUMMARY.COLUMNS.length; k++ )
										{
											var oCOLUMN = oSUMMARY.COLUMNS[k];
											if ( oCOLUMN.COLUMN_ID == row['COLUMN_ID'] )
											{
												if ( row['COLUMN_TEXT'] != null )
												{
													for ( var l = 0; l < oCOLUMN.MENUS.length; l++ )
													{
														var oMENU = oCOLUMN.MENUS[l];
														if ( oMENU.MENU_ID == row['MENU_ID'] )
														{
															if ( row['MENU_TEXT'] != null )
															{
																oMENU.ANSWERED.push(row);
																oMENU.ANSWER_TOTAL++;
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
							}
						}
					}
					SurveyQuestion_Helper_RenderAnswered(divQuestionHeading, nANSWERED, nSKIPPED);
					
					for ( var l = 0; l < this.ANSWER_CHOICES_SUMMARY.length; l++ )
					{
						var oSUMMARY = this.ANSWER_CHOICES_SUMMARY[l];
//MAX_DUMP_DEPTH = 6;
//alert(dumpObj(oSUMMARY), 'oSUMMARY');
						var divSUMMARY = document.createElement('div');
						divSUMMARY.className = 'SurveyResultsColumnMatrixHeader';
						divSUMMARY.innerHTML = oSUMMARY.ANSWER_TEXT;
						divQuestionBody.appendChild(divSUMMARY);
						
						var nSUMMARIES     = 2 * oSUMMARY.COLUMNS.length;
						var nSUMMARY_WIDTH = Math.ceil(100 / (nSUMMARIES + 2));
						
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
						var tdColumn = document.createElement('td');
						tdColumn.className = 'SurveyResultsAnswerMatrixHeader';
						tdColumn.width     = nSUMMARY_WIDTH.toString() + '%';
						tr.appendChild(tdColumn);
						for ( var k = 0; k < arrCOLUMN_CHOICES.length; k++ )
						{
							tdColumn = document.createElement('td');
							tdColumn.className = 'SurveyResultsResponseMatrixHeader';
							tdColumn.width     = nSUMMARY_WIDTH.toString() + '%';
							tdColumn.innerHTML = arrCOLUMN_CHOICES[k].Heading;
							tr.appendChild(tdColumn);
							tdColumn = document.createElement('td');
							tdColumn.className = 'SurveyResultsResponseMatrixHeader';
							tdColumn.width     = nSUMMARY_WIDTH.toString() + '%';
							tr.appendChild(tdColumn);
						}
						//var tdTotal = document.createElement('td');
						//tdTotal.className = 'SurveyResultsResponseMatrixHeaderTotal';
						//tdTotal.width     = nSUMMARY_WIDTH.toString() + '%';
						//tdTotal.innerHTML = L10n.Term('SurveyResults.LBL_RESPONSES');
						//tr.appendChild(tdTotal);
						for ( var k = 0; k < nMENU_MAX; k++ )
						{
							tr = document.createElement('tr');
							tbody.appendChild(tr);
							tdColumn = document.createElement('td');
							tdColumn.className = 'SurveyResultsAnswerMatrixBody';
							tdColumn.width     = nSUMMARY_WIDTH.toString() + '%';
							tr.appendChild(tdColumn);
							
							for ( var j = 0; j < oSUMMARY.COLUMNS.length; j++ )
							{
								var oCOLUMN = oSUMMARY.COLUMNS[j];
								if ( k < oCOLUMN.MENUS.length )
								{
									var oMENU = oCOLUMN.MENUS[k];
									var tdMenu = document.createElement('td');
									tdMenu.className = 'SurveyResultsAnswerMatrixBody';
									tdMenu.width     = nSUMMARY_WIDTH.toString() + '%';
									tr.appendChild(tdMenu);
									tdMenu.innerHTML = oMENU.MENU_TEXT;

									var tdColumn = document.createElement('td');
									tdColumn.className = 'SurveyResultsResponseBody';
									tdColumn.width     = nSUMMARY_WIDTH.toString() + '%';
									tr.appendChild(tdColumn);
									var divResponseLeft = document.createElement('div');
									divResponseLeft.style.float = 'left';
									if ( oMENU.ANSWER_TOTAL > 0 )
										divResponseLeft.innerHTML = Math.ceil(100 * oMENU.ANSWERED.length / oMENU.ANSWER_TOTAL).toString() + '%';
									else
										divResponseLeft.innerHTML = '0%';
									tdColumn.appendChild(divResponseLeft);
						
									var divResponseRight = document.createElement('div');
									divResponseRight.className   = 'SurveyResultsResponseMatrixBodyTotal';
									divResponseRight.style.float = 'right';
									divResponseRight.innerHTML = oMENU.ANSWERED.length;
									tdColumn.appendChild(divResponseRight);
								}
								else
								{
									var tdMenu = document.createElement('td');
									tdMenu.className = 'SurveyResultsAnswerMatrixBody';
									tdMenu.width     = nSUMMARY_WIDTH.toString() + '%';
									tr.appendChild(tdMenu);
									var tdColumn = document.createElement('td');
									tdColumn.className = 'SurveyResultsResponseBody';
									tdColumn.width     = nSUMMARY_WIDTH.toString() + '%';
									tr.appendChild(tdColumn);
								}
								//var tdTotal = document.createElement('td');
								//tdTotal.className = 'SurveyResultsResponseMatrixTotal';
								//tdTotal.width     = nSUMMARY_WIDTH.toString() + '%';
								//tdTotal.innerHTML = oCOLUMN.ANSWER_TOTAL.toString();
								//tr.appendChild(tdTotal);
							}
						}
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

					// 12/27/2015 Paul.  Don't create charts.  There would be too many,  Answers * Columns. 
					/*
					for ( var l = 0; l < this.ANSWER_CHOICES_SUMMARY.length; l++ )
					{
						var oSUMMARY = this.ANSWER_CHOICES_SUMMARY[l];
						var arrCOLUMN_OPTIONS = oSUMMARY.COLUMNS;
						var divANSWER = document.createElement('div');
						divANSWER.className = 'SurveyResultsColumnMatrixHeader';
						divANSWER.innerHTML = oSUMMARY.ANSWER_TEXT;
						divQuestionBody.appendChild(divANSWER);
						
						var data = new Array();
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
							var series = new Array();
							data.push(series);
						}
						for ( var j = 0; j < oSUMMARY.COLUMNS.length; j++ )
						{
							var oCOLUMNS = oSUMMARY.COLUMNS[j];
							for ( var k = 0; k < oCOLUMNS.MENUS.length; k++ )
							{
								var oMENU = oCOLUMNS.MENUS[k];
								var oSeries = new Object();
								options.series.unshift(oSeries);
								oSeries.label = oMENU.MENU_TEXT;
								
								var nPercentage = 0;
								if ( oMENU.ANSWER_TOTAL > 0 )
									nPercentage = Math.ceil(100 * oMENU.ANSWERED.length / oMENU.ANSWER_TOTAL);
								
								var values = new Array();
								values.push(nPercentage);
								values.push(oMENU.MENU_TEXT)
								//data[oSUMMARY.oCOLUMNS.length - k - 1].unshift(values);
							}
						}
						
						//alert(dumpObj(data, 'data'));
						try
						{
							var divChartFrame = document.createElement('div');
							divChartFrame.className = 'SurveyResultsChart';
							divQuestionBody.appendChild(divChartFrame);
							var divChart = document.createElement('div');
							divChart.id        = this.ID + '_Chart_' + oCOLUMN.COLUMN_ID;
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
					*/
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
		throw new Error('SurveyQuestion_DropdownMatrix.Summary: ' + e.message);
	}
}

