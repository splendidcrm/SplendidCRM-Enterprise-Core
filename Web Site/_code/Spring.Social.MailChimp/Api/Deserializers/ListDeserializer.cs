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

namespace Spring.Social.MailChimp.Api.Impl.Json
{
	class ListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			if ( json.ContainsName("lists") )
			{
				json = json.GetValue("lists");
			}
			Spring.Social.MailChimp.Api.List obj = new Spring.Social.MailChimp.Api.List();
			obj.RawContent = json.ToString();
			
			// 04/08/2016 Paul.  When less data than paginated request, then final entries have ID of 0. 
			string sID = json.GetValueOrDefault<string>("id");
			if ( sID == String.Empty || sID == "0" )
				return null;
			obj.id                    = json.GetValueOrDefault<String   >("id"                   );
			obj.date_created          = json.GetValueOrDefault<DateTime?>("date_created"         );
			// 04/16/2016 Paul.  MailChimp does not have a modified date field, so just use created date. 
			obj.lastmodifieddate      = json.GetValueOrDefault<DateTime?>("date_created"         );
			obj.created_by            = json.GetValueOrDefault<String   >("created_by"           );
			obj.name                  = json.GetValueOrDefault<String   >("name"                 );
			obj.permission_reminder   = json.GetValueOrDefault<String   >("permission_reminder"  );
			obj.use_archive_bar       = json.GetValueOrDefault<bool?    >("use_archive_bar"      );
			obj.notify_on_subscribe   = json.GetValueOrDefault<String   >("notify_on_subscribe"  );
			obj.notify_on_unsubscribe = json.GetValueOrDefault<String   >("notify_on_unsubscribe");
			obj.list_rating           = json.GetValueOrDefault<int?     >("list_rating"          );
			obj.email_type_option     = json.GetValueOrDefault<bool?    >("email_type_option"    );
			obj.subscribe_url_short   = json.GetValueOrDefault<String   >("subscribe_url_short"  );
			obj.subscribe_url_long    = json.GetValueOrDefault<String   >("subscribe_url_long"   );
			obj.beamer_address        = json.GetValueOrDefault<String   >("beamer_address"       );
			obj.visibility            = json.GetValueOrDefault<String   >("visibility"           );
			JsonValue jsonModules = json.GetValue("modules");
			if ( jsonModules != null && jsonModules.IsArray )
			{
				obj.modules = new List<String>();
				foreach ( JsonValue itemValue in jsonModules.GetValues() )
				{
					obj.modules.Add(itemValue.GetValue<string>());
				}
			}
			// Contact
			JsonValue jsonContact = json.GetValue("contact");
			if ( jsonContact != null )
			{
				obj.contact = new List.Contact();
				obj.contact.company                     = jsonContact.GetValueOrDefault<String  >("company"                      );
				obj.contact.address1                    = jsonContact.GetValueOrDefault<String  >("address1"                     );
				obj.contact.address2                    = jsonContact.GetValueOrDefault<String  >("address2"                     );
				obj.contact.city                        = jsonContact.GetValueOrDefault<String  >("city"                         );
				obj.contact.state                       = jsonContact.GetValueOrDefault<String  >("state"                        );
				obj.contact.zip                         = jsonContact.GetValueOrDefault<String  >("zip"                          );
				obj.contact.country                     = jsonContact.GetValueOrDefault<String  >("country"                      );
				obj.contact.phone                       = jsonContact.GetValueOrDefault<String  >("phone"                        );
			}
			// Campaign Defaults
			JsonValue jsonCampaignDefaults = json.GetValue("campaign_defaults");
			if ( jsonCampaignDefaults != null )
			{
				obj.campaign_defaults = new List.CampaignDefaults();
				obj.campaign_defaults.from_name         = jsonCampaignDefaults.GetValueOrDefault<String  >("from_name"                    );
				obj.campaign_defaults.from_email        = jsonCampaignDefaults.GetValueOrDefault<String  >("from_email"                   );
				obj.campaign_defaults.subject           = jsonCampaignDefaults.GetValueOrDefault<String  >("subject"                      );
				obj.campaign_defaults.language          = jsonCampaignDefaults.GetValueOrDefault<String  >("language"                     );
			}
			// Stats
			JsonValue jsonStats = json.GetValue("stats");
			if ( jsonStats != null )
			{
				obj.stats = new List.Stats();
				obj.stats.member_count                  = jsonStats.GetValueOrDefault<int?     >("member_count"                 );
				obj.stats.unsubscribe_count             = jsonStats.GetValueOrDefault<int?     >("unsubscribe_count"            );
				obj.stats.cleaned_count                 = jsonStats.GetValueOrDefault<int?     >("cleaned_count"                );
				obj.stats.member_count_since_send       = jsonStats.GetValueOrDefault<int?     >("member_count_since_send"      );
				obj.stats.unsubscribe_count_since_send  = jsonStats.GetValueOrDefault<int?     >("unsubscribe_count_since_send" );
				obj.stats.cleaned_count_since_send      = jsonStats.GetValueOrDefault<int?     >("cleaned_count_since_send"     );
				obj.stats.campaign_count                = jsonStats.GetValueOrDefault<int?     >("campaign_count"               );
				obj.stats.merge_field_count             = jsonStats.GetValueOrDefault<int?     >("merge_field_count"            );
				obj.stats.avg_sub_rate                  = jsonStats.GetValueOrDefault<Decimal? >("avg_sub_rate"                 );
				obj.stats.avg_unsub_rate                = jsonStats.GetValueOrDefault<Decimal? >("avg_unsub_rate"               );
				obj.stats.target_sub_rate               = jsonStats.GetValueOrDefault<Decimal? >("target_sub_rate"              );
				obj.stats.open_rate                     = jsonStats.GetValueOrDefault<Decimal? >("open_rate"                    );
				obj.stats.click_rate                    = jsonStats.GetValueOrDefault<Decimal? >("click_rate"                   );
				if ( !String.IsNullOrEmpty(jsonStats.GetValueOrDefault<String>("campaign_last_sent")) ) obj.stats.campaign_last_sent = jsonStats.GetValueOrDefault<DateTime?>("campaign_last_sent");
				if ( !String.IsNullOrEmpty(jsonStats.GetValueOrDefault<String>("last_sub_date"     )) ) obj.stats.last_sub_date      = jsonStats.GetValueOrDefault<DateTime?>("last_sub_date"     );
				if ( !String.IsNullOrEmpty(jsonStats.GetValueOrDefault<String>("last_unsub_date"   )) ) obj.stats.last_unsub_date    = jsonStats.GetValueOrDefault<DateTime?>("last_unsub_date"   );
			}
			return obj;
		}
	}

	class ListListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Spring.Social.MailChimp.Api.List> items = new List<Spring.Social.MailChimp.Api.List>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("lists");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					Spring.Social.MailChimp.Api.List item = mapper.Deserialize<Spring.Social.MailChimp.Api.List>(itemValue);
					// 04/08/2016 Paul.  When less data than paginated request, then final entries have ID of 0. 
					if ( item != null && !String.IsNullOrEmpty(item.id) )
						items.Add(item);
				}
			}
			return items;
		}
	}

	class ListPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ListPagination pag = new ListPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				pag.total  = json.GetValueOrDefault<int>("total_items");
				pag.items  = mapper.Deserialize<IList<Spring.Social.MailChimp.Api.List>>(json);
			}
			return pag;
		}
	}
}
