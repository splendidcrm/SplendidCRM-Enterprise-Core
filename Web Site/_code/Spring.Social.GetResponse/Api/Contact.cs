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
	public class Contact : HBase
	{
		// http://apidocs.getresponse.com/en/v3/
		#region Properties
		public String name          { get; set; }
		public String email         { get; set; }
		public String note          { get; set; }
		public String origin        { get; set; }
		public String campaignId    { get; set; }
		public String campaignName  { get; set; }
		public String ipAddress     { get; set; }
		public String timeZone      { get; set; }
		public String dayOfCycle    { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"          , Type.GetType("System.String"  ));
			dt.Columns.Add("createdOn"   , Type.GetType("System.DateTime"));
			dt.Columns.Add("changedOn"   , Type.GetType("System.DateTime"));
			dt.Columns.Add("name"        , Type.GetType("System.String"  ));
			dt.Columns.Add("email"       , Type.GetType("System.String"  ));
			dt.Columns.Add("note"        , Type.GetType("System.String"  ));
			dt.Columns.Add("origin"      , Type.GetType("System.String"  ));
			dt.Columns.Add("campaignId"  , Type.GetType("System.String"  ));
			dt.Columns.Add("campaignName", Type.GetType("System.String"  ));
			dt.Columns.Add("ipAddress"   , Type.GetType("System.String"  ));
			dt.Columns.Add("timeZone"    , Type.GetType("System.String"  ));
			dt.Columns.Add("dayOfCycle"  , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id           != null   ) row["id"          ] = Sql.ToDBInteger (this.id              );
			if ( this.createdOn    .HasValue ) row["createdOn"   ] = Sql.ToDBDateTime(this.createdOn .Value);
			if ( this.changedOn    .HasValue ) row["changedOn"   ] = Sql.ToDBDateTime(this.changedOn .Value);
			if ( this.name         != null   ) row["name"        ] = Sql.ToDBString  (this.name            );
			if ( this.email        != null   ) row["email"       ] = Sql.ToDBString  (this.email           );
			if ( this.note         != null   ) row["note"        ] = Sql.ToDBString  (this.note            );
			if ( this.origin       != null   ) row["origin"      ] = Sql.ToDBString  (this.origin          );
			if ( this.campaignId   != null   ) row["campaignId"  ] = Sql.ToDBString  (this.campaignId      );
			if ( this.campaignName != null   ) row["campaignName"] = Sql.ToDBString  (this.campaignName    );
			if ( this.ipAddress    != null   ) row["ipAddress"   ] = Sql.ToDBString  (this.ipAddress       );
			if ( this.timeZone     != null   ) row["timeZone"    ] = Sql.ToDBString  (this.timeZone        );
			if ( this.dayOfCycle   != null   ) row["dayOfCycle"  ] = Sql.ToDBInteger (this.dayOfCycle      );
		}

		public static DataRow ConvertToRow(Contact obj)
		{
			DataTable dt = Contact.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Contact> contacts)
		{
			DataTable dt = Contact.CreateTable();
			if ( contacts != null )
			{
				foreach ( Contact contact in contacts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					contact.SetRow(row);
				}
			}
			return dt;
		}
	}
}
