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
using System.Web;
using System.Net;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;

namespace Spring.Social.MicrosoftTeams.Api.Impl
{
	class ChatTemplate : IChatOperations
	{
		protected RestTemplate restTemplate;

		public ChatTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		// https://learn.microsoft.com/en-us/graph/api/user-list-joinedteams?view=graph-rest-1.0&tabs=http
		public IList<Chat> GetAll(string filter)
		{
			Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChatTemplate.GetAll " + Sql.ToString(filter));
			string sURL = "/v1.0/me/chats?$orderBy=lastMessagePreview/createdDateTime desc";
			if ( !Sql.IsEmptyString(filter) )
			{
				// https://learn.microsoft.com/en-us/graph/query-parameters?tabs=http
				sURL += "&$filter=" + filter;
			}
			ChatPagination pag = this.restTemplate.GetForObject<ChatPagination>(sURL);
			List<Chat> all = new List<Chat>(pag.chats);
			return all;
		}
		/*
		public virtual Chat GetById(string id)
		{
			//Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChatTemplate.GetById " + Sql.ToString(id));
			string sURL = "/v1.0/me/mailFolders/" + id;
			return this.restTemplate.GetForObject<Chat>(sURL);
		}
		
		public virtual Chat Insert(string parentFolderId, string displayName)
		{
			Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChatTemplate.Insert " + parentFolderId + "  " + displayName);
			string sURL = "/v1.0/me/mailFolders/" + parentFolderId + "/childFolders";
			Chat obj = new Chat();
			obj.DisplayName = displayName;
			return this.restTemplate.PostForObject<Chat>(sURL, obj);
		}
		
		public virtual Chat Update(Chat obj)
		{
			//Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChatTemplate.Update " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			if ( Sql.IsEmptyString(obj.Id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/v1.0/me/mailFolders/" + obj.Id;
			//this.restTemplate.PostForObject<Chat>(sURL, obj);
			// 12/05/2020 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Chat), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Chat> responseExtractor = new MessageConverterResponseExtractor<Chat>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<Chat>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}
		
		public virtual void Delete(string id)
		{
			//Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChatTemplate.Delete " + Sql.ToString(id));
			string sURL = "/v1.0/me/mailFolders/" + id;
			this.restTemplate.Delete(sURL);
		}
		*/
	}
}
