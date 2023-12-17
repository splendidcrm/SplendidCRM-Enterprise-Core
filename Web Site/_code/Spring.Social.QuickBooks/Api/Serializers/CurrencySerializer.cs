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
	class CurrencySerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Currency o = obj as Currency;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Id              ) ) json.AddValue("Id"              , new JsonValue(o.Id                ));
			if ( !Sql.IsEmptyString(o.SyncToken       ) ) json.AddValue("SyncToken"       , new JsonValue(o.SyncToken         ));
			if ( !Sql.IsEmptyString(o.Name            ) ) json.AddValue("Name"            , new JsonValue(o.Name              ));
			if ( !Sql.IsEmptyString(o.Separator       ) ) json.AddValue("Separator"       , new JsonValue(o.Separator         ));
			if ( !Sql.IsEmptyString(o.Format          ) ) json.AddValue("Format"          , new JsonValue(o.Format            ));
			if ( !Sql.IsEmptyString(o.DecimalPlaces   ) ) json.AddValue("DecimalPlaces"   , new JsonValue(o.DecimalPlaces     ));
			if ( !Sql.IsEmptyString(o.DecimalSeparator) ) json.AddValue("DecimalSeparator", new JsonValue(o.DecimalSeparator  ));
			if ( !Sql.IsEmptyString(o.Symbol          ) ) json.AddValue("Symbol"          , new JsonValue(o.Symbol            ));
			if ( o.Active           .HasValue           ) json.AddValue("Active"          , new JsonValue(o.Active      .Value));
			if ( o.UserDefined      .HasValue           ) json.AddValue("UserDefined"     , new JsonValue(o.UserDefined .Value));
			if ( o.ExchangeRate     .HasValue           ) json.AddValue("ExchangeRate"    , new JsonValue(o.ExchangeRate.Value));
			if ( o.AsOfDate         .HasValue           ) json.AddValue("AsOfDate"        , new JsonValue(o.AsOfDate    .Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			if ( o.Code             .HasValue           ) json.AddValue("Code"            , _EnumSerializer.Serialize(o.Code          .Value));
			if ( o.SymbolPosition   .HasValue           ) json.AddValue("SymbolPosition"  , _EnumSerializer.Serialize(o.SymbolPosition.Value));
			// 02/01/2015  Paul.  QBO is required. 
			// https://developer.intuit.com/docs/95_legacy/qbd_v3/qbd_v3_reference/020_key_concepts/050_sparse_update
			json.AddValue("domain", new JsonValue("QBO"  ));
			json.AddValue("sparse", new JsonValue("false"));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
