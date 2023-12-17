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

namespace Spring.Social.Shopify.Api.Impl
{
	class QBaseTemplate<T>
	{
		protected RestTemplate restTemplate;
		protected string       companyId   ;
		protected string       tableName   ;
		protected int          maxResults  ;
		protected string       moduleBase  ;

		public QBaseTemplate(RestTemplate restTemplate, string tableName)
		{
			this.restTemplate = restTemplate;
			this.companyId    = String.Empty;
			this.tableName    = tableName   ;
			this.maxResults   = 250         ;
			this.moduleBase   = "/admin/api/2022-01/graphql.json";
		}

		protected virtual string BuildGraph(int max, string cursor, string query)
		{
			// 03/09/2022 Paul.  Having a rate limit issue, so remove description and tags. 
			// https://shopify.dev/concepts/about-apis/rate-limits
			string sGraph = @"
			{
				products (first: " + this.maxResults.ToString() + (!Sql.IsEmptyString(cursor) ? ", after: " + cursor : String.Empty) + (!Sql.IsEmptyString(query) ? ", query: \"" + query + "\"": String.Empty) + @")
				{
					edges
					{
						node
						{
							id
							createdAt
							updatedAt
							publishedAt
							title
							handle
							descriptionHtml
							productType
							vendor
							tags
							totalInventory
							priceRangeV2
							{
								maxVariantPrice
								{
									amount
									currencyCode
								}
								minVariantPrice
								{
									amount
									currencyCode
								}
							}
						}
						cursor
					}
					pageInfo
					{
						hasNextPage
					}
				}
			}";
			return sGraph;
		}

		protected virtual string BuildGraph(string id)
		{
			// 03/09/2022 Paul.  Having a rate limit issue, so remove description and tags. 
			// https://shopify.dev/concepts/about-apis/rate-limits
			string sGraph = @"
			{
				products (id: " + id + @")
				{
					id
					createdAt
					updatedAt
					publishedAt
					title
					handle
					descriptionHtml
					productType
					vendor
					tags
					totalInventory
					priceRangeV2
					{
						maxVariantPrice
						{
							amount
							currencyCode
						}
						minVariantPrice
						{
							amount
							currencyCode
						}
					}
				}
			}";
			return sGraph;
		}

		public virtual IList<T> GetModified(DateTime startModifiedDate)
		{
			string sQuery = String.Empty;
			if ( startModifiedDate != DateTime.MinValue )
			{
				// 03/10/2022 Paul.  Must use updated_at and not updatedAt. 
				// https://shopify.dev/api/usage/search-syntax
				sQuery = "updated_at >= \'" + startModifiedDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss") + "\'";
			}
			string sGraph = BuildGraph(this.maxResults, String.Empty, sQuery);
			QBasePagination<T> pag = this.restTemplate.PostForObject<QBasePagination<T>>(this.moduleBase, new ShopifyGraphQl(sGraph));
			List<T> all = new List<T>(pag.items);
			while ( pag.pageInfo != null && !Sql.IsEmptyString(pag.pageInfo.last_cursor) )
			{
				sGraph = BuildGraph(this.maxResults, pag.pageInfo.last_cursor, sQuery);
				pag = this.restTemplate.PostForObject<QBasePagination<T>>(this.moduleBase, sGraph);
				foreach ( T product in pag.items )
				{
					all.Add(product);
				}
			}
			return all;
		}

		public virtual IList<T> GetAll(string filter)
		{
			string sGraph = BuildGraph(this.maxResults, String.Empty, String.Empty);
			QBasePagination<T> pag = this.restTemplate.PostForObject<QBasePagination<T>>(this.moduleBase, new ShopifyGraphQl(sGraph));
			List<T> all = new List<T>(pag.items);
			while ( pag.pageInfo != null && !Sql.IsEmptyString(pag.pageInfo.last_cursor) )
			{
				sGraph = BuildGraph(this.maxResults, pag.pageInfo.last_cursor, String.Empty);
				pag = this.restTemplate.PostForObject<QBasePagination<T>>(this.moduleBase, sGraph);
				foreach ( T product in pag.items )
				{
					all.Add(product);
				}
			}
			return all;
		}

		public T GetByName(string name)
		{
			T obj = default(T);
			string sQuery = "select * from " + this.tableName + " where Name = \'" + Sql.EscapeSQL(name) + "\'";
			string sURL = "company/" + companyId + "/query?query=" + HttpUtils.UrlEncode(sQuery);
			IList<T> lst = this.restTemplate.GetForObject<IList<T>>(sURL);
			if ( lst.Count > 0 )
				obj = lst[0];
			return obj;
		}
	}
}
