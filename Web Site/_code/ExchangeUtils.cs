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
using Microsoft.Exchange.WebServices.Data;
using System.Security.Cryptography.X509Certificates;

using Spring.Social.Office365;

namespace SplendidCRM
{
	public class ExchangeUtils
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SplendidDefaults     SplendidDefaults   = new SplendidDefaults();
		private Utils                Utils              ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private XmlUtil              XmlUtil            ;
		private MimeUtils            MimeUtils          ;
		private SyncError            SyncError          ;
		private ActiveDirectory      ActiveDirectory    ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private Office365Sync        Office365Sync      ;
		private Crm.Modules          Modules            ;
		private Crm.Emails           Emails             ;
		private Crm.EmailImages      EmailImages        ;
		private Crm.NoteAttachments  NoteAttachments    ;

		public ExchangeUtils(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, Utils Utils, SplendidError SplendidError, XmlUtil XmlUtil, MimeUtils MimeUtils, SyncError SyncError, ActiveDirectory ActiveDirectory, ExchangeSecurity ExchangeSecurity, Office365Sync Office365Sync, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.Emails Emails, SplendidCRM.Crm.EmailImages EmailImages, SplendidCRM.Crm.NoteAttachments NoteAttachments)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.Utils               = Utils              ;
			this.SplendidError       = SplendidError      ;
			this.XmlUtil             = XmlUtil            ;
			this.MimeUtils           = MimeUtils          ;
			this.SyncError           = SyncError          ;
			this.ActiveDirectory     = ActiveDirectory    ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.Office365Sync       = Office365Sync      ;
			this.Modules             = Modules            ;
			this.Emails              = Emails             ;
			this.EmailImages         = EmailImages        ;
			this.NoteAttachments     = NoteAttachments    ;
		}

		public static Guid EXCHANGE_ID = new Guid("00000000-0000-0000-0000-00000000000D");
		// 07/19/2018 Paul.  Send does not return an message ID, so we need to set an extended property, then retrieve it later. 
		public static Guid   SPLENDIDCRM_PROPERTY_SET_ID = new Guid("0F0D74BB-94C7-46A8-A4BC-AB5D790A9A15");
		public static string SPLENDIDCRM_PROPERTY_NAME   = "X-SplendidCRM-ID";
		private static Dictionary<Guid, PullSubscription> dictInboundSubscriptions = new Dictionary<Guid, PullSubscription>();

		#region Authentication Helpers
		// 12/13/2017 Paul.  Allow version to be changed. 
		public bool ValidateExchange(string sSERVER_URL, string sUSER_NAME, string sPASSWORD, bool bIGNORE_CERTIFICATE, string sIMPERSONATED_TYPE, string sEXCHANGE_VERSION, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			RemoteCertificateValidationCallback OriginalValidator = ServicePointManager.ServerCertificateValidationCallback;
			try
			{
				if ( !Sql.IsEmptyString(sSERVER_URL) )
				{
					// 02/22/2010 Paul.  We must decrypt the password before using it. 
					if ( !Sql.IsEmptyString(sPASSWORD) )
					{
						// 02/06/2017 Paul.  Simplify decryption call. 
						sPASSWORD = Security.DecryptPassword(sPASSWORD);
					}

					// 03/22/2010 Paul.  This method is only needed if your EWS endpoint has a certificate that is not trusted.
					if ( bIGNORE_CERTIFICATE )
					{
						// 03/22/2010 Paul.  Replace with a dummy always-true validator
						ServicePointManager.ServerCertificateValidationCallback =
							delegate(Object obj, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
							{
								return true;
							};
					}
					// 03/28/2010 Paul.  Lets force UTC time. 
					// 06/05/2011 Paul.  A customer had an internal server error when trying to connect to Exchange 2010 SP1. 
					// 01/17/2017 Paul.  Default to Exchange 2013 SP1. 
					ExchangeVersion version = ExchangeVersion.Exchange2013_SP1;
					switch ( Sql.ToString(sEXCHANGE_VERSION) )
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
					if ( !Sql.IsEmptyString(sUSER_NAME) )
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
					}
					// 08/30/2013 Paul.  Office365 requires that we use auto-discover to get the server URL. 
					if ( sSERVER_URL.ToLower().StartsWith("autodiscover") && !Sql.IsEmptyString(sUSER_NAME) )
					{
						service.AutodiscoverUrl(sUSER_NAME, delegate (String redirectionUrl)
						{
							return redirectionUrl.ToLower().StartsWith("https://");
						});
						sbErrors.AppendLine("Using AutodiscoverURL: " + service.Url + ".  ");
					}
					else
					{
						service.Url = new Uri(sSERVER_URL);
					}
					/*
					if ( !Sql.IsEmptyString(sIMPERSONATED_TYPE) )
					{
						if ( sIMPERSONATED_TYPE == "SmtpAddress" )
							service.ImpersonatedUserId = new ImpersonatedUserId(ConnectingIdType.SmtpAddress  , txtIMPERSONATED_USER.Text);
						else
							service.ImpersonatedUserId = new ImpersonatedUserId(ConnectingIdType.PrincipalName, txtIMPERSONATED_USER.Text);
					}
					*/
					/*
					EmailMessage message = new EmailMessage(service);
					message.Subject = "Hello world! " + DateTime.Now.ToString();
					message.Body = "Sent using the EWS Managed API.";
					message.ToRecipients.Add("paul@splendidcrm.com");
					message.SendAndSaveCopy();
					*/
					Folder fldInbox = Folder.Bind(service, WellKnownFolderName.Inbox);
					int nUnreadCount = fldInbox.UnreadCount;
					// 08/09/2018 Paul.  Allow translation of connection success. 
					string sCULTURE = Sql.ToString(Application["CONFIG.default_language"]);
					if ( Session != null )
						sCULTURE = Sql.ToString (Session["USER_SETTINGS/CULTURE"]);
					sbErrors.AppendLine(String.Format(L10N.Term(Application, sCULTURE, "Users.LBL_CONNECTION_SUCCESSFUL"), nUnreadCount.ToString(), "Inbox"));
					//sbErrors.AppendLine("Connection successful. " + nUnreadCount.ToString() + " items in Inbox" + "<br />");
					
					// 04/28/2010 Paul.  WebDAV is not enabled by default in Exchange 2010. 
					// There does not seem to be a reliable way to get the list of users using EWS, 
					// so we need to change the way that we manage users. 
					/*
					// 03/20/2010 Paul.  Now test the WebDAV as it will be needed to get the list of Exchange users. 
					NetworkCredential credentials = null;
					if ( !Sql.IsEmptyString(sUSER_NAME) )
					{
						string[] arrUSER_NAME = sUSER_NAME.Split('\\');
						if ( arrUSER_NAME.Length > 1 )
							credentials = new NetworkCredential(arrUSER_NAME[1], sPASSWORD, arrUSER_NAME[0]);
						else
							credentials = new NetworkCredential(sUSER_NAME, sPASSWORD, String.Empty);
					}
					
					string sWebDAV = sSERVER_URL.ToLower().Replace("/ews/exchange.asmx", "");
					sWebDAV += "/public/?Cmd=galfind=&an=";  // AN for alias, LN for last name. 
					// 03/22/2010 Paul.  Search for any name, starting with A.  The results are not important. 
					HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(sWebDAV + "A");
					objRequest.Credentials = credentials;
					objRequest.Headers.Add("cache-control", "no-cache");
					objRequest.PreAuthenticate   = true ;
					objRequest.KeepAlive         = false;
					objRequest.AllowAutoRedirect = false;
					objRequest.Timeout           = 10000;  //10 seconds
					objRequest.Method            = "GET";

					// 01/11/2011 Paul.  Make sure to dispose of the response object as soon as possible. 
					using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
					{
						if ( objResponse != null )
						{
							if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found )
							{
								bValidSource = true;
							}
							else
							{
								sbErrors.AppendLine(objResponse.StatusDescription);
							}
						}
					}
					*/
				}
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			finally
			{
				ServicePointManager.ServerCertificateValidationCallback = OriginalValidator;
			}
			return bValidSource;
		}

		public void SendTestMessage(string sSERVER_URL, string sUSER_NAME, string sPASSWORD, string sFromAddress, string sFromName, string sToAddress, string sToName)
		{
			if ( !Sql.IsEmptyString(sPASSWORD) )
			{
				// 02/06/2017 Paul.  Simplify decryption call. 
				sPASSWORD = Security.DecryptPassword(sPASSWORD);
			}
			SplendidMailExchangePassword client = new SplendidMailExchangePassword(sSERVER_URL, sUSER_NAME, sPASSWORD);
			
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
			mail.Subject = "SplendidCRM Exchange Test Email " + DateTime.Now.ToString();
			mail.Body    = "This is a test.";
			client.Send(mail);
		}

		// 12/13/2020 Paul.  Move Office365 methods to Office365utils. 

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public int ValidateImpersonation(string sEXCHANGE_ALIAS, string sEXCHANGE_EMAIL)
		{
			// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
			ExchangeService service = this.CreateExchangeService(sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, String.Empty, String.Empty, Guid.Empty);
			Folder fldContacts = Folder.Bind(service, WellKnownFolderName.Contacts);
			int nTotalCount = fldContacts.TotalCount;
			return nTotalCount;
		}

		// 12/13/2020 Paul.  Move Office365 methods to Office365utils. 

		// 04/28/2010 Paul.  WebDAV is not enabled by default in Exchange 2010. 
		// There does not seem to be a reliable way to get the list of users using EWS, 
		// so we need to change the way that we manage users. 
		/*
		public DataTable ExchangeUsers(StringBuilder sbErrors)
		{
			DataTable dtExchange = new DataTable();
			dtExchange = new DataTable();
			dtExchange.Columns.Add("ID"              , typeof(System.Guid  ));
			dtExchange.Columns.Add("EXCHANGE_NAME"   , typeof(System.String));
			dtExchange.Columns.Add("EXCHANGE_ALIAS"  , typeof(System.String));
			dtExchange.Columns.Add("EXCHANGE_EMAIL"  , typeof(System.String));
			dtExchange.Columns.Add("EXCHANGE_PHONE"  , typeof(System.String));
			dtExchange.Columns.Add("EXCHANGE_TITLE"  , typeof(System.String));
			dtExchange.Columns.Add("EXCHANGE_COMPANY", typeof(System.String));

			RemoteCertificateValidationCallback OriginalValidator = ServicePointManager.ServerCertificateValidationCallback;
			try
			{
				string sSERVER_URL         = Sql.ToString (Application["CONFIG.Exchange.ServerURL"        ]);
				string sUSER_NAME          = Sql.ToString (Application["CONFIG.Exchange.UserName"         ]);
				string sPASSWORD           = Sql.ToString (Application["CONFIG.Exchange.Password"         ]);
				bool   bIGNORE_CERTIFICATE = Sql.ToBoolean(Application["CONFIG.Exchange.IgnoreCertificate"]);
				
				// 02/22/2010 Paul.  We must decrypt the password before using it. 
				if ( !Sql.IsEmptyString(sPASSWORD) )
				{
					// 02/06/2017 Paul.  Simplify decryption call. 
					sPASSWORD = Security.DecryptPassword(Application, sPASSWORD);
				}
				
				// 03/22/2010 Paul.  This method is only needed if your EWS endpoint has a certificate that is not trusted.
				if ( bIGNORE_CERTIFICATE )
				{
					// 03/22/2010 Paul.  Replace with a dummy always-true validator
					ServicePointManager.ServerCertificateValidationCallback =
						delegate(Object obj, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
						{
							return true;
						};
				}
				
				NetworkCredential credentials = null;
				if ( !Sql.IsEmptyString(sUSER_NAME) )
				{
					string[] arrUSER_NAME = sUSER_NAME.Split('\\');
					if ( arrUSER_NAME.Length > 1 )
						credentials = new NetworkCredential(arrUSER_NAME[1], sPASSWORD, arrUSER_NAME[0]);
					else
						credentials = new NetworkCredential(sUSER_NAME, sPASSWORD, String.Empty);
				}
				
				XmlDocument xmlMailboxes = new XmlDocument();
				XmlNamespaceManager nsmgr = new XmlNamespaceManager(xmlMailboxes.NameTable);
				nsmgr.AddNamespace("a", "WM");
				
				string sWebDAV = sSERVER_URL.ToLower().Replace("/ews/exchange.asmx", "");
				sWebDAV += "/public/?Cmd=galfind=&an=";  // AN for alias, LN for last name. 
				foreach ( char chAlpha in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".ToCharArray() )
				{
					HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create(sWebDAV + chAlpha);
					objRequest.Credentials = credentials;
					objRequest.Headers.Add("cache-control", "no-cache");
					objRequest.PreAuthenticate   = true ;
					objRequest.KeepAlive         = false;
					objRequest.AllowAutoRedirect = false;
					objRequest.Timeout           = 10000;  //10 seconds
					objRequest.Method            = "GET";

					try
					{
						// 01/11/2011 Paul.  Make sure to dispose of the response object as soon as possible. 
						using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
						{
							if ( objResponse != null )
							{
								if ( objResponse.StatusCode == HttpStatusCode.OK || objResponse.StatusCode == HttpStatusCode.Found )
								{
									using ( StreamReader readStream = new StreamReader(objResponse.GetResponseStream(), System.Text.Encoding.UTF8) )
									{
										string sResponse = readStream.ReadToEnd();
										//<a:response xmlns:a="WM">
										//	<a:addresslist>
										//		<a:item>
										//			<a:DN>Paul Rony</a:DN>
										//			<a:PH></a:PH>
										//			<a:OF></a:OF>
										//			<a:TL></a:TL>
										//			<a:CP></a:CP>
										//			<a:AN>paulrony</a:AN>
										//			<a:EM>paul@splendidcrm.com</a:EM>
										//		</a:item>
										//	</a:addresslist>
										//</a:response>
										
										xmlMailboxes.LoadXml(sResponse);
										XmlNodeList nlAddressList = xmlMailboxes.DocumentElement.SelectNodes("a:addresslist/a:item", nsmgr);
										foreach ( XmlNode item in nlAddressList )
										{
											string sNAME    = XmlUtil.SelectSingleNode(item, "a:DN", nsmgr);
											string sALIAS   = XmlUtil.SelectSingleNode(item, "a:AN", nsmgr);
											string sEMAIL   = XmlUtil.SelectSingleNode(item, "a:EM", nsmgr);
											string sPHONE   = XmlUtil.SelectSingleNode(item, "a:PH", nsmgr);
											string sTITLE   = XmlUtil.SelectSingleNode(item, "a:TL", nsmgr);
											string sCOMPANY = XmlUtil.SelectSingleNode(item, "a:CP", nsmgr);
											//lblError.Text += sAlias + " " + sName + " " + sEmail + "<br />" + ControlChars.CrLf;
											
											DataRow row = dtExchange.NewRow();
											dtExchange.Rows.Add(row);
											row["ID"              ] = Guid.NewGuid();
											row["EXCHANGE_NAME"   ] = sNAME ;
											row["EXCHANGE_ALIAS"  ] = sALIAS;
											row["EXCHANGE_EMAIL"  ] = sEMAIL;
											row["EXCHANGE_PHONE"  ] = sPHONE  ;
											row["EXCHANGE_TITLE"  ] = sTITLE  ;
											row["EXCHANGE_COMPANY"] = sCOMPANY;
										}
									}
								}
							}
						}
					}
					catch(Exception ex)
					{
						sbErrors.AppendLine("Error: " + ex.Message + "<br />");
					}
				}
			}
			finally
			{
				ServicePointManager.ServerCertificateValidationCallback = OriginalValidator;
			}
			return dtExchange;
		}
		*/

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
		public ExchangeService CreateExchangeService(string sEXCHANGE_ALIAS, string sEXCHANGE_EMAIL, string sMAIL_SMTPUSER, string sMAIL_SMTPPASS, Guid gEXCHANGE_ID)
		{
			string sSERVER_URL          = Sql.ToString (Application["CONFIG.Exchange.ServerURL"        ]);
			string sUSER_NAME           = Sql.ToString (Application["CONFIG.Exchange.UserName"         ]);
			string sPASSWORD            = Sql.ToString (Application["CONFIG.Exchange.Password"         ]);
			bool   bIGNORE_CERTIFICATE  = Sql.ToBoolean(Application["CONFIG.Exchange.IgnoreCertificate"]);
			string sIMPERSONATED_TYPE   = Sql.ToString (Application["CONFIG.Exchange.ImpersonatedType" ]);
			// 01/17/2017 Paul.  Add support for OAuth. 
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"         ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"     ]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			
			// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
			// 11/28/2011 Paul.  MAIL_SMTPPASS is encpryted, so get the value before sPASSWORD is decrypted. 
			if ( Sql.IsEmptyString(sIMPERSONATED_TYPE) )
				sIMPERSONATED_TYPE = "NoImpersonation";
			if ( sIMPERSONATED_TYPE == "NoImpersonation" && !Sql.IsEmptyString(sMAIL_SMTPUSER) )
			{
				sUSER_NAME = sMAIL_SMTPUSER;
				sPASSWORD  = sMAIL_SMTPPASS;
			}
			// 02/22/2010 Paul.  We must decrypt the password before using it. 
			if ( !Sql.IsEmptyString(sPASSWORD) )
			{
				// 02/06/2017 Paul.  Simplify decryption call. 
				sPASSWORD = Security.DecryptPassword(sPASSWORD);
			}
			
			// 03/22/2010 Paul.  This method is only needed if your EWS endpoint has a certificate that is not trusted.
			if ( bIGNORE_CERTIFICATE )
			{
				// 03/22/2010 Paul.  Replace with a dummy always-true validator
				ServicePointManager.ServerCertificateValidationCallback =
					delegate(Object obj, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
					{
						return true;
					};
			}
			
			// 03/28/2010 Paul.  Lets force UTC time. 
			// 06/05/2011 Paul.  A customer had an internal server error when trying to connect to Exchange 2010 SP1. 
			// 01/17/2017 Paul.  Default to Exchange 2013 SP1. 
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
			// 01/17/2017 Paul.  Add support for OAuth. 
			if ( !Sql.IsEmptyString(sOAUTH_CLIENT_ID) )
			{
				// 07/05/2018 Paul.  Impersonation will not work with Office 365. 
				//if ( Sql.IsEmptyGuid(gEXCHANGE_ID) )
				//	gEXCHANGE_ID = ExchangeUtils.EXCHANGE_ID;
				// 06/22/2018 Paul.  Getting unauthorized too frequently, so refresh every time. 
				// 07/09/2018 Paul.  We don't want to refresh every 5 minutes, so let regular timeout apply. 
				Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gEXCHANGE_ID, false);
				service.Credentials = new OAuthCredentials(token.access_token);
			}
			else
			{
				if ( !Sql.IsEmptyString(sUSER_NAME) )
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
				}
			}
			// 08/30/2013 Paul.  Office365 requires that we use auto-discover to get the server URL. 
			if ( sSERVER_URL.ToLower().StartsWith("autodiscover") && !Sql.IsEmptyString(sUSER_NAME) )
			{
				service.AutodiscoverUrl(sUSER_NAME, delegate (String redirectionUrl)
				{
					if ( !Sql.IsEmptyString(sOAUTH_CLIENT_ID) )
						return (redirectionUrl == "https://autodiscover-s.outlook.com/autodiscover/autodiscover.xml");
					else
						return redirectionUrl.ToLower().StartsWith("https://");
				});
			}
			else
			{
				service.Url = new Uri(sSERVER_URL);
			}

			if ( sIMPERSONATED_TYPE == "SmtpAddress" && !Sql.IsEmptyString(sEXCHANGE_EMAIL) )
				service.ImpersonatedUserId = new ImpersonatedUserId(ConnectingIdType.SmtpAddress  , sEXCHANGE_EMAIL);
			// 03/31/2010 Paul.  We don't need to impersonate if the alias is the same as the user. 
			// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
			else if ( sIMPERSONATED_TYPE == "PrincipalName" )
			{
				if ( sUSER_NAME != sEXCHANGE_ALIAS && !Sql.IsEmptyString(sEXCHANGE_ALIAS) )
					service.ImpersonatedUserId = new ImpersonatedUserId(ConnectingIdType.PrincipalName, sEXCHANGE_ALIAS);
			}
			return service;
		}

		public ExchangeService CreateExchangeService(ExchangeSync.UserSync User)
		{
			// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
			Guid gEXCHANGE_ID = Guid.Empty;
			if ( User.OFFICE365_OAUTH_ENABLED )
				gEXCHANGE_ID = User.USER_ID;
			return CreateExchangeService(User.EXCHANGE_ALIAS, User.EXCHANGE_EMAIL, User.MAIL_SMTPUSER, User.MAIL_SMTPPASS, gEXCHANGE_ID);
		}

		#endregion

		private void UpdateFolderTreeNodeCounts(ExchangeService service, XmlNode xFolder)
		{
			XmlDocument xml = xFolder.OwnerDocument;
			int nPageOffset = 0;
			const int nPageSize = 100;
			string sFOLDER_ID = XmlUtil.GetNamedItem(xFolder, "Id"  );
			FindFoldersResults fChildResults = null;
			do
			{
				fChildResults = service.FindFolders(sFOLDER_ID, new FolderView(nPageSize, nPageOffset));
				foreach (Folder fld in fChildResults.Folders )
				{
					if ( Sql.IsEmptyString(fld.FolderClass) || fld.FolderClass == "IPF.Note" )
					{
						XmlNode xChild = xFolder.SelectSingleNode("//Folder[@Id=" + XmlUtil.EncaseXpathString(fld.Id.UniqueId) + "]");
						if ( xChild == null )
						{
							xChild = xml.CreateElement("Folder");
							xFolder.AppendChild(xChild);
							XmlUtil.SetSingleNodeAttribute(xml, xChild, "Id", fld.Id.UniqueId);
						}
						XmlUtil.SetSingleNodeAttribute(xml, xChild, "FolderClass", fld.FolderClass           );
						XmlUtil.SetSingleNodeAttribute(xml, xChild, "TotalCount" , fld.TotalCount .ToString());
						XmlUtil.SetSingleNodeAttribute(xml, xChild, "Name"       , fld.DisplayName           );
						if ( fld.UnreadCount > 0 )
							XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", "<b>" + fld.DisplayName + "</b> <font color=blue>(" + fld.UnreadCount.ToString() + ")</font>");
						else
							XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", fld.DisplayName           );
					}
				}
				nPageOffset += nPageSize;
			}
			while ( fChildResults.MoreAvailable );
		}

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public void UpdateFolderTreeNodeCounts(ExchangeSync.UserSync User, XmlNode xFolder)
		{
			ExchangeService service = this.CreateExchangeService(User);
			UpdateFolderTreeNodeCounts(service, xFolder);
		}

		private void GetFolderTreeFromResults(ExchangeService service, XmlNode xParent, FindFoldersResults fResults)
		{
			XmlDocument xml = xParent.OwnerDocument;
			foreach (Folder fld in fResults.Folders )
			{
				if ( Sql.IsEmptyString(fld.FolderClass) || fld.FolderClass == "IPF.Note" )
				{
					XmlElement xChild = xml.CreateElement("Folder");
					xParent.AppendChild(xChild);
					XmlUtil.SetSingleNodeAttribute(xml, xChild, "Id"         , fld.Id.UniqueId           );
					XmlUtil.SetSingleNodeAttribute(xml, xChild, "FolderClass", fld.FolderClass           );
					XmlUtil.SetSingleNodeAttribute(xml, xChild, "TotalCount" , fld.TotalCount .ToString());
					// 07/31/2010 Paul.  We need to separate the Name from the DisplayName due to the formatting differences. 
					XmlUtil.SetSingleNodeAttribute(xml, xChild, "Name"       , fld.DisplayName           );
					if ( fld.UnreadCount > 0 )
						XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", "<b>" + fld.DisplayName + "</b> <font color=blue>(" + fld.UnreadCount.ToString() + ")</font>");
					else
						XmlUtil.SetSingleNodeAttribute(xml, xChild, "DisplayName", fld.DisplayName           );
					if ( fld.ChildFolderCount > 0 )
					{
						int nPageOffset = 0;
						const int nPageSize = 100;
						FindFoldersResults fChildResults = null;
						do
						{
							fChildResults = service.FindFolders(fld.Id, new FolderView(nPageSize, nPageOffset));
							GetFolderTreeFromResults(service, xChild, fChildResults);
							nPageOffset += nPageSize;
						}
						while ( fChildResults.MoreAvailable );
					}
				}
			}
		}

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public XmlDocument GetFolderTree(ExchangeSync.UserSync User, ref string sInboxFolderId)
		{
			XmlDocument xml = new XmlDocument();
			xml.AppendChild(xml.CreateProcessingInstruction("xml" , "version=\"1.0\" encoding=\"UTF-8\""));
			xml.AppendChild(xml.CreateElement("Folders"));
			
			ExchangeService service = this.CreateExchangeService(User);
			int nPageOffset = 0;
			const int nPageSize = 100;
			FindFoldersResults fResults = null;
			XmlUtil.SetSingleNodeAttribute(xml, xml.DocumentElement, "DisplayName", "Mailbox - " + User.EXCHANGE_ALIAS);
			Folder fldInbox = Folder.Bind(service, WellKnownFolderName.Inbox);
			sInboxFolderId = fldInbox.Id.UniqueId;
			do
			{
				fResults = service.FindFolders(WellKnownFolderName.MsgFolderRoot, new FolderView(nPageSize, nPageOffset));
				GetFolderTreeFromResults(service, xml.DocumentElement, fResults);
				nPageOffset += nPageSize;
			}
			while ( fResults.MoreAvailable );
			return xml;
		}

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public void GetFolderCount(ExchangeSync.UserSync User, string sFOLDER_ID, ref int nTotalCount, ref int nUnreadCount)
		{
			ExchangeService service = this.CreateExchangeService(User);
			Folder fld = Folder.Bind(service, sFOLDER_ID);
			nTotalCount  = fld.TotalCount ;
			nUnreadCount = fld.UnreadCount;
		}

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public void DeleteMessage(ExchangeSync.UserSync User, string sUNIQUE_ID)
		{
			ExchangeService service = this.CreateExchangeService(User);
			Item itm = Item.Bind(service, sUNIQUE_ID);
			itm.Delete(DeleteMode.MoveToDeletedItems);
		}

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public DataTable GetMessage(ExchangeSync.UserSync User, string sUNIQUE_ID)
		{
			DataTable dt = null;
			
			ExchangeService service = this.CreateExchangeService(User);
			PropertySet psItemClass = new PropertySet(BasePropertySet.IdOnly, ItemSchema.ItemClass);
			Item item = Item.Bind(service, sUNIQUE_ID, psItemClass);
			if ( item.ItemClass == "IPM.Note" )
				dt = GetMessage(service, sUNIQUE_ID);
			else if ( item.ItemClass == "IPM.Post" )
				dt = GetPost(service, sUNIQUE_ID);
			return dt;
		}

		// 07/17/2010 Paul.  Method name should be singular as only one message is being retrieved. 
		public DataTable GetMessage(ExchangeService service, string sUNIQUE_ID)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			// 01/26/2017 Paul.  Convert to MimeMessage
