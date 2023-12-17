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

namespace Spring.Social.HubSpot.Api
{
	// http://developers.hubspot.com/docs/methods/companies/companies-overview
	// http://knowledge.hubspot.com/contacts-user-guide/how-to-use-company-properties
	[Serializable]
	public class Company : HBase
	{
		#region Properties
		// http://knowledge.hubspot.com/contacts-user-guide/how-to-use-company-properties
		public DateTime? hubspot_owner_assigneddate                    { get; set; }  // read-only 

		// 09/27/2020 Paul.  HubSpot is now using long instead of integers. 
		public String    name                                          { get; set; }
		public String    phone                                         { get; set; }
		public String    address                                       { get; set; }
		public String    address2                                      { get; set; }
		public String    city                                          { get; set; }
		public String    state                                         { get; set; }
		public String    zip                                           { get; set; }
		public String    country                                       { get; set; }
		public String    timezone                                      { get; set; }
		public String    website                                       { get; set; }
		public String    domain                                        { get; set; }
		public String    about_us                                      { get; set; }
		public String    founded_year                                  { get; set; }
		public bool?     is_public                                     { get; set; }
		public long?     numberofemployees                             { get; set; }
		public String    industry                                      { get; set; }
		public String    type                                          { get; set; }
		public String    description                                   { get; set; }
		public String    total_money_raised                            { get; set; }
		public Decimal?  annualrevenue                                 { get; set; }
		public DateTime? closedate                                     { get; set; }
		public String    lifecyclestage                                { get; set; }
		public String    hs_lead_status                                { get; set; }
		public String    twitterhandle                                 { get; set; }
		public String    twitterbio                                    { get; set; }
		public long?     twitterfollowers                              { get; set; }
		public String    facebook_company_page                         { get; set; }
		public long?     facebookfans                                  { get; set; }
		public String    linkedin_company_page                         { get; set; }
		public String    linkedinbio                                   { get; set; }
		public String    googleplus_page                               { get; set; }

