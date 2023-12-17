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

namespace Spring.Social.SalesFusion.Api.Impl
{
	class LeadTemplate : ILeadOperations
	{
		protected virtual string CrmType
		{
			get { return "Lead"; }
		}

		protected RestTemplate restTemplate;
		const string sEndpoint = "/api/contacts/";

		public LeadTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		public virtual IList<HBase> GetModified(DateTime startModifiedDate)
		{
			string sURL = sEndpoint + "?crm_type=" + CrmType;
			if ( startModifiedDate != DateTime.MinValue )
				sURL += "&date_field=updated_date&start_date=" + startModifiedDate.ToUniversalTime().ToString("u");
			LeadPagination pag = this.restTemplate.GetForObject<LeadPagination>(sURL);
			List<HBase> all = new List<HBase>();
			foreach ( Lead item in pag.results )
			{
				if ( startModifiedDate == DateTime.MinValue || item.updated_date > startModifiedDate )
					all.Insert(0, item);
			}
			int nPage = 2;
			while ( !Sql.IsEmptyString(pag.next) )
			{
				string sPagedURL = sURL + (sURL.Contains("?") ? "&" : "?") + "page=" + nPage.ToString();
				pag = this.restTemplate.GetForObject<LeadPagination>(sPagedURL);
				foreach ( Lead item in pag.results )
				{
					if ( startModifiedDate == DateTime.MinValue || item.updated_date > startModifiedDate )
						all.Insert(0, item);
				}
				nPage++;
			}
			return all;
		}

		public virtual IList<Lead> GetAll()
		{
			string sURL = sEndpoint + "?crm_type=" + CrmType;
			LeadPagination pag = this.restTemplate.GetForObject<LeadPagination>(sURL);
			List<Lead> all = new List<Lead>(pag.results);
			int nPage = 2;
			while ( !Sql.IsEmptyString(pag.next) )
			{
				string sPagedURL = sURL + "?page=" + nPage.ToString();
				pag = this.restTemplate.GetForObject<LeadPagination>(sPagedURL);
				foreach ( Lead item in pag.results )
				{
					all.Add(item);
				}
				nPage++;
			}
			return all;
		}

		public virtual int GetCount()
		{
			string sURL = sEndpoint + "?crm_type=" + CrmType + "&page=1";
			HPagination pag = this.restTemplate.GetForObject<HPagination>(sURL);
			return pag.total_count;
		}

		public virtual IList<Lead> GetPage(int page)
		{
			string sURL = sEndpoint + "?crm_type=" + CrmType + "&page=" + page.ToString();
			LeadPagination pag = this.restTemplate.GetForObject<LeadPagination>(sURL);
			List<Lead> all = new List<Lead>(pag.results);
			return all;
		}

		public virtual Lead GetByEmail(string sEmailAddress)
		{
			string sURL = sEndpoint + "?crm_type=" + CrmType + "&email=" + sEmailAddress;
			return this.restTemplate.GetForObject<Lead>(sURL);
		}

		public Lead GetById(int id)
		{
			string sURL = sEndpoint + id.ToString() + "/";
			Lead lead = this.restTemplate.GetForObject<Lead>(sURL);
			if ( lead != null )
				lead.id = id;
			return lead;
		}

		public Lead Insert(Lead obj)
		{
			string sURL = sEndpoint;
			return this.restTemplate.PostForObject<Lead>(sURL, obj);
		}

		public void Update(Lead obj)
		{
			if ( !obj.id.HasValue )
				throw(new Exception("id must not be null during update operation."));
			string sURL = sEndpoint + obj.id.Value.ToString();
			//this.restTemplate.PostForObject<Lead>(sURL, obj);
			// 04/28/2015 Paul.  PUT method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Lead), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Lead> responseExtractor = new MessageConverterResponseExtractor<Lead>(this.restTemplate.MessageConverters);
			this.restTemplate.Execute<Lead>(sURL, HttpMethod.PUT, requestCallback, responseExtractor);
		}

		public void Delete(int id)
		{
			string sURL = sEndpoint + id.ToString() + "/";
			this.restTemplate.Delete(sURL);
		}
	}
}
