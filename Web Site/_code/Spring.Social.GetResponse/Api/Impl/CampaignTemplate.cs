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
using System.Collections.Generic;
using System.Collections.Specialized;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;

namespace Spring.Social.GetResponse.Api.Impl
{
	class CampaignTemplate : ICampaignOperations
	{
		protected RestTemplate restTemplate;
		protected string       baseModule  ;
		protected int          perPage     ;

		public CampaignTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.baseModule   = "campaigns" ;
			this.perPage      = 500         ;
		}

		public virtual IList<Campaign> GetModified(DateTime startModifiedDate)
		{
			// http://apidocs.getresponse.com/en/v3/
			string sURL = baseModule;
			IList<Campaign> all = this.restTemplate.GetForObject<IList<Campaign>>(sURL);
			return all;
		}

		public virtual IList<Campaign> GetAll(string search)
		{
			// http://apidocs.getresponse.com/en/v3/resources/campaigns
			string sURL = baseModule;
			if ( !Sql.IsEmptyString(search) )
				sURL += "?query[name]=" + HttpUtils.UrlEncode(search);
			IList<Campaign> all = this.restTemplate.GetForObject<IList<Campaign>>(sURL);
			return all;
		}

		public Campaign GetById(string id)
		{
			string sURL = baseModule + "/" + id;
			return this.restTemplate.GetForObject<Campaign>(sURL);
		}

		public Campaign Insert(Campaign obj)
		{
			string sURL = baseModule;
			return this.restTemplate.PostForObject<Campaign>(sURL, obj);
		}

		public Campaign Update(Campaign obj)
		{
			if ( obj.id == null )
				throw(new Exception("id must not be null during update operation."));
			string sURL = baseModule + "/" + obj.id;
			return this.restTemplate.PostForObject<Campaign>(sURL, obj);
		}

		public void Delete(string id)
		{
			string sURL = baseModule + "/" + id;
			this.restTemplate.Delete(sURL);
		}
	}
}