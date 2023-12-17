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
	class ContactSerializer : IJsonSerializer
	{
		protected virtual string CrmType
		{
			get { return "Contact"; }
		}

		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Contact o = obj as Contact;
			
			o.crm_type = CrmType;

			JsonObject json           = new JsonObject();
			if ( o.owner_id                     .HasValue ) json.AddValue("owner_id"                     , new JsonValue(o.owner_id                     .Value));
			if ( o.crm_id                       != null   ) json.AddValue("crm_id"                       , new JsonValue(o.crm_id                             ));

			//if ( o.contact_id                   .HasValue ) json.AddValue("contact_id"                   , new JsonValue(o.contact_id                   .Value));
			//if ( o.contact                      != null   ) json.AddValue("contact"                      , new JsonValue(o.contact                            ));
			if ( o.crm_type                     != null   ) json.AddValue("crm_type"                     , new JsonValue(o.crm_type                           ));
			if ( o.salutation                   != null   ) json.AddValue("salutation"                   , new JsonValue(o.salutation                         ));
			if ( o.first_name                   != null   ) json.AddValue("first_name"                   , new JsonValue(o.first_name                         ));
			if ( o.last_name                    != null   ) json.AddValue("last_name"                    , new JsonValue(o.last_name                          ));
			if ( o.phone                        != null   ) json.AddValue("phone"                        , new JsonValue(o.phone                              ));
			if ( o.mobile                       != null   ) json.AddValue("mobile"                       , new JsonValue(o.mobile                             ));
			if ( o.fax                          != null   ) json.AddValue("fax"                          , new JsonValue(o.fax                                ));
			if ( o.home_phone                   != null   ) json.AddValue("home_phone"                   , new JsonValue(o.home_phone                         ));
			if ( o.other_phone                  != null   ) json.AddValue("other_phone"                  , new JsonValue(o.other_phone                        ));
			if ( o.email                        != null   ) json.AddValue("email"                        , new JsonValue(o.email                              ));
			//if ( o.account_id                   .HasValue ) json.AddValue("account_id"                   , new JsonValue(o.account_id                   .Value));
			//if ( o.account_name                 != null   ) json.AddValue("account_name"                 , new JsonValue(o.account_name                       ));
			//if ( o.account                      != null   ) json.AddValue("account"                      , new JsonValue(o.account                            ));
			if ( o.billing_street               != null   ) json.AddValue("billing_street"               , new JsonValue(o.billing_street                     ));
			if ( o.billing_city                 != null   ) json.AddValue("billing_city"                 , new JsonValue(o.billing_city                       ));
			if ( o.billing_state                != null   ) json.AddValue("billing_state"                , new JsonValue(o.billing_state                      ));
			if ( o.billing_zip                  != null   ) json.AddValue("billing_zip"                  , new JsonValue(o.billing_zip                        ));
			if ( o.billing_country              != null   ) json.AddValue("billing_country"              , new JsonValue(o.billing_country                    ));
			if ( o.mailing_street               != null   ) json.AddValue("mailing_street"               , new JsonValue(o.mailing_street                     ));
			if ( o.mailing_city                 != null   ) json.AddValue("mailing_city"                 , new JsonValue(o.mailing_city                       ));
			if ( o.mailing_state                != null   ) json.AddValue("mailing_state"                , new JsonValue(o.mailing_state                      ));
			if ( o.mailing_zip                  != null   ) json.AddValue("mailing_zip"                  , new JsonValue(o.mailing_zip                        ));
			if ( o.mailing_country              != null   ) json.AddValue("mailing_country"              , new JsonValue(o.mailing_country                    ));
			if ( o.street                       != null   ) json.AddValue("street"                       , new JsonValue(o.street                             ));
			if ( o.city                         != null   ) json.AddValue("city"                         , new JsonValue(o.city                               ));
			if ( o.state                        != null   ) json.AddValue("state"                        , new JsonValue(o.state                              ));
			if ( o.postal_code                  != null   ) json.AddValue("postal_code"                  , new JsonValue(o.postal_code                        ));
			if ( o.country                      != null   ) json.AddValue("country"                      , new JsonValue(o.country                            ));
			if ( o.area                         != null   ) json.AddValue("area"                         , new JsonValue(o.area                               ));
			if ( o.region                       != null   ) json.AddValue("region"                       , new JsonValue(o.region                             ));
			if ( o.district                     != null   ) json.AddValue("district"                     , new JsonValue(o.district                           ));
			if ( o.status                       != null   ) json.AddValue("status"                       , new JsonValue(o.status                             ));
			if ( o.industry                     != null   ) json.AddValue("industry"                     , new JsonValue(o.industry                           ));
			if ( o.source                       != null   ) json.AddValue("source"                       , new JsonValue(o.source                             ));
			if ( o.lead_source_id               != null   ) json.AddValue("lead_source_id"               , new JsonValue(o.lead_source_id                     ));
			if ( o.gender                       != null   ) json.AddValue("gender"                       , new JsonValue(o.gender                             ));
			if ( o.birth_date                   .HasValue ) json.AddValue("birth_date"                   , new JsonValue(o.birth_date                   .Value.ToString("YYYY-MM-DD")));
			if ( o.salary                       != null   ) json.AddValue("salary"                       , new JsonValue(o.salary                             ));
			if ( o.company                      != null   ) json.AddValue("company"                      , new JsonValue(o.company                            ));
			if ( o.title                        != null   ) json.AddValue("title"                        , new JsonValue(o.title                              ));
			if ( o.department                   != null   ) json.AddValue("department"                   , new JsonValue(o.department                         ));
			if ( o.website                      != null   ) json.AddValue("website"                      , new JsonValue(o.website                            ));
			if ( o.currency_iso_code            != null   ) json.AddValue("currency_iso_code"            , new JsonValue(o.currency_iso_code                  ));
			if ( o.purlid                       != null   ) json.AddValue("purlid"                       , new JsonValue(o.purlid                             ));
			if ( o.rating                       != null   ) json.AddValue("rating"                       , new JsonValue(o.rating                             ));
			if ( o.assistant_name               != null   ) json.AddValue("assistant_name"               , new JsonValue(o.assistant_name                     ));
			if ( o.assistant_phone              != null   ) json.AddValue("assistant_phone"              , new JsonValue(o.assistant_phone                    ));
			if ( o.owner_email                  != null   ) json.AddValue("owner_email"                  , new JsonValue(o.owner_email                        ));
			if ( o.description                  != null   ) json.AddValue("description"                  , new JsonValue(o.description                        ));
			if ( o.short_description            != null   ) json.AddValue("short_description"            , new JsonValue(o.short_description                  ));
			if ( o.do_not_call                  != null   ) json.AddValue("do_not_call"                  , new JsonValue(o.do_not_call                        ));
			if ( o.opt_out                      != null   ) json.AddValue("opt_out"                      , new JsonValue(o.opt_out                            ));
			if ( o.opt_out_date                 .HasValue ) json.AddValue("opt_out_date"                 , new JsonValue(o.opt_out_date                 .Value.ToUniversalTime().ToString("u")));
			if ( o.last_modified_by_id          != null   ) json.AddValue("last_modified_by_id"          , new JsonValue(o.last_modified_by_id                ));
			if ( o.last_modified_date           != null   ) json.AddValue("last_modified_date"           , new JsonValue(o.last_modified_date                 ));
			if ( o.last_activity_date           != null   ) json.AddValue("last_activity_date"           , new JsonValue(o.last_activity_date                 ));

			//if ( o.custom_score_field           != null   ) json.AddValue("custom_score_field"           , new JsonValue(o.custom_score_field                 ));
			//if ( o.deliverability_status        .HasValue ) json.AddValue("deliverability_status"        , new JsonValue(o.deliverability_status        .Value));
			//if ( o.deliverability_message       != null   ) json.AddValue("deliverability_message"       , new JsonValue(o.deliverability_message             ));
			//if ( o.delivered_date               .HasValue ) json.AddValue("delivered_date"               , new JsonValue(o.delivered_date               .Value.ToUniversalTime().ToString("u")));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
