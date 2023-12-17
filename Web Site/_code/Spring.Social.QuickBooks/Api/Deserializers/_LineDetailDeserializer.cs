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
	class AccountBasedExpenseLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			AccountBasedExpenseLineDetail obj = new AccountBasedExpenseLineDetail();
			obj.TaxAmount       = json.GetValueOrDefault<Decimal?>("TaxAmount"      );
			obj.TaxInclusiveAmt = json.GetValueOrDefault<Decimal?>("TaxInclusiveAmt");

			if ( json.ContainsName("BillableStatus") ) obj.BillableStatus = _EnumDeserializer.DeserializeBillableStatus(json.GetValue("BillableStatus"));

			JsonValue customerRef = json.GetValue("CustomerRef");
			JsonValue classRef    = json.GetValue("ClassRef"   );
			JsonValue accountRef  = json.GetValue("AccountRef" );
			JsonValue markupInfo  = json.GetValue("MarkupInfo" );
			JsonValue taxCodeRef  = json.GetValue("TaxCodeRef" );
			if ( customerRef != null && customerRef.IsObject ) obj.CustomerRef = mapper.Deserialize<ReferenceType>(customerRef);
			if ( classRef    != null && classRef   .IsObject ) obj.ClassRef    = mapper.Deserialize<ReferenceType>(classRef   );
			if ( accountRef  != null && accountRef .IsObject ) obj.AccountRef  = mapper.Deserialize<ReferenceType>(accountRef );
			if ( markupInfo  != null && markupInfo .IsObject ) obj.MarkupInfo  = mapper.Deserialize<MarkupInfo   >(markupInfo );
			if ( taxCodeRef  != null && taxCodeRef .IsObject ) obj.TaxCodeRef  = mapper.Deserialize<ReferenceType>(taxCodeRef );
			return obj;
		}
	}

	class DepositLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			DepositLineDetail obj = new DepositLineDetail();
			obj.CheckNum = json.GetValueOrDefault<String>("CheckNum");

			if ( json.ContainsName("TxnType") ) obj.TxnType = _EnumDeserializer.DeserializeTxnType(json.GetValue("TxnType"));

			JsonValue entity           = json.GetValue("Entity"          );
			JsonValue classRef         = json.GetValue("ClassRef"        );
			JsonValue accountRef       = json.GetValue("AccountRef"      );
			JsonValue paymentMethodRef = json.GetValue("PaymentMethodRef");
			if ( entity           != null && entity          .IsObject ) obj.Entity           = mapper.Deserialize<ReferenceType>(entity          );
			if ( classRef         != null && classRef        .IsObject ) obj.ClassRef         = mapper.Deserialize<ReferenceType>(classRef        );
			if ( accountRef       != null && accountRef      .IsObject ) obj.AccountRef       = mapper.Deserialize<ReferenceType>(accountRef      );
			if ( paymentMethodRef != null && paymentMethodRef.IsObject ) obj.PaymentMethodRef = mapper.Deserialize<ReferenceType>(paymentMethodRef);
			return obj;
		}
	}

	class DescriptionLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			DescriptionLineDetail obj = new DescriptionLineDetail();
			obj.ServiceDate = json.GetValueOrDefault<DateTime?>("ServiceDate");
			return obj;
		}
	}

	class DiscountLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			DiscountLineDetail obj = new DiscountLineDetail();

			JsonValue discount           = json.GetValue("Discount"          );
			JsonValue classRef           = json.GetValue("ClassRef"          );
			JsonValue taxCodeRef         = json.GetValue("TaxCodeRef"        );
			JsonValue discountAccountRef = json.GetValue("DiscountAccountRef");
			if ( discount           != null && discount          .IsObject ) obj.Discount           = mapper.Deserialize<DiscountOverride>(discount          );
			if ( classRef           != null && classRef          .IsObject ) obj.ClassRef           = mapper.Deserialize<ReferenceType   >(classRef          );
			if ( taxCodeRef         != null && taxCodeRef        .IsObject ) obj.TaxCodeRef         = mapper.Deserialize<ReferenceType   >(taxCodeRef        );
			if ( discountAccountRef != null && discountAccountRef.IsObject ) obj.DiscountAccountRef = mapper.Deserialize<ReferenceType   >(discountAccountRef);
			return obj;
		}
	}

	class GroupLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			GroupLineDetail obj = new GroupLineDetail();
			obj.Quantity    = json.GetValueOrDefault<Decimal? >("Quantity"   );
			obj.ServiceDate = json.GetValueOrDefault<DateTime?>("ServiceDate");

			JsonValue groupItemRef = json.GetValue("GroupItemRef");
			JsonValue uOMRef       = json.GetValue("UOMRef"      );
			JsonValue line         = json.GetValue("Line"        );
			if ( groupItemRef != null && groupItemRef.IsObject ) obj.GroupItemRef = mapper.Deserialize<ReferenceType>(groupItemRef);
			if ( uOMRef       != null && uOMRef      .IsObject ) obj.UOMRef       = mapper.Deserialize<UOMRef       >(uOMRef      );
			if ( line         != null && line        .IsArray  ) obj.Line         = mapper.Deserialize<IList<Line>  >(line        );
			return obj;
		}
	}

	class JournalEntryLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			JournalEntryLineDetail obj = new JournalEntryLineDetail();
			obj.TaxAmount = json.GetValueOrDefault<Decimal?>("TaxAmount");

			if ( json.ContainsName("PostingType"    ) ) obj.PostingType     = _EnumDeserializer.DeserializePostingType    (json.GetValue("PostingType"    ));
			if ( json.ContainsName("TaxApplicableOn") ) obj.TaxApplicableOn = _EnumDeserializer.DeserializeTaxApplicableOn(json.GetValue("TaxApplicableOn"));
			if ( json.ContainsName("BillableStatus" ) ) obj.BillableStatus  = _EnumDeserializer.DeserializeBillableStatus (json.GetValue("BillableStatus" ));

			JsonValue entity        = json.GetValue("Entity"       );
			JsonValue accountRef    = json.GetValue("AccountRef"   );
			JsonValue classRef      = json.GetValue("ClassRef"     );
			JsonValue departmentRef = json.GetValue("DepartmentRef");
			JsonValue taxCodeRef    = json.GetValue("TaxCodeRef"   );
			if ( entity        != null && entity       .IsObject ) obj.Entity        = mapper.Deserialize<EntityTypeRef>(entity       );
			if ( accountRef    != null && accountRef   .IsObject ) obj.AccountRef    = mapper.Deserialize<ReferenceType>(accountRef   );
			if ( classRef      != null && classRef     .IsObject ) obj.ClassRef      = mapper.Deserialize<ReferenceType>(classRef     );
			if ( departmentRef != null && departmentRef.IsObject ) obj.DepartmentRef = mapper.Deserialize<ReferenceType>(departmentRef);
			if ( taxCodeRef    != null && taxCodeRef   .IsObject ) obj.TaxCodeRef    = mapper.Deserialize<ReferenceType>(taxCodeRef   );
			return obj;
		}
	}

	class ItemBasedExpenseLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ItemBasedExpenseLineDetail obj = new ItemBasedExpenseLineDetail();
			obj.TaxInclusiveAmt = json.GetValueOrDefault<Decimal?>("TaxInclusiveAmt");

			if ( json.ContainsName("BillableStatus") ) obj.BillableStatus = _EnumDeserializer.DeserializeBillableStatus(json.GetValue("BillableStatus"));

			JsonValue customerRef = json.GetValue("CustomerRef");
			if ( customerRef != null && customerRef.IsObject ) obj.CustomerRef = mapper.Deserialize<ReferenceType>(customerRef);
			return obj;
		}
	}

	class ItemReceiptLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ItemReceiptLineDetail obj = new ItemReceiptLineDetail();
			return obj;
		}
	}

	class PaymentLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			PaymentLineDetail obj = new PaymentLineDetail();
			obj.ServiceDate = json.GetValueOrDefault<DateTime?>("ServiceDate");
			obj.Balance     = json.GetValueOrDefault<Decimal? >("Balance"    );

			JsonValue itemRef  = json.GetValue("ItemRef" );
			JsonValue classRef = json.GetValue("ClassRef");
			JsonValue discount = json.GetValue("Discount");
			if ( itemRef  != null && itemRef .IsObject ) obj.ItemRef  = mapper.Deserialize<ReferenceType   >(itemRef );
			if ( classRef != null && classRef.IsObject ) obj.ClassRef = mapper.Deserialize<ReferenceType   >(classRef);
			if ( discount != null && discount.IsObject ) obj.Discount = mapper.Deserialize<DiscountOverride>(discount);
			return obj;
		}
	}

	class PurchaseOrderItemLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			PurchaseOrderItemLineDetail obj = new PurchaseOrderItemLineDetail();
			obj.ManPartNum     = json.GetValueOrDefault<String  >("ManPartNum"    );
			obj.ManuallyClosed = json.GetValueOrDefault<Boolean?>("ManuallyClosed");
			obj.OpenQty        = json.GetValueOrDefault<Decimal?>("OpenQty"       );
			return obj;
		}
	}

	class SalesItemLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			SalesItemLineDetail obj = new SalesItemLineDetail();
			obj.UnitPrice       = json.GetValueOrDefault<Decimal? >("UnitPrice"      );
			obj.Qty             = json.GetValueOrDefault<Decimal? >("Qty"            );
			obj.ServiceDate     = json.GetValueOrDefault<DateTime?>("ServiceDate"    );
			obj.TaxInclusiveAmt = json.GetValueOrDefault<Decimal? >("TaxInclusiveAmt");
			
			JsonValue itemRef    = json.GetValue("ItemRef"   );
			JsonValue taxCodeRef = json.GetValue("TaxCodeRef");
			if ( itemRef    != null && itemRef   .IsObject ) obj.ItemRef    = mapper.Deserialize<ReferenceType>(itemRef   );
			if ( taxCodeRef != null && taxCodeRef.IsObject ) obj.TaxCodeRef = mapper.Deserialize<ReferenceType>(taxCodeRef);
			return obj;
		}
	}

	class SalesOrderItemLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			SalesOrderItemLineDetail obj = new SalesOrderItemLineDetail();
			obj.ManuallyClosed = json.GetValueOrDefault<Boolean?>("ManuallyClosed");
			return obj;
		}
	}

	class SubTotalLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			SubTotalLineDetail obj = new SubTotalLineDetail();
			obj.ServiceDate = json.GetValueOrDefault<DateTime?>("ServiceDate");

			JsonValue itemRef = json.GetValue("ItemRef");
			if ( itemRef != null && itemRef.IsObject ) obj.ItemRef = mapper.Deserialize<ReferenceType>(itemRef);
			return obj;
		}
	}

	class TaxLineDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			TaxLineDetail obj = new TaxLineDetail();
			obj.PercentBased        = json.GetValueOrDefault<Boolean? >("PercentBased"       );
			obj.TaxPercent          = json.GetValueOrDefault<Decimal? >("TaxPercent"         );
			obj.NetAmountTaxable    = json.GetValueOrDefault<Decimal? >("NetAmountTaxable"   );
			obj.TaxInclusiveAmount  = json.GetValueOrDefault<Decimal? >("TaxInclusiveAmount" );
			obj.OverrideDeltaAmount = json.GetValueOrDefault<Decimal? >("OverrideDeltaAmount");
			obj.ServiceDate         = json.GetValueOrDefault<DateTime?>("ServiceDate"        );

			JsonValue taxRateRef = json.GetValue("TaxRateRef");
			if ( taxRateRef != null && taxRateRef.IsObject ) obj.TaxRateRef = mapper.Deserialize<ReferenceType>(taxRateRef);
			return obj;
		}
	}
}
