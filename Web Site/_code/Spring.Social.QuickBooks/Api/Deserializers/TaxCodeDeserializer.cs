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
	class TaxCodeDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			if ( json.ContainsName("TaxCode") )
			{
				json = json.GetValue("TaxCode");
			}
			TaxCode obj = new TaxCode();
			obj.RawContent  = json.ToString();
			obj.Id          = json.GetValueOrDefault<String  >("Id"         );
			obj.SyncToken   = json.GetValueOrDefault<String  >("SyncToken"  );
			obj.Name        = json.GetValueOrDefault<String  >("Name"       );
			obj.Description = json.GetValueOrDefault<String  >("Description");
			obj.Active      = json.GetValueOrDefault<Boolean?>("Active"     );
			obj.Taxable     = json.GetValueOrDefault<Boolean?>("Taxable"    );
			obj.TaxGroup    = json.GetValueOrDefault<Boolean?>("TaxGroup"   );

			JsonValue metaData            = json.GetValue("MetaData"           );
			JsonValue salesTaxRateList    = json.GetValue("SalesTaxRateList"   );
			JsonValue purchaseTaxRateList = json.GetValue("PurchaseTaxRateList");
			if ( metaData            != null && metaData           .IsObject ) obj.MetaData            = mapper.Deserialize<ModificationMetaData>(metaData           );
			if ( salesTaxRateList    != null && salesTaxRateList   .IsObject ) obj.SalesTaxRateList    = mapper.Deserialize<TaxRateRefList      >(salesTaxRateList   );
			if ( purchaseTaxRateList != null && purchaseTaxRateList.IsObject ) obj.PurchaseTaxRateList = mapper.Deserialize<TaxRateRefList      >(purchaseTaxRateList);
			return obj;
		}
	}

	class TaxCodeListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<TaxCode> taxCodes = new List<TaxCode>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				JsonValue jsonTaxCodes = jsonResponse.GetValue("TaxCode");
				if ( jsonTaxCodes != null && jsonTaxCodes.IsArray )
				{
					foreach ( JsonValue itemValue in jsonTaxCodes.GetValues() )
					{
						taxCodes.Add( mapper.Deserialize<TaxCode>(itemValue) );
					}
				}
			}
			return taxCodes;
		}
	}
}
