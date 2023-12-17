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

namespace Spring.Social.Pardot.Api
{
	[Serializable]
	public class Prospect
	{
		// http://developer.pardot.com/kb/object-field-references/#prospect
		#region Properties
		public String                 RawContent           { get; set; }
		public int                    id                   { get; set; }  // Pardot ID
		public DateTime?              created_at           { get; set; }  // Time prospect was created in Pardot; Time is reported in API 
		public DateTime?              updated_at           { get; set; }  // Last time prospect was updated in Pardot; Time is reported in API 
		public String                 salutation           { get; set; }  // formal prefix
		public String                 first_name           { get; set; }  // first name
		public String                 last_name            { get; set; }  // last name
		public String                 email                { get; set; }  // email address
		public String                 password             { get; set; }  // password
		public String                 company              { get; set; }  // company
		public int?                   prospect_account_id  { get; set; }  // account ID
		public String                 website              { get; set; }  // website URL
		public String                 job_title            { get; set; }  // job title
		public String                 department           { get; set; }  // department
		public String                 country              { get; set; }  // country
		public String                 address_one          { get; set; }  // address, line 1
		public String                 address_two          { get; set; }  // address, line 2
		public String                 city                 { get; set; }  // city
		public String                 state                { get; set; }  // US state
		public String                 territory            { get; set; }  // territory
		public String                 zip                  { get; set; }  // postal code
		public String                 phone                { get; set; }  // phone number
		public String                 fax                  { get; set; }  // fax number
		public String                 source               { get; set; }  // source
		public String                 annual_revenue       { get; set; }  // annual revenue
		public String                 employees            { get; set; }  // number of employees
		public String                 industry             { get; set; }  // industry
		public String                 years_in_business    { get; set; }  // number of years in business
		public String                 comments             { get; set; }  // Comments about this prospect
		public String                 notes                { get; set; }  // Notes about this prospect
		public int?                   score                { get; set; }  // score
		public String                 grade                { get; set; }  // letter grade
		public String                 recent_interaction   { get; set; }  // Describes the most recent interaction with Pardot
		public String                 crm_lead_fid         { get; set; }  // lead ID in a supported CRM system
		public String                 crm_contact_fid      { get; set; }  // contact ID in a supported CRM system
		public String                 crm_owner_fid        { get; set; }  // owner ID in a supported CRM system
		public String                 crm_account_fid      { get; set; }  // Account ID in a supported CRM system
		public DateTime?              crm_last_sync        { get; set; }  // Last time this prospect was synced with a supported CRM system
		public String                 crm_url              { get; set; }  // URL to view the prospect within the CRM system
		public bool?                  is_do_not_email      { get; set; }  // If value is 1, prospect prefers not to be emailed
		public bool?                  is_do_not_call       { get; set; }  // If value is 1, prospect prefers not to be called
		public bool?                  opted_out            { get; set; }  // If value is 1, prospect has opted out of marketing communications
		public bool?                  is_reviewed          { get; set; }  // If value is 1, prospect has been reviewed
		public bool?                  is_starred           { get; set; }  // If value is 1, prospect has been starred
		public int?                   campaign_id          { get; set; }  // Pardot Campaign ID
		public String                 campaign_name        { get; set; }  // Campaign Name. 
		public DateTime?              last_activity_at     { get; set; }  // Time stamp of this latest visitor activity;
		public VisitorActivity        last_activity        { get; set; }
		public IList<VisitorActivity> visitor_activities   { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                   , Type.GetType("System.Int64"   ));
			dt.Columns.Add("created_at"           , Type.GetType("System.DateTime"));
			dt.Columns.Add("updated_at"           , Type.GetType("System.DateTime"));
			dt.Columns.Add("salutation"           , Type.GetType("System.String"  ));
			dt.Columns.Add("first_name"           , Type.GetType("System.String"  ));
			dt.Columns.Add("last_name"            , Type.GetType("System.String"  ));
			dt.Columns.Add("email"                , Type.GetType("System.String"  ));
			dt.Columns.Add("password"             , Type.GetType("System.String"  ));
			dt.Columns.Add("company"              , Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_account_id"  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("website"              , Type.GetType("System.String"  ));
			dt.Columns.Add("job_title"            , Type.GetType("System.String"  ));
			dt.Columns.Add("department"           , Type.GetType("System.String"  ));
			dt.Columns.Add("country"              , Type.GetType("System.String"  ));
			dt.Columns.Add("address_one"          , Type.GetType("System.String"  ));
			dt.Columns.Add("address_two"          , Type.GetType("System.String"  ));
			dt.Columns.Add("city"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("state"                , Type.GetType("System.String"  ));
			dt.Columns.Add("territory"            , Type.GetType("System.String"  ));
			dt.Columns.Add("zip"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                , Type.GetType("System.String"  ));
			dt.Columns.Add("fax"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("source"               , Type.GetType("System.String"  ));
			dt.Columns.Add("annual_revenue"       , Type.GetType("System.String"  ));
			dt.Columns.Add("employees"            , Type.GetType("System.String"  ));
			dt.Columns.Add("industry"             , Type.GetType("System.String"  ));
			dt.Columns.Add("years_in_business"    , Type.GetType("System.String"  ));
			dt.Columns.Add("comments"             , Type.GetType("System.String"  ));
			dt.Columns.Add("notes"                , Type.GetType("System.String"  ));
			dt.Columns.Add("score"                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("grade"                , Type.GetType("System.String"  ));
			dt.Columns.Add("recent_interaction"   , Type.GetType("System.String"  ));
			dt.Columns.Add("crm_lead_fid"         , Type.GetType("System.String"  ));
			dt.Columns.Add("crm_contact_fid"      , Type.GetType("System.String"  ));
			dt.Columns.Add("crm_owner_fid"        , Type.GetType("System.String"  ));
			dt.Columns.Add("crm_account_fid"      , Type.GetType("System.String"  ));
			dt.Columns.Add("crm_last_sync"        , Type.GetType("System.DateTime"));
			dt.Columns.Add("crm_url"              , Type.GetType("System.String"  ));
			dt.Columns.Add("is_do_not_email"      , Type.GetType("System.Boolean" ));
			dt.Columns.Add("is_do_not_call"       , Type.GetType("System.Boolean" ));
			dt.Columns.Add("opted_out"            , Type.GetType("System.Boolean" ));
			dt.Columns.Add("is_reviewed"          , Type.GetType("System.Boolean" ));
			dt.Columns.Add("is_starred"           , Type.GetType("System.Boolean" ));
			dt.Columns.Add("campaign_id"          , Type.GetType("System.Int64"   ));
			dt.Columns.Add("campaign_name"        , Type.GetType("System.String"  ));
			dt.Columns.Add("last_activity_at"     , Type.GetType("System.DateTime"));
			dt.Columns.Add("last_activity_type"   , Type.GetType("System.String"  ));
			dt.Columns.Add("last_activity_details", Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                  != 0      ) row["id"                 ] = Sql.ToDBString  (this.id                       );
			if ( this.created_at          .HasValue ) row["created_at"         ] = Sql.ToDBDateTime(this.created_at               );
			if ( this.updated_at          .HasValue ) row["updated_at"         ] = Sql.ToDBDateTime(this.updated_at               );
			if ( this.salutation          != null   ) row["salutation"         ] = Sql.ToDBString  (this.salutation               );
			if ( this.first_name          != null   ) row["first_name"         ] = Sql.ToDBString  (this.first_name               );
			if ( this.last_name           != null   ) row["last_name"          ] = Sql.ToDBString  (this.last_name                );
			if ( this.email               != null   ) row["email"              ] = Sql.ToDBString  (this.email                    );
			if ( this.password            != null   ) row["password"           ] = Sql.ToDBString  (this.password                 );
			if ( this.company             != null   ) row["company"            ] = Sql.ToDBString  (this.company                  );
			if ( this.prospect_account_id .HasValue ) row["prospect_account_id"] = Sql.ToDBInteger (this.prospect_account_id.Value);
			if ( this.website             != null   ) row["website"            ] = Sql.ToDBString  (this.website                  );
			if ( this.job_title           != null   ) row["job_title"          ] = Sql.ToDBString  (this.job_title                );
			if ( this.department          != null   ) row["department"         ] = Sql.ToDBString  (this.department               );
			if ( this.country             != null   ) row["country"            ] = Sql.ToDBString  (this.country                  );
			if ( this.address_one         != null   ) row["address_one"        ] = Sql.ToDBString  (this.address_one              );
			if ( this.address_two         != null   ) row["address_two"        ] = Sql.ToDBString  (this.address_two              );
			if ( this.city                != null   ) row["city"               ] = Sql.ToDBString  (this.city                     );
			if ( this.state               != null   ) row["state"              ] = Sql.ToDBString  (this.state                    );
			if ( this.territory           != null   ) row["territory"          ] = Sql.ToDBString  (this.territory                );
			if ( this.zip                 != null   ) row["zip"                ] = Sql.ToDBString  (this.zip                      );
			if ( this.phone               != null   ) row["phone"              ] = Sql.ToDBString  (this.phone                    );
			if ( this.fax                 != null   ) row["fax"                ] = Sql.ToDBString  (this.fax                      );
			if ( this.source              != null   ) row["source"             ] = Sql.ToDBString  (this.source                   );
			if ( this.annual_revenue      != null   ) row["annual_revenue"     ] = Sql.ToDBString  (this.annual_revenue           );
			if ( this.employees           != null   ) row["employees"          ] = Sql.ToDBString  (this.employees                );
			if ( this.industry            != null   ) row["industry"           ] = Sql.ToDBString  (this.industry                 );
			if ( this.years_in_business   != null   ) row["years_in_business"  ] = Sql.ToDBString  (this.years_in_business        );
			if ( this.comments            != null   ) row["comments"           ] = Sql.ToDBString  (this.comments                 );
			if ( this.notes               != null   ) row["notes"              ] = Sql.ToDBString  (this.notes                    );
			if ( this.score               .HasValue ) row["score"              ] = Sql.ToDBInteger (this.score              .Value);
			if ( this.grade               != null   ) row["grade"              ] = Sql.ToDBString  (this.grade                    );
			if ( this.last_activity_at    .HasValue ) row["last_activity_at"   ] = Sql.ToDBDateTime(this.last_activity_at   .Value);
			if ( this.recent_interaction  != null   ) row["recent_interaction" ] = Sql.ToDBString  (this.recent_interaction       );
			if ( this.crm_lead_fid        != null   ) row["crm_lead_fid"       ] = Sql.ToDBString  (this.crm_lead_fid             );
			if ( this.crm_contact_fid     != null   ) row["crm_contact_fid"    ] = Sql.ToDBString  (this.crm_contact_fid          );
			if ( this.crm_owner_fid       != null   ) row["crm_owner_fid"      ] = Sql.ToDBString  (this.crm_owner_fid            );
			if ( this.crm_account_fid     != null   ) row["crm_account_fid"    ] = Sql.ToDBString  (this.crm_account_fid          );
			if ( this.crm_last_sync       .HasValue ) row["crm_last_sync"      ] = Sql.ToDBDateTime(this.crm_last_sync      .Value);
			if ( this.crm_url             != null   ) row["crm_url"            ] = Sql.ToDBString  (this.crm_url                  );
			if ( this.is_do_not_email     .HasValue ) row["is_do_not_email"    ] = Sql.ToDBBoolean (this.is_do_not_email    .Value);
			if ( this.is_do_not_call      .HasValue ) row["is_do_not_call"     ] = Sql.ToDBBoolean (this.is_do_not_call     .Value);
			if ( this.opted_out           .HasValue ) row["opted_out"          ] = Sql.ToDBBoolean (this.opted_out          .Value);
			if ( this.is_reviewed         .HasValue ) row["is_reviewed"        ] = Sql.ToDBBoolean (this.is_reviewed        .Value);
			if ( this.is_starred          .HasValue ) row["is_starred"         ] = Sql.ToDBBoolean (this.is_starred         .Value);
			if ( this.campaign_id         .HasValue ) row["campaign_id"        ] = Sql.ToDBInteger (this.campaign_id        .Value);
			if ( this.campaign_name       != null   ) row["campaign_name"      ] = Sql.ToDBString  (this.campaign_name            );
			if ( this.last_activity != null )
			{
				row["last_activity_type"   ] = Sql.ToDBString  (this.last_activity.type_name);
				row["last_activity_details"] = Sql.ToDBString  (this.last_activity.details  );
			}
		}

		public static DataRow ConvertToRow(Prospect obj)
		{
			DataTable dt = Prospect.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Prospect> prospects)
		{
			DataTable dt = Prospect.CreateTable();
			if ( prospects != null )
			{
				foreach ( Prospect prospect in prospects )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					prospect.SetRow(row);
				}
			}
			return dt;
		}

		public DataTable GetVisitorActivities()
		{
			DataTable dt = VisitorActivity.CreateTable();
			if ( this.visitor_activities != null )
			{
				foreach ( VisitorActivity activity in this.visitor_activities )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					activity.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class ProspectPagination
	{
		public IList<Prospect> items      { get; set; }
		public int             total      { get; set; }
	}
}
