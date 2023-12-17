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
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Spring.Social.QuickBooks.Api
{
	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/payment
	[Serializable]
	public class Payment : QBase
	{
		#region Properties
		public DateTime?                 TxnDate                           { get; set; }
		public String                    PrivateNote                       { get; set; }  // 4000 chars. 
		public String                    TxnStatus                         { get; set; }
		public IList<Line>               Lines                             { get; set; }
		public ReferenceType             CustomerRef                       { get; set; }
		public ReferenceType             ARAccountRef                      { get; set; }
		public ReferenceType             DepositToAccountRef               { get; set; }
		public ReferenceType             PaymentMethodRef                  { get; set; }
		public String                    PaymentRefNum                     { get; set; }
		public CreditChargeInfo          CreditCardPayment                 { get; set; }
		public Decimal?                  TotalAmt                          { get; set; }
		public Decimal?                  UnappliedAmt                      { get; set; }
		public ReferenceType             CurrencyRef                       { get; set; }
		public Decimal?                  ExchangeRate                      { get; set; }

		public DateTime TxnDateValue
		{
			get
			{
				return this.TxnDate.HasValue ? this.TxnDate.Value : DateTime.MinValue;
			}
			set
			{
				this.TxnDate = value;
			}
		}

		public Decimal TotalAmtValue
		{
			get
			{
				return this.TotalAmt.HasValue ? this.TotalAmt.Value : 0;
			}
			set
			{
				this.TotalAmt = value;
			}
		}

		public Decimal ExchangeRateValue
		{
			get
			{
				return this.ExchangeRate.HasValue ? this.ExchangeRate.Value : 1;
			}
			set
			{
				this.ExchangeRate = value;
			}
		}

		public string CurrencyRefValue
		{
			get
			{
				return this.CurrencyRef == null ? String.Empty : this.CurrencyRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.CurrencyRef = new ReferenceType(value);
				else
					this.CurrencyRef = null;
			}
		}

		public string CustomerRefValue
		{
			get
			{
				return this.CustomerRef == null ? String.Empty : this.CustomerRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.CustomerRef = new ReferenceType(value);
				else
					this.CustomerRef = null;
			}
		}

		public string ARAccountRefValue
		{
			get
			{
				return this.ARAccountRef == null ? String.Empty : this.ARAccountRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.ARAccountRef = new ReferenceType(value);
				else
					this.ARAccountRef = null;
			}
		}

		public string DepositToAccountRefValue
		{
			get
			{
				string sDepositToAccount = String.Empty;
				if ( this.DepositToAccountRef != null )
				{
					if ( !Sql.IsEmptyString(this.DepositToAccountRef.Name) )
						sDepositToAccount = Sql.ToString(this.DepositToAccountRef.Name);
					else
						sDepositToAccount = Sql.ToString(this.DepositToAccountRef.Value);
				}
				return sDepositToAccount;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.DepositToAccountRef = new ReferenceType(value);
				else
					this.DepositToAccountRef = null;
			}
		}

		public string PaymentMethodRefValue
		{
			get
			{
				string sPaymentMethod = String.Empty;
				if ( this.PaymentMethodRef != null )
				{
					if ( !Sql.IsEmptyString(this.PaymentMethodRef.Name) )
						sPaymentMethod = Sql.ToString(this.PaymentMethodRef.Name);
					else
						sPaymentMethod = Sql.ToString(this.PaymentMethodRef.Value);
				}
				return sPaymentMethod;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.PaymentMethodRef = new ReferenceType(value);
				else
					this.PaymentMethodRef = null;
			}
		}

		public string InvoiceRefValue
		{
			get
			{
				bool bFoundInvoice = false;
				string sInvoiceId = String.Empty;
				if ( this.Lines != null )
				{
					// 02/21/2015 Paul.  Look for first line with first transaction that is an Invoice. 
					for ( int iLine = 0; !bFoundInvoice & iLine < this.Lines.Count; iLine++ )
					{
						if ( this.Lines[iLine].LinkedTxn != null )
						{
							for ( int jLinked = 0; !bFoundInvoice && jLinked < this.Lines[iLine].LinkedTxn.Count; jLinked++ )
							{
								if ( this.Lines[iLine].LinkedTxn[jLinked].TxnType == TxnTypeEnum.Invoice )
								{
									sInvoiceId = Sql.ToString(this.Lines[iLine].LinkedTxn[jLinked].TxnId);
									bFoundInvoice = true;
									break;
								}
							}
						}
					}
				}
				return sInvoiceId;
			}
			set
			{
				bool bFoundInvoice = false;
				if ( this.Lines != null )
				{
					// 02/21/2015 Paul.  Look for first line with first transaction that is an Invoice. 
					for ( int iLine = 0; !bFoundInvoice && iLine < this.Lines.Count; iLine++ )
					{
						if ( this.Lines[iLine].LinkedTxn != null )
						{
							for ( int jLinked = 0; !bFoundInvoice && jLinked < this.Lines[iLine].LinkedTxn.Count; jLinked++ )
							{
								if ( this.Lines[iLine].LinkedTxn[jLinked].TxnType == TxnTypeEnum.Invoice )
								{
									if ( !Sql.IsEmptyString(value) )
									{
										this.Lines[iLine].LinkedTxn[jLinked].TxnId = value;
									}
									else
									{
										this.Lines[iLine].LinkedTxn.RemoveAt(jLinked);
										if ( this.Lines[iLine].LinkedTxn.Count == 0 )
											this.Lines.RemoveAt(iLine);
									}
									bFoundInvoice = true;
									break;
								}
							}
						}
					}
				}
				if ( !bFoundInvoice && !Sql.IsEmptyString(value) )
				{
					if ( this.Lines == null )
						this.Lines = new List<Line>();
					// 02/21/2015 Paul.  The above code will set an existing line, so here we will always create a new line. 
					Line line = new Line();
					line.LinkedTxn = new List<LinkedTxn>();
					line.LinkedTxn.Add(new LinkedTxn());
					line.LinkedTxn[0].TxnId   = value;
					line.LinkedTxn[0].TxnType = TxnTypeEnum.Invoice;
					this.Lines.Add(line);
				}
			}
		}

		#endregion

		public Payment()
		{
			this.Lines = new List<Line>();
		}

		public static DataTable CreateTable()
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("Id"                 , Type.GetType("System.Int64"   ));
			dt.Columns.Add("SyncToken"          , Type.GetType("System.Int64"   ));
			dt.Columns.Add("TimeCreated"        , Type.GetType("System.DateTime"));
			dt.Columns.Add("TimeModified"       , Type.GetType("System.DateTime"));
			dt.Columns.Add("TxnDate"            , Type.GetType("System.DateTime"));
			dt.Columns.Add("PrivateNote"        , Type.GetType("System.String"  ));
			dt.Columns.Add("TxnStatus"          , Type.GetType("System.String"  ));
			dt.Columns.Add("Customer"           , Type.GetType("System.String"  ));
			dt.Columns.Add("CustomerName"       , Type.GetType("System.String"  ));
			dt.Columns.Add("ARAccount"          , Type.GetType("System.String"  ));
			dt.Columns.Add("DepositToAccount"   , Type.GetType("System.String"  ));
			dt.Columns.Add("PaymentMethod"      , Type.GetType("System.String"  ));
			dt.Columns.Add("PaymentNum"         , Type.GetType("System.String"  ));
			dt.Columns.Add("CreditCardPayment"  , Type.GetType("System.String"  ));
			dt.Columns.Add("TotalAmt"           , Type.GetType("System.Decimal" ));
			dt.Columns.Add("UnappliedAmt"       , Type.GetType("System.Decimal" ));
			dt.Columns.Add("Currency"           , Type.GetType("System.String"  ));
			dt.Columns.Add("ExchangeRate"       , Type.GetType("System.Decimal" ));
			return dt;
		}

		public void SetRow(DataRow row)
		{
			for ( int i = 0; i < row.Table.Columns.Count; i++ )
			{
				row[i] = DBNull.Value;
			}
			if ( this.Id                  != null   ) row["Id"                 ] = Sql.ToDBString  (this.Id                            );
			if ( this.SyncToken           != null   ) row["SyncToken"          ] = Sql.ToDBString  (this.SyncToken                     );
			if ( this.MetaData            != null   ) row["TimeCreated"        ] = Sql.ToDBDateTime(this.MetaData.CreateTime           );
			if ( this.MetaData            != null   ) row["TimeModified"       ] = Sql.ToDBDateTime(this.MetaData.LastUpdatedTime      );
			if ( this.TxnDate             .HasValue ) row["TxnDate"            ] = Sql.ToDBDateTime(this.TxnDate                 .Value);
			if ( this.PrivateNote         != null   ) row["PrivateNote"        ] = Sql.ToDBString  (this.PrivateNote                   );
			if ( this.TxnStatus           != null   ) row["TxnStatus"          ] = Sql.ToDBString  (this.TxnStatus                     );
			if ( this.CustomerRef         != null   ) row["Customer"           ] = Sql.ToDBString  (this.CustomerRefValue              );
			if ( this.CustomerRef         != null   ) row["CustomerName"       ] = Sql.ToDBString  (this.CustomerRef.Name              );
			if ( this.ARAccountRef        != null   ) row["ARAccount"          ] = Sql.ToDBString  (this.ARAccountRefValue             );
			if ( this.DepositToAccountRef != null   ) row["DepositToAccount"   ] = Sql.ToDBString  (this.DepositToAccountRefValue      );
			if ( this.PaymentMethodRef    != null   ) row["PaymentMethod"      ] = Sql.ToDBString  (this.PaymentMethodRefValue         );
			if ( this.PaymentRefNum       != null   ) row["PaymentNum"         ] = Sql.ToDBString  (this.PaymentRefNum                 );
			if ( this.TotalAmt            .HasValue ) row["TotalAmt"           ] = Sql.ToDBDecimal (this.TotalAmt                .Value);
			if ( this.UnappliedAmt        .HasValue ) row["UnappliedAmt"       ] = Sql.ToDBDecimal (this.UnappliedAmt            .Value);
			if ( this.CurrencyRef         != null   ) row["Currency"           ] = Sql.ToDBString  (this.CurrencyRefValue              );
			if ( this.ExchangeRate        .HasValue ) row["ExchangeRate"       ] = Sql.ToDBDecimal (this.ExchangeRate            .Value);
			//if ( this.CreditCardPayment   != null   ) row["CreditCardPayment"  ] = Sql.ToDBString  (this.CreditCardPayment        );
		}

		public static DataRow ConvertToRow(Payment obj)
		{
			DataTable dt = Payment.CreateTable();
			DataRow row = dt.NewRow();
			obj.SetRow(row);
			return row;
		}

		public static DataTable ConvertToTable(IList<Payment> payments)
		{
			DataTable dt = Payment.CreateTable();
			if ( payments != null )
			{
				foreach ( Payment payment in payments )
				{
					DataRow row = dt.NewRow();
					dt.Rows.Add(row);
					payment.SetRow(row);
				}
			}
			return dt;
		}
	}
}
