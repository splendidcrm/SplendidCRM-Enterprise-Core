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

namespace Spring.Social.PhoneBurner.Api.Impl.Json
{
	class DialSessionSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			DialSession o = obj as DialSession;
			
			JsonObject json = new JsonObject();
			if ( o.contacts != null )
			{
				json.AddValue("contacts", mapper.Serialize(o.contacts ));
				
				JsonObject api_callbegin = new JsonObject();
				api_callbegin.AddValue("callback_type", new JsonValue("api_callbegin"));
				api_callbegin.AddValue("callback"     , new JsonValue(o.api_callbegin));
				JsonObject api_calldone  = new JsonObject();
				api_calldone.AddValue ("callback_type", new JsonValue("api_calldone" ));
				api_calldone.AddValue ("callback"     , new JsonValue(o.api_calldone ));
				
				JsonArray arr = new JsonArray();
				arr.AddValue(api_callbegin);
				arr.AddValue(api_calldone );
				json.AddValue("callbacks", arr);
			}
			json.AddValue("custom_data", mapper.Serialize(o.custom_data));

			o.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.PhoneBurner.Api.Impl.Json.DialSessionSerializer.Serialize " + o.RawContent);
			return json;
		}
	}
}
