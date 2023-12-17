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

namespace Spring.Social.Shopify.Api.Impl.Json
{
	class MailingAddressDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MailingAddress obj = new MailingAddress();
			obj.id               = json.GetValueOrDefault<String>("id"              );
			obj.firstName        = json.GetValueOrDefault<String>("firstName"       );
			obj.lastName         = json.GetValueOrDefault<String>("lastName"        );
			obj.phone            = json.GetValueOrDefault<String>("phone"           );
			obj.company          = json.GetValueOrDefault<String>("company"         );
			obj.address1         = json.GetValueOrDefault<String>("address1"        );
			obj.address2         = json.GetValueOrDefault<String>("address2"        );
			obj.city             = json.GetValueOrDefault<String>("city"            );
			obj.province         = json.GetValueOrDefault<String>("province"        );
			obj.provinceCode     = json.GetValueOrDefault<String>("provinceCode"    );
			obj.country          = json.GetValueOrDefault<String>("country"         );
			obj.countryCode      = json.GetValueOrDefault<String>("countryCode"     );
			obj.zip              = json.GetValueOrDefault<String>("zip"             );
			obj.latitude         = json.GetValueOrDefault<float >("latitude"        );
			obj.longitude        = json.GetValueOrDefault<float >("longitude"       );
			return obj;
		}
	}

	class MailingAddressListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue value, JsonMapper mapper)
		{
			IList<MailingAddress> addresses = new List<MailingAddress>();
			if ( value != null && value.IsArray )
			{
				foreach ( JsonValue itemValue in value.GetValues() )
				{
					addresses.Add( mapper.Deserialize<MailingAddress>(itemValue) );
				}
			}
			return addresses;
		}
	}
}
