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

namespace Spring.Social.MicrosoftTeams.Api.Impl.Json
{
	class ChatDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			Chat obj = new Chat();
			obj.RawContent = json.ToString();
			//Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.Json.ChatDeserializer.Deserialize " + obj.RawContent);
			
			try
			{
				// Entity
				obj.Id                           = json.GetValueOrDefault<String>   ("id"                        );
				obj.ODataId                      = json.GetValueOrDefault<String>   ("@odata.id"                 );
				obj.CreatedDateTime              = json.GetValueOrDefault<DateTime?>("createdDateTime"           );
				obj.Deleted                      = json.ContainsName("@removed");

				// Chat
				obj.Topic                        = json.GetValueOrDefault<String>   ("topic"                     );
				obj.Description                  = json.GetValueOrDefault<String>   ("description"               );
				obj.TenantId                     = json.GetValueOrDefault<String>   ("tenantId"                  );
				obj.ChatType                     = json.GetValueOrDefault<String>   ("chatType"                  );
				obj.WebUrl                       = json.GetValueOrDefault<String>   ("webUrl"                    );
				obj.LastUpdatedDateTime          = json.GetValueOrDefault<DateTime> ("lastUpdatedDateTime"       );

				JsonValue chatViewpoint  = json.GetValue("chatViewpoint");
				if ( chatViewpoint != null )
				{
					obj.IsHidden                = chatViewpoint.GetValueOrDefault<bool?>    ("isHidden"               );
					obj.LastMessageReadDateTime = chatViewpoint.GetValueOrDefault<DateTime?>("lastMessageReadDateTime");
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

	class ChatListDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			IList<Chat> Chats = new List<Chat>();
			if ( json != null && json.IsArray )
			{
				foreach ( JsonValue itemValue in json.GetValues() )
				{
					Chats.Add( mapper.Deserialize<Chat>(itemValue) );
				}
			}
			return Chats;
		}
	}

	class ChatPaginationDeserializer : IJsonDeserializer
	{
		public object Deserialize(JsonValue json, JsonMapper mapper)
		{
			ChatPagination pag = new ChatPagination();
			//JsonUtils.FaultCheck(json);
			if ( json != null && !json.IsNull )
			{
				//Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.Json.ChatPaginationDeserializer.Deserialize " + json.ToString());
				JsonValue chats  = json.GetValue("value");
				pag.count = json.GetValueOrDefault<int>("@odata.count");
				if ( chats != null && !chats.IsNull )
				{
					pag.chats = mapper.Deserialize<IList<Chat>>(chats);
				}
			}
			return pag;
		}
	}
}
