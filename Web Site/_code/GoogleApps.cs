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
using System.Xml;
using System.Data;
using System.Web;
using System.Text;
using System.Collections.Generic;
using System.Threading;

using Microsoft.AspNetCore.Http;

using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Web;
using Google.Apis.Auth.OAuth2.Flows;
using Google.Apis.Gmail.v1;
using Google.Apis.Gmail.v1.Data;
using Google.Apis.Services;

namespace SplendidCRM
{
	public class GoogleApps
	{
		public class EventStatus
		{
			public const string CANCELLED = "cancelled";
			public const string CONFIRMED = "confirmed";
			public const string TENTATIVE = "tentative";
		}

		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private SyncError            SyncError          ;
		private XmlUtil              XmlUtil            ;
		private MimeUtils            MimeUtils          ;

		public GoogleApps(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, XmlUtil XmlUtil, MimeUtils MimeUtils)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
			this.XmlUtil             = XmlUtil            ;
			this.MimeUtils           = MimeUtils          ;
		}

		public bool GoogleAppsEnabled()
		{
			bool bGoogleApps = Sql.ToBoolean(Application["CONFIG.GoogleApps.Enabled"]);
#if DEBUG
			//bGoogleAppsEnabled = true;
#endif
			if ( bGoogleApps )
			{
				string sClientID     = Sql.ToString(Application["CONFIG.GoogleApps.ClientID"    ]);
				string sClientSecret = Sql.ToString(Application["CONFIG.GoogleApps.ClientSecret"]);
				bGoogleApps = !Sql.IsEmptyString(sClientID) && !Sql.IsEmptyString(sClientSecret);
			}
			return bGoogleApps;
		}

		public BaseClientService.Initializer GetUserCredentialInitializer(Guid gUSER_ID, string sScope)
		{
			string sOAuthClientID     = Sql.ToString(Application["CONFIG.GoogleApps.ClientID"         ]);
			string sOAuthClientSecret = Sql.ToString(Application["CONFIG.GoogleApps.ClientSecret"     ]);
			GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow(new GoogleAuthorizationCodeFlow.Initializer
			{
				ClientSecrets = new ClientSecrets
				{
					ClientId     = sOAuthClientID,
					ClientSecret = sOAuthClientSecret
				}
			});
			// http://www.daimto.com/google-calendar-api-authentication-with-c/
			Google.Apis.Auth.OAuth2.Responses.TokenResponse token = this.RefreshAccessToken(gUSER_ID, false);
			token.Scope = sScope;
			UserCredential credential = new UserCredential(flow, gUSER_ID.ToString(), token);
			// https://developers.google.com/google-apps/calendar/quickstart/dotnet
			BaseClientService.Initializer initializer = new BaseClientService.Initializer()
			{
				HttpClientInitializer = credential,
				ApplicationName       = "SplendidCRM",
			};
			return initializer;
		}

