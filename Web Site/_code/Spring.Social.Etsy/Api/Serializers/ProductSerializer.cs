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
using System.Diagnostics;
using Spring.Json;

namespace Spring.Social.Etsy.Api.Impl.Json
{
	class ProductSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Product o = obj as Product;
			
			JsonObject json = new JsonObject();
			if ( o.id              != null   ) json.AddValue("id"             , new JsonValue(o.id             ));
			if ( o.title           != null   ) json.AddValue("title"          , new JsonValue(o.title          ));
			if ( o.handle          != null   ) json.AddValue("handle"         , new JsonValue(o.handle         ));
			if ( o.description     != null   ) json.AddValue("description"    , new JsonValue(o.description    ));
			if ( o.descriptionHtml != null   ) json.AddValue("descriptionHtml", new JsonValue(o.descriptionHtml));
			if ( o.productType     != null   ) json.AddValue("productType"    , new JsonValue(o.productType    ));
			if ( o.vendor          != null   ) json.AddValue("vendor"         , new JsonValue(o.vendor         ));
			if ( o.totalInventory  .HasValue ) json.AddValue("totalInventory" , new JsonValue(o.totalInventory.Value.ToString()));
			if ( o.tags            != null   ) json.AddValue("tags"           , mapper.Serialize(o.tags));
			if ( o.maxVariantPrice != null )
			{
				JsonObject maxVariantPrice = new JsonObject();
				maxVariantPrice.AddValue("amount"      , new JsonValue(o.maxVariantPrice.amount      ));
				maxVariantPrice.AddValue("currencyCode", new JsonValue(o.maxVariantPrice.currencyCode));
				json.AddValue("maxVariantPrice", maxVariantPrice);
			}
			if ( o.minVariantPrice != null )
			{
				JsonObject minVariantPrice = new JsonObject();
				minVariantPrice.AddValue("amount"      , new JsonValue(o.minVariantPrice.amount      ));
				minVariantPrice.AddValue("currencyCode", new JsonValue(o.minVariantPrice.currencyCode));
				json.AddValue("minVariantPrice", minVariantPrice);
			}
			o.RawContent = json.ToString();
			return json;
		}
	}
}
