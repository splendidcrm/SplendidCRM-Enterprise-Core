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
using System.IO;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Diagnostics;
using Spring.Json;
using Spring.Social.Office365;
using Spring.Social.Office365.Api;
using Spring.Social.Office365.Api.Impl.Json;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;

namespace SplendidCRM.Pages
{
	[IgnoreAntiforgeryToken]
	public class Office365NotificationsModel : PageModel
	{
		private HttpContext          Context            ;
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SyncError            SyncError          ;
		private Crm.Modules          Modules            ;
		private Office365Sync        Office365Sync      ;
		private IBackgroundTaskQueue taskQueue          ;

		public Office365NotificationsModel(IHttpContextAccessor httpContextAccessor, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SyncError SyncError, SplendidCRM.Crm.Modules Modules, Office365Sync Office365Sync, IBackgroundTaskQueue taskQueue)
		{
			this.Context             = httpContextAccessor.HttpContext;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SyncError           = SyncError          ;
			this.Modules             = Modules            ;
			this.Office365Sync       = Office365Sync      ;
			this.taskQueue           = taskQueue          ;
		}

		public IActionResult OnGet()
		{
			string sMessage = "Missing validation token";
			try
			{
				string validationToken = Sql.ToString(Request.Query["validationToken"]);
				if ( !Sql.IsEmptyString(validationToken) )
				{
					//Debug.WriteLine("Office365Notifications validationToken: " + validationToken);
					Response.ContentType = Request.ContentType;
					sMessage = validationToken;
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
			}
			byte[] data = System.Text.Encoding.UTF8.GetBytes(sMessage);
			Response.ContentType = "text/plain";  // "image/gif"
			return File(data, Response.ContentType);
		}

		public async Task<IActionResult> OnPostAsync()
		{
			string sMessage = String.Empty;
			string sFormBody = String.Empty;
			using ( StreamReader rdr = new StreamReader(Request.Body) )
			{
				sFormBody = await rdr.ReadToEndAsync();
			}
			try
			{
				if ( Request.ContentType.StartsWith("application/json") )
				{
#if DEBUG
					Debug.WriteLine("Office365Notifications.ContentType: " + Request.ContentType);
					Debug.WriteLine("Office365Notifications.QueryString: " + Request.QueryString);
					if ( !Sql.IsEmptyString(sFormBody) )
						Debug.WriteLine("Office365Notifications.Body: " + sFormBody);
#endif
					JsonValue json = JsonValue.Parse(sFormBody);
					JsonMapper jsonMapper = new JsonMapper();
					jsonMapper.RegisterDeserializer(typeof(ResourceData                   ), new ResourceDataDeserializer                ());
					jsonMapper.RegisterDeserializer(typeof(SubscriptionNotification       ), new SubscriptionNotificationDeserializer    ());
					jsonMapper.RegisterDeserializer(typeof(IList<SubscriptionNotification>), new SubscriptionNotificationListDeserializer());
					jsonMapper.RegisterDeserializer(typeof(SubscriptionNotificationBody   ), new SubscriptionNotificationBodyDeserializer());
					SubscriptionNotificationBody body = jsonMapper.Deserialize<SubscriptionNotificationBody>(json);
					foreach ( SubscriptionNotification notification in body.values )
					{
						//Debug.WriteLine(notification.ToString());
						Guid gUSER_ID = Sql.ToGuid(notification.ClientState);
						if ( !Sql.IsEmptyGuid(gUSER_ID) )
						{
							bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"      ]);
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Office365Notifications: " + Sql.ToString(notification.ChangeType) + " " + Sql.ToString(notification.LifecycleEvent) + " for " + gUSER_ID.ToString() + ", " + notification.Resource);
							// 12/25/2020 Paul.  Use a queue to prevent hitting concurrency limit. 
							// Application is over its MailboxConcurrency limit.
							await Office365Sync.AddNotificationToQueue(notification, taskQueue);
						}
						Response.StatusCode = 202;
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
			}
			byte[] data = System.Text.Encoding.UTF8.GetBytes(sMessage);
			Response.ContentType = "text/plain";  // "image/gif"
			return File(data, Response.ContentType);
		}
	}
}
