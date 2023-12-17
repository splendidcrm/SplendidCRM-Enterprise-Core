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
	class MailingAddressSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			MailingAddress o = obj as MailingAddress;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.id          ) ) json.AddValue("id"               , new JsonValue(o.id          ));
			if ( !Sql.IsEmptyString(o.firstName   ) ) json.AddValue("firstName"        , new JsonValue(o.firstName   ));
			if ( !Sql.IsEmptyString(o.lastName    ) ) json.AddValue("lastName"         , new JsonValue(o.lastName    ));
			if ( !Sql.IsEmptyString(o.phone       ) ) json.AddValue("phone"            , new JsonValue(o.phone       ));
			if ( !Sql.IsEmptyString(o.company     ) ) json.AddValue("company"          , new JsonValue(o.company     ));
			if ( !Sql.IsEmptyString(o.address1    ) ) json.AddValue("address1"         , new JsonValue(o.address1    ));
			if ( !Sql.IsEmptyString(o.address2    ) ) json.AddValue("address2"         , new JsonValue(o.address2    ));
			if ( !Sql.IsEmptyString(o.city        ) ) json.AddValue("city"             , new JsonValue(o.city        ));
			if ( !Sql.IsEmptyString(o.province    ) ) json.AddValue("province"         , new JsonValue(o.province    ));
			if ( !Sql.IsEmptyString(o.provinceCode) ) json.AddValue("provinceCode"     , new JsonValue(o.provinceCode));
			if ( !Sql.IsEmptyString(o.country     ) ) json.AddValue("country"          , new JsonValue(o.country     ));
			if ( !Sql.IsEmptyString(o.countryCode ) ) json.AddValue("countryCode"      , new JsonValue(o.countryCode ));
			if ( !Sql.IsEmptyString(o.zip         ) ) json.AddValue("zip"              , new JsonValue(o.zip         ));
			if ( o.latitude  != 0.0                 ) json.AddValue("latitude"         , new JsonValue(o.latitude    ));
			if ( o.longitude != 0.0                 ) json.AddValue("longitude"        , new JsonValue(o.longitude   ));
			return json;
		}
	}

	class MailingAddressListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<MailingAddress> lst = obj as IList<MailingAddress>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( MailingAddress o in lst )
				{
					json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
