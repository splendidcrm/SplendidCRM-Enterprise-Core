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

using Spring.Social.PhoneBurner.Api.Impl.Json;

namespace Spring.Social.PhoneBurner.Api.Impl
{
	public class PhoneBurnerTemplate : AbstractOAuth2ApiBinding, IPhoneBurner 
	{
		private static readonly Uri API_URI_BASE = new Uri("https://www.phoneburner.com/");

		private string               access_token       ;
		private IContactOperations   contactOperations  ;
		private IDialOperations      dialOperations     ;

		public PhoneBurnerTemplate(string accessToken)
			: base(accessToken)
		{
			this.access_token = accessToken;
			this.InitSubApis();
		}

		#region IPhoneBurner Members
		public IContactOperations ContactOperations
		{
			get { return this.contactOperations; }
		}

		public IDialOperations DialOperations
		{
			get { return this.dialOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.BaseAddress = API_URI_BASE;
			restTemplate.ErrorHandler = new PhoneBurnerErrorHandler();
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
			JsonMapper jsonMapper = JsonMessageConverter();
			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		public static JsonMapper JsonMessageConverter()
		{
			JsonMapper jsonMapper = new JsonMapper();
			
			jsonMapper.RegisterDeserializer(typeof(IList<String>           ), new StringListDeserializer           ());
			jsonMapper.RegisterDeserializer(typeof(Contact                 ), new ContactDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(ContactPagination       ), new ContactPaginationDeserializer    ());
			jsonMapper.RegisterDeserializer(typeof(IList<Contact>          ), new ContactListDeserializer          ());

			jsonMapper.RegisterDeserializer(typeof(AdditionalName          ), new AdditionalNameDeserializer       ());
			jsonMapper.RegisterDeserializer(typeof(IList<AdditionalName>   ), new AdditionalNameListDeserializer   ());
			jsonMapper.RegisterDeserializer(typeof(AdditionalPhone         ), new AdditionalPhoneDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(IList<AdditionalPhone>  ), new AdditionalPhoneListDeserializer  ());
			jsonMapper.RegisterDeserializer(typeof(QuestionAndAnswer       ), new QuestionAndAnswerDeserializer    ());
			jsonMapper.RegisterDeserializer(typeof(IList<QuestionAndAnswer>), new QuestionAndAnswerListDeserializer());
			jsonMapper.RegisterDeserializer(typeof(CustomField             ), new CustomFieldDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(IList<CustomField>      ), new CustomFieldListDeserializer      ());
			jsonMapper.RegisterDeserializer(typeof(SocialAccount           ), new SocialAccountDeserializer        ());
			jsonMapper.RegisterDeserializer(typeof(IList<SocialAccount>    ), new SocialAccountListDeserializer    ());
			jsonMapper.RegisterDeserializer(typeof(Phone                   ), new PhoneDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(IList<Phone>            ), new PhoneListDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(Email                   ), new EmailDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(IList<Email>            ), new EmailListDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(Address                 ), new AddressDeserializer              ());
			jsonMapper.RegisterDeserializer(typeof(IList<Address>          ), new AddressListDeserializer          ());
			jsonMapper.RegisterDeserializer(typeof(PrimaryEmail            ), new PrimaryEmailDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(PrimaryPhone            ), new PrimaryPhoneDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(PrimaryAddress          ), new PrimaryAddressDeserializer       ());
			jsonMapper.RegisterDeserializer(typeof(Category                ), new CategoryDeserializer             ());
			jsonMapper.RegisterDeserializer(typeof(Note                    ), new NoteDeserializer                 ());
			jsonMapper.RegisterDeserializer(typeof(ContactStats            ), new ContactStatsDeserializer         ());
			jsonMapper.RegisterDeserializer(typeof(DialSessionResult       ), new DialSessionResultDeserializer    ());
			jsonMapper.RegisterDeserializer(typeof(CustomData              ), new CustomDataDeserializer           ());
			jsonMapper.RegisterDeserializer(typeof(CallBegin               ), new CallBeginDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(CallDone                ), new CallDoneDeserializer             ());

			jsonMapper.RegisterSerializer  (typeof(Contact                 ), new ContactSerializer                ());
			jsonMapper.RegisterSerializer  (typeof(List<Contact>           ), new ContactListSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(AdditionalName          ), new AdditionalNameSerializer         ());
			jsonMapper.RegisterSerializer  (typeof(List<AdditionalName>    ), new AdditionalNameListSerializer     ());
			jsonMapper.RegisterSerializer  (typeof(AdditionalPhone         ), new AdditionalPhoneSerializer        ());
			jsonMapper.RegisterSerializer  (typeof(List<AdditionalPhone>   ), new AdditionalPhoneListSerializer    ());
			jsonMapper.RegisterSerializer  (typeof(QuestionAndAnswer       ), new QuestionAndAnswerSerializer      ());
			jsonMapper.RegisterSerializer  (typeof(List<QuestionAndAnswer> ), new QuestionAndAnswerListSerializer  ());
			jsonMapper.RegisterSerializer  (typeof(CustomField             ), new CustomFieldSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(List<CustomField>       ), new CustomFieldListSerializer        ());
			jsonMapper.RegisterSerializer  (typeof(SocialAccount           ), new SocialAccountSerializer          ());
			jsonMapper.RegisterSerializer  (typeof(List<SocialAccount>     ), new SocialAccountListSerializer      ());
			jsonMapper.RegisterSerializer  (typeof(DialSession             ), new DialSessionSerializer            ());
			jsonMapper.RegisterSerializer  (typeof(CustomData              ), new CustomDataSerializer             ());

			return jsonMapper;
		}

		private void InitSubApis()
		{
			this.contactOperations = new ContactTemplate    (this.access_token, this.RestTemplate);
			this.dialOperations    = new DialSessionTemplate(this.access_token, this.RestTemplate);
		}
	}
}