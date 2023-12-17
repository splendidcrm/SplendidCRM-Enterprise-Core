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

using Spring.Social.ConstantContact.Api.Impl.Json;

namespace Spring.Social.ConstantContact.Api.Impl
{
	public class ConstantContactTemplate : AbstractOAuth2ApiBinding, IConstantContact 
	{
		// 11/11/2019 Paul.  Update to v3 api. 
		// https://v3.developer.constantcontact.com/api_guide/v3_technical_overview.html#resources
		private static readonly Uri API_URI_BASE = new Uri("https://api.cc.email");

		private string               api_key            ;
		private IContactOperations   contactOperations  ;
		private IListOperations      listOperations     ;

		public ConstantContactTemplate(string api_key, string accessToken)
			: base(accessToken)
		{
			this.api_key = api_key;
			this.InitSubApis();
		}

		#region IConstantContact Members
		public IContactOperations ContactOperations
		{
			get { return this.contactOperations; }
		}

		public IListOperations ListOperations
		{
			get { return this.listOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.BaseAddress = API_URI_BASE;
			restTemplate.ErrorHandler = new ConstantContactErrorHandler();
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
			jsonMapper.RegisterDeserializer(typeof(Contact            ), new ContactDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(ContactPagination  ), new ContactPaginationDeserializer());
			jsonMapper.RegisterDeserializer(typeof(Address            ), new AddressDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(EmailAddress       ), new EmailAddressDeserializer     ());
			jsonMapper.RegisterDeserializer(typeof(ListRef            ), new ListRefDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(Note               ), new NoteDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(List               ), new ListDeserializer             ());

			jsonMapper.RegisterDeserializer(typeof(IList<Contact>     ), new ContactListDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(IList<Address>     ), new AddressListDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(IList<EmailAddress>), new EmailAddressListDeserializer ());
			jsonMapper.RegisterDeserializer(typeof(IList<ListRef>     ), new ListRefListDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(IList<Note>        ), new NoteListDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(IList<List>        ), new ListListDeserializer         ());

			jsonMapper.RegisterSerializer  (typeof(Contact            ), new ContactSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(Address            ), new AddressSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(EmailAddress       ), new EmailAddressSerializer       ());
			jsonMapper.RegisterSerializer  (typeof(ListRef            ), new ListRefSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(Note               ), new NoteSerializer               ());
			// 08/15/2018 Paul.  Missing serializer for the list. 
			jsonMapper.RegisterSerializer  (typeof(List               ), new ListSerializer               ());

			jsonMapper.RegisterSerializer  (typeof(List<Address>      ), new AddressListSerializer        ());
			jsonMapper.RegisterSerializer  (typeof(List<EmailAddress> ), new EmailAddressListSerializer   ());
			jsonMapper.RegisterSerializer  (typeof(List<ListRef>      ), new ListRefListSerializer        ());
			jsonMapper.RegisterSerializer  (typeof(List<Note>         ), new NoteListSerializer           ());
			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		private void InitSubApis()
		{
			this.contactOperations = new ContactTemplate(this.api_key, this.RestTemplate);
			this.listOperations    = new ListTemplate   (this.api_key, this.RestTemplate);
		}
	}
}