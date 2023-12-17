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
using Google.Apis.Util;

namespace Google.Apis.Contacts.v3
{
	public abstract class ContactsBaseServiceRequest<TResponse> : ClientServiceRequestWithETag<TResponse>
	{
		protected ContactsBaseServiceRequest(Google.Apis.Services.IClientService service) : base( service )
		{
		}

		#region Query Parameters
		[RequestParameterAttribute("alt"        , RequestParameterType.Query)] public string Alt        { get; set; }
		[RequestParameterAttribute("v"          , RequestParameterType.Query)] public string Version    { get; set; }
		[RequestParameterAttribute("key"        , RequestParameterType.Query)] public string Key        { get; set; }
		[RequestParameterAttribute("oauth_token", RequestParameterType.Query)] public string OauthToken { get; set; }
		#endregion

		protected override void InitParameters()
		{
			base.InitParameters();

			// 09/10/2015 Paul.  alt is required and default is xml, so we must force the requirement. 
			RequestParameters.Add("alt"        , new Google.Apis.Discovery.Parameter { Name = "alt"        , IsRequired = true , ParameterType = "query", DefaultValue = "json", Pattern = null } );
			// 09/17/2015 Paul.  Must include v=3.0 query parameter to get StructuredName. 
			RequestParameters.Add("v"          , new Google.Apis.Discovery.Parameter { Name = "v"          , IsRequired = true , ParameterType = "query", DefaultValue = "3.0" , Pattern = null } );
			RequestParameters.Add("key"        , new Google.Apis.Discovery.Parameter { Name = "key"        , IsRequired = false, ParameterType = "query", DefaultValue = null  , Pattern = null } );
			RequestParameters.Add("oauth_token", new Google.Apis.Discovery.Parameter { Name = "oauth_token", IsRequired = false, ParameterType = "query", DefaultValue = null  , Pattern = null } );

			// 09/11/2015 Paul.  Only Json is supported by this library. 
			this.Alt = "json";
			this.Version = "3.0";
		}
	}
}

