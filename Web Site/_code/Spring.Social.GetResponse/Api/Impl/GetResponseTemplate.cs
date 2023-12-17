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

using Spring.Json;
using Spring.Rest.Client;
using Spring.Social.OAuth2;
using Spring.Http.Converters;
using Spring.Http.Converters.Json;

using Spring.Social.GetResponse.Api.Impl.Json;

namespace Spring.Social.GetResponse.Api.Impl
{
	public class GetResponseTemplate : GetResponseOAuth2ApiBinding, IGetResponse 
	{
		private static readonly Uri API_URI_BASE = new Uri("https://api.getresponse.com/v3/");

		private IContactOperations   contactOperations  ;
		private ICampaignOperations  campaignOperations ;

		public GetResponseTemplate(string apiKey)
			: base(apiKey)
		{
			this.InitSubApis();
		}

		#region IGetResponse Members
		public IContactOperations ContactOperations
		{
			get { return this.contactOperations; }
		}

		public ICampaignOperations CampaignOperations
		{
			get { return this.campaignOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.BaseAddress = API_URI_BASE;
			restTemplate.ErrorHandler = new GetResponseErrorHandler();
		}

		protected override IList<IHttpMessageConverter> GetMessageConverters()
		{
			IList<IHttpMessageConverter> converters = base.GetMessageConverters();
			converters.Add(new ByteArrayHttpMessageConverter());
			converters.Add(this.GetJsonMessageConverter());
			return converters;
		}

		protected virtual SpringJsonHttpMessageConverter GetJsonMessageConverter()
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(Contact            ), new ContactDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(Campaign           ), new CampaignDeserializer         ());

			jsonMapper.RegisterDeserializer(typeof(IList<Contact>     ), new ContactListDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(IList<Campaign>    ), new CampaignListDeserializer     ());

			jsonMapper.RegisterSerializer  (typeof(Contact            ), new ContactSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(Campaign           ), new CampaignSerializer           ());

			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		private void InitSubApis()
		{
			this.contactOperations  = new ContactTemplate (this.RestTemplate);
			this.campaignOperations = new CampaignTemplate(this.RestTemplate);
		}
	}
}