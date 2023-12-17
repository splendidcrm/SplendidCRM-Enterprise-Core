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
	class TaxRateDetailDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			if ( json.ContainsName("TaxRateDetail") )
			{
				json = json.GetValue("TaxRateDetail");
			}
			TaxRateDetail obj = new TaxRateDetail();
			obj.TaxOrder = json.GetValueOrDefault<int?  >("TaxOrder");

			if ( json.ContainsName("TaxTypeApplicable") ) obj.TaxTypeApplicable = _EnumDeserializer.DeserializeTaxType(json.GetValue("TaxTypeApplicable"));

			JsonValue taxRateRef  = json.GetValue("TaxRateRef");
			if ( taxRateRef != null && taxRateRef.IsObject ) obj.TaxRateRef = mapper.Deserialize<ReferenceType>(taxRateRef);
			return obj;
		}
	}

	class TaxRateDetailListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue value, JsonMapper mapper)
		{
			IList<TaxRateDetail> taxRates = new List<TaxRateDetail>();
			if ( value != null && value.IsArray )
			{
				foreach ( JsonValue itemValue in value.GetValues() )
				{
					taxRates.Add( mapper.Deserialize<TaxRateDetail>(itemValue) );
				}
			}
			return taxRates;
		}
	}
}
