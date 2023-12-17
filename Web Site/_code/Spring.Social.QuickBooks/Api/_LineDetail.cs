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
using System.Collections.Generic;

namespace Spring.Social.QuickBooks.Api
{
	[Serializable]
	public class AccountBasedExpenseLineDetail
	{
		public ReferenceType        CustomerRef     { get; set; }
		public ReferenceType        ClassRef        { get; set; }
		public ReferenceType        AccountRef      { get; set; }
		public BillableStatusEnum?  BillableStatus  { get; set; }
		public MarkupInfo           MarkupInfo      { get; set; }
		public Decimal?             TaxAmount       { get; set; }
		public ReferenceType        TaxCodeRef      { get; set; }
		public Decimal?             TaxInclusiveAmt { get; set; }
	}

	[Serializable]
	public class DepositLineDetail
	{
		public ReferenceType        Entity           { get; set; }
		public ReferenceType        ClassRef         { get; set; }
		public ReferenceType        AccountRef       { get; set; }
		public ReferenceType        PaymentMethodRef { get; set; }
		public String               CheckNum         { get; set; }
		public TxnTypeEnum?         TxnType          { get; set; }
	}

	[Serializable]
	public class DescriptionLineDetail
	{
		public DateTime?            ServiceDate { get; set; }
	}

	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/invoice#/DiscountLineDetail
	[Serializable]
	public class DiscountLineDetail
	{
		public DiscountOverride     Discount           { get; set; }
		public ReferenceType        ClassRef           { get; set; }
		public ReferenceType        TaxCodeRef         { get; set; }
		public ReferenceType        DiscountAccountRef { get; set; }

		public string DiscountAccountRefValue
		{
			get
			{
				return this.DiscountAccountRef == null ? String.Empty : this.DiscountAccountRef.Value;
			}
			set
			{
				if ( !Sql.IsEmptyString(value) )
					this.DiscountAccountRef = new ReferenceType(value);
				else
					this.DiscountAccountRef = null;
			}
		}
	}

	[Serializable]
	public class GroupLineDetail
	{
		public ReferenceType        GroupItemRef { get; set; }
		public Decimal?             Quantity     { get; set; }
		public UOMRef               UOMRef       { get; set; }
		public DateTime?            ServiceDate  { get; set; }
		public IList<Line>          Line         { get; set; }
	}

	[Serializable]
	public class JournalEntryLineDetail
	{
		public PostingTypeEnum?     PostingType     { get; set; }
		public EntityTypeRef        Entity          { get; set; }
		public ReferenceType        AccountRef      { get; set; }
		public ReferenceType        ClassRef        { get; set; }
		public ReferenceType        DepartmentRef   { get; set; }
		public ReferenceType        TaxCodeRef      { get; set; }
		public TaxApplicableOnEnum? TaxApplicableOn { get; set; }
		public Decimal?             TaxAmount       { get; set; }
		public BillableStatusEnum?  BillableStatus  { get; set; }
	}

	[Serializable]
	public class ItemBasedExpenseLineDetail
	{
		public ReferenceType        CustomerRef     { get; set; }
		public BillableStatusEnum?  BillableStatus  { get; set; }
		public Decimal?             TaxInclusiveAmt { get; set; }
	}

	[Serializable]
	public class ItemReceiptLineDetail
	{
		// 06/17/2014 Paul.  Currently only contains the Ex field, which we typically ignore. 
	}

	[Serializable]
	public class PaymentLineDetail
	{
		public ReferenceType        ItemRef     { get; set; }
		public DateTime?            ServiceDate { get; set; }
		public ReferenceType        ClassRef    { get; set; }
		public Decimal?             Balance     { get; set; }
		public DiscountOverride     Discount    { get; set; }
	}

	[Serializable]
	public class PurchaseOrderItemLineDetail
	{
		public String               ManPartNum     { get; set; }
		public Boolean?             ManuallyClosed { get; set; }
		public Decimal?             OpenQty        { get; set; }
	}

	[Serializable]
	public class SalesItemLineDetail
	{
		public ReferenceType        ItemRef         { get; set; }
		public Decimal?             UnitPrice       { get; set; }
		public Decimal?             Qty             { get; set; }
		public ReferenceType        TaxCodeRef      { get; set; }
		public DateTime?            ServiceDate     { get; set; }
		public Decimal?             TaxInclusiveAmt { get; set; }
	}

	[Serializable]
	public class SalesOrderItemLineDetail
	{
		public Boolean?             ManuallyClosed { get; set; }
	}

	[Serializable]
	public class SubTotalLineDetail
	{
		public ReferenceType        ItemRef     { get; set; }
		public DateTime?            ServiceDate { get; set; }
	}

	[Serializable]
	public class TaxLineDetail
	{
		public ReferenceType        TaxRateRef          { get; set; }
		public Boolean?             PercentBased        { get; set; }
		public Decimal?             TaxPercent          { get; set; }
		public Decimal?             NetAmountTaxable    { get; set; }
		public Decimal?             TaxInclusiveAmount  { get; set; }
		public Decimal?             OverrideDeltaAmount { get; set; }
		public DateTime?            ServiceDate         { get; set; }
	}
}
