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
using System.Web;
using System.Net;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;

namespace Spring.Social.Office365.Api.Impl
{
	class SubscriptionTemplate : ISubscriptionOperations
	{
		protected RestTemplate restTemplate;

		public SubscriptionTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		public virtual IList<Subscription> GetAll()
		{
			// https://docs.microsoft.com/en-us/graph/api/resources/subscription?view=graph-rest-1.0
			string sURL = "/v1.0/subscriptions";
			SubscriptionPagination pag = this.restTemplate.GetForObject<SubscriptionPagination>(sURL);
			List<Subscription> all = new List<Subscription>(pag.subscriptions);
			return all;
		}

		public virtual Subscription GetById(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.SubscriptionTemplate.GetById " + Sql.ToString(id));
			string sURL = "/v1.0/subscriptions/" + id;
			return this.restTemplate.GetForObject<Subscription>(sURL);
		}
		
		public virtual Subscription Insert(Subscription obj)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.SubscriptionTemplate.Insert " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			string sURL = "/v1.0/subscriptions";
			return this.restTemplate.PostForObject<Subscription>(sURL, obj);
		}
		
		public virtual Subscription Update(Subscription obj)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.SubscriptionTemplate.Update " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			if ( Sql.IsEmptyString(obj.Id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/v1.0/subscriptions/" + obj.Id;
			//this.restTemplate.PostForObject<Subscription>(sURL, obj);
			// 12/05/2020 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Subscription), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Subscription> responseExtractor = new MessageConverterResponseExtractor<Subscription>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<Subscription>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}
		
		public virtual void Delete(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.SubscriptionTemplate.Delete " + Sql.ToString(id));
			string sURL = "/v1.0/subscriptions/" + id;
			this.restTemplate.Delete(sURL);
		}

		public virtual Subscription UpdateExpiration(string id, DateTimeOffset? expirationDateTime)
		{
			Subscription subscription = new Subscription();
			subscription.ExpirationDateTime = expirationDateTime;
			
			string sURL = "/v1.0/subscriptions/" + id;
			IList<Spring.Http.Converters.IHttpMessageConverter> requestConverter = new List<Spring.Http.Converters.IHttpMessageConverter>();
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterSerializer(typeof(Subscription), new Spring.Social.Office365.Api.Impl.Json.SubscriptionUpdateSerializer());
			requestConverter.Add(new Spring.Http.Converters.Json.SpringJsonHttpMessageConverter(jsonMapper));
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(subscription, typeof(Subscription), requestConverter);
			MessageConverterResponseExtractor<Subscription> responseExtractor = new MessageConverterResponseExtractor<Subscription>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<Subscription>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}
	}
}