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
	class ProspectDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			JsonUtils.FaultCheck(json);
			Prospect obj = new Prospect();
			obj.RawContent = json.ToString();
			System.Diagnostics.Debug.WriteLine(obj.RawContent);
			if ( json.ContainsName("prospect") )
			{
				json = json.GetValue("prospect");
			}
			
			obj.id         = json.GetValueOrDefault<int     >("id"        );
			obj.created_at = json.GetValueOrDefault<DateTime>("created_at");
			obj.updated_at = json.GetValueOrDefault<DateTime>("updated_at");
			if ( json.ContainsName("salutation"         ) ) obj.salutation          = json.GetValueOrDefault<String  >("salutation"         );
			if ( json.ContainsName("first_name"         ) ) obj.first_name          = json.GetValueOrDefault<String  >("first_name"         );
			if ( json.ContainsName("last_name"          ) ) obj.last_name           = json.GetValueOrDefault<String  >("last_name"          );
			if ( json.ContainsName("email"              ) ) obj.email               = json.GetValueOrDefault<String  >("email"              );
			if ( json.ContainsName("password"           ) ) obj.password            = json.GetValueOrDefault<String  >("password"           );
			if ( json.ContainsName("company"            ) ) obj.company             = json.GetValueOrDefault<String  >("company"            );
			if ( json.ContainsName("prospect_account_id") ) obj.prospect_account_id = json.GetValueOrDefault<int     >("prospect_account_id");
			if ( json.ContainsName("website"            ) ) obj.website             = json.GetValueOrDefault<String  >("website"            );
			if ( json.ContainsName("job_title"          ) ) obj.job_title           = json.GetValueOrDefault<String  >("job_title"          );
			if ( json.ContainsName("department"         ) ) obj.department          = json.GetValueOrDefault<String  >("department"         );
			if ( json.ContainsName("country"            ) ) obj.country             = json.GetValueOrDefault<String  >("country"            );
			if ( json.ContainsName("address_one"        ) ) obj.address_one         = json.GetValueOrDefault<String  >("address_one"        );
			if ( json.ContainsName("address_two"        ) ) obj.address_two         = json.GetValueOrDefault<String  >("address_two"        );
			if ( json.ContainsName("city"               ) ) obj.city                = json.GetValueOrDefault<String  >("city"               );
			if ( json.ContainsName("state"              ) ) obj.state               = json.GetValueOrDefault<String  >("state"              );
			if ( json.ContainsName("territory"          ) ) obj.territory           = json.GetValueOrDefault<String  >("territory"          );
			if ( json.ContainsName("zip"                ) ) obj.zip                 = json.GetValueOrDefault<String  >("zip"                );
			if ( json.ContainsName("phone"              ) ) obj.phone               = json.GetValueOrDefault<String  >("phone"              );
			if ( json.ContainsName("fax"                ) ) obj.fax                 = json.GetValueOrDefault<String  >("fax"                );
			if ( json.ContainsName("source"             ) ) obj.source              = json.GetValueOrDefault<String  >("source"             );
			if ( json.ContainsName("annual_revenue"     ) ) obj.annual_revenue      = json.GetValueOrDefault<String  >("annual_revenue"     );
			if ( json.ContainsName("employees"          ) ) obj.employees           = json.GetValueOrDefault<String  >("employees"          );
			if ( json.ContainsName("industry"           ) ) obj.industry            = json.GetValueOrDefault<String  >("industry"           );
			if ( json.ContainsName("years_in_business"  ) ) obj.years_in_business   = json.GetValueOrDefault<String  >("years_in_business"  );
			if ( json.ContainsName("comments"           ) ) obj.comments            = json.GetValueOrDefault<String  >("comments"           );
			if ( json.ContainsName("notes"              ) ) obj.notes               = json.GetValueOrDefault<String  >("notes"              );
			if ( json.ContainsName("score"              ) ) obj.score               = json.GetValueOrDefault<int     >("score"              );
			if ( json.ContainsName("grade"              ) ) obj.grade               = json.GetValueOrDefault<String  >("grade"              );
			if ( json.ContainsName("recent_interaction" ) ) obj.recent_interaction  = json.GetValueOrDefault<String  >("recent_interaction" );
			if ( json.ContainsName("crm_lead_fid"       ) ) obj.crm_lead_fid        = json.GetValueOrDefault<String  >("crm_lead_fid"       );
			if ( json.ContainsName("crm_contact_fid"    ) ) obj.crm_contact_fid     = json.GetValueOrDefault<String  >("crm_contact_fid"    );
			if ( json.ContainsName("crm_owner_fid"      ) ) obj.crm_owner_fid       = json.GetValueOrDefault<String  >("crm_owner_fid"      );
			if ( json.ContainsName("crm_account_fid"    ) ) obj.crm_account_fid     = json.GetValueOrDefault<String  >("crm_account_fid"    );
			if ( json.ContainsName("crm_last_sync"      ) ) obj.crm_last_sync       = json.GetValueOrDefault<DateTime>("crm_last_sync"      );
			if ( json.ContainsName("crm_url"            ) ) obj.crm_url             = json.GetValueOrDefault<String  >("crm_url"            );
			if ( json.ContainsName("is_do_not_email"    ) ) obj.is_do_not_email     = json.GetValueOrDefault<int     >("is_do_not_email"    ) == 1;
			if ( json.ContainsName("is_do_not_call"     ) ) obj.is_do_not_call      = json.GetValueOrDefault<int     >("is_do_not_call"     ) == 1;
			if ( json.ContainsName("opted_out"          ) ) obj.opted_out           = json.GetValueOrDefault<int     >("opted_out"          ) == 1;
			if ( json.ContainsName("is_reviewed"        ) ) obj.is_reviewed         = json.GetValueOrDefault<int     >("is_reviewed"        ) == 1;
			if ( json.ContainsName("is_starred"         ) ) obj.is_starred          = json.GetValueOrDefault<int     >("is_starred"         ) == 1;
			if ( json.ContainsName("campaign_id"        ) ) obj.campaign_id         = json.GetValueOrDefault<int     >("campaign_id"        );
			if ( json.ContainsName("last_activity_at"   ) ) obj.last_activity_at    = json.GetValueOrDefault<DateTime>("last_activity_at"   );
			if ( json.ContainsName("campaign") )
			{
				JsonValue jsonCampaign = json.GetValue("campaign");
				if ( jsonCampaign != null && !jsonCampaign.IsNull )
				{
					obj.campaign_name = jsonCampaign.GetValueOrDefault<string  >("name");
				}
			}
			if ( json.ContainsName("last_activity") )
			{
				JsonValue jsonLastActivity = json.GetValue("last_activity");
				if ( jsonLastActivity != null && !jsonLastActivity.IsNull )
				{
					obj.last_activity = mapper.Deserialize<VisitorActivity>(jsonLastActivity);
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

	class ProspectListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Prospect> items = new List<Prospect>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("prospect");
			if ( jsonResponse != null )
			{
				if ( jsonResponse.IsArray )
				{
					foreach ( JsonValue itemValue in jsonResponse.GetValues() )
					{
						items.Add( mapper.Deserialize<Prospect>(itemValue) );
					}
				}
				else
				{
					items.Add( mapper.Deserialize<Prospect>(jsonResponse) );
				}
			}
			return items;
		}
	}

	class ProspectPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ProspectPagination pag = new ProspectPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.ContainsName("result") )
			{
				json = json.GetValue("result");
				pag.total = json.GetValueOrDefault<int>("total_results");
				pag.items = mapper.Deserialize<IList<Prospect>>(json);
			}
			return pag;
		}
	}
}
