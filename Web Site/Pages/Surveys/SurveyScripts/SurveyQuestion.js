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

function SurveyQuestion_LoadItem(sMODULE_NAME, sID, callback, context)
{
	var xhr = CreateSplendidRequest('Survey.svc/GetSurveyQuestion?ID=' + sID, 'GET');
	xhr.onreadystatechange = function()
	{
		if ( xhr.readyState == 4 )
		{
			GetSplendidResult(xhr, function(result)
			{
				try
				{
					if ( result.status == 200 )
					{
						if ( result.d !== undefined )
						{
							callback.call(context||this, 1, result.d.results);
						}
						else if ( result.ExceptionDetail !== undefined )
						{
							callback.call(context||this, -1, result.ExceptionDetail.Message);
						}
						else
						{
							callback.call(context||this, -1, xhr.responseText);
						}
					}
					else
					{
						if ( result.ExceptionDetail !== undefined )
							callback.call(context||this, -1, result.ExceptionDetail.Message);
						else
							callback.call(context||this, -1, xhr.responseText);
					}
				}
				catch(e)
				{
					callback.call(context||this, -1, SplendidError.FormatError(e, 'SurveyQuestion_LoadItem'));
				}
			});
		}
	}
	try
	{
		xhr.send();
	}
	catch(e)
	{
		// 03/28/2012 Paul.  IE9 is returning -2146697208 when working offline. 
		if ( e.number != -2146697208 )
			callback.call(context||this, -1, SplendidError.FormatError(e, 'SurveyQuestion_LoadItem'));
	}
}

function SurveyQuestion_Factory(row)
{
	var question = null;
	switch ( row.QUESTION_TYPE )
	{
		case 'Radio'            :  question = new SurveyQuestion_Radio           (row);  break;
		case 'Checkbox'         :  question = new SurveyQuestion_Checkbox        (row);  break;
		case 'Dropdown'         :  question = new SurveyQuestion_Dropdown        (row);  break;
		case 'Ranking'          :  question = new SurveyQuestion_Ranking         (row);  break;
		case 'Rating Scale'     :  question = new SurveyQuestion_RatingScale     (row);  break;
		case 'Radio Matrix'     :  question = new SurveyQuestion_RadioMatrix     (row);  break;
		case 'Checkbox Matrix'  :  question = new SurveyQuestion_CheckboxMatrix  (row);  break;
		case 'Dropdown Matrix'  :  question = new SurveyQuestion_DropdownMatrix  (row);  break;
		case 'Text Area'        :  question = new SurveyQuestion_TextArea        (row);  break;
		case 'Textbox'          :  question = new SurveyQuestion_Textbox         (row);  break;
		case 'Textbox Multiple' :  question = new SurveyQuestion_TextboxMultiple (row);  break;
		case 'Textbox Numerical':  question = new SurveyQuestion_TextboxNumerical(row);  break;
		case 'Plain Text'       :  question = new SurveyQuestion_PlainText       (row);  break;
		case 'Image'            :  question = new SurveyQuestion_Image           (row);  break;
		case 'Date'             :  question = new SurveyQuestion_Date            (row);  break;
		case 'Demographic'      :  question = new SurveyQuestion_Demographic     (row);  break;
		// 10/08/2014 Paul.  Add Range question type. 
		case 'Range'            :  question = new SurveyQuestion_Range           (row);  break;
		// 11/07/2018 Paul.  Provide a way to get a single numerical value for lead population.
		case 'Single Numerical' :  question = new SurveyQuestion_SingleNumerical (row);  break;
		// 11/07/2018 Paul.  Provide a way to get a single date for lead population.
		case 'Single Date'      :  question = new SurveyQuestion_SingleDate      (row);  break;
		// 11/10/2018 Paul.  Provide a way to get a single checkbox for lead population.
		case 'Single Checkbox'  :  question = new SurveyQuestion_SingleCheckbox  (row);  break;
		// 11/10/2018 Paul.  Provide a way to get a hidden value for lead population.
		case 'Hidden'           :  question = new SurveyQuestion_Hidden          (row);  break;
		default:
			throw new Error('Unsupported question type: ' + row.QUESTION_TYPE);
			break;
	}
	return question;
}

