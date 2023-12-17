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
using Spring.Social.Watson.Api;
using Spring.Social.Watson.Api.Impl;

namespace Spring.Social.Watson.Connect
{
	public class WatsonServiceProvider : AbstractOAuth2ServiceProvider<IWatson>
	{
		// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
		// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
		protected string region    ;
		protected string pod_number;

		// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
		// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
		public WatsonServiceProvider(string clientId, string clientSecret, string region, string podNumber)
			: base(new WatsonOAuth2Template(clientId, clientSecret, region, podNumber))
		{
			this.pod_number = podNumber;
		}

		public override IWatson GetApi(String accessToken)
		{
			// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
			// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
			return new WatsonTemplate(accessToken, this.region, this.pod_number);
		}
	}
}
