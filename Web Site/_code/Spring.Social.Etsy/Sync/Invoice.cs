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

namespace Spring.Social.Etsy
{
	public class Invoice : QOrder
	{
		private SplendidError        SplendidError      ;

		#region Properties
		public DateTime DueDate                    ;
		public DateTime ShipDate                   ;
		public Decimal  Balance                    ;
		#endregion

		public Invoice(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.Etsy.Api.IEtsy shopify, DataTable dtCurrencies, DataTable dtShippers, DataTable dtTaxRates, DataTable dtItems, DataTable dtCustomers, DataTable dtPaymentTerms, string sDiscountAccountId, SplendidCRM.DbProviderFactory dbf, IDbConnection con, bool bShortStateName, bool bShortCountryName)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, shopify, dtCurrencies, dtShippers, dtTaxRates, dtItems, dtCustomers, dtPaymentTerms, sDiscountAccountId, dbf, con, "Invoices", "Invoices", "INVOICES", "DATE_MODIFIED_UTC", true, bShortStateName, bShortCountryName)
		{
			this.SplendidError       = SplendidError      ;
		}

		public override void Reset()
		{
			base.Reset();
			this.DueDate   = DateTime.MinValue;
			this.ShipDate  = DateTime.MinValue;
			this.Balance   = 0;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = base.SetFromCRM(sID, row, sbChanges);
			
			if ( Sql.IsEmptyString(this.ID) )
			{
				this.DocNumber          = Sql.ToString  (row["INVOICE_NUM"                ]);
				this.DueDate            = Sql.ToDateTime(row["DUE_DATE"                   ]).Date;
				this.ShipDate           = Sql.ToDateTime(row["SHIP_DATE"                  ]).Date;
				// 03/11/2015 Paul.  Balance/AMOUNT_DUE is managed differently, so it does not make sense to sync. 
				//this.Balance            = Sql.ToDecimal (row["AMOUNT_DUE_USDOLLAR"        ]);
			}
			else
			{
				// 03/09/2015 Paul.  Etsy is truncating the DateTime to just a date.  Do not treat that as a change event. 
				if ( Compare(this.DocNumber         , row["INVOICE_NUM"             ]      , "INVOICE_NUM"                , sbChanges) ) { this.DocNumber          = Sql.ToString  (row["INVOICE_NUM"           ])     ;  bChanged = true; }
				if ( Compare(this.DueDate           , Sql.ToDateTime(row["DUE_DATE" ]).Date, "DUE_DATE"                   , sbChanges) ) { this.DueDate            = Sql.ToDateTime(row["DUE_DATE"              ]).Date;  bChanged = true; }
				if ( Compare(this.ShipDate          , Sql.ToDateTime(row["SHIP_DATE"]).Date, "SHIP_DATE"                  , sbChanges) ) { this.ShipDate           = Sql.ToDateTime(row["SHIP_DATE"             ]).Date;  bChanged = true; }
				// 03/11/2015 Paul.  Balance/AMOUNT_DUE is managed differently, so it does not make sense to sync. 
				//if ( Compare(this.Balance           , row["AMOUNT_DUE_USDOLLAR"     ]      , "AMOUNT_DUE_USDOLLAR"        , sbChanges) ) { this.Balance            = Sql.ToDecimal (row["AMOUNT_DUE_USDOLLAR"   ])     ;  bChanged = true; }
			}
			return bChanged;
		}