function SurveyQuestion_Validate(row)
{
	var bValid = false;
	try
	{
		var question = SurveyQuestion_Factory(row);
		if ( question != null )
		{
			var divQuestionError = document.getElementById(question.ID + '_Error');
			SurveyQuestion_Helper_Clear(divQuestionError);
			bValid = question.Validate(divQuestionError);
			if ( !bValid )
			{
				divQuestionError.style.display = 'inline';
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Validate: ' + e.message);
	}
	return bValid;
}

function SurveyQuestion_Value(row)
{
	var arrValue = '';
	try
	{
		var question = SurveyQuestion_Factory(row);
		if ( question != null )
		{
			arrValue = question.Value();
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Value: ' + e.message);
	}
	return arrValue;
}

function SurveyQuestion_Helper_Clear(div)
{
	while ( div.childNodes.length > 0 )
	{
		div.removeChild(div.firstChild);
	}
}

function SurveyQuestion_Helper_RenderOther(row, divQuestionBody, sID, arrANSWER_CHOICES, arrCOLUMN_CHOICES, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		if ( Sql.ToBoolean(row.OTHER_ENABLED) )
		{
			var rad = null;
			var chk = null;
			var sel = null;
			var div = document.createElement('div');
			if ( row.QUESTION_TYPE == 'Rating Scale' )
				div.className = 'SurveyColumnOther';
			else
				div.className = 'SurveyAnswerChoice';
			divQuestionBody.appendChild(div);
			var lab = document.createElement('label');
			lab.style.marginRight = '10px';
			
			var sOTHER_ID   = md5('Other');
			var sOTHER_TEXT = null;
			if ( Sql.ToBoolean(row.OTHER_AS_CHOICE) )
			{
				if ( row.QUESTION_TYPE == 'Radio' )
				{
					rad = document.createElement('input');
					rad.id        = sID + '_Other';
					rad.name      = sID;
					rad.type      = 'radio';
					rad.className = 'SurveyAnswerChoiceRadio';
					rad.value     = 'Other';
					div.appendChild(rad);
					lab.setAttribute('for', rad.id);
					
					rad.disabled = Sql.ToBoolean(bDisable);
					if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
					{
						for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
						{
							if ( sOTHER_ID == rowQUESTION_RESULTS[j].ANSWER_ID )
							{
								sOTHER_TEXT = rowQUESTION_RESULTS[j].OTHER_TEXT;
								rad.checked = true;
								break;
							}
						}
					}
				}
				else if ( row.QUESTION_TYPE == 'Checkbox' )
				{
					chk = document.createElement('input');
					chk.id        = sID + '_Other';
					chk.name      = sID;
					chk.type      = 'checkbox';
					chk.className = 'SurveyAnswerChoiceCheckbox';
					chk.value     = 'Other';
					div.appendChild(chk);
					lab.setAttribute('for', chk.id);
					
					chk.disabled = Sql.ToBoolean(bDisable);
					if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
					{
						for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
						{
							if ( sOTHER_ID == rowQUESTION_RESULTS[j].ANSWER_ID )
							{
								sOTHER_TEXT = rowQUESTION_RESULTS[j].OTHER_TEXT;
								chk.checked = true;
								break;
							}
						}
					}
				}
				else if ( row.QUESTION_TYPE == 'Dropdown' )
				{
					sel = document.getElementById(sID);
					var opt = document.createElement('option');
					opt.value     = 'Other';
					opt.innerHTML = row.OTHER_LABEL;
					sel.appendChild(opt);
					
					sel.disabled = Sql.ToBoolean(bDisable);
					if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
					{
						for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
						{
							if ( sOTHER_ID == rowQUESTION_RESULTS[j].ANSWER_ID )
							{
								sOTHER_TEXT = rowQUESTION_RESULTS[j].OTHER_TEXT;
								sel.options.selectedIndex = sel.options.length - 1;
								break;
							}
						}
					}
				}
			}
			else if ( row.QUESTION_TYPE != 'Rating Scale' )
			{
				lab.className = 'SurveyAnswerChoice SurveyAnswerOther';
			}
			div.appendChild(lab);
			lab.innerHTML = Sql.ToString(row.OTHER_LABEL);
			
			if ( !Sql.ToBoolean(row.OTHER_AS_CHOICE) )
			{
				if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
				{
					for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
					{
						// 08/15/2013 Paul.  Answer ID will be null when only Other value is provided. 
						if ( sID == rowQUESTION_RESULTS[j].ANSWER_ID || rowQUESTION_RESULTS[j].ANSWER_ID == null )
						{
							sOTHER_TEXT = rowQUESTION_RESULTS[j].OTHER_TEXT;
							break;
						}
					}
				}
			}
			// 09/10/2018 Paul.  For rating scale and OTHER_ONE_PER_ROW, the column ID will be Other. 
			if ( row.QUESTION_TYPE == 'Rating Scale' && Sql.ToBoolean(row.OTHER_ONE_PER_ROW) )
			{
				if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
				{
					var sQUESTION_ID = row.ID.replace(/-/g, '_');
					for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
					{
						if ( sID == sQUESTION_ID + '_' + rowQUESTION_RESULTS[j].ANSWER_ID && rowQUESTION_RESULTS[j].COLUMN_ID == sOTHER_ID )
						{
							sOTHER_TEXT = rowQUESTION_RESULTS[j].ANSWER_TEXT;
							break;
						}
					}
				}
			}
			
			var txt = null;
			if ( Sql.ToInteger(row.OTHER_HEIGHT) > 1 )
			{
				txt = document.createElement('textarea');
				txt.id        = sID + '_OtherText';
				if ( row.QUESTION_TYPE != 'Rating Scale' )
					txt.className = 'SurveyAnswerChoice SurveyAnswerOther';
				txt.rows      = row.OTHER_HEIGHT;
				// 12/31/2015 Paul.  Ignore margins on mobile device as they make the layout terrible. 
				if ( isMobileDevice() )
					txt.style.width = '100%';
				else if ( Sql.ToInteger(row.OTHER_WIDTH) > 0 )
					txt.cols = row.OTHER_WIDTH;
				div.appendChild(txt);
				if ( !Sql.ToBoolean(row.OTHER_AS_CHOICE) )
				{
					lab.setAttribute('for', txt.id);
				}
			}
			else
			{
				txt = document.createElement('input');
				txt.id        = sID + '_OtherText';
				txt.type      = 'text';
				if ( row.QUESTION_TYPE != 'Rating Scale' )
					txt.className = 'SurveyAnswerChoice SurveyAnswerOther';
				// 12/31/2015 Paul.  Ignore margins on mobile device as they make the layout terrible. 
				if ( isMobileDevice() )
					txt.style.width = '100%';
				else if ( Sql.ToInteger(row.OTHER_WIDTH) > 0 )
					txt.size = row.OTHER_WIDTH;
				div.appendChild(txt);
				if ( !Sql.ToBoolean(row.OTHER_AS_CHOICE) )
				{
					lab.setAttribute('for', txt.id);
				}
			}
			txt.disabled = Sql.ToBoolean(bDisable);
			if ( sOTHER_TEXT != null )
				txt.value = sOTHER_TEXT;
			
			if ( !Sql.ToBoolean(bDisable) )
			{
				if ( row.QUESTION_TYPE == 'Radio' )
				{
					if ( Sql.ToBoolean(row.OTHER_AS_CHOICE) )
					{
						txt.onfocus = function()
						{
							rad.checked = true;
						};
					}
					else if ( arrANSWER_CHOICES !== undefined && arrANSWER_CHOICES != null )
					{
						txt.onfocus = function()
						{
							for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
							{
								var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
								var rad = document.getElementById(sID + '_' + sANSWER_ID);
								if ( rad != null && rad.checked )
									rad.checked = false;
							}
						};
					}
				}
				else if ( row.QUESTION_TYPE == 'Checkbox' )
				{
					if ( Sql.ToBoolean(row.OTHER_AS_CHOICE) )
					{
						txt.onfocus = function()
						{
							chk.checked = true;
						};
					}
					else if ( arrANSWER_CHOICES !== undefined && arrANSWER_CHOICES != null )
					{
						txt.onfocus = function()
						{
							for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
							{
								var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
								var chk = document.getElementById(sID + '_' + sANSWER_ID);
								if ( chk != null && chk.checked )
									chk.checked = false;
							}
						};
					}
				}
				else if ( row.QUESTION_TYPE == 'Dropdown' )
				{
					if ( Sql.ToBoolean(row.OTHER_AS_CHOICE) )
					{
						lab.style.display = 'none';
						txt.onfocus = function()
						{
							sel = document.getElementById(sID);
							sel.options.selectedIndex = sel.options.length - 1;
						};
					}
					else
					{
						txt.onfocus = function()
						{
							sel = document.getElementById(sID);
							sel.options.selectedIndex = 0;
						};
					}
				}
				else if ( row.QUESTION_TYPE == 'Rating Scale' )
				{
					if ( Sql.ToBoolean(row.OTHER_ONE_PER_ROW) )
					{
						if ( arrCOLUMN_CHOICES !== undefined && arrCOLUMN_CHOICES != null )
						{
							txt.onfocus = function()
							{
								for ( var j = 0; j < arrCOLUMN_CHOICES.length; j++ )
								{
									var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[j].Label);
									rad = document.getElementById(sID + '_' + sCOLUMN_ID);
									if ( rad != null && rad.checked )
										rad.checked = false;
								}
								var bNA_ENABLED  = Sql.ToBoolean(row.NA_ENABLED) && !Sql.IsEmptyString(row.NA_LABEL);
								if ( bNA_ENABLED )
								{
									var sCOLUMN_ID = md5('N/A');
									rad = document.getElementById(sID + '_' + sCOLUMN_ID);
									if ( rad != null )
										rad.checked = false;
								}
							};
						}
					}
				}
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Helper_RenderOther: ' + e.message);
	}
}

function SurveyQuestion_Helper_RenderHeader(divQuestionHeading, row)
{
	try
	{
		// 12/23/2015 Paul.  Use a table to make it easy to put export on the right. 
		var tblQuestionHeader = document.createElement('table');
		tblQuestionHeader.cellPadding = 0;
		tblQuestionHeader.cellSpacing = 0;
		tblQuestionHeader.border      = 0;
		tblQuestionHeader.width       = '100%';
		divQuestionHeading.appendChild(tblQuestionHeader);
		var tbodyQuestionHeader = document.createElement('tbody');
		tblQuestionHeader.appendChild(tbodyQuestionHeader);
		var trQuestionHeader = document.createElement('tr');
		tbodyQuestionHeader.appendChild(trQuestionHeader);
		var tdQuestionHeaderText = document.createElement('td');
		trQuestionHeader.appendChild(tdQuestionHeaderText);
		tdQuestionHeaderText.className = 'SurveyQuestionHeading';
		tdQuestionHeaderText.width     = '90%';
		var tdQuestionHeaderExport = document.createElement('td');
		trQuestionHeader.appendChild(tdQuestionHeaderExport);
		tdQuestionHeaderExport.vAlign  = 'top';
		tdQuestionHeaderExport.align   = 'right';
		tdQuestionHeaderExport.width   = '10%';
		
		if ( Sql.ToBoolean(row.REQUIRED) )
		{
			var spnREQUIRED_ASTERISK = document.createElement('span');
			spnREQUIRED_ASTERISK.className = 'SurveyQuestionRequiredAsterisk';
			tdQuestionHeaderText.appendChild(spnREQUIRED_ASTERISK);
			var txtREQUIRED_ASTERISK = document.createTextNode('*');
			spnREQUIRED_ASTERISK.appendChild(txtREQUIRED_ASTERISK);
		}
		if ( row.QUESTION_NUMBER > 0 )
		{
			var spnQUESTION_NUMBER = document.createElement('span');
			// 11/12/2018 Paul.  Add a style so that the number can be hidden or altered. 
			spnQUESTION_NUMBER.className = 'SurveyQuestionNumber';
			tdQuestionHeaderText.appendChild(spnQUESTION_NUMBER);
			var txtQUESTION_NUMBER = document.createTextNode(row.QUESTION_NUMBER.toString() + '. ');
			spnQUESTION_NUMBER.appendChild(txtQUESTION_NUMBER);
		}
		// 11/11/2018 Paul.  Description might be null. 
		if ( !Sql.IsEmptyString(row.DESCRIPTION) )
		{
			var spnQuestionText = document.createElement('span');
			tdQuestionHeaderText.appendChild(spnQuestionText);
			spnQuestionText.innerHTML = row.DESCRIPTION;
		}

		try
		{
			// 12/24/2015 Paul.  L10n is only available in SummaryView.ascx. This is fine because we do not want to display in non-summary mode. 
			var lnkQuestionExport = document.createElement('a');
			tdQuestionHeaderExport.appendChild(lnkQuestionExport);
			lnkQuestionExport.className = 'listViewTdLinkS1';
			lnkQuestionExport.innerHTML = L10n.Term("SurveyResults.LBL_EXPORT");
			lnkQuestionExport.href      = 'exportSummary.aspx?SURVEY_ID=' + row.SURVEY_ID + '&SURVEY_PAGE_ID=' + row.SURVEY_PAGE_ID + '&SURVEY_QUESTION_ID=' + row.ID;
			lnkQuestionExport.target    = 'SurveyResults_' + row.ID;
		}
		catch(e)
		{
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Helper_RenderHeader: ' + e.message);
	}
}

function SurveyQuestion_Helper_RenderAnswered(divQuestionHeading, nANSWERED, nSKIPPED)
{
	var divAnswered = document.createElement('div');
	divQuestionHeading.appendChild(divAnswered);
	var spnAnswered = document.createElement('span');
	spnAnswered.className = 'SurveyResultsSubHeader';
	spnAnswered.innerHTML = L10n.Term("SurveyResults.LBL_ANSWERED").replace('{0}', nANSWERED.toString());
	divAnswered.appendChild(spnAnswered);
	var spnSkipped = document.createElement('span');
	spnSkipped.className = 'SurveyResultsSubHeader';
	spnSkipped.innerHTML = L10n.Term("SurveyResults.LBL_SKIPPED").replace('{0}', nSKIPPED.toString());
	divAnswered.appendChild(spnSkipped);
}

function SurveyQuestion_Helper_OtherValidation(row, sValue)
{
	var bValid = false;
	try
	{
		switch ( row.OTHER_VALIDATION_TYPE )
		{
			case 'Date'           :
				bValid = Sql.IsDate(sValue);
				if ( bValid )
				{
					var dtMIN   = Sql.ToDateTime(row.OTHER_VALIDATION_MIN);
					var dtMAX   = Sql.ToDateTime(row.OTHER_VALIDATION_MAX);
					var dtVALUE = Sql.ToDateTime(sValue);
					bValid      = (dtVALUE >= dtMIN && dtVALUE <= dtMAX);
				}
				break;
			case 'Specific Length':
				bValid = (sValue.length         >= Sql.ToInteger(row.OTHER_VALIDATION_MIN) && sValue.length         <= Sql.ToInteger(row.OTHER_VALIDATION_MAX));
				break;
			case 'Integer'        :
				bValid = Sql.IsInteger(sValue);
				if ( bValid )
				{
					bValid = (Sql.ToInteger(sValue) >= Sql.ToInteger(row.OTHER_VALIDATION_MIN) && Sql.ToInteger(sValue) <= Sql.ToInteger(row.OTHER_VALIDATION_MAX));
				}
				break;
			case 'Decimal'        :
				bValid = Sql.IsFloat(sValue);
				if ( bValid )
				{
					bValid = (Sql.ToFloat  (sValue) >= Sql.ToFloat  (row.OTHER_VALIDATION_MIN) && Sql.ToFloat  (sValue) <= Sql.ToFloat  (row.OTHER_VALIDATION_MAX));
				}
				break;
			case 'Email'          :
				bValid = Sql.IsEmail(sValue);
				break;
			default               :
				bValid = true;
				break;
		}
	}
	catch(e)
	{
	}
	return bValid;
}

function SurveyQuestion_Helper_OtherValidationMessage(row)
{
	var sError = Sql.ToString(row.OTHER_VALIDATION_MESSAGE);
	switch ( row.OTHER_VALIDATION_TYPE )
	{
		case 'Date'           :
		case 'Specific Length':
		case 'Integer'        :
		case 'Decimal'        :
			sError = sError.replace('{0}', row.OTHER_VALIDATION_MIN).replace('{1}', row.OTHER_VALIDATION_MAX);
			break;
	}
	return sError;
}

function SurveyQuestion_Helper_Validation(row, sValue)
{
	var bValid = false;
	try
	{
		switch ( row.VALIDATION_TYPE )
		{
			case 'Date'           :
			{
				var dtMIN   = Sql.ToDateTime(row.VALIDATION_MIN);
				var dtMAX   = Sql.ToDateTime(row.VALIDATION_MAX);
				var dtVALUE = Sql.ToDateTime(sValue);
				bValid      = (dtVALUE >= dtMIN && dtVALUE <= dtMAX);
				break;
			}
			case 'Specific Length':  bValid = (sValue.length         >= Sql.ToInteger(row.VALIDATION_MIN) && sValue.length         <= Sql.ToInteger(row.VALIDATION_MAX));  break;
			case 'Integer'        :  bValid = (Sql.ToInteger(sValue) >= Sql.ToInteger(row.VALIDATION_MIN) && Sql.ToInteger(sValue) <= Sql.ToInteger(row.VALIDATION_MAX));  break;
			case 'Decimal'        :  bValid = (Sql.ToFloat  (sValue) >= Sql.ToFloat  (row.VALIDATION_MIN) && Sql.ToFloat  (sValue) <= Sql.ToFloat  (row.VALIDATION_MAX));  break;
			case 'Email'          :  bValid = Sql.IsEmail(sValue);  break;
			default               :  bValid = true;  break;
		}
	}
	catch(e)
	{
	}
	return bValid;
}

function SurveyQuestion_Helper_ValidationMessage(row)
{
	var sError = Sql.ToString(row.VALIDATION_MESSAGE);
	switch ( row.VALIDATION_TYPE )
	{
		case 'Date'           :
		case 'Specific Length':
		case 'Integer'        :
		case 'Decimal'        :
			sError = sError.replace('{0}', row.VALIDATION_MIN).replace('{1}', row.VALIDATION_MAX);
			break;
	}
	return sError;
}

function SurveyQuestion_Helper_RequiredTypeValidation(row, nSelected, nTotal)
{
	var bValid = false;
	try
	{
		switch ( row.REQUIRED_TYPE )
		{
			case 'All'     :  bValid = (nSelected == nTotal);  break;
			case 'At Least':  bValid = (nSelected >= Sql.ToInteger(row.REQUIRED_RESPONSES_MIN));  break;
			case 'At Most' :  bValid = (nSelected <= Sql.ToInteger(row.REQUIRED_RESPONSES_MAX));  break;
			case 'Exactly' :  bValid = (nSelected == Sql.ToInteger(row.REQUIRED_RESPONSES_MIN));  break;
			case 'Range'   :  bValid = (nSelected >= Sql.ToInteger(row.REQUIRED_RESPONSES_MIN) && nSelected <= Sql.ToInteger(row.REQUIRED_RESPONSES_MAX));  break;
			default        :  break;
		}
	}
	catch(e)
	{
	}
	return bValid;
}

function SurveyQuestion_Helper_RequiredTypeMessage(row, nTotal)
{
	var sError = Sql.ToString(row.REQUIRED_MESSAGE);
	sError = sError.replace('{REQUIRED_TYPE}', Sql.ToString(row.REQUIRED_TYPE));
	switch ( row.REQUIRED_TYPE )
	{
		case 'All'     :  sError = sError.replace('{0}', nTotal.toString());  break;
		case 'At Least':  sError = sError.replace('{0}', row.REQUIRED_RESPONSES_MIN);  break;
		case 'At Most' :  sError = sError.replace('{0}', row.REQUIRED_RESPONSES_MAX);  break;
		case 'Exactly' :  sError = sError.replace('{0}', row.REQUIRED_RESPONSES_MIN);  break;
		case 'Range'   :  sError = sError.replace('{0}', row.REQUIRED_RESPONSES_MIN).replace('{1}', row.REQUIRED_RESPONSES_MAX);  break;
	}
	return sError;
}

function SurveyQuestion_ConvertFromEpocDate(nSeconds)
{
	// 08/21/2018 Paul.  JavaScript counts months from 0 to 11. 
	// https://www.w3schools.com/js/js_dates.asp
	var dtUnixEpoc = new Date(1970, 0, 1);
	dtUnixEpoc.setSeconds(dtUnixEpoc.getSeconds() + nSeconds)
	return dtUnixEpoc;
}

// 08/17/2018 Paul.  For date validation, we need to store time in seconds as the database field is an integer.  Convert to seconds since 1970. 
function SurveyQuestion_Helper_RequiredDateValidation(row, dtSelected)
{
	var bValid = false;
	try
	{
		switch ( row.REQUIRED_TYPE )
		{
			case 'All'     :  bValid = true;  break;
			case 'At Least':  bValid = (dtSelected >= SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MIN)));  break;
			case 'At Most' :  bValid = (dtSelected <= SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MAX)));  break;
			case 'Exactly' :  bValid = (dtSelected == SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MIN)));  break;
			case 'Range'   :  bValid = (dtSelected >= SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MIN)) && dtSelected <= SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MAX)));  break;
			default        :  bValid = Sql.IsDate(dtSelected);  break;
		}
	}
	catch(e)
	{
	}
	return bValid;
}

