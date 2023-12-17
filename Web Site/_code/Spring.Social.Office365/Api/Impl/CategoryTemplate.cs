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
using System.Web;
using System.Net;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;

namespace Spring.Social.Office365.Api.Impl
{
	class CategoryTemplate : ICategoryOperations
	{
		protected RestTemplate restTemplate;

		public CategoryTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		public virtual IList<OutlookCategory> GetAll(string search)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.CategoryTemplate.GetAll " + Sql.ToString(search));
			int nPageSize = 100;
			string sSort = "displayName asc";
			string sURL = "/v1.0/me/outlook/masterCategories?$count=true&$orderby=" + sSort + "&$top=" + nPageSize.ToString();
			if ( !Sql.IsEmptyString(search) )
			{
				// https://docs.microsoft.com/en-us/graph/query-parameters
				sURL += "&$filter=" + search;
			}
			OutlookCategoryPagination pag = this.restTemplate.GetForObject<OutlookCategoryPagination>(sURL);
			List<OutlookCategory> all = new List<OutlookCategory>(pag.categories);
			int nPageOffset = 0;
			while ( all.Count < pag.count )
			{
				nPageOffset += nPageSize;
				string sPagedURL = sURL + "&skip=" + nPageOffset;
				pag = this.restTemplate.GetForObject<OutlookCategoryPagination>(sPagedURL);
				foreach ( OutlookCategory category in pag.categories )
				{
					all.Add(category);
				}
			}
			return all;
		}

		public virtual OutlookCategory GetById(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.CategoryTemplate.GetById " + Sql.ToString(id));
			string sURL = "/v1.0/me/outlook/masterCategories/" + id;
			return this.restTemplate.GetForObject<OutlookCategory>(sURL);
		}
		
		public virtual OutlookCategory Insert(OutlookCategory obj)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.CategoryTemplate.Insert " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			string sURL = "/v1.0/me/outlook/masterCategories";
			return this.restTemplate.PostForObject<OutlookCategory>(sURL, obj);
		}
		
		public virtual OutlookCategory Update(OutlookCategory obj)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.CategoryTemplate.Update " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			if ( Sql.IsEmptyString(obj.Id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/v1.0/me/outlook/masterCategories/" + obj.Id;
			//this.restTemplate.PostForObject<OutlookCategory>(sURL, obj);
			// 12/05/2020 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(OutlookCategory), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<OutlookCategory> responseExtractor = new MessageConverterResponseExtractor<OutlookCategory>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<OutlookCategory>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}
		
		public virtual void Delete(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.CategoryTemplate.Delete " + Sql.ToString(id));
			string sURL = "/v1.0/me/outlook/masterCategories/" + id;
			this.restTemplate.Delete(sURL);
		}
	}
}