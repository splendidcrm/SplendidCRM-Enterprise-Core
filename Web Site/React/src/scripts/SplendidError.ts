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
import { dumpObj } from '../scripts/utility';
import { formatDate } from '../scripts/Formatting';

export class SplendidErrorStore
{
	arrErrorLog = new Array();
	sLastError = '';

	public ClearAllErrors()
	{
		this.arrErrorLog = new Array();
		this.sLastError = '';
	}

	public SystemError(e, method)
	{
		let message = this.FormatError(e, method);
		this.arrErrorLog.push(message);
		this.sLastError = message;
	}

	public SystemMessage(message)
	{
		if ( message != null && message != '' )
		{
			// 06/27/2017 Paul.  Prepend timestamp. 
			this.arrErrorLog.push(formatDate((new Date()), 'YYYY/MM/DD HH:mm:ss') + ' ' + message);
		}
		this.sLastError = message;
	}

	public SystemLog(message)
	{
		if (message != null && message != '')
		{
			this.arrErrorLog.push(formatDate((new Date()), 'YYYY/MM/DD HH:mm:ss') + ' ' + message);
		}
	}

	public SystemAlert(e, method)
	{
		let message = this.FormatError(e, method);
		this.arrErrorLog.push(message);
		alert(message);
	}

	public FormatError(e, method)
	{
		if ( typeof(e) == 'object' )
		{
			return method + ': ' + e.message + '<br>\n' + dumpObj(e, method);
		}
		else if ( typeof(e) == 'string' )
		{
			return method + ': ' + e + '<br>\n' + dumpObj(e, method);
		}
		else if ( typeof(e) != null )
		{
			return method + ': ' + e.toString() + '<br>\n' + dumpObj(e, method);
		}
		else
		{
			return method + ': ' + 'Unknown error' + '<br>\n' + dumpObj(e, method);
		}
	}
}

const splendidErrors = new SplendidErrorStore();
export default splendidErrors;
