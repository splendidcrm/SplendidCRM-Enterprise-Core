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
	class TaxRateDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 06/12/2014 Paul.  This method is called for each array item and for a single item. 
			if ( json.ContainsName("TaxRate") )
			{
				json = json.GetValue("TaxRate");
			}
			TaxRate obj = new TaxRate();
			obj.RawContent  = json.ToString();
			obj.Id          = json.GetValueOrDefault<String  >("Id"         );
			obj.SyncToken   = json.GetValueOrDefault<String  >("SyncToken"  );
			obj.Name        = json.GetValueOrDefault<String  >("Name"       );
			obj.Description = json.GetValueOrDefault<String  >("Description");
			obj.Active      = json.GetValueOrDefault<Boolean?>("Active"     );
			obj.Rate        = json.GetValueOrDefault<Decimal?>("RateValue"  );

			if ( json.ContainsName("SpecialTaxType") ) obj.SpecialTaxType = _EnumDeserializer.DeserializeSpecialTaxType    (json.GetValue("SpecialTaxType"));
			if ( json.ContainsName("DisplayType"   ) ) obj.DisplayType    = _EnumDeserializer.DeserializeTaxRateDisplayType(json.GetValue("DisplayType"   ));

			JsonValue metaData         = json.GetValue("MetaData"        );
			JsonValue agencyRef        = json.GetValue("AgencyRef"       );
			JsonValue taxReturnLineRef = json.GetValue("TaxReturnLineRef");
			JsonValue effectiveTaxRate = json.GetValue("EffectiveTaxRate");
			if ( metaData         != null && metaData        .IsObject ) obj.MetaData         = mapper.Deserialize<ModificationMetaData   >(metaData        );
			if ( agencyRef        != null && agencyRef       .IsObject ) obj.AgencyRef        = mapper.Deserialize<ReferenceType          >(agencyRef       );
			if ( taxReturnLineRef != null && taxReturnLineRef.IsObject ) obj.TaxReturnLineRef = mapper.Deserialize<ReferenceType          >(taxReturnLineRef);
			if ( effectiveTaxRate != null && effectiveTaxRate.IsArray  ) obj.EffectiveTaxRate = mapper.Deserialize<IList<EffectiveTaxRate>>(effectiveTaxRate);
			return obj;
		}
	}

	class TaxRateListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<TaxRate> taxRates = new List<TaxRate>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				JsonValue jsonTaxRates = jsonResponse.GetValue("TaxRate");
				if ( jsonTaxRates != null && jsonTaxRates.IsArray )
				{
					foreach ( JsonValue itemValue in jsonTaxRates.GetValues() )
					{
						taxRates.Add( mapper.Deserialize<TaxRate>(itemValue) );
					}
				}
			}
			return taxRates;
		}
	}
}