		public Google.Apis.Auth.OAuth2.Responses.TokenResponse RefreshAccessToken(Guid gUSER_ID, bool bForceRefresh)
		{
			Google.Apis.Auth.OAuth2.Responses.TokenResponse token = null;
			string sOAuthAccessToken  = Sql.ToString(Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthAccessToken" ]);
			string sOAuthRefreshToken = Sql.ToString(Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthRefreshToken"]);
			string sOAuthExpiresAt    = Sql.ToString(Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ]);
			try
			{
				DateTime dtOAuthExpiresAt = Sql.ToDateTime(sOAuthExpiresAt);
				if ( Sql.IsEmptyString(sOAuthAccessToken) || dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now.AddMinutes(15) > dtOAuthExpiresAt || bForceRefresh )
				{
					Application.Remove("CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthAccessToken" );
					Application.Remove("CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthRefreshToken");
					Application.Remove("CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthExpiresAt"   );
					
					sOAuthAccessToken = String.Empty;
					dtOAuthExpiresAt  = DateTime.MinValue;
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						if ( Sql.IsEmptyString(sOAuthAccessToken) )
						{
							string sSQL = String.Empty;
							sSQL = "select TOKEN                               " + ControlChars.CrLf
							     + "     , TOKEN_EXPIRES_AT                    " + ControlChars.CrLf
							     + "     , REFRESH_TOKEN                       " + ControlChars.CrLf
							     + "  from vwOAUTH_TOKENS                      " + ControlChars.CrLf
							     + " where NAME             = @NAME            " + ControlChars.CrLf
							     + "   and ASSIGNED_USER_ID = @ASSIGNED_USER_ID" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@NAME"            , "GoogleApps");
								Sql.AddParameter(cmd, "@ASSIGNED_USER_ID", gUSER_ID    );
								using ( IDataReader rdr = cmd.ExecuteReader() )
								{
									if ( rdr.Read() )
									{
										sOAuthAccessToken  = Sql.ToString  (rdr["TOKEN"           ]);
										sOAuthRefreshToken = Sql.ToString  (rdr["REFRESH_TOKEN"   ]);
										dtOAuthExpiresAt   = Sql.ToDateTime(rdr["TOKEN_EXPIRES_AT"]);
										sOAuthExpiresAt    = dtOAuthExpiresAt.ToShortDateString() + " " + dtOAuthExpiresAt.ToShortTimeString();
									}
								}
							}
						}
						if ( Sql.IsEmptyString(sOAuthAccessToken) )
						{
							throw(new Exception("Google Apps Access Token does not exist for user " + gUSER_ID.ToString()));
						}
						else if ( Sql.IsEmptyString(sOAuthRefreshToken) )
						{
							throw(new Exception("Google Apps Refresh Token does not exist for user " + gUSER_ID.ToString()));
						}
						else if ( dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now.AddMinutes(15) > dtOAuthExpiresAt || bForceRefresh )
						{
							string sOAuthClientID     = Sql.ToString(Application["CONFIG.GoogleApps.ClientID"         ]);
							string sOAuthClientSecret = Sql.ToString(Application["CONFIG.GoogleApps.ClientSecret"     ]);
							GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow(new GoogleAuthorizationCodeFlow.Initializer
							{
								//DataStore = new SessionDataStore(Session),
								ClientSecrets = new ClientSecrets
								{
									ClientId     = sOAuthClientID,
									ClientSecret = sOAuthClientSecret
								}
							});
							
							try
							{
								token = flow.RefreshTokenAsync(gUSER_ID.ToString(), sOAuthRefreshToken, CancellationToken.None).Result;
							}
							catch
							{
								// 09/09/2015 Paul.  If the refresh fails, delete the database record so that we will not retry the sync. 
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
										Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
										Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
										// 01/16/2017 Paul.  This method needed to be called within the transaction. 
										SqlProcs.spOAUTH_TOKENS_Delete(gUSER_ID, "GoogleApps", trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
									}
								}
								throw;
							}
							sOAuthAccessToken  = token.AccessToken ;
							sOAuthRefreshToken = token.RefreshToken;
							dtOAuthExpiresAt   = DateTime.Now.AddSeconds(token.ExpiresInSeconds.Value);
							sOAuthExpiresAt    = dtOAuthExpiresAt.ToShortDateString() + " " + dtOAuthExpiresAt.ToShortTimeString();
							Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
							Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
							Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spOAUTH_TOKENS_Update(gUSER_ID, "GoogleApps", sOAuthAccessToken, String.Empty, dtOAuthExpiresAt, sOAuthRefreshToken, trn);
									trn.Commit();
								}
								catch
								{
									trn.Rollback();
									throw;
								}
							}
						}
						else
						{
							Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
							Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
							Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
							token = new Google.Apis.Auth.OAuth2.Responses.TokenResponse();
							token.AccessToken      = sOAuthAccessToken ;
							token.RefreshToken     = sOAuthRefreshToken;
							token.ExpiresInSeconds = Convert.ToInt64((dtOAuthExpiresAt - DateTime.Now).TotalSeconds);
							token.TokenType        = "Bearer";
						}
					}
				}
				else
				{
					token = new Google.Apis.Auth.OAuth2.Responses.TokenResponse();
					token.AccessToken      = sOAuthAccessToken ;
					token.RefreshToken     = sOAuthRefreshToken;
					token.ExpiresInSeconds = Convert.ToInt64((dtOAuthExpiresAt - DateTime.Now).TotalSeconds);
					token.TokenType        = "Bearer";
				}
			}
			catch
			{
				Application.Remove("CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthAccessToken" );
				Application.Remove("CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthRefreshToken");
				Application.Remove("CONFIG.GoogleApps." + gUSER_ID.ToString() + ".OAuthExpiresAt"   );
				throw;
			}
			return token;
		}

		public bool TestAccessToken(Guid gUSER_ID, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
				GmailService service = new GmailService(initializer);
				
				ListMessagesResponse lst = service.Users.Messages.List("me").Execute();
				int nCount = lst.Messages.Count;
				// 08/09/2018 Paul.  Allow translation of connection success. 
				string sCULTURE = Sql.ToString(Application["CONFIG.default_language"]);
				if ( Session != null )
					sCULTURE = Sql.ToString (Session["USER_SETTINGS/CULTURE"]);
				sbErrors.AppendLine(String.Format(L10N.Term(Application, sCULTURE, "Users.LBL_CONNECTION_SUCCESSFUL"), nCount.ToString(), "Inbox"));
				//sbErrors.AppendLine("Connection successful. " + nCount.ToString() + " items in Inbox");
				bValidSource = true;
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		public string GetEmailAddress(Guid gUSER_ID, StringBuilder sbErrors)
		{
			string sEmailAddress = String.Empty;
			try
			{
				Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
				GmailService service = new GmailService(initializer);
				
				UsersResource.GetProfileRequest req = service.Users.GetProfile("me");
				Google.Apis.Gmail.v1.Data.Profile profile = req.Execute();
				sEmailAddress = profile.EmailAddress;
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return sEmailAddress;
		}

		public bool TestMailbox(Guid gUSER_ID, string sMAILBOX, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
				GmailService service = new GmailService(initializer);
				
				UsersResource.MessagesResource.ListRequest req = service.Users.Messages.List("me");
				req.LabelIds = sMAILBOX;
				ListMessagesResponse lst = req.Execute();
				int nCount = lst.Messages.Count;
				// 08/09/2018 Paul.  Allow translation of connection success. 
				string sCULTURE = Sql.ToString(Application["CONFIG.default_language"]);
				if ( Session != null )
					sCULTURE = Sql.ToString (Session["USER_SETTINGS/CULTURE"]);
				sbErrors.AppendLine(String.Format(L10N.Term(Application, sCULTURE, "Users.LBL_CONNECTION_SUCCESSFUL"), nCount.ToString(), sMAILBOX));
				//sbErrors.AppendLine("Connection successful. " + nCount.ToString() + " items in " + sMAILBOX);
				bValidSource = true;
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		public void SendTestMessage(Guid gOAUTH_TOKEN_ID, string sFromAddress, string sFromName, string sToAddress, string sToName)
		{
			SplendidMailGmail client = new SplendidMailGmail(this, gOAUTH_TOKEN_ID);
			
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
			mail.Subject = "SplendidCRM Gmail Test Email " + DateTime.Now.ToString();
			mail.Body    = "This is a test.";
			client.Send(mail);
		}


		private void UpdateFolderTreeNodeCounts(GmailService service, XmlNode xFolder)
		{
			XmlDocument xml = xFolder.OwnerDocument;
			string sFOLDER_ID = XmlUtil.GetNamedItem(xFolder, "Id");
			ListLabelsResponse lst = service.Users.Labels.List("me").Execute();
			foreach ( Label fld in lst.Labels )
			{
				XmlNode xChild = xFolder.SelectSingleNode("//Folder[@Id=" + XmlUtil.EncaseXpathString(fld.Id) + "]");
				if ( xChild == null )
				{
					xChild = xml.CreateElement("Folder");
					xFolder.AppendChild(xChild);
					XmlUtil.SetSingleNodeAttribute(xml, xChild, "Id", fld.Id);
				}
				XmlUtil.SetSingleNodeAttribute(xml, xChild, "TotalCount" , fld.MessagesTotal.HasValue ? fld.MessagesTotal.Value.ToString() : "");
				XmlUtil.SetSingleNodeAttribute(xml, xChild, "Name"       , fld.Name                    );
				if ( fld.MessagesUnread.HasValue && fld.MessagesUnread.Value > 0 )
					XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", "<b>" + fld.Name + "</b> <font color=blue>(" + fld.MessagesUnread.Value.ToString() + ")</font>");
				else
					XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", fld.Name + " [" + fld.Id + ", " + Sql.ToString(fld.Type) + ", " + Sql.ToString(fld.LabelListVisibility) + "]");
			}
		}

		public void UpdateFolderTreeNodeCounts(Guid gUSER_ID, XmlNode xFolder)
		{
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);
			UpdateFolderTreeNodeCounts(service, xFolder);
		}

		private void GetFolderTreeFromResults(GmailService service, XmlNode xParent, Label fld)
		{
			XmlDocument xml = xParent.OwnerDocument;
			XmlElement xChild = xml.CreateElement("Folder");
			xParent.AppendChild(xChild);
			XmlUtil.SetSingleNodeAttribute(xml, xChild, "Id"         , fld.Id                      );
			XmlUtil.SetSingleNodeAttribute(xml, xChild, "TotalCount" , fld.MessagesTotal.HasValue ? fld.MessagesTotal.Value.ToString() : "");
			XmlUtil.SetSingleNodeAttribute(xml, xChild, "Name"       , fld.Name                    );
			if ( fld.MessagesUnread.HasValue && fld.MessagesUnread.Value > 0 )
				XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", "<b>" + fld.Name + "</b> <font color=blue>(" + fld.MessagesUnread.Value.ToString() + ")</font>");
			else
				XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", fld.Name + " [" + fld.Id + ", " + Sql.ToString(fld.Type) + ", " + Sql.ToString(fld.LabelListVisibility) + "]");
			//if ( fld.ChildFolderCount > 0 )
			//{
			//	int nPageOffset = 0;
			//	const int nPageSize = 100;
			//	FindFoldersResults fChildResults = null;
			//	do
			//	{
			//		fChildResults = service.FindFolders(fld.Id, new FolderView(nPageSize, nPageOffset));
			//		GetFolderTreeFromResults(service, xChild, fChildResults);
			//		nPageOffset += nPageSize;
			//	}
			//	while ( fChildResults.MoreAvailable );
			//}
		}

		public XmlDocument GetFolderTree(Guid gUSER_ID, ref string sGOOGLEAPPS_USERNAME, ref string sInboxFolderId)
		{
			XmlDocument xml = new XmlDocument();
			xml.AppendChild(xml.CreateProcessingInstruction("xml" , "version=\"1.0\" encoding=\"UTF-8\""));
			xml.AppendChild(xml.CreateElement("Folders"));
			
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);
			
			Profile profile = service.Users.GetProfile("me").Execute();
			sGOOGLEAPPS_USERNAME = profile.EmailAddress;
			ListLabelsResponse lst = service.Users.Labels.List("me").Execute();

			sInboxFolderId = "INBOX";
			XmlUtil.SetSingleNodeAttribute(xml, xml.DocumentElement, "DisplayName", "Mailbox - " + sGOOGLEAPPS_USERNAME);
			foreach ( Label fld in lst.Labels )
			{
				//if ( label.LabelListVisibility == "show" )
					GetFolderTreeFromResults(service, xml.DocumentElement, fld);
			}
			return xml;
		}

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public void GetFolderCount(Guid gUSER_ID, string sFOLDER_ID, ref int nTotalCount, ref int nUnreadCount)
		{
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);

			ListLabelsResponse lst = service.Users.Labels.List("me").Execute();
			foreach ( Label fld in lst.Labels )
			{
				if ( fld.Id == sFOLDER_ID )
				{
					nTotalCount  = fld.MessagesTotal .HasValue ? fld.MessagesTotal .Value : 0;
					nUnreadCount = fld.MessagesUnread.HasValue ? fld.MessagesUnread.Value : 0;
				}
			}
		}

		public void DeleteMessage(Guid gUSER_ID, string sUNIQUE_ID)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);
			
			service.Users.Messages.Delete("me", sUNIQUE_ID).Execute();
		}

		public DataTable GetMessage(Guid gUSER_ID, string sUNIQUE_ID)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);
			
			UsersResource.MessagesResource.GetRequest get = service.Users.Messages.Get("me", sUNIQUE_ID);
			get.Format = UsersResource.MessagesResource.GetRequest.FormatEnum.Raw;
			Message msg = get.Execute();
			// 02/09/2017 Paul.  Gmail returns a Base64Url, not a regular Base64 string. 
			byte[] by = SplendidMailGmail.Base64UrlDecode(msg.Raw);
			using ( MemoryStream stm = new MemoryStream(by) )
			{
				MimeKit.MimeMessage email = MimeKit.MimeMessage.Load(stm);
				if ( email != null )
				{
					double dSize = msg.SizeEstimate.HasValue ? msg.SizeEstimate.Value : 0;
					DataRow row = MimeUtils.CreateMessageRecord(dt, email, dSize);
					row["UNIQUE_ID"] = msg.Id;
				}
			}
			return dt;
		}

		public MimeKit.MimeMessage GetMimeMessage(Guid gUSER_ID, string sUNIQUE_ID)
		{
			MimeKit.MimeMessage email = null;
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);
			
			// https://developers.google.com/gmail/api/v1/reference/users/messages/modify
			UsersResource.MessagesResource.GetRequest get = service.Users.Messages.Get("me", sUNIQUE_ID);
			get.Format = UsersResource.MessagesResource.GetRequest.FormatEnum.Raw;
			Message msg = get.Execute();
			// 02/09/2017 Paul.  Gmail returns a Base64Url, not a regular Base64 string. 
			byte[] by = SplendidMailGmail.Base64UrlDecode(msg.Raw);
			using ( MemoryStream stm = new MemoryStream(by) )
			{
				email = MimeKit.MimeMessage.Load(stm);
			}
			return email;
		}

		public void MarkAsRead(Guid gUSER_ID, string sUNIQUE_ID)
		{
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);
			
			ModifyMessageRequest mods = new ModifyMessageRequest();
			mods.RemoveLabelIds = new List<string>() { "UNREAD" };
			UsersResource.MessagesResource.ModifyRequest req = service.Users.Messages.Modify(mods, "me", sUNIQUE_ID);
		}

		public void MarkAsUnread(Guid gUSER_ID, string sUNIQUE_ID)
		{
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);
			
			ModifyMessageRequest mods = new ModifyMessageRequest();
			mods.AddLabelIds = new List<string>() { "UNREAD" };
			UsersResource.MessagesResource.ModifyRequest req = service.Users.Messages.Modify(mods, "me", sUNIQUE_ID);
		}

		public byte[] GetAttachmentData(Guid gUSER_ID, string sUNIQUE_ID, int nATTACHMENT_ID, ref string sFILENAME, ref string sCONTENT_TYPE)
		{
			byte[] byDataBinary = null;
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);
			
			UsersResource.MessagesResource.GetRequest get = service.Users.Messages.Get("me", sUNIQUE_ID);
			get.Format = UsersResource.MessagesResource.GetRequest.FormatEnum.Raw;
			Message msg = get.Execute();
			// 02/09/2017 Paul.  Gmail returns a Base64Url, not a regular Base64 string. 
			byte[] by = SplendidMailGmail.Base64UrlDecode(msg.Raw);
			using ( MemoryStream stm = new MemoryStream(by) )
			{
				MimeKit.MimeMessage email = MimeKit.MimeMessage.Load(stm);
				if ( email != null )
				{
					if ( email.Attachments != null )
					{
						int nAttachment = 0;
						foreach ( MimeKit.MimeEntity att in email.Attachments )
						{
							if ( nATTACHMENT_ID == nAttachment )
							{
								if ( att is MimeKit.MessagePart || att is MimeKit.MimePart )
								{
									// http://www.mimekit.net/docs/html/WorkingWithMessages.htm
									sFILENAME        = String.Empty;
									string sFILE_EXT = String.Empty;
									sCONTENT_TYPE = att.ContentType.MediaType;
									if ( att.ContentDisposition != null && att.ContentDisposition.FileName != null )
									{
										sFILENAME = Path.GetFileName (att.ContentDisposition.FileName);
										sFILE_EXT = Path.GetExtension(sFILENAME);
									}
									using ( MemoryStream mem = new MemoryStream() )
									{
										if ( att is MimeKit.MessagePart )
										{
											MimeKit.MessagePart part = att as MimeKit.MessagePart;
											part.Message.WriteTo(mem);
										}
										else if ( att is MimeKit.MimePart )
										{
											MimeKit.MimePart part = att as MimeKit.MimePart;
											part.Content.DecodeTo(mem);
										}
										byDataBinary = mem.ToArray();
									}
								}
								break;
							}
							nAttachment++;
						}
					}
				}
			}
			return byDataBinary;
		}

		public DataTable GetFolderMessages(Guid gUSER_ID, string sFOLDER_ID, int nPageSize, int nPageOffset, string sSortColumn, string sSortOrder)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);

			// Search operators you can use with Gmail
			// https://support.google.com/mail/answer/7190?hl=en
			UsersResource.MessagesResource.ListRequest req = service.Users.Messages.List("me");
			req.LabelIds   = "UNREAD";
			req.MaxResults = 100;
			
			Dictionary<string, bool> dictUnread = new Dictionary<string,bool>();
			ListMessagesResponse lstUnread = req.Execute();
			foreach ( Message msg in lstUnread.Messages )
			{
				dictUnread[msg.Id] = true;
			}
			while ( !Sql.IsEmptyString(lstUnread.NextPageToken) )
			{
				req.PageToken = lstUnread.NextPageToken;
				ListMessagesResponse more = req.Execute();
				if ( more.Messages != null )
				{
					foreach ( Message msg in more.Messages )
					{
						dictUnread[msg.Id] = true;
						lstUnread.Messages.Add(msg);
					}
				}
				lstUnread.NextPageToken = more.NextPageToken;
			}
			req.LabelIds   = sFOLDER_ID;
			req.MaxResults = 100;
			ListMessagesResponse lst = req.Execute();
			while ( !Sql.IsEmptyString(lst.NextPageToken) )
			{
				req.PageToken = lst.NextPageToken;
				ListMessagesResponse more = req.Execute();
				if ( more.Messages != null )
				{
					foreach ( Message msg in more.Messages )
					{
						lst.Messages.Add(msg);
					}
				}
				lst.NextPageToken = more.NextPageToken;
			}
			
			int nMaxOffset = nPageOffset + nPageSize;
			for ( int i = nPageOffset; i < nMaxOffset && i < lst.Messages.Count; i++ )
			{
				Message msg = lst.Messages[i];
				UsersResource.MessagesResource.GetRequest get = service.Users.Messages.Get("me", msg.Id);
				get.Format = UsersResource.MessagesResource.GetRequest.FormatEnum.Metadata;
				msg = get.Execute();
				StringBuilder sbHeaders = new StringBuilder();
				foreach ( MessagePartHeader head in msg.Payload.Headers )
				{
					sbHeaders.AppendLine(head.Name + ": " + head.Value);
				}
				using ( MemoryStream stm = new MemoryStream(Encoding.UTF8.GetBytes(sbHeaders.ToString())) )
				{
					MimeKit.MimeMessage email = MimeKit.MimeMessage.Load(stm);
					if ( email != null )
					{
						double dSize = msg.SizeEstimate.HasValue ? msg.SizeEstimate.Value : 0;
						DataRow row = MimeUtils.CreateMessageRecord(dt, email, dSize);
						row["UNIQUE_ID"] = msg.Id;
						if ( dictUnread.ContainsKey(msg.Id) )
							row["IS_READ"] = false;
					}
				}
			}
			return dt;
		}

		public DataTable GetFolderMessages(Guid gUSER_ID, string sFOLDER_ID, bool bONLY_SINCE, long nLAST_EMAIL_UID, int nMaxRecords)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);

			// Search operators you can use with Gmail
			// https://support.google.com/mail/answer/7190?hl=en
			UsersResource.MessagesResource.ListRequest req = service.Users.Messages.List("me");
			req.LabelIds   = sFOLDER_ID;
			req.MaxResults = 100;
			if ( bONLY_SINCE && nLAST_EMAIL_UID > 0 )
				req.Q = "after:" + nLAST_EMAIL_UID.ToString();
			
			ListMessagesResponse lst = req.Execute();
			while ( !Sql.IsEmptyString(lst.NextPageToken) && (lst.Messages.Count < nMaxRecords || nMaxRecords <= 0) )
			{
				req.PageToken = lst.NextPageToken;
				ListMessagesResponse more = req.Execute();
				if ( more.Messages != null )
				{
					foreach ( Message msg in more.Messages )
					{
						if ( lst.Messages.Count < nMaxRecords || nMaxRecords <= 0 )
							lst.Messages.Add(msg);
					}
				}
				lst.NextPageToken = more.NextPageToken;
			}
			
			dt.Columns.Add("INTERNAL_DATE", typeof(System.Int64 ));
			dt.Columns.Add("LABELS"       , typeof(System.String));
			for ( int i = 0; i < lst.Messages.Count; i++ )
			{
				Message msg = lst.Messages[i];
				UsersResource.MessagesResource.GetRequest get = service.Users.Messages.Get("me", msg.Id);
				get.Format = UsersResource.MessagesResource.GetRequest.FormatEnum.Metadata;
				msg = get.Execute();
				StringBuilder sbHeaders = new StringBuilder();
				foreach ( MessagePartHeader head in msg.Payload.Headers )
				{
					sbHeaders.AppendLine(head.Name + ": " + head.Value);
				}
				using ( MemoryStream stm = new MemoryStream(Encoding.UTF8.GetBytes(sbHeaders.ToString())) )
				{
					MimeKit.MimeMessage email = MimeKit.MimeMessage.Load(stm);
					if ( email != null )
					{
						double dSize = msg.SizeEstimate.HasValue ? msg.SizeEstimate.Value : 0;
						DataRow row = MimeUtils.CreateMessageRecord(dt, email, dSize);
						row["UNIQUE_ID"       ] = msg.Id;
						row["INTERNAL_DATE"   ] = msg.InternalDate.HasValue ? msg.InternalDate.Value : 0;
						row["LABELS"          ] = String.Join(",", msg.LabelIds);
						string sHeaders = sbHeaders.ToString();
						sHeaders = sHeaders.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;");
						sHeaders = sHeaders.Replace(ControlChars.CrLf, "<br />" + ControlChars.CrLf);
						row["INTERNET_HEADERS"] = sHeaders;
					}
				}
			}
			return dt;
		}

		public Guid ImportMessage(Guid gUSER_ID, string sPARENT_TYPE, Guid gPARENT_ID, Guid gASSIGNED_USER_ID, Guid gTEAM_ID, string sTEAM_SET_LIST, string sUNIQUE_ID)
		{
			Guid gEMAIL_ID = Guid.Empty;
			
			DataTable dt = MimeUtils.CreateMessageTable();
			Google.Apis.Services.BaseClientService.Initializer initializer = this.GetUserCredentialInitializer(gUSER_ID, GmailService.Scope.GmailReadonly);
			GmailService service = new GmailService(initializer);
			
			UsersResource.MessagesResource.GetRequest get = service.Users.Messages.Get("me", sUNIQUE_ID);
			get.Format = UsersResource.MessagesResource.GetRequest.FormatEnum.Raw;
			Message msg = get.Execute();
			// 02/09/2017 Paul.  Gmail returns a Base64Url, not a regular Base64 string. 
			byte[] by = SplendidMailGmail.Base64UrlDecode(msg.Raw);
			using ( MemoryStream stm = new MemoryStream(by) )
			{
				MimeKit.MimeMessage email = MimeKit.MimeMessage.Load(stm);
				if ( email != null )
				{
					gEMAIL_ID = MimeUtils.ImportMessage(sPARENT_TYPE, gPARENT_ID, gUSER_ID, gASSIGNED_USER_ID, gTEAM_ID, sTEAM_SET_LIST, sUNIQUE_ID, email);
				}
			}
			return gEMAIL_ID;
		}
	}
}
