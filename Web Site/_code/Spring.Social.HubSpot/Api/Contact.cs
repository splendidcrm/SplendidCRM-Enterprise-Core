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
	// http://developers.hubspot.com/docs/methods/contacts/contacts-overview
	// http://knowledge.hubspot.com/contacts-user-guide/how-to-use-contact-properties
	[Serializable]
	public class Contact : HBase
	{
		#region Properties
		// http://knowledge.hubspot.com/contacts-user-guide/how-to-use-contact-properties
		public String    firstname                                     { get; set; }
		public String    lastname                                      { get; set; }
		public String    salutation                                    { get; set; }
		public String    email                                         { get; set; }
		public String    phone                                         { get; set; }
		public String    mobilephone                                   { get; set; }
		public String    fax                                           { get; set; }
		public String    address                                       { get; set; }
		public String    city                                          { get; set; }
		public String    state                                         { get; set; }
		public String    zip                                           { get; set; }
		public String    country                                       { get; set; }
		public String    jobtitle                                      { get; set; }
		public DateTime? closedate                                     { get; set; }
		public String    lifecyclestage                                { get; set; }
		public String    website                                       { get; set; }
		public String    company                                       { get; set; }
		public String    message                                       { get; set; }
		public String    photo                                         { get; set; }
		public String    numemployees                                  { get; set; }
		public String    annualrevenue                                 { get; set; }
		public String    industry                                      { get; set; }
		public String    hs_persona                                    { get; set; }
		public String    hs_facebookid                                 { get; set; }
		public String    hs_googleplusid                               { get; set; }
		public String    hs_linkedinid                                 { get; set; }
		public String    hs_twitterid                                  { get; set; }
		public String    twitterhandle                                 { get; set; }
		public String    twitterprofilephoto                           { get; set; }
		public String    linkedinbio                                   { get; set; }
		public String    twitterbio                                    { get; set; }
		public String    blog_default_hubspot_blog_subscription        { get; set; }
		// 09/27/2020 Paul.  HubSpot is now using long instead of integers. 
		public long?     followercount                                 { get; set; }
		public long?     linkedinconnections                           { get; set; }
		public long?     kloutscoregeneral                             { get; set; }
		public long?     associatedcompanyid                           { get; set; }  // this is the companyId. 

		// http://knowledge.hubspot.com/contacts-user-guide/how-to-use-the-social-media-information-property-group
		// https://api.hubapi.com/contacts/v1/properties?access_token=
		public long?     days_to_close                                 { get; set; }  // read-only 
		public DateTime? first_conversion_date                         { get; set; }  // read-only 
		public String    first_conversion_event_name                   { get; set; }  // read-only 
		public String    hs_emailconfirmationstatus                    { get; set; }  // read-only 
		public DateTime? hubspot_owner_assigneddate                    { get; set; }  // read-only 
		public String    ipaddress                                     { get; set; }  // read-only 
		public String    ip_city                                       { get; set; }  // read-only 
		public String    ip_country                                    { get; set; }  // read-only 
		public String    ip_latlon                                     { get; set; }  // read-only 
		public String    ip_state                                      { get; set; }  // read-only 
		public long?     num_conversion_events                         { get; set; }  // read-only 
		public long?     num_unique_conversion_events                  { get; set; }  // read-only 
		public long?     hs_email_delivered                            { get; set; }  // read-only 
		public long?     hs_email_open                                 { get; set; }  // read-only 
		public long?     hs_email_click                                { get; set; }  // read-only 
		public long?     hs_email_bounce                               { get; set; }  // read-only 
		public bool?     hs_email_optout                               { get; set; }  // read-only 
		public bool?     hs_email_is_ineligible                        { get; set; }  // read-only 
		public String    hs_email_last_email_name                      { get; set; }  // read-only 
		public DateTime? hs_email_first_send_date                      { get; set; }  // read-only 
		public DateTime? hs_email_last_send_date                       { get; set; }  // read-only 
		public DateTime? hs_email_first_open_date                      { get; set; }  // read-only 
		public DateTime? hs_email_last_open_date                       { get; set; }  // read-only 
		public DateTime? hs_email_first_click_date                     { get; set; }  // read-only 
		public DateTime? hs_email_last_click_date                      { get; set; }  // read-only 
		public DateTime? hs_email_lastupdated                          { get; set; }  // read-only 
		public String    hs_analytics_source                           { get; set; }  // read-only 
		public String    hs_analytics_source_data_1                    { get; set; }  // read-only 
		public String    hs_analytics_source_data_2                    { get; set; }  // read-only 
		public String    hs_analytics_first_referrer                   { get; set; }  // read-only 
		public String    hs_analytics_last_referrer                    { get; set; }  // read-only 
		public long?     hs_analytics_num_page_views                   { get; set; }  // read-only 
		public long?     hs_analytics_num_visits                       { get; set; }  // read-only 
		public long?     hs_analytics_num_event_completions            { get; set; }  // read-only 
		public String    hs_analytics_average_page_views               { get; set; }  // read-only 
		public DateTime? hs_analytics_first_timestamp                  { get; set; }  // read-only 
		public DateTime? hs_analytics_last_timestamp                   { get; set; }  // read-only 
		public DateTime? hs_analytics_first_visit_timestamp            { get; set; }  // read-only 
		public DateTime? hs_analytics_last_visit_timestamp             { get; set; }  // read-only 
		public String    hs_analytics_first_url                        { get; set; }  // read-only 
		public String    hs_analytics_last_url                         { get; set; }  // read-only 
		public Decimal?  hs_analytics_revenue                          { get; set; }  // read-only 
		public long?     hs_social_twitter_clicks                      { get; set; }  // read-only 
		public long?     hs_social_facebook_clicks                     { get; set; }  // read-only 
		public long?     hs_social_linkedin_clicks                     { get; set; }  // read-only 
		public long?     hs_social_google_plus_clicks                  { get; set; }  // read-only 
		public long?     hs_social_num_broadcast_clicks                { get; set; }  // read-only 
		public DateTime? hs_social_last_engagement                     { get; set; }  // read-only 
		public DateTime? recent_conversion_date                        { get; set; }  // read-only 
		public String    recent_conversion_event_name                  { get; set; }  // read-only 
		public String    surveymonkeyeventlastupdated                  { get; set; }  // read-only 
		public String    webinareventlastupdated                       { get; set; }  // read-only 
		public DateTime? hs_lifecyclestage_lead_date                   { get; set; }  // read-only 
		public DateTime? hs_lifecyclestage_marketingqualifiedlead_date { get; set; }  // read-only 
		public DateTime? hs_lifecyclestage_opportunity_date            { get; set; }  // read-only 
		public DateTime? hs_lifecyclestage_salesqualifiedlead_date     { get; set; }  // read-only 
		public DateTime? hs_lifecyclestage_evangelist_date             { get; set; }  // read-only 
		public DateTime? hs_lifecyclestage_customer_date               { get; set; }  // read-only 
		public DateTime? hs_lifecyclestage_subscriber_date             { get; set; }  // read-only 
		public DateTime? hs_lifecyclestage_other_date                  { get; set; }  // read-only 
		public DateTime? associatedcompanylastupdated                  { get; set; }  // read-only 
		public bool?     currentlyinworkflow                           { get; set; }  // read-only 
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
			dt.Columns.Add("firstname"                                     , Type.GetType("System.String"  ));
			dt.Columns.Add("lastname"                                      , Type.GetType("System.String"  ));
			dt.Columns.Add("salutation"                                    , Type.GetType("System.String"  ));
			dt.Columns.Add("email"                                         , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                                         , Type.GetType("System.String"  ));
			dt.Columns.Add("mobilephone"                                   , Type.GetType("System.String"  ));
			dt.Columns.Add("fax"                                           , Type.GetType("System.String"  ));
			dt.Columns.Add("address"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("city"                                          , Type.GetType("System.String"  ));
			dt.Columns.Add("state"                                         , Type.GetType("System.String"  ));
			dt.Columns.Add("zip"                                           , Type.GetType("System.String"  ));
			dt.Columns.Add("country"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("jobtitle"                                      , Type.GetType("System.String"  ));
			dt.Columns.Add("closedate"                                     , Type.GetType("System.DateTime"));
			dt.Columns.Add("lifecyclestage"                                , Type.GetType("System.String"  ));
			dt.Columns.Add("website"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("company"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("message"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("photo"                                         , Type.GetType("System.String"  ));
			dt.Columns.Add("numemployees"                                  , Type.GetType("System.String"  ));
			dt.Columns.Add("annualrevenue"                                 , Type.GetType("System.String"  ));
			dt.Columns.Add("industry"                                      , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_persona"                                    , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_facebookid"                                 , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_googleplusid"                               , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_linkedinid"                                 , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_twitterid"                                  , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterhandle"                                 , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterprofilephoto"                           , Type.GetType("System.String"  ));
			dt.Columns.Add("linkedinbio"                                   , Type.GetType("System.String"  ));
			dt.Columns.Add("twitterbio"                                    , Type.GetType("System.String"  ));
			dt.Columns.Add("blog_default_hubspot_blog_subscription"        , Type.GetType("System.String"  ));
			dt.Columns.Add("followercount"                                 , Type.GetType("System.Int64"   ));
			dt.Columns.Add("linkedinconnections"                           , Type.GetType("System.Int64"   ));
			dt.Columns.Add("kloutscoregeneral"                             , Type.GetType("System.Int64"   ));
			dt.Columns.Add("associatedcompanyid"                           , Type.GetType("System.Int64"   ));
			// read-only 
			dt.Columns.Add("days_to_close"                                 , Type.GetType("System.Int64"   ));
			dt.Columns.Add("first_conversion_date"                         , Type.GetType("System.DateTime"));
			dt.Columns.Add("first_conversion_event_name"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_emailconfirmationstatus"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("hubspot_owner_assigneddate"                    , Type.GetType("System.DateTime"));
			dt.Columns.Add("ipaddress"                                     , Type.GetType("System.String"  ));
			dt.Columns.Add("ip_city"                                       , Type.GetType("System.String"  ));
			dt.Columns.Add("ip_country"                                    , Type.GetType("System.String"  ));
			dt.Columns.Add("ip_latlon"                                     , Type.GetType("System.String"  ));
			dt.Columns.Add("ip_state"                                      , Type.GetType("System.String"  ));
			dt.Columns.Add("num_conversion_events"                         , Type.GetType("System.Int64"   ));
			dt.Columns.Add("num_unique_conversion_events"                  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_email_delivered"                            , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_email_open"                                 , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_email_click"                                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_email_bounce"                               , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_email_optout"                               , Type.GetType("System.Boolean" ));
			dt.Columns.Add("hs_email_is_ineligible"                        , Type.GetType("System.Boolean" ));
			dt.Columns.Add("hs_email_last_email_name"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_email_first_send_date"                      , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_email_last_send_date"                       , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_email_first_open_date"                      , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_email_last_open_date"                       , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_email_first_click_date"                     , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_email_last_click_date"                      , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_email_lastupdated"                          , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_analytics_source"                           , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_source_data_1"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_source_data_2"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_first_referrer"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_last_referrer"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_num_page_views"                   , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_analytics_num_visits"                       , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_analytics_num_event_completions"            , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_analytics_average_page_views"               , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_first_timestamp"                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_analytics_last_timestamp"                   , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_analytics_first_visit_timestamp"            , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_analytics_last_visit_timestamp"             , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_analytics_first_url"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_last_url"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_analytics_revenue"                          , Type.GetType("System.Decimal" ));
			dt.Columns.Add("hs_social_twitter_clicks"                      , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_social_facebook_clicks"                     , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_social_linkedin_clicks"                     , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_social_google_plus_clicks"                  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_social_num_broadcast_clicks"                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("hs_social_last_engagement"                     , Type.GetType("System.DateTime"));
			dt.Columns.Add("recent_conversion_date"                        , Type.GetType("System.DateTime"));
			dt.Columns.Add("recent_conversion_event_name"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("surveymonkeyeventlastupdated"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("webinareventlastupdated"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("hs_lifecyclestage_lead_date"                   , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_lifecyclestage_marketingqualifiedlead_date" , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_lifecyclestage_opportunity_date"            , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_lifecyclestage_salesqualifiedlead_date"     , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_lifecyclestage_evangelist_date"             , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_lifecyclestage_customer_date"               , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_lifecyclestage_subscriber_date"             , Type.GetType("System.DateTime"));
			dt.Columns.Add("hs_lifecyclestage_other_date"                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("associatedcompanylastupdated"                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("currentlyinworkflow"                           , Type.GetType("System.Boolean" ));
			dt.Columns.Add("hubspotscore"                                  , Type.GetType("System.Int64"   ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                                            .HasValue ) row["id"                                            ] = Sql.ToDBInteger (this.id                                            .Value);
			if ( this.isDeleted                                     .HasValue ) row["isDeleted"                                     ] = Sql.ToDBBoolean (this.isDeleted                                     .Value );
			if ( this.createdate                                    .HasValue ) row["createdate"                                    ] = Sql.ToDBDateTime(this.createdate                                    .Value);
			if ( this.lastmodifieddate                              .HasValue ) row["lastmodifieddate"                              ] = Sql.ToDBDateTime(this.lastmodifieddate                              .Value);
			if ( this.hubspot_owner_id                              .HasValue ) row["hubspot_owner_id"                              ] = Sql.ToDBInteger (this.hubspot_owner_id                              .Value);
			if ( this.firstname                                     != null   ) row["firstname"                                     ] = Sql.ToDBString  (this.firstname                                           );
			if ( this.lastname                                      != null   ) row["lastname"                                      ] = Sql.ToDBString  (this.lastname                                            );
			if ( this.salutation                                    != null   ) row["salutation"                                    ] = Sql.ToDBString  (this.salutation                                          );
			if ( this.email                                         != null   ) row["email"                                         ] = Sql.ToDBString  (this.email                                               );
			if ( this.phone                                         != null   ) row["phone"                                         ] = Sql.ToDBString  (this.phone                                               );
			if ( this.mobilephone                                   != null   ) row["mobilephone"                                   ] = Sql.ToDBString  (this.mobilephone                                         );
			if ( this.fax                                           != null   ) row["fax"                                           ] = Sql.ToDBString  (this.fax                                                 );
			if ( this.address                                       != null   ) row["address"                                       ] = Sql.ToDBString  (this.address                                             );
			if ( this.city                                          != null   ) row["city"                                          ] = Sql.ToDBString  (this.city                                                );
			if ( this.state                                         != null   ) row["state"                                         ] = Sql.ToDBString  (this.state                                               );
			if ( this.zip                                           != null   ) row["zip"                                           ] = Sql.ToDBString  (this.zip                                                 );
			if ( this.country                                       != null   ) row["country"                                       ] = Sql.ToDBString  (this.country                                             );
			if ( this.jobtitle                                      != null   ) row["jobtitle"                                      ] = Sql.ToDBString  (this.jobtitle                                            );
			if ( this.closedate                                     .HasValue ) row["closedate"                                     ] = Sql.ToDBDateTime(this.closedate                                     .Value);
			if ( this.lifecyclestage                                != null   ) row["lifecyclestage"                                ] = Sql.ToDBString  (this.lifecyclestage                                      );
			if ( this.website                                       != null   ) row["website"                                       ] = Sql.ToDBString  (this.website                                             );
			if ( this.company                                       != null   ) row["company"                                       ] = Sql.ToDBString  (this.company                                             );
			if ( this.message                                       != null   ) row["message"                                       ] = Sql.ToDBString  (this.message                                             );
			if ( this.photo                                         != null   ) row["photo"                                         ] = Sql.ToDBString  (this.photo                                               );
			if ( this.numemployees                                  != null   ) row["numemployees"                                  ] = Sql.ToDBString  (this.numemployees                                        );
			if ( this.annualrevenue                                 != null   ) row["annualrevenue"                                 ] = Sql.ToDBString  (this.annualrevenue                                       );
			if ( this.industry                                      != null   ) row["industry"                                      ] = Sql.ToDBString  (this.industry                                            );
			if ( this.hs_persona                                    != null   ) row["hs_persona"                                    ] = Sql.ToDBString  (this.hs_persona                                          );
			if ( this.hs_facebookid                                 != null   ) row["hs_facebookid"                                 ] = Sql.ToDBString  (this.hs_facebookid                                       );
			if ( this.hs_googleplusid                               != null   ) row["hs_googleplusid"                               ] = Sql.ToDBString  (this.hs_googleplusid                                     );
			if ( this.hs_linkedinid                                 != null   ) row["hs_linkedinid"                                 ] = Sql.ToDBString  (this.hs_linkedinid                                       );
			if ( this.hs_twitterid                                  != null   ) row["hs_twitterid"                                  ] = Sql.ToDBString  (this.hs_twitterid                                        );
			if ( this.twitterhandle                                 != null   ) row["twitterhandle"                                 ] = Sql.ToDBString  (this.twitterhandle                                       );
			if ( this.twitterprofilephoto                           != null   ) row["twitterprofilephoto"                           ] = Sql.ToDBString  (this.twitterprofilephoto                                 );
			if ( this.linkedinbio                                   != null   ) row["linkedinbio"                                   ] = Sql.ToDBString  (this.linkedinbio                                         );
			if ( this.twitterbio                                    != null   ) row["twitterbio"                                    ] = Sql.ToDBString  (this.twitterbio                                          );
			if ( this.blog_default_hubspot_blog_subscription        != null   ) row["blog_default_hubspot_blog_subscription"        ] = Sql.ToDBString  (this.blog_default_hubspot_blog_subscription              );
			if ( this.followercount                                 .HasValue ) row["followercount"                                 ] = Sql.ToDBInteger (this.followercount                                 .Value);
			if ( this.linkedinconnections                           .HasValue ) row["linkedinconnections"                           ] = Sql.ToDBInteger (this.linkedinconnections                           .Value);
			if ( this.kloutscoregeneral                             .HasValue ) row["kloutscoregeneral"                             ] = Sql.ToDBInteger (this.kloutscoregeneral                             .Value);
			if ( this.associatedcompanyid                           .HasValue ) row["associatedcompanyid"                           ] = Sql.ToDBInteger (this.associatedcompanyid                           .Value);
			// read-only 
			if ( this.days_to_close                                 .HasValue ) row["days_to_close"                                 ] = Sql.ToDBInteger  (this.days_to_close                                .Value);
			if ( this.first_conversion_date                         .HasValue ) row["first_conversion_date"                         ] = Sql.ToDBDateTime (this.first_conversion_date                        .Value);
			if ( this.first_conversion_event_name                   != null   ) row["first_conversion_event_name"                   ] = Sql.ToDBString   (this.first_conversion_event_name                        );
			if ( this.hs_emailconfirmationstatus                    != null   ) row["hs_emailconfirmationstatus"                    ] = Sql.ToDBString   (this.hs_emailconfirmationstatus                         );
			if ( this.hubspot_owner_assigneddate                    .HasValue ) row["hubspot_owner_assigneddate"                    ] = Sql.ToDBDateTime (this.hubspot_owner_assigneddate                   .Value);
			if ( this.ipaddress                                     != null   ) row["ipaddress"                                     ] = Sql.ToDBString   (this.ipaddress                                          );
			if ( this.ip_city                                       != null   ) row["ip_city"                                       ] = Sql.ToDBString   (this.ip_city                                            );
			if ( this.ip_country                                    != null   ) row["ip_country"                                    ] = Sql.ToDBString   (this.ip_country                                         );
			if ( this.ip_latlon                                     != null   ) row["ip_latlon"                                     ] = Sql.ToDBString   (this.ip_latlon                                          );
			if ( this.ip_state                                      != null   ) row["ip_state"                                      ] = Sql.ToDBString   (this.ip_state                                           );
			if ( this.num_conversion_events                         .HasValue ) row["num_conversion_events"                         ] = Sql.ToDBInteger  (this.num_conversion_events                        .Value);
			if ( this.num_unique_conversion_events                  .HasValue ) row["num_unique_conversion_events"                  ] = Sql.ToDBInteger  (this.num_unique_conversion_events                 .Value);
			if ( this.hs_email_delivered                            .HasValue ) row["hs_email_delivered"                            ] = Sql.ToDBInteger  (this.hs_email_delivered                           .Value);
			if ( this.hs_email_open                                 .HasValue ) row["hs_email_open"                                 ] = Sql.ToDBInteger  (this.hs_email_open                                .Value);
			if ( this.hs_email_click                                .HasValue ) row["hs_email_click"                                ] = Sql.ToDBInteger  (this.hs_email_click                               .Value);
			if ( this.hs_email_bounce                               .HasValue ) row["hs_email_bounce"                               ] = Sql.ToDBInteger  (this.hs_email_bounce                              .Value);
			if ( this.hs_email_optout                               .HasValue ) row["hs_email_optout"                               ] = Sql.ToDBBoolean  (this.hs_email_optout                              .Value);
			if ( this.hs_email_is_ineligible                        .HasValue ) row["hs_email_is_ineligible"                        ] = Sql.ToDBBoolean  (this.hs_email_is_ineligible                       .Value);
			if ( this.hs_email_last_email_name                      != null   ) row["hs_email_last_email_name"                      ] = Sql.ToDBString   (this.hs_email_last_email_name                           );
			if ( this.hs_email_first_send_date                      .HasValue ) row["hs_email_first_send_date"                      ] = Sql.ToDBDateTime (this.hs_email_first_send_date                     .Value);
			if ( this.hs_email_last_send_date                       .HasValue ) row["hs_email_last_send_date"                       ] = Sql.ToDBDateTime (this.hs_email_last_send_date                      .Value);
			if ( this.hs_email_first_open_date                      .HasValue ) row["hs_email_first_open_date"                      ] = Sql.ToDBDateTime (this.hs_email_first_open_date                     .Value);
			if ( this.hs_email_last_open_date                       .HasValue ) row["hs_email_last_open_date"                       ] = Sql.ToDBDateTime (this.hs_email_last_open_date                      .Value);
			if ( this.hs_email_first_click_date                     .HasValue ) row["hs_email_first_click_date"                     ] = Sql.ToDBDateTime (this.hs_email_first_click_date                    .Value);
			if ( this.hs_email_last_click_date                      .HasValue ) row["hs_email_last_click_date"                      ] = Sql.ToDBDateTime (this.hs_email_last_click_date                     .Value);
			if ( this.hs_email_lastupdated                          .HasValue ) row["hs_email_lastupdated"                          ] = Sql.ToDBDateTime (this.hs_email_lastupdated                         .Value);
			if ( this.hs_analytics_source                           != null   ) row["hs_analytics_source"                           ] = Sql.ToDBString   (this.hs_analytics_source                                );
			if ( this.hs_analytics_source_data_1                    != null   ) row["hs_analytics_source_data_1"                    ] = Sql.ToDBString   (this.hs_analytics_source_data_1                         );
			if ( this.hs_analytics_source_data_2                    != null   ) row["hs_analytics_source_data_2"                    ] = Sql.ToDBString   (this.hs_analytics_source_data_2                         );
			if ( this.hs_analytics_first_referrer                   != null   ) row["hs_analytics_first_referrer"                   ] = Sql.ToDBString   (this.hs_analytics_first_referrer                        );
			if ( this.hs_analytics_last_referrer                    != null   ) row["hs_analytics_last_referrer"                    ] = Sql.ToDBString   (this.hs_analytics_last_referrer                         );
			if ( this.hs_analytics_num_page_views                   .HasValue ) row["hs_analytics_num_page_views"                   ] = Sql.ToDBInteger  (this.hs_analytics_num_page_views                  .Value);
			if ( this.hs_analytics_num_visits                       .HasValue ) row["hs_analytics_num_visits"                       ] = Sql.ToDBInteger  (this.hs_analytics_num_visits                      .Value);
			if ( this.hs_analytics_num_event_completions            .HasValue ) row["hs_analytics_num_event_completions"            ] = Sql.ToDBInteger  (this.hs_analytics_num_event_completions           .Value);
			if ( this.hs_analytics_average_page_views               != null   ) row["hs_analytics_average_page_views"               ] = Sql.ToDBString   (this.hs_analytics_average_page_views                    );
			if ( this.hs_analytics_first_timestamp                  .HasValue ) row["hs_analytics_first_timestamp"                  ] = Sql.ToDBDateTime (this.hs_analytics_first_timestamp                 .Value);
			if ( this.hs_analytics_last_timestamp                   .HasValue ) row["hs_analytics_last_timestamp"                   ] = Sql.ToDBDateTime (this.hs_analytics_last_timestamp                  .Value);
			if ( this.hs_analytics_first_visit_timestamp            .HasValue ) row["hs_analytics_first_visit_timestamp"            ] = Sql.ToDBDateTime (this.hs_analytics_first_visit_timestamp           .Value);
			if ( this.hs_analytics_last_visit_timestamp             .HasValue ) row["hs_analytics_last_visit_timestamp"             ] = Sql.ToDBDateTime (this.hs_analytics_last_visit_timestamp            .Value);
			if ( this.hs_analytics_first_url                        != null   ) row["hs_analytics_first_url"                        ] = Sql.ToDBString   (this.hs_analytics_first_url                             );
			if ( this.hs_analytics_last_url                         != null   ) row["hs_analytics_last_url"                         ] = Sql.ToDBString   (this.hs_analytics_last_url                              );
			if ( this.hs_analytics_revenue                          .HasValue ) row["hs_analytics_revenue"                          ] = Sql.ToDBDecimal  (this.hs_analytics_revenue                         .Value);
			if ( this.hs_social_twitter_clicks                      .HasValue ) row["hs_social_twitter_clicks"                      ] = Sql.ToDBInteger  (this.hs_social_twitter_clicks                     .Value);
			if ( this.hs_social_facebook_clicks                     .HasValue ) row["hs_social_facebook_clicks"                     ] = Sql.ToDBInteger  (this.hs_social_facebook_clicks                    .Value);
			if ( this.hs_social_linkedin_clicks                     .HasValue ) row["hs_social_linkedin_clicks"                     ] = Sql.ToDBInteger  (this.hs_social_linkedin_clicks                    .Value);
			if ( this.hs_social_google_plus_clicks                  .HasValue ) row["hs_social_google_plus_clicks"                  ] = Sql.ToDBInteger  (this.hs_social_google_plus_clicks                 .Value);
			if ( this.hs_social_num_broadcast_clicks                .HasValue ) row["hs_social_num_broadcast_clicks"                ] = Sql.ToDBInteger  (this.hs_social_num_broadcast_clicks               .Value);
			if ( this.hs_social_last_engagement                     .HasValue ) row["hs_social_last_engagement"                     ] = Sql.ToDBDateTime (this.hs_social_last_engagement                    .Value);
			if ( this.recent_conversion_date                        .HasValue ) row["recent_conversion_date"                        ] = Sql.ToDBDateTime (this.recent_conversion_date                       .Value);
			if ( this.recent_conversion_event_name                  != null   ) row["recent_conversion_event_name"                  ] = Sql.ToDBString   (this.recent_conversion_event_name                       );
			if ( this.surveymonkeyeventlastupdated                  != null   ) row["surveymonkeyeventlastupdated"                  ] = Sql.ToDBString   (this.surveymonkeyeventlastupdated                       );
			if ( this.webinareventlastupdated                       != null   ) row["webinareventlastupdated"                       ] = Sql.ToDBString   (this.webinareventlastupdated                            );
			if ( this.hs_lifecyclestage_lead_date                   .HasValue ) row["hs_lifecyclestage_lead_date"                   ] = Sql.ToDBDateTime (this.hs_lifecyclestage_lead_date                  .Value);
			if ( this.hs_lifecyclestage_marketingqualifiedlead_date .HasValue ) row["hs_lifecyclestage_marketingqualifiedlead_date" ] = Sql.ToDBDateTime (this.hs_lifecyclestage_marketingqualifiedlead_date.Value);
			if ( this.hs_lifecyclestage_opportunity_date            .HasValue ) row["hs_lifecyclestage_opportunity_date"            ] = Sql.ToDBDateTime (this.hs_lifecyclestage_opportunity_date           .Value);
			if ( this.hs_lifecyclestage_salesqualifiedlead_date     .HasValue ) row["hs_lifecyclestage_salesqualifiedlead_date"     ] = Sql.ToDBDateTime (this.hs_lifecyclestage_salesqualifiedlead_date    .Value);
			if ( this.hs_lifecyclestage_evangelist_date             .HasValue ) row["hs_lifecyclestage_evangelist_date"             ] = Sql.ToDBDateTime (this.hs_lifecyclestage_evangelist_date            .Value);
			if ( this.hs_lifecyclestage_customer_date               .HasValue ) row["hs_lifecyclestage_customer_date"               ] = Sql.ToDBDateTime (this.hs_lifecyclestage_customer_date              .Value);
			if ( this.hs_lifecyclestage_subscriber_date             .HasValue ) row["hs_lifecyclestage_subscriber_date"             ] = Sql.ToDBDateTime (this.hs_lifecyclestage_subscriber_date            .Value);
			if ( this.hs_lifecyclestage_other_date                  .HasValue ) row["hs_lifecyclestage_other_date"                  ] = Sql.ToDBDateTime (this.hs_lifecyclestage_other_date                 .Value);
			if ( this.associatedcompanylastupdated                  .HasValue ) row["associatedcompanylastupdated"                  ] = Sql.ToDBDateTime (this.associatedcompanylastupdated                 .Value);
			if ( this.currentlyinworkflow                           .HasValue ) row["currentlyinworkflow"                           ] = Sql.ToDBBoolean  (this.currentlyinworkflow                          .Value);
			if ( this.hubspotscore                                  .HasValue ) row["hubspotscore"                                  ] = Sql.ToDBInteger  (this.hubspotscore                                 .Value);
		}

		public static DataRow ConvertToRow(Contact obj)
		{
			DataTable dt = Contact.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Contact> contacts)
		{
			DataTable dt = Contact.CreateTable();
			if ( contacts != null )
			{
				foreach ( Contact contact in contacts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					contact.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class ContactPagination
	{
		// 09/28/2020 Paul.  Must use long values. 
		public IList<Contact> items      { get; set; }
		public long           offset     { get; set; }
		public bool           hasmore    { get; set; }
		public long           timeoffset { get; set; }
	}
}
