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

using Spring.Social.MailChimp.Api.Impl.Json;

namespace Spring.Social.MailChimp.Api.Impl
{
	public class MailChimpTemplate : AbstractOAuth2ApiBinding, IMailChimp 
	{
		private string               access_token       ;
		private string               data_center        ;
		private ITemplateOperations  templateOperations ;
		private IListOperations      listOperations     ;
		private ICampaignOperations  campaignOperations ;
		private IMemberOperations    memberOperations   ;
		private IAccountOperations   accountOperations  ;

		public MailChimpTemplate(string accessToken, string dataCenter)
			: base(accessToken)
		{
			this.access_token = accessToken;
			this.data_center  = dataCenter ;
			this.RestTemplate.BaseAddress = new Uri("https://" + data_center + ".api.mailchimp.com");
			this.InitSubApis();
		}

		#region IMailChimp Members
		public ITemplateOperations TemplateOperations
		{
			get { return this.templateOperations; }
		}

		public IListOperations ListOperations
		{
			get { return this.listOperations; }
		}

		public ICampaignOperations CampaignOperations
		{
			get { return this.campaignOperations; }
		}

		public IMemberOperations MemberOperations
		{
			get { return this.memberOperations; }
		}

		public IAccountOperations AccountOperations
		{
			get { return this.accountOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.ErrorHandler = new MailChimpErrorHandler();
		}

		protected override OAuth2Version GetOAuth2Version()
		{
			return OAuth2Version.Draft10;
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
			jsonMapper.RegisterDeserializer(typeof(Template          ), new TemplateDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(TemplatePagination), new TemplatePaginationDeserializer   ());
			jsonMapper.RegisterDeserializer(typeof(IList<Template>   ), new TemplateListDeserializer         ());

			jsonMapper.RegisterDeserializer(typeof(Spring.Social.MailChimp.Api.List       ), new ListDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(ListPagination                         ), new ListPaginationDeserializer   ());
			jsonMapper.RegisterDeserializer(typeof(IList<Spring.Social.MailChimp.Api.List>), new ListListDeserializer         ());

			jsonMapper.RegisterDeserializer(typeof(Campaign          ), new CampaignDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(CampaignPagination), new CampaignPaginationDeserializer   ());
			jsonMapper.RegisterDeserializer(typeof(IList<Campaign>   ), new CampaignListDeserializer         ());

			jsonMapper.RegisterDeserializer(typeof(Member            ), new MemberDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(MemberPagination  ), new MemberPaginationDeserializer     ());
			jsonMapper.RegisterDeserializer(typeof(IList<Member>     ), new MemberListDeserializer           ());
			// 02/16/2017 Paul.  Make sure that member does not exist. 
			jsonMapper.RegisterDeserializer(typeof(MemberSearch      ), new MemberSearchDeserializer         ());

			jsonMapper.RegisterDeserializer(typeof(Account           ), new AccountDeserializer              ());


			jsonMapper.RegisterSerializer  (typeof(Template          ), new TemplateSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(List              ), new ListSerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(Campaign          ), new CampaignSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(Member            ), new MemberSerializer                 ());

			// 05/29/2016 Paul.  Add merge fields. 
			jsonMapper.RegisterDeserializer(typeof(MergeField          ), new MergeFieldDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(IList<MergeField>   ), new MergeFieldListDeserializer      ());
			// 02/16/2017 Paul.  MergeFieldPagination. 
			jsonMapper.RegisterDeserializer(typeof(MergeFieldPagination), new MergeFieldPaginationDeserializer());
			jsonMapper.RegisterSerializer  (typeof(MergeField          ), new MergeFieldSerializer            ());

			// 05/30/2016 Paul.  Generic Array Deserializers. 
			jsonMapper.RegisterDeserializer(typeof(List<String>     ), new StringListDeserializer           ());
			jsonMapper.RegisterDeserializer(typeof(List<DateTime>   ), new DateTimeListDeserializer         ());
			jsonMapper.RegisterSerializer  (typeof(List<String>     ), new StringListSerializer             ());
			jsonMapper.RegisterSerializer  (typeof(List<DateTime>   ), new DateTimeListSerializer           ());
			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		class StringListDeserializer : IJsonDeserializer
		{
			public object Deserialize(JsonValue json, JsonMapper mapper)
			{
				List<String> items = null;
				if ( json != null && json.IsArray )
				{
					items = new List<String>();
					foreach ( JsonValue itemValue in json.GetValues() )
					{
						string item = itemValue.GetValue<String>();
						items.Add(item);
					}
				}
				return items;
			}
		}

		class StringListSerializer : IJsonSerializer
		{
			public JsonValue Serialize(object obj, JsonMapper mapper)
			{
				List<String> lst = obj as List<String>;
			
				JsonArray json = new JsonArray();
				foreach ( string sValue in lst )
				{
					json.AddValue(new JsonValue(sValue));
				}
				return json;
			}
		}

		class DateTimeListDeserializer : IJsonDeserializer
		{
			public object Deserialize(JsonValue json, JsonMapper mapper)
			{
				List<DateTime> items = null;
				if ( json != null && json.IsArray )
				{
					items = new List<DateTime>();
					foreach ( JsonValue itemValue in json.GetValues() )
					{
						DateTime? dt = itemValue.GetValue<DateTime?>();
						items.Add(dt.Value);
					}
				}
				return items;
			}
		}

		class DateTimeListSerializer : IJsonSerializer
		{
			public JsonValue Serialize(object obj, JsonMapper mapper)
			{
				List<DateTime> lst = obj as List<DateTime>;
			
				JsonArray json = new JsonArray();
				foreach ( DateTime dtValue in lst )
				{
					json.AddValue(new JsonValue(dtValue.ToString("yyyy-MM-ddTHH:mm:ssK")));
				}
				return json;
			}
		}

		private void InitSubApis()
		{
			this.templateOperations = new TemplateTemplate(this.RestTemplate);
			this.listOperations     = new ListTemplate    (this.RestTemplate);
			this.campaignOperations = new CampaignTemplate(this.RestTemplate);
			this.memberOperations   = new MemberTemplate  (this.RestTemplate);
			this.accountOperations  = new AccountTemplate (this.RestTemplate);
		}
	}
}