		public override DataTable GetLineItemsFromCRM(ExchangeSession Session, IDbConnection con, Guid gUSER_ID, bool bRequireItems)
		{
			DataTable dt = new DataTable();
			Etsy.InvoiceLineItem qoli = new Etsy.InvoiceLineItem(this.Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, shopify, vwItems.Table, this.LOCAL_ID, this.ID);
			string sSQL = String.Empty;
			sSQL = "select vw" + qoli.CRMTableName + ".*                                                                            " + ControlChars.CrLf
			     + "     , vw" + qoli.CRMTableName + "_SYNC.SYNC_ID                                                                 " + ControlChars.CrLf
			     + "     , vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_ID                                                           " + ControlChars.CrLf
			     + "     , vw" + qoli.CRMTableName + "_SYNC.SYNC_REMOTE_KEY                                                         " + ControlChars.CrLf
			     + "     , vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                            " + ControlChars.CrLf
			     + "     , vw" + qoli.CRMTableName + "_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                           " + ControlChars.CrLf
			     + "  from            " + Sql.MetadataName(con, "vw" + qoli.CRMTableName + "_QBOnline") + "  vw" + qoli.CRMTableName  + ControlChars.CrLf
			     + "  left outer join vw" + qoli.CRMTableName + "_SYNC                                                              " + ControlChars.CrLf
			     + "               on vw" + qoli.CRMTableName + "_SYNC.SYNC_SERVICE_NAME     = N'EtsyOnline'                  " + ControlChars.CrLf
			     + "              and vw" + qoli.CRMTableName + "_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID               " + ControlChars.CrLf
			     + "              and vw" + qoli.CRMTableName + "_SYNC.SYNC_LOCAL_ID         = vw" + qoli.CRMTableName + ".ID       " + ControlChars.CrLf
			     + " where vw" + qoli.CRMTableName + "." + qoli.CRMParentFieldName + " = @ID                                        " + ControlChars.CrLf
			     + " order by vw" + qoli.CRMTableName + "." + qoli.CRMTableSort + "                                                 " + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID     );
				Sql.AddParameter(cmd, "@ID"                   , this.LOCAL_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			if ( bRequireItems && !Sql.IsEmptyGuid(this.LOCAL_ID) && dt.Rows.Count == 0 )
			{
				throw(new Exception("Invoice " + this.LOCAL_ID.ToString() + " does not have any valid line items"));
			}
			return dt;
		}

