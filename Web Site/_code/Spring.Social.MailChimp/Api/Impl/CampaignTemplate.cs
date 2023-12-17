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
	class CampaignTemplate : ICampaignOperations
	{
		protected RestTemplate restTemplate;
		protected int          maxResults  ;

		public CampaignTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults   = 1000        ;
		}

		public virtual IList<HBase> GetModified(DateTime startModifiedDate)
		{
			long lTicks = JsonUtils.ToUnixTicks(startModifiedDate);
			int nOffset   = 0;
			int nPageSize = 100;
			string sURL = "/3.0/campaigns?count=" + nPageSize.ToString();
			if ( startModifiedDate != DateTime.MinValue )
				sURL += "&since_created_at=" + System.Web.HttpUtility.UrlEncode(startModifiedDate.ToString("yyyy-MM-ddTHH:mm:ssK"));
			CampaignPagination pag = this.restTemplate.GetForObject<CampaignPagination>(sURL);
			List<HBase> all = new List<HBase>();
			// 04/16/2016 Paul.  We need to keep track of skipped items. 
			int nSkipCount = 0;
			foreach ( Campaign campaign in pag.items )
			{
				if ( startModifiedDate == DateTime.MinValue || campaign.date_created > startModifiedDate )
					all.Insert(0, campaign);
				else
					nSkipCount++;
			}
			while ( (all.Count + nSkipCount) < pag.total )
			{
				nOffset += nPageSize;
				string sPagedURL = sURL + "&offset=" + nOffset;
				pag = this.restTemplate.GetForObject<CampaignPagination>(sPagedURL);
				foreach ( Campaign campaign in pag.items )
				{
					// 04/08/2016 Paul.  since_created_at is not working, so manually filter. 
					if ( startModifiedDate == DateTime.MinValue || campaign.date_created > startModifiedDate )
						all.Insert(0, campaign);
					else
						nSkipCount++;
				}
			}
			return all;
		}

		public virtual IList<Campaign> GetAll(string type)
		{
			// http://developer.mailchimp.com/documentation/mailchimp/reference/templates/#read-get_templates
			int nOffset   = 0;
			int nPageSize = 100;
			string sURL = "/3.0/campaigns?count=" + nPageSize.ToString();
			if ( !String.IsNullOrEmpty(type) )
				sURL += "&type=" + type;
			CampaignPagination pag = this.restTemplate.GetForObject<CampaignPagination>(sURL);
			List<Campaign> all = new List<Campaign>(pag.items);
			while ( all.Count < pag.total )
			{
				nOffset += nPageSize;
				string sPagedURL = sURL + "&offset=" + nOffset;
				pag = this.restTemplate.GetForObject<CampaignPagination>(sPagedURL);
				foreach ( Campaign campaign in pag.items )
				{
					all.Add(campaign);
				}
			}
			return all;
		}

		public Campaign GetById(string id)
		{
			string sURL = "/3.0/campaigns/" + id;
			return this.restTemplate.GetForObject<Campaign>(sURL);
		}

		public Campaign Insert(Campaign obj)
		{
			string sURL = "/3.0/campaigns";
			return this.restTemplate.PostForObject<Campaign>(sURL, obj);
		}

		public void Update(Campaign obj)
		{
			if ( String.IsNullOrEmpty(obj.id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/3.0/campaigns/" + obj.id + "";
			//this.restTemplate.PostForObject<Campaign>(sURL, obj);
			// 04/08/2016 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Campaign), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Campaign> responseExtractor = new MessageConverterResponseExtractor<Campaign>(this.restTemplate.MessageConverters);
			this.restTemplate.Execute<Campaign>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}

		public void Delete(string id)
		{
			string sURL = "/3.0/campaigns/" + id;
			this.restTemplate.Delete(sURL);
		}
	}
}