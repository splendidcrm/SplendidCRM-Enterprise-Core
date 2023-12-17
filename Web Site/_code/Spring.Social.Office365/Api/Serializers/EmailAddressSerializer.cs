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
using System.Diagnostics;
using Spring.Json;

namespace Spring.Social.Office365.Api.Impl.Json
{
	class EmailAddressSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			EmailAddress o = obj as EmailAddress;
			
			JsonObject json = new JsonObject();
			json.AddValue("address", (Sql.IsEmptyString(o.Address) ? new JsonValue() : new JsonValue(o.Address)));
			json.AddValue("name"   , (Sql.IsEmptyString(o.Name   ) ? new JsonValue() : new JsonValue(o.Name   )));
			return json;
		}
	}

	class EmailAddressListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<EmailAddress> lst = obj as IList<EmailAddress>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( EmailAddress o in lst )
				{
					// 12/17/2021 Paul.  Office365 is returning empty addresses, then complaining if empty address is sent. 
					if ( !Sql.IsEmptyString(o.Address) )
						json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
