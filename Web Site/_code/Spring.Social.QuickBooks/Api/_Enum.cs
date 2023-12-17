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

namespace Spring.Social.QuickBooks.Api
{
	[Serializable]
	public enum AccountClassificationEnum
	{
		Asset,
		Equity,
		Expense,
		Liability,
		Revenue
	}

	[Serializable]
	public enum AccountTypeEnum
	{
		Bank,
		AccountsReceivable,
		OtherCurrentAsset,
		FixedAsset,
		OtherAsset,
		AccountsPayable,
		CreditCard,
		OtherCurrentLiability,
		LongTermLiability,
		Equity,
		Income,
		CostofGoodsSold,
		Expense,
		OtherIncome,
		OtherExpense,
		NonPosting
	}

	[Serializable]
	public enum BillableStatusEnum
	{
		Billable,
		NotBillable,
		HasBeenBilled
	}

	[Serializable]
	public enum CCTxnModeEnum
	{
		CardNotPresent,
		CardPresent
	}

	[Serializable]
	public enum CCTxnTypeEnum
	{
		Authorization,
		Capture,
		Charge,
		Refund,
		VoiceAuthorization
	}

	[Serializable]
	public enum ContactTypeEnum
	{
		TelephoneNumber,
		EmailAddress,
		WebSiteAddress,
		GenericContactType
	}

	[Serializable]
	public enum CurrencyCode
	{
		AED,
		AFA,
		ALL,
		ANG,
		AOA,
		AOK,
		ARP,
		ARS,
		AMD,
		ATS,
		AUD,
		AWF,
		AWG,
		AZM,
		BAM,
		BBD,
		BDT,
		BEF,
		BGL,
		BHD,
		BIF,
		BMD,
		BND,
		BOB,
		BRC,
		BRL,
		BSD,
		BTN,
		BUK,
		BWP,
		BYR,
		BYB,
		BZD,
		CAD,
		CDF,
		CHF,
		CLP,
		CNY,
		COP,
		CRC,
		CZK,
		CUP,
		CVE,
		DDM,
		DEM,
		DJF,
		DKK,
		DOP,
		DZD,
		ECS,
		EEK,
		EGP,
		ERN,
		ESP,
		ETB,
		EUR,
		FIM,
		FJD,
		FKP,
		FRF,
		GBP,
		GEL,
		GHC,
		GIP,
		GMD,
		GNF,
		GRD,
		GTQ,
		GWP,
		GYD,
		HKD,
		HNL,
		HRK,
		HTG,
		HUF,
		IDR,
		IEP,
		ILS,
		INR,
		IQD,
		IRR,
		ISK,
		ITL,
		JMD,
		JOD,
		KES,
		KGS,
		KHR,
		KMF,
		KPW,
		KRW,
		KWD,
		KYD,
		KZT,
		LAK,
		LBP,
		LKR,
		LRD,
		LSL,
		LTL,
		LUF,
		LVL,
		LYD,
		MAD,
		MDL,
		MGF,
		MKD,
		MMK,
		MNT,
		MOP,
		MRO,
		MUR,
		MVR,
		MWK,
		MXN,
		MXP,
		MYR,
		MZM,
		NAD,
		NGN,
		NIC,
		NIO,
		NLG,
		NOK,
		NPR,
		NZD,
		OMR,
		PAB,
		PEN,
		PES,
		PGK,
		PHP,
		PKR,
		PLN,
		PLZ,
		PTE,
		PYG,
		QAR,
		ROL,
		RUR,
		RWF,
		SAR,
		SBD,
		SCR,
		SDD,
		SDP,
		SEK,
		SGD,
		SHP,
		SIT,
		SKK,
		SLL,
		SM,
		SOS,
		SRG,
		STD,
		SUR,
		SVC,
		SYP,
		SZL,
		THB,
		TMM,
		TND,
		TOP,
		TRL,
		TTD,
		TWD,
		TZS,
		UAH,
		UGS,
		UGX,
		USD,
		UYP,
		UYU,
		UZS,
		VND,
		VUV,
		VAL,
		WST,
		XAF,
		XCD,
		XOF,
		XPF,
		YER,
		YUD,
		ZAR,
		ZMK,
		ZRZ,
		ZWD
	}

	[Serializable]
	public enum DeliveryErrorTypeEnum
	{
		MissingInfo,  // Missing Info
		Undeliverable,
		DeliveryServerDown,  // Delivery Server Down
		BouncedEmail  // Bounced Email
	}

