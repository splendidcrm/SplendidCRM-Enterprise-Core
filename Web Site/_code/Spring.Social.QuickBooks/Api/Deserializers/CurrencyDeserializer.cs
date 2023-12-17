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
	class CurrencyDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 06/12/2014 Paul.  This method is called for each array item and for a single item. 
			if ( json.ContainsName("Currency") )
			{
				json = json.GetValue("Currency");
			}
			Currency obj = new Currency();
			obj.RawContent       = json.ToString();
			obj.Id               = json.GetValueOrDefault<String   >("Id"              );
			obj.SyncToken        = json.GetValueOrDefault<String   >("SyncToken"       );
			obj.Name             = json.GetValueOrDefault<String   >("Name"            );
			obj.Active           = json.GetValueOrDefault<Boolean? >("Active"          );
			obj.Separator        = json.GetValueOrDefault<String   >("Separator"       );
			obj.Format           = json.GetValueOrDefault<String   >("Format"          );
			obj.DecimalPlaces    = json.GetValueOrDefault<String   >("DecimalPlaces"   );
			obj.DecimalSeparator = json.GetValueOrDefault<String   >("DecimalSeparator");
			obj.Symbol           = json.GetValueOrDefault<String   >("Symbol"          );
			obj.UserDefined      = json.GetValueOrDefault<Boolean? >("UserDefined"     );
			obj.ExchangeRate     = json.GetValueOrDefault<Decimal? >("ExchangeRate"    );
			obj.AsOfDate         = json.GetValueOrDefault<DateTime?>("AsOfDate"        );

			if ( json.ContainsName("Code"          ) ) obj.Code           = _EnumDeserializer.DeserializeCurrencyCode  (json.GetValue("Code"          ));
			if ( json.ContainsName("SymbolPosition") ) obj.SymbolPosition = _EnumDeserializer.DeserializeSymbolPosition(json.GetValue("SymbolPosition"));

			JsonValue metaData    = json.GetValue("MetaData"   );
			if ( metaData    != null && metaData   .IsObject ) obj.MetaData    = mapper.Deserialize<ModificationMetaData>(metaData   );
			return obj;
		}
	}
}
