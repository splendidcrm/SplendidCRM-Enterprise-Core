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
	class ChannelTemplate : IChannelOperations
	{
		protected RestTemplate restTemplate;

		public ChannelTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		// https://learn.microsoft.com/en-us/graph/api/user-list-joinedteams?view=graph-rest-1.0&tabs=http
		public IList<Channel> GetAll(Team team, string filter)
		{
			Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChannelTemplate.GetAll " + Sql.ToString(filter));
			string sURL = "/v1.0/teams/" + team.Id.ToString() + "/allChannels";
			if ( !Sql.IsEmptyString(filter) )
			{
				// https://learn.microsoft.com/en-us/graph/query-parameters?tabs=http
				sURL += "?$filter=" + filter;
			}
			ChannelPagination pag = this.restTemplate.GetForObject<ChannelPagination>(sURL);
			List<Channel> all = new List<Channel>(pag.channels);
			foreach ( Channel channel in all )
			{
				channel.Team = team;
			}
			return all;
		}
		/*
		public virtual Channel GetById(string id)
		{
			//Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChannelTemplate.GetById " + Sql.ToString(id));
			string sURL = "/v1.0/me/mailFolders/" + id;
			return this.restTemplate.GetForObject<Channel>(sURL);
		}
		
		public virtual Channel Insert(string parentFolderId, string displayName)
		{
			Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChannelTemplate.Insert " + parentFolderId + "  " + displayName);
			string sURL = "/v1.0/me/mailFolders/" + parentFolderId + "/childFolders";
			Channel obj = new Channel();
			obj.DisplayName = displayName;
			return this.restTemplate.PostForObject<Channel>(sURL, obj);
		}
		
		public virtual Channel Update(Channel obj)
		{
			//Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChannelTemplate.Update " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			if ( Sql.IsEmptyString(obj.Id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/v1.0/me/mailFolders/" + obj.Id;
			//this.restTemplate.PostForObject<Channel>(sURL, obj);
			// 12/05/2020 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Channel), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Channel> responseExtractor = new MessageConverterResponseExtractor<Channel>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<Channel>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}
		
		public virtual void Delete(string id)
		{
			//Debug.WriteLine("Spring.Social.MicrosoftTeams.Api.Impl.ChannelTemplate.Delete " + Sql.ToString(id));
			string sURL = "/v1.0/me/mailFolders/" + id;
			this.restTemplate.Delete(sURL);
		}
		*/
	}
}
