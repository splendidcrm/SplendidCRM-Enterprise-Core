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
using System.Diagnostics;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;

namespace Spring.Social.PhoneBurner.Api.Impl
{
	class ContactTemplate : IContactOperations
	{
		protected string       access_token;
		protected RestTemplate restTemplate;
		protected int          maxResults  ;

		public ContactTemplate(string access_token, RestTemplate restTemplate)
		{
			this.access_token = access_token;
			this.restTemplate = restTemplate;
			this.maxResults   = 1000        ;
		}

		public virtual IList<HBase> GetModified(DateTime startModifiedDate)
		{
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.ContactTemplate.GetModified " + startModifiedDate.ToString());
			// 08/16/2020 Paul.  The documentation says that 100 is the maximum. 
			// https://www.phoneburner.com/developer/route_list#contacts
			string sURL = "/rest/1/contacts?page_size=100";
			sURL += "&sort_order=ASC";
			sURL += "&included_trashed=1";
			if ( startModifiedDate != DateTime.MinValue )
			{
				sURL += "&include_new=1";
				sURL += "&updated_from=" + startModifiedDate.ToString("yyyy-MM-dd HH:mm:ss");
			}
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			List<HBase> all = new List<HBase>(pag.items);
			while ( pag.page < pag.total_pages )
			{
				string sPagedURL = sURL + "&page=" + pag.page + 1;
				pag = this.restTemplate.GetForObject<ContactPagination>(sPagedURL);
				foreach ( Contact contact in pag.items )
				{
					all.Insert(0, contact);
				}
			}
			return all;
		}

		public virtual IList<Contact> GetAll(string search)
		{
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.ContactTemplate.GetAll " + Sql.ToString(search));
			// 08/16/2020 Paul.  The documentation says that 100 is the maximum. 
			// https://www.phoneburner.com/developer/route_list#contacts
			string sURL = "/rest/1/contacts?page_size=100";
			sURL += "&sort_order=ASC";
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			List<Contact> all = new List<Contact>(pag.items);
			while ( pag.page < pag.total_pages )
			{
				string sPagedURL = sURL + "&page=" + pag.page + 1;
				pag = this.restTemplate.GetForObject<ContactPagination>(sPagedURL);
				foreach ( Contact contact in pag.items )
				{
					all.Add(contact);
				}
			}
			return all;
		}

		public int GetCount()
		{
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.ContactTemplate.GetCount");
			// 08/16/2020 Paul.  The documentation says that 100 is the maximum. 
			// https://www.phoneburner.com/developer/route_list#contacts
			string sURL = "/rest/1/contacts?page_size=1";
			sURL += "&sort_order=ASC";
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			return pag.total_results;
		}

		public IList<Contact> GetPage(int nPage, int nPageSize)
		{
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.ContactTemplate.GetPage " + Sql.ToString(nPage));
			// 08/16/2020 Paul.  The documentation says that 100 is the maximum. 
			// https://www.phoneburner.com/developer/route_list#contacts
			string sURL = "/rest/1/contacts?page_size=" + Sql.ToString(nPageSize);
			sURL += "&sort_order=ASC";
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			List<Contact> all = new List<Contact>(pag.items);
			return all;
		}

		public Contact GetByEmail(string email)
		{
			string sURL = "/rest/1/contacts?page_size=1";
			sURL += "page=1";
			sURL += "email_address=" + email;
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			Contact contact = null;
			if ( pag.items.Count > 0 )
				contact = pag.items[0];
			return contact;
		}

		public Contact GetById(string id)
		{
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.ContactTemplate.GetById " + Sql.ToString(id));
			string sURL = "/rest/1/contacts/" + id;
			return this.restTemplate.GetForObject<Contact>(sURL);
		}

		public Contact Insert(Contact obj)
		{
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.ContactTemplate.Insert " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			string sURL = "/rest/1/contacts";
			return this.restTemplate.PostForObject<Contact>(sURL, obj);
		}

		public void Update(Contact obj)
		{
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.ContactTemplate.Update " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			if ( Sql.IsEmptyString(obj.id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/rest/1/contacts/" + obj.id;
			//this.restTemplate.PostForObject<Contact>(sURL, obj);
			// 08/16/2020 Paul.  PUT method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Contact), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Contact> responseExtractor = new MessageConverterResponseExtractor<Contact>(this.restTemplate.MessageConverters);
			this.restTemplate.Execute<Contact>(sURL, HttpMethod.PUT, requestCallback, responseExtractor);
		}

		public void Delete(string id)
		{
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.ContactTemplate.Delete " + Sql.ToString(id));
			string sURL = "/rest/1/contacts/" + id;
			this.restTemplate.Delete(sURL);
		}
	}
}