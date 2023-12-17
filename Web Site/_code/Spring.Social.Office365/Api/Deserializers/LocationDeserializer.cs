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

namespace Spring.Social.Office365.Api.Impl.Json
{
	class LocationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Location obj = new Location();
			obj.DisplayName          = json.GetValueOrDefault<String>   ("displayName"         );
			obj.LocationEmailAddress = json.GetValueOrDefault<String>   ("locationEmailAddress");
			obj.LocationType         = json.GetValueOrDefault<String>   ("locationType"        );
			obj.LocationUri          = json.GetValueOrDefault<String>   ("locationUri"         );
			obj.UniqueId             = json.GetValueOrDefault<String>   ("uniqueId"            );
			obj.UniqueIdType         = json.GetValueOrDefault<String>   ("uniqueIdType"        );
			
			JsonValue Address        = json.GetValue                    ("address"             );
			JsonValue Coordinates    = json.GetValue                    ("coordinates"         );
			JsonValue AdditionalData = json.GetValue                    ("additionalData"      );
			if ( Address        != null && !Address       .IsNull && Address       .IsObject ) obj.Address        = mapper.Deserialize<PhysicalAddress      >(Address       );
			if ( Coordinates    != null && !Coordinates   .IsNull && Coordinates   .IsObject ) obj.Coordinates    = mapper.Deserialize<OutlookGeoCoordinates>(Coordinates   );
			if ( AdditionalData != null && !AdditionalData.IsNull && AdditionalData.IsObject ) obj.AdditionalData = mapper.Deserialize<AdditionalData       >(AdditionalData);
			return obj;
		}
	}

	class LocationListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Location> locations = new List<Location>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					locations.Add( mapper.Deserialize<Location>(itemValue) );
				}
			}
			return locations;
		}
	}

}
