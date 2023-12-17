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

namespace Spring.Social.iContact.Api.Impl
{
	class ContactTemplate : IContactOperations
	{
		private string             siContactAccountId     ;
		private string             siContactClientFolderId;
		protected RestTemplate     restTemplate           ;
		protected int              maxResults             ;

		public ContactTemplate(string siContactAccountId, string siContactClientFolderId, RestTemplate restTemplate)
		{
			this.siContactAccountId      = siContactAccountId     ;
			this.siContactClientFolderId = siContactClientFolderId;
			this.restTemplate            = restTemplate           ;
			this.maxResults              = 100                    ;
		}

		private string BaseURL()
		{
			return "/icp/a/" + this.siContactAccountId + "/c/" + this.siContactClientFolderId + "/contacts";
		}

		public virtual bool Validate()
		{
			string sURL = BaseURL();
			sURL += "?status=total&orderby=createDate:desc&limit=1";
			this.restTemplate.GetForObject<ContactPagination>(sURL);
			// 05/02/2015 Paul.   An exception will be thrown if something is wrong, so we can always return true. 
			return true;
		}

		public virtual IList<Contact> GetAll()
		{
			string sURL = BaseURL();
			// http://www.icontact.com/developerportal/documentation/advanced-users/
			sURL += "?status=total&orderby=createDate:asc&limit=" + maxResults.ToString();
			ContactPagination pag = this.restTemplate.GetForObject<ContactPagination>(sURL);
			List<Contact> all = new List<Contact>(pag.items);
			while ( all.Count < pag.total )
			{
				string sPagedURL = sURL + "&offset=" + all.Count.ToString();
				pag = this.restTemplate.GetForObject<ContactPagination>(sPagedURL);
				foreach ( Contact contact in pag.items )
				{
					all.Add(contact);
				}
			}
			return all;
		}

		public Contact GetByEmail(string email)
		{
			string sURL = BaseURL() + "?status=total&email=" + email;
			return this.restTemplate.GetForObject<Contact>(sURL);
		}

		public Contact GetById(string id)
		{
			string sURL = BaseURL()+ "/" + id;
			return this.restTemplate.GetForObject<Contact>(sURL);
		}

		public Contact Insert(Contact obj)
		{
			string sURL = BaseURL();
			IList<Contact> arr = this.restTemplate.PostForObject<IList<Contact>>(sURL, obj);
			return arr[0];
		}

		public void Update(Contact obj)
		{
			// 05/02/2015 Paul.  iContact will update based on email if the contactId is not provided. 
			//if ( !Sql.IsEmptyString(obj.contactId) )
			//	throw(new Exception("id must not be null during update operation."));
			string sURL = BaseURL() + "/" + obj.contactId;
			this.restTemplate.PostForObject<Contact>(sURL, obj);
		}

		public void Delete(string id)
		{
			string sURL = BaseURL() + "/" + id;
			this.restTemplate.Delete(sURL);
		}
	}
}
