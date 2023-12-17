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
	class InvoiceDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 06/12/2014 Paul.  This method is called for each array item and for a single item. 
			if ( json.ContainsName("Invoice") )
			{
				json = json.GetValue("Invoice");
			}
			Invoice obj = new Invoice();
			obj.RawContent                    = json.ToString();
			obj.Id                            = json.GetValueOrDefault<String   >("Id"                          );
			obj.SyncToken                     = json.GetValueOrDefault<String   >("SyncToken"                   );
			obj.DocNumber                     = json.GetValueOrDefault<String   >("DocNumber"                   );
			obj.TxnDate                       = json.GetValueOrDefault<DateTime?>("TxnDate"                     );
			obj.ExchangeRate                  = json.GetValueOrDefault<Decimal? >("ExchangeRate"                );
			obj.PrivateNote                   = json.GetValueOrDefault<String   >("PrivateNote"                 );
			obj.DueDate                       = json.GetValueOrDefault<DateTime?>("DueDate"                     );
			obj.ShipDate                      = json.GetValueOrDefault<DateTime?>("ShipDate"                    );
			obj.TrackingNum                   = json.GetValueOrDefault<String   >("TrackingNum"                 );
			obj.TotalAmt                      = json.GetValueOrDefault<Decimal? >("TotalAmt"                    );
			obj.HomeTotalAmt                  = json.GetValueOrDefault<Decimal? >("HomeTotalAmt"                );
			obj.ApplyTaxAfterDiscount         = json.GetValueOrDefault<Boolean? >("ApplyTaxAfterDiscount"       );
			obj.Balance                       = json.GetValueOrDefault<Decimal? >("Balance"                     );
			obj.Deposit                       = json.GetValueOrDefault<Decimal? >("Deposit"                     );
			obj.AllowIPNPayment               = json.GetValueOrDefault<Boolean? >("AllowIPNPayment"             );

			if ( json.ContainsName("GlobalTaxCalculation") ) obj.GlobalTaxCalculation  = _EnumDeserializer.DeserializeGlobalTaxCalculation(json.GetValue("GlobalTaxCalculation"));
			if ( json.ContainsName("PrintStatus"         ) ) obj.PrintStatus           = _EnumDeserializer.DeserializePrintStatus         (json.GetValue("PrintStatus"         ));
			if ( json.ContainsName("EmailStatus"         ) ) obj.EmailStatus           = _EnumDeserializer.DeserializeEmailStatus         (json.GetValue("EmailStatus"         ));

			JsonValue metaData            = json.GetValue("MetaData"           );
			JsonValue departmentRef       = json.GetValue("DepartmentRef"      );
			JsonValue currencyRef         = json.GetValue("CurrencyRef"        );
			JsonValue linkedTxn           = json.GetValue("LinkedTxn"          );
			JsonValue line                = json.GetValue("Line"               );
			JsonValue txnTaxDetail        = json.GetValue("TxnTaxDetail"       );
			JsonValue customerRef         = json.GetValue("CustomerRef"        );
			JsonValue customerMemo        = json.GetValue("CustomerMemo"       );
			JsonValue billAddr            = json.GetValue("BillAddr"           );
			JsonValue shipAddr            = json.GetValue("ShipAddr"           );
			JsonValue salesTermRef        = json.GetValue("SalesTermRef"       );
			JsonValue shipMethodRef       = json.GetValue("ShipMethodRef"      );
			JsonValue billEmail           = json.GetValue("BillEmail"          );
			JsonValue depositToAccountRef = json.GetValue("DepositToAccountRef");
			if ( metaData            != null && metaData           .IsObject ) obj.MetaData            = mapper.Deserialize<ModificationMetaData   >(metaData           );
			if ( departmentRef       != null && departmentRef      .IsObject ) obj.DepartmentRef       = mapper.Deserialize<ReferenceType          >(departmentRef      );
			if ( currencyRef         != null && currencyRef        .IsObject ) obj.CurrencyRef         = mapper.Deserialize<ReferenceType          >(currencyRef        );
			if ( linkedTxn           != null && linkedTxn          .IsArray  ) obj.LinkedTxns          = mapper.Deserialize<IList<LinkedTxn>       >(linkedTxn          );
			if ( line                != null && line               .IsArray  ) obj.Lines               = mapper.Deserialize<IList<Line>            >(line               );
			if ( txnTaxDetail        != null && txnTaxDetail       .IsObject ) obj.TxnTaxDetail        = mapper.Deserialize<TxnTaxDetail           >(txnTaxDetail       );
			if ( customerRef         != null && customerRef        .IsObject ) obj.CustomerRef         = mapper.Deserialize<ReferenceType          >(customerRef        );
			if ( customerMemo        != null && customerMemo       .IsObject ) obj.CustomerMemo        = mapper.Deserialize<MemoRef                >(customerMemo       );
			if ( billAddr            != null && billAddr           .IsObject ) obj.BillAddr            = mapper.Deserialize<PhysicalAddress        >(billAddr           );
			if ( shipAddr            != null && shipAddr           .IsObject ) obj.ShipAddr            = mapper.Deserialize<PhysicalAddress        >(shipAddr           );
			if ( salesTermRef        != null && salesTermRef       .IsObject ) obj.SalesTermRef        = mapper.Deserialize<ReferenceType          >(salesTermRef       );
			if ( shipMethodRef       != null && shipMethodRef      .IsObject ) obj.ShipMethodRef       = mapper.Deserialize<ReferenceType          >(shipMethodRef      );
			if ( billEmail           != null && billEmail          .IsObject ) obj.BillEmail           = mapper.Deserialize<EmailAddress           >(billEmail          );
			if ( depositToAccountRef != null && depositToAccountRef.IsObject ) obj.DepositToAccountRef = mapper.Deserialize<ReferenceType          >(depositToAccountRef);
			return obj;
		}
	}

	class InvoiceListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Invoice> invoices = new List<Invoice>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				JsonValue jsonInvoices = jsonResponse.GetValue("Invoice");
				if ( jsonInvoices != null && jsonInvoices.IsArray )
				{
					foreach ( JsonValue itemValue in jsonInvoices.GetValues() )
					{
						invoices.Add( mapper.Deserialize<Invoice>(itemValue) );
					}
				}
			}
			return invoices;
		}
	}
}
