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
	class GenericContactTypeSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			GenericContactType o = obj as GenericContactType;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Id   ) ) json.AddValue("Id"     , new JsonValue(o.Id     ));
			if ( !Sql.IsEmptyString(o.Name ) ) json.AddValue("Name"   , new JsonValue(o.Name   ));
			if ( !Sql.IsEmptyString(o.Value) ) json.AddValue("Value"  , new JsonValue(o.Value  ));
			if ( !Sql.IsEmptyString(o.Type ) ) json.AddValue("Type"   , new JsonValue(o.Type   ));
			if ( !Sql.IsEmptyString(o.Tag  ) ) json.AddValue("Tag"    , new JsonValue(o.Tag    ));
			if ( o.Default.HasValue          ) json.AddValue("Default", new JsonValue(o.Default.Value));
			return json;
		}
	}
}
