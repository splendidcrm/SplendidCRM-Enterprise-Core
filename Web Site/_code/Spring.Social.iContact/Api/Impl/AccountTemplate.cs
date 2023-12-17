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
using System.Collections.Generic;
using System.Collections.Specialized;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;

namespace Spring.Social.iContact.Api.Impl
{
	class AccountTemplate : IAccountOperations
	{
		protected RestTemplate restTemplate;

		public AccountTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		public IList<Account> GetAccounts()
		{
			string sURL = "https://app.icontact.com/icp/a/";
			IList<Account> all = this.restTemplate.GetForObject<IList<Account>>(sURL);
			return all;
		}

		public IList<ClientFolder> GetClientFolders(string sAccountID)
		{
			string sURL = "https://app.icontact.com/icp/a/" + sAccountID + "/c";
			IList<ClientFolder> all = this.restTemplate.GetForObject<IList<ClientFolder>>(sURL);
			return all;
		}

	}
}
