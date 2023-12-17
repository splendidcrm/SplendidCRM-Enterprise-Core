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
	class TaxRateTemplate : QBaseTemplate<TaxRate>, ITaxRateOperations
	{
		public TaxRateTemplate(RestTemplate restTemplate, string companyId) : base(restTemplate, companyId, "taxrate")
		{
		}

		// 02/24/2015 Paul.  We want to filter internal TaxRates, such as:
		// NC Dept of Revenue-Other adjustments
		// NC Dept of Revenue-Adjustments to tax on sales
		public override IList<QBase> GetModified(DateTime startModifiedDate)
		{
			List<QBase> all = new List<QBase>();
			string sQuery = "select * from " + this.tableName;
			if ( startModifiedDate != DateTime.MinValue )
				sQuery += " where Metadata.LastUpdatedTime > '" + startModifiedDate.ToString("yyyy-MM-ddTHH:mm:sszzz") + "'";
			sQuery += " orderby Metadata.LastUpdatedTime";
			
			string sQueryPaginated = sQuery + " startPosition 1 maxResults 1000";
			string sURL = "company/" + companyId + "/query?query=" + HttpUtils.UrlEncode(sQueryPaginated);
			IList<TaxRate> lst = this.restTemplate.GetForObject<IList<TaxRate>>(sURL);
			foreach ( TaxRate qb in lst )
			{
				if ( qb.RateValue > 0 )
					all.Add(qb);
			}
			return all;
		}

		public override IList<TaxRate> GetAll(string filter, string sort)
		{
			List<TaxRate> all = new List<TaxRate>();
			string sQuery = "select * from " + this.tableName;
			if ( !String.IsNullOrEmpty(filter) )
				sQuery += " where " + filter;
			if ( !String.IsNullOrEmpty(sort) )
				sQuery += " order by " + sort;
			
			string sQueryPaginated = sQuery + " startPosition 1 maxResults 1000";
			string sURL = "company/" + companyId + "/query?query=" + HttpUtils.UrlEncode(sQueryPaginated);
			IList<TaxRate> lst = this.restTemplate.GetForObject<IList<TaxRate>>(sURL);
			foreach ( TaxRate qb in lst )
			{
				if ( qb.RateValue > 0 )
					all.Add(qb);
			}
			return all;
		}


		public TaxRate GetById(string id)
		{
			// https://qb.sbfinance.intuit.com/v3/company/{companyId}/TaxRate/{id}
			return this.restTemplate.GetForObject<TaxRate>("company/{companyId}/" + this.tableName + "/{id}", companyId, id);
		}

		public TaxRate Insert(TaxRate obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName;
			return this.restTemplate.PostForObject<TaxRate>(sURL, obj);
		}

		public TaxRate Update(TaxRate obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=update";
			return this.restTemplate.PostForObject<TaxRate>(sURL, obj);
		}

		public TaxRate Delete(string id)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=update";
			NameValueCollection data = new NameValueCollection();
			data.Add("Id"    , id     );
			data.Add("Active", "false");
			return this.restTemplate.PostForObject<TaxRate>(sURL, data);
		}
	}
}
