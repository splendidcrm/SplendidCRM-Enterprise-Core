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
	class CampaignSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Campaign o = obj as Campaign;
			
			JsonObject json = new JsonObject();
			json.AddValue("type", new JsonValue(o.type));
			// Recipients
			JsonObject jsonRecipients = new JsonObject();
			if ( o.recipients != null )
			{
			}
			json.AddValue("recipients", jsonRecipients);
			// Settings
			JsonObject jsonSettings = new JsonObject();
			if ( o.settings != null )
			{
			}
			json.AddValue("settings", jsonSettings);
			// VariateSettings
			JsonObject jsonVariateSettings = new JsonObject();
			if ( o.variate_settings != null )
			{
				jsonVariateSettings.AddValue("winner_criteria", new JsonValue(o.variate_settings.winner_criteria));
				if ( o.variate_settings.wait_time.HasValue ) jsonVariateSettings.AddValue("wait_time", new JsonValue(o.variate_settings.wait_time.Value));
				if ( o.variate_settings.test_size.HasValue ) jsonVariateSettings.AddValue("test_size", new JsonValue(o.variate_settings.test_size.Value));
				if ( o.variate_settings.subject_lines      != null ) jsonVariateSettings.AddValue("subject_lines"     , mapper.Serialize(o.variate_settings.subject_lines     ));
				if ( o.variate_settings.send_times         != null ) jsonVariateSettings.AddValue("send_times"        , mapper.Serialize(o.variate_settings.send_times        ));
				if ( o.variate_settings.from_names         != null ) jsonVariateSettings.AddValue("from_names"        , mapper.Serialize(o.variate_settings.from_names        ));
				if ( o.variate_settings.reply_to_addresses != null ) jsonVariateSettings.AddValue("reply_to_addresses", mapper.Serialize(o.variate_settings.reply_to_addresses));
				json.AddValue("variate_settings", jsonVariateSettings);
			}
			// RssOptions
			JsonObject jsonRssOptions = new JsonObject();
			if ( o.rss_opts != null )
			{
				jsonRssOptions.AddValue("feed_url" , new JsonValue(o.rss_opts.feed_url ));
				jsonRssOptions.AddValue("frequency", new JsonValue(o.rss_opts.frequency));
				if ( o.rss_opts.constrain_rss_img.HasValue ) jsonRssOptions.AddValue("constrain_rss_img", new JsonValue(o.rss_opts.constrain_rss_img.Value));
				if ( o.rss_opts.schedule != null )
				{
					JsonObject jsonSchedule = new JsonObject();
					if ( o.rss_opts.schedule.hour.HasValue                          ) jsonSchedule.AddValue("hour"             , new JsonValue(o.rss_opts.schedule.hour.Value));
					if ( !String.IsNullOrEmpty(o.rss_opts.schedule.weekly_send_day) ) jsonSchedule.AddValue("weekly_send_day"  , new JsonValue(o.rss_opts.schedule.weekly_send_day));
					if ( o.rss_opts.schedule.monthly_send_date.HasValue             ) jsonSchedule.AddValue("monthly_send_date", new JsonValue(o.rss_opts.schedule.monthly_send_date.Value));
					if ( o.rss_opts.schedule.daily_send != null )
					{
						JsonObject jsonDailySend = new JsonObject();
						if ( o.rss_opts.schedule.daily_send.sunday   .HasValue ) jsonDailySend.AddValue("sunday"   , new JsonValue(o.rss_opts.schedule.daily_send.sunday   .Value));
						if ( o.rss_opts.schedule.daily_send.monday   .HasValue ) jsonDailySend.AddValue("monday"   , new JsonValue(o.rss_opts.schedule.daily_send.monday   .Value));
						if ( o.rss_opts.schedule.daily_send.tuesday  .HasValue ) jsonDailySend.AddValue("tuesday"  , new JsonValue(o.rss_opts.schedule.daily_send.tuesday  .Value));
						if ( o.rss_opts.schedule.daily_send.wednesday.HasValue ) jsonDailySend.AddValue("wednesday", new JsonValue(o.rss_opts.schedule.daily_send.wednesday.Value));
						if ( o.rss_opts.schedule.daily_send.thursday .HasValue ) jsonDailySend.AddValue("thursday" , new JsonValue(o.rss_opts.schedule.daily_send.thursday .Value));
						if ( o.rss_opts.schedule.daily_send.friday   .HasValue ) jsonDailySend.AddValue("friday"   , new JsonValue(o.rss_opts.schedule.daily_send.friday   .Value));
						if ( o.rss_opts.schedule.daily_send.saturday .HasValue ) jsonDailySend.AddValue("saturday" , new JsonValue(o.rss_opts.schedule.daily_send.saturday .Value));
						jsonRssOptions.AddValue("daily_send", jsonDailySend);
					}
					jsonRssOptions.AddValue("rss_opts", jsonSchedule);
				}
				json.AddValue("rss_opts", jsonRssOptions);
			}
			// SocialCard
			JsonObject jsonSocialCard = new JsonObject();
			if ( o.social_card != null )
			{
				if ( !String.IsNullOrEmpty(o.social_card.image_url  ) ) jsonSocialCard.AddValue("image_url"  , new JsonValue(o.social_card.image_url  ));
				if ( !String.IsNullOrEmpty(o.social_card.description) ) jsonSocialCard.AddValue("description", new JsonValue(o.social_card.description));
				if ( !String.IsNullOrEmpty(o.social_card.title      ) ) jsonSocialCard.AddValue("title"      , new JsonValue(o.social_card.title      ));
				json.AddValue("social_card", jsonSocialCard);
			}
			
			/*
			// Contact
			JsonObject jsonContact = new JsonObject();
			if ( o.contact != null )
			{
				jsonContact.AddValue("company"   , new JsonValue(o.contact.company ));
				jsonContact.AddValue("address1"  , new JsonValue(o.contact.address1));
				if ( !String.IsNullOrEmpty(o.contact.address2) )
					jsonContact.AddValue("address2"  , new JsonValue(o.contact.address2));
				jsonContact.AddValue("city"      , new JsonValue(o.contact.city    ));
				jsonContact.AddValue("state"     , new JsonValue(o.contact.state   ));
				jsonContact.AddValue("zip"       , new JsonValue(o.contact.zip     ));
				jsonContact.AddValue("country"   , new JsonValue(o.contact.country ));  // A two-character ISO3166 country code. Defaults to US if invalid.
				if ( !String.IsNullOrEmpty(o.contact.phone) )
					jsonContact.AddValue("phone"     , new JsonValue(o.contact.phone   ));
			}
			json.AddValue("contact", jsonContact);
			
			// Campaign Defaults
			JsonObject jsonCampaignDefaults = new JsonObject();
			if ( o.campaign_defaults != null )
			{
				json.AddValue("from_name" , new JsonValue(o.campaign_defaults.from_name ));
				json.AddValue("from_email", new JsonValue(o.campaign_defaults.from_email));
				json.AddValue("subject"   , new JsonValue(o.campaign_defaults.subject   ));
				json.AddValue("language"  , new JsonValue(o.campaign_defaults.language  ));
			}
			json.AddValue("campaign_defaults", jsonCampaignDefaults);
			*/
			o.RawContent = json.ToString();
			return json;
		}
	}
}
