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
using Spring.Social.OAuth2;

namespace Spring.Social.ConstantContact.Connect
{
	public class ConstantContactOAuth2Template : OAuth2Template
	{
		// 11/11/2019 Paul.  ConstantContact v3 API. 
		// https://v3.developer.constantcontact.com/api_guide/server_flow.html
		public ConstantContactOAuth2Template(string clientId, string clientSecret)
			: base(clientId, clientSecret
				, "https://api.cc.email/v3/idfed"
				, "https://idfed.constantcontact.com/as/token.oauth2"
				, true)  // 04/26/2015 Paul.  UseParametersForClientAuthentication so that client_id gets sent. 
		{
		}
	}
}
