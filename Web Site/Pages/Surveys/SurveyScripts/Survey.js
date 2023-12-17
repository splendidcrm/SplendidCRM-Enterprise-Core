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

// 12/30/2015 Paul.  Build runtime header manually so that we can adjust for mobile dynamically. 
function Survey_CreateRuntimeHeader(divSurveyBody)
{
	var tblSurveyHeader = document.createElement('table');
	tblSurveyHeader.id          = 'tblSurveyHeader';
	tblSurveyHeader.cellPadding = 0;
	tblSurveyHeader.cellSpacing = 0;
	tblSurveyHeader.border      = 0;
	tblSurveyHeader.width       = '100%';
	tblSurveyHeader.className   = 'SurveyHeader';
	divSurveyBody.appendChild(tblSurveyHeader);
	var tbodySurveyHeader = document.createElement('tbody');
	tblSurveyHeader.appendChild(tbodySurveyHeader);
	var trSurveyHeader = document.createElement('tr');
	tbodySurveyHeader.appendChild(trSurveyHeader);
	
	var tdLogo = document.createElement('td');
	tdLogo.width = (isMobileDevice() ? '50%' : '1%');
	trSurveyHeader.appendChild(tdLogo);
	var divSurveyLogo = document.createElement('div');
	divSurveyLogo.id = 'divSurveyLogo';
	tdLogo.appendChild(divSurveyLogo);
	
	var tdProgressHeader = document.createElement('td');
	if ( isMobileDevice() )
	{
		var trMobileHeader = document.createElement('tr');
		tbodySurveyHeader.appendChild(trMobileHeader);
		trMobileHeader.appendChild(tdProgressHeader);
		tdProgressHeader.colSpan = 2;
	}
	else
	{
		trSurveyHeader.appendChild(tdProgressHeader);
	}
	
	var tdExit = document.createElement('td');
	tdExit.width = (isMobileDevice() ? '50%' : '1%');
	tdExit.align = 'right';
	trSurveyHeader.appendChild(tdExit);
	var divSurveyExitLink = document.createElement('span');
	divSurveyExitLink.id        = 'divSurveyExitLink';
	divSurveyExitLink.className = 'SurveyExitLink';
	divSurveyExitLink.style.marginRight = '8px';
	tdExit.appendChild(divSurveyExitLink);

	var divProgress = document.createElement('div');
	divProgress.align = 'center';
	tdProgressHeader.appendChild(divProgress);
	var divSurveyProgressBarFrame = document.createElement('div');
	divSurveyProgressBarFrame.id        = 'divSurveyProgressBarFrame';
	divSurveyProgressBarFrame.align     = 'left';
	divSurveyProgressBarFrame.className = 'SurveyProgressBarFrame';
	if ( isMobileDevice() )
		divSurveyProgressBarFrame.style.width = '95%';
	divProgress.appendChild(divSurveyProgressBarFrame);

	var tblSurveyProgressBar = document.createElement('table');
	tblSurveyProgressBar.id          = 'tblSurveyProgressBar';
	tblSurveyProgressBar.cellSpacing = 0;
	tblSurveyProgressBar.width       = '100%';
	divSurveyProgressBarFrame.appendChild(tblSurveyProgressBar);
	var tbodySurveyProgressBar = document.createElement('tbody');
	tbodySurveyProgressBar.className = 'SurveyProgressBar';
	tblSurveyProgressBar.appendChild(tbodySurveyProgressBar);
	tr = document.createElement('tr');
	tbodySurveyProgressBar.appendChild(tr);
	td = document.createElement('td');
	td.align         = 'center';
	td.style.padding = '2px';
	tr.appendChild(td);
	var divSurveyProgressBarText = document.createElement('div');
	divSurveyProgressBarText.id        = 'divSurveyProgressBarText';
	// 03/14/2016 Paul.  Firefox does not support innerText. 
	divSurveyProgressBarText.innerHTML = '0%';
	td.appendChild(divSurveyProgressBarText);

	var lblError = document.createElement('div');
	lblError.id        = 'lblError';
	lblError.className = 'SurveyQuestionError';
	divProgress.appendChild(lblError);

	var divSurveyTitle = document.createElement('div');
	divSurveyTitle.id        = 'divSurveyTitle';
	divSurveyTitle.className = 'SurveyTitle';
	divSurveyBody.appendChild(divSurveyTitle);
	var divSurveyPages = document.createElement('div');
	divSurveyPages.id        = 'divSurveyPages';
	divSurveyBody.appendChild(divSurveyPages);
	var br = document.createElement('br');
	divSurveyBody.appendChild(br);
	var divSurveyComplete = document.createElement('div');
	divSurveyComplete.id            = 'divSurveyComplete';
	divSurveyComplete.align         = 'center';
	divSurveyComplete.className     = 'SurveyComplete';
	divSurveyComplete.style.display = 'none';
	divSurveyBody.appendChild(divSurveyComplete);

	var divFooterCopyright = document.getElementById('divFooterCopyright');
	if ( divFooterCopyright != null && isMobileDevice() )
	{
		divFooterCopyright.style.display = 'none';
	}
}

