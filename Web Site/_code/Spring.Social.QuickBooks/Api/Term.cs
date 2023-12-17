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
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/term
	[Serializable]
	public class Term : QBase
	{
		public String   Name               { get; set; }  // 31 chars. 
		public Boolean? Active             { get; set; }
		public String   TypeValue          { get; set; }
		public Decimal? DiscountPercent    { get; set; }
		public int?     DueDays            { get; set; }
		public int?     DiscountDays       { get; set; }
		public int?     DayOfMonthDue      { get; set; }
		public int?     DueNextMonthDays   { get; set; }
		public int?     DiscountDayOfMonth { get; set; }

		public bool ActiveValue
		{
			get
			{
				return this.Active.HasValue ? this.Active.Value : false;
			}
			set
			{
				this.Active = value;
			}
		}

		public Term()
		{
			this.Active    = true         ;
			this.TypeValue = "STANDARD"   ;  // This field is restricted to STANDARD or DATE_DRIVEN. 
		}

		public Term(string sName)
		{
			this.Name      = sName        ;
			this.Active    = true         ;
			this.TypeValue = "STANDARD"   ;  // This field is restricted to STANDARD or DATE_DRIVEN. 
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"                , Type.GetType("System.String"  ));
			dt.Columns.Add("SyncToken"         , Type.GetType("System.Int64"   ));
			dt.Columns.Add("TimeCreated"       , Type.GetType("System.DateTime"));
			dt.Columns.Add("TimeModified"      , Type.GetType("System.DateTime"));
			dt.Columns.Add("Name"              , Type.GetType("System.String"  ));
			dt.Columns.Add("Active"            , Type.GetType("System.Boolean" ));
			dt.Columns.Add("Type"              , Type.GetType("System.String"  ));
			dt.Columns.Add("DiscountPercent"   , Type.GetType("System.Decimal" ));
			dt.Columns.Add("DueDays"           , Type.GetType("System.Int32"   ));
			dt.Columns.Add("DiscountDays"      , Type.GetType("System.Int32"   ));
			dt.Columns.Add("DayOfMonthDue"     , Type.GetType("System.Int32"   ));
			dt.Columns.Add("DueNextMonthDays"  , Type.GetType("System.Int32"   ));
			dt.Columns.Add("DiscountDayOfMonth", Type.GetType("System.Int32"   ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.Id        != null   ) row["Id"            ] = Sql.ToDBString  (this.Id                            );
			if ( this.SyncToken != null   ) row["SyncToken"     ] = Sql.ToDBString  (this.SyncToken                     );
			if ( this.MetaData  != null   ) row["TimeCreated"   ] = Sql.ToDBDateTime(this.MetaData.CreateTime           );
			if ( this.MetaData  != null   ) row["TimeModified"  ] = Sql.ToDBDateTime(this.MetaData.LastUpdatedTime      );
			if ( this.Name      != null   ) row["Name"          ] = Sql.ToDBString  (this.Name                          );
			row["Active"            ] = Sql.ToDBBoolean(this.Active   );
			row["Type"              ] = Sql.ToDBString (this.TypeValue);
			row["DiscountPercent"   ] = Sql.ToDBDecimal(this.TypeValue);
			row["DueDays"           ] = Sql.ToDBInteger(this.TypeValue);
			row["DiscountDays"      ] = Sql.ToDBInteger(this.TypeValue);
			row["DayOfMonthDue"     ] = Sql.ToDBInteger(this.TypeValue);
			row["DueNextMonthDays"  ] = Sql.ToDBInteger(this.TypeValue);
			row["DiscountDayOfMonth"] = Sql.ToDBInteger(this.TypeValue);
		}

		public static DataRow ConvertToRow(Term obj)
		{
			DataTable dt = Term.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Term> terms)
		{
			DataTable dt = Term.CreateTable();
			if ( terms != null )
			{
				foreach ( Term term in terms )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					term.SetRow(row);
				}
			}
			return dt;
		}
	}
}
