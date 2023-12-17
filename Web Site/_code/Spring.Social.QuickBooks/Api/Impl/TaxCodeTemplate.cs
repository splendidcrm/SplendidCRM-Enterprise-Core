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
	class TaxCodeTemplate : QBaseTemplate<TaxCode>, ITaxCodeOperations
	{
		public TaxCodeTemplate(RestTemplate restTemplate, string companyId) : base(restTemplate, companyId, "taxcode")
		{
		}

		// 02/24/2015 Paul.  We want to filter internal TaxCodes, such as:
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
			IList<TaxCode> lst = this.restTemplate.GetForObject<IList<TaxCode>>(sURL);
			foreach ( TaxCode qb in lst )
			{
				//if ( qb.TaxableValue && !qb.TaxGroupValue )
				int nId = 0;
				// 02/26/2015 Paul.  Id must be an integer.  Ignore TAX, NON and CustomSalesTax. 
				if ( int.TryParse(qb.Id, out nId) )
					all.Add(qb);
			}
			return all;
		}

		public override IList<TaxCode> GetAll(string filter, string sort)
		{
			List<TaxCode> all = new List<TaxCode>();
			string sQuery = "select * from " + this.tableName;
			if ( !String.IsNullOrEmpty(filter) )
				sQuery += " where " + filter;
			if ( !String.IsNullOrEmpty(sort) )
				sQuery += " order by " + sort;
			
			string sQueryPaginated = sQuery + " startPosition 1 maxResults 1000";
			string sURL = "company/" + companyId + "/query?query=" + HttpUtils.UrlEncode(sQueryPaginated);
			IList<TaxCode> lst = this.restTemplate.GetForObject<IList<TaxCode>>(sURL);
			foreach ( TaxCode qb in lst )
			{
				//if ( qb.TaxableValue && !qb.TaxGroupValue )
				int nId = 0;
				// 02/26/2015 Paul.  Id must be an integer.  Ignore TAX, NON and CustomSalesTax. 
				if ( int.TryParse(qb.Id, out nId) )
					all.Add(qb);
			}
			return all;
		}


		public TaxCode GetById(string id)
		{
			// https://qb.sbfinance.intuit.com/v3/company/{companyId}/TaxCode/{id}
			return this.restTemplate.GetForObject<TaxCode>("company/{companyId}/" + this.tableName + "/{id}", companyId, id);
		}

		public TaxCode Insert(TaxCode obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName;
			return this.restTemplate.PostForObject<TaxCode>(sURL, obj);
		}

		public TaxCode Update(TaxCode obj)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=update";
			return this.restTemplate.PostForObject<TaxCode>(sURL, obj);
		}

		public TaxCode Delete(string id)
		{
			string sURL = "company/" + companyId + "/" + this.tableName + "?operation=update";
			NameValueCollection data = new NameValueCollection();
			data.Add("Id"    , id     );
			data.Add("Active", "false");
			return this.restTemplate.PostForObject<TaxCode>(sURL, data);
		}
	}
}
