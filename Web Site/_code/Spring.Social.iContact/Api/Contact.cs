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

namespace Spring.Social.iContact.Api
{
	// http://developers.icontact.com/docs/methods/contacts/contacts-overview
	// http://knowledge.icontact.com/contacts-user-guide/how-to-use-contact-properties
	[Serializable]
	public class Contact
	{
		#region Properties
		// http://www.icontact.com/developerportal/documentation/contacts/
		public String   RawContent   { get; set; }
		public String   contactId    { get; set; }
		public DateTime createDate   { get; set; }  // Read-only. 
		public String   email        { get; set; }  // Required field. 
		public String   prefix       { get; set; }
		public String   firstName    { get; set; }
		public String   lastName     { get; set; }
		public String   suffix       { get; set; }
		public String   street       { get; set; }
		public String   street2      { get; set; }
		public String   city         { get; set; }
		public String   state        { get; set; }
		public String   postalCode   { get; set; }
		public String   phone        { get; set; }
		public String   fax          { get; set; }
		public String   business     { get; set; }
		public String   status       { get; set; }  // Status can only be changed to donotcontact or normal when updating a contact. You cannot change a contact’s status if that status is donotcontact, pending, or invitable
		public int?     bounceCount  { get; set; }  // Read-only. 
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("contactId"  , Type.GetType("System.String"  ));
			dt.Columns.Add("createDate" , Type.GetType("System.DateTime"));
			dt.Columns.Add("email"      , Type.GetType("System.String"  ));
			dt.Columns.Add("prefix"     , Type.GetType("System.String"  ));
			dt.Columns.Add("firstName"  , Type.GetType("System.String"  ));
			dt.Columns.Add("lastName"   , Type.GetType("System.String"  ));
			dt.Columns.Add("suffix"     , Type.GetType("System.String"  ));
			dt.Columns.Add("street"     , Type.GetType("System.String"  ));
			dt.Columns.Add("street2"    , Type.GetType("System.String"  ));
			dt.Columns.Add("city"       , Type.GetType("System.String"  ));
			dt.Columns.Add("state"      , Type.GetType("System.String"  ));
			dt.Columns.Add("postalCode" , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"      , Type.GetType("System.String"  ));
			dt.Columns.Add("fax"        , Type.GetType("System.String"  ));
			dt.Columns.Add("business"   , Type.GetType("System.String"  ));
			dt.Columns.Add("status"     , Type.GetType("System.String"  ));
			dt.Columns.Add("bounceCount", Type.GetType("System.Int64"   ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.contactId   != null   ) row["contactId"  ] = Sql.ToDBString  (this.contactId        );
			/* if ( this.createDate  != null   ) */
				row["createDate" ] = Sql.ToDBDateTime(this.createDate       );
			if ( this.email       != null   ) row["email"      ] = Sql.ToDBString  (this.email            );
			if ( this.prefix      != null   ) row["prefix"     ] = Sql.ToDBString  (this.prefix           );
			if ( this.firstName   != null   ) row["firstName"  ] = Sql.ToDBString  (this.firstName        );
			if ( this.lastName    != null   ) row["lastName"   ] = Sql.ToDBString  (this.lastName         );
			if ( this.suffix      != null   ) row["suffix"     ] = Sql.ToDBString  (this.suffix           );
			if ( this.street      != null   ) row["street"     ] = Sql.ToDBString  (this.street           );
			if ( this.street2     != null   ) row["street2"    ] = Sql.ToDBString  (this.street2          );
			if ( this.city        != null   ) row["city"       ] = Sql.ToDBString  (this.city             );
			if ( this.state       != null   ) row["state"      ] = Sql.ToDBString  (this.state            );
			if ( this.postalCode  != null   ) row["postalCode" ] = Sql.ToDBString  (this.postalCode       );
			if ( this.phone       != null   ) row["phone"      ] = Sql.ToDBString  (this.phone            );
			if ( this.fax         != null   ) row["fax"        ] = Sql.ToDBString  (this.fax              );
			if ( this.business    != null   ) row["business"   ] = Sql.ToDBString  (this.business         );
			if ( this.status      != null   ) row["status"     ] = Sql.ToDBString  (this.status           );
			if ( this.bounceCount .HasValue ) row["bounceCount"] = Sql.ToDBInteger (this.bounceCount.Value);
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

	public class ContactPagination
	{
		public IList<Contact> items      { get; set; }
		public int            limit      { get; set; }
		public int            offset     { get; set; }
		public int            total      { get; set; }
	}
}
