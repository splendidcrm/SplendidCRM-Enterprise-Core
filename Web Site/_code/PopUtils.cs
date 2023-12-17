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
using System.Xml;
using System.Diagnostics;
using System.Net.Mail;
using System.Net.Mime;

using Microsoft.AspNetCore.Http;

using MimeKit;
using MailKit;
using MailKit.Net.Pop3;

namespace SplendidCRM
{
	public class PopUtils
	{
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private SplendidError        SplendidError      ;
		private SyncError            SyncError          ;
		private MimeUtils            MimeUtils          ;
		private XmlUtil              XmlUtil            ;

		public PopUtils(HttpSessionState Session, SplendidError SplendidError, SyncError SyncError, MimeUtils MimeUtils, XmlUtil XmlUtil)
		{
			this.Session             = Session            ;
			this.SplendidError       = SplendidError      ;
			this.SyncError           = SyncError          ;
			this.MimeUtils           = MimeUtils          ;
			this.XmlUtil             = XmlUtil            ;
		}

		public bool Validate(string sSERVER_URL, int nPORT, bool bMAILBOX_SSL, string sEMAIL_USER, string sEMAIL_PASSWORD, StringBuilder sbErrors)
		{
			bool bValid = false;
			//Pop3.Pop3MimeClient pop = new Pop3.Pop3MimeClient(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD);
			using ( Pop3Client pop = new Pop3Client() )
			{
				try
				{
					pop.Timeout = 60 * 1000; //give pop server 60 seconds to answer
					pop.Connect(sSERVER_URL, nPORT, (bMAILBOX_SSL ? MailKit.Security.SecureSocketOptions.SslOnConnect : MailKit.Security.SecureSocketOptions.Auto));
					pop.AuthenticationMechanisms.Remove ("XOAUTH2");
					pop.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
				
					int nTotalEmails = pop.Count;
					// 08/09/2018 Paul.  Allow translation of connection success. 
					string sCULTURE = Sql.ToString(Application["CONFIG.default_language"]);
					if ( Session != null )
						sCULTURE = Sql.ToString (Session["USER_SETTINGS/CULTURE"]);
					sbErrors.AppendLine(String.Format(L10N.Term(Application, sCULTURE, "Users.LBL_CONNECTION_SUCCESSFUL"), nTotalEmails.ToString(), "Inbox"));
					//sbErrors.AppendLine("Connection successful. " + nTotalEmails.ToString() + " items in Inbox" + "<br />");
					bValid = true;
				}
				catch(Exception ex)
				{
					sbErrors.AppendLine(ex.Message);
				}
			}
			return bValid;
		}

		public XmlDocument GetFolderTree(HttpContext Context, string sSERVER_URL, int nPORT, bool bMAILBOX_SSL, string sEMAIL_USER, string sEMAIL_PASSWORD)
		{
			XmlDocument xml = new XmlDocument();
			xml.AppendChild(xml.CreateProcessingInstruction("xml" , "version=\"1.0\" encoding=\"UTF-8\""));
			xml.AppendChild(xml.CreateElement("Folders"));
			XmlUtil.SetSingleNodeAttribute(xml, xml.DocumentElement, "DisplayName", "Mailbox - " + sEMAIL_USER);
			
			//Pop3.Pop3MimeClient pop = new Pop3.Pop3MimeClient(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD);
			using ( Pop3Client pop = new Pop3Client() )
			{
				MailKit.Security.SecureSocketOptions options = MailKit.Security.SecureSocketOptions.Auto;
				if ( bMAILBOX_SSL )
					options = MailKit.Security.SecureSocketOptions.SslOnConnect;
				pop.Timeout = 60 * 1000; //give pop server 60 seconds to answer
				pop.Connect(sSERVER_URL, nPORT, options);
				pop.AuthenticationMechanisms.Remove ("XOAUTH2");
				pop.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
				
				int nTotalEmails = pop.Count;
				int nUnreadCount = 0;
				string sMAILBOX = "INBOX";

				XmlElement xChild = xml.CreateElement("Folder");
				xml.DocumentElement.AppendChild(xChild);
				XmlUtil.SetSingleNodeAttribute(xml, xChild, "Id"         , sMAILBOX);
				XmlUtil.SetSingleNodeAttribute(xml, xChild, "TotalCount" , nTotalEmails.ToString());
				XmlUtil.SetSingleNodeAttribute(xml, xChild, "UnreadCount", nUnreadCount.ToString());
				if ( nUnreadCount > 0 )
					XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", "<b>" + sMAILBOX + "</b> <font color=blue>(" + nUnreadCount.ToString() + ")</font>");
				else
					XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", sMAILBOX       );
			}
			return xml;
		}

