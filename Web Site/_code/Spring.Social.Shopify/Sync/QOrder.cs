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
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Xml;
using System.Diagnostics;
using SplendidCRM;

namespace Spring.Social.Shopify
{
	public class QOrder : QObject
	{
		#region Properties
		public string   DocNumber                  ;
		//public string   CustomerName               ;
		public string   CustomerId                 ;
		public DateTime TxnDate                    ;
		public string   PrivateNote                ;
		// 03/19/2015 Paul.  TrackingNum is for shipping, not Purchase Orders. 
		//public string   POnumber                   ;
		public string   SalesTermId                ;
		public string   ShipMethod                 ;
		public string   Currency                   ;
		public Decimal  ExchangeRate               ;
		public Decimal  Subtotal                   ;
		public Decimal  ShippingAmount             ;
		public Decimal  Discount                   ;
		public Decimal  Tax                        ;
		public Decimal  TotalAmt                   ;
		public string   TaxCodeTaxRate             ;
		public string   BillingStreet              ;
		public string   BillingCity                ;
		public string   BillingState               ;
		public string   BillingPostalCode          ;
		public string   BillingCountry             ;
		public string   BillingRawAddress          ;
		public string   ShippingStreet             ;
		public string   ShippingCity               ;
		public string   ShippingState              ;
		public string   ShippingPostalCode         ;
		public string   ShippingCountry            ;
		public string   ShippingRawAddress         ;
		public List<Shopify.LineItem> LineItems ;
		public string   DiscountAccountId          ;
		#endregion
		protected DataView vwCurrencies  ;
		protected DataView vwShippers    ;
		protected DataView vwTaxRates    ;
		protected DataView vwItems       ;
		protected DataView vwCustomers   ;
		protected DataView vwPaymentTerms;
		protected SplendidCRM.DbProviderFactory dbf;
		protected IDbConnection     con;

		public DataTable Items
		{
			get { return vwItems.Table; }
		}

		public QOrder(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Shopify.Api.IShopify shopify, DataTable dtCurrencies, DataTable dtShippers, DataTable dtTaxRates, DataTable dtItems, DataTable dtCustomers, DataTable dtPaymentTerms, string sDiscountAccountId, SplendidCRM.DbProviderFactory dbf, IDbConnection con, string sShopifyTableName, string sCRMModuleName, string sCRMTableName, string sCRMTableSort, bool bCRMAssignedUser, bool bShortStateName, bool bShortCountryName)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, shopify, sShopifyTableName, "DocNumber", sCRMModuleName, sCRMTableName, sCRMTableSort, bCRMAssignedUser, bShortStateName, bShortCountryName)
		{
			this.LineItems      = new List<Shopify.LineItem>();
			this.vwCurrencies   = new DataView(dtCurrencies  );
			this.vwShippers     = new DataView(dtShippers    );
			this.vwTaxRates     = new DataView(dtTaxRates    );
			this.vwItems        = new DataView(dtItems       );
			this.vwCustomers    = new DataView(dtCustomers   );
			this.vwPaymentTerms = new DataView(dtPaymentTerms);
			this.DiscountAccountId = sDiscountAccountId;
			this.dbf = dbf;
			this.con = con;
		}

		public override void Reset()
		{
			base.Reset();
			this.DocNumber          = String.Empty;
			//this.CustomerName       = String.Empty;
			this.CustomerId         = String.Empty;
			this.TxnDate            = DateTime.MinValue;
			this.PrivateNote        = String.Empty;
			// 03/19/2015 Paul.  TrackingNum is for shipping, not Purchase Orders. 
			//this.POnumber           = String.Empty;
			this.SalesTermId        = String.Empty;
			this.ShipMethod         = String.Empty;
			this.Currency           = String.Empty;
			// 02/19/2015 Paul.  Default ExchangeRate to 1. 
			this.ExchangeRate       = 1;
			this.Subtotal           = 0;
			this.ShippingAmount     = 0;
			this.Discount           = 0;
			this.Tax                = 0;
			this.TotalAmt           = 0;
			this.TaxCodeTaxRate     = String.Empty;
			this.BillingStreet      = String.Empty;
			this.BillingCity        = String.Empty;
			this.BillingState       = String.Empty;
			this.BillingPostalCode  = String.Empty;
			this.BillingCountry     = String.Empty;
			this.ShippingStreet     = String.Empty;
			this.ShippingCity       = String.Empty;
			this.ShippingState      = String.Empty;
			this.ShippingPostalCode = String.Empty;
			this.ShippingCountry    = String.Empty;
			this.LineItems          = new List<Shopify.LineItem>();
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			string sSalesTermId = String.Empty;
			vwPaymentTerms.RowFilter = "SYNC_NAME = '" + Sql.ToString(row["PAYMENT_TERMS"]) + "'";
			if ( vwPaymentTerms.Count > 0 )
				sSalesTermId = Sql.ToString(vwPaymentTerms[0]["SYNC_REMOTE_KEY"]);
			
			string sCustomerId = String.Empty;
			vwCustomers.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["BILLING_ACCOUNT_ID"]) + "'";
			if ( vwCustomers.Count > 0 )
				sCustomerId = Sql.ToString(vwCustomers[0]["SYNC_REMOTE_KEY"]);
			
