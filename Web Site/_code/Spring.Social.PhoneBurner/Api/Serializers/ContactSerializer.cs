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

namespace Spring.Social.PhoneBurner.Api.Impl.Json
{
	class ContactSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Contact o = obj as Contact;
			
			JsonObject json           = new JsonObject();

			if ( o.owner_id                  .HasValue ) json.AddValue("owner_id"                , new JsonValue(o.owner_id                 .Value));
			if ( o.owner_username            != null   ) json.AddValue("owner_username"          , new JsonValue(o.owner_username                 ));
			if ( o.email                     != null   ) json.AddValue("email"                   , new JsonValue(o.email                          ));
			if ( o.first_name                != null   ) json.AddValue("first_name"              , new JsonValue(o.first_name                     ));
			if ( o.last_name                 != null   ) json.AddValue("last_name"               , new JsonValue(o.last_name                      ));
			if ( o.phone                     != null   ) json.AddValue("phone"                   , new JsonValue(o.phone                          ));
			if ( o.phone_type                .HasValue ) json.AddValue("phone_type"              , new JsonValue(o.phone_type               .Value));
			if ( o.phone_label               != null   ) json.AddValue("phone_label"             , new JsonValue(o.phone_label                    ));
			if ( o.address1                  != null   ) json.AddValue("address1"                , new JsonValue(o.address1                       ));
			if ( o.address2                  != null   ) json.AddValue("address2"                , new JsonValue(o.address2                       ));
			if ( o.city                      != null   ) json.AddValue("city"                    , new JsonValue(o.city                           ));
			if ( o.state                     != null   ) json.AddValue("state"                   , new JsonValue(o.state                          ));
			if ( o.state_other               != null   ) json.AddValue("state_other"             , new JsonValue(o.state_other                    ));
			if ( o.zip                       != null   ) json.AddValue("zip"                     , new JsonValue(o.zip                            ));
			if ( o.country                   != null   ) json.AddValue("country"                 , new JsonValue(o.country                        ));
			if ( o.ad_code                   != null   ) json.AddValue("ad_code"                 , new JsonValue(o.ad_code                        ));
			if ( o.notes                     != null   ) json.AddValue("notes"                   , new JsonValue(o.notes.notes                    ));
			if ( o.viewed                    != null   ) json.AddValue("viewed"                  , new JsonValue(o.viewed                         ));
			if ( o.category_id               != null   ) json.AddValue("category_id"             , new JsonValue(o.category_id                    ));
			if ( o.token                     != null   ) json.AddValue("token"                   , new JsonValue(o.token                          ));
			if ( o.return_lead_token         != null   ) json.AddValue("return_lead_token"       , new JsonValue(o.return_lead_token              ));
			if ( o.lead_id                   != null   ) json.AddValue("lead_id"                 , new JsonValue(o.lead_id                        ));
			if ( o.order_number              != null   ) json.AddValue("order_number"            , new JsonValue(o.order_number                   ));
			if ( o.lead_vendor_product_name  != null   ) json.AddValue("lead_vendor_product_name", new JsonValue(o.lead_vendor_product_name       ));
			if ( o.allow_duplicates          != null   ) json.AddValue("allow_duplicates"        , new JsonValue(o.allow_duplicates               ));
			if ( o.rating                    != null   ) json.AddValue("rating"                  , new JsonValue(o.rating                         ));

			if ( o.additional_name           != null   ) json.AddValue("additional_name"         , mapper.Serialize(o.additional_name             ));
			if ( o.additional_phone          != null   ) json.AddValue("additional_phone"        , mapper.Serialize(o.additional_phone            ));
			if ( o.q_and_a                   != null   ) json.AddValue("q_and_a"                 , mapper.Serialize(o.q_and_a                     ));
			if ( o.custom_fields             != null   ) json.AddValue("custom_fields"           , mapper.Serialize(o.custom_fields               ));
			if ( o.social_accounts           != null   ) json.AddValue("social_accounts"         , mapper.Serialize(o.social_accounts             ));

			if ( o.tags != null )
			{
				JsonArray arr = new JsonArray();
				foreach ( string s in o.tags )
				{
					arr.AddValue(new JsonValue(s));
				}
				json.AddValue("tags", arr);
			}

			o.RawContent = json.ToString();
			return json;
		}
	}

	class ContactListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<Contact> lst = obj as IList<Contact>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( Contact o in lst )
				{
					json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
