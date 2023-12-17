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

namespace Spring.Social.Pardot.Api.Impl.Json
{
	class CampaignDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			JsonUtils.FaultCheck(json);
			Campaign obj = new Campaign();
			obj.RawContent = json.ToString();
			System.Diagnostics.Debug.WriteLine(obj.RawContent);
			if ( json.ContainsName("campaign") )
			{
				json = json.GetValue("campaign");
			}
			
			obj.id         = json.GetValueOrDefault<int     >("id"        );
			obj.created_at = json.GetValueOrDefault<DateTime>("created_at");
			obj.updated_at = json.GetValueOrDefault<DateTime>("updated_at");
			if ( json.ContainsName("name") ) obj.name = json.GetValueOrDefault<String  >("name");
			if ( json.ContainsName("cost") ) obj.cost = json.GetValueOrDefault<int     >("cost");
			return obj;
		}
	}

	class CampaignListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Campaign> items = new List<Campaign>();
			JsonUtils.FaultCheck(json);
			JsonValue jsonResponse = json.GetValue("campaign");
			if ( jsonResponse != null )
			{
				if ( jsonResponse.IsArray )
				{
					foreach ( JsonValue itemValue in jsonResponse.GetValues() )
					{
						items.Add( mapper.Deserialize<Campaign>(itemValue) );
					}
				}
				else
				{
					items.Add( mapper.Deserialize<Campaign>(jsonResponse) );
				}
			}
			return items;
		}
	}

	class CampaignPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			CampaignPagination pag = new CampaignPagination();
			JsonUtils.FaultCheck(json);
			if ( json != null && json.ContainsName("result") )
			{
				json = json.GetValue("result");
				pag.total = json.GetValueOrDefault<int>("total_results");
				pag.items = mapper.Deserialize<IList<Campaign>>(json);
			}
			return pag;
		}
	}
}
