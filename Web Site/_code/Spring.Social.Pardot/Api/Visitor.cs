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
	public class Visitor
	{
		[Serializable]
		public class Company
		{
			public string   name            { get; set; }
			public string   street_address  { get; set; }
			public string   city            { get; set; }
			public string   state           { get; set; }
			public string   postal_code     { get; set; }
			public string   country         { get; set; }
			public string   email           { get; set; }
		}

		// http://developer.pardot.com/kb/object-field-references/#visitor
		#region Properties
		public String   RawContent                     { get; set; }
		public int      id                             { get; set; }  // Pardot ID for this visitor
		public DateTime? created_at                     { get; set; }  // Time visitor was created in Pardot
		public DateTime? updated_at                     { get; set; }  // Last time visitor was updated in Pardot
		public int?     page_view_count                { get; set; }  // Number of page views by this visitor
		public string   ip_address                     { get; set; }  // IP address
		public string   hostname                       { get; set; }  // Hostname
		public string   browser                        { get; set; }  
		public string   browser_version                { get; set; }  
		public string   operating_system               { get; set; }  
		public string   operating_system_version       { get; set; }  
		public string   language                       { get; set; }  
		public string   screen_height                  { get; set; }  
		public string   screen_width                   { get; set; }  
		public bool?    is_flash_enabled               { get; set; }  
		public bool?    is_java_enabled                { get; set; }  
		public string   campaign_parameter             { get; set; }  // Campaign parameter utm_campaign from Google Analytics
		public string   medium_parameter               { get; set; }  // Medium parameter utm_medium from Google Analytics
		public string   source_parameter               { get; set; }  // Source parameter utm_source from Google Analytics
		public string   content_parameter              { get; set; }  // Content parameter utm_content from Google Analytics
		public string   term_parameter                 { get; set; }  // Term parameter utm_term from Google Analytics
		public Prospect prospect                       { get; set; }
		public Company  identified_company             { get; set; }
		public IList<VisitorActivity> visitor_activities { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                      , Type.GetType("System.Int64"   ));
			dt.Columns.Add("created_at"              , Type.GetType("System.DateTime"));
			dt.Columns.Add("updated_at"              , Type.GetType("System.DateTime"));
			dt.Columns.Add("page_view_count"         , Type.GetType("System.Int64"   ));
			dt.Columns.Add("ip_address"              , Type.GetType("System.String"  ));
			dt.Columns.Add("hostname"                , Type.GetType("System.String"  ));
			dt.Columns.Add("browser"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("browser_version"         , Type.GetType("System.String"  ));
			dt.Columns.Add("operating_system"        , Type.GetType("System.String"  ));
			dt.Columns.Add("operating_system_version", Type.GetType("System.String"  ));
			dt.Columns.Add("language"                , Type.GetType("System.String"  ));
			dt.Columns.Add("screen_height"           , Type.GetType("System.String"  ));
			dt.Columns.Add("screen_width"            , Type.GetType("System.String"  ));
			dt.Columns.Add("is_flash_enabled"        , Type.GetType("System.Boolean" ));
			dt.Columns.Add("is_java_enabled"         , Type.GetType("System.Boolean" ));
			dt.Columns.Add("campaign_parameter"      , Type.GetType("System.String"  ));
			dt.Columns.Add("medium_parameter"        , Type.GetType("System.String"  ));
			dt.Columns.Add("source_parameter"        , Type.GetType("System.String"  ));
			dt.Columns.Add("content_parameter"       , Type.GetType("System.String"  ));
			dt.Columns.Add("term_parameter"          , Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_id"             , Type.GetType("System.Int64"   ));
			dt.Columns.Add("prospect_name"           , Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_first_name"     , Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_last_name"      , Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_email"          , Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_company"        , Type.GetType("System.String"  ));
			dt.Columns.Add("company_name"            , Type.GetType("System.String"  ));
			dt.Columns.Add("company_street_address"  , Type.GetType("System.String"  ));
			dt.Columns.Add("company_city"            , Type.GetType("System.String"  ));
			dt.Columns.Add("company_state"           , Type.GetType("System.String"  ));
			dt.Columns.Add("company_postal_code"     , Type.GetType("System.String"  ));
			dt.Columns.Add("company_country"         , Type.GetType("System.String"  ));
			dt.Columns.Add("company_email"           , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                       != 0      ) row["id"                      ] = Sql.ToDBString  (this.id                            );
			if ( this.created_at               .HasValue ) row["created_at"              ] = Sql.ToDBDateTime(this.created_at                    );
			if ( this.updated_at               .HasValue ) row["updated_at"              ] = Sql.ToDBDateTime(this.updated_at                    );
			if ( this.page_view_count          .HasValue ) row["page_view_count"         ] = Sql.ToDBInteger (this.page_view_count         .Value);
			if ( this.ip_address               != null   ) row["ip_address"              ] = Sql.ToDBInteger (this.ip_address                    );
			if ( this.hostname                 != null   ) row["hostname"                ] = Sql.ToDBString  (this.hostname                      );
			if ( this.browser                  != null   ) row["browser"                 ] = Sql.ToDBString  (this.browser                       );
			if ( this.browser_version          != null   ) row["browser_version"         ] = Sql.ToDBString  (this.browser_version               );
			if ( this.operating_system         != null   ) row["operating_system"        ] = Sql.ToDBString  (this.operating_system              );
			if ( this.operating_system_version != null   ) row["operating_system_version"] = Sql.ToDBString  (this.operating_system_version      );
			if ( this.language                 != null   ) row["language"                ] = Sql.ToDBString  (this.language                      );
			if ( this.screen_height            != null   ) row["screen_height"           ] = Sql.ToDBString  (this.screen_height                 );
			if ( this.screen_width             != null   ) row["screen_width"            ] = Sql.ToDBString  (this.screen_width                  );
			if ( this.is_flash_enabled         .HasValue ) row["is_flash_enabled"        ] = Sql.ToDBString  (this.is_flash_enabled        .Value);
			if ( this.is_java_enabled          .HasValue ) row["is_java_enabled"         ] = Sql.ToDBString  (this.is_java_enabled         .Value);
			if ( this.campaign_parameter       != null   ) row["campaign_parameter"      ] = Sql.ToDBString  (this.campaign_parameter            );
			if ( this.medium_parameter         != null   ) row["medium_parameter"        ] = Sql.ToDBInteger (this.medium_parameter              );
			if ( this.source_parameter         != null   ) row["source_parameter"        ] = Sql.ToDBInteger (this.source_parameter              );
			if ( this.content_parameter        != null   ) row["content_parameter"       ] = Sql.ToDBInteger (this.content_parameter             );
			if ( this.term_parameter           != null   ) row["term_parameter"          ] = Sql.ToDBInteger (this.term_parameter                );
			if ( this.prospect != null )
			{
				if ( this.prospect.id         != 0      ) row["prospect_id"        ] = Sql.ToDBString  (this.prospect.id        );
				if ( this.prospect.first_name != null   ) row["prospect_first_name"] = Sql.ToDBString  (this.prospect.first_name);
				if ( this.prospect.last_name  != null   ) row["prospect_last_name" ] = Sql.ToDBString  (this.prospect.last_name );
				if ( this.prospect.email      != null   ) row["prospect_email"     ] = Sql.ToDBString  (this.prospect.email     );
				if ( this.prospect.company    != null   ) row["prospect_company"   ] = Sql.ToDBString  (this.prospect.company   );
				row["prospect_name"] = (Sql.ToString(this.prospect.first_name) + " " + Sql.ToString(this.prospect.last_name)).Trim();
				if ( Sql.IsEmptyString(row["prospect_name"]) && this.prospect.id > 0 )
					row["prospect_name"] = this.prospect.id.ToString();
			}
			if ( this.identified_company != null )
			{
				if ( this.identified_company.name           != null   ) row["company_name"          ] = Sql.ToDBString  (this.identified_company.name          );
				if ( this.identified_company.street_address != null   ) row["company_street_address"] = Sql.ToDBString  (this.identified_company.street_address);
				if ( this.identified_company.city           != null   ) row["company_city"          ] = Sql.ToDBString  (this.identified_company.city          );
				if ( this.identified_company.state          != null   ) row["company_state"         ] = Sql.ToDBString  (this.identified_company.state         );
				if ( this.identified_company.postal_code    != null   ) row["company_postal_code"   ] = Sql.ToDBString  (this.identified_company.postal_code   );
				if ( this.identified_company.country        != null   ) row["company_country"       ] = Sql.ToDBString  (this.identified_company.country       );
				if ( this.identified_company.email          != null   ) row["company_email"         ] = Sql.ToDBString  (this.identified_company.email         );
			}
		}

		public static DataRow ConvertToRow(Visitor obj)
		{
			DataTable dt = Visitor.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Visitor> visitors)
		{
			DataTable dt = Visitor.CreateTable();
			if ( visitors != null )
			{
				foreach ( Visitor visitor in visitors )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					visitor.SetRow(row);
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

	public class VisitorPagination
	{
		public IList<Visitor>      items      { get; set; }
		public int                 total      { get; set; }
	}
}
