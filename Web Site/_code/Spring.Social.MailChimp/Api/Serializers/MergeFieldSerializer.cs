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

namespace Spring.Social.MailChimp.Api.Impl.Json
{
	class MergeFieldSerializer : IJsonSerializer
	{
		public JsonValue Serialize(object obj, JsonMapper mapper)
		{
			MergeField o = obj as MergeField;
			
			JsonObject json = new JsonObject();
			// http://developer.mailchimp.com/documentation/mailchimp/reference/lists/merge-fields/
			if ( o.merge_id > 0 )
				json.AddValue("merge_id"     , new JsonValue(o.merge_id     ));
			if ( !Sql.IsEmptyString(o.name         ) ) json.AddValue("name"         , new JsonValue(o.name         ));
			if ( !Sql.IsEmptyString(o.tag          ) ) json.AddValue("tag"          , new JsonValue(o.tag          ));
			if ( !Sql.IsEmptyString(o.type         ) ) json.AddValue("type"         , new JsonValue(o.type         ));
			if ( !Sql.IsEmptyString(o.default_value) ) json.AddValue("default_value", new JsonValue(o.default_value));
			if ( !Sql.IsEmptyString(o.help_text    ) ) json.AddValue("help_text"    , new JsonValue(o.help_text    ));
			if ( o.required     .HasValue            ) json.AddValue("required"     , new JsonValue(o.required     .Value));
			if ( o.is_public    .HasValue            ) json.AddValue("public"       , new JsonValue(o.is_public    .Value));
			if ( o.display_order.HasValue            ) json.AddValue("display_order", new JsonValue(o.display_order.Value));
			if ( o.options != null )
			{
				JsonObject jsonOptions = new JsonObject();
				if ( !Sql.IsEmptyString(o.options.phone_format) ) jsonOptions.AddValue("phone_format"   , new JsonValue(o.options.phone_format         ));
				if ( !Sql.IsEmptyString(o.options.date_format ) ) jsonOptions.AddValue("date_format"    , new JsonValue(o.options.date_format          ));
				if ( o.options.default_country.HasValue         ) jsonOptions.AddValue("default_country", new JsonValue(o.options.default_country.Value));
				if ( o.options.size           .HasValue         ) jsonOptions.AddValue("size"           , new JsonValue(o.options.size           .Value));
				if ( o.options.choices != null                  ) jsonOptions.AddValue("choices"        , mapper.Serialize(o.options.choices));
			}
			o.RawContent = json.ToString();
			return json;
		}
	}
}
