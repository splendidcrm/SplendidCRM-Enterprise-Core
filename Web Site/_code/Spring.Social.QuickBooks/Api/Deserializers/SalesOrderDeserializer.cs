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
	class SalesOrderDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 06/12/2014 Paul.  This method is called for each array item and for a single item. 
			if ( json.ContainsName("SalesOrder") )
			{
				json = json.GetValue("SalesOrder");
			}
			SalesOrder obj = new SalesOrder();
			obj.RawContent                    = json.ToString();
			obj.Id                            = json.GetValueOrDefault<String   >("Id"                          );
			obj.SyncToken                     = json.GetValueOrDefault<String   >("SyncToken"                   );
			obj.DocNumber                     = json.GetValueOrDefault<String   >("DocNumber"                   );
			obj.TxnDate                       = json.GetValueOrDefault<DateTime?>("TxnDate"                     );
			obj.ExchangeRate                  = json.GetValueOrDefault<Decimal? >("ExchangeRate"                );
			obj.PrivateNote                   = json.GetValueOrDefault<String   >("PrivateNote"                 );
			obj.TxnStatus                     = json.GetValueOrDefault<String   >("TxnStatus"                   );
			obj.TxnSource                     = json.GetValueOrDefault<String   >("TxnSource"                   );
			obj.AutoDocNumber                 = json.GetValueOrDefault<Boolean? >("AutoDocNumber"               );
			obj.DueDate                       = json.GetValueOrDefault<DateTime?>("DueDate"                     );
			obj.PONumber                      = json.GetValueOrDefault<String   >("PONumber"                    );
			obj.FOB                           = json.GetValueOrDefault<String   >("FOB"                         );
			obj.ShipDate                      = json.GetValueOrDefault<DateTime?>("ShipDate"                    );
			obj.TrackingNum                   = json.GetValueOrDefault<String   >("TrackingNum"                 );
			obj.TotalAmt                      = json.GetValueOrDefault<Decimal? >("TotalAmt"                    );
			obj.HomeTotalAmt                  = json.GetValueOrDefault<Decimal? >("HomeTotalAmt"                );
			obj.ApplyTaxAfterDiscount         = json.GetValueOrDefault<Boolean? >("ApplyTaxAfterDiscount"       );
			obj.Balance                       = json.GetValueOrDefault<Decimal? >("Balance"                     );
			obj.FinanceCharge                 = json.GetValueOrDefault<Boolean? >("FinanceCharge"               );
			obj.PaymentRefNum                 = json.GetValueOrDefault<String   >("PaymentRefNum"               );
			obj.ManuallyClosed                = json.GetValueOrDefault<Boolean? >("ManuallyClosed"              );

			if ( json.ContainsName("GlobalTaxCalculation") ) obj.GlobalTaxCalculation  = _EnumDeserializer.DeserializeGlobalTaxCalculation(json.GetValue("GlobalTaxCalculation"));
			if ( json.ContainsName("PrintStatus"         ) ) obj.PrintStatus           = _EnumDeserializer.DeserializePrintStatus         (json.GetValue("PrintStatus"         ));
			if ( json.ContainsName("EmailStatus"         ) ) obj.EmailStatus           = _EnumDeserializer.DeserializeEmailStatus         (json.GetValue("EmailStatus"         ));
			if ( json.ContainsName("PaymentType"         ) ) obj.PaymentType           = _EnumDeserializer.DeserializePaymentType         (json.GetValue("PaymentType"         ));

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
			JsonValue remitToRef          = json.GetValue("RemitToRef"         );
			JsonValue classRef            = json.GetValue("ClassRef"           );
			JsonValue salesTermRef        = json.GetValue("SalesTermRef"       );
			JsonValue salesRepRef         = json.GetValue("SalesRepRef"        );
			JsonValue shipMethodRef       = json.GetValue("ShipMethodRef"      );
			JsonValue templateRef         = json.GetValue("TemplateRef"        );
			JsonValue billEmail           = json.GetValue("BillEmail"          );
			JsonValue aRAccountRef        = json.GetValue("ARAccountRef"       );
			JsonValue paymentMethodRef    = json.GetValue("PaymentMethodRef"   );
			JsonValue depositToAccountRef = json.GetValue("DepositToAccountRef");
			JsonValue deliveryInfo        = json.GetValue("DeliveryInfo"       );
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
			if ( remitToRef          != null && remitToRef         .IsObject ) obj.RemitToRef          = mapper.Deserialize<ReferenceType          >(remitToRef         );
			if ( classRef            != null && classRef           .IsObject ) obj.ClassRef            = mapper.Deserialize<ReferenceType          >(classRef           );
			if ( salesTermRef        != null && salesTermRef       .IsObject ) obj.SalesTermRef        = mapper.Deserialize<ReferenceType          >(salesTermRef       );
			if ( salesRepRef         != null && salesRepRef        .IsObject ) obj.SalesRepRef         = mapper.Deserialize<ReferenceType          >(salesRepRef        );
			if ( shipMethodRef       != null && shipMethodRef      .IsObject ) obj.ShipMethodRef       = mapper.Deserialize<ReferenceType          >(shipMethodRef      );
			if ( templateRef         != null && templateRef        .IsObject ) obj.TemplateRef         = mapper.Deserialize<ReferenceType          >(templateRef        );
			if ( billEmail           != null && billEmail          .IsObject ) obj.BillEmail           = mapper.Deserialize<EmailAddress           >(billEmail          );
			if ( aRAccountRef        != null && aRAccountRef       .IsObject ) obj.ARAccountRef        = mapper.Deserialize<ReferenceType          >(aRAccountRef       );
			if ( paymentMethodRef    != null && paymentMethodRef   .IsObject ) obj.PaymentMethodRef    = mapper.Deserialize<ReferenceType          >(paymentMethodRef   );
			if ( depositToAccountRef != null && depositToAccountRef.IsObject ) obj.DepositToAccountRef = mapper.Deserialize<ReferenceType          >(depositToAccountRef);
			if ( deliveryInfo        != null && deliveryInfo       .IsObject ) obj.DeliveryInfo        = mapper.Deserialize<TransactionDeliveryInfo>(deliveryInfo       );
			return obj;
		}
	}

	class SalesOrderListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<SalesOrder> salesOrders = new List<SalesOrder>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				JsonValue jsonSalesOrders = jsonResponse.GetValue("SalesOrder");
				if ( jsonSalesOrders != null && jsonSalesOrders.IsArray )
				{
					foreach ( JsonValue itemValue in jsonSalesOrders.GetValues() )
					{
						salesOrders.Add( mapper.Deserialize<SalesOrder>(itemValue) );
					}
				}
			}
			return salesOrders;
		}
	}
}
