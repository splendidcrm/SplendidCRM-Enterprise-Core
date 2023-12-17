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

using Spring.Social.OAuth2;
using Spring.Social.Etsy.Api;
using Spring.Social.Etsy.Api.Impl;

namespace Spring.Social.Etsy.Connect
{
	public class EtsyServiceProvider : AbstractOAuth2ServiceProvider<IEtsy>
	{
		private string shop_id;
		private string api_key;

		public EtsyServiceProvider(string shop_id, string clientId, string clientSecret)
			: base(new EtsyOAuth2Template(clientId, clientSecret))
		{
			this.shop_id = shop_id ;
			this.api_key = clientId;
		}

		public override IEtsy GetApi(String accessToken)
		{
			return new EtsyTemplate(this.shop_id, this.api_key, accessToken);
		}
	}
}
