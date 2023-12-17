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

namespace Spring.Social.QuickBooks.Api.Impl.Json
{
	class ItemDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 06/12/2014 Paul.  This method is called for each array item and for a single item. 
			if ( json.ContainsName("Item") )
			{
				json = json.GetValue("Item");
			}
			Item obj = new Item();
			obj.RawContent          = json.ToString();
			obj.Id                  = json.GetValueOrDefault<String   >("Id"                 );
			obj.SyncToken           = json.GetValueOrDefault<String   >("SyncToken"          );
			obj.Name                = json.GetValueOrDefault<String   >("Name"               );
			obj.Description         = json.GetValueOrDefault<String   >("Description"        );
			obj.Active              = json.GetValueOrDefault<Boolean? >("Active"             );
			obj.SubItem             = json.GetValueOrDefault<Boolean? >("SubItem"            );
			obj.Level               = json.GetValueOrDefault<int      >("Level"              );
			obj.FullyQualifiedName  = json.GetValueOrDefault<String   >("FullyQualifiedName" );
			obj.Taxable             = json.GetValueOrDefault<Boolean? >("Taxable"            );
			obj.SalesTaxIncluded    = json.GetValueOrDefault<Boolean? >("SalesTaxIncluded"   );
			obj.UnitPrice           = json.GetValueOrDefault<Decimal? >("UnitPrice"          );
			obj.RatePercent         = json.GetValueOrDefault<Decimal? >("RatePercent"        );
			obj.PurchaseDesc        = json.GetValueOrDefault<String   >("PurchaseDesc"       );
			obj.PurchaseTaxIncluded = json.GetValueOrDefault<Boolean? >("PurchaseTaxIncluded");
			obj.PurchaseCost        = json.GetValueOrDefault<Decimal? >("PurchaseCost"       );
			obj.TrackQtyOnHand      = json.GetValueOrDefault<Boolean? >("TrackQtyOnHand"     );
			obj.QtyOnHand           = json.GetValueOrDefault<Decimal? >("QtyOnHand"          );
			obj.InvStartDate        = json.GetValueOrDefault<DateTime?>("InvStartDate"       );

			if ( json.ContainsName("Type"           ) ) obj.Type            = _EnumDeserializer.DeserializeItemType       (json.GetValue("Type"           ));

			JsonValue metaData            = json.GetValue("MetaData"           );
			JsonValue ParentRef           = json.GetValue("ParentRef"          );
			JsonValue IncomeAccountRef    = json.GetValue("IncomeAccountRef"   );
			JsonValue ExpenseAccountRef   = json.GetValue("ExpenseAccountRef"  );
			JsonValue AssetAccountRef     = json.GetValue("AssetAccountRef"    );
			JsonValue SalesTaxCodeRef     = json.GetValue("SalesTaxCodeRef"    );
			JsonValue PurchaseTaxCodeRef  = json.GetValue("PurchaseTaxCodeRef" );
			if ( metaData            != null && metaData           .IsObject ) obj.MetaData            = mapper.Deserialize<ModificationMetaData>(metaData           );
			if ( ParentRef           != null && ParentRef          .IsObject ) obj.ParentRef           = mapper.Deserialize<ReferenceType       >(ParentRef          );
			if ( IncomeAccountRef    != null && IncomeAccountRef   .IsObject ) obj.IncomeAccountRef    = mapper.Deserialize<ReferenceType       >(IncomeAccountRef   );
			if ( ExpenseAccountRef   != null && ExpenseAccountRef  .IsObject ) obj.ExpenseAccountRef   = mapper.Deserialize<ReferenceType       >(ExpenseAccountRef  );
			if ( AssetAccountRef     != null && AssetAccountRef    .IsObject ) obj.AssetAccountRef     = mapper.Deserialize<ReferenceType       >(AssetAccountRef    );
			if ( SalesTaxCodeRef     != null && SalesTaxCodeRef    .IsObject ) obj.SalesTaxCodeRef     = mapper.Deserialize<ReferenceType       >(SalesTaxCodeRef    );
			if ( PurchaseTaxCodeRef  != null && PurchaseTaxCodeRef .IsObject ) obj.PurchaseTaxCodeRef  = mapper.Deserialize<ReferenceType       >(PurchaseTaxCodeRef );
			return obj;
		}
	}

	class ItemListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Item> items = new List<Item>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				JsonValue jsonItems = jsonResponse.GetValue("Item");
				if ( jsonItems != null && jsonItems.IsArray )
				{
					foreach ( JsonValue itemValue in jsonItems.GetValues() )
					{
						items.Add( mapper.Deserialize<Item>(itemValue) );
					}
				}
			}
			return items;
		}
	}
}
