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
using System.Web;
using System.Net;
using System.Net.Mail;
using System.Collections.Generic;
using Spring.Social.Office365;
using Spring.Social.Office365.Api;

namespace SplendidCRM
{
	public class SplendidMailOffice365 : SplendidMailClient
	{
		private HttpApplicationState Application        = new HttpApplicationState();
		private Office365Sync Office365Sync    ;

		private Office365AccessToken token;

		public SplendidMailOffice365(Office365Sync Office365Sync, Guid gOAUTH_TOKEN_ID)
		{
			this.Office365Sync = Office365Sync;

			string sOAuthClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
			string sOAuthClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			this.token       = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, gOAUTH_TOKEN_ID, false);
		}

		override public void Send(System.Net.Mail.MailMessage mail)
		{
			Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(this.token.access_token);

			Message msg = new Message();
			msg.Subject       = mail.Subject;
			msg.Body          = new ItemBody(mail.Body);
			// 12/13/2020 Paul.  Cannot send as someone else. 
			//msg.From          = new Recipient(mail.From.DisplayName, mail.From.Address);
			msg.ToRecipients  = new List<Recipient>();
			msg.CcRecipients  = new List<Recipient>();
			msg.BccRecipients = new List<Recipient>();
			foreach ( System.Net.Mail.MailAddress to in mail.To )
			{
				msg.ToRecipients.Add(new Recipient(to.DisplayName, to.Address));
			}
			foreach ( System.Net.Mail.MailAddress to in mail.CC )
			{
				msg.CcRecipients.Add(new Recipient(to.DisplayName, to.Address));
			}
			foreach ( System.Net.Mail.MailAddress to in mail.Bcc )
			{
				msg.BccRecipients.Add(new Recipient(to.DisplayName, to.Address));
			}
			if ( mail.Headers.Count > 0 )
			{
				msg.InternetMessageHeaders = new List<InternetMessageHeader>();
			}
			// 07/19/2018 Paul.  Pull the Email ID from the headers as it is already being provided. 
			Guid gEMAIL_ID = Guid.Empty;
			for ( int iHeader = 0; iHeader < mail.Headers.Count; iHeader++ )
			{
				string sHeaderKey   = mail.Headers.GetKey(iHeader);
				string sHeaderValue = mail.Headers.Get   (iHeader);
				if ( sHeaderKey == "X-SplendidCRM-ID" )
					gEMAIL_ID = Sql.ToGuid(sHeaderValue);
				// https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http
				msg.InternetMessageHeaders.Add(new InternetMessageHeader(sHeaderKey, sHeaderValue));
			}
			if ( gEMAIL_ID != Guid.Empty )
			{
				msg.SingleValueExtendedProperties = new List<SingleValueLegacyExtendedProperty>();
				// 07/19/2018 Paul.  Send does not return an message ID, so we need to set an extended property, then retrieve it later. 
				string sPropertyId = "String {" + ExchangeUtils.SPLENDIDCRM_PROPERTY_SET_ID.ToString() + "} Name " + ExchangeUtils.SPLENDIDCRM_PROPERTY_NAME;
				msg.SingleValueExtendedProperties.Add(new SingleValueLegacyExtendedProperty(sPropertyId, gEMAIL_ID.ToString()));
			}
			long lTotalAttachmentSize = 0;
			foreach ( System.Net.Mail.Attachment attachment in mail.Attachments )
			{
				lTotalAttachmentSize += attachment.ContentStream.Length;
			}
			if ( lTotalAttachmentSize < 3 * 1024 * 1024 )
			{
				foreach ( System.Net.Mail.Attachment attachment in mail.Attachments )
				{
					// 03/01/2021 Paul.  initialize the attachment list. 
					if ( msg.Attachments == null )
					{
						msg.Attachments = new List<Spring.Social.Office365.Api.Attachment>();
					}
					// https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http
					msg.Attachments.Add(new Spring.Social.Office365.Api.Attachment(attachment.Name, attachment.ContentType.ToString(), attachment.ContentStream));
				}
				service.MailOperations.SendMail(msg);
			}
			else
			{
				msg = service.MailOperations.Create(msg);
				foreach ( System.Net.Mail.Attachment attachment in mail.Attachments )
				{
					Spring.Social.Office365.Api.Attachment att = new Spring.Social.Office365.Api.Attachment(attachment.Name, attachment.ContentType.ToString(), attachment.ContentStream);
					service.MailOperations.AddAttachment(msg.Id, att);
				}
				service.MailOperations.Send(msg.Id);
			}
		}
	}
}
