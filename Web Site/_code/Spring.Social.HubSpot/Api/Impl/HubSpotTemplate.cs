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

using Spring.Social.HubSpot.Api.Impl.Json;

namespace Spring.Social.HubSpot.Api.Impl
{
	public class HubSpotTemplate : AbstractOAuth2ApiBinding, IHubSpot 
	{
		private static readonly Uri API_URI_BASE = new Uri("https://api.hubapi.com/");

		private string               access_token       ;
		private ILeadOperations      leadOperations     ;
		private IContactOperations   contactOperations  ;
		private ICompanyOperations   companyOperations  ;

		public HubSpotTemplate(string accessToken)
			: base(accessToken)
		{
			this.access_token = accessToken;
			this.InitSubApis();
		}

		#region IHubSpot Members
		public ILeadOperations LeadOperations
		{
			get { return this.leadOperations; }
		}

		public IContactOperations ContactOperations
		{
			get { return this.contactOperations; }
		}

		public ICompanyOperations CompanyOperations
		{
			get { return this.companyOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.BaseAddress = API_URI_BASE;
			restTemplate.ErrorHandler = new HubSpotErrorHandler();
		}

		protected override OAuth2Version GetOAuth2Version()
		{
			// 09/26/2020 Paul.  Latest version use bearer tokens. 
			// https://legacydocs.hubspot.com/docs/methods/oauth2/oauth2-quickstart#step1directtohubspotsoauth20server
			return OAuth2Version.Bearer;
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
			jsonMapper.RegisterDeserializer(typeof(Lead             ), new LeadDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(LeadPagination   ), new LeadPaginationDeserializer   ());
			jsonMapper.RegisterDeserializer(typeof(IList<Lead>      ), new LeadListDeserializer         ());

			jsonMapper.RegisterDeserializer(typeof(Contact          ), new ContactDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(ContactPagination), new ContactPaginationDeserializer());
			jsonMapper.RegisterDeserializer(typeof(IList<Contact>   ), new ContactListDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(Company          ), new CompanyDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(CompanyPagination), new CompanyPaginationDeserializer());
			jsonMapper.RegisterDeserializer(typeof(IList<Company>   ), new CompanyListDeserializer      ());

			jsonMapper.RegisterSerializer  (typeof(Lead             ), new LeadSerializer               ());
			jsonMapper.RegisterSerializer  (typeof(Contact          ), new ContactSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(Company          ), new CompanySerializer            ());
			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		private void InitSubApis()
		{
			// 09/26/2020 Paul.  Latest version use bearer tokens. 
			this.leadOperations    = new LeadTemplate   (this.RestTemplate);
			this.contactOperations = new ContactTemplate(this.RestTemplate);
			this.companyOperations = new CompanyTemplate(this.RestTemplate);
		}
	}
}