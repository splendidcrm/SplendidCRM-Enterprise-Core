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
	class MergeFieldDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MergeField obj = new MergeField();
			obj.RawContent = json.ToString();
			
			// http://developer.mailchimp.com/documentation/mailchimp/reference/lists/merge-fields/
			obj.merge_id         = json.GetValueOrDefault<int    >("merge_id"     );
			obj.tag              = json.GetValueOrDefault<String >("tag"          );
			obj.name             = json.GetValueOrDefault<String >("name"         );
			obj.required         = json.GetValueOrDefault<bool?  >("required"     );
			obj.default_value    = json.GetValueOrDefault<String >("default_value");
			obj.is_public        = json.GetValueOrDefault<bool?  >("public"       );
			obj.display_order    = json.GetValueOrDefault<int?   >("display_order");
			obj.help_text        = json.GetValueOrDefault<String >("help_text"    );
			JsonValue jsonOptions = json.GetValue("options");
			if ( jsonOptions != null )
			{
				obj.options = new MergeField.MergeOptions();
				obj.options.default_country = jsonOptions.GetValueOrDefault<int?  >("default_country");
				obj.options.phone_format    = jsonOptions.GetValueOrDefault<String>("phone_format"   );
				obj.options.date_format     = jsonOptions.GetValueOrDefault<String>("date_format"    );
				obj.options.size            = jsonOptions.GetValueOrDefault<int?  >("size"           );
				obj.options.choices         = mapper.Deserialize<List<String>>(jsonOptions.GetValue("choices"));
			}
			return obj;
		}
	}

	class MergeFieldListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<MergeField> items = new List<MergeField>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("merge_fields");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					MergeField item = mapper.Deserialize<MergeField>(itemValue);
					items.Add(item);
				}
			}
			return items;
		}
	}

	// 02/16/2017 Paul.  MergeFieldPagination
	class MergeFieldPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			MergeFieldPagination pag = new MergeFieldPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				pag.total  = json.GetValueOrDefault<int>("total_items");
				pag.items  = mapper.Deserialize<IList<MergeField>>(json);
			}
			return pag;
		}
	}
}
