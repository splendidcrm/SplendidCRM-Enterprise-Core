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

using Spring.Social.Shopify.Api;

namespace Spring.Social.Shopify.Api.Impl.Json
{
	class ProductDeserializer : IJsonDeserializer
	{
/*
{
  "data": {
    "products": {
      "edges": [
        {
          "node": {
            "id": "gid://shopify/Product/6785278312563",
            "createdAt": "2022-03-09T08:39:15Z",
            "updatedAt": "2022-03-09T08:39:16Z",
            "publishedAt": null,
            "title": "SplendidCRM Enterprise 13.0 for SQL Server",
            "handle": "splendidcrm-enterprise-13-0-for-sql-server",
            "description": "A highly-scalable and highly-customizable customer relationship management (CRM) application. Enterprise includes Reporting, Dynamic Teams, Order Management, Credit Card payments, Exchange Sync, Cloud Sync and Workflow.",
            "descriptionHtml": "<span data-mce-fragment=\"1\">A highly-scalable and highly-customizable customer relationship management (CRM) application. Enterprise includes Reporting, Dynamic Teams, Order Management, Credit Card payments, Exchange Sync, Cloud Sync and Workflow.</span>",
            "productType": "",
            "tags": [],
            "vendor": "SplendidCRM Dev",
            "totalInventory": 0,
            "priceRangeV2": {
              "maxVariantPrice": {
                "amount": "480.0",
                "currencyCode": "USD"
              },
              "minVariantPrice": {
                "amount": "480.0",
                "currencyCode": "USD"
              }
            }
          },
          "cursor": "eyJsYXN0X2lkIjo2Nzg1Mjc4MzEyNTYzLCJsYXN0X3ZhbHVlIjoiNjc4NTI3ODMxMjU2MyJ9"
        }
      ],
      "pageInfo": {
        "hasNextPage": true
      }
    }
  },
  "extensions": {
    "cost": {
      "requestedQueryCost": 4,
      "actualQueryCost": 4,
      "throttleStatus": {
        "maximumAvailable": 1000,
        "currentlyAvailable": 996,
        "restoreRate": 50
      }
    }
  }
}
*/
	
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Product obj = new Product();
			obj.RawContent = json.ToString();
			
			// 03/17/2022 Paul.  cursor is outside of node. 
			obj.cursor           = json.GetValueOrDefault<string   >("cursor"         );
			if ( json.ContainsName("node") )
			{
				json = json.GetValue("node");
			}
			obj.id                = json.GetValueOrDefault<String   >("id"             );
			obj.createdAt         = json.GetValueOrDefault<DateTime >("createdAt"      );
			obj.updatedAt         = json.GetValueOrDefault<DateTime?>("updatedAt"      );
			obj.publishedAt       = json.GetValueOrDefault<DateTime?>("publishedAt"    );
			obj.title             = json.GetValueOrDefault<String   >("title"          );
			obj.handle            = json.GetValueOrDefault<String   >("handle"         );
			obj.description       = json.GetValueOrDefault<String   >("description"    );
			obj.descriptionHtml   = json.GetValueOrDefault<String   >("descriptionHtml");
			obj.productType       = json.GetValueOrDefault<String   >("productType"    );
			obj.vendor            = json.GetValueOrDefault<String   >("vendor"         );
			obj.totalInventory    = json.GetValueOrDefault<int?     >("totalInventory" );
			if ( json.ContainsName("tags") )
				obj.tags         = mapper.Deserialize<List<String>>(json.GetValue("tags"));

			JsonValue maxVariantPrice = json.GetValue("maxVariantPrice");
			JsonValue minVariantPrice = json.GetValue("minVariantPrice");
			if ( maxVariantPrice != null )
			{
				obj.maxVariantPrice = new MoneyV2();
				obj.maxVariantPrice.amount       = maxVariantPrice.GetValueOrDefault<Decimal>("amount"      );
				obj.maxVariantPrice.currencyCode = maxVariantPrice.GetValueOrDefault<string >("currencyCode");
			}
			if ( minVariantPrice != null )
			{
				obj.minVariantPrice = new MoneyV2();
				obj.minVariantPrice.amount       = minVariantPrice.GetValueOrDefault<Decimal>("amount"      );
				obj.minVariantPrice.currencyCode = minVariantPrice.GetValueOrDefault<string >("currencyCode");
			}
			return obj;
		}
	}

	class ProductListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Product> items = new List<Product>();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add( mapper.Deserialize<Product>(itemValue) );
				}
			}
			return items;
		}
	}
}