		public override void SetLineItemsFromCRM(ExchangeSession Session, IDbConnection con, Guid gUSER_ID, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Etsy.VerboseStatus"]);
			try
			{
				this.LineItems = new List<Etsy.LineItem>();
				
				using ( DataTable dt = GetLineItemsFromCRM(Session, con, gUSER_ID, true) )
				{
					for ( int i = 0; i < dt.Rows.Count ; i++ )
					{
						Etsy.InvoiceLineItem qoli = new Etsy.InvoiceLineItem(this.Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, shopify, vwItems.Table, this.LOCAL_ID, this.ID);
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
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qoli.EtsyTableName + ".Sync: Sending new " + qoli.EtsyTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
							else
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qoli.EtsyTableName + ".Sync: Binding " + qoli.EtsyTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
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

		public override LineItem CreateLineItem()
		{
			return new Etsy.InvoiceLineItem(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, shopify, this.Items, Guid.Empty, String.Empty);
		}

		public override void SetFromEtsy(string sId)
		{
			this.Reset();
			Spring.Social.Etsy.Api.Order obj = this.shopify.OrderOperations.GetById(sId);
			this.RawContent     = obj.RawContent        ;
			this.ID             = obj.Id                ;
			this.TimeCreated    = obj.TimeCreated       ;
			this.TimeModified   = obj.TimeModified      ;
			/*
			this.DocNumber      = obj.DocNumber         ;
			this.DueDate        = obj.DueDateValue      ;
			this.ShipDate       = obj.ShipDateValue     ;
			this.TxnDate        = obj.TxnDateValue      ;
			this.ExchangeRate   = obj.ExchangeRateValue ;
			this.TotalAmt       = obj.TotalAmtValue     ;
			this.Balance        = obj.BalanceValue      ;
			this.PrivateNote    = obj.PrivateNote       ;
			this.SalesTermId    = obj.SalesTermRefValue ;
			this.Currency       = obj.CurrencyRefValue  ;
			this.Tax            = obj.TxnTaxDetailValue ;
			this.TaxCodeTaxRate = obj.TxnTaxCodeTaxRate ;
			this.CustomerId     = obj.CustomerRefValue  ;
			this.Name           = obj.CustomerMemoValue ;
			this.ShipMethod     = obj.ShipMethodRefValue;
			*/
			SetAddressFromEtsy(obj.billingAddress, this.ShortStateName, this.ShortCountryName, ref this.BillingStreet , ref this.BillingCity , ref this.BillingState , ref this.BillingPostalCode , ref this.BillingCountry , ref this.BillingRawAddress );
			SetAddressFromEtsy(obj.shippingAddress, this.ShortStateName, this.ShortCountryName, ref this.ShippingStreet, ref this.ShippingCity, ref this.ShippingState, ref this.ShippingPostalCode, ref this.ShippingCountry, ref this.ShippingRawAddress);
			foreach ( Spring.Social.Etsy.Api.LineItem line in obj.lineItems )
			{
			}
		}

		public override void Update()
		{
			Spring.Social.Etsy.Api.Order obj = this.shopify.OrderOperations.GetById(this.ID);
			obj.Id                    = this.ID                ;
			/*
			obj.DocNumber             = this.DocNumber         ;
			obj.DueDateValue          = this.DueDate           ;
			obj.ShipDateValue         = this.ShipDate          ;
			obj.TxnDateValue          = this.TxnDate           ;
			obj.BalanceValue          = this.Balance           ;
			obj.TotalAmtValue         = this.TotalAmt          ;
			obj.PrivateNote           = Sql.Truncate(this.PrivateNote, 4000);
			if ( this.Discount > 0 )
				obj.ApplyTaxAfterDiscount = true;
			//obj.ExpirationDateValue   = this.ExpirationDate         ;
			//obj.AcceptedBy            = this.AcceptedBy             ;
			//obj.AcceptedDate          = this.AcceptedDate           ;
			obj.TxnTaxDetailValue     = this.Tax                    ;
			obj.TxnTaxCodeTaxRate     = this.TaxCodeTaxRate         ;
			obj.CustomerRefValue      = this.CustomerId             ;
			obj.CustomerMemoValue     = this.Name                   ;
			//obj.DepartmentRefValue    = this.Department             ;
			//obj.ClassRefValue         = this.Class                  ;
			// 02/19/2015 Paul.  "Due on Receipt" caused bad request error. 
			obj.SalesTermRefValue     = this.SalesTermId            ;
			obj.ShipMethodRefValue    = this.ShipMethod             ;
			// 03/12/2015 Paul.  TrackingNum is for shipping, not Purchase Orders. 
			//obj.TrackingNum           = this.POnumber               ;
			//obj.GlobalTaxCalculation  = this.GlobalTaxCalculation   ;
			//obj.PrintStatus           = this.PrintStatus            ;
			//obj.EmailStatus           = this.EmailStatus            ;
			//obj.BillEmailValue        = this.BillEmail              ;
			// 02/13/2015 Paul.  Default to USD.  vwCurrencies will be empty if using US Etsy Online as it only supports USD. 
			// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/currency
			if ( vwCurrencies.Table.Rows.Count > 0 )
			{
				obj.ExchangeRateValue     = this.ExchangeRate      ;
				obj.CurrencyRefValue      = this.Currency          ;
			}
			obj.SetBillAddr(this.BillingStreet , this.BillingCity , this.BillingState , this.BillingPostalCode , this.BillingCountry );
			obj.SetShipAddr(this.ShippingStreet, this.ShippingCity, this.ShippingState, this.ShippingPostalCode, this.ShippingCountry);
			*/
			
			// 03/08/2015 Paul.  We are not going to merge line items.  Just overwrite all line items. 
			SetLineItemsFromCRM(obj);
			obj = this.shopify.OrderOperations.Update(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.TimeModified;
			foreach ( Spring.Social.Etsy.Api.LineItem line in obj.lineItems )
			{
			}
		}

		public override string Insert()
		{
			this.ID = String.Empty;
			
			Spring.Social.Etsy.Api.Order obj = new Spring.Social.Etsy.Api.Order();
			obj.Id                    = this.ID                ;
			/*
			obj.DocNumber             = this.DocNumber         ;
			obj.DueDateValue          = this.DueDate           ;
			obj.ShipDateValue         = this.ShipDate          ;
			obj.TxnDateValue          = this.TxnDate           ;
			obj.BalanceValue          = this.Balance           ;
			obj.TotalAmtValue         = this.TotalAmt          ;
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
			//obj.DepartmentRefValue    = this.Department             ;
			//obj.ClassRefValue         = this.Class                  ;
			obj.SalesTermRefValue     = this.SalesTermId            ;
			obj.ShipMethodRefValue    = this.ShipMethod             ;
			// 03/12/2015 Paul.  TrackingNum is for shipping, not Purchase Orders. 
			//obj.TrackingNum           = this.POnumber               ;
			//obj.GlobalTaxCalculation  = this.GlobalTaxCalculation   ;
			//obj.PrintStatus           = this.PrintStatus            ;
			//obj.EmailStatus           = this.EmailStatus            ;
			//obj.BillEmailValue        = this.BillEmail              ;
			// 02/13/2015 Paul.  Default to USD.  vwCurrencies will be empty if using US Etsy Online as it only supports USD. 
			// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/currency
			if ( vwCurrencies.Table.Rows.Count > 0 )
			{
				obj.ExchangeRateValue     = this.ExchangeRate      ;
				obj.CurrencyRefValue      = this.Currency          ;
			}
			obj.SetBillAddr(this.BillingStreet , this.BillingCity , this.BillingState , this.BillingPostalCode , this.BillingCountry );
			obj.SetShipAddr(this.ShippingStreet, this.ShippingCity, this.ShippingState, this.ShippingPostalCode, this.ShippingCountry);
			*/
			
			// 03/08/2015 Paul.  We are not going to merge line items.  Just overwrite all line items. 
			SetLineItemsFromCRM(obj);
			obj = this.shopify.OrderOperations.Insert(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.TimeModified;
			foreach ( Spring.Social.Etsy.Api.LineItem line in obj.lineItems )
			{
			}
			return this.ID;
		}

		public override void Delete()
		{
			this.shopify.OrderOperations.Delete(this.ID);
		}

		public override void Get(string sID)
		{
			IList<Spring.Social.Etsy.Api.Order> lst = this.shopify.OrderOperations.GetAll("Id = '" + sID + "'");
			if ( lst.Count > 0 )
			{
				this.SetFromEtsy(lst[0].Id);
			}
			else
			{
				this.Deleted = true;
			}
		}

		public override IList<Spring.Social.Etsy.Api.QBase> SelectModified(DateTime dtStartModifiedDate)
		{
			IList<Spring.Social.Etsy.Api.Order> invoices = this.shopify.OrderOperations.GetModified(dtStartModifiedDate);
			List<Spring.Social.Etsy.Api.QBase> lst = new List<Spring.Social.Etsy.Api.QBase>();
			foreach ( Spring.Social.Etsy.Api.Order invoice in invoices )
			{
				lst.Add(invoice);
			}
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			Sql.AppendParameter(cmd, Sql.ToString(this.DocNumber), "INVOICE_NUM");
			Guid gBILLING_ACCOUNT_ID = Guid.Empty;
			if ( !Sql.IsEmptyString(this.CustomerId) )
			{
				vwCustomers.RowFilter = "SYNC_REMOTE_KEY = '" + this.CustomerId + "'";
				if ( vwCustomers.Count > 0 )
				{
					gBILLING_ACCOUNT_ID = Sql.ToGuid(vwCustomers[0]["SYNC_LOCAL_ID"]);
					Sql.AppendParameter(cmd, gBILLING_ACCOUNT_ID, "BILLING_ACCOUNT_ID");
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
							case "INVOICE_NUM"                :  oValue = Sql.ToDBString  (this.DocNumber              );  break;
							case "DUE_DATE"                   :
								// 03/09/2015 Paul.  Etsy is truncating the DateTime to just a date.  Do not treat that as a change event. 
								if ( Sql.ToDateTime(par.Value).Date != Sql.ToDateTime(this.DueDate).Date )
									oValue = Sql.ToDBDateTime(this.DueDate);  break;
							case "SHIP_DATE"                  :
								// 03/09/2015 Paul.  Etsy is truncating the DateTime to just a date.  Do not treat that as a change event. 
								if ( Sql.ToDateTime(par.Value).Date != Sql.ToDateTime(this.ShipDate).Date )
									oValue = Sql.ToDBDateTime(this.ShipDate);  break;
							// 03/11/2015 Paul.  Balance/AMOUNT_DUE is managed differently, so it does not make sense to sync. 
							//case "AMOUNT_DUE"                 :  oValue = Sql.ToDBDecimal (this.Balance                );  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						if ( oValue != null )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "INVOICE_NUM"                :  bChanged = ParameterChanged(par, oValue,   30, sbChanges);  break;
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
			IDbCommand cmdINVOICES_UpdateTotals = SqlProcs.Factory(trn.Connection, "spINVOICES_UpdateTotals");
			cmdINVOICES_UpdateTotals.Transaction = trn;
			Sql.SetParameter(cmdINVOICES_UpdateTotals, "@ID"              , gID          );
			Sql.SetParameter(cmdINVOICES_UpdateTotals, "@MODIFIED_USER_ID", gUSER_ID     );
			cmdINVOICES_UpdateTotals.ExecuteNonQuery();
		}
	}
}
