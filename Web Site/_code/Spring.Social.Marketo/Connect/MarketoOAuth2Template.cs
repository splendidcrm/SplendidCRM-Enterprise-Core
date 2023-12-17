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
using System.Threading.Tasks;
using System.Collections.Specialized;

using Spring.Rest.Client;
using Spring.Social.OAuth2;
using Spring.Json;
using Spring.Http;
using Spring.Http.Converters.Json;

namespace Spring.Social.Marketo.Connect
{
	public class MarketoOAuth2Template : OAuth2Template
	{
		private string _identityUrl;

		// http://developers.marketo.com/documentation/rest/authentication/
		public MarketoOAuth2Template(string clientId, string clientSecret, string endpointUrl, string identityUrl)
			: base(clientId, clientSecret, String.Empty, "oauth/token", true)  // 05/15/2015 Paul.  UseParametersForClientAuthentication so that client_id gets sent. 
		{
			this._identityUrl = identityUrl;
			if ( !this._identityUrl.EndsWith("/") ) this._identityUrl += "/";
			this.RestTemplate.BaseAddress = new Uri(this._identityUrl);
		}

		protected string BuildUrl(string path, NameValueCollection parameters)
		{
			System.Text.StringBuilder qsBuilder = new System.Text.StringBuilder();
			bool isFirst = true;
			foreach ( string key in parameters )
			{
				if ( isFirst )
				{
					qsBuilder.Append('?');
					isFirst = false;
				}
				else
				{
					qsBuilder.Append('&');
				}
				qsBuilder.Append(HttpUtils.UrlEncode(key));
				qsBuilder.Append('=');
				qsBuilder.Append(HttpUtils.UrlEncode(parameters[key]));
			}
			return path + qsBuilder.ToString();
		}

		protected override Task<AccessGrant> PostForAccessGrantAsync(string accessTokenUrl, NameValueCollection request)
		{
			JsonMapper jsonMapper = new JsonMapper();
			jsonMapper.RegisterDeserializer(typeof(AccessToken), new Spring.Social.Marketo.Api.Impl.Json.AccessTokenDeserializer());
			this.RestTemplate.MessageConverters.Add(new SpringJsonHttpMessageConverter(jsonMapper));
			// 05/15/2015 Paul.  Marketo expects a GET operation. 
			return this.RestTemplate.GetForObjectAsync<AccessToken>(this.BuildUrl(accessTokenUrl, request))
				.ContinueWith<AccessGrant>(task =>
				{
					// Exeption should bubble up. 
					//if ( task.Status == TaskStatus.RanToCompletion && task.Result != null )
					AccessGrant grant = new AccessGrant(task.Result.access_token, task.Result.scope, String.Empty, task.Result.expires_in);
					return grant;
				});
		}
	}
}
