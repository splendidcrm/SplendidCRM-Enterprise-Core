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
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Json;

namespace Spring.Social.MailChimp.Api
{
	[Serializable]
	public class Campaign : HBase
	{
		public class Recipients
		{
			public class Segment
			{
				public class Conditions
				{
					public class Aim
					{
						public string    op                   { get; set; }
						public string    field                { get; set; }
						public string    value                { get; set; }
					}

					public string    condition_type               { get; set; }
					public Aim       aim                          { get; set; }
				}

				public int?             saved_segment_id          { get; set; }
				public String           match                     { get; set; }
				public List<Conditions> conditions                { get; set; }
			}

			public String    list_id                      { get; set; }
			public String    segment_text                 { get; set; }
			public Segment   segment_opts                 { get; set; }
		}

		public class Settings
		{
			public String       subject_line                 { get; set; }
			public String       title                        { get; set; }
			public String       from_name                    { get; set; }
			public String       reply_to                     { get; set; }
			public bool?        use_conversation             { get; set; }
			public String       to_name                      { get; set; }
			public String       folder_id                    { get; set; }
			public bool?        authenticate                 { get; set; }
			public bool?        auto_footer                  { get; set; }
			public bool?        inline_css                   { get; set; }
			public bool?        auto_tweet                   { get; set; }
			public List<String> auto_fb_post                 { get; set; }
			public bool?        fb_comments                  { get; set; }
			public bool?        timewarp                     { get; set; }
			public int?         template_id                  { get; set; }
			public bool?        drag_and_drop                { get; set; }
		}

		public class VariateSettings
		{
			public class Combinations
			{
				public String     id                          { get; set; }
				public int?       subject_line                { get; set; }
				public DateTime?  send_time                   { get; set; }
				public int?       from_name                   { get; set; }
				public int?       reply_to                    { get; set; }
				public int?       content_description         { get; set; }
				public int?       recipients                  { get; set; }
			}

			public String             winning_combination_id       { get; set; }
			public String             winning_campaign_id          { get; set; }
			public String             winner_criteria              { get; set; }
			public int?               wait_time                    { get; set; }
			public int?               test_size                    { get; set; }
			public List<String>       subject_lines                { get; set; }
			public List<DateTime>     send_times                   { get; set; }
			public List<String>       from_names                   { get; set; }
			public List<String>       reply_to_addresses           { get; set; }
			public List<String>       contents                     { get; set; }
			public List<Combinations> combinations                 { get; set; }
		}

		public class Tracking
		{
			public class Salesforce
			{
				public bool?      campaign                 { get; set; }
				public bool?      notes                    { get; set; }
			}

			public class Highrise
			{
				public bool?      campaign                 { get; set; }
				public bool?      notes                    { get; set; }
			}

			public class Capsule
			{
				public bool?      notes                    { get; set; }
			}

			public bool?      opens                        { get; set; }
			public bool?      html_clicks                  { get; set; }
			public bool?      text_clicks                  { get; set; }
			public bool?      goal_tracking                { get; set; }
			public bool?      ecomm360                     { get; set; }
			public String     google_analytics             { get; set; }
			public String     clicktale                    { get; set; }
			public Salesforce salesforce                   { get; set; }
			public Highrise   highrise                     { get; set; }
			public Capsule    capsule                      { get; set; }
		}

		public class RssOptions
		{
			public class Schedule
			{
				public class DailySend
				{
					public bool?     sunday                       { get; set; }
					public bool?     monday                       { get; set; }
					public bool?     tuesday                      { get; set; }
					public bool?     wednesday                    { get; set; }
					public bool?     thursday                     { get; set; }
					public bool?     friday                       { get; set; }
					public bool?     saturday                     { get; set; }
				}

				public int?      hour                         { get; set; }
				public DailySend daily_send                   { get; set; }
				public string    weekly_send_day              { get; set; }
				public Decimal?  monthly_send_date            { get; set; }
			}

			public String    feed_url                     { get; set; }
			public String    frequency                    { get; set; }
			public Schedule  schedule                     { get; set; }
			public DateTime? last_sent                    { get; set; }
			public bool?     constrain_rss_img            { get; set; }
		}