// 08/17/2018 Paul.  For date validation, we need to store time in seconds as the database field is an integer.  Convert to seconds since 1970. 
function SurveyQuestion_Helper_RequiredDateMessage(row, dtValue)
{
	try
	{
		var sDATE_FORMAT = sUSER_DATE_FORMAT;
		if ( sDATE_FORMAT === undefined )
			sDATE_FORMAT = 'mm/dd/yy';
		// 08/17/2018 Paul.  Convert Windows format to datepicker format. 
		sDATE_FORMAT = sDATE_FORMAT.replace('yyyy', 'yy');
		sDATE_FORMAT = sDATE_FORMAT.replace('MM'  , 'mm');
		
		var sError = Sql.ToString(row.REQUIRED_MESSAGE);
		sError = sError.replace('{REQUIRED_TYPE}', Sql.ToString(row.REQUIRED_TYPE));
		switch ( row.REQUIRED_TYPE )
		{
			case 'All'     :  sError = sError.replace('{0}', $.datepicker.formatDate(sDATE_FORMAT, dtValue));  break;
			case 'At Least':  sError = sError.replace('{0}', $.datepicker.formatDate(sDATE_FORMAT, SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MIN))));  break;
			case 'At Most' :  sError = sError.replace('{0}', $.datepicker.formatDate(sDATE_FORMAT, SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MAX))));  break;
			case 'Exactly' :  sError = sError.replace('{0}', $.datepicker.formatDate(sDATE_FORMAT, SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MIN))));  break;
			case 'Range'   :  sError = sError.replace('{0}', $.datepicker.formatDate(sDATE_FORMAT, SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MIN)))).replace('{1}', $.datepicker.formatDate(sDATE_FORMAT, SurveyQuestion_ConvertFromEpocDate(Sql.ToInteger(row.REQUIRED_RESPONSES_MAX))));  break;
		}
	}
	catch(e)
	{
		sError = e.message;
	}
	return sError;
}

