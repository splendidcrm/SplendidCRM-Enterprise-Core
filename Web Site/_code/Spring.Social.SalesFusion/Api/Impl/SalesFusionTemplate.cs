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

using Spring.Social.SalesFusion.Api.Impl.Json;

namespace Spring.Social.SalesFusion.Api.Impl
{
	public class SalesFusionTemplate : ISalesFusion 
	{
		private static readonly Uri API_URI_BASE = new Uri("https://pub.salesfusion360.com/");

		public RestTemplate                 RestTemplate         ;
		private string                      username             ;
		private string                      domain               ;
		private string                      password             ;
		private IAccountOperations          accountOperations    ;
		private IContactOperations          contactOperations    ;
		private ILeadOperations             leadOperations       ;
		private IOpportunityOperations      opportunityOperations;
		private IDistributionListOperations listOperations       ;
		private IUserOperations             userOperations       ;

		public SalesFusionTemplate(string username, string domain, string password)
		{
			this.username = username;
			this.domain   = domain  ;
			this.password = password;
			this.RestTemplate = new RestTemplate();
			ConfigureRestTemplate(this.RestTemplate);
			this.InitSubApis();
		}

		#region ISalesFusion Members
		public IAccountOperations AccountOperations
		{
			get { return this.accountOperations; }
		}

		public IContactOperations ContactOperations
		{
			get { return this.contactOperations; }
		}

		public ILeadOperations LeadOperations
		{
			get { return this.leadOperations; }
		}

		public IOpportunityOperations OpportunityOperations
		{
			get { return this.opportunityOperations; }
		}

		public IDistributionListOperations ListOperations
		{
			get { return this.listOperations; }
		}

		public IUserOperations UserOperations
		{
			get { return this.userOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}

		public bool IsAuthorized
		{
			get { return true; }
		}
		#endregion

		protected void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.BaseAddress = API_URI_BASE;
			restTemplate.ErrorHandler = new SalesFusionErrorHandler();
			restTemplate.RequestInterceptors.Add(new Spring.Http.Client.Interceptor.BasicSigningRequestInterceptor(this.username + "@" + this.domain, this.password));
			restTemplate.MessageConverters = this.GetMessageConverters();
		}

		protected IList<IHttpMessageConverter> GetMessageConverters()
		{
			IList<IHttpMessageConverter> converters = new List<IHttpMessageConverter>();
			converters.Add(new StringHttpMessageConverter   ());
			converters.Add(new FormHttpMessageConverter     ());
			converters.Add(new ByteArrayHttpMessageConverter());
			converters.Add(this.GetJsonMessageConverter());
			return converters;
		}

		protected virtual SpringJsonHttpMessageConverter GetJsonMessageConverter()
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(HPagination               ), new HPaginationDeserializer               ());

			jsonMapper.RegisterDeserializer(typeof(Account                   ), new AccountDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(AccountPagination         ), new AccountPaginationDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(IList<Account>            ), new AccountListDeserializer               ());

			jsonMapper.RegisterDeserializer(typeof(Contact                   ), new ContactDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(ContactPagination         ), new ContactPaginationDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(IList<Contact>            ), new ContactListDeserializer               ());

			jsonMapper.RegisterDeserializer(typeof(Lead                      ), new LeadDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(LeadPagination            ), new LeadPaginationDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(IList<Lead>               ), new LeadListDeserializer                  ());

			jsonMapper.RegisterDeserializer(typeof(Opportunity               ), new OpportunityDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(OpportunityPagination     ), new OpportunityPaginationDeserializer     ());
			jsonMapper.RegisterDeserializer(typeof(IList<Opportunity>        ), new OpportunityListDeserializer           ());

			jsonMapper.RegisterDeserializer(typeof(DistributionList          ), new DistributionListDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(DistributionListPagination), new DistributionListPaginationDeserializer());
			jsonMapper.RegisterDeserializer(typeof(IList<DistributionList>   ), new DistributionListListDeserializer      ());

			jsonMapper.RegisterDeserializer(typeof(User                      ), new UserDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(UserPagination            ), new UserPaginationDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(IList<User>               ), new UserListDeserializer                  ());

			jsonMapper.RegisterSerializer  (typeof(Account                   ), new AccountSerializer                     ());
			jsonMapper.RegisterSerializer  (typeof(Contact                   ), new ContactSerializer                     ());
			jsonMapper.RegisterSerializer  (typeof(Lead                      ), new LeadSerializer                        ());
			jsonMapper.RegisterSerializer  (typeof(Opportunity               ), new OpportunitySerializer                 ());
			jsonMapper.RegisterSerializer  (typeof(DistributionList          ), new DistributionListSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(User                      ), new UserSerializer                        ());
			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		private void InitSubApis()
		{
			this.accountOperations     = new AccountTemplate         (this.RestTemplate);
			this.contactOperations     = new ContactTemplate         (this.RestTemplate);
			this.leadOperations        = new LeadTemplate            (this.RestTemplate);
			this.opportunityOperations = new OpportunityTemplate     (this.RestTemplate);
			this.listOperations        = new DistributionListTemplate(this.RestTemplate);
			this.userOperations        = new UserTemplate            (this.RestTemplate);
		}
	}
}
