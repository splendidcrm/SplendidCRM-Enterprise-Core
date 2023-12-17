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

namespace Spring.Social.Pardot.Api.Impl.Json
{
	class ProspectAccountSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			ProspectAccount o = obj as ProspectAccount;
			
			JsonObject json = new JsonObject();
			if ( o.name                   != null   ) json.AddValue("name"                , new JsonValue(o.name                        ));
			if ( o.number                 .HasValue ) json.AddValue("number"              , new JsonValue(o.number                .Value));
			if ( o.description            != null   ) json.AddValue("description"         , new JsonValue(o.description                 ));
			if ( o.phone                  != null   ) json.AddValue("phone"               , new JsonValue(o.phone                       ));
			if ( o.fax                    != null   ) json.AddValue("fax"                 , new JsonValue(o.fax                         ));
			if ( o.website                != null   ) json.AddValue("website"             , new JsonValue(o.website                     ));
			if ( o.rating                 != null   ) json.AddValue("rating"              , new JsonValue(o.rating                      ));
			if ( o.site                   != null   ) json.AddValue("site"                , new JsonValue(o.site                        ));
			if ( o.type                   != null   ) json.AddValue("type"                , new JsonValue(o.type                        ));
			if ( o.annual_revenue         .HasValue ) json.AddValue("annual_revenue"      , new JsonValue(o.annual_revenue        .Value));
			if ( o.industry               != null   ) json.AddValue("industry"            , new JsonValue(o.industry                    ));
			if ( o.sic                    != null   ) json.AddValue("sic"                 , new JsonValue(o.sic                         ));
			if ( o.employees              .HasValue ) json.AddValue("employees"           , new JsonValue(o.employees             .Value));
			if ( o.ownership              != null   ) json.AddValue("ownership"           , new JsonValue(o.ownership                   ));
			if ( o.ticker_symbol          != null   ) json.AddValue("ticker_symbol"       , new JsonValue(o.ticker_symbol               ));
			if ( o.billing_address_one    != null   ) json.AddValue("billing_address_one" , new JsonValue(o.billing_address_one         ));
			if ( o.billing_address_two    != null   ) json.AddValue("billing_address_two" , new JsonValue(o.billing_address_two         ));
			if ( o.billing_city           != null   ) json.AddValue("billing_city"        , new JsonValue(o.billing_city                ));
			if ( o.billing_state          != null   ) json.AddValue("billing_state"       , new JsonValue(o.billing_state               ));
			if ( o.billing_zip            != null   ) json.AddValue("billing_zip"         , new JsonValue(o.billing_zip                 ));
			if ( o.billing_country        != null   ) json.AddValue("billing_country"     , new JsonValue(o.billing_country             ));
			if ( o.shipping_address_one   != null   ) json.AddValue("shipping_address_one", new JsonValue(o.shipping_address_one        ));
			if ( o.shipping_address_two   != null   ) json.AddValue("shipping_address_two", new JsonValue(o.shipping_address_two        ));
			if ( o.shipping_city          != null   ) json.AddValue("shipping_city"       , new JsonValue(o.shipping_city               ));
			if ( o.shipping_state         != null   ) json.AddValue("shipping_state"      , new JsonValue(o.shipping_state              ));
			if ( o.shipping_zip           != null   ) json.AddValue("shipping_zip"        , new JsonValue(o.shipping_zip                ));
			if ( o.shipping_country       != null   ) json.AddValue("shipping_country"    , new JsonValue(o.shipping_country            ));
			o.RawContent = json.ToString();
			// 07/16/2017 Paul.  For some unknown reason, data posted is in x-www-form-urlencoded format instead of json. 
			return json;
		}
	}
}
