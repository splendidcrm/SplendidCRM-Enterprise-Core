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
	class AccountBasedExpenseLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			AccountBasedExpenseLineDetail o = obj as AccountBasedExpenseLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.CustomerRef    != null   ) json.AddValue("CustomerRef"    , mapper.Serialize(o.CustomerRef));
			if ( o.ClassRef       != null   ) json.AddValue("ClassRef"       , mapper.Serialize(o.ClassRef   ));
			if ( o.AccountRef     != null   ) json.AddValue("AccountRef"     , mapper.Serialize(o.AccountRef ));
			if ( o.BillableStatus .HasValue ) json.AddValue("BillableStatus" , _EnumSerializer.Serialize(o.BillableStatus.Value));
			if ( o.MarkupInfo     != null   ) json.AddValue("MarkupInfo"     , mapper.Serialize(o.MarkupInfo ));
			if ( o.TaxAmount      .HasValue ) json.AddValue("TaxAmount"      , new JsonValue(o.TaxAmount      .Value));
			if ( o.TaxCodeRef     != null   ) json.AddValue("TaxCodeRef"     , mapper.Serialize(o.TaxCodeRef ));
			if ( o.TaxInclusiveAmt.HasValue ) json.AddValue("TaxInclusiveAmt", new JsonValue(o.TaxInclusiveAmt.Value));
			return json;
		}
	}

	class DepositLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			DepositLineDetail o = obj as DepositLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.Entity           != null   ) json.AddValue("Entity"          , mapper.Serialize(o.Entity          ));
			if ( o.ClassRef         != null   ) json.AddValue("ClassRef"        , mapper.Serialize(o.ClassRef        ));
			if ( o.AccountRef       != null   ) json.AddValue("AccountRef"      , mapper.Serialize(o.AccountRef      ));
			if ( o.PaymentMethodRef != null   ) json.AddValue("PaymentMethodRef", mapper.Serialize(o.PaymentMethodRef));
			if ( o.CheckNum         != null   ) json.AddValue("CheckNum"        , new JsonValue(o.CheckNum));
			if ( o.TxnType          .HasValue ) json.AddValue("TxnType"         , _EnumSerializer.Serialize(o.TxnType.Value));
			return json;
		}
	}

	class DescriptionLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			DescriptionLineDetail o = obj as DescriptionLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.ServiceDate.HasValue ) json.AddValue("ServiceDate", new JsonValue(o.ServiceDate.Value.ToString("yyyy-MM-dd")));
			return json;
		}
	}

	class DiscountLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			DiscountLineDetail o = obj as DiscountLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.Discount           != null   ) json.AddValue("Discount"           , mapper.Serialize(o.Discount          ));
			if ( o.ClassRef           != null   ) json.AddValue("ClassRef"           , mapper.Serialize(o.ClassRef          ));
			if ( o.TaxCodeRef         != null   ) json.AddValue("TaxCodeRef"         , mapper.Serialize(o.TaxCodeRef        ));
			if ( o.DiscountAccountRef != null   ) json.AddValue("DiscountAccountRef" , mapper.Serialize(o.DiscountAccountRef));
			return json;
		}
	}

	class GroupLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			GroupLineDetail o = obj as GroupLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.GroupItemRef != null   ) json.AddValue("GroupItemRef", mapper.Serialize(o.GroupItemRef));
			if ( o.Quantity     .HasValue ) json.AddValue("Quantity"    , new JsonValue(o.Quantity   .Value));
			if ( o.UOMRef       != null   ) json.AddValue("UOMRef"      , mapper.Serialize(o.UOMRef      ));
			if ( o.ServiceDate  .HasValue ) json.AddValue("ServiceDate" , new JsonValue(o.ServiceDate.Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			if ( o.Line         != null   ) json.AddValue("Line"        , mapper.Serialize(o.Line        ));
			return json;
		}
	}

	class JournalEntryLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			JournalEntryLineDetail o = obj as JournalEntryLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.PostingType    .HasValue ) json.AddValue("PostingType"    , _EnumSerializer.Serialize(o.PostingType    .Value));
			if ( o.Entity         != null   ) json.AddValue("Entity"         , mapper.Serialize(o.Entity       ));
			if ( o.AccountRef     != null   ) json.AddValue("AccountRef"     , mapper.Serialize(o.AccountRef   ));
			if ( o.ClassRef       != null   ) json.AddValue("ClassRef"       , mapper.Serialize(o.ClassRef     ));
			if ( o.DepartmentRef  != null   ) json.AddValue("DepartmentRef"  , mapper.Serialize(o.DepartmentRef));
			if ( o.TaxCodeRef     != null   ) json.AddValue("TaxCodeRef"     , mapper.Serialize(o.TaxCodeRef   ));
			if ( o.TaxApplicableOn.HasValue ) json.AddValue("TaxApplicableOn", _EnumSerializer.Serialize(o.TaxApplicableOn.Value));
			if ( o.TaxAmount      .HasValue ) json.AddValue("TaxAmount"      , new JsonValue(o.TaxAmount.Value));
			if ( o.BillableStatus .HasValue ) json.AddValue("BillableStatus" , _EnumSerializer.Serialize(o.BillableStatus .Value));
			return json;
		}
	}

	class ItemBasedExpenseLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			ItemBasedExpenseLineDetail o = obj as ItemBasedExpenseLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.CustomerRef    != null   ) json.AddValue("CustomerRef"    , mapper.Serialize(o.CustomerRef));
			if ( o.BillableStatus .HasValue ) json.AddValue("BillableStatus" , _EnumSerializer.Serialize(o.BillableStatus.Value));
			if ( o.TaxInclusiveAmt.HasValue ) json.AddValue("TaxInclusiveAmt", new JsonValue(o.TaxInclusiveAmt.Value));
			return json;
		}
	}

	class ItemReceiptLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			ItemReceiptLineDetail o = obj as ItemReceiptLineDetail;
			
			JsonObject json = new JsonObject();
			return json;
		}
	}

	class PaymentLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			PaymentLineDetail o = obj as PaymentLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.ItemRef    != null   ) json.AddValue("ItemRef"    , mapper.Serialize(o.ItemRef ));
			if ( o.ServiceDate.HasValue ) json.AddValue("ServiceDate", new JsonValue(o.ServiceDate.Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			if ( o.ClassRef   != null   ) json.AddValue("ClassRef"   , mapper.Serialize(o.ClassRef));
			if ( o.Balance    .HasValue ) json.AddValue("Balance"    , new JsonValue(o.Balance    .Value));
			if ( o.Discount   != null   ) json.AddValue("Discount"   , mapper.Serialize(o.Discount));
			return json;
		}
	}

	class PurchaseOrderItemLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			PurchaseOrderItemLineDetail o = obj as PurchaseOrderItemLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.ManPartNum    != null   ) json.AddValue("ManPartNum"    , new JsonValue(o.ManPartNum          ));
			if ( o.ManuallyClosed.HasValue ) json.AddValue("ManuallyClosed", new JsonValue(o.ManuallyClosed.Value));
			if ( o.OpenQty       .HasValue ) json.AddValue("OpenQty"       , new JsonValue(o.OpenQty       .Value));
			return json;
		}
	}

	class SalesItemLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			SalesItemLineDetail o = obj as SalesItemLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.ItemRef        != null   ) json.AddValue("ItemRef"        , mapper.Serialize(o.ItemRef       ));
			if ( o.UnitPrice      .HasValue ) json.AddValue("UnitPrice"      , new JsonValue(o.UnitPrice      .Value));
			if ( o.Qty            .HasValue ) json.AddValue("Qty"            , new JsonValue(o.Qty            .Value));
			if ( o.TaxCodeRef     != null   ) json.AddValue("TaxCodeRef"     , mapper.Serialize(o.TaxCodeRef    ));
			if ( o.ServiceDate    .HasValue ) json.AddValue("ServiceDate"    , new JsonValue(o.ServiceDate    .Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			if ( o.TaxInclusiveAmt.HasValue ) json.AddValue("TaxInclusiveAmt", new JsonValue(o.TaxInclusiveAmt.Value));
			return json;
		}
	}

	class SalesOrderItemLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			SalesOrderItemLineDetail o = obj as SalesOrderItemLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.ManuallyClosed.HasValue ) json.AddValue("ManuallyClosed", new JsonValue(o.ManuallyClosed.Value));
			return json;
		}
	}

	class SubTotalLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			SubTotalLineDetail o = obj as SubTotalLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.ItemRef    != null   ) json.AddValue("ItemRef"    , mapper.Serialize(o.ItemRef));
			if ( o.ServiceDate.HasValue ) json.AddValue("ServiceDate", new JsonValue(o.ServiceDate.Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			return json;
		}
	}

	class TaxLineDetailSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			TaxLineDetail o = obj as TaxLineDetail;
			
			JsonObject json = new JsonObject();
			if ( o.TaxRateRef         != null   ) json.AddValue("TaxRateRef"         , mapper.Serialize(o.TaxRateRef));
			if ( o.PercentBased       .HasValue ) json.AddValue("PercentBased"       , new JsonValue(o.PercentBased       .Value));
			if ( o.TaxPercent         .HasValue ) json.AddValue("TaxPercent"         , new JsonValue(o.TaxPercent         .Value));
			if ( o.NetAmountTaxable   .HasValue ) json.AddValue("NetAmountTaxable"   , new JsonValue(o.NetAmountTaxable   .Value));
			if ( o.TaxInclusiveAmount .HasValue ) json.AddValue("TaxInclusiveAmount" , new JsonValue(o.TaxInclusiveAmount .Value));
			if ( o.OverrideDeltaAmount.HasValue ) json.AddValue("OverrideDeltaAmount", new JsonValue(o.OverrideDeltaAmount.Value));
			if ( o.ServiceDate        .HasValue ) json.AddValue("ServiceDate"        , new JsonValue(o.ServiceDate        .Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			return json;
		}
	}
}
