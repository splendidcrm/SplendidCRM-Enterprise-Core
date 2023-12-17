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

namespace Spring.Social.ConstantContact.Api
{
	// http://developer.constantcontact.com/docs/developer-guides/api-documentation-index.html
	[Serializable]
	public class Contact : HBase
	{
		#region Properties
		// http://developer.constantcontact.com/docs/contacts-api/contacts-resource.html
		// 11/11/2019 Paul.  Updated to v3. 
		// https://v3.developer.constantcontact.com/api_reference/index.html#!/Contacts/getContacts
		public String              prefix_name     { get; set; }
		public String              first_name      { get; set; }
		public String              last_name       { get; set; }
		public String              job_title       { get; set; }
		public String              company_name    { get; set; }
		public String              work_phone      { get; set; }
		public String              fax             { get; set; }
		public String              cell_phone      { get; set; }
		public String              home_phone      { get; set; }
		public EmailAddress        email_address   { get; set; }
		public IList<Address>      addresses       { get; set; }
		public IList<ListRef>      lists           { get; set; }
		public IList<Note>         notes           { get; set; }
		public String              confirmed       { get; set; }
		public String              status          { get; set; }
		public String              source          { get; set; }
		public String              source_details  { get; set; }
		#endregion

		public string Email1
		{
			get
			{
				string email_address = String.Empty;
				if ( this.email_address != null )
				{
					email_address = this.email_address.address;
				}
				return email_address;
			}
			set
			{
				if ( this.email_address == null || this.email_address.address != value )
				{
					this.email_address = new EmailAddress(value);
				}
			}
		}

		// 05/04/2015 Paul.  The API will only allow for 1 email. 
		/*
		public string Email2
		{
			get
			{
				string email_address = String.Empty;
				if ( this.email_addresses != null && this.email_addresses.Count > 1 )
					email_address = this.email_addresses[1].email_address;
				return email_address;
			}
			set
			{
				if ( this.email_addresses == null )
					this.email_addresses = new List<EmailAddress>();
				if ( this.email_addresses.Count == 0 )
				{
					// 05/03/2015 Paul.  If we are setting Email2 and there is no Email1, then do nothing. 
				}
				else if ( this.email_addresses.Count == 1 )
				{
					this.email_addresses.Add(new EmailAddress(value));
				}
				else if ( this.email_addresses[1].email_address != value )
				{
					this.email_addresses[1] = new EmailAddress(value);
				}
				// 05/04/2015 Paul.  Clean list by removing empty emails. 
				CleanupEmails();
			}
		}
		*/

		public string Notes
		{
			get
			{
				string sNotes = String.Empty;
				if ( this.notes != null )
				{
					foreach ( Note note in this.notes )
					{
						sNotes += note.note + ControlChars.CrLf;
					}
				}
				return sNotes;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
				{
					if ( this.notes != null && this.notes.Count > 0 )
					{
						if ( this.notes[notes.Count - 1].note != value )
							this.notes.Add(new Note(value));
					}
					else
					{
						this.notes = new List<Note>();
						this.notes.Add(new Note(value));
					}
				}
			}
		}

		public string Lists
		{
			get
			{
				string sLists = String.Empty;
				if ( this.lists != null )
				{
					foreach ( ListRef list in this.lists )
					{
						if ( sLists.Length > 0 )
							sLists += ",";
						sLists += list.id;
					}
				}
				return sLists;
			}
			set
			{
				this.lists = new List<ListRef>();
				if ( !Sql.IsEmptyString(value) )
				{
					foreach ( string id in value.Split(',') )
					{
						this.lists.Add(new ListRef(id));
					}
				}
			}
		}

		public void AddList(string id)
		{
			if ( !Sql.IsEmptyString(id) )
			{
				if ( this.lists != null && this.lists.Count > 0 )
				{
					bool bFound = false;
					for ( int i = 0; i < this.lists.Count; i++ )
					{
						if ( this.lists[i].id == id )
							bFound = true;
					}
					if ( !bFound )
						this.lists.Add(new ListRef(id));
				}
				else
				{
					this.lists = new List<ListRef>();
					this.lists.Add(new ListRef(id));
				}
			}
		}

		private void CleanupAddresses()
		{
			for ( int i = this.addresses.Count - 1; i >= 0; i-- )
			{
				if ( this.addresses[i].IsEmptyAddress() )
					this.addresses.RemoveAt(i);
			}
			if ( this.addresses.Count == 0 )
				this.addresses = null;
		}

