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
	class PaymentDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 06/12/2014 Paul.  This method is called for each array item and for a single item. 
			if ( json.ContainsName("Payment") )
			{
				json = json.GetValue("Payment");
			}
			Payment obj = new Payment();
			obj.RawContent                    = json.ToString();
			obj.Id                            = json.GetValueOrDefault<String   >("Id"                          );
			obj.SyncToken                     = json.GetValueOrDefault<String   >("SyncToken"                   );
			obj.TxnDate                       = json.GetValueOrDefault<DateTime?>("TxnDate"                     );
			obj.ExchangeRate                  = json.GetValueOrDefault<Decimal? >("ExchangeRate"                );
			obj.PrivateNote                   = json.GetValueOrDefault<String   >("PrivateNote"                 );
			obj.TxnStatus                     = json.GetValueOrDefault<String   >("TxnStatus"                   );

			obj.PaymentRefNum                 = json.GetValueOrDefault<String   >("PaymentRefNum"               );
			obj.TotalAmt                      = json.GetValueOrDefault<Decimal? >("TotalAmt"                    );
			obj.UnappliedAmt                  = json.GetValueOrDefault<Decimal? >("UnappliedAmt"                );

			JsonValue metaData            = json.GetValue("MetaData"           );
			JsonValue currencyRef         = json.GetValue("CurrencyRef"        );
			JsonValue line                = json.GetValue("Line"               );
			JsonValue customerRef         = json.GetValue("CustomerRef"        );
			JsonValue aRAccountRef        = json.GetValue("ARAccountRef"       );
			JsonValue depositToAccountRef = json.GetValue("DepositToAccountRef");
			JsonValue paymentMethodRef    = json.GetValue("PaymentMethodRef"   );
			if ( metaData            != null && metaData           .IsObject ) obj.MetaData            = mapper.Deserialize<ModificationMetaData   >(metaData           );
			if ( currencyRef         != null && currencyRef        .IsObject ) obj.CurrencyRef         = mapper.Deserialize<ReferenceType          >(currencyRef        );
			if ( line                != null && line               .IsArray  ) obj.Lines               = mapper.Deserialize<IList<Line>            >(line               );
			if ( customerRef         != null && customerRef        .IsObject ) obj.CustomerRef         = mapper.Deserialize<ReferenceType          >(customerRef        );
			if ( aRAccountRef        != null && aRAccountRef       .IsObject ) obj.ARAccountRef        = mapper.Deserialize<ReferenceType          >(aRAccountRef       );
			if ( depositToAccountRef != null && depositToAccountRef.IsObject ) obj.DepositToAccountRef = mapper.Deserialize<ReferenceType          >(depositToAccountRef);
			if ( paymentMethodRef    != null && paymentMethodRef   .IsObject ) obj.PaymentMethodRef    = mapper.Deserialize<ReferenceType          >(paymentMethodRef   );
			return obj;
		}
	}

	class PaymentListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Payment> payments = new List<Payment>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				JsonValue jsonPayments = jsonResponse.GetValue("Payment");
				if ( jsonPayments != null && jsonPayments.IsArray )
				{
					foreach ( JsonValue itemValue in jsonPayments.GetValues() )
					{
						payments.Add( mapper.Deserialize<Payment>(itemValue) );
					}
				}
			}
			return payments;
		}
	}
}
