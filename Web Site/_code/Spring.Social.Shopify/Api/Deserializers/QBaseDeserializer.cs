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
	class QBaseDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			QBase obj = new QBase();
			obj.RawContent = json.ToString();
			
			// 03/17/2022 Paul.  cursor is outside of node. 
			obj.cursor           = json.GetValueOrDefault<string   >("cursor"         );
			if ( json.ContainsName("node") )
			{
				json = json.GetValue("node");
			}
			obj.id               = json.GetValueOrDefault<string   >("id"             );
			obj.createdAt        = json.GetValueOrDefault<DateTime >("createdAt"      );
			obj.updatedAt        = json.GetValueOrDefault<DateTime?>("updatedAt"      );
			return obj;
		}
	}

	class QBaseListDeserializer<T> : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<T> items = new List<T>();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					items.Add( mapper.Deserialize<T>(itemValue) );
				}
			}
			return items;
		}
	}

	class QBasePaginationDeserializer<T> : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			QBasePagination<T> pag = new QBasePagination<T>();
			JsonUtils.FaultCheck(json);
			if ( json != null )
			{
				JsonValue data = json.GetValue("data");
				if ( data != null )
				{
					ICollection<JsonValue> jsonItems = data.GetValues();
					if ( jsonItems != null && jsonItems.Count > 0 )
					{
						IEnumerator<JsonValue> en = jsonItems.GetEnumerator();
						en.MoveNext();
						JsonValue products = en.Current;
						if ( products.ContainsName("edges") )
						{
							JsonValue edges = products.GetValue("edges");
							if ( edges != null && edges.IsArray )
							{
								pag.items = mapper.Deserialize<IList<T>>(edges);
							}
						}
						pag.pageInfo = new PageInfo();
						JsonValue pageInfo = products.GetValue("pageInfo");
						if ( pageInfo != null )
						{
							pag.pageInfo.hasNextPage = pageInfo.GetValueOrDefault<bool>("hasNextPage");
							if ( pag.pageInfo.hasNextPage && pag.items.Count > 0 )
							{
								QBase lastItem = pag.items[pag.items.Count - 1] as QBase;
								pag.pageInfo.last_cursor = lastItem.cursor;
							}
							pag.pageInfo.hasPreviousPage = pageInfo.GetValueOrDefault<bool>("hasPreviousPage");
							if ( pag.pageInfo.hasPreviousPage && pag.items.Count > 0 )
							{
								QBase firstItem = pag.items[0] as QBase;
								pag.pageInfo.first_cursor = firstItem.cursor;
							}
						}
					}
				}
			}
			return pag;
		}
	}
}
