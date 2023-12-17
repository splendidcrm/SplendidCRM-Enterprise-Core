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
using System.Collections.Generic;
using System.Collections.Specialized;
using Spring.Http;
using Spring.Rest.Client;

namespace Spring.Social.Etsy.Api.Impl
{
	class QBaseTemplate<T>
	{
		protected RestTemplate restTemplate;
		protected string       shop_id     ;
		protected int          maxResults  ;
		protected string       moduleBase  ;

		public QBaseTemplate(RestTemplate restTemplate, string shop_id, string moduleBase)
		{
			this.restTemplate = restTemplate;
			this.shop_id      = shop_id     ;
			// https://developers.etsy.com/documentation/essentials/urlsyntax#pagination
#if DEBUG
			this.maxResults   = 10          ;
#else
			this.maxResults   = 100         ;
#endif
			this.moduleBase   = moduleBase  ;
		}

		public virtual IList<T> GetModified(DateTime startModifiedDate)
		{
			//this.RestTemplate.BaseAddress  = new Uri(API_URI_BASE, "/v3/application/shop/" + shop_id + "/");
			string sURL = this.moduleBase + "/active";
#if !DEBUG
			if ( this.moduleBase == "listings" )
				sURL = "shops/" + shop_id + "/" + sURL;
#endif
			if ( startModifiedDate != DateTime.MinValue )
			{
				sURL += "?updated_at >= \'" + startModifiedDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss") + "\'";
			}
			string sPagedURL = sURL + (!sURL.Contains("?") ? "?" : "&") + "offset=0" + "&limit=" + this.maxResults.ToString();
			QBasePagination<T> pag = this.restTemplate.GetForObject<QBasePagination<T>>(sPagedURL);
			List<T> all = new List<T>(pag.items);
			while ( all.Count < pag.count )
			{
				sPagedURL = sURL + (!sURL.Contains("?") ? "?" : "&") + "offset=" + all.Count.ToString() + "&limit=" + this.maxResults.ToString();
				pag = this.restTemplate.GetForObject<QBasePagination<T>>(sPagedURL);
				foreach ( T item in pag.items )
				{
					all.Add(item);
				}
			}
			return all;
		}

		public virtual IList<T> GetAll(string filter)
		{
			string sURL = this.moduleBase + "/active";
			if ( this.moduleBase == "listings" )
				sURL = "shops/" + shop_id + "/" + sURL;
			string sPagedURL = sURL + (!sURL.Contains("?") ? "?" : "&") + "offset=0" + "&limit=" + this.maxResults.ToString();
			QBasePagination<T> pag = this.restTemplate.GetForObject<QBasePagination<T>>(sPagedURL);
			List<T> all = new List<T>(pag.items);
			while ( all.Count < pag.count )
			{
				sPagedURL = sURL + (!sURL.Contains("?") ? "?" : "&") + "offset=" + all.Count.ToString() + "&limit=" + this.maxResults.ToString();
				pag = this.restTemplate.GetForObject<QBasePagination<T>>(sPagedURL);
				foreach ( T item in pag.items )
				{
					all.Add(item);
				}
			}
			return all;
		}

		public T GetByName(string name)
		{
			T obj = default(T);
			string sQuery = "select * from " + this.moduleBase + " where Name = \'" + Sql.EscapeSQL(name) + "\'";
			string sURL = "company/" + shop_id + "/query?query=" + HttpUtils.UrlEncode(sQuery);
			IList<T> lst = this.restTemplate.GetForObject<IList<T>>(sURL);
			if ( lst.Count > 0 )
				obj = lst[0];
			return obj;
		}
	}
}
