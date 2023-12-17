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
	// https://pub.salesfusion360.com/api/lists/distribution/
	[Serializable]
	public class DistributionList : HBase
	{
		#region Properties
		public int?       list_id                       { get { return id; }  set { id = value; } }
		public String     list_name                     { get; set; }  // 200
		public String     list                          { get; set; }
		public String     list_type                     { get; set; }  // 50
		public String     description                   { get; set; }  // 500
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			AddBaseColumns(dt);

			dt.Columns.Add("list_id"                      , Type.GetType("System.Int32"   ));
			dt.Columns.Add("list_name"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("list"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("list_type"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("description"                  , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			SetBaseColumns(row);

			if ( this.list_id                      .HasValue ) row["list_id"                      ] = Sql.ToDBInteger (this.list_id                      .Value);
			if ( this.list_name                    != null   ) row["list_name"                    ] = Sql.ToDBString  (this.list_name                          );
			if ( this.list                         != null   ) row["list"                         ] = Sql.ToDBString  (this.list                               );
			if ( this.list_type                    != null   ) row["list_type"                    ] = Sql.ToDBString  (this.list_type                          );
			if ( this.description                  != null   ) row["description"                  ] = Sql.ToDBString  (this.description                        );
		}

		public static DataRow ConvertToRow(DistributionList obj)
		{
			DataTable dt = DistributionList.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<DistributionList> lists)
		{
			DataTable dt = DistributionList.CreateTable();
			if ( lists != null )
			{
				foreach ( DistributionList list in lists )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					list.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class DistributionListPagination : HPagination
	{
		public IList<DistributionList> results { get; set; }
	}
}
