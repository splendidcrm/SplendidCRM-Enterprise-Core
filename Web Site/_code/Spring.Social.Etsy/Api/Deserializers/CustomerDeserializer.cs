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

namespace Spring.Social.Etsy.Api.Impl.Json
{
	class CustomerDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Customer obj = new Customer();
			obj.RawContent = json.ToString();
			
			// 03/17/2022 Paul.  cursor is outside of node. 
			obj.cursor           = json.GetValueOrDefault<string   >("cursor"         );
			if ( json.ContainsName("node") )
			{
				json = json.GetValue("node");
			}
			obj.id                = json.GetValueOrDefault<String   >("id"               );
			obj.createdAt         = json.GetValueOrDefault<DateTime >("createdAt"        );
			obj.updatedAt         = json.GetValueOrDefault<DateTime?>("updatedAt"        );
			obj.firstName         = json.GetValueOrDefault<String   >("firstName"        );
			obj.lastName          = json.GetValueOrDefault<String   >("lastName"         );
			obj.displayName       = json.GetValueOrDefault<String   >("displayName"      );
			obj.email             = json.GetValueOrDefault<String   >("email"            );
			obj.phone             = json.GetValueOrDefault<String   >("phone"            );
			obj.locale            = json.GetValueOrDefault<String   >("locale"           );
			obj.note              = json.GetValueOrDefault<String   >("note"             );
			obj.taxExempt         = json.GetValueOrDefault<bool     >("taxExempt"        );
			obj.validEmailAddress = json.GetValueOrDefault<bool     >("validEmailAddress");
			obj.verifiedEmail     = json.GetValueOrDefault<bool     >("verifiedEmail"    );
			if ( json.ContainsName("state"         ) ) obj.state          = _EnumDeserializer.DeserializeCustomerState(json.GetValue("state"));
			if ( json.ContainsName("image"         ) ) obj.image          = mapper.Deserialize<Image                >(json.GetValue("image"         ));
			if ( json.ContainsName("tags"          ) ) obj.tags           = mapper.Deserialize<List<String         >>(json.GetValue("tags"          ));
			if ( json.ContainsName("defaultAddress") ) obj.defaultAddress = mapper.Deserialize<MailingAddress       >(json.GetValue("defaultAddress"));
			if ( json.ContainsName("addresses"     ) ) obj.addresses      = mapper.Deserialize<IList<MailingAddress>>(json.GetValue("addresses"     ));
			if ( json.ContainsName("orders"        ) ) obj.orders         = mapper.Deserialize<IList<Order         >>(json.GetValue("orders"        ));
			return obj;
		}
	}

	class CustomerListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Customer> items = new List<Customer>();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add( mapper.Deserialize<Customer>(itemValue) );
				}
			}
			return items;
		}
	}
}
