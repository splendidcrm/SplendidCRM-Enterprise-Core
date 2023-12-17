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

namespace Spring.Social.PhoneBurner.Api.Impl.Json
{
	class PhoneDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Phone obj = new Phone();

			try
			{
				obj.do_not_call   = json.GetValueOrDefault<int   >("do_not_call"  );
				obj.is_global_dnc = json.GetValueOrDefault<int   >("is_global_dnc");
				obj.user_phone_id = json.GetValueOrDefault<String>("user_phone_id");
				obj.user_id       = json.GetValueOrDefault<String>("user_id"      );
				obj.phone         = json.GetValueOrDefault<String>("phone"        );
				obj.raw_phone     = json.GetValueOrDefault<String>("raw_phone"    );
				obj.area_code     = json.GetValueOrDefault<String>("area_code"    );
				obj.type          = json.GetValueOrDefault<String>("type"         );
				obj.is_primary    = json.GetValueOrDefault<String>("is_primary"   );
				obj.label         = json.GetValueOrDefault<String>("label"        );
				// 09/03/2020 Paul.  CallDone uses alternate fields. 
				JsonValue number      = json.GetValue("number"     );
				JsonValue phone_type  = json.GetValue("phone_type" );
				JsonValue phone_label = json.GetValue("phone_label");
				if ( number      != null ) obj.phone = json.GetValueOrDefault<String>("number"     );
				if ( phone_type  != null ) obj.type  = json.GetValueOrDefault<String>("phone_type" );
				if ( phone_label != null ) obj.label = json.GetValueOrDefault<String>("phone_label");
			}
			catch(Exception ex)
			{
				System.Diagnostics.Debug.WriteLine(ex.Message);
				System.Diagnostics.Debug.WriteLine(ex.StackTrace);
				throw;
			}
			return obj;
		}
	}

	class PhoneListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Phone> items = new List<Phone>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add( mapper.Deserialize<Phone>(itemValue) );
				}
			}
			return items;
		}
	}

}
