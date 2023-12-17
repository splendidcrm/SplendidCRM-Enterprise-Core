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

namespace Spring.Social.Marketo.Api
{
	// http://developers.marketo.com/documentation/rest/describe/
	[Serializable]
	public class LeadField
	{
		#region Properties
		public String    RawContent   { get; set; }
		public int?      id           { get; set; }
		public String    displayName  { get; set; }
		public String    dataType     { get; set; }
		public int?      length       { get; set; }
		public String    soapName     { get; set; }
		public bool?     soapReadOnly { get; set; }
		public String    restName     { get; set; }
		public bool?     restReadOnly { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"          , Type.GetType("System.Int64"  ));
			dt.Columns.Add("displayName" , Type.GetType("System.String" ));
			dt.Columns.Add("dataType"    , Type.GetType("System.String" ));
			dt.Columns.Add("length"      , Type.GetType("System.Int64"  ));
			dt.Columns.Add("soapName"    , Type.GetType("System.String" ));
			dt.Columns.Add("soapReadOnly", Type.GetType("System.Boolean"));
			dt.Columns.Add("restName"    , Type.GetType("System.String" ));
			dt.Columns.Add("restReadOnly", Type.GetType("System.Boolean"));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id           .HasValue ) row["id"          ] = Sql.ToDBInteger (this.id          .Value);
			if ( this.displayName  != null   ) row["displayName" ] = Sql.ToDBBoolean (this.displayName       );
			if ( this.dataType     != null   ) row["dataType"    ] = Sql.ToDBDateTime(this.dataType          );
			if ( this.length       .HasValue ) row["length"      ] = Sql.ToDBDateTime(this.length      .Value);
			if ( this.soapName     != null   ) row["soapName"    ] = Sql.ToDBString  (this.soapName          );
			if ( this.soapReadOnly .HasValue ) row["soapReadOnly"] = Sql.ToDBString  (this.soapReadOnly.Value);
			if ( this.restName     != null   ) row["restName"    ] = Sql.ToDBString  (this.restName          );
			if ( this.restReadOnly .HasValue ) row["restReadOnly"] = Sql.ToDBString  (this.restReadOnly.Value);
		}

		public static DataRow ConvertToRow(LeadField obj)
		{
			DataTable dt = LeadField.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<LeadField> leads)
		{
			DataTable dt = LeadField.CreateTable();
			if ( leads != null )
			{
				foreach ( LeadField lead in leads )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					lead.SetRow(row);
				}
			}
			return dt;
		}
	}
}
