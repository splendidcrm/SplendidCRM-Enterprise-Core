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
	class OpportunitySerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Opportunity o = obj as Opportunity;
			
			JsonObject json           = new JsonObject();
			if ( o.owner_id                     .HasValue ) json.AddValue("owner_id"                     , new JsonValue(o.owner_id                     .Value));
			if ( o.crm_id                       != null   ) json.AddValue("crm_id"                       , new JsonValue(o.crm_id                             ));

			//if ( o.opportunity_id               .HasValue ) json.AddValue("opportunity_id"               , new JsonValue(o.opportunity_id               .Value));
			//if ( o.opportunity                  != null   ) json.AddValue("opportunity"                  , new JsonValue(o.opportunity                        ));
			if ( o.name                         != null   ) json.AddValue("name"                         , new JsonValue(o.name                               ));
			if ( o.contact_id                   .HasValue ) json.AddValue("contact_id"                   , new JsonValue(o.contact_id                   .Value));
			//if ( o.contact                      != null   ) json.AddValue("contact"                      , new JsonValue(o.contact                            ));
			if ( o.account_id                   .HasValue ) json.AddValue("account_id"                   , new JsonValue(o.account_id                   .Value));
			//if ( o.account                      != null   ) json.AddValue("account"                      , new JsonValue(o.account                            ));
			if ( o.closing_date                 .HasValue ) json.AddValue("closing_date"                 , new JsonValue(o.closing_date                 .Value.ToUniversalTime().ToString("u")));
			if ( o.lead_source                  != null   ) json.AddValue("lead_source"                  , new JsonValue(o.lead_source                        ));
			if ( o.stage                        != null   ) json.AddValue("stage"                        , new JsonValue(o.stage                              ));
			if ( o.next_step                    != null   ) json.AddValue("next_step"                    , new JsonValue(o.next_step                          ));
			if ( o.amount                       .HasValue ) json.AddValue("amount"                       , new JsonValue(o.amount                       .Value));
			if ( o.probability                  != null   ) json.AddValue("probability"                  , new JsonValue(o.probability                        ));
			//if ( o.won                          != null   ) json.AddValue("won"                          , new JsonValue(o.won                                ));
			if ( o.est_closing_date             .HasValue ) json.AddValue("est_closing_date"             , new JsonValue(o.est_closing_date             .Value.ToUniversalTime().ToString("u")));
			if ( o.sub_lead_source_originator   != null   ) json.AddValue("sub_lead_source_originator"   , new JsonValue(o.sub_lead_source_originator         ));
			if ( o.lead_source_originator       != null   ) json.AddValue("lead_source_originator"       , new JsonValue(o.lead_source_originator             ));
			if ( o.sub_lead_source              != null   ) json.AddValue("sub_lead_source"              , new JsonValue(o.sub_lead_source                    ));
			if ( o.description                  != null   ) json.AddValue("description"                  , new JsonValue(o.description                        ));
			if ( o.opp_type                     != null   ) json.AddValue("opp_type"                     , new JsonValue(o.opp_type                           ));
			if ( o.shared_opp                   != null   ) json.AddValue("shared_opp"                   , new JsonValue(o.shared_opp                         ));
			if ( o.product_name                 != null   ) json.AddValue("product_name"                 , new JsonValue(o.product_name                       ));
			if ( o.action_steps_complete        != null   ) json.AddValue("action_steps_complete"        , new JsonValue(o.action_steps_complete              ));
			//if ( o.custom_mapping               != null   ) json.AddValue("custom_mapping"               , new JsonValue(o.custom_mapping                     ));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
