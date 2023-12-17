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
	public class Opportunity
	{
		// http://developer.pardot.com/kb/object-field-references/#opportunity
		#region Properties
		public String   RawContent          { get; set; }
		public int      id                  { get; set; }  // Pardot ID
		public DateTime? created_at          { get; set; }  // Time account was created in Pardot. 
		public DateTime? updated_at          { get; set; }  // Last updated. 
		public String   name                { get; set; }  // name 
		public Double?  value               { get; set; }  // value
		public int?     probability         { get; set; }  // probability
		public String   type                { get; set; }  // type 
		public String   stage               { get; set; }  // stage 
		public String   status              { get; set; }  // status
		public DateTime? closed_at           { get; set; }  // closed date
		public int?     campaign_id         { get; set; }  // Campaign ID
		public String   campaign_name       { get; set; }
		// http://www.pardot.com/wp-content/help/uploads/2012/04/Pardot_Import_Opportunities.png
		// At the minimum, you must map the opportunity Name, Amount, Probability, Closed, Won, Email, and an External or Internal Identifier.
		public String   email               { get; set; }
		public String   crm_opportunity_fid { get; set; }
		public bool?    is_closed           { get; set; }
		public bool?    is_won              { get; set; }
		public Prospect prospect            { get; set; }
		public IList<VisitorActivity> visitor_activities { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                 , Type.GetType("System.Int64"   ));
			dt.Columns.Add("created_at"         , Type.GetType("System.DateTime"));
			dt.Columns.Add("updated_at"         , Type.GetType("System.DateTime"));
			dt.Columns.Add("name"               , Type.GetType("System.String"  ));
			dt.Columns.Add("value"              , Type.GetType("System.Double"  ));
			dt.Columns.Add("probability"        , Type.GetType("System.Int64"   ));
			dt.Columns.Add("type"               , Type.GetType("System.String"  ));
			dt.Columns.Add("stage"              , Type.GetType("System.String"  ));
			dt.Columns.Add("status"             , Type.GetType("System.String"  ));
			dt.Columns.Add("closed_at"          , Type.GetType("System.String"  ));
			dt.Columns.Add("campaign_id"        , Type.GetType("System.Int64"   ));
			dt.Columns.Add("campaign_name"      , Type.GetType("System.String"  ));
			dt.Columns.Add("crm_opportunity_fid", Type.GetType("System.String"  ));
			dt.Columns.Add("email"              , Type.GetType("System.String"  ));
			dt.Columns.Add("is_closed"          , Type.GetType("System.Boolean" ));
			dt.Columns.Add("is_won"             , Type.GetType("System.Boolean" ));
			dt.Columns.Add("prospect_id"        , Type.GetType("System.Int64"   ));
			dt.Columns.Add("prospect_name"      , Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_first_name", Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_last_name" , Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_email"     , Type.GetType("System.String"  ));
			dt.Columns.Add("prospect_company"   , Type.GetType("System.String"  ));
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
			if ( this.name                != null   ) row["name"               ] = Sql.ToDBString  (this.name                     );
			if ( this.value               .HasValue ) row["value"              ] = Sql.ToDBDouble  (this.value              .Value);
			if ( this.probability         .HasValue ) row["probability"        ] = Sql.ToDBInteger (this.probability        .Value);
			if ( this.type                != null   ) row["type"               ] = Sql.ToDBString  (this.type                     );
			if ( this.stage               != null   ) row["stage"              ] = Sql.ToDBString  (this.stage                    );
			if ( this.status              != null   ) row["status"             ] = Sql.ToDBString  (this.status                   );
			if ( this.closed_at           .HasValue ) row["closed_at"          ] = Sql.ToDBString  (this.closed_at                );
			if ( this.campaign_id         .HasValue ) row["campaign_id"        ] = Sql.ToDBInteger (this.campaign_id        .Value);
			if ( this.campaign_name       != null   ) row["campaign_name"      ] = Sql.ToDBString  (this.campaign_name            );
			if ( this.email               != null   ) row["email"              ] = Sql.ToDBString  (this.email                    );
			if ( this.crm_opportunity_fid != null   ) row["crm_opportunity_fid"] = Sql.ToDBString  (this.crm_opportunity_fid      );
			if ( this.is_closed           .HasValue ) row["is_closed"          ] = Sql.ToDBInteger (this.is_closed          .Value);
			if ( this.is_won              .HasValue ) row["is_won"             ] = Sql.ToDBInteger (this.is_won             .Value);
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
		}

		public static DataRow ConvertToRow(Opportunity obj)
		{
			DataTable dt = Opportunity.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Opportunity> opportunities)
		{
			DataTable dt = Opportunity.CreateTable();
			if ( opportunities != null )
			{
				foreach ( Opportunity opportunity in opportunities )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					opportunity.SetRow(row);
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

	public class OpportunityPagination
	{
		public IList<Opportunity>  items      { get; set; }
		public int                 total      { get; set; }
	}
}
