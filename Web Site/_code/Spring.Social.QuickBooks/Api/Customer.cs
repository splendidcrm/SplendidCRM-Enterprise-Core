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

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/customer
	[Serializable]
	public class Customer : QBase
	{
		#region Properties
		public String                 Title                   { get; set; }
		public String                 GivenName               { get; set; }
		public String                 MiddleName              { get; set; }
		public String                 FamilyName              { get; set; }
		public String                 Suffix                  { get; set; }
		public String                 FullyQualifiedName      { get; set; }
		public String                 CompanyName             { get; set; }
		public String                 DisplayName             { get; set; }
		public String                 PrintOnCheckName        { get; set; }
		public Boolean?               Active                  { get; set; }
		public TelephoneNumber        PrimaryPhone            { get; set; }
		public TelephoneNumber        AlternatePhone          { get; set; }
		public TelephoneNumber        Mobile                  { get; set; }
		public TelephoneNumber        Fax                     { get; set; }
		public EmailAddress           PrimaryEmailAddr        { get; set; }
		public WebSiteAddress         WebAddr                 { get; set; }
		public ReferenceType          DefaultTaxCodeRef       { get; set; }
		public Boolean?               Taxable                 { get; set; }
		public PhysicalAddress        BillAddr                { get; set; }
		public PhysicalAddress        ShipAddr                { get; set; }
		public String                 Notes                   { get; set; }
		public Boolean?               Job                     { get; set; }
		public Boolean?               BillWithParent          { get; set; }
		public ReferenceType          ParentRef               { get; set; }
		public int?                   Level                   { get; set; }
		public ReferenceType          SalesTermRef            { get; set; }
		public ReferenceType          PaymentMethodRef        { get; set; }
		public Decimal?               Balance                 { get; set; }
		public DateTime?              OpenBalanceDate         { get; set; }
		public Decimal?               BalanceWithJobs         { get; set; }
		public ReferenceType          CurrencyRef             { get; set; }
		public String                 PreferredDeliveryMethod { get; set; }
		public String                 ResaleNum               { get; set; }

		public bool ActiveValue
		{
			get
			{
				return this.Active.HasValue ? this.Active.Value : false;
			}
			set
			{
				this.Active = value;
			}
		}

		public string ParentRefValue
		{
			get
			{
				return this.ParentRef == null ? String.Empty : this.ParentRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.ParentRef = new ReferenceType(value);
				else
					this.ParentRef = null;
			}
		}

		public string PrimaryEmailAddrValue
		{
			get
			{
				return this.PrimaryEmailAddr == null ? String.Empty : this.PrimaryEmailAddr.Address;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.PrimaryEmailAddr = new EmailAddress(value);
				else
					this.PrimaryEmailAddr = null;
			}
		}

		public string AlternatePhoneValue
		{
			get
			{
				return this.AlternatePhone == null ? String.Empty : this.AlternatePhone.FreeFormNumber;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.AlternatePhone = new TelephoneNumber(value);
				else
					this.AlternatePhone = null;
			}
		}

		public string FaxValue
		{
			get
			{
				return this.Fax == null ? String.Empty : this.Fax.FreeFormNumber;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.Fax = new TelephoneNumber(value);
				else
					this.Fax = null;
			}
		}

		public string PrimaryPhoneValue
		{
			get
			{
				return this.PrimaryPhone == null ? String.Empty : this.PrimaryPhone.FreeFormNumber;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.PrimaryPhone = new TelephoneNumber(value);
				else
					this.PrimaryPhone = null;
			}
		}

		public void SetBillAddr(string sBillingStreet , string sBillingCity , string sBillingState , string sBillingPostalCode , string sBillingCountry)
		{
			if ( !Sql.IsEmptyString(sBillingStreet) || !Sql.IsEmptyString(sBillingCity) || !Sql.IsEmptyString(sBillingState) || !Sql.IsEmptyString(sBillingPostalCode) || !Sql.IsEmptyString(sBillingCountry) )
				this.BillAddr = new PhysicalAddress(sBillingStreet , sBillingCity , sBillingState , sBillingPostalCode , sBillingCountry);
			else
				this.BillAddr = null;
		}

		public void SetShipAddr(string sShippingStreet, string sShippingCity, string sShippingState, string sShippingPostalCode, string sShippingCountry)
		{
			if ( !Sql.IsEmptyString(sShippingStreet) || !Sql.IsEmptyString(sShippingCity) || !Sql.IsEmptyString(sShippingState) || !Sql.IsEmptyString(sShippingPostalCode) || !Sql.IsEmptyString(sShippingCountry) )
				this.ShipAddr = new PhysicalAddress(sShippingStreet, sShippingCity, sShippingState, sShippingPostalCode, sShippingCountry);
			else
				this.ShipAddr = null;
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
			if ( this.Id                      != null   ) row["Id"                     ] = Sql.ToDBString  (this.Id                                    );
			if ( this.SyncToken               != null   ) row["SyncToken"              ] = Sql.ToDBString  (this.SyncToken                             );
			if ( this.MetaData                != null   ) row["TimeCreated"            ] = Sql.ToDBDateTime(this.MetaData.CreateTime                   );
			if ( this.MetaData                != null   ) row["TimeModified"           ] = Sql.ToDBDateTime(this.MetaData.LastUpdatedTime              );
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
			if ( this.WebAddr                 != null   ) row["WebAddr"                ] = Sql.ToDBString  (this.WebAddr                .URI           );
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
				if ( !Sql.IsEmptyString(this.BillAddr.Line1) ) sbStreet.AppendLine(this.BillAddr.Line1);
				if ( !Sql.IsEmptyString(this.BillAddr.Line2) ) sbStreet.AppendLine(this.BillAddr.Line2);
				if ( !Sql.IsEmptyString(this.BillAddr.Line3) ) sbStreet.AppendLine(this.BillAddr.Line3);
				if ( !Sql.IsEmptyString(this.BillAddr.Line4) ) sbStreet.AppendLine(this.BillAddr.Line4);
				if ( !Sql.IsEmptyString(this.BillAddr.Line5) ) sbStreet.AppendLine(this.BillAddr.Line5);
				row["BillingStreet"    ] = Sql.ToString(sbStreet.ToString()                 );
				row["BillingLine1"     ] = Sql.ToString(this.BillAddr.Line1                 );
				row["BillingLine2"     ] = Sql.ToString(this.BillAddr.Line2                 );
				row["BillingLine3"     ] = Sql.ToString(this.BillAddr.Line3                 );
				row["BillingLine4"     ] = Sql.ToString(this.BillAddr.Line4                 );
				row["BillingLine5"     ] = Sql.ToString(this.BillAddr.Line5                 );
				row["BillingCity"      ] = Sql.ToString(this.BillAddr.City                  );
				row["BillingState"     ] = Sql.ToString(this.BillAddr.CountrySubDivisionCode);
				row["BillingPostalCode"] = Sql.ToString(this.BillAddr.PostalCode            );
				row["BillingCountry"   ] = Sql.ToString(this.BillAddr.Country               );
			}
			if ( this.ShipAddr != null )
			{
				StringBuilder sbStreet = new StringBuilder();
				if ( !Sql.IsEmptyString(this.ShipAddr.Line1) ) sbStreet.AppendLine(this.ShipAddr.Line1);
				if ( !Sql.IsEmptyString(this.ShipAddr.Line2) ) sbStreet.AppendLine(this.ShipAddr.Line2);
				if ( !Sql.IsEmptyString(this.ShipAddr.Line3) ) sbStreet.AppendLine(this.ShipAddr.Line3);
				if ( !Sql.IsEmptyString(this.ShipAddr.Line4) ) sbStreet.AppendLine(this.ShipAddr.Line4);
				if ( !Sql.IsEmptyString(this.ShipAddr.Line5) ) sbStreet.AppendLine(this.ShipAddr.Line5);
				row["ShippingStreet"    ] = Sql.ToString(sbStreet.ToString()                 );
				row["ShippingLine1"     ] = Sql.ToString(this.ShipAddr.Line1                 );
				row["ShippingLine2"     ] = Sql.ToString(this.ShipAddr.Line2                 );
				row["ShippingLine3"     ] = Sql.ToString(this.ShipAddr.Line3                 );
				row["ShippingLine4"     ] = Sql.ToString(this.ShipAddr.Line4                 );
				row["ShippingLine5"     ] = Sql.ToString(this.ShipAddr.Line5                 );
				row["ShippingCity"      ] = Sql.ToString(this.ShipAddr.City                  );
				row["ShippingState"     ] = Sql.ToString(this.ShipAddr.CountrySubDivisionCode);
				row["ShippingPostalCode"] = Sql.ToString(this.ShipAddr.PostalCode            );
				row["ShippingCountry"   ] = Sql.ToString(this.ShipAddr.Country               );
			}
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
