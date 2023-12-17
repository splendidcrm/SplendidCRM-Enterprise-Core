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

namespace Spring.Social.ConstantContact.Api.Impl.Json
{
	class AddressDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Address obj = new Address();
			
			obj.id              = json.GetValueOrDefault<string>("id"             );
			obj.address_type    = json.GetValueOrDefault<string>("address_type"   );
			obj.city            = json.GetValueOrDefault<string>("city"           );
			obj.country_code    = json.GetValueOrDefault<string>("country_code"   );
			obj.line1           = json.GetValueOrDefault<string>("line1"          );
			obj.line2           = json.GetValueOrDefault<string>("line2"          );
			obj.line3           = json.GetValueOrDefault<string>("line3"          );
			obj.postal_code     = json.GetValueOrDefault<string>("postal_code"    );
			obj.state           = json.GetValueOrDefault<string>("state"          );
			obj.state_code      = json.GetValueOrDefault<string>("state_code"     );
			obj.sub_postal_code = json.GetValueOrDefault<string>("sub_postal_code");
			return obj;
		}
	}

	class AddressListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Address> items = new List<Address>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add( mapper.Deserialize<Address>(itemValue) );
				}
			}
			return items;
		}
	}
}
