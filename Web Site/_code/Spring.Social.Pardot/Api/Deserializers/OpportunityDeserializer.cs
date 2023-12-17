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

namespace Spring.Social.Pardot.Api.Impl.Json
{
	class OpportunityDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			JsonUtils.FaultCheck(json);
			Opportunity obj = new Opportunity();
			obj.RawContent = json.ToString();
			System.Diagnostics.Debug.WriteLine(obj.RawContent);
			if ( json.ContainsName("opportunity") )
			{
				json = json.GetValue("opportunity");
			}
			
			obj.id         = json.GetValueOrDefault<int     >("id"        );
			obj.created_at = json.GetValueOrDefault<DateTime>("created_at");
			obj.updated_at = json.GetValueOrDefault<DateTime>("updated_at");
			if ( json.ContainsName("name"               ) ) obj.name                = json.GetValueOrDefault<String  >("name"               );
			if ( json.ContainsName("value"              ) ) obj.value               = json.GetValueOrDefault<Double  >("value"              );
			if ( json.ContainsName("probability"        ) ) obj.probability         = json.GetValueOrDefault<int     >("probability"        );
			if ( json.ContainsName("type"               ) ) obj.type                = json.GetValueOrDefault<String  >("type"               );
			if ( json.ContainsName("stage"              ) ) obj.stage               = json.GetValueOrDefault<String  >("stage"              );
			if ( json.ContainsName("status"             ) ) obj.status              = json.GetValueOrDefault<String  >("status"             );
			if ( json.ContainsName("closed_at"          ) ) obj.closed_at           = json.GetValueOrDefault<DateTime>("closed_at"          );
			if ( json.ContainsName("campaign_id"        ) ) obj.campaign_id         = json.GetValueOrDefault<int     >("campaign_id"        );
			if ( json.ContainsName("email"              ) ) obj.email               = json.GetValueOrDefault<String  >("email"              );
			if ( json.ContainsName("crm_opportunity_fid") ) obj.crm_opportunity_fid = json.GetValueOrDefault<String  >("crm_opportunity_fid");
			if ( json.ContainsName("is_closed"          ) ) obj.is_closed           = json.GetValueOrDefault<int     >("is_closed"          ) == 1;
			if ( json.ContainsName("is_won"             ) ) obj.is_won              = json.GetValueOrDefault<int     >("is_won"             ) == 1;
			if ( json.ContainsName("prospects") )
			{
				JsonValue jsonProspects = json.GetValue("prospects");
				if ( jsonProspects != null && !jsonProspects.IsNull )
				{
					obj.prospect = mapper.Deserialize<Prospect>(jsonProspects);
					if ( obj.prospect != null )
					{
						obj.email = obj.prospect.email;
					}
				}
			}
			if ( json.ContainsName("campaign") )
			{
				JsonValue jsonCampaign = json.GetValue("campaign");
				if ( jsonCampaign != null && !jsonCampaign.IsNull )
				{
					obj.campaign_id   = jsonCampaign.GetValueOrDefault<int     >("id"  );
					obj.campaign_name = jsonCampaign.GetValueOrDefault<string  >("name");
				}
			}
			if ( json.ContainsName("opportunity_activities") )
			{
				JsonValue jsonVisitorActivities = json.GetValue("opportunity_activities");
				if ( jsonVisitorActivities != null && !jsonVisitorActivities.IsNull )
				{
					obj.visitor_activities = mapper.Deserialize<IList<VisitorActivity>>(jsonVisitorActivities);
				}
			}
			return obj;
		}
	}

	class OpportunityListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Opportunity> items = new List<Opportunity>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("opportunity");
			if ( jsonResponse != null )
			{
				if ( jsonResponse.IsArray )
				{
					foreach ( JsonValue itemValue in jsonResponse.GetValues() )
					{
						items.Add( mapper.Deserialize<Opportunity>(itemValue) );
					}
				}
				else
				{
					items.Add( mapper.Deserialize<Opportunity>(jsonResponse) );
				}
			}
			return items;
		}
	}

	class OpportunityPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			OpportunityPagination pag = new OpportunityPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.ContainsName("result") )
			{
				json = json.GetValue("result");
				pag.total = json.GetValueOrDefault<int>("total_results");
				pag.items = mapper.Deserialize<IList<Opportunity>>(json);
			}
			return pag;
		}
	}
}
