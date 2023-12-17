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
using System.Net;
using Spring.Social.OAuth1;
using Spring.Social.QuickBooks.Api;
using Spring.Social.QuickBooks.Api.Impl;

namespace Spring.Social.QuickBooks.Connect
{
	public class QuickBooksServiceProvider : AbstractOAuth1ServiceProvider<IQuickBooks>
	{
		public QuickBooksServiceProvider(string consumerKey, string consumerSecret)
			: base(consumerKey, consumerSecret, new OAuth1Template(consumerKey, consumerSecret,
				"https://oauth.intuit.com/oauth/v1/get_request_token", 
				"https://workplace.intuit.com/Connect/Begin", 
				"https://appcenter.intuit.com/api/v1/authenticate", 
				"https://oauth.intuit.com/oauth/v1/get_access_token"))
		{
		}

		public override IQuickBooks GetApi(string accessToken, string secret)
		{
			throw(new Exception("GetApi requires a CompanyId"));
		}

		public IQuickBooks GetApi(string accessToken, string secret, string companyId)
		{
			// 11/12/2019 Paul.  QuickBooks now requires Tls12. 
			if ( !ServicePointManager.SecurityProtocol.HasFlag(SecurityProtocolType.Tls12) )
			{
				ServicePointManager.SecurityProtocol = ServicePointManager.SecurityProtocol | SecurityProtocolType.Tls12;
			}
			return new QuickBooksTemplate(this.ConsumerKey, this.ConsumerSecret, accessToken, secret, companyId);
		}
	}
}
