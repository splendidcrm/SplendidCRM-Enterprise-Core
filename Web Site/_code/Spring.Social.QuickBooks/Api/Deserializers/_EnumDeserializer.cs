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
using System.Globalization;
using System.Collections.Generic;
using Spring.Json;

namespace Spring.Social.QuickBooks.Api.Impl.Json
{
	public class _EnumDeserializer
	{
		public static BillableStatusEnum DeserializeBillableStatus(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Billable"     : return BillableStatusEnum.Billable     ;
					case "NotBillable"  : return BillableStatusEnum.NotBillable  ;
					case "HasBeenBilled": return BillableStatusEnum.HasBeenBilled;
				}
			}
			return BillableStatusEnum.Billable;
		}

		public static AccountTypeEnum DeserializeAccountType(JsonValue json)
		{
			if ( json != null )
			{
				// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/account#Account_Classifications
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Bank"                 : return AccountTypeEnum.Bank                 ;
					case "Accounts Receivable"  : return AccountTypeEnum.AccountsReceivable   ;
					case "Other Current Asset"  : return AccountTypeEnum.OtherCurrentAsset    ;
					case "Fixed Asset"          : return AccountTypeEnum.FixedAsset           ;
					case "Other Asset"          : return AccountTypeEnum.OtherAsset           ;
					case "Accounts Payable"     : return AccountTypeEnum.AccountsPayable      ;
					case "CreditCard"           : return AccountTypeEnum.CreditCard           ;
					case "OtherCurrentLiability": return AccountTypeEnum.OtherCurrentLiability;
					case "LongTermLiability"    : return AccountTypeEnum.LongTermLiability    ;
					case "Equity"               : return AccountTypeEnum.Equity               ;
					case "Income"               : return AccountTypeEnum.Income               ;
					case "CostofGoodsSold"      : return AccountTypeEnum.CostofGoodsSold      ;
					case "Expense"              : return AccountTypeEnum.Expense              ;
					case "OtherIncome"          : return AccountTypeEnum.OtherIncome          ;
					case "OtherExpense"         : return AccountTypeEnum.OtherExpense         ;
					case "NonPosting"           : return AccountTypeEnum.NonPosting           ;
				}
			}
			return AccountTypeEnum.Bank;
		}

		public static AccountClassificationEnum DeserializeClassification(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Asset"     : return AccountClassificationEnum.Asset    ;
					case "Equity"    : return AccountClassificationEnum.Equity   ;
					case "Expense"   : return AccountClassificationEnum.Expense  ;
					case "Liability" : return AccountClassificationEnum.Liability;
					case "Revenue"   : return AccountClassificationEnum.Revenue  ;
				}
			}
			return AccountClassificationEnum.Asset;
		}

		public static ContactTypeEnum DeserializeContactType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "TelephoneNumber"   : return ContactTypeEnum.TelephoneNumber   ;
					case "EmailAddress"      : return ContactTypeEnum.EmailAddress      ;
					case "WebSiteAddress"    : return ContactTypeEnum.WebSiteAddress    ;
					case "GenericContactType": return ContactTypeEnum.GenericContactType;
				}
			}
			return ContactTypeEnum.TelephoneNumber;
		}

		public static CCTxnModeEnum DeserializeCCTxnMode(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "CardNotPresent": return CCTxnModeEnum.CardNotPresent;
					case "CardPresent"   : return CCTxnModeEnum.CardPresent   ;
				}
			}
			return CCTxnModeEnum.CardNotPresent;
		}

		public static CCTxnTypeEnum DeserializeCCTxnType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Authorization"     : return CCTxnTypeEnum.Authorization     ;
					case "Capture"           : return CCTxnTypeEnum.Capture           ;
					case "Charge"            : return CCTxnTypeEnum.Charge            ;
					case "Refund"            : return CCTxnTypeEnum.Refund            ;
					case "VoiceAuthorization": return CCTxnTypeEnum.VoiceAuthorization;
				}
			}
			return CCTxnTypeEnum.Authorization;
		}

		public static CurrencyCode DeserializeCurrencyCode(JsonValue json)
		{
			if ( json != null )
			{
				CurrencyCode code;
				string value = json.GetValue<string>();
				if ( Enum.TryParse<CurrencyCode>(value, true, out code) )
					return code;
			}
			return CurrencyCode.USD;
		}

		public static SymbolPositionEnum DeserializeSymbolPosition(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Leading" : return SymbolPositionEnum.Leading ;
					case "Trailing": return SymbolPositionEnum.Trailing;
				}
			}
			return SymbolPositionEnum.Leading;
		}

		public static EntityTypeEnum DeserializeEntityType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Customer": return EntityTypeEnum.Customer;
					case "Employee": return EntityTypeEnum.Employee;
					case "Job"     : return EntityTypeEnum.Job     ;
					case "Other"   : return EntityTypeEnum.Other   ;
					case "Vendor"  : return EntityTypeEnum.Vendor  ;
				}
			}
			return EntityTypeEnum.Customer;
		}

		public static GlobalTaxCalculationEnum DeserializeGlobalTaxCalculation(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "TaxInclusive" : return GlobalTaxCalculationEnum.TaxInclusive ;
					case "TaxExcluded"  : return GlobalTaxCalculationEnum.TaxExcluded  ;
					case "NotApplicable": return GlobalTaxCalculationEnum.NotApplicable;
				}
			}
			return GlobalTaxCalculationEnum.TaxInclusive;
		}

		public static ItemChoiceType4 DeserializeItemChoiceType4(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "TaxGroupCodeRef": return ItemChoiceType4.TaxGroupCodeRef;
					case "TaxRateRef"     : return ItemChoiceType4.TaxRateRef     ;
				}
			}
			return ItemChoiceType4.TaxRateRef;
		}

		public static EmailStatusEnum DeserializeEmailStatus(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "NotSet"    : return EmailStatusEnum.NotSet    ;
					case "NeedToSend": return EmailStatusEnum.NeedToSend;
					case "EmailSent" : return EmailStatusEnum.EmailSent ;
				}
			}
			return EmailStatusEnum.NotSet;
		}

		public static ETransactionStatusEnum DeserializeETransactionStatus(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Sent"               : return ETransactionStatusEnum.Sent            ;
					case "Viewed"             : return ETransactionStatusEnum.Viewed          ;
					case "Paid"               : return ETransactionStatusEnum.Paid            ;
					case "Delivery Error"     : return ETransactionStatusEnum.DeliveryError   ;
					case "Updated"            : return ETransactionStatusEnum.Updated         ;
					case "Error"              : return ETransactionStatusEnum.Error           ;
					case "Accepted"           : return ETransactionStatusEnum.Accepted        ;
					case "Rejected"           : return ETransactionStatusEnum.Rejected        ;
					case "Sent With ICN Error": return ETransactionStatusEnum.SentWithICNError;
					case "Delivered"          : return ETransactionStatusEnum.Delivered       ;
					case "Disputed"           : return ETransactionStatusEnum.Disputed        ;
				}
			}
			return ETransactionStatusEnum.Sent;
		}

		public static ItemTypeEnum DeserializeItemType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Assembly"    : return ItemTypeEnum.Assembly    ;
					case "Fixed Asset" : return ItemTypeEnum.FixedAsset  ;
					case "Group"       : return ItemTypeEnum.Group       ;
					case "Inventory"   : return ItemTypeEnum.Inventory   ;
					case "NonInventory": return ItemTypeEnum.NonInventory;
					case "Other Charge": return ItemTypeEnum.OtherCharge ;
					case "Payment"     : return ItemTypeEnum.Payment     ;
					case "Service"     : return ItemTypeEnum.Service     ;
					case "Subtotal"    : return ItemTypeEnum.Subtotal    ;
					case "Discount"    : return ItemTypeEnum.Discount    ;
					case "Tax"         : return ItemTypeEnum.Tax         ;
					case "Tax Group"   : return ItemTypeEnum.TaxGroup    ;
				}
			}
			return ItemTypeEnum.Assembly;
		}

		public static SpecialItemTypeEnum DeserializeSpecialItemType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "FinanceCharge"              : return SpecialItemTypeEnum.FinanceCharge              ;
					case "ReimbursableExpenseGroup"   : return SpecialItemTypeEnum.ReimbursableExpenseGroup   ;
					case "ReimbursableExpenseSubtotal": return SpecialItemTypeEnum.ReimbursableExpenseSubtotal;
				}
			}
			return SpecialItemTypeEnum.FinanceCharge;
		}

		public static JobStatusEnum DeserializeStatus(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Awarded"   : return JobStatusEnum.Awarded   ;
					case "Closed"    : return JobStatusEnum.Closed    ;
					case "InProgress": return JobStatusEnum.InProgress;
					case "None"      : return JobStatusEnum.None      ;
					case "NotAwarded": return JobStatusEnum.NotAwarded;
					case "Pending"   : return JobStatusEnum.Pending   ;
				}
			}
			return JobStatusEnum.None;
		}

		public static PostingTypeEnum DeserializePostingType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Credit": return PostingTypeEnum.Credit;
					case "Debit" : return PostingTypeEnum.Debit ;
				}
			}
			return PostingTypeEnum.Credit;
		}

		public static TaxApplicableOnEnum DeserializeTaxApplicableOn(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Purchase": return TaxApplicableOnEnum.Purchase;
					case "Sales"   : return TaxApplicableOnEnum.Sales   ;
				}
			}
			return TaxApplicableOnEnum.Purchase;
		}

		public static LineDetailTypeEnum DeserializeLineDetailType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "PaymentLineDetail"            : return LineDetailTypeEnum.PaymentLineDetail            ;
					case "DiscountLineDetail"           : return LineDetailTypeEnum.DiscountLineDetail           ;
					case "TaxLineDetail"                : return LineDetailTypeEnum.TaxLineDetail                ;
					case "SalesItemLineDetail"          : return LineDetailTypeEnum.SalesItemLineDetail          ;
					case "ItemBasedExpenseLineDetail"   : return LineDetailTypeEnum.ItemBasedExpenseLineDetail   ;
					case "AccountBasedExpenseLineDetail": return LineDetailTypeEnum.AccountBasedExpenseLineDetail;
					case "DepositLineDetail"            : return LineDetailTypeEnum.DepositLineDetail            ;
					case "PurchaseOrderItemLineDetail"  : return LineDetailTypeEnum.PurchaseOrderItemLineDetail  ;
					case "ItemReceiptLineDetail"        : return LineDetailTypeEnum.ItemReceiptLineDetail        ;
					case "JournalEntryLineDetail"       : return LineDetailTypeEnum.JournalEntryLineDetail       ;
					case "GroupLineDetail"              : return LineDetailTypeEnum.GroupLineDetail              ;
					case "DescriptionOnly"              : return LineDetailTypeEnum.DescriptionOnly              ;
					case "SubTotalLineDetail"           : return LineDetailTypeEnum.SubTotalLineDetail           ;
					case "SalesOrderItemLineDetail"     : return LineDetailTypeEnum.SalesOrderItemLineDetail     ;
				}
			}
			return LineDetailTypeEnum.PaymentLineDetail;
		}

		public static TxnTypeEnum DeserializeTxnType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "APCreditCard"         : return TxnTypeEnum.APCreditCard         ;
					case "ARRefundCreditCard"   : return TxnTypeEnum.ARRefundCreditCard   ;
					case "Bill"                 : return TxnTypeEnum.Bill                 ;
					case "BillPaymentCheck"     : return TxnTypeEnum.BillPaymentCheck     ;
					case "BuildAssembly"        : return TxnTypeEnum.BuildAssembly        ;
					case "CarryOver"            : return TxnTypeEnum.CarryOver            ;
					case "CashPurchase"         : return TxnTypeEnum.CashPurchase         ;
					case "Charge"               : return TxnTypeEnum.Charge               ;
					case "Check"                : return TxnTypeEnum.Check                ;
					case "CreditMemo"           : return TxnTypeEnum.CreditMemo           ;
					case "Deposit"              : return TxnTypeEnum.Deposit              ;
					case "EFPLiabilityCheck"    : return TxnTypeEnum.EFPLiabilityCheck    ;
					case "EFTBillPayment"       : return TxnTypeEnum.EFTBillPayment       ;
					case "EFTRefund"            : return TxnTypeEnum.EFTRefund            ;
					case "Estimate"             : return TxnTypeEnum.Estimate             ;
					case "InventoryAdjustment"  : return TxnTypeEnum.InventoryAdjustment  ;
					case "InventoryTransfer"    : return TxnTypeEnum.InventoryTransfer    ;
					case "Invoice"              : return TxnTypeEnum.Invoice              ;
					case "ItemReceipt"          : return TxnTypeEnum.ItemReceipt          ;
					case "JournalEntry"         : return TxnTypeEnum.JournalEntry         ;
					case "LiabilityAdjustment"  : return TxnTypeEnum.LiabilityAdjustment  ;
					case "Paycheck"             : return TxnTypeEnum.Paycheck             ;
					case "PayrollLiabilityCheck": return TxnTypeEnum.PayrollLiabilityCheck;
					case "PurchaseOrder"        : return TxnTypeEnum.PurchaseOrder        ;
					case "PriorPayment"         : return TxnTypeEnum.PriorPayment         ;
					case "ReceivePayment"       : return TxnTypeEnum.ReceivePayment       ;
					case "RefundCheck"          : return TxnTypeEnum.RefundCheck          ;
					case "SalesOrder"           : return TxnTypeEnum.SalesOrder           ;
					case "SalesReceipt"         : return TxnTypeEnum.SalesReceipt         ;
					case "SalesTaxPaymentCheck" : return TxnTypeEnum.SalesTaxPaymentCheck ;
					case "Transfer"             : return TxnTypeEnum.Transfer             ;
					case "TimeActivity"         : return TxnTypeEnum.TimeActivity         ;
					case "VendorCredit"         : return TxnTypeEnum.VendorCredit         ;
					case "YTDAdjustment"        : return TxnTypeEnum.YTDAdjustment        ;
				}
			}
			return TxnTypeEnum.APCreditCard;
		}

		public static PrintStatusEnum DeserializePrintStatus(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "NotSet"       : return PrintStatusEnum.NotSet       ;
					case "NeedToPrint"  : return PrintStatusEnum.NeedToPrint  ;
					case "PrintComplete": return PrintStatusEnum.PrintComplete;
				}
			}
			return PrintStatusEnum.NotSet;
		}

		public static PaymentTypeEnum DeserializePaymentType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Cash"      : return PaymentTypeEnum.Cash      ;
					case "Check"     : return PaymentTypeEnum.Check     ;
					case "CreditCard": return PaymentTypeEnum.CreditCard;
					case "Expense"   : return PaymentTypeEnum.Expense   ;
					case "Other"     : return PaymentTypeEnum.Other     ;
				}
			}
			return PaymentTypeEnum.Cash;
		}

		public static SpecialTaxTypeEnum DeserializeSpecialTaxType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "NONE"           : return SpecialTaxTypeEnum.NONE           ;
					case "ZERO_RATE"      : return SpecialTaxTypeEnum.ZERO_RATE      ;
					case "FOREIGN_TAX"    : return SpecialTaxTypeEnum.FOREIGN_TAX    ;
					case "REVERSE_CHARGE" : return SpecialTaxTypeEnum.REVERSE_CHARGE ;
					case "ADJUSTMENT_RATE": return SpecialTaxTypeEnum.ADJUSTMENT_RATE;
				}
			}
			return SpecialTaxTypeEnum.NONE;
		}

		public static TaxRateDisplayTypeEnum DeserializeTaxRateDisplayType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "ReadOnly"              : return TaxRateDisplayTypeEnum.ReadOnly              ;
					case "HideInTransactionForms": return TaxRateDisplayTypeEnum.HideInTransactionForms;
					case "HideInPrintedForms"    : return TaxRateDisplayTypeEnum.HideInPrintedForms    ;
					case "HideInAll"             : return TaxRateDisplayTypeEnum.HideInAll             ;
				}
			}
			return TaxRateDisplayTypeEnum.ReadOnly;
		}

		public static DeliveryTypeEnum DeserializeDeliveryType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "Email"     : return DeliveryTypeEnum.Email     ;
					case "Tradeshift": return DeliveryTypeEnum.Tradeshift;
				}
			}
			return DeliveryTypeEnum.Email;
		}

		public static DeliveryErrorTypeEnum DeserializeDeliveryErrorType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "MissingInfo"       : return DeliveryErrorTypeEnum.MissingInfo       ;
					case "Undeliverable"     : return DeliveryErrorTypeEnum.Undeliverable     ;
					case "DeliveryServerDown": return DeliveryErrorTypeEnum.DeliveryServerDown;
					case "BouncedEmail"      : return DeliveryErrorTypeEnum.BouncedEmail      ;
				}
			}
			return DeliveryErrorTypeEnum.MissingInfo;
		}

		public static TaxTypeEnum DeserializeTaxType(JsonValue json)
		{
			if ( json != null )
			{
				string value = json.GetValue<string>();
				switch ( value )
				{
					case "TaxOnAmount"       : return TaxTypeEnum.TaxOnAmount       ;
					case "TaxOnAmountPlusTax": return TaxTypeEnum.TaxOnAmountPlusTax;
					case "TaxOnTax"          : return TaxTypeEnum.TaxOnTax          ;
				}
			}
			return TaxTypeEnum.TaxOnAmount;
		}
	}
}
