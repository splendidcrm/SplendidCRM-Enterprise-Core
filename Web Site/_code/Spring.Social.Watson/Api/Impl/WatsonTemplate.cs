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
using System.Xml;
using System.Collections.Generic;

using Spring.Xml;
using Spring.Rest.Client;
using Spring.Social.OAuth2;
using Spring.Http.Converters;
using Spring.Http.Converters.Xml;

namespace Spring.Social.Watson.Api.Impl
{
	public class WatsonTemplate : AbstractOAuth2ApiBinding, IWatson 
	{
		private string                  access_token          ;
		private string                  region                ;
		private string                  pod_number            ;
		private IDatabaseOperations     databaseOperations    ;
		private IProspectListOperations prospectListOperations;
		private IContactOperations      contactOperations     ;

		// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
		// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
		public WatsonTemplate(string accessToken, string region, string podNumber)
			: base(accessToken)
		{
			this.access_token = accessToken;
			this.pod_number   = podNumber ;
			// https://www.ibm.com/support/knowledgecenter/en/SSWU4L/Integrations/imc_Integrations/ConfiguringtheEndpointintheSilverpopCustomSetting.html
			//this.RestTemplate.BaseAddress = new Uri("https://api" + pod_number + ".silverpop.com");
			// 10/02/2020 Paul.  New urls for Acoustic. 
			// https://help.goacoustic.com/hc/en-us/articles/360048880034-Standardized-Acoustic-URLs
			this.region       = region;
			this.RestTemplate.BaseAddress = new Uri("https://api-campaign-" + region + "-" + podNumber + ".goacoustic.com");
			this.InitSubApis();
		}

		#region IWatson Members
		public IDatabaseOperations DatabaseOperations
		{
			get { return this.databaseOperations; }
		}

		public IProspectListOperations ProspectListOperations
		{
			get { return this.prospectListOperations; }
		}

		public IContactOperations ContactOperations
		{
			get { return this.contactOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.ErrorHandler = new WatsonErrorHandler();
		}

		protected override OAuth2Version GetOAuth2Version()
		{
			return OAuth2Version.Bearer;
		}

		protected override IList<IHttpMessageConverter> GetMessageConverters()
		{
			IList<IHttpMessageConverter> converters = base.GetMessageConverters();
			converters.Add(new ByteArrayHttpMessageConverter());
			converters.Add(this.GetXmlMessageConverter());
			return converters;
		}

		protected virtual XmlElementHttpMessageConverter GetXmlMessageConverter()
		{
			XmlElementMapper xmlMapper = new XmlElementMapper();
			xmlMapper.RegisterDeserializer(typeof(Database           ), new DatabaseDeserializer          ());
			xmlMapper.RegisterDeserializer(typeof(IList<Database>    ), new DatabaseListDeserializer      ());

			xmlMapper.RegisterDeserializer(typeof(ProspectList       ), new ProspectListDeserializer      ());
			xmlMapper.RegisterDeserializer(typeof(ProspectListInsert ), new ProspectListInsertDeserializer());
			xmlMapper.RegisterDeserializer(typeof(IList<ProspectList>), new ProspectListListDeserializer  ());

			xmlMapper.RegisterDeserializer(typeof(Contact            ), new ContactDeserializer           ());
			xmlMapper.RegisterDeserializer(typeof(ContactInsert      ), new ContactInsertDeserializer     ());
			xmlMapper.RegisterDeserializer(typeof(IList<Contact>     ), new ContactListDeserializer       ());

			//xmlMapper.RegisterSerializer  (typeof(ProspectList       ), new ProspectListSerializer        ());
			//xmlMapper.RegisterSerializer  (typeof(Contact            ), new ContactSerializer             ());
			xmlMapper.RegisterSerializer  (typeof(XmlDocument        ), new XmlDocumentSerializer         ());
			return new XmlElementHttpMessageConverter(xmlMapper);
		}

		private void InitSubApis()
		{
			this.databaseOperations     = new DatabaseTemplate    (this.RestTemplate);
			this.prospectListOperations = new ProspectListTemplate(this.RestTemplate);
			this.contactOperations      = new ContactTemplate     (this.RestTemplate);
		}
	}
}