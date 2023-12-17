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

namespace Spring.Social.ConstantContact.Api.Impl
{
	class ContactTemplate : IContactOperations
	{
		protected string       api_key     ;
		protected RestTemplate restTemplate;
		protected int          maxResults  ;
		protected string       moduleBase  ;

		public ContactTemplate(string api_key, RestTemplate restTemplate)
		{
			this.api_key      = api_key     ;
			this.restTemplate = restTemplate;
			this.maxResults   = 500         ;
#if DEBUG
			this.maxResults   = 5           ;
#endif
			// 11/11/2019 Paul.  Update to v3 api. 
			// https://v3.developer.constantcontact.com/api_guide/v3_technical_overview.html#resources
			this.moduleBase   = "/v3/contacts";
		}

		public virtual IList<Contact> GetModified(DateTime startModifiedDate)
		{
			// https://constantcontact.mashery.com/io-docs
			string sURL = moduleBase + "?api_key=" + api_key;
			// 04/27/2015 Paul.  A Sync-All request will have min date. 
			if ( startModifiedDate != DateTime.MinValue )
				sURL += "&modified_since=" + HttpUtils.UrlEncode(startModifiedDate.ToString("yyyy-MM-ddTHH:mm:ss"));
			sURL += "&status=all&limit=" + maxResults.ToString();
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			List<Contact> all = new List<Contact>();
			// 05/04/2015 Paul.  We are noticing that some records that are a few seconds off are being returned as modified.
			foreach ( Contact contact in pag.items )
			{
				if ( startModifiedDate == DateTime.MinValue || contact.modified_date > startModifiedDate )
					all.Add(contact);
			}
			while ( !Sql.IsEmptyString(pag.next_link) )
			{
				// 07/28/2016 Paul.  next_link includes full URL, so we just add the key. 
				string sPagedURL = pag.next_link + "&api_key=" + api_key;
				pag = this.restTemplate.GetForObject<ContactPagination>(sPagedURL);
				foreach ( Contact contact in pag.items )
				{
					if ( startModifiedDate == DateTime.MinValue || contact.modified_date > startModifiedDate )
						all.Insert(0, contact);
				}
			}
			return all;
		}

		public virtual IList<Contact> GetAll(string search)
		{
			string sURL = moduleBase + "?api_key=" + api_key;
			if ( !String.IsNullOrEmpty(search) )
			{
				sURL += "&email=" + HttpUtils.UrlEncode(search);
			}
			// 05/04/2015 Paul.  The documentation says that 500 is the maximum. 
			sURL += "&status=ALL&limit=" + maxResults.ToString();
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			List<Contact> all = new List<Contact>(pag.items);
			// http://developer.constantcontact.com/docs/developer-guides/paginated-output.html
			while ( !Sql.IsEmptyString(pag.next_link) )
			{
				// 07/28/2016 Paul.  next_link includes full URL, so we just add the key. 
				string sPagedURL = pag.next_link + "&api_key=" + api_key;
				pag = this.restTemplate.GetForObject<ContactPagination>(sPagedURL);
				foreach ( Contact contact in pag.items )
				{
					all.Add(contact);
				}
			}
			return all;
		}

		public Contact GetByEmail(string email)
		{
			string sURL = moduleBase + "?api_key=" + api_key;
			sURL += "&email=" + HttpUtils.UrlEncode(email);
			return this.restTemplate.GetForObject<Contact>(sURL);
		}

		public Contact GetById(string id)
		{
			string sURL = moduleBase + "/" + id + "?api_key=" + api_key;
			return this.restTemplate.GetForObject<Contact>(sURL);
		}

		public Contact Insert(Contact obj)
		{
			string sURL = moduleBase + "?api_key=" + api_key;
			return this.restTemplate.PostForObject<Contact>(sURL, obj);
		}

		public Contact Update(Contact obj)
		{
			if ( obj.id == null )
				throw(new Exception("id must not be null during update operation."));
			string sURL = moduleBase + "/" + obj.id + "?api_key=" + api_key;
			//this.restTemplate.PostForObject<Contact>(sURL, obj);
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Contact), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Contact> responseExtractor = new MessageConverterResponseExtractor<Contact>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<Contact>(sURL, HttpMethod.PUT, requestCallback, responseExtractor);
		}

		public void Delete(string id)
		{
			string sURL = moduleBase + "/" + id + "?api_key=" + api_key;
			this.restTemplate.Delete(sURL);
		}
	}
}