function SurveyQuestion_Helper_ForcedRanking(sID, arrANSWER_CHOICES, sCURRENT_ANSWER_ID, sCURRENT_COLUMN_ID)
{
	for ( var i = 0; i < arrANSWER_CHOICES.length; i++ )
	{
		var sANSWER_ID = md5(arrANSWER_CHOICES[i]);
		if ( sANSWER_ID != sCURRENT_ANSWER_ID )
		{
			var rad = document.getElementById(sID + '_' + sANSWER_ID + '_' + sCURRENT_COLUMN_ID);
			if ( rad != null && rad.checked )
			{
				rad.checked = false;
			}
		}
	}
}

function SurveyQuestion_Helper_RandomizeAnswers(row)
{
	try
	{
		if ( row.RANDOMIZE_APPLIED === undefined )
			row.RANDOMIZE_APPLIED = false;
		if ( row.RANDOMIZE_COUNT === undefined )
			row.RANDOMIZE_COUNT = 0;
		if ( !row.RANDOMIZE_APPLIED && !Sql.IsEmptyString(row.RANDOMIZE_TYPE) && !Sql.IsEmptyString(row.ANSWER_CHOICES) && row.QUESTION_TYPE != 'Demographic' )
		{
			// http://www.w3schools.com/jsref/jsref_obj_array.asp
			var arrANSWER_CHOICES = row.ANSWER_CHOICES.split('\r\n');
			if ( arrANSWER_CHOICES.length > 1 )
			{
				var sLastItem = null;
				if ( Sql.ToBoolean(row.RANDOMIZE_NOT_LAST) )
				{
					sLastItem = arrANSWER_CHOICES.pop();
				}
				if ( row.RANDOMIZE_TYPE == 'Randomize' )
				{
					// http://stackoverflow.com/questions/2450954/how-to-randomize-a-javascript-array
					for ( var i = arrANSWER_CHOICES.length - 1; i > 0; i-- )
					{
						var j = Math.floor(Math.random() * (i + 1));
						var temp = arrANSWER_CHOICES[i];
						arrANSWER_CHOICES[i] = arrANSWER_CHOICES[j];
						arrANSWER_CHOICES[j] = temp;
					}
				}
				else if ( row.RANDOMIZE_TYPE == 'Flip' )
				{
					if ( Sql.ToInteger(row.RANDOMIZE_COUNT) % 2 == 0 )
					{
						arrANSWER_CHOICES.reverse();
					}
				}
				else if ( row.RANDOMIZE_TYPE == 'Sort' )
				{
					arrANSWER_CHOICES.sort(function(a, b)
					{
						var al = a.toLowerCase();
						var bl = b.toLowerCase();
						return al == bl ? (a == b ? 0 : (a < b ? -1 : 1)) : (al < bl ? -1 : 1);
					});
				}
				if ( sLastItem != null )
					arrANSWER_CHOICES.push(sLastItem);
				row.ANSWER_CHOICES = arrANSWER_CHOICES.join('\r\n');
			}
		}
		row.RANDOMIZE_APPLIED = true;
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Helper_RandomizeAnswers: ' + e.message);
	}
}

