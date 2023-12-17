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
	class TaxCodeSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			TaxCode o = obj as TaxCode;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Id         ) ) json.AddValue("Id"                 , new JsonValue(o.Id             ));
			if ( !Sql.IsEmptyString(o.SyncToken  ) ) json.AddValue("SyncToken"          , new JsonValue(o.SyncToken      ));
			if ( !Sql.IsEmptyString(o.Name       ) ) json.AddValue("Name"               , new JsonValue(o.Name           ));
			if ( !Sql.IsEmptyString(o.Description) ) json.AddValue("Description"        , new JsonValue(o.Description    ));
			if ( o.Active              .HasValue   ) json.AddValue("Active"             , new JsonValue(o.Active   .Value));
			if ( o.Taxable             .HasValue   ) json.AddValue("Taxable"            , new JsonValue(o.Taxable  .Value));
			if ( o.TaxGroup            .HasValue   ) json.AddValue("TaxGroup"           , new JsonValue(o.TaxGroup .Value));
			if ( o.SalesTaxRateList    != null     ) json.AddValue("SalesTaxRateList"   , mapper.Serialize(o.SalesTaxRateList   ));
			if ( o.PurchaseTaxRateList != null     ) json.AddValue("PurchaseTaxRateList", mapper.Serialize(o.PurchaseTaxRateList));
			json.AddValue("domain", new JsonValue("QBO"  ));
			json.AddValue("sparse", new JsonValue("false"));
			o.RawContent = json.ToString();
			return json;
		}
	}

	class TaxCodeListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<Line> lst = obj as IList<Line>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( Line o in lst )
				{
					json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
