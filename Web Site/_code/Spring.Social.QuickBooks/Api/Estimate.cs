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
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/estimate
	[Serializable]
	public class Estimate : QOrder
	{
		#region Properties
		public String                    TxnStatus                         { get; set; }
		public ReferenceType             ClassRef                          { get; set; }
		public DateTime?                 ExpirationDate                    { get; set; }
		public String                    AcceptedBy                        { get; set; }
		public DateTime?                 AcceptedDate                      { get; set; }
		#endregion

		public Estimate()
		{
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"                           , Type.GetType("System.String"  ));
			dt.Columns.Add("SyncToken"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("TimeCreated"                  , Type.GetType("System.DateTime"));
			dt.Columns.Add("TimeModified"                 , Type.GetType("System.DateTime"));
			dt.Columns.Add("DocNumber"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("TxnDate"                      , Type.GetType("System.DateTime"));
			dt.Columns.Add("Department"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("Currency"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("ExchangeRate"                 , Type.GetType("System.Decimal" ));
			dt.Columns.Add("PrivateNote"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("TxnStatus"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("TotalTax"                     , Type.GetType("System.Decimal" ));
			dt.Columns.Add("Customer"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("CustomerName"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("CustomerMemo"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("Class"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("SalesTerm"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("ShipMethod"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("ShipDate"                     , Type.GetType("System.DateTime"));
			dt.Columns.Add("GlobalTaxCalculation"         , Type.GetType("System.String"  ));
			dt.Columns.Add("TotalAmt"                     , Type.GetType("System.Decimal" ));
			dt.Columns.Add("ApplyTaxAfterDiscount"        , Type.GetType("System.Boolean" ));
			dt.Columns.Add("Template"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("PrintStatus"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("EmailStatus"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("BillEmail"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("ARAccount"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("Balance"                      , Type.GetType("System.Decimal" ));
			dt.Columns.Add("FinanceCharge"                , Type.GetType("System.Boolean" ));
			dt.Columns.Add("ExpirationDate"               , Type.GetType("System.DateTime"));
			dt.Columns.Add("AcceptedBy"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("AcceptedDate"                 , Type.GetType("System.DateTime"));

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

			//dt.Columns.Add("LinkedTxn"                    , Type.GetType("System.LinkedTxn[]" );
			//dt.Columns.Add("Line"                         , Type.GetType("System.Line[]"      );
			//dt.Columns.Add("TxnTaxDetail"                 , Type.GetType("System.TxnTaxDetail");
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.Id                    != null   ) row["Id"                     ] = Sql.ToDBString  (this.Id                           );
			if ( this.SyncToken             != null   ) row["SyncToken"              ] = Sql.ToDBString  (this.SyncToken                    );
			if ( this.MetaData              != null   ) row["TimeCreated"            ] = Sql.ToDBDateTime(this.MetaData.CreateTime          );
			if ( this.MetaData              != null   ) row["TimeModified"           ] = Sql.ToDBDateTime(this.MetaData.LastUpdatedTime     );
			if ( this.DocNumber             != null   ) row["DocNumber"              ] = Sql.ToDBString  (this.DocNumber                    );
			if ( this.TxnDate               .HasValue ) row["TxnDate"                ] = Sql.ToDBDateTime(this.TxnDate                .Value);
			if ( this.DepartmentRef         != null   ) row["Department"             ] = Sql.ToDBString  (this.DepartmentRef          .Value);
			if ( this.CurrencyRef           != null   ) row["Currency"               ] = Sql.ToDBString  (this.CurrencyRef            .Value);
			if ( this.ExchangeRate          .HasValue ) row["ExchangeRate"           ] = Sql.ToDBDecimal (this.ExchangeRate           .Value);
			if ( this.PrivateNote           != null   ) row["PrivateNote"            ] = Sql.ToDBString  (this.PrivateNote                  );
			if ( this.TxnStatus             != null   ) row["TxnStatus"              ] = Sql.ToDBString  (this.TxnStatus                    );
			if ( this.TxnTaxDetail          != null   ) row["TotalTax"               ] = Sql.ToDBDecimal (this.TxnTaxDetail.TotalTax        );
			if ( this.CustomerRef           != null   ) row["Customer"               ] = Sql.ToDBString  (this.CustomerRef            .Value);
			if ( this.CustomerRef           != null   ) row["CustomerName"           ] = Sql.ToDBString  (this.CustomerRef            .Name );
			if ( this.CustomerMemo          != null   ) row["CustomerMemo"           ] = Sql.ToDBString  (this.CustomerMemo           .Value);
			if ( this.ClassRef              != null   ) row["Class"                  ] = Sql.ToDBString  (this.ClassRef               .Value);
			if ( this.SalesTermRef          != null   ) row["SalesTerm"              ] = Sql.ToDBString  (this.SalesTermRef           .Value);
			if ( this.ShipMethodRef         != null   ) row["ShipMethod"             ] = Sql.ToDBString  (this.ShipMethodRef          .Value);
			if ( this.ShipDate              .HasValue ) row["ShipDate"               ] = Sql.ToDBDateTime(this.ShipDate               .Value);
			if ( this.GlobalTaxCalculation  != null   ) row["GlobalTaxCalculation"   ] = Sql.ToDBString  (this.GlobalTaxCalculation         );
			if ( this.TotalAmt              .HasValue ) row["TotalAmt"               ] = Sql.ToDBDecimal (this.TotalAmt               .Value);
			if ( this.ApplyTaxAfterDiscount .HasValue ) row["ApplyTaxAfterDiscount"  ] = Sql.ToDBBoolean (this.ApplyTaxAfterDiscount  .Value);
			if ( this.PrintStatus           .HasValue ) row["PrintStatus"            ] = Sql.ToDBString  (this.PrintStatus            .Value);
			if ( this.EmailStatus           .HasValue ) row["EmailStatus"            ] = Sql.ToDBString  (this.EmailStatus            .Value);
			if ( this.BillEmail             != null   ) row["BillEmail"              ] = Sql.ToDBString  (this.BillEmail                    );
			if ( this.ExpirationDate        .HasValue ) row["ExpirationDate"         ] = Sql.ToDBDateTime(this.ExpirationDate         .Value);
			if ( this.AcceptedBy            != null   ) row["AcceptedBy"             ] = Sql.ToDBString  (this.AcceptedBy                   );
			if ( this.AcceptedDate          .HasValue ) row["AcceptedDate"           ] = Sql.ToDBDateTime(this.AcceptedDate           .Value);

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

		public static DataRow ConvertToRow(Estimate obj)
		{
			DataTable dt = Estimate.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Estimate> estimates)
		{
			DataTable dt = Estimate.CreateTable();
			if ( estimates != null )
			{
				foreach ( Estimate estimate in estimates )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					estimate.SetRow(row);
				}
			}
			return dt;
		}

		public DataTable GetLineItemsTable()
		{
			DataTable dt = Spring.Social.QuickBooks.Api.Line.ConvertToTable(this.Lines);
			return dt;
		}
	}
}
