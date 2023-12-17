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
	public class Order : QBase
	{
		#region Properties
		public DateTime?                 cancelledAt                       { get; set; }
		public DateTime?                 closedAt                          { get; set; }
		public DateTime?                 processedAt                       { get; set; }
		public bool                      closed                            { get; set; }
		public bool                      confirmed                         { get; set; }
		public bool                      fullyPaid                         { get; set; }
		public bool                      unpaid                            { get; set; }
		public string                    currencyCode                      { get; set; }
		public int                       currentSubtotalLineItemsQuantity  { get; set; }
		public bool                      taxesIncluded                     { get; set; }
		public int                       currentTotalWeight                { get; set; }
		public string                    customerLocale                    { get; set; }
		public string                    discountCode                      { get; set; }
		public string                    email                             { get; set; }
		public string                    phone                             { get; set; }
		public string                    note                              { get; set; }
		public MoneyV2                   currentCartDiscountAmountSet      { get; set; }
		public MoneyV2                   currentSubtotalPriceSet           { get; set; }
		public MoneyV2                   currentTotalDiscountsSet          { get; set; }
		public MoneyV2                   currentTotalDutiesSet             { get; set; }
		public MoneyV2                   currentTotalPriceSet              { get; set; }
		public MoneyV2                   currentTotalTaxSet                { get; set; }
		public Customer                  customer                          { get; set; }
		public MailingAddress            billingAddress                    { get; set; }
		public MailingAddress            shippingAddress                   { get; set; }
		//public IList<ShipMethod>         shippingLines                     { get; set; }

		public IList<LineItem>           lineItems                         { get; set; }

		public override string ToString()
		{
			StringBuilder sb = new StringBuilder();
			sb.AppendLine("Order");
			sb.AppendLine("   id                              : " +  this.id                              );
			sb.AppendLine("   cursor                          : " +  this.cursor                          );
			sb.AppendLine("   createdAt                       : " + (this.createdAt                       .HasValue ? this.createdAt  .Value.ToString() : String.Empty));
			sb.AppendLine("   updatedAt                       : " + (this.updatedAt                       .HasValue ? this.updatedAt  .Value.ToString() : String.Empty));
			sb.AppendLine("   cancelledAt                     : " + (this.cancelledAt                     .HasValue ? this.cancelledAt.Value.ToString() : String.Empty));
			sb.AppendLine("   closedAt                        : " + (this.closedAt                        .HasValue ? this.closedAt   .Value.ToString() : String.Empty));
			sb.AppendLine("   processedAt                     : " + (this.processedAt                     .HasValue ? this.processedAt.Value.ToString() : String.Empty));
			sb.AppendLine("   closed                          : " +  this.closed                          .ToString());
			sb.AppendLine("   confirmed                       : " +  this.confirmed                       .ToString());
			sb.AppendLine("   fullyPaid                       : " +  this.fullyPaid                       .ToString());
			sb.AppendLine("   unpaid                          : " +  this.unpaid                          .ToString());
			sb.AppendLine("   currencyCode                    : " +  this.currencyCode                    );
			sb.AppendLine("   currentSubtotalLineItemsQuantity: " +  this.currentSubtotalLineItemsQuantity.ToString());
			sb.AppendLine("   taxesIncluded                   : " +  this.taxesIncluded                   .ToString());
			sb.AppendLine("   currentTotalWeight              : " +  this.currentTotalWeight              .ToString());
			sb.AppendLine("   customerLocale                  : " +  this.customerLocale                  );
			sb.AppendLine("   discountCode                    : " +  this.discountCode                    );
			sb.AppendLine("   email                           : " +  this.email                           );
			sb.AppendLine("   phone                           : " +  this.phone                           );
			sb.AppendLine("   note                            : " +  this.note                            );
			sb.AppendLine("   currentCartDiscountAmountSet    : " + (this.currentCartDiscountAmountSet    != null ? this.currentCartDiscountAmountSet.ToString() : String.Empty));
			sb.AppendLine("   currentSubtotalPriceSet         : " + (this.currentSubtotalPriceSet         != null ? this.currentSubtotalPriceSet     .ToString() : String.Empty));
			sb.AppendLine("   currentTotalDiscountsSet        : " + (this.currentTotalDiscountsSet        != null ? this.currentTotalDiscountsSet    .ToString() : String.Empty));
			sb.AppendLine("   currentTotalDutiesSet           : " + (this.currentTotalDutiesSet           != null ? this.currentTotalDutiesSet       .ToString() : String.Empty));
			sb.AppendLine("   currentTotalPriceSet            : " + (this.currentTotalPriceSet            != null ? this.currentTotalPriceSet        .ToString() : String.Empty));
			sb.AppendLine("   currentTotalTaxSet              : " + (this.currentTotalTaxSet              != null ? this.currentTotalTaxSet          .ToString() : String.Empty));
			sb.AppendLine("   customer                        : " + (this.customer                        != null ? this.customer.id                 .ToString() : String.Empty));
			sb.AppendLine("   billingAddress                  : " + (this.billingAddress                  != null ? this.billingAddress              .ToString() : String.Empty));
			sb.AppendLine("   shippingAddress                 : " + (this.shippingAddress                 != null ? this.shippingAddress             .ToString() : String.Empty));
			//sb.AppendLine("   shippingLines                   : " + (this.shippingLines                   != null ? this.shippingLines               .ToString() : String.Empty));
			return sb.ToString();
		}
		#endregion

		public Order()
		{
			this.lineItems = new List<LineItem>();
		}

		public void SetBillAddr(string sBillingStreet , string sBillingCity , string sBillingState , string sBillingPostalCode , string sBillingCountry)
		{
			if ( !Sql.IsEmptyString(sBillingStreet) || !Sql.IsEmptyString(sBillingCity) || !Sql.IsEmptyString(sBillingState) || !Sql.IsEmptyString(sBillingPostalCode) || !Sql.IsEmptyString(sBillingCountry) )
				this.billingAddress = new MailingAddress(sBillingStreet , sBillingCity , sBillingState , sBillingPostalCode , sBillingCountry);
			else
				this.billingAddress = null;
		}

		public void SetShipAddr(string sShippingStreet, string sShippingCity, string sShippingState, string sShippingPostalCode, string sShippingCountry)
		{
			if ( !Sql.IsEmptyString(sShippingStreet) || !Sql.IsEmptyString(sShippingCity) || !Sql.IsEmptyString(sShippingState) || !Sql.IsEmptyString(sShippingPostalCode) || !Sql.IsEmptyString(sShippingCountry) )
				this.shippingAddress = new MailingAddress(sShippingStreet, sShippingCity, sShippingState, sShippingPostalCode, sShippingCountry);
			else
				this.shippingAddress = null;
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
			dt.Columns.Add("TxnSource"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("AutoDocNumber"                , Type.GetType("System.Boolean" ));
			dt.Columns.Add("Customer"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("CustomerMemo"                 , Type.GetType("System.String"  ));
			dt.Columns.Add("RemitTo"                      , Type.GetType("System.String"  ));
			dt.Columns.Add("Class"                        , Type.GetType("System.String"  ));
			dt.Columns.Add("SalesTerm"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("DueDate"                      , Type.GetType("System.DateTime"));
			dt.Columns.Add("SalesRep"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("PONumber"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("FOB"                          , Type.GetType("System.String"  ));
			dt.Columns.Add("ShipMethod"                   , Type.GetType("System.String"  ));
			dt.Columns.Add("ShipDate"                     , Type.GetType("System.DateTime"));
			dt.Columns.Add("TrackingNum"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("GlobalTaxCalculation"         , Type.GetType("System.String"  ));
			dt.Columns.Add("TotalAmt"                     , Type.GetType("System.Decimal" ));
			dt.Columns.Add("HomeTotalAmt"                 , Type.GetType("System.Decimal" ));
			dt.Columns.Add("ApplyTaxAfterDiscount"        , Type.GetType("System.Boolean" ));
			dt.Columns.Add("Template"                     , Type.GetType("System.String"  ));
			dt.Columns.Add("PrintStatus"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("EmailStatus"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("BillEmail"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("ARAccount"                    , Type.GetType("System.String"  ));
			dt.Columns.Add("Balance"                      , Type.GetType("System.Decimal" ));
			dt.Columns.Add("FinanceCharge"                , Type.GetType("System.Boolean" ));
			dt.Columns.Add("PaymentMethod"                , Type.GetType("System.String"  ));
			dt.Columns.Add("PaymentRefNum"                , Type.GetType("System.String"  ));
			dt.Columns.Add("PaymentType"                  , Type.GetType("System.String"  ));
			dt.Columns.Add("DepositToAccount"             , Type.GetType("System.String"  ));
			dt.Columns.Add("DeliveryInfo"                 , Type.GetType("System.DateTime"));
			dt.Columns.Add("ManuallyClosed"               , Type.GetType("System.Boolean" ));

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
			/*
			if ( this.Id                    != null   ) row["Id"                     ] = Sql.ToDBString  (this.Id                           );
			if ( this.DocNumber             != null   ) row["DocNumber"              ] = Sql.ToDBString  (this.DocNumber                    );
			if ( this.TxnDate               .HasValue ) row["TxnDate"                ] = Sql.ToDBDateTime(this.TxnDate                .Value);
			if ( this.DepartmentRef         != null   ) row["Department"             ] = Sql.ToDBString  (this.DepartmentRef          .Value);
			if ( this.CurrencyRef           != null   ) row["Currency"               ] = Sql.ToDBString  (this.CurrencyRef            .Value);
			if ( this.ExchangeRate          .HasValue ) row["ExchangeRate"           ] = Sql.ToDBDecimal (this.ExchangeRate           .Value);
			if ( this.PrivateNote           != null   ) row["PrivateNote"            ] = Sql.ToDBString  (this.PrivateNote                  );
			if ( this.TxnStatus             != null   ) row["TxnStatus"              ] = Sql.ToDBString  (this.TxnStatus                    );
			if ( this.TxnTaxDetail          != null   ) row["TotalTax"               ] = Sql.ToDBDecimal (this.TxnTaxDetail.TotalTax        );
			if ( this.TxnSource             != null   ) row["TxnSource"              ] = Sql.ToDBString  (this.TxnSource                    );
			if ( this.AutoDocNumber         .HasValue ) row["AutoDocNumber"          ] = Sql.ToDBBoolean (this.AutoDocNumber          .Value);
			if ( this.CustomerRef           != null   ) row["Customer"               ] = Sql.ToDBString  (this.CustomerRef            .Value);
			if ( this.CustomerMemo          != null   ) row["CustomerMemo"           ] = Sql.ToDBString  (this.CustomerMemo                 );
			if ( this.RemitToRef            != null   ) row["RemitTo"                ] = Sql.ToDBString  (this.RemitToRef             .Value);
			if ( this.ClassRef              != null   ) row["Class"                  ] = Sql.ToDBString  (this.ClassRef               .Value);
			if ( this.SalesTermRef          != null   ) row["SalesTerm"              ] = Sql.ToDBString  (this.SalesTermRef           .Value);
			if ( this.DueDate               .HasValue ) row["DueDate"                ] = Sql.ToDBDateTime(this.DueDate                .Value);
			if ( this.SalesRepRef           != null   ) row["SalesRep"               ] = Sql.ToDBString  (this.SalesRepRef            .Value);
			if ( this.PONumber              != null   ) row["PONumber"               ] = Sql.ToDBString  (this.PONumber                     );
			if ( this.FOB                   != null   ) row["FOB"                    ] = Sql.ToDBString  (this.FOB                          );
			if ( this.ShipMethodRef         != null   ) row["ShipMethod"             ] = Sql.ToDBString  (this.ShipMethodRef          .Value);
			if ( this.ShipDate              .HasValue ) row["ShipDate"               ] = Sql.ToDBDateTime(this.ShipDate               .Value);
			if ( this.TrackingNum           != null   ) row["TrackingNum"            ] = Sql.ToDBString  (this.TrackingNum                  );
			if ( this.GlobalTaxCalculation  != null   ) row["GlobalTaxCalculation"   ] = Sql.ToDBString  (this.GlobalTaxCalculation         );
			if ( this.TotalAmt              .HasValue ) row["TotalAmt"               ] = Sql.ToDBDecimal (this.TotalAmt               .Value);
			if ( this.HomeTotalAmt          .HasValue ) row["HomeTotalAmt"           ] = Sql.ToDBDecimal (this.HomeTotalAmt           .Value);
			if ( this.ApplyTaxAfterDiscount .HasValue ) row["ApplyTaxAfterDiscount"  ] = Sql.ToDBBoolean (this.ApplyTaxAfterDiscount  .Value);
			if ( this.TemplateRef           != null   ) row["Template"               ] = Sql.ToDBString  (this.TemplateRef            .Value);
			if ( this.PrintStatus           .HasValue ) row["PrintStatus"            ] = Sql.ToDBString  (this.PrintStatus            .Value);
			if ( this.EmailStatus           .HasValue ) row["EmailStatus"            ] = Sql.ToDBString  (this.EmailStatus            .Value);
			if ( this.BillEmail             != null   ) row["BillEmail"              ] = Sql.ToDBString  (this.BillEmail                    );
			if ( this.ARAccountRef          != null   ) row["ARAccount"              ] = Sql.ToDBString  (this.ARAccountRef           .Value);
			if ( this.Balance               .HasValue ) row["Balance"                ] = Sql.ToDBDecimal (this.Balance                .Value);
			if ( this.FinanceCharge         .HasValue ) row["FinanceCharge"          ] = Sql.ToDBBoolean (this.FinanceCharge          .Value);
			if ( this.PaymentMethodRef      != null   ) row["PaymentMethod"          ] = Sql.ToDBString  (this.PaymentMethodRef       .Value);
			if ( this.PaymentRefNum         != null   ) row["PaymentRefNum"          ] = Sql.ToDBString  (this.PaymentRefNum                );
			if ( this.PaymentType           .HasValue ) row["PaymentType"            ] = Sql.ToDBString  (this.PaymentType            .Value);
			if ( this.DepositToAccountRef   != null   ) row["DepositToAccount"       ] = Sql.ToDBString  (this.DepositToAccountRef    .Value);
			if ( this.DeliveryInfo          != null   ) row["DeliveryInfo"           ] = Sql.ToDBDateTime(this.DeliveryInfo                 );
			if ( this.ManuallyClosed        .HasValue ) row["ManuallyClosed"         ] = Sql.ToDBBoolean (this.ManuallyClosed         .Value);
			*/

			if ( this.billingAddress != null )
			{
				StringBuilder sbStreet = new StringBuilder();
				if ( !Sql.IsEmptyString(this.billingAddress.address1) ) sbStreet.AppendLine(this.billingAddress.address1);
				if ( !Sql.IsEmptyString(this.billingAddress.address2) ) sbStreet.AppendLine(this.billingAddress.address2);
				row["BillingStreet"    ] = Sql.ToString(sbStreet.ToString()         );
				row["BillingAddress1"  ] = Sql.ToString(this.billingAddress.address1);
				row["BillingAddress2"  ] = Sql.ToString(this.billingAddress.address2);
				row["BillingCity"      ] = Sql.ToString(this.billingAddress.city    );
				row["BillingState"     ] = Sql.ToString(this.billingAddress.province);
				row["BillingPostalCode"] = Sql.ToString(this.billingAddress.zip     );
				row["BillingCountry"   ] = Sql.ToString(this.billingAddress.country );
			}
			if ( this.shippingAddress != null )
			{
				StringBuilder sbStreet = new StringBuilder();
				if ( !Sql.IsEmptyString(this.shippingAddress.address1) ) sbStreet.AppendLine(this.shippingAddress.address1);
				if ( !Sql.IsEmptyString(this.shippingAddress.address2) ) sbStreet.AppendLine(this.shippingAddress.address2);
				row["ShippingStreet"    ] = Sql.ToString(sbStreet.ToString()          );
				row["ShippingAddress1"  ] = Sql.ToString(this.shippingAddress.address1);
				row["ShippingAddress2"  ] = Sql.ToString(this.shippingAddress.address2);
				row["ShippingCity"      ] = Sql.ToString(this.shippingAddress.city    );
				row["ShippingState"     ] = Sql.ToString(this.shippingAddress.province);
				row["ShippingPostalCode"] = Sql.ToString(this.shippingAddress.zip     );
				row["ShippingCountry"   ] = Sql.ToString(this.shippingAddress.country );
			}
		}

		public static DataRow ConvertToRow(Order obj)
		{
			DataTable dt = Order.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Order> orders)
		{
			DataTable dt = Order.CreateTable();
			if ( orders != null )
			{
				foreach ( Order order in orders )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					order.SetRow(row);
				}
			}
			return dt;
		}
	}
}
