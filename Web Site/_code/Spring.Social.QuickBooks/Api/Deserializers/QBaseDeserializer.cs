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
	class QBaseDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			// 02/17/2015 Paul.  This method is called for each array item and for a single item. 
			JsonValue metaData = json.GetValue("MetaData");
			if ( metaData == null )
			{
				ICollection<JsonValue> jsonItems = json.GetValues();
				IEnumerator<JsonValue> en = jsonItems.GetEnumerator();
				en.MoveNext();
				json = en.Current;
			}
			QBase obj = new QBase();
			obj.Id        = json.GetValueOrDefault<String>("Id"       );
			obj.SyncToken = json.GetValueOrDefault<String>("SyncToken");
			
			metaData = json.GetValue("MetaData");
			if ( metaData != null && metaData.IsObject ) obj.MetaData = mapper.Deserialize<ModificationMetaData>(metaData);
			return obj;
		}
	}

	class QBaseListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<QBase> items = new List<QBase>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				ICollection<JsonValue> jsonItems = jsonResponse.GetValues();
				if ( jsonItems.Count > 0 )
				{
					IEnumerator<JsonValue> en = jsonItems.GetEnumerator();
					en.MoveNext();
					JsonValue jsonItem = en.Current;
					if ( jsonItem != null && jsonItem.IsArray )
					{
						foreach ( JsonValue itemValue in jsonItem.GetValues() )
						{
							items.Add( mapper.Deserialize<QBase>(itemValue) );
						}
					}
				}
			}
			return items;
		}
	}

	class QBasePaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			QBasePagination qbase = new QBasePagination();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("QueryResponse");
			if ( jsonResponse != null && jsonResponse.IsObject )
			{
				qbase.StartPosition = jsonResponse.GetValueOrDefault<int>("startPosition");
				qbase.MaxResults    = jsonResponse.GetValueOrDefault<int>("maxResults"   );
				qbase.TotalCount    = jsonResponse.GetValueOrDefault<int>("totalCount"   );
				qbase.Items         = mapper.Deserialize<IList<QBase>>(json);
			}
			return qbase;
		}
	}
}
