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

namespace Spring.Social.iContact.Api.Impl.Json
{
	class ContactDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 05/02/2015 Paul.  This method is called for each array item and for a single item. 
			if ( json.ContainsName("contact") )
			{
				json = json.GetValue("contact");
			}
			Contact obj = new Contact();
			obj.RawContent = json.ToString();
			
			obj.contactId    = json.GetValueOrDefault<string  >("contactId"  );
			obj.createDate   = json.GetValueOrDefault<DateTime>("createDate" );
			obj.email        = json.GetValueOrDefault<string  >("email"      );
			obj.prefix       = json.GetValueOrDefault<string  >("prefix"     );
			obj.firstName    = json.GetValueOrDefault<string  >("firstName"  );
			obj.lastName     = json.GetValueOrDefault<string  >("lastName"   );
			obj.suffix       = json.GetValueOrDefault<string  >("suffix"     );
			obj.street       = json.GetValueOrDefault<string  >("street"     );
			obj.street2      = json.GetValueOrDefault<string  >("street2"    );
			obj.city         = json.GetValueOrDefault<string  >("city"       );
			obj.state        = json.GetValueOrDefault<string  >("state"      );
			obj.postalCode   = json.GetValueOrDefault<string  >("postalCode" );
			obj.phone        = json.GetValueOrDefault<string  >("phone"      );
			obj.fax          = json.GetValueOrDefault<string  >("fax"        );
			obj.business     = json.GetValueOrDefault<string  >("business"   );
			obj.status       = json.GetValueOrDefault<string  >("status"     );
			obj.bounceCount  = Sql.ToInteger(json.GetValueOrDefault<string>("bounceCount"));
			return obj;
		}
	}

	class ContactListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Contact> items = new List<Contact>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("contacts");
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
				pag.limit  = json.GetValueOrDefault<int>("limit" );
				pag.offset = json.GetValueOrDefault<int>("offset");
				pag.total  = json.GetValueOrDefault<int>("total" );
				pag.items  = mapper.Deserialize<IList<Contact>>(json);
			}
			return pag;
		}
	}
}