function SurveyQuestion_Render(row, divQuestionFrame, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		// 06/13/2013 Paul.  We need to clear the Rendering text. 
		SurveyQuestion_Helper_Clear(divQuestionFrame);

		SurveyQuestion_Helper_RandomizeAnswers(row);
		var question = SurveyQuestion_Factory(row);
		if ( question != null )
		{
			var divQuestionContent = document.createElement('div');
			divQuestionContent.className = 'SurveyQuestionContent';
			divQuestionFrame.appendChild(divQuestionContent);

			var divQuestionError = document.createElement('div');
			divQuestionError.id            = question.ID + '_Error';
			divQuestionError.className     = 'SurveyQuestionError';
			divQuestionError.style.display = 'none';
			divQuestionContent.appendChild(divQuestionError);

			var divQuestionHeading = document.createElement('div');
			divQuestionHeading.id        = question.ID + '_Heading';
			divQuestionHeading.className = 'SurveyQuestionHeading';
			divQuestionContent.appendChild(divQuestionHeading);

			var divQuestionBody = document.createElement('div');
			divQuestionBody.id            = question.ID + '_Body';
			divQuestionBody.className = 'SurveyQuestionBody';
			divQuestionContent.appendChild(divQuestionBody);

			// 12/31/2015 Paul.  Ignore margins on mobile device as they make the layout terrible. 
			if ( !isMobileDevice() )
			{
				if ( Sql.ToInteger(row.SPACING_LEFT  ) > 0 ) divQuestionFrame.style.marginLeft   = Sql.ToInteger(row.SPACING_LEFT  )+ 'px';
				if ( Sql.ToInteger(row.SPACING_TOP   ) > 0 ) divQuestionFrame.style.marginTop    = Sql.ToInteger(row.SPACING_TOP   )+ 'px';
				if ( Sql.ToInteger(row.SPACING_RIGHT ) > 0 ) divQuestionFrame.style.marginRight  = Sql.ToInteger(row.SPACING_RIGHT )+ 'px';
				if ( Sql.ToInteger(row.SPACING_BOTTOM) > 0 ) divQuestionFrame.style.marginBottom = Sql.ToInteger(row.SPACING_BOTTOM)+ 'px';
			}

			question.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable);
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Render: ' + e.message);
	}
}

