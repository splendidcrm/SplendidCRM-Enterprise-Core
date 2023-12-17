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
	class LineSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Line o = obj as Line;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Id         ) ) json.AddValue("Id"         , new JsonValue(o.Id          ));
			if ( !Sql.IsEmptyString(o.LineNum    ) ) json.AddValue("LineNum"    , new JsonValue(o.LineNum     ));
			if ( !Sql.IsEmptyString(o.Description) ) json.AddValue("Description", new JsonValue(o.Description ));
			if ( o.Amount      .HasValue           ) json.AddValue("Amount"     , new JsonValue(o.Amount.Value));
			if ( o.DetailType  .HasValue           ) json.AddValue("DetailType", _EnumSerializer.Serialize(o.DetailType.Value));
			if ( o.LinkedTxn   != null             ) json.AddValue("LinkedTxn"  , mapper.Serialize(o.LinkedTxn  ));
			// https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/030_entity_services_reference/invoice#Line_Details
			if ( o.Item != null && o.DetailType.HasValue )
			{
				// 02/13/2015 Paul.  The Item property is serialized as the detail type. 
				// 03/06/2015 Paul.  Correct DescriptionOnly. 
				string sItemType = o.DetailType.Value.ToString();
				if ( sItemType == "DescriptionOnly" )
					sItemType = "DescriptionLineDetail";
				json.AddValue(sItemType, mapper.Serialize(o.Item));
			}
			o.RawContent = json.ToString();
			return json;
		}
	}

	class LineListSerializer : IJsonSerializer
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
