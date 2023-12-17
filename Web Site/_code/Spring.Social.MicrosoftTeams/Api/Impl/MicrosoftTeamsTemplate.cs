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
using System.Collections.Generic;

using Spring.Json;
using Spring.Rest.Client;
using Spring.Social.OAuth2;
using Spring.Http.Converters;
using Spring.Http.Converters.Json;

using Spring.Social.MicrosoftTeams.Api.Impl.Json;

namespace Spring.Social.MicrosoftTeams.Api.Impl
{
	public class MicrosoftTeamsTemplate : AbstractOAuth2ApiBinding, IMicrosoftTeams
	{
		ITeamOperations         teamOperations   ;
		IChannelOperations      channelOperations;
		IChatOperations         chatOperations   ;

		public MicrosoftTeamsTemplate(string accessToken)
			: base(accessToken)
		{
			this.InitSubApis();
		}

		#region IMicrosoftTeams Members

		public ITeamOperations TeamOperations
		{
			get { return this.teamOperations; }
		}

		public IChannelOperations ChannelOperations
		{
			get { return this.channelOperations; }
		}

		public IChatOperations ChatOperations
		{
			get { return this.chatOperations; }
		}

		public IRestOperations RestOperations
		{
			get { return this.RestTemplate; }
		}
		#endregion

		protected override void ConfigureRestTemplate(RestTemplate restTemplate)
		{
			restTemplate.BaseAddress = new Uri("https://graph.microsoft.com");
			restTemplate.ErrorHandler = new MicrosoftTeamsErrorHandler();
		}

		protected override OAuth2Version GetOAuth2Version()
		{
			return OAuth2Version.Bearer;
		}

		protected override IList<IHttpMessageConverter> GetMessageConverters()
		{
			IList<IHttpMessageConverter> converters = base.GetMessageConverters();
			converters.Add(new ByteArrayHttpMessageConverter());
			converters.Add(this.GetJsonMessageConverter());
			return converters;
		}

		protected virtual SpringJsonHttpMessageConverter GetJsonMessageConverter()
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(AccessToken           ), new AccessTokenDeserializer            ());

			// Teams
			jsonMapper.RegisterDeserializer(typeof(Team                  ), new TeamDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(IList<Team>           ), new TeamListDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(TeamPagination        ), new TeamPaginationDeserializer         ());
			//jsonMapper.RegisterSerializer  (typeof(Team                  ), new TeamSerializer                     ());

			// Channels
			jsonMapper.RegisterDeserializer(typeof(Channel               ), new ChannelDeserializer                ());
			jsonMapper.RegisterDeserializer(typeof(IList<Channel>        ), new ChannelListDeserializer            ());
			jsonMapper.RegisterDeserializer(typeof(ChannelPagination     ), new ChannelPaginationDeserializer      ());
			//jsonMapper.RegisterSerializer  (typeof(Channel               ), new ChannelSerializer                  ());

			// Chats
			jsonMapper.RegisterDeserializer(typeof(Chat                  ), new ChatDeserializer                   ());
			jsonMapper.RegisterDeserializer(typeof(IList<Chat>           ), new ChatListDeserializer               ());
			jsonMapper.RegisterDeserializer(typeof(ChatPagination        ), new ChatPaginationDeserializer         ());
			//jsonMapper.RegisterSerializer  (typeof(Chat                  ), new ChatSerializer                     ());

			return new SpringJsonHttpMessageConverter(jsonMapper);
		}

		private void InitSubApis()
		{
			this.teamOperations         = new TeamTemplate        (this.RestTemplate);
			this.channelOperations      = new ChannelTemplate     (this.RestTemplate);
			this.chatOperations         = new ChatTemplate        (this.RestTemplate);
		}
	}
}
