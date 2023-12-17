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

function SurveyQuestion_Demographic(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
}

// 10/08/2018 Paul.  Provide sample for question editor. 
SurveyQuestion_Demographic.prototype.InitSample = function()
{
	this.row.COLUMN_CHOICES = '<?xml version="1.0" encoding="UTF-8"?><Demographic>';
	this.row.COLUMN_CHOICES += '<Field Name="NAME" Visible="True" Required="False">Name:</Field>';
	this.row.COLUMN_CHOICES += '<Field Name="COMPANY" Visible="True" Required="False">Company:</Field>';
	//this.row.COLUMN_CHOICES += '<Field Name="ADDRESS1" Visible="True" Required="False">Address 1:</Field>';
	//this.row.COLUMN_CHOICES += '<Field Name="ADDRESS2" Visible="True" Required="False">Address 2:</Field>';
	//this.row.COLUMN_CHOICES += '<Field Name="CITY" Visible="True" Required="False">City:</Field>';
	//this.row.COLUMN_CHOICES += '<Field Name="STATE" Visible="True" Required="False">State/Province:</Field>';
	//this.row.COLUMN_CHOICES += '<Field Name="POSTAL_CODE" Visible="True" Required="False">Postal Code:</Field>';
	//this.row.COLUMN_CHOICES += '<Field Name="COUNTRY" Visible="True" Required="False">Country:</Field>';
	this.row.COLUMN_CHOICES += '<Field Name="EMAIL_ADDRESS" Visible="True" Required="False">Email Address:</Field>';
	this.row.COLUMN_CHOICES += '<Field Name="PHONE_NUMBER" Visible="True" Required="False">Phone Number:</Field>';
	this.row.COLUMN_CHOICES += '</Demographic>';
}

