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
	public class Campaign
	{
		// http://developer.pardot.com/kb/object-field-references/#campaign
		#region Properties
		public String   RawContent    { get; set; }
		public int      id            { get; set; }  // Pardot ID
		public DateTime? created_at    { get; set; }  // Time account was created in Pardot. 
		public DateTime? updated_at    { get; set; }  // Last updated. 
		public string   name          { get; set; }  // name 
		public int?     cost          { get; set; }  // cost
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"           , Type.GetType("System.Int64"   ));
			dt.Columns.Add("created_at"   , Type.GetType("System.DateTime"));
			dt.Columns.Add("updated_at"   , Type.GetType("System.DateTime"));
			dt.Columns.Add("name"         , Type.GetType("System.String"  ));
			dt.Columns.Add("cost"         , Type.GetType("System.Int64"   ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id            != 0      ) row["id"           ] = Sql.ToDBString  (this.id                );
			if ( this.created_at    .HasValue ) row["created_at"   ] = Sql.ToDBDateTime(this.created_at        );
			if ( this.updated_at    .HasValue ) row["updated_at"   ] = Sql.ToDBDateTime(this.updated_at        );
			if ( this.name          != null   ) row["name"         ] = Sql.ToDBString  (this.name              );
			if ( this.cost          .HasValue ) row["cost"         ] = Sql.ToDBInteger (this.cost        .Value);
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

		public static DataTable ConvertToCachedTable(IList<Campaign> campaigns)
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("NAME"        , Type.GetType("System.String"  ));
			dt.Columns.Add("DISPLAY_NAME", Type.GetType("System.String"  ));
			if ( campaigns != null )
			{
				foreach ( Campaign campaign in campaigns )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					row["NAME"        ] = campaign.id;
					row["DISPLAY_NAME"] = campaign.name;
				}
			}
			return dt;
		}
	}

	public class CampaignPagination
	{
		public IList<Campaign>     items      { get; set; }
		public int                 total      { get; set; }
	}
}
