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
	class AccountDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 06/12/2014 Paul.  This method is called for each array item and for a single item. 
			if ( json.ContainsName("Account") )
			{
				json = json.GetValue("Account");
			}
			Account obj = new Account();
			obj.RawContent                    = json.ToString();
			obj.Id                            = json.GetValueOrDefault<String   >("Id"                           );
			obj.SyncToken                     = json.GetValueOrDefault<String   >("SyncToken"                    );
			obj.Name                          = json.GetValueOrDefault<String   >("Name"                         );
			obj.SubAccount                    = json.GetValueOrDefault<Boolean? >("SubAccount"                   );
			obj.Description                   = json.GetValueOrDefault<String   >("Description"                  );
			obj.FullyQualifiedName            = json.GetValueOrDefault<String   >("FullyQualifiedName"           );
			obj.Active                        = json.GetValueOrDefault<Boolean? >("Active"                       );
			obj.AccountSubType                = json.GetValueOrDefault<String   >("AccountSubType"               );
			obj.AcctNum                       = json.GetValueOrDefault<String   >("AcctNum"                      );
			obj.BankNum                       = json.GetValueOrDefault<String   >("BankNum"                      );
			obj.OpeningBalance                = json.GetValueOrDefault<Decimal? >("OpeningBalance"               );
			obj.OpeningBalanceDate            = json.GetValueOrDefault<DateTime?>("OpeningBalanceDate"           );
			obj.CurrentBalance                = json.GetValueOrDefault<Decimal? >("CurrentBalance"               );
			obj.CurrentBalanceWithSubAccounts = json.GetValueOrDefault<Decimal? >("CurrentBalanceWithSubAccounts");
			obj.TaxAccount                    = json.GetValueOrDefault<Boolean? >("TaxAccount"                   );
			obj.OnlineBankingEnabled          = json.GetValueOrDefault<Boolean? >("OnlineBankingEnabled"         );
			obj.FIName                        = json.GetValueOrDefault<String   >("FIName"                       );

			if ( json.ContainsName("AccountType"   ) ) obj.AccountType    = _EnumDeserializer.DeserializeAccountType   (json.GetValue("AccountType"   ));
			if ( json.ContainsName("Classification") ) obj.Classification = _EnumDeserializer.DeserializeClassification(json.GetValue("Classification"));

			JsonValue metaData    = json.GetValue("MetaData"   );
			JsonValue parentRef   = json.GetValue("ParentRef"  );
			JsonValue currencyRef = json.GetValue("CurrencyRef");
			JsonValue taxCodeRef  = json.GetValue("TaxCodeRef" );
			if ( metaData    != null && metaData   .IsObject ) obj.MetaData    = mapper.Deserialize<ModificationMetaData>(metaData   );
			if ( parentRef   != null && parentRef  .IsObject ) obj.ParentRef   = mapper.Deserialize<ReferenceType       >(parentRef  );
			if ( currencyRef != null && currencyRef.IsObject ) obj.CurrencyRef = mapper.Deserialize<ReferenceType       >(currencyRef);
			if ( taxCodeRef  != null && taxCodeRef .IsObject ) obj.TaxCodeRef  = mapper.Deserialize<ReferenceType       >(taxCodeRef );
			return obj;
		}
	}

	class AccountListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Account> accounts = new List<Account>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				JsonValue jsonAccounts = jsonResponse.GetValue("Account");
				if ( jsonAccounts != null && jsonAccounts.IsArray )
				{
					foreach ( JsonValue itemValue in jsonAccounts.GetValues() )
					{
						accounts.Add( mapper.Deserialize<Account>(itemValue) );
					}
				}
			}
			return accounts;
		}
	}
}