SurveyQuestion_Demographic.prototype.Value = function()
{
	var bValid = false;
	var arrValue = new Array();
	try
	{
		if ( !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			// <Demographic><Field Name="NAME" Visible="" Required="">Name:</Field></Demographic>
			var arrCOLUMN_CHOICES = new Array();
			var xmlCOLUMN_CHOICES = $.parseXML(this.row.COLUMN_CHOICES);
			$(xmlCOLUMN_CHOICES).find('Field').each(function()
			{
				var oColumnChoice = new Object();
				oColumnChoice.Name     = $(this).attr('Name'    );
				oColumnChoice.Visible  = Sql.ToBoolean($(this).attr('Visible' ));
				oColumnChoice.Required = Sql.ToBoolean($(this).attr('Required'));
				oColumnChoice.Label    = $(this).text();
				arrCOLUMN_CHOICES.push(oColumnChoice);
			});
			if ( arrCOLUMN_CHOICES.length > 0 )
			{
				bValid = true;
				for ( var i = 0; i < arrCOLUMN_CHOICES.length; i++ )
				{
					if ( arrCOLUMN_CHOICES[i].Visible )
					{
						var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[i].Name);
						var txt = document.getElementById(this.ID + '_' + sCOLUMN_ID);
						if ( txt != null )
						{
							var sTxtValue = Trim(txt.value);
							// 06/19/2013 Paul.  Even if no values, log that the user saw the question. 
							//if ( sTxtValue.length > 0 )
								arrValue.push(sCOLUMN_ID + ',' + sTxtValue);
						}
					}
				}
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Demographic.Value: ' + e.message);
	}
	return arrValue;
}

SurveyQuestion_Demographic.prototype.Validate = function(divQuestionError)
{
	var bValid = false;
	try
	{
		if ( !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			// <Demographic><Field Name="NAME" Visible="" Required="">Name:</Field></Demographic>
			var arrCOLUMN_CHOICES = new Array();
			var xmlCOLUMN_CHOICES = $.parseXML(this.row.COLUMN_CHOICES);
			$(xmlCOLUMN_CHOICES).find('Field').each(function()
			{
				var oColumnChoice = new Object();
				oColumnChoice.Name     = $(this).attr('Name'    );
				oColumnChoice.Visible  = Sql.ToBoolean($(this).attr('Visible' ));
				oColumnChoice.Required = Sql.ToBoolean($(this).attr('Required'));
				oColumnChoice.Label    = $(this).text();
				arrCOLUMN_CHOICES.push(oColumnChoice);
			});
			if ( arrCOLUMN_CHOICES.length > 0 )
			{
				bValid = true;
				for ( var i = 0; i < arrCOLUMN_CHOICES.length; i++ )
				{
					if ( arrCOLUMN_CHOICES[i].Visible && arrCOLUMN_CHOICES[i].Required )
					{
						var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[i].Name);
						var txt = document.getElementById(this.ID + '_' + sCOLUMN_ID);
						if ( txt != null )
						{
							var sTxtValue = Trim(txt.value);
							var spnRequiredMessage = document.getElementById(this.ID + '_' + sCOLUMN_ID + '_Error');
							if ( spnRequiredMessage != null )
							{
								var bTxtValid = (sTxtValue.length > 0);
								if ( bTxtValid && arrCOLUMN_CHOICES[i].Name == 'EMAIL_ADDRESS' )
									bTxtValid = Sql.IsEmail(sTxtValue);
								spnRequiredMessage.style.display = (!bTxtValid ? 'inline' : 'none');
								if ( !bTxtValid )
									bValid = false;
							}
						}
					}
				}
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
		throw new Error('SurveyQuestion_Demographic.Validate: ' + e.message);
		bValid = false;
	}
	return bValid;
}

SurveyQuestion_Demographic.prototype.Render = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, bDisable)
{
	try
	{
		SurveyQuestion_Helper_RenderHeader(divQuestionHeading, this.row);
		if ( !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			// <Demographic><Field Name="NAME" Visible="" Required="">Name:</Field></Demographic>
			var arrCOLUMN_CHOICES = new Array();
			var xmlCOLUMN_CHOICES = $.parseXML(this.row.COLUMN_CHOICES);
			$(xmlCOLUMN_CHOICES).find('Field').each(function()
			{
				var oColumnChoice = new Object();
				oColumnChoice.Name     = $(this).attr('Name'    );
				oColumnChoice.Visible  = Sql.ToBoolean($(this).attr('Visible' ));
				oColumnChoice.Required = Sql.ToBoolean($(this).attr('Required'));
				oColumnChoice.Label    = $(this).text();
				arrCOLUMN_CHOICES.push(oColumnChoice);
			});
			//alert(dumpObj(arrCOLUMN_CHOICES, 'arrCOLUMN_CHOICES'));
			if ( arrCOLUMN_CHOICES.length > 0 )
			{
				var tbl = document.createElement('table');
				tbl.cellSpacing = 2;
				tbl.cellPadding = 2;
				tbl.border      = 0;
				tbl.style.width = '100%';
				divQuestionBody.appendChild(tbl);
				var tbody = document.createElement('tbody');
				tbl.appendChild(tbody);

				var nLABEL_WIDTH = Sql.ToInteger(this.row.COLUMN_WIDTH);
				var nFIELD_WIDTH = 100 - nLABEL_WIDTH;
				for ( var i = 0; i < arrCOLUMN_CHOICES.length; i++ )
				{
					if ( arrCOLUMN_CHOICES[i].Visible )
					{
						var sCOLUMN_ID = md5(arrCOLUMN_CHOICES[i].Name);
						var tr = document.createElement('tr');
						tbody.appendChild(tr);
						var tdLabel = document.createElement('td');
						tdLabel.style.width = nLABEL_WIDTH.toString() + '%';
						tr.appendChild(tdLabel);
						var tdField = document.createElement('td');
						tdField.style.width = nFIELD_WIDTH.toString() + '%';
						tr.appendChild(tdField);
					
						var div = document.createElement('div');
						div.className = 'SurveyAnswerChoice';
						tdLabel.appendChild(div);
						var lab = document.createElement('label');
						div.appendChild(lab);
						lab.innerHTML = arrCOLUMN_CHOICES[i].Label;
						
						div = document.createElement('div');
						div.className = 'SurveyAnswerChoice';
						tdField.appendChild(div);
						var txt = document.createElement('input');
						txt.id        = this.ID + '_' + sCOLUMN_ID;
						txt.type      = 'text';
						txt.className = 'SurveyAnswerChoiceTextbox';
						// 12/31/2015 Paul.  Ignore margins on mobile device as they make the layout terrible. 
						if ( isMobileDevice() )
							txt.style.width = '100%';
						else if ( Sql.ToInteger(this.row.BOX_WIDTH ) > 0 )
							txt.size = this.row.BOX_WIDTH;
						div.appendChild(txt);
						lab.setAttribute('for', txt.id);
						
						if ( arrCOLUMN_CHOICES[i].Required )
						{
							var txtREQUIRED_ASTERISK = document.createTextNode('*');
							lab.appendChild(txtREQUIRED_ASTERISK);
							var spnRequiredMessage = document.createElement('span');
							spnRequiredMessage.id                    = this.ID + '_' + sCOLUMN_ID + '_Error';
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
						
						txt.disabled = Sql.ToBoolean(bDisable);
						if ( rowQUESTION_RESULTS !== undefined && rowQUESTION_RESULTS != null )
						{
							for ( var j = 0; j < rowQUESTION_RESULTS.length; j++ )
							{
								if ( sCOLUMN_ID == rowQUESTION_RESULTS[j].ANSWER_ID )
								{
									// 09/18/2016 Paul.  Answer may be null. 
									if ( rowQUESTION_RESULTS[j].ANSWER_TEXT != null )
										txt.value = rowQUESTION_RESULTS[j].ANSWER_TEXT;
									break;
								}
							}
						}
					}
				}
			}
		}
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Demographic.Render: ' + e.message);
	}
}

SurveyQuestion_Demographic.prototype.Report = function(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS)
{
	try
	{
		this.Render(divQuestionHeading, divQuestionBody, rowQUESTION_RESULTS, true);
	}
	catch(e)
	{
		throw new Error('SurveyQuestion_Demographic.Report: ' + e.message);
	}
}

SurveyQuestion_Demographic.prototype.Summary = function(divQuestionHeading, divQuestionBody, callback, context)
{
	try
	{
		if ( this.SUMMARY_VISIBLE === undefined )
			this.SUMMARY_VISIBLE = true;
		else
			return;
		
		this.ANSWER_CHOICES_SUMMARY = new Array();
		if ( !Sql.IsEmptyString(this.row.COLUMN_CHOICES) )
		{
			// <Demographic><Field Name="NAME" Visible="" Required="">Name:</Field></Demographic>
			var arrCOLUMN_CHOICES = new Array();
			var xmlCOLUMN_CHOICES = $.parseXML(this.row.COLUMN_CHOICES);
			$(xmlCOLUMN_CHOICES).find('Field').each(function()
			{
				var oColumnChoice = new Object();
				oColumnChoice.Name     = $(this).attr('Name'    );
				oColumnChoice.Visible  = Sql.ToBoolean($(this).attr('Visible' ));
				oColumnChoice.Required = Sql.ToBoolean($(this).attr('Required'));
				oColumnChoice.Label    = $(this).text();
				arrCOLUMN_CHOICES.push(oColumnChoice);
			});
			for ( var i = 0; i < arrCOLUMN_CHOICES.length; i++ )
			{
				if ( arrCOLUMN_CHOICES[i].Visible )
				{
					var oSUMMARY = new Object();
					oSUMMARY.ANSWER_TEXT = arrCOLUMN_CHOICES[i].Label;
					oSUMMARY.ANSWER_ID   = md5(arrCOLUMN_CHOICES[i].Name);
					oSUMMARY.ANSWERED    = new Array();
					oSUMMARY.SKIPPED     = new Array();
					this.ANSWER_CHOICES_SUMMARY.push(oSUMMARY);
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
								}
							}
						}
					}
					SurveyQuestion_Helper_RenderAnswered(divQuestionHeading, nANSWERED, nSKIPPED);
					
					var tbl = document.createElement('table');
					tbl.id          = this.ID;
					tbl.className   = 'SurveyResultsDemographic';
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
						
						tdResponse = document.createElement('td');
						tdResponse.className = 'SurveyResultsResponseBody';
						tdResponse.width     = '35%';
						tr.appendChild(tdResponse);
						var divResponseLeft = document.createElement('div');
						divResponseLeft.style.float = 'left';
						if ( nANSWERED > 0 )
							divResponseLeft.innerHTML = Math.ceil(100 * oANSWER_CHOICES_SUMMARY.ANSWERED.length / nANSWERED).toString() + '%';
						else
							divResponseLeft.innerHTML = '0%';
						tdResponse.appendChild(divResponseLeft);
						
						var divResponseRight = document.createElement('div');
						divResponseRight.style.float = 'right';
						divResponseRight.innerHTML = oANSWER_CHOICES_SUMMARY.ANSWERED.length;
						tdResponse.appendChild(divResponseRight);
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
		throw new Error('SurveyQuestion_Demographic.Summary: ' + e.message);
	}
}

