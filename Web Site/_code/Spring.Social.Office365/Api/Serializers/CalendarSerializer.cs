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
	class CalendarSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			Calendar o = obj as Calendar;
			
			JsonObject json = new JsonObject();
			json.AddValue("canEdit"                     , (                 !o.CanEdit                     .HasValue  ? new JsonValue() :    new JsonValue(o.CanEdit                     .Value)));
			json.AddValue("canShare"                    , (                 !o.CanShare                    .HasValue  ? new JsonValue() :    new JsonValue(o.CanShare                    .Value)));
			json.AddValue("canViewPrivateItems"         , (                 !o.CanViewPrivateItems         .HasValue  ? new JsonValue() :    new JsonValue(o.CanViewPrivateItems         .Value)));
			json.AddValue("color"                       , (Sql.IsEmptyString(o.Color                                ) ? new JsonValue() :    new JsonValue(o.Color                             )));
			json.AddValue("defaultOnlineMeetingProvider", (Sql.IsEmptyString(o.DefaultOnlineMeetingProvider         ) ? new JsonValue() :    new JsonValue(o.DefaultOnlineMeetingProvider      )));
			json.AddValue("hexColor"                    , (Sql.IsEmptyString(o.HexColor                             ) ? new JsonValue() :    new JsonValue(o.HexColor                          )));
			json.AddValue("isDefaultCalendar"           , (                 !o.IsDefaultCalendar           .HasValue  ? new JsonValue() :    new JsonValue(o.IsDefaultCalendar           .Value)));
			json.AddValue("isRemovable"                 , (                 !o.IsRemovable                 .HasValue  ? new JsonValue() :    new JsonValue(o.IsRemovable                 .Value)));
			json.AddValue("isTallyingResponses"         , (                 !o.IsTallyingResponses         .HasValue  ? new JsonValue() :    new JsonValue(o.IsTallyingResponses         .Value)));
			json.AddValue("name"                        , (Sql.IsEmptyString(o.Name                                 ) ? new JsonValue() :    new JsonValue(o.Name                              )));
			json.AddValue("owner"                       , (                  o.Owner                       == null    ? new JsonObject() : mapper.Serialize(o.Owner                             )));
			json.AddValue("events"                      , (                  o.Events                      == null    ? new JsonArray()  : mapper.Serialize(o.Events                            )));
			return json;
		}
	}
}
