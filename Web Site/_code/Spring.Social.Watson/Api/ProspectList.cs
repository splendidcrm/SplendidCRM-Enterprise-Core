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

namespace Spring.Social.Watson.Api
{
	[Serializable]
	public class ProspectList : HBase
	{
		#region Properties
		public String           NAME                      { get; set; }
		public int?             TYPE                      { get; set; }
		public int?             SIZE                      { get; set; }
		public int?             NUM_OPT_OUTS              { get; set; }
		public int?             NUM_UNDELIVERABLE         { get; set; }
		public int?             VISIBILITY                { get; set; }
		public String           PARENT_DATABASE_ID        { get; set; }
		public String           PARENT_NAME               { get; set; }
		public String           ORGANIZATION_ID           { get; set; }
		public String           USER_ID                   { get; set; }
		public String           PARENT_FOLDER_PATH        { get; set; }
		public String           PARENT_FOLDER_ID          { get; set; }
		public bool?            IS_FOLDER                 { get; set; }
		public bool?            FLAGGED_FOR_BACKUP        { get; set; }
		public String           SUPPRESSION_LIST_ID       { get; set; }
		public bool?            OPT_IN_FORM_DEFINED       { get; set; }
		public bool?            OPT_OUT_FORM_DEFINED      { get; set; }
		public bool?            PROFILE_FORM_DEFINED      { get; set; }
		public bool?            OPT_IN_AUTOREPLY_DEFINED  { get; set; }
		public bool?            PROFILE_AUTOREPLY_DEFINED { get; set; }
		public List<string>     COLUMNS                   { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("ID"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("CREATED"                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("LAST_MODIFIED"            , Type.GetType("System.DateTime"));
			dt.Columns.Add("NAME"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("TYPE"                     , Type.GetType("System.Int64"   ));
			dt.Columns.Add("SIZE"                     , Type.GetType("System.Int64"   ));
			dt.Columns.Add("NUM_OPT_OUTS"             , Type.GetType("System.Int64"   ));
			dt.Columns.Add("NUM_UNDELIVERABLE"        , Type.GetType("System.Int64"   ));
			dt.Columns.Add("VISIBILITY"               , Type.GetType("System.Int64"   ));
			dt.Columns.Add("PARENT_DATABASE_ID"       , Type.GetType("System.String"  ));
			dt.Columns.Add("PARENT_NAME"              , Type.GetType("System.String"  ));
			dt.Columns.Add("ORGANIZATION_ID"          , Type.GetType("System.String"  ));
			dt.Columns.Add("USER_ID"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("PARENT_FOLDER_ID"         , Type.GetType("System.String"  ));
			dt.Columns.Add("IS_FOLDER"                , Type.GetType("System.Boolean" ));
			dt.Columns.Add("FLAGGED_FOR_BACKUP"       , Type.GetType("System.Boolean" ));
			dt.Columns.Add("SUPPRESSION_LIST_ID"      , Type.GetType("System.String"  ));
			dt.Columns.Add("OPT_IN_FORM_DEFINED"      , Type.GetType("System.Boolean" ));
			dt.Columns.Add("OPT_OUT_FORM_DEFINED"     , Type.GetType("System.Boolean" ));
			dt.Columns.Add("PROFILE_FORM_DEFINED"     , Type.GetType("System.Boolean" ));
			dt.Columns.Add("OPT_IN_AUTOREPLY_DEFINED" , Type.GetType("System.Boolean" ));
			dt.Columns.Add("PROFILE_AUTOREPLY_DEFINED", Type.GetType("System.Boolean" ));
			dt.Columns.Add("COLUMNS"                  , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.ID                       != null   ) row["ID"                       ] = Sql.ToDBString  (this.ID                             );
			if ( this.CREATED                  .HasValue ) row["CREATED"                  ] = Sql.ToDBDateTime(this.CREATED                  .Value);
			if ( this.LAST_MODIFIED            .HasValue ) row["LAST_MODIFIED"            ] = Sql.ToDBDateTime(this.LAST_MODIFIED            .Value);
			if ( this.NAME                     != null   ) row["NAME"                     ] = Sql.ToDBString  (this.NAME                           );
			if ( this.TYPE                     .HasValue ) row["TYPE"                     ] = Sql.ToDBString  (this.TYPE                     .Value);
			if ( this.SIZE                     .HasValue ) row["SIZE"                     ] = Sql.ToDBString  (this.SIZE                     .Value);
			if ( this.NUM_OPT_OUTS             .HasValue ) row["NUM_OPT_OUTS"             ] = Sql.ToDBBoolean (this.NUM_OPT_OUTS             .Value);
			if ( this.NUM_UNDELIVERABLE        .HasValue ) row["NUM_UNDELIVERABLE"        ] = Sql.ToDBString  (this.NUM_UNDELIVERABLE        .Value);
			if ( this.VISIBILITY               .HasValue ) row["VISIBILITY"               ] = Sql.ToDBString  (this.VISIBILITY               .Value);
			if ( this.PARENT_DATABASE_ID       != null   ) row["PARENT_DATABASE_ID"       ] = Sql.ToDBInteger (this.PARENT_DATABASE_ID             );
			if ( this.PARENT_NAME              != null   ) row["PARENT_NAME"              ] = Sql.ToDBInteger (this.PARENT_NAME                    );
			if ( this.ORGANIZATION_ID          != null   ) row["ORGANIZATION_ID"          ] = Sql.ToDBBoolean (this.ORGANIZATION_ID                );
			if ( this.USER_ID                  != null   ) row["USER_ID"                  ] = Sql.ToDBBoolean (this.USER_ID                        );
			if ( this.PARENT_FOLDER_ID         != null   ) row["PARENT_FOLDER_ID"         ] = Sql.ToDBString  (this.PARENT_FOLDER_ID               );
			if ( this.IS_FOLDER                .HasValue ) row["IS_FOLDER"                ] = Sql.ToDBString  (this.IS_FOLDER                .Value);
			if ( this.FLAGGED_FOR_BACKUP       .HasValue ) row["FLAGGED_FOR_BACKUP"       ] = Sql.ToDBString  (this.FLAGGED_FOR_BACKUP       .Value);
			if ( this.SUPPRESSION_LIST_ID      != null   ) row["SUPPRESSION_LIST_ID"      ] = Sql.ToDBString  (this.SUPPRESSION_LIST_ID            );
			if ( this.OPT_IN_FORM_DEFINED      .HasValue ) row["OPT_IN_FORM_DEFINED"      ] = Sql.ToDBString  (this.OPT_IN_FORM_DEFINED      .Value);
			if ( this.OPT_OUT_FORM_DEFINED     .HasValue ) row["OPT_OUT_FORM_DEFINED"     ] = Sql.ToDBString  (this.OPT_OUT_FORM_DEFINED     .Value);
			if ( this.PROFILE_FORM_DEFINED     .HasValue ) row["PROFILE_FORM_DEFINED"     ] = Sql.ToDBString  (this.PROFILE_FORM_DEFINED     .Value);
			if ( this.OPT_IN_AUTOREPLY_DEFINED .HasValue ) row["OPT_IN_AUTOREPLY_DEFINED" ] = Sql.ToDBString  (this.OPT_IN_AUTOREPLY_DEFINED .Value);
			if ( this.PROFILE_AUTOREPLY_DEFINED.HasValue ) row["PROFILE_AUTOREPLY_DEFINED"] = Sql.ToDBString  (this.PROFILE_AUTOREPLY_DEFINED.Value);
			if ( this.COLUMNS                  != null   ) row["COLUMNS"                  ] = Sql.ToDBString  (String.Join(",", this.COLUMNS.ToArray()));
		}

		public static DataRow ConvertToRow(Spring.Social.Watson.Api.ProspectList obj)
		{
			DataTable dt = Spring.Social.Watson.Api.ProspectList.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Spring.Social.Watson.Api.ProspectList> lists)
		{
			DataTable dt = Spring.Social.Watson.Api.ProspectList.CreateTable();
			if ( lists != null )
			{
				foreach ( Spring.Social.Watson.Api.ProspectList list in lists )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					list.SetRow(row);
				}
			}
			return dt;
		}
	}

	[Serializable]
	public class ProspectListInsert
	{
		public String           RawContent                { get; set; }
		public String           CONTACT_LIST_ID           { get; set; }
		public String           PARENT_FOLDER_ID          { get; set; }
	}
}