function Survey_LoadItem(sMODULE_NAME, sID, callback, context)
{
	var xhr = CreateSplendidRequest('Survey.svc/GetSurvey?ID=' + sID, 'GET');
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
					callback.call(context||this, -1, SplendidError.FormatError(e, 'Survey_LoadItem'));
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
			callback.call(context||this, -1, SplendidError.FormatError(e, 'Survey_LoadItem'));
	}
}

function SurveyResults_LoadTable(sTABLE_NAME, sSORT_FIELD, sSORT_DIRECTION, sSELECT, sFILTER, callback, context)
{
	// 03/01/2013 Paul.  If sSORT_FIELD is not provided, then clear sSORT_DIRECTION. 
	if ( sSORT_FIELD === undefined || sSORT_FIELD == null || sSORT_FIELD == '' )
	{
		sSORT_FIELD     = '';
		sSORT_DIRECTION = '';
	}
	var xhr = CreateSplendidRequest('Rest.svc/GetModuleTable?TableName=' + sTABLE_NAME + '&$orderby=' + encodeURIComponent(sSORT_FIELD + ' ' + sSORT_DIRECTION) + '&$select=' + escape(sSELECT) + '&$filter=' + escape(sFILTER), 'GET');
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
							// 10/04/2011 Paul.  SurveyResults_LoadTable returns the rows. 
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
					callback.call(context||this, -1, SplendidError.FormatError(e, 'SurveyResults_LoadTable'));
				}
			}, context||this);
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
			callback.call(context||this, -1, SplendidError.FormatError(e, 'SurveyResults_LoadTable'));
	}
}

