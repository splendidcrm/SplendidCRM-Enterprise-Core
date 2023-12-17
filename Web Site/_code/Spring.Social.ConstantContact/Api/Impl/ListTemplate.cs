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
	class ListTemplate : IListOperations
	{
		protected string       api_key     ;
		protected RestTemplate restTemplate;
		protected int          maxResults  ;
		protected string       moduleBase  ;

		public ListTemplate(string api_key, RestTemplate restTemplate)
		{
			this.api_key      = api_key     ;
			this.restTemplate = restTemplate;
			this.maxResults   = 500         ;
			// 11/11/2019 Paul.  Update to v3 api. 
			// https://v3.developer.constantcontact.com/api_guide/v3_technical_overview.html#resources
			this.moduleBase   = "/v3/lists" ;
		}

		public virtual IList<List> GetModified(DateTime startModifiedDate)
		{
			// https://constantcontact.mashery.com/io-docs
			string sURL = moduleBase + "?api_key=" + api_key;
			// 04/27/2015 Paul.  A Sync-All request will have min date. 
			if ( startModifiedDate != DateTime.MinValue )
				sURL += "&modified_since=" + HttpUtils.UrlEncode(startModifiedDate.ToString("yyyy-MM-ddTHH:mm:ss"));
			IList<List> all = this.restTemplate.GetForObject<IList<List>>(sURL);
			return all;
		}

		public virtual IList<List> GetAll()
		{
			string sURL = moduleBase + "?api_key=" + api_key;
			IList<List> all = this.restTemplate.GetForObject<IList<List>>(sURL);
			return all;
		}

		public List GetById(string id)
		{
			string sURL = moduleBase + "/" + id + "?api_key=" + api_key;
			return this.restTemplate.GetForObject<List>(sURL);
		}

		public List Insert(List obj)
		{
			string sURL = moduleBase + "?api_key=" + api_key;
			return this.restTemplate.PostForObject<List>(sURL, obj);
		}

		public List Update(List obj)
		{
			if ( obj.id == null )
				throw(new Exception("id must not be null during update operation."));
			string sURL = moduleBase + "/" + obj.id + "?api_key=" + api_key;
			//this.restTemplate.PostForObject<List>(sURL, obj);
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(List), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<List> responseExtractor = new MessageConverterResponseExtractor<List>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<List>(sURL, HttpMethod.PUT, requestCallback, responseExtractor);
		}

		public void Delete(string id)
		{
			string sURL = moduleBase + "/" + id + "?api_key=" + api_key;
			this.restTemplate.Delete(sURL);
		}
	}
}