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
using System.Net;
using Spring.Social.OAuth2;
using Spring.Social.iContact.Api;
using Spring.Social.iContact.Api.Impl;

namespace Spring.Social.iContact.Connect
{
	public class iContactServiceProvider : AbstractOAuth2ServiceProvider<IiContact>
	{
		string sApiAppId               = String.Empty;
		string sApiUsername            = String.Empty;
		string sApiPassword            = String.Empty;
		string siContactAccountId      = String.Empty;
		string siContactClientFolderId = String.Empty;

		public iContactServiceProvider(string sApiAppId, string sApiUsername, string sApiPassword, string siContactAccountId, string siContactClientFolderId)
			: base(new iContactOAuth2Template())
		{
			this.sApiAppId               = sApiAppId              ;
			this.sApiUsername            = sApiUsername           ;
			this.sApiPassword            = sApiPassword           ;
			this.siContactAccountId      = siContactAccountId     ;
			this.siContactClientFolderId = siContactClientFolderId;
		}

		public override IiContact GetApi(String accessToken)
		{
			// 11/11/2019 Paul.  TLS12 is now requird. 
			if ( !ServicePointManager.SecurityProtocol.HasFlag(SecurityProtocolType.Tls12) )
			{
				ServicePointManager.SecurityProtocol = ServicePointManager.SecurityProtocol | SecurityProtocolType.Tls12;
			}
			// 05/02/2015 Paul.  iContact does not use an accessToken.  Instead, it uses header values for App Id, API Username and API Password. 
			return new iContactTemplate(sApiAppId, sApiUsername, sApiPassword, siContactAccountId, siContactClientFolderId);
		}
	}
}
