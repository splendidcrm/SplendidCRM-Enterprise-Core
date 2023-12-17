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

namespace Spring.Social.Marketo.Api.Impl.Json
{
	class LeadFieldDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			LeadField obj = new LeadField();
			obj.RawContent = json.ToString();
			
			obj.id           = json.GetValueOrDefault<int?  >("id"          );
			obj.displayName  = json.GetValueOrDefault<String>("displayName" );
			obj.dataType     = json.GetValueOrDefault<String>("dataType"    );
			obj.length       = json.GetValueOrDefault<int?  >("length"      );
			if ( json.ContainsName("soap") )
			{
				JsonValue jsonSoap = json.GetValue("soap");
				obj.soapName     = jsonSoap.GetValueOrDefault<String>("name"    );
				obj.soapReadOnly = jsonSoap.GetValueOrDefault<bool? >("readOnly");
			}
			if ( json.ContainsName("rest") )
			{
				JsonValue jsonRest = json.GetValue("rest");
				obj.restName     = jsonRest.GetValueOrDefault<String>("name"    );
				obj.restReadOnly = jsonRest.GetValueOrDefault<bool? >("readOnly");
			}
			return obj;
		}
	}

	class LeadFieldListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<LeadField> items = new List<LeadField>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("result");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					items.Add( mapper.Deserialize<LeadField>(itemValue) );
				}
			}
			return items;
		}
	}
}
