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

function formatDate(dtValue, sFormat)
{
	if ( dtValue instanceof Date && dtValue.getFullYear() > 1 && sFormat !== undefined && sFormat != null )
	{
		// 05/05/2013 Paul.  The FullCalendar has a better date formatting function. 
		// http://arshaw.com/fullcalendar/docs/utilities/formatDate/
		var options = 
			{ monthNames     : L10n.GetListTerms('month_names_dom'      )
			, monthNamesShort: L10n.GetListTerms('short_month_names_dom')
			, dayNames       : L10n.GetListTerms('day_names_dom'        )
			, dayNamesShort  : L10n.GetListTerms('short_day_names_dom'  )
			};
		return $.fullCalendar.formatDate(dtValue, sFormat, options);
	}
	else
	{
		return '';
	}
}

function FromJsonDate(sDATA_VALUE, sFormat)
{
	if ( typeof(sDATA_VALUE) == 'string' && sDATA_VALUE.substr(0, 7) == '\\/Date(' )
	{
		//alert(sDATA_VALUE.substr(sDATA_VALUE.length - 3, 3) + ' = ' + ')\\/');
		if ( sDATA_VALUE.substr(sDATA_VALUE.length - 3, 3) == ')\\/' )
		{
			sDATA_VALUE = sDATA_VALUE.substr(7, sDATA_VALUE.length - 7 - 3);
			var utcTime = parseInt(sDATA_VALUE);
			var dt = new Date(utcTime);
			// 08/28/2014 Paul.  SyncRest will return all dates as UTC and we store all dates as UTC in SQLite. 
			if ( !bREMOTE_ENABLED )
			{
				var off = dt.getTimezoneOffset();
				dt.setMinutes(dt.getMinutes() + off);
			}
			if ( sFormat !== undefined )
				sDATA_VALUE = formatDate(dt, sFormat);
			else
				sDATA_VALUE = dt;
		}
	}
	return sDATA_VALUE;
}

// http://weblogs.asp.net/bleroy/archive/2008/01/18/dates-and-json.aspx
function ToJsonDate(dt)
{
	var sDATA_VALUE = null;
	// 01/19/2013 Paul.  During testing, dt was not a valid date and threw an exception on getTimezoneOffset.  
	if ( !isNaN(dt) && Object.prototype.toString.call(dt) === '[object Date]' )
	{
		// 02/21/2013 Paul.  First clone the date before modifying. 
		var temp = new Date(dt.getTime());
		// 08/28/2014 Paul.  SyncRest will return all dates as UTC and we store all dates as UTC in SQLite. 
		if ( !bREMOTE_ENABLED )
		{
			var off = temp.getTimezoneOffset();
			temp.setMinutes(temp.getMinutes() - off);
		}
		// http://www.w3schools.com/jsref/jsref_obj_date.asp
		sDATA_VALUE = '\\/Date(' + temp.getTime() + ')\\/';
	}
	return sDATA_VALUE;
}

// 02/26/2016 Paul.  Use values from C# NumberFormatInfo. 
// https://www.customd.com/articles/14/jquery-number-format-redux
function formatNumber(number, oNumberFormat)
{
	number = (number + '').replace(/[^0-9+\-Ee.]/g, '');
	var n    = !isFinite(+number       ) ? 0 : +number;
	var prec = oNumberFormat.CurrencyDecimalDigits   ;
	var grp  = oNumberFormat.CurrencyGroupSizes      ;
	var sep  = oNumberFormat.CurrencyGroupSeparator  ;
	var dec  = oNumberFormat.CurrencyDecimalSeparator;
	var s    = '';
	s = (prec ? n.toFixed(prec) : '' + Math.round(n)).split('.');
	if ( s[0].length > grp )
	{
		var regex = new RegExp('\\B(?=(?:\\d{' + grp + '})+(?!\\d))', 'g');
		s[0] = s[0].replace(regex, sep);
	}
	if ( (s[1] || '').length > prec )
	{
		s[1] = s[1] || '';
		s[1] += new Array(prec - s[1].length + 1).join('0');
	}
	return s.join(dec);
}

var arrCurrencyNegativePattern  = ['($n)', '-$n', '$-n', '$n-', '(n$)', '-n$', 'n-$', 'n$-', '-n $', '-$ n', 'n $-', '$ n-', '$ -n', 'n- $', '($ n)', '(n $)'];  // https://msdn.microsoft.com/en-us/library/system.globalization.numberformatinfo.currencynegativepattern(v=vs.110).aspx
var arrCurrencyPositivePattern  = ['$n', 'n$', '$ n', 'n $'];  // https://msdn.microsoft.com/en-us/library/system.globalization.numberformatinfo.currencypositivepattern.aspx

function formatCurrency(number, oNumberFormat)
{
	var n = !isFinite(+number) ? 0 : +number;
	var s = formatNumber(number, oNumberFormat);
	if ( n >= 0 )
		s = arrCurrencyPositivePattern[oNumberFormat.CurrencyPositivePattern].replace('n', s).replace('$', oNumberFormat.CurrencySymbol);
	else
		s = arrCurrencyNegativePattern[oNumberFormat.CurrencyNegativePattern].replace('n', s).replace('$', oNumberFormat.CurrencySymbol);
	return s;
}