// 10/08/2018 Paul.  Provide sample for question editor. 
function SurveyQuestion_RenderSample(row, divQuestionFrame)
{
	try
	{
		// 06/13/2013 Paul.  We need to clear the Rendering text. 
		SurveyQuestion_Helper_Clear(divQuestionFrame);

		SurveyQuestion_Helper_RandomizeAnswers(row);
		var question = SurveyQuestion_Factory(row);
		if ( question != null )
		{
			var divQuestionContent = document.createElement('div');
			divQuestionContent.className = 'SurveyQuestionContent';
			divQuestionFrame.appendChild(divQuestionContent);

			var divQuestionError = document.createElement('div');
			divQuestionError.id            = question.ID + '_Error';
			divQuestionError.className     = 'SurveyQuestionError';
			divQuestionError.style.display = 'none';
			divQuestionContent.appendChild(divQuestionError);

			var divQuestionHeading = document.createElement('div');
			divQuestionHeading.id        = question.ID + '_Heading';
			divQuestionHeading.className = 'SurveyQuestionHeading';
			divQuestionContent.appendChild(divQuestionHeading);

			var divQuestionBody = document.createElement('div');
			divQuestionBody.id            = question.ID + '_Body';
			divQuestionBody.className = 'SurveyQuestionBody';
			divQuestionContent.appendChild(divQuestionBody);

			// 12/31/2015 Paul.  Ignore margins on mobile device as they make the layout terrible. 
			if ( !isMobileDevice() )
			{
				if ( Sql.ToInteger(row.SPACING_LEFT  ) > 0 ) divQuestionFrame.style.marginLeft   = Sql.ToInteger(row.SPACING_LEFT  )+ 'px';
				if ( Sql.ToInteger(row.SPACING_TOP   ) > 0 ) divQuestionFrame.style.marginTop    = Sql.ToInteger(row.SPACING_TOP   )+ 'px';
				if ( Sql.ToInteger(row.SPACING_RIGHT ) > 0 ) divQuestionFrame.style.marginRight  = Sql.ToInteger(row.SPACING_RIGHT )+ 'px';
				if ( Sql.ToInteger(row.SPACING_BOTTOM) > 0 ) divQuestionFrame.style.marginBottom = Sql.ToInteger(row.SPACING_BOTTOM)+ 'px';
			}
			if (question.InitSample !== undefined )
				question.InitSample();
			question.Render(divQuestionHeading, divQuestionBody, null, true);
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_RenderSample: ' + e.message);
	}
}

function SurveyQuestion_Report(row, divQuestionFrame, rowPAGE_RESULTS)
{
	try
	{
		// 06/13/2013 Paul.  We need to clear the Rendering text. 
		SurveyQuestion_Helper_Clear(divQuestionFrame);

		var question = SurveyQuestion_Factory(row);
		if ( question != null )
		{
			var divQuestionContent = document.createElement('div');
			divQuestionContent.className = 'SurveyQuestionContent';
			divQuestionFrame.appendChild(divQuestionContent);

			var divQuestionError = document.createElement('div');
			divQuestionError.id            = question.ID + '_Error';
			divQuestionError.className     = 'SurveyQuestionError';
			divQuestionError.style.display = 'none';
			divQuestionContent.appendChild(divQuestionError);

			var divQuestionHeading = document.createElement('div');
			divQuestionHeading.id        = question.ID + '_Heading';
			divQuestionHeading.className = 'SurveyQuestionHeading';
			divQuestionContent.appendChild(divQuestionHeading);

			var divQuestionBody = document.createElement('div');
			divQuestionBody.id            = question.ID + '_Body';
			divQuestionBody.className = 'SurveyQuestionBody';
			divQuestionContent.appendChild(divQuestionBody);

			// 12/31/2015 Paul.  Ignore margins on mobile device as they make the layout terrible. 
			if ( !isMobileDevice() )
			{
				if ( Sql.ToInteger(row.SPACING_LEFT  ) > 0 ) divQuestionFrame.style.marginLeft   = Sql.ToInteger(row.SPACING_LEFT  )+ 'px';
				if ( Sql.ToInteger(row.SPACING_TOP   ) > 0 ) divQuestionFrame.style.marginTop    = Sql.ToInteger(row.SPACING_TOP   )+ 'px';
				if ( Sql.ToInteger(row.SPACING_RIGHT ) > 0 ) divQuestionFrame.style.marginRight  = Sql.ToInteger(row.SPACING_RIGHT )+ 'px';
				if ( Sql.ToInteger(row.SPACING_BOTTOM) > 0 ) divQuestionFrame.style.marginBottom = Sql.ToInteger(row.SPACING_BOTTOM)+ 'px';
			}

			var rowQUESTION_RESULTS = new Array();
			for ( var j = 0; j < rowPAGE_RESULTS.length; j++ )
			{
				if ( question.row.ID == rowPAGE_RESULTS[j].SURVEY_QUESTION_ID )
				{
					var rowRESULTS = rowPAGE_RESULTS[j];
					if ( rowRESULTS.ANSWER_ID != null ) rowRESULTS.ANSWER_ID = rowRESULTS.ANSWER_ID.replace(/-/g, '');
					if ( rowRESULTS.COLUMN_ID != null ) rowRESULTS.COLUMN_ID = rowRESULTS.COLUMN_ID.replace(/-/g, '');
					if ( rowRESULTS.MENU_ID   != null ) rowRESULTS.MENU_ID   = rowRESULTS.MENU_ID.replace(/-/g, '');
					rowQUESTION_RESULTS.push(rowRESULTS);
				}
			}
			question.Report(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS);
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Render: ' + e.message);
	}
}

function SurveyQuestion_Summary(row, divQuestionFrame, callback, context)
{
	try
	{
		// 06/13/2013 Paul.  We need to clear the Rendering text. 
		SurveyQuestion_Helper_Clear(divQuestionFrame);

		var question = SurveyQuestion_Factory(row);
		if ( question != null )
		{
			var divQuestionContent = document.createElement('div');
			divQuestionContent.className = 'SurveyQuestionContent';
			divQuestionFrame.appendChild(divQuestionContent);
			
			var divQuestionError = document.createElement('div');
			divQuestionError.id            = question.ID + '_Error';
			divQuestionError.className     = 'SurveyQuestionError';
			divQuestionError.style.display = 'none';
			divQuestionContent.appendChild(divQuestionError);
			
			var divQuestionHeading = document.createElement('div');
			divQuestionHeading.id        = question.ID + '_Heading';
			divQuestionHeading.className = 'SurveyQuestionHeading';
			divQuestionContent.appendChild(divQuestionHeading);
			
			var divQuestionBody = document.createElement('div');
			divQuestionBody.id            = question.ID + '_Body';
			divQuestionBody.className = 'SurveyQuestionBody';
			divQuestionContent.appendChild(divQuestionBody);
			
			SurveyQuestion_Helper_RenderHeader(divQuestionHeading, row);
			
			if ( $(divQuestionHeading).is(':appeared') )
			{
				question.Summary(divQuestionHeading, divQuestionBody, callback, context);
			}
			else
			{
				$(divQuestionHeading).appear();
				// 06/20/2013 Paul.  Use one() so that it is only rendered once. 
				$(document.body).one('appear', divQuestionBody, function(e, $affected)
				{
					question.Summary(divQuestionHeading, divQuestionBody, callback, context);
				});
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Summary: ' + e.message);
	}
}

function SurveyQuestion_ResultsPaginationFormat(type)
{
	switch ( type )
	{
		case 'block':  // n and c
			if ( this.value != this.page )
				return '<a href="#">' + this.value + '</a>';
			else
				return this.value;
		case 'first':  // [
			if ( this.page > 1 )
				return '<a href="#">' + L10n.Term('.LNK_LIST_FIRST') + '</a>';
			else
				return  '' + L10n.Term('.LNK_LIST_FIRST') + '';
		case 'prev' :  // <
			if ( this.page > 1 )
				return '<a href="#">&lt; ' + L10n.Term('.LNK_LIST_PREVIOUS') + '</a>';
			else
				return '&lt; ' + L10n.Term('.LNK_LIST_PREVIOUS') + '';
		case 'next' :  // >
			if ( this.page < this.pages )
				return '<a href="#">' + L10n.Term('.LNK_LIST_NEXT') + ' &gt;</a>';
			else
				return '' + L10n.Term('.LNK_LIST_NEXT') + ' &gt;';
		case 'last' :  // ]
			if ( this.page < this.pages )
				return '<a href="#">' + L10n.Term('.LNK_LIST_LAST') + '</a>';
			else
				return '' + L10n.Term('.LNK_LIST_LAST') + '';
		case 'leap' :
			//litPageRange.Text = String.Format("&nbsp; <span class=\"pageNumbers\">({0} - {1} {2} {3})</span> ", nPageStart, nPageEnd, sOf, vw.Count);
			return ' ( ' + (this.slice[0] + 1) + ' - ' + this.slice[1] + ' ' + L10n.Term('.LBL_LIST_OF') + ' ' + this.number + ' ) ';
		case 'fill' :
			return ' ';
	}
	return '';
}

function SurveyQuestion_ResultsPaginateResponses(divResponses, arrANSWERED, sDATE_ENTERED_NAME, sANSWER_TEXT_NAME)
{
	var tbl = document.createElement('table');
	tbl.id          = divResponses.id + '_AllResponses';
	tbl.className   = 'SurveyResultsAllResponses';
	tbl.cellPadding = 2;
	tbl.cellSpacing = 0;
	tbl.border      = 0;
	divResponses.appendChild(tbl);
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
	spnPagination.id = divResponses.id + '_pagination';
	
	// http://www.xarg.org/2011/09/jquery-pagination-revised/
	$('#' + spnPagination.id).paging(arrANSWERED.length, 
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
				var row = arrANSWERED[i];
				var tdDate = document.createElement('td');
				tdDate.className = 'SurveyResultsTextResponses SurveyResultsTextResponsesDate';
				tr.appendChild(tdDate);
				tdDate.innerHTML = FromJsonDate(row[sDATE_ENTERED_NAME], Security.USER_DATE_FORMAT() + ' ' + Security.USER_TIME_FORMAT());
				var tdText = document.createElement('td');
				tdText.className = 'SurveyResultsTextResponses SurveyResultsTextResponsesText';
				tr.appendChild(tdText);
				// 06/19/2013 Paul.  Use createTextNode to prevent user data hacks. 
				if ( row[sANSWER_TEXT_NAME] != null )
				{
					tdText.appendChild(document.createTextNode(row[sANSWER_TEXT_NAME]));
				}
				var tdView = document.createElement('td');
				tdView.className = 'SurveyResultsTextResponses SurveyResultsTextResponsesView';
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

