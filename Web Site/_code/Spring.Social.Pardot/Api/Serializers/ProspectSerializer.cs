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
	class ProspectSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Prospect o = obj as Prospect;
			
			JsonObject json = new JsonObject();
			if ( o.campaign_id         .HasValue ) json.AddValue("campaign_id"        , new JsonValue(o.campaign_id        .Value));
			if ( o.salutation          != null   ) json.AddValue("salutation"         , new JsonValue(o.salutation               ));
			if ( o.first_name          != null   ) json.AddValue("first_name"         , new JsonValue(o.first_name               ));
			if ( o.last_name           != null   ) json.AddValue("last_name"          , new JsonValue(o.last_name                ));
			if ( o.email               != null   ) json.AddValue("email"              , new JsonValue(o.email                    ));
			if ( o.password            != null   ) json.AddValue("password"           , new JsonValue(o.password                 ));
			if ( o.company             != null   ) json.AddValue("company"            , new JsonValue(o.company                  ));
			if ( o.prospect_account_id .HasValue ) json.AddValue("prospect_account_id", new JsonValue(o.prospect_account_id.Value));
			if ( o.website             != null   ) json.AddValue("website"            , new JsonValue(o.website                  ));
			if ( o.job_title           != null   ) json.AddValue("job_title"          , new JsonValue(o.job_title                ));
			if ( o.department          != null   ) json.AddValue("department"         , new JsonValue(o.department               ));
			if ( o.country             != null   ) json.AddValue("country"            , new JsonValue(o.country                  ));
			if ( o.address_one         != null   ) json.AddValue("address_one"        , new JsonValue(o.address_one              ));
			if ( o.address_two         != null   ) json.AddValue("address_two"        , new JsonValue(o.address_two              ));
			if ( o.city                != null   ) json.AddValue("city"               , new JsonValue(o.city                     ));
			if ( o.state               != null   ) json.AddValue("state"              , new JsonValue(o.state                    ));
			if ( o.territory           != null   ) json.AddValue("territory"          , new JsonValue(o.territory                ));
			if ( o.zip                 != null   ) json.AddValue("zip"                , new JsonValue(o.zip                      ));
			if ( o.phone               != null   ) json.AddValue("phone"              , new JsonValue(o.phone                    ));
			if ( o.fax                 != null   ) json.AddValue("fax"                , new JsonValue(o.fax                      ));
			if ( o.source              != null   ) json.AddValue("source"             , new JsonValue(o.source                   ));
			if ( o.annual_revenue      != null   ) json.AddValue("annual_revenue"     , new JsonValue(o.annual_revenue           ));
			if ( o.employees           != null   ) json.AddValue("employees"          , new JsonValue(o.employees                ));
			if ( o.industry            != null   ) json.AddValue("industry"           , new JsonValue(o.industry                 ));
			if ( o.years_in_business   != null   ) json.AddValue("years_in_business"  , new JsonValue(o.years_in_business        ));
			if ( o.comments            != null   ) json.AddValue("comments"           , new JsonValue(o.comments                 ));
			if ( o.notes               != null   ) json.AddValue("notes"              , new JsonValue(o.notes                    ));
			if ( o.score               .HasValue ) json.AddValue("score"              , new JsonValue(o.score              .Value));
			if ( o.is_do_not_email     .HasValue ) json.AddValue("is_do_not_email"    , new JsonValue(o.is_do_not_email    .Value ? 1 : 0));
			if ( o.is_do_not_call      .HasValue ) json.AddValue("is_do_not_call"     , new JsonValue(o.is_do_not_call     .Value ? 1 : 0));
			if ( o.is_reviewed         .HasValue ) json.AddValue("is_reviewed"        , new JsonValue(o.is_reviewed        .Value ? 1 : 0));
			if ( o.is_starred          .HasValue ) json.AddValue("is_starred"         , new JsonValue(o.is_starred         .Value ? 1 : 0));
			o.RawContent = json.ToString();
			// 07/16/2017 Paul.  For some unknown reason, data posted is in x-www-form-urlencoded format instead of json. 
			return json;
		}
	}
}