		public class ABTesting
		{
			public String    split_test                   { get; set; }
			public String    pick_winner                  { get; set; }
			public String    wait_units                   { get; set; }
			public int?      wait_time                    { get; set; }
			public int?      split_size                   { get; set; }
			public String    from_name_a                  { get; set; }
			public String    from_name_b                  { get; set; }
			public String    reply_email_a                { get; set; }
			public String    reply_email_b                { get; set; }
			public String    subject_a                    { get; set; }
			public String    subject_b                    { get; set; }
			public String    send_time_a                  { get; set; }
			public String    send_time_b                  { get; set; }
			public String    send_time_winner             { get; set; }
		}

		public class SocialCard
		{
			public String    image_url                    { get; set; }
			public String    description                  { get; set; }
			public String    title                        { get; set; }
		}

		public class ReportSummary
		{
			public int?      opens                        { get; set; }
			public int?      unique_opens                 { get; set; }
			public Decimal?  open_rate                    { get; set; }
			public int?      clicks                       { get; set; }
			public int?      subscriber_clicks            { get; set; }
			public Decimal?  click_rate                   { get; set; }
		}

		public class DeliveryStatus
		{
			public bool?     enabled                      { get; set; }
			public bool?     can_cancel                   { get; set; }
			public string    status                       { get; set; }
			public int?      emails_sent                  { get; set; }
			public int?      emails_canceled              { get; set; }
		}

		#region Properties
		public String           type                      { get; set; }
		public String           archive_url               { get; set; }
		public String           status                    { get; set; }
		public int?             emails_sent               { get; set; }
		public DateTime?        send_time                 { get; set; }
		public String           content_type              { get; set; }
		public Recipients       recipients                { get; set; }
		public Settings         settings                  { get; set; }
		public VariateSettings  variate_settings          { get; set; }
		public Tracking         tracking                  { get; set; }
		public RssOptions       rss_opts                  { get; set; }
		public ABTesting        ab_split_opts             { get; set; }
		public SocialCard       social_card               { get; set; }
		public ReportSummary    report_summary            { get; set; }
		public DeliveryStatus   delivery_status           { get; set; }
		#endregion

