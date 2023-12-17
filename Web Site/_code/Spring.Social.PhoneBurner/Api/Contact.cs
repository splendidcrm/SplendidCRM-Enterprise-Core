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

namespace Spring.Social.PhoneBurner.Api
{
	[Serializable]
	public class Contact : HBase
	{
		#region Properties
		// https://www.phoneburner.com/developer/route_list#contacts
		public int?                     contact_user_id          { get; set; }
		public int?                     owner_id                 { get; set; }  // The member ID that will be owner of the contact.
		public String                   owner_username           { get; set; }  // The member username that will be owner of the contact.
		public String                   email                    { get; set; }  // Email address
		public String                   first_name               { get; set; }  // First name of the contact.
		public String                   last_name                { get; set; }  // Last name of the contact.
		public IList<AdditionalName>    additional_name          { get; set; }  // Additional names(s) of the contact.
		public IList<AdditionalPhone>   additional_phone         { get; set; }  // Additional phone(s) for the contact.
		public String                   phone                    { get; set; }  // Telephone number
		public int?                     phone_type               { get; set; }  // Phone Type: 1=Home, 2=Work, 3=Cell, 5=Other
		public String                   phone_label              { get; set; }  // Label for the telephone number
		public String                   address1                 { get; set; }  // Address line 1
		public String                   address2                 { get; set; }  // Address line 2
		public String                   city                     { get; set; }  // City
		public String                   state                    { get; set; }  // State
		public String                   state_other              { get; set; }  // State if not in standard list
		public String                   zip                      { get; set; }  // Zipcode
		public String                   country                  { get; set; }  // Country
		public String                   ad_code                  { get; set; }  // Promo code. Useful for attaching an identifier on each contact. Often use for advertising tracking.
		public String                   viewed                   { get; set; }  // Mark the contact as viewed by setting to '1'. The default is '0', not viewed
		public String                   category_id              { get; set; }  // The contact "folder"
		public IList<String>            tags                     { get; set; }  // List of tags to add to the contact
		public IList<QuestionAndAnswer> q_and_a                  { get; set; }  // Question(s) and answer(s)
		public IList<CustomField>       custom_fields            { get; set; }  // "Custom Fields - Each entry passed in must have a name, type, and value. 
		                                                                        //  Currently available types are (1=plain text field, 2=checkbox, 3=date field)."
		public IList<SocialAccount>     social_accounts          { get; set; }  // "Social Accounts - Each entry passed in must have a type and an account.
		                                                                        //  Currently available types are (1=Twitter, 2=Facebook, 3=LinkedIn, 4=About Me, 5=Google Profile, 6=Google Plus, 7=Quora, 8=Foursquare, 9=YouTube, 10=Picasa, 11=Plancast, 12=Klout, 13=Flickr)."
		public String                   token                    { get; set; }  // Vendor token
		public String                   return_lead_token        { get; set; }  // Vendor return_lead_token
		public String                   lead_id                  { get; set; }  // Vendor lead_id
		public String                   order_number             { get; set; }  // Vendor order number
		public String                   lead_vendor_product_name { get; set; }  // Vendor product name
		public String                   allow_duplicates         { get; set; }  // Set to 1 (true) to allow duplicates. Set to 0 (false) to restrict duplicates.
		public String                   rating                   { get; set; }  // The star rating for a contact. Valid range: whole numbers between 1 and 5
		public DateTime?                last_call_time           { get; set; }
		public int?                     total_calls              { get; set; }
		public String                   source_code              { get; set; }
		public String                   language                 { get; set; }
		public String                   region                   { get; set; }
		public String                   time_zone                { get; set; }
		public String                   location_name            { get; set; }
		public String                   latitude                 { get; set; }
		public String                   longitude                { get; set; }
		public DateTime?                last_login               { get; set; }
		public String                   do_not_call              { get; set; }

