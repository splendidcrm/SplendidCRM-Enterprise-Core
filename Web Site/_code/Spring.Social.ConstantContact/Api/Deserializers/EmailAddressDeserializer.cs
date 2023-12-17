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
	class EmailAddressDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			EmailAddress obj = new EmailAddress();
			
		// 11/11/2019 Paul.  Updated to v3. 
		// https://v3.developer.constantcontact.com/api_reference/index.html#!/Contacts/getContacts
			obj.permission_to_send = json.GetValueOrDefault<string  >("permission_to_send");
			obj.confirm_status     = json.GetValueOrDefault<string  >("confirm_status"    );
			obj.address            = json.GetValueOrDefault<string  >("address"           );
			obj.opt_in_date        = json.GetValueOrDefault<DateTime>("opt_in_date"       );
			obj.opt_in_source      = json.GetValueOrDefault<string  >("opt_in_source"     );
			obj.opt_out_date       = json.GetValueOrDefault<string  >("opt_out_date"      );
			obj.opt_out_source     = json.GetValueOrDefault<string  >("opt_out_source"    );
			return obj;
		}
	}

	class EmailAddressListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<EmailAddress> items = new List<EmailAddress>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add( mapper.Deserialize<EmailAddress>(itemValue) );
				}
			}
			return items;
		}
	}
}
