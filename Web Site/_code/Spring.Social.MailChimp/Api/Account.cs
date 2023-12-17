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
	public class Account : HBase
	{
		#region Properties
		public String    name                            { get; set; }
		public String    email                           { get; set; }
		public String    role                            { get; set; }
		// Contact properties
		public String    company                         { get; set; }
		public String    addr1                           { get; set; }
		public String    addr2                           { get; set; }
		public String    city                            { get; set; }
		public String    state                           { get; set; }
		public String    zip                             { get; set; }
		public String    country                         { get; set; }

		public bool?     pro_enabled                     { get; set; }
		public DateTime? last_login                      { get; set; }
		public int?      total_subscribers               { get; set; }
		// industry_stats
		public Decimal?  open_rate                       { get; set; }
		public Decimal?  bounce_rate                     { get; set; }
		public Decimal?  click_rate                      { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"               , Type.GetType("System.String"  ));
			dt.Columns.Add("date_created"     , Type.GetType("System.DateTime"));  // 2015-09-15T13:09:22+00:00
			dt.Columns.Add("created_by"       , Type.GetType("System.String"  ));
			dt.Columns.Add("name"             , Type.GetType("System.String"  ));
			dt.Columns.Add("email"            , Type.GetType("System.String"  ));
			dt.Columns.Add("role"             , Type.GetType("System.String"  ));
			dt.Columns.Add("company"          , Type.GetType("System.String"  ));
			dt.Columns.Add("addr1"            , Type.GetType("System.String"  ));
			dt.Columns.Add("addr2"            , Type.GetType("System.String"  ));
			dt.Columns.Add("city"             , Type.GetType("System.String"  ));
			dt.Columns.Add("state"            , Type.GetType("System.String"  ));
			dt.Columns.Add("zip"              , Type.GetType("System.String"  ));
			dt.Columns.Add("country"          , Type.GetType("System.String"  ));
			dt.Columns.Add("pro_enabled"      , Type.GetType("System.Boolean" ));
			dt.Columns.Add("last_login"       , Type.GetType("System.DateTime"));
			dt.Columns.Add("total_subscribers", Type.GetType("System.Int64"   ));
			dt.Columns.Add("open_rate"        , Type.GetType("System.Decimal" ));
			dt.Columns.Add("bounce_rate"      , Type.GetType("System.Decimal" ));
			dt.Columns.Add("click_rate"       , Type.GetType("System.Decimal" ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                != null   ) row["id"               ] = Sql.ToDBString  (this.id                     );
			if ( this.date_created      .HasValue ) row["date_created"     ] = Sql.ToDBDateTime(this.date_created     .Value);
			if ( this.created_by        != null   ) row["created_by"       ] = Sql.ToDBString  (this.created_by             );
			if ( this.name              != null   ) row["name"             ] = Sql.ToDBString  (this.name                   );
			if ( this.email             != null   ) row["email"            ] = Sql.ToDBString  (this.email                  );
			if ( this.role              != null   ) row["role"             ] = Sql.ToDBString  (this.role                   );
			if ( this.company           != null   ) row["company"          ] = Sql.ToDBString  (this.company                );
			if ( this.addr1             != null   ) row["addr1"            ] = Sql.ToDBString  (this.addr1                  );
			if ( this.addr2             != null   ) row["addr2"            ] = Sql.ToDBString  (this.addr2                  );
			if ( this.city              != null   ) row["city"             ] = Sql.ToDBString  (this.city                   );
			if ( this.state             != null   ) row["state"            ] = Sql.ToDBString  (this.state                  );
			if ( this.zip               != null   ) row["zip"              ] = Sql.ToDBString  (this.zip                    );
			if ( this.country           != null   ) row["country"          ] = Sql.ToDBString  (this.country                );
			if ( this.pro_enabled       .HasValue ) row["pro_enabled"      ] = Sql.ToDBBoolean (this.pro_enabled      .Value);
			if ( this.last_login        .HasValue ) row["last_login"       ] = Sql.ToDBDateTime(this.last_login       .Value);
			if ( this.total_subscribers .HasValue ) row["total_subscribers"] = Sql.ToDBString  (this.total_subscribers.Value);
			if ( this.open_rate         .HasValue ) row["open_rate"        ] = Sql.ToDBDecimal (this.open_rate        .Value);
			if ( this.bounce_rate       .HasValue ) row["bounce_rate"      ] = Sql.ToDBDecimal (this.bounce_rate      .Value);
			if ( this.click_rate        .HasValue ) row["click_rate"       ] = Sql.ToDBDecimal (this.click_rate       .Value);
		}

		public static DataRow ConvertToRow(Account obj)
		{
			DataTable dt = Account.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Account> accounts)
		{
			DataTable dt = Account.CreateTable();
			if ( accounts != null )
			{
				foreach ( Account account in accounts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					account.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class AccountPagination
	{
		public IList<Account>  items      { get; set; }
		public int             total      { get; set; }
	}
}
