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
	class VisitorActivityDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			VisitorActivity obj = new VisitorActivity();
			obj.RawContent = json.ToString();
			System.Diagnostics.Debug.WriteLine(obj.RawContent);
			if ( json.ContainsName("visitor_activity") )
			{
				json = json.GetValue("visitor_activity");
			}
			
			obj.id         = json.GetValueOrDefault<int     >("id"        );
			obj.created_at = json.GetValueOrDefault<DateTime>("created_at");
			if ( json.ContainsName("prospect_id"                   ) ) obj.prospect_id                    = json.GetValueOrDefault<int     >("prospect_id"                   );
			if ( json.ContainsName("visitor_id"                    ) ) obj.visitor_id                     = json.GetValueOrDefault<int     >("visitor_id"                    );
			if ( json.ContainsName("type"                          ) ) obj.type                           = json.GetValueOrDefault<int     >("type"                          );
			if ( json.ContainsName("type_name"                     ) ) obj.type_name                      = json.GetValueOrDefault<String  >("type_name"                     );
			if ( json.ContainsName("details"                       ) ) obj.details                        = json.GetValueOrDefault<String  >("details"                       );
			if ( json.ContainsName("email_id"                      ) ) obj.email_id                       = json.GetValueOrDefault<int     >("email_id"                      );
			if ( json.ContainsName("email_template_id"             ) ) obj.email_template_id              = json.GetValueOrDefault<int     >("email_template_id"             );
			if ( json.ContainsName("list_email_id"                 ) ) obj.list_email_id                  = json.GetValueOrDefault<int     >("list_email_id"                 );
			if ( json.ContainsName("form_id"                       ) ) obj.form_id                        = json.GetValueOrDefault<int     >("form_id"                       );
			if ( json.ContainsName("form_handler_id"               ) ) obj.form_handler_id                = json.GetValueOrDefault<int     >("form_handler_id"               );
			if ( json.ContainsName("site_search_query_id"          ) ) obj.site_search_query_id           = json.GetValueOrDefault<int     >("site_search_query_id"          );
			if ( json.ContainsName("landing_page_id"               ) ) obj.landing_page_id                = json.GetValueOrDefault<int     >("landing_page_id"               );
			if ( json.ContainsName("paid_search_id_id"             ) ) obj.paid_search_id_id              = json.GetValueOrDefault<int     >("paid_search_id_id"             );
			if ( json.ContainsName("multivariate_test_variation_id") ) obj.multivariate_test_variation_id = json.GetValueOrDefault<int     >("multivariate_test_variation_id");
			if ( json.ContainsName("visitor_page_view_id"          ) ) obj.visitor_page_view_id           = json.GetValueOrDefault<int     >("visitor_page_view_id"          );
			if ( json.ContainsName("file_id"                       ) ) obj.file_id                        = json.GetValueOrDefault<int     >("file_id"                       );
			if ( json.ContainsName("campaign") )
			{
				JsonValue jsonCampaign = json.GetValue("campaign");
				obj.campaign_id   = jsonCampaign.GetValueOrDefault<int     >("id"  );
				obj.campaign_name = jsonCampaign.GetValueOrDefault<string  >("name");
			}
			return obj;
		}
	}
	
	class VisitorActivityListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<VisitorActivity> items = new List<VisitorActivity>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("visitor_activity");
			if ( jsonResponse != null )
			{
				if ( jsonResponse.IsArray )
				{
					foreach ( JsonValue itemValue in jsonResponse.GetValues() )
					{
						items.Add( mapper.Deserialize<VisitorActivity>(itemValue) );
					}
				}
				else
				{
					items.Add( mapper.Deserialize<VisitorActivity>(jsonResponse) );
				}
			}
			return items;
		}
	}

}
