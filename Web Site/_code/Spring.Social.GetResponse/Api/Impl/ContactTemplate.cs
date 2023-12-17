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

namespace Spring.Social.GetResponse.Api.Impl
{
	class ContactTemplate : IContactOperations
	{
		protected RestTemplate restTemplate;
		protected string       baseModule  ;
		protected int          perPage     ;

		public ContactTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.baseModule   = "contacts"  ;
			this.perPage      = 500         ;
		}

		public virtual IList<Contact> GetModified(DateTime startModifiedDate)
		{
			// http://apidocs.getresponse.com/en/v3/
			string sURL = baseModule;
			if ( startModifiedDate != DateTime.MinValue )
			{
				// 05/06/2015 Paul.  Not allowed search field. 
				//sURL += "?query[createdOn[from]]=" + startModifiedDate.ToString("s");
				//sURL += "&query[createdOn[to]]="   + DateTime.Now.AddHours(1).ToString("s");
			}
			IList<Contact> all = this.restTemplate.GetForObject<IList<Contact>>(sURL);
			return all;
		}

		public virtual IList<Contact> GetAll(string search)
		{
			// http://apidocs.getresponse.com/en/v3/resources/contacts
			string sURL = baseModule;
			// 05/07/2015 Paul.  Pagination is returned in HTTP headers. 
			IList<Contact> all = this.restTemplate.GetForObject<IList<Contact>>(sURL);
			return all;
		}

		public Contact GetById(string id)
		{
			string sURL = baseModule + "/" + id;
			return this.restTemplate.GetForObject<Contact>(sURL);
		}

		public Contact Insert(Contact obj)
		{
			string sURL = baseModule;
			return this.restTemplate.PostForObject<Contact>(sURL, obj);
		}

		public Contact Update(Contact obj)
		{
			if ( obj.id == null )
				throw(new Exception("id must not be null during update operation."));
			string sURL = baseModule + "/" + obj.id;
			return this.restTemplate.PostForObject<Contact>(sURL, obj);
		}

		public void Delete(string id)
		{
			string sURL = baseModule + "/" + id;
			this.restTemplate.Delete(sURL);
		}
	}
}