		public IList<Phone>             phones                   { get; set; }
		public IList<Email>             emails                   { get; set; }
		public IList<Address>           addresses                { get; set; }
		public PrimaryEmail             primary_email            { get; set; }
		public PrimaryPhone             primary_phone            { get; set; }
		public PrimaryAddress           primary_address          { get; set; }
		public Note                     notes                    { get; set; }  // Contact notes. Free form text which is added into the notes field of the contact.
		public Category                 category                 { get; set; }
		public ContactStats             stats                    { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("date_added"              , Type.GetType("System.DateTime"));
			dt.Columns.Add("date_modified"           , Type.GetType("System.DateTime"));
			dt.Columns.Add("owner_id"                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("owner_username"          , Type.GetType("System.String"  ));
			dt.Columns.Add("email"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("name"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("first_name"              , Type.GetType("System.String"  ));
			dt.Columns.Add("last_name"               , Type.GetType("System.String"  ));
			dt.Columns.Add("additional_name"         , Type.GetType("System.String"  ));
			dt.Columns.Add("additional_phone"        , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("phone_type"              , Type.GetType("System.Int64"   ));
			dt.Columns.Add("phone_label"             , Type.GetType("System.String"  ));
			dt.Columns.Add("address1"                , Type.GetType("System.String"  ));
			dt.Columns.Add("address2"                , Type.GetType("System.String"  ));
			dt.Columns.Add("city"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("state"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("state_other"             , Type.GetType("System.String"  ));
			dt.Columns.Add("zip"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("country"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("ad_code"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("notes"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("viewed"                  , Type.GetType("System.Int64"   ));
			dt.Columns.Add("category_id"             , Type.GetType("System.Int64"   ));
			dt.Columns.Add("tags"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("q_and_a"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("custom_fields"           , Type.GetType("System.String"  ));
			dt.Columns.Add("social_accounts"         , Type.GetType("System.String"  ));
			dt.Columns.Add("token"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("return_lead_token"       , Type.GetType("System.String"  ));
			dt.Columns.Add("lead_id"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("order_number"            , Type.GetType("System.String"  ));
			dt.Columns.Add("lead_vendor_product_name", Type.GetType("System.String"  ));
			dt.Columns.Add("allow_duplicates"        , Type.GetType("System.String"  ));
			dt.Columns.Add("rating"                  , Type.GetType("System.Int64"   ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			row["id"  ] = this.id;
			row["name"] = (Sql.ToString(this.first_name) + " " + Sql.ToString(this.last_name)).Trim();
			if ( this.date_added                .HasValue ) row["date_added"              ] = Sql.ToDBDateTime(this.date_added               .Value);
			if ( this.date_modified             .HasValue ) row["date_modified"           ] = Sql.ToDBDateTime(this.date_modified            .Value);
			if ( this.owner_id                  .HasValue ) row["owner_id"                ] = Sql.ToDBInteger (this.owner_id                 .Value);
			if ( this.owner_username            != null   ) row["owner_username"          ] = Sql.ToDBString  (this.owner_username                 );
			if ( this.email                     != null   ) row["email"                   ] = Sql.ToDBString  (this.email                          );
			if ( this.first_name                != null   ) row["first_name"              ] = Sql.ToDBString  (this.first_name                     );
			if ( this.last_name                 != null   ) row["last_name"               ] = Sql.ToDBString  (this.last_name                      );
			if ( this.additional_name           != null   ) row["additional_name"         ] = Sql.ToDBString  (this.additional_name                );
			if ( this.additional_phone          != null   ) row["additional_phone"        ] = Sql.ToDBString  (this.additional_phone               );
			if ( this.phone                     != null   ) row["phone"                   ] = Sql.ToDBString  (this.phone                          );
			if ( this.phone_type                .HasValue ) row["phone_type"              ] = Sql.ToDBInteger (this.phone_type               .Value);
			if ( this.phone_label               != null   ) row["phone_label"             ] = Sql.ToDBString  (this.phone_label                    );
			if ( this.address1                  != null   ) row["address1"                ] = Sql.ToDBString  (this.address1                       );
			if ( this.address2                  != null   ) row["address2"                ] = Sql.ToDBString  (this.address2                       );
			if ( this.city                      != null   ) row["city"                    ] = Sql.ToDBString  (this.city                           );
			if ( this.state                     != null   ) row["state"                   ] = Sql.ToDBString  (this.state                          );
			if ( this.state_other               != null   ) row["state_other"             ] = Sql.ToDBString  (this.state_other                    );
			if ( this.zip                       != null   ) row["zip"                     ] = Sql.ToDBString  (this.zip                            );
			if ( this.country                   != null   ) row["country"                 ] = Sql.ToDBString  (this.country                        );
			if ( this.ad_code                   != null   ) row["ad_code"                 ] = Sql.ToDBString  (this.ad_code                        );
			if ( this.notes                     != null   ) row["notes"                   ] = Sql.ToDBString  (this.notes                          );
			if ( this.viewed                    != null   ) row["viewed"                  ] = Sql.ToDBString  (this.viewed                         );
			if ( this.category_id               != null   ) row["category_id"             ] = Sql.ToDBString  (this.category_id                    );
			if ( this.tags                      != null   ) row["tags"                    ] = Sql.ToDBString  (this.tags                           );
			if ( this.q_and_a                   != null   ) row["q_and_a"                 ] = Sql.ToDBString  (this.q_and_a                        );
			if ( this.custom_fields             != null   ) row["custom_fields"           ] = Sql.ToDBString  (this.custom_fields                  );
			if ( this.social_accounts           != null   ) row["social_accounts"         ] = Sql.ToDBString  (this.social_accounts                );
			if ( this.token                     != null   ) row["token"                   ] = Sql.ToDBString  (this.token                          );
			if ( this.return_lead_token         != null   ) row["return_lead_token"       ] = Sql.ToDBString  (this.return_lead_token              );
			if ( this.lead_id                   != null   ) row["lead_id"                 ] = Sql.ToDBString  (this.lead_id                        );
			if ( this.order_number              != null   ) row["order_number"            ] = Sql.ToDBString  (this.order_number                   );
			if ( this.lead_vendor_product_name  != null   ) row["lead_vendor_product_name"] = Sql.ToDBString  (this.lead_vendor_product_name       );
			if ( this.allow_duplicates          != null   ) row["allow_duplicates"        ] = Sql.ToDBString  (this.allow_duplicates               );
			if ( this.rating                    != null   ) row["rating"                  ] = Sql.ToDBString  (this.rating                         );
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
		public IList<Contact> items         { get; set; }
		public int            total_results { get; set; }
		public int            total_pages   { get; set; }
		public int            page          { get; set; }
	}
}
