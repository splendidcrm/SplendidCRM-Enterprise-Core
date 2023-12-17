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
	class EffectiveTaxRateSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			EffectiveTaxRate o = obj as EffectiveTaxRate;
			
			JsonObject json = new JsonObject();
			if ( o.RateValue    .HasValue ) json.AddValue("RateValue"    , new JsonValue(o.RateValue    .Value));
			if ( o.EffectiveDate.HasValue ) json.AddValue("EffectiveDate", new JsonValue(o.EffectiveDate.Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			if ( o.EndDate      .HasValue ) json.AddValue("EndDate"      , new JsonValue(o.EndDate      .Value.ToString("yyyy-MM-ddTHH:mm:sszzz")));
			return json;
		}
	}

	class EffectiveTaxRateListSerializer : IJsonSerializer
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
