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
	// https://pub.salesfusion360.com/api/accounts/
	[Serializable]
	public class Account : HBase
	{
		#region Properties
		public int?       account_id                    { get { return id; }  set { id = value; } }
		public String     account_name                  { get; set; }  // 255
		public String     account                       { get; set; }
		public String     account_number                { get; set; }  // 255
		public String     phone                         { get; set; }  // 255
		public String     fax                           { get; set; }  // 255
		public String     billing_street                { get; set; }  // 255
		public String     billing_city                  { get; set; }  // 255
		public String     billing_state                 { get; set; }  // 255
		public String     billing_zip                   { get; set; }  // 10
		public String     billing_country               { get; set; }  // 255
		public String     shipping_street               { get; set; }  // 255
		public String     shipping_city                 { get; set; }  // 255
		public String     shipping_state                { get; set; }  // 255
		public String     shipping_zip                  { get; set; }  // 10
		public String     shipping_country              { get; set; }  // 255
		public String     contacts                      { get; set; }
		public String     custom_score_field            { get; set; }
		public String     industry                      { get; set; }  // 80
		public String     type                          { get; set; }  // 40
		public Boolean?   key_account                   { get; set; }
		public int?       account_score                 { get; set; }
		public String     sic                           { get; set; }  // 255
		public String     rating                        { get; set; }  // 40
		public String     description                   { get; set; }  // 255
		public String     url                           { get; set; }  // 255
		public String     currency_iso_code             { get; set; }  // 255
		public DateTime?  salesfusion_last_activity     { get; set; }
		public String     short_description             { get; set; }  // 255
		public String     campaign_id                   { get; set; }  // 255
		//public object     custom_fields                 { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			AddBaseColumns(dt);

			dt.Columns.Add("account_id"                   , Type.GetType("System.Int32"   ));
			dt.Columns.Add("account_name"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("account"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("account_number"               , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("fax"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_street"               , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_city"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_state"                , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_zip"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_country"              , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_street"              , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_city"                , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_state"               , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_zip"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_country"             , Type.GetType("System.String"  ));
			dt.Columns.Add("contacts"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("custom_score_field"           , Type.GetType("System.String"  ));
			dt.Columns.Add("industry"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("type"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("key_account"                  , Type.GetType("System.Boolean" ));
			dt.Columns.Add("account_score"                , Type.GetType("System.Int32"   ));
			dt.Columns.Add("sic"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("rating"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("description"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("url"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("currency_iso_code"            , Type.GetType("System.String"  ));
			dt.Columns.Add("salesfusion_last_activity"    , Type.GetType("System.DateTime"));
			dt.Columns.Add("short_description"            , Type.GetType("System.String"  ));
			dt.Columns.Add("campaign_id"                  , Type.GetType("System.String"  ));
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

			if ( this.account_id                   .HasValue ) row["account_id"                   ] = Sql.ToDBInteger (this.account_id                   .Value);
			if ( this.account_name                 != null   ) row["account_name"                 ] = Sql.ToDBString  (this.account_name                       );
			if ( this.account                      != null   ) row["account"                      ] = Sql.ToDBString  (this.account                            );
			if ( this.account_number               != null   ) row["account_number"               ] = Sql.ToDBString  (this.account_number                     );
			if ( this.phone                        != null   ) row["phone"                        ] = Sql.ToDBString  (this.phone                              );
			if ( this.fax                          != null   ) row["fax"                          ] = Sql.ToDBString  (this.fax                                );
			if ( this.billing_street               != null   ) row["billing_street"               ] = Sql.ToDBString  (this.billing_street                     );
			if ( this.billing_city                 != null   ) row["billing_city"                 ] = Sql.ToDBString  (this.billing_city                       );
			if ( this.billing_state                != null   ) row["billing_state"                ] = Sql.ToDBString  (this.billing_state                      );
			if ( this.billing_zip                  != null   ) row["billing_zip"                  ] = Sql.ToDBString  (this.billing_zip                        );
			if ( this.billing_country              != null   ) row["billing_country"              ] = Sql.ToDBString  (this.billing_country                    );
			if ( this.shipping_street              != null   ) row["shipping_street"              ] = Sql.ToDBString  (this.shipping_street                    );
			if ( this.shipping_city                != null   ) row["shipping_city"                ] = Sql.ToDBString  (this.shipping_city                      );
			if ( this.shipping_state               != null   ) row["shipping_state"               ] = Sql.ToDBString  (this.shipping_state                     );
			if ( this.shipping_zip                 != null   ) row["shipping_zip"                 ] = Sql.ToDBString  (this.shipping_zip                       );
			if ( this.shipping_country             != null   ) row["shipping_country"             ] = Sql.ToDBString  (this.shipping_country                   );
			if ( this.contacts                     != null   ) row["contacts"                     ] = Sql.ToDBString  (this.contacts                           );
			if ( this.custom_score_field           != null   ) row["custom_score_field"           ] = Sql.ToDBString  (this.custom_score_field                 );
			if ( this.industry                     != null   ) row["industry"                     ] = Sql.ToDBString  (this.industry                           );
			if ( this.type                         != null   ) row["type"                         ] = Sql.ToDBString  (this.type                               );
			if ( this.key_account                  .HasValue ) row["key_account"                  ] = Sql.ToDBBoolean (this.key_account                  .Value);
			if ( this.account_score                .HasValue ) row["account_score"                ] = Sql.ToDBInteger (this.account_score                .Value);
			if ( this.sic                          != null   ) row["sic"                          ] = Sql.ToDBString  (this.sic                                );
			if ( this.rating                       != null   ) row["rating"                       ] = Sql.ToDBString  (this.rating                             );
			if ( this.description                  != null   ) row["description"                  ] = Sql.ToDBString  (this.description                        );
			if ( this.url                          != null   ) row["url"                          ] = Sql.ToDBString  (this.url                                );
			if ( this.currency_iso_code            != null   ) row["currency_iso_code"            ] = Sql.ToDBString  (this.currency_iso_code                  );
			if ( this.salesfusion_last_activity    .HasValue ) row["salesfusion_last_activity"    ] = Sql.ToDBDateTime(this.salesfusion_last_activity    .Value);
			if ( this.short_description            != null   ) row["short_description"            ] = Sql.ToDBString  (this.short_description                  );
			if ( this.campaign_id                  != null   ) row["campaign_id"                  ] = Sql.ToDBString  (this.campaign_id                        );
		}

		public static DataRow ConvertToRow(Account obj)
		{
			DataTable dt = Account.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Account> accounts)
		{
			DataTable dt = Account.CreateTable();
			if ( accounts != null )
			{
				foreach ( Account account in accounts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					account.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class AccountPagination : HPagination
	{
		public IList<Account> results     { get; set; }
	}
}
