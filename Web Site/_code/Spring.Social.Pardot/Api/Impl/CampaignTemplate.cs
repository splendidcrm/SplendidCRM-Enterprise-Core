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

namespace Spring.Social.Pardot.Api.Impl
{
	class CampaignTemplate : ICampaignOperations
	{
		protected RestTemplate  restTemplate;
		protected int           maxResults  ;
		protected string        ApiUserKey  ;
		protected string        ApiKey      ;

		public CampaignTemplate(RestTemplate restTemplate, string sApiUserKey, string sApiKey)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 200         ;
			this.ApiUserKey   = sApiUserKey ;
			this.ApiKey       = sApiKey     ;
		}

		// https://pi.pardot.com/api/campaign/version/4/do/query
		private string BaseURL()
		{
			return "/api/campaign/version/4/do/";
		}

		public virtual bool Validate()
		{
			string sURL = BaseURL();
			sURL += "query?format=json&limit=1";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			this.restTemplate.PostForObject<CampaignPagination>(sURL, null);
			return true;
		}

		public virtual IList<Campaign> GetModified(DateTime startModifiedDate)
		{
			string sURL = BaseURL();
			sURL += "query?format=json&limit=" + maxResults.ToString();
			sURL += "&fields=id";
			sURL += "&updated_after=" + startModifiedDate.ToString("yyyy-MM-ddTHH:mm:ss");
			sURL += "&sort_by=updated_at&sort_order=ascending";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			CampaignPagination pag = this.restTemplate.PostForObject<CampaignPagination>(sURL, null);
			List<Campaign> all = new List<Campaign>(pag.items);
			while ( all.Count < pag.total )
			{
				string sPagedURL = sURL + "&offset=" + all.Count.ToString();
				pag = this.restTemplate.PostForObject<CampaignPagination>(sPagedURL, null);
				foreach ( Campaign account in pag.items )
				{
					all.Add(account);
				}
			}
			return all;
		}

		public virtual IList<Campaign> GetDeleted(DateTime startModifiedDate)
		{
			string sURL = BaseURL();
			sURL += "query?format=json&limit=" + maxResults.ToString();
			sURL += "&deleted=true";
			sURL += "&fields=id";
			sURL += "&updated_after=" + startModifiedDate.ToString("yyyy-MM-ddTHH:mm:ss");
			sURL += "&sort_by=updated_at&sort_order=ascending";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			CampaignPagination pag = this.restTemplate.PostForObject<CampaignPagination>(sURL, null);
			List<Campaign> all = new List<Campaign>(pag.items);
			while ( all.Count < pag.total )
			{
				string sPagedURL = sURL + "&offset=" + all.Count.ToString();
				pag = this.restTemplate.PostForObject<CampaignPagination>(sPagedURL, null);
				foreach ( Campaign account in pag.items )
				{
					all.Add(account);
				}
			}
			return all;
		}

		public virtual IList<Campaign> GetAll(string sort_by, string sort_order)
		{
			if ( String.IsNullOrEmpty(sort_by) )
				sort_by = "id";
			if ( String.IsNullOrEmpty(sort_order) )
				sort_order = "asc";
			if ( sort_order == "asc" )
				sort_order ="ascending";
			else if ( sort_order == "desc" )
				sort_order ="descending";
			string sURL = BaseURL();
			sURL += "query?format=json&limit=" + maxResults.ToString();
			sURL += "&output=full";
			sURL += "&sort_by=" + sort_by + "&sort_order=" + sort_order;
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			CampaignPagination pag = this.restTemplate.PostForObject<CampaignPagination>(sURL, null);
			List<Campaign> all = new List<Campaign>(pag.items);
			while ( all.Count < pag.total )
			{
				string sPagedURL = sURL + "&offset=" + all.Count.ToString();
				pag = this.restTemplate.PostForObject<CampaignPagination>(sPagedURL, null);
				foreach ( Campaign account in pag.items )
				{
					all.Add(account);
				}
			}
			return all;
		}

		public IList<Campaign> GetPage(string sort_by, string sort_order, int nPage, int nPageSize)
		{
			int nDesiredTotal = nPageSize;
			if ( nPageSize > 200 )
				nPageSize = 200;
			if ( String.IsNullOrEmpty(sort_by) )
				sort_by = "id";
			if ( String.IsNullOrEmpty(sort_order) )
				sort_order = "asc";
			if ( sort_order == "asc" )
				sort_order ="ascending";
			else if ( sort_order == "desc" )
				sort_order ="descending";
			int nOffset = nPage * nPageSize;
			string sURL = BaseURL();
			sURL += "query?format=json&limit=" + nPageSize.ToString();
			sURL += "&offset=" + nOffset;
			sURL += "&output=full";
			sURL += "&sort_by=" + sort_by + "&sort_order=" + sort_order;
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			CampaignPagination pag = this.restTemplate.PostForObject<CampaignPagination>(sURL, null);
			List<Campaign> all = new List<Campaign>(pag.items);
			while ( all.Count < pag.total && all.Count < nDesiredTotal )
			{
				string sPagedURL = sURL + "&offset=" + all.Count.ToString();
				pag = this.restTemplate.PostForObject<CampaignPagination>(sPagedURL, null);
				foreach ( Campaign account in pag.items )
				{
					all.Add(account);
				}
			}
			return all;
		}

		public int GetCount()
		{
			string sURL = BaseURL();
			sURL += "query?format=json&limit=1&fields=id";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			CampaignPagination pag = this.restTemplate.PostForObject<CampaignPagination>(sURL, null);
			return pag.total;
		}

		public Campaign GetById(int id)
		{
			string sURL = BaseURL() + "read/id/" + id.ToString();
			sURL += "?format=json";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			return this.restTemplate.PostForObject<Campaign>(sURL, null);
		}

		public Campaign Insert(Campaign obj)
		{
			string sURL = BaseURL() + "create/";
			sURL += "?format=json";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			Campaign account = this.restTemplate.PostForObject<Campaign>(sURL, obj);
			return account;
		}

		public void Update(Campaign obj)
		{
			string sURL = BaseURL() + "update/id/" + obj.id;
			sURL += "?format=json";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			Campaign account = this.restTemplate.PostForObject<Campaign>(sURL, obj);
			System.Diagnostics.Debug.WriteLine(account.RawContent);
		}

		public void Delete(int id)
		{
			string sURL = BaseURL() + "delete/id/" + id.ToString();
			sURL += "?format=json";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			this.restTemplate.PostForObject<Campaign>(sURL, null);
		}
	}
}
