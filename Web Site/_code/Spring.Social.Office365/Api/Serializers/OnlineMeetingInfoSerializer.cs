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
	class OnlineMeetingInfoSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			OnlineMeetingInfo o = obj as OnlineMeetingInfo;
			
			JsonObject json = new JsonObject();
			json.AddValue("conferenceId"   , (Sql.IsEmptyString(o.ConferenceId               ) ? new JsonValue() :    new JsonValue(o.ConferenceId   )));
			json.AddValue("joinUrl"        , (Sql.IsEmptyString(o.JoinUrl                    ) ? new JsonValue() :    new JsonValue(o.JoinUrl        )));
			json.AddValue("quickDial"      , (Sql.IsEmptyString(o.QuickDial                  ) ? new JsonValue() :    new JsonValue(o.QuickDial      )));
			json.AddValue("tollNumber"     , (Sql.IsEmptyString(o.TollNumber                 ) ? new JsonValue() :    new JsonValue(o.TollNumber     )));

			json.AddValue("phones"         , (                  o.Phones          == null      ? new JsonArray() : mapper.Serialize(o.Phones         )));
			json.AddValue("tollFreeNumbers", (                  o.TollFreeNumbers == null      ? new JsonArray() : mapper.Serialize(o.TollFreeNumbers)));
			return json;
		}
	}
}
