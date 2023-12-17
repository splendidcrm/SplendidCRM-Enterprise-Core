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
	class CustomerDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 06/12/2014 Paul.  This method is called for each array item and for a single item. 
			if ( json.ContainsName("Customer") )
			{
				json = json.GetValue("Customer");
			}
			Customer obj = new Customer();
			obj.RawContent              = json.ToString();
			obj.Id                      = json.GetValueOrDefault<String               >("Id"                      );
			obj.SyncToken               = json.GetValueOrDefault<String               >("SyncToken"               );
			obj.Title                   = json.GetValueOrDefault<String               >("Title"                   );
			obj.GivenName               = json.GetValueOrDefault<String               >("GivenName"               );
			obj.MiddleName              = json.GetValueOrDefault<String               >("MiddleName"              );
			obj.FamilyName              = json.GetValueOrDefault<String               >("FamilyName"              );
			obj.Suffix                  = json.GetValueOrDefault<String               >("Suffix"                  );
			obj.FullyQualifiedName      = json.GetValueOrDefault<String               >("FullyQualifiedName"      );
			obj.CompanyName             = json.GetValueOrDefault<String               >("CompanyName"             );
			obj.DisplayName             = json.GetValueOrDefault<String               >("DisplayName"             );
			obj.PrintOnCheckName        = json.GetValueOrDefault<String               >("PrintOnCheckName"        );
			obj.Active                  = json.GetValueOrDefault<Boolean?             >("Active"                  );
			obj.Taxable                 = json.GetValueOrDefault<Boolean?             >("Taxable"                 );
			obj.Notes                   = json.GetValueOrDefault<String               >("Notes"                   );
			obj.Job                     = json.GetValueOrDefault<Boolean?             >("Job"                     );
			obj.BillWithParent          = json.GetValueOrDefault<Boolean?             >("BillWithParent"          );
			obj.Level                   = json.GetValueOrDefault<int?                 >("Level"                   );
			obj.Balance                 = json.GetValueOrDefault<Decimal?             >("Balance"                 );
			obj.OpenBalanceDate         = json.GetValueOrDefault<DateTime?            >("OpenBalanceDate"         );
			obj.BalanceWithJobs         = json.GetValueOrDefault<Decimal?             >("BalanceWithJobs"         );
			obj.PreferredDeliveryMethod = json.GetValueOrDefault<String               >("PreferredDeliveryMethod" );
			obj.ResaleNum               = json.GetValueOrDefault<String               >("ResaleNum"               );

			JsonValue metaData            = json.GetValue("MetaData"                );
			JsonValue primaryPhone        = json.GetValue("PrimaryPhone"            );
			JsonValue alternatePhone      = json.GetValue("AlternatePhone"          );
			JsonValue mobile              = json.GetValue("Mobile"                  );
			JsonValue fax                 = json.GetValue("Fax"                     );
			JsonValue primaryEmailAddr    = json.GetValue("PrimaryEmailAddr"        );
			JsonValue webAddr             = json.GetValue("WebAddr"                 );
			JsonValue defaultTaxCodeRef   = json.GetValue("DefaultTaxCodeRef"       );
			JsonValue billAddr            = json.GetValue("BillAddr"                );
			JsonValue shipAddr            = json.GetValue("ShipAddr"                );
			JsonValue parentRef           = json.GetValue("ParentRef"               );
			JsonValue salesTermRef        = json.GetValue("SalesTermRef"            );
			JsonValue paymentMethodRef    = json.GetValue("PaymentMethodRef"        );
			JsonValue currencyRef         = json.GetValue("CurrencyRef"             );

			if ( metaData          != null && metaData         .IsObject ) obj.MetaData          = mapper.Deserialize<ModificationMetaData  >(metaData         );
			if ( primaryPhone      != null && primaryPhone     .IsObject ) obj.PrimaryPhone      = mapper.Deserialize<TelephoneNumber       >(primaryPhone     );
			if ( alternatePhone    != null && alternatePhone   .IsObject ) obj.AlternatePhone    = mapper.Deserialize<TelephoneNumber       >(alternatePhone   );
			if ( mobile            != null && mobile           .IsObject ) obj.Mobile            = mapper.Deserialize<TelephoneNumber       >(mobile           );
			if ( fax               != null && fax              .IsObject ) obj.Fax               = mapper.Deserialize<TelephoneNumber       >(fax              );
			if ( primaryEmailAddr  != null && primaryEmailAddr .IsObject ) obj.PrimaryEmailAddr  = mapper.Deserialize<EmailAddress          >(primaryEmailAddr );
			if ( webAddr           != null && webAddr          .IsObject ) obj.WebAddr           = mapper.Deserialize<WebSiteAddress        >(webAddr          );
			if ( defaultTaxCodeRef != null && defaultTaxCodeRef.IsObject ) obj.DefaultTaxCodeRef = mapper.Deserialize<ReferenceType         >(defaultTaxCodeRef);
			if ( billAddr          != null && billAddr         .IsObject ) obj.BillAddr          = mapper.Deserialize<PhysicalAddress       >(billAddr         );
			if ( shipAddr          != null && shipAddr         .IsObject ) obj.ShipAddr          = mapper.Deserialize<PhysicalAddress       >(shipAddr         );
			if ( parentRef         != null && parentRef        .IsObject ) obj.ParentRef         = mapper.Deserialize<ReferenceType         >(parentRef        );
			if ( salesTermRef      != null && salesTermRef     .IsObject ) obj.SalesTermRef      = mapper.Deserialize<ReferenceType         >(salesTermRef     );
			if ( paymentMethodRef  != null && paymentMethodRef .IsObject ) obj.PaymentMethodRef  = mapper.Deserialize<ReferenceType         >(paymentMethodRef );
			if ( currencyRef       != null && currencyRef      .IsObject ) obj.CurrencyRef       = mapper.Deserialize<ReferenceType         >(currencyRef      );
			return obj;
		}
	}

	class CustomerListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Customer> customers = new List<Customer>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				JsonValue jsonCustomers = jsonResponse.GetValue("Customer");
				if ( jsonCustomers != null && jsonCustomers.IsArray )
				{
					foreach ( JsonValue itemValue in jsonCustomers.GetValues() )
					{
						customers.Add( mapper.Deserialize<Customer>(itemValue) );
					}
				}
			}
			return customers;
		}
	}
}
