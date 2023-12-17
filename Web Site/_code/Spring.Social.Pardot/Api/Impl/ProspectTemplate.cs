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
	class ProspectTemplate : IProspectOperations
	{
		protected RestTemplate  restTemplate;
		protected int           maxResults  ;
		protected string        ApiUserKey  ;
		protected string        ApiKey      ;

		public ProspectTemplate(RestTemplate restTemplate, string sApiUserKey, string sApiKey)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 200         ;
			this.ApiUserKey   = sApiUserKey ;
			this.ApiKey       = sApiKey     ;
		}

		// https://pi.pardot.com/api/prospect/version/4/do/query
		private string BaseURL()
		{
			return "/api/prospect/version/4/do/";
		}

		public virtual bool Validate()
		{
			string sURL = BaseURL();
			sURL += "query?format=json&limit=1";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			this.restTemplate.PostForObject<ProspectPagination>(sURL, null);
			return true;
		}

		public virtual IList<Prospect> GetModified(DateTime startModifiedDate)
		{
			string sURL = BaseURL();
			sURL += "query?format=json&limit=" + maxResults.ToString();
			sURL += "&fields=id";
			sURL += "&updated_after=" + startModifiedDate.ToString("yyyy-MM-ddTHH:mm:ss");
			sURL += "&sort_by=updated_at&sort_order=ascending";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			ProspectPagination pag = this.restTemplate.PostForObject<ProspectPagination>(sURL, null);
			List<Prospect> all = new List<Prospect>(pag.items);
			while ( all.Count < pag.total )
			{
				string sPagedURL = sURL + "&offset=" + all.Count.ToString();
				pag = this.restTemplate.PostForObject<ProspectPagination>(sPagedURL, null);
				foreach ( Prospect prospect in pag.items )
				{
					all.Add(prospect);
				}
			}
			return all;
		}

		public virtual IList<Prospect> GetDeleted(DateTime startModifiedDate)
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
			ProspectPagination pag = this.restTemplate.PostForObject<ProspectPagination>(sURL, null);
			List<Prospect> all = new List<Prospect>(pag.items);
			while ( all.Count < pag.total )
			{
				string sPagedURL = sURL + "&offset=" + all.Count.ToString();
				pag = this.restTemplate.PostForObject<ProspectPagination>(sPagedURL, null);
				foreach ( Prospect prospect in pag.items )
				{
					all.Add(prospect);
				}
			}
			return all;
		}

		public virtual IList<Prospect> GetAll(string sort_by, string sort_order)
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
			ProspectPagination pag = this.restTemplate.PostForObject<ProspectPagination>(sURL, null);
			List<Prospect> all = new List<Prospect>(pag.items);
			while ( all.Count < pag.total )
			{
				string sPagedURL = sURL + "&offset=" + all.Count.ToString();
				pag = this.restTemplate.PostForObject<ProspectPagination>(sPagedURL, null);
				foreach ( Prospect prospect in pag.items )
				{
					all.Add(prospect);
				}
			}
			return all;
		}

		public IList<Prospect> GetPage(string sort_by, string sort_order, int nPage, int nPageSize)
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
			ProspectPagination pag = this.restTemplate.PostForObject<ProspectPagination>(sURL, null);
			List<Prospect> all = new List<Prospect>(pag.items);
			while ( all.Count < pag.total && all.Count < nDesiredTotal )
			{
				string sPagedURL = sURL + "&offset=" + all.Count.ToString();
				pag = this.restTemplate.PostForObject<ProspectPagination>(sPagedURL, null);
				foreach ( Prospect prospect in pag.items )
				{
					all.Add(prospect);
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
			ProspectPagination pag = this.restTemplate.PostForObject<ProspectPagination>(sURL, null);
			return pag.total;
		}

		public Prospect GetByEmail(string email)
		{
			string sURL = BaseURL() + "read/email/" + Spring.Http.HttpUtils.UrlEncode(email);
			sURL += "?format=json";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			return this.restTemplate.PostForObject<Prospect>(sURL, null);
		}

		public Prospect GetById(int id)
		{
			string sURL = BaseURL() + "read/id/" + id.ToString();
			sURL += "?format=json";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			return this.restTemplate.PostForObject<Prospect>(sURL, null);
		}

		public Prospect Insert(Prospect obj)
		{
			string sURL = BaseURL() + "create/email/" + Spring.Http.HttpUtils.UrlEncode(obj.email);
			sURL += "?format=json";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			Prospect prospect = this.restTemplate.PostForObject<Prospect>(sURL, obj);
			return prospect;
		}

		public void Update(Prospect obj)
		{
			string sURL = BaseURL() + "update/id/" + obj.id;
			sURL += "?format=json";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			Prospect prospect = this.restTemplate.PostForObject<Prospect>(sURL, obj);
			System.Diagnostics.Debug.WriteLine(prospect.RawContent);
		}

		public void Delete(int id)
		{
			string sURL = BaseURL() + "delete/id/" + id.ToString();
			sURL += "?format=json";
			sURL += "&user_key=" + this.ApiUserKey;
			sURL += "&api_key="  + this.ApiKey    ;
			// 07/15/2017 Paul.  Get is returning XML at top of json. 
			this.restTemplate.PostForObject<Prospect>(sURL, null);
		}
	}
}
