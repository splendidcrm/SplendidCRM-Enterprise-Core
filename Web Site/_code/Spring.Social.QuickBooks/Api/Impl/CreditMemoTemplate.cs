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
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Http;
using Spring.Rest.Client;

namespace Spring.Social.QuickBooks.Api.Impl
{
	class CreditMemoTemplate : QBaseTemplate<CreditMemo>, ICreditMemoOperations
	{
		public CreditMemoTemplate(RestTemplate restTemplate, string companyId) : base(restTemplate, companyId, "creditmemo")
		{
		}

		public CreditMemo GetById(string id)
		{
			// https://qb.sbfinance.intuit.com/v3/company/{companyId}/creditmemo/{id}
			return this.restTemplate.GetForObject<CreditMemo>("company/{companyId}/" + this.tableName + "/{id}", companyId, id);
		}

		public CreditMemo Insert(CreditMemo obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName;
			return this.restTemplate.PostForObject<CreditMemo>(sURL, obj);
		}

		public CreditMemo Update(CreditMemo obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=update";
			return this.restTemplate.PostForObject<CreditMemo>(sURL, obj);
		}

		public CreditMemo Delete(string id)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=delete";
			CreditMemo obj = GetById(id);
			return this.restTemplate.PostForObject<CreditMemo>(sURL, obj);
		}
	}
}
