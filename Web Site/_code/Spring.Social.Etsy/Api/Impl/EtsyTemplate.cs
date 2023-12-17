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
using Spring.Http.Converters.Xml;
using Spring.Social.Etsy.Api.Impl.Json;

namespace Spring.Social.Etsy.Api.Impl
{
	public class EtsyTemplate : EtsyOAuth2ApiBinding, IEtsy 
	{
		// https://www.etsy.com/developers/documentation/getting_started/api_basics
		private static readonly Uri API_URI_BASE = new Uri("https://api.etsy.com/v3/application/");

		private string               shop_id            ;
		private string               api_key            ;

		public ICustomerOperations      customerOperations     ;
		public IOrderOperations         orderOperations        ;
		public IProductOperations       productOperations      ;

		public EtsyTemplate(string shop_id, string api_key, string accessToken) : base(api_key, accessToken)
		{
			this.shop_id = shop_id;
			this.api_key = api_key;
			this.RestTemplate.BaseAddress  = API_URI_BASE;
			this.InitSubApis();
		}

		#region IEtsy Members
		public ICustomerOperations      CustomerOperations      { get { return this.customerOperations     ; } }
		public IOrderOperations         OrderOperations         { get { return this.orderOperations        ; } }
		public IProductOperations       ProductOperations       { get { return this.productOperations      ; } }
		public IRestOperations          RestOperations          { get { return this.RestTemplate           ; } }
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.ErrorHandler = new EtsyErrorHandler();
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
			jsonMapper.RegisterDeserializer(typeof(QBase                         ), new QBaseDeserializer                         ());
			jsonMapper.RegisterDeserializer(typeof(Customer                      ), new CustomerDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(Product                       ), new ProductDeserializer                       ());
			jsonMapper.RegisterDeserializer(typeof(Order                         ), new OrderDeserializer                         ());
			
			jsonMapper.RegisterDeserializer(typeof(Image                         ), new ImageDeserializer                         ());
			jsonMapper.RegisterDeserializer(typeof(MailingAddress                ), new MailingAddressDeserializer                ());

			jsonMapper.RegisterDeserializer(typeof(LineItem                      ), new LineItemDeserializer                      ());
			jsonMapper.RegisterDeserializer(typeof(TxnTaxDetail                  ), new TxnTaxDetailDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(TaxLine                       ), new TaxLineDeserializer                       ());
			jsonMapper.RegisterDeserializer(typeof(MoneyV2                       ), new MoneyV2Deserializer                       ());
			
			jsonMapper.RegisterDeserializer(typeof(QBasePagination<QBase        >), new QBasePaginationDeserializer<QBase        >());
			jsonMapper.RegisterDeserializer(typeof(QBasePagination<Customer     >), new QBasePaginationDeserializer<Customer     >());
			jsonMapper.RegisterDeserializer(typeof(QBasePagination<Product      >), new QBasePaginationDeserializer<Product      >());
			jsonMapper.RegisterDeserializer(typeof(QBasePagination<Order        >), new QBasePaginationDeserializer<Order        >());
			jsonMapper.RegisterDeserializer(typeof(IList<QBase                  >), new QBaseListDeserializer      <QBase        >());
			jsonMapper.RegisterDeserializer(typeof(IList<Customer               >), new QBaseListDeserializer      <Customer     >());
			jsonMapper.RegisterDeserializer(typeof(IList<Product                >), new QBaseListDeserializer      <Product      >());
			jsonMapper.RegisterDeserializer(typeof(IList<Order                  >), new QBaseListDeserializer      <Order        >());

			jsonMapper.RegisterDeserializer(typeof(IList<Customer               >), new CustomerListDeserializer                  ());
			jsonMapper.RegisterDeserializer(typeof(IList<Product                >), new ProductListDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(IList<Order                  >), new OrderListDeserializer                     ());

			jsonMapper.RegisterDeserializer(typeof(IList<MailingAddress         >), new MailingAddressListDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(IList<TaxLine                >), new TaxLineListDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(IList<MoneyV2                >), new MoneyV2ListDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(IList<LineItem               >), new LineItemListDeserializer                  ());

			jsonMapper.RegisterSerializer  (typeof(Customer                      ), new CustomerSerializer                        ());
			jsonMapper.RegisterSerializer  (typeof(Product                       ), new ProductSerializer                         ());
			jsonMapper.RegisterSerializer  (typeof(Order                         ), new OrderSerializer                           ());

			jsonMapper.RegisterSerializer  (typeof(Image                         ), new ImageSerializer                           ());
			jsonMapper.RegisterSerializer  (typeof(MailingAddress                ), new MailingAddressSerializer                  ());

			jsonMapper.RegisterSerializer  (typeof(LineItem                      ), new LineItemSerializer                        ());
			jsonMapper.RegisterSerializer  (typeof(TxnTaxDetail                  ), new TxnTaxDetailSerializer                    ());
			jsonMapper.RegisterSerializer  (typeof(TaxLine                       ), new TaxLineSerializer                         ());
			jsonMapper.RegisterSerializer  (typeof(MoneyV2                       ), new MoneyV2Serializer                         ());

			jsonMapper.RegisterSerializer  (typeof(List<MailingAddress          >), new MailingAddressListSerializer              ());
			jsonMapper.RegisterSerializer  (typeof(List<TaxLine                 >), new TaxLineListSerializer                     ());
			jsonMapper.RegisterSerializer  (typeof(List<MoneyV2                 >), new MoneyV2ListSerializer                     ());
			jsonMapper.RegisterSerializer  (typeof(List<LineItem                >), new LineItemListSerializer                    ());

			jsonMapper.RegisterDeserializer(typeof(List<String                  >), new StringListDeserializer                    ());
			jsonMapper.RegisterSerializer  (typeof(List<String                  >), new StringListSerializer                      ());
			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		private void InitSubApis()
		{
			this.customerOperations      = new CustomerTemplate     (this.RestTemplate, shop_id);
			this.orderOperations         = new OrderTemplate        (this.RestTemplate, shop_id);
			this.productOperations       = new ProductTemplate      (this.RestTemplate, shop_id);
		}
	}
}
