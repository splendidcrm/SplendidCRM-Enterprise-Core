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
	class ItemSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Item o = obj as Item;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Id                ) ) json.AddValue("Id"                 , new JsonValue(o.Id                       ));
			if ( !Sql.IsEmptyString(o.SyncToken         ) ) json.AddValue("SyncToken"          , new JsonValue(o.SyncToken                ));
			if ( !Sql.IsEmptyString(o.Name              ) ) json.AddValue("Name"               , new JsonValue(o.Name                     ));
			if ( !Sql.IsEmptyString(o.Description       ) ) json.AddValue("Description"        , new JsonValue(o.Description              ));
			if ( !Sql.IsEmptyString(o.PurchaseDesc      ) ) json.AddValue("PurchaseDesc"       , new JsonValue(o.PurchaseDesc             ));
			//if ( !Sql.IsEmptyString(o.FullyQualifiedName) ) json.AddValue("FullyQualifiedName" , new JsonValue(o.FullyQualifiedName       ));
			if ( o.Level               .HasValue          ) json.AddValue("Level"              , new JsonValue(o.Level              .Value));
			if ( o.Active              .HasValue          ) json.AddValue("Active"             , new JsonValue(o.Active             .Value));
			if ( o.SubItem             .HasValue          ) json.AddValue("SubItem"            , new JsonValue(o.SubItem            .Value));
			if ( o.Taxable             .HasValue          ) json.AddValue("Taxable"            , new JsonValue(o.Taxable            .Value));
			if ( o.SalesTaxIncluded    .HasValue          ) json.AddValue("SalesTaxIncluded"   , new JsonValue(o.SalesTaxIncluded   .Value));
			if ( o.UnitPrice           .HasValue          ) json.AddValue("UnitPrice"          , new JsonValue(o.UnitPrice          .Value));
			if ( o.RatePercent         .HasValue          ) json.AddValue("RatePercent"        , new JsonValue(o.RatePercent        .Value));
			if ( o.PurchaseTaxIncluded .HasValue          ) json.AddValue("PurchaseTaxIncluded", new JsonValue(o.PurchaseTaxIncluded.Value));
			if ( o.PurchaseCost        .HasValue          ) json.AddValue("PurchaseCost"       , new JsonValue(o.PurchaseCost       .Value));
			if ( o.TrackQtyOnHand      .HasValue          ) json.AddValue("TrackQtyOnHand"     , new JsonValue(o.TrackQtyOnHand     .Value));
			if ( o.QtyOnHand           .HasValue          ) json.AddValue("QtyOnHand"          , new JsonValue(o.QtyOnHand          .Value));
			if ( o.InvStartDate        .HasValue          ) json.AddValue("InvStartDate"       , new JsonValue(o.InvStartDate       .Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			if ( o.Type                .HasValue          ) json.AddValue("Type"               , _EnumSerializer.Serialize(o.Type   .Value));
			if ( o.ParentRef           != null            ) json.AddValue("ParentRef"          , mapper.Serialize(o.ParentRef          ));
			if ( o.IncomeAccountRef    != null            ) json.AddValue("IncomeAccountRef"   , mapper.Serialize(o.IncomeAccountRef   ));
			if ( o.ExpenseAccountRef   != null            ) json.AddValue("ExpenseAccountRef"  , mapper.Serialize(o.ExpenseAccountRef  ));
			if ( o.AssetAccountRef     != null            ) json.AddValue("AssetAccountRef"    , mapper.Serialize(o.AssetAccountRef    ));
			if ( o.SalesTaxCodeRef     != null            ) json.AddValue("SalesTaxCodeRef"    , mapper.Serialize(o.SalesTaxCodeRef    ));
			if ( o.PurchaseTaxCodeRef  != null            ) json.AddValue("PurchaseTaxCodeRef" , mapper.Serialize(o.PurchaseTaxCodeRef ));
			// 02/01/2015  Paul.  QBO is required. 
			// https://developer.intuit.com/docs/95_legacy/qbd_v3/qbd_v3_reference/020_key_concepts/050_sparse_update
			json.AddValue("domain", new JsonValue("QBO"  ));
			json.AddValue("sparse", new JsonValue("false"));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