		public void SetAddress(string address_type, string street, string city, string state, string postal_code, string country_code)
		{
			if ( this.addresses == null )
				this.addresses = new List<Address>();
			if ( address_type != "BUSINESS" && address_type != "PERSONAL" )
				address_type = "BUSINESS";
			Address adr = null;
			foreach ( Address address in this.addresses )
			{
				if ( address.address_type == address_type )
				{
					adr = address;
					break;
				}
			}
			if ( adr == null )
			{
				adr = new Address(address_type);
				this.addresses.Add(adr);
			}
			string[] arrStreet = street.Split(ControlChars.CrLf.ToCharArray());
			adr.line1        = arrStreet.Length > 0 ? arrStreet[0] : String.Empty;
			adr.line2        = arrStreet.Length > 1 ? arrStreet[1] : String.Empty;
			adr.line3        = arrStreet.Length > 2 ? arrStreet[2] : String.Empty;
			adr.city         = city        ;
			adr.state        = state       ;
			adr.postal_code  = postal_code ;
			adr.country_code = country_code;
			// 05/04/2015 Paul.  Clean list by removing empty addresses. 
			CleanupAddresses();
		}

		public void GetAddress(string address_type, ref string street, ref string city, ref string state, ref string postal_code, ref string country_code)
		{
			if ( this.addresses != null )
			{
				if ( address_type != "BUSINESS" && address_type != "PERSONAL" )
					address_type = "BUSINESS";
				Address adr = null;
				foreach ( Address address in this.addresses )
				{
					if ( address.address_type == address_type )
					{
						adr = address;
						break;
					}
				}
				if ( adr != null )
				{
					street       = adr.line1       ;
					if ( !Sql.IsEmptyString(adr.line2) )
						street += ControlChars.CrLf + adr.line2;
					if ( !Sql.IsEmptyString(adr.line3) )
						street += ControlChars.CrLf + adr.line3;
					city         = adr.city        ;
					state        = adr.state       ;
					postal_code  = adr.postal_code ;
					country_code = adr.country_code;
				}
			}
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("created_date"            , Type.GetType("System.DateTime"));
			dt.Columns.Add("modified_date"           , Type.GetType("System.DateTime"));
			dt.Columns.Add("prefix_name"             , Type.GetType("System.String"  ));
			dt.Columns.Add("first_name"              , Type.GetType("System.String"  ));
			dt.Columns.Add("last_name"               , Type.GetType("System.String"  ));
			dt.Columns.Add("job_title"               , Type.GetType("System.String"  ));
			dt.Columns.Add("company_name"            , Type.GetType("System.String"  ));
			dt.Columns.Add("work_phone"              , Type.GetType("System.String"  ));
			dt.Columns.Add("fax"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("cell_phone"              , Type.GetType("System.String"  ));
			dt.Columns.Add("home_phone"              , Type.GetType("System.String"  ));
			dt.Columns.Add("email1"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("email2"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("business_line1"          , Type.GetType("System.String"  ));
			dt.Columns.Add("business_line2"          , Type.GetType("System.String"  ));
			dt.Columns.Add("business_line3"          , Type.GetType("System.String"  ));
			dt.Columns.Add("business_city"           , Type.GetType("System.String"  ));
			dt.Columns.Add("business_state"          , Type.GetType("System.String"  ));
			dt.Columns.Add("business_state_code"     , Type.GetType("System.String"  ));
			dt.Columns.Add("business_postal_code"    , Type.GetType("System.String"  ));
			dt.Columns.Add("business_sub_postal_code", Type.GetType("System.String"  ));
			dt.Columns.Add("business_country_code"   , Type.GetType("System.String"  ));
			dt.Columns.Add("personal_line1"          , Type.GetType("System.String"  ));
			dt.Columns.Add("personal_line2"          , Type.GetType("System.String"  ));
			dt.Columns.Add("personal_line3"          , Type.GetType("System.String"  ));
			dt.Columns.Add("personal_city"           , Type.GetType("System.String"  ));
			dt.Columns.Add("personal_state"          , Type.GetType("System.String"  ));
			dt.Columns.Add("personal_state_code"     , Type.GetType("System.String"  ));
			dt.Columns.Add("personal_postal_code"    , Type.GetType("System.String"  ));
			dt.Columns.Add("personal_sub_postal_code", Type.GetType("System.String"  ));
			dt.Columns.Add("personal_country_code"   , Type.GetType("System.String"  ));
			dt.Columns.Add("lists"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("notes"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("confirmed"               , Type.GetType("System.String"  ));
			dt.Columns.Add("status"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("source"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("source_details"          , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			Address adrBusiness = null;
			Address adrPersonal = null;
			foreach ( Address address in this.addresses )
			{
				if ( address.address_type == "BUSINESS" && adrBusiness == null )
				{
					adrBusiness = address;
				}
				else if ( address.address_type == "PERSONAL" && adrPersonal == null )
				{
					adrPersonal = address;
				}
			}
			if ( this.id               != null   ) row["id"             ] = Sql.ToDBInteger (this.id                    );
			if ( this.created_date     .HasValue ) row["created_date"   ] = Sql.ToDBDateTime(this.created_date    .Value);
			if ( this.modified_date    .HasValue ) row["modified_date"  ] = Sql.ToDBDateTime(this.modified_date   .Value);
			if ( this.prefix_name      != null   ) row["prefix_name"    ] = Sql.ToDBString  (this.prefix_name           );
			if ( this.first_name       != null   ) row["first_name"     ] = Sql.ToDBString  (this.first_name            );
			if ( this.last_name        != null   ) row["last_name"      ] = Sql.ToDBString  (this.last_name             );
			if ( this.job_title        != null   ) row["job_title"      ] = Sql.ToDBString  (this.job_title             );
			if ( this.company_name     != null   ) row["company_name"   ] = Sql.ToDBString  (this.company_name          );
			if ( this.work_phone       != null   ) row["work_phone"     ] = Sql.ToDBString  (this.work_phone            );
			if ( this.fax              != null   ) row["fax"            ] = Sql.ToDBString  (this.fax                   );
			if ( this.cell_phone       != null   ) row["cell_phone"     ] = Sql.ToDBString  (this.cell_phone            );
			if ( this.home_phone       != null   ) row["home_phone"     ] = Sql.ToDBString  (this.home_phone            );
			if ( this.Email1           != null   ) row["email1"         ] = Sql.ToDBString  (this.Email1                );
			//if ( this.Email2           != null   ) row["email2"         ] = Sql.ToDBString  (this.Email2                );
			if ( adrBusiness           != null   )
			{
				if ( adrBusiness.line1           != null   ) row["business_line1"          ] = Sql.ToDBString(adrBusiness.line1          );
				if ( adrBusiness.line2           != null   ) row["business_line2"          ] = Sql.ToDBString(adrBusiness.line2          );
				if ( adrBusiness.line3           != null   ) row["business_line3"          ] = Sql.ToDBString(adrBusiness.line3          );
				if ( adrBusiness.city            != null   ) row["business_city"           ] = Sql.ToDBString(adrBusiness.city           );
				if ( adrBusiness.state           != null   ) row["business_state"          ] = Sql.ToDBString(adrBusiness.state          );
				if ( adrBusiness.state_code      != null   ) row["business_state_code"     ] = Sql.ToDBString(adrBusiness.state_code     );
				if ( adrBusiness.postal_code     != null   ) row["business_postal_code"    ] = Sql.ToDBString(adrBusiness.postal_code    );
				if ( adrBusiness.sub_postal_code != null   ) row["business_sub_postal_code"] = Sql.ToDBString(adrBusiness.sub_postal_code);
				if ( adrBusiness.country_code    != null   ) row["business_country_code"   ] = Sql.ToDBString(adrBusiness.country_code   );
			}
			if ( adrPersonal           != null   )
			{
				if ( adrPersonal.line1           != null   ) row["personal_line1"          ] = Sql.ToDBString(adrPersonal.line1          );
				if ( adrPersonal.line2           != null   ) row["personal_line2"          ] = Sql.ToDBString(adrPersonal.line2          );
				if ( adrPersonal.line3           != null   ) row["personal_line3"          ] = Sql.ToDBString(adrPersonal.line3          );
				if ( adrPersonal.city            != null   ) row["personal_city"           ] = Sql.ToDBString(adrPersonal.city           );
				if ( adrPersonal.state           != null   ) row["personal_state"          ] = Sql.ToDBString(adrPersonal.state          );
				if ( adrPersonal.state_code      != null   ) row["personal_state_code"     ] = Sql.ToDBString(adrPersonal.state_code     );
				if ( adrPersonal.postal_code     != null   ) row["personal_postal_code"    ] = Sql.ToDBString(adrPersonal.postal_code    );
				if ( adrPersonal.sub_postal_code != null   ) row["personal_sub_postal_code"] = Sql.ToDBString(adrPersonal.sub_postal_code);
				if ( adrPersonal.country_code    != null   ) row["personal_country_code"   ] = Sql.ToDBString(adrPersonal.country_code   );
			}
			if ( this.lists            != null   ) row["lists"          ] = Sql.ToDBString  (this.Lists                 );
			if ( this.notes            != null   ) row["notes"          ] = Sql.ToDBString  (this.Notes                 );
			if ( this.confirmed        != null   ) row["confirmed"      ] = Sql.ToDBString  (this.confirmed             );
			if ( this.status           != null   ) row["status"         ] = Sql.ToDBString  (this.status                );
			if ( this.source           != null   ) row["source"         ] = Sql.ToDBString  (this.source                );
			if ( this.source_details   != null   ) row["source_details" ] = Sql.ToDBString  (this.source_details        );
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
		public string         next_link  { get; set; }
	}
}
