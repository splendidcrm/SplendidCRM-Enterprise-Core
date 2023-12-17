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
using System.Diagnostics;
using Spring.Json;

namespace Spring.Social.Shopify.Api.Impl.Json
{
	class CustomerSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Customer o = obj as Customer;
			
			JsonObject json = new JsonObject();
			/*
			if ( !Sql.IsEmptyString(o.Id                     ) ) json.AddValue("Id"                     , new JsonValue(o.Id                     ));
			if ( !Sql.IsEmptyString(o.Title                  ) ) json.AddValue("Title"                  , new JsonValue(Sql.Truncate(o.Title                  ,   15)));
			if ( !Sql.IsEmptyString(o.GivenName              ) ) json.AddValue("GivenName"              , new JsonValue(Sql.Truncate(o.GivenName              ,   25)));
			if ( !Sql.IsEmptyString(o.MiddleName             ) ) json.AddValue("MiddleName"             , new JsonValue(Sql.Truncate(o.MiddleName             ,   25)));
			if ( !Sql.IsEmptyString(o.FamilyName             ) ) json.AddValue("FamilyName"             , new JsonValue(Sql.Truncate(o.FamilyName             ,   25)));
			if ( !Sql.IsEmptyString(o.Suffix                 ) ) json.AddValue("Suffix"                 , new JsonValue(Sql.Truncate(o.Suffix                 ,   10)));
			if ( !Sql.IsEmptyString(o.CompanyName            ) ) json.AddValue("CompanyName"            , new JsonValue(Sql.Truncate(o.CompanyName            ,   50)));
			// The DisplayName, GivenName, MiddleName, FamilyName, and PrintOnCheckName attributes must not contain a colon,":".
			// The DisplayName attribute must be unique across all other customers, employees, vendors, and other names.
			if ( !Sql.IsEmptyString(o.DisplayName            ) ) json.AddValue("DisplayName"            , new JsonValue(Sql.Truncate(o.DisplayName            ,  100)));
			if ( !Sql.IsEmptyString(o.PrintOnCheckName       ) ) json.AddValue("PrintOnCheckName"       , new JsonValue(Sql.Truncate(o.PrintOnCheckName       ,  100)));
			if ( !Sql.IsEmptyString(o.Notes                  ) ) json.AddValue("Notes"                  , new JsonValue(Sql.Truncate(o.Notes                  , 2000)));
			if ( !Sql.IsEmptyString(o.PreferredDeliveryMethod) ) json.AddValue("PreferredDeliveryMethod", new JsonValue(Sql.Truncate(o.PreferredDeliveryMethod,   15)));  // Print, Email or None. 
			if ( !Sql.IsEmptyString(o.ResaleNum              ) ) json.AddValue("ResaleNum"              , new JsonValue(Sql.Truncate(o.ResaleNum              ,   15)));
			//if ( !Sql.IsEmptyString(o.FullyQualifiedName     ) ) json.AddValue("FullyQualifiedName"     , new JsonValue(o.FullyQualifiedName     ));
			if ( o.Active                  .HasValue           ) json.AddValue("Active"                 , new JsonValue(o.Active           .Value));
			if ( o.Taxable                 .HasValue           ) json.AddValue("Taxable"                , new JsonValue(o.Taxable          .Value));
			if ( o.Job                     .HasValue           ) json.AddValue("Job"                    , new JsonValue(o.Job              .Value));
			if ( o.BillWithParent          .HasValue           ) json.AddValue("BillWithParent"         , new JsonValue(o.BillWithParent   .Value));
			if ( o.Level                   .HasValue           ) json.AddValue("Level"                  , new JsonValue(o.Level            .Value));
			if ( o.Balance                 .HasValue           ) json.AddValue("Balance"                , new JsonValue(o.Balance          .Value));
			if ( o.OpenBalanceDate         .HasValue           ) json.AddValue("OpenBalanceDate"        , new JsonValue(o.OpenBalanceDate  .Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			if ( o.BalanceWithJobs         .HasValue           ) json.AddValue("BalanceWithJobs"        , new JsonValue(o.BalanceWithJobs  .Value));
			if ( o.PrimaryPhone            != null             ) json.AddValue("PrimaryPhone"           , mapper.Serialize(o.PrimaryPhone     ));
			if ( o.AlternatePhone          != null             ) json.AddValue("AlternatePhone"         , mapper.Serialize(o.AlternatePhone   ));
			if ( o.Mobile                  != null             ) json.AddValue("Mobile"                 , mapper.Serialize(o.Mobile           ));
			if ( o.Fax                     != null             ) json.AddValue("Fax"                    , mapper.Serialize(o.Fax              ));
			if ( o.PrimaryEmailAddr        != null             ) json.AddValue("PrimaryEmailAddr"       , mapper.Serialize(o.PrimaryEmailAddr ));
			if ( o.image                   != null             ) json.AddValue("image"                  , mapper.Serialize(o.image            ));
			if ( o.DefaultTaxCodeRef       != null             ) json.AddValue("DefaultTaxCodeRef"      , mapper.Serialize(o.DefaultTaxCodeRef));
			if ( o.BillAddr                != null             ) json.AddValue("BillAddr"               , mapper.Serialize(o.BillAddr         ));
			if ( o.ShipAddr                != null             ) json.AddValue("ShipAddr"               , mapper.Serialize(o.ShipAddr         ));
			if ( o.ParentRef               != null             ) json.AddValue("ParentRef"              , mapper.Serialize(o.ParentRef        ));
			if ( o.SalesTermRef            != null             ) json.AddValue("SalesTermRef"           , mapper.Serialize(o.SalesTermRef     ));
			if ( o.PaymentMethodRef        != null             ) json.AddValue("PaymentMethodRef"       , mapper.Serialize(o.PaymentMethodRef ));
			if ( o.CurrencyRef             != null             ) json.AddValue("CurrencyRef"            , mapper.Serialize(o.CurrencyRef      ));
			*/
			o.RawContent = json.ToString();
			return json;
		}
	}
}
