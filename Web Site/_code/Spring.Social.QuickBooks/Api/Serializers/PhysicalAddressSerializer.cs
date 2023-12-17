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
	class PhysicalAddressSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			PhysicalAddress o = obj as PhysicalAddress;
			
			JsonObject json = new JsonObject();
			if ( !Sql.IsEmptyString(o.Id                    ) ) json.AddValue("Id"                      , new JsonValue(o.Id                    ));
			if ( !Sql.IsEmptyString(o.Line1                 ) ) json.AddValue("Line1"                   , new JsonValue(o.Line1                 ));
			if ( !Sql.IsEmptyString(o.Line2                 ) ) json.AddValue("Line2"                   , new JsonValue(o.Line2                 ));
			if ( !Sql.IsEmptyString(o.Line3                 ) ) json.AddValue("Line3"                   , new JsonValue(o.Line3                 ));
			if ( !Sql.IsEmptyString(o.Line4                 ) ) json.AddValue("Line4"                   , new JsonValue(o.Line4                 ));
			if ( !Sql.IsEmptyString(o.Line5                 ) ) json.AddValue("Line5"                   , new JsonValue(o.Line5                 ));
			if ( !Sql.IsEmptyString(o.City                  ) ) json.AddValue("City"                    , new JsonValue(o.City                  ));
			if ( !Sql.IsEmptyString(o.Country               ) ) json.AddValue("Country"                 , new JsonValue(o.Country               ));
			if ( !Sql.IsEmptyString(o.CountryCode           ) ) json.AddValue("CountryCode"             , new JsonValue(o.CountryCode           ));
			if ( !Sql.IsEmptyString(o.CountrySubDivisionCode) ) json.AddValue("CountrySubDivisionCode"  , new JsonValue(o.CountrySubDivisionCode));
			if ( !Sql.IsEmptyString(o.PostalCode            ) ) json.AddValue("PostalCode"              , new JsonValue(o.PostalCode            ));
			if ( !Sql.IsEmptyString(o.PostalCodeSuffix      ) ) json.AddValue("PostalCodeSuffix"        , new JsonValue(o.PostalCodeSuffix      ));
			if ( !Sql.IsEmptyString(o.Lat                   ) ) json.AddValue("Lat"                     , new JsonValue(o.Lat                   ));
			if ( !Sql.IsEmptyString(o.Long                  ) ) json.AddValue("Long"                    , new JsonValue(o.Long                  ));
			if ( !Sql.IsEmptyString(o.Tag                   ) ) json.AddValue("Tag"                     , new JsonValue(o.Tag                   ));
			if ( !Sql.IsEmptyString(o.Note                  ) ) json.AddValue("Note"                    , new JsonValue(o.Note                  ));
			return json;
		}
	}

	class PhysicalAddressListSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			IList<Line> lst = obj as IList<Line>;
			JsonArray json = new JsonArray();
			if ( lst != null )
			{
				foreach ( Line o in lst )
				{
					json.AddValue(mapper.Serialize(o));
				}
			}
			return json;
		}
	}
}
