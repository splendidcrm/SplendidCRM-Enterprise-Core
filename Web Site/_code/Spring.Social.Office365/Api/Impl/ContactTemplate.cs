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
	class ContactTemplate : IContactOperations
	{
		protected RestTemplate restTemplate;

		public ContactTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		public virtual ContactPagination GetContactsDelta(string category, string stateToken, int nPageSize)
		{
			// https://docs.microsoft.com/en-us/graph/delta-query-messages#example-to-synchronize-messages-in-a-folder
			// https://docs.microsoft.com/en-us/graph/delta-query-messages#optional-request-header
			if ( nPageSize <= 0 )
				nPageSize = 100;
			this.restTemplate.RequestInterceptors.Add(new Office365RequestInterceptor("Prefer" , "odata.maxpagesize=" + nPageSize.ToString()));
			// The following parameters are not supported with change tracking over the 'Contacts' resource: '$orderby, $filter, $select, $expand, $search, $top'.
			string sURL = "/v1.0/me/contacts/delta?";
			if ( !Sql.IsEmptyString(stateToken) )
			{
				sURL += Sql.ToString(stateToken);
			}
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			return pag;
		}

		public virtual IList<Contact> GetModified(string category, DateTime startModifiedDate, int nPageSize)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.ContactTemplate.GetModified " + startModifiedDate.ToString());
			if ( nPageSize <= 0 )
				nPageSize = 100;
			string filter = String.Empty;
			if ( !Sql.IsEmptyString(category) )
			{
				filter = "categories/any(a:a eq '" + Sql.EscapeSQL(category) + "')";
			}
			// https://docs.microsoft.com/en-us/graph/query-parameters
			string sSort = "lastModifiedDateTime asc";
			string sURL = "/v1.0/me/contacts?$count=true&$orderby=" + sSort + "&$top=" + nPageSize.ToString();
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
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			List<Contact> all = new List<Contact>(pag.contacts);
			int nPageOffset = 0;
			while ( all.Count < pag.count )
			{
				nPageOffset += nPageSize;
				string sPagedURL = sURL + "&skip=" + nPageOffset;
				pag = this.restTemplate.GetForObject<ContactPagination>(sPagedURL);
				foreach ( Contact contact in pag.contacts )
				{
					all.Add(contact);
				}
			}
			return all;
		}

		public virtual IList<Contact> GetAll(string filter)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.ContactTemplate.GetAll " + Sql.ToString(filter));
			int nPageSize = 100;
			string sSort = "lastModifiedDateTime asc";
			string sURL = "/v1.0/me/contacts?$count=true&$orderby=" + sSort + "&$top=" + nPageSize.ToString();
			if ( !Sql.IsEmptyString(filter) )
			{
				// https://docs.microsoft.com/en-us/graph/query-parameters
				sURL += "&$filter=" + filter;
			}
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			List<Contact> all = new List<Contact>(pag.contacts);
			int nPageOffset = 0;
			while ( all.Count < pag.count )
			{
				nPageOffset += nPageSize;
				string sPagedURL = sURL + "&skip=" + nPageOffset;
				pag = this.restTemplate.GetForObject<ContactPagination>(sPagedURL);
				foreach ( Contact contact in pag.contacts )
				{
					all.Add(contact);
				}
			}
			return all;
		}

		public virtual int GetCount()
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.ContactTemplate.GetCount");
			// https://developer.microsoft.com/en-us/graph/graph-explorer/
			// 12/02/2020 Paul.  $count to return count, top=1 to only return one record, select=id to only return id. 
			string sURL = "/v1.0/me/contacts?$count=true&$top=1&$select=id";
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			return pag.count;
		}
		
		public virtual ContactPagination GetPage(string filter, string sort, int nPageOffset, int nPageSize)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.ContactTemplate.GetPage " + Sql.ToString(nPage));
			if ( nPageSize <= 0 )
				nPageSize = 100;
			if ( Sql.IsEmptyString(sort) )
				sort = "lastModifiedDateTime asc";
			string sURL = "/v1.0/me/contacts?$count=true&$orderby=" + sort + "&$top=" + nPageSize.ToString();
			if ( nPageOffset > 0 )
			{
				sURL += "&$skip=" + nPageOffset.ToString();
			}
			if ( !Sql.IsEmptyString(filter) )
			{
				// https://docs.microsoft.com/en-us/graph/query-parameters
				sURL += "&$filter=" + filter;
			}
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			return pag;
		}
		
		public virtual Contact GetById(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.ContactTemplate.GetById " + Sql.ToString(id));
			string sURL = "/v1.0/me/contacts/" + id + "?$expand=photo,singleValueExtendedProperties,multiValueExtendedProperties";
			// 12/25/2020 Paul.  SplendidCRM does not use HTML for Contact description. 
			this.restTemplate.RequestInterceptors.Add(new Office365RequestInterceptor("Prefer" , "outlook.body-content-type=\"text\""));
			return this.restTemplate.GetForObject<Contact>(sURL);
		}
		
		public virtual Contact Insert(Contact obj)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.ContactTemplate.Insert " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			string sURL = "/v1.0/me/contacts";
			return this.restTemplate.PostForObject<Contact>(sURL, obj);
		}
		
		public virtual Contact Update(Contact obj)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.ContactTemplate.Update " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			if ( Sql.IsEmptyString(obj.Id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/v1.0/me/contacts/" + obj.Id;
			//this.restTemplate.PostForObject<Contact>(sURL, obj);
			// 12/05/2020 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(Contact), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<Contact> responseExtractor = new MessageConverterResponseExtractor<Contact>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<Contact>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}
		
		public virtual void Delete(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.ContactTemplate.Delete " + Sql.ToString(id));
			string sURL = "/v1.0/me/contacts/" + id;
			this.restTemplate.Delete(sURL);
		}

		// 11/22/2023 Paul.  When unsyncing, we need to immediately clear the remote flag. 
		public virtual void Unsync(string id, string sCONTACTS_CATEGORY)
		{
			if ( !Sql.IsEmptyString(sCONTACTS_CATEGORY) )
			{
				string sURL = "/v1.0/me/contacts/" + id + "?select=id,createdDateTime,lastModifiedDateTime,changeKey,categories";
				OutlookItem obj = this.restTemplate.GetForObject<OutlookItem>(sURL);
				List<String> lstCategories = new List<String>();
				bool bUpdate = false;
				if ( obj.Categories.Contains(sCONTACTS_CATEGORY) )
				{
					obj.Categories.Remove(sCONTACTS_CATEGORY);
						bUpdate = true;
				}
				if ( bUpdate )
				{
					sURL = "/v1.0/me/contacts/" + obj.Id;
					HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(OutlookItem), this.restTemplate.MessageConverters);
					MessageConverterResponseExtractor<OutlookItem> responseExtractor = new MessageConverterResponseExtractor<OutlookItem>(this.restTemplate.MessageConverters);
					this.restTemplate.Execute<OutlookItem>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
				}
			}
		}
	}
}
