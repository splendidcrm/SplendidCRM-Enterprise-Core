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
using System.Text;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Net;
using System.Net.Security;
using System.Web;
using System.Xml;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;

using Spring.Social.Office365;

namespace SplendidCRM
{
	public class Office365Utils
	{
		private HttpApplicationState Application        = new HttpApplicationState();
		private SplendidDefaults     SplendidDefaults    = new SplendidDefaults();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private MimeUtils            MimeUtils          ;
		private ActiveDirectory      ActiveDirectory    ;
		private SyncError            SyncError          ;
		private Crm.NoteAttachments  NoteAttachments    ;
		private Office365Sync        Office365Sync      ;

		public Office365Utils(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, MimeUtils MimeUtils, ActiveDirectory ActiveDirectory, SyncError SyncError, SplendidCRM.Crm.NoteAttachments NoteAttachments, Office365Sync Office365Sync)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.MimeUtils           = MimeUtils          ;
			this.ActiveDirectory     = ActiveDirectory    ;
			this.SyncError           = SyncError          ;
			this.NoteAttachments     = NoteAttachments    ;
			this.Office365Sync       = Office365Sync      ;
		}

		public Dictionary<Guid, string> dictInboundSubscriptions = new Dictionary<Guid, string>();

		// 12/13/2020 Paul.  Move Office365 methods to Office365utils. 
		public void SendTestMessage(Guid gUSER_ID, string sFromAddress, string sFromName, string sToAddress, string sToName)
		{
			SplendidMailOffice365 client = new SplendidMailOffice365(Office365Sync, gUSER_ID);
			
			System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
			System.Net.Mail.MailAddress addr = null;
			if ( Sql.IsEmptyString(sFromName) )
				mail.From = new System.Net.Mail.MailAddress(sFromAddress);
			else
				mail.From = new System.Net.Mail.MailAddress(sFromAddress, sFromName);
			// 04/06/2021 Paul.  Should be testing for empty sToName. 
			if ( Sql.IsEmptyString(sToName) )
				addr = new System.Net.Mail.MailAddress(sToAddress);
			else
				addr = new System.Net.Mail.MailAddress(sToAddress, sToName);
			mail.To.Add(addr);
			mail.Subject = "SplendidCRM Office 365 Test Email " + DateTime.Now.ToString();
			mail.Body    = "This is a test.";
			// 12/13/2020 Paul.  Add to test ability to get message ID. 
			mail.Headers.Add("X-SplendidCRM-ID", (Guid.NewGuid()).ToString());
			client.Send(mail);
		}

		// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
		public bool ValidateExchange(string sOAuthDirectoryTenatID, string sOAuthClientID, string sOAuthClientSecret, Guid gUSER_ID, string sMAILBOX, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, gUSER_ID, false);
				// 02/10/2017 Paul.  https://outlook.office.com/EWS/Exchange.asmx does not work. 
				string sSERVER_URL = "https://outlook.office365.com/EWS/Exchange.asmx";
				if ( !Sql.IsEmptyString(sSERVER_URL) )
				{
					/*
					ExchangeVersion version = ExchangeVersion.Exchange2013_SP1;
					ExchangeService service = new ExchangeService(version, TimeZoneInfo.Utc);
					// How to: Authenticate an EWS application by using OAuth
					// https://msdn.microsoft.com/en-us/library/office/dn903761(v=exchg.150).aspx
					service.Credentials = new OAuthCredentials(token.access_token);
					
					// 08/30/2013 Paul.  Office365 requires that we use auto-discover to get the server URL. 
					//if ( sSERVER_URL.ToLower().StartsWith("autodiscover") && !Sql.IsEmptyString(sUSER_NAME) )
					//{
					//	service.AutodiscoverUrl(sUSER_NAME, delegate (String redirectionUrl)
					//	{
					//		return (redirectionUrl == "https://autodiscover-s.outlook.com/autodiscover/autodiscover.xml");
					//	});
					//	sbErrors.AppendLine("Using AutodiscoverURL: " + service.Url + ".  ");
					//}
					//else
					{
						service.Url = new Uri(sSERVER_URL);
					}
					*/
					Spring.Social.Office365.Api.IOffice365 office365 = Office365Sync.CreateApi(token.access_token);
					int nUnreadCount = office365.MailOperations.GetInboxUnreadCount();
					office365.ContactOperations.GetCount();
					office365.EventOperations.GetCount();

					// 10/28/2022 Paul.  Mailbox may include subfolders. 
					IList<Spring.Social.Office365.Api.MailFolder> fResults = office365.FolderOperations.GetAll(sMAILBOX);
					if ( fResults.Count > 0 )
					{
						Spring.Social.Office365.Api.MailFolder fld =  fResults[0];
						int nTotalCount = fld.TotalItemCount;
						// 08/09/2018 Paul.  Allow translation of connection success. 
						string sCULTURE = Sql.ToString(Application["CONFIG.default_language"]);
						if ( Session != null )
							sCULTURE = Sql.ToString (Session["USER_SETTINGS/CULTURE"]);
						sbErrors.AppendLine(String.Format(L10N.Term(Application, sCULTURE, "Users.LBL_CONNECTION_SUCCESSFUL"), nTotalCount.ToString(), sMAILBOX));
						//sbErrors.AppendLine("Connection successful. " + nTotalCount.ToString() + " items in " + sMAILBOX + "<br />");
						bValidSource = true;
					}
					else
					{
						sbErrors.AppendLine("Could not find folder " + sMAILBOX);
						bValidSource = true;
					}
				}
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		public void GetMessage(Guid gMAILBOX_ID, string sUNIQUE_ID, ref string sNAME, ref string sFROM_ADDR, ref bool bIS_READ, ref int nSIZE)
		{
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"         ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"     ]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gMAILBOX_ID, false);
			Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(token.access_token);

			Spring.Social.Office365.Api.Message message = service.MailOperations.GetById(sUNIQUE_ID, "id,subject,body,from,isread");
			if ( message != null )
			{
				sNAME = Sql.ToString(message.Subject);
				if ( message.From != null )
				{
					sFROM_ADDR = Sql.ToString(message.From.EmailAddress.Address).ToLower();
				}
				bIS_READ = (message.IsRead.HasValue ? message.IsRead.Value : false);
				nSIZE    = message.Size  ;
			}
		}

		public void MarkAsUnread(Guid gMAILBOX_ID, string sUNIQUE_ID)
		{
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"         ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"     ]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gMAILBOX_ID, false);
			Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(token.access_token);

			service.MailOperations.MarkAsUnread(sUNIQUE_ID);
		}

		public DataTable GetFolderMessages(Spring.Social.Office365.Office365Sync.UserSync User, string sFOLDER_ID, int nPageSize, int nPageOffset, string sSortColumn, string sSortOrder)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"         ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"     ]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, User.USER_ID, false);
			Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(token.access_token);

			string sort = String.Empty;
			if ( !Sql.IsEmptyString(sSortColumn) )
			{
				sort = "lastModifiedDateTime";
				switch ( sSortColumn )
				{
					case "FROM"      :  sort = "from/emailAddress/name " + sSortOrder + ",from/emailAddress/address" + sSortOrder;  break;
					case "NAME"      :  sort = "subject "                + sSortOrder;  break;
					case "DATE_START":  sort = "sentDateTime "           + sSortOrder;  break;
					//case "TO_ADDRS"  :  sort = EmailMessageSchema.DisplayTo   ;  break;
					//case "SIZE"      :  sort = EmailMessageSchema.Size        ;  break;
				}
			}
			
			// 10/28/2022 Paul.  Change name to reflect function.  The entire message is not returned, just the ids. 
			Spring.Social.Office365.Api.MessagePagination results = service.FolderOperations.GetMessageIds(sFOLDER_ID, String.Empty, sort, nPageOffset, nPageSize);
			for ( int i = 0; i < results.messages.Count; i++ )
			{
				Spring.Social.Office365.Api.Message email = service.MailOperations.GetById(results.messages[i].Id);

				DataRow row = dt.NewRow();
				dt.Rows.Add(row);
				double dSize = email.Size;
				string sSize = String.Empty;
				if ( dSize < 1024 )
					sSize = dSize.ToString() + " B";
				else if ( dSize < 1024 * 1024 )
					sSize = Math.Floor(dSize / 1024).ToString() + " KB";
				else
					sSize = Math.Floor(dSize / (1024 * 1024)).ToString() + " MB";
					
				row["ID"             ] = Guid.NewGuid().ToString().Replace('-', '_');
				row["UNIQUE_ID"      ] = Sql.ToDBString(email.Id               );
				row["SIZE"           ] = Sql.ToDBDouble(dSize                  );
				row["SIZE_STRING"    ] = Sql.ToDBString(sSize                  );
				// 10/28/2022 Paul.  IsRead is bool?, but we cannot field to null.  Must use DBNull. 
				row["IS_READ"        ] = (email.IsRead.HasValue ? (object) email.IsRead.Value : DBNull.Value);
				row["TO_ADDRS"       ] = Sql.ToDBString(email.DisplayTo        );
				row["CC_ADDRS"       ] = Sql.ToDBString(email.DisplayCc        );
				row["NAME"           ] = Sql.ToDBString(email.Subject          );
				row["MESSAGE_ID"     ] = Sql.ToDBString(email.InternetMessageId);
				// 01/18/2021 Paul.  DateTimeOffice already has a LocalDateTime variable. 
				row["DATE_START"     ] = (email.LastModifiedDateTime.HasValue ? (object) email.LastModifiedDateTime.Value.LocalDateTime : DBNull.Value);
				row["DATE_MODIFIED"  ] = (email.LastModifiedDateTime.HasValue ? (object) email.LastModifiedDateTime.Value.LocalDateTime : DBNull.Value);
				row["DATE_ENTERED"   ] = (email.CreatedDateTime     .HasValue ? (object) email.CreatedDateTime     .Value.LocalDateTime : DBNull.Value);
				//row["DateTimeReceived"] = email.DateTimeReceived.ToLocalTime();
				row["CATEGORIES"     ] = (email.Categories          != null   ? (object) email.Categories          .ToString()          : DBNull.Value);
				//row["BodyType"       ] = email.Body.BodyType   .ToString();
				// 10/28/2022 Paul. InternetMessageHeaders are provided by Office365. 
				if ( email.InternetMessageHeaders != null )
				{
					StringBuilder sbHeaders = new StringBuilder();
					foreach ( Spring.Social.Office365.Api.InternetMessageHeader prop in email.InternetMessageHeaders )
					{
						sbHeaders.AppendLine(prop.Name + ": " + prop.Value);
					}
					row["INTERNET_HEADERS"] = sbHeaders.ToString();
				}

				//row["DESCRIPTION"     ] = email.Body.Text                        ;
				if ( email.From != null )
				{
					string sFrom = email.From.ToString();
					row["FROM"      ] = Sql.ToDBString(sFrom                          );
					row["FROM_ADDR" ] = Sql.ToDBString(email.From.EmailAddress.Address);
					row["FROM_NAME" ] = Sql.ToDBString(email.From.EmailAddress.Name   );
					if ( email.IsFromMe(User.EXCHANGE_EMAIL) )
						row["DATE_START"] = email.DateTimeSent.ToLocalTime();
					else
						row["DATE_START"] = email.DateTimeReceived.ToLocalTime();
				}
				// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
				// 01/24/2017 Paul.  email.Attachments is empty.  
				row["HAS_ATTACHMENTS"] = (email.HasAttachments.HasValue ? (object) email.HasAttachments : DBNull.Value);
			}
			nPageOffset += nPageSize;
			return dt;
		}

		public string GetFolderId(string sUSERNAME, string sPASSWORD, Guid gMAILBOX_ID, string sMAILBOX)
		{
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"         ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"     ]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gMAILBOX_ID, false);
			Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(token.access_token);

			Spring.Social.Office365.Api.MailFolder fldExchangeRoot = service.FolderOperations.GetWellKnownFolder("msgfolderroot");
			IList<Spring.Social.Office365.Api.MailFolder> fResults = service.FolderOperations.GetChildFolders(fldExchangeRoot.Id, sMAILBOX);
			if ( fResults.Count > 0 )
			{
				return fResults[0].Id;
			}
			return String.Empty;
		}

		public DataTable GetFolderMessages(string sUSERNAME, string sPASSWORD, Guid gMAILBOX_ID, string sMAILBOX, bool bONLY_SINCE, string sEXCHANGE_WATERMARK)
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("UNIQUE_ID"         , typeof(System.String));
			dt.Columns.Add("EXCHANGE_WATERMARK", typeof(System.String));
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"         ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"     ]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			int    nPageSize            = Sql.ToInteger(Application["CONFIG.Exchange.Messages.PageSize"]);
			if ( nPageSize <= 0 )
				nPageSize = 100;
			// 01/11/2021 Paul.  Some people may leave thousands of messages in their Inbox or SentItems folder.  Try to limit the import. 
			int  nMESSAGE_AGE_DAYS = Sql.ToInteger(Application["CONFIG.Exchange.MessageAgeDays" ]);
			if ( nMESSAGE_AGE_DAYS == 0 )
				nMESSAGE_AGE_DAYS = 7;
			DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.UtcNow.AddDays(-nMESSAGE_AGE_DAYS);
			Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gMAILBOX_ID, false);
			Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(token.access_token);
			
			// 01/28/2017 Paul.  Only Since flag means that we only track changes. 
			// 12/15/2020 Paul.  https://docs.microsoft.com/en-us/graph/delta-query-messages#example-to-synchronize-messages-in-a-folder
			if ( bONLY_SINCE )
			{
				string sFolderID = String.Empty;
				if ( !dictInboundSubscriptions.ContainsKey(gMAILBOX_ID) )
				{
					Spring.Social.Office365.Api.MailFolder fldExchangeRoot = service.FolderOperations.GetWellKnownFolder("msgfolderroot");
					IList<Spring.Social.Office365.Api.MailFolder> fResults = service.FolderOperations.GetChildFolders(fldExchangeRoot.Id, sMAILBOX);
					if ( fResults.Count > 0 )
					{
						sFolderID = fResults[0].Id;
						dictInboundSubscriptions.Add(gMAILBOX_ID, sFolderID);
					}
				}
				else
				{
					sFolderID = dictInboundSubscriptions[gMAILBOX_ID];
				}
				if ( !Sql.IsEmptyString(sFolderID) )
				{
					Spring.Social.Office365.Api.MessagePagination results = null;
					do
					{
						// 01/28/2017 Paul.  The Pull.Watermark changes with each call to GetEvents. 
						results = service.FolderOperations.GetMessagesDelta(sFolderID, sEXCHANGE_WATERMARK, nPageSize);
						if ( !Sql.IsEmptyString(results.nextLink) )
						{
							sEXCHANGE_WATERMARK = results.nextLink.Split('?')[1];
						}
						else if ( !Sql.IsEmptyString(results.deltaLink) )
						{
							sEXCHANGE_WATERMARK = results.deltaLink.Split('?')[1];
						}
						foreach ( Spring.Social.Office365.Api.Message email in results.messages )
						{
							// 01/11/2021 Paul.  Some people may leave thousands of messages in their Inbox or SentItems folder.  Try to limit the import. 
							if ( email.CreatedDateTime.Value.DateTime.ToUniversalTime() > dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC )
							{
								DataRow row = dt.NewRow();
								dt.Rows.Add(row);
								row["UNIQUE_ID"         ] = email.Id           ;
								row["EXCHANGE_WATERMARK"] = sEXCHANGE_WATERMARK;
							}
						}
					}
					while ( results != null && !Sql.IsEmptyString(results.nextLink) );
				}
			}
			else
			{
				Spring.Social.Office365.Api.MailFolder fldExchangeRoot = service.FolderOperations.GetWellKnownFolder("msgfolderroot");
				IList<Spring.Social.Office365.Api.MailFolder> fResults = service.FolderOperations.GetChildFolders(fldExchangeRoot.Id, sMAILBOX);
				if ( fResults.Count > 0 )
				{
					Spring.Social.Office365.Api.MailFolder fld = fResults[0];
					int nPageOffset = 0;
					string sFOLDER_ID = fld.Id;
					while ( nPageOffset < fld.TotalItemCount )
					{
						string sort = "sentDateTime asc";
						// 10/28/2022 Paul.  Change name to reflect function.  The entire message is not returned, just the ids. 
						Spring.Social.Office365.Api.MessagePagination results = service.FolderOperations.GetMessageIds(sFOLDER_ID, String.Empty, sort, nPageOffset, nPageSize);
						foreach ( Spring.Social.Office365.Api.Message email in results.messages )
						{
							DataRow row = dt.NewRow();
							dt.Rows.Add(row);
							row["UNIQUE_ID"] = email.Id;
						}
						nPageOffset += results.messages.Count;
					}
				}
				else
				{
					throw(new Exception("Could not find folder " + sMAILBOX + " for Mailbox " + gMAILBOX_ID.ToString()));
				}
			}
			return dt;
		}

		public string NormalizeInternetAddressName(Spring.Social.Office365.Api.Recipient recipient)
		{
			Spring.Social.Office365.Api.EmailAddress addr = recipient.EmailAddress;
			string sDisplayName = addr.Name;
			if ( Sql.IsEmptyString(sDisplayName) )
				sDisplayName = addr.Address;
			else if ( sDisplayName.StartsWith("\"") && sDisplayName.EndsWith("\"") || sDisplayName.StartsWith("\'") && sDisplayName.EndsWith("\'") )
				sDisplayName = sDisplayName.Substring(1, sDisplayName.Length-2);
			return sDisplayName;
		}

		public void BuildAddressList(Spring.Social.Office365.Api.Recipient addr, StringBuilder sbTO_ADDRS, StringBuilder sbTO_ADDRS_NAMES, StringBuilder sbTO_ADDRS_EMAILS)
		{
			sbTO_ADDRS.Append((sbTO_ADDRS.Length > 0) ? "; " : String.Empty);
			sbTO_ADDRS.Append(addr.ToString());
			
			sbTO_ADDRS_NAMES.Append((sbTO_ADDRS_NAMES.Length > 0) ? "; " : String.Empty);
			sbTO_ADDRS_NAMES.Append(NormalizeInternetAddressName(addr));
			
			sbTO_ADDRS_EMAILS.Append((sbTO_ADDRS_EMAILS.Length > 0) ? "; " : String.Empty);
			sbTO_ADDRS_EMAILS.Append(addr.EmailAddress.Address);
		}

		public Guid FindTargetTrackerKey(Spring.Social.Office365.Api.Message email, string sHtmlBody, string sTextBody)
		{
			Guid gTARGET_TRACKER_KEY = Guid.Empty;
			if ( email.InternetMessageHeaders != null )
			{
				foreach ( Spring.Social.Office365.Api.InternetMessageHeader prop in email.InternetMessageHeaders )
				{
					if ( prop.Name == "X-SplendidCRM-ID" )
					{
						gTARGET_TRACKER_KEY = Sql.ToGuid(prop.Value);
					}
				}
			}
			if ( Sql.IsEmptyGuid(gTARGET_TRACKER_KEY) )
			{
				// 01/13/2008 Paul.  Now look for a RemoveMe tracker, or any of the other expected trackers. 
				if ( !Sql.IsEmptyString(sHtmlBody) )
				{
					foreach ( string sTracker in MimeUtils.arrTrackers )
					{
						int nStartTracker = sHtmlBody.IndexOf(sTracker);
						if ( nStartTracker > 0 )
						{
							nStartTracker += sTracker.Length;
							gTARGET_TRACKER_KEY = Sql.ToGuid(sHtmlBody.Substring(nStartTracker, 36));
							if ( !Sql.IsEmptyGuid(gTARGET_TRACKER_KEY) )
								return gTARGET_TRACKER_KEY;
						}
					}
				}
				if ( !Sql.IsEmptyString(sTextBody) )
				{
					foreach ( string sTracker in MimeUtils.arrTrackers )
					{
						int nStartTracker = sTextBody.IndexOf(sTracker);
						if ( nStartTracker > 0 )
						{
							nStartTracker += sTracker.Length;
							gTARGET_TRACKER_KEY = Sql.ToGuid(sTextBody.Substring(nStartTracker, 36));
							if ( !Sql.IsEmptyGuid(gTARGET_TRACKER_KEY) )
								return gTARGET_TRACKER_KEY;
						}
					}
				}
			}
			return gTARGET_TRACKER_KEY;
		}

		public string EmbedInlineImages(Spring.Social.Office365.Api.Message email, string sDESCRIPTION_HTML)
		{
			// 01/21/2017 Paul.  Instead of saving the image as a separate record, save as data in the HTML. 
			// https://github.com/jstedfast/MimeKit/issues/134
			if ( email.Attachments != null && email.Attachments.Count > 0 )
			{
				foreach ( Spring.Social.Office365.Api.Attachment attach in email.Attachments )
				{
					bool bInline = attach.ContentId != null && attach.ContentType.StartsWith("image") && (sDESCRIPTION_HTML.IndexOf("cid:" + attach.ContentId) >= 0);
					if ( bInline )
					{
						Spring.Social.Office365.Api.Attachment part = attach;
						//part.Load();
						if ( part.ContentBytes != null )
						{
							string imageBase64 = "data:" + part.ContentType + ";base64," + Convert.ToBase64String(part.ContentBytes);
							sDESCRIPTION_HTML = sDESCRIPTION_HTML.Replace("cid:" + part.ContentId, imageBase64);
						}
					}
				}
			}
			return sDESCRIPTION_HTML;
		}

		public Guid ImportInboundEmail(IDbConnection con, Guid gMAILBOX_ID, string sINTENT, Guid gGROUP_ID, Guid gGROUP_TEAM_ID, string sUNIQUE_ID, string sUNIQUE_MESSAGE_ID, string sEXCHANGE_EMAIL)
		{
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"         ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"     ]);
			int    nPageSize            = Sql.ToInteger(Application["CONFIG.Exchange.Messages.PageSize"]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gMAILBOX_ID, false);
			Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(token.access_token);

			bool bLoadSuccessful = false;
			Spring.Social.Office365.Api.Message email = null;
			string sDESCRIPTION = String.Empty;
			try
			{
				email = service.MailOperations.GetById(sUNIQUE_ID);
				if ( email != null )
				{
					if ( email.Body != null )
					sDESCRIPTION = email.Body.Content;
					bLoadSuccessful = true;
				}
			}
			catch(Exception ex)
			{
				string sError = "Error loading Exchange email for " + gMAILBOX_ID.ToString() + ", " + sUNIQUE_ID + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
			// 09/04/2011 Paul.  Return the email ID so that we can use this method with the Chrome Extension. 
			Guid gEMAIL_ID = Guid.Empty;
			if ( bLoadSuccessful )
			{
				try
				{
					string sEMAIL_TYPE = "inbound";
					string sSTATUS     = "unread";
					// 07/30/2008 Paul.  Lookup the default culture. 
					string sCultureName   = SplendidDefaults.Culture();
					long   lUploadMaxSize = Sql.ToLong(Application["CONFIG.upload_maxsize"]);
					
					DateTime dtREMOTE_DATE_MODIFIED_UTC = email.LastModifiedDateTime.Value.UtcDateTime;
					DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
					string sFROM_ADDR = String.Empty;
					string sFROM_NAME = String.Empty;
					if ( email.From != null )
					{
						sFROM_ADDR = email.From.EmailAddress.Address;
						sFROM_NAME = NormalizeInternetAddressName(email.From);
					}
					
					// 01/28/2017 Paul.  Save ReplyTo if it is available. 
					string sREPLY_TO_ADDR = String.Empty;
					string sREPLY_TO_NAME = String.Empty;
					if ( email.ReplyTo != null && email.ReplyTo.Count > 0 )
					{
						foreach ( Spring.Social.Office365.Api.Recipient addr in email.ReplyTo )
						{
							sREPLY_TO_NAME = NormalizeInternetAddressName(addr);
							sREPLY_TO_ADDR = addr.EmailAddress.Address;
							break;
						}
					}
					
					StringBuilder sbTO_ADDRS        = new StringBuilder();
					StringBuilder sbTO_ADDRS_NAMES  = new StringBuilder();
					StringBuilder sbTO_ADDRS_EMAILS = new StringBuilder();
					if ( email.ToRecipients != null && email.ToRecipients.Count > 0 )
					{
						foreach ( Spring.Social.Office365.Api.Recipient addr in email.ToRecipients )
						{
							BuildAddressList(addr, sbTO_ADDRS, sbTO_ADDRS_NAMES, sbTO_ADDRS_EMAILS);
						}
					}
					
					StringBuilder sbCC_ADDRS        = new StringBuilder();
					StringBuilder sbCC_ADDRS_NAMES  = new StringBuilder();
					StringBuilder sbCC_ADDRS_EMAILS = new StringBuilder();
					if ( email.CcRecipients != null && email.CcRecipients.Count > 0 )
					{
						foreach ( Spring.Social.Office365.Api.Recipient addr in email.CcRecipients )
						{
							BuildAddressList(addr, sbTO_ADDRS, sbTO_ADDRS_NAMES, sbTO_ADDRS_EMAILS);
						}
					}
					
					StringBuilder sbBCC_ADDRS        = new StringBuilder();
					StringBuilder sbBCC_ADDRS_NAMES  = new StringBuilder();
					StringBuilder sbBCC_ADDRS_EMAILS = new StringBuilder();
					if ( email.BccRecipients != null && email.BccRecipients.Count > 0 )
					{
						foreach ( Spring.Social.Office365.Api.Recipient addr in email.BccRecipients )
						{
							BuildAddressList(addr, sbTO_ADDRS, sbTO_ADDRS_NAMES, sbTO_ADDRS_EMAILS);
						}
					}
					
					// 01/21/2017 Paul.  Only get the body values once as they may be computed. 
					// http://www.mimekit.net/docs/html/WorkingWithMessages.htm
					string sTextBody = sDESCRIPTION;
					string sHtmlBody = sDESCRIPTION;
					// 01/13/2008 Paul.  First look for our special header. 
					// Our special header will only exist if the email is a bounce. 
					Guid gTARGET_TRACKER_KEY = Guid.Empty;
					// 01/13/2008 Paul.  The header will always be in lower case. 
					gTARGET_TRACKER_KEY = FindTargetTrackerKey(email, sHtmlBody, sTextBody);
					// 01/20/2008 Paul.  mm.DeliveredTo can be NULL. 
					// 01/20/2008 Paul.  Filter the XSS tags before inserting the email. 
					// 01/23/2008 Paul.  DateTime in the email is in universal time. 
				
					string sSAFE_BODY_PLAIN = EmailUtils.XssFilter(sTextBody, Sql.ToString(Application["CONFIG.email_xss"]));
					string sSAFE_BODY_HTML  = EmailUtils.XssFilter(sHtmlBody, Sql.ToString(Application["CONFIG.email_xss"]));
					sSAFE_BODY_HTML = EmbedInlineImages(email, sSAFE_BODY_HTML);
					
					// 01/28/2017 Paul.  Exchange does not store raw content, so getting it would be an expensive operation. 
					// https://msdn.microsoft.com/en-us/library/office/hh545614(v=exchg.140).aspx
					string sRawContent = String.Empty;
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spEMAILS_InsertInbound
								( ref gEMAIL_ID
								, gGROUP_ID
								, email.Subject
								, email.IsFromMe(sEXCHANGE_EMAIL) ? email.DateTimeSent.ToLocalTime() : email.DateTimeReceived.ToLocalTime()
								, sSAFE_BODY_PLAIN
								, sSAFE_BODY_HTML
								, sFROM_ADDR
								, sFROM_NAME
								, sbTO_ADDRS.ToString()
								, sbCC_ADDRS.ToString()
								, sbBCC_ADDRS.ToString()
								, sbTO_ADDRS_NAMES  .ToString()
								, sbTO_ADDRS_EMAILS .ToString()
								, sbCC_ADDRS_NAMES  .ToString()
								, sbCC_ADDRS_EMAILS .ToString()
								, sbBCC_ADDRS_NAMES .ToString()
								, sbBCC_ADDRS_EMAILS.ToString()
								, sEMAIL_TYPE
								, sSTATUS
								// 09/04/2011 Paul.  In order to prevent duplicate emails, we need to use the unique message ID. 
								, sUNIQUE_MESSAGE_ID  // mm.MessageId + ((mm.DeliveredTo != null && mm.DeliveredTo.Address != null) ? mm.DeliveredTo.Address : String.Empty)
								// 07/24/2010 Paul.  ReplyTo is obsolete in .NET 4.0. 
								// 01/28/2017 Paul.  Save ReplyTo if it is available. 
								, sREPLY_TO_ADDR
								, sREPLY_TO_NAME
								, sINTENT
								, gMAILBOX_ID
								, gTARGET_TRACKER_KEY
								, sRawContent
								// 01/28/2017 Paul.  Use new GROUP_TEAM_ID value associated with InboundEmail record. 
								, gGROUP_TEAM_ID
								, trn
								);
							
							if ( email.Attachments != null && email.Attachments.Count > 0 )
							{
								foreach ( Spring.Social.Office365.Api.Attachment attach in email.Attachments )
								{
									// 01/28/2017 Paul.  Don't use sSAFE_BODY_HTML here because the content items will have already been replaced and would fail the inline test. 
									bool bInline = attach.ContentId != null && attach.ContentType.StartsWith("image") && (sHtmlBody.IndexOf("cid:" + attach.ContentId) >= 0);
									if ( !bInline )
									{
										Spring.Social.Office365.Api.Attachment file = attach;
										//file.Load();
										if ( file.ContentBytes != null )
										{
											// 04/01/2010 Paul.  file.Size is only available on Exchange 2010. 
											long lFileSize = file.ContentBytes.Length;  // file.Size;
											if ( (lUploadMaxSize == 0) || (lFileSize <= lUploadMaxSize) )
											{
												string sFILENAME       = String.Empty;
												string sFILE_MIME_TYPE = file.ContentType;
												try
												{
													if ( !String.IsNullOrEmpty(file.Name) )
														sFILENAME = Path.GetFileName(file.Name);
													else
														sFILENAME = Path.GetFileName(file.Name);
												}
												catch
												{
													sFILENAME = Path.GetFileName(file.Name);
												}
												string sFILE_EXT = Path.GetExtension(sFILENAME);
												
												Guid gNOTE_ID = Guid.Empty;
												// 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
												SqlProcs.spNOTES_Update
													( ref gNOTE_ID
													, L10N.Term(Application, sCultureName, "Emails.LBL_EMAIL_ATTACHMENT") + ": " + sFILENAME
													, "Emails"       // PARENT_TYPE
													, gEMAIL_ID      // PARENT_ID
													, Guid.Empty     // CONTACT_ID
													, Sql.ToString(file.ContentId)   // DESCRIPTION
													// 01/28/2017 Paul.  Use new GROUP_TEAM_ID value associated with InboundEmail record. 
													, gGROUP_TEAM_ID // TEAM_ID
													, String.Empty   // TEAM_SET_LIST
													, gGROUP_ID      // ASSIGNED_USER_ID
													// 05/17/2017 Paul.  Add Tags module. 
													, String.Empty   // TAG_SET_NAME
													// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
													, false          // IS_PRIVATE
													// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
													, String.Empty   // ASSIGNED_SET_LIST
													, trn
													);
											
												Guid gNOTE_ATTACHMENT_ID = Guid.Empty;
												SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, file.Name, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
												//SqlProcs.spNOTES_ATTACHMENT_Update(gNOTE_ATTACHMENT_ID, file.Content, trn);
												// 11/06/2010 Paul.  Use our streamable function. 
												// 11/06/2010 Paul.  Move LoadFile() to Crm.NoteAttachments. 
												NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, file.ContentBytes, trn);
											}
										}
									}
								}
							}
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
							throw;
						}
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				}
			}
			return gEMAIL_ID;
		}
	}
}
