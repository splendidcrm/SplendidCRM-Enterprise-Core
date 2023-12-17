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
	class EffectiveTaxRateDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			EffectiveTaxRate obj = new EffectiveTaxRate();
			obj.RateValue     = json.GetValueOrDefault<Decimal? >("RateValue"    );
			obj.EffectiveDate = json.GetValueOrDefault<DateTime?>("EffectiveDate");
			obj.EndDate       = json.GetValueOrDefault<DateTime?>("EndDate"      );
			return obj;
		}
	}

	class EffectiveTaxRateListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue value, JsonMapper mapper)
		{
			IList<EffectiveTaxRate> rates = new List<EffectiveTaxRate>();
			if ( value != null && value.IsArray )
			{
				foreach ( JsonValue itemValue in value.GetValues() )
				{
					rates.Add( mapper.Deserialize<EffectiveTaxRate>(itemValue) );
				}
			}
			return rates;
		}
	}
}