#if true
			PropertySet psMime = new PropertySet(BasePropertySet.IdOnly, ItemSchema.MimeContent, ItemSchema.Size);
			EmailMessage message = EmailMessage.Bind(service, sUNIQUE_ID, psMime);
			using ( MemoryStream mem = new MemoryStream(message.MimeContent.Content) )
			{
				MimeKit.MimeMessage email = MimeKit.MimeMessage.Load(mem);
				if ( email != null )
				{
					MimeUtils.CreateMessageRecord(dt, email, message.Size);
				}
			}
#else
			DataRow row = dt.NewRow();
			dt.Rows.Add(row);
			
			// 06/04/2010 Paul.  In our first request, we are going to get the plain-text body. 
			PropertySet psBodyText = new PropertySet(BasePropertySet.IdOnly, EmailMessageSchema.Body);
			psBodyText.RequestedBodyType = BodyType.Text;
			EmailMessage email = EmailMessage.Bind(service, sUNIQUE_ID, psBodyText);
			row["DESCRIPTION"] = email.Body.Text;
			// 06/04/2010 Paul.  Then we will load the entire email.
			email.Load();
			
			double dSize = email.Size;
			string sSize = String.Empty;
			if ( dSize < 1024 )
				sSize = dSize.ToString() + " B";
			else if ( dSize < 1024 * 1024 )
				sSize = Math.Floor(dSize / 1024).ToString() + " KB";
			else
				sSize = Math.Floor(dSize / (1024 * 1024)).ToString() + " MB";

			XmlDocument xmlInternetHeaders = new XmlDocument();
			xmlInternetHeaders.AppendChild(xmlInternetHeaders.CreateElement("Headers"));
			// 06/26/2015 Paul.   Body and InternetHeaders are not loaded as part of the FirstClassProperties. 
			if ( email.InternetMessageHeaders != null )
			{
				for ( int i = 0; i < email.InternetMessageHeaders.Count; i++ )
				{
					XmlElement xHeader = xmlInternetHeaders.CreateElement("Header");
					xmlInternetHeaders.DocumentElement.AppendChild(xHeader);
					XmlElement xName  = xmlInternetHeaders.CreateElement("Name" );
					XmlElement xValue = xmlInternetHeaders.CreateElement("Value");
					xHeader.AppendChild(xName );
					xHeader.AppendChild(xValue);
					xName .InnerText = email.InternetMessageHeaders[i].Name ;
					xValue.InnerText = email.InternetMessageHeaders[i].Value;
				}
			}
			row["ID"                    ] = Guid.NewGuid().ToString().Replace('-', '_');
			row["UNIQUE_ID"             ] = email.Id.UniqueId                ;
			row["SIZE"                  ] = email.Size                       ;
			row["SIZE_STRING"           ] = sSize                            ;
			row["IS_READ"               ] = email.IsRead                     ;
			// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
			row["HAS_ATTACHMENTS"       ] = (email.Attachments != null && email.Attachments.Count > 0);
			row["TO_ADDRS"              ] = email.DisplayTo                  ;
			row["CC_ADDRS"              ] = email.DisplayCc                  ;
			row["NAME"                  ] = email.Subject                    ;
			row["MESSAGE_ID"            ] = email.InternetMessageId          ;
			row["DATE_START"            ] = email.LastModifiedTime.ToLocalTime();
			row["DATE_MODIFIED"         ] = email.LastModifiedTime.ToLocalTime();
			row["DATE_ENTERED"          ] = email.DateTimeCreated .ToLocalTime();
			//row["DateTimeReceived"      ] = email.DateTimeReceived.ToLocalTime();
			row["CATEGORIES"            ] = email.Categories      .ToString();
			//row["BodyType"              ] = email.Body.BodyType   .ToString();
			row["INTERNET_HEADERS"      ] = xmlInternetHeaders.OuterXml;
			row["DESCRIPTION_HTML"      ] = email.Body.Text                        ;
			if ( email.From != null )
			{
				string sFrom = String.Empty;
				if ( Sql.IsEmptyString(email.From.Address) )
					sFrom = email.From.Name;
				else if ( Sql.IsEmptyString(email.From.Name) )
					sFrom = email.From.Address;
				else
					sFrom = String.Format("{0} <{1}>", email.From.Name, email.From.Address);
				row["FROM"      ] = sFrom                 ;
				row["FROM_ADDR" ] = email.From.Address    ;
				row["FROM_NAME" ] = email.From.Name       ;
				if ( email.IsFromMe )
					row["DATE_START"] = email.DateTimeSent.ToLocalTime();
				else
					row["DATE_START"] = email.DateTimeReceived.ToLocalTime();
			}
			if ( email.ToRecipients != null && email.ToRecipients.Count > 0 )
			{
				StringBuilder sbTO_ADDRS = new StringBuilder();
				foreach ( EmailAddress addr in email.ToRecipients )
				{
					if ( sbTO_ADDRS.Length > 0 ) sbTO_ADDRS.Append(';');
					if ( Sql.IsEmptyString(addr.Address) )
						sbTO_ADDRS.Append(addr.Name);
					else if ( Sql.IsEmptyString(addr.Name) )
						sbTO_ADDRS.Append(addr.Address);
					else
						sbTO_ADDRS.Append(String.Format("{0} <{1}>", addr.Name, addr.Address));
				}
				row["TO_ADDRS"] = sbTO_ADDRS.ToString();
			}
			if ( email.CcRecipients != null && email.CcRecipients.Count > 0 )
			{
				StringBuilder sbCC_ADDRS = new StringBuilder();
				foreach ( EmailAddress addr in email.CcRecipients )
				{
					if ( sbCC_ADDRS.Length > 0 ) sbCC_ADDRS.Append(';');
					if ( Sql.IsEmptyString(addr.Address) )
						sbCC_ADDRS.Append(addr.Name);
					else if ( Sql.IsEmptyString(addr.Name) )
						sbCC_ADDRS.Append(addr.Address);
					else
						sbCC_ADDRS.Append(String.Format("{0} <{1}>", addr.Name, addr.Address));
				}
				row["CC_ADDRS"] = sbCC_ADDRS.ToString();
			}
			// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
			//if ( email.HasAttachments )
			if ( email.Attachments != null && email.Attachments.Count > 0 )
			{
				row["ATTACHMENTS"] = GetAttachments(email);
			}
