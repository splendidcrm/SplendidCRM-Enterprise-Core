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
	public class Payment : QObject
	{
		#region Properties
		public DateTime TxnDate                    ;
		public string   CustomerId                 ;
		public string   InvoiceId                  ;
		public Decimal  Amount                     ;
		public string   PaymentMethodId            ;
		public string   PaymentReference           ;
		public string   Currency                   ;
		public Decimal  ExchangeRate               ;
		public string   PaymentsDepositAccountId   ;
		#endregion
		protected DataView vwCurrencies  ;
		protected DataView vwCustomers   ;
		protected DataView vwPaymentTypes;
		protected DataView vwInvoices    ;

		public Payment(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, ExchangeSecurity ExchangeSecurity, SyncError SyncError, Spring.Social.QuickBooks.Api.IQuickBooks quickBooks, DataTable dtCurrencies, DataTable dtCustomers, DataTable dtPaymentTypes, DataTable dtInvoices, string sPaymentsDepositAccountId)
			: base(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, quickBooks, "Payments", "Id", "Payments", "PAYMENTS", "DATE_MODIFIED_UTC", false, false, false)
		{
			this.vwCurrencies   = new DataView(dtCurrencies  );
			this.vwCustomers    = new DataView(dtCustomers   );
			this.vwPaymentTypes = new DataView(dtPaymentTypes);
			this.vwInvoices     = new DataView(dtInvoices    );
			this.PaymentsDepositAccountId = sPaymentsDepositAccountId;
		}

		public override void Reset()
		{
			base.Reset();
			this.TxnDate          = DateTime.MinValue;
			this.CustomerId       = String.Empty;
			this.InvoiceId        = String.Empty;
			this.Amount           = 0;
			this.PaymentMethodId  = String.Empty;
			this.PaymentReference = String.Empty;
			this.Currency         = String.Empty;
			this.ExchangeRate     = 1;
		}

		public override bool SetFromCRM(string sID, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			string sInvoiceId = String.Empty;
			vwInvoices.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["INVOICE_ID"]) + "'";
			if ( vwInvoices.Count > 0 )
				sInvoiceId = Sql.ToString(vwInvoices[0]["SYNC_REMOTE_KEY"]);
			
			string sCustomerId = String.Empty;
			vwCustomers.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["ACCOUNT_ID"]) + "'";
			if ( vwCustomers.Count > 0 )
				sCustomerId = Sql.ToString(vwCustomers[0]["SYNC_REMOTE_KEY"]);
			
			string sPaymentMethodId = String.Empty;
			vwPaymentTypes.RowFilter = "SYNC_LOCAL_ID = '" + Sql.ToString(row["PAYMENT_TYPE_ID"]) + "'";
			if ( vwPaymentTypes.Count > 0 )
				sPaymentMethodId = Sql.ToString(vwPaymentTypes[0]["SYNC_REMOTE_KEY"]);
			
			this.ID       = sID;
			this.LOCAL_ID = Sql.ToGuid(row["ID"]);
			if ( Sql.IsEmptyString(this.ID) )
			{
				this.Name             =               Sql.ToString  (row["PAYMENT_NUM"          ]);
				this.TxnDate          =               Sql.ToDateTime(row["PAYMENT_DATE"         ]).Date;
				this.CustomerId       =               Sql.ToString  (sCustomerId                 );
				this.InvoiceId        =               Sql.ToString  (sInvoiceId                  );
				this.Amount           =               Sql.ToDecimal (row["AMOUNT_USDOLLAR"      ]);
				this.PaymentMethodId  =               Sql.ToString  (sPaymentMethodId            );
				this.PaymentReference = Sql.MaxLength(Sql.ToString  (row["CUSTOMER_REFERENCE"   ]),  21);  // 03/24/2015 Paul.  Validated max length. 
				this.Currency         =               Sql.ToString  (row["CURRENCY_ISO4217"     ]);
				this.ExchangeRate     =               Sql.ToDecimal (row["EXCHANGE_RATE"        ]);
				bChanged = true;
			}
			else
			{
				if ( Compare(this.Name            ,               Sql.ToString  (row["PAYMENT_NUM"          ])      , "PAYMENT_NUM"          , sbChanges) ) { this.Name             =               Sql.ToString  (row["PAYMENT_NUM"          ])      ;  bChanged = true; }
				if ( Compare(this.TxnDate         ,               Sql.ToDateTime(row["PAYMENT_DATE"         ]).Date , "PAYMENT_DATE"         , sbChanges) ) { this.TxnDate          =               Sql.ToDateTime(row["PAYMENT_DATE"         ]).Date ;  bChanged = true; }
				if ( Compare(this.CustomerId      ,               Sql.ToString  (sCustomerId                 )      , "ACCOUNT_ID"           , sbChanges) ) { this.CustomerId       =               Sql.ToString  (sCustomerId                 )      ;  bChanged = true; }
				if ( Compare(this.InvoiceId       ,               Sql.ToString  (sInvoiceId                  )      , "INVOICE_ID"           , sbChanges) ) { this.InvoiceId        =               Sql.ToString  (sInvoiceId                  )      ;  bChanged = true; }
				if ( Compare(this.Amount          ,               Sql.ToDecimal (row["AMOUNT_USDOLLAR"      ])      , "AMOUNT_USDOLLAR"      , sbChanges) ) { this.Amount           =               Sql.ToDecimal (row["AMOUNT_USDOLLAR"      ])      ;  bChanged = true; }
				if ( Compare(this.PaymentMethodId ,               Sql.ToString  (sPaymentMethodId            )      , "PAYMENT_TYPE"         , sbChanges) ) { this.PaymentMethodId  =               Sql.ToString  (sPaymentMethodId            )      ;  bChanged = true; }
				if ( Compare(this.PaymentReference, Sql.MaxLength(Sql.ToString  (row["CUSTOMER_REFERENCE"   ]),  21), "CUSTOMER_REFERENCE"   , sbChanges) ) { this.PaymentReference = Sql.MaxLength(Sql.ToString  (row["CUSTOMER_REFERENCE"   ]),  21);  bChanged = true; }
				if ( Compare(this.Currency        ,               Sql.ToString  (row["CURRENCY_ISO4217"     ])      , "CURRENCY_ISO4217"     , sbChanges) ) { this.Currency         =               Sql.ToString  (row["CURRENCY_ISO4217"     ])      ;  bChanged = true; }
				if ( Compare(this.ExchangeRate    ,               Sql.ToDecimal (row["EXCHANGE_RATE"        ])      , "EXCHANGE_RATE"        , sbChanges) ) { this.ExchangeRate     =               Sql.ToDecimal (row["EXCHANGE_RATE"        ])      ;  bChanged = true; }
	
			}
			return bChanged;
		}

		public override void SetFromQuickBooks(string sId)
		{
			this.Reset();
			Spring.Social.QuickBooks.Api.Payment obj = this.quickBooks.PaymentOperations.GetById(sId);
			this.RawContent       = obj.RawContent           ;
			this.ID               = obj.Id                   ;
			this.TimeCreated      = obj.TimeCreated          ;
			this.TimeModified     = obj.TimeModified         ;
			this.Name             = obj.PrivateNote          ;
			this.TxnDate          = obj.TxnDateValue         ;
			this.CustomerId       = obj.CustomerRefValue     ;
			this.InvoiceId        = obj.InvoiceRefValue      ;
			//this.TotalAmt         = obj.TotalAmtValue        ;
			this.PaymentMethodId  = obj.PaymentMethodRefValue;
			this.PaymentReference = obj.PaymentRefNum        ;
			this.Currency         = obj.CurrencyRefValue     ;
			this.ExchangeRate     = obj.ExchangeRateValue    ;
			// 03/03/2015 Paul.  We don't know the CRM Invoice, so we have to assume that the payment only has one invoice. 
			foreach ( Spring.Social.QuickBooks.Api.Line line in obj.Lines )
			{
				if ( line.LinkedTxn != null )
				{
					foreach ( Spring.Social.QuickBooks.Api.LinkedTxn link in line.LinkedTxn )
					{
						if ( link.TxnType.Value == Api.TxnTypeEnum.Invoice )
							this.Amount = line.AmountValue;
					}
				}
			}
		}

		private void LinkToInvoice(Spring.Social.QuickBooks.Api.Payment obj)
		{
			try
			{
				bool bFoundInvoice = false;
				if ( obj.Lines != null )
				{
					foreach ( Spring.Social.QuickBooks.Api.Line line in obj.Lines )
					{
						if ( line.LinkedTxn != null )
						{
							foreach ( Spring.Social.QuickBooks.Api.LinkedTxn link in line.LinkedTxn )
							{
								if ( link.TxnType.Value == Api.TxnTypeEnum.Invoice && link.TxnId == this.InvoiceId )
								{
									line.AmountValue = this.Amount;
									bFoundInvoice = true;
								}
							}
						}
					}
				}
				if ( !bFoundInvoice && !Sql.IsEmptyString(this.InvoiceId) )
				{
					if ( obj.Lines == null )
						obj.Lines = new List<Spring.Social.QuickBooks.Api.Line>();
					Spring.Social.QuickBooks.Api.Line line = new Spring.Social.QuickBooks.Api.Line();
					line.AmountValue = this.Amount;
					line.LinkedTxn   = new List<Spring.Social.QuickBooks.Api.LinkedTxn>();
					line.LinkedTxn.Add(new Spring.Social.QuickBooks.Api.LinkedTxn());
					line.LinkedTxn[0].TxnId   = this.ID;
					line.LinkedTxn[0].TxnType = Spring.Social.QuickBooks.Api.TxnTypeEnum.CreditMemo;
					line.LineNum     = (obj.Lines.Count + 1).ToString();
					obj.Lines.Add(line);
				}
				decimal dTotal = 0;
				foreach ( Spring.Social.QuickBooks.Api.Line line in obj.Lines )
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
				obj.TotalAmtValue = dTotal;
			}
			catch(Exception ex)
			{
				Debug.WriteLine(ex.Message);
			}
		}

		public override void Update()
		{
			Spring.Social.QuickBooks.Api.Payment obj = this.quickBooks.PaymentOperations.GetById(this.ID);
			obj.PrivateNote              = this.Name                    ;
			obj.TxnDate                  = this.TxnDate                 ;
			// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/payment
			obj.TxnStatus                = "PAID"                       ;  // 02/16/2015 Paul.  Always set to paid. 
			obj.CustomerRefValue         = this.CustomerId              ;
			obj.InvoiceRefValue          = this.InvoiceId               ;
			// 02/17/2015 Paul.  We are not going to update the deposit account. 
			if ( Sql.IsEmptyString(obj.DepositToAccountRefValue) )
				obj.DepositToAccountRefValue = this.PaymentsDepositAccountId;
			// 03/03/2015 Paul.  There can be multiple lines, so search for the invoice to update. 
			//obj.Lines[0].Amount          = this.TotalAmt                ;
			//obj.TotalAmt                 = this.TotalAmt                ;
			LinkToInvoice(obj);
			obj.PaymentMethodRefValue    = this.PaymentMethodId         ;
			obj.PaymentRefNum            = this.PaymentReference        ;
			if ( vwCurrencies.Table.Rows.Count > 0 )
			{
				obj.ExchangeRate          = this.ExchangeRate      ;
				obj.CurrencyRefValue      = this.Currency          ;
			}
			obj = this.quickBooks.PaymentOperations.Update(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
		}

		public override string Insert()
		{
			this.ID = String.Empty;
			
			Spring.Social.QuickBooks.Api.Payment obj = new Spring.Social.QuickBooks.Api.Payment();
			obj.PrivateNote              = this.Name                    ;
			obj.TxnDate                  = this.TxnDate                 ;
			// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/payment
			obj.TxnStatus                = "PAID"                       ;  // 02/16/2015 Paul.  Always set to paid. 
			obj.CustomerRefValue         = this.CustomerId              ;
			obj.InvoiceRefValue          = this.InvoiceId               ;
			obj.DepositToAccountRefValue = this.PaymentsDepositAccountId;
			// 03/03/2015 Paul.  There can be multiple lines, so search for the invoice to update. 
			//obj.Lines[0].Amount          = this.TotalAmt                ;
			//obj.TotalAmt                 = this.TotalAmt                ;
			LinkToInvoice(obj);
			obj.PaymentMethodRefValue    = this.PaymentMethodId         ;
			obj.PaymentRefNum            = this.PaymentReference        ;
			if ( vwCurrencies.Table.Rows.Count > 0 )
			{
				obj.ExchangeRate          = this.ExchangeRate      ;
				obj.CurrencyRefValue      = this.Currency          ;
			}
			obj = this.quickBooks.PaymentOperations.Insert(obj);
			this.RawContent   = obj.RawContent;
			this.ID           = obj.Id;
			this.TimeModified = obj.MetaData.LastUpdatedTime;
			return this.ID;
		}

		public override void Delete()
		{
			this.quickBooks.PaymentOperations.Delete(this.ID);
		}

		public override void Get(string sID)
		{
			IList<Spring.Social.QuickBooks.Api.Payment> lst = this.quickBooks.PaymentOperations.GetAll("Id = '" + sID + "'", String.Empty);
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
			IList<Spring.Social.QuickBooks.Api.QBase> lst = this.quickBooks.PaymentOperations.GetModified(dtStartModifiedDate);
			return lst;
		}

		public override void FilterCRM(IDbCommand cmd)
		{
			Sql.AppendParameter(cmd, Sql.ToString(this.Name), "PAYMENT_NUM");
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
			bool bChanged = this.InitUpdateProcedure(spUpdate, row, gUSER_ID, gTEAM_ID);
			// 02/13/2015 Paul.  Default to USD.  vwCurrencies will be empty if using US QuickBooks Online as it only supports USD. 
			// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/currency
			Guid gCURRENCY_ID = new Guid("E340202E-6291-4071-B327-A34CB4DF239B");
			if ( !Sql.IsEmptyString(this.Currency) )
			{
				vwCurrencies.RowFilter = "ISO4217 = '" + this.Currency + "'";
				if ( vwCurrencies.Count > 0 )
					gCURRENCY_ID = Sql.ToGuid(vwCurrencies[0]["ID"]);
			}
			
			Guid gACCOUNT_ID = Guid.Empty;
			if ( !Sql.IsEmptyString(this.CustomerId) )
			{
				vwCustomers.RowFilter = "SYNC_REMOTE_KEY = '" + this.CustomerId + "'";
				if ( vwCustomers.Count > 0 )
					gACCOUNT_ID = Sql.ToGuid(vwCustomers[0]["SYNC_LOCAL_ID"]);
			}
			
			string sPAYMENT_TYPE = String.Empty;
			if ( !Sql.IsEmptyString(this.PaymentMethodId) )
			{
				vwPaymentTypes.RowFilter = "SYNC_REMOTE_KEY = '" + this.PaymentMethodId + "'";
				if ( vwPaymentTypes.Count > 0 )
					sPAYMENT_TYPE = Sql.ToString(vwPaymentTypes[0]["SYNC_NAME"]);
			}
			
			foreach(IDbDataParameter par in spUpdate.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spUpdate, par.ParameterName).ToUpper();
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "PAYMENT_NUM"       :  oValue = Sql.ToDBString  (this.Name            );  break;
							case "ACCOUNT_ID"        :  oValue = Sql.ToDBGuid    (     gACCOUNT_ID     );  break;
							case "CURRENCY_ID"       :
								// 03/02/2015 Paul.  Only update if QuickBooks value is not empty. 
								if ( !Sql.IsEmptyString(this.Currency) )
									if ( vwCurrencies.Count > 0 )
										oValue = Sql.ToDBGuid    (     gCURRENCY_ID    );
								break;
							case "EXCHANGE_RATE"     :  oValue = Sql.ToDBDecimal (this.ExchangeRate    );  break;
							case "PAYMENT_DATE"      :
								// 03/09/2015 Paul.  QuickBooks is truncating the DateTime to just a date.  Do not treat that as a change event. 
								if ( Sql.ToDateTime(par.Value).Date != Sql.ToDateTime(this.TxnDate).Date )
									oValue = Sql.ToDBDateTime(this.TxnDate);  break;
							case "PAYMENT_TYPE"      :
								// 03/02/2015 Paul.  Only update if QuickBooks value is not empty. 
								if ( !Sql.IsEmptyString(this.PaymentMethodId) )
									if ( vwPaymentTypes.Count > 0 )
										oValue = Sql.ToDBString  (sPAYMENT_TYPE        );
								break;
							case "AMOUNT"            :  oValue = Sql.ToDBDecimal (this.Amount          );  break;
							case "CUSTOMER_REFERENCE":  oValue = Sql.ToDBString  (this.PaymentReference);  break;
							case "MODIFIED_USER_ID"  :  oValue = gUSER_ID                               ;  break;
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						// 02/17/2015 Paul.  Modified User ID does not count as a changed field. 
						if ( oValue != null && sColumnName != "MODIFIED_USER_ID" )
						{
							if ( !bChanged )
							{
								switch ( sColumnName )
								{
									case "PAYMENT_NUM"       :  bChanged = ParameterChanged(par, oValue,   21, sbChanges);  break;
									case "PAYMENT_TYPE"      :  bChanged = ParameterChanged(par, oValue,   25, sbChanges);  break;
									case "CUSTOMER_REFERENCE":  bChanged = ParameterChanged(par, oValue,   50, sbChanges);  break;
									default                  :  bChanged = ParameterChanged(par, oValue      , sbChanges);  break;
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
				Sql.SetParameter(cmdINVOICES_PAYMENTS_Update, "@AMOUNT"          , this.Amount  );
				cmdINVOICES_PAYMENTS_Update.ExecuteNonQuery();
			}
		}
	}
}
