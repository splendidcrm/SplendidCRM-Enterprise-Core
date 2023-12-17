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
	public class Member : HBase
	{
		public class MergeField
		{
			public String     field_name                 { get; set; }
			public String     value                      { get; set; }

			public MergeField(String field_name, String value)
			{
				this.field_name = field_name;
				this.value      = value     ;
			}
		}

		public class Interest
		{
			public String     interest_id                { get; set; }
			public bool?      value                      { get; set; }
		}

		public class Stats
		{
			public Decimal?   avg_open_rate              { get; set; }
			public Decimal?   avg_click_rate             { get; set; }
		}

		public class Location
		{
			public Decimal?   latitude                   { get; set; }
			public Decimal?   longitude                  { get; set; }
			public int?       gmtoff                     { get; set; }
			public int?       dstoff                     { get; set; }
			public String     country_code               { get; set; }
			public String     timezone                   { get; set; }
		}

		public class Note
		{
			public String     note_id                    { get; set; }
			public DateTime?  created_at                 { get; set; }
			public String     created_by                 { get; set; }
			public String     note                       { get; set; }
		}

		#region Properties
		// http://developer.mailchimp.com/documentation/mailchimp/reference/lists/members/#
		public String           email_address            { get; set; }
		public String           unique_email_id          { get; set; }
		public String           email_type               { get; set; }
		public String           status                   { get; set; }
		public String           status_if_new            { get; set; }
		public List<MergeField> merge_fields             { get; set; }
		public List<Interest >  interests                { get; set; }
		public Stats            stats                    { get; set; }
		public String           ip_signup                { get; set; }
		public DateTime?        timestamp_signup         { get; set; }
		public String           ip_opt                   { get; set; }
		public DateTime?        timestamp_opt            { get; set; }
		public String           member_rating            { get; set; }
		public String           language                 { get; set; }
		public bool?            vip                      { get; set; }
		public String           email_client             { get; set; }
		public Location         location                 { get; set; }
		public Note             last_note                { get; set; }
		public String           list_id                  { get; set; }
		#endregion

		public void SetMergeField(string field_name, string value)
		{
			if ( this.merge_fields == null )
				this.merge_fields = new List<Spring.Social.MailChimp.Api.Member.MergeField>();
			bool bFound = false;
			foreach ( Spring.Social.MailChimp.Api.Member.MergeField field in this.merge_fields )
			{
				if ( field.field_name == field_name )
				{
					field.value = value;
					bFound = true;
				}
			}
			if ( !bFound )
			{
				Spring.Social.MailChimp.Api.Member.MergeField field = new MergeField(field_name, value);
				this.merge_fields.Add(field);
			}
		}

		public string GetMergeField(string field_name)
		{
			string value = String.Empty;
			if ( this.merge_fields != null )
			{
				foreach ( Spring.Social.MailChimp.Api.Member.MergeField field in this.merge_fields )
				{
					if ( field.field_name == field_name )
					{
						value = field.value;
						break;
					}
				}
			}
			return value;
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"              , Type.GetType("System.String"  ));
			dt.Columns.Add("date_created"    , Type.GetType("System.DateTime"));  // 2015-09-15T13:09:22+00:00
			dt.Columns.Add("email_address"   , Type.GetType("System.String"  ));
			dt.Columns.Add("unique_email_id" , Type.GetType("System.String"  ));
			dt.Columns.Add("email_type"      , Type.GetType("System.String"  ));
			dt.Columns.Add("status"          , Type.GetType("System.String"  ));
			dt.Columns.Add("status_if_new"   , Type.GetType("System.String"  ));
			dt.Columns.Add("avg_open_rate"   , Type.GetType("System.Decimal" ));
			dt.Columns.Add("avg_click_rate"  , Type.GetType("System.Decimal" ));
			dt.Columns.Add("ip_signup"       , Type.GetType("System.String"  ));
			dt.Columns.Add("timestamp_signup", Type.GetType("System.DateTime"));
			dt.Columns.Add("ip_opt"          , Type.GetType("System.String"  ));
			dt.Columns.Add("timestamp_opt"   , Type.GetType("System.DateTime"));
			dt.Columns.Add("member_rating"   , Type.GetType("System.String"  ));
			dt.Columns.Add("language"        , Type.GetType("System.String"  ));
			dt.Columns.Add("vip"             , Type.GetType("System.Boolean" ));
			dt.Columns.Add("email_client"    , Type.GetType("System.String"  ));
			dt.Columns.Add("latitude"        , Type.GetType("System.Decimal" ));
			dt.Columns.Add("longitude"       , Type.GetType("System.Decimal" ));
			dt.Columns.Add("gmtoff"          , Type.GetType("System.Int64"   ));
			dt.Columns.Add("dstoff"          , Type.GetType("System.Int64"   ));
			dt.Columns.Add("country_code"    , Type.GetType("System.String"  ));
			dt.Columns.Add("timezone"        , Type.GetType("System.String"  ));
			dt.Columns.Add("note_id"         , Type.GetType("System.String"  ));
			dt.Columns.Add("note_created_at" , Type.GetType("System.DateTime"));
			dt.Columns.Add("note_created_by" , Type.GetType("System.String"  ));
			dt.Columns.Add("note"            , Type.GetType("System.String"  ));
			dt.Columns.Add("list_id"         , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                                              != null   ) row["id"              ] = Sql.ToDBString  (this.id                           );
			if ( this.date_created                                    .HasValue ) row["date_created"    ] = Sql.ToDBDateTime(this.date_created          .Value );
			if ( this.email_address                                   != null   ) row["email_address"   ] = Sql.ToDBString  (this.email_address                );
			if ( this.unique_email_id                                 != null   ) row["unique_email_id" ] = Sql.ToDBString  (this.unique_email_id              );
			if ( this.email_type                                      != null   ) row["email_type"      ] = Sql.ToDBString  (this.email_type                   );
			if ( this.status                                          != null   ) row["status"          ] = Sql.ToDBString  (this.status                       );
			if ( this.status_if_new                                   != null   ) row["status_if_new"   ] = Sql.ToDBString  (this.status_if_new                );
			if ( this.stats     != null && this.stats.avg_open_rate   .HasValue ) row["avg_open_rate"   ] = Sql.ToDBDecimal (this.stats.avg_open_rate   .Value );
			if ( this.stats     != null && this.stats.avg_click_rate  .HasValue ) row["avg_click_rate"  ] = Sql.ToDBDecimal (this.stats.avg_click_rate  .Value );
			if ( this.ip_signup                                       != null   ) row["ip_signup"       ] = Sql.ToDBString  (this.ip_signup                    );
			if ( this.timestamp_signup                                .HasValue ) row["timestamp_signup"] = Sql.ToDateTime  (this.timestamp_signup      .Value );
			if ( this.ip_opt                                          != null   ) row["ip_opt"          ] = Sql.ToDBString  (this.ip_opt                       );
			if ( this.timestamp_opt                                   .HasValue ) row["timestamp_opt"   ] = Sql.ToDateTime  (this.timestamp_opt         .Value );
			if ( this.member_rating                                   != null   ) row["member_rating"   ] = Sql.ToDBString  (this.member_rating                );
			if ( this.language                                        != null   ) row["language"        ] = Sql.ToDBString  (this.language                     );
			if ( this.vip                                             .HasValue ) row["vip"             ] = Sql.ToDBString  (this.vip                   .Value );
			if ( this.email_client                                    != null   ) row["email_client"    ] = Sql.ToBoolean   (this.email_client                 );
			if ( this.location  != null && this.location.latitude     .HasValue ) row["latitude"        ] = Sql.ToDBDecimal (this.location.latitude     .Value );
			if ( this.location  != null && this.location.longitude    .HasValue ) row["longitude"       ] = Sql.ToDBDecimal (this.location.longitude    .Value );
			if ( this.location  != null && this.location.gmtoff       .HasValue ) row["gmtoff"          ] = Sql.ToDBInteger (this.location.gmtoff       .Value );
			if ( this.location  != null && this.location.dstoff       .HasValue ) row["dstoff"          ] = Sql.ToDBInteger (this.location.dstoff       .Value );
			if ( this.location  != null && this.location.country_code != null   ) row["country_code"    ] = Sql.ToDBString  (this.location.country_code        );
			if ( this.location  != null && this.location.timezone     != null   ) row["timezone"        ] = Sql.ToDBString  (this.location.timezone            );
			if ( this.last_note != null && this.last_note.note_id     != null   ) row["note_id"         ] = Sql.ToDBString  (this.last_note.note_id            );
			if ( this.last_note != null && this.last_note.created_at  .HasValue ) row["note_created_at" ] = Sql.ToDateTime  (this.last_note.created_at  .Value );
			if ( this.last_note != null && this.last_note.created_by  != null   ) row["note_created_by" ] = Sql.ToDBString  (this.last_note.created_by         );
			if ( this.last_note != null && this.last_note.note        != null   ) row["note"            ] = Sql.ToDBString  (this.last_note.note               );
			if ( this.list_id                                         != null   ) row["list_id"         ] = Sql.ToDBString  (this.list_id                      );
		}

		public static DataRow ConvertToRow(Member obj)
		{
			DataTable dt = Member.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Member> members)
		{
			DataTable dt = Member.CreateTable();
			if ( members != null )
			{
				foreach ( Member member in members )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					member.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class MemberPagination
	{
		public IList<Member> items      { get; set; }
		public int           total      { get; set; }
	}

	// 02/16/2017 Paul.  Make sure that member does not exist. 
	public class MemberSearch
	{
		public IList<Member> items      { get; set; }
		public int           total      { get; set; }
	}

}