#endif
			return dt;
		}

		// 01/28/2017 Paul.  InboundEmail needs the result in MimeMessage format. 
		public void GetMessage(Guid gMAILBOX_ID, string sUNIQUE_ID, ref string sNAME, ref string sFROM_ADDR, ref bool bIS_READ, ref int nSIZE)
		{
			ExchangeService service = CreateExchangeService(String.Empty, String.Empty, String.Empty, String.Empty, gMAILBOX_ID);
			PropertySet psMime = new PropertySet(BasePropertySet.IdOnly, EmailMessageSchema.Subject, EmailMessageSchema.From, ItemSchema.Size, EmailMessageSchema.IsRead);
			EmailMessage message = EmailMessage.Bind(service, sUNIQUE_ID, psMime);
			if ( message != null )
			{
				sNAME = Sql.ToString(message.Subject);
				if ( message.From != null )
				{
					sFROM_ADDR = Sql.ToString(message.From.Address).ToLower();
				}
				bIS_READ = message.IsRead;
				nSIZE    = message.Size  ;
			}
		}

		public void MarkAsRead(Guid gMAILBOX_ID, string sUNIQUE_ID)
		{
			ExchangeService service = CreateExchangeService(String.Empty, String.Empty, String.Empty, String.Empty, gMAILBOX_ID);
			PropertySet psMime = new PropertySet(BasePropertySet.IdOnly, EmailMessageSchema.IsRead);
			EmailMessage message = EmailMessage.Bind(service, sUNIQUE_ID, psMime);
			if ( message != null )
			{
				if ( !message.IsRead )
				{
					message.IsRead = true;
					message.Update(ConflictResolutionMode.AutoResolve);
				}
			}
		}

		public void MarkAsUnread(Guid gMAILBOX_ID, string sUNIQUE_ID)
		{
			ExchangeService service = CreateExchangeService(String.Empty, String.Empty, String.Empty, String.Empty, gMAILBOX_ID);
			PropertySet psMime = new PropertySet(BasePropertySet.IdOnly, EmailMessageSchema.IsRead);
			EmailMessage message = EmailMessage.Bind(service, sUNIQUE_ID, psMime);
			if ( message != null )
			{
				if ( message.IsRead )
				{
					message.IsRead = false;
					message.Update(ConflictResolutionMode.AutoResolve);
				}
			}
		}

		public DataTable GetPost(ExchangeService service, string sUNIQUE_ID)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			DataRow row = dt.NewRow();
			dt.Rows.Add(row);
			
			// 06/04/2010 Paul.  In our first request, we are going to get the plain-text body. 
			PropertySet psBodyText = new PropertySet(BasePropertySet.IdOnly, PostItemSchema.Body);
			psBodyText.RequestedBodyType = BodyType.Text;
			PostItem email = PostItem.Bind(service, sUNIQUE_ID, psBodyText);
			row["DESCRIPTION"] = email.Body.Text;
			// 06/04/2010 Paul.  Then we will load the entire email.
			email.Load();
			
			double dSize = email.Size;
			string sSize = String.Empty;
			if ( dSize < 1024 )
				sSize = dSize.ToString() + " B";
			else if ( dSize < 1024 * 1024 )
				sSize = Math.Floor(dSize / 1024).ToString() + " KB";
			else
				sSize = Math.Floor(dSize / (1024 * 1024)).ToString() + " MB";

			row["ID"                    ] = Guid.NewGuid().ToString().Replace('-', '_');
			row["UNIQUE_ID"             ] = email.Id.UniqueId                ;
			row["SIZE"                  ] = email.Size                       ;
			row["SIZE_STRING"           ] = sSize                            ;
			row["IS_READ"               ] = email.IsRead                     ;
			// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
			row["HAS_ATTACHMENTS"       ] = (email.Attachments != null && email.Attachments.Count > 0);
			row["TO_ADDRS"              ] = String.Empty                     ;
			row["CC_ADDRS"              ] = String.Empty                     ;
			row["NAME"                  ] = email.Subject                    ;
			row["MESSAGE_ID"            ] = String.Empty                     ;
			row["DATE_START"            ] = email.LastModifiedTime.ToLocalTime();
			row["DATE_MODIFIED"         ] = email.LastModifiedTime.ToLocalTime();
			row["DATE_ENTERED"          ] = email.DateTimeCreated .ToLocalTime();
			row["CATEGORIES"            ] = email.Categories      .ToString();
			row["DESCRIPTION_HTML"      ] = email.Body.Text                  ;
			// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
			//if ( email.HasAttachments )
			if ( email.Attachments != null && email.Attachments.Count > 0 )
			{
				row["ATTACHMENTS"] = GetAttachments(email);
			}
			return dt;
		}

		// 11/06/2010 Paul.  Return the Attachments so that we can show embedded images or download the attachments. 
		public string GetAttachments(Item email)
		{
			XmlDocument xml = new XmlDocument();
			xml.AppendChild(xml.CreateXmlDeclaration("1.0", "UTF-8", null));
			xml.AppendChild(xml.CreateElement("Attachments"));
			foreach ( Attachment attach in email.Attachments )
			{
				if ( attach is FileAttachment )
				{
					FileAttachment part = attach as FileAttachment;
					XmlNode xAttachment = xml.CreateElement("Attachment");
					xml.DocumentElement.AppendChild(xAttachment);
					
					XmlUtil.SetSingleNode(xml, xAttachment, "ID"                , part.Id                        );
					XmlUtil.SetSingleNode(xml, xAttachment, "Name"              , part.Name                      );
					
					// 11/06/2010 Paul.  part.IsInline throws an exception.  If ContentId is not null, then the it is an inline image. 
					bool bIsInline = !String.IsNullOrEmpty(part.ContentId);
					XmlUtil.SetSingleNode(xml, xAttachment, "IsInline"          , bIsInline.ToString()       );
					try
					{
						if ( !String.IsNullOrEmpty(part.FileName) )
							XmlUtil.SetSingleNode(xml, xAttachment, "FileName"          , part.FileName                  );
						else
							XmlUtil.SetSingleNode(xml, xAttachment, "FileName"          , part.Name                      );
					}
					catch
					{
						XmlUtil.SetSingleNode(xml, xAttachment, "FileName"          , part.Name                      );
					}
					try
					{
						XmlUtil.SetSingleNode(xml, xAttachment, "Size"              , part.Size.ToString()           );
					}
					catch
					{
					}
					//XmlUtil.SetSingleNode(xml, xAttachment, "MediaType"         , part.ContentType.MediaType     );
					//XmlUtil.SetSingleNode(xml, xAttachment, "CharSet"           , part.ContentType.CharSet       );
					XmlUtil.SetSingleNode(xml, xAttachment, "ContentType"       , part.ContentType               );
					XmlUtil.SetSingleNode(xml, xAttachment, "ContentID"         , part.ContentId                 );
					//XmlUtil.SetSingleNode(xml, xAttachment, "ContentDescription", part.ContentDescription        );
					//XmlUtil.SetSingleNode(xml, xAttachment, "ContentEncoding"   , part.ContentEncoding.ToString());
					//XmlUtil.SetSingleNode(xml, xAttachment, "ContentMD5"        , part.ContentMD5                );
					//XmlUtil.SetSingleNode(xml, xAttachment, "ContentLanguage"   , part.ContentLanguage           );
					//XmlUtil.SetSingleNode(xml, xAttachment, "Disposition"       , part.Disposition               );
					//XmlUtil.SetSingleNode(xml, xAttachment, "Boundary"          , part.Boundary                  );
					XmlUtil.SetSingleNode(xml, xAttachment, "Location"          , part.ContentLocation           );
					try
					{
						XmlUtil.SetSingleNode(xml, xAttachment, "LastModifiedTime"  , part.LastModifiedTime.ToLocalTime().ToString());
					}
					catch
					{
					}
				}
			}
			return xml.OuterXml;
		}

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public byte[] GetAttachmentData(ExchangeSync.UserSync User, string sUNIQUE_ID, string sATTACHMENT_ID, ref string sFILENAME, ref string sCONTENT_TYPE, ref bool bINLINE)
		{
			byte[] byDataBinary = null;
			ExchangeService service = this.CreateExchangeService(User);
			EmailMessage email = EmailMessage.Bind(service, sUNIQUE_ID);
			email.Load();
			// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
			//if ( email.HasAttachments )
			if ( email.Attachments != null && email.Attachments.Count > 0 )
			{
				foreach ( Attachment part in email.Attachments )
				{
					// 01/24/2017 Paul.  When using MimeKit, the ID will be the file name. 
					if ( part.Id == sATTACHMENT_ID || part.Name == sATTACHMENT_ID )
					{
						if ( part is FileAttachment )
						{
							FileAttachment file = part as FileAttachment;
							try
							{
								bINLINE       = !String.IsNullOrEmpty(part.ContentId);
								sCONTENT_TYPE = part.ContentType;
								if ( !String.IsNullOrEmpty(file.FileName) )
									sFILENAME = Path.GetFileName(file.FileName);
								else
									sFILENAME = Path.GetFileName(part.Name);
							}
							catch
							{
								sFILENAME = Path.GetFileName(part.Name);
							}
							file.Load();
							byDataBinary = file.Content;
						}
						break;
					}
				}
			}
			return byDataBinary;
		}

		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public DataTable GetFolderMessages(ExchangeSync.UserSync User, string sFOLDER_ID, int nPageSize, int nPageOffset, string sSortColumn, string sSortOrder)
		{
			DataTable dt = MimeUtils.CreateMessageTable();
			ExchangeService service = this.CreateExchangeService(User);
			
			SearchFilter filter = null;
			ItemView ivMessages = new ItemView(nPageSize, nPageOffset);
			// https://msdn.microsoft.com/en-us/library/office/dn600367(v=exchg.150).aspx
			ivMessages.PropertySet = PropertySet.FirstClassProperties;
			if ( !Sql.IsEmptyString(sSortColumn) )
			{
				SortDirection sortDirection = SortDirection.Descending;
				if ( sSortOrder == "asc" )
					sortDirection = SortDirection.Ascending;
				PropertyDefinitionBase sortColumn = EmailMessageSchema.LastModifiedTime;
				switch ( sSortColumn )
				{
					case "FROM"      :  sortColumn = EmailMessageSchema.From        ;  break;
					case "NAME"      :  sortColumn = EmailMessageSchema.Subject     ;  break;
					case "DATE_START":  sortColumn = EmailMessageSchema.DateTimeSent;  break;
					case "TO_ADDRS"  :  sortColumn = EmailMessageSchema.DisplayTo   ;  break;
					case "SIZE"      :  sortColumn = EmailMessageSchema.Size        ;  break;
				}
				if ( sortColumn != EmailMessageSchema.LastModifiedTime )
					ivMessages.OrderBy.Add(sortColumn, sortDirection);
			}
			ivMessages.OrderBy.Add(EmailMessageSchema.LastModifiedTime, SortDirection.Descending);
			
			FindItemsResults<Item> results = null;
			if ( filter != null )
				results = service.FindItems(sFOLDER_ID, filter, ivMessages);
			else
				results = service.FindItems(sFOLDER_ID, ivMessages);
			
			foreach (Item itemMessage in results.Items )
			{
				if ( itemMessage is EmailMessage )
				{
					EmailMessage email = itemMessage as EmailMessage;
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
					row["UNIQUE_ID"      ] = email.Id.UniqueId      ;
					row["SIZE"           ] = email.Size             ;
					row["SIZE_STRING"    ] = sSize                  ;
					row["IS_READ"        ] = email.IsRead           ;
					row["TO_ADDRS"       ] = email.DisplayTo        ;
					row["CC_ADDRS"       ] = email.DisplayCc        ;
					row["NAME"           ] = email.Subject          ;
					row["MESSAGE_ID"     ] = email.InternetMessageId;
					row["DATE_START"     ] = email.LastModifiedTime.ToLocalTime();
					row["DATE_MODIFIED"  ] = email.LastModifiedTime.ToLocalTime();
					row["DATE_ENTERED"   ] = email.DateTimeCreated .ToLocalTime();
					//row["DateTimeReceived"] = email.DateTimeReceived.ToLocalTime();
					row["CATEGORIES"     ] = email.Categories      .ToString();
					//row["BodyType"       ] = email.Body.BodyType   .ToString();
					// Body and InternetHeaders are not loaded as part of the FirstClassProperties. 
					//row["INTERNET_HEADERS"] = email.InternetMessageHeaders.ToString();
					//row["DESCRIPTION"     ] = email.Body.Text                        ;
					if ( email.From != null )
					{
						string sFrom = String.Empty;
						if ( Sql.IsEmptyString(email.From.Address) )
							sFrom = email.From.Name;
						else if ( Sql.IsEmptyString(email.From.Name) )
							sFrom = email.From.Address;
						else
						{
							// 06/26/2015 Paul.  We do not want to display the Exchange address. 
							if ( email.From.Address.StartsWith("/") )
								sFrom = email.From.Name;
							else
							{
								// 06/26/2015 Paul.  We are going to encode in the UI. 
								sFrom = String.Format("{0} <{1}>", email.From.Name, email.From.Address);
							}
						}
						row["FROM"      ] = sFrom                 ;
						row["FROM_ADDR" ] = email.From.Address    ;
						row["FROM_NAME" ] = email.From.Name       ;
						if ( email.IsFromMe )
							row["DATE_START"] = email.DateTimeSent.ToLocalTime();
						else
							row["DATE_START"] = email.DateTimeReceived.ToLocalTime();
					}
					// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
					// 01/24/2017 Paul.  email.Attachments is empty.  
					row["HAS_ATTACHMENTS"] = email.HasAttachments ;
				}
				else if ( itemMessage is PostItem )
				{
					PostItem email = itemMessage as PostItem;
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

					row["ID"                    ] = Guid.NewGuid().ToString().Replace('-', '_');
					row["UNIQUE_ID"             ] = email.Id.UniqueId                ;
					row["SIZE"                  ] = email.Size                       ;
					row["SIZE_STRING"           ] = sSize                            ;
					row["IS_READ"               ] = email.IsRead                     ;
					// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
					// 01/24/2017 Paul.  email.Attachments is empty.  
					row["HAS_ATTACHMENTS"       ] = email.HasAttachments             ;
					row["TO_ADDRS"              ] = String.Empty                     ;
					row["CC_ADDRS"              ] = String.Empty                     ;
					row["NAME"                  ] = email.Subject                    ;
					row["MESSAGE_ID"            ] = String.Empty                     ;
					row["DATE_START"            ] = email.LastModifiedTime.ToLocalTime();
					row["DATE_MODIFIED"         ] = email.LastModifiedTime.ToLocalTime();
					row["DATE_ENTERED"          ] = email.DateTimeCreated .ToLocalTime();
					row["CATEGORIES"            ] = email.Categories      .ToString();
				}
			}
			nPageOffset += nPageSize;
			return dt;
		}

		public string GetFolderId(string sUSERNAME, string sPASSWORD, Guid gMAILBOX_ID, string sMAILBOX)
		{
			ExchangeService service = CreateExchangeService(String.Empty, String.Empty, sUSERNAME, sPASSWORD, gMAILBOX_ID);
			WellKnownFolderName fldExchangeRoot = WellKnownFolderName.MsgFolderRoot;
			SearchFilter filter = new SearchFilter.IsEqualTo(FolderSchema.DisplayName, sMAILBOX);
			FindFoldersResults fResults = service.FindFolders(fldExchangeRoot, filter, new FolderView(1, 0));
			if ( fResults.Folders.Count > 0 )
			{
				return fResults.Folders[0].Id.UniqueId;
			}
			return String.Empty;
		}

		public DataTable GetFolderMessages(string sUSERNAME, string sPASSWORD, Guid gMAILBOX_ID, string sMAILBOX, bool bONLY_SINCE, string sEXCHANGE_WATERMARK)
		{
			DataTable dt = new DataTable();
			dt.Columns.Add("UNIQUE_ID"         , typeof(System.String));
			dt.Columns.Add("EXCHANGE_WATERMARK", typeof(System.String));
			ExchangeService service = CreateExchangeService(String.Empty, String.Empty, sUSERNAME, sPASSWORD, gMAILBOX_ID);
			
			// 01/28/2017 Paul.  Only Since flag means that we only track changes. 
			if ( bONLY_SINCE )
			{
				PullSubscription pull = null;
				if ( !dictInboundSubscriptions.ContainsKey(gMAILBOX_ID) )
				{
					List<EventType> arrEvents  = new List<EventType>();
					arrEvents.Add(EventType.Created );
					arrEvents.Add(EventType.Modified);
					arrEvents.Add(EventType.Moved   );
					arrEvents.Add(EventType.Copied  );
				
					WellKnownFolderName fldExchangeRoot = WellKnownFolderName.MsgFolderRoot;
					SearchFilter filter = new SearchFilter.IsEqualTo(FolderSchema.DisplayName, sMAILBOX);
					List<FolderId> arrFolders = new List<FolderId>();
					FindFoldersResults fResults = service.FindFolders(fldExchangeRoot, filter, new FolderView(1, 0));
					if ( fResults.Folders.Count > 0 )
					{
						arrFolders.Add(fResults.Folders[0].Id);
					}
					
					pull = service.SubscribeToPullNotifications(arrFolders, 60, sEXCHANGE_WATERMARK, arrEvents.ToArray());
					dictInboundSubscriptions.Add(gMAILBOX_ID, pull);
				}
				else
				{
					pull = dictInboundSubscriptions[gMAILBOX_ID];
				}
				do
				{
					// 01/28/2017 Paul.  The Pull.Watermark changes with each call to GetEvents. 
					GetEventsResults results = pull.GetEvents();
					foreach ( ItemEvent evt in results.ItemEvents )
					{
						// evt.OldItemId;
						// evt.OldParentFolderId;
						// evt.EventType
						// evt.ParentFolderId.UniqueId;
						DataRow row = dt.NewRow();
						dt.Rows.Add(row);
						row["UNIQUE_ID"         ] = evt.ItemId.UniqueId;
						row["EXCHANGE_WATERMARK"] = pull.Watermark     ;
					}
				}
				while ( pull.MoreEventsAvailable.Value );
			}
			else
			{
				WellKnownFolderName fldExchangeRoot = WellKnownFolderName.MsgFolderRoot;
				SearchFilter filter = new SearchFilter.IsEqualTo(FolderSchema.DisplayName, sMAILBOX);
				FindFoldersResults fResults = service.FindFolders(fldExchangeRoot, filter, new FolderView(1, 0));
				if ( fResults.Folders.Count > 0 )
				{
					Folder fld = fResults.Folders[0];
					int nPageSize   = 100;
					int nPageOffset = 0;
					string sFOLDER_ID = fld.Id.UniqueId;
					while ( nPageOffset < fld.TotalCount )
					{
						ItemView ivMessages = new ItemView(nPageSize, nPageOffset);
						ivMessages.OrderBy.Add(EmailMessageSchema.DateTimeSent, SortDirection.Ascending);
						FindItemsResults<Item> results = service.FindItems(sFOLDER_ID, ivMessages);
						foreach (Item itemMessage in results.Items )
						{
							if ( itemMessage is EmailMessage )
							{
								EmailMessage email = itemMessage as EmailMessage;
								DataRow row = dt.NewRow();
								dt.Rows.Add(row);
								row["UNIQUE_ID"] = email.Id.UniqueId;
							}
						}
						nPageOffset += results.Items.Count;
					}
				}
				else
				{
					throw(new Exception("Could not find folder " + sMAILBOX + " for Mailbox " + gMAILBOX_ID.ToString()));
				}
			}
			return dt;
		}

		public Guid ImportMessage(HttpSessionState Session, ExchangeService service, IDbConnection con, string sPARENT_TYPE, Guid gPARENT_ID, string sEXCHANGE_ALIAS, Guid gUSER_ID, Guid gASSIGNED_USER_ID, Guid gTEAM_ID, string sTEAM_SET_LIST, string sREMOTE_KEY)
		{
			Guid gEMAIL_ID = Guid.Empty;
			long   lUploadMaxSize  = Sql.ToLong(Application["CONFIG.upload_maxsize"]);
			string sCULTURE        = L10N.NormalizeCulture(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			
			// 06/04/2010 Paul.  In our first request, we are going to get the plain-text body. 
			PropertySet psBodyText = new PropertySet(BasePropertySet.IdOnly, EmailMessageSchema.Body);
			psBodyText.RequestedBodyType = BodyType.Text;
			EmailMessage email = EmailMessage.Bind(service, sREMOTE_KEY, psBodyText);
			string sDESCRIPTION = email.Body.Text;
			bool bLoadSuccessful = false;
			try
			{
				// 01/28/2017 Paul.  Then we will load the entire email.
				email.Load();
				bLoadSuccessful = true;
			}
			catch(Exception ex)
			{
				string sError = "Error loading email for " + sEXCHANGE_ALIAS + ", " + sREMOTE_KEY + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
			if ( bLoadSuccessful )
			{
				// 11/06/2010 Paul.  Inline images are stored in the EMAIL_IMAGES table and not the NOTE_ATTACHMENTS table. 
				string sSiteURL = Utils.MassEmailerSiteURL();
				string sFileURL = sSiteURL + "Images/EmailImage.aspx?ID=";
				
				string sDESCRIPTION_HTML = email.Body.Text;
				DateTime dtREMOTE_DATE_MODIFIED_UTC = email.LastModifiedTime;
				DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.Parameters.Clear();
					// 04/22/2010 Paul.  Always lookup the Contact. 
					Guid   gCONTACT_ID     = Guid.Empty;
					Guid   gSENDER_USER_ID = gUSER_ID;
					string sSQL = String.Empty;
					sSQL = "select ID                      " + ControlChars.CrLf
					     + "  from vwCONTACTS              " + ControlChars.CrLf;
					cmd.CommandText = sSQL;
					// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
					Security.Filter(cmd, "Contacts", "view");
					Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							gCONTACT_ID = Sql.ToGuid(rdr["ID"]);
						}
					}
					
					string sREPLY_TO_NAME = String.Empty;
					string sREPLY_TO_ADDR = String.Empty;
					if ( email.ReplyTo != null && email.ReplyTo.Count > 0 )
					{
						sREPLY_TO_NAME = email.ReplyTo[0].Name   ;
						sREPLY_TO_ADDR = email.ReplyTo[0].Address;
					}
					
					StringBuilder sbTO_ADDRS_IDS    = new StringBuilder();
					StringBuilder sbTO_ADDRS_NAMES  = new StringBuilder();
					StringBuilder sbTO_ADDRS_EMAILS = new StringBuilder();
					if ( email.ToRecipients != null && email.ToRecipients.Count > 0 )
					{
						foreach ( EmailAddress addr in email.ToRecipients )
						{
							if ( sbTO_ADDRS_NAMES .Length > 0 ) sbTO_ADDRS_NAMES .Append(';');
							if ( sbTO_ADDRS_EMAILS.Length > 0 ) sbTO_ADDRS_EMAILS.Append(';');
							sbTO_ADDRS_NAMES .Append(addr.Name   );
							sbTO_ADDRS_EMAILS.Append(addr.Address);
							// 07/18/2010 Paul.  Exchange, Imap and Pop3 utils will all use this method to lookup a contact by email. 
							// 08/30/2010 Paul.  The previous method only returned Contacts, where as this new method returns Contacts, Leads and Prospects. 
							Guid gRECIPIENT_ID = Emails.RecipientByEmail(con, addr.Address);
							if ( !Sql.IsEmptyGuid(gRECIPIENT_ID) )
							{
								if ( sbTO_ADDRS_IDS.Length > 0 )
									sbTO_ADDRS_IDS.Append(';');
								sbTO_ADDRS_IDS.Append(gRECIPIENT_ID.ToString());
							}
						}
					}
					StringBuilder sbCC_ADDRS_IDS    = new StringBuilder();
					StringBuilder sbCC_ADDRS_NAMES  = new StringBuilder();
					StringBuilder sbCC_ADDRS_EMAILS = new StringBuilder();
					if ( email.CcRecipients != null && email.CcRecipients.Count > 0 )
					{
						foreach ( EmailAddress addr in email.CcRecipients )
						{
							if ( sbCC_ADDRS_NAMES .Length > 0 ) sbCC_ADDRS_NAMES .Append(';');
							if ( sbCC_ADDRS_EMAILS.Length > 0 ) sbCC_ADDRS_EMAILS.Append(';');
							sbCC_ADDRS_NAMES .Append(addr.Name   );
							sbCC_ADDRS_EMAILS.Append(addr.Address);
							// 07/18/2010 Paul.  Exchange, Imap and Pop3 utils will all use this method to lookup a contact by email. 
							// 08/30/2010 Paul.  The previous method only returned Contacts, where as this new method returns Contacts, Leads and Prospects. 
							Guid gRECIPIENT_ID = Emails.RecipientByEmail(con, addr.Address);
							if ( !Sql.IsEmptyGuid(gRECIPIENT_ID) )
							{
								if ( sbCC_ADDRS_IDS.Length > 0 )
									sbCC_ADDRS_IDS.Append(';');
								sbCC_ADDRS_IDS.Append(gRECIPIENT_ID.ToString());
							}
						}
					}
					StringBuilder sbBCC_ADDRS_IDS    = new StringBuilder();
					StringBuilder sbBCC_ADDRS_NAMES  = new StringBuilder();
					StringBuilder sbBCC_ADDRS_EMAILS = new StringBuilder();
					if ( email.BccRecipients != null && email.BccRecipients.Count > 0 )
					{
						foreach ( EmailAddress addr in email.BccRecipients )
						{
							if ( sbBCC_ADDRS_NAMES .Length > 0 ) sbBCC_ADDRS_NAMES .Append(';');
							if ( sbBCC_ADDRS_EMAILS.Length > 0 ) sbBCC_ADDRS_EMAILS.Append(';');
							sbBCC_ADDRS_NAMES .Append(addr.Name   );
							sbBCC_ADDRS_EMAILS.Append(addr.Address);
							// 07/18/2010 Paul.  Exchange, Imap and Pop3 utils will all use this method to lookup a contact by email. 
							// 08/30/2010 Paul.  The previous method only returned Contacts, where as this new method returns Contacts, Leads and Prospects. 
							Guid gRECIPIENT_ID = Emails.RecipientByEmail(con, addr.Address);
							if ( !Sql.IsEmptyGuid(gRECIPIENT_ID) )
							{
								if ( sbBCC_ADDRS_IDS.Length > 0 )
									sbBCC_ADDRS_IDS.Append(';');
								sbBCC_ADDRS_IDS.Append(gRECIPIENT_ID.ToString());
							}
						}
					}
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							// 11/06/2010 Paul.  Set ID so that it can be used with inline images. 
							gEMAIL_ID = Guid.NewGuid();
							if ( email.Attachments != null && email.Attachments.Count > 0 )
							{
								foreach ( Attachment attach in email.Attachments )
								{
									// 11/06/2010 Paul.  Inline images are stored in the EMAIL_IMAGES table and not the NOTE_ATTACHMENTS table. 
									bool bIsInline = !String.IsNullOrEmpty(attach.ContentId);
									if ( attach is FileAttachment && bIsInline )
									{
										FileAttachment file = attach as FileAttachment;
										file.Load();
										if ( file.Content != null )
										{
											string sFILENAME       = String.Empty;
											string sFILE_MIME_TYPE = file.ContentType;
											try
											{
												if ( !String.IsNullOrEmpty(file.FileName) )
													sFILENAME = Path.GetFileName(file.FileName);
												else
													sFILENAME = Path.GetFileName(file.Name);
											}
											catch
											{
												sFILENAME = Path.GetFileName(file.Name);
											}
											string sFILE_EXT = Path.GetExtension(sFILENAME);
											
											Guid gIMAGE_ID = Guid.Empty;
											SqlProcs.spEMAIL_IMAGES_Insert
												( ref gIMAGE_ID
												, gEMAIL_ID
												, sFILENAME
												, sFILE_EXT
												, sFILE_MIME_TYPE
												, trn
												);
											// 11/06/2010 Paul.  Move LoadFile() to Crm.NoteAttachments. 
											EmailImages.LoadFile(gIMAGE_ID, file.Content, trn);
											// 11/06/2010 Paul.  Now replace the ContentId with the new Image URL. 
											string sContentID = attach.ContentId;
											if ( sContentID.StartsWith("<") && sContentID.EndsWith(">") )
												sContentID = sContentID.Substring(1, sContentID.Length - 2);
											sDESCRIPTION_HTML = sDESCRIPTION_HTML.Replace("cid:" + sContentID, sFileURL + gIMAGE_ID.ToString());
										}
									}
								}
							}
							SqlProcs.spEMAILS_Update
								( ref gEMAIL_ID
								, gASSIGNED_USER_ID
								, email.Subject
								, email.IsFromMe ? email.DateTimeSent.ToLocalTime() : email.DateTimeReceived.ToLocalTime()
								, sPARENT_TYPE
								, gPARENT_ID
								, sDESCRIPTION        // DESCRIPTION
								, sDESCRIPTION_HTML   // DESCRIPTION_HTML
								, email.From.Address  // FROM_ADDR
								, email.From.Name     // FROM_NAME
								, email.DisplayTo
								, email.DisplayCc
								, String.Empty
								, sbTO_ADDRS_IDS    .ToString()
								, sbTO_ADDRS_NAMES  .ToString()
								, sbTO_ADDRS_EMAILS .ToString()
								, sbCC_ADDRS_IDS    .ToString()
								, sbCC_ADDRS_NAMES  .ToString()
								, sbCC_ADDRS_EMAILS .ToString()
								, sbBCC_ADDRS_IDS   .ToString()
								, sbBCC_ADDRS_NAMES .ToString()
								, sbBCC_ADDRS_EMAILS.ToString()
								, "archived"
								, email.InternetMessageId
								, sREPLY_TO_NAME
								, sREPLY_TO_ADDR
								, String.Empty  // INTENT
								, Guid.Empty    // MAILBOX_ID
								, gTEAM_ID
								, sTEAM_SET_LIST
								// 05/17/2017 Paul.  Add Tags module. 
								, String.Empty      // TAG_SET_NAME
								// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
								, false             // IS_PRIVATE
								// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
								, String.Empty      // ASSIGNED_SET_LIST
								, trn
								);
							
							// 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
							SqlProcs.spEMAIL_CLIENT_SYNC_Update(gUSER_ID, gEMAIL_ID, sREMOTE_KEY, sPARENT_TYPE, gPARENT_ID, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, trn);
							// 04/01/2010 Paul.  Always add the current user to the email. 
							SqlProcs.spEMAILS_USERS_Update(gEMAIL_ID, gUSER_ID, trn);
							// 04/01/2010 Paul.  Always lookup and assign the contact. 
							if ( !Sql.IsEmptyGuid(gCONTACT_ID) )
							{
								SqlProcs.spEMAILS_CONTACTS_Update(gEMAIL_ID, gCONTACT_ID, trn);
							}
							// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
							//if ( email.HasAttachments )
							if ( email.Attachments != null && email.Attachments.Count > 0 )
							{
								// 03/31/2010 Paul.  Web do not need to load the attachments separately. 
								// email.Load(new PropertySet(ItemSchema.Attachments));
								foreach ( Attachment attach in email.Attachments )
								{
									// 11/06/2010 Paul.  Inline images are stored in the EMAIL_IMAGES table and not the NOTE_ATTACHMENTS table. 
									bool bIsInline = !String.IsNullOrEmpty(attach.ContentId);
									if ( attach is FileAttachment && !bIsInline )
									{
										FileAttachment file = attach as FileAttachment;
										file.Load();
										if ( file.Content != null )
										{
											// 04/01/2010 Paul.  file.Size is only available on Exchange 2010. 
											long lFileSize = file.Content.Length;  // file.Size;
											if ( (lUploadMaxSize == 0) || (lFileSize <= lUploadMaxSize) )
											{
												string sFILENAME       = String.Empty;
												string sFILE_MIME_TYPE = file.ContentType;
												try
												{
													if ( !String.IsNullOrEmpty(file.FileName) )
														sFILENAME = Path.GetFileName(file.FileName);
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
													, L10N.Term(Application, sCULTURE, "Emails.LBL_EMAIL_ATTACHMENT") + ": " + sFILENAME
													, "Emails"   // Parent Type
													, gEMAIL_ID  // Parent ID
													, Guid.Empty
													, String.Empty
													, gTEAM_ID       // TEAM_ID
													, sTEAM_SET_LIST // TEAM_SET_LIST
													, gASSIGNED_USER_ID
													// 05/17/2017 Paul.  Add Tags module. 
													, String.Empty   // TAG_SET_NAME
													// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
													, false          // IS_PRIVATE
													// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
													, String.Empty   // ASSIGNED_SET_LIST
													, trn
													);
												
												Guid gNOTE_ATTACHMENT_ID = Guid.Empty;
												SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, file.FileName, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
												//SqlProcs.spNOTES_ATTACHMENT_Update(gNOTE_ATTACHMENT_ID, file.Content, trn);
												// 11/06/2010 Paul.  Use our streamable function. 
												// 11/06/2010 Paul.  Move LoadFile() to Crm.NoteAttachments. 
												NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, file.Content, trn);
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
			}
			return gEMAIL_ID;
		}

		// 07/31/2010 Paul.  Add support for IPM.Post import. 
		public Guid ImportPost(HttpSessionState Session, ExchangeService service, IDbConnection con, string sPARENT_TYPE, Guid gPARENT_ID, string sEXCHANGE_ALIAS, Guid gUSER_ID, Guid gASSIGNED_USER_ID, Guid gTEAM_ID, string sTEAM_SET_LIST, string sREMOTE_KEY)
		{
			Guid gEMAIL_ID = Guid.Empty;
			long   lUploadMaxSize  = Sql.ToLong(Application["CONFIG.upload_maxsize"]);
			string sCULTURE        = L10N.NormalizeCulture(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			
			// 06/04/2010 Paul.  In our first request, we are going to get the plain-text body. 
			PropertySet psBodyText = new PropertySet(BasePropertySet.IdOnly, PostItemSchema.Body);
			psBodyText.RequestedBodyType = BodyType.Text;
			PostItem email = PostItem.Bind(service, sREMOTE_KEY, psBodyText);
			string sDESCRIPTION = email.Body.Text;
			bool bLoadSuccessful = false;
			try
			{
				// 06/04/2010 Paul.  Then we will load the entire email.
				email.Load();
				bLoadSuccessful = true;
			}
			catch(Exception ex)
			{
				string sError = "Error loading email for " + sEXCHANGE_ALIAS + ", " + sREMOTE_KEY + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
			if ( bLoadSuccessful )
			{
				// 11/06/2010 Paul.  Inline images are stored in the EMAIL_IMAGES table and not the NOTE_ATTACHMENTS table. 
				string sSiteURL = Utils.MassEmailerSiteURL();
				string sFileURL = sSiteURL + "Images/EmailImage.aspx?ID=";
				
				string sDESCRIPTION_HTML = email.Body.Text;
				DateTime dtREMOTE_DATE_MODIFIED_UTC = email.LastModifiedTime;
				DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						// 11/06/2010 Paul.  Set ID so that it can be used with inline images. 
						gEMAIL_ID = Guid.NewGuid();
						if ( email.Attachments != null && email.Attachments.Count > 0 )
						{
							foreach ( Attachment attach in email.Attachments )
							{
								// 11/06/2010 Paul.  Inline images are stored in the EMAIL_IMAGES table and not the NOTE_ATTACHMENTS table. 
								bool bIsInline = !String.IsNullOrEmpty(attach.ContentId);
								if ( attach is FileAttachment && bIsInline )
								{
									FileAttachment file = attach as FileAttachment;
									file.Load();
									if ( file.Content != null )
									{
										string sFILENAME       = String.Empty;
										string sFILE_MIME_TYPE = file.ContentType;
										try
										{
											if ( !String.IsNullOrEmpty(file.FileName) )
												sFILENAME = Path.GetFileName(file.FileName);
											else
												sFILENAME = Path.GetFileName(file.Name);
										}
										catch
										{
											sFILENAME = Path.GetFileName(file.Name);
										}
										string sFILE_EXT = Path.GetExtension(sFILENAME);
										
										Guid gIMAGE_ID = Guid.Empty;
										SqlProcs.spEMAIL_IMAGES_Insert
											( ref gIMAGE_ID
											, gEMAIL_ID
											, sFILENAME
											, sFILE_EXT
											, sFILE_MIME_TYPE
											, trn
											);
										// 11/06/2010 Paul.  Move LoadFile() to Crm.NoteAttachments. 
										EmailImages.LoadFile(gIMAGE_ID, file.Content, trn);
										// 11/06/2010 Paul.  Now replace the ContentId with the new Image URL. 
										string sContentID = attach.ContentId;
										if ( sContentID.StartsWith("<") && sContentID.EndsWith(">") )
											sContentID = sContentID.Substring(1, sContentID.Length - 2);
										sDESCRIPTION_HTML = sDESCRIPTION_HTML.Replace("cid:" + sContentID, sFileURL + gIMAGE_ID.ToString());
									}
								}
							}
						}
						SqlProcs.spEMAILS_Update
							( ref gEMAIL_ID
							, gASSIGNED_USER_ID
							, email.Subject
							, email.LastModifiedTime.ToLocalTime()
							, sPARENT_TYPE
							, gPARENT_ID
							, sDESCRIPTION      // DESCRIPTION
							, sDESCRIPTION_HTML // DESCRIPTION_HTML
							, String.Empty  // FROM_ADDR
							, String.Empty  // FROM_NAME
							, String.Empty  // TO_ADDRS
							, String.Empty  // CC_ADDRS
							, String.Empty  // BCC_ADDRS
							, String.Empty  // TO_ADDRS_IDS
							, String.Empty  // TO_ADDRS_NAMES
							, String.Empty  // TO_ADDRS_EMAILS
							, String.Empty  // CC_ADDRS_IDS
							, String.Empty  // CC_ADDRS_NAMES
							, String.Empty  // CC_ADDRS_EMAILS
							, String.Empty  // BCC_ADDRS_IDS
							, String.Empty  // BCC_ADDRS_NAMES
							, String.Empty  // BCC_ADDRS_EMAILS
							, "archived"    // TYPE
							, String.Empty  // MESSAGE_ID
							, String.Empty  // REPLY_TO_NAME
							, String.Empty  // REPLY_TO_ADDR
							, String.Empty  // INTENT
							, Guid.Empty    // MAILBOX_ID
							, gTEAM_ID
							, sTEAM_SET_LIST
							// 05/17/2017 Paul.  Add Tags module. 
							, String.Empty  // TAG_SET_NAME
							// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
							, false         // IS_PRIVATE
							// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
							, String.Empty  // ASSIGNED_SET_LIST
							, trn
							);
						
						// 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
						SqlProcs.spEMAIL_CLIENT_SYNC_Update(gUSER_ID, gEMAIL_ID, sREMOTE_KEY, sPARENT_TYPE, gPARENT_ID, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, trn);
						// 04/01/2010 Paul.  Always add the current user to the email. 
						SqlProcs.spEMAILS_USERS_Update(gEMAIL_ID, gUSER_ID, trn);
						// 11/05/2010 Paul.  Inline images are not considered attachments, so they the HasAttachments flag may not be set. 
						//if ( email.HasAttachments )
						if ( email.Attachments != null && email.Attachments.Count > 0 )
						{
							// 03/31/2010 Paul.  Web do not need to load the attachments separately. 
							// email.Load(new PropertySet(ItemSchema.Attachments));
							foreach ( Attachment attach in email.Attachments )
							{
								// 11/06/2010 Paul.  Inline images are stored in the EMAIL_IMAGES table and not the NOTE_ATTACHMENTS table. 
								bool bIsInline = !String.IsNullOrEmpty(attach.ContentId);
								if ( attach is FileAttachment && !bIsInline )
								{
									FileAttachment file = attach as FileAttachment;
									file.Load();
									if ( file.Content != null )
									{
										// 04/01/2010 Paul.  file.Size is only available on Exchange 2010. 
										long lFileSize = file.Content.Length;  // file.Size;
										if ( (lUploadMaxSize == 0) || (lFileSize <= lUploadMaxSize) )
										{
											string sFILENAME       = String.Empty;
											string sFILE_MIME_TYPE = file.ContentType;
											try
											{
												if ( !String.IsNullOrEmpty(file.FileName) )
													sFILENAME = Path.GetFileName(file.FileName);
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
												, L10N.Term(Application, sCULTURE, "Emails.LBL_EMAIL_ATTACHMENT") + ": " + sFILENAME
												, "Emails"   // Parent Type
												, gEMAIL_ID  // Parent ID
												, Guid.Empty
												, String.Empty
												, gTEAM_ID       // TEAM_ID
												, sTEAM_SET_LIST // TEAM_SET_LIST
												, gASSIGNED_USER_ID
												// 05/17/2017 Paul.  Add Tags module. 
												, String.Empty   // TAG_SET_NAME
												// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
												, false          // IS_PRIVATE
												// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
												, String.Empty   // ASSIGNED_SET_LIST
												, trn
												);
											
											Guid gNOTE_ATTACHMENT_ID = Guid.Empty;
											SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, file.FileName, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
											//SqlProcs.spNOTES_ATTACHMENT_Update(gNOTE_ATTACHMENT_ID, file.Content, trn);
											// 11/06/2010 Paul.  Use our streamable function. 
											// 11/06/2010 Paul.  Move LoadFile() to Crm.NoteAttachments. 
											NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, file.Content, trn);
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
			return gEMAIL_ID;
		}

		// 06/02/2010 Paul.  This version cannot be called from a background thread. 
		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public Guid ImportMessage(ExchangeSync.UserSync User, HttpSessionState Session, string sPARENT_TYPE, Guid gPARENT_ID, Guid gASSIGNED_USER_ID, Guid gTEAM_ID, string sTEAM_SET_LIST, string sREMOTE_KEY)
		{
			Guid gEMAIL_ID = Guid.Empty;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				
				string sSQL = String.Empty;
				// 07/24/2010 Paul.  We have a problem in the the REMOTE_KEY is case-significant, but the query is not. 
				// This is the reason why some messages are not getting imported into the CRM. 
				// 07/24/2010 Paul.  Instead of managing collation in code, it is better to change the collation on the field in the database. 
				// 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
				sSQL = "select SYNC_LOCAL_ID                                 " + ControlChars.CrLf
				     + "  from vwEMAIL_CLIENT_SYNC                           " + ControlChars.CrLf
				     + " where SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
				     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + /* Sql.CaseSensitiveCollation(con) + */ ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", User.USER_ID   );
					Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
					gEMAIL_ID = Sql.ToGuid(cmd.ExecuteScalar());
					if ( Sql.IsEmptyGuid(gEMAIL_ID) )
					{
						// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
						ExchangeService service = this.CreateExchangeService(User);
						// 07/31/2010 Paul.  We do not want to allow the import of anything other than an Email, 
						// so get the ItemClass first and throw an exception if the class is not supported. 
						PropertySet psItemClass = new PropertySet(BasePropertySet.IdOnly, ItemSchema.ItemClass);
						Item item = Item.Bind(service, sREMOTE_KEY, psItemClass);
						if ( item.ItemClass == "IPM.Note" )
							gEMAIL_ID = ImportMessage(Session, service, con, sPARENT_TYPE, gPARENT_ID, User.EXCHANGE_ALIAS, User.USER_ID, gASSIGNED_USER_ID, gTEAM_ID, sTEAM_SET_LIST, sREMOTE_KEY);
						else if ( item.ItemClass == "IPM.Post" )
							gEMAIL_ID = ImportPost(Session, service, con, sPARENT_TYPE, gPARENT_ID, User.EXCHANGE_ALIAS, User.USER_ID, gASSIGNED_USER_ID, gTEAM_ID, sTEAM_SET_LIST, sREMOTE_KEY);
						else
							throw(new Exception("Cannot import a message of type " + item.ItemClass));
						
					}
					else
					{
						// 06/04/2010 Paul.  If the email already exists, then create the relationship. 
						SqlProcs.spEMAILS_RELATED_Update(gEMAIL_ID, sPARENT_TYPE, gPARENT_ID);
					}
				}
			}
			return gEMAIL_ID;
		}

		public string NormalizeInternetAddressName(EmailAddress addr)
		{
			string sDisplayName = addr.Name;
			if ( Sql.IsEmptyString(sDisplayName) )
				sDisplayName = addr.Address;
			else if ( sDisplayName.StartsWith("\"") && sDisplayName.EndsWith("\"") || sDisplayName.StartsWith("\'") && sDisplayName.EndsWith("\'") )
				sDisplayName = sDisplayName.Substring(1, sDisplayName.Length-2);
			return sDisplayName;
		}

		public void BuildAddressList(EmailAddress addr, StringBuilder sbTO_ADDRS, StringBuilder sbTO_ADDRS_NAMES, StringBuilder sbTO_ADDRS_EMAILS)
		{
			sbTO_ADDRS.Append((sbTO_ADDRS.Length > 0) ? "; " : String.Empty);
			sbTO_ADDRS.Append(addr.ToString());
			
			sbTO_ADDRS_NAMES.Append((sbTO_ADDRS_NAMES.Length > 0) ? "; " : String.Empty);
			sbTO_ADDRS_NAMES.Append(NormalizeInternetAddressName(addr));
			
			sbTO_ADDRS_EMAILS.Append((sbTO_ADDRS_EMAILS.Length > 0) ? "; " : String.Empty);
			sbTO_ADDRS_EMAILS.Append(addr.Address);
		}

		public Guid FindTargetTrackerKey(EmailMessage email, string sHtmlBody, string sTextBody)
		{
			Guid gTARGET_TRACKER_KEY = Guid.Empty;
			if ( email.InternetMessageHeaders != null )
			{
				foreach ( InternetMessageHeader prop in email.InternetMessageHeaders )
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

		public string EmbedInlineImages(EmailMessage email, string sDESCRIPTION_HTML)
		{
			// 01/21/2017 Paul.  Instead of saving the image as a separate record, save as data in the HTML. 
			// https://github.com/jstedfast/MimeKit/issues/134
			if ( email.Attachments != null && email.Attachments.Count > 0 )
			{
				foreach ( Attachment attach in email.Attachments )
				{
					bool bInline = attach.ContentId != null && attach.ContentType.StartsWith("image") && (sDESCRIPTION_HTML.IndexOf("cid:" + attach.ContentId) >= 0);
					if ( attach is FileAttachment && bInline )
					{
						FileAttachment part = attach as FileAttachment;
						part.Load();
						if ( part.Content != null )
						{
							string imageBase64 = "data:" + part.ContentType + ";base64," + Convert.ToBase64String(part.Content);
							sDESCRIPTION_HTML = sDESCRIPTION_HTML.Replace("cid:" + part.ContentId, imageBase64);
						}
					}
				}
			}
			return sDESCRIPTION_HTML;
		}

		public Guid ImportInboundEmail(IDbConnection con, Guid gMAILBOX_ID, string sINTENT, Guid gGROUP_ID, Guid gGROUP_TEAM_ID, string sUNIQUE_ID, string sUNIQUE_MESSAGE_ID)
		{
			ExchangeService service = CreateExchangeService(String.Empty, String.Empty, String.Empty, String.Empty, gMAILBOX_ID);
			
			// 01/28/2017 Paul.  In our first request, we are going to get the plain-text body. 
			PropertySet psBodyText = new PropertySet(BasePropertySet.IdOnly, EmailMessageSchema.Body);
			psBodyText.RequestedBodyType = BodyType.Text;
			EmailMessage email = EmailMessage.Bind(service, sUNIQUE_ID, psBodyText);
			string sDESCRIPTION = email.Body.Text;
			bool bLoadSuccessful = false;
			try
			{
				// 06/04/2010 Paul.  Then we will load the entire email.
				email.Load();
				bLoadSuccessful = true;
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
					
					DateTime dtREMOTE_DATE_MODIFIED_UTC = email.LastModifiedTime;
					DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
					string sFROM_ADDR = String.Empty;
					string sFROM_NAME = String.Empty;
					if ( email.From != null )
					{
						sFROM_ADDR = email.From.Address;
						sFROM_NAME = NormalizeInternetAddressName(email.From);
					}
					
					// 01/28/2017 Paul.  Save ReplyTo if it is available. 
					string sREPLY_TO_ADDR = String.Empty;
					string sREPLY_TO_NAME = String.Empty;
					if ( email.ReplyTo != null && email.ReplyTo.Count > 0 )
					{
						foreach ( EmailAddress addr in email.ReplyTo )
						{
							sREPLY_TO_NAME = NormalizeInternetAddressName(addr);
							sREPLY_TO_ADDR = addr.Address;
							break;
						}
					}
					
					StringBuilder sbTO_ADDRS        = new StringBuilder();
					StringBuilder sbTO_ADDRS_NAMES  = new StringBuilder();
					StringBuilder sbTO_ADDRS_EMAILS = new StringBuilder();
					if ( email.ToRecipients != null && email.ToRecipients.Count > 0 )
					{
						foreach ( EmailAddress addr in email.ToRecipients )
						{
							BuildAddressList(addr, sbTO_ADDRS, sbTO_ADDRS_NAMES, sbTO_ADDRS_EMAILS);
						}
					}
					
					StringBuilder sbCC_ADDRS        = new StringBuilder();
					StringBuilder sbCC_ADDRS_NAMES  = new StringBuilder();
					StringBuilder sbCC_ADDRS_EMAILS = new StringBuilder();
					if ( email.CcRecipients != null && email.CcRecipients.Count > 0 )
					{
						foreach ( EmailAddress addr in email.CcRecipients )
						{
							BuildAddressList(addr, sbTO_ADDRS, sbTO_ADDRS_NAMES, sbTO_ADDRS_EMAILS);
						}
					}
					
					StringBuilder sbBCC_ADDRS        = new StringBuilder();
					StringBuilder sbBCC_ADDRS_NAMES  = new StringBuilder();
					StringBuilder sbBCC_ADDRS_EMAILS = new StringBuilder();
					if ( email.BccRecipients != null && email.BccRecipients.Count > 0 )
					{
						foreach ( EmailAddress addr in email.BccRecipients )
						{
							BuildAddressList(addr, sbTO_ADDRS, sbTO_ADDRS_NAMES, sbTO_ADDRS_EMAILS);
						}
					}
					
					// 01/21/2017 Paul.  Only get the body values once as they may be computed. 
					// http://www.mimekit.net/docs/html/WorkingWithMessages.htm
					string sTextBody = sDESCRIPTION;
					string sHtmlBody = email.Body.Text;
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
								, email.IsFromMe ? email.DateTimeSent.ToLocalTime() : email.DateTimeReceived.ToLocalTime()
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
								foreach ( Attachment attach in email.Attachments )
								{
									// 01/28/2017 Paul.  Don't use sSAFE_BODY_HTML here because the content items will have already been replaced and would fail the inline test. 
									bool bInline = attach.ContentId != null && attach.ContentType.StartsWith("image") && (sHtmlBody.IndexOf("cid:" + attach.ContentId) >= 0);
									if ( attach is FileAttachment && !bInline )
									{
										FileAttachment file = attach as FileAttachment;
										file.Load();
										if ( file.Content != null )
										{
											// 04/01/2010 Paul.  file.Size is only available on Exchange 2010. 
											long lFileSize = file.Content.Length;  // file.Size;
											if ( (lUploadMaxSize == 0) || (lFileSize <= lUploadMaxSize) )
											{
												string sFILENAME       = String.Empty;
												string sFILE_MIME_TYPE = file.ContentType;
												try
												{
													if ( !String.IsNullOrEmpty(file.FileName) )
														sFILENAME = Path.GetFileName(file.FileName);
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
												SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, file.FileName, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
												//SqlProcs.spNOTES_ATTACHMENT_Update(gNOTE_ATTACHMENT_ID, file.Content, trn);
												// 11/06/2010 Paul.  Use our streamable function. 
												// 11/06/2010 Paul.  Move LoadFile() to Crm.NoteAttachments. 
												NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, file.Content, trn);
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