function Survey(row)
{
	this.row = row;
	this.ID  = row.ID.replace(/-/g, '_');
	this.PARENT_ID        = null;
	this.SURVEY_RESULT_ID = null;
	this.IS_COMPLETE      = false;
	this.START_DATE       =  new Date();
	this.SUBMIT_DATE      = null;

	// 12/27/2015 Paul.  On a mobile device, place each question on it's own page. 
	// By creating the mobile pages here, not much else needs to change. 
	// 01/01/2016 Paul.  Catalin wants to force page navigation for each question, just like mobile navigation. 
	if ( isMobileDevice() || Sql.ToString(this.row.SURVEY_STYLE) == 'One Question Per Page' )
	{
		var MOBILE_SURVEY_PAGES = new Array();
		for ( var i = 0; i < this.row.SURVEY_PAGES.length; i++ )
		{
			var rowSURVEY_PAGE = this.row.SURVEY_PAGES[i];
			for ( var j = 0; j < rowSURVEY_PAGE.SURVEY_QUESTIONS.length; j++ )
			{
				var rowSURVEY_QUESTION = rowSURVEY_PAGE.SURVEY_QUESTIONS[j];
				var rowMOBILE_PAGE = new Object();
				rowMOBILE_PAGE.ID                     = rowSURVEY_PAGE.ID                    ;
				rowMOBILE_PAGE.SURVEY_ID              = rowSURVEY_PAGE.SURVEY_ID             ;
				rowMOBILE_PAGE.NAME                   = rowSURVEY_PAGE.NAME                  ;
				rowMOBILE_PAGE.PAGE_NUMBER            = rowSURVEY_PAGE.PAGE_NUMBER           ;
				rowMOBILE_PAGE.QUESTION_RANDOMIZATION = rowSURVEY_PAGE.QUESTION_RANDOMIZATION;
				rowMOBILE_PAGE.DESCRIPTION            = rowSURVEY_PAGE.DESCRIPTION           ;
				rowMOBILE_PAGE.RANDOMIZE_COUNT        = rowSURVEY_PAGE.RANDOMIZE_COUNT       ;
				rowMOBILE_PAGE.SURVEY_QUESTIONS       = new Array();
				rowMOBILE_PAGE.SURVEY_QUESTIONS.push(rowSURVEY_QUESTION);
				rowMOBILE_PAGE.MOBILE_ID              = rowSURVEY_QUESTION.ID;
				MOBILE_SURVEY_PAGES.push(rowMOBILE_PAGE);
			}
		}
		this.row.SURVEY_PAGES = MOBILE_SURVEY_PAGES;
	}
	// 11/10/2018 Paul.  Hidden questions will remain on the page, but we need to prevent them from being on their own page. 
	// So move them to the first page. 
	var HIDDEN_QUESTIONS = new Array();
	for ( var i = this.row.SURVEY_PAGES.length - 1; i >= 0 ; i-- )
	{
		var rowSURVEY_PAGE = this.row.SURVEY_PAGES[i];
		for ( var j = rowSURVEY_PAGE.SURVEY_QUESTIONS.length - 1; j >= 0; j-- )
		{
			var rowSURVEY_QUESTION = rowSURVEY_PAGE.SURVEY_QUESTIONS[j];
			if ( rowSURVEY_QUESTION.QUESTION_TYPE == 'Hidden' )
			{
				HIDDEN_QUESTIONS.push(rowSURVEY_QUESTION);
				rowSURVEY_PAGE.SURVEY_QUESTIONS.splice(j, 1);
			}
		}
		if ( rowSURVEY_PAGE.SURVEY_QUESTIONS.length == 0 )
		{
			this.row.SURVEY_PAGES.splice(i, 1);
		}
	}
	if ( HIDDEN_QUESTIONS.length > 0 )
	{
		for ( var j = 0; j < HIDDEN_QUESTIONS.length; j++ )
		{
			var rowSURVEY_QUESTION = HIDDEN_QUESTIONS[j];
			this.row.SURVEY_PAGES[0].SURVEY_QUESTIONS.push(rowSURVEY_QUESTION);
		}
	}
}

Survey.prototype.Randomize = function()
{
	try
	{
		if ( this.row.RANDOMIZE_APPLIED === undefined )
			this.row.RANDOMIZE_APPLIED = false;
		if ( this.row.RANDOMIZE_COUNT === undefined )
			this.row.RANDOMIZE_COUNT = 0;
		if ( !this.row.RANDOMIZE_APPLIED )
		{
			if ( !Sql.IsEmptyString(this.row.PAGE_RANDOMIZATION) && this.row.SURVEY_PAGES.length > 0 )
			{
				if ( this.row.SURVEY_PAGES.length > 1 )
				{
					if ( this.row.PAGE_RANDOMIZATION == 'Randomize' )
					{
						// http://stackoverflow.com/questions/2450954/how-to-randomize-a-javascript-array
						for ( var i = this.row.SURVEY_PAGES.length - 1; i > 0; i-- )
						{
							var j = Math.floor(Math.random() * (i + 1));
							var temp = this.row.SURVEY_PAGES[i];
							this.row.SURVEY_PAGES[i] = this.row.SURVEY_PAGES[j];
							this.row.SURVEY_PAGES[j] = temp;
						}
					}
					else if ( this.row.PAGE_RANDOMIZATION == 'Flip' )
					{
						if ( Sql.ToInteger(this.row.RANDOMIZE_COUNT) % 2 == 0 )
						{
							this.row.SURVEY_PAGES.reverse();
						}
					}
					else if ( this.row.PAGE_RANDOMIZATION == 'Rotate' )
					{
						var nRotateCount = Sql.ToInteger(this.row.RANDOMIZE_COUNT) % this.row.SURVEY_PAGES.length;
						for ( var i = 0; i < nRotateCount; i++ )
						{
							this.row.SURVEY_PAGES.push(this.row.SURVEY_PAGES.shift());
						}
					}
				}
			}
			this.row.RANDOMIZE_APPLIED = true;
		}
		this.RenumberPages();
	}
	catch(e)
	{
		throw new Error('Survey.Randomize: ' + e.message);
	}
}

Survey.prototype.RenumberPages = function()
{
	if ( this.row.RENUMBER_PAGES === undefined )
		this.row.RENUMBER_PAGES = true;
	if ( this.row.RENUMBER_PAGES )
	{
		var nQUESTION_OFFSET = 0;
		for ( var i = 0; i < this.row.SURVEY_PAGES.length; i++ )
		{
			var rowPAGE = this.row.SURVEY_PAGES[i];
			rowPAGE.PAGE_NUMBER = i + 1;
			rowPAGE.QUESTION_OFFSET = nQUESTION_OFFSET;
			
			var nNON_QUESTIONS = 0;
			for ( var j = 0; j < rowPAGE.SURVEY_QUESTIONS.length; j++ )
			{
				var rowQUESTION = rowPAGE.SURVEY_QUESTIONS[j];
				// 06/13/2013 Paul.  Plain Text and Images do not get question numbers. 
				// 11/10/2018 Paul.  Provide a way to get a hidden value for lead population. 
				if ( rowQUESTION.QUESTION_TYPE == 'Plain Text' || rowQUESTION.QUESTION_TYPE == 'Image' || rowQUESTION.QUESTION_TYPE == 'Hidden' )
					nNON_QUESTIONS++;
			}
			nQUESTION_OFFSET += rowPAGE.SURVEY_QUESTIONS.length - nNON_QUESTIONS;
		}
		this.row.RENUMBER_PAGES = false;
	}
}

Survey.prototype.ApplyTheme = function()
{
	try
	{
		var sSURVEY_THEME_ID = this.row.SURVEY_THEME_ID.replace(/-/g, '_');
		var bThemeFound = false;
		var lnkDefaultTheme = null;
		var arrLinks = document.getElementsByTagName('link');
		for ( var i = 0; i < arrLinks.length; i++ )
		{
			if ( arrLinks[i].getAttribute('id') == sSURVEY_THEME_ID )
			{
				bThemeFound = true;
			}
			if ( arrLinks[i].getAttribute('href').indexOf('stylesheet.aspx') >= 0 )
			{
				lnkDefaultTheme = arrLinks[i];
			}
		}
		if ( !bThemeFound )
		{
			var css = document.createElement('link');
			css.setAttribute('id'   , sSURVEY_THEME_ID);
			css.setAttribute('rel'  , 'stylesheet');
			css.setAttribute('type' , 'text/css'  );
			css.setAttribute('href' , sREMOTE_SERVER + 'Surveys/stylesheet.aspx?ID=' + this.row.SURVEY_THEME_ID);
			// 06/15/2013 Paul.  Unload the default theme after the new theme has been loaded to prevent ugly page. 
			// IE9 does not seem to support the load event for links. 
			if ( css.addEventListener !== undefined )
			{
				css.addEventListener('load', function()
				{
					if ( lnkDefaultTheme != null )
						lnkDefaultTheme.parentNode.removeChild(lnkDefaultTheme);
				});
			}
			else
			{
				// 06/15/2013 Paul.  Keep both themes to prevent flicker. 
				//if ( lnkDefaultTheme != null )
				//	lnkDefaultTheme.parentNode.removeChild(lnkDefaultTheme);
			}
			document.getElementsByTagName('head')[0].appendChild(css);
		}
	}
	catch(e)
	{
		throw new Error('Survey.ApplyTheme: ' + e.message);
	}
}

Survey.prototype.Render = function(rowQUESTION_RESULTS, bDisable)
{
	try
	{
		this.ApplyTheme();
		document.title = this.row.NAME;
		
		var divSurveyTitle = document.getElementById('divSurveyTitle');
		divSurveyTitle.innerHTML = this.row.NAME;

		var divSurveyProgressBarText = document.getElementById('divSurveyProgressBarText');
		divSurveyProgressBarText.innerHTML = '0%';
		
		var divSurveyPages = document.getElementById('divSurveyPages');
		while ( divSurveyPages.childNodes.length > 0 )
		{
			divSurveyPages.removeChild(divSurveyPages.firstChild);
		}
		
		this.Randomize();
		for ( var i = 0; i < this.row.SURVEY_PAGES.length; i++ )
		{
			var page = new SurveyPage(this.row.SURVEY_PAGES[i]);
			page.Render(divSurveyPages, rowQUESTION_RESULTS, bDisable);
			this.RenderPageNavigation(page, i);
			if ( i == 0 )
				page.Activate(true);
		}
		this.UpdateProgressBar(0);
	}
	catch(e)
	{
		throw new Error('Survey.Render: ' + e.message);
	}
}

