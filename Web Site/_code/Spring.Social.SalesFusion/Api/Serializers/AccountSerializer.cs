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

namespace Spring.Social.SalesFusion.Api.Impl.Json
{
	class AccountSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Account o = obj as Account;
			
			JsonObject json           = new JsonObject();
			if ( o.owner_id                     .HasValue ) json.AddValue("owner_id"                     , new JsonValue(o.owner_id                     .Value));
			if ( o.crm_id                       != null   ) json.AddValue("crm_id"                       , new JsonValue(o.crm_id                             ));

			//if ( o.account_id                   .HasValue ) json.AddValue("account_id"                   , new JsonValue(o.account_id                   .Value));
			if ( o.account_name                 != null   ) json.AddValue("account_name"                 , new JsonValue(o.account_name                       ));
			//if ( o.account                      != null   ) json.AddValue("account"                      , new JsonValue(o.account                            ));
			if ( o.account_number               != null   ) json.AddValue("account_number"               , new JsonValue(o.account_number                     ));
			if ( o.phone                        != null   ) json.AddValue("phone"                        , new JsonValue(o.phone                              ));
			if ( o.fax                          != null   ) json.AddValue("fax"                          , new JsonValue(o.fax                                ));
			if ( o.billing_street               != null   ) json.AddValue("billing_street"               , new JsonValue(o.billing_street                     ));
			if ( o.billing_city                 != null   ) json.AddValue("billing_city"                 , new JsonValue(o.billing_city                       ));
			if ( o.billing_state                != null   ) json.AddValue("billing_state"                , new JsonValue(o.billing_state                      ));
			if ( o.billing_zip                  != null   ) json.AddValue("billing_zip"                  , new JsonValue(o.billing_zip                        ));
			if ( o.billing_country              != null   ) json.AddValue("billing_country"              , new JsonValue(o.billing_country                    ));
			if ( o.shipping_street              != null   ) json.AddValue("shipping_street"              , new JsonValue(o.shipping_street                    ));
			if ( o.shipping_city                != null   ) json.AddValue("shipping_city"                , new JsonValue(o.shipping_city                      ));
			if ( o.shipping_state               != null   ) json.AddValue("shipping_state"               , new JsonValue(o.shipping_state                     ));
			if ( o.shipping_zip                 != null   ) json.AddValue("shipping_zip"                 , new JsonValue(o.shipping_zip                       ));
			if ( o.shipping_country             != null   ) json.AddValue("shipping_country"             , new JsonValue(o.shipping_country                   ));
			//if ( o.contacts                     != null   ) json.AddValue("contacts"                     , new JsonValue(o.contacts                           ));
			//if ( o.custom_score_field           != null   ) json.AddValue("custom_score_field"           , new JsonValue(o.custom_score_field                 ));
			if ( o.industry                     != null   ) json.AddValue("industry"                     , new JsonValue(o.industry                           ));
			if ( o.type                         != null   ) json.AddValue("type"                         , new JsonValue(o.type                               ));
			if ( o.key_account                  .HasValue ) json.AddValue("key_account"                  , new JsonValue(o.key_account                  .Value));
			//if ( o.account_score                .HasValue ) json.AddValue("account_score"                , new JsonValue(o.account_score                .Value));
			if ( o.sic                          != null   ) json.AddValue("sic"                          , new JsonValue(o.sic                                ));
			if ( o.rating                       != null   ) json.AddValue("rating"                       , new JsonValue(o.rating                             ));
			if ( o.description                  != null   ) json.AddValue("description"                  , new JsonValue(o.description                        ));
			if ( o.url                          != null   ) json.AddValue("url"                          , new JsonValue(o.url                                ));
			if ( o.currency_iso_code            != null   ) json.AddValue("currency_iso_code"            , new JsonValue(o.currency_iso_code                  ));
			if ( o.salesfusion_last_activity    .HasValue ) json.AddValue("salesfusion_last_activity"    , new JsonValue(o.salesfusion_last_activity    .Value.ToUniversalTime().ToString("u")));
			if ( o.short_description            != null   ) json.AddValue("short_description"            , new JsonValue(o.short_description                  ));
			if ( o.campaign_id                  != null   ) json.AddValue("campaign_id"                  , new JsonValue(o.campaign_id                        ));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
