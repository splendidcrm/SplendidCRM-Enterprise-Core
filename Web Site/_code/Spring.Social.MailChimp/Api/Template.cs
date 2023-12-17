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
	public class Template : HBase
	{
		#region Properties
		public String    name                            { get; set; }
		public String    type                            { get; set; }
		public String    folder_id                       { get; set; }
		public bool?     drag_and_drop                   { get; set; }
		public bool?     responsive                      { get; set; }
		public String    category                        { get; set; }
		public bool?     active                          { get; set; }
		public String    html                            { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"           , Type.GetType("System.String"  ));
			dt.Columns.Add("date_created" , Type.GetType("System.DateTime"));  // 2015-09-15T13:09:22+00:00
			dt.Columns.Add("created_by"   , Type.GetType("System.String"  ));
			dt.Columns.Add("name"         , Type.GetType("System.String"  ));
			dt.Columns.Add("type"         , Type.GetType("System.String"  ));
			dt.Columns.Add("folder_id"    , Type.GetType("System.String"  ));
			dt.Columns.Add("drag_and_drop", Type.GetType("System.Boolean" ));
			dt.Columns.Add("responsive"   , Type.GetType("System.Boolean" ));
			dt.Columns.Add("category"     , Type.GetType("System.String"  ));
			dt.Columns.Add("active"       , Type.GetType("System.Boolean" ));
			dt.Columns.Add("html"         , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id            != null   ) row["id"           ] = Sql.ToDBString  (this.id                 );
			if ( this.date_created  .HasValue ) row["date_created" ] = Sql.ToDBDateTime(this.date_created .Value);
			if ( this.created_by    != null   ) row["created_by"   ] = Sql.ToDBString  (this.created_by         );
			if ( this.name          != null   ) row["name"         ] = Sql.ToDBString  (this.name               );
			if ( this.type          != null   ) row["type"         ] = Sql.ToDBString  (this.type               );
			if ( this.folder_id     != null   ) row["folder_id"    ] = Sql.ToDBString  (this.folder_id          );
			if ( this.drag_and_drop .HasValue ) row["drag_and_drop"] = Sql.ToDBBoolean (this.drag_and_drop.Value);
			if ( this.responsive    .HasValue ) row["responsive"   ] = Sql.ToDBBoolean (this.responsive   .Value);
			if ( this.category      != null   ) row["category"     ] = Sql.ToDBString  (this.category           );
			if ( this.active        .HasValue ) row["active"       ] = Sql.ToDBBoolean (this.active       .Value);
			if ( this.html          != null   ) row["html"         ] = Sql.ToDBString  (this.html               );
		}

		public static DataRow ConvertToRow(Template obj)
		{
			DataTable dt = Template.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Template> templates)
		{
			DataTable dt = Template.CreateTable();
			if ( templates != null )
			{
				foreach ( Template template in templates )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					template.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class TemplatePagination
	{
		public IList<Template> items      { get; set; }
		public int             total      { get; set; }
	}
}