// 12/13/2015 Paul.  Use a flag to prevent survey takers from clicking the submit button more than once. 
var bSubmittingSurvey = false;

Survey.prototype.RenderPageNavigation = function(page, nPageIndex)
{
	try
	{
		var divSurveyPage = document.getElementById(page.ID);
		var divSurveyPageNavigation = document.createElement('div');
		divSurveyPageNavigation.id        = 'divSurveyPageNavigation';
		divSurveyPageNavigation.className = 'SurveyPageNavigation';
		divSurveyPage.appendChild(divSurveyPageNavigation);
		// 01/01/2016 Paul.  Don't center navigation buttons on mobile.
		if ( isMobileDevice() )
		{
			divSurveyPageNavigation.style.textAlign = 'left';
		}
		
		var bStartPage = (nPageIndex == 0);
		var bEndPage   = (nPageIndex == this.row.SURVEY_PAGES.length - 1);
		if ( !bStartPage )
		{
			var spnSurveyPrev = document.createElement('span');
			spnSurveyPrev.innerHTML = this.LBL_PREV_LINK;
			spnSurveyPrev.className = 'SurveyNavigationButton';
			divSurveyPageNavigation.appendChild(spnSurveyPrev);
			spnSurveyPrev.onclick = BindArguments(function(survey, page, nPageIndex)
			{
				try
				{
					page.Activate(false);
					var pagePrev = new SurveyPage(survey.row.SURVEY_PAGES[nPageIndex - 1]);
					pagePrev.Activate(true);
					survey.UpdateProgressBar(nPageIndex - 1);
				}
				catch(e)
				{
					alert(e.message);
				}
			}, this, page, nPageIndex);
		}
		if ( !bEndPage )
		{
			var spnSurveyNext = document.createElement('span');
			spnSurveyNext.innerHTML = this.LBL_NEXT_LINK;
			spnSurveyNext.className = 'SurveyNavigationButton';
			divSurveyPageNavigation.appendChild(spnSurveyNext);
			spnSurveyNext.onclick = BindArguments(function(survey, page, nPageIndex)
			{
				if ( page.Validate() )
				{
					try
					{
						survey.SubmitResults(page, nPageIndex, false, function(status, message)
						{
							if ( status == 1 )
							{
								page.Activate(false);
								var pageNext = new SurveyPage(survey.row.SURVEY_PAGES[nPageIndex + 1]);
								pageNext.Activate(true);
								survey.UpdateProgressBar(nPageIndex + 1);
							}
						});
					}
					catch(e)
					{
						alert(e.message);
					}
				}
			}, this, page, nPageIndex);
		}
		else
		{
			var spnSurveyDone = document.createElement('span');
			spnSurveyDone.innerHTML = this.LBL_SUBMIT_LINK;
			spnSurveyDone.className = 'SurveyNavigationButton';
			divSurveyPageNavigation.appendChild(spnSurveyDone);
			spnSurveyDone.onclick = BindArguments(function(survey, page, nPageIndex)
			{
				try
				{
					// 12/13/2015 Paul.  Use a flag to prevent survey takers from clicking the submit button more than once. 
					if ( !bSubmittingSurvey )
					{
						bSubmittingSurvey = true;
						// 12/13/2015 Paul.  As a failsafe to prevent against a permanent disable of submit, use a 3 second timeout to re-enable. 
						setTimeout(function(){ bSubmittingSurvey = false; }, 3000);
						
						if ( page.Validate() )
						{
							survey.SubmitResults(page, nPageIndex, true, function(status, message)
							{
								bSubmittingSurvey = false;
								//alert('Done.  Ready to test again');
							});
						}
						else
						{
							bSubmittingSurvey = false;
						}
					}
					else
					{
						alert('Results are currently being submitted.  Please wait.');
					}
				}
				catch(e)
				{
					alert(e.message);
				}
			}, this, page, nPageIndex);
		}
	}
	catch(e)
	{
		throw new Error('Survey.PageNavigation: ' + e.message);
	}
}

Survey.prototype.UpdateProgressBar = function(nPageIndex)
{
	var nProgress = Math.round(100 * (nPageIndex + 1) / this.row.SURVEY_PAGES.length);
	if ( nProgress > 100 )
		nProgress = 100;
	else if ( nProgress == 0 )
		nProgress = 1;
	
	var sProgress = nProgress.toString() + '%';
	var tblSurveyProgressBar     = document.getElementById('tblSurveyProgressBar'    );
	var divSurveyProgressBarText = document.getElementById('divSurveyProgressBarText');
	divSurveyProgressBarText.innerHTML = sProgress;
	tblSurveyProgressBar.style.width   = sProgress;
}

Survey.prototype.SubmitResults = function(page, nPageIndex, bSurveyComplete, callback)
{
	var divSurveyComplete = document.getElementById('divSurveyComplete');
	divSurveyComplete.style.display = 'none';

	if ( bSurveyComplete )
	{
		this.IS_COMPLETE = true;
		this.SUBMIT_DATE = ToJsonDate(new Date());
	}
	
	var newSURVEY = new Object();
	newSURVEY.ID               = this.row.ID;
	newSURVEY.PARENT_ID        = this.PARENT_ID;
	newSURVEY.SURVEY_RESULT_ID = this.SURVEY_RESULT_ID;
	newSURVEY.IS_COMPLETE      = this.IS_COMPLETE;
	newSURVEY.START_DATE       = ToJsonDate(this.START_DATE);
	newSURVEY.SUBMIT_DATE      = this.SUBMIT_DATE;
	newSURVEY.SURVEY_PAGES     = new Array();
	// 01/04/2019 Paul.  Survey kisok may take current user assignment. 
	newSURVEY.CURRENT_USER_ID  = null;
	newSURVEY.CURRENT_TEAM_ID  = null;
	// 10/01/2018 Paul.  Include SURVEY_TARGET_MODULE. 
	newSURVEY.SURVEY_TARGET_MODULE = this.row.SURVEY_TARGET_MODULE;

	var arrSURVEY_PAGES = this.row.SURVEY_PAGES;
	var i = nPageIndex;
	//for ( var i = 0; i < arrSURVEY_PAGES.length; i++ )
	{
		var newPAGE = new Object();
		newSURVEY.SURVEY_PAGES.push(newPAGE);
		newPAGE.ID               = arrSURVEY_PAGES[i].ID;
		newPAGE.SURVEY_QUESTIONS = new Array();
		
		var arrSURVEY_QUESTIONS = arrSURVEY_PAGES[i].SURVEY_QUESTIONS;
		for ( var j = 0; j < arrSURVEY_QUESTIONS.length; j++ )
		{
			var sQUESTION_TYPE = arrSURVEY_QUESTIONS[j].QUESTION_TYPE;
			if ( sQUESTION_TYPE != 'Plain Text' && sQUESTION_TYPE != 'Image' )
			{
				var newQUESTION = new Object();
				newPAGE.SURVEY_QUESTIONS.push(newQUESTION);
				newQUESTION.ID              = arrSURVEY_QUESTIONS[j].ID;
				newQUESTION.QUESTION_TYPE   = sQUESTION_TYPE;
				// 03/12/2019 Paul.  Include DISPLAY_FORMAT for Single Date. 
				if ( sQUESTION_TYPE == 'Date' || sQUESTION_TYPE == 'Single Date' )
					newQUESTION.DISPLAY_FORMAT  = arrSURVEY_QUESTIONS[j].DISPLAY_FORMAT;
				newQUESTION.OTHER_AS_CHOICE = arrSURVEY_QUESTIONS[j].OTHER_AS_CHOICE;
				// 10/01/2018 Paul.  Save raw survey page data for lead generation. 
				newQUESTION.ANSWER_CHOICES  = arrSURVEY_QUESTIONS[j].ANSWER_CHOICES;
				newQUESTION.COLUMN_CHOICES  = arrSURVEY_QUESTIONS[j].COLUMN_CHOICES;
				var arrVALUES = SurveyQuestion_Value(arrSURVEY_QUESTIONS[j]);
				// 06/15/2013 Paul.  Even if no values, log that the user saw the question. 
				if ( arrVALUES != null && arrVALUES.length > 0 )
					newQUESTION.VALUES = arrVALUES;
			}
		}
	}
	
	//MAX_DUMP_DEPTH = 5;
	//alert(dumpObj(newSURVEY, 'newSURVEY ' + nPageIndex + ' ' + arrSURVEY_PAGES.length));
	this.Update(newSURVEY, function(status, message)
	{
		var divSurveyComplete = document.getElementById('divSurveyComplete');
		if ( status == 1 )
		{
			this.SURVEY_RESULT_ID = message;
			if ( bSurveyComplete )
			{
				page.Activate(false);
				divSurveyComplete.className = 'SurveyComplete';
				divSurveyComplete.innerHTML = this.LBL_SURVEY_COMPLETE;
				divSurveyComplete.style.display = 'block';
			}
		}
		else
		{
			divSurveyComplete.className = 'SurveyQuestionError';
			divSurveyComplete.innerHTML = message;
			divSurveyComplete.style.display = 'block';
		}
		callback(status, message);
	}, this);
}

