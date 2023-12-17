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

namespace Spring.Social.GetResponse.Api.Impl.Json
{
	class ContactDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Contact obj = new Contact();
			obj.RawContent = json.ToString();
			
			obj.id         = json.GetValueOrDefault<string   >("contactId"     );
			if ( json.ContainsName("searchContactId") )
				obj.id = json.GetValueOrDefault<string>("searchContactId");
			
			obj.createdOn  = json.GetValueOrDefault<DateTime?>("createdOn"     );
			obj.changedOn  = json.GetValueOrDefault<DateTime?>("changedOn"     );
			obj.name       = json.GetValueOrDefault<string   >("name"          );
			obj.email      = json.GetValueOrDefault<string   >("email"         );
			obj.note       = json.GetValueOrDefault<string   >("note"          );
			obj.origin     = json.GetValueOrDefault<string   >("origin"        );
			obj.ipAddress  = json.GetValueOrDefault<string   >("ipAddress"     );
			obj.timeZone   = json.GetValueOrDefault<string   >("timeZone"      );
			obj.dayOfCycle = json.GetValueOrDefault<string   >("dayOfCycle"    );
			if ( json.ContainsName("campaign") )
			{
				JsonValue jsonCampaign = json.GetValue("campaign");
				obj.campaignId   = jsonCampaign.GetValueOrDefault<string>("campaignId");
				obj.campaignName = jsonCampaign.GetValueOrDefault<string>("name"      );
			}
			return obj;
		}
	}

	class ContactListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Contact> items = new List<Contact>();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add(mapper.Deserialize<Contact>(itemValue));
				}
			}
			return items;
		}
	}
}