		public void GetFolderCount(HttpContext Context, string sSERVER_URL, int nPORT, bool bMAILBOX_SSL, string sEMAIL_USER, string sEMAIL_PASSWORD, ref int nTotalCount, ref int nUnreadCount)
		{
			//Pop3.Pop3MimeClient pop = new Pop3.Pop3MimeClient(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD);
			using ( Pop3Client pop = new Pop3Client() )
			{
				MailKit.Security.SecureSocketOptions options = MailKit.Security.SecureSocketOptions.Auto;
				if ( bMAILBOX_SSL )
					options = MailKit.Security.SecureSocketOptions.SslOnConnect;
				pop.Timeout = 60 * 1000; //give pop server 60 seconds to answer
				pop.Connect(sSERVER_URL, nPORT, options);
				pop.AuthenticationMechanisms.Remove ("XOAUTH2");
				pop.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
				
				nTotalCount  = pop.Count;
				nUnreadCount = 0;
			}
		}

		// 07/18/2010 Paul.  Return the headers so that we don't have to fetch them again in the GetMessage method. 
		private int FindMessageByMessageID(Pop3Client pop, string sMessageID, ref HeaderList headers)
		{
			IList<HeaderList> lstHeaders = pop.GetMessageHeaders(0, pop.Count);
			for ( int i = 0; i < lstHeaders.Count; i++ )
			{
				if ( lstHeaders[i].Contains("Message-ID") )
				{
					headers = lstHeaders[i];
					return i;
				}
			}
			return -1;
		}

		public void DeleteMessage(HttpContext Context, string sSERVER_URL, int nPORT, bool bMAILBOX_SSL, string sEMAIL_USER, string sEMAIL_PASSWORD, string sUNIQUE_ID)
		{
			// 07/18/2010 Paul.  The POP3 Message Number is meaningless as it is only valid for the connection, and we disconnect immediately. 
			// We will use the MessageID as the primary key and we will need to lookup the Message Number in order to delete it. 
			//Pop3.Pop3MimeClient pop = new Pop3.Pop3MimeClient(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD);
			using ( Pop3Client pop = new Pop3Client() )
			{
				pop.Timeout = 60 * 1000; //give pop server 60 seconds to answer
				pop.Connect(sSERVER_URL, nPORT, (bMAILBOX_SSL ? MailKit.Security.SecureSocketOptions.SslOnConnect : MailKit.Security.SecureSocketOptions.Auto));
				pop.AuthenticationMechanisms.Remove ("XOAUTH2");
				pop.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
				
				HeaderList headers = null;
				int nMessageNumber = FindMessageByMessageID(pop, sUNIQUE_ID, ref headers);
				if ( nMessageNumber >= 0 )
				{
					pop.DeleteMessage(nMessageNumber);
				}
			}
		}

		public DataTable GetMessage(HttpContext Context, string sSERVER_URL, int nPORT, bool bMAILBOX_SSL, string sEMAIL_USER, string sEMAIL_PASSWORD, string sUNIQUE_ID)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			
			//Pop3.Pop3MimeClient pop = new Pop3.Pop3MimeClient(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD);
			using ( Pop3Client pop = new Pop3Client() )
			{
				pop.Timeout = 60 * 1000; //give pop server 60 seconds to answer
				pop.Connect(sSERVER_URL, nPORT, (bMAILBOX_SSL ? MailKit.Security.SecureSocketOptions.SslOnConnect : MailKit.Security.SecureSocketOptions.Auto));
				pop.AuthenticationMechanisms.Remove ("XOAUTH2");
				pop.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
				
				HeaderList headers = null;
				int nMessageNumber = FindMessageByMessageID(pop, sUNIQUE_ID, ref headers);
				if ( nMessageNumber >= 0 )
				{
					MimeMessage email = MimeMessage.Load(pop.GetStream(nMessageNumber));
					if ( email != null )
					{
						double dSize = pop.GetMessageSize(nMessageNumber);
						MimeUtils.CreateMessageRecord(dt, email, dSize);
					}
				}
			}
			return dt;
		}

