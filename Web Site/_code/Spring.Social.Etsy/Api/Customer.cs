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

namespace Spring.Social.Etsy.Api
{
	[Serializable]
	public class Customer : QBase
	{
		#region Properties
		public String                 firstName               { get; set; }
		public String                 lastName                { get; set; }
		public String                 displayName             { get; set; }
		public String                 email                   { get; set; }
		public String                 phone                   { get; set; }
		public String                 locale                  { get; set; }
		public String                 note                    { get; set; }
		public bool                   taxExempt               { get; set; }
		public bool                   validEmailAddress       { get; set; }
		public bool                   verifiedEmail           { get; set; }
		public CustomerStateEnum      state                   { get; set; }
		public Image                  image                   { get; set; }
		public IList<String>          tags                    { get; set; }
		public MailingAddress         defaultAddress          { get; set; }
		public IList<MailingAddress>  addresses               { get; set; }
		public IList<Order>           orders                  { get; set; }
		//public IList<SubscriptionContract>    subscriptionContracts   { get; set; }

		public override string ToString()
		{
			StringBuilder sb = new StringBuilder();
			sb.AppendLine("Customer");
			sb.AppendLine("   id               : " +  this.id               );
			sb.AppendLine("   cursor           : " +  this.cursor           );
			sb.AppendLine("   createdAt        : " + (this.createdAt        .HasValue ? this.createdAt  .Value.ToString() : String.Empty));
			sb.AppendLine("   updatedAt        : " + (this.updatedAt        .HasValue ? this.updatedAt  .Value.ToString() : String.Empty));
			sb.AppendLine("   firstName        : " +  this.firstName        );
			sb.AppendLine("   lastName         : " +  this.lastName         );
			sb.AppendLine("   displayName      : " +  this.displayName      );
			sb.AppendLine("   email            : " +  this.email            );
			sb.AppendLine("   phone            : " +  this.phone            );
			sb.AppendLine("   locale           : " +  this.locale           );
			sb.AppendLine("   note             : " +  this.note             );
			sb.AppendLine("   taxExempt        : " +  this.taxExempt        .ToString());
			sb.AppendLine("   validEmailAddress: " +  this.validEmailAddress.ToString());
			sb.AppendLine("   verifiedEmail    : " +  this.verifiedEmail    .ToString());
			sb.AppendLine("   state            : " +  this.state            .ToString());
			sb.AppendLine("   image            : " + (this.image            != null ? this.image         .ToString() : "null"));
			sb.AppendLine("   tags             : " + (this.tags             != null ? this.tags          .ToString() : "null"));
			sb.AppendLine("   defaultAddress   : " + (this.defaultAddress   != null ? this.defaultAddress.ToString() : "null"));
			sb.AppendLine("   addresses        : " + (this.addresses        != null ? this.addresses     .ToString() : "null"));
			sb.AppendLine("   tags             : " + (this.tags             != null ? this.tags          .ToString() : "null"));
			sb.AppendLine("   orders           : " + (this.orders           != null ? this.orders        .ToString() : "null"));
			return sb.ToString();
		}

		public void SetBillAddr(string sBillingStreet , string sBillingCity , string sBillingState , string sBillingPostalCode , string sBillingCountry)
		{
			/*
			if ( !Sql.IsEmptyString(sBillingStreet) || !Sql.IsEmptyString(sBillingCity) || !Sql.IsEmptyString(sBillingState) || !Sql.IsEmptyString(sBillingPostalCode) || !Sql.IsEmptyString(sBillingCountry) )
				this.BillAddr = new MailingAddress(sBillingStreet , sBillingCity , sBillingState , sBillingPostalCode , sBillingCountry);
			else
				this.BillAddr = null;
			*/
		}