		public Campaign()
		{
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                                         , Type.GetType("System.String"  ));
			dt.Columns.Add("date_created"                               , Type.GetType("System.DateTime"));  // 2015-09-15T13:09:22+00:00
			dt.Columns.Add("created_by"                                 , Type.GetType("System.String"  ));
			dt.Columns.Add("type"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("archive_url"                                , Type.GetType("System.String"  ));
			dt.Columns.Add("status"                                     , Type.GetType("System.String"  ));
			dt.Columns.Add("emails_sent"                                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("send_time"                                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("content_type"                               , Type.GetType("System.String"  ));
			// Recipients
			// Settings
			dt.Columns.Add("subject_line"                               , Type.GetType("System.String"  ));
			dt.Columns.Add("title"                                      , Type.GetType("System.String"  ));
			dt.Columns.Add("from_name"                                  , Type.GetType("System.String"  ));
			dt.Columns.Add("reply_to"                                   , Type.GetType("System.String"  ));
			dt.Columns.Add("use_conversation"                           , Type.GetType("System.Boolean" ));
			dt.Columns.Add("to_name"                                    , Type.GetType("System.String"  ));
			dt.Columns.Add("folder_id"                                  , Type.GetType("System.String"  ));
			dt.Columns.Add("authenticate"                               , Type.GetType("System.Boolean" ));
			dt.Columns.Add("auto_footer"                                , Type.GetType("System.Boolean" ));
			dt.Columns.Add("inline_css"                                 , Type.GetType("System.Boolean" ));
			dt.Columns.Add("auto_tweet"                                 , Type.GetType("System.Boolean" ));
			dt.Columns.Add("auto_fb_post"                               , Type.GetType("System.String"  ));
			dt.Columns.Add("fb_comments"                                , Type.GetType("System.Boolean" ));
			dt.Columns.Add("timewarp"                                   , Type.GetType("System.Boolean" ));
			dt.Columns.Add("template_id"                                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("drag_and_drop"                              , Type.GetType("System.Boolean" ));
			// VariateSettings
			dt.Columns.Add("winning_combination_id"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("winning_campaign_id"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("winner_criteria"                            , Type.GetType("System.String"  ));
			dt.Columns.Add("wait_time"                                  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("test_size"                                  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("subject_lines"                              , Type.GetType("System.String"  ));
			dt.Columns.Add("send_times"                                 , Type.GetType("System.String"  ));
			dt.Columns.Add("from_names"                                 , Type.GetType("System.String"  ));
			dt.Columns.Add("reply_to_addresses"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("contents"                                   , Type.GetType("System.String"  ));
			// Tracking
			dt.Columns.Add("opens"                                      , Type.GetType("System.Boolean" ));
			dt.Columns.Add("html_clicks"                                , Type.GetType("System.Boolean" ));
			dt.Columns.Add("text_clicks"                                , Type.GetType("System.Boolean" ));
			dt.Columns.Add("goal_tracking"                              , Type.GetType("System.Boolean" ));
			dt.Columns.Add("ecomm360"                                   , Type.GetType("System.Boolean" ));
			dt.Columns.Add("google_analytics"                           , Type.GetType("System.String"  )); 
			dt.Columns.Add("clicktale"                                  , Type.GetType("System.String"  )); 
			dt.Columns.Add("salesforce_campaign"                        , Type.GetType("System.Boolean" ));
			dt.Columns.Add("salesforce_notes"                           , Type.GetType("System.Boolean" ));
			dt.Columns.Add("highrise_campaign"                          , Type.GetType("System.Boolean" ));
			dt.Columns.Add("highrise_notes"                             , Type.GetType("System.Boolean" ));
			dt.Columns.Add("capsule_notes"                              , Type.GetType("System.Boolean" ));
			// RssOptions
			dt.Columns.Add("rss_opts_feed_url"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("rss_opts_frequency"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("rss_opts_schedule_hour"                     , Type.GetType("System.Int64"   ));
			dt.Columns.Add("rss_opts_schedule_weekly_send_day"          , Type.GetType("System.String"  ));
			dt.Columns.Add("rss_opts_schedule_monthly_send_date"        , Type.GetType("System.Decimal" ));
			dt.Columns.Add("rss_opts_schedule_daily_send_sunday"        , Type.GetType("System.Boolean" ));
			dt.Columns.Add("rss_opts_schedule_daily_send_monday"        , Type.GetType("System.Boolean" ));
			dt.Columns.Add("rss_opts_schedule_daily_send_tuesday"       , Type.GetType("System.Boolean" ));
			dt.Columns.Add("rss_opts_schedule_daily_send_wednesday"     , Type.GetType("System.Boolean" ));
			dt.Columns.Add("rss_opts_schedule_daily_send_thursday"      , Type.GetType("System.Boolean" ));
			dt.Columns.Add("rss_opts_schedule_daily_send_friday"        , Type.GetType("System.Boolean" ));
			dt.Columns.Add("rss_opts_schedule_daily_send_saturday"      , Type.GetType("System.Boolean" ));
			dt.Columns.Add("rss_opts_last_sent"                         , Type.GetType("System.DateTime"));
			dt.Columns.Add("rss_opts_constrain_rss_img"                 , Type.GetType("System.Boolean" ));
			// ABTesting
			dt.Columns.Add("ab_split_opts_split_test"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_pick_winner"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_wait_units"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_wait_time"                    , Type.GetType("System.Int64"   ));
			dt.Columns.Add("ab_split_opts_split_size"                   , Type.GetType("System.Int64"   ));
			dt.Columns.Add("ab_split_opts_from_name_a"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_from_name_b"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_reply_email_a"                , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_reply_email_b"                , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_subject_a"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_subject_b"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_send_time_a"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_send_time_b"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("ab_split_opts_send_time_winner"             , Type.GetType("System.String"  ));
			// SocialCard
			dt.Columns.Add("social_card_image_url"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("social_card_description"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("social_card_title"                          , Type.GetType("System.String"  ));
			// ReportSummary
			dt.Columns.Add("report_summary_opens"                       , Type.GetType("System.Int64"   ));
			dt.Columns.Add("report_summary_unique_opens"                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("report_summary_open_rate"                   , Type.GetType("System.Decimal" ));
			dt.Columns.Add("report_summary_clicks"                      , Type.GetType("System.Int64"   ));
			dt.Columns.Add("report_summary_subscriber_clicks"           , Type.GetType("System.Int64"   ));
			dt.Columns.Add("report_summary_click_rate"                  , Type.GetType("System.Decimal" ));
			// DeliveryStatus
			dt.Columns.Add("delivery_status_enabled"                    , Type.GetType("System.Boolean" ));
			dt.Columns.Add("delivery_status_can_cancel"                 , Type.GetType("System.Boolean" ));
			dt.Columns.Add("delivery_status_status"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("delivery_status_emails_sent"                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("delivery_status_emails_canceled"            , Type.GetType("System.Int64"   ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                                      != null   ) row["id"                                          ] = Sql.ToDBString  (this.id                                           );
			if ( this.date_created                            .HasValue ) row["date_created"                                ] = Sql.ToDBDateTime(this.date_created                           .Value);
			if ( this.created_by                              != null   ) row["created_by"                                  ] = Sql.ToDBString  (this.created_by                                   );
			if ( this.type                                    != null   ) row["type"                                        ] = Sql.ToDBString  (this.type                                         );
			if ( this.archive_url                             != null   ) row["archive_url"                                 ] = Sql.ToDBString  (this.archive_url                                  );
			if ( this.status                                  != null   ) row["status"                                      ] = Sql.ToDBString  (this.status                                       );
			if ( this.emails_sent                             .HasValue ) row["emails_sent"                                 ] = Sql.ToDBInteger (this.emails_sent                            .Value);
			if ( this.send_time                               .HasValue ) row["send_time"                                   ] = Sql.ToDBDateTime(this.send_time                              .Value);
			if ( this.content_type                            != null   ) row["content_type"                                ] = Sql.ToDBString  (this.content_type                                 );
			// Recipients
			// Settings
			if ( this.settings.subject_line                   != null   ) row["subject_line"                                ] = Sql.ToDBString  (this.settings.subject_line                        );
			if ( this.settings.title                          != null   ) row["title"                                       ] = Sql.ToDBString  (this.settings.title                               );
			if ( this.settings.from_name                      != null   ) row["from_name"                                   ] = Sql.ToDBString  (this.settings.from_name                           );
			if ( this.settings.reply_to                       != null   ) row["reply_to"                                    ] = Sql.ToDBString  (this.settings.reply_to                            );
			if ( this.settings.use_conversation               .HasValue ) row["use_conversation"                            ] = Sql.ToDBBoolean (this.settings.use_conversation              .Value);
			if ( this.settings.to_name                        != null   ) row["to_name"                                     ] = Sql.ToDBString  (this.settings.to_name                             );
			if ( this.settings.folder_id                      != null   ) row["folder_id"                                   ] = Sql.ToDBString  (this.settings.folder_id                           );
			if ( this.settings.authenticate                   .HasValue ) row["authenticate"                                ] = Sql.ToDBBoolean (this.settings.authenticate                  .Value);
			if ( this.settings.auto_footer                    .HasValue ) row["auto_footer"                                 ] = Sql.ToDBBoolean (this.settings.auto_footer                   .Value);
			if ( this.settings.inline_css                     .HasValue ) row["inline_css"                                  ] = Sql.ToDBBoolean (this.settings.inline_css                    .Value);
			if ( this.settings.auto_tweet                     .HasValue ) row["auto_tweet"                                  ] = Sql.ToDBBoolean (this.settings.auto_tweet                    .Value);
			if ( this.settings.auto_fb_post                   != null   ) row["auto_fb_post"                                ] = Sql.ToDBString  (this.settings.auto_fb_post                        );
			if ( this.settings.fb_comments                    .HasValue ) row["fb_comments"                                 ] = Sql.ToDBBoolean (this.settings.fb_comments                   .Value);
			if ( this.settings.timewarp                       .HasValue ) row["timewarp"                                    ] = Sql.ToDBBoolean (this.settings.timewarp                      .Value);
			if ( this.settings.template_id                    .HasValue ) row["template_id"                                 ] = Sql.ToDBInteger (this.settings.template_id                   .Value);
			if ( this.settings.drag_and_drop                  .HasValue ) row["drag_and_drop"                               ] = Sql.ToDBBoolean (this.settings.drag_and_drop                 .Value);
			// VariateSettings
			if ( this.variate_settings.winning_combination_id != null   ) row["winning_combination_id"                      ] = Sql.ToDBString  (this.variate_settings.winning_combination_id      );
			if ( this.variate_settings.winning_campaign_id    != null   ) row["winning_campaign_id"                         ] = Sql.ToDBString  (this.variate_settings.winning_campaign_id         );
			if ( this.variate_settings.winner_criteria        != null   ) row["winner_criteria"                             ] = Sql.ToDBString  (this.variate_settings.winner_criteria             );
			if ( this.variate_settings.wait_time              .HasValue ) row["wait_time"                                   ] = Sql.ToDBInteger (this.variate_settings.wait_time             .Value);
			if ( this.variate_settings.test_size              .HasValue ) row["test_size"                                   ] = Sql.ToDBInteger (this.variate_settings.test_size             .Value);
			if ( this.variate_settings.subject_lines          != null   ) row["subject_lines"                               ] = Sql.ToDBString  (String.Join(",", this.variate_settings.subject_lines     .ToArray()));
			if ( this.variate_settings.send_times             != null   ) row["send_times"                                  ] = Sql.ToDBString  (String.Join(",", this.variate_settings.send_times        .ToArray()));
			if ( this.variate_settings.from_names             != null   ) row["from_names"                                  ] = Sql.ToDBString  (String.Join(",", this.variate_settings.from_names        .ToArray()));
			if ( this.variate_settings.reply_to_addresses     != null   ) row["reply_to_addresses"                          ] = Sql.ToDBString  (String.Join(",", this.variate_settings.reply_to_addresses.ToArray()));
			if ( this.variate_settings.contents               != null   ) row["contents"                                    ] = Sql.ToDBString  (String.Join(",", this.variate_settings.contents          .ToArray()));
			// Tracking
			if ( this.tracking.opens                          .HasValue ) row["opens"                                       ] = Sql.ToDBBoolean (this.tracking.opens                         .Value);
			if ( this.tracking.html_clicks                    .HasValue ) row["html_clicks"                                 ] = Sql.ToDBBoolean (this.tracking.html_clicks                   .Value);
			if ( this.tracking.text_clicks                    .HasValue ) row["text_clicks"                                 ] = Sql.ToDBBoolean (this.tracking.text_clicks                   .Value);
			if ( this.tracking.goal_tracking                  .HasValue ) row["goal_tracking"                               ] = Sql.ToDBBoolean (this.tracking.goal_tracking                 .Value);
			if ( this.tracking.ecomm360                       .HasValue ) row["ecomm360"                                    ] = Sql.ToDBBoolean (this.tracking.ecomm360                      .Value);
			if ( this.tracking.google_analytics               != null   ) row["google_analytics"                            ] = Sql.ToDBString  (this.tracking.google_analytics                    );
			if ( this.tracking.clicktale                      != null   ) row["clicktale"                                   ] = Sql.ToDBString  (this.tracking.clicktale                           );
			if ( this.tracking.salesforce != null && this.tracking.salesforce.campaign .HasValue ) row["salesforce_campaign"] = Sql.ToDBBoolean (this.tracking.salesforce.campaign           .Value);
			if ( this.tracking.salesforce != null && this.tracking.salesforce.notes    .HasValue ) row["salesforce_notes"   ] = Sql.ToDBBoolean (this.tracking.salesforce.notes              .Value);
			if ( this.tracking.highrise   != null && this.tracking.highrise  .campaign .HasValue ) row["highrise_campaign"  ] = Sql.ToDBBoolean (this.tracking.highrise  .campaign           .Value);
			if ( this.tracking.highrise   != null && this.tracking.highrise  .notes    .HasValue ) row["highrise_notes"     ] = Sql.ToDBBoolean (this.tracking.highrise  .notes              .Value);
			if ( this.tracking.capsule    != null && this.tracking.capsule   .notes    .HasValue ) row["capsule_notes"      ] = Sql.ToDBBoolean (this.tracking.capsule   .notes              .Value);
			// RssOptions
			if ( this.rss_opts.feed_url                       != null   ) row["rss_opts_feed_url"                           ] = Sql.ToDBString  (this.rss_opts.feed_url                            );
			if ( this.rss_opts.frequency                      != null   ) row["rss_opts_frequency"                          ] = Sql.ToDBString  (this.rss_opts.frequency                           );
			if ( this.rss_opts.last_sent                      .HasValue ) row["rss_opts_last_sent"                          ] = Sql.ToDBDateTime(this.rss_opts.last_sent                     .Value);
			if ( this.rss_opts.constrain_rss_img              .HasValue ) row["rss_opts_constrain_rss_img"                  ] = Sql.ToDBBoolean (this.rss_opts.constrain_rss_img             .Value);
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.hour             .HasValue                                                ) row["rss_opts_schedule_hour"                     ] = Sql.ToDBInteger (this.rss_opts.schedule.hour                .Value);
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.weekly_send_day  != null                                                  ) row["rss_opts_schedule_weekly_send_day"          ] = Sql.ToDBString  (this.rss_opts.schedule.weekly_send_day           );
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.monthly_send_date.HasValue                                                ) row["rss_opts_schedule_monthly_send_date"        ] = Sql.ToDBString  (this.rss_opts.schedule.monthly_send_date   .Value);
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.daily_send != null && this.rss_opts.schedule.daily_send.sunday    != null ) row["rss_opts_schedule_daily_send_sunday"        ] = Sql.ToDBDecimal (this.rss_opts.schedule.daily_send.sunday   .Value);
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.daily_send != null && this.rss_opts.schedule.daily_send.monday    != null ) row["rss_opts_schedule_daily_send_monday"        ] = Sql.ToDBBoolean (this.rss_opts.schedule.daily_send.monday   .Value);
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.daily_send != null && this.rss_opts.schedule.daily_send.tuesday   != null ) row["rss_opts_schedule_daily_send_tuesday"       ] = Sql.ToDBBoolean (this.rss_opts.schedule.daily_send.tuesday  .Value);
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.daily_send != null && this.rss_opts.schedule.daily_send.wednesday != null ) row["rss_opts_schedule_daily_send_wednesday"     ] = Sql.ToDBBoolean (this.rss_opts.schedule.daily_send.wednesday.Value);
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.daily_send != null && this.rss_opts.schedule.daily_send.thursday  != null ) row["rss_opts_schedule_daily_send_thursday"      ] = Sql.ToDBBoolean (this.rss_opts.schedule.daily_send.thursday .Value);
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.daily_send != null && this.rss_opts.schedule.daily_send.friday    != null ) row["rss_opts_schedule_daily_send_friday"        ] = Sql.ToDBBoolean (this.rss_opts.schedule.daily_send.friday   .Value);
			if ( this.rss_opts.schedule != null && this.rss_opts.schedule.daily_send != null && this.rss_opts.schedule.daily_send.saturday  != null ) row["rss_opts_schedule_daily_send_saturday"      ] = Sql.ToDBBoolean (this.rss_opts.schedule.daily_send.saturday .Value);
			// ABTesting
			if ( this.ab_split_opts.split_test                != null   ) row["ab_split_opts_split_test"                    ] = Sql.ToDBString  (this.ab_split_opts.split_test                     );
			if ( this.ab_split_opts.pick_winner               != null   ) row["ab_split_opts_pick_winner"                   ] = Sql.ToDBString  (this.ab_split_opts.pick_winner                    );
			if ( this.ab_split_opts.wait_units                != null   ) row["ab_split_opts_wait_units"                    ] = Sql.ToDBString  (this.ab_split_opts.wait_units                     );
			if ( this.ab_split_opts.wait_time                 .HasValue ) row["ab_split_opts_wait_time"                     ] = Sql.ToDBString  (this.ab_split_opts.wait_time                .Value);
			if ( this.ab_split_opts.split_size                .HasValue ) row["ab_split_opts_split_size"                    ] = Sql.ToDBString  (this.ab_split_opts.split_size               .Value);
			if ( this.ab_split_opts.from_name_a               != null   ) row["ab_split_opts_from_name_a"                   ] = Sql.ToDBString  (this.ab_split_opts.from_name_a                    );
			if ( this.ab_split_opts.from_name_b               != null   ) row["ab_split_opts_from_name_b"                   ] = Sql.ToDBString  (this.ab_split_opts.from_name_b                    );
			if ( this.ab_split_opts.reply_email_a             != null   ) row["ab_split_opts_reply_email_a"                 ] = Sql.ToDBString  (this.ab_split_opts.reply_email_a                  );
			if ( this.ab_split_opts.reply_email_b             != null   ) row["ab_split_opts_reply_email_b"                 ] = Sql.ToDBString  (this.ab_split_opts.reply_email_b                  );
			if ( this.ab_split_opts.subject_a                 != null   ) row["ab_split_opts_subject_a"                     ] = Sql.ToDBString  (this.ab_split_opts.subject_a                      );
			if ( this.ab_split_opts.subject_b                 != null   ) row["ab_split_opts_subject_b"                     ] = Sql.ToDBString  (this.ab_split_opts.subject_b                      );
			if ( this.ab_split_opts.send_time_a               != null   ) row["ab_split_opts_send_time_a"                   ] = Sql.ToDBString  (this.ab_split_opts.send_time_a                    );
			if ( this.ab_split_opts.send_time_b               != null   ) row["ab_split_opts_send_time_b"                   ] = Sql.ToDBString  (this.ab_split_opts.send_time_b                    );
			if ( this.ab_split_opts.send_time_winner          != null   ) row["ab_split_opts_send_time_winner"              ] = Sql.ToDBString  (this.ab_split_opts.send_time_winner               );
			// SocialCard
			if ( this.social_card.image_url                   != null   ) row["social_card_image_url"                       ] = Sql.ToDBString  (this.social_card.image_url                        );
			if ( this.social_card.description                 != null   ) row["social_card_description"                     ] = Sql.ToDBString  (this.social_card.description                      );
			if ( this.social_card.title                       != null   ) row["social_card_title"                           ] = Sql.ToDBString  (this.social_card.title                            );
			// ReportSummary
			if ( this.report_summary.opens                    .HasValue ) row["report_summary_opens"                        ] = Sql.ToDBString  (this.report_summary.opens                   .Value);
			if ( this.report_summary.unique_opens             .HasValue ) row["report_summary_unique_opens"                 ] = Sql.ToDBString  (this.report_summary.unique_opens            .Value);
			if ( this.report_summary.open_rate                .HasValue ) row["report_summary_open_rate"                    ] = Sql.ToDBString  (this.report_summary.open_rate               .Value);
			if ( this.report_summary.clicks                   .HasValue ) row["report_summary_clicks"                       ] = Sql.ToDBString  (this.report_summary.clicks                  .Value);
			if ( this.report_summary.subscriber_clicks        .HasValue ) row["report_summary_subscriber_clicks"            ] = Sql.ToDBString  (this.report_summary.subscriber_clicks       .Value);
			if ( this.report_summary.click_rate               .HasValue ) row["report_summary_click_rate"                   ] = Sql.ToDBString  (this.report_summary.click_rate              .Value);
			// DeliveryStatus
			if ( this.delivery_status.enabled                 .HasValue ) row["delivery_status_enabled"                    ] = Sql.ToDBString  (this.delivery_status.enabled                .Value );
			if ( this.delivery_status.can_cancel              .HasValue ) row["delivery_status_can_cancel"                 ] = Sql.ToDBString  (this.delivery_status.can_cancel             .Value );
			if ( this.delivery_status.status                  != null   ) row["delivery_status_status"                     ] = Sql.ToDBString  (this.delivery_status.status                        );
			if ( this.delivery_status.emails_sent             .HasValue ) row["delivery_status_emails_sent"                ] = Sql.ToDBString  (this.delivery_status.emails_sent            .Value );
			if ( this.delivery_status.emails_canceled         .HasValue ) row["delivery_status_emails_canceled"            ] = Sql.ToDBString  (this.delivery_status.emails_canceled        .Value );
		}

		public static DataRow ConvertToRow(Campaign obj)
		{
			DataTable dt = Campaign.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Campaign> lists)
		{
			DataTable dt = Campaign.CreateTable();
			if ( lists != null )
			{
				foreach ( Campaign list in lists )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					list.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class CampaignPagination
	{
		public IList<Campaign> items      { get; set; }
		public int             total      { get; set; }
	}
}
