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

namespace Spring.Social.QuickBooks.Api.Impl.Json
{
	class PhysicalAddressDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			PhysicalAddress obj = new PhysicalAddress();
			obj.Id                      = json.GetValueOrDefault<String>("Id"                      );
			obj.Line1                   = json.GetValueOrDefault<String>("Line1"                   );
			obj.Line2                   = json.GetValueOrDefault<String>("Line2"                   );
			obj.Line3                   = json.GetValueOrDefault<String>("Line3"                   );
			obj.Line4                   = json.GetValueOrDefault<String>("Line4"                   );
			obj.Line5                   = json.GetValueOrDefault<String>("Line5"                   );
			obj.City                    = json.GetValueOrDefault<String>("City"                    );
			obj.Country                 = json.GetValueOrDefault<String>("Country"                 );
			obj.CountryCode             = json.GetValueOrDefault<String>("CountryCode"             );
			obj.CountrySubDivisionCode  = json.GetValueOrDefault<String>("CountrySubDivisionCode"  );
			obj.PostalCode              = json.GetValueOrDefault<String>("PostalCode"              );
			obj.PostalCodeSuffix        = json.GetValueOrDefault<String>("PostalCodeSuffix"        );
			obj.Lat                     = json.GetValueOrDefault<String>("Lat"                     );
			obj.Long                    = json.GetValueOrDefault<String>("Long"                    );
			obj.Tag                     = json.GetValueOrDefault<String>("Tag"                     );
			obj.Note                    = json.GetValueOrDefault<String>("Note"                    );
			return obj;
		}
	}

	class PhysicalAddressListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue value, JsonMapper mapper)
		{
			IList<PhysicalAddress> addresses = new List<PhysicalAddress>();
			if ( value != null && value.IsArray )
			{
				foreach ( JsonValue itemValue in value.GetValues() )
				{
					addresses.Add( mapper.Deserialize<PhysicalAddress>(itemValue) );
				}
			}
			return addresses;
		}
	}
}
