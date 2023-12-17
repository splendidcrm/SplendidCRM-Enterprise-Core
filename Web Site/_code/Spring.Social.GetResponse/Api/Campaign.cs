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

namespace Spring.Social.GetResponse.Api
{
	[Serializable]
	public class Campaign : HBase
	{
		// http://apidocs.getresponse.com/en/v3/
		#region Properties
		public String name          { get; set; }
		public String description   { get; set; }
		public String languageCode  { get; set; }
		public bool?  isDefault     { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"          , Type.GetType("System.String"  ));
			dt.Columns.Add("createdOn"   , Type.GetType("System.DateTime"));
			dt.Columns.Add("changedOn"   , Type.GetType("System.DateTime"));
			dt.Columns.Add("name"        , Type.GetType("System.String"  ));
			dt.Columns.Add("description" , Type.GetType("System.String"  ));
			dt.Columns.Add("languageCode", Type.GetType("System.String"  ));
			dt.Columns.Add("isDefault"   , Type.GetType("System.Boolean" ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id           != null   ) row["id"          ] = Sql.ToDBInteger (this.id                );
			if ( this.createdOn    .HasValue ) row["createdOn"   ] = Sql.ToDBDateTime(this.createdOn   .Value);
			if ( this.changedOn    .HasValue ) row["changedOn"   ] = Sql.ToDBDateTime(this.changedOn   .Value);
			if ( this.name         != null   ) row["name"        ] = Sql.ToDBString  (this.name              );
			if ( this.description  != null   ) row["description" ] = Sql.ToDBString  (this.description       );
			if ( this.languageCode != null   ) row["languageCode"] = Sql.ToDBString  (this.languageCode      );
			if ( this.isDefault    .HasValue ) row["isDefault"   ] = Sql.ToDBBoolean (this.isDefault   .Value);
		}

		public static DataRow ConvertToRow(Campaign obj)
		{
			DataTable dt = Campaign.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Campaign> campaigns)
		{
			DataTable dt = Campaign.CreateTable();
			if ( campaigns != null )
			{
				foreach ( Campaign campaign in campaigns )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					campaign.SetRow(row);
				}
			}
			return dt;
		}
	}
}
