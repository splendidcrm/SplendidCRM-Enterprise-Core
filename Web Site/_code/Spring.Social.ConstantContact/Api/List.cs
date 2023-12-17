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

namespace Spring.Social.ConstantContact.Api
{
	[Serializable]
	public class List : HBase
	{
		#region Properties
		// http://developer.constantcontact.com/docs/contact-list-api/contactlist-resource.html
		public String              name            { get; set; }
		public String              status          { get; set; }
		public int?                contact_count   { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("created_date"            , Type.GetType("System.DateTime"));
			dt.Columns.Add("modified_date"           , Type.GetType("System.DateTime"));
			dt.Columns.Add("name"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("status"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("contact_count"           , Type.GetType("System.Int64"   ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id               != null   ) row["id"             ] = Sql.ToDBInteger (this.id                    );
			if ( this.created_date     .HasValue ) row["created_date"   ] = Sql.ToDBDateTime(this.created_date    .Value);
			if ( this.modified_date    .HasValue ) row["modified_date"  ] = Sql.ToDBDateTime(this.modified_date   .Value);
			if ( this.name             != null   ) row["name"           ] = Sql.ToDBString  (this.name                  );
			if ( this.status           != null   ) row["status"         ] = Sql.ToDBString  (this.status                );
			if ( this.contact_count    .HasValue ) row["contact_count"  ] = Sql.ToDBInteger (this.contact_count   .Value);
		}

		public static DataRow ConvertToRow(List obj)
		{
			DataTable dt = List.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<List> lists)
		{
			DataTable dt = List.CreateTable();
			if ( lists != null )
			{
				foreach ( List list in lists )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					list.SetRow(row);
				}
			}
			return dt;
		}
	}
}
