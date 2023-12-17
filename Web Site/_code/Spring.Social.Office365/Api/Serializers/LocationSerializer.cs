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
using System.Diagnostics;
using Spring.Json;

namespace Spring.Social.Office365.Api.Impl.Json
{
	class LocationSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Location o = obj as Location;
			
			JsonObject json = new JsonObject();
			json.AddValue("displayName"         , (Sql.IsEmptyString(o.DisplayName         ) ? new JsonValue() : new JsonValue(o.DisplayName         )));
			json.AddValue("locationEmailAddress", (Sql.IsEmptyString(o.LocationEmailAddress) ? new JsonValue() : new JsonValue(o.LocationEmailAddress)));
			json.AddValue("locationType"        , (Sql.IsEmptyString(o.LocationType        ) ? new JsonValue() : new JsonValue(o.LocationType        )));
			json.AddValue("locationUri"         , (Sql.IsEmptyString(o.LocationUri         ) ? new JsonValue() : new JsonValue(o.LocationUri         )));
			json.AddValue("uniqueId"            , (Sql.IsEmptyString(o.UniqueId            ) ? new JsonValue() : new JsonValue(o.UniqueId            )));
			json.AddValue("uniqueIdType"        , (Sql.IsEmptyString(o.UniqueIdType        ) ? new JsonValue() : new JsonValue(o.UniqueIdType        )));

			json.AddValue("address"             , (                  o.Address     == null   ? new JsonObject() : mapper.Serialize(o.Address          )));
			json.AddValue("coordinates"         , (                  o.Coordinates == null   ? new JsonObject() : mapper.Serialize(o.Coordinates      )));
			return json;
		}
	}

	class LocationListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<Location> lst = obj as IList<Location>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( Location o in lst )
				{
					json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
