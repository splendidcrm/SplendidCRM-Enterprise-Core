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
	public class _EnumSerializer
	{
		public static JsonValue Serialize(BillableStatusEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(AccountTypeEnum e)
		{
			// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/account#Account_Classifications
			JsonValue json = null;
			switch ( e )
			{
				case AccountTypeEnum.Bank                 : json = new JsonValue("Bank"                 );  break;
				case AccountTypeEnum.AccountsReceivable   : json = new JsonValue("Accounts Receivable"  );  break;
				case AccountTypeEnum.OtherCurrentAsset    : json = new JsonValue("Other Current Asset"  );  break;
				case AccountTypeEnum.FixedAsset           : json = new JsonValue("Fixed Asset"          );  break;
				case AccountTypeEnum.OtherAsset           : json = new JsonValue("Other Asset"          );  break;
				case AccountTypeEnum.AccountsPayable      : json = new JsonValue("Accounts Payable"     );  break;
				case AccountTypeEnum.CreditCard           : json = new JsonValue("CreditCard"           );  break;
				case AccountTypeEnum.OtherCurrentLiability: json = new JsonValue("OtherCurrentLiability");  break;
				case AccountTypeEnum.LongTermLiability    : json = new JsonValue("LongTermLiability"    );  break;
				case AccountTypeEnum.Equity               : json = new JsonValue("Equity"               );  break;
				case AccountTypeEnum.Income               : json = new JsonValue("Income"               );  break;
				case AccountTypeEnum.CostofGoodsSold      : json = new JsonValue("CostofGoodsSold"      );  break;
				case AccountTypeEnum.Expense              : json = new JsonValue("Expense"              );  break;
				case AccountTypeEnum.OtherIncome          : json = new JsonValue("OtherIncome"          );  break;
				case AccountTypeEnum.OtherExpense         : json = new JsonValue("OtherExpense"         );  break;
				case AccountTypeEnum.NonPosting           : json = new JsonValue("NonPosting"           );  break;
			}
			return json;
		}

		public static JsonValue Serialize(AccountClassificationEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(ContactTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(CCTxnModeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(CCTxnTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(CurrencyCode e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(SymbolPositionEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(EntityTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(GlobalTaxCalculationEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(ItemChoiceType4 e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(EmailStatusEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(ETransactionStatusEnum e)
		{
			JsonValue json = null;
			switch ( e )
			{
				case ETransactionStatusEnum.Sent            : json = new JsonValue("Sent"               );  break;
				case ETransactionStatusEnum.Viewed          : json = new JsonValue("Viewed"             );  break;
				case ETransactionStatusEnum.Paid            : json = new JsonValue("Paid"               );  break;
				case ETransactionStatusEnum.DeliveryError   : json = new JsonValue("Delivery Error"     );  break;
				case ETransactionStatusEnum.Updated         : json = new JsonValue("Updated"            );  break;
				case ETransactionStatusEnum.Error           : json = new JsonValue("Error"              );  break;
				case ETransactionStatusEnum.Accepted        : json = new JsonValue("Accepted"           );  break;
				case ETransactionStatusEnum.Rejected        : json = new JsonValue("Rejected"           );  break;
				case ETransactionStatusEnum.SentWithICNError: json = new JsonValue("Sent With ICN Error");  break;
				case ETransactionStatusEnum.Delivered       : json = new JsonValue("Delivered"          );  break;
				case ETransactionStatusEnum.Disputed        : json = new JsonValue("Disputed"           );  break;
			}
			return json;
		}

		public static JsonValue Serialize(ItemTypeEnum e)
		{
			JsonValue json = null;
			switch ( e )
			{
				case ItemTypeEnum.Assembly    : json = new JsonValue("Assembly"    );  break;
				case ItemTypeEnum.FixedAsset  : json = new JsonValue("Fixed Asset" );  break;
				case ItemTypeEnum.Group       : json = new JsonValue("Group"       );  break;
				case ItemTypeEnum.Inventory   : json = new JsonValue("Inventory"   );  break;
				case ItemTypeEnum.NonInventory: json = new JsonValue("NonInventory");  break;
				case ItemTypeEnum.OtherCharge : json = new JsonValue("Other Charge");  break;
				case ItemTypeEnum.Payment     : json = new JsonValue("Payment"     );  break;
				case ItemTypeEnum.Service     : json = new JsonValue("Service"     );  break;
				case ItemTypeEnum.Subtotal    : json = new JsonValue("Subtotal"    );  break;
				case ItemTypeEnum.Discount    : json = new JsonValue("Discount"    );  break;
				case ItemTypeEnum.Tax         : json = new JsonValue("Tax"         );  break;
				case ItemTypeEnum.TaxGroup    : json = new JsonValue("Tax Group"   );  break;
			}
			return json;
		}

		public static JsonValue Serialize(SpecialItemTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(JobStatusEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(PostingTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(TaxApplicableOnEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(LineDetailTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(TxnTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(PrintStatusEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(PaymentTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(SpecialTaxTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(TaxRateDisplayTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(DeliveryTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(DeliveryErrorTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}

		public static JsonValue Serialize(TaxTypeEnum e)
		{
			JsonValue json = new JsonValue(e.ToString());
			return json;
		}
	}
}
