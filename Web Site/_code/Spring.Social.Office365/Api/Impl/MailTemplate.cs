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
using System.Xml;
using System.Net;
using System.Collections.Generic;
using System.Collections.Specialized;

using Spring.Json;
using Spring.Http;
using Spring.Rest.Client;
using Spring.Rest.Client.Support;

namespace Spring.Social.Office365.Api.Impl
{
	class MailTemplate : IMailOperations
	{
		protected RestTemplate restTemplate;
		protected int maxResults;

		public MailTemplate(RestTemplate restTemplate)
		{
			this.restTemplate = restTemplate;
			this.maxResults = 1000;
		}

		public virtual int GetInboxUnreadCount()
		{
			// https://www.c-sharpcorner.com/blogs/get-unread-mails-from-inbox-using-microsoft-graph
			// https://developer.microsoft.com/en-us/graph/graph-explorer/
			// 12/02/2020 Paul.  $count to return count, top=1 to only return one record, select=id to only return id. 
			string sURL = "/v1.0/me/mailFolders/Inbox/messages?$count=true&$top=1&$select=id&$filter=isRead ne true";
			MessagePagination pag = this.restTemplate.GetForObject<MessagePagination>(sURL);
			return pag.count;
		}

		public virtual Message GetById(string id)
		{
			// 12/02/2020 Paul.  internet headers must be retrieved separately, so get first. 
			string sURL = "/v1.0/me/messages/" + id + "?$select=internetMessageHeaders,body";
			// https://docs.microsoft.com/en-us/graph/outlook-create-send-messages#reading-messages-with-control-over-the-body-format-returned
			this.restTemplate.RequestInterceptors.Add(new Office365RequestInterceptor("Prefer" , "outlook.body-content-type=\"text\""));
			Message messageHeaders = this.restTemplate.GetForObject<Message>(sURL);
			
			// 12/02/2020 Paul.  $expand=attachments to include attachments in the request. 
			sURL = "/v1.0/me/messages/" + id + "?$expand=attachments";
			Message message = this.restTemplate.GetForObject<Message>(sURL);
			message.InternetMessageHeaders = messageHeaders.InternetMessageHeaders;
			// 12/25/2020 Paul.  The plain text body is returned in BodyPreview. 
			message.BodyPreview            = (messageHeaders.Body != null ? messageHeaders.Body.Content : String.Empty);
			return message;
		}

		public virtual Message GetById(string id, string select)
		{
			string sURL = "/v1.0/me/messages/" + id + "?$select=" + select;
			Message message = this.restTemplate.GetForObject<Message>(sURL);
			return message;
		}

		public virtual Message Create(Message msg)
		{
			string sURL = "/v1.0/me/messages";
			Message draft = this.restTemplate.PostForObject<Message>(sURL, msg);
			return draft;
		}

		public virtual void AddAttachment(string id, Attachment att)
		{
			// https://docs.microsoft.com/en-us/graph/api/message-post-attachments?view=graph-rest-1.0&tabs=http
			string sURL = "/v1.0/me/messages/" + id + "/attachments";
			this.restTemplate.PostForObject<Attachment>(sURL, att);
		}

		public virtual void Send(string id)
		{
			// https://docs.microsoft.com/en-us/graph/api/message-send?view=graph-rest-1.0&tabs=http
			try
			{
				string sURL = "/v1.0/me/messages/" + id + "/send";
				// 02/06/2021 Paul.  SendMessage does not return anything, so specify object. 
				this.restTemplate.PostForObject<object>(sURL, null);
			}
			catch(Exception ex)
			{
				// 02/19/2021 Paul.  This error can be thrown when Outlook returns a response without a media type. 
				if ( ex.Message.Contains("Could not extract response: no suitable HttpMessageConverter found") )
					return;
				throw;
			}
		}

		public virtual void SendMail(Message msg)
		{
			// https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http
			try
			{
				string sURL = "/v1.0/me/sendMail";
				SendMessage sendMessage = new SendMessage(msg);
				// 02/06/2021 Paul.  SendMessage does not return anything, so specify object. 
				this.restTemplate.PostForObject<object>(sURL, sendMessage);
			}
			catch(Exception ex)
			{
				// 02/19/2021 Paul.  This error can be thrown when Outlook returns a response without a media type. 
				if ( ex.Message.Contains("Could not extract response: no suitable HttpMessageConverter found") )
					return;
				throw;
			}
		}

		public virtual void MarkAsUnread (string id)
		{
			string sURL = "/v1.0/me/messages/" + id + "?$select=id,lastModifiedDateTime,isRead,subject";
			Message message = this.restTemplate.GetForObject<Message>(sURL);
			if ( message != null )
			{
				if ( message.IsRead.HasValue && message.IsRead.Value )
				{
					message.IsRead = false;
					// https://docs.microsoft.com/en-us/graph/api/message-update?view=graph-rest-1.0&tabs=http
					IList<Spring.Http.Converters.IHttpMessageConverter> requestConverter = new List<Spring.Http.Converters.IHttpMessageConverter>();
					JsonMapper jsonMapper = new JsonMapper();
					jsonMapper.RegisterSerializer(typeof(Message), new Spring.Social.Office365.Api.Impl.Json.MessageUpdateSerializer());
					requestConverter.Add(new Spring.Http.Converters.Json.SpringJsonHttpMessageConverter(jsonMapper));
					HttpEntityRequestCallback requestCallback = new HttpEntityRequestCallback(message, typeof(Message), requestConverter);
					MessageConverterResponseExtractor<Message> responseExtractor = new MessageConverterResponseExtractor<Message>(this.restTemplate.MessageConverters);
					sURL = "/v1.0/me/messages/" + id;
					this.restTemplate.Execute<Message>(sURL, HttpMethod.PATCH, requestCallback, responseExtractor);
				}
			}
		}

	}
}