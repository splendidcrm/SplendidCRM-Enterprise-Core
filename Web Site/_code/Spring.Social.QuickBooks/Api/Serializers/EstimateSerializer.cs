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
	class EstimateSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Estimate o = obj as Estimate;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Id         ) ) json.AddValue("Id"                   , new JsonValue(o.Id                   ));
			if ( !Sql.IsEmptyString(o.SyncToken  ) ) json.AddValue("SyncToken"            , new JsonValue(o.SyncToken            ));
			if ( !Sql.IsEmptyString(o.DocNumber  ) ) json.AddValue("DocNumber"            , new JsonValue(o.DocNumber            ));
			if ( !Sql.IsEmptyString(o.PrivateNote) ) json.AddValue("PrivateNote"          , new JsonValue(o.PrivateNote          ));
			if ( !Sql.IsEmptyString(o.TxnStatus  ) ) json.AddValue("TxnStatus"            , new JsonValue(o.TxnStatus            ));
			if ( !Sql.IsEmptyString(o.AcceptedBy ) ) json.AddValue("AcceptedBy"           , new JsonValue(o.AcceptedBy           ));
			if ( o.TxnDate              .HasValue  ) json.AddValue("TxnDate"              , new JsonValue(o.TxnDate              .Value.ToString("yyyy-MM-dd")));
			if ( o.ExchangeRate         .HasValue  ) json.AddValue("ExchangeRate"         , new JsonValue(o.ExchangeRate         .Value));
			if ( o.ShipDate             .HasValue  ) json.AddValue("ShipDate"             , new JsonValue(o.ShipDate             .Value.ToString("yyyy-MM-dd")));
			if ( o.TotalAmt             .HasValue  ) json.AddValue("TotalAmt"             , new JsonValue(o.TotalAmt             .Value));
			if ( o.ApplyTaxAfterDiscount.HasValue  ) json.AddValue("ApplyTaxAfterDiscount", new JsonValue(o.ApplyTaxAfterDiscount.Value));
			if ( o.ExpirationDate       .HasValue  ) json.AddValue("ExpirationDate"       , new JsonValue(o.ExpirationDate       .Value.ToString("yyyy-MM-dd")));
			if ( o.AcceptedDate         .HasValue  ) json.AddValue("AcceptedDate"         , new JsonValue(o.AcceptedDate         .Value.ToString("yyyy-MM-dd")));
			if ( o.GlobalTaxCalculation .HasValue  ) json.AddValue("GlobalTaxCalculation" , _EnumSerializer.Serialize(o.GlobalTaxCalculation.Value));
			if ( o.PrintStatus          .HasValue  ) json.AddValue("PrintStatus"          , _EnumSerializer.Serialize(o.PrintStatus         .Value));
			if ( o.EmailStatus          .HasValue  ) json.AddValue("EmailStatus"          , _EnumSerializer.Serialize(o.EmailStatus         .Value));
			if ( o.DepartmentRef        != null    ) json.AddValue("DepartmentRef"        , mapper.Serialize(o.DepartmentRef      ));
			if ( o.CurrencyRef          != null    ) json.AddValue("CurrencyRef"          , mapper.Serialize(o.CurrencyRef        ));
			if ( o.LinkedTxns           != null    ) json.AddValue("LinkedTxn"            , mapper.Serialize(o.LinkedTxns         ));
			if ( o.Lines                != null    ) json.AddValue("Line"                 , mapper.Serialize(o.Lines              ));
			if ( o.TxnTaxDetail         != null    ) json.AddValue("TxnTaxDetail"         , mapper.Serialize(o.TxnTaxDetail       ));
			if ( o.CustomerRef          != null    ) json.AddValue("CustomerRef"          , mapper.Serialize(o.CustomerRef        ));
			if ( o.CustomerMemo         != null    ) json.AddValue("CustomerMemo"         , mapper.Serialize(o.CustomerMemo       ));
			if ( o.BillAddr             != null    ) json.AddValue("BillAddr"             , mapper.Serialize(o.BillAddr           ));
			if ( o.ShipAddr             != null    ) json.AddValue("ShipAddr"             , mapper.Serialize(o.ShipAddr           ));
			if ( o.ClassRef             != null    ) json.AddValue("ClassRef"             , mapper.Serialize(o.ClassRef           ));
			if ( o.SalesTermRef         != null    ) json.AddValue("SalesTermRef"         , mapper.Serialize(o.SalesTermRef       ));
			if ( o.ShipMethodRef        != null    ) json.AddValue("ShipMethodRef"        , mapper.Serialize(o.ShipMethodRef      ));
			if ( o.BillEmail            != null    ) json.AddValue("BillEmail"            , mapper.Serialize(o.BillEmail          ));
			// 02/01/2015  Paul.  QBO is required. 
			// https://developer.intuit.com/docs/95_legacy/qbd_v3/qbd_v3_reference/020_key_concepts/050_sparse_update
			json.AddValue("domain", new JsonValue("QBO"  ));
			json.AddValue("sparse", new JsonValue("false"));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
