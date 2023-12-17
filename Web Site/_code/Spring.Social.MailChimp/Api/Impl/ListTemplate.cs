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

namespace Spring.Social.MailChimp.Api.Impl
{
	class ListTemplate : IListOperations
	{
		protected RestTemplate restTemplate;
		protected int          maxResults  ;

		public ListTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 1000        ;
		}

		public virtual IList<HBase> GetModified(DateTime startModifiedDate)
		{
			long lTicks = JsonUtils.ToUnixTicks(startModifiedDate);
			int nOffset   = 0;
			int nPageSize = 100;
			string sURL = "/3.0/lists?count=" + nPageSize.ToString();
			// https://en.wikipedia.org/wiki/ISO_8601
			if ( startModifiedDate != DateTime.MinValue )
				sURL += "&since_created_at=" + System.Web.HttpUtility.UrlEncode(startModifiedDate.ToString("yyyy-MM-ddTHH:mm:ssK"));
			ListPagination pag = this.restTemplate.GetForObject<ListPagination>(sURL);
			List<HBase> all = new List<HBase>();
			// 04/16/2016 Paul.  We need to keep track of skipped items. 
			int nSkipCount = 0;
			foreach ( Spring.Social.MailChimp.Api.List list in pag.items )
			{
				if ( startModifiedDate == DateTime.MinValue || list.date_created > startModifiedDate )
					all.Insert(0, list);
				else
					nSkipCount++;
			}
			while ( (all.Count + nSkipCount) < pag.total )
			{
				nOffset += nPageSize;
				string sPagedURL = sURL + "&offset=" + nOffset;
				pag = this.restTemplate.GetForObject<ListPagination>(sPagedURL);
				foreach ( Spring.Social.MailChimp.Api.List list in pag.items )
				{
					// 04/08/2016 Paul.  since_created_at is not working, so manually filter. 
					if ( startModifiedDate == DateTime.MinValue || list.date_created > startModifiedDate )
						all.Insert(0, list);
					else
						nSkipCount++;
				}
			}
			return all;
		}

		public virtual IList<Spring.Social.MailChimp.Api.List> GetAll()
		{
			// http://developer.mailchimp.com/documentation/mailchimp/reference/lists/#read-get_lists
			int nOffset   = 0;
			int nPageSize = 100;
			string sURL = "/3.0/lists?count=" + nPageSize.ToString();
			ListPagination pag = this.restTemplate.GetForObject<ListPagination>(sURL);
			List<Spring.Social.MailChimp.Api.List> all = new List<Spring.Social.MailChimp.Api.List>(pag.items);
			while ( all.Count < pag.total )
			{
				nOffset += nPageSize;
				string sPagedURL = sURL + "&offset=" + nOffset;
				pag = this.restTemplate.GetForObject<ListPagination>(sPagedURL);
				foreach ( List list in pag.items )
				{
					all.Add(list);
				}
			}
			return all;
		}

		public Spring.Social.MailChimp.Api.List GetById(string id)
		{
			string sURL = "/3.0/lists/" + id;
			return this.restTemplate.GetForObject<Spring.Social.MailChimp.Api.List>(sURL);
		}

		public Spring.Social.MailChimp.Api.List Insert(Spring.Social.MailChimp.Api.List obj)
		{
			string sURL = "/3.0/lists";
			return this.restTemplate.PostForObject<List>(sURL, obj);
		}

		public void Update(Spring.Social.MailChimp.Api.List obj)
		{
			if ( String.IsNullOrEmpty(obj.id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/3.0/lists/" + obj.id + "";
			//this.restTemplate.PostForObject<List>(sURL, obj);
			// 04/08/2016 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Spring.Social.MailChimp.Api.List), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<List> responseExtractor = new MessageConverterResponseExtractor<Spring.Social.MailChimp.Api.List>(this.restTemplate.MessageConverters);
			this.restTemplate.Execute<Spring.Social.MailChimp.Api.List>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}

		public void Delete(string id)
		{
			string sURL = "/3.0/lists/" + id;
			this.restTemplate.Delete(sURL);
		}

		public IList<Spring.Social.MailChimp.Api.Member> GetMembers(string id)
		{
			// http://developer.mailchimp.com/documentation/mailchimp/reference/lists/members/
			int nOffset   = 0;
			int nPageSize = 100;
			string sURL = "/3.0/lists/" + id + "/members?count=" + nPageSize.ToString();
			MemberPagination pag = this.restTemplate.GetForObject<MemberPagination>(sURL);
			List<Spring.Social.MailChimp.Api.Member> all = new List<Spring.Social.MailChimp.Api.Member>(pag.items);
			while ( all.Count < pag.total )
			{
				nOffset += nPageSize;
				string sPagedURL = sURL + "&offset=" + nOffset;
				pag = this.restTemplate.GetForObject<MemberPagination>(sPagedURL);
				foreach ( Member member in pag.items )
				{
					all.Add(member);
				}
			}
			return all;
		}

		// 05/29/2016 Paul.  Add merge fields. 
		public IList<Spring.Social.MailChimp.Api.MergeField> GetMergeFields(string id)
		{
			// http://developer.mailchimp.com/documentation/mailchimp/reference/lists/merge-fields/
			// 02/16/2017 Paul.  MergeFields need to be paginated. 
			int nOffset   = 0;
			int nPageSize = 10;
			string sURL = "/3.0/lists/" + id + "/merge-fields?count=" + nPageSize.ToString();
			MergeFieldPagination pag = this.restTemplate.GetForObject<MergeFieldPagination>(sURL);
			List<MergeField> all = new List<MergeField>(pag.items);
			while ( all.Count < pag.total )
			{
				nOffset += nPageSize;
				string sPagedURL = sURL + "&offset=" + nOffset;
				pag = this.restTemplate.GetForObject<MergeFieldPagination>(sPagedURL);
				foreach ( MergeField field in pag.items )
				{
					all.Add(field);
				}
			}
			return all;
		}

		public Spring.Social.MailChimp.Api.MergeField AddMergeField(string id, MergeField obj)
		{
			// http://developer.mailchimp.com/documentation/mailchimp/reference/lists/merge-fields/
			string sURL = "/3.0/lists/" + id + "/merge-fields";
			return this.restTemplate.PostForObject<MergeField>(sURL, obj);
		}
	}
}
