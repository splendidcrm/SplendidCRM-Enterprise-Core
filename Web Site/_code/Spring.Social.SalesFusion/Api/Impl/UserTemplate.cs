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
	class UserTemplate : IUserOperations
	{
		protected RestTemplate restTemplate;
		const string sEndpoint = "/api/users/";

		public UserTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		public virtual IList<User> GetAll()
		{
			string sURL = sEndpoint;
			UserPagination pag = this.restTemplate.GetForObject<UserPagination>(sURL);
			List<User> all = new List<User>(pag.results);
			int nPage = 2;
			while ( !Sql.IsEmptyString(pag.next) )
			{
				string sPagedURL = sURL + (sURL.Contains("?") ? "&" : "?") + "page=" + nPage.ToString();
				pag = this.restTemplate.GetForObject<UserPagination>(sPagedURL);
				foreach ( User item in pag.results )
				{
					all.Add(item);
				}
				nPage++;
			}
			return all;
		}

		public virtual int GetCount()
		{
			string sURL = sEndpoint + "?page=1";
			HPagination pag = this.restTemplate.GetForObject<HPagination>(sURL);
			return pag.total_count;
		}

		public virtual IList<User> GetPage(int page)
		{
			string sURL = sEndpoint + "?page=" + page.ToString();
			UserPagination pag = this.restTemplate.GetForObject<UserPagination>(sURL);
			List<User> all = new List<User>(pag.results);
			return all;
		}

		public User GetById(int id)
		{
			string sURL = sEndpoint + id.ToString() + "/";
			User user = this.restTemplate.GetForObject<User>(sURL);
			if ( user != null )
				user.id = id;
			return user;
		}

		public User GetByName(string name)
		{
			string sURL = sEndpoint + "?user_name=" + HttpUtils.UrlEncode(name);
			return this.restTemplate.GetForObject<User>(sURL);
		}

		public User Insert(User obj)
		{
			string sURL = sEndpoint;
			return this.restTemplate.PostForObject<User>(sURL, obj);
		}

		public void Update(User obj)
		{
			if ( !obj.id.HasValue )
				throw(new Exception("id must not be null during update operation."));
			string sURL = sEndpoint + obj.id.Value.ToString();
			//this.restTemplate.PostForObject<User>(sURL, obj);
			// 04/28/2015 Paul.  PUT method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(User), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<User> responseExtractor = new MessageConverterResponseExtractor<User>(this.restTemplate.MessageConverters);
			this.restTemplate.Execute<User>(sURL, HttpMethod.PUT, requestCallback, responseExtractor);
		}

		public void Delete(int id)
		{
			string sURL = sEndpoint + id.ToString() + "/";
			this.restTemplate.Delete(sURL);
		}
	}
}