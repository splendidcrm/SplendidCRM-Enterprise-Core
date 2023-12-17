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
	class ContactDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Contact obj = new Contact();
			obj.RawContent = json.ToString();
			DateTime addedAt = JsonUtils.FromUnixTicks(json.GetValueOrDefault<string>("addedAt"));
			
			// 09/28/2020 Paul.  Must use long values. 
			obj.id        = json.GetValueOrDefault<long>("vid"      );
			obj.isDeleted = json.GetValueOrDefault<bool>("isDeleted");
			if ( json.ContainsName("properties") )
			{
				JsonValue jsonProperties = json.GetValue("properties");
				obj.createdate                                    = JsonUtils.GetPropertiesDateTime(jsonProperties, "createdate"                                    );
				obj.lastmodifieddate                              = JsonUtils.GetPropertiesDateTime(jsonProperties, "lastmodifieddate"                              );
				obj.hubspot_owner_id                              = JsonUtils.GetPropertiesInteger (jsonProperties, "hubspot_owner_id"                              );
				obj.firstname                                     = JsonUtils.GetPropertiesString  (jsonProperties, "firstname"                                     );
				obj.lastname                                      = JsonUtils.GetPropertiesString  (jsonProperties, "lastname"                                      );
				obj.salutation                                    = JsonUtils.GetPropertiesString  (jsonProperties, "salutation"                                    );
				obj.email                                         = JsonUtils.GetPropertiesString  (jsonProperties, "email"                                         );
				obj.phone                                         = JsonUtils.GetPropertiesString  (jsonProperties, "phone"                                         );
				obj.mobilephone                                   = JsonUtils.GetPropertiesString  (jsonProperties, "mobilephone"                                   );
				obj.fax                                           = JsonUtils.GetPropertiesString  (jsonProperties, "fax"                                           );
				obj.address                                       = JsonUtils.GetPropertiesString  (jsonProperties, "address"                                       );
				obj.city                                          = JsonUtils.GetPropertiesString  (jsonProperties, "city"                                          );
				obj.state                                         = JsonUtils.GetPropertiesString  (jsonProperties, "state"                                         );
				obj.zip                                           = JsonUtils.GetPropertiesString  (jsonProperties, "zip"                                           );
				obj.country                                       = JsonUtils.GetPropertiesString  (jsonProperties, "country"                                       );
				obj.jobtitle                                      = JsonUtils.GetPropertiesString  (jsonProperties, "jobtitle"                                      );
				obj.closedate                                     = JsonUtils.GetPropertiesDateTime(jsonProperties, "closedate"                                     );
				obj.lifecyclestage                                = JsonUtils.GetPropertiesString  (jsonProperties, "lifecyclestage"                                );
				obj.website                                       = JsonUtils.GetPropertiesString  (jsonProperties, "website"                                       );
				obj.company                                       = JsonUtils.GetPropertiesString  (jsonProperties, "company"                                       );
				obj.message                                       = JsonUtils.GetPropertiesString  (jsonProperties, "message"                                       );
				obj.photo                                         = JsonUtils.GetPropertiesString  (jsonProperties, "photo"                                         );
				obj.numemployees                                  = JsonUtils.GetPropertiesString  (jsonProperties, "numemployees"                                  );
				obj.annualrevenue                                 = JsonUtils.GetPropertiesString  (jsonProperties, "annualrevenue"                                 );
				obj.industry                                      = JsonUtils.GetPropertiesString  (jsonProperties, "industry"                                      );
				obj.hs_persona                                    = JsonUtils.GetPropertiesString  (jsonProperties, "hs_persona"                                    );
				obj.hs_facebookid                                 = JsonUtils.GetPropertiesString  (jsonProperties, "hs_facebookid"                                 );
				obj.hs_googleplusid                               = JsonUtils.GetPropertiesString  (jsonProperties, "hs_googleplusid"                               );
				obj.hs_linkedinid                                 = JsonUtils.GetPropertiesString  (jsonProperties, "hs_linkedinid"                                 );
				obj.hs_twitterid                                  = JsonUtils.GetPropertiesString  (jsonProperties, "hs_twitterid"                                  );
				obj.twitterhandle                                 = JsonUtils.GetPropertiesString  (jsonProperties, "twitterhandle"                                 );
				obj.twitterprofilephoto                           = JsonUtils.GetPropertiesString  (jsonProperties, "twitterprofilephoto"                           );
				obj.linkedinbio                                   = JsonUtils.GetPropertiesString  (jsonProperties, "linkedinbio"                                   );
				obj.twitterbio                                    = JsonUtils.GetPropertiesString  (jsonProperties, "twitterbio"                                    );
				obj.blog_default_hubspot_blog_subscription        = JsonUtils.GetPropertiesString  (jsonProperties, "blog_default_hubspot_blog_subscription"        );
				obj.followercount                                 = JsonUtils.GetPropertiesInteger (jsonProperties, "followercount"                                 );
				obj.linkedinconnections                           = JsonUtils.GetPropertiesInteger (jsonProperties, "linkedinconnections"                           );
				obj.kloutscoregeneral                             = JsonUtils.GetPropertiesInteger (jsonProperties, "kloutscoregeneral"                             );
				obj.associatedcompanyid                           = JsonUtils.GetPropertiesInteger (jsonProperties, "associatedcompanyid"                           );
				// read-only 
				obj.days_to_close                                 = JsonUtils.GetPropertiesInteger (jsonProperties, "days_to_close"                                 );
				obj.first_conversion_date                         = JsonUtils.GetPropertiesDateTime(jsonProperties, "first_conversion_date"                         );
				obj.first_conversion_event_name                   = JsonUtils.GetPropertiesString  (jsonProperties, "first_conversion_event_name"                   );
				obj.hs_emailconfirmationstatus                    = JsonUtils.GetPropertiesString  (jsonProperties, "hs_emailconfirmationstatus"                    );
				obj.hubspot_owner_assigneddate                    = JsonUtils.GetPropertiesDateTime(jsonProperties, "hubspot_owner_assigneddate"                    );
				obj.ipaddress                                     = JsonUtils.GetPropertiesString  (jsonProperties, "ipaddress"                                     );
				obj.ip_city                                       = JsonUtils.GetPropertiesString  (jsonProperties, "ip_city"                                       );
				obj.ip_country                                    = JsonUtils.GetPropertiesString  (jsonProperties, "ip_country"                                    );
				obj.ip_latlon                                     = JsonUtils.GetPropertiesString  (jsonProperties, "ip_latlon"                                     );
				obj.ip_state                                      = JsonUtils.GetPropertiesString  (jsonProperties, "ip_state"                                      );
				obj.num_conversion_events                         = JsonUtils.GetPropertiesInteger (jsonProperties, "num_conversion_events"                         );
				obj.num_unique_conversion_events                  = JsonUtils.GetPropertiesInteger (jsonProperties, "num_unique_conversion_events"                  );
				obj.hs_email_delivered                            = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_email_delivered"                            );
				obj.hs_email_open                                 = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_email_open"                                 );
				obj.hs_email_click                                = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_email_click"                                );
				obj.hs_email_bounce                               = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_email_bounce"                               );
				obj.hs_email_optout                               = JsonUtils.GetPropertiesBoolean (jsonProperties, "hs_email_optout"                               );
				obj.hs_email_is_ineligible                        = JsonUtils.GetPropertiesBoolean (jsonProperties, "hs_email_is_ineligible"                        );
				obj.hs_email_last_email_name                      = JsonUtils.GetPropertiesString  (jsonProperties, "hs_email_last_email_name"                      );
				obj.hs_email_first_send_date                      = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_email_first_send_date"                      );
				obj.hs_email_last_send_date                       = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_email_last_send_date"                       );
				obj.hs_email_first_open_date                      = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_email_first_open_date"                      );
				obj.hs_email_last_open_date                       = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_email_last_open_date"                       );
				obj.hs_email_first_click_date                     = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_email_first_click_date"                     );
				obj.hs_email_last_click_date                      = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_email_last_click_date"                      );
				obj.hs_email_lastupdated                          = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_email_lastupdated"                          );
				obj.hs_analytics_source                           = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_source"                           );
				obj.hs_analytics_source_data_1                    = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_source_data_1"                    );
				obj.hs_analytics_source_data_2                    = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_source_data_2"                    );
				obj.hs_analytics_first_referrer                   = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_first_referrer"                   );
				obj.hs_analytics_last_referrer                    = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_last_referrer"                    );
				obj.hs_analytics_num_page_views                   = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_analytics_num_page_views"                   );
				obj.hs_analytics_num_visits                       = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_analytics_num_visits"                       );
				obj.hs_analytics_num_event_completions            = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_analytics_num_event_completions"            );
				obj.hs_analytics_average_page_views               = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_average_page_views"               );
				obj.hs_analytics_first_timestamp                  = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_analytics_first_timestamp"                  );
				obj.hs_analytics_last_timestamp                   = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_analytics_last_timestamp"                   );
				obj.hs_analytics_first_visit_timestamp            = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_analytics_first_visit_timestamp"            );
				obj.hs_analytics_last_visit_timestamp             = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_analytics_last_visit_timestamp"             );
				obj.hs_analytics_first_url                        = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_first_url"                        );
				obj.hs_analytics_last_url                         = JsonUtils.GetPropertiesString  (jsonProperties, "hs_analytics_last_url"                         );
				obj.hs_analytics_revenue                          = JsonUtils.GetPropertiesDecimal (jsonProperties, "hs_analytics_revenue"                          );
				obj.hs_social_twitter_clicks                      = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_social_twitter_clicks"                      );
				obj.hs_social_facebook_clicks                     = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_social_facebook_clicks"                     );
				obj.hs_social_linkedin_clicks                     = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_social_linkedin_clicks"                     );
				obj.hs_social_google_plus_clicks                  = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_social_google_plus_clicks"                  );
				obj.hs_social_num_broadcast_clicks                = JsonUtils.GetPropertiesInteger (jsonProperties, "hs_social_num_broadcast_clicks"                );
				obj.hs_social_last_engagement                     = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_social_last_engagement"                     );
				obj.recent_conversion_date                        = JsonUtils.GetPropertiesDateTime(jsonProperties, "recent_conversion_date"                        );
				obj.recent_conversion_event_name                  = JsonUtils.GetPropertiesString  (jsonProperties, "recent_conversion_event_name"                  );
				obj.surveymonkeyeventlastupdated                  = JsonUtils.GetPropertiesString  (jsonProperties, "surveymonkeyeventlastupdated"                  );
				obj.webinareventlastupdated                       = JsonUtils.GetPropertiesString  (jsonProperties, "webinareventlastupdated"                       );
				obj.hs_lifecyclestage_lead_date                   = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_lifecyclestage_lead_date"                   );
				obj.hs_lifecyclestage_marketingqualifiedlead_date = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_lifecyclestage_marketingqualifiedlead_date" );
				obj.hs_lifecyclestage_opportunity_date            = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_lifecyclestage_opportunity_date"            );
				obj.hs_lifecyclestage_salesqualifiedlead_date     = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_lifecyclestage_salesqualifiedlead_date"     );
				obj.hs_lifecyclestage_evangelist_date             = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_lifecyclestage_evangelist_date"             );
				obj.hs_lifecyclestage_customer_date               = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_lifecyclestage_customer_date"               );
				obj.hs_lifecyclestage_subscriber_date             = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_lifecyclestage_subscriber_date"             );
				obj.hs_lifecyclestage_other_date                  = JsonUtils.GetPropertiesDateTime(jsonProperties, "hs_lifecyclestage_other_date"                  );
				obj.associatedcompanylastupdated                  = JsonUtils.GetPropertiesDateTime(jsonProperties, "associatedcompanylastupdated"                  );
				obj.currentlyinworkflow                           = JsonUtils.GetPropertiesBoolean (jsonProperties, "currentlyinworkflow"                           );
				obj.hubspotscore                                  = JsonUtils.GetPropertiesInteger (jsonProperties, "hubspotscore"                                  );
			}
			return obj;
		}
	}

	class ContactListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Contact> items = new List<Contact>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("contacts");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					items.Add( mapper.Deserialize<Contact>(itemValue) );
				}
			}
			return items;
		}
	}

	class ContactPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ContactPagination pag = new ContactPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				// 09/28/2020 Paul.  Must use long values. 
				pag.offset     = json.GetValueOrDefault<long>("offset"     );
				pag.hasmore    = json.GetValueOrDefault<bool>("has-more"   );
				pag.timeoffset = json.GetValueOrDefault<long>("time-offset");
				pag.items      = mapper.Deserialize<IList<Contact>>(json);
			}
			return pag;
		}
	}
}
