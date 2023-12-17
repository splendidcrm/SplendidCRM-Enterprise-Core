/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
using System;
using System.Net.Mail;

using Microsoft.Extensions.Caching.Memory;

namespace SplendidCRM
{
	// 01/17/2017 Paul.  New SplendidMailClient object to encapsulate SMTP, Exchange and Google mail. 
	abstract public class SplendidMailClient
	{
		abstract public void Send(MailMessage mail);

		// 01/18/2017 Paul.  This method will return the appropriate Campaign Manager client, based on configuration. This is the global email sending account. 
		public static SplendidMailClient CreateMailClient(HttpApplicationState Application, IMemoryCache memoryCache, Security Security, SplendidError SplendidError, GoogleApps GoogleApps, Spring.Social.Office365.Office365Sync Office365Sync)
		{
			string sMAIL_SENDTYPE = Sql.ToString(Application["CONFIG.mail_sendtype"]);
			SplendidMailClient client = null;
			if ( String.Compare(sMAIL_SENDTYPE, "Office365", true) == 0 )
			{
				client = new SplendidMailOffice365(Office365Sync, ExchangeUtils.EXCHANGE_ID);
			}
			// 01/31/2017 Paul.  Add support for Exchange using Username/Password. 
			else if ( String.Compare(sMAIL_SENDTYPE, "Exchange-Password", true) == 0 )
			{
				client = new SplendidMailExchangePassword(Security);
			}
			else if ( String.Compare(sMAIL_SENDTYPE, "GoogleApps", true) == 0 )
			{
				client = new SplendidMailGmail(GoogleApps, EmailUtils.CAMPAIGN_MANAGER_ID);
			}
			else
			{
				client = new SplendidMailSmtp(Application, memoryCache, Security, SplendidError);
			}
			return client;
		}
	}
}
