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
	class ReferenceTypeDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ReferenceType obj = new ReferenceType();
			obj.Name  = json.GetValueOrDefault<String>("name" );
			obj.Type  = json.GetValueOrDefault<String>("type" );
			obj.Value = json.GetValueOrDefault<String>("value");
			return obj;
		}
	}

	class MemoRefDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MemoRef obj = new MemoRef();
			obj.Name  = json.GetValueOrDefault<String>("name" );
			obj.Value = json.GetValueOrDefault<String>("value");
			return obj;
		}
	}

	class EntityTypeRefDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			EntityTypeRef obj = new EntityTypeRef();

			if ( json.ContainsName("Type") ) obj.Type = _EnumDeserializer.DeserializeEntityType(json.GetValue("Type"));

			JsonValue entityRef = json.GetValue("EntityRef");
			if ( entityRef != null && entityRef.IsObject ) obj.EntityRef = mapper.Deserialize<ReferenceType>(entityRef);
			return obj;
		}
	}

	class UOMRefDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			UOMRef obj = new UOMRef();
			obj.Unit = json.GetValueOrDefault<String>("Unit");
			
			JsonValue uOMSetRef = json.GetValue("UOMSetRef");
			if ( uOMSetRef != null && uOMSetRef.IsObject ) obj.UOMSetRef = mapper.Deserialize<ReferenceType>(uOMSetRef);
			return obj;
		}
	}
}
