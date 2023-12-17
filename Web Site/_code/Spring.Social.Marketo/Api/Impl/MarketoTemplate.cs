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

using Spring.Social.Marketo.Api.Impl.Json;

namespace Spring.Social.Marketo.Api.Impl
{
	public class MarketoTemplate : AbstractOAuth2ApiBinding, IMarketo 
	{
		private ILeadOperations      leadOperations     ;

		public MarketoTemplate(string endpointUrl, string accessToken)
			: base(accessToken)
		{
			if ( !endpointUrl.EndsWith("/") )
				endpointUrl += "/";
			this.RestTemplate.BaseAddress = new Uri(endpointUrl);
			this.InitSubApis();
		}

		#region IMarketo Members
		public ILeadOperations LeadOperations
		{
			get { return this.leadOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.ErrorHandler = new MarketoErrorHandler();
		}

		protected override OAuth2Version GetOAuth2Version()
		{
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
			jsonMapper.RegisterDeserializer(typeof(IList<Lead>      ), new LeadListDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(LeadPagination   ), new LeadPaginationDeserializer   ());

			jsonMapper.RegisterDeserializer(typeof(LeadField        ), new LeadFieldDeserializer        ());
			jsonMapper.RegisterDeserializer(typeof(IList<LeadField> ), new LeadFieldListDeserializer    ());

			jsonMapper.RegisterSerializer  (typeof(Lead             ), new LeadSerializer               ());
			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		private void InitSubApis()
		{
			this.leadOperations    = new LeadTemplate   (this.RestTemplate);
		}
	}
}