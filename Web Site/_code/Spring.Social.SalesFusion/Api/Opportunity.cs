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

namespace Spring.Social.SalesFusion.Api
{
	// https://pub.salesfusion360.com/api/opportunities/
	[Serializable]
	public class Opportunity : HBase
	{
		#region Properties
		public int?       opportunity_id                { get { return id; }  set { id = value; } }
		public String     opportunity                   { get; set; }
		public String     name                          { get; set; }  // ? unspecified, assume 255
		public int?       contact_id                    { get; set; }
		public String     contact                       { get; set; }
		public int?       account_id                    { get; set; }
		public String     account                       { get; set; }
		public DateTime?  closing_date                  { get; set; }
		public String     lead_source                   { get; set; }  // 50
		public String     stage                         { get; set; }  // 50
		public String     next_step                     { get; set; }  // 50
		public Decimal?   amount                        { get; set; }
		public String     probability                   { get; set; }  // 50
		public String     won                           { get; set; }
		public DateTime?  est_closing_date              { get; set; }
		public String     sub_lead_source_originator    { get; set; }  // 100
		public String     lead_source_originator        { get; set; }  // 100
		public String     sub_lead_source               { get; set; }  // 100
		public String     description                   { get; set; }  // 500
		public String     opp_type                      { get; set; }  // 50
		public String     shared_opp                    { get; set; }  // 5
		public String     product_name                  { get; set; }  // 100
		public String     action_steps_complete         { get; set; }  // 500
		public String     custom_mapping                { get; set; }
		//public object     custom_fields                 { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			AddBaseColumns(dt);

			dt.Columns.Add("opportunity_id"               , Type.GetType("System.Int32"   ));
			dt.Columns.Add("opportunity"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("name"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("contact_id"                   , Type.GetType("System.Int32"   ));
			dt.Columns.Add("contact"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("account_id"                   , Type.GetType("System.Int32"   ));
			dt.Columns.Add("account"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("closing_date"                 , Type.GetType("System.DateTime"));
			dt.Columns.Add("lead_source"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("stage"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("next_step"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("amount"                       , Type.GetType("System.Decimal" ));
			dt.Columns.Add("probability"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("won"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("est_closing_date"             , Type.GetType("System.DateTime"));
			dt.Columns.Add("sub_lead_source_originator"   , Type.GetType("System.String"  ));
			dt.Columns.Add("lead_source_originator"       , Type.GetType("System.String"  ));
			dt.Columns.Add("sub_lead_source"              , Type.GetType("System.String"  ));
			dt.Columns.Add("description"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("opp_type"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("shared_opp"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("product_name"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("action_steps_complete"        , Type.GetType("System.String"  ));
			dt.Columns.Add("custom_mapping"               , Type.GetType("System.String"  ));
			//dt.Columns.Add("custom_fields"                , Type.GetType("System.object"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			SetBaseColumns(row);

			if ( this.opportunity_id               .HasValue ) row["opportunity_id"               ] = Sql.ToDBInteger (this.opportunity_id               .Value);
			if ( this.opportunity                  != null   ) row["opportunity"                  ] = Sql.ToDBString  (this.opportunity                        );
			if ( this.name                         != null   ) row["name"                         ] = Sql.ToDBString  (this.name                               );
			if ( this.contact_id                   .HasValue ) row["contact_id"                   ] = Sql.ToDBInteger (this.contact_id                   .Value);
			if ( this.contact                      != null   ) row["contact"                      ] = Sql.ToDBString  (this.contact                            );
			if ( this.account_id                   .HasValue ) row["account_id"                   ] = Sql.ToDBInteger (this.account_id                   .Value);
			if ( this.account                      != null   ) row["account"                      ] = Sql.ToDBString  (this.account                            );
			if ( this.closing_date                 .HasValue ) row["closing_date"                 ] = Sql.ToDBDateTime(this.closing_date                 .Value);
			if ( this.lead_source                  != null   ) row["lead_source"                  ] = Sql.ToDBString  (this.lead_source                        );
			if ( this.stage                        != null   ) row["stage"                        ] = Sql.ToDBString  (this.stage                              );
			if ( this.next_step                    != null   ) row["next_step"                    ] = Sql.ToDBString  (this.next_step                          );
			if ( this.amount                       .HasValue ) row["amount"                       ] = Sql.ToDBDecimal (this.amount                       .Value);
			if ( this.probability                  != null   ) row["probability"                  ] = Sql.ToDBString  (this.probability                        );
			if ( this.won                          != null   ) row["won"                          ] = Sql.ToDBString  (this.won                                );
			if ( this.est_closing_date             .HasValue ) row["est_closing_date"             ] = Sql.ToDBDateTime(this.est_closing_date             .Value);
			if ( this.sub_lead_source_originator   != null   ) row["sub_lead_source_originator"   ] = Sql.ToDBString  (this.sub_lead_source_originator         );
			if ( this.lead_source_originator       != null   ) row["lead_source_originator"       ] = Sql.ToDBString  (this.lead_source_originator             );
			if ( this.sub_lead_source              != null   ) row["sub_lead_source"              ] = Sql.ToDBString  (this.sub_lead_source                    );
			if ( this.description                  != null   ) row["description"                  ] = Sql.ToDBString  (this.description                        );
			if ( this.opp_type                     != null   ) row["opp_type"                     ] = Sql.ToDBString  (this.opp_type                           );
			if ( this.shared_opp                   != null   ) row["shared_opp"                   ] = Sql.ToDBString  (this.shared_opp                         );
			if ( this.product_name                 != null   ) row["product_name"                 ] = Sql.ToDBString  (this.product_name                       );
			if ( this.action_steps_complete        != null   ) row["action_steps_complete"        ] = Sql.ToDBString  (this.action_steps_complete              );
			if ( this.custom_mapping               != null   ) row["custom_mapping"               ] = Sql.ToDBString  (this.custom_mapping                     );
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
	}

	public class OpportunityPagination : HPagination
	{
		public IList<Opportunity> results { get; set; }
	}
}