		// http://knowledge.hubspot.com/contacts-user-guide/how-to-use-company-properties
		// https://api.hubapi.com/companies/v2/properties?access_token=
		public long?     days_to_close                                 { get; set; }  // read-only 
		public DateTime? first_contact_createdate                      { get; set; }  // read-only 
		public DateTime? first_conversion_date                         { get; set; }  // read-only 
		public String    first_conversion_event_name                   { get; set; }  // read-only 
		public String    hs_analytics_source                           { get; set; }  // read-only 
		public String    hs_analytics_source_data_1                    { get; set; }  // read-only 
		public String    hs_analytics_source_data_2                    { get; set; }  // read-only 
		public DateTime? hs_analytics_first_timestamp                  { get; set; }  // read-only 
		public DateTime? hs_analytics_last_timestamp                   { get; set; }  // read-only 
		public DateTime? hs_analytics_first_visit_timestamp            { get; set; }  // read-only 
		public DateTime? hs_analytics_last_visit_timestamp             { get; set; }  // read-only 
		public long?     hs_analytics_num_page_views                   { get; set; }  // read-only 
		public long?     hs_analytics_num_visits                       { get; set; }  // read-only 
		public long?     num_conversion_events                         { get; set; }  // read-only 
		public DateTime? recent_conversion_date                        { get; set; }  // read-only 
		public String    recent_conversion_event_name                  { get; set; }  // read-only 
		public long?     hubspotscore                                  { get; set; }  // read-only 
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                                            , Type.GetType("System.Int64"   ));
			dt.Columns.Add("isDeleted"                                     , Type.GetType("System.Boolean" ));
			dt.Columns.Add("createdate"                                    , Type.GetType("System.DateTime"));
			dt.Columns.Add("lastmodifieddate"                              , Type.GetType("System.DateTime"));
			dt.Columns.Add("hubspot_owner_id"                              , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hubspot_owner_assigneddate"                    , Type.GetType("System.DateTime"));
			dt.Columns.Add("name"                                          , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                                         , Type.GetType("System.String"  ));
			dt.Columns.Add("address"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("address2"                                      , Type.GetType("System.String"  ));
			dt.Columns.Add("city"                                          , Type.GetType("System.String"  ));
			dt.Columns.Add("state"                                         , Type.GetType("System.String"  ));
			dt.Columns.Add("zip"                                           , Type.GetType("System.String"  ));
			dt.Columns.Add("country"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("timezone"                                      , Type.GetType("System.String"  ));
			dt.Columns.Add("website"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("domain"                                        , Type.GetType("System.String"  ));
			dt.Columns.Add("about_us"                                      , Type.GetType("System.String"  ));
			dt.Columns.Add("founded_year"                                  , Type.GetType("System.String"  ));
			dt.Columns.Add("is_public"                                     , Type.GetType("System.Boolean" ));
			dt.Columns.Add("numberofemployees"                             , Type.GetType("System.Int64"   ));
			dt.Columns.Add("industry"                                      , Type.GetType("System.String"  ));
			dt.Columns.Add("type"                                          , Type.GetType("System.String"  ));
			dt.Columns.Add("description"                                   , Type.GetType("System.String"  ));
			dt.Columns.Add("total_money_raised"                            , Type.GetType("System.String"  ));
			dt.Columns.Add("annualrevenue"                                 , Type.GetType("System.Decimal" ));
			dt.Columns.Add("closedate"                                     , Type.GetType("System.DateTime"));
			dt.Columns.Add("lifecyclestage"                                , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_lead_status"                                , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterhandle"                                 , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterbio"                                    , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterfollowers"                              , Type.GetType("System.Int64"   ));
			dt.Columns.Add("facebook_company_page"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("facebookfans"                                  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("linkedin_company_page"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("linkedinbio"                                   , Type.GetType("System.String"  ));
			dt.Columns.Add("googleplus_page"                               , Type.GetType("System.String"  ));
			dt.Columns.Add("days_to_close"                                 , Type.GetType("System.Int64"   ));
			dt.Columns.Add("first_contact_createdate"                      , Type.GetType("System.DateTime"));
			dt.Columns.Add("first_conversion_date"                         , Type.GetType("System.DateTime"));
			dt.Columns.Add("first_conversion_event_name"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_source"                           , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_source_data_1"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_source_data_2"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_first_timestamp"                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_analytics_last_timestamp"                   , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_analytics_first_visit_timestamp"            , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_analytics_last_visit_timestamp"             , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_analytics_num_page_views"                   , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_analytics_num_visits"                       , Type.GetType("System.Int64"   ));
			dt.Columns.Add("num_conversion_events"                         , Type.GetType("System.Int64"   ));
			dt.Columns.Add("recent_conversion_date"                        , Type.GetType("System.DateTime"));
			dt.Columns.Add("recent_conversion_event_name"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("hubspotscore"                                  , Type.GetType("System.Int64"   ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                                            .HasValue ) row["id"                                            ] = Sql.ToDBInteger (this.id                                      .Value);
			if ( this.isDeleted                                     .HasValue ) row["isDeleted"                                     ] = Sql.ToDBBoolean (this.isDeleted                               .Value);
			if ( this.createdate                                    .HasValue ) row["createdate"                                    ] = Sql.ToDBDateTime(this.createdate                              .Value);
			if ( this.lastmodifieddate                              .HasValue ) row["lastmodifieddate"                              ] = Sql.ToDBDateTime(this.lastmodifieddate                        .Value);
			if ( this.hubspot_owner_id                              .HasValue ) row["hubspot_owner_id"                              ] = Sql.ToDBInteger (this.hubspot_owner_id                        .Value);
			if ( this.hubspot_owner_assigneddate                    .HasValue ) row["hubspot_owner_assigneddate"                    ] = Sql.ToDBDateTime(this.hubspot_owner_assigneddate              .Value);
			if ( this.name                                          != null   ) row["name"                                          ] = Sql.ToDBString  (this.name                                          );
			if ( this.phone                                         != null   ) row["phone"                                         ] = Sql.ToDBString  (this.phone                                         );
			if ( this.address                                       != null   ) row["address"                                       ] = Sql.ToDBString  (this.address                                       );
			if ( this.address2                                      != null   ) row["address2"                                      ] = Sql.ToDBString  (this.address2                                      );
			if ( this.city                                          != null   ) row["city"                                          ] = Sql.ToDBString  (this.city                                          );
			if ( this.state                                         != null   ) row["state"                                         ] = Sql.ToDBString  (this.state                                         );
			if ( this.zip                                           != null   ) row["zip"                                           ] = Sql.ToDBString  (this.zip                                           );
			if ( this.country                                       != null   ) row["country"                                       ] = Sql.ToDBString  (this.country                                       );
			if ( this.timezone                                      != null   ) row["timezone"                                      ] = Sql.ToDBString  (this.timezone                                      );
			if ( this.website                                       != null   ) row["website"                                       ] = Sql.ToDBString  (this.website                                       );
			if ( this.domain                                        != null   ) row["domain"                                        ] = Sql.ToDBString  (this.domain                                        );
			if ( this.about_us                                      != null   ) row["about_us"                                      ] = Sql.ToDBString  (this.about_us                                      );
			if ( this.founded_year                                  != null   ) row["founded_year"                                  ] = Sql.ToDBString  (this.founded_year                                  );
			if ( this.is_public                                     .HasValue ) row["is_public"                                     ] = Sql.ToDBBoolean (this.is_public                               .Value);
			if ( this.numberofemployees                             .HasValue ) row["numberofemployees"                             ] = Sql.ToDBInteger (this.numberofemployees                       .Value);
			if ( this.industry                                      != null   ) row["industry"                                      ] = Sql.ToDBString  (this.industry                                      );
			if ( this.type                                          != null   ) row["type"                                          ] = Sql.ToDBString  (this.type                                          );
			if ( this.description                                   != null   ) row["description"                                   ] = Sql.ToDBString  (this.description                                   );
			if ( this.total_money_raised                            != null   ) row["total_money_raised"                            ] = Sql.ToDBString  (this.total_money_raised                            );
			if ( this.annualrevenue                                 .HasValue ) row["annualrevenue"                                 ] = Sql.ToDBDecimal (this.annualrevenue                           .Value);
			if ( this.closedate                                     .HasValue ) row["closedate"                                     ] = Sql.ToDBDateTime(this.closedate                               .Value);
			if ( this.lifecyclestage                                != null   ) row["lifecyclestage"                                ] = Sql.ToDBString  (this.lifecyclestage                                );
			if ( this.hs_lead_status                                != null   ) row["hs_lead_status"                                ] = Sql.ToDBString  (this.hs_lead_status                                );
			if ( this.twitterhandle                                 != null   ) row["twitterhandle"                                 ] = Sql.ToDBString  (this.twitterhandle                                 );
			if ( this.twitterbio                                    != null   ) row["twitterbio"                                    ] = Sql.ToDBString  (this.twitterbio                                    );
			if ( this.twitterfollowers                              .HasValue ) row["twitterfollowers"                              ] = Sql.ToDBInteger (this.twitterfollowers                        .Value);
			if ( this.facebook_company_page                         != null   ) row["facebook_company_page"                         ] = Sql.ToDBString  (this.facebook_company_page                         );
			if ( this.facebookfans                                  .HasValue ) row["facebookfans"                                  ] = Sql.ToDBInteger (this.facebookfans                            .Value);
			if ( this.linkedin_company_page                         != null   ) row["linkedin_company_page"                         ] = Sql.ToDBString  (this.linkedin_company_page                         );
			if ( this.linkedinbio                                   != null   ) row["linkedinbio"                                   ] = Sql.ToDBString  (this.linkedinbio                                   );
			if ( this.googleplus_page                               != null   ) row["googleplus_page"                               ] = Sql.ToDBString  (this.googleplus_page                               );
			if ( this.days_to_close                                 .HasValue ) row["days_to_close"                                 ] = Sql.ToDBInteger (this.days_to_close                           .Value);
			if ( this.first_contact_createdate                      .HasValue ) row["first_contact_createdate"                      ] = Sql.ToDBDateTime(this.first_contact_createdate                .Value);
			if ( this.first_conversion_date                         .HasValue ) row["first_conversion_date"                         ] = Sql.ToDBDateTime(this.first_conversion_date                   .Value);
			if ( this.first_conversion_event_name                   != null   ) row["first_conversion_event_name"                   ] = Sql.ToDBString  (this.first_conversion_event_name                   );
			if ( this.hs_analytics_source                           != null   ) row["hs_analytics_source"                           ] = Sql.ToDBString  (this.hs_analytics_source                           );
			if ( this.hs_analytics_source_data_1                    != null   ) row["hs_analytics_source_data_1"                    ] = Sql.ToDBString  (this.hs_analytics_source_data_1                    );
			if ( this.hs_analytics_source_data_2                    != null   ) row["hs_analytics_source_data_2"                    ] = Sql.ToDBString  (this.hs_analytics_source_data_2                    );
			if ( this.hs_analytics_first_timestamp                  .HasValue ) row["hs_analytics_first_timestamp"                  ] = Sql.ToDBDateTime(this.hs_analytics_first_timestamp            .Value);
			if ( this.hs_analytics_last_timestamp                   .HasValue ) row["hs_analytics_last_timestamp"                   ] = Sql.ToDBDateTime(this.hs_analytics_last_timestamp             .Value);
			if ( this.hs_analytics_first_visit_timestamp            .HasValue ) row["hs_analytics_first_visit_timestamp"            ] = Sql.ToDBDateTime(this.hs_analytics_first_visit_timestamp      .Value);
			if ( this.hs_analytics_last_visit_timestamp             .HasValue ) row["hs_analytics_last_visit_timestamp"             ] = Sql.ToDBDateTime(this.hs_analytics_last_visit_timestamp       .Value);
			if ( this.hs_analytics_num_page_views                   .HasValue ) row["hs_analytics_num_page_views"                   ] = Sql.ToDBInteger (this.hs_analytics_num_page_views             .Value);
			if ( this.hs_analytics_num_visits                       .HasValue ) row["hs_analytics_num_visits"                       ] = Sql.ToDBInteger (this.hs_analytics_num_visits                 .Value);
			if ( this.num_conversion_events                         .HasValue ) row["num_conversion_events"                         ] = Sql.ToDBInteger (this.num_conversion_events                   .Value);
			if ( this.recent_conversion_date                        .HasValue ) row["recent_conversion_date"                        ] = Sql.ToDBDateTime(this.recent_conversion_date                  .Value);
			if ( this.recent_conversion_event_name                  != null   ) row["recent_conversion_event_name"                  ] = Sql.ToDBString  (this.recent_conversion_event_name                  );
			if ( this.hubspotscore                                  .HasValue ) row["hubspotscore"                                  ] = Sql.ToDBInteger (this.hubspotscore                            .Value);
		}

		public static DataRow ConvertToRow(Company obj)
		{
			DataTable dt = Company.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Company> companies)
		{
			DataTable dt = Company.CreateTable();
			if ( companies != null )
			{
				foreach ( Company company in companies )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					company.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class CompanyPagination
	{
		// 09/28/2020 Paul.  Must use long values. 
		public IList<Company> items      { get; set; }
		public long           offset     { get; set; }
		public long           total      { get; set; }
		public bool           hasmore    { get; set; }
		public long           timeoffset { get; set; }
	}
}
