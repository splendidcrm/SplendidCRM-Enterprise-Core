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
	class OpportunitySerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Opportunity o = obj as Opportunity;
			
			// At the minimum, you must map the opportunity Name, Amount, Probability, Closed, Won, Email, and an External or Internal Identifier.
			JsonObject json = new JsonObject();
			if ( o.name                != null   ) json.AddValue("name"               , new JsonValue(o.name                     ));
			if ( o.value               .HasValue ) json.AddValue("value"              , new JsonValue(o.value              .Value));
			if ( o.probability         .HasValue ) json.AddValue("probability"        , new JsonValue(o.probability        .Value));
			if ( !Sql.IsEmptyString(o.type  )    ) json.AddValue("type"               , new JsonValue(o.type                     ));
			if ( !Sql.IsEmptyString(o.stage )    ) json.AddValue("stage"              , new JsonValue(o.stage                    ));
			if ( !Sql.IsEmptyString(o.status)    ) json.AddValue("status"             , new JsonValue(o.status                   ));
			if ( o.campaign_id         .HasValue ) json.AddValue("campaign_id"        , new JsonValue(o.campaign_id        .Value));
			if ( o.email               != null   ) json.AddValue("email"              , new JsonValue(o.email                    ));
			if ( o.crm_opportunity_fid != null   ) json.AddValue("crm_opportunity_fid", new JsonValue(o.crm_opportunity_fid      ));
			if ( o.is_closed           .HasValue ) json.AddValue("is_closed"          , new JsonValue(o.is_closed          .Value ? 1 : 0));
			if ( o.is_won              .HasValue ) json.AddValue("is_won"             , new JsonValue(o.is_won             .Value ? 1 : 0));
			if ( o.closed_at           .HasValue && o.closed_at != DateTime.MinValue )
				json.AddValue("closed_at", new JsonValue(o.closed_at.Value.ToString("yyyy-MM-dd")));
			o.RawContent = json.ToString();
			// 07/16/2017 Paul.  For some unknown reason, data posted is in x-www-form-urlencoded format instead of json. 
			return json;
		}
	}
}
