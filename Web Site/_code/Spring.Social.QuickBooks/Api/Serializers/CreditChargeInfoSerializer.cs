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
	class CreditChargeInfoSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			CreditChargeInfo o = obj as CreditChargeInfo;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Number            ) ) json.AddValue("Number"            , new JsonValue(o.Number              ));
			if ( !Sql.IsEmptyString(o.Type              ) ) json.AddValue("Type"              , new JsonValue(o.Type                ));
			if ( !Sql.IsEmptyString(o.NameOnAcct        ) ) json.AddValue("NameOnAcct"        , new JsonValue(o.NameOnAcct          ));
			if ( !Sql.IsEmptyString(o.BillAddrStreet    ) ) json.AddValue("BillAddrStreet"    , new JsonValue(o.BillAddrStreet      ));
			if ( !Sql.IsEmptyString(o.PostalCode        ) ) json.AddValue("PostalCode"        , new JsonValue(o.PostalCode          ));
			if ( !Sql.IsEmptyString(o.CommercialCardCode) ) json.AddValue("CommercialCardCode", new JsonValue(o.CommercialCardCode  ));
			if ( !Sql.IsEmptyString(o.PrevCCTransId     ) ) json.AddValue("PrevCCTransId"     , new JsonValue(o.PrevCCTransId       ));
			if ( o.CcExpiryMonth      .HasValue           ) json.AddValue("CcExpiryMonth"     , new JsonValue(o.CcExpiryMonth .Value));
			if ( o.CcExpiryYear       .HasValue           ) json.AddValue("CcExpiryYear"      , new JsonValue(o.CcExpiryYear  .Value));
			if ( o.Amount             .HasValue           ) json.AddValue("Amount"            , new JsonValue(o.Amount        .Value));
			if ( o.ProcessPayment     .HasValue           ) json.AddValue("ProcessPayment"    , new JsonValue(o.ProcessPayment.Value));
			if ( o.CCTxnMode          .HasValue           ) json.AddValue("CCTxnMode"         , _EnumSerializer.Serialize(o.CCTxnMode.Value));
			if ( o.CCTxnType          .HasValue           ) json.AddValue("CCTxnType"         , _EnumSerializer.Serialize(o.CCTxnType.Value));
			return json;
		}
	}
}