			string sTaxCodeTaxRate = String.Empty;
			// 02/26/2015 Paul.  We need to use SHOPIFY_TAX_VENDOR when setting the TaxCodeTaxRate. 
			vwTaxRates.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["TAXRATE_ID"]) + "'";
			if ( vwTaxRates.Count > 0 )
				sTaxCodeTaxRate = Sql.ToString(vwTaxRates[0]["SHOPIFY_TAX_VENDOR"]);
			
			this.ID       = sID;
			this.LOCAL_ID = Sql.ToGuid(row["ID"]);
			if ( Sql.IsEmptyString(this.ID) )
			{
				//this.CustomerName       = Sql.ToString  (row["BILLING_ACCOUNT_NAME"       ]);
				this.TxnDate            = Sql.ToDateTime(row["DATE_ENTERED"]).Date          ;
				this.CustomerId         = Sql.ToString  (    sCustomerId                   );
				this.Name               = Sql.ToString  (row["NAME"                       ]);
				this.PrivateNote        = Sql.ToString  (row["DESCRIPTION"                ]);
				// 03/19/2015 Paul.  TrackingNum is for shipping, not Purchase Orders. 
				//this.POnumber           = Sql.ToString  (row["PURCHASE_ORDER_NUM"         ]);
				this.SalesTermId        = Sql.ToString  (    sSalesTermId                  );
				this.ShipMethod         = Sql.ToString  (row["SHIPPER_NAME"               ]);
				this.Currency           = Sql.ToString  (row["CURRENCY_ISO4217"           ]);
				this.ExchangeRate       = Sql.ToDecimal (row["EXCHANGE_RATE"              ]);
				this.Subtotal           = Sql.ToDecimal (row["SUBTOTAL_USDOLLAR"          ]);
				this.ShippingAmount     = Sql.ToDecimal (row["SHIPPING_USDOLLAR"          ]);
				this.Discount           = Sql.ToDecimal (row["DISCOUNT_USDOLLAR"          ]);
				this.Tax                = Sql.ToDecimal (row["TAX_USDOLLAR"               ]);
				this.TaxCodeTaxRate     = Sql.ToString  (    sTaxCodeTaxRate               );
				this.TotalAmt           = Sql.ToDecimal (row["TOTAL_USDOLLAR"             ]);
				this.BillingStreet      = Sql.ToString  (row["BILLING_ADDRESS_STREET"     ]);
				this.BillingCity        = Sql.ToString  (row["BILLING_ADDRESS_CITY"       ]);
				this.BillingState       = Sql.ToString  (row["BILLING_ADDRESS_STATE"      ]);
				this.BillingPostalCode  = Sql.ToString  (row["BILLING_ADDRESS_POSTALCODE" ]);
				this.BillingCountry     = Sql.ToString  (row["BILLING_ADDRESS_COUNTRY"    ]);
				this.ShippingStreet     = Sql.ToString  (row["SHIPPING_ADDRESS_STREET"    ]);
				this.ShippingCity       = Sql.ToString  (row["SHIPPING_ADDRESS_CITY"      ]);
				this.ShippingState      = Sql.ToString  (row["SHIPPING_ADDRESS_STATE"     ]);
				this.ShippingPostalCode = Sql.ToString  (row["SHIPPING_ADDRESS_POSTALCODE"]);
				this.ShippingCountry    = Sql.ToString  (row["SHIPPING_ADDRESS_COUNTRY"   ]);
				bChanged = true;
			}
			else
			{
				//if ( Compare(this.CustomerName     , row["BILLING_ACCOUNT_NAME"       ], "BILLING_ACCOUNT_NAME"      , sbChanges) ) { this.CustomerName       = Sql.ToString  (row["BILLING_ACCOUNT_NAME"       ]);  bChanged = true; }
				// 02/18/2015 Paul.  TxnDate does not include time. 
				if ( Compare(this.TxnDate           , Sql.ToDateTime(row["DATE_ENTERED"]).Date, "DATE_ENTERED"               , sbChanges) ) { this.TxnDate            = Sql.ToDateTime(row["DATE_ENTERED"]).Date          ;  bChanged = true; }
				if ( Compare(this.CustomerId        ,     sCustomerId                         , "BILLING_ACCOUNT_ID"         , sbChanges) ) { this.CustomerId         = Sql.ToString  (    sCustomerId                   );  bChanged = true; }
				if ( Compare(this.Name              , row["NAME"                       ]      , "NAME"                       , sbChanges) ) { this.Name               = Sql.ToString  (row["NAME"                       ]);  bChanged = true; }
				if ( Compare(this.PrivateNote       , row["DESCRIPTION"                ]      , "DESCRIPTION"                , sbChanges) ) { this.PrivateNote        = Sql.ToString  (row["DESCRIPTION"                ]);  bChanged = true; }
				// 03/19/2015 Paul.  TrackingNum is for shipping, not Purchase Orders. 
				//if ( Compare(this.POnumber          , row["PURCHASE_ORDER_NUM"         ]      , "PURCHASE_ORDER_NUM"         , sbChanges) ) { this.POnumber           = Sql.ToString  (row["PURCHASE_ORDER_NUM"         ]);  bChanged = true; }
				if ( Compare(this.SalesTermId       ,     sSalesTermId                        , "PAYMENT_TERMS"              , sbChanges) ) { this.SalesTermId        = Sql.ToString  (    sSalesTermId                  );  bChanged = true; }
				if ( Compare(this.ShipMethod        , row["SHIPPER_NAME"               ]      , "SHIPPER_NAME"               , sbChanges) ) { this.ShipMethod         = Sql.ToString  (row["SHIPPER_NAME"               ]);  bChanged = true; }
				if ( Compare(this.Currency          , row["CURRENCY_ISO4217"           ]      , "CURRENCY_ISO4217"           , sbChanges) ) { this.Currency           = Sql.ToString  (row["CURRENCY_ISO4217"           ]);  bChanged = true; }
				if ( Compare(this.ExchangeRate      , row["EXCHANGE_RATE"              ]      , "EXCHANGE_RATE"              , sbChanges) ) { this.ExchangeRate       = Sql.ToDecimal (row["EXCHANGE_RATE"              ]);  bChanged = true; }
				if ( Compare(this.Subtotal          , row["SUBTOTAL_USDOLLAR"          ]      , "SUBTOTAL_USDOLLAR"          , sbChanges) ) { this.Subtotal           = Sql.ToDecimal (row["SUBTOTAL_USDOLLAR"          ]);  bChanged = true; }
				if ( Compare(this.ShippingAmount    , row["SHIPPING_USDOLLAR"          ]      , "SHIPPING_USDOLLAR"          , sbChanges) ) { this.ShippingAmount     = Sql.ToDecimal (row["SHIPPING_USDOLLAR"          ]);  bChanged = true; }
				if ( Compare(this.Discount          , row["DISCOUNT_USDOLLAR"          ]      , "DISCOUNT_USDOLLAR"          , sbChanges) ) { this.Discount           = Sql.ToDecimal (row["DISCOUNT_USDOLLAR"          ]);  bChanged = true; }
				if ( Compare(this.Tax               , row["TAX_USDOLLAR"               ]      , "TAX_USDOLLAR"               , sbChanges) ) { this.Tax                = Sql.ToDecimal (row["TAX_USDOLLAR"               ]);  bChanged = true; }
				if ( Compare(this.TotalAmt          , row["TOTAL_USDOLLAR"             ]      , "TOTAL_USDOLLAR"             , sbChanges) ) { this.TotalAmt           = Sql.ToDecimal (row["TOTAL_USDOLLAR"             ]);  bChanged = true; }
				if ( Compare(this.TaxCodeTaxRate    ,     sTaxCodeTaxRate                     , "TAXRATE_ID"                 , sbChanges) ) { this.TaxCodeTaxRate     = Sql.ToString  (    sTaxCodeTaxRate               );  bChanged = true; }
				if ( Compare(this.BillingStreet     , row["BILLING_ADDRESS_STREET"     ]      , "BillingStreet"              , sbChanges) ) { this.BillingStreet      = Sql.ToString  (row["BILLING_ADDRESS_STREET"     ]);  bChanged = true; }
				if ( Compare(this.BillingCity       , row["BILLING_ADDRESS_CITY"       ]      , "BILLING_ADDRESS_CITY"       , sbChanges) ) { this.BillingCity        = Sql.ToString  (row["BILLING_ADDRESS_CITY"       ]);  bChanged = true; }
				if ( Compare(this.BillingState      , row["BILLING_ADDRESS_STATE"      ]      , "BILLING_ADDRESS_STATE"      , sbChanges) ) { this.BillingState       = Sql.ToString  (row["BILLING_ADDRESS_STATE"      ]);  bChanged = true; }
				if ( Compare(this.BillingPostalCode , row["BILLING_ADDRESS_POSTALCODE" ]      , "BILLING_ADDRESS_POSTALCODE" , sbChanges) ) { this.BillingPostalCode  = Sql.ToString  (row["BILLING_ADDRESS_POSTALCODE" ]);  bChanged = true; }
				if ( Compare(this.BillingCountry    , row["BILLING_ADDRESS_COUNTRY"    ]      , "BILLING_ADDRESS_COUNTRY"    , sbChanges) ) { this.BillingCountry     = Sql.ToString  (row["BILLING_ADDRESS_COUNTRY"    ]);  bChanged = true; }
				if ( Compare(this.ShippingStreet    , row["SHIPPING_ADDRESS_STREET"    ]      , "ShippingStreet"             , sbChanges) ) { this.ShippingStreet     = Sql.ToString  (row["SHIPPING_ADDRESS_STREET"    ]);  bChanged = true; }
				if ( Compare(this.ShippingCity      , row["SHIPPING_ADDRESS_CITY"      ]      , "SHIPPING_ADDRESS_CITY"      , sbChanges) ) { this.ShippingCity       = Sql.ToString  (row["SHIPPING_ADDRESS_CITY"      ]);  bChanged = true; }
				if ( Compare(this.ShippingState     , row["SHIPPING_ADDRESS_STATE"     ]      , "SHIPPING_ADDRESS_STATE"     , sbChanges) ) { this.ShippingState      = Sql.ToString  (row["SHIPPING_ADDRESS_STATE"     ]);  bChanged = true; }
				if ( Compare(this.ShippingPostalCode, row["SHIPPING_ADDRESS_POSTALCODE"]      , "SHIPPING_ADDRESS_POSTALCODE", sbChanges) ) { this.ShippingPostalCode = Sql.ToString  (row["SHIPPING_ADDRESS_POSTALCODE"]);  bChanged = true; }
				if ( Compare(this.ShippingCountry   , row["SHIPPING_ADDRESS_COUNTRY"   ]      , "SHIPPING_ADDRESS_COUNTRY"   , sbChanges) ) { this.ShippingCountry    = Sql.ToString  (row["SHIPPING_ADDRESS_COUNTRY"   ]);  bChanged = true; }
			}
			return bChanged;
		}

		protected void SetAddressFromShopify(Spring.Social.Shopify.Api.MailingAddress addr, bool bShortStateName, bool bShortCountryName, ref string sStreet, ref string sCity, ref string sState, ref string sPostalCode, ref string sCountry, ref string sRawAddress)
		{
			if ( addr != null )
			{
				StringBuilder sbStreet = new StringBuilder();
				if ( !Sql.IsEmptyString(addr.address1) ) sbStreet.AppendLine(addr.address1);
				if ( !Sql.IsEmptyString(addr.address2) ) sbStreet.AppendLine(addr.address2);
				sStreet     = Sql.ToString(sbStreet.ToString()).Trim();
				sCity       = Sql.ToString(addr.city       );
				sState      = Sql.ToString(addr.province   );
				sPostalCode = Sql.ToString(addr.zip        );
				sCountry    = Sql.ToString(addr.country    );
			}
		}

		public override void SetFromShopify(string sId)
		{
			base.SetFromShopify(sId);
		}

		public virtual LineItem CreateLineItem()
		{
			throw(new Exception("Not implemented."));
		}

		public virtual DataTable GetLineItemsFromCRM(ExchangeSession Session, IDbConnection con, Guid gUSER_ID, bool bRequireItems)
		{
			throw(new Exception("Not implemented."));
		}

		public virtual void SetLineItemsFromCRM(ExchangeSession Session, IDbConnection con, Guid gUSER_ID, StringBuilder sbErrors)
		{
			throw(new Exception("Not implemented."));
		}

		public virtual void SetLineItemsFromCRM(Spring.Social.Shopify.Api.Order obj)
		{
			// 03/08/2015 Paul.  We are not going to merge line items.  Just overwrite all line items. 
			obj.lineItems.Clear();
			int nLineNumber = 1;
			foreach ( LineItem oLine in this.LineItems )
			{
				Spring.Social.Shopify.Api.LineItem line = new Spring.Social.Shopify.Api.LineItem();
				{
					line.id          = oLine.ID             ;
					//line.Description = oLine.ItemName       ;
					//line.Quantity    = oLine.ItemQuantity   ;
					//line.UnitPrice   = oLine.ItemRate       ;
					//line.Amount      = oLine.ItemAmount     ;
					//line.LineNum     = nLineNumber.ToString();
					nLineNumber++;
				}
				obj.lineItems.Add(line);
			}
			// 02/17/2015 Paul.  SubTotalLineDetail is read-only. 
			// DiscountLine � Holds the discount applied to the entire transaction. 
			// 03/06/2015 Paul.  The Sales Form Discounts company preference must be enabled for this type of line to be available.
			// In the Shopify Online app, select Company Settings, Sales section, Sales form content, then Discount enabled. 
			if ( this.Discount > 0 )
			{
				if ( Sql.IsEmptyString(this.DiscountAccountId) )
					throw(new Exception("DiscountAccountId is empty.  Make sure that CRM setting Shopify.DiscountAccount is valid and that Shopify Online is enabled for discounts."));
				Spring.Social.Shopify.Api.LineItem line = new Spring.Social.Shopify.Api.LineItem();
				obj.lineItems.Add(line);
			}
		}

		// 03/08/2015 Paul.  We are not going to merge line items.  Just overwrite all line items. 
		/*
		public virtual void MergeLineItemsFromCRM(Spring.Social.Shopify.Api.QOrder obj)
		{
			List<LineItem> lstNewItems = new List<LineItem>();
			List<Spring.Social.Shopify.Api.Line> lstMatched = new List<Spring.Social.Shopify.Api.Line>();
			foreach ( LineItem oLine in this.LineItems )
			{
				bool bFound = false;
				foreach ( Spring.Social.Shopify.Api.Line line in obj.Lines )
				{
					if ( line.DetailType == Spring.Social.Shopify.Api.LineDetailTypeEnum.SalesItemLineDetail )
					{
						if ( line.ItemRefId == oLine.ItemRefId )
						{
							line.Id          = oLine.ID             ;
							line.LineNum     = oLine.ItemLineNum    ;
							line.ItemRefId   = oLine.ItemRefId      ;
							line.ItemRefName = oLine.ItemPartNumber ;
							line.Description = oLine.ItemName       ;
							line.TaxCode     = oLine.ItemTaxCode    ;
							line.Quantity    = oLine.ItemQuantity   ;
							line.UnitPrice   = oLine.ItemRate       ;
							line.Amount      = oLine.ItemAmount     ;
							bFound = true;
							lstMatched.Add(line);
							break;
						}
					}
					else if ( line.DetailType == Spring.Social.Shopify.Api.LineDetailTypeEnum.DescriptionOnly && oLine.ItemType == "Comment" )
					{
						// 03/06/2015 Paul.  We are looking for an exact match for a description line.  We will delete and create new comments instead of updating comments. 
						if ( line.Description == oLine.ItemDescription )
						{
							line.Id          = oLine.ID             ;
							line.LineNum     = oLine.ItemLineNum    ;
							bFound = true;
							lstMatched.Add(line);
							break;
						}
					}
				}
				if ( !bFound )
					lstNewItems.Add(oLine);
			}
			foreach ( LineItem oLine in lstNewItems )
			{
				Spring.Social.Shopify.Api.Line line = new Spring.Social.Shopify.Api.Line();
				if ( oLine.ItemType == "Comment" )
				{
					line.Id          = oLine.ID             ;
					line.Description = oLine.ItemDescription;
					line.DetailType  = Spring.Social.Shopify.Api.LineDetailTypeEnum.DescriptionOnly;
					line.Item        = new Spring.Social.Shopify.Api.DescriptionLineDetail();
				}
				else
				{
					line.Id          = oLine.ID             ;
					line.LineNum     = oLine.ItemLineNum    ;
					line.ItemRefId   = oLine.ItemRefId      ;
					line.ItemRefName = oLine.ItemPartNumber ;
					line.Description = oLine.ItemName       ;
					line.TaxCode     = oLine.ItemTaxCode    ;
					line.Quantity    = oLine.ItemQuantity   ;
					line.UnitPrice   = oLine.ItemRate       ;
					line.Amount      = oLine.ItemAmount     ;
				}
				obj.Lines.Add(line);
				lstMatched.Add(line);
			}
			// 02/17/2015 Paul.  SubTotalLineDetail is read-only. 
			bool bShippingFound = false;
			bool bDiscountFound = false;
			// 02/12/2015 Paul.  Remove Shopify items that are no longer in CRM, but for only sale items. 
			for ( int i = obj.Lines.Count - 1; i >= 0; i-- )
			{
				Spring.Social.Shopify.Api.Line line = obj.Lines[i];
				if ( line.DetailType == Spring.Social.Shopify.Api.LineDetailTypeEnum.SalesItemLineDetail )
				{
					if ( line.ItemRefId == "SHIPPING_ITEM_ID" )
					{
						// 03/06/2015 Paul.  We are getting blank lines in the middle of the items.  Try forcing shipping and discounts to the bottom. 
						//line.AmountValue = this.ShippingAmount;
						//bShippingFound = true;
						obj.Lines.Remove(line);
					}
					else if ( line.ItemRefName == "Shipping" || line.ItemRefName == "Sale Tax" )
					{
						// 02/19/2015 Paul.  Ignore these items. 
					}
					else if ( !lstMatched.Contains(line) )
					{
						obj.Lines.Remove(line);
					}
				}
				// 02/18/2015 Paul.  SubTotal is read-only. 
				else if ( line.DetailType == Spring.Social.Shopify.Api.LineDetailTypeEnum.SubTotalLineDetail )
				{
					obj.Lines.Remove(line);
				}
				else if ( line.DetailType == Spring.Social.Shopify.Api.LineDetailTypeEnum.DiscountLineDetail )
				{
					// 03/06/2015 Paul.  We are getting blank lines in the middle of the items.  Try forcing shipping and discounts to the bottom. 
					//line.AmountValue = this.Discount;
					//bDiscountFound = true;
					obj.Lines.Remove(line);
				}
				// 03/01/2015 Paul.  Shopify is adding a blank line when we send a record. 
				else if ( line.DetailType == Spring.Social.Shopify.Api.LineDetailTypeEnum.DescriptionOnly )
				{
					// 03/06/2015 Paul.  Remove empty lines or existing unmatched descriptions. 
					if ( line.IsEmpty() || !lstMatched.Contains(line) )
						obj.Lines.Remove(line);
				}
			}
			// DiscountLine � Holds the discount applied to the entire transaction. 
			// 03/06/2015 Paul.  The Sales Form Discounts company preference must be enabled for this type of line to be available.
			// In the Shopify Online app, select Company Settings, Sales section, Sales form content, then Discount enabled. 
			if ( !bDiscountFound && this.Discount > 0 )
			{
				if ( Sql.IsEmptyString(this.DiscountAccountId) )
					throw(new Exception("DiscountAccountId is empty.  Make sure that CRM setting Shopify.DiscountAccount is valid and that Shopify Online is enabled for discounts."));
				Spring.Social.Shopify.Api.Line line = new Spring.Social.Shopify.Api.Line();
				line.DetailType  = Spring.Social.Shopify.Api.LineDetailTypeEnum.DiscountLineDetail;
				line.Item        = new Spring.Social.Shopify.Api.DiscountLineDetail();
				line.AmountValue = this.Discount;
				(line.Item as Spring.Social.Shopify.Api.DiscountLineDetail).DiscountAccountRefValue   = this.DiscountAccountId;
				obj.Lines.Add(line);
			}
			if ( !bShippingFound && this.ShippingAmount > 0 )
			{
				Spring.Social.Shopify.Api.Line line = new Spring.Social.Shopify.Api.Line();
				line.DetailType  = Spring.Social.Shopify.Api.LineDetailTypeEnum.SalesItemLineDetail;
				line.Item        = new Spring.Social.Shopify.Api.SalesItemLineDetail();
				line.ItemRefId   = "SHIPPING_ITEM_ID";
				line.ItemRefName = "Shipping";
				line.AmountValue = this.ShippingAmount;
				obj.Lines.Add(line);
			}
			// 03/06/2015 Paul.  Renumber lines in hopes that it will remove the created blank lines. 
			int nLineNumber = 1;
			for ( int i = 0; i < obj.Lines.Count; i++ )
			{
				Spring.Social.Shopify.Api.Line line = obj.Lines[i];
				if ( line.DetailType == Spring.Social.Shopify.Api.LineDetailTypeEnum.SalesItemLineDetail )
				{
					if ( line.ItemRefId != "SHIPPING_ITEM_ID" )
					{
						line.LineNum = nLineNumber.ToString();
						nLineNumber++;
					}
				}
				else if ( line.DetailType == Spring.Social.Shopify.Api.LineDetailTypeEnum.DescriptionOnly )
				{
					line.LineNum = nLineNumber.ToString();
					nLineNumber++;
				}
				else
				{
					line.LineNum = String.Empty;
				}
			}
		}
		*/

		// 03/08/2015 Paul.  We are not going to merge line items.  Just overwrite all line items. 
		/*
		public virtual bool MergeLineItemsFromCRM(HttpContext Context, ExchangeSession Session, DataTable dtLineItems, string sSYNC_ACTION, StringBuilder sbChanges)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Shopify.VerboseStatus"]);
			bool bChanged = false;
			DataView vwLineItems = new DataView(dtLineItems);
			foreach ( LineItem oLine in this.LineItems )
			{
				if ( Sql.IsEmptyGuid(oLine.PRODUCT_TEMPLATE_ID) && !Sql.IsEmptyString(oLine.ItemRefId) )
				{
					vwItems.RowFilter = "SYNC_REMOTE_KEY = '" + oLine.ItemRefId + "'";
					if ( vwItems.Count > 0 )
					{
						oLine.PRODUCT_TEMPLATE_ID = Sql.ToGuid(vwItems[0]["SYNC_LOCAL_ID"]);
					}
				}
				vwLineItems.RowFilter = "SYNC_REMOTE_KEY = '" + oLine.ID + "'";
				if ( vwLineItems.Count > 0 )
				{
					oLine.LOCAL_ID = Sql.ToGuid(vwLineItems[0]["ID"]);
				}
				else
				{
					foreach ( DataRow row in dtLineItems.Rows )
					{
						Guid gPRODUCT_TEMPLATE_ID = Sql.ToGuid(row["PRODUCT_TEMPLATE_ID"]);
						if ( oLine.PRODUCT_TEMPLATE_ID == gPRODUCT_TEMPLATE_ID )
						{
							oLine.LOCAL_ID = Sql.ToGuid(row["ID"]);
							if ( sSYNC_ACTION.StartsWith("local") )
							{
								bChanged |= oLine.SetFromCRM(oLine.ID, row, sbChanges);
							}
							break;
						}
						else if ( oLine.ItemDescription == "Comment" &&  Sql.ToString(row["LINE_ITEM_TYPE"]) == "Comment" )
						{
							if ( Sql.ToString(oLine.ItemDescription) == Sql.ToString(row["DESCRIPTION"]) )
							{
								oLine.LOCAL_ID = Sql.ToGuid(row["ID"]);
								if ( sSYNC_ACTION.StartsWith("local") )
								{
									bChanged |= oLine.SetFromCRM(oLine.ID, row, sbChanges);
								}
								break;
							}
						}
					}
				}
			}
			if ( sSYNC_ACTION.StartsWith("local") )
			{
				// 03/03/2015 Paul.  After matching existing line, add lines not found. 
				for ( int i = 0; i < dtLineItems.Rows.Count ; i++ )
				{
					DataRow row = dtLineItems.Rows[i];
					Guid   gID                  = Sql.ToGuid  (row["ID"                 ]);
					Guid   gPRODUCT_TEMPLATE_ID = Sql.ToGuid  (row["PRODUCT_TEMPLATE_ID"]);
					string sLINE_ITEM_TYPE      = Sql.ToString(row["LINE_ITEM_TYPE"     ]);
					Guid   gASSIGNED_USER_ID    = Guid.Empty;
					bool bLineFound = false;
					foreach ( LineItem line in this.LineItems )
					{
						if ( line.LOCAL_ID == gID )
						{
							bLineFound = true;
							break;
						}
						else if ( Sql.IsEmptyGuid(line.LOCAL_ID) )
						{
							if ( sLINE_ITEM_TYPE == "Comment" )
							{
								if ( line.ItemType == "Comment" )
								{
									if ( Sql.ToString(line.ItemDescription) == Sql.ToString(row["DESCRIPTION"]) )
									{
										line.LOCAL_ID = gID;
										bLineFound = true;
										break;
									}
								}
							}
							else
							{
								vwItems.RowFilter = "SYNC_REMOTE_KEY = '" + line.ItemRefId + "'";
								if ( vwItems.Count > 0 )
								{
									if ( gPRODUCT_TEMPLATE_ID == Sql.ToGuid(vwItems[0]["SYNC_LOCAL_ID"]) )
									{
										line.LOCAL_ID = gID;
										bLineFound = true;
										bChanged |= line.SetFromCRM(line.ID, row, sbChanges);
										break;
									}
								}
							}
						}
					}
					if ( !bLineFound )
					{
						Shopify.LineItem qoli = this.CreateLineItem();
						qoli.Reset();
//#if !DEBUG
						if ( SplendidInit.bEnableACLFieldSecurity )
						{
							bool bApplyACL = false;
							foreach ( DataColumn col in dtLineItems.Columns )
							{
								Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, qoli.CRMModuleName, col.ColumnName, gASSIGNED_USER_ID);
								if ( !acl.IsReadable() )
								{
									row[col.ColumnName] = DBNull.Value;
									bApplyACL = true;
								}
							}
							if ( bApplyACL )
								dtLineItems.AcceptChanges();
						}
//#endif
						if ( bVERBOSE_STATUS )
						{
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qoli.ShopifyTableName + ".Sync: Sending new " + qoli.ShopifyTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
						}
						qoli.SetFromCRM(String.Empty, row, sbChanges);
						//qoli.ItemLineNum = (i + 1).ToString();
						this.LineItems.Add(qoli);
						bChanged = true;
					}
				}
			}
			return bChanged;
		}
		*/

		public bool CompareLineItemsFromCRM(ExchangeSession Session, DataTable dtLineItems, string sSYNC_ACTION, StringBuilder sbChanges)
		{
			bool bChanged = (this.LineItems.Count != dtLineItems.Rows.Count);
			for ( int i = 0; i < dtLineItems.Rows.Count && !bChanged; i++  )
			{
				DataRow row = dtLineItems.Rows[i];
				LineItem oLine = this.LineItems[i];
				bChanged |= oLine.CompareToCRM(row, sbChanges);
			}
			return bChanged;
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			
			Guid gBILLING_ACCOUNT_ID = Guid.Empty;
			if ( !Sql.IsEmptyString(this.CustomerId) )
			{
				vwCustomers.RowFilter = "SYNC_REMOTE_KEY = '" + this.CustomerId + "'";
				if ( vwCustomers.Count > 0 )
					gBILLING_ACCOUNT_ID = Sql.ToGuid(vwCustomers[0]["SYNC_LOCAL_ID"]);
			}
			
			Guid gTAXRATE_ID = Guid.Empty;
			if ( !Sql.IsEmptyString(this.TaxCodeTaxRate) )
			{
				// 02/26/2015 Paul.  We need to use SHOPIFY_TAX_VENDOR when setting the TaxCodeTaxRate. 
				vwTaxRates.RowFilter = "SHOPIFY_TAX_VENDOR = '" + this.TaxCodeTaxRate + "'";
				if ( vwTaxRates.Count > 0 )
					gTAXRATE_ID = Sql.ToGuid(vwTaxRates[0]["SYNC_LOCAL_ID"]);
			}
			
			// 02/13/2015 Paul.  Default to USD.  vwCurrencies will be empty if using US Shopify Online as it only supports USD. 
			// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/currency
			Guid gCURRENCY_ID = new Guid("E340202E-6291-4071-B327-A34CB4DF239B");
			if ( !Sql.IsEmptyString(this.Currency) )
			{
				vwCurrencies.RowFilter = "ISO4217 = '" + this.Currency + "'";
				if ( vwCurrencies.Count > 0 )
					gCURRENCY_ID = Sql.ToGuid(vwCurrencies[0]["ID"]);
			}
			
			Guid gSHIPPER_ID = Guid.Empty;
			if ( !Sql.IsEmptyString(this.ShipMethod) )
			{
				vwShippers.RowFilter = "SYNC_NAME = '" + this.ShipMethod + "'";
				if ( vwShippers.Count > 0 )
					gSHIPPER_ID = Sql.ToGuid(vwShippers[0]["SYNC_LOCAL_ID"]);
			}
			
			string sPAYMENT_TERMS = String.Empty;
			if ( !Sql.IsEmptyString(this.SalesTermId) )
			{
				vwPaymentTerms.RowFilter = "SYNC_REMOTE_KEY = '" + this.SalesTermId + "'";
				if ( vwPaymentTerms.Count > 0 )
					sPAYMENT_TERMS = Sql.ToString(vwPaymentTerms[0]["SYNC_NAME"]);
			}
			
			// 03/12/2015 Paul.  Shopify is combining all address fields into a single string array. 
			// We are having trouble splitting the data back into parts. 
			string sBILLING_ADDRESS_STREET      = String.Empty;
			string sBILLING_ADDRESS_CITY        = String.Empty;
			string sBILLING_ADDRESS_STATE       = String.Empty;
			string sBILLING_ADDRESS_POSTALCODE  = String.Empty;
			string sBILLING_ADDRESS_COUNTRY     = String.Empty;
			string sSHIPPING_ADDRESS_STREET     = String.Empty;
			string sSHIPPING_ADDRESS_CITY       = String.Empty;
			string sSHIPPING_ADDRESS_STATE      = String.Empty;
			string sSHIPPING_ADDRESS_POSTALCODE = String.Empty;
			string sSHIPPING_ADDRESS_COUNTRY    = String.Empty;
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
				switch ( sColumnName )
				{
					case "BILLING_ADDRESS_STREET"     :  sBILLING_ADDRESS_STREET      = Sql.ToString(par.Value);  break;
					case "BILLING_ADDRESS_CITY"       :  sBILLING_ADDRESS_CITY        = Sql.ToString(par.Value);  break;
					case "BILLING_ADDRESS_STATE"      :  sBILLING_ADDRESS_STATE       = Sql.ToString(par.Value);  break;
					case "BILLING_ADDRESS_POSTALCODE" :  sBILLING_ADDRESS_POSTALCODE  = Sql.ToString(par.Value);  break;
					case "BILLING_ADDRESS_COUNTRY"    :  sBILLING_ADDRESS_COUNTRY     = Sql.ToString(par.Value);  break;
					case "SHIPPING_ADDRESS_STREET"    :  sSHIPPING_ADDRESS_STREET     = Sql.ToString(par.Value);  break;
					case "SHIPPING_ADDRESS_CITY"      :  sSHIPPING_ADDRESS_CITY       = Sql.ToString(par.Value);  break;
					case "SHIPPING_ADDRESS_STATE"     :  sSHIPPING_ADDRESS_STATE      = Sql.ToString(par.Value);  break;
					case "SHIPPING_ADDRESS_POSTALCODE":  sSHIPPING_ADDRESS_POSTALCODE = Sql.ToString(par.Value);  break;
					case "SHIPPING_ADDRESS_COUNTRY"   :  sSHIPPING_ADDRESS_COUNTRY    = Sql.ToString(par.Value);  break;
				}
			}
			// 03/12/2015 Paul.  If the combined address does not change, then don't update. 
			bool bBillingAddressUnchanged = false;
			if ( !Sql.IsEmptyString(this.BillingRawAddress) )
			{
				StringBuilder sbBILLING_ADDRESS  = new StringBuilder();
				if ( !Sql.IsEmptyString(sBILLING_ADDRESS_STREET) )
					sbBILLING_ADDRESS.AppendLine(sBILLING_ADDRESS_STREET.Trim());
				string sCityStateZip = String.Empty;
				if ( !Sql.IsEmptyString(sBILLING_ADDRESS_CITY      ) ) sCityStateZip += sBILLING_ADDRESS_CITY;
				if ( !Sql.IsEmptyString(sBILLING_ADDRESS_STATE     ) ) sCityStateZip += ", " + sBILLING_ADDRESS_STATE;
				if ( !Sql.IsEmptyString(sBILLING_ADDRESS_POSTALCODE) ) sCityStateZip += " "  + sBILLING_ADDRESS_POSTALCODE;
				if ( !Sql.IsEmptyString(sCityStateZip) )
				{
					sbBILLING_ADDRESS.AppendLine(sCityStateZip);
				}
				if ( !Sql.IsEmptyString(sBILLING_ADDRESS_COUNTRY) ) sbBILLING_ADDRESS.AppendLine(sBILLING_ADDRESS_COUNTRY);
				bBillingAddressUnchanged = (this.BillingRawAddress.Trim().Replace("  ", " ").Replace("\r\n", "\n") == sbBILLING_ADDRESS.ToString().Trim().Replace("  ", " ").Replace("\r\n", "\n"));
			}
			bool bShippingAddressUnchanged = false;
			if ( !Sql.IsEmptyString(this.ShippingRawAddress) )
			{
				StringBuilder sbSHIPPING_ADDRESS = new StringBuilder();
				if ( !Sql.IsEmptyString(sSHIPPING_ADDRESS_STREET) )
					sbSHIPPING_ADDRESS.AppendLine(sSHIPPING_ADDRESS_STREET.Trim());
				string sCityStateZip = String.Empty;
				if ( !Sql.IsEmptyString(sSHIPPING_ADDRESS_CITY      ) ) sCityStateZip += sSHIPPING_ADDRESS_CITY;
				if ( !Sql.IsEmptyString(sSHIPPING_ADDRESS_STATE     ) ) sCityStateZip += ", " + sSHIPPING_ADDRESS_STATE;
				if ( !Sql.IsEmptyString(sSHIPPING_ADDRESS_POSTALCODE) ) sCityStateZip += " "  + sSHIPPING_ADDRESS_POSTALCODE;
				if ( !Sql.IsEmptyString(sCityStateZip) )
				{
					sbSHIPPING_ADDRESS.AppendLine(sCityStateZip);
				}
				if ( !Sql.IsEmptyString(sSHIPPING_ADDRESS_COUNTRY) ) sbSHIPPING_ADDRESS.AppendLine(sSHIPPING_ADDRESS_COUNTRY);
				bShippingAddressUnchanged = (this.ShippingRawAddress.Trim().Replace("  ", " ").Replace("\r\n", "\n") == sbSHIPPING_ADDRESS.ToString().Trim().Replace("  ", " ").Replace("\r\n", "\n"));
			}
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, this.CRMModuleName, sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "NAME"                       :  oValue = Sql.ToDBString  (this.Name                   );  break;
							case "BILLING_ACCOUNT_ID"         :  oValue = Sql.ToDBGuid    (     gBILLING_ACCOUNT_ID    );  break;
							case "CURRENCY_ID"                :
								// 03/02/2015 Paul.  Only update if Shopify value is not empty. 
								if ( !Sql.IsEmptyString(this.Currency) )
									if ( vwCurrencies.Count > 0 )
										oValue = Sql.ToDBGuid    (     gCURRENCY_ID           );
								break;
							case "DESCRIPTION"                :  oValue = Sql.ToDBString  (this.PrivateNote            );  break;
							// 03/19/2015 Paul.  TrackingNum is for shipping, not Purchase Orders. 
							//case "PURCHASE_ORDER_NUM"         :  oValue = Sql.ToDBString  (this.POnumber               );  break;
							case "PAYMENT_TERMS"              :
								// 03/02/2015 Paul.  Only update if Shopify value is not empty. 
								if ( !Sql.IsEmptyString(this.SalesTermId) )
									if ( vwPaymentTerms.Count > 0 )
										oValue = Sql.ToDBString  (     sPAYMENT_TERMS         );
								break;
							case "SHIPPER_ID"                 :
								// 03/02/2015 Paul.  Only update if Shopify value is not empty. 
								if ( !Sql.IsEmptyString(this.ShipMethod) )
									if ( vwShippers.Count > 0 )
										oValue = Sql.ToDBGuid    (     gSHIPPER_ID            );
								break;
							case "EXCHANGE_RATE"              :  oValue = Sql.ToDBDecimal (this.ExchangeRate           );  break;
							case "SUBTOTAL"                   :  oValue = Sql.ToDBDecimal (this.Subtotal               );  break;
							case "SHIPPING"                   :  oValue = Sql.ToDBDecimal (this.ShippingAmount         );  break;
							case "TAX"                        :  oValue = Sql.ToDBDecimal (this.Tax                    );  break;
							case "TOTAL"                      :  oValue = Sql.ToDBDecimal (this.TotalAmt               );  break;
							case "TAXRATE_ID"                 :
								// 03/02/2015 Paul.  Only update if Shopify value is not empty. 
								if ( !Sql.IsEmptyString(this.TaxCodeTaxRate) )
									if ( vwTaxRates.Count > 0 )
										oValue = Sql.ToDBGuid    (     gTAXRATE_ID            );
								break;
							// 03/12/2015 Paul.  If the combined address does not change, then don't update. 
							case "BILLING_ADDRESS_STREET"     :  if ( !bBillingAddressUnchanged  ) oValue = Sql.ToDBString  (this.BillingStreet          );  break;
							case "BILLING_ADDRESS_CITY"       :  if ( !bBillingAddressUnchanged  ) oValue = Sql.ToDBString  (this.BillingCity            );  break;
							case "BILLING_ADDRESS_STATE"      :  if ( !bBillingAddressUnchanged  ) oValue = Sql.ToDBString  (this.BillingState           );  break;
							case "BILLING_ADDRESS_POSTALCODE" :  if ( !bBillingAddressUnchanged  ) oValue = Sql.ToDBString  (this.BillingPostalCode      );  break;
							case "BILLING_ADDRESS_COUNTRY"    :  if ( !bBillingAddressUnchanged  ) oValue = Sql.ToDBString  (this.ShippingCountry        );  break;
							case "SHIPPING_ADDRESS_STREET"    :  if ( !bShippingAddressUnchanged ) oValue = Sql.ToDBString  (this.ShippingStreet         );  break;
							case "SHIPPING_ADDRESS_CITY"      :  if ( !bShippingAddressUnchanged ) oValue = Sql.ToDBString  (this.ShippingCity           );  break;
							case "SHIPPING_ADDRESS_STATE"     :  if ( !bShippingAddressUnchanged ) oValue = Sql.ToDBString  (this.ShippingState          );  break;
							case "SHIPPING_ADDRESS_POSTALCODE":  if ( !bShippingAddressUnchanged ) oValue = Sql.ToDBString  (this.ShippingPostalCode     );  break;
							case "SHIPPING_ADDRESS_COUNTRY"   :  if ( !bShippingAddressUnchanged ) oValue = Sql.ToDBString  (this.ShippingCountry        );  break;
							case "MODIFIED_USER_ID"           :  oValue = gUSER_ID                                      ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "NAME"                       :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "DESCRIPTION"                :  bChanged = ParameterChanged(par, oValue, 4095, sbChanges);  break;
									case "PURCHASE_ORDER_NUM"         :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "PAYMENT_TERMS"              :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "BILLING_ADDRESS_STREET"     :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "BILLING_ADDRESS_CITY"       :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "BILLING_ADDRESS_STATE"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "BILLING_ADDRESS_POSTALCODE" :  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "BILLING_ADDRESS_COUNTRY"    :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "SHIPPING_ADDRESS_STREET"    :  bChanged = ParameterChanged(par, oValue,  150, sbChanges);  break;
									case "SHIPPING_ADDRESS_CITY"      :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "SHIPPING_ADDRESS_STATE"     :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									case "SHIPPING_ADDRESS_POSTALCODE":  bChanged = ParameterChanged(par, oValue,   20, sbChanges);  break;
									case "SHIPPING_ADDRESS_COUNTRY"   :  bChanged = ParameterChanged(par, oValue,  100, sbChanges);  break;
									default                           :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
						// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}
	}
}
