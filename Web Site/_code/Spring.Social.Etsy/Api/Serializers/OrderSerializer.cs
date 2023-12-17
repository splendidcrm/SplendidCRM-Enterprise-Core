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

namespace Spring.Social.Etsy.Api.Impl.Json
{
	class OrderSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Order o = obj as Order;
			
			JsonObject json = new JsonObject();
			/*
			if ( !Sql.IsEmptyString(o.Id           ) ) json.AddValue("Id"                   , new JsonValue(o.Id                   ));
			if ( !Sql.IsEmptyString(o.DocNumber    ) ) json.AddValue("DocNumber"            , new JsonValue(o.DocNumber            ));
			if ( !Sql.IsEmptyString(o.PrivateNote  ) ) json.AddValue("PrivateNote"          , new JsonValue(o.PrivateNote          ));
			if ( !Sql.IsEmptyString(o.TxnStatus    ) ) json.AddValue("TxnStatus"            , new JsonValue(o.TxnStatus            ));
			if ( !Sql.IsEmptyString(o.TxnSource    ) ) json.AddValue("TxnSource"            , new JsonValue(o.TxnSource            ));
			if ( !Sql.IsEmptyString(o.PONumber     ) ) json.AddValue("PONumber"             , new JsonValue(o.PONumber             ));
			if ( !Sql.IsEmptyString(o.FOB          ) ) json.AddValue("FOB"                  , new JsonValue(o.FOB                  ));
			if ( !Sql.IsEmptyString(o.TrackingNum  ) ) json.AddValue("TrackingNum"          , new JsonValue(o.TrackingNum          ));
			if ( !Sql.IsEmptyString(o.PaymentRefNum) ) json.AddValue("PaymentRefNum"        , new JsonValue(o.PaymentRefNum        ));
			if ( o.TxnDate              .HasValue    ) json.AddValue("TxnDate"              , new JsonValue(o.TxnDate              .Value.ToString("yyyy-MM-dd")));
			if ( o.ExchangeRate         .HasValue    ) json.AddValue("ExchangeRate"         , new JsonValue(o.ExchangeRate         .Value));
			if ( o.AutoDocNumber        .HasValue    ) json.AddValue("AutoDocNumber"        , new JsonValue(o.AutoDocNumber        .Value));
			if ( o.DueDate              .HasValue    ) json.AddValue("DueDate"              , new JsonValue(o.DueDate              .Value.ToString("yyyy-MM-dd")));
			if ( o.ShipDate             .HasValue    ) json.AddValue("ShipDate"             , new JsonValue(o.ShipDate             .Value.ToString("yyyy-MM-dd")));
			if ( o.TotalAmt             .HasValue    ) json.AddValue("TotalAmt"             , new JsonValue(o.TotalAmt             .Value));
			if ( o.HomeTotalAmt         .HasValue    ) json.AddValue("HomeTotalAmt"         , new JsonValue(o.HomeTotalAmt         .Value));
			if ( o.ApplyTaxAfterDiscount.HasValue    ) json.AddValue("ApplyTaxAfterDiscount", new JsonValue(o.ApplyTaxAfterDiscount.Value));
			if ( o.Balance              .HasValue    ) json.AddValue("Balance"              , new JsonValue(o.Balance              .Value));
			if ( o.FinanceCharge        .HasValue    ) json.AddValue("FinanceCharge"        , new JsonValue(o.FinanceCharge        .Value));
			if ( o.ManuallyClosed       .HasValue    ) json.AddValue("ManuallyClosed"       , new JsonValue(o.ManuallyClosed       .Value));
			if ( o.GlobalTaxCalculation .HasValue    ) json.AddValue("GlobalTaxCalculation" , _EnumSerializer.Serialize(o.GlobalTaxCalculation.Value));
			if ( o.PrintStatus          .HasValue    ) json.AddValue("PrintStatus"          , _EnumSerializer.Serialize(o.PrintStatus         .Value));
			if ( o.EmailStatus          .HasValue    ) json.AddValue("EmailStatus"          , _EnumSerializer.Serialize(o.EmailStatus         .Value));
			if ( o.PaymentType          .HasValue    ) json.AddValue("PaymentType"          , _EnumSerializer.Serialize(o.PaymentType         .Value));
			if ( o.DepartmentRef        != null      ) json.AddValue("DepartmentRef"        , mapper.Serialize(o.DepartmentRef      ));
			if ( o.CurrencyRef          != null      ) json.AddValue("CurrencyRef"          , mapper.Serialize(o.CurrencyRef        ));
			if ( o.LinkedTxns           != null      ) json.AddValue("LinkedTxn"            , mapper.Serialize(o.LinkedTxns         ));
			if ( o.Lines                != null      ) json.AddValue("Line"                 , mapper.Serialize(o.Lines              ));
			if ( o.TxnTaxDetail         != null      ) json.AddValue("TxnTaxDetail"         , mapper.Serialize(o.TxnTaxDetail       ));
			if ( o.CustomerRef          != null      ) json.AddValue("CustomerRef"          , mapper.Serialize(o.CustomerRef        ));
			if ( o.CustomerMemo         != null      ) json.AddValue("CustomerMemo"         , mapper.Serialize(o.CustomerMemo       ));
			if ( o.BillAddr             != null      ) json.AddValue("BillAddr"             , mapper.Serialize(o.BillAddr           ));
			if ( o.ShipAddr             != null      ) json.AddValue("ShipAddr"             , mapper.Serialize(o.ShipAddr           ));
			if ( o.RemitToRef           != null      ) json.AddValue("RemitToRef"           , mapper.Serialize(o.RemitToRef         ));
			if ( o.ClassRef             != null      ) json.AddValue("ClassRef"             , mapper.Serialize(o.ClassRef           ));
			if ( o.SalesTermRef         != null      ) json.AddValue("SalesTermRef"         , mapper.Serialize(o.SalesTermRef       ));
			if ( o.SalesRepRef          != null      ) json.AddValue("SalesRepRef"          , mapper.Serialize(o.SalesRepRef        ));
			if ( o.ShipMethodRef        != null      ) json.AddValue("ShipMethodRef"        , mapper.Serialize(o.ShipMethodRef      ));
			if ( o.TemplateRef          != null      ) json.AddValue("TemplateRef"          , mapper.Serialize(o.TemplateRef        ));
			if ( o.BillEmail            != null      ) json.AddValue("BillEmail"            , mapper.Serialize(o.BillEmail          ));
			if ( o.ARAccountRef         != null      ) json.AddValue("ARAccountRef"         , mapper.Serialize(o.ARAccountRef       ));
			if ( o.PaymentMethodRef     != null      ) json.AddValue("PaymentMethodRef"     , mapper.Serialize(o.PaymentMethodRef   ));
			if ( o.DepositToAccountRef  != null      ) json.AddValue("DepositToAccountRef"  , mapper.Serialize(o.DepositToAccountRef));
			if ( o.DeliveryInfo         != null      ) json.AddValue("DeliveryInfo"         , mapper.Serialize(o.DeliveryInfo       ));
			*/
			o.RawContent = json.ToString();
			return json;
		}
	}
}
