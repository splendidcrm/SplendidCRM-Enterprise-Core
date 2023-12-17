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
	class ReferenceTypeSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			ReferenceType o = obj as ReferenceType;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Name ) ) json.AddValue("name" , new JsonValue(o.Name ));
			if ( !Sql.IsEmptyString(o.Type ) ) json.AddValue("type" , new JsonValue(o.Type ));
			if ( !Sql.IsEmptyString(o.Value) ) json.AddValue("value", new JsonValue(o.Value));
			return json;
		}
	}

	class MemoRefSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			MemoRef o = obj as MemoRef;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Name ) ) json.AddValue("name" , new JsonValue(o.Name ));
			if ( !Sql.IsEmptyString(o.Value) ) json.AddValue("value", new JsonValue(o.Value));
			return json;
		}
	}

	class EntityTypeRefSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			EntityTypeRef o = obj as EntityTypeRef;
			
			JsonObject json = new JsonObject();
			if ( o.Type      .HasValue ) json.AddValue("Type"     , _EnumSerializer.Serialize(o.Type.Value));
			if ( o.EntityRef != null   ) json.AddValue("EntityRef", mapper.Serialize(o.EntityRef));
			return json;
		}
	}

	class UOMRefSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			UOMRef o = obj as UOMRef;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Unit) ) json.AddValue("Unit"     , new JsonValue(o.Unit));
			if ( o.UOMSetRef != null        ) json.AddValue("UOMSetRef", mapper.Serialize(o.UOMSetRef));
			return json;
		}
	}
}
