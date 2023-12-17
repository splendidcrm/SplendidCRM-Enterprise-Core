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
using System.Diagnostics;

using Microsoft.Exchange.WebServices.Data;

namespace SplendidCRM
{
	public class SplendidMailExchangePassword : SplendidMailClient
	{
		private HttpApplicationState Application        = new HttpApplicationState();
		private Security             Security           ;

		private string sSERVER_URL;
		private string sUSER_NAME ;
		private string sPASSWORD  ;

		public SplendidMailExchangePassword(Security Security)
		{
			this.Security            = Security           ;

			this.sSERVER_URL = Sql.ToString(Application["CONFIG.Exchange.ServerURL"]);
			this.sUSER_NAME  = Sql.ToString(Application["CONFIG.smtpuser"          ]);
			this.sPASSWORD   = Sql.ToString(Application["CONFIG.smtppass"          ]);
			// 02/06/2017 Paul.  Password must be decrypted before use. 
			if ( !Sql.IsEmptyString(sPASSWORD) )
				sPASSWORD = Security.DecryptPassword(sPASSWORD);
		}

		public SplendidMailExchangePassword(string sSERVER_URL, string sUSER_NAME, string sPASSWORD)
		{
			this.sSERVER_URL = sSERVER_URL;
			this.sUSER_NAME  = sUSER_NAME ;
			this.sPASSWORD   = sPASSWORD  ;
		}

		override public void Send(MailMessage mail)
		{
			ExchangeVersion version = ExchangeVersion.Exchange2013_SP1;
			switch ( Sql.ToString(Application["CONFIG.Exchange.Version"]) )
			{
				case "Exchange2007_SP1":  version = ExchangeVersion.Exchange2007_SP1;  break;
				case "Exchange2010"    :  version = ExchangeVersion.Exchange2010    ;  break;
				case "Exchange2010_SP1":  version = ExchangeVersion.Exchange2010_SP1;  break;
				// 06/23/2015 Paul.  Add Exchange versions. 
				case "Exchange2010_SP2":  version = ExchangeVersion.Exchange2010_SP2;  break;
				case "Exchange2013"    :  version = ExchangeVersion.Exchange2013    ;  break;
				case "Exchange2013_SP1":  version = ExchangeVersion.Exchange2013_SP1;  break;
			}
			ExchangeService service = new ExchangeService(version, TimeZoneInfo.Utc);
			// 04/15/2018 Paul.  If impersonation is enabled, then the USER_NAME will contain the principal name and the password will be blank. 
			string sIMPERSONATED_TYPE   = Sql.ToString (Application["CONFIG.Exchange.ImpersonatedType" ]);
			if ( !Sql.IsEmptyString(sUSER_NAME) && !Sql.IsEmptyString(sPASSWORD) )
			{
				string[] arrUSER_NAME = sUSER_NAME.Split('\\');
				if ( arrUSER_NAME.Length > 1 )
					service.Credentials = new WebCredentials(arrUSER_NAME[1], sPASSWORD, arrUSER_NAME[0]);
				else
					service.Credentials = new WebCredentials(sUSER_NAME, sPASSWORD, String.Empty);
			}
			else
			{
				service.UseDefaultCredentials = true;
				string sEXCHANGE_EMAIL = mail.From.Address;
				if ( sIMPERSONATED_TYPE == "SmtpAddress" && !Sql.IsEmptyString(sEXCHANGE_EMAIL) )
					service.ImpersonatedUserId = new ImpersonatedUserId(ConnectingIdType.SmtpAddress  , sEXCHANGE_EMAIL);
				// 03/31/2010 Paul.  We don't need to impersonate if the alias is the same as the user. 
				else if ( sIMPERSONATED_TYPE == "PrincipalName" )
				{
					if ( Sql.ToString (Application["CONFIG.Exchange.UserName"]) != sUSER_NAME && !Sql.IsEmptyString(sUSER_NAME) )
						service.ImpersonatedUserId = new ImpersonatedUserId(ConnectingIdType.PrincipalName, sUSER_NAME);
				}
			}
			if ( sSERVER_URL.ToLower().StartsWith("autodiscover") && !Sql.IsEmptyString(sUSER_NAME) )
			{
				service.AutodiscoverUrl(sUSER_NAME, delegate (String redirectionUrl)
				{
					return redirectionUrl.ToLower().StartsWith("https://");
				});
			}
			else
			{
				service.Url = new Uri(sSERVER_URL);
			}
			
			EmailMessage msg = new EmailMessage(service);
			msg.Subject = mail.Subject;
			msg.Body    = mail.Body   ;
			msg.From    = new EmailAddress(mail.From.DisplayName, mail.From.Address);
			foreach ( MailAddress to in mail.To )
			{
				msg.ToRecipients.Add(new EmailAddress(to.DisplayName, to.Address));
			}
			foreach ( MailAddress to in mail.CC )
			{
				msg.CcRecipients.Add(new EmailAddress(to.DisplayName, to.Address));
			}
			foreach ( MailAddress to in mail.Bcc )
			{
				msg.BccRecipients.Add(new EmailAddress(to.DisplayName, to.Address));
			}
			// 07/19/2018 Paul.  Pull the Email ID from the headers as it is already being provided. 
			Guid gEMAIL_ID = Guid.Empty;
			for ( int iHeader = 0; iHeader < mail.Headers.Count; iHeader++ )
			{
				string sHeaderKey   = mail.Headers.GetKey(iHeader);
				string sHeaderValue = mail.Headers.Get   (iHeader);
				if ( sHeaderKey == "X-SplendidCRM-ID" )
					gEMAIL_ID = Sql.ToGuid(sHeaderValue);
				ExtendedPropertyDefinition headerProperty = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.InternetHeaders, sHeaderKey, MapiPropertyType.String);
				PropertySet columns = new PropertySet(BasePropertySet.IdOnly, EmailMessageSchema.InternetMessageId, headerProperty);
				msg.SetExtendedProperty(headerProperty, sHeaderValue);
			}
			foreach ( System.Net.Mail.Attachment attachment in mail.Attachments )
			{
				// https://msdn.microsoft.com/en-us/library/office/dn726694(v=exchg.150).aspx
				msg.Attachments.AddFileAttachment(attachment.Name, attachment.ContentStream);
			}
			if ( gEMAIL_ID != Guid.Empty )
			{
				// 07/19/2018 Paul.  Send does not return an message ID, so we need to set an extended property, then retrieve it later. 
				ExtendedPropertyDefinition splendidProperty = new ExtendedPropertyDefinition(ExchangeUtils.SPLENDIDCRM_PROPERTY_SET_ID, ExchangeUtils.SPLENDIDCRM_PROPERTY_NAME, MapiPropertyType.String);
				msg.SetExtendedProperty(splendidProperty, gEMAIL_ID.ToString());
			}
			msg.SendAndSaveCopy();
		}
	}
}
