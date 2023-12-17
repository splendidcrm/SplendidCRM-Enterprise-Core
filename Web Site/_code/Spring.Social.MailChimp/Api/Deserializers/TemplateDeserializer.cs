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
	class TemplateDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			if ( json.ContainsName("templates") )
			{
				json = json.GetValue("templates");
			}
			Template obj = new Template();
			obj.RawContent = json.ToString();
			
			// 04/08/2016 Paul.  When less data than paginated request, then final entries have ID of 0. 
			string sID = json.GetValueOrDefault<string>("id");
			if ( sID == String.Empty || sID == "0" )
				return null;
			// http://developer.mailchimp.com/documentation/mailchimp/reference/templates/#
			obj.id               = json.GetValueOrDefault<String   >("id"           );
			obj.date_created     = json.GetValueOrDefault<DateTime?>("date_created" );
			// 04/16/2016 Paul.  MailChimp does not have a modified date field, so just use created date. 
			obj.lastmodifieddate = json.GetValueOrDefault<DateTime?>("date_created" );
			obj.created_by       = json.GetValueOrDefault<String   >("created_by"   );
			obj.name             = json.GetValueOrDefault<String   >("name"         );
			obj.type             = json.GetValueOrDefault<String   >("type"         );
			obj.folder_id        = json.GetValueOrDefault<String   >("folder_id"    );
			obj.drag_and_drop    = json.GetValueOrDefault<bool?    >("drag_and_drop");
			obj.responsive       = json.GetValueOrDefault<bool?    >("responsive"   );
			obj.category         = json.GetValueOrDefault<String   >("category"     );
			obj.active           = json.GetValueOrDefault<bool?    >("active"       );
			obj.html             = json.GetValueOrDefault<String   >("html"         );
			// 04/08/2016 Paul.  Convert inactive to deleted. 
			obj.isDeleted = obj.active.HasValue && !obj.active.Value;
			return obj;
		}
	}

	class TemplateListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Template> items = new List<Template>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("templates");
			if ( jsonResponse != null && jsonResponse.IsArray )
			{
				foreach ( JsonValue itemValue in jsonResponse.GetValues() )
				{
					Template item = mapper.Deserialize<Template>(itemValue);
					// 04/08/2016 Paul.  When less data than paginated request, then final entries have ID of 0. 
					if ( item != null && !String.IsNullOrEmpty(item.id) )
						items.Add(item);
				}
			}
			return items;
		}
	}

	class TemplatePaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			TemplatePagination pag = new TemplatePagination();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				pag.total  = json.GetValueOrDefault<int>("total_items");
				pag.items  = mapper.Deserialize<IList<Template>>(json);
			}
			return pag;
		}
	}
}
