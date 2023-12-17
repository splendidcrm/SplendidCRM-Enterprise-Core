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
	class MemberTemplate : IMemberOperations
	{
		protected RestTemplate restTemplate;
		protected int          maxResults  ;

		public MemberTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 1000        ;
		}

		public virtual IList<HBase> GetModified(string list_id, DateTime startModifiedDate)
		{
			long lTicks = JsonUtils.ToUnixTicks(startModifiedDate);
			int nOffset   = 0;
			int nPageSize = 100;
			string sURL = "/3.0/lists/" + list_id + "/members?count=" + nPageSize.ToString();
			// https://en.wikipedia.org/wiki/ISO_8601
			if ( startModifiedDate != DateTime.MinValue )
				sURL += "&since_last_changed=" + System.Web.HttpUtility.UrlEncode(startModifiedDate.ToString("yyyy-MM-ddTHH:mm:ssK"));
			MemberPagination pag = this.restTemplate.GetForObject<MemberPagination>(sURL);
			List<HBase> all = new List<HBase>();
			// 04/16/2016 Paul.  We need to keep track of skipped items. 
			int nSkipCount = 0;
			foreach ( Member member in pag.items )
			{
				if ( startModifiedDate == DateTime.MinValue || member.date_created > startModifiedDate )
					all.Insert(0, member);
				else
					nSkipCount++;
			}
			while ( (all.Count + nSkipCount) < pag.total )
			{
				nOffset += nPageSize;
				string sPagedURL = sURL + "&offset=" + nOffset;
				pag = this.restTemplate.GetForObject<MemberPagination>(sPagedURL);
				foreach ( Member member in pag.items )
				{
					// 04/08/2016 Paul.  since_created_at is not working, so manually filter. 
					if ( startModifiedDate == DateTime.MinValue || member.date_created > startModifiedDate )
						all.Insert(0, member);
					else
						nSkipCount++;
				}
			}
			return all;
		}

		public virtual IList<Member> GetAll(string list_id, string type)
		{
			// http://developer.mailchimp.com/documentation/mailchimp/reference/templates/#read-get_templates
			int nOffset   = 0;
			int nPageSize = 100;
			string sURL = "/3.0/lists/" + list_id + "/members?count=" + nPageSize.ToString();
			if ( !String.IsNullOrEmpty(type) )
				sURL += "&type=" + type;
			MemberPagination pag = this.restTemplate.GetForObject<MemberPagination>(sURL);
			List<Member> all = new List<Member>(pag.items);
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

		// 02/16/2017 Paul.  Make sure that member does not exist. 
		public virtual IList<Member> Search(string list_id, string email)
		{
			// http://developer.mailchimp.com/documentation/mailchimp/reference/templates/#read-get_templates
			string sURL = "/3.0/search-members?list_id=" + list_id + "&query=" + email;
			MemberSearch pag = this.restTemplate.GetForObject<MemberSearch>(sURL);
			return pag.items;
		}

		public Member GetById(string list_id, string id)
		{
			string sURL = "/3.0/lists/" + list_id + "/members/" + id;
			return this.restTemplate.GetForObject<Member>(sURL);
		}

		public Member Insert(string list_id, Member obj)
		{
			string sURL = "/3.0/lists/" + list_id + "/members";
			return this.restTemplate.PostForObject<Member>(sURL, obj);
		}

		public void Update(string list_id, Member obj)
		{
			if ( String.IsNullOrEmpty(obj.id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/3.0/lists/" + list_id + "/members/" + obj.id + "";
			//this.restTemplate.PostForObject<Member>(sURL, obj);
			// 04/08/2016 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Member), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Member> responseExtractor = new MessageConverterResponseExtractor<Member>(this.restTemplate.MessageConverters);
			this.restTemplate.Execute<Member>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}

		public void Delete(string list_id, string id)
		{
			string sURL = "/3.0/lists/" + list_id + "/members/" + id;
			this.restTemplate.Delete(sURL);
		}
	}
}