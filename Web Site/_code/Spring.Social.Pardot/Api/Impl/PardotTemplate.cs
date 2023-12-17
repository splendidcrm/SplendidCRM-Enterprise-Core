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

using Spring.Social.Pardot.Api.Impl.Json;

namespace Spring.Social.Pardot.Api.Impl
{
	public class PardotTemplate : AbstractOAuth2ApiBinding, IPardot 
	{
		private static readonly Uri API_URI_BASE = new Uri("https://pi.pardot.com");

		private string ApiUserKey ;
		private string ApiKey     ;
		private IProspectOperations        prospectOperations       ;
		private IProspectAccountOperations prospectAccountOperations;
		private ICampaignOperations        campaignOperations       ;
		private IOpportunityOperations     opportunityOperations    ;
		private IVisitorOperations         visitorOperations        ;

		public PardotTemplate(string sApiUserKey, string sApiKey) : base()
		{
			this.ApiUserKey = sApiUserKey;
			this.ApiKey     = sApiKey    ;
			this.InitSubApis();
		}

		#region IPardot Members
		public IProspectOperations ProspectOperations
		{
			get { return this.prospectOperations; }
		}

		public IProspectAccountOperations ProspectAccountOperations
		{
			get { return this.prospectAccountOperations; }
		}

		public ICampaignOperations CampaignOperations
		{
			get { return this.campaignOperations; }
		}

		public IOpportunityOperations OpportunityOperations
		{
			get { return this.opportunityOperations; }
		}

		public IVisitorOperations VisitorOperations
		{
			get { return this.visitorOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.BaseAddress = API_URI_BASE;
			// 07/16/2017 Paul. Errors are returned in Json. 
			//restTemplate.ErrorHandler = new PardotErrorHandler();
		}

		protected override OAuth2Version GetOAuth2Version()
		{
			return OAuth2Version.Draft10;
		}

		protected override IList<IHttpMessageConverter> GetMessageConverters()
		{
			IList<IHttpMessageConverter> converters = base.GetMessageConverters();
			converters.Add(new ByteArrayHttpMessageConverter());
			//converters.Add(new SpringJsonHttpMessageConverter(this.GetJsonMapper()));
			// 07/16/2017 Paul.  For some unknown reason, data posted is in x-www-form-urlencoded format instead of json. 
			converters.Add(new PardotJsonHttpMessageConverter(this.GetJsonMapper()));
			return converters;
		}

		protected JsonMapper GetJsonMapper()
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(Prospect                 ), new ProspectDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(ProspectPagination       ), new ProspectPaginationDeserializer       ());
			jsonMapper.RegisterDeserializer(typeof(IList<Prospect>          ), new ProspectListDeserializer             ());

			jsonMapper.RegisterDeserializer(typeof(VisitorActivity          ), new VisitorActivityDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(IList<VisitorActivity>   ), new VisitorActivityListDeserializer      ());

			jsonMapper.RegisterDeserializer(typeof(ProspectAccount          ), new ProspectAccountDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(ProspectAccountPagination), new ProspectAccountPaginationDeserializer());
			jsonMapper.RegisterDeserializer(typeof(IList<ProspectAccount>   ), new ProspectAccountListDeserializer      ());

			jsonMapper.RegisterDeserializer(typeof(Campaign                 ), new CampaignDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(CampaignPagination       ), new CampaignPaginationDeserializer       ());
			jsonMapper.RegisterDeserializer(typeof(IList<Campaign>          ), new CampaignListDeserializer             ());

			jsonMapper.RegisterDeserializer(typeof(Opportunity              ), new OpportunityDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(OpportunityPagination    ), new OpportunityPaginationDeserializer    ());
			jsonMapper.RegisterDeserializer(typeof(IList<Opportunity>       ), new OpportunityListDeserializer          ());

			jsonMapper.RegisterDeserializer(typeof(Visitor                  ), new VisitorDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(VisitorPagination        ), new VisitorPaginationDeserializer        ());
			jsonMapper.RegisterDeserializer(typeof(IList<Visitor>           ), new VisitorListDeserializer              ());

			jsonMapper.RegisterSerializer  (typeof(Prospect                 ), new ProspectSerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(ProspectAccount          ), new ProspectAccountSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(Campaign                 ), new CampaignSerializer                   ());
			jsonMapper.RegisterSerializer  (typeof(Opportunity              ), new OpportunitySerializer                ());
			return jsonMapper;
		}

		private void InitSubApis()
		{
			this.prospectOperations        = new ProspectTemplate       (this.RestTemplate, this.ApiUserKey, this.ApiKey);
			this.prospectAccountOperations = new ProspectAccountTemplate(this.RestTemplate, this.ApiUserKey, this.ApiKey);
			this.campaignOperations        = new CampaignTemplate       (this.RestTemplate, this.ApiUserKey, this.ApiKey);
			this.opportunityOperations     = new OpportunityTemplate    (this.RestTemplate, this.ApiUserKey, this.ApiKey);
			this.visitorOperations         = new VisitorTemplate        (this.RestTemplate, this.ApiUserKey, this.ApiKey);
		}
	}
}