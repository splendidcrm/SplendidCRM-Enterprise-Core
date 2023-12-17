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

namespace Spring.Social.PhoneBurner.Api.Impl.Json
{
	class CategoryDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Category obj = new Category();

			try
			{
				obj.name          = json.GetValueOrDefault<String>("name"         );
				obj.contact_count = json.GetValueOrDefault<String>("contact_count");
				obj.campaign_text = json.GetValueOrDefault<String>("campaign_text");
				obj.layout        = json.GetValueOrDefault<String>("layout"       );
				obj.layout_id     = json.GetValueOrDefault<String>("layout_id"    );
				obj.cm_view_id    = json.GetValueOrDefault<String>("cm_view_id"   );
				obj.view_name     = json.GetValueOrDefault<String>("view_name"    );
				obj.description   = json.GetValueOrDefault<String>("description"  );
				JsonValue category_id = json.GetValue("category_id");
				if ( category_id != null )
				{
					if ( category_id.IsArray )
					{
						foreach ( JsonValue itemValue in category_id.GetValues() )
						{
							obj.category_id = itemValue.GetValueOrDefault<String>("category_id");
						}
					}
					else
					{
						obj.category_id = category_id.GetValue<String>();
					}
				}
			}
			catch(Exception ex)
			{
				System.Diagnostics.Debug.WriteLine(ex.Message);
				System.Diagnostics.Debug.WriteLine(ex.StackTrace);
				throw;
			}
			return obj;
		}
	}
}
