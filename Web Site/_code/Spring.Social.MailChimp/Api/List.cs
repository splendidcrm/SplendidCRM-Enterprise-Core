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
	public class List : HBase
	{
		// Contact Properties. 
		public class Contact
		{
			public String    company                      { get; set; }
			public String    address1                     { get; set; }
			public String    address2                     { get; set; }
			public String    city                         { get; set; }
			public String    state                        { get; set; }
			public String    zip                          { get; set; }
			public String    country                      { get; set; }
			public String    phone                        { get; set; }
		}

		public class CampaignDefaults
		{
			public String    from_name                    { get; set; }
			public String    from_email                   { get; set; }
			public String    subject                      { get; set; }
			public String    language                     { get; set; }
		}

		public class Stats
		{
			public int?      member_count                 { get; set; }
			public int?      unsubscribe_count            { get; set; }
			public int?      cleaned_count                { get; set; }
			public int?      member_count_since_send      { get; set; }
			public int?      unsubscribe_count_since_send { get; set; }
			public int?      cleaned_count_since_send     { get; set; }
			public int?      campaign_count               { get; set; }
			public DateTime? campaign_last_sent           { get; set; }
			public int?      merge_field_count            { get; set; }
			public Decimal?  avg_sub_rate                 { get; set; }
			public Decimal?  avg_unsub_rate               { get; set; }
			public Decimal?  target_sub_rate              { get; set; }
			public Decimal?  open_rate                    { get; set; }
			public Decimal?  click_rate                   { get; set; }
			public DateTime? last_sub_date                { get; set; }
			public DateTime? last_unsub_date              { get; set; }
		}

		#region Properties
		public String           name                      { get; set; }
		public String           permission_reminder       { get; set; }
		public bool?            use_archive_bar           { get; set; }
		public String           notify_on_subscribe       { get; set; }
		public String           notify_on_unsubscribe     { get; set; }
		public int?             list_rating               { get; set; }
		public bool?            email_type_option         { get; set; }
		public String           subscribe_url_short       { get; set; }
		public String           subscribe_url_long        { get; set; }
		public String           beamer_address            { get; set; }
		public String           visibility                { get; set; }
		public List<String>     modules                   { get; set; }
		public Contact          contact                   { get; set; }
		public CampaignDefaults campaign_defaults         { get; set; }
		public Stats            stats                     { get; set; }
		#endregion

		public List()
		{
			this.contact           = new Contact();
			this.campaign_defaults = new CampaignDefaults();
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                           , Type.GetType("System.String"  ));
			dt.Columns.Add("date_created"                 , Type.GetType("System.DateTime"));  // 2015-09-15T13:09:22+00:00
			dt.Columns.Add("created_by"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("permission_reminder"          , Type.GetType("System.String"  ));
			dt.Columns.Add("use_archive_bar"              , Type.GetType("System.Boolean" ));
			dt.Columns.Add("notify_on_subscribe"          , Type.GetType("System.String"  ));
			dt.Columns.Add("notify_on_unsubscribe"        , Type.GetType("System.String"  ));
			dt.Columns.Add("list_rating"                  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("email_type_option"            , Type.GetType("System.Boolean" ));
			dt.Columns.Add("subscribe_url_short"          , Type.GetType("System.String"  ));
			dt.Columns.Add("subscribe_url_long"           , Type.GetType("System.String"  ));
			dt.Columns.Add("beamer_address"               , Type.GetType("System.String"  ));
			dt.Columns.Add("visibility"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("modules"                      , Type.GetType("System.String"  ));
			// Contact
			dt.Columns.Add("name"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("company"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("address1"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("address2"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("city"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("state"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("zip"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("country"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                        , Type.GetType("System.String"  ));
			// Campaign Defaults
			dt.Columns.Add("from_name"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("from_email"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("subject"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("language"                     , Type.GetType("System.String"  ));
			// Stats
			dt.Columns.Add("member_count"                 , Type.GetType("System.Int64"   ));
			dt.Columns.Add("unsubscribe_count"            , Type.GetType("System.Int64"   ));
			dt.Columns.Add("cleaned_count"                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("member_count_since_send"      , Type.GetType("System.Int64"   ));
			dt.Columns.Add("unsubscribe_count_since_send" , Type.GetType("System.Int64"   ));
			dt.Columns.Add("cleaned_count_since_send"     , Type.GetType("System.Int64"   ));
			dt.Columns.Add("campaign_count"               , Type.GetType("System.Int64"   ));
			dt.Columns.Add("campaign_last_sent"           , Type.GetType("System.DateTime"));
			dt.Columns.Add("merge_field_count"            , Type.GetType("System.Int64"   ));
			dt.Columns.Add("avg_sub_rate"                 , Type.GetType("System.Decimal" ));
			dt.Columns.Add("avg_unsub_rate"               , Type.GetType("System.Decimal" ));
			dt.Columns.Add("target_sub_rate"              , Type.GetType("System.Decimal" ));
			dt.Columns.Add("open_rate"                    , Type.GetType("System.Decimal" ));
			dt.Columns.Add("click_rate"                   , Type.GetType("System.Decimal" ));
			dt.Columns.Add("last_sub_date"                , Type.GetType("System.DateTime"));
			dt.Columns.Add("last_unsub_date"              , Type.GetType("System.DateTime"));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                     != null   ) row["id"                   ] = Sql.ToDBString  (this.id                         );
			if ( this.date_created           .HasValue ) row["date_created"         ] = Sql.ToDBDateTime(this.date_created         .Value);
			if ( this.created_by             != null   ) row["created_by"           ] = Sql.ToDBString  (this.created_by                 );
			if ( this.name                   != null   ) row["name"                 ] = Sql.ToDBString  (this.name                       );
			if ( this.permission_reminder    != null   ) row["permission_reminder"  ] = Sql.ToDBString  (this.permission_reminder        );
			if ( this.use_archive_bar        .HasValue ) row["use_archive_bar"      ] = Sql.ToDBBoolean (this.use_archive_bar      .Value);
			if ( this.notify_on_subscribe    != null   ) row["notify_on_subscribe"  ] = Sql.ToDBString  (this.notify_on_subscribe        );
			if ( this.notify_on_unsubscribe  != null   ) row["notify_on_unsubscribe"] = Sql.ToDBString  (this.notify_on_unsubscribe      );
			if ( this.list_rating            .HasValue ) row["list_rating"          ] = Sql.ToDBInteger (this.list_rating          .Value);
			if ( this.email_type_option      .HasValue ) row["email_type_option"    ] = Sql.ToDBBoolean (this.email_type_option    .Value);
			if ( this.subscribe_url_short    != null   ) row["subscribe_url_short"  ] = Sql.ToDBString  (this.subscribe_url_short        );
			if ( this.subscribe_url_long     != null   ) row["subscribe_url_long"   ] = Sql.ToDBString  (this.subscribe_url_long         );
			if ( this.beamer_address         != null   ) row["beamer_address"       ] = Sql.ToDBString  (this.beamer_address             );
			if ( this.visibility             != null   ) row["visibility"           ] = Sql.ToDBString  (this.visibility                 );
			if ( this.modules                != null   ) row["modules"              ] = Sql.ToDBString  (String.Join(",", this.modules)  );
			// Contact
			if ( this.contact           != null && this.contact.company                     != null   ) row["company"                      ] = Sql.ToDBString  (this.contact.company                     );
			if ( this.contact           != null && this.contact.address1                    != null   ) row["address1"                     ] = Sql.ToDBString  (this.contact.address1                    );
			if ( this.contact           != null && this.contact.address2                    != null   ) row["address2"                     ] = Sql.ToDBString  (this.contact.address2                    );
			if ( this.contact           != null && this.contact.city                        != null   ) row["city"                         ] = Sql.ToDBString  (this.contact.city                        );
			if ( this.contact           != null && this.contact.state                       != null   ) row["state"                        ] = Sql.ToDBString  (this.contact.state                       );
			if ( this.contact           != null && this.contact.zip                         != null   ) row["zip"                          ] = Sql.ToDBString  (this.contact.zip                         );
			if ( this.contact           != null && this.contact.country                     != null   ) row["country"                      ] = Sql.ToDBString  (this.contact.country                     );
			if ( this.contact           != null && this.contact.phone                       != null   ) row["phone"                        ] = Sql.ToDBString  (this.contact.phone                       );
			// Campaing Defaults
			if ( this.campaign_defaults != null && this.campaign_defaults.from_name         != null   ) row["from_name"                    ] = Sql.ToDBString  (this.campaign_defaults.from_name         );
			if ( this.campaign_defaults != null && this.campaign_defaults.from_email        != null   ) row["from_email"                   ] = Sql.ToDBString  (this.campaign_defaults.from_email        );
			if ( this.campaign_defaults != null && this.campaign_defaults.subject           != null   ) row["subject"                      ] = Sql.ToDBString  (this.campaign_defaults.subject           );
			if ( this.campaign_defaults != null && this.campaign_defaults.language          != null   ) row["language"                     ] = Sql.ToDBString  (this.campaign_defaults.language          );
			// Stats
			if ( this.stats             != null && this.stats.member_count                  != null   ) row["member_count"                 ] = Sql.ToDBInteger (this.stats.member_count                .Value);
			if ( this.stats             != null && this.stats.unsubscribe_count             != null   ) row["unsubscribe_count"            ] = Sql.ToDBInteger (this.stats.unsubscribe_count           .Value);
			if ( this.stats             != null && this.stats.cleaned_count                 != null   ) row["cleaned_count"                ] = Sql.ToDBInteger (this.stats.cleaned_count               .Value);
			if ( this.stats             != null && this.stats.member_count_since_send       != null   ) row["member_count_since_send"      ] = Sql.ToDBInteger (this.stats.member_count_since_send     .Value);
			if ( this.stats             != null && this.stats.unsubscribe_count_since_send  != null   ) row["unsubscribe_count_since_send" ] = Sql.ToDBInteger (this.stats.unsubscribe_count_since_send.Value);
			if ( this.stats             != null && this.stats.cleaned_count_since_send      != null   ) row["cleaned_count_since_send"     ] = Sql.ToDBInteger (this.stats.cleaned_count_since_send    .Value);
			if ( this.stats             != null && this.stats.campaign_count                != null   ) row["campaign_count"               ] = Sql.ToDBInteger (this.stats.campaign_count              .Value);
			if ( this.stats             != null && this.stats.campaign_last_sent            != null   ) row["campaign_last_sent"           ] = Sql.ToDBDateTime(this.stats.campaign_last_sent          .Value);
			if ( this.stats             != null && this.stats.merge_field_count             != null   ) row["merge_field_count"            ] = Sql.ToDBInteger (this.stats.merge_field_count           .Value);
			if ( this.stats             != null && this.stats.avg_sub_rate                  != null   ) row["avg_sub_rate"                 ] = Sql.ToDBDecimal (this.stats.avg_sub_rate                .Value);
			if ( this.stats             != null && this.stats.avg_unsub_rate                != null   ) row["avg_unsub_rate"               ] = Sql.ToDBDecimal (this.stats.avg_unsub_rate              .Value);
			if ( this.stats             != null && this.stats.target_sub_rate               != null   ) row["target_sub_rate"              ] = Sql.ToDBDecimal (this.stats.target_sub_rate             .Value);
			if ( this.stats             != null && this.stats.open_rate                     != null   ) row["open_rate"                    ] = Sql.ToDBDecimal (this.stats.open_rate                   .Value);
			if ( this.stats             != null && this.stats.click_rate                    != null   ) row["click_rate"                   ] = Sql.ToDBDecimal (this.stats.click_rate                  .Value);
			if ( this.stats             != null && this.stats.last_sub_date                 != null   ) row["last_sub_date"                ] = Sql.ToDBDateTime(this.stats.last_sub_date               .Value);
			if ( this.stats             != null && this.stats.last_unsub_date               != null   ) row["last_unsub_date"              ] = Sql.ToDBDateTime(this.stats.last_unsub_date             .Value);
		}

		public static DataRow ConvertToRow(Spring.Social.MailChimp.Api.List obj)
		{
			DataTable dt = Spring.Social.MailChimp.Api.List.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Spring.Social.MailChimp.Api.List> lists)
		{
			DataTable dt = Spring.Social.MailChimp.Api.List.CreateTable();
			if ( lists != null )
			{
				foreach ( Spring.Social.MailChimp.Api.List list in lists )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					list.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class ListPagination
	{
		public IList<Spring.Social.MailChimp.Api.List> items      { get; set; }
		public int                                     total      { get; set; }
	}
}
