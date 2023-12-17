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
using System.Diagnostics;
using SplendidCRM;

namespace Spring.Social.QuickBooks
{
	public class CreditMemo : QOrder
	{
		private SplendidError        SplendidError      ;

		#region Properties
		public Guid     INVOICE_ID                 ;
		public string   InvoiceId                  ;
		public string   PaymentsDepositAccountId   ;
		#endregion
		protected DataView vwInvoices    ;

		public CreditMemo(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.QuickBooks.Api.IQuickBooks quickBooks, DataTable dtCurrencies, DataTable dtShippers, DataTable dtTaxRates, DataTable dtItems, DataTable dtCustomers, DataTable dtInvoices, DataTable dtPaymentTerms, string sPaymentsDepositAccountId, string sDiscountAccountId, SplendidCRM.DbProviderFactory dbf, IDbConnection con, bool bShortStateName, bool bShortCountryName)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtPaymentTerms, sDiscountAccountId, dbf, con, "CreditMemos", "Payments", "CREDIT_MEMOS", "DATE_MODIFIED_UTC", false, bShortStateName, bShortCountryName)
		{
			this.SplendidError       = SplendidError      ;
			this.vwInvoices               = new DataView(dtInvoices    );
			this.PaymentsDepositAccountId = sPaymentsDepositAccountId;
		}

		public override void Reset()
		{
			base.Reset();
			this.INVOICE_ID = Guid.Empty;
			this.InvoiceId  = String.Empty;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			// 02/22/2015 Paul.  Do not call base as the fields are different from that of Invoices and Quotes. 
			//bool bChanged = base.SetFromCRM(sID, row, sbChanges);
			bool bChanged = false;
			string sInvoiceId = String.Empty;
			vwInvoices.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["INVOICE_ID"]) + "'";
			if ( vwInvoices.Count > 0 )
				sInvoiceId = Sql.ToString(vwInvoices[0]["SYNC_REMOTE_KEY"]);
			
