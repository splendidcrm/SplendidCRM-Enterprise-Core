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
using Spring.Rest.Client.Support;

namespace Spring.Social.HubSpot.Api.Impl
{
	class CompanyTemplate : ICompanyOperations
	{
		protected RestTemplate restTemplate;
		protected int          maxResults  ;

		// 09/26/2020 Paul.  Latest version use bearer tokens. 
		public CompanyTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 1000        ;
		}

		public virtual IList<HBase> GetModified(DateTime startModifiedDate)
		{
			long lTicks = JsonUtils.ToUnixTicks(startModifiedDate);
			// http://developers.hubspot.com/docs/methods/companies/get_companies_created
			// http://developers.hubspot.com/docs/methods/companies/get_companies_modified
			string sURL = "/companies/v2/companies/recent/modified";
			// 04/27/2015 Paul.  A Sync-All request will have min date. 
			if ( startModifiedDate == DateTime.MinValue )
				sURL = "/companies/v2/companies";
			// 04/25/2015 Paul.  The documentation says that 100 is the maximum. 
			sURL += "?count=100&propertyMode=value_only&property=companyId&property=isDeleted&property=createdate&property=hs_lastmodifieddate";
			CompanyPagination pag = this.restTemplate.GetForObject<CompanyPagination>(sURL);
			List<HBase> all = new List<HBase>();
			foreach ( Company company in pag.items )
			{
				if ( startModifiedDate == DateTime.MinValue || company.lastmodifieddate > startModifiedDate )
					all.Insert(0, company);
			}
			while ( pag.hasmore )
			{
				string sPagedURL = sURL + "&offset=" + pag.offset;
				pag = this.restTemplate.GetForObject<CompanyPagination>(sPagedURL);
				foreach ( Company company in pag.items )
				{
					if ( startModifiedDate == DateTime.MinValue || company.lastmodifieddate > startModifiedDate )
						all.Insert(0, company);
				}
			}
			return all;
		}

		public virtual IList<Company> GetAll(string search)
		{
			string sURL = "/companies/v2/companies?count=100";
			// 04/25/2015 Paul.  There does not appear to be a search function. 
			//if ( !String.IsNullOrEmpty(search) )
			//{
			//	sURL = "/companies/v2/search/query?access_token=" + access_token;
			//	sURL += "&q=" + HttpUtils.UrlEncode(search);
			//}
			// 04/25/2015 Paul.  The maximum for contacts is 100, so assume that companies have the same max. 
			sURL += "&propertyMode=value_only";
			CompanyPagination pag = this.restTemplate.GetForObject<CompanyPagination>(sURL);
			List<Company> all = new List<Company>(pag.items);
			while ( pag.hasmore )
			{
				string sPagedURL = sURL + "&offset=" + pag.offset;
				pag = this.restTemplate.GetForObject<CompanyPagination>(sPagedURL);
				foreach ( Company company in pag.items )
				{
					all.Add(company);
				}
			}
			return all;
		}

		// 09/27/2020 Paul.  HubSpot is now using long instead of integers. 
		public Company GetById(long id)
		{
			string sURL = "/companies/v2/companies/" + id.ToString();
			return this.restTemplate.GetForObject<Company>(sURL);
		}

		public Company Insert(Company obj)
		{
			string sURL = "/companies/v2/companies";
			return this.restTemplate.PostForObject<Company>(sURL, obj);
		}

		public void Update(Company obj)
		{
			if ( !obj.id.HasValue )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/companies/v2/companies/" + obj.id.Value.ToString();
			//this.restTemplate.PostForObject<Company>(sURL, obj);
			// 04/28/2015 Paul.  PUT method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Company), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Company> responseExtractor = new MessageConverterResponseExtractor<Company>(this.restTemplate.MessageConverters);
			this.restTemplate.Execute<Company>(sURL, HttpMethod.PUT, requestCallback, responseExtractor);
		}

		// 09/27/2020 Paul.  HubSpot is now using long instead of integers. 
		public void Delete(long id)
		{
			string sURL = "/companies/v2/companies/" + id.ToString();
			this.restTemplate.Delete(sURL);
		}
	}
}