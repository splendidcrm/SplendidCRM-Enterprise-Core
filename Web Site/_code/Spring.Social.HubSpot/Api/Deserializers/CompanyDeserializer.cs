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

namespace Spring.Social.HubSpot.Api.Impl.Json
{
	class CompanyDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Company obj = new Company();
			obj.RawContent = json.ToString();
			DateTime addedAt = JsonUtils.FromUnixTicks(json.GetValueOrDefault<string>("addedAt"));
			
			// 09/28/2020 Paul.  Must use long values. 
			obj.id        = json.GetValueOrDefault<long>("companyId");
			obj.isDeleted = json.GetValueOrDefault<bool>("isDeleted");
			if ( json.ContainsName("properties") )
			{
				JsonValue jsonProperties = json.GetValue("properties");
				obj.createdate                         = JsonUtils.GetPropertiesDateTime(jsonProperties, "createdate"                        );
				obj.lastmodifieddate                   = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_lastmodifieddate"               );
				obj.hubspot_owner_id                   = JsonUtils.GetPropertiesInteger (jsonProperties, "hubspot_owner_id"                  );
				obj.hubspot_owner_assigneddate         = JsonUtils.GetPropertiesDateTime(jsonProperties, "hubspot_owner_assigneddate"        );
				obj.name                               = JsonUtils.GetPropertiesString  (jsonProperties, "name"                              );
				obj.phone                              = JsonUtils.GetPropertiesString  (jsonProperties, "phone"                             );
				obj.address                            = JsonUtils.GetPropertiesString  (jsonProperties, "address"                           );
				obj.address2                           = JsonUtils.GetPropertiesString  (jsonProperties, "address2"                          );
				obj.city                               = JsonUtils.GetPropertiesString  (jsonProperties, "city"                              );
				obj.state                              = JsonUtils.GetPropertiesString  (jsonProperties, "state"                             );
				obj.zip                                = JsonUtils.GetPropertiesString  (jsonProperties, "zip"                               );
				obj.country                            = JsonUtils.GetPropertiesString  (jsonProperties, "country"                           );
				obj.timezone                           = JsonUtils.GetPropertiesString  (jsonProperties, "timezone"                          );
				obj.website                            = JsonUtils.GetPropertiesString  (jsonProperties, "website"                           );
				obj.domain                             = JsonUtils.GetPropertiesString  (jsonProperties, "domain"                            );
				obj.about_us                           = JsonUtils.GetPropertiesString  (jsonProperties, "about_us"                          );
				obj.founded_year                       = JsonUtils.GetPropertiesString  (jsonProperties, "founded_year"                      );
				obj.is_public                          = JsonUtils.GetPropertiesBoolean (jsonProperties, "is_public"                         );
				obj.numberofemployees                  = JsonUtils.GetPropertiesInteger (jsonProperties, "numberofemployees"                 );
				obj.industry                           = JsonUtils.GetPropertiesString  (jsonProperties, "industry"                          );
				obj.type                               = JsonUtils.GetPropertiesString  (jsonProperties, "type"                              );
				obj.description                        = JsonUtils.GetPropertiesString  (jsonProperties, "description"                       );
				obj.total_money_raised                 = JsonUtils.GetPropertiesString  (jsonProperties, "total_money_raised"                );
				obj.annualrevenue                      = JsonUtils.GetPropertiesDecimal (jsonProperties, "annualrevenue"                     );
				obj.closedate                          = JsonUtils.GetPropertiesDateTime(jsonProperties, "closedate"                         );
				obj.lifecyclestage                     = JsonUtils.GetPropertiesString  (jsonProperties, "lifecyclestage"                    );
				obj.hs_lead_status                     = JsonUtils.GetPropertiesString  (jsonProperties, "hs_lead_status"                    );
				obj.twitterhandle                      = JsonUtils.GetPropertiesString  (jsonProperties, "twitterhandle"                     );
				obj.twitterbio                         = JsonUtils.GetPropertiesString  (jsonProperties, "twitterbio"                        );
				obj.twitterfollowers                   = JsonUtils.GetPropertiesInteger (jsonProperties, "twitterfollowers"                  );
				obj.facebook_company_page              = JsonUtils.GetPropertiesString  (jsonProperties, "facebook_company_page"             );
				obj.facebookfans                       = JsonUtils.GetPropertiesInteger (jsonProperties, "facebookfans"                      );
				obj.linkedin_company_page              = JsonUtils.GetPropertiesString  (jsonProperties, "linkedin_company_page"             );
				obj.linkedinbio                        = JsonUtils.GetPropertiesString  (jsonProperties, "linkedinbio"                       );
				obj.googleplus_page                    = JsonUtils.GetPropertiesString  (jsonProperties, "googleplus_page"                   );
				// read-only 
				obj.days_to_close                      = JsonUtils.GetPropertiesInteger (jsonProperties, "days_to_close"                     );
				obj.first_contact_createdate           = JsonUtils.GetPropertiesDateTime(jsonProperties, "first_contact_createdate"          );
				obj.first_conversion_date              = JsonUtils.GetPropertiesDateTime(jsonProperties, "first_conversion_date"             );
				obj.first_conversion_event_name        = JsonUtils.GetPropertiesString  (jsonProperties, "first_conversion_event_name"       );
				obj.hs_analytics_source                = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_source"               );
				obj.hs_analytics_source_data_1         = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_source_data_1"        );
				obj.hs_analytics_source_data_2         = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_source_data_2"        );
				obj.hs_analytics_first_timestamp       = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_analytics_first_timestamp"      );
				obj.hs_analytics_last_timestamp        = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_analytics_last_timestamp"       );
				obj.hs_analytics_first_visit_timestamp = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_analytics_first_visit_timestamp");
				obj.hs_analytics_last_visit_timestamp  = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_analytics_last_visit_timestamp" );
				obj.hs_analytics_num_page_views        = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_analytics_num_page_views"       );
				obj.hs_analytics_num_visits            = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_analytics_num_visits"           );
				obj.num_conversion_events              = JsonUtils.GetPropertiesInteger (jsonProperties, "num_conversion_events"             );
				obj.recent_conversion_date             = JsonUtils.GetPropertiesDateTime(jsonProperties, "recent_conversion_date"            );
				obj.recent_conversion_event_name       = JsonUtils.GetPropertiesString  (jsonProperties, "recent_conversion_event_name"      );
				obj.hubspotscore                       = JsonUtils.GetPropertiesInteger (jsonProperties, "hubspotscore"                      );
			}
			return obj;
		}
	}

	class CompanyListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Company> items = new List<Company>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("companies");
			if ( jsonResponse == null )
				jsonResponse = json.GetValue("results");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					items.Add( mapper.Deserialize<Company>(itemValue) );
				}
			}
			return items;
		}
	}

	class CompanyPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			CompanyPagination pag = new CompanyPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				// 09/28/2020 Paul.  Must use long values. 
				pag.offset     = json.GetValueOrDefault<long>("offset"     );
				pag.total      = json.GetValueOrDefault<long>("total"      );
				pag.hasmore    = json.GetValueOrDefault<bool>("has-more"   );
				pag.timeoffset = json.GetValueOrDefault<long>("time-offset");
				pag.items      = mapper.Deserialize<IList<Company>>(json);
			}
			return pag;
		}
	}
}
