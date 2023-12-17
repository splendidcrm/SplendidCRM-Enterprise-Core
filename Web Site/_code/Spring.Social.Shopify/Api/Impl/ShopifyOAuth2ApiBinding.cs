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

using Spring.Rest.Client;
using Spring.Http.Client;
using Spring.Http.Converters;

namespace Spring.Social.Shopify.Api.Impl
{
	public abstract class ShopifyOAuth2ApiBinding : IApiBinding
	{
		private string       accessToken ;
		private RestTemplate restTemplate;

		public RestTemplate RestTemplate
		{
			get { return this.restTemplate; }
		}

		protected ShopifyOAuth2ApiBinding(string accessToken)
		{
			this.accessToken  = accessToken;
			this.restTemplate = new RestTemplate();
			((WebClientHttpRequestFactory)restTemplate.RequestFactory).Expect100Continue = false;
			this.RestTemplate.RequestInterceptors.Add(new ShopifyRequestInterceptor("X-Shopify-Access-Token", accessToken));
			this.restTemplate.MessageConverters = this.GetMessageConverters();
			this.ConfigureRestTemplate(this.restTemplate);
		}

		#region IApiBinding Members

		public bool IsAuthorized
		{
			get { return this.accessToken != null; }
		}

		#endregion

		protected virtual IList<IHttpMessageConverter> GetMessageConverters()
		{
			IList<IHttpMessageConverter> messageConverters = new List<IHttpMessageConverter>();
			messageConverters.Add(new StringHttpMessageConverter());
			return messageConverters;
		}

		protected virtual void ConfigureRestTemplate(RestTemplate restTemplate)
		{
		}
	}
}
