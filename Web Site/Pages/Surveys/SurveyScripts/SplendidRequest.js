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

var SplendidError = new Object();
SplendidError.FormatError = function(e, method)
{
	return e.message + '<br>\n' + dumpObj(e, method);
};
SplendidError.SystemAlert = function(e, method)
{
	alert(dumpObj(e, method));
};
SplendidError.SystemMessage = function(message)
{
	var divError = document.getElementById('divError');
	divError.innerHTML = message;
};

function CreateSplendidRequest(sPath, sMethod, sContentType)
{
	// http://www.w3.org/TR/XMLHttpRequest/
	var xhr = null;
	try
	{
		if ( window.XMLHttpRequest )
			xhr = new XMLHttpRequest();
		else if ( window.ActiveXObject )
			xhr = new ActiveXObject("Msxml2.XMLHTTP");
		
		var url = sREMOTE_SERVER + sPath;
		if ( sMethod === undefined )
			sMethod = 'POST';
		if ( sContentType === undefined )
			sContentType = 'application/json; charset=utf-8';
		xhr.open(sMethod, url, true);
		if ( sAUTHENTICATION == 'Basic' )
			xhr.setRequestHeader('Authorization', 'Basic ' + Base64.encode(sUSER_NAME + ':' + sPASSWORD));
		xhr.setRequestHeader('content-type', sContentType);
		// 09/27/2011 Paul.  Add the URL to the object for debugging purposes. 
		// 10/19/2011 Paul.  IE6 does not allow this. 
		if ( window.XMLHttpRequest )
		{
			xhr.url    = url;
			xhr.Method = sMethod;
		}
	}
	catch(e)
	{
		SplendidError.SystemAlert(e, 'CreateSplendidRequest');
	}
	return xhr;
}

function GetSplendidResult(xhr, callback, context)
{
	var result = null;
	try
	{
		//alert(dumpObj(xhr, 'xhr.status = ' + xhr.status));
		if ( xhr.responseText.length > 0 )
		{
			result = JSON.parse(xhr.responseText);
			result.status = xhr.status;
			callback.call(context||this, result);
		}
		else if ( xhr.status == 0 || xhr.status == 2 || xhr.status == 12002 || xhr.status == 12007 || xhr.status == 12029 || xhr.status == 12030 || xhr.status == 12031 || xhr.status == 12152 )
		{
		}
		else if ( xhr.status == 405 )
		{
			var sMessage = 'Method Not Allowed.  ' + xhr.url;
			result = { 'status': xhr.status, 'ExceptionDetail': { 'status': xhr.status, 'Message': sMessage } };
			callback.call(context||this, result);
		}
		else
		{
			result = { 'status': xhr.status, 'ExceptionDetail': { 'status': xhr.status, 'Message': xhr.statusText + '(' + xhr.status + ')' } };
			callback.call(context||this, result);
		}
	}
	catch(e)
	{
		SplendidError.SystemAlert(e, 'GetSplendidResult');
		callback.call(context||this, result);
	}
}

function getUrlParam(paramName)
{
	var reParam = new RegExp('(?:[\?&]|&amp;)' + paramName + '=([^&]+)', 'i') ;
	var match = window.location.search.toLowerCase().match(reParam) ;

	return (match && match.length > 1) ? match[1] : '' ;
}