		public void SetShipAddr(string sShippingStreet, string sShippingCity, string sShippingState, string sShippingPostalCode, string sShippingCountry)
		{
			/*
			if ( !Sql.IsEmptyString(sShippingStreet) || !Sql.IsEmptyString(sShippingCity) || !Sql.IsEmptyString(sShippingState) || !Sql.IsEmptyString(sShippingPostalCode) || !Sql.IsEmptyString(sShippingCountry) )
				this.ShipAddr = new MailingAddress(sShippingStreet, sShippingCity, sShippingState, sShippingPostalCode, sShippingCountry);
			else
				this.ShipAddr = null;
			*/
		}
		#endregion

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"                           , Type.GetType("System.Int64"   ));
			dt.Columns.Add("SyncToken"                    , Type.GetType("System.Int64"   ));
			dt.Columns.Add("TimeCreated"                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("TimeModified"                 , Type.GetType("System.DateTime"));
			dt.Columns.Add("Title"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("FirstName"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("MiddleName"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("LastName"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("Suffix"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("Name"                         , Type.GetType("System.String"  ));
			dt.Columns.Add("CompanyName"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("DisplayName"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("PrintOnCheckName"             , Type.GetType("System.String"  ));
			dt.Columns.Add("Active"                       , Type.GetType("System.Boolean" ));
			dt.Columns.Add("PrimaryPhone"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("AlternatePhone"               , Type.GetType("System.String"  ));
			dt.Columns.Add("Mobile"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("Fax"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("PrimaryEmailAddr"             , Type.GetType("System.String"  ));
			dt.Columns.Add("WebAddr"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("DefaultTaxCode"               , Type.GetType("System.String"  ));
			dt.Columns.Add("Taxable"                      , Type.GetType("System.Boolean" ));
			dt.Columns.Add("Notes"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("Job"                          , Type.GetType("System.Boolean" ));
			dt.Columns.Add("BillWithParent"               , Type.GetType("System.Boolean" ));
			dt.Columns.Add("Parent"                       , Type.GetType("System.String"  ));
			dt.Columns.Add("Level"                        , Type.GetType("System.Int64"   ));
			dt.Columns.Add("SalesTerm"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("PaymentMethod"                , Type.GetType("System.String"  ));
			dt.Columns.Add("Balance"                      , Type.GetType("System.Decimal" ));
			dt.Columns.Add("OpenBalanceDate"              , Type.GetType("System.DateTime"));
			dt.Columns.Add("BalanceWithJobs"              , Type.GetType("System.Decimal" ));
			dt.Columns.Add("Currency"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("PreferredDeliveryMethod"      , Type.GetType("System.String"  ));
			dt.Columns.Add("ResaleNum"                    , Type.GetType("System.String"  ));

			dt.Columns.Add("BillingStreet"                , Type.GetType("System.String"  ));
			dt.Columns.Add("BillingLine1"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("BillingLine2"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("BillingLine3"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("BillingLine4"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("BillingLine5"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("BillingCity"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("BillingState"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("BillingCountry"               , Type.GetType("System.String"  ));
			dt.Columns.Add("BillingPostalCode"            , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingStreet"               , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingLine1"                , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingLine2"                , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingLine3"                , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingLine4"                , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingLine5"                , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingCity"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingState"                , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingCountry"              , Type.GetType("System.String"  ));
			dt.Columns.Add("ShippingPostalCode"           , Type.GetType("System.String"  ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			/*
			if ( this.Id                      != null   ) row["Id"                     ] = Sql.ToDBString  (this.Id                                    );
			if ( this.Title                   != null   ) row["Title"                  ] = Sql.ToDBString  (this.Title                                 );
			if ( this.GivenName               != null   ) row["FirstName"              ] = Sql.ToDBString  (this.GivenName                             );
			if ( this.MiddleName              != null   ) row["MiddleName"             ] = Sql.ToDBString  (this.MiddleName                            );
			if ( this.FamilyName              != null   ) row["LastName"               ] = Sql.ToDBString  (this.FamilyName                            );
			if ( this.Suffix                  != null   ) row["Suffix"                 ] = Sql.ToDBString  (this.Suffix                                );
			if ( this.FullyQualifiedName      != null   ) row["Name"                   ] = Sql.ToDBString  (this.FullyQualifiedName                    );
			if ( this.CompanyName             != null   ) row["CompanyName"            ] = Sql.ToDBString  (this.CompanyName                           );
			if ( this.DisplayName             != null   ) row["DisplayName"            ] = Sql.ToDBString  (this.DisplayName                           );
			if ( this.PrintOnCheckName        != null   ) row["PrintOnCheckName"       ] = Sql.ToDBString  (this.PrintOnCheckName                      );
			if ( this.Active                  .HasValue ) row["Active"                 ] = Sql.ToDBBoolean (this.Active                 .Value         );
			if ( this.PrimaryPhone            != null   ) row["PrimaryPhone"           ] = Sql.ToDBString  (this.PrimaryPhone           .FreeFormNumber);
			if ( this.AlternatePhone          != null   ) row["AlternatePhone"         ] = Sql.ToDBString  (this.AlternatePhone         .FreeFormNumber);
			if ( this.Mobile                  != null   ) row["Mobile"                 ] = Sql.ToDBString  (this.Mobile                 .FreeFormNumber);
			if ( this.Fax                     != null   ) row["Fax"                    ] = Sql.ToDBString  (this.Fax                    .FreeFormNumber);
			if ( this.PrimaryEmailAddr        != null   ) row["PrimaryEmailAddr"       ] = Sql.ToDBString  (this.PrimaryEmailAddr       .Address       );
			if ( this.image                   != null   ) row["image"                  ] = Sql.ToDBString  (this.image                  .url           );
			if ( this.DefaultTaxCodeRef       != null   ) row["DefaultTaxCode"         ] = Sql.ToDBString  (this.DefaultTaxCodeRef      .Value         );
			if ( this.Taxable                 != null   ) row["Taxable"                ] = Sql.ToDBBoolean (this.Taxable                .Value         );
			if ( this.Notes                   != null   ) row["Notes"                  ] = Sql.ToDBString  (this.Notes                                 );
			if ( this.Job                     != null   ) row["Job"                    ] = Sql.ToDBBoolean (this.Job                    .Value         );
			if ( this.BillWithParent          != null   ) row["BillWithParent"         ] = Sql.ToDBBoolean (this.BillWithParent         .Value         );
			if ( this.ParentRef               != null   ) row["Parent"                 ] = Sql.ToDBString  (this.ParentRef              .Value         );
			if ( this.Level                   != null   ) row["Level"                  ] = Sql.ToDBInteger (this.Level                  .Value         );
			if ( this.SalesTermRef            != null   ) row["SalesTerm"              ] = Sql.ToDBString  (this.SalesTermRef           .Value         );
			if ( this.PaymentMethodRef        != null   ) row["PaymentMethod"          ] = Sql.ToDBString  (this.PaymentMethodRef       .Value         );
			if ( this.Balance                 != null   ) row["Balance"                ] = Sql.ToDBDecimal (this.Balance                .Value         );
			if ( this.OpenBalanceDate         != null   ) row["OpenBalanceDate"        ] = Sql.ToDBDateTime(this.OpenBalanceDate        .Value         );
			if ( this.BalanceWithJobs         != null   ) row["BalanceWithJobs"        ] = Sql.ToDBDecimal (this.BalanceWithJobs        .Value         );
			if ( this.CurrencyRef             != null   ) row["Currency"               ] = Sql.ToDBString  (this.CurrencyRef            .Value         );
			if ( this.PreferredDeliveryMethod != null   ) row["PreferredDeliveryMethod"] = Sql.ToDBString  (this.PreferredDeliveryMethod               );
			if ( this.ResaleNum               != null   ) row["ResaleNum"              ] = Sql.ToDBString  (this.ResaleNum                             );
			
			if ( this.BillAddr != null )
			{
				StringBuilder sbStreet = new StringBuilder();
				if ( !Sql.IsEmptyString(this.billingAddress.Line1) ) sbStreet.AppendLine(this.billingAddress.Line1);
				if ( !Sql.IsEmptyString(this.billingAddress.Line2) ) sbStreet.AppendLine(this.billingAddress.Line2);
				row["BillingStreet"    ] = Sql.ToString(sbStreet.ToString()         );
				row["BillingAddress1"  ] = Sql.ToString(this.billingAddress.address1);
				row["BillingAddress2"  ] = Sql.ToString(this.billingAddress.address2);
				row["BillingCity"      ] = Sql.ToString(this.billingAddress.city    );
				row["BillingState"     ] = Sql.ToString(this.billingAddress.province);
				row["BillingPostalCode"] = Sql.ToString(this.billingAddress.zip     );
				row["BillingCountry"   ] = Sql.ToString(this.billingAddress.country );
			}
			if ( this.ShipAddr != null )
			{
				StringBuilder sbStreet = new StringBuilder();
				if ( !Sql.IsEmptyString(this.shippingAddress.Line1) ) sbStreet.AppendLine(this.shippingAddress.Line1);
				if ( !Sql.IsEmptyString(this.shippingAddress.Line2) ) sbStreet.AppendLine(this.shippingAddress.Line2);
				row["ShippingStreet"    ] = Sql.ToString(sbStreet.ToString()          );
				row["ShippingAddress1"  ] = Sql.ToString(this.shippingAddress.address1);
				row["ShippingAddress2"  ] = Sql.ToString(this.shippingAddress.address2);
				row["ShippingCity"      ] = Sql.ToString(this.shippingAddress.city    );
				row["ShippingState"     ] = Sql.ToString(this.shippingAddress.province);
				row["ShippingPostalCode"] = Sql.ToString(this.shippingAddress.zip     );
				row["ShippingCountry"   ] = Sql.ToString(this.shippingAddress.country );
			}
			*/
		}

		public static DataRow ConvertToRow(Customer obj)
		{
			DataTable dt = Customer.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Customer> customers)
		{
			DataTable dt = Customer.CreateTable();
			if ( customers != null )
			{
				foreach ( Customer customer in customers )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					customer.SetRow(row);
				}
			}
			return dt;
		}
	}
}