		public byte[] GetAttachmentData(HttpContext Context, string sSERVER_URL, int nPORT, bool bMAILBOX_SSL, string sEMAIL_USER, string sEMAIL_PASSWORD, string sUNIQUE_ID, int nATTACHMENT_ID, ref string sFILENAME, ref string sCONTENT_TYPE, ref bool bINLINE)
		{
			byte[] byDataBinary = null;
			//Pop3.Pop3MimeClient pop = new Pop3.Pop3MimeClient(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD);
			using ( Pop3Client pop = new Pop3Client() )
			{
				pop.Timeout = 60 * 1000; //give pop server 60 seconds to answer
				pop.Connect(sSERVER_URL, nPORT, (bMAILBOX_SSL ? MailKit.Security.SecureSocketOptions.SslOnConnect : MailKit.Security.SecureSocketOptions.Auto));
				pop.AuthenticationMechanisms.Remove ("XOAUTH2");
				pop.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
				
				HeaderList headers = null;
				int nMessageNumber = FindMessageByMessageID(pop, sUNIQUE_ID, ref headers);
				if ( nMessageNumber >= 0 )
				{
					MimeMessage email = MimeMessage.Load(pop.GetStream(nMessageNumber));
					if ( email != null )
					{
						if ( email.Attachments != null )
						{
							int nAttachment = 0;
							foreach ( MimeKit.MimeEntity att in email.Attachments )
							{
								if ( nATTACHMENT_ID == nAttachment )
								{
									if ( att is MessagePart || att is MimePart )
									{
										// http://www.mimekit.net/docs/html/WorkingWithMessages.htm
										bINLINE          = false;
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
											if ( att is MessagePart )
											{
												MessagePart part = att as MessagePart;
												part.Message.WriteTo(mem);
											}
											else if ( att is MimePart )
											{
												MimePart part = att as MimePart;
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
			}
			return byDataBinary;
		}

		public DataTable GetFolderMessages(HttpContext Context, string sSERVER_URL, int nPORT, bool bMAILBOX_SSL, string sEMAIL_USER, string sEMAIL_PASSWORD)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			
			//Pop3.Pop3MimeClient pop = new Pop3.Pop3MimeClient(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD);
			using ( Pop3Client pop = new Pop3Client() )
			{
				pop.Timeout = 60 * 1000; //give pop server 60 seconds to answer
				pop.Connect(sSERVER_URL, nPORT, (bMAILBOX_SSL ? MailKit.Security.SecureSocketOptions.SslOnConnect : MailKit.Security.SecureSocketOptions.Auto));
				pop.AuthenticationMechanisms.Remove ("XOAUTH2");
				pop.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
				
				int nMessageIndex = 0;
				IList<int> lstMessageSizes = pop.GetMessageSizes();
				IList<Stream> lstMessages = pop.GetStreams(0, pop.Count);
				foreach ( Stream stm in lstMessages )
				{
					MimeMessage email = MimeMessage.Load(stm);
					if ( email != null )
					{
						DataRow row = MimeUtils.CreateMessageRecord(dt, email, lstMessageSizes[nMessageIndex]);
					}
					nMessageIndex++;
				}
			}
			return dt;
		}

		public Guid ImportMessage(HttpContext Context, HttpSessionState Session, string sPARENT_TYPE, Guid gPARENT_ID, string sSERVER_URL, int nPORT, bool bMAILBOX_SSL, string sEMAIL_USER, string sEMAIL_PASSWORD, Guid gUSER_ID, Guid gASSIGNED_USER_ID, Guid gTEAM_ID, string sTEAM_SET_LIST, string sUNIQUE_ID)
		{
			Guid gEMAIL_ID = Guid.Empty;
			
			//Pop3.Pop3MimeClient pop = new Pop3.Pop3MimeClient(sSERVER_URL, nPORT, bMAILBOX_SSL, sEMAIL_USER, sEMAIL_PASSWORD);
			using ( Pop3Client pop = new Pop3Client() )
			{
				pop.Timeout = 60 * 1000; //give pop server 60 seconds to answer
				pop.Connect(sSERVER_URL, nPORT, (bMAILBOX_SSL ? MailKit.Security.SecureSocketOptions.SslOnConnect : MailKit.Security.SecureSocketOptions.Auto));
				pop.AuthenticationMechanisms.Remove ("XOAUTH2");
				pop.Authenticate (sEMAIL_USER, sEMAIL_PASSWORD);
						
				HeaderList headers = null;
				int nMessageNumber = FindMessageByMessageID(pop, sUNIQUE_ID, ref headers);
				if ( nMessageNumber >= 0 )
				{
					MimeKit.MimeMessage email = null;
					bool bLoadSuccessful = false;
					try
					{
						email = MimeKit.MimeMessage.Load(pop.GetStream(nMessageNumber));
						bLoadSuccessful = true;
					}
					catch(Exception ex)
					{
						string sError = "Error loading email for " + sEMAIL_USER + ", " + sUNIQUE_ID + "." + ControlChars.CrLf;
						sError += Utils.ExpandException(ex) + ControlChars.CrLf;
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
					}
					if ( email != null && bLoadSuccessful )
					{
						gEMAIL_ID = MimeUtils.ImportMessage(sPARENT_TYPE, gPARENT_ID, gUSER_ID, gASSIGNED_USER_ID, gTEAM_ID, sTEAM_SET_LIST, sUNIQUE_ID, email);
					}
				}
				else
				{
					string sError = "Error loading email for " + sEMAIL_USER + ", " + sUNIQUE_ID + "." + ControlChars.CrLf;
					throw(new Exception(sError));
				}
			}
			return gEMAIL_ID;
		}
	}
}

