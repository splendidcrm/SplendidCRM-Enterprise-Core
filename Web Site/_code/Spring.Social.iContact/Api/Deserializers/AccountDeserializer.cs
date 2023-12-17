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
	class AccountDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Account obj = new Account();
			obj.RawContent = json.ToString();
			
			obj.billingStreet     = json.GetValueOrDefault<string  >("billingStreet"    );
			obj.billingCity       = json.GetValueOrDefault<string  >("billingCity"      );
			obj.billingState      = json.GetValueOrDefault<string  >("billingState"     );
			obj.billingPostalCode = json.GetValueOrDefault<string  >("billingPostalCode");
			obj.billingCountry    = json.GetValueOrDefault<string  >("billingCountry"   );
			obj.city              = json.GetValueOrDefault<string  >("city"             );
			obj.accountId         = json.GetValueOrDefault<string  >("accountId"        );
			obj.companyName       = json.GetValueOrDefault<string  >("companyName"      );
			obj.country           = json.GetValueOrDefault<string  >("country"          );
			obj.email             = json.GetValueOrDefault<string  >("email"            );
			obj.enabled           = json.GetValueOrDefault<string  >("enabled"          );
			obj.fax               = json.GetValueOrDefault<string  >("fax"              );
			obj.firstName         = json.GetValueOrDefault<string  >("firstName"        );
			obj.lastName          = json.GetValueOrDefault<string  >("lastName"         );
			obj.multiClientFolder = json.GetValueOrDefault<string  >("multiClientFolder");
			obj.multiUser         = json.GetValueOrDefault<string  >("multiUser"        );
			obj.phone             = json.GetValueOrDefault<string  >("phone"            );
			obj.postalCode        = json.GetValueOrDefault<string  >("postalCode"       );
			obj.state             = json.GetValueOrDefault<string  >("state"            );
			obj.street            = json.GetValueOrDefault<string  >("street"           );
			obj.title             = json.GetValueOrDefault<string  >("title"            );
			obj.accountType       = json.GetValueOrDefault<string  >("accountType"      );
			obj.subscriberLimit   = json.GetValueOrDefault<string  >("subscriberLimit"  );
			return obj;
		}
	}

	class AccountListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Account> items = new List<Account>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("accounts");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					items.Add( mapper.Deserialize<Account>(itemValue) );
				}
			}
			return items;
		}
	}
}
