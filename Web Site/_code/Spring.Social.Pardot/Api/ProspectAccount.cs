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

namespace Spring.Social.Pardot.Api
{
	[Serializable]
	public class ProspectAccount
	{
		// http://developer.pardot.com/kb/object-field-references/#prospectAccount
		#region Properties
		public String   RawContent             { get; set; }
		public int      id                     { get; set; }  // Pardot ID
		public DateTime? created_at             { get; set; }  // Time account was created in Pardot. 
		public DateTime? updated_at             { get; set; }  // Last time prospect was updated in Pardot; Time is reported in API 
		public String   name                   { get; set; }
		public int?     number                 { get; set; }
		public String   description            { get; set; }
		public String   phone                  { get; set; }
		public String   fax                    { get; set; }
		public String   website                { get; set; }
		public String   rating                 { get; set; }
		public String   site                   { get; set; }
		public String   type                   { get; set; }
		public int?     annual_revenue         { get; set; }
		public String   industry               { get; set; }
		public String   sic                    { get; set; }
		public int?     employees              { get; set; }
		public String   ownership              { get; set; }
		public String   ticker_symbol          { get; set; }
		public String   billing_address_one    { get; set; }
		public String   billing_address_two    { get; set; }
		public String   billing_city           { get; set; }
		public String   billing_state          { get; set; }
		public String   billing_zip            { get; set; }
		public String   billing_country        { get; set; }
		public String   shipping_address_one   { get; set; }
		public String   shipping_address_two   { get; set; }
		public String   shipping_city          { get; set; }
		public String   shipping_state         { get; set; }
		public String   shipping_zip           { get; set; }
		public String   shipping_country       { get; set; }
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("id"                    , Type.GetType("System.Int64"   ));
			dt.Columns.Add("created_at"            , Type.GetType("System.DateTime"));
			dt.Columns.Add("updated_at"            , Type.GetType("System.DateTime"));
			dt.Columns.Add("name"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("number"                , Type.GetType("System.Int64"   ));
			dt.Columns.Add("description"           , Type.GetType("System.String"  ));
			dt.Columns.Add("phone"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("fax"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("website"               , Type.GetType("System.String"  ));
			dt.Columns.Add("rating"                , Type.GetType("System.String"  ));
			dt.Columns.Add("site"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("type"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("annual_revenue"        , Type.GetType("System.Int64"   ));
			dt.Columns.Add("industry"              , Type.GetType("System.String"  ));
			dt.Columns.Add("sic"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("employees"             , Type.GetType("System.Int64"   ));
			dt.Columns.Add("ownership"             , Type.GetType("System.String"  ));
			dt.Columns.Add("ticker_symbol"         , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_address_one"   , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_address_two"   , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_city"          , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_state"         , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_zip"           , Type.GetType("System.String"  ));
			dt.Columns.Add("billing_country"       , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_address_one"  , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_address_two"  , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_city"         , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_state"        , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_zip"          , Type.GetType("System.String"  ));
			dt.Columns.Add("shipping_country"      , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.id                     != 0      ) row["id"                  ] = Sql.ToDBString  (this.id                          );
			if ( this.created_at             .HasValue ) row["created_at"          ] = Sql.ToDBDateTime(this.created_at                  );
			if ( this.updated_at             .HasValue ) row["updated_at"          ] = Sql.ToDBDateTime(this.updated_at                  );
			if ( this.name                   != null   ) row["name"                ] = Sql.ToDBString  (this.name                        );
			if ( this.number                 .HasValue ) row["number"              ] = Sql.ToDBInteger (this.number                .Value);
			if ( this.description            != null   ) row["description"         ] = Sql.ToDBString  (this.description                 );
			if ( this.phone                  != null   ) row["phone"               ] = Sql.ToDBString  (this.phone                       );
			if ( this.fax                    != null   ) row["fax"                 ] = Sql.ToDBString  (this.fax                         );
			if ( this.website                != null   ) row["website"             ] = Sql.ToDBString  (this.website                     );
			if ( this.rating                 != null   ) row["rating"              ] = Sql.ToDBString  (this.rating                      );
			if ( this.site                   != null   ) row["site"                ] = Sql.ToDBString  (this.site                        );
			if ( this.type                   != null   ) row["type"                ] = Sql.ToDBString  (this.type                        );
			if ( this.annual_revenue         .HasValue ) row["annual_revenue"      ] = Sql.ToDBInteger (this.annual_revenue        .Value);
			if ( this.industry               != null   ) row["industry"            ] = Sql.ToDBString  (this.industry                    );
			if ( this.sic                    != null   ) row["sic"                 ] = Sql.ToDBString  (this.sic                         );
			if ( this.employees              .HasValue ) row["employees"           ] = Sql.ToDBInteger (this.employees             .Value);
			if ( this.ownership              != null   ) row["ownership"           ] = Sql.ToDBString  (this.ownership                   );
			if ( this.ticker_symbol          != null   ) row["ticker_symbol"       ] = Sql.ToDBString  (this.ticker_symbol               );
			if ( this.billing_address_one    != null   ) row["billing_address_one" ] = Sql.ToDBString  (this.billing_address_one         );
			if ( this.billing_address_two    != null   ) row["billing_address_two" ] = Sql.ToDBString  (this.billing_address_two         );
			if ( this.billing_city           != null   ) row["billing_city"        ] = Sql.ToDBString  (this.billing_city                );
			if ( this.billing_state          != null   ) row["billing_state"       ] = Sql.ToDBString  (this.billing_state               );
			if ( this.billing_zip            != null   ) row["billing_zip"         ] = Sql.ToDBString  (this.billing_zip                 );
			if ( this.billing_country        != null   ) row["billing_country"     ] = Sql.ToDBString  (this.billing_country             );
			if ( this.shipping_address_one   != null   ) row["shipping_address_one"] = Sql.ToDBString  (this.shipping_address_one        );
			if ( this.shipping_address_two   != null   ) row["shipping_address_two"] = Sql.ToDBString  (this.shipping_address_two        );
			if ( this.shipping_city          != null   ) row["shipping_city"       ] = Sql.ToDBString  (this.shipping_city               );
			if ( this.shipping_state         != null   ) row["shipping_state"      ] = Sql.ToDBString  (this.shipping_state              );
			if ( this.shipping_zip           != null   ) row["shipping_zip"        ] = Sql.ToDBString  (this.shipping_zip                );
			if ( this.shipping_country       != null   ) row["shipping_country"    ] = Sql.ToDBString  (this.shipping_country            );
		}

		public static DataRow ConvertToRow(ProspectAccount obj)
		{
			DataTable dt = ProspectAccount.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<ProspectAccount> accounts)
		{
			DataTable dt = ProspectAccount.CreateTable();
			if ( accounts != null )
			{
				foreach ( ProspectAccount account in accounts )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					account.SetRow(row);
				}
			}
			return dt;
		}
	}

	public class ProspectAccountPagination
	{
		public IList<ProspectAccount>  items      { get; set; }
		public int                     total      { get; set; }
	}
}
