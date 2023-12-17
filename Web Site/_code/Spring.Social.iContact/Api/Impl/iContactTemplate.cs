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

using Spring.Social.iContact.Api.Impl.Json;

namespace Spring.Social.iContact.Api.Impl
{
	public class iContactTemplate : AbstractOAuth2ApiBinding, IiContact 
	{
		private static readonly Uri API_URI_BASE = new Uri("https://app.icontact.com");

		private string             siContactAccountId     ;
		private string             siContactClientFolderId;
		private IAccountOperations accountOperations      ;
		private IContactOperations contactOperations      ;

		public iContactTemplate(string sApiAppId, string sApiUsername, string sApiPassword, string siContactAccountId, string siContactClientFolderId)
			: base()
		{
			this.siContactAccountId      = siContactAccountId     ;
			this.siContactClientFolderId = siContactClientFolderId;
			
			this.RestTemplate.RequestInterceptors.Add(new iContactRequestInterceptor("Api-Version" , "2.0"       ));
			this.RestTemplate.RequestInterceptors.Add(new iContactRequestInterceptor("Api-AppId"   , sApiAppId   ));
			this.RestTemplate.RequestInterceptors.Add(new iContactRequestInterceptor("Api-Username", sApiUsername));
			this.RestTemplate.RequestInterceptors.Add(new iContactRequestInterceptor("API-Password", sApiPassword));
			this.InitSubApis();
		}

		#region IiContact Members
		public IAccountOperations AccountOperations
		{
			get { return this.accountOperations; }
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
			restTemplate.BaseAddress = API_URI_BASE;
			restTemplate.ErrorHandler = new iContactErrorHandler();
		}

		protected override OAuth2Version GetOAuth2Version()
		{
			return OAuth2Version.Draft10;
		}

		protected override IList<IHttpMessageConverter> GetMessageConverters()
		{
			IList<IHttpMessageConverter> converters = base.GetMessageConverters();
			converters.Add(new ByteArrayHttpMessageConverter());
			converters.Add(new SpringJsonHttpMessageConverter(this.GetJsonMapper()));
			// 05/01/2015 Paul.  iContact is returning Content-Type: text/html; charset=utf-8 
			converters.Add(new iContactJsonHttpMessageConverter(this.GetJsonMapper()));
			return converters;
		}

		protected JsonMapper GetJsonMapper()
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(Contact            ), new ContactDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(ContactPagination  ), new ContactPaginationDeserializer());
			jsonMapper.RegisterDeserializer(typeof(IList<Contact>     ), new ContactListDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(Account            ), new AccountDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(IList<Account>     ), new AccountListDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(ClientFolder       ), new ClientFolderDeserializer     ());
			jsonMapper.RegisterDeserializer(typeof(IList<ClientFolder>), new ClientFolderListDeserializer ());

			jsonMapper.RegisterSerializer  (typeof(Contact            ), new ContactSerializer            ());
			return jsonMapper;
		}

		private void InitSubApis()
		{
			this.accountOperations = new AccountTemplate(this.RestTemplate);
			this.contactOperations = new ContactTemplate(siContactAccountId, siContactClientFolderId, this.RestTemplate);
		}
	}
}