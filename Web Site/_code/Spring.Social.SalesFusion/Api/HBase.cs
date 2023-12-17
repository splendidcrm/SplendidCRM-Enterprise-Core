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
	public class HBase
	{
		public String     RawContent                    { get; set; }
		public int?       id                            { get; set; }
		public DateTime?  created_date                  { get; set; }
		public int?       created_by_id                 { get; set; }
		public String     created_by                    { get; set; }  // URL
		public DateTime?  updated_date                  { get; set; }
		public int?       updated_by_id                 { get; set; }
		public String     updated_by                    { get; set; }  // URL
		public int?       owner_id                      { get; set; }
		public String     owner_name                    { get; set; }
		public String     owner                         { get; set; }  // URL
		public String     crm_id                        { get; set; }  // 100

		protected static void AddBaseColumns(DataTable dt)
		{
			dt.Columns.Add("id"                           , Type.GetType("System.Int32"   ));
			dt.Columns.Add("created_date"                 , Type.GetType("System.DateTime"));
			dt.Columns.Add("created_by_id"                , Type.GetType("System.Int32"   ));
			dt.Columns.Add("created_by"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("updated_date"                 , Type.GetType("System.DateTime"));
			dt.Columns.Add("updated_by_id"                , Type.GetType("System.Int32"   ));
			dt.Columns.Add("updated_by"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("owner_id"                     , Type.GetType("System.Int32"   ));
			dt.Columns.Add("owner_name"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("owner"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("crm_id"                       , Type.GetType("System.String"  ));
		}

		protected void SetBaseColumns(DataRow row)
		{
			if ( this.id                           .HasValue ) row["id"                           ] = Sql.ToDBInteger (this.id                           .Value);
			if ( this.created_date                 .HasValue ) row["created_date"                 ] = Sql.ToDBDateTime(this.created_date                 .Value);
			if ( this.created_by_id                .HasValue ) row["created_by_id"                ] = Sql.ToDBInteger (this.created_by_id                .Value);
			if ( this.created_by                   != null   ) row["created_by"                   ] = Sql.ToDBString  (this.created_by                         );
			if ( this.updated_date                 .HasValue ) row["updated_date"                 ] = Sql.ToDBDateTime(this.updated_date                 .Value);
			if ( this.updated_by_id                .HasValue ) row["updated_by_id"                ] = Sql.ToDBInteger (this.updated_by_id                .Value);
			if ( this.updated_by                   != null   ) row["updated_by"                   ] = Sql.ToDBString  (this.updated_by                         );
			if ( this.owner_id                     .HasValue ) row["owner_id"                     ] = Sql.ToDBInteger (this.owner_id                     .Value);
			if ( this.owner_name                   != null   ) row["owner_name"                   ] = Sql.ToDBString  (this.owner_name                         );
			if ( this.owner                        != null   ) row["owner"                        ] = Sql.ToDBString  (this.owner                              );
			if ( this.crm_id                       != null   ) row["crm_id"                       ] = Sql.ToDBString  (this.crm_id                             );
		}
	}

	public class HPagination
	{
		public int            page_size   { get; set; }
		public int            page_number { get; set; }
		public int            total_count { get; set; }
		public String         next        { get; set; }
	}
}
