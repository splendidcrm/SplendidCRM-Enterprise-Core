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
using System.Globalization;
using System.Collections.Generic;
using Spring.Json;

namespace Spring.Social.Shopify.Api.Impl.Json
{
	class OrderDeserializer : IJsonDeserializer
	{
		private static MoneyV2 DeserializeMoneyBag(JsonValue json)
		{
			MoneyV2 money = null;
			if ( json != null )
			{
				if ( json.ContainsName("shopMoney") )
				{
					JsonValue shopMoney = json.GetValue("shopMoney");
					if ( shopMoney != null )
					{
						money = new MoneyV2();
						money.amount       = shopMoney.GetValueOrDefault<Decimal>("amount"      );
						money.currencyCode = shopMoney.GetValueOrDefault<string >("currencyCode");
					}
				}
			}
			return money;
		}

		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Order obj = new Order();
			obj.RawContent = json.ToString();
			
			// 03/17/2022 Paul.  cursor is outside of node. 
			obj.cursor           = json.GetValueOrDefault<string   >("cursor"         );
			if ( json.ContainsName("node") )
			{
				json = json.GetValue("node");
			}
			obj.id                               = json.GetValueOrDefault<String   >("id"                              );
			obj.createdAt                        = json.GetValueOrDefault<DateTime >("createdAt"                       );
			obj.updatedAt                        = json.GetValueOrDefault<DateTime?>("updatedAt"                       );
			obj.cancelledAt                      = json.GetValueOrDefault<DateTime?>("cancelledAt"                     );
			obj.closedAt                         = json.GetValueOrDefault<DateTime?>("closedAt"                        );
			obj.processedAt                      = json.GetValueOrDefault<DateTime?>("processedAt"                     );
			obj.closed                           = json.GetValueOrDefault<bool     >("closed"                          );
			obj.confirmed                        = json.GetValueOrDefault<bool     >("confirmed"                       );
			obj.fullyPaid                        = json.GetValueOrDefault<bool     >("fullyPaid"                       );
			obj.unpaid                           = json.GetValueOrDefault<bool     >("unpaid"                          );
			obj.currencyCode                     = json.GetValueOrDefault<string   >("currencyCode"                    );
			obj.currentSubtotalLineItemsQuantity = json.GetValueOrDefault<int      >("currentSubtotalLineItemsQuantity");
			obj.taxesIncluded                    = json.GetValueOrDefault<bool     >("taxesIncluded"                   );
			obj.currentTotalWeight               = json.GetValueOrDefault<int      >("currentTotalWeight"              );
			obj.customerLocale                   = json.GetValueOrDefault<string   >("customerLocale"                  );
			obj.discountCode                     = json.GetValueOrDefault<string   >("discountCode"                    );
			obj.email                            = json.GetValueOrDefault<string   >("email"                           );
			obj.phone                            = json.GetValueOrDefault<string   >("phone"                           );
			obj.note                             = json.GetValueOrDefault<string   >("note"                            );

			if ( json.ContainsName("currentCartDiscountAmountSet") ) obj.currentCartDiscountAmountSet = DeserializeMoneyBag(json.GetValue("currentCartDiscountAmountSet"));
			if ( json.ContainsName("currentSubtotalPriceSet"     ) ) obj.currentSubtotalPriceSet      = DeserializeMoneyBag(json.GetValue("currentSubtotalPriceSet"     ));
			if ( json.ContainsName("currentTotalDiscountsSet"    ) ) obj.currentTotalDiscountsSet     = DeserializeMoneyBag(json.GetValue("currentTotalDiscountsSet"    ));
			if ( json.ContainsName("currentTotalDutiesSet"       ) ) obj.currentTotalDutiesSet        = DeserializeMoneyBag(json.GetValue("currentTotalDutiesSet"       ));
			if ( json.ContainsName("currentTotalPriceSet"        ) ) obj.currentTotalPriceSet         = DeserializeMoneyBag(json.GetValue("currentTotalPriceSet"        ));
			if ( json.ContainsName("currentTotalTaxSet"          ) ) obj.currentTotalTaxSet           = DeserializeMoneyBag(json.GetValue("currentTotalTaxSet"          ));

			if ( json.ContainsName("customer"       ) ) obj.customer        = mapper.Deserialize<Customer         >(json.GetValue("customer"       ));
			if ( json.ContainsName("billingAddress" ) ) obj.billingAddress  = mapper.Deserialize<MailingAddress   >(json.GetValue("billingAddress" ));
			if ( json.ContainsName("shippingAddress") ) obj.shippingAddress = mapper.Deserialize<MailingAddress   >(json.GetValue("shippingAddress"));
			//if ( json.ContainsName("shippingLines"  ) ) obj.shippingLines   = mapper.Deserialize<IList<ShipMethod>>(json.GetValue("shippingLines"  ));
			return obj;
		}
	}

	class OrderListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Order> items = new List<Order>();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add( mapper.Deserialize<Order>(itemValue) );
				}
			}
			return items;
		}
	}
}