	[Serializable]
	public enum DeliveryTypeEnum
	{
		Email,
		Tradeshift
	}

	[Serializable]
	public enum EmailStatusEnum
	{
		NotSet,
		NeedToSend,
		EmailSent
	}

	[Serializable]
	public enum EntityTypeEnum
	{
		Customer,
		Employee,
		Job,
		Other,
		Vendor
	}

	[Serializable]
	public enum ETransactionStatusEnum
	{
		Sent,
		Viewed,
		Paid,
		DeliveryError,  // Delivery Error
		Updated,
		Error,
		Accepted,
		Rejected,
		SentWithICNError,  // Sent With ICN Error
		Delivered,
		Disputed
	}

	[Serializable]
	public enum GlobalTaxCalculationEnum
	{
		TaxInclusive,
		TaxExcluded,
		NotApplicable
	}

	[Serializable]
	public enum ItemChoiceType4
	{
		TaxGroupCodeRef,
		TaxRateRef
	}

	[Serializable]
	public enum ItemTypeEnum
	{
		Assembly,
		FixedAsset,   // Fixed Asset
		Group,
		Inventory,
		NonInventory,
		OtherCharge,  // Other Charge
		Payment,
		Service,
		Subtotal,
		Discount,
		Tax,
		TaxGroup      // Tax Group
	}

	[Serializable]
	public enum JobStatusEnum
	{
		Awarded,
		Closed,
		InProgress,
		None,
		NotAwarded,
		Pending
	}

	[Serializable]
	public enum LineDetailTypeEnum
	{
		PaymentLineDetail,
		DiscountLineDetail,
		TaxLineDetail,
		SalesItemLineDetail,
		ItemBasedExpenseLineDetail,
		AccountBasedExpenseLineDetail,
		DepositLineDetail,
		PurchaseOrderItemLineDetail,
		ItemReceiptLineDetail,
		JournalEntryLineDetail,
		GroupLineDetail,
		DescriptionOnly,
		SubTotalLineDetail,
		SalesOrderItemLineDetail
	}

	[Serializable]
	public enum PaymentTypeEnum
	{
		Cash,
		Check,
		CreditCard,
		Expense,
		Other
	}

	[Serializable]
	public enum PostingTypeEnum
	{
		Credit,
		Debit
	}

	[Serializable]
	public enum PrintStatusEnum
	{
		NotSet,
		NeedToPrint,
		PrintComplete
	}

	[Serializable]
	public enum SpecialItemTypeEnum
	{
		FinanceCharge,
		ReimbursableExpenseGroup,
		ReimbursableExpenseSubtotal
	}

	[Serializable]
	public enum SpecialTaxTypeEnum
	{
		NONE,
		ZERO_RATE,
		FOREIGN_TAX,
		REVERSE_CHARGE,
		ADJUSTMENT_RATE
	}

	[Serializable]
	public enum SymbolPositionEnum
	{
		Leading,
		Trailing
	}

	[Serializable]
	public enum TaxApplicableOnEnum
	{
		Purchase,
		Sales
	}

	[Serializable]
	public enum TaxRateDisplayTypeEnum
	{
		ReadOnly,
		HideInTransactionForms,
		HideInPrintedForms,
		HideInAll
	}

	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/020_key_concepts/0400enumerations_and_codes
	[Serializable]
	public enum TxnTypeEnum
	{
		APCreditCard,
		ARRefundCreditCard,
		Bill,
		BillPaymentCheck,
		BuildAssembly,
		CarryOver,
		CashPurchase,
		Charge,
		Check,
		CreditMemo,
		Deposit,
		EFPLiabilityCheck,
		EFTBillPayment,
		EFTRefund,
		Estimate,
		InventoryAdjustment,
		InventoryTransfer,
		Invoice,
		ItemReceipt,
		JournalEntry,
		LiabilityAdjustment,
		Paycheck,
		PayrollLiabilityCheck,
		PurchaseOrder,
		PriorPayment,
		ReceivePayment,
		RefundCheck,
		SalesOrder,
		SalesReceipt,
		SalesTaxPaymentCheck,
		Transfer,
		TimeActivity,
		VendorCredit,
		YTDAdjustment
 	}

	// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/taxcode
	[Serializable]
	public enum TaxTypeEnum
	{
		TaxOnAmount,
		TaxOnAmountPlusTax,
		TaxOnTax
	}
}
