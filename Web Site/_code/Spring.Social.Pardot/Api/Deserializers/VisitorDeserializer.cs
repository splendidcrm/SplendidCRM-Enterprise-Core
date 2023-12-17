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
	class VisitorDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			JsonUtils.FaultCheck(json);
			Visitor obj = new Visitor();
			obj.RawContent = json.ToString();
			System.Diagnostics.Debug.WriteLine(obj.RawContent);
			if ( json.ContainsName("visitor") )
			{
				json = json.GetValue("visitor");
			}
			
			obj.id         = json.GetValueOrDefault<int     >("id"        );
			obj.created_at = json.GetValueOrDefault<DateTime>("created_at");
			obj.updated_at = json.GetValueOrDefault<DateTime>("updated_at");
			if ( json.ContainsName("page_view_count"         ) ) obj.page_view_count          = json.GetValueOrDefault<int     >("page_view_count"         );
			if ( json.ContainsName("ip_address"              ) ) obj.ip_address               = json.GetValueOrDefault<String  >("ip_address"              );
			if ( json.ContainsName("hostname"                ) ) obj.hostname                 = json.GetValueOrDefault<String  >("hostname"                );
			if ( json.ContainsName("browser"                 ) ) obj.browser                  = json.GetValueOrDefault<String  >("browser"                 );
			if ( json.ContainsName("browser_version"         ) ) obj.browser_version          = json.GetValueOrDefault<String  >("browser_version"         );
			if ( json.ContainsName("operating_system"        ) ) obj.operating_system         = json.GetValueOrDefault<String  >("operating_system"        );
			if ( json.ContainsName("operating_system_version") ) obj.operating_system_version = json.GetValueOrDefault<String  >("operating_system_version");
			if ( json.ContainsName("language"                ) ) obj.language                 = json.GetValueOrDefault<String  >("language"                );
			if ( json.ContainsName("screen_height"           ) ) obj.screen_height            = json.GetValueOrDefault<String  >("screen_height"           );
			if ( json.ContainsName("screen_width"            ) ) obj.screen_width             = json.GetValueOrDefault<String  >("screen_width"            );
			if ( json.ContainsName("is_flash_enabled"        ) ) obj.is_flash_enabled         = json.GetValueOrDefault<bool    >("is_flash_enabled"        );
			if ( json.ContainsName("is_java_enabled"         ) ) obj.is_java_enabled          = json.GetValueOrDefault<bool    >("is_java_enabled"         );
			if ( json.ContainsName("campaign_parameter"      ) ) obj.campaign_parameter       = json.GetValueOrDefault<String  >("campaign_parameter"      );
			if ( json.ContainsName("medium_parameter"        ) ) obj.medium_parameter         = json.GetValueOrDefault<String  >("medium_parameter"        );
			if ( json.ContainsName("source_parameter"        ) ) obj.source_parameter         = json.GetValueOrDefault<String  >("source_parameter"        );
			if ( json.ContainsName("content_parameter"       ) ) obj.content_parameter        = json.GetValueOrDefault<String  >("content_parameter"       );
			if ( json.ContainsName("term_parameter"          ) ) obj.term_parameter           = json.GetValueOrDefault<String  >("term_parameter"          );
			if ( json.ContainsName("prospect_id"             ) )
			{
				int? prospect_id = json.GetValueOrDefault<int     >("prospect_id");
				if ( prospect_id.HasValue && prospect_id.Value > 0 )
				{
					obj.prospect = new Prospect();
					obj.prospect.id = json.GetValueOrDefault<int     >("prospect_id");
				}
			}
			if ( json.ContainsName("prospect") )
			{
				JsonValue jsonProspect = json.GetValue("prospect");
				if ( jsonProspect != null && !jsonProspect.IsNull )
				{
					obj.prospect = mapper.Deserialize<Prospect>(jsonProspect);
				}
			}
			if ( json.ContainsName("identified_company") )
			{
				JsonValue jsonCompany = json.GetValue("identified_company");
				if ( jsonCompany != null && !jsonCompany.IsNull )
				{
					obj.identified_company = new Visitor.Company();
					obj.identified_company.name           = jsonCompany.GetValueOrDefault<String  >("name"          );
					obj.identified_company.street_address = jsonCompany.GetValueOrDefault<String  >("street_address");
					obj.identified_company.city           = jsonCompany.GetValueOrDefault<String  >("city"          );
					obj.identified_company.state          = jsonCompany.GetValueOrDefault<String  >("state"         );
					obj.identified_company.postal_code    = jsonCompany.GetValueOrDefault<String  >("postal_code"   );
					obj.identified_company.country        = jsonCompany.GetValueOrDefault<String  >("country"       );
					obj.identified_company.email          = jsonCompany.GetValueOrDefault<String  >("email"         );
				}
			}
			if ( json.ContainsName("visitor_activities") )
			{
				JsonValue jsonVisitorActivities = json.GetValue("visitor_activities");
				if ( jsonVisitorActivities != null && !jsonVisitorActivities.IsNull )
				{
					obj.visitor_activities = mapper.Deserialize<IList<VisitorActivity>>(jsonVisitorActivities);
				}
			}
			return obj;
		}
	}

	class VisitorListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Visitor> items = new List<Visitor>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("visitor");
			if ( jsonResponse != null )
			{
				if ( jsonResponse.IsArray )
				{
					foreach ( JsonValue itemValue in jsonResponse.GetValues() )
					{
						items.Add( mapper.Deserialize<Visitor>(itemValue) );
					}
				}
				else
				{
					items.Add( mapper.Deserialize<Visitor>(jsonResponse) );
				}
			}
			return items;
		}
	}

	class VisitorPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			VisitorPagination pag = new VisitorPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.ContainsName("result") )
			{
				json = json.GetValue("result");
				pag.total = json.GetValueOrDefault<int>("total_results");
				pag.items = mapper.Deserialize<IList<Visitor>>(json);
			}
			return pag;
		}
	}
}
