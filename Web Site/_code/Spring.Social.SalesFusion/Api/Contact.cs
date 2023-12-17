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
	// https://pub.salesfusion360.com/api/contacts/
	[Serializable]
	public class Contact : HBase
	{
		#region Properties
		public int?       contact_id                    { get { return id; }  set { id = value; } }
		public String     contact                       { get; set; }
		public String     crm_type                      { get; set; }
		public String     salutation                    { get; set; }  // 10
		public String     first_name                    { get; set; }  // 40
		public String     last_name                     { get; set; }  // 40
		public String     phone                         { get; set; }  // 40
		public String     mobile                        { get; set; }  // 40
		public String     fax                           { get; set; }  // 40
		public String     home_phone                    { get; set; }  // 40
		public String     other_phone                   { get; set; }  // 40
		public String     email                         { get; set; }  // 250
		public int?       account_id                    { get; set; }
		public String     account_name                  { get; set; }
		public String     account                       { get; set; }
		public String     billing_street                { get; set; }  // 80
		public String     billing_city                  { get; set; }  // 40
		public String     billing_state                 { get; set; }  // 20
		public String     billing_zip                   { get; set; }  // 20
		public String     billing_country               { get; set; }  // 40
		public String     mailing_street                { get; set; }  // 80
		public String     mailing_city                  { get; set; }  // 40
		public String     mailing_state                 { get; set; }  // 20
		public String     mailing_zip                   { get; set; }  // 20
		public String     mailing_country               { get; set; }  // 40
		public String     street                        { get; set; }  // 255
		public String     city                          { get; set; }  // 40
		public String     state                         { get; set; }  // 20
		public String     postal_code                   { get; set; }  // 20
		public String     country                       { get; set; }  // 40
		public String     area                          { get; set; }  // 50
		public String     region                        { get; set; }  // 50
		public String     district                      { get; set; }  // 50
		public String     status                        { get; set; }  // 40
		public String     industry                      { get; set; }  // 40
		public String     source                        { get; set; }  // 250
		public String     lead_source_id                { get; set; }  // 50
		public String     gender                        { get; set; }  // 50
		public DateTime?  birth_date                    { get; set; }
		public String     salary                        { get; set; }  // 20
		public String     company                       { get; set; }  // 255
		public String     title                         { get; set; }  // 80
		public String     department                    { get; set; }  // 80
		public String     website                       { get; set; }  // 255
		public String     currency_iso_code             { get; set; }  // 40
		public String     purlid                        { get; set; }  // 100
		public String     rating                        { get; set; }  // 40
		public String     assistant_name                { get; set; }  // 40
		public String     assistant_phone               { get; set; }  // 40
		public String     owner_email                   { get; set; }  // 150
		public String     description                   { get; set; }  // 450
		public String     short_description             { get; set; }  // 100
		public String     do_not_call                   { get; set; }  // 20
		public String     opt_out                       { get; set; }
		public DateTime?  opt_out_date                  { get; set; }
		public String     last_modified_by_id           { get; set; }  // 18
		public String     last_modified_date            { get; set; }  // 20
		public String     last_activity_date            { get; set; }  // 20

		public String     custom_score_field            { get; set; }
		public int?       deliverability_status         { get; set; }
		public String     deliverability_message        { get; set; }
		public DateTime?  delivered_date                { get; set; }
		//public object     custom_fields                 { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			AddBaseColumns(dt);

			dt.Columns.Add("contact_id"                   , Type.GetType("System.Int32"   ));
			dt.Columns.Add("contact"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("crm_type"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("salutation"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("first_name"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("last_name"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("mobile"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("fax"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("home_phone"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("other_phone"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("email"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("account_id"                   , Type.GetType("System.Int32"   ));
			dt.Columns.Add("account_name"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("account"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_street"               , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_city"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_state"                , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_zip"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_country"              , Type.GetType("System.String"  ));
			dt.Columns.Add("mailing_street"               , Type.GetType("System.String"  ));
			dt.Columns.Add("mailing_city"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("mailing_state"                , Type.GetType("System.String"  ));
			dt.Columns.Add("mailing_zip"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("mailing_country"              , Type.GetType("System.String"  ));
			dt.Columns.Add("street"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("city"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("state"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("postal_code"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("country"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("area"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("region"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("district"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("status"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("industry"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("source"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("lead_source_id"               , Type.GetType("System.String"  ));
			dt.Columns.Add("gender"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("birth_date"                   , Type.GetType("System.DateTime"));
			dt.Columns.Add("salary"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("company"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("title"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("department"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("website"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("currency_iso_code"            , Type.GetType("System.String"  ));
			dt.Columns.Add("purlid"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("rating"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("assistant_name"               , Type.GetType("System.String"  ));
			dt.Columns.Add("assistant_phone"              , Type.GetType("System.String"  ));
			dt.Columns.Add("owner_email"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("description"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("short_description"            , Type.GetType("System.String"  ));
			dt.Columns.Add("do_not_call"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("opt_out"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("opt_out_date"                 , Type.GetType("System.DateTime"));
			dt.Columns.Add("last_modified_by_id"          , Type.GetType("System.String"  ));
			dt.Columns.Add("last_modified_date"           , Type.GetType("System.String"  ));
			dt.Columns.Add("last_activity_date"           , Type.GetType("System.String"  ));

			dt.Columns.Add("custom_score_field"           , Type.GetType("System.String"  ));
			dt.Columns.Add("deliverability_status"        , Type.GetType("System.Int32"   ));
			dt.Columns.Add("deliverability_message"       , Type.GetType("System.String"  ));
			dt.Columns.Add("delivered_date"               , Type.GetType("System.DateTime"));
			//dt.Columns.Add("custom_fields"                , Type.GetType("System.object"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			SetBaseColumns(row);

			if ( this.contact_id                   .HasValue ) row["contact_id"                   ] = Sql.ToDBInteger (this.contact_id                   .Value);
			if ( this.contact                      != null   ) row["contact"                      ] = Sql.ToDBString  (this.contact                            );
			if ( this.crm_type                     != null   ) row["crm_type"                     ] = Sql.ToDBString  (this.crm_type                           );
			if ( this.salutation                   != null   ) row["salutation"                   ] = Sql.ToDBString  (this.salutation                         );
			if ( this.first_name                   != null   ) row["first_name"                   ] = Sql.ToDBString  (this.first_name                         );
			if ( this.last_name                    != null   ) row["last_name"                    ] = Sql.ToDBString  (this.last_name                          );
			if ( this.phone                        != null   ) row["phone"                        ] = Sql.ToDBString  (this.phone                              );
			if ( this.mobile                       != null   ) row["mobile"                       ] = Sql.ToDBString  (this.mobile                             );
			if ( this.fax                          != null   ) row["fax"                          ] = Sql.ToDBString  (this.fax                                );
			if ( this.home_phone                   != null   ) row["home_phone"                   ] = Sql.ToDBString  (this.home_phone                         );
			if ( this.other_phone                  != null   ) row["other_phone"                  ] = Sql.ToDBString  (this.other_phone                        );
			if ( this.email                        != null   ) row["email"                        ] = Sql.ToDBString  (this.email                              );
			if ( this.account_id                   .HasValue ) row["account_id"                   ] = Sql.ToDBInteger (this.account_id                   .Value);
			if ( this.account_name                 != null   ) row["account_name"                 ] = Sql.ToDBString  (this.account_name                       );
			if ( this.account                      != null   ) row["account"                      ] = Sql.ToDBString  (this.account                            );
			if ( this.billing_street               != null   ) row["billing_street"               ] = Sql.ToDBString  (this.billing_street                     );
			if ( this.billing_city                 != null   ) row["billing_city"                 ] = Sql.ToDBString  (this.billing_city                       );
			if ( this.billing_state                != null   ) row["billing_state"                ] = Sql.ToDBString  (this.billing_state                      );
			if ( this.billing_zip                  != null   ) row["billing_zip"                  ] = Sql.ToDBString  (this.billing_zip                        );
			if ( this.billing_country              != null   ) row["billing_country"              ] = Sql.ToDBString  (this.billing_country                    );
			if ( this.mailing_street               != null   ) row["mailing_street"               ] = Sql.ToDBString  (this.mailing_street                     );
			if ( this.mailing_city                 != null   ) row["mailing_city"                 ] = Sql.ToDBString  (this.mailing_city                       );
			if ( this.mailing_state                != null   ) row["mailing_state"                ] = Sql.ToDBString  (this.mailing_state                      );
			if ( this.mailing_zip                  != null   ) row["mailing_zip"                  ] = Sql.ToDBString  (this.mailing_zip                        );
			if ( this.mailing_country              != null   ) row["mailing_country"              ] = Sql.ToDBString  (this.mailing_country                    );
			if ( this.street                       != null   ) row["street"                       ] = Sql.ToDBString  (this.street                             );
			if ( this.city                         != null   ) row["city"                         ] = Sql.ToDBString  (this.city                               );
			if ( this.state                        != null   ) row["state"                        ] = Sql.ToDBString  (this.state                              );
			if ( this.postal_code                  != null   ) row["postal_code"                  ] = Sql.ToDBString  (this.postal_code                        );
			if ( this.country                      != null   ) row["country"                      ] = Sql.ToDBString  (this.country                            );
			if ( this.area                         != null   ) row["area"                         ] = Sql.ToDBString  (this.area                               );
			if ( this.region                       != null   ) row["region"                       ] = Sql.ToDBString  (this.region                             );
			if ( this.district                     != null   ) row["district"                     ] = Sql.ToDBString  (this.district                           );
			if ( this.status                       != null   ) row["status"                       ] = Sql.ToDBString  (this.status                             );
			if ( this.industry                     != null   ) row["industry"                     ] = Sql.ToDBString  (this.industry                           );
			if ( this.source                       != null   ) row["source"                       ] = Sql.ToDBString  (this.source                             );
			if ( this.lead_source_id               != null   ) row["lead_source_id"               ] = Sql.ToDBString  (this.lead_source_id                     );
			if ( this.gender                       != null   ) row["gender"                       ] = Sql.ToDBString  (this.gender                             );
			if ( this.birth_date                   .HasValue ) row["birth_date"                   ] = Sql.ToDBDateTime(this.birth_date                   .Value);
			if ( this.salary                       != null   ) row["salary"                       ] = Sql.ToDBString  (this.salary                             );
			if ( this.company                      != null   ) row["company"                      ] = Sql.ToDBString  (this.company                            );
			if ( this.title                        != null   ) row["title"                        ] = Sql.ToDBString  (this.title                              );
			if ( this.department                   != null   ) row["department"                   ] = Sql.ToDBString  (this.department                         );
			if ( this.website                      != null   ) row["website"                      ] = Sql.ToDBString  (this.website                            );
			if ( this.currency_iso_code            != null   ) row["currency_iso_code"            ] = Sql.ToDBString  (this.currency_iso_code                  );
			if ( this.purlid                       != null   ) row["purlid"                       ] = Sql.ToDBString  (this.purlid                             );
			if ( this.rating                       != null   ) row["rating"                       ] = Sql.ToDBString  (this.rating                             );
			if ( this.assistant_name               != null   ) row["assistant_name"               ] = Sql.ToDBString  (this.assistant_name                     );
			if ( this.assistant_phone              != null   ) row["assistant_phone"              ] = Sql.ToDBString  (this.assistant_phone                    );
			if ( this.owner_email                  != null   ) row["owner_email"                  ] = Sql.ToDBString  (this.owner_email                        );
			if ( this.description                  != null   ) row["description"                  ] = Sql.ToDBString  (this.description                        );
			if ( this.short_description            != null   ) row["short_description"            ] = Sql.ToDBString  (this.short_description                  );
			if ( this.do_not_call                  != null   ) row["do_not_call"                  ] = Sql.ToDBString  (this.do_not_call                        );
			if ( this.opt_out                      != null   ) row["opt_out"                      ] = Sql.ToDBString  (this.opt_out                            );
			if ( this.opt_out_date                 .HasValue ) row["opt_out_date"                 ] = Sql.ToDBDateTime(this.opt_out_date                 .Value);
			if ( this.last_modified_by_id          != null   ) row["last_modified_by_id"          ] = Sql.ToDBString  (this.last_modified_by_id                );
			if ( this.last_modified_date           != null   ) row["last_modified_date"           ] = Sql.ToDBString  (this.last_modified_date                 );
			if ( this.last_activity_date           != null   ) row["last_activity_date"           ] = Sql.ToDBString  (this.last_activity_date                 );

			if ( this.custom_score_field           != null   ) row["custom_score_field"           ] = Sql.ToDBString  (this.custom_score_field                 );
			if ( this.deliverability_status        .HasValue ) row["deliverability_status"        ] = Sql.ToDBInteger (this.deliverability_status        .Value);
			if ( this.deliverability_message       != null   ) row["deliverability_message"       ] = Sql.ToDBString  (this.deliverability_message             );
			if ( this.delivered_date               .HasValue ) row["delivered_date"               ] = Sql.ToDBDateTime(this.delivered_date               .Value);
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

	public class ContactPagination : HPagination
	{
		public IList<Contact> results     { get; set; }
	}
}
