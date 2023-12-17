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
	class CampaignDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			if ( json.ContainsName("campaigns") )
			{
				json = json.GetValue("campaigns");
			}
			Campaign obj = new Campaign();
			obj.RawContent = json.ToString();
			
			// 04/08/2016 Paul.  When less data than paginated request, then final entries have ID of 0. 
			string sID = json.GetValueOrDefault<String>("id");
			if ( sID == String.Empty || sID == "0" )
				return null;
			// http://developer.mailchimp.com/documentation/mailchimp/reference/campaigns/#
			obj.id               = json.GetValueOrDefault<String   >("id"          );
			obj.date_created     = json.GetValueOrDefault<DateTime?>("date_created");
			// 04/16/2016 Paul.  MailChimp does not have a modified date field, so just use created date. 
			obj.lastmodifieddate = json.GetValueOrDefault<DateTime?>("date_created");
			obj.created_by       = json.GetValueOrDefault<String   >("created_by"  );
			obj.type             = json.GetValueOrDefault<String   >("type"        );
			obj.archive_url      = json.GetValueOrDefault<String   >("archive_url" );
			obj.status           = json.GetValueOrDefault<String   >("status"      );
			obj.emails_sent      = json.GetValueOrDefault<int?     >("emails_sent" );
			obj.content_type     = json.GetValueOrDefault<String   >("content_type");
			if ( !String.IsNullOrEmpty(json.GetValueOrDefault<String>("send_time")) )
				obj.send_time     = json.GetValueOrDefault<DateTime?>("send_time"   );
			// Recipients
			JsonValue jsonRecipients = json.GetValue("recipients");
			if ( jsonRecipients != null )
			{
				obj.recipients = new Campaign.Recipients();
				obj.recipients.list_id      = jsonRecipients.GetValueOrDefault<String      >("list_id"     );
				obj.recipients.segment_text = jsonRecipients.GetValueOrDefault<String      >("segment_text");
				JsonValue jsonSegment = jsonRecipients.GetValue("segment_opts");
				if ( jsonSegment != null )
				{
					obj.recipients.segment_opts = new Campaign.Recipients.Segment();
					obj.recipients.segment_opts.saved_segment_id = jsonSegment.GetValueOrDefault<int?      >("saved_segment_id");
					obj.recipients.segment_opts.match            = jsonSegment.GetValueOrDefault<String    >("match"           );
					JsonValue jsonConditions = jsonSegment.GetValue("conditions");
					if ( jsonConditions != null && jsonConditions.IsArray )
					{
						obj.recipients.segment_opts.conditions = new List<Campaign.Recipients.Segment.Conditions>();
						foreach ( JsonValue itemValue in jsonConditions.GetValues() )
						{
							Campaign.Recipients.Segment.Conditions condition = new Campaign.Recipients.Segment.Conditions();
							obj.recipients.segment_opts.conditions.Add(condition);
							condition.condition_type = itemValue.GetValueOrDefault<String    >("condition_type");
							JsonValue jsonAim = itemValue.GetValue("aim");
							if ( jsonAim != null )
							{
								condition.aim = new Campaign.Recipients.Segment.Conditions.Aim();
								condition.aim.op    = jsonAim.GetValueOrDefault<String   >("op"   );
								condition.aim.field = jsonAim.GetValueOrDefault<String   >("field");
								condition.aim.value = jsonAim.GetValueOrDefault<String   >("value");
							}
						}
					}
				}
			}
			// Settings
			JsonValue jsonSettings = json.GetValue("settings");
			if ( jsonSettings != null )
			{
				obj.settings = new Campaign.Settings();
				obj.settings.subject_line     = jsonSettings.GetValueOrDefault<String      >("subject_line"     );
				obj.settings.title            = jsonSettings.GetValueOrDefault<String      >("title"            );
				obj.settings.from_name        = jsonSettings.GetValueOrDefault<String      >("from_name"        );
				obj.settings.reply_to         = jsonSettings.GetValueOrDefault<String      >("reply_to"         );
				obj.settings.use_conversation = jsonSettings.GetValueOrDefault<bool?       >("use_conversation" );
				obj.settings.to_name          = jsonSettings.GetValueOrDefault<String      >("to_name"          );
				obj.settings.folder_id        = jsonSettings.GetValueOrDefault<String      >("folder_id"        );
				obj.settings.authenticate     = jsonSettings.GetValueOrDefault<bool?       >("authenticate"     );
				obj.settings.auto_footer      = jsonSettings.GetValueOrDefault<bool?       >("auto_footer"      );
				obj.settings.inline_css       = jsonSettings.GetValueOrDefault<bool?       >("inline_css"       );
				obj.settings.auto_tweet       = jsonSettings.GetValueOrDefault<bool?       >("auto_tweet"       );
				obj.settings.fb_comments      = jsonSettings.GetValueOrDefault<bool?       >("fb_comments"      );
				obj.settings.timewarp         = jsonSettings.GetValueOrDefault<bool?       >("timewarp"         );
				obj.settings.template_id      = jsonSettings.GetValueOrDefault<int?        >("template_id"      );
				obj.settings.drag_and_drop    = jsonSettings.GetValueOrDefault<bool?       >("drag_and_drop"    );
				obj.settings.auto_fb_post     = mapper.Deserialize<List<String>>(jsonSettings.GetValue("auto_fb_post"));
			}
			// VariateSettings
			JsonValue jsonVariateSettings = json.GetValue("variate_settings");
			if ( jsonVariateSettings != null )
			{
				obj.variate_settings = new Campaign.VariateSettings();
				obj.variate_settings.winning_combination_id   = jsonVariateSettings.GetValueOrDefault<String        >("winning_combination_id"  );
				obj.variate_settings.winning_campaign_id      = jsonVariateSettings.GetValueOrDefault<String        >("winning_campaign_id"     );
				obj.variate_settings.winner_criteria          = jsonVariateSettings.GetValueOrDefault<String        >("winner_criteria"         );
				obj.variate_settings.wait_time                = jsonVariateSettings.GetValueOrDefault<int?          >("wait_time"               );
				obj.variate_settings.test_size                = jsonVariateSettings.GetValueOrDefault<int?          >("test_size"               );
				obj.variate_settings.subject_lines            = mapper.Deserialize<List<String>  >(jsonVariateSettings.GetValue("subject_lines"     ));
				obj.variate_settings.send_times               = mapper.Deserialize<List<DateTime>>(jsonVariateSettings.GetValue("send_times"        ));
				obj.variate_settings.from_names               = mapper.Deserialize<List<String>  >(jsonVariateSettings.GetValue("from_names"        ));
				obj.variate_settings.reply_to_addresses       = mapper.Deserialize<List<String>  >(jsonVariateSettings.GetValue("reply_to_addresses"));
				obj.variate_settings.contents                 = mapper.Deserialize<List<String>  >(jsonVariateSettings.GetValue("contents"          ));
				JsonValue jsonCombinations = jsonVariateSettings.GetValue("combinations");
				if ( jsonCombinations != null && jsonCombinations.IsArray )
				{
					obj.variate_settings.combinations = new List<Campaign.VariateSettings.Combinations>();
					foreach ( JsonValue itemValue in jsonCombinations.GetValues() )
					{
						Campaign.VariateSettings.Combinations combination = new Campaign.VariateSettings.Combinations();
						obj.variate_settings.combinations.Add(combination);
						combination.id                  = itemValue.GetValueOrDefault<String    >("id"                 );
						combination.subject_line        = itemValue.GetValueOrDefault<int?      >("subject_line"       );
						combination.send_time           = itemValue.GetValueOrDefault<DateTime? >("send_time"          );
						combination.from_name           = itemValue.GetValueOrDefault<int?      >("from_name"          );
						combination.reply_to            = itemValue.GetValueOrDefault<int?      >("reply_to"           );
						combination.content_description = itemValue.GetValueOrDefault<int?      >("content_description");
						combination.recipients          = itemValue.GetValueOrDefault<int?      >("recipients"         );
					}
				}
			}
			// Tracking
			JsonValue jsonTracking = json.GetValue("tracking");
			if ( jsonTracking != null )
			{
				obj.tracking = new Campaign.Tracking();
				obj.tracking.opens            = jsonTracking.GetValueOrDefault<bool?     >("opens"           );
				obj.tracking.html_clicks      = jsonTracking.GetValueOrDefault<bool?     >("html_clicks"     );
				obj.tracking.text_clicks      = jsonTracking.GetValueOrDefault<bool?     >("text_clicks"     );
				obj.tracking.goal_tracking    = jsonTracking.GetValueOrDefault<bool?     >("goal_tracking"   );
				obj.tracking.ecomm360         = jsonTracking.GetValueOrDefault<bool?     >("ecomm360"        );
				obj.tracking.google_analytics = jsonTracking.GetValueOrDefault<String    >("google_analytics");
				obj.tracking.clicktale        = jsonTracking.GetValueOrDefault<String    >("clicktale"       );
				JsonValue jsonSalesforce = jsonTracking.GetValue("salesforce");
				if ( jsonSalesforce != null )
				{
					obj.tracking.salesforce = new Campaign.Tracking.Salesforce();
					obj.tracking.salesforce.campaign = jsonSalesforce.GetValueOrDefault<bool?     >("campaign");
					obj.tracking.salesforce.notes    = jsonSalesforce.GetValueOrDefault<bool?     >("notes"   );
				}
				JsonValue jsonHighrise = jsonTracking.GetValue("highrise");
				if ( jsonHighrise != null )
				{
					obj.tracking.highrise = new Campaign.Tracking.Highrise();
					obj.tracking.highrise.campaign = jsonHighrise.GetValueOrDefault<bool?     >("campaign");
					obj.tracking.highrise.notes    = jsonHighrise.GetValueOrDefault<bool?     >("notes"   );
				}
				JsonValue jsonCapsule = jsonTracking.GetValue("capsule");
				if ( jsonCapsule != null )
				{
					obj.tracking.capsule = new Campaign.Tracking.Capsule();
					obj.tracking.capsule.notes    = jsonCapsule.GetValueOrDefault<bool?     >("notes"   );
				}
			}
			// RssOptions
			JsonValue jsonRssOptions = json.GetValue("rss_opts");
			if ( jsonRssOptions != null )
			{
				obj.rss_opts = new Campaign.RssOptions();
				obj.rss_opts.feed_url          = jsonRssOptions.GetValueOrDefault<String   >("feed_url"         );
				obj.rss_opts.frequency         = jsonRssOptions.GetValueOrDefault<String   >("frequency"        );
				obj.rss_opts.constrain_rss_img = jsonRssOptions.GetValueOrDefault<bool?    >("constrain_rss_img");
				if ( !String.IsNullOrEmpty(jsonRssOptions.GetValueOrDefault<String>("last_sent")) )
					obj.rss_opts.last_sent         = jsonRssOptions.GetValueOrDefault<DateTime?>("last_sent"        );
				JsonValue jsonSchedule = jsonRssOptions.GetValue("schedule");
				if ( jsonSchedule != null )
				{
					obj.rss_opts.schedule = new Campaign.RssOptions.Schedule();
					obj.rss_opts.schedule.hour              = jsonSchedule.GetValueOrDefault<int?     >("hour"             );
					obj.rss_opts.schedule.weekly_send_day   = jsonSchedule.GetValueOrDefault<String   >("weekly_send_day"  );
					obj.rss_opts.schedule.monthly_send_date = jsonSchedule.GetValueOrDefault<Decimal? >("monthly_send_date");
					JsonValue jsonDailySend = jsonSchedule.GetValue("daily_send");
					if ( jsonDailySend != null )
					{
						obj.rss_opts.schedule.daily_send = new Campaign.RssOptions.Schedule.DailySend();
						obj.rss_opts.schedule.daily_send.sunday    = jsonDailySend.GetValueOrDefault<bool?    >("sunday"   );
						obj.rss_opts.schedule.daily_send.monday    = jsonDailySend.GetValueOrDefault<bool?    >("monday"   );
						obj.rss_opts.schedule.daily_send.tuesday   = jsonDailySend.GetValueOrDefault<bool?    >("tuesday"  );
						obj.rss_opts.schedule.daily_send.wednesday = jsonDailySend.GetValueOrDefault<bool?    >("wednesday");
						obj.rss_opts.schedule.daily_send.thursday  = jsonDailySend.GetValueOrDefault<bool?    >("thursday" );
						obj.rss_opts.schedule.daily_send.friday    = jsonDailySend.GetValueOrDefault<bool?    >("friday"   );
						obj.rss_opts.schedule.daily_send.saturday  = jsonDailySend.GetValueOrDefault<bool?    >("saturday" );
					}
				}
			}
			// ABTesting
			JsonValue jsonABTesting = json.GetValue("ab_split_opts");
			if ( jsonABTesting != null )
			{
				obj.ab_split_opts = new Campaign.ABTesting();
				obj.ab_split_opts.split_test         = jsonABTesting.GetValueOrDefault<String   >("split_test"       );
				obj.ab_split_opts.pick_winner        = jsonABTesting.GetValueOrDefault<String   >("pick_winner"      );
				obj.ab_split_opts.wait_units         = jsonABTesting.GetValueOrDefault<String   >("wait_units"       );
				obj.ab_split_opts.wait_time          = jsonABTesting.GetValueOrDefault<int?     >("wait_time"        );
				obj.ab_split_opts.split_size         = jsonABTesting.GetValueOrDefault<int?     >("split_size"       );
				obj.ab_split_opts.from_name_a        = jsonABTesting.GetValueOrDefault<String   >("from_name_a"      );
				obj.ab_split_opts.from_name_b        = jsonABTesting.GetValueOrDefault<String   >("from_name_b"      );
				obj.ab_split_opts.reply_email_a      = jsonABTesting.GetValueOrDefault<String   >("reply_email_a"    );
				obj.ab_split_opts.reply_email_b      = jsonABTesting.GetValueOrDefault<String   >("reply_email_b"    );
				obj.ab_split_opts.subject_a          = jsonABTesting.GetValueOrDefault<String   >("subject_a"        );
				obj.ab_split_opts.subject_b          = jsonABTesting.GetValueOrDefault<String   >("subject_b"        );
				obj.ab_split_opts.send_time_a        = jsonABTesting.GetValueOrDefault<String   >("send_time_a"      );
				obj.ab_split_opts.send_time_b        = jsonABTesting.GetValueOrDefault<String   >("send_time_b"      );
				obj.ab_split_opts.send_time_winner   = jsonABTesting.GetValueOrDefault<String   >("send_time_winner" );
			}
			// SocialCard
			JsonValue jsonSocialCard = json.GetValue("social_card");
			if ( jsonSocialCard != null )
			{
				obj.social_card = new Campaign.SocialCard();
				obj.social_card.image_url            = jsonSocialCard.GetValueOrDefault<String   >("image_url"   );
				obj.social_card.description          = jsonSocialCard.GetValueOrDefault<String   >("description" );
				obj.social_card.title                = jsonSocialCard.GetValueOrDefault<String   >("title"       );
			}
			// ReportSummary
			JsonValue jsonReportSummary = json.GetValue("report_summary");
			if ( jsonReportSummary != null )
			{
				obj.report_summary = new Campaign.ReportSummary();
				obj.report_summary.opens             = jsonReportSummary.GetValueOrDefault<int?     >("opens"            );
				obj.report_summary.unique_opens      = jsonReportSummary.GetValueOrDefault<int?     >("unique_opens"     );
				obj.report_summary.open_rate         = jsonReportSummary.GetValueOrDefault<Decimal? >("open_rate"        );
				obj.report_summary.clicks            = jsonReportSummary.GetValueOrDefault<int?     >("clicks"           );
				obj.report_summary.subscriber_clicks = jsonReportSummary.GetValueOrDefault<int?     >("subscriber_clicks");
				obj.report_summary.click_rate        = jsonReportSummary.GetValueOrDefault<Decimal? >("click_rate"       );
			}
			// DeliveryStatus
			JsonValue jsonDeliveryStatus = json.GetValue("delivery_status");
			if ( jsonDeliveryStatus != null )
			{
				obj.delivery_status = new Campaign.DeliveryStatus();
				obj.delivery_status.enabled          = jsonDeliveryStatus.GetValueOrDefault<bool?    >("enabled"        );
				obj.delivery_status.can_cancel       = jsonDeliveryStatus.GetValueOrDefault<bool?    >("can_cancel"     );
				obj.delivery_status.status           = jsonDeliveryStatus.GetValueOrDefault<String   >("status"         );
				obj.delivery_status.emails_sent      = jsonDeliveryStatus.GetValueOrDefault<int?     >("emails_sent"    );
				obj.delivery_status.emails_canceled  = jsonDeliveryStatus.GetValueOrDefault<int?     >("emails_canceled");
			}
			return obj;
		}
	}

	class CampaignListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Campaign> items = new List<Campaign>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("campaigns");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					Campaign item = mapper.Deserialize<Campaign>(itemValue);
					// 04/08/2016 Paul.  When less data than paginated request, then final entries have ID of 0. 
					if ( item != null && !String.IsNullOrEmpty(item.id) )
						items.Add(item);
				}
			}
			return items;
		}
	}

	class CampaignPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			CampaignPagination pag = new CampaignPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				pag.total  = json.GetValueOrDefault<int>("total_items");
				pag.items  = mapper.Deserialize<IList<Campaign>>(json);
			}
			return pag;
		}
	}
}
