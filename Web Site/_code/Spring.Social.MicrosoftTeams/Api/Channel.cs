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

namespace Spring.Social.MicrosoftTeams.Api
{
	[Serializable]
	public class Channel : Entity
	{
		// https://learn.microsoft.com/en-us/graph/api/resources/channel?view=graph-rest-1.0
		#region Properties
		public Team                Team             { get; set; }
		public String              DisplayName      { get; set; }
		public String              Description      { get; set; }
		public String              MembershipType   { get; set; }
		public String              WebUrl           { get; set; }
		public String              TenantId         { get; set; }
		#endregion

		public Channel()
		{
			this.ODataType = "microsoft.graph.channel";
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"             , Type.GetType("System.String"  ));
			dt.Columns.Add("Name"           , Type.GetType("System.String"  ));
			dt.Columns.Add("Description"    , Type.GetType("System.String"  ));
			dt.Columns.Add("MembershipType" , Type.GetType("System.String"  ));
			dt.Columns.Add("WebUrl"         , Type.GetType("System.String"  ));
			dt.Columns.Add("TenantId"       , Type.GetType("System.String"  ));
			dt.Columns.Add("CreatedDateTime", Type.GetType("System.DateTime"));
			dt.Columns.Add("TeamId"         , Type.GetType("System.Guid"    ));
			dt.Columns.Add("TeamName"       , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			row["Id"             ] = this.Id              ;
			row["Name"           ] = this.DisplayName     ;
			row["Description"    ] = this.Description     ;
			row["MembershipType" ] = this.MembershipType  ;
			row["WebUrl"         ] = this.WebUrl          ;
			row["TenantId"       ] = this.TenantId        ;
			row["CreatedDateTime"] = this.CreatedDateTime ;
			row["TeamId"         ] = this.Team.Id         ;
			row["TeamName"       ] = this.Team.DisplayName;
		}

		public static DataRow ConvertToRow(Team obj)
		{
			DataTable dt = Team.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Channel> channels)
		{
			DataTable dt = Team.CreateTable();
			if ( channels != null )
			{
				foreach ( Channel channel in channels )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					channel.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class ChannelPagination
	{
		public IList<Channel> channels       { get; set; }
		public int            count          { get; set; }
	}
}