			string sCustomerId = String.Empty;
			vwCustomers.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["ACCOUNT_ID"]) + "'";
			if ( vwCustomers.Count > 0 )
				sCustomerId = Sql.ToString(vwCustomers[0]["SYNC_REMOTE_KEY"]);
			
			string sTaxCodeTaxRate = String.Empty;
			// 02/26/2015 Paul.  We need to use QUICKBOOKS_TAX_VENDOR when setting the TaxCodeTaxRate. 
			vwTaxRates.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["TAXRATE_ID"]) + "'";
			if ( vwTaxRates.Count > 0 )
				sTaxCodeTaxRate = Sql.ToString(vwTaxRates[0]["QUICKBOOKS_TAX_VENDOR"]);
			
			this.ID         = sID;
			this.LOCAL_ID   = Sql.ToGuid(row["ID"        ]);
			this.INVOICE_ID = Sql.ToGuid(row["INVOICE_ID"]);
			if ( Sql.IsEmptyString(this.ID) )
			{
				this.Name             = Sql.ToString  (row["PAYMENT_NUM"          ]);
				this.PrivateNote      = Sql.ToString  (row["DESCRIPTION"          ]);
				this.TxnDate          = Sql.ToDateTime(row["PAYMENT_DATE"         ]).Date;
				this.CustomerId       = Sql.ToString  (sCustomerId                 );
				//this.InvoiceId        = Sql.ToString  (sInvoiceId                  );
				this.TaxCodeTaxRate   = Sql.ToString  (sTaxCodeTaxRate             );
				this.ShippingAmount   = Sql.ToDecimal (row["SHIPPING_USDOLLAR"    ]);
				this.Tax              = Sql.ToDecimal (row["TAX_USDOLLAR"         ]);
				this.TotalAmt         = Sql.ToDecimal (row["AMOUNT_USDOLLAR"      ]);
				this.Currency         = Sql.ToString  (row["CURRENCY_ISO4217"     ]);
				this.ExchangeRate     = Sql.ToDecimal (row["EXCHANGE_RATE"        ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.Name            , Sql.ToString  (row["PAYMENT_NUM"          ])      , "PAYMENT_NUM"          , sbChanges) ) { this.Name           = Sql.ToString  (row["PAYMENT_NUM"          ])      ;  bChanged = true; }
				if ( Compare(this.PrivateNote     , Sql.ToString  (row["DESCRIPTION"          ])      , "DESCRIPTION"          , sbChanges) ) { this.PrivateNote    = Sql.ToString  (row["DESCRIPTION"          ])      ;  bChanged = true; }
				if ( Compare(this.TxnDate         , Sql.ToDateTime(row["PAYMENT_DATE"         ]).Date , "PAYMENT_DATE"         , sbChanges) ) { this.TxnDate        = Sql.ToDateTime(row["PAYMENT_DATE"         ]).Date ;  bChanged = true; }
				if ( Compare(this.CustomerId      , Sql.ToString  (sCustomerId                 )      , "ACCOUNT_ID"           , sbChanges) ) { this.CustomerId     = Sql.ToString  (sCustomerId                 )      ;  bChanged = true; }
				//if ( Compare(this.InvoiceId       , Sql.ToString  (sInvoiceId                  )      , "INVOICE_ID"           , sbChanges) ) { this.InvoiceId      = Sql.ToString  (sInvoiceId                  )      ;  bChanged = true; }
				if ( Compare(this.TaxCodeTaxRate  , Sql.ToString  (sTaxCodeTaxRate             )      , "TAXRATE_ID"           , sbChanges) ) { this.TaxCodeTaxRate = Sql.ToString  (sTaxCodeTaxRate             )      ;  bChanged = true; }
				if ( Compare(this.ShippingAmount  , Sql.ToDecimal (row["SHIPPING_USDOLLAR"    ])      , "SHIPPING_USDOLLAR"    , sbChanges) ) { this.ShippingAmount = Sql.ToDecimal (row["SHIPPING_USDOLLAR"    ])      ;  bChanged = true; }
				if ( Compare(this.Tax             , Sql.ToDecimal (row["TAX_USDOLLAR"         ])      , "TAX_USDOLLAR"         , sbChanges) ) { this.Tax            = Sql.ToDecimal (row["TAX_USDOLLAR"         ])      ;  bChanged = true; }
				if ( Compare(this.TotalAmt        , Sql.ToDecimal (row["AMOUNT_USDOLLAR"      ])      , "AMOUNT_USDOLLAR"      , sbChanges) ) { this.TotalAmt       = Sql.ToDecimal (row["AMOUNT_USDOLLAR"      ])      ;  bChanged = true; }
				if ( Compare(this.Currency        , Sql.ToString  (row["CURRENCY_ISO4217"     ])      , "CURRENCY_ISO4217"     , sbChanges) ) { this.Currency       = Sql.ToString  (row["CURRENCY_ISO4217"     ])      ;  bChanged = true; }
				if ( Compare(this.ExchangeRate    , Sql.ToDecimal (row["EXCHANGE_RATE"        ])      , "EXCHANGE_RATE"        , sbChanges) ) { this.ExchangeRate   = Sql.ToDecimal (row["EXCHANGE_RATE"        ])      ;  bChanged = true; }
			}
			this.InvoiceId = sInvoiceId;
			return bChanged;
		}

		public override DataTable GetLineItemsFromCRM(ExchangeSession Session, IDbConnection con, Guid gUSER_ID, bool bRequireItems)
		{
			DataTable dt = new DataTable();
			QuickBooks.InvoiceLineItem qoli = new QuickBooks.InvoiceLineItem(this.Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, vwItems.Table, this.INVOICE_ID, this.ID);
			string sSQL = String.Empty;
			sSQL = "select vw" + qoli.CRMTableName + ".*                                                                            " + ControlChars.CrLf
			     + "     , vw" + qoli.CRMTableName + "_SYNC.SYNC_ID                                                                 " + ControlChars.CrLf
			     + "     , vw" + qoli.CRMTableName + "_SYNC.SYNC_REMOTE_KEY                                                         " + ControlChars.CrLf
			     + "     , vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                            " + ControlChars.CrLf
			     + "     , vw" + qoli.CRMTableName + "_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                           " + ControlChars.CrLf
			     + "  from            " + Sql.MetadataName(con, "vw" + qoli.CRMTableName + "_QBOnline") + "  vw" + qoli.CRMTableName  + ControlChars.CrLf
			     + "  left outer join vw" + qoli.CRMTableName + "_SYNC                                                              " + ControlChars.CrLf
			     + "               on vw" + qoli.CRMTableName + "_SYNC.SYNC_SERVICE_NAME     = N'QuickBooksOnline'                  " + ControlChars.CrLf
			     + "              and vw" + qoli.CRMTableName + "_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID               " + ControlChars.CrLf
			     + "              and vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_ID         = vw" + qoli.CRMTableName + ".ID       " + ControlChars.CrLf
			     + " where vw" + qoli.CRMTableName + "." + qoli.CRMParentFieldName + " = @ID                                        " + ControlChars.CrLf
			     + " order by vw" + qoli.CRMTableName + "." + qoli.CRMTableSort + "                                                 " + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID       );
				Sql.AddParameter(cmd, "@ID"                   , this.INVOICE_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			if ( bRequireItems && !Sql.IsEmptyGuid(this.INVOICE_ID) && dt.Rows.Count == 0 )
			{
				throw(new Exception("CreditMemo/Payment " + this.INVOICE_ID.ToString() + " does not have any valid line items"));
			}
			return dt;
		}

		public override void SetLineItemsFromCRM(ExchangeSession Session, IDbConnection con, Guid gUSER_ID, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.QuickBooks.VerboseStatus"]);
			try
			{
				this.LineItems = new List<QuickBooks.LineItem>();
				
				using ( DataTable dt = GetLineItemsFromCRM(Session, con, gUSER_ID, true) )
				{
					for ( int i = 0; i < dt.Rows.Count ; i++ )
					{
						QuickBooks.InvoiceLineItem qoli = new QuickBooks.InvoiceLineItem(this.Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, vwItems.Table, this.INVOICE_ID, this.ID);
						qoli.Reset();
						
						DataRow row = dt.Rows[i];
						Guid     gID                             = Sql.ToGuid    (row["ID"                           ]);
						Guid     gASSIGNED_USER_ID               = Guid.Empty;
						Guid     gSYNC_ID                        = Sql.ToGuid    (row["SYNC_ID"                      ]);
						string   sSYNC_REMOTE_KEY                = Sql.ToString  (row["SYNC_REMOTE_KEY"              ]);
						DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
						DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
						DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
						string   sSYNC_ACTION                    = Sql.IsEmptyGuid(gSYNC_ID) ? "local new" : "local changed";
#if !DEBUG
						if ( SplendidInit.bEnableACLFieldSecurity )
						{
							bool bApplyACL = false;
							foreach ( DataColumn col in dt.Columns )
							{
								Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, qoli.CRMModuleName, col.ColumnName, gASSIGNED_USER_ID);
								if ( !acl.IsReadable() )
								{
									row[col.ColumnName] = DBNull.Value;
									bApplyACL = true;
								}
							}
							if ( bApplyACL )
								dt.AcceptChanges();
						}
#endif
						if ( bVERBOSE_STATUS )
						{
							if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qoli.QuickBooksTableName + ".Sync: Sending new " + qoli.QuickBooksTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
							else
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qoli.QuickBooksTableName + ".Sync: Binding " + qoli.QuickBooksTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
						}
						qoli.SetFromCRM(sSYNC_REMOTE_KEY, row, sbErrors);
						qoli.ItemLineNum = (i + 1).ToString();
						this.LineItems.Add(qoli);
					}
				}
			}
			catch(Exception ex)
			{
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				sbErrors.AppendLine(Utils.ExpandException(ex));
				throw;
			}
		}

		public override void SetFromQuickBooks(string sId)
		{
			this.Reset();
			Spring.Social.QuickBooks.Api.CreditMemo obj = this.quickBooks.CreditMemoOperations.GetById(sId);
			this.RawContent     =      obj.RawContent        ;
			this.ID             =      obj.Id                ;
			this.TimeCreated    =      obj.TimeCreated       ;
			this.TimeModified   =      obj.TimeModified      ;
			this.DocNumber      =      obj.DocNumber         ;
			this.TxnDate        =      obj.TxnDateValue      ;
			this.ExchangeRate   =      obj.ExchangeRateValue ;
			// 02/22/2015 Paul.  The CRM uses a negative value and QuickBooks uses a positive value. 
			this.TotalAmt       = -1 * obj.TotalAmtValue     ;
			this.PrivateNote    =      obj.PrivateNote       ;
			this.SalesTermId    =      obj.SalesTermRefValue ;
			this.Currency       =      obj.CurrencyRefValue  ;
			this.Tax            =      obj.TxnTaxDetailValue ;
			this.TaxCodeTaxRate =      obj.TxnTaxCodeTaxRate ;
			this.CustomerId     =      obj.CustomerRefValue  ;
			this.Name           =      obj.CustomerMemoValue ;
			//this.InvoiceId      =      obj.InvoiceRefValue   ;
			SetAddressFromQuickBooks(obj.BillAddr, this.ShortStateName, this.ShortCountryName, ref this.BillingStreet , ref this.BillingCity , ref this.BillingState , ref this.BillingPostalCode , ref this.BillingCountry , ref this.BillingRawAddress );
			SetAddressFromQuickBooks(obj.ShipAddr, this.ShortStateName, this.ShortCountryName, ref this.ShippingStreet, ref this.ShippingCity, ref this.ShippingState, ref this.ShippingPostalCode, ref this.ShippingCountry, ref this.ShippingRawAddress);
			foreach ( Spring.Social.QuickBooks.Api.Line line in obj.Lines )
			{
				if ( line.DetailType == Spring.Social.QuickBooks.Api.LineDetailTypeEnum.SalesItemLineDetail && line.Item is Spring.Social.QuickBooks.Api.SalesItemLineDetail )
				{
					if ( line.ItemRefId == "SHIPPING_ITEM_ID" )
					{
						this.ShippingAmount = line.AmountValue;
					}
					else if ( line.ItemRefName == "Shipping" || line.ItemRefName == "Sale Tax" )
					{
						// 02/19/2015 Paul.  Ignore these items. 
					}
					else
					{
						InvoiceLineItem oLine = new InvoiceLineItem(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, this.vwItems.Table, this.LOCAL_ID, this.ID);
						oLine.RawContent            = line.RawContent ;
						oLine.ID                    = line.Id         ;
						oLine.ItemLineNum           = line.LineNum    ;
						oLine.ItemRefId             = line.ItemRefId  ;
						oLine.ItemName              = line.Description;
						oLine.ItemPartNumber        = line.ItemRefName;
						oLine.ItemTaxCode           = line.TaxCode    ;
						oLine.ItemQuantity          = line.Quantity   ;
						oLine.ItemRate              = line.UnitPrice  ;
						oLine.ItemAmount            = line.AmountValue;
						
						vwItems.RowFilter = "SYNC_REMOTE_KEY = '" + oLine.ItemRefId + "'";
						if ( vwItems.Count > 0 )
							oLine.PRODUCT_TEMPLATE_ID = Sql.ToGuid(vwItems[0]["SYNC_LOCAL_ID"]);
						this.LineItems.Add(oLine);
					}
				}
				else if ( line.DetailType == Spring.Social.QuickBooks.Api.LineDetailTypeEnum.SubTotalLineDetail && line.Item is Spring.Social.QuickBooks.Api.SubTotalLineDetail )
				{
					this.Subtotal = line.AmountValue;
				}
				else if ( line.DetailType == Spring.Social.QuickBooks.Api.LineDetailTypeEnum.DescriptionOnly )
				{
					InvoiceLineItem oLine = new InvoiceLineItem(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, this.vwItems.Table, this.LOCAL_ID, this.ID);
					oLine.RawContent            = line.RawContent ;
					oLine.ID                    = line.Id         ;
					oLine.ItemLineNum           = line.LineNum    ;
					oLine.ItemDescription       = line.Description;
					oLine.ItemType              = "Comment"       ;
					this.LineItems.Add(oLine);
				}
			}
		}

		private Spring.Social.QuickBooks.Api.Payment FindPaymentId()
		{
			IList<Spring.Social.QuickBooks.Api.Payment> lstPayments = this.quickBooks.PaymentOperations.GetAll("CustomerRef = \'" + this.CustomerId + "\'", String.Empty);
			foreach ( Spring.Social.QuickBooks.Api.Payment payment in lstPayments )
			{
				if ( payment.Lines != null )
				{
					foreach ( Spring.Social.QuickBooks.Api.Line line in payment.Lines )
					{
						if ( line.LinkedTxn != null )
						{
							foreach ( Spring.Social.QuickBooks.Api.LinkedTxn link in line.LinkedTxn )
							{
								if ( link.TxnType.Value == Api.TxnTypeEnum.Invoice && link.TxnId == this.InvoiceId )
								{
									return payment;
								}
							}
						}
					}
				}
			}
			return null;
		}

		private void LinkToPayment(Spring.Social.QuickBooks.Api.Payment payment)
		{
			try
			{
				if ( payment != null )
				{
					bool bFoundCreditMemo = false;
					if ( payment.Lines != null )
					{
						foreach ( Spring.Social.QuickBooks.Api.Line line in payment.Lines )
						{
							if ( line.LinkedTxn != null )
							{
								foreach ( Spring.Social.QuickBooks.Api.LinkedTxn link in line.LinkedTxn )
								{
									if ( link.TxnType.Value == Api.TxnTypeEnum.CreditMemo && link.TxnId == this.ID )
									{
										line.AmountValue = -this.TotalAmt;
										bFoundCreditMemo = true;
									}
								}
							}
						}
					}
					if ( !bFoundCreditMemo )
					{
						if ( payment.Lines == null )
							payment.Lines = new List<Spring.Social.QuickBooks.Api.Line>();
						Spring.Social.QuickBooks.Api.Line line = new Spring.Social.QuickBooks.Api.Line();
						line.AmountValue = -this.TotalAmt;
						line.LinkedTxn   = new List<Spring.Social.QuickBooks.Api.LinkedTxn>();
						line.LinkedTxn.Add(new Spring.Social.QuickBooks.Api.LinkedTxn());
						line.LinkedTxn[0].TxnId   = this.ID;
						line.LinkedTxn[0].TxnType = Spring.Social.QuickBooks.Api.TxnTypeEnum.CreditMemo;
						line.LineNum     = (payment.Lines.Count + 1).ToString();
						payment.Lines.Add(line);
					}
					decimal dTotal = 0;
					foreach ( Spring.Social.QuickBooks.Api.Line line in payment.Lines )
					{
						if ( line.LinkedTxn != null )
						{
							foreach ( Spring.Social.QuickBooks.Api.LinkedTxn link in line.LinkedTxn )
							{
								if ( link.TxnType.Value == Api.TxnTypeEnum.Invoice )
									dTotal += line.AmountValue;
								else if ( link.TxnType.Value == Api.TxnTypeEnum.CreditMemo )
									dTotal -= line.AmountValue;
							}
						}
					}
					// 03/03/2015 Paul.  Attaching a credit memo is clearing the deposit account. 
					if ( Sql.IsEmptyString(payment.DepositToAccountRefValue) )
						payment.DepositToAccountRefValue = this.PaymentsDepositAccountId;
					payment.TotalAmtValue = dTotal;
					this.quickBooks.PaymentOperations.Update(payment);
				}
			}
			catch(Exception ex)
			{
				Debug.WriteLine(ex.Message);
			}
		}

		public override void Update()
		{
			Spring.Social.QuickBooks.Api.Payment payment = FindPaymentId();
			
			Spring.Social.QuickBooks.Api.CreditMemo obj = this.quickBooks.CreditMemoOperations.GetById(this.ID);
			obj.Id                    =      this.ID                ;
			obj.DocNumber             =      this.DocNumber         ;
			obj.TxnDateValue          =      this.TxnDate           ;
			// 02/22/2015 Paul.  The CRM uses a negative value and QuickBooks uses a positive value. 
			obj.TotalAmtValue         = -1 * this.TotalAmt          ;
			obj.PrivateNote           = Sql.Truncate(this.PrivateNote, 4000);
			//obj.ShipDateValue         = this.ShipDate               ;
			if ( this.Discount > 0 )
				obj.ApplyTaxAfterDiscount = true;
			//obj.ExpirationDateValue   = this.ExpirationDate         ;
			//obj.AcceptedBy            = this.AcceptedBy             ;
			//obj.AcceptedDate          = this.AcceptedDate           ;
			obj.TxnTaxDetailValue     = this.Tax                    ;
			obj.TxnTaxCodeTaxRate     = this.TaxCodeTaxRate         ;
			obj.CustomerRefValue      = this.CustomerId             ;
			obj.CustomerMemoValue     = this.Name                   ;
			//obj.InvoiceRefValue       = this.InvoiceId              ;
			//obj.DepartmentRefValue    = this.Department             ;
			//obj.ClassRefValue         = this.Class                  ;
			obj.SalesTermRefValue     = this.SalesTermId            ;
			//obj.ShipMethodRefValue    = this.ShipMethod             ;
			//obj.GlobalTaxCalculation  = this.GlobalTaxCalculation   ;
			//obj.PrintStatus           = this.PrintStatus            ;
			//obj.EmailStatus           = this.EmailStatus            ;
			//obj.BillEmailValue        = this.BillEmail              ;
			// 02/13/2015 Paul.  Default to USD.  vwCurrencies will be empty if using US QuickBooks Online as it only supports USD. 
			// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/currency
			if ( vwCurrencies.Table.Rows.Count > 0 )
			{
				obj.ExchangeRateValue     = this.ExchangeRate      ;
				obj.CurrencyRefValue      = this.Currency          ;
			}
			obj.SetBillAddr(this.BillingStreet , this.BillingCity , this.BillingState , this.BillingPostalCode , this.BillingCountry );
			obj.SetShipAddr(this.ShippingStreet, this.ShippingCity, this.ShippingState, this.ShippingPostalCode, this.ShippingCountry);
			
			// 03/08/2015 Paul.  We are not going to merge line items.  Just overwrite all line items. 
			SetLineItemsFromCRM(obj);
			obj = this.quickBooks.CreditMemoOperations.Update(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
			// 03/03/2015 Paul.  After creating the credit memo, attach to matching payment. 
			if ( payment != null )
				LinkToPayment(payment);
		}

		public override string Insert()
		{
			this.ID = String.Empty;
			
			Spring.Social.QuickBooks.Api.Payment payment = FindPaymentId();
			
			Spring.Social.QuickBooks.Api.CreditMemo obj = new Spring.Social.QuickBooks.Api.CreditMemo();
			obj.Id                    =      this.ID                ;
			obj.DocNumber             =      this.DocNumber         ;
			obj.TxnDateValue          =      this.TxnDate           ;
			// 02/22/2015 Paul.  The CRM uses a negative value and QuickBooks uses a positive value. 
			obj.TotalAmtValue         = -1 * this.TotalAmt          ;
			obj.PrivateNote           = Sql.Truncate(this.PrivateNote, 4000);
			//obj.ShipDateValue         = this.ShipDate               ;
			if ( this.Discount > 0 )
				obj.ApplyTaxAfterDiscount = true;
			//obj.ExpirationDateValue   = this.ExpirationDate         ;
			//obj.AcceptedBy            = this.AcceptedBy             ;
			//obj.AcceptedDate          = this.AcceptedDate           ;
			obj.TxnTaxDetailValue     = this.Tax                    ;
			obj.TxnTaxCodeTaxRate     = this.TaxCodeTaxRate         ;
			obj.CustomerRefValue      = this.CustomerId             ;
			obj.CustomerMemoValue     = this.Name                   ;
			//obj.InvoiceRefValue       = this.InvoiceId              ;
			//obj.DepartmentRefValue    = this.Department             ;
			//obj.ClassRefValue         = this.Class                  ;
			obj.SalesTermRefValue     = this.SalesTermId            ;
			//obj.ShipMethodRefValue    = this.ShipMethod             ;
			//obj.GlobalTaxCalculation  = this.GlobalTaxCalculation   ;
			//obj.PrintStatus           = this.PrintStatus            ;
			//obj.EmailStatus           = this.EmailStatus            ;
			//obj.BillEmailValue        = this.BillEmail              ;
			// 02/13/2015 Paul.  Default to USD.  vwCurrencies will be empty if using US QuickBooks Online as it only supports USD. 
			// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/currency
			if ( vwCurrencies.Table.Rows.Count > 0 )
			{
				obj.ExchangeRateValue     = this.ExchangeRate      ;
				obj.CurrencyRefValue      = this.Currency          ;
			}
			obj.SetBillAddr(this.BillingStreet , this.BillingCity , this.BillingState , this.BillingPostalCode , this.BillingCountry );
			obj.SetShipAddr(this.ShippingStreet, this.ShippingCity, this.ShippingState, this.ShippingPostalCode, this.ShippingCountry);
			
			// 03/08/2015 Paul.  We are not going to merge line items.  Just overwrite all line items. 
			SetLineItemsFromCRM(obj);
			obj = this.quickBooks.CreditMemoOperations.Insert(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
			// 03/03/2015 Paul.  After creating the credit memo, attach to matching payment. 
			if ( payment != null )
				LinkToPayment(payment);
			return this.ID;
		}

		public override void Delete()
		{
			this.quickBooks.CreditMemoOperations.Delete(this.ID);
		}

		public override void Get(string sID)
		{
			IList<Spring.Social.QuickBooks.Api.CreditMemo> lst = this.quickBooks.CreditMemoOperations.GetAll("Id = '" + sID + "'", String.Empty);
			if ( lst.Count > 0 )
			{
				this.SetFromQuickBooks(lst[0].Id);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.QuickBooks.Api.QBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.QuickBooks.Api.QBase> lst = this.quickBooks.CreditMemoOperations.GetModified(dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			Sql.AppendParameter(cmd, Sql.ToString(this.DocNumber), "PAYMENT_NUM");
			Guid gBILLING_ACCOUNT_ID = Guid.Empty;
			if ( !Sql.IsEmptyString(this.CustomerId) )
			{
				vwCustomers.RowFilter = "SYNC_REMOTE_KEY = '" + this.CustomerId + "'";
				if ( vwCustomers.Count > 0 )
				{
					gBILLING_ACCOUNT_ID = Sql.ToGuid(vwCustomers[0]["SYNC_LOCAL_ID"]);
					Sql.AppendParameter(cmd, gBILLING_ACCOUNT_ID, "ACCOUNT_ID");
				}
			}
		}

		// 02/03/2015 Paul.  It would be helpful to track changes. 
		public override bool BuildUpdateProcedure(ExchangeSession Session, IDbCommand spUpdate, DataRow row, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, IDbTransaction trn, StringBuilder sbChanges)
		{
			bool bChanged = base.BuildUpdateProcedure(Session, spUpdate, row, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID, trn, sbChanges);
			
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
							case "PAYMENT_NUM"                :  oValue = Sql.ToDBString  (this.DocNumber              );  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						if ( oValue != null )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "PAYMENT_NUM"                :  bChanged = ParameterChanged(par, oValue,   21, sbChanges);  break;
									// 02/10/2014 Paul.  Need to include the default change test. 
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

		public override void ProcedureUpdated(Guid gID, string sREMOTE_KEY, IDbTransaction trn, Guid gUSER_ID)
		{
			vwInvoices.RowFilter = "SYNC_REMOTE_KEY = '" + this.InvoiceId + "'";
			if ( vwInvoices.Count > 0 )
			{
				Guid gINVOICE_ID = Sql.ToGuid(vwInvoices[0]["SYNC_LOCAL_ID"]);
				
				IDbCommand cmdINVOICES_PAYMENTS_Update = SqlProcs.Factory(trn.Connection, "spINVOICES_PAYMENTS_Update");
				foreach(IDbDataParameter par in cmdINVOICES_PAYMENTS_Update.Parameters)
				{
					par.Value = DBNull.Value;
				}
				cmdINVOICES_PAYMENTS_Update.Transaction = trn;
				Sql.SetParameter(cmdINVOICES_PAYMENTS_Update, "@MODIFIED_USER_ID", gUSER_ID     );
				Sql.SetParameter(cmdINVOICES_PAYMENTS_Update, "@INVOICE_ID"      , gINVOICE_ID  );
				Sql.SetParameter(cmdINVOICES_PAYMENTS_Update, "@PAYMENT_ID"      , gID          );
				Sql.SetParameter(cmdINVOICES_PAYMENTS_Update, "@AMOUNT"          , this.TotalAmt);
				cmdINVOICES_PAYMENTS_Update.ExecuteNonQuery();
			}
		}
	}
}
