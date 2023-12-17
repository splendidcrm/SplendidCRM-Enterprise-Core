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
	class LineItemDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			LineItem obj = new LineItem();
			obj.RawContent   = json.ToString();
			obj.id                   = json.GetValueOrDefault<String>("id"                  );
			obj.sku                  = json.GetValueOrDefault<String>("sku"                 );
			obj.name                 = json.GetValueOrDefault<String>("name"                );
			obj.title                = json.GetValueOrDefault<String>("title"               );
			obj.vendor               = json.GetValueOrDefault<String>("vendor"              );
			obj.currentQuantity      = json.GetValueOrDefault<int   >("currentQuantity"     );
			obj.quantity             = json.GetValueOrDefault<int   >("quantity"            );
			obj.requiresShipping     = json.GetValueOrDefault<bool  >("requiresShipping"    );
			obj.taxable              = json.GetValueOrDefault<bool  >("taxable"             );

			if ( json.ContainsName("image"               ) ) obj.image                = mapper.Deserialize<Image         >(json.GetValue("image"               ));
			if ( json.ContainsName("originalTotalSet"    ) ) obj.originalTotalSet     = mapper.Deserialize<MoneyV2       >(json.GetValue("originalTotalSet"    ));
			if ( json.ContainsName("originalUnitPriceSet") ) obj.originalUnitPriceSet = mapper.Deserialize<MoneyV2       >(json.GetValue("originalUnitPriceSet"));
			if ( json.ContainsName("product"             ) ) obj.product              = mapper.Deserialize<Product       >(json.GetValue("product"             ));
			if ( json.ContainsName("taxLines"            ) ) obj.taxLines             = mapper.Deserialize<IList<TaxLine>>(json.GetValue("taxLines"            ));
			return obj;
		}
	}

	class LineItemListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue value, JsonMapper mapper)
		{
			IList<LineItem> lines = new List<LineItem>();
			if ( value != null && value.IsArray )
			{
				foreach ( JsonValue itemValue in value.GetValues() )
				{
					lines.Add( mapper.Deserialize<LineItem>(itemValue) );
				}
			}
			return lines;
		}
	}
}
