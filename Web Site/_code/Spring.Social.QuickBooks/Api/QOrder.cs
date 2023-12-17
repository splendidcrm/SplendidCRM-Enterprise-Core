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
	public class QOrder : QBase
	{
		// Transaction
		public String                    DocNumber                         { get; set; }  // 21 chars. 
		public DateTime?                 TxnDate                           { get; set; }
		public ReferenceType             DepartmentRef                     { get; set; }
		public ReferenceType             CurrencyRef                       { get; set; }
		public Decimal?                  ExchangeRate                      { get; set; }
		public String                    PrivateNote                       { get; set; }  // 4000 chars. 
		public IList<LinkedTxn>          LinkedTxns                        { get; set; }
		public IList<Line>               Lines                             { get; set; }
		public TxnTaxDetail              TxnTaxDetail                      { get; set; }

		// SalesTransaction
		public ReferenceType             CustomerRef                       { get; set; }
		public MemoRef                   CustomerMemo                      { get; set; }  // 1000 chars. 
		public PhysicalAddress           BillAddr                          { get; set; }
		public PhysicalAddress           ShipAddr                          { get; set; }
		public ReferenceType             SalesTermRef                      { get; set; }
		public GlobalTaxCalculationEnum? GlobalTaxCalculation              { get; set; }
		public ReferenceType             ShipMethodRef                     { get; set; }
		public DateTime?                 ShipDate                          { get; set; }
		public String                    TrackingNum                       { get; set; }
		public Decimal?                  TotalAmt                          { get; set; }
		public Decimal?                  HomeTotalAmt                      { get; set; }
		public Boolean?                  ApplyTaxAfterDiscount             { get; set; }
		public PrintStatusEnum?          PrintStatus                       { get; set; }
		public EmailStatusEnum?          EmailStatus                       { get; set; }
		public EmailAddress              BillEmail                         { get; set; }

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

		public Decimal ExchangeRateValue
		{
			get
			{
				// 02/19/2015 Paul.  Default ExchangeRate to 1. 
				return this.ExchangeRate.HasValue ? this.ExchangeRate.Value : 1;
			}
			set
			{
				this.ExchangeRate = value;
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

		public string DepartmentRefValue
		{
			get
			{
				return this.DepartmentRef == null ? String.Empty : this.DepartmentRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.DepartmentRef = new ReferenceType(value);
				else
					this.DepartmentRef = null;
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

		public Decimal TxnTaxDetailValue
		{
			get
			{
				return (this.TxnTaxDetail == null || !this.TxnTaxDetail.TotalTax.HasValue) ? 0 : this.TxnTaxDetail.TotalTax.Value;
			}
			set
			{
				if ( this.TxnTaxDetail == null )
					this.TxnTaxDetail = new TxnTaxDetail(value);
				else
					this.TxnTaxDetail.TotalTax = value;
			}
		}

		public string TxnTaxCodeTaxRate
		{
			get
			{
				return (this.TxnTaxDetail == null ) ? String.Empty : this.TxnTaxDetail.TxnTaxCodeTaxRate;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
				{
					if ( this.TxnTaxDetail == null )
						this.TxnTaxDetail = new TxnTaxDetail();
					this.TxnTaxDetail.TxnTaxCodeTaxRate = value;
				}
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

		public string CustomerMemoValue
		{
			get
			{
				return this.CustomerMemo == null ? String.Empty : this.CustomerMemo.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.CustomerMemo = new MemoRef(value);
				else
					this.CustomerMemo = null;
			}
		}

		public string SalesTermRefValue
		{
			get
			{
				return this.SalesTermRef == null ? String.Empty : this.SalesTermRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.SalesTermRef = new ReferenceType(value);
				else
					this.SalesTermRef = null;
			}
		}

		public string GlobalTaxCalculationValue
		{
			get
			{
				return (this.GlobalTaxCalculation == null || !this.GlobalTaxCalculation.HasValue) ? String.Empty : this.GlobalTaxCalculation.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.GlobalTaxCalculation = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializeGlobalTaxCalculation(new Spring.Json.JsonValue(value));
				else
					this.GlobalTaxCalculation = null;
			}
		}

		public string ShipMethodRefValue
		{
			get
			{
				return this.ShipMethodRef == null ? String.Empty : this.ShipMethodRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.ShipMethodRef = new ReferenceType(value);
				else
					this.ShipMethodRef = null;
			}
		}

		public DateTime ShipDateValue
		{
			get
			{
				return this.ShipDate.HasValue ? this.ShipDate.Value : DateTime.MinValue;
			}
			set
			{
				this.ShipDate = value;
			}
		}

		public string PrintStatusValue
		{
			get
			{
				return (this.PrintStatus == null || !this.PrintStatus.HasValue) ? String.Empty : this.PrintStatus.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.PrintStatus = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializePrintStatus(new Spring.Json.JsonValue(value));
				else
					this.PrintStatus = null;
			}
		}

		public string EmailStatusValue
		{
			get
			{
				return (this.EmailStatus == null || !this.EmailStatus.HasValue) ? String.Empty : this.EmailStatus.Value.ToString();
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.EmailStatus = Spring.Social.QuickBooks.Api.Impl.Json._EnumDeserializer.DeserializeEmailStatus(new Spring.Json.JsonValue(value));
				else
					this.EmailStatus = null;
			}
		}

		public string BillEmailValue
		{
			get
			{
				return this.BillEmail == null ? String.Empty : this.BillEmail.Address;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.BillEmail = new EmailAddress(value);
				else
					this.BillEmail = null;
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

		public QOrder()
		{
			this.Lines = new List<Line>();
		}

	}
}