Survey.prototype.Update = function(row, callback, context)
{
	/*
	if ( !ValidateCredentials() )
	{
		callback.call(context||this, -1, 'Invalid connection information.');
		return;
	}
	else if ( row == null )
	{
		callback.call(context||this, -1, 'UpdateModule: row is invalid.');
		return;
	}
	*/
	var xhr = CreateSplendidRequest('Survey.svc/UpdateSurvey', 'POST', 'application/octet-stream');
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
							var sID = result.d;
							callback.call(context||this, 1, sID);
						}
						else
						{
							callback.call(context||this, -1, xhr.responseText);
						}
					}
					else if ( result.status == 0 )
					{
						callback.call(context||this, -1, 'Offline save is not suported at this time.');
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
					callback.call(context||this, -1, SplendidError.FormatError(e, 'Survey.Update'));
				}
			});
		}
	}
	try
	{
		xhr.send(JSON.stringify(row));
	}
	catch(e)
	{
		callback.call(context||this, -1, SplendidError.FormatError(e, 'Survey.Update'));
	}
}

Survey.prototype.Report = function(rowSURVEY_RESULTS)
{
	try
	{
		this.ApplyTheme();
		
		var divSurveyTitle = document.getElementById('divSurveyTitle');
		divSurveyTitle.innerHTML = this.row.NAME;
		
		var divSurveyPages = document.getElementById('divSurveyPages');
		while ( divSurveyPages.childNodes.length > 0 )
		{
			divSurveyPages.removeChild(divSurveyPages.firstChild);
		}
		
		this.RenumberPages();
		for ( var i = 0; i < this.row.SURVEY_PAGES.length; i++ )
		{
			var page = new SurveyPage(this.row.SURVEY_PAGES[i]);
			
			var rowPAGE_RESULTS = new Array();
			for ( var j = 0; j < rowSURVEY_RESULTS.length; j++ )
			{
				if ( page.row.ID == rowSURVEY_RESULTS[j].SURVEY_PAGE_ID )
				{
					rowPAGE_RESULTS.push(rowSURVEY_RESULTS[j]);
				}
			}
			page.Report(divSurveyPages, rowPAGE_RESULTS);
		}
	}
	catch(e)
	{
		throw new Error('Survey.Report: ' + e.message);
	}
}

Survey.prototype.Summary = function()
{
	try
	{
		this.ApplyTheme();
		
		var divSurveyTitle = document.getElementById('divSurveyTitle');
		divSurveyTitle.innerHTML = this.row.NAME;
		
		var divSurveyPages = document.getElementById('divSurveyPages');
		while ( divSurveyPages.childNodes.length > 0 )
		{
			divSurveyPages.removeChild(divSurveyPages.firstChild);
		}
		
		this.RenumberPages();
		for ( var i = 0; i < this.row.SURVEY_PAGES.length; i++ )
		{
			var page = new SurveyPage(this.row.SURVEY_PAGES[i]);
			page.Summary(divSurveyPages);
		}
		//$.force_appear();

	}
	catch(e)
	{
		throw new Error('Survey.Summary: ' + e.message);
	}
}

