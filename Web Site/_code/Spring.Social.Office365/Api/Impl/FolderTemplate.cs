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
	class FolderTemplate : IFolderOperations
	{
		protected RestTemplate restTemplate;

		public FolderTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
		}

		// 10/28/2022 Paul.  Folders will be split into a list that we can recursively navigate. 
		private IList<MailFolder> GetAll(string parentFolderId, List<string> lstFolders)
		{
			string filter = String.Empty;
			if ( lstFolders.Count > 0 )
			{
				string sMAILBOX = lstFolders[0];
				lstFolders.RemoveAt(0);
				if ( !Sql.IsEmptyString(sMAILBOX) )
				{
					filter = "displayName eq '" + Sql.EscapeSQL(sMAILBOX) + "'";
				}
			}
			Debug.WriteLine("Spring.Social.Office365.Api.Impl.FolderTemplate.GetAll " + parentFolderId + " " + Sql.ToString(filter));
			int nPageSize = 100;
			string sSort = "displayName asc";
			string sURL = "/v1.0/me/mailFolders" + (!Sql.IsEmptyString(parentFolderId) ? "/" + parentFolderId + "/childFolders" : "") + "?$count=true&$orderby=" + sSort + "&$top=" + nPageSize.ToString();
			if ( !Sql.IsEmptyString(filter) )
			{
				// https://docs.microsoft.com/en-us/graph/query-parameters
				sURL += "&$filter=" + filter;
			}
			MailFolderPagination pag = this.restTemplate.GetForObject<MailFolderPagination>(sURL);
			List<MailFolder> all = new List<MailFolder>(pag.folders);
			if ( all.Count > 0 && lstFolders.Count > 0 )
			{
				// 10/28/2022 Paul.  Recursive call to get next folder in list. 
				return GetAll(all[0].Id, lstFolders);
			}
			else
			{
				int nPageOffset = 0;
				while ( all.Count < pag.count )
				{
					nPageOffset += nPageSize;
					string sPagedURL = sURL + "&skip=" + nPageOffset;
					pag = this.restTemplate.GetForObject<MailFolderPagination>(sPagedURL);
					foreach ( MailFolder folder in pag.folders )
					{
						all.Add(folder);
					}
				}
			}
			return all;
		}

		// 10/28/2022 Paul.  Mailbox may include subfolders. 
		public virtual IList<MailFolder> GetAll(string sMAILBOX)
		{
			List<string> lstFolders = new List<string>(sMAILBOX.Replace("\\", "/").Split('/'));
			IList<MailFolder> all = GetAll(String.Empty, lstFolders);
			return all;
		}

		public virtual MailFolder GetById(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.FolderTemplate.GetById " + Sql.ToString(id));
			string sURL = "/v1.0/me/mailFolders/" + id;
			return this.restTemplate.GetForObject<MailFolder>(sURL);
		}
		
		public virtual MailFolder Insert(string parentFolderId, string displayName)
		{
			Debug.WriteLine("Spring.Social.Office365.Api.Impl.FolderTemplate.Insert " + parentFolderId + "  " + displayName);
			string sURL = "/v1.0/me/mailFolders/" + parentFolderId + "/childFolders";
			MailFolder obj = new MailFolder();
			obj.DisplayName = displayName;
			return this.restTemplate.PostForObject<MailFolder>(sURL, obj);
		}
		
		public virtual MailFolder Update(MailFolder obj)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.FolderTemplate.Update " + Sql.ToString(obj.first_name) + " " + Sql.ToString(obj.last_name));
			if ( Sql.IsEmptyString(obj.Id) )
				throw(new Exception("id must not be null during update operation."));
			string sURL = "/v1.0/me/mailFolders/" + obj.Id;
			//this.restTemplate.PostForObject<MailFolder>(sURL, obj);
			// 12/05/2020 Paul.  PATCH method is used instead of POST. 
			HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(obj, typeof(MailFolder), this.restTemplate.MessageConverters);
			MessageConverterResponseExtractor<MailFolder> responseExtractor = new MessageConverterResponseExtractor<MailFolder>(this.restTemplate.MessageConverters);
			return this.restTemplate.Execute<MailFolder>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
		}
		
		public virtual void Delete(string id)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.FolderTemplate.Delete " + Sql.ToString(id));
			string sURL = "/v1.0/me/mailFolders/" + id;
			this.restTemplate.Delete(sURL);
		}

		// 10/28/2022 Paul.  Change name to reflect function.  The entire message is not returned, just the ids. 
		public virtual MessagePagination GetMessageIds(string id, string search, string sort, int nPageOffset, int nPageSize)
		{
			if ( nPageSize <= 0 )
				nPageSize = 100;
			// 12/30/2020 Paul.  Not practical to use filter and sort. 
			// The restriction or sort order is too complex for this operation.
			// https://docs.microsoft.com/en-us/graph/api/user-list-messages?view=graph-rest-1.0&tabs=http
			string sURL = "/v1.0/me/mailFolders/" + id + "/messages?$count=true&$select=id&$top=" + nPageSize.ToString();
			if ( nPageOffset > 0 )
			{
				sURL += "&$skip=" + nPageOffset.ToString();
			}
			if ( !Sql.IsEmptyString(search) )
			{
				// https://docs.microsoft.com/en-us/graph/query-parameters
				sURL += "&$filter=" + search;
			}
			MessagePagination pag = this.restTemplate.GetForObject<MessagePagination>(sURL);
			return pag;
		}

		public virtual MessagePagination GetMessagesDelta(string id, string stateToken, int nPageSize)
		{
			// https://docs.microsoft.com/en-us/graph/delta-query-messages#example-to-synchronize-messages-in-a-folder
			// https://docs.microsoft.com/en-us/graph/delta-query-messages#optional-request-header
			if ( nPageSize <= 0 )
				nPageSize = 100;
			this.restTemplate.RequestInterceptors.Add(new Office365RequestInterceptor("Prefer" , "odata.maxpagesize=" + nPageSize.ToString()));
			string sURL = "/v1.0/me/mailFolders/" + id + "/messages/delta?" + Sql.ToString(stateToken);
			MessagePagination pag = this.restTemplate.GetForObject<MessagePagination>(sURL);
			return pag;
		}

		// 10/28/2022 Paul.  Folders will be split into a list that we can recursively navigate. 
		private IList<MailFolder> GetChildFolders(string parentFolderId, List<string> lstFolders)
		{
			string folderName = String.Empty;
			if ( lstFolders.Count > 0 )
			{
				string sMAILBOX = lstFolders[0];
				lstFolders.RemoveAt(0);
				if ( !Sql.IsEmptyString(sMAILBOX) )
				{
					folderName = sMAILBOX;
				}
			}

			int nPageSize = 100;
			string sSort = "displayName asc";
			string sURL = "/v1.0/me/mailFolders/" + parentFolderId + "/childFolders?$count=true&$orderby=" + sSort + "&$top=" + nPageSize.ToString();
			if ( !Sql.IsEmptyString(folderName) )
			{
				sURL += "&$filter=displayName eq '" + Sql.EscapeSQL(folderName) + "'";
			}
			MailFolderPagination pag = this.restTemplate.GetForObject<MailFolderPagination>(sURL);
			List<MailFolder> all = new List<MailFolder>(pag.folders);
			if ( all.Count > 0 && lstFolders.Count > 0 )
			{
				// 10/28/2022 Paul.  Recursive call to get next folder in list. 
				return GetChildFolders(all[0].Id, lstFolders);
			}
			else
			{
				int nPageOffset = 0;
				while ( all.Count < pag.count )
				{
					nPageOffset += nPageSize;
					string sPagedURL = sURL + "&skip=" + nPageOffset;
					pag = this.restTemplate.GetForObject<MailFolderPagination>(sPagedURL);
					foreach ( MailFolder folder in pag.folders )
					{
						all.Add(folder);
					}
				}
			}
			return all;
		}

		// 10/28/2022 Paul.  Mailbox may include subfolders. 
		public virtual IList<MailFolder> GetChildFolders(string id, string sMAILBOX)
		{
			List<string> lstFolders = new List<string>(sMAILBOX.Replace("\\", "/").Split('/'));
			IList<MailFolder> all = GetAll(String.Empty, lstFolders);
			return all;
		}

		// https://docs.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0
		// msgfolderroot, drafts, inbox, outbox, sentitems
		public virtual MailFolder GetWellKnownFolder(string folderName)
		{
			//Debug.WriteLine("Spring.Social.Office365.Api.Impl.FolderTemplate.GetWellKnownFolder " + Sql.ToString(folderName));
			string sURL = "/v1.0/me/mailFolders/" + folderName;
			return this.restTemplate.GetForObject<MailFolder>(sURL);
		}
	}
}