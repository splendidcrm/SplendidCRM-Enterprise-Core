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

namespace Spring.Social.QuickBooks.Api.Impl
{
	class QBaseTemplate<T>
	{
		protected RestTemplate restTemplate;
		protected string       companyId   ;
		protected string       tableName   ;
		protected int          maxResults  ;

		public QBaseTemplate(RestTemplate restTemplate, string companyId, string tableName)
		{
			this.restTemplate = restTemplate;
			this.companyId    = companyId   ;
			this.tableName    = tableName   ;
			this.maxResults   = 1000        ;
		}

		public virtual IList<QBase> GetModified(DateTime startModifiedDate)
		{
			// https://msdn.microsoft.com/en-us/library/zdtaw1bw(v=vs.110).aspx
			// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/querying_data
			string sQuery = "select Id, SyncToken, Metadata.CreateTime, Metadata.LastUpdatedTime from " + this.tableName;
			if ( startModifiedDate != DateTime.MinValue )
				sQuery += " where Metadata.LastUpdatedTime > '" + startModifiedDate.ToString("yyyy-MM-ddTHH:mm:sszzz") + "'";
			// 02/17/2015 Paul.  QuickBooks uses ORDERBY, not ORDER BY. Need to add pagination. 
			// https://developer.intuit.com/docs/0100_accounting/0300_developer_guides/querying_data
			sQuery += " orderby Metadata.LastUpdatedTime";
			
			string sQueryPaginated = sQuery + " startPosition 1 maxResults " + maxResults.ToString();
			string sURL = "company/" + companyId + "/query?query=" + HttpUtils.UrlEncode(sQueryPaginated);
			QBasePagination qbase = this.restTemplate.GetForObject<QBasePagination>(sURL);
			
			List<QBase> all = new List<QBase>(qbase.Items);
			// 03/04/2015 Paul.  Use Count and not TotalCount as TotalCount is only valid when using count(*) in the query. 
			if ( all.Count == maxResults )
			{
				// 02/17/2015 Paul.  If we receive the maximum requested records, then expect pagination. 
				sQuery = "select count(*) from " + this.tableName;
				if ( startModifiedDate != DateTime.MinValue )
					sQuery += " where Metadata.LastUpdatedTime > '" + startModifiedDate.ToString("yyyy-MM-ddTHH:mm:sszzz") + "'";
				sURL = "company/" + companyId + "/query?query=" + HttpUtils.UrlEncode(sQuery);
				qbase = this.restTemplate.GetForObject<QBasePagination>(sURL);
				
				sQuery = "select Id, SyncToken, Metadata.CreateTime, Metadata.LastUpdatedTime from " + this.tableName;
				if ( startModifiedDate != DateTime.MinValue )
					sQuery += " where Metadata.LastUpdatedTime > '" + startModifiedDate.ToString("yyyy-MM-ddTHH:mm:sszzz") + "'";
				int nTotalCount = qbase.TotalCount;
				int nTotalPages = nTotalCount / maxResults + (nTotalCount % maxResults > 0 ? 1 : 0);
				// 02/17/2015 Paul.  Start with 1 as we already fetched the first page. 
				for ( int i = 1; i < nTotalPages; i++ )
				{
					sQueryPaginated = sQuery + " startPosition " + (i * maxResults + 1).ToString() + " maxResults " + maxResults.ToString();
					sURL = "company/" + companyId + "/query?query=" + HttpUtils.UrlEncode(sQueryPaginated);
					qbase = this.restTemplate.GetForObject<QBasePagination>(sURL);
					foreach ( QBase qb in qbase.Items )
					{
						all.Add(qb);
					}
				}
			}
			return all;
		}

		public virtual IList<T> GetAll(string filter, string sort)
		{
			// 02/17/2015 Paul.  Always start with a count query so that we con't have to create a pagination object for each QuickBooks object. 
			string sQuery = "select count(*) from " + this.tableName;
			if ( !String.IsNullOrEmpty(filter) )
				sQuery += " where " + filter;
			if ( !String.IsNullOrEmpty(sort) )
				sQuery += " orderby " + sort;
			string sURL = "company/" + companyId + "/query?query=" + HttpUtils.UrlEncode(sQuery);
			QBasePagination qbase = this.restTemplate.GetForObject<QBasePagination>(sURL);
			
			List<T> all = new List<T>();
			sQuery = "select * from " + this.tableName;
			if ( !String.IsNullOrEmpty(filter) )
				sQuery += " where " + filter;
			if ( !String.IsNullOrEmpty(sort) )
				sQuery += " order by " + sort;
			
			int nTotalCount = qbase.TotalCount;
			int nTotalPages = nTotalCount / maxResults + (nTotalCount % maxResults > 0 ? 1 : 0);
			for ( int i = 0; i < nTotalPages; i++ )
			{
				string sQueryPaginated = sQuery + " startPosition " + (i * maxResults + 1).ToString() + " maxResults " + maxResults.ToString();
				sURL = "company/" + companyId + "/query?query=" + HttpUtils.UrlEncode(sQueryPaginated);
				IList<T> lst = this.restTemplate.GetForObject<IList<T>>(sURL);
				foreach ( T qb in lst )
				{
					all.Add(qb);
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
