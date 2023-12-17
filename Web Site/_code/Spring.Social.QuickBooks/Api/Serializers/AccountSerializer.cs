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
	class AccountSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Account o = obj as Account;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Id                ) ) json.AddValue("Id"                           , new JsonValue(o.Id                           ));
			if ( !Sql.IsEmptyString(o.SyncToken         ) ) json.AddValue("SyncToken"                    , new JsonValue(o.SyncToken                    ));
			if ( !Sql.IsEmptyString(o.Name              ) ) json.AddValue("Name"                         , new JsonValue(o.Name                         ));
			if ( !Sql.IsEmptyString(o.Description       ) ) json.AddValue("Description"                  , new JsonValue(o.Description                  ));
			if ( !Sql.IsEmptyString(o.AccountSubType    ) ) json.AddValue("AccountSubType"               , new JsonValue(o.AccountSubType               ));
			if ( !Sql.IsEmptyString(o.AcctNum           ) ) json.AddValue("AcctNum"                      , new JsonValue(o.AcctNum                      ));
			if ( !Sql.IsEmptyString(o.BankNum           ) ) json.AddValue("BankNum"                      , new JsonValue(o.BankNum                      ));
			if ( !Sql.IsEmptyString(o.FIName            ) ) json.AddValue("FIName"                       , new JsonValue(o.FIName                       ));
			//if ( !Sql.IsEmptyString(o.FullyQualifiedName) ) json.AddValue("FullyQualifiedName"           , new JsonValue(o.FullyQualifiedName           ));
			if ( o.SubAccount                   .HasValue ) json.AddValue("SubAccount"                   , new JsonValue(o.SubAccount                   .Value));
			if ( o.Active                       .HasValue ) json.AddValue("Active"                       , new JsonValue(o.Active                       .Value));
			if ( o.OpeningBalance               .HasValue ) json.AddValue("OpeningBalance"               , new JsonValue(o.OpeningBalance               .Value));
			if ( o.OpeningBalanceDate           .HasValue ) json.AddValue("OpeningBalanceDate"           , new JsonValue(o.OpeningBalanceDate           .Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			if ( o.CurrentBalance               .HasValue ) json.AddValue("CurrentBalance"               , new JsonValue(o.CurrentBalance               .Value));
			if ( o.CurrentBalanceWithSubAccounts.HasValue ) json.AddValue("CurrentBalanceWithSubAccounts", new JsonValue(o.CurrentBalanceWithSubAccounts.Value));
			if ( o.TaxAccount                   .HasValue ) json.AddValue("TaxAccount"                   , new JsonValue(o.TaxAccount                   .Value));
			if ( o.OnlineBankingEnabled         .HasValue ) json.AddValue("OnlineBankingEnabled"         , new JsonValue(o.OnlineBankingEnabled         .Value));
			if ( o.AccountType                  .HasValue ) json.AddValue("AccountType"                  , _EnumSerializer.Serialize(o.AccountType   .Value));
			if ( o.Classification               .HasValue ) json.AddValue("Classification"               , _EnumSerializer.Serialize(o.Classification.Value));
			if ( o.ParentRef                    != null   ) json.AddValue("ParentRef"                    , mapper.Serialize(o.ParentRef  ));
			if ( o.CurrencyRef                  != null   ) json.AddValue("CurrencyRef"                  , mapper.Serialize(o.CurrencyRef));
			if ( o.TaxCodeRef                   != null   ) json.AddValue("TaxCodeRef"                   , mapper.Serialize(o.TaxCodeRef ));
			// 02/01/2015  Paul.  QBO is required. 
			// https://developer.intuit.com/docs/95_legacy/qbd_v3/qbd_v3_reference/020_key_concepts/050_sparse_update
			json.AddValue("domain", new JsonValue("QBO"  ));
			json.AddValue("sparse", new JsonValue("false"));
			o.RawContent = json.ToString();
			return json;
		}
	}
}
