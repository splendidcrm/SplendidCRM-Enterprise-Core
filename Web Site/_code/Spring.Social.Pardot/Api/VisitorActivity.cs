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
	public class VisitorActivity
	{
		// http://developer.pardot.com/kb/object-field-references/#visitor-activity
		#region Properties
		public String       RawContent                     { get; set; }
		public int          id                             { get; set; }  // Pardot ID
		public DateTime?    created_at                     { get; set; }  // Time that visitor activity occurred. 
		public int?         prospect_id                    { get; set; }  // Prospect ID. 
		public int?         visitor_id                     { get; set; }  // Visitor ID. 
		public int?         type                           { get; set; }  // Visitor activity's type number
		public String       type_name                      { get; set; }  // Visitor activity's type name
		public String       details                        { get; set; }  // Details about this visitor activity such as the name of the object associated with this activity, the search phrase used in a site search query, etc. 
		public int?         email_id                       { get; set; }  // Email ID. 
		public int?         email_template_id              { get; set; }  // Email Template ID. 
		public int?         list_email_id                  { get; set; }  // List ID. 
		public int?         form_id                        { get; set; }  // Form ID. 
		public int?         form_handler_id                { get; set; }  // Form Handler ID. 
		public int?         site_search_query_id           { get; set; }  // Site Search Query ID. 
		public int?         landing_page_id                { get; set; }  // Landing Page ID. 
		public int?         paid_search_id_id              { get; set; }  // Paid Search ID. 
		public int?         multivariate_test_variation_id { get; set; }  // Test Variation ID. 
		public int?         visitor_page_view_id           { get; set; }  // Visitor Page ID. 
		public int?         file_id                        { get; set; }  // File ID. 
		public int?         campaign_id                    { get; set; }  // Campaign ID. 
		public String       campaign_name                  { get; set; }  // Campaign Name. 
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                            , Type.GetType("System.Int64"   ));
			dt.Columns.Add("created_at"                    , Type.GetType("System.DateTime"));
			dt.Columns.Add("prospect_id"                   , Type.GetType("System.Int64"   ));
			dt.Columns.Add("visitor_id"                    , Type.GetType("System.Int64"   ));
			dt.Columns.Add("type"                          , Type.GetType("System.Int64"   ));
			dt.Columns.Add("type_name"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("details"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("email_id"                      , Type.GetType("System.Int64"   ));
			dt.Columns.Add("email_template_id"             , Type.GetType("System.Int64"   ));
			dt.Columns.Add("list_email_id"                 , Type.GetType("System.Int64"   ));
			dt.Columns.Add("form_id"                       , Type.GetType("System.Int64"   ));
			dt.Columns.Add("form_handler_id"               , Type.GetType("System.Int64"   ));
			dt.Columns.Add("site_search_query_id"          , Type.GetType("System.Int64"   ));
			dt.Columns.Add("landing_page_id"               , Type.GetType("System.Int64"   ));
			dt.Columns.Add("paid_search_id_id"             , Type.GetType("System.Int64"   ));
			dt.Columns.Add("multivariate_test_variation_id", Type.GetType("System.Int64"   ));
			dt.Columns.Add("visitor_page_view_id"          , Type.GetType("System.Int64"   ));
			dt.Columns.Add("file_id"                       , Type.GetType("System.Int64"   ));
			dt.Columns.Add("campaign_id"                   , Type.GetType("System.Int64"   ));
			dt.Columns.Add("campaign_name"                 , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                             != 0      ) row["id"                            ] = Sql.ToDBString  (this.id                                  );
			if ( this.created_at                     .HasValue ) row["created_at"                    ] = Sql.ToDBDateTime(this.created_at                          );
			if ( this.prospect_id                    .HasValue ) row["prospect_id"                   ] = Sql.ToDBInteger (this.prospect_id                   .Value);
			if ( this.visitor_id                     .HasValue ) row["visitor_id"                    ] = Sql.ToDBInteger (this.visitor_id                    .Value);
			if ( this.type                           .HasValue ) row["type"                          ] = Sql.ToDBInteger (this.type                          .Value);
			if ( this.type_name                      != null   ) row["type_name"                     ] = Sql.ToDBString  (this.type_name                           );
			if ( this.details                        != null   ) row["details"                       ] = Sql.ToDBString  (this.details                             );
			if ( this.email_id                       .HasValue ) row["email_id"                      ] = Sql.ToDBInteger (this.email_id                      .Value);
			if ( this.email_template_id              .HasValue ) row["email_template_id"             ] = Sql.ToDBInteger (this.email_template_id             .Value);
			if ( this.list_email_id                  .HasValue ) row["list_email_id"                 ] = Sql.ToDBInteger (this.list_email_id                 .Value);
			if ( this.form_id                        .HasValue ) row["form_id"                       ] = Sql.ToDBInteger (this.form_id                       .Value);
			if ( this.form_handler_id                .HasValue ) row["form_handler_id"               ] = Sql.ToDBInteger (this.form_handler_id               .Value);
			if ( this.site_search_query_id           .HasValue ) row["site_search_query_id"          ] = Sql.ToDBInteger (this.site_search_query_id          .Value);
			if ( this.landing_page_id                .HasValue ) row["landing_page_id"               ] = Sql.ToDBInteger (this.landing_page_id               .Value);
			if ( this.paid_search_id_id              .HasValue ) row["paid_search_id_id"             ] = Sql.ToDBInteger (this.paid_search_id_id             .Value);
			if ( this.multivariate_test_variation_id .HasValue ) row["multivariate_test_variation_id"] = Sql.ToDBInteger (this.multivariate_test_variation_id.Value);
			if ( this.visitor_page_view_id           .HasValue ) row["visitor_page_view_id"          ] = Sql.ToDBInteger (this.visitor_page_view_id          .Value);
			if ( this.file_id                        .HasValue ) row["file_id"                       ] = Sql.ToDBInteger (this.file_id                       .Value);
			if ( this.campaign_id                    .HasValue ) row["campaign_id"                   ] = Sql.ToDBInteger (this.campaign_id                   .Value);
			if ( this.campaign_name                  != null   ) row["campaign_name"                 ] = Sql.ToDBString  (this.campaign_name                       );
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
	}
}
