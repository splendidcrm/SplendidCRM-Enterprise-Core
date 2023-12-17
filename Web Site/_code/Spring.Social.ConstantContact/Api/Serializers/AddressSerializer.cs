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

namespace Spring.Social.ConstantContact.Api.Impl.Json
{
	class AddressSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Address o = obj as Address;
			
			JsonObject json = new JsonObject();
			if ( o.id              != null   ) json.AddValue("id"             , new JsonValue(o.id             ));
			if ( o.address_type    != null   ) json.AddValue("address_type"   , new JsonValue(o.address_type   ));
			if ( o.city            != null   ) json.AddValue("city"           , new JsonValue(o.city           ));
			if ( o.country_code    != null   ) json.AddValue("country_code"   , new JsonValue(o.country_code   ));
			if ( o.line1           != null   ) json.AddValue("line1"          , new JsonValue(o.line1          ));
			if ( o.line2           != null   ) json.AddValue("line2"          , new JsonValue(o.line2          ));
			if ( o.line3           != null   ) json.AddValue("line3"          , new JsonValue(o.line3          ));
			if ( o.postal_code     != null   ) json.AddValue("postal_code"    , new JsonValue(o.postal_code    ));
			if ( o.state           != null   ) json.AddValue("state"          , new JsonValue(o.state          ));
			if ( o.state_code      != null   ) json.AddValue("state_code"     , new JsonValue(o.state_code     ));
			if ( o.sub_postal_code != null   ) json.AddValue("sub_postal_code", new JsonValue(o.sub_postal_code));
			return json;
		}
	}

	class AddressListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<Address> lst = obj as IList<Address>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( Address o in lst )
				{
					json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
