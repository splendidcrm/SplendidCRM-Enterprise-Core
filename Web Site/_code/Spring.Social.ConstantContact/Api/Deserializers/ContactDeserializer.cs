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
	class ContactDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Contact obj = new Contact();
			obj.RawContent = json.ToString();
			
			// 11/11/2019 Paul.  Updated to v3. 
			// https://v3.developer.constantcontact.com/api_reference/index.html#!/Contacts/getContacts
			obj.id               = json.GetValueOrDefault<string  >("contact_id"    );
			obj.created_date     = json.GetValueOrDefault<DateTime>("created_at"    );
			obj.modified_date    = json.GetValueOrDefault<DateTime>("updated_at"    );
			obj.prefix_name      = json.GetValueOrDefault<string  >("prefix_name"   );
			obj.first_name       = json.GetValueOrDefault<string  >("first_name"    );
			obj.last_name        = json.GetValueOrDefault<string  >("last_name"     );
			obj.job_title        = json.GetValueOrDefault<string  >("job_title"     );
			obj.company_name     = json.GetValueOrDefault<string  >("company_name"  );
			obj.work_phone       = json.GetValueOrDefault<string  >("work_phone"    );
			obj.fax              = json.GetValueOrDefault<string  >("fax"           );
			obj.cell_phone       = json.GetValueOrDefault<string  >("cell_phone"    );
			obj.home_phone       = json.GetValueOrDefault<string  >("home_phone"    );
			obj.confirmed        = json.GetValueOrDefault<string  >("confirmed"     );
			obj.status           = json.GetValueOrDefault<string  >("status"        );
			obj.source           = json.GetValueOrDefault<string  >("source"        );
			obj.source_details   = json.GetValueOrDefault<string  >("source_details");

			JsonValue email_address   = json.GetValue("email_address"   );
			JsonValue addresses       = json.GetValue("street_addresses");
			JsonValue lists           = json.GetValue("lists"           );
			JsonValue notes           = json.GetValue("notes"           );
			if ( email_address != null && email_address.IsArray ) obj.email_address = mapper.Deserialize<EmailAddress  >(email_address);
			if ( addresses     != null && addresses    .IsArray ) obj.addresses     = mapper.Deserialize<IList<Address>>(addresses    );
			if ( lists         != null && lists        .IsArray ) obj.lists         = mapper.Deserialize<IList<ListRef>>(lists        );
			if ( notes         != null && notes        .IsArray ) obj.notes         = mapper.Deserialize<IList<Note   >>(notes        );
			return obj;
		}
	}

	class ContactListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Contact> items = new List<Contact>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("results");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					items.Add( mapper.Deserialize<Contact>(itemValue) );
				}
			}
			return items;
		}
	}

	class ContactPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ContactPagination pag = new ContactPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				// http://developer.constantcontact.com/docs/developer-guides/paginated-output.html
				JsonValue jsonMeta = json.GetValue("meta");
				if ( jsonMeta != null )
				{
					JsonValue jsonPagination = jsonMeta.GetValue("pagination");
					if ( jsonPagination != null )
					{
						pag.next_link = jsonPagination.GetValueOrDefault<string>("next_link");
					}
				}
				pag.items = mapper.Deserialize<IList<Contact>>(json);
			}
			return pag;
		}
	}
}
