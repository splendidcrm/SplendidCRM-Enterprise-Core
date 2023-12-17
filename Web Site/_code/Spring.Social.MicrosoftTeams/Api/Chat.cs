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
	public class Chat : Entity
	{
		// https://learn.microsoft.com/en-us/graph/api/resources/chat?view=graph-rest-1.0
		#region Properties
		public String              Topic                   { get; set; }
		public String              ChatType                { get; set; }
		public String              Description             { get; set; }
		public String              TenantId                { get; set; }
		public String              WebUrl                  { get; set; }
		public DateTime            LastUpdatedDateTime     { get; set; }
		public bool?               IsHidden                { get; set; }
		public DateTime?           LastMessageReadDateTime { get; set; }
		#endregion

		public Chat()
		{
			this.ODataType = "microsoft.graph.chat";
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("Name"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("ChatType"               , Type.GetType("System.String"  ));
			dt.Columns.Add("Description"            , Type.GetType("System.String"  ));
			dt.Columns.Add("TenantId"               , Type.GetType("System.String"  ));
			dt.Columns.Add("WebUrl"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("CreatedDateTime"        , Type.GetType("System.DateTime"));
			dt.Columns.Add("LastUpdatedDateTime"    , Type.GetType("System.DateTime"));
			dt.Columns.Add("IsHidden"               , Type.GetType("System.Boolean" ));
			dt.Columns.Add("LastMessageReadDateTime", Type.GetType("System.DateTime"));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			row["Id"                     ] = this.Id                     ;
			row["Name"                   ] = this.Topic                  ;
			row["ChatType"               ] = this.ChatType               ;
			row["Description"            ] = this.Description            ;
			row["TenantId"               ] = this.TenantId               ;
			row["WebUrl"                 ] = this.WebUrl                 ;
			row["CreatedDateTime"        ] = this.CreatedDateTime        ;
			row["LastUpdatedDateTime"    ] = this.LastUpdatedDateTime    ;
			if ( this.IsHidden.HasValue )
				row["IsHidden"               ] = this.IsHidden.Value               ;
			if ( this.LastMessageReadDateTime.HasValue )
				row["LastMessageReadDateTime"] = this.LastMessageReadDateTime.Value;
		}

		public static DataRow ConvertToRow(Team obj)
		{
			DataTable dt = Team.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Chat> chats)
		{
			DataTable dt = Team.CreateTable();
			if ( chats != null )
			{
				foreach ( Chat chat in chats )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					chat.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class ChatPagination
	{
		public IList<Chat>    chats          { get; set; }
		public int            count          { get; set; }
	}
}
