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
	class EventTemplate : IEventOperations
	{
		protected RestTemplate restTemplate;

		public EventTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		public virtual EventPagination GetEventsDelta(string category, DateTime startModifiedDate, string stateToken, int nPageSize)
		{
			// https://docs.microsoft.com/en-us/graph/delta-query-messages#example-to-synchronize-messages-in-a-folder
			// https://docs.microsoft.com/en-us/graph/delta-query-messages#optional-request-header
			if ( nPageSize <= 0 )
				nPageSize = 100;
#if DEBUG
			nPageSize = 1;
#endif
			this.restTemplate.RequestInterceptors.Add(new Office365RequestInterceptor("Prefer" , "odata.maxpagesize=" + nPageSize.ToString()));
			// The following parameters are not supported with change tracking over the 'CalendarView' resource: '$orderby, $filter, $select, $expand, $search'.
			string sURL = "/v1.0/me/calendarView/delta?";
			if ( !Sql.IsEmptyString(stateToken) )
			{
				sURL += Sql.ToString(stateToken);
			}
			else
			{
				if ( startModifiedDate == DateTime.MinValue )
					startModifiedDate = DateTime.UtcNow;
				// https://docs.microsoft.com/en-us/graph/api/event-delta?view=graph-rest-1.0&tabs=http
				sURL += "&startDateTime=" + startModifiedDate.AddMilliseconds(600).ToString(DateTimeTimeZone.DateTimeFormat);
				DateTime endDateTime = DateTime.UtcNow.AddYears(1);
				sURL += "&endDateTime=" + endDateTime.ToString(DateTimeTimeZone.DateTimeFormat);
			}
			EventPagination pag = this.restTemplate.GetForObject<EventPagination>(sURL);
			return pag;
		}

		public virtual IList<Event> GetModified(string category, DateTime startModifiedDate, int nPageSize)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.EventTemplate.GetModified " + startModifiedDate.ToString());
			if ( nPageSize <= 0 )
				nPageSize = 100;
			string filter = String.Empty;
			if ( !Sql.IsEmptyString(category) )
			{
				filter = "categories/any(a:a eq '" + Sql.EscapeSQL(category) + "')";
			}
			// https://docs.microsoft.com/en-us/graph/query-parameters
			string sSort = "lastModifiedDateTime asc";
			string sURL = "/v1.0/me/events?$count=true&$orderby=" + sSort + "&$top=" + nPageSize.ToString();
			if ( startModifiedDate > DateTime.MinValue )
			{
				// 03/28/2010 Paul.  The Greater Than filter does not appear to be working. 
				// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
				// 03/28/2010 Paul.  IsGreaterThan is being treated as IsGreaterThanOrEqualTo. 
				if ( !Sql.IsEmptyString(filter) )
					filter += " and ";
				// https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings?redirectedfrom=MSDN#Roundtrip
				filter += "lastModifiedDateTime ge " + startModifiedDate.AddMilliseconds(600).ToString(DateTimeTimeZone.DateTimeFormat);
			}
			if ( !Sql.IsEmptyString(filter) )
				sURL += "&$filter=" + filter;
			EventPagination pag = this.restTemplate.GetForObject<EventPagination>(sURL);
			List<Event> all = new List<Event>(pag.events);
			int nPageOffset = 0;
			while ( all.Count < pag.count )
			{
				nPageOffset += nPageSize;
				string sPagedURL = sURL + "&skip=" + nPageOffset;
				pag = this.restTemplate.GetForObject<EventPagination>(sPagedURL);
				foreach ( Event evt in pag.events )
				{
					all.Add(evt);
				}
			}
			return all;
		}

		public virtual IList<Event> GetAll(string search)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.EventTemplate.GetAll " + Sql.ToString(search));
			int nPageSize = 100;
			string sSort = "lastModifiedDateTime asc";
			string sURL = "/v1.0/me/events?$count=true&$orderby=" + sSort + "&$top=" + nPageSize.ToString();
			if ( !Sql.IsEmptyString(search) )
			{
				// https://docs.microsoft.com/en-us/graph/query-parameters
				sURL += "&$filter=" + search;
			}
			EventPagination pag = this.restTemplate.GetForObject<EventPagination>(sURL);
			List<Event> all = new List<Event>(pag.events);
			int nPageOffset = 0;
			while ( all.Count < pag.count )
			{
				nPageOffset += nPageSize;
				string sPagedURL = sURL + "&skip=" + nPageOffset;
				pag = this.restTemplate.GetForObject<EventPagination>(sPagedURL);
				foreach ( Event evt in pag.events )
				{
					all.Add(evt);
				}
			}
			return all;
		}

		public virtual int GetCount()
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.EventTemplate.GetCount");
			// https://developer.microsoft.com/en-us/graph/graph-explorer/
			// 12/02/2020 Paul.  $count to return count, top=1 to only return one record, select=id to only return id. 
			string sURL = "/v1.0/me/events?$count=true&$top=1&$select=id";
			EventPagination pag = this.restTemplate.GetForObject<EventPagination>(sURL);
			return pag.count;
		}

		public virtual EventPagination GetPage(string search, string sort, int nPageOffset, int nPageSize)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.EventTemplate.GetPage " + Sql.ToString(nPage));
			if ( nPageSize <= 0 )
				nPageSize = 100;
			if ( Sql.IsEmptyString(sort) )
				sort = "lastModifiedDateTime asc";
			string sURL = "/v1.0/me/events?$count=true&$orderby=" + sort + "&$top=" + nPageSize.ToString();
			if ( nPageOffset > 0 )
			{
				sURL += "&$skip=" + nPageOffset.ToString();
			}
			if ( !Sql.IsEmptyString(search) )
			{
				// https://docs.microsoft.com/en-us/graph/query-parameters
				sURL += "&$filter=" + search;
			}
			EventPagination pag = this.restTemplate.GetForObject<EventPagination>(sURL);
			return pag;
		}
		
		public virtual Event GetById(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.EventTemplate.GetById " + Sql.ToString(id));
			string sURL = "/v1.0/me/events/" + id;
			// 12/25/2020 Paul.  SplendidCRM does not use HTML for Call/Meeting description. 
			this.restTemplate.RequestInterceptors.Add(new Office365RequestInterceptor("Prefer" , "outlook.body-content-type=\"text\""));
			return this.restTemplate.GetForObject<Event>(sURL);
		}
		
		public virtual Event Insert(Event obj)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.EventTemplate.Insert " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			string sURL = "/v1.0/me/events";
			return this.restTemplate.PostForObject<Event>(sURL, obj);
		}
		
		public virtual Event Update(Event obj)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.EventTemplate.Update " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			if ( Sql.IsEmptyString(obj.Id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/v1.0/me/events/" + obj.Id;
			//this.restTemplate.PostForObject<Event>(sURL, obj);
			// 12/05/2020 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Event), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Event> responseExtractor = new MessageConverterResponseExtractor<Event>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<Event>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}
		
		public virtual void Delete(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.EventTemplate.Delete " + Sql.ToString(id));
			string sURL = "/v1.0/me/events/" + id;
			this.restTemplate.Delete(sURL);
		}
	}
}