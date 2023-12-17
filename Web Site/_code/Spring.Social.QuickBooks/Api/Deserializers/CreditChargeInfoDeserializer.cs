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
	class CreditChargeInfoDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			CreditChargeInfo obj = new CreditChargeInfo();
			obj.Number             = json.GetValueOrDefault<String  >("Number"            );
			obj.Type               = json.GetValueOrDefault<String  >("Type"              );
			obj.NameOnAcct         = json.GetValueOrDefault<String  >("NameOnAcct"        );
			obj.CcExpiryMonth      = json.GetValueOrDefault<int?    >("CcExpiryMonth"     );
			obj.CcExpiryYear       = json.GetValueOrDefault<int?    >("CcExpiryYear"      );
			obj.BillAddrStreet     = json.GetValueOrDefault<String  >("BillAddrStreet"    );
			obj.PostalCode         = json.GetValueOrDefault<String  >("PostalCode"        );
			obj.CommercialCardCode = json.GetValueOrDefault<String  >("CommercialCardCode");
			obj.PrevCCTransId      = json.GetValueOrDefault<String  >("PrevCCTransId"     );
			obj.Amount             = json.GetValueOrDefault<Decimal?>("Amount"            );
			obj.ProcessPayment     = json.GetValueOrDefault<Boolean?>("ProcessPayment"    );

			if ( json.ContainsName("CCTxnMode") ) obj.CCTxnMode = _EnumDeserializer.DeserializeCCTxnMode(json.GetValue("CCTxnMode"));
			if ( json.ContainsName("CCTxnType") ) obj.CCTxnType = _EnumDeserializer.DeserializeCCTxnType(json.GetValue("CCTxnType"));
			return obj;
		}
	}
}
