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
	class ListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Spring.Social.MailChimp.Api.List o = obj as Spring.Social.MailChimp.Api.List;
			
			JsonObject json = new JsonObject();
			if ( !String.IsNullOrEmpty(o.name                 ) ) json.AddValue("name"                 , new JsonValue(o.name                       ));
			if ( !String.IsNullOrEmpty(o.permission_reminder  ) ) json.AddValue("permission_reminder"  , new JsonValue(o.permission_reminder        ));
			if ( o.email_type_option.HasValue                   ) json.AddValue("email_type_option"    , new JsonValue(o.email_type_option    .Value));
			if ( o.use_archive_bar.HasValue                     ) json.AddValue("use_archive_bar"      , new JsonValue(o.use_archive_bar      .Value));
			if ( !String.IsNullOrEmpty(o.notify_on_subscribe  ) ) json.AddValue("notify_on_subscribe"  , new JsonValue(Sql.Truncate(o.notify_on_subscribe  , 100)));
			if ( !String.IsNullOrEmpty(o.notify_on_unsubscribe) ) json.AddValue("notify_on_unsubscribe", new JsonValue(Sql.Truncate(o.notify_on_unsubscribe, 100)));
			if ( !String.IsNullOrEmpty(o.visibility           ) ) json.AddValue("visibility"           , new JsonValue(o.visibility                 ));  // pub or prv. 
			
			// Contact
			JsonObject jsonContact = new JsonObject();
			if ( o.contact != null )
			{
				if ( !String.IsNullOrEmpty(o.contact.company ) ) jsonContact.AddValue("company"   , new JsonValue(o.contact.company ));
				if ( !String.IsNullOrEmpty(o.contact.address1) ) jsonContact.AddValue("address1"  , new JsonValue(o.contact.address1));
				if ( !String.IsNullOrEmpty(o.contact.address2) ) jsonContact.AddValue("address2"  , new JsonValue(o.contact.address2));
				if ( !String.IsNullOrEmpty(o.contact.city    ) ) jsonContact.AddValue("city"      , new JsonValue(o.contact.city    ));
				if ( !String.IsNullOrEmpty(o.contact.state   ) ) jsonContact.AddValue("state"     , new JsonValue(o.contact.state   ));
				if ( !String.IsNullOrEmpty(o.contact.zip     ) ) jsonContact.AddValue("zip"       , new JsonValue(o.contact.zip     ));
				if ( !String.IsNullOrEmpty(o.contact.country ) ) jsonContact.AddValue("country"   , new JsonValue(o.contact.country ));  // A two-character ISO3166 country code. Defaults to US if invalid.
				if ( !String.IsNullOrEmpty(o.contact.phone   ) ) jsonContact.AddValue("phone"     , new JsonValue(o.contact.phone   ));
			}
			json.AddValue("contact", jsonContact);
			
			// Campaign Defaults
			JsonObject jsonCampaignDefaults = new JsonObject();
			if ( o.campaign_defaults != null )
			{
				if ( !String.IsNullOrEmpty(o.campaign_defaults.from_name ) ) jsonCampaignDefaults.AddValue("from_name" , new JsonValue(Sql.Truncate(o.campaign_defaults.from_name , 100)));
				if ( !String.IsNullOrEmpty(o.campaign_defaults.from_email) ) jsonCampaignDefaults.AddValue("from_email", new JsonValue(Sql.Truncate(o.campaign_defaults.from_email, 150)));
				if ( !String.IsNullOrEmpty(o.campaign_defaults.subject   ) ) jsonCampaignDefaults.AddValue("subject"   , new JsonValue(Sql.Truncate(o.campaign_defaults.subject   , 100)));
				if ( !String.IsNullOrEmpty(o.campaign_defaults.language  ) ) jsonCampaignDefaults.AddValue("language"  , new JsonValue(o.campaign_defaults.language  ));
			}
			json.AddValue("campaign_defaults", jsonCampaignDefaults);
			o.RawContent = json.ToString();
			return json;
		}
	}
}
