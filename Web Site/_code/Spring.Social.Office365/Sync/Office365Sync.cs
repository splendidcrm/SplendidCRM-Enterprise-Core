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
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Net;
using System.Xml;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Diagnostics;

using SplendidCRM;

using Microsoft.AspNetCore.Http;

namespace Spring.Social.Office365
{
	public class Office365Sync
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private SplendidCRM.Crm.Modules          Modules          ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private SyncError            SyncError          ;
		private SplendidCRM.Crm.NoteAttachments NoteAttachments ;

		public const int    nPUSH_EXPIRATION_MINUTES = 1 * 24 * 60;  // Expires in 1 day. 
		public const string scope = "openid offline_access Mail.ReadWrite Mail.Send Contacts.ReadWrite Calendars.ReadWrite MailboxSettings.ReadWrite User.Read";
		public  static bool bInsideSyncAll      = false;
		private static List<Guid>                         arrProcessing         = new List<Guid>();
		// 01/22/2012 Paul.  Keep track of the last time we synced to prevent it from being too frequent. 
		private static Dictionary<Guid, DateTime>         dictLastSync          = new Dictionary<Guid,DateTime>();
		// 07/07/2018 Paul.  Add the SplendidCRM category to the user's master list if it does not already exist. 
		private static Dictionary<Guid, string>           dictSplendidCategories = new Dictionary<Guid,string>();
		// 05/12/2023 Paul.  Keep track of failures and don't delete token immediately. 
		private static Dictionary<Guid, int>              dictUserRefreshFailures = new Dictionary<Guid,int>();

		public Office365Sync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SplendidCRM.Crm.Modules Modules, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SplendidCRM.Crm.NoteAttachments NoteAttachments)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.Modules             = Modules            ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
			this.NoteAttachments     = NoteAttachments    ;
		}

		public bool Office365Enabled()
		{
			string sClientID         = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
			string sClientSecret     = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
			bool   bOffice365Enabled = !Sql.IsEmptyString(sClientSecret) && !Sql.IsEmptyString(sClientID);
			return bOffice365Enabled;
		}

		public Guid Office365UserID()
		{
			Guid gOFFICE365_USER_ID = Sql.ToGuid(Application["CONFIG.Exchange.UserID"]);
			if ( Sql.IsEmptyGuid(gOFFICE365_USER_ID) )
				gOFFICE365_USER_ID = new Guid("00000000-0000-0000-0000-00000000000D");  // Use special Office365 user. 
			return gOFFICE365_USER_ID;
		}

		public Spring.Social.Office365.Api.IOffice365 CreateApi(string sOAuthAccessToken)
		{
			Spring.Social.Office365.Api.IOffice365 office365 = null;
			string sOffice365ClientID     = Sql.ToString(Application["CONFIG.Exchange.ClientID"        ]);
			string sOffice365ClientSecret = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"    ]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			
			Spring.Social.Office365.Connect.Office365ServiceProvider office365ServiceProvider = new Spring.Social.Office365.Connect.Office365ServiceProvider(sOAuthDirectoryTenatID, sOffice365ClientID, sOffice365ClientSecret);
			office365 = office365ServiceProvider.GetApi(sOAuthAccessToken);
			return office365;
		}

		public bool RefreshAccessToken(string sOAuthAccessToken, string sOAuthExpiresAt, StringBuilder sbErrors)
		{
			bool bSuccess = false;
			string sOffice365ClientID     = Sql.ToString(Application["CONFIG.Office365.ClientID"         ]);
			string sOffice365ClientSecret = Sql.ToString(Application["CONFIG.Office365.ClientSecret"     ]);
			string sOAuthRefreshToken     = Sql.ToString(Application["CONFIG.Office365.OAuthRefreshToken"]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
			try
			{
				DateTime dtOAuthExpiresAt = Sql.ToDateTime(sOAuthExpiresAt);
				// 09/09/2015 Paul.  Need to make sure that a new token is retrieved even if values are null or date has expired. 
				if ( Sql.IsEmptyString(sOAuthAccessToken) || dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now.AddHours(1) > dtOAuthExpiresAt )
				{
					Spring.Social.Office365.Connect.Office365ServiceProvider office365ServiceProvider = new Spring.Social.Office365.Connect.Office365ServiceProvider(sOAuthDirectoryTenatID, sOffice365ClientID, sOffice365ClientSecret);
					Spring.Social.OAuth2.OAuth2Parameters parameters = new Spring.Social.OAuth2.OAuth2Parameters();
					// 01/28/2023 Paul.  Use RefreshAccessAsync instead of AuthenticateClientAsync. 
					office365ServiceProvider.OAuthOperations.RefreshAccessAsync(sOAuthRefreshToken, parameters)
						.ContinueWith<Spring.Social.OAuth2.AccessGrant>(task =>
						{
							if ( task.Status == System.Threading.Tasks.TaskStatus.RanToCompletion && task.Result != null )
							{
								DateTime dtExpires = (task.Result.ExpireTime.HasValue ? task.Result.ExpireTime.Value.ToLocalTime() : DateTime.Now.AddHours(8));
								sOAuthAccessToken  = task.Result.AccessToken     ;
								sOAuthExpiresAt    = dtExpires.ToShortDateString() + " " + dtExpires.ToShortTimeString();
							}
							else
							{
								// 04/27/2015 Paul.  If there is an error, clear the in-memory value only. We want to allow a retry. 
								Application["CONFIG.Office365.OAuthAccessToken"] = String.Empty;
								throw(new Exception("Could not refresh Office365 access token.", task.Exception));
							}
							return null;
						}).Wait();
					//SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					//using ( IDbConnection con = dbf.CreateConnection() )
					//{
					//	con.Open();
					//	using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					//	{
					//		try
					//		{
					//			Application["CONFIG.Office365.OAuthAccessToken"  ] = sOAuthAccessToken ;
					//			Application["CONFIG.Office365.OAuthExpiresAt"    ] = sOAuthExpiresAt   ;
					//			SqlProcs.spCONFIG_Update("system", "Office365.OAuthAccessToken"  , Sql.ToString(Application["CONFIG.Office365.OAuthAccessToken"  ]), trn);
					//			SqlProcs.spCONFIG_Update("system", "Office365.OAuthExpiresAt"    , Sql.ToString(Application["CONFIG.Office365.OAuthExpiresAt"    ]), trn);
					//			trn.Commit();
					//			bSuccess = true;
					//		}
					//		catch
					//		{
					//			trn.Rollback();
					//			throw;
					//		}
					//	}
					//}
				}
			}
			catch(Exception ex)
			{
				sbErrors.Append(Utils.ExpandException(ex));
			}
			return bSuccess;
		}

		// 11/09/2019 Paul.  Pass the RedirectURL so that we can call from the React client. 
		// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
		public Office365AccessToken Office365AcquireAccessToken(HttpRequest Request, string sOAuthDirectoryTenatID, string sOAuthClientID, string sOAuthClientSecret, Guid gUSER_ID, string sAuthorizationCode, string sRedirect)
		{
			Office365AccessToken token       = null;
			string sOAuthAccessToken  = String.Empty;
			string sOAuthRefreshToken = String.Empty;
			string sOAuthExpiresAt    = String.Empty;
			try
			{
				DateTime dtOAuthExpiresAt = DateTime.MinValue;
				if ( Sql.IsEmptyString(sRedirect) )
					sRedirect = Request.Scheme + "://" + Request.Host.Host + Sql.ToString(Application["rootURL"]) + "Office365OAuth";
				
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					try
					{
						// 02/10/2017 Paul.  Change to https://login.microsoftonline.com. 
						// https://blogs.technet.microsoft.com/enterprisemobility/2015/03/06/simplifying-our-azure-ad-authentication-flows/
						// 11/29/2020 Paul.  Update to version 2, https://docs.microsoft.com/en-us/graph/auth-v2-user
						// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
						if ( Sql.IsEmptyString(sOAuthDirectoryTenatID) )
							sOAuthDirectoryTenatID = "common";
						WebRequest webRequest = WebRequest.Create("https://login.microsoftonline.com/" + sOAuthDirectoryTenatID + "/oauth2/v2.0/token");
						webRequest.ContentType = "application/x-www-form-urlencoded";
						webRequest.Method = "POST";
						string scope = Spring.Social.Office365.Office365Sync.scope;
						// https://docs.microsoft.com/en-us/azure/active-directory/active-directory-v2-protocols-oauth-code
						// https://blogs.msdn.microsoft.com/exchangedev/2014/03/25/using-oauth2-to-access-calendar-contact-and-mail-api-in-office-365-exchange-online/
						string requestDetails = "grant_type=authorization_code&scope=" + HttpUtility.UrlEncode(scope) + "&code=" + HttpUtility.UrlEncode(sAuthorizationCode) + "&redirect_uri=" + HttpUtility.UrlEncode(sRedirect) + "&client_id=" + sOAuthClientID + "&client_secret=" + HttpUtility.UrlEncode(sOAuthClientSecret);
						byte[] bytes = System.Text.Encoding.ASCII.GetBytes(requestDetails);
						webRequest.ContentLength = bytes.Length;
						using ( Stream outputStream = webRequest.GetRequestStream() )
						{
							outputStream.Write(bytes, 0, bytes.Length);
						}
						using ( WebResponse webResponse = webRequest.GetResponse() )
						{
							DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(Office365AccessToken));
							token = (Office365AccessToken)serializer.ReadObject(webResponse.GetResponseStream());
						}
					}
					catch
					{
						// 01/16/2017 Paul.  If the refresh fails, delete the database record so that we will not retry the sync. 
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spOAUTH_TOKENS_Delete(gUSER_ID, "Office365", trn);
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
					dtOAuthExpiresAt   = DateTime.Now.AddSeconds(token.ExpiresInSeconds);
					sOAuthExpiresAt    = dtOAuthExpiresAt.ToShortDateString() + " " + dtOAuthExpiresAt.ToShortTimeString();
					Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
					Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
					Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							// 01/19/2017 Paul.  Name must match SEND_TYPE. 
							SqlProcs.spOAUTH_TOKENS_Update(gUSER_ID, "Office365", sOAuthAccessToken, String.Empty, dtOAuthExpiresAt, sOAuthRefreshToken, trn);
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
			catch
			{
				Application.Remove("CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthAccessToken" );
				Application.Remove("CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthRefreshToken");
				Application.Remove("CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthExpiresAt"   );
				throw;
			}
			return token;
		}

		// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
		public Office365AccessToken Office365RefreshAccessToken(string sOAuthDirectoryTenatID, string sOAuthClientID, string sOAuthClientSecret, Guid gUSER_ID, bool bForceRefresh)
		{
			Office365AccessToken token = null;
			string sOAuthAccessToken  = Sql.ToString(Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthAccessToken" ]);
			string sOAuthRefreshToken = Sql.ToString(Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthRefreshToken"]);
			string sOAuthExpiresAt    = Sql.ToString(Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ]);
			DateTime dtOAuthExpiresAt = Sql.ToDateTime(sOAuthExpiresAt);
			try
			{
				// 01/10/2021 Paul.  We were getting expired token errors, so try and get the profile prior to a sync operation. 
				if ( !(Sql.IsEmptyString(sOAuthAccessToken) || dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now > dtOAuthExpiresAt || bForceRefresh) )
				{
					Spring.Social.Office365.Api.IOffice365 office365 = this.CreateApi(sOAuthAccessToken);
					office365.MyProfileOperations.GetMyProfile();
				}
			}
			catch
			{
				bForceRefresh = true;
			}
			try
			{
				// 07/09/2018 Paul.  Decrease forward looking to 6 minutes. 
				if ( Sql.IsEmptyString(sOAuthAccessToken) || dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now > dtOAuthExpiresAt || bForceRefresh )
				{
					Application.Remove("CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthAccessToken" );
					Application.Remove("CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthRefreshToken");
					Application.Remove("CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthExpiresAt"   );
					
					sOAuthAccessToken = String.Empty;
					dtOAuthExpiresAt  = DateTime.MinValue;
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
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
								Sql.AddParameter(cmd, "@NAME"            , "Office365");
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
							throw(new Exception("Office 365 Access Token does not exist for user " + gUSER_ID.ToString()));
						}
						else if ( Sql.IsEmptyString(sOAuthRefreshToken) )
						{
							throw(new Exception("Office 365 Refresh Token does not exist for user " + gUSER_ID.ToString()));
						}
						// 07/09/2018 Paul.  Decrease forward looking to 6 minutes. 
						else if ( dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now > dtOAuthExpiresAt || bForceRefresh )
						{
							// 02/10/2017 Paul.  One endpoint to rule them all does not work with ExchangeService. https://graph.microsoft.io/en-us/
							// 02/10/2017 Paul.  Use new endpoint. https://msdn.microsoft.com/en-us/office/office365/api/use-outlook-rest-api
							try
							{
								// 02/10/2017 Paul.  Change to https://login.microsoftonline.com. 
								// https://blogs.technet.microsoft.com/enterprisemobility/2015/03/06/simplifying-our-azure-ad-authentication-flows/
								// 11/29/2020 Paul.  Update to version 2, https://docs.microsoft.com/en-us/graph/auth-v2-user
								// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
								if ( Sql.IsEmptyString(sOAuthDirectoryTenatID) )
									sOAuthDirectoryTenatID = "common";
								WebRequest webRequest = WebRequest.Create("https://login.microsoftonline.com/" + sOAuthDirectoryTenatID + "/oauth2/v2.0/token");
								webRequest.ContentType = "application/x-www-form-urlencoded";
								webRequest.Method = "POST";
								string scope = Spring.Social.Office365.Office365Sync.scope;
								// https://docs.microsoft.com/en-us/azure/active-directory/active-directory-v2-protocols-oauth-code
								// https://blogs.msdn.microsoft.com/exchangedev/2014/03/25/using-oauth2-to-access-calendar-contact-and-mail-api-in-office-365-exchange-online/
								
								// 11/29/2020 Paul.  The docs say the redirect_url is required, but the call succeeds without it.  Maybe it is succeeding because the token has not expired during our tests. 
								//  The problem with supplying the original URL is that it can come from the ASP.NET site or from the React Client. 
								string requestDetails = "grant_type=refresh_token&refresh_token=" + HttpUtility.UrlEncode(sOAuthRefreshToken) + "&scope=" + HttpUtility.UrlEncode(scope) + "&client_id=" + sOAuthClientID + "&client_secret=" + HttpUtility.UrlEncode(sOAuthClientSecret);
								byte[] bytes = System.Text.Encoding.ASCII.GetBytes(requestDetails);
								webRequest.ContentLength = bytes.Length;
								using ( Stream outputStream = webRequest.GetRequestStream() )
								{
									outputStream.Write(bytes, 0, bytes.Length);
								}
								using ( WebResponse webResponse = webRequest.GetResponse() )
								{
									DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(Office365AccessToken));
									token = (Office365AccessToken)serializer.ReadObject(webResponse.GetResponseStream());
								}
							}
							catch(Exception ex)
							{
								// 05/12/2023 Paul.  Keep track of failures and don't delete token immediately. 
								int nRefreshFailures    = 1;
								if ( dictUserRefreshFailures.ContainsKey(gUSER_ID) )
									nRefreshFailures = dictUserRefreshFailures[gUSER_ID] + 1;
								dictUserRefreshFailures[gUSER_ID] = nRefreshFailures;
								// 02/19/2021 Paul.  Token refresh is working most of the time, so maybe we can just ignore this error and retry a few minutes later. 
								if ( !ex.Message.Contains("The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel.") )
								{
									int nMaxRefreshFailures = Sql.ToInteger(Application["CONFIG.Office365.MaxRefreshFailures"]);
									if ( nMaxRefreshFailures == 0 )
										nMaxRefreshFailures = 12;
									if ( nRefreshFailures >= nMaxRefreshFailures )
									{
										// 01/16/2017 Paul.  If the refresh fails, delete the database record so that we will not retry the sync. 
										using ( IDbTransaction trn = Sql.BeginTransaction(con) )
										{
											try
											{
												SqlProcs.spOAUTH_TOKENS_Delete(gUSER_ID, "Office365", trn);
												trn.Commit();
											}
											catch
											{
												trn.Rollback();
											}
										}
										//if ( dictUserRefreshFailures.ContainsKey(gUSER_ID) )
										//	dictUserRefreshFailures.Remove(gUSER_ID);
									}
								}
								// 07/05/2018 Paul.  Add better error when refresh token fails. 
								throw(new Exception("Office 365 Refresh Token failed (" + nRefreshFailures.ToString() + " times) for user " + gUSER_ID.ToString(), ex));
							}
							// 05/12/2023 Paul.  Keep track of failures and don't delete token immediately. 
							if ( dictUserRefreshFailures.ContainsKey(gUSER_ID) )
								dictUserRefreshFailures.Remove(gUSER_ID);
							
							sOAuthAccessToken  = token.AccessToken ;
							sOAuthRefreshToken = token.RefreshToken;
							// 07/09/2018 Paul.  Office365 returns 3599, so token expires in 1 hour. 
							dtOAuthExpiresAt   = DateTime.Now.AddSeconds(token.ExpiresInSeconds);
							sOAuthExpiresAt    = dtOAuthExpiresAt.ToShortDateString() + " " + dtOAuthExpiresAt.ToShortTimeString();
							Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
							Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
							Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 01/19/2017 Paul.  Name must match SEND_TYPE. 
									SqlProcs.spOAUTH_TOKENS_Update(gUSER_ID, "Office365", sOAuthAccessToken, String.Empty, dtOAuthExpiresAt, sOAuthRefreshToken, trn);
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
							Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthAccessToken" ] = sOAuthAccessToken ;
							Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthRefreshToken"] = sOAuthRefreshToken;
							Application["CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
							token = new Office365AccessToken();
							token.AccessToken      = sOAuthAccessToken ;
							token.RefreshToken     = sOAuthRefreshToken;
							token.ExpiresInSeconds = Convert.ToInt64((dtOAuthExpiresAt - DateTime.Now).TotalSeconds);
							token.TokenType        = "Bearer";
						}
					}
				}
				else
				{
					token = new Office365AccessToken();
					token.AccessToken      = sOAuthAccessToken ;
					token.RefreshToken     = sOAuthRefreshToken;
					token.ExpiresInSeconds = Convert.ToInt64((dtOAuthExpiresAt - DateTime.Now).TotalSeconds);
					token.TokenType        = "Bearer";
				}
			}
			catch
			{
				Application.Remove("CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthAccessToken" );
				Application.Remove("CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthRefreshToken");
				Application.Remove("CONFIG.Office365." + gUSER_ID.ToString() + ".OAuthExpiresAt"   );
				throw;
			}
			return token;
		}

		// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
		public bool Office365TestAccessToken(string sOAuthDirectoryTenatID, string sOAuthClientID, string sOAuthClientSecret, Guid gUSER_ID, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Office365AccessToken token = Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret, gUSER_ID, false);
				// 02/10/2017 Paul.  https://outlook.office.com/EWS/Exchange.asmx does not work. 
				string sSERVER_URL = "https://outlook.office365.com/EWS/Exchange.asmx";
				if ( !Sql.IsEmptyString(sSERVER_URL) )
				{
					// 08/09/2018 Paul.  Allow translation of connection success. 
					Spring.Social.Office365.Api.IOffice365 office365 = this.CreateApi(token.access_token);
					IList<Spring.Social.Office365.Api.MailFolder> folders = office365.FolderOperations.GetAll(String.Empty);
					int nUnreadCount = office365.MailOperations.GetInboxUnreadCount();
					office365.ContactOperations.GetCount();
					office365.EventOperations.GetCount();

					string sCULTURE = Sql.ToString(Application["CONFIG.default_language"]);
					if ( Session != null )
						sCULTURE = Sql.ToString (Session["USER_SETTINGS/CULTURE"]);
					sbErrors.AppendLine(String.Format(L10N.Term(Application, sCULTURE, "Users.LBL_CONNECTION_SUCCESSFUL"), nUnreadCount.ToString(), "Inbox"));
					//sbErrors.AppendLine("Connection successful. " + nUnreadCount.ToString() + " items in Inbox" + "<br />");
				}
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		#region Subscription
		private static Dictionary<Guid, object> dictPullSubscriptions = new Dictionary<Guid, object>();
		private static Dictionary<Guid, Dictionary<string, Spring.Social.Office365.Api.Subscription>> dictPushSubscriptions = new Dictionary<Guid, Dictionary<string, Spring.Social.Office365.Api.Subscription>>();

		public void StopPullSubscription(Guid gUSER_ID)
		{
			if ( dictPullSubscriptions.ContainsKey(gUSER_ID) )
			{
				dictPullSubscriptions.Remove(gUSER_ID);
			}
		}

		public void StopPushSubscription(Guid gUSER_ID, Spring.Social.Office365.Api.IOffice365 service)
		{
			if ( dictPushSubscriptions.ContainsKey(gUSER_ID) )
			{
				dictPushSubscriptions.Remove(gUSER_ID);
			}
			if ( service != null )
			{
				IList<Spring.Social.Office365.Api.Subscription> subscriptions = service.SubscriptionOperations.GetAll();
				foreach ( Spring.Social.Office365.Api.Subscription sub in subscriptions )
				{
					service.SubscriptionOperations.Delete(sub.Id);
				}
			}
		}
		#endregion

		#region Sync Helpers
		// 12/25/2020 Paul.  We need to establish a queue as users to be processed may come from push or pull. 
		private static Queue<DataRow> queueUsers = new Queue<DataRow>();
		public void AddUserToQueue(DataRow row)
		{
			lock ( queueUsers )
			{
				bool bFound = false;
				Guid gUSER_ID = Sql.ToGuid(row["USER_ID"]);
				foreach ( DataRow rowQueue in queueUsers )
				{
					if ( gUSER_ID == Sql.ToGuid(rowQueue["USER_ID"]) )
					{
						bFound = true;
						break;
					}
				}
				// 12/25/2020 Paul.  No need to add if already in queue. 
				if ( !bFound )
					queueUsers.Enqueue(row);
			}
		}

		public bool AddUserToQueue(Guid gUSER_ID)
		{
			bool bAdded = false;
			try
			{
				using ( DataTable dt = new DataTable() )
				{
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL;
						sSQL = "select *                          " + ControlChars.CrLf
						     + "  from vwEXCHANGE_USERS           " + ControlChars.CrLf
						     + " where OFFICE365_OAUTH_ENABLED = 1" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AppendParameter(cmd, gUSER_ID, "USER_ID");
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
							}
						}
					}
					if ( dt.Rows.Count > 0 )
					{
						DataRow row = dt.Rows[0];
						lock ( queueUsers )
						{
							bool bFound = false;
							foreach ( DataRow rowQueue in queueUsers )
							{
								if ( gUSER_ID == Sql.ToGuid(rowQueue["USER_ID"]) )
								{
									bFound = true;
									break;
								}
							}
							// 12/25/2020 Paul.  No need to add if already in queue. 
							if ( !bFound )
							{
								queueUsers.Enqueue(row);
								bAdded = true;
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
			}
			return bAdded;
		}

		public void SyncAllUsers()
		{
			string sSERVER_URL          = Sql.ToString (Application["CONFIG.Exchange.ServerURL"    ]);
			// 05/09/2018 Paul.  We need to also check for ClientID for Office 365. 
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"     ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret" ]);
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			if ( !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sOAUTH_CLIENT_ID) && !Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) )
			{
				try
				{
					using ( DataTable dt = new DataTable() )
					{
						// 04/04/2010 Paul.  As much as we would like to cache the EXCHANGE_USERS table, 
						// the Watermark value is critical to the Pull Subscription. 
						SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
							// 01/17/2017 Paul.  Get all columns so that we do not get an error when including OFFICE365_OAUTH_ENABLED. 
							sSQL = "select *                          " + ControlChars.CrLf
							     + "  from vwEXCHANGE_USERS           " + ControlChars.CrLf
							     + " where OFFICE365_OAUTH_ENABLED = 1" + ControlChars.CrLf
							     + " order by EXCHANGE_ALIAS          " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dt);
								}
							}
						}
						foreach ( DataRow row in dt.Rows )
						{
							AddUserToQueue(row);
						}
					}
					ProcessUserQueue();
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}
		}

		public Queue<Spring.Social.Office365.Api.SubscriptionNotification> queueNotifications = new Queue<Spring.Social.Office365.Api.SubscriptionNotification>();

		public async Task AddNotificationToQueue(Spring.Social.Office365.Api.SubscriptionNotification notification, IBackgroundTaskQueue taskQueue)
		{
			Guid   gUSER_ID    = Sql.ToGuid(notification.ClientState);
			string sChangeType = notification.ChangeType;
			string sREMOTE_KEY = notification.ResourceData.Id;
			// Lifecycle Notifications. 
			// https://blog.thoughtstuff.co.uk/2020/10/using-microsoft-graph-change-notifications-dont-miss-out-on-broken-subscriptions-with-new-lifecycle-notifications/
			// https://docs.microsoft.com/en-us/graph/webhooks-lifecycle?WT.mc_id=M365-MVP-5001530
			if ( notification.LifecycleEvent == "subscriptionRemoved" || notification.LifecycleEvent == "reauthorizationRequired" )
			{
				string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365AccessToken token = this.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gUSER_ID, false);
				Spring.Social.Office365.Api.IOffice365 service = this.CreateApi(token.access_token);
				this.StopPullSubscription(gUSER_ID);
				this.StopPushSubscription(gUSER_ID, service);
				this.AddUserToQueue(gUSER_ID);
				this.ProcessUserQueue();
			}
			else if ( notification.LifecycleEvent == "missed" )
			{
				this.AddUserToQueue(gUSER_ID);
				this.ProcessUserQueue();
			}
			else
			{
				bool bFound = false;
				lock ( queueNotifications )
				{
					foreach ( Spring.Social.Office365.Api.SubscriptionNotification note2 in queueNotifications )
					{
						if ( notification.Resource == note2.Resource )
						{
							bFound = true;
							break;
						}
					}
					// 12/25/2020 Paul.  No need to add if already in queue. 
					if ( !bFound )
					{
						queueNotifications.Enqueue(notification);
					}
				}
				// 01/11/2021 Paul.  If we are not busy, then fire a normal processing event. 
				if ( !bInsideSyncAll )
				{
					bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
					if ( bVERBOSE_STATUS )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "AddNotificationToQueue: Starting ProcessUserQueue as it is not currently busy. ");
					// 01/11/2021 Paul.  We need to process inside a thread as Office365 is expecting an immediate return. 
					await taskQueue.QueueBackgroundWorkItemAsync(ProcessUserQueue);
				}
			}
		}

		public void ProcessNotificationQueue()
		{
			while ( queueNotifications.Count > 0 )
			{
				Spring.Social.Office365.Api.SubscriptionNotification notification = null;
				lock ( queueNotifications )
				{
					notification = queueNotifications.Dequeue();
				}
				Guid   gUSER_ID    = Sql.ToGuid(notification.ClientState);
				string sChangeType = notification.ChangeType;
				string sREMOTE_KEY = notification.ResourceData.Id;
				if ( sChangeType == "created" || sChangeType == "updated" )
				{
					if ( notification.ResourceData.ODataType == "#Microsoft.Graph.Event" )
					{
						this.ImportAppointment(gUSER_ID, sREMOTE_KEY);
					}
					else if ( notification.ResourceData.ODataType == "#Microsoft.Graph.Contact" )
					{
						this.ImportContact(gUSER_ID, sREMOTE_KEY);
					}
					else if ( notification.ResourceData.ODataType == "#Microsoft.Graph.Message" )
					{
						// 01/11/2021 Paul.  We need to get the parent folder from the subscription. 
						bool bFoundSubscription = false;
						if ( dictPushSubscriptions.ContainsKey(gUSER_ID) )
						{
							Dictionary<string, Spring.Social.Office365.Api.Subscription> subscriptions = dictPushSubscriptions[gUSER_ID];
							if ( subscriptions != null )
							{
								foreach ( string sResource in subscriptions.Keys )
								{
									Spring.Social.Office365.Api.Subscription push = subscriptions[sResource];
									if ( push.Id == notification.SubscriptionId )
									{
										bFoundSubscription = true;
										string sPARENT_KEY = push.Resource;
										if ( sPARENT_KEY.StartsWith("me/mailfolders('") )
											sPARENT_KEY = sPARENT_KEY.Substring(16);
										if ( sPARENT_KEY.EndsWith("')/messages") )
											sPARENT_KEY = sPARENT_KEY.Substring(0, sPARENT_KEY.Length - 11);
										this.ImportMessage(gUSER_ID, sPARENT_KEY, sREMOTE_KEY);
									}
								}
							}
						}
						if ( !bFoundSubscription )
						{
							bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ProcessNotificationQueue: Could not find subscription " + notification.SubscriptionId + " for user " + gUSER_ID.ToString() + " and resource " + sREMOTE_KEY);
						}
					}
				}
				else if ( sChangeType == "deleted" )
				{
					if ( notification.ResourceData.ODataType == "#Microsoft.Graph.Event" )
					{
						this.DeleteAppointment(gUSER_ID, sREMOTE_KEY);
					}
					else if ( notification.ResourceData.ODataType == "#Microsoft.Graph.Contact" )
					{
						this.DeleteContact(gUSER_ID, sREMOTE_KEY);
					}
				}
			}
		}

#pragma warning disable CS1998
		public async ValueTask ProcessUserQueue(CancellationToken token)
		{
			ProcessUserQueue();
		}
#pragma warning restore CS1998

		public void ProcessUserQueue()
		{
			if ( !bInsideSyncAll )
			{
				bInsideSyncAll = true;
				try
				{
					// 12/25/2020 Paul.  Use a queue to prevent hitting concurrency limit. 
					// Application is over its MailboxConcurrency limit.
					// 12/25/2020 Paul.  Process notifications before. 
					ProcessNotificationQueue();
					// 03/29/2010 Paul.  Process the users outside the connection scope. 
					while ( queueUsers.Count > 0 )
					{
						DataRow row = null;
						lock ( queueUsers )
						{
							row = queueUsers.Dequeue();
						}
						
						string sEXCHANGE_ALIAS        = Sql.ToString (row["EXCHANGE_ALIAS"         ]);
						string sEXCHANGE_EMAIL        = Sql.ToString (row["EXCHANGE_EMAIL"         ]);
						Guid   gASSIGNED_USER_ID      = Sql.ToGuid   (row["ASSIGNED_USER_ID"       ]);
						string sMAIL_SMTPUSER         = Sql.ToString (row["MAIL_SMTPUSER"          ]);
						string sMAIL_SMTPPASS         = Sql.ToString (row["MAIL_SMTPPASS"          ]);
						bool bOFFICE365_OAUTH_ENABLED = Sql.ToBoolean(row["OFFICE365_OAUTH_ENABLED"]);
						StringBuilder sbErrors = new StringBuilder();
						// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
						Office365Sync.UserSync User = new Office365Sync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, ExchangeSecurity, SyncError, Modules, NoteAttachments, this, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gASSIGNED_USER_ID, false, bOFFICE365_OAUTH_ENABLED);
						// 11/03/2013 Paul.  Capture the error and continue. 
						try
						{
							this.Sync(User, sbErrors);
						}
						catch(Exception ex)
						{
							// 06/22/2018 Paul.  Expand exception and include stack info. 
							string sError = "Office365Sync.SyncAllUsers(" + sEXCHANGE_ALIAS + " " + sEXCHANGE_EMAIL + ")<br />" + ControlChars.CrLf 
								+ Utils.ExpandException(ex) + "<br />" + ControlChars.CrLf
								+ Sql.ToString(ex.StackTrace);
							SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
							SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
							// 05/01/2018 Paul.  If the mailbox does not exist, then disable. 
							if ( ex.Message.StartsWith("The SMTP address has no mailbox associated with it.") )
							{
								SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
								using ( IDbConnection con = dbf.CreateConnection() )
								{
									con.Open();
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEXCHANGE_USERS_DeleteByEmail(sEXCHANGE_EMAIL, trn);
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
							// 07/05/2018 Paul.  Stop subscriptions if there was a token error. 
							if ( ex.Message.StartsWith("The SMTP address has no mailbox associated with it.") 
							  || ex.Message.StartsWith("Office 365 Access Token")
							  || ex.Message.StartsWith("Office 365 Refresh Token")
							  )
							{
								SplendidCache.ClearExchangeFolders(User.USER_ID);
							}
						}
					}
					// 12/25/2020 Paul.  Use a queue to prevent hitting concurrency limit. 
					// Application is over its MailboxConcurrency limit.
					// 12/25/2020 Paul.  Process notifications afterward. 
					ProcessNotificationQueue();
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
				finally
				{
					bInsideSyncAll = false;
				}
			}
		}

		public class UserSync
		{
			private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			private HttpApplicationState Application        = new HttpApplicationState();
			private HttpSessionState     Session            ;
			private Security             Security           ;
			private Sql                  Sql                ;
			private SqlProcs             SqlProcs           ;
			private SplendidError        SplendidError      ;
			private SplendidCache        SplendidCache      ;
			private ExchangeSecurity     ExchangeSecurity   ;
			private SyncError            SyncError          ;
			private SplendidCRM.Crm.Modules          Modules            ;
			private SplendidCRM.Crm.NoteAttachments  NoteAttachments    ;
			private Office365Sync        Office365Sync      ;

			public string      EXCHANGE_ALIAS    ;
			public string      EXCHANGE_EMAIL    ;
			public string      MAIL_SMTPUSER     ;
			public string      MAIL_SMTPPASS     ;
			public Guid        USER_ID           ;
			public bool        SyncAll           ;
			// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
			public bool        OFFICE365_OAUTH_ENABLED;
			
			public UserSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, Office365Sync Office365Sync)
			{
				this.Session            = Session                ;
				this.Security           = Security               ;
				this.Sql                = Sql                    ;
				this.SqlProcs           = SqlProcs               ;
				this.SplendidError      = SplendidError          ;
				this.SplendidCache      = SplendidCache          ;
				this.ExchangeSecurity   = ExchangeSecurity       ;
				this.SyncError          = SyncError              ;
				this.Modules            = Modules                ;
				this.NoteAttachments    = NoteAttachments        ;
				this.Office365Sync      = Office365Sync          ;

				this.EXCHANGE_ALIAS     = Security.EXCHANGE_ALIAS;
				this.EXCHANGE_EMAIL     = Security.EXCHANGE_EMAIL;
				this.MAIL_SMTPUSER      = Security.MAIL_SMTPUSER ;
				this.MAIL_SMTPPASS      = Security.MAIL_SMTPPASS ;
				this.USER_ID            = Security.USER_ID       ;
				this.SyncAll            = false                  ;
				// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
				// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
				this.OFFICE365_OAUTH_ENABLED = Sql.ToBoolean(Session["OFFICE365_OAUTH_ENABLED"]);
			}
			
			public UserSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, Office365Sync Office365Sync, string sEXCHANGE_ALIAS, string sEXCHANGE_EMAIL, string sMAIL_SMTPUSER, string sMAIL_SMTPPASS, Guid gUSER_ID, bool bSyncAll, bool bOFFICE365_OAUTH_ENABLED)
			{
				this.Session            = Session                ;
				this.Security           = Security               ;
				this.Sql                = Sql                    ;
				this.SqlProcs           = SqlProcs               ;
				this.SplendidError      = SplendidError          ;
				this.SplendidCache      = SplendidCache          ;
				this.ExchangeSecurity   = ExchangeSecurity       ;
				this.SyncError          = SyncError              ;
				this.Modules            = Modules                ;
				this.NoteAttachments    = NoteAttachments        ;
				this.Office365Sync      = Office365Sync          ;

				this.EXCHANGE_ALIAS     = sEXCHANGE_ALIAS    ;
				this.EXCHANGE_EMAIL     = sEXCHANGE_EMAIL    ;
				this.MAIL_SMTPUSER      = sMAIL_SMTPUSER     ;
				this.MAIL_SMTPPASS      = sMAIL_SMTPPASS     ;
				this.USER_ID            = gUSER_ID           ;
				this.SyncAll            = bSyncAll           ;
				// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
				this.OFFICE365_OAUTH_ENABLED = bOFFICE365_OAUTH_ENABLED;
			}
			
			public void Start()
			{
				// 04/25/2010 Paul.  Provide elapse time for SyncAll. 
				DateTime dtStart = DateTime.Now;
				bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  Begin " + EXCHANGE_ALIAS + ", " + USER_ID.ToString() + " at " + dtStart.ToString());
				StringBuilder sbErrors = new StringBuilder();
				// 11/27/2021 Paul.  We should be catching all errors. 
				try
				{
					// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
					Office365Sync service = new Office365Sync(Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, Modules, ExchangeSecurity, SyncError, NoteAttachments);
					service.Sync(this, sbErrors);
					DateTime dtEnd = DateTime.Now;
					TimeSpan ts = dtEnd - dtStart;
					if ( bVERBOSE_STATUS )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  End "   + EXCHANGE_ALIAS + ", " + USER_ID.ToString() + " at " + dtEnd.ToString() + ". Elapse time " + ts.Minutes.ToString() + " minutes " + ts.Seconds.ToString() + " seconds.");
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}

			// 03/13/2012 Paul.  Move SyncSentItems into a thread as it can take a long time to work. 
			public void SyncSentItems()
			{
				StringBuilder sbErrors = new StringBuilder();
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(this.USER_ID);
				string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, USER_ID, false);
				Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(token.access_token);
				// 11/27/2021 Paul.  We should be catching all errors. 
				try
				{
					// 01/11/2021 Paul.  Some people may leave thousands of messages in their Inbox or SentItems folder.  Try to limit the import. 
					int  nMESSAGE_AGE_DAYS = Sql.ToInteger(Application["CONFIG.Exchange.MessageAgeDays" ]);
					if ( nMESSAGE_AGE_DAYS == 0 )
						nMESSAGE_AGE_DAYS = 7;
					DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.UtcNow.AddDays(-nMESSAGE_AGE_DAYS);
				
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						Office365Sync.SyncSentItems(Session, service, con, this.EXCHANGE_ALIAS, this.USER_ID, true, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC, sbErrors);
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}

			// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
			public void SyncInbox()
			{
				StringBuilder sbErrors = new StringBuilder();
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(this.USER_ID);
				string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, USER_ID, false);
				Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(token.access_token);
				// 11/27/2021 Paul.  We should be catching all errors. 
				try
				{
					// 01/11/2021 Paul.  Some people may leave thousands of messages in their Inbox or SentItems folder.  Try to limit the import. 
					int  nMESSAGE_AGE_DAYS = Sql.ToInteger(Application["CONFIG.Exchange.MessageAgeDays" ]);
					if ( nMESSAGE_AGE_DAYS == 0 )
						nMESSAGE_AGE_DAYS = 7;
					DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.UtcNow.AddDays(-nMESSAGE_AGE_DAYS);
				
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						Office365Sync.SyncInbox(Session, service, con, this.EXCHANGE_ALIAS, this.USER_ID, true, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC, sbErrors);
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}

			public static UserSync Create(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, ActiveDirectory ActiveDirectory, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, Office365Sync Office365Sync, Guid gUSER_ID, bool bSyncAll)
			{
				Office365Sync.UserSync User = null;
				SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					// 01/17/2017 Paul.  Get all columns so that we do not get an error when including OFFICE365_OAUTH_ENABLED. 
					sSQL = "select *                 " + ControlChars.CrLf
					     + "  from vwEXCHANGE_USERS  " + ControlChars.CrLf
					     + " where ASSIGNED_USER_ID  = @USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
						using ( IDataReader row = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( row.Read() )
							{
								string sEXCHANGE_ALIAS     = Sql.ToString(row["EXCHANGE_ALIAS"    ]);
								string sEXCHANGE_EMAIL     = Sql.ToString(row["EXCHANGE_EMAIL"    ]);
								Guid   gASSIGNED_USER_ID   = Sql.ToGuid  (row["ASSIGNED_USER_ID"  ]);
								string sMAIL_SMTPUSER      = Sql.ToString(row["MAIL_SMTPUSER"     ]);
								string sMAIL_SMTPPASS      = Sql.ToString(row["MAIL_SMTPPASS"     ]);
								// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
								bool bOFFICE365_OAUTH_ENABLED = false;
								try
								{
									bOFFICE365_OAUTH_ENABLED = Sql.ToBoolean(row["OFFICE365_OAUTH_ENABLED"]);
								}
								catch
								{
								}
								User = new Office365Sync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, ExchangeSecurity, SyncError, Modules, NoteAttachments, Office365Sync, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gASSIGNED_USER_ID, bSyncAll, bOFFICE365_OAUTH_ENABLED);
							}
						}
					}
				}
				return User;
			}
		}

		// 01/22/2012 Paul.  The workflow engine will fire user sync events when a record changes. 
		public void SyncUser(Guid gUSER_ID)
		{
			string sSERVER_URL = Sql.ToString(Application["CONFIG.Exchange.ServerURL"]);
			// 05/09/2018 Paul.  We need to also check for ClientID for Office 365. 
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
			if ( !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sOAUTH_CLIENT_ID) && !Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) )
			{
				try
				{
					using ( DataTable dt = new DataTable() )
					{
						// 04/04/2010 Paul.  As much as we would like to cache the EXCHANGE_USERS table, 
						// the Watermark value is critical to the Pull Subscription. 
						SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
							// 01/17/2017 Paul.  Get all columns so that we do not get an error when including OFFICE365_OAUTH_ENABLED. 
							sSQL = "select *                          " + ControlChars.CrLf
							     + "  from vwEXCHANGE_USERS           " + ControlChars.CrLf
							     + " where ASSIGNED_USER_ID = @USER_ID" + ControlChars.CrLf
							     + " order by EXCHANGE_ALIAS          " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dt);
								}
							}
						}
						// 03/29/2010 Paul.  Process the users outside the connection scope. 
						foreach ( DataRow row in dt.Rows )
						{
							string sEXCHANGE_ALIAS     = Sql.ToString(row["EXCHANGE_ALIAS"    ]);
							string sEXCHANGE_EMAIL     = Sql.ToString(row["EXCHANGE_EMAIL"    ]);
							Guid   gASSIGNED_USER_ID   = Sql.ToGuid  (row["ASSIGNED_USER_ID"  ]);
							string sMAIL_SMTPUSER      = Sql.ToString(row["MAIL_SMTPUSER"     ]);
							string sMAIL_SMTPPASS      = Sql.ToString(row["MAIL_SMTPPASS"     ]);
							// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
							bool bOFFICE365_OAUTH_ENABLED = false;
							try
							{
								bOFFICE365_OAUTH_ENABLED = Sql.ToBoolean(row["OFFICE365_OAUTH_ENABLED"]);
							}
							catch
							{
							}
							StringBuilder sbErrors = new StringBuilder();
							// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
							Office365Sync.UserSync User = new Office365Sync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, ExchangeSecurity, SyncError, Modules, NoteAttachments, this, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gASSIGNED_USER_ID, false, bOFFICE365_OAUTH_ENABLED);
							this.Sync(User, sbErrors);
						}
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}
		}
		#endregion

		#region Sync
		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public void Sync(Office365Sync.UserSync User, StringBuilder sbErrors)
		{
			// 01/22/2012 Paul.  If the last sync was less than 15 seconds ago, then skip this request. 
			lock ( dictLastSync )
			{
				if ( dictLastSync.ContainsKey(User.USER_ID) )
				{
					DateTime dtLastSync = dictLastSync[User.USER_ID];
					if ( dtLastSync.AddSeconds(15) > DateTime.Now )
						return;
				}
			}
			// 03/29/2010 Paul.  We need to make sure that we only have one processing operation at a time. 
			if ( !arrProcessing.Contains(User.USER_ID) )
			{
				// 01/11/2021 Paul.  Track elapse time per user. 
				bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
				DateTime dtStartUserSync = DateTime.Now;
				lock ( arrProcessing )
				{
					arrProcessing.Add(User.USER_ID);
					// 01/22/2012 Paul.  Keep track of the last time we synced to prevent it from being too frequent. 
					dictLastSync[User.USER_ID] = DateTime.Now;
				}
				try
				{
					ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
					if ( bVERBOSE_STATUS )
					{
						// https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Begin sync " + User.EXCHANGE_ALIAS + " to " + User.USER_ID.ToString() + " at " + dtStartUserSync.ToString("G"));
					}
					
					// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
					string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
					string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
					// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
					string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
					Office365AccessToken token = this.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, User.USER_ID, false);
					Spring.Social.Office365.Api.IOffice365 service = CreateApi(token.access_token);
					DataTable dtUserFolders = null;
					// 04/05/2010 Paul.  When the Watermark is empty, no events will be created for existing items. 
					if ( User.SyncAll )
					{
						// 04/25/2010 Paul.  If this is a SyncAll, then we need to stop any existing subscriptions. 
						StopPullSubscription(User.USER_ID);
						//StopPushSubscription(User.USER_ID);
					}
					
					// 04/04/2010 Paul.  For now, we are still going to poll the Contacts and Appointments separately. 
					// It may make sense to have separate subscriptions for Contacts or Appointments. 
					// 04/06/2010 Paul.  Contacts and Appointment folders are not part of the subscription, but we still need to send CRM changes. 
					// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
					// 02/12/2021 Paul.  Allow disable contacts. 
					bool bDisableContacts = Sql.ToBoolean(Application["CONFIG.Exchange.DisableContacts"]);
					if ( !bDisableContacts )
					{
						this.SyncContacts    (Session, service, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
					}
					// 08/14/2017 Paul.  A customer wanted to disable appointments because it was interferring with Skype for Business.  The created call is causing Skype to be set to busy. 
					bool bDisableAppointments = Sql.ToBoolean(Application["CONFIG.Exchange.DisableAppointments"]);
					if ( !bDisableAppointments )
					{
						this.SyncAppointments(Session, service, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
					}
					
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						
						string sSQL = String.Empty;
						// 06/03/2010 Paul.  View name is too long for Oracle.  Reduce using metadata function. 
						// 12/19/2020 Paul.  Office365 uses a DELTA_TOKEN for each folder. 
						sSQL = "select ID                              " + ControlChars.CrLf
						     + "     , NAME                            " + ControlChars.CrLf
						     + "     , MODULE_NAME                     " + ControlChars.CrLf
						     + "     , NAME_CHANGED                    " + ControlChars.CrLf
						     + "     , NEW_FOLDER                      " + ControlChars.CrLf
						     + "     , REMOTE_KEY                      " + ControlChars.CrLf
						     + "     , DELTA_TOKEN                     " + ControlChars.CrLf
						     + "  from " + Sql.MetadataName(con, "vwEXCHANGE_USERS_FOLDERS_Changed") + ControlChars.CrLf
						     + " where USER_ID = @USER_ID              " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@USER_ID", User.USER_ID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtChanges = new DataTable() )
								{
									da.Fill(dtChanges);
									if ( dtChanges.Rows.Count > 0 )
									{
										DataView vwChanges = new DataView(dtChanges);
										// 04/05/2010 Paul.  If there are new folders, then remove the existing subscription so that it can be created again. 
										vwChanges.RowFilter = "NEW_FOLDER = 1";
										if ( vwChanges.Count > 0 )
										{
											// 04/22/2010 Paul.  Log the folder status. 
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: " + vwChanges.Count.ToString() + " new folders for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString());
											StopPullSubscription(User.USER_ID);
											StopPushSubscription(User.USER_ID, service);
											// 04/07/2010 Paul.  If a new folder is added, we need to clear the folder and recompute the subscriptions. 
											SplendidCache.ClearExchangeFolders(User.USER_ID);
											
											// 04/22/2010 Paul.  We need to clear the module folders table any time the subscription changes. 
											DataTable dtSync = SplendidCache.ExchangeModulesSync();
											foreach ( DataRow rowModule in dtSync.Rows )
											{
												string sMODULE_NAME      = Sql.ToString (rowModule["MODULE_NAME"     ]);
												bool   bEXCHANGE_FOLDERS = Sql.ToBoolean(rowModule["EXCHANGE_FOLDERS"]);
												if ( bEXCHANGE_FOLDERS )
												{
													SplendidCache.ClearExchangeModulesFolders(sMODULE_NAME, User.USER_ID);
												}
											}
										}
										vwChanges.RowFilter = "NAME_CHANGED = 1";
										if ( vwChanges.Count > 0 )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: " + vwChanges.Count.ToString() + " changed folders for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString());
											foreach ( DataRowView row in vwChanges )
											{
												Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"         ]);
												string sPARENT_NAME = Sql.ToString(row["NAME"       ]);
												string sMODULE_NAME = Sql.ToString(row["MODULE_NAME"]);
												string sREMOTE_KEY  = Sql.ToString(row["REMOTE_KEY" ]);
												if ( !Sql.IsEmptyString(sPARENT_NAME) && !Sql.IsEmptyString(sREMOTE_KEY) )
												{
													try
													{
														Spring.Social.Office365.Api.MailFolder fld = new Spring.Social.Office365.Api.MailFolder();
														fld.Id          = sREMOTE_KEY ;
														fld.DisplayName = sPARENT_NAME;
														service.FolderOperations.Update(fld);
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																// 03/11/2012 Paul.  The well known flag should be false.  This is not really a bug as the folder record is not created here. 
																SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fld.Id, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, false, trn);
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
														SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
														SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
														sbErrors.AppendLine(Utils.ExpandException(ex));
													}
												}
											}
										}
									}
								}
							}
						}
						bool   bInboxRoot           = Sql.ToBoolean(Application["CONFIG.Exchange.InboxRoot"          ]);
						bool   bSentItemsRoot       = Sql.ToBoolean(Application["CONFIG.Exchange.SentItemsRoot"      ]);
						// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
						bool   bSentItemsSync       = Sql.ToBoolean(Application["CONFIG.Exchange.SentItemsSync"      ]);
						// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
						bool   bInboxSync           = Sql.ToBoolean(Application["CONFIG.Exchange.InboxSync"          ]);
						bool   bPushNotifications   = Sql.ToBoolean(Application["CONFIG.Exchange.PushNotifications"  ]);
						string sPushNotificationURL = Sql.ToString (Application["CONFIG.Exchange.PushNotificationURL"]);
						// 12/26/2020 Paul.  No sense in creating separate url as lifesycle events are not firing. 
						int    nSubscriptionRefresh = Sql.ToInteger(Application["CONFIG.Exchange.SubscriptionRefresh"]);
						if ( nSubscriptionRefresh <= 0 )
							nSubscriptionRefresh = 60;  // Default to 60 minutes. 
						// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
						string sCRM_FOLDER_NAME     = Sql.ToString (Application["CONFIG.Exchange.CrmFolderName"      ]);
						if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
							sCRM_FOLDER_NAME = "SplendidCRM";
						// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
						string sCALENDAR_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Calendar.Category"]);
						string sCONTACTS_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Contacts.Category"]);
						// 04/07/2010 Paul.  If the Push URL is empty, then Push will not be used. 
						if ( Sql.IsEmptyString(sPushNotificationURL) )
							bPushNotifications = false;
						if ( bPushNotifications )
						{
							sPushNotificationURL = sPushNotificationURL.Replace("/ExchangeService2007.asmx", "");
							if ( sPushNotificationURL.EndsWith("/") )
								sPushNotificationURL = sPushNotificationURL.Substring(0, sPushNotificationURL.Length - 1);
							if ( !sPushNotificationURL.ToLower().EndsWith("/office365notifications.aspx") )
								sPushNotificationURL += "/Office365Notifications.aspx";
						}
						else
						{
							StopPushSubscription(User.USER_ID, service);
						}
						
						// 07/07/2018 Paul.  Add the SplendidCRM category to the user's master list if it does not already exist. 
						if ( !dictSplendidCategories.ContainsKey(User.USER_ID) )
						{
							dictSplendidCategories.Add(User.USER_ID, User.EXCHANGE_ALIAS);
							try
							{
								IList<Spring.Social.Office365.Api.OutlookCategory> categories = service.CategoryOperations.GetAll("displayName eq '" + sCALENDAR_CATEGORY + "'");
								// 12/09/2020 Paul.  Can't get the category filter to work, so just manually search.  Filter does not work on category explorer either. 
								bool bSplendidCRMFound = false;
								if ( categories != null )
								{
									foreach ( Spring.Social.Office365.Api.OutlookCategory category in categories )
									{
										if ( category.DisplayName == sCALENDAR_CATEGORY )
										{
											bSplendidCRMFound = true;
											break;
										}
									}
								}
								if ( !bSplendidCRMFound )
								{
									Spring.Social.Office365.Api.OutlookCategory category = new Spring.Social.Office365.Api.OutlookCategory();
									category.DisplayName = sCALENDAR_CATEGORY;
									category.Color       = "preset14";
									category = service.CategoryOperations.Insert(category);
								}
							}
							catch(Exception ex)
							{
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), ex);
								SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), ex);
							}
						}

						if ( !dictPullSubscriptions.ContainsKey(User.USER_ID) )
						{
							// 12/24/2020 Paul.  We need to prevent multiple identical subscriptions. 
							StopPushSubscription(User.USER_ID, service);
							// 04/06/2010 Paul.  First check if there are any existing Exchange Folders. 
							// If not, then we want to perform a Sync All so that all folders are created. 
							dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
							if ( dtUserFolders.Rows.Count == 0 )
								User.SyncAll = true;
							
							if ( User.SyncAll )
							{
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										//Spring.Social.Office365.Api.MailFolder fldContacts = service.FolderOperations.GetWellKnownFolder("contacts");
										// 12/19/2020 Paul.  Office365 does not have a contacts folder, but we need to keep in list for processing. 
										SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, "contacts", "Contacts", Guid.Empty, String.Empty, true, trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										throw;
									}
								}
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										//Spring.Social.Office365.Api.MailFolder fldCalendar = service.FolderOperations.GetWellKnownFolder("calendar");
										// 12/19/2020 Paul.  Office365 does not have a calendar folder, but we need to keep in list for processing. 
										SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, "events", "Calendar", Guid.Empty, String.Empty, true, trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										throw;
									}
								}
								// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
								if ( bSentItemsSync )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											Spring.Social.Office365.Api.MailFolder fldSentItems = service.FolderOperations.GetWellKnownFolder("sentitems");
											SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldSentItems.Id, "Sent Items", Guid.Empty, String.Empty, true, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
								if ( bInboxSync )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											Spring.Social.Office365.Api.MailFolder fldInbox = service.FolderOperations.GetWellKnownFolder("inbox");
											SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldInbox.Id, "Inbox", Guid.Empty, String.Empty, true, trn);
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
							
							DataTable dtSync = SplendidCache.ExchangeModulesSync();
							
							Spring.Social.Office365.Api.MailFolder fldExchangeRoot = service.FolderOperations.GetWellKnownFolder("msgfolderroot");
							Spring.Social.Office365.Api.MailFolder fldSplendidRoot = null;
							Spring.Social.Office365.Api.MailFolder fldModuleFolder = null;
							if ( bInboxRoot )
								fldExchangeRoot = service.FolderOperations.GetWellKnownFolder("inbox");
							// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
							this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, String.Empty, Guid.Empty, String.Empty, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
							
							foreach ( DataRow rowModule in dtSync.Rows )
							{
								fldModuleFolder = null;
								string sMODULE_NAME      = Sql.ToString (rowModule["MODULE_NAME"     ]);
								bool   bEXCHANGE_FOLDERS = Sql.ToBoolean(rowModule["EXCHANGE_FOLDERS"]);
								// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
								this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, Guid.Empty, String.Empty, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
								if ( bEXCHANGE_FOLDERS )
								{
									DataTable dtModuleFolders = SplendidCache.ExchangeModulesFolders(sMODULE_NAME, User.USER_ID);
									//04/04/2010 Paul.  ExchangeModulesFolders can return NULL if Exchange Folders is not supported. 
									// At this time, only Accounts, Bugs, Cases, Contacts, Leads, Opportunities and Projects are supported. 
									if ( dtModuleFolders != null )
									{
										foreach ( DataRow rowFolder in dtModuleFolders.Rows )
										{
											Guid   gPARENT_ID   = Sql.ToGuid   (rowFolder["ID"        ]);
											string sPARENT_NAME = Sql.ToString (rowFolder["NAME"      ]);
											// 05/14/2010 Paul.  We need the NEW_FOLDER flag to determine if we should perform a first SyncAll. 
											bool   bNEW_FOLDER  = Sql.ToBoolean(rowFolder["NEW_FOLDER"]);
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll || bNEW_FOLDER, sbErrors);
										}
									}
								}
							}
							if ( bSentItemsRoot )
							{
								fldExchangeRoot = service.FolderOperations.GetWellKnownFolder("sentitems");
								fldSplendidRoot = null;
								fldModuleFolder = null;
								// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
								this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, String.Empty, Guid.Empty, String.Empty, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
								
								foreach ( DataRow rowModule in dtSync.Rows )
								{
									fldModuleFolder = null;
									string sMODULE_NAME      = Sql.ToString (rowModule["MODULE_NAME"     ]);
									bool   bEXCHANGE_FOLDERS = Sql.ToBoolean(rowModule["EXCHANGE_FOLDERS"]);
									// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
									this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, Guid.Empty, String.Empty, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
									if ( bEXCHANGE_FOLDERS )
									{
										DataTable dtModuleFolders = SplendidCache.ExchangeModulesFolders(sMODULE_NAME, User.USER_ID);
										//04/04/2010 Paul.  ExchangeModulesFolders can return NULL if Exchange Folders is not supported. 
										// At this time, only Accounts, Bugs, Cases, Contacts, Leads, Opportunities and Projects are supported. 
										if ( dtModuleFolders != null )
										{
											foreach ( DataRow rowFolder in dtModuleFolders.Rows )
											{
												Guid   gPARENT_ID   = Sql.ToGuid  (rowFolder["ID"  ]);
												string sPARENT_NAME = Sql.ToString(rowFolder["NAME"]);
												// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
												this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
											}
										}
									}
								}
							}
							
							bool bFolderDeleted = false;
							StringBuilder sbUserFolders = new StringBuilder();
							List<Spring.Social.Office365.Api.MailFolder> arrFolders = new List<Spring.Social.Office365.Api.MailFolder>();
							SplendidCache.ClearExchangeFolders(User.USER_ID);
							dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
							// 03/11/2012 Paul.  The Sent Items Sync flag is new, so we need to check if an existing user needs to have the Sent Items included in the sync. 
							if ( bSentItemsSync )
							{
								DataView vwSentItems = new DataView(dtUserFolders);
								vwSentItems.RowFilter = "WELL_KNOWN_FOLDER = 1 and MODULE_NAME = 'Sent Items'";
								if ( vwSentItems.Count == 0 )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											Spring.Social.Office365.Api.MailFolder fldSentItems = service.FolderOperations.GetWellKnownFolder("sentitems");
											SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldSentItems.Id, "Sent Items", Guid.Empty, String.Empty, true, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
									SplendidCache.ClearExchangeFolders(User.USER_ID);
									dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
								}
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: SyncSentItems for " + User.EXCHANGE_ALIAS);
								// 03/11/2012 Paul.  The Sent Items folder can be very large, so only get the messages from the last 2 hours. 
								this.SyncSentItems(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, false, DateTime.UtcNow.AddHours(-2), sbErrors);
							}
							// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
							if ( bInboxSync )
							{
								DataView vwInbox = new DataView(dtUserFolders);
								vwInbox.RowFilter = "WELL_KNOWN_FOLDER = 1 and MODULE_NAME = 'Inbox'";
								if ( vwInbox.Count == 0 )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											Spring.Social.Office365.Api.MailFolder fldInbox = service.FolderOperations.GetWellKnownFolder("inbox");
											SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldInbox.Id, "Inbox", Guid.Empty, String.Empty, true, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
									SplendidCache.ClearExchangeFolders(User.USER_ID);
									dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
								}
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: SyncInbox for " + User.EXCHANGE_ALIAS);
								// 07/05/2017 Paul.  The Inbox folder can be very large, so only get the messages from the last 2 hours. 
								this.SyncInbox(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, false, DateTime.UtcNow.AddHours(-2), sbErrors);
							}
							foreach ( DataRow row in dtUserFolders.Rows )
							{
								string sREMOTE_KEY        = Sql.ToString(row["REMOTE_KEY"        ]);
								string sMODULE_NAME       = Sql.ToString(row["MODULE_NAME"       ]);
								string sPARENT_NAME       = Sql.ToString(row["PARENT_NAME"       ]);
								bool   bWELL_KNOWN_FOLDER = Sql.ToBoolean(row["WELL_KNOWN_FOLDER"]);
								// 05/14/2010 Paul.  The folder may have been deleted in Exchange.  The subscription will fail if any of the folders does not exist. 
								// So we need to validate each folder and remove it from the list if it does not exist. 
								try
								{
									Spring.Social.Office365.Api.MailFolder fld = null;
									if ( bWELL_KNOWN_FOLDER && ((sREMOTE_KEY == "contacts" || sMODULE_NAME == "Contacts") || (sREMOTE_KEY == "events" || sMODULE_NAME == "Calendar")) )
									{
										fld = new Spring.Social.Office365.Api.MailFolder();
										fld.Id = sREMOTE_KEY;
									}
									else
									{
										fld = service.FolderOperations.GetById(sREMOTE_KEY);
									}
									// 05/14/2010 Paul.  We expect a missing folder to throw an exception. 
									arrFolders.Add(fld);
								}
								catch
								{
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Deleting folder " + sPARENT_NAME + " in " + sMODULE_NAME);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEXCHANGE_FOLDERS_Delete(User.USER_ID, sREMOTE_KEY, trn);
											trn.Commit();
											bFolderDeleted = true;
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								// 04/25/2010 Paul.  Exclude the SplendidCRM Root folder. 
								if ( !Sql.IsEmptyString(sMODULE_NAME) )
								{
									if ( sbUserFolders.Length > 0 )
										sbUserFolders.Append(", ");
									sbUserFolders.AppendLine(sMODULE_NAME + (Sql.IsEmptyString(sPARENT_NAME) ? String.Empty : " - " + sPARENT_NAME));
								}
							}
							if ( bFolderDeleted )
							{
								SplendidCache.ClearExchangeFolders(User.USER_ID);
								dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
							}
							// 04/25/2010 Paul.  Include the folders getting sync'd in the status message. 
							// 06/30/2018 Paul.  Include the machine name to help debug. 
							string sMachineName = String.Empty;
							try
							{
								// 06/30/2018 Paul.  Azure does not support MachineName.  Just ignore the error. 
								// 07/06/2018 Paul.  ServerName and ApplicationPath may be more useful for those times when two apps are running on the same machine. 
								sMachineName = Sql.ToString(Application["ServerName"]) + Sql.ToString(Application["ApplicationPath"]);  // System.Environment.MachineName;
							}
							catch
							{
							}
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Adding Pull subscription for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString() + " on " + sMachineName + "." + ControlChars.CrLf + "Folders: " + sbUserFolders.ToString());
							
							dictPullSubscriptions.Add(User.USER_ID, null);
						}
						else
						{
							dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
						}
						Dictionary<string, Spring.Social.Office365.Api.Subscription> push = null;
						if ( bPushNotifications )
						{
							if ( dictPushSubscriptions.ContainsKey(User.USER_ID) )
							{
								push = dictPushSubscriptions[User.USER_ID];
							}
							else
							{
								StopPushSubscription(User.USER_ID, service);
								push = new Dictionary<string, Spring.Social.Office365.Api.Subscription>();
								dictPushSubscriptions.Add(User.USER_ID, push);
							}
						}
						foreach ( DataRow row in dtUserFolders.Rows )
						{
							string sREMOTE_KEY        = Sql.ToString(row["REMOTE_KEY"        ]);
							string sMODULE_NAME       = Sql.ToString(row["MODULE_NAME"       ]);
							Guid   gPARENT_ID         = Sql.ToGuid  (row["PARENT_ID"         ]);
							string sPARENT_NAME       = Sql.ToString(row["PARENT_NAME"       ]);
							bool   bWELL_KNOWN_FOLDER = Sql.ToBoolean(row["WELL_KNOWN_FOLDER"]);
							// 12/19/2020 Paul.  Office365 uses a DELTA_TOKEN for each folder. 
							string sDELTA_TOKEN       = Sql.ToString(row["DELTA_TOKEN"       ]);
							// 11/27/2021 Paul.  Clear the delta token when sync all. 
							if ( User.SyncAll )
								sDELTA_TOKEN = String.Empty;
							
							if ( bWELL_KNOWN_FOLDER && (sREMOTE_KEY == "contacts" || sMODULE_NAME == "Contacts") )
							{
								int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Contacts.PageSize"]);
								if ( nPageSize <= 0 )
									nPageSize = 100;
								// 01/14/2021 Paul.  Limit the number of contacts being imported to those modified in the last 180 days. 
								int  nCONTACT_AGE_DAYS = Sql.ToInteger(Application["CONFIG.Exchange.ContactAgeDays" ]);
								if ( nCONTACT_AGE_DAYS == 0 )
									nCONTACT_AGE_DAYS = 180;
								DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.UtcNow.AddDays(-nCONTACT_AGE_DAYS);
								bool bUpdateWatermark = false;
								// 01/10/2021 Paul.  Use new token indicator to determine if watermark is updated to prevent system from getting stuck. 
								string sNEW_DELTA_TOKEN = sDELTA_TOKEN;
								List<Spring.Social.Office365.Api.Contact> results = new List<Spring.Social.Office365.Api.Contact>();
								try
								{
									Spring.Social.Office365.Api.ContactPagination page = null;
									do
									{
										// 01/28/2017 Paul.  The Pull.Watermark changes with each call to GetEvents. 
										page = service.ContactOperations.GetContactsDelta(sCONTACTS_CATEGORY, sNEW_DELTA_TOKEN, nPageSize);
										foreach ( Spring.Social.Office365.Api.Contact evt in page.contacts )
										{
											// 01/14/2021 Paul.  Limit the number of contacts being imported to those modified in the last 180 days. 
											if ( evt.LastModifiedDateTime.HasValue && evt.LastModifiedDateTime.Value.DateTime.ToUniversalTime() > dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC )
											{
												results.Add(evt);
											}
										}
										if ( !Sql.IsEmptyString(page.nextLink) )
										{
											sNEW_DELTA_TOKEN = page.nextLink.Split('?')[1];
										}
										else if ( !Sql.IsEmptyString(page.deltaLink) )
										{
											sNEW_DELTA_TOKEN = page.deltaLink.Split('?')[1];
										}
									}
									while ( results != null && !Sql.IsEmptyString(page.nextLink) );
								}
								catch(Exception ex)
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Stopping Pull subscription for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString() + ". " + ex.Message);
								}
								foreach ( Spring.Social.Office365.Api.Contact evt in results )
								{
									string sItemID         = evt.Id;
									// 12/12/2017 Paul.  Capture and ignore error.  We are seeing Emails in the Contacts folder. 
									Spring.Social.Office365.Api.Contact contact = null;
									try
									{
										contact = service.ContactOperations.GetById(sItemID);
									}
									catch(Exception ex)
									{
										string sError = "Sync: Error retrieving Contact " + sREMOTE_KEY + " for " + User.EXCHANGE_ALIAS + "." + ControlChars.CrLf;
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
										// 01/10/2021 Paul.  Exit if we get a token error. 
										if ( ex.Message == "Access token has expired." )
										{
											throw;
										}
									}
									// 04/07/2010 Paul.  The subscription means that we will get a change event for all items, 
									// so we need to make sure and filter only those that are marked as SplendidCRM. 
									// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
									// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
									// 12/12/2017 Paul.  Capture and ignore error.  We are seeing Emails in the Contacts folder. 
									// 01/12/2021 Paul.  Office 365 does not support contact categories. 
									// 01/13/2021 Paul.  Outlook 365 web site does not support categories, but Outlook windows client does. Outlook 365 will create empty array for Categories. 
									if ( contact != null && (Sql.IsEmptyString(sCONTACTS_CATEGORY) || (contact.Categories == null || contact.Categories.Count == 0 || contact.Categories.Contains(sCONTACTS_CATEGORY))) )
									{
										// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
										this.ImportContact(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, contact, sbErrors);
										bUpdateWatermark = true;
									}
								}
								// 01/10/2021 Paul.  Use new token indicator to determine if watermark is updated to prevent system from getting stuck. 
								if ( bUpdateWatermark || sDELTA_TOKEN != sNEW_DELTA_TOKEN )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEXCHANGE_FOLDERS_UpdateDeltaToken(User.USER_ID, sREMOTE_KEY, sNEW_DELTA_TOKEN, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								if ( bPushNotifications && push != null )
								{
									Spring.Social.Office365.Api.Subscription subscription = new Spring.Social.Office365.Api.Subscription();
									// https://docs.microsoft.com/en-us/graph/api/subscription-post-subscriptions?view=graph-rest-1.0&tabs=http
									subscription.Resource                 = "me/contacts";
									subscription.ChangeType               = "created,updated,deleted";
									subscription.NotificationUrl          = sPushNotificationURL;
									// 12/26/2020 Paul.  No sense in creating separate url as lifesycle events are not firing. 
									subscription.LifecycleNotificationUrl = sPushNotificationURL;  //.Replace("Office365Notifications.aspx", "Office365Lifecycle.aspx");
									// https://docs.microsoft.com/en-us/graph/api/resources/subscription?view=graph-rest-1.0
									subscription.ExpirationDateTime       = DateTime.UtcNow.AddMinutes(nPUSH_EXPIRATION_MINUTES);
									subscription.ClientState              = User.USER_ID.ToString();
									subscription.ApplicationId            = "SplendidCRM";
									subscription.IncludeResourceData      = false;
									// 12/25/2020 Paul.  If subscription has expired, try to update.  If that fails, then just recreated. 
									if ( push.ContainsKey(subscription.Resource) )
									{
										if ( push[subscription.Resource].ExpirationDateTime.Value.UtcDateTime < DateTime.UtcNow )
										{
											push.Remove(subscription.Resource);
										}
										else if ( push[subscription.Resource].ExpirationDateTime.Value.UtcDateTime.AddMinutes(-nSubscriptionRefresh) < DateTime.UtcNow )
										{
											try
											{
												service.SubscriptionOperations.UpdateExpiration(push[subscription.Resource].Id, subscription.ExpirationDateTime);
												if ( bVERBOSE_STATUS )
												{
													Debug.WriteLine("Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
												}
											}
											catch(Exception ex)
											{
												push.Remove(subscription.Resource);
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Sync: Failed Update Subscription Expiration for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource + ". " + ex.Message);
											}
										}
									}
									if ( !push.ContainsKey(subscription.Resource) )
									{
										try
										{
											subscription = service.SubscriptionOperations.Insert(subscription);
											push.Add(subscription.Resource, subscription);
											if ( bVERBOSE_STATUS )
											{
												Debug.WriteLine("Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
											}
										}
										catch(Exception ex)
										{
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Sync: Failed Push Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource + ". " + ex.Message);
										}
									}
								}
							}
							else if ( bWELL_KNOWN_FOLDER && (sREMOTE_KEY == "events" || sMODULE_NAME == "Calendar") )
							{
								int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Appointments.PageSize"]);
								if ( nPageSize <= 0 )
									nPageSize = 100;
								bool bUpdateWatermark = false;
								// 01/10/2021 Paul.  Use new token indicator to determine if watermark is updated to prevent system from getting stuck. 
								string sNEW_DELTA_TOKEN = sDELTA_TOKEN;
								List<Spring.Social.Office365.Api.Event> results = new List<Spring.Social.Office365.Api.Event>();
								try
								{
									int  nAPPOINTMENT_AGE_DAYS = Sql.ToInteger(Application["CONFIG.Exchange.AppointmentAgeDays" ]);
									if ( nAPPOINTMENT_AGE_DAYS == 0 )
										nAPPOINTMENT_AGE_DAYS = 7;
									DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.UtcNow.AddDays(-nAPPOINTMENT_AGE_DAYS);
									Spring.Social.Office365.Api.EventPagination page = null;
									do
									{
										// 01/28/2017 Paul.  The Pull.Watermark changes with each call to GetEvents. 
										page = service.EventOperations.GetEventsDelta(sCALENDAR_CATEGORY, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC, sNEW_DELTA_TOKEN, nPageSize);
										foreach ( Spring.Social.Office365.Api.Event evt in page.events )
										{
											results.Add(evt);
										}
										if ( !Sql.IsEmptyString(page.nextLink) )
										{
											sNEW_DELTA_TOKEN = page.nextLink.Split('?')[1];
										}
										else if ( !Sql.IsEmptyString(page.deltaLink) )
										{
											sNEW_DELTA_TOKEN = page.deltaLink.Split('?')[1];
										}
									}
									while ( results != null && !Sql.IsEmptyString(page.nextLink) );
								}
								catch(Exception ex)
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Stopping Pull subscription for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString() + ". " + ex.Message);
								}
								foreach ( Spring.Social.Office365.Api.Event evt in results )
								{
									string sItemID         = evt.Id;
									// 03/26/2013 Paul.  When an appointment is created using Outlook Web Access, it seems to create and delete multiple records. 
									// A few others have reported this problem and it only seems to happen with appointments. 
									Spring.Social.Office365.Api.Event appointment = null;
									try
									{
										appointment = service.EventOperations.GetById(sItemID);
									}
									catch(Exception ex)
									{
										string sError = "Sync: Error retrieving Event " + sREMOTE_KEY + " for " + User.EXCHANGE_ALIAS + "." + ControlChars.CrLf;
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
										// 01/10/2021 Paul.  Exit if we get a token error. 
										if ( ex.Message == "Access token has expired." )
										{
											throw;
										}
									}
									// 04/07/2010 Paul.  The subscription means that we will get a change event for all items, 
									// so we need to make sure and filter only those that are marked as SplendidCRM. 
									// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
									// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
									if ( appointment != null && (Sql.IsEmptyString(sCALENDAR_CATEGORY) || appointment.Categories.Contains(sCALENDAR_CATEGORY)) )
									{
										// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
										this.ImportAppointment(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, appointment, sbErrors);
										bUpdateWatermark = true;
									}
								}
								// 01/10/2021 Paul.  Use new token indicator to determine if watermark is updated to prevent system from getting stuck. 
								if ( bUpdateWatermark || sDELTA_TOKEN != sNEW_DELTA_TOKEN )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEXCHANGE_FOLDERS_UpdateDeltaToken(User.USER_ID, sREMOTE_KEY, sNEW_DELTA_TOKEN, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								if ( bPushNotifications && push != null )
								{
									Spring.Social.Office365.Api.Subscription subscription = new Spring.Social.Office365.Api.Subscription();
									// https://docs.microsoft.com/en-us/graph/api/subscription-post-subscriptions?view=graph-rest-1.0&tabs=http
									subscription.Resource                 = "me/events";
									subscription.ChangeType               = "created,updated,deleted";
									subscription.NotificationUrl          = sPushNotificationURL;
									// 12/26/2020 Paul.  No sense in creating separate url as lifesycle events are not firing. 
									subscription.LifecycleNotificationUrl = sPushNotificationURL;  //.Replace("Office365Notifications.aspx", "Office365Lifecycle.aspx");
									// https://docs.microsoft.com/en-us/graph/api/resources/subscription?view=graph-rest-1.0
									subscription.ExpirationDateTime       = DateTime.UtcNow.AddMinutes(nPUSH_EXPIRATION_MINUTES);
									subscription.ClientState              = User.USER_ID.ToString();
									subscription.ApplicationId            = "SplendidCRM";
									subscription.IncludeResourceData      = false;
									// 12/25/2020 Paul.  If subscription has expired, try to update.  If that fails, then just recreated. 
									if ( push.ContainsKey(subscription.Resource) )
									{
										if ( push[subscription.Resource].ExpirationDateTime.Value.UtcDateTime < DateTime.UtcNow )
										{
											push.Remove(subscription.Resource);
										}
										else if ( push[subscription.Resource].ExpirationDateTime.Value.UtcDateTime.AddMinutes(-nSubscriptionRefresh) < DateTime.UtcNow )
										{
											try
											{
												service.SubscriptionOperations.UpdateExpiration(push[subscription.Resource].Id, subscription.ExpirationDateTime);
												if ( bVERBOSE_STATUS )
												{
													Debug.WriteLine("Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
												}
											}
											catch(Exception ex)
											{
												push.Remove(subscription.Resource);
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Sync: Failed Update Subscription Expiration for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource + ". " + ex.Message);
											}
										}
									}
									if ( !push.ContainsKey(subscription.Resource) )
									{
										try
										{
											subscription = service.SubscriptionOperations.Insert(subscription);
											push.Add(subscription.Resource, subscription);
											if ( bVERBOSE_STATUS )
											{
												Debug.WriteLine("Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
											}
										}
										catch(Exception ex)
										{
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Sync: Failed Push Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource + ". " + ex.Message);
										}
									}
								}
							}
							else
							{
								int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Messages.PageSize"]);
								if ( nPageSize <= 0 )
									nPageSize = 100;
								// 01/11/2021 Paul.  Some people may leave thousands of messages in their Inbox or SentItems folder.  Try to limit the import. 
								int  nMESSAGE_AGE_DAYS = Sql.ToInteger(Application["CONFIG.Exchange.MessageAgeDays" ]);
								if ( nMESSAGE_AGE_DAYS == 0 )
									nMESSAGE_AGE_DAYS = 7;
								DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.UtcNow.AddDays(-nMESSAGE_AGE_DAYS);
								bool bUpdateWatermark = false;
								// 01/10/2021 Paul.  Use new token indicator to determine if watermark is updated to prevent system from getting stuck. 
								string sNEW_DELTA_TOKEN = sDELTA_TOKEN;
								// 04/26/2010 Paul.  The Pull.Watermark changes with each call to GetEvents. 
								// 05/20/2018 Paul.  Catch the error and remove the subscription.  It will be created again in the next scheduled event. 
								List<Spring.Social.Office365.Api.Message> results = new List<Spring.Social.Office365.Api.Message>();
								try
								{
									Spring.Social.Office365.Api.MessagePagination page = null;
									do
									{
										// 01/28/2017 Paul.  The Pull.Watermark changes with each call to GetEvents. 
										page = service.FolderOperations.GetMessagesDelta(sREMOTE_KEY, sNEW_DELTA_TOKEN, nPageSize);
										foreach ( Spring.Social.Office365.Api.Message evt in page.messages )
										{
											// 01/11/2021 Paul.  Some people may leave thousands of messages in their Inbox or SentItems folder.  Try to limit the import. 
											// 01/12/2021 Paul.  A deleted message will only return the "@removed" property. 
											// 01/12/2021 Paul.  A deleted remote message does not delete locally, so just ignore. 
											if ( evt.Deleted )
											{
												if ( bVERBOSE_STATUS )
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Deleted message for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString() + " will be ignored. " + evt.Id);
											}
											else if ( evt.CreatedDateTime.HasValue && evt.CreatedDateTime.Value.DateTime.ToUniversalTime() > dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC )
											{
												results.Add(evt);
											}
										}
										if ( !Sql.IsEmptyString(page.nextLink) )
										{
											sNEW_DELTA_TOKEN = page.nextLink.Split('?')[1];
										}
										else if ( !Sql.IsEmptyString(page.deltaLink) )
										{
											sNEW_DELTA_TOKEN = page.deltaLink.Split('?')[1];
										}
									}
									while ( results != null && !Sql.IsEmptyString(page.nextLink) );
								}
								catch(Exception ex)
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Stopping Pull subscription for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString() + ". " + ex.Message);
								}
								foreach ( Spring.Social.Office365.Api.Message evt in results )
								{
									string sItemID = evt.Id;
									{
										try
										{
											// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
											if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Sent Items" )
											{
												//Spring.Social.Office365.Api.Message email = service.MailOperations.GetById(sItemID);
												// 10/28/2022 Paul.  Don't need entire email if we are going to GetById. 
												this.ImportSentItem(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, sItemID, sbErrors);
												bUpdateWatermark = true;
											}
											// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
											else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Inbox" )
											{
												//Spring.Social.Office365.Api.Message email = service.MailOperations.GetById(sItemID);
												// 12/06/2020 Paul.  Not sure how to put a note into a mail folder, so assume that it cannot be done. 
												//string sItemClass  = email.ItemClass;
												//if ( sItemClass == "IPM.Note" )
												{
													// 10/28/2022 Paul.  Don't need entire email if we are going to GetById. 
													this.ImportInbox(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, sItemID, sbErrors);
													bUpdateWatermark = true;
												}
											}
											else
											{
												Spring.Social.Office365.Api.Message email = service.MailOperations.GetById(sItemID);
												// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
												this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, User.EXCHANGE_ALIAS, User.USER_ID, email, sbErrors);
												bUpdateWatermark = true;
											}
										}
										catch(Exception ex)
										{
											string sError = "Sync: Error retrieving Message " + sREMOTE_KEY + " for " + User.EXCHANGE_ALIAS + "." + ControlChars.CrLf;
											sError += Utils.ExpandException(ex) + ControlChars.CrLf;
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											sbErrors.AppendLine(sError);
											// 01/10/2021 Paul.  Exit if we get a token error. 
											if ( ex.Message == "Access token has expired." )
											{
												throw;
											}
										}
									}
								}
								// 04/26/2010 Paul.  The Pull.Watermark changes with each call to GetEvents. 
								// We need to make sure to update the database value any time we notice a change. 
								if ( bUpdateWatermark || sDELTA_TOKEN != sNEW_DELTA_TOKEN )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEXCHANGE_FOLDERS_UpdateDeltaToken(User.USER_ID, sREMOTE_KEY, sNEW_DELTA_TOKEN, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								if ( bPushNotifications && push != null )
								{
									Spring.Social.Office365.Api.Subscription subscription = new Spring.Social.Office365.Api.Subscription();
									// https://docs.microsoft.com/en-us/graph/api/subscription-post-subscriptions?view=graph-rest-1.0&tabs=http
									subscription.Resource                 = "me/mailfolders('" + sREMOTE_KEY + "')/messages";
									subscription.ChangeType               = "created,updated,deleted";
									subscription.NotificationUrl          = sPushNotificationURL;
									// 12/26/2020 Paul.  No sense in creating separate url as lifesycle events are not firing. 
									subscription.LifecycleNotificationUrl = sPushNotificationURL;  //.Replace("Office365Notifications.aspx", "Office365Lifecycle.aspx");
									// https://docs.microsoft.com/en-us/graph/api/resources/subscription?view=graph-rest-1.0
									subscription.ExpirationDateTime       = DateTime.UtcNow.AddMinutes(nPUSH_EXPIRATION_MINUTES);
									subscription.ClientState              = User.USER_ID.ToString();
									subscription.ApplicationId            = "SplendidCRM";
									subscription.IncludeResourceData      = false;
									// 12/25/2020 Paul.  If subscription has expired, try to update.  If that fails, then just recreated. 
									if ( push.ContainsKey(subscription.Resource) )
									{
										if ( push[subscription.Resource].ExpirationDateTime.Value.UtcDateTime < DateTime.UtcNow )
										{
											push.Remove(subscription.Resource);
										}
										else if ( push[subscription.Resource].ExpirationDateTime.Value.UtcDateTime.AddMinutes(-nSubscriptionRefresh) < DateTime.UtcNow )
										{
											try
											{
												service.SubscriptionOperations.UpdateExpiration(push[subscription.Resource].Id, subscription.ExpirationDateTime);
												if ( bVERBOSE_STATUS )
												{
													Debug.WriteLine("Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
												}
											}
											catch(Exception ex)
											{
												push.Remove(subscription.Resource);
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Sync: Failed Update Subscription Expiration for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource + ". " + ex.Message);
											}
										}
									}
									if ( !push.ContainsKey(subscription.Resource) )
									{
										try
										{
											subscription = service.SubscriptionOperations.Insert(subscription);
											push.Add(subscription.Resource, subscription);
											if ( bVERBOSE_STATUS )
											{
												Debug.WriteLine("Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource + " " + sMODULE_NAME);
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource);
											}
										}
										catch(Exception ex)
										{
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Sync: Failed Push Subscription for " + User.EXCHANGE_ALIAS + " to " + subscription.Resource + ". " + ex.Message);
										}
									}
								}
							}
						}
					}
#if false
					Debug.WriteLine("Start Subscriptions");
					IList<Spring.Social.Office365.Api.Subscription> subscriptions = service.SubscriptionOperations.GetAll();
					foreach ( Spring.Social.Office365.Api.Subscription sub in subscriptions )
					{
						service.SubscriptionOperations.Delete(sub.Id);
						Debug.WriteLine("Subscription: " + sub.Id);
					}
					Debug.WriteLine("Still existing Subscriptions");
					subscriptions = service.SubscriptionOperations.GetAll();
					foreach ( Spring.Social.Office365.Api.Subscription sub in subscriptions )
					{
						service.SubscriptionOperations.Delete(sub.Id);
						Debug.WriteLine("Subscription: " + sub.Id);
					}
					Debug.WriteLine("End Subscriptions");
#endif
				}
				finally
				{
					// 01/11/2021 Paul.  Track elapse time per user. 
					DateTime dtEndUserSync = DateTime.Now;
					double dElapseSeconds = (dtEndUserSync - dtStartUserSync).TotalSeconds;
					if ( bVERBOSE_STATUS )
					{
						// https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: End sync " + User.EXCHANGE_ALIAS + " to " + User.USER_ID.ToString() + " at " + dtEndUserSync.ToString("G") + " took " + Math.Floor(dElapseSeconds).ToString() + " seconds.");
					}
					lock ( arrProcessing )
					{
						arrProcessing.Remove(User.USER_ID);
					}
				}
			}
			else
			{
				// 04/25/2010 Paul.  Lets log the busy status. 
				string sError = "Sync:  Already busy processing " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString();
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
				sbErrors.AppendLine(sError);
			}
		}
		#endregion

		#region Sync Contacts
		// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
		private bool SetExchangeContact(Spring.Social.Office365.Api.Contact contact, DataRow row, StringBuilder sbChanges, string sCONTACTS_CATEGORY)
		{
			bool bChanged = false;
			// 03/28/2010 Paul.  An empty FileAs will cause an exception when calling Contact.Bind(); 
			string sFILE_AS = Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]);
			sFILE_AS = sFILE_AS.Trim();
			if ( Sql.IsEmptyString(sFILE_AS) )
				sFILE_AS = "(no name)";
			if ( Sql.IsEmptyString(contact.Id) )
			{
				// 03/28/2010 Paul.  You must load or assign this property before you can read its value. 
				// So set all the fields to empty values. 
				// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
				// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
				if ( !Sql.IsEmptyString(sCONTACTS_CATEGORY) )
				{
					if ( contact.Categories == null )
						contact.Categories = new List<String>();
					contact.Categories.Add(sCONTACTS_CATEGORY);
				}
				contact.GivenName     = Sql.ToString  (row["FIRST_NAME"  ]);
				contact.Surname       = Sql.ToString  (row["LAST_NAME"   ]);
				contact.CompanyName   = Sql.ToString  (row["ACCOUNT_NAME"]);
				contact.JobTitle      = Sql.ToString  (row["TITLE"       ]);
				contact.Department    = Sql.ToString  (row["DEPARTMENT"  ]);
				contact.AssistantName = Sql.ToString  (row["ASSISTANT"   ]);
				contact.Birthday      = Sql.ToDateTime(row["BIRTHDATE"   ]);
				contact.PersonalNotes = Sql.ToString  (row["DESCRIPTION" ]);
				// 03/28/2010 Paul.  An empty FileAs will cause an exception when calling Contact.Bind(); 
				contact.FileAs        = sFILE_AS;
				// 03/28/2010 Paul.  An empty Email Address will cause an exception; 
				// We cannot even check for the existance of the email due to a bug in the API. 
				contact.EmailAddresses = new List<Spring.Social.Office365.Api.EmailAddress>();
				if ( !Sql.IsEmptyString(row["EMAIL1"]) )
				{
					contact.EmailAddresses.Add(new Spring.Social.Office365.Api.EmailAddress(Sql.ToString(row["EMAIL1"])));
				}
				if ( !Sql.IsEmptyString(row["EMAIL2"]) )
				{
					contact.EmailAddresses.Add(new Spring.Social.Office365.Api.EmailAddress(Sql.ToString(row["EMAIL2"])));
				}
				
				contact.BusinessPhones = new List<string>();
				contact.HomePhones     = new List<string>();
				if ( !Sql.IsEmptyString(row["PHONE_WORK"     ]) ) contact.BusinessPhones.Add(Sql.ToString(row["PHONE_WORK"     ]));
				if ( !Sql.IsEmptyString(row["PHONE_FAX"      ]) ) contact.BusinessPhones.Add(Sql.ToString(row["PHONE_FAX"      ]));
				//if ( !Sql.IsEmptyString(row["ASSISTANT_PHONE"]) ) contact.BusinessPhones.Add(Sql.ToString(row["ASSISTANT_PHONE"]));
				if ( !Sql.IsEmptyString(row["PHONE_HOME"     ]) ) contact.HomePhones    .Add(Sql.ToString(row["PHONE_HOME"     ]));
				if ( !Sql.IsEmptyString(row["PHONE_OTHER"    ]) ) contact.HomePhones    .Add(Sql.ToString(row["PHONE_OTHER"    ]));
				contact.MobilePhone                                 = Sql.ToString(row["PHONE_MOBILE"   ]);
				
				contact.BusinessAddress = new Spring.Social.Office365.Api.PhysicalAddress();
				contact.OtherAddress    = new Spring.Social.Office365.Api.PhysicalAddress();
				contact.BusinessAddress.Street          = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);
				contact.BusinessAddress.City            = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);
				contact.BusinessAddress.State           = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);
				contact.BusinessAddress.PostalCode      = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);
				contact.BusinessAddress.CountryOrRegion = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);
				contact.OtherAddress.Street             = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);
				contact.OtherAddress.City               = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);
				contact.OtherAddress.State              = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);
				contact.OtherAddress.PostalCode         = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);
				contact.OtherAddress.CountryOrRegion    = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);
				bChanged = true;
			}
			else
			{
				// 03/29/2010 Paul.  Lets not always add the SplendidCRM category, but only do it during creation. 
				// This should not be an issue as we currently do not lookup the Exchange user when creating a contact that originated from the CRM. 
				// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
				//if ( !contact.Categories.Contains(sCRM_FOLDER_NAME) )
				//{
				//	contact.Categories.Add(sCRM_FOLDER_NAME);
				//	bChanged = true;
				//}
				string   sBody          = String.Empty;
				DateTime dtBirthday     = DateTime.MinValue;
				string   sEmailAddress1 = String.Empty;
				string   sEmailAddress2 = String.Empty;
				string   sFileAs        = String.Empty;
				try
				{
					sFileAs = Sql.ToString(contact.FileAs       );
					sBody   = Sql.ToString(contact.PersonalNotes);
				}
				catch
				{
				}
				try
				{
					if ( contact.Birthday.HasValue )
					{
						// 01/18/2021 Paul.  DateTimeOffice already has a LocalDateTime variable. 
						dtBirthday = contact.Birthday.Value.LocalDateTime;
						// 03/28/2010 Paul.  Check for Exchange minimum date. 
						if ( dtBirthday.Year < 1753 )
							dtBirthday = DateTime.MinValue;
					}
				}
				catch
				{
				}
				try
				{
					if ( !Sql.IsEmptyString(contact.Id) && contact.EmailAddresses != null && contact.EmailAddresses.Count > 0 )
						sEmailAddress1 = Sql.ToString(contact.EmailAddresses[0].Address);
				}
				catch
				{
				}
				try
				{
					if ( !Sql.IsEmptyString(contact.Id) && contact.EmailAddresses != null && contact.EmailAddresses.Count > 1 )
						sEmailAddress2 = Sql.ToString(contact.EmailAddresses[1].Address);
				}
				catch
				{
				}
				// 03/28/2010 Paul.  When updating the description, we need to maintain the HTML flag. 
				string   sDESCRIPTION  = Sql.ToString(row["DESCRIPTION"]);
				// 03/28/2010 Paul.  An empty Email Address will cause an exception when calling Contact.Bind(); 
				if ( sFileAs        != sFILE_AS                           ) { contact.FileAs                                        = sFILE_AS                                     ;  bChanged = true; sbChanges.AppendLine("FileAs "     + " changed."); }
				if ( sBody          != sDESCRIPTION                       ) { contact.PersonalNotes                                 = sDESCRIPTION                                 ;  bChanged = true; sbChanges.AppendLine("DESCRIPTION" + " changed."); }
				if ( dtBirthday     != Sql.ToDateTime(row["BIRTHDATE"  ]) ) { contact.Birthday                                      = Sql.ToDateTime(row["BIRTHDATE"])             ;  bChanged = true; sbChanges.AppendLine("BIRTHDATE"   + " changed."); }
				if ( sEmailAddress1 != Sql.ToString  (row["EMAIL1"     ]) )
				{
					if ( !Sql.IsEmptyString(row["EMAIL1"]) )
					{
						if ( contact.EmailAddresses != null )
							contact.EmailAddresses = new List<Spring.Social.Office365.Api.EmailAddress>();
						contact.EmailAddresses.Add(new Spring.Social.Office365.Api.EmailAddress(Sql.ToString(row["EMAIL1"])));
					}
					bChanged = true;
					sbChanges.AppendLine("EMAIL1"      + " changed.");
				}
				if ( sEmailAddress2 != Sql.ToString  (row["EMAIL2"     ]) )
				{
					if ( !Sql.IsEmptyString(row["EMAIL2"]) )
					{
						if ( contact.EmailAddresses != null )
							contact.EmailAddresses = new List<Spring.Social.Office365.Api.EmailAddress>();
						contact.EmailAddresses.Add(new Spring.Social.Office365.Api.EmailAddress(Sql.ToString(row["EMAIL2"])));
					}
					bChanged = true;
					sbChanges.AppendLine("EMAIL2"      + " changed.");
				}
				
				if ( Sql.ToString(contact.AssistantName                                                   ) != Sql.ToString(row["ASSISTANT"                 ]) ) { contact.AssistantName                                                    = Sql.ToString(row["ASSISTANT"                 ]);  bChanged = true; sbChanges.AppendLine("ASSISTANT"                  + " changed."); }
				if ( Sql.ToString(contact.CompanyName                                                     ) != Sql.ToString(row["ACCOUNT_NAME"              ]) ) { contact.CompanyName                                                      = Sql.ToString(row["ACCOUNT_NAME"              ]);  bChanged = true; sbChanges.AppendLine("ACCOUNT_NAME"               + " changed."); }
				if ( Sql.ToString(contact.Department                                                      ) != Sql.ToString(row["DEPARTMENT"                ]) ) { contact.Department                                                       = Sql.ToString(row["DEPARTMENT"                ]);  bChanged = true; sbChanges.AppendLine("DEPARTMENT"                 + " changed."); }
				if ( Sql.ToString(contact.GivenName                                                       ) != Sql.ToString(row["FIRST_NAME"                ]) ) { contact.GivenName                                                        = Sql.ToString(row["FIRST_NAME"                ]);  bChanged = true; sbChanges.AppendLine("FIRST_NAME"                 + " changed."); }
				if ( Sql.ToString(contact.JobTitle                                                        ) != Sql.ToString(row["TITLE"                     ]) ) { contact.JobTitle                                                         = Sql.ToString(row["TITLE"                     ]);  bChanged = true; sbChanges.AppendLine("TITLE"                      + " changed."); }
				if ( Sql.ToString(contact.Surname                                                         ) != Sql.ToString(row["LAST_NAME"                 ]) ) { contact.Surname                                                          = Sql.ToString(row["LAST_NAME"                 ]);  bChanged = true; sbChanges.AppendLine("LAST_NAME"                  + " changed."); }
				if ( Sql.ToString(contact.MobilePhone                                                     ) != Sql.ToString(row["PHONE_MOBILE"              ]) ) { contact.MobilePhone                                                      = Sql.ToString(row["PHONE_MOBILE"              ]);  bChanged = true; sbChanges.AppendLine("PHONE_MOBILE"               + " changed."); }
				
				if ( Sql.ToString(contact.BusinessPhones != null && contact.BusinessPhones.Count > 0 ? contact.BusinessPhones[0] : String.Empty) != Sql.ToString(row["PHONE_WORK"     ]) )
				{
					if ( !Sql.IsEmptyString(row["PHONE_WORK"]) )
					{
						if ( contact.BusinessPhones != null )
							contact.BusinessPhones = new List<String>();
						contact.BusinessPhones.Add(Sql.ToString(row["PHONE_WORK"     ]));
						bChanged = true;
						sbChanges.AppendLine("PHONE_WORK"                + " changed.");
					}
				}
				if ( Sql.ToString(contact.BusinessPhones != null && contact.BusinessPhones.Count > 1 ? contact.BusinessPhones[1] : String.Empty) != Sql.ToString(row["PHONE_FAX"     ]) )
				{
					if ( !Sql.IsEmptyString(row["PHONE_FAX"]) )
					{
						if ( contact.BusinessPhones != null )
							contact.BusinessPhones = new List<String>();
						contact.BusinessPhones.Add(Sql.ToString(row["PHONE_FAX"     ]));
						bChanged = true;
						sbChanges.AppendLine("PHONE_FAX"                + " changed.");
					}
				}
				//if ( Sql.ToString(contact.BusinessPhones != null && contact.BusinessPhones.Count > 2 ? contact.BusinessPhones[2] : String.Empty) != Sql.ToString(row["ASSISTANT_PHONE"     ]) )
				//{
				//	if ( !Sql.IsEmptyString(row["ASSISTANT_PHONE"]) )
				//	{
				//		if ( contact.BusinessPhones != null )
				//			contact.BusinessPhones = new List<String>();
				//		contact.BusinessPhones.Add(Sql.ToString(row["ASSISTANT_PHONE"     ]));
				//		bChanged = true;
				//		sbChanges.AppendLine("ASSISTANT_PHONE"                + " changed.");
				//	}
				//}
				if ( Sql.ToString(contact.HomePhones != null && contact.HomePhones.Count > 0 ? contact.HomePhones[0] : String.Empty) != Sql.ToString(row["PHONE_HOME"     ]) )
				{
					if ( !Sql.IsEmptyString(row["PHONE_HOME"]) )
					{
						if ( contact.HomePhones != null )
							contact.HomePhones = new List<String>();
						contact.HomePhones.Add(Sql.ToString(row["PHONE_HOME"     ]));
						bChanged = true;
						sbChanges.AppendLine("PHONE_HOME"                + " changed.");
					}
				}
				if ( Sql.ToString(contact.HomePhones != null && contact.HomePhones.Count > 1 ? contact.HomePhones[1] : String.Empty) != Sql.ToString(row["PHONE_OTHER"     ]) )
				{
					if ( !Sql.IsEmptyString(row["PHONE_OTHER"]) )
					{
						if ( contact.HomePhones != null )
							contact.HomePhones = new List<String>();
						contact.HomePhones.Add(Sql.ToString(row["PHONE_OTHER"     ]));
						bChanged = true;
						sbChanges.AppendLine("PHONE_OTHER"                + " changed.");
					}
				}
				
				if ( contact.BusinessAddress == null )
					contact.BusinessAddress = new Spring.Social.Office365.Api.PhysicalAddress();
				if ( Sql.ToString(contact.BusinessAddress.Street         ) != Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]) ) { contact.BusinessAddress.Street          = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_STREET"     + " changed."); }
				if ( Sql.ToString(contact.BusinessAddress.City           ) != Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]) ) { contact.BusinessAddress.City            = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_CITY"       + " changed."); }
				if ( Sql.ToString(contact.BusinessAddress.State          ) != Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]) ) { contact.BusinessAddress.State           = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_STATE"      + " changed."); }
				if ( Sql.ToString(contact.BusinessAddress.PostalCode     ) != Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]) ) { contact.BusinessAddress.PostalCode      = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_POSTALCODE" + " changed."); }
				if ( Sql.ToString(contact.BusinessAddress.CountryOrRegion) != Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]) ) { contact.BusinessAddress.CountryOrRegion = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_COUNTRY"    + " changed."); }
				
				if ( contact.OtherAddress == null )
					contact.OtherAddress = new Spring.Social.Office365.Api.PhysicalAddress();
				if ( Sql.ToString(contact.OtherAddress.Street            ) != Sql.ToString(row["ALT_ADDRESS_STREET"        ]) ) { contact.OtherAddress.Street             = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_STREET"         + " changed."); }
				if ( Sql.ToString(contact.OtherAddress.City              ) != Sql.ToString(row["ALT_ADDRESS_CITY"          ]) ) { contact.OtherAddress.City               = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_CITY"           + " changed."); }
				if ( Sql.ToString(contact.OtherAddress.State             ) != Sql.ToString(row["ALT_ADDRESS_STATE"         ]) ) { contact.OtherAddress.State              = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_STATE"          + " changed."); }
				if ( Sql.ToString(contact.OtherAddress.PostalCode        ) != Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]) ) { contact.OtherAddress.PostalCode         = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_POSTALCODE"     + " changed."); }
				if ( Sql.ToString(contact.OtherAddress.CountryOrRegion   ) != Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]) ) { contact.OtherAddress.CountryOrRegion    = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_COUNTRY"        + " changed."); }
			}
			return bChanged;
		}

		public void SyncContacts(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + sEXCHANGE_ALIAS + " to " + gUSER_ID.ToString());
			
			string sCONFLICT_RESOLUTION = Sql.ToString(Application["CONFIG.Exchange.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
			//string sCRM_FOLDER_NAME     = Sql.ToString(Application["CONFIG.Exchange.CrmFolderName"     ]);
			//if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
			//	sCRM_FOLDER_NAME = "SplendidCRM";
			// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
			string sCONTACTS_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Contacts.Category"]);
			
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				
				try
				{
					string sSQL = String.Empty;
					// 04/05/2010 Paul.  When the Watermark is empty, no events will be created for existing items.  In that case, poll the folder 
					// 04/16/2018 Paul.  This condition makes no sense as it prevents normal processing of items unless SyncAll has been pressed on the admin page. 
					//if ( bSyncAll )
					{
						DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.MinValue;
						if ( !bSyncAll )
						{
							sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
							     + "  from vwCONTACTS_SYNC                               " + ControlChars.CrLf
							     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
							     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
								dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.SpecifyKind(Sql.ToDateTime(cmd.ExecuteScalar()), DateTimeKind.Utc);
							}
						}
						
						// 07/07/2015 Paul.  Allow the page size to be customized. 
						int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Contacts.PageSize"]);
						IList<Spring.Social.Office365.Api.Contact> items = service.ContactOperations.GetModified(sCONTACTS_CATEGORY, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC, nPageSize);
						if ( items.Count > 0 )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + items.Count.ToString() + " contacts to retrieve from " + sEXCHANGE_ALIAS);
						foreach ( Spring.Social.Office365.Api.Contact contact in items )
						{
							this.ImportContact(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, contact, sbErrors);
						}
					}
					
					// 03/26/2010 Paul.  Join to vwCONTACTS_USERS so that we only get contacts that are marked as Sync. 
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					// 09/18/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
					// 10/26/2015 Paul.  vwCONTACTS_USERS.SERVICE_NAME will be NULL when the user wants to Sync the contact record. 
					sSQL = "select vwCONTACTS.*                                                               " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_ID                                                    " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_REMOTE_KEY                                            " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                               " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                              " + ControlChars.CrLf
					     + "  from            vwCONTACTS                                                      " + ControlChars.CrLf
					     + "       inner join vwCONTACTS_USERS                                                " + ControlChars.CrLf
					     + "               on vwCONTACTS_USERS.CONTACT_ID           = vwCONTACTS.ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_USERS.USER_ID              = @SYNC_USER_ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_USERS.SERVICE_NAME is null                           " + ControlChars.CrLf
					     + "  left outer join vwCONTACTS_SYNC                                                 " + ControlChars.CrLf
					     + "               on vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'Exchange'             " + ControlChars.CrLf
					     + "              and vwCONTACTS_SYNC.SYNC_LOCAL_ID         = vwCONTACTS.ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_SYNC.SYNC_ASSIGNED_USER_ID = vwCONTACTS_USERS.USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SYNC_USER_ID", gUSER_ID);
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
						
						// 03/28/2010 Paul.  All that is important is that the current date is greater than the last sync date. 
						cmd.CommandText += "   and (vwCONTACTS_SYNC.ID is null or vwCONTACTS.DATE_MODIFIED_UTC > vwCONTACTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC)" + ControlChars.CrLf;
						cmd.CommandText += " order by vwCONTACTS.DATE_MODIFIED_UTC" + ControlChars.CrLf;
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + dt.Rows.Count.ToString() + " contacts to send to " + sEXCHANGE_ALIAS);
								foreach ( DataRow row in dt.Rows )
								{
									Guid     gID                             = Sql.ToGuid    (row["ID"                           ]);
									Guid     gASSIGNED_USER_ID               = Sql.ToGuid    (row["ASSIGNED_USER_ID"             ]);
									Guid     gSYNC_ID                        = Sql.ToGuid    (row["SYNC_ID"                      ]);
									string   sSYNC_REMOTE_KEY                = Sql.ToString  (row["SYNC_REMOTE_KEY"              ]);
									DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
									DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
									DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
									string   sSYNC_ACTION                    = Sql.IsEmptyGuid(gSYNC_ID) ? "local new" : "local changed";
									if ( SplendidInit.bEnableACLFieldSecurity )
									{
										bool bApplyACL = false;
										foreach ( DataColumn col in dt.Columns )
										{
											Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Contacts", col.ColumnName, gASSIGNED_USER_ID);
											if ( !acl.IsReadable() )
											{
												row[col.ColumnName] = DBNull.Value;
												bApplyACL = true;
											}
										}
										if ( bApplyACL )
											dt.AcceptChanges();
									}
									StringBuilder sbChanges = new StringBuilder();
									try
									{
										Spring.Social.Office365.Api.Contact contact = null;
										if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Sending new contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sEXCHANGE_ALIAS);
											contact = new Spring.Social.Office365.Api.Contact();
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
											// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
											this.SetExchangeContact(contact, row, sbChanges, sCONTACTS_CATEGORY);
											contact = service.ContactOperations.Insert(contact);
											sSYNC_REMOTE_KEY = contact.Id;
										}
										else
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Binding contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sEXCHANGE_ALIAS);
											
											// 03/28/2010 Paul.  Instead of binding, use FindItems as the contact may have been deleted in Exchange. 
											// 03/28/2010 Paul.  FindItems is generating an exception: The specified value is invalid for property. 
											//ItemView ivContacts = new ItemView(1, 0);
											//filter = new SearchFilter.IsEqualTo(ContactSchema.Id, sSYNC_REMOTE_KEY);
											//results = service.FindItems(WellKnownFolderName.Contacts, filter, ivContacts);
											//if ( results.Items.Count > 0 )
											try
											{
												//contact = results.Items[0] as Contact;
												contact = service.ContactOperations.GetById(sSYNC_REMOTE_KEY);
												// 03/28/2010 Paul.  We need to double-check for conflicts. 
												DateTime dtREMOTE_DATE_MODIFIED_UTC = (contact.LastModifiedDateTime.HasValue ? contact.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
												// 01/12/2021 Paul.  A deleted message will only return the "@removed" property. 
												if ( contact.Deleted )
												{
													sSYNC_ACTION = "remote deleted";
												}
												else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
												{
													if ( sCONFLICT_RESOLUTION == "remote" )
													{
														// 03/24/2010 Paul.  Remote is the winner of conflicts. 
														sSYNC_ACTION = "remote changed";
													}
													else if ( sCONFLICT_RESOLUTION == "local" )
													{
														// 03/24/2010 Paul.  Local is the winner of conflicts. 
														sSYNC_ACTION = "local changed";
													}
													// 12/25/2020 Paul.  Remvoe the 1 hour window as it is preventing a sync. 
													else if ( dtREMOTE_DATE_MODIFIED_UTC > dtDATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "remote changed";
													}
													// 12/25/2020 Paul.  Remvoe the 1 hour window as it is preventing a sync. 
													else if ( dtDATE_MODIFIED_UTC > dtREMOTE_DATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "local changed";
													}
													else
													{
														sSYNC_ACTION = "prompt change";
													}
												}
												// 03/29/2010 Paul.  If we find the contact, but the Categories no longer contains SplendidCRM, 
												// then the user must have stopped the syncing. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												// 01/12/2021 Paul.  Office 365 does not support contact categories. 
												// 01/13/2021 Paul.  Outlook 365 web site does not support categories, but Outlook windows client does. Outlook 365 will create empty array for Categories. 
												// 01/13/2021 Paul.  Deleted is handled above, not by category clearing. 
												//if ( !Sql.IsEmptyString(sCONTACTS_CATEGORY) && (contact.Categories == null || !contact.Categories.Contains(sCONTACTS_CATEGORY)) )
												//{
												//	sSYNC_ACTION = "remote deleted";
												//}
											}
											catch(Exception ex)
											{
												string sError = "Error retrieving Exchange contact " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + "." + ControlChars.CrLf;
												sError += Utils.ExpandException(ex) + ControlChars.CrLf;
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
												sbErrors.AppendLine(sError);
												sSYNC_ACTION = "remote deleted";
											}
											if ( sSYNC_ACTION == "local changed" )
											{
												// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
												// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												bool bChanged = this.SetExchangeContact(contact, row, sbChanges, sCONTACTS_CATEGORY);
												if ( bChanged )
												{
													if ( bVERBOSE_STATUS )
														SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Sending contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sEXCHANGE_ALIAS);
													service.ContactOperations.Update(contact);
													contact = service.ContactOperations.GetById(contact.Id);
												}
											}
										}
										if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
										{
											if ( contact != null )
											{
												// 03/25/2010 Paul.  Update the modified date after the save. 
												// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
												DateTime dtREMOTE_DATE_MODIFIED_UTC = (contact.LastModifiedDateTime.HasValue ? contact.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
												DateTime dtREMOTE_DATE_MODIFIED     = (contact.LastModifiedDateTime.HasValue ? TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local) : DateTime.MinValue);
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														// 03/26/2010 Paul.  Make sure to set the Sync flag. 
														// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
														// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
														SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sSYNC_REMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
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
										else if ( sSYNC_ACTION == "remote deleted" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Unsyncing contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " for " + sEXCHANGE_ALIAS);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gID, sSYNC_REMOTE_KEY, "Exchange", trn);
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
									catch(Exception ex)
									{
										// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
										string sError = "Error creating Exchange contact " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + " for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
										sError += sbChanges.ToString();
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
									}
								}
							}
						}
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					sbErrors.AppendLine(Utils.ExpandException(ex));
				}
			}
		}

		// 12/12/2011 Paul.  Move population logic to a static method. 
		// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
		// 01/28/2012 Paul.  The transaction is necessary so that an account can be created. 
		public bool BuildCONTACTS_Update(ExchangeSession Session, IDbCommand spCONTACTS_Update, DataRow row, Spring.Social.Office365.Api.Contact contact, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, bool bCreateAccount, IDbTransaction trn)
		{
			bool bChanged = false;
			// 03/25/2010 Paul.  We start with the existing record values so that we can apply ACL Field Security rules. 
			if ( row != null && row.Table != null )
			{
				foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					// 03/28/2010 Paul.  We must assign a value to all parameters. 
					string sParameterName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
					if ( row.Table.Columns.Contains(sParameterName) )
						par.Value = row[sParameterName];
					else
						par.Value = DBNull.Value;
				}
			}
			else
			{
				bChanged = true;
				foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					string sParameterName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
					if ( sParameterName == "TEAM_ID" )
						par.Value = gTEAM_ID;
					else if ( sParameterName == "ASSIGNED_USER_ID" )
						par.Value = gUSER_ID;
					// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
					else if ( sParameterName == "MODIFIED_USER_ID" )
						par.Value = gUSER_ID;
					else
						par.Value = DBNull.Value;
				}
			}
			foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Contacts", sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "DESCRIPTION"               :  oValue = Sql.ToDBString  (contact.PersonalNotes );  break;
							case "ASSISTANT"                 :  oValue = Sql.ToDBString  (contact.AssistantName );  break;
							case "BIRTHDATE"                 :  oValue = (!contact.Birthday.HasValue ? DBNull.Value : Sql.ToDBDateTime(contact.Birthday.Value.DateTime));  break;
							case "ACCOUNT_NAME"              :  oValue = Sql.ToDBString  (contact.CompanyName   );  break;
							case "DEPARTMENT"                :  oValue = Sql.ToDBString  (contact.Department    );  break;
							case "FIRST_NAME"                :  oValue = Sql.ToDBString  (contact.GivenName     );  break;
							case "TITLE"                     :  oValue = Sql.ToDBString  (contact.JobTitle      );  break;
							case "LAST_NAME"                 :  oValue = Sql.ToDBString  (contact.Surname       );  break;
							case "EMAIL1"                    :  if ( contact.EmailAddresses != null && contact.EmailAddresses.Count > 0 ) oValue = Sql.ToDBString(contact.EmailAddresses[0].Address      );  break;
							case "EMAIL2"                    :  if ( contact.EmailAddresses != null && contact.EmailAddresses.Count > 1 ) oValue = Sql.ToDBString(contact.EmailAddresses[1].Address      );  break;
							//case "ASSISTANT_PHONE"           :  if ( contact.BusinessPhones != null && contact.BusinessPhones.Count > 2 ) oValue = Sql.ToDBString(contact.BusinessPhones[2]              );  break;
							case "PHONE_FAX"                 :  if ( contact.BusinessPhones != null && contact.BusinessPhones.Count > 1 ) oValue = Sql.ToDBString(contact.BusinessPhones[1]              );  break;
							case "PHONE_WORK"                :  if ( contact.BusinessPhones != null && contact.BusinessPhones.Count > 0 ) oValue = Sql.ToDBString(contact.BusinessPhones[0]              );  break;
							case "PHONE_MOBILE"              :                                                                            oValue = Sql.ToDBString(contact.MobilePhone                    );  break;
							case "PHONE_OTHER"               :  if ( contact.HomePhones     != null && contact.HomePhones.Count     > 1 ) oValue = Sql.ToDBString(contact.HomePhones[1]                  );  break;
							case "PHONE_HOME"                :  if ( contact.HomePhones     != null && contact.HomePhones.Count     > 0 ) oValue = Sql.ToDBString(contact.HomePhones[0]                  );  break;
							case "PRIMARY_ADDRESS_STREET"    :  if ( contact.BusinessAddress != null                                    ) oValue = Sql.ToDBString(contact.BusinessAddress.Street         );  break;
							case "PRIMARY_ADDRESS_CITY"      :  if ( contact.BusinessAddress != null                                    ) oValue = Sql.ToDBString(contact.BusinessAddress.City           );  break;
							case "PRIMARY_ADDRESS_STATE"     :  if ( contact.BusinessAddress != null                                    ) oValue = Sql.ToDBString(contact.BusinessAddress.State          );  break;
							case "PRIMARY_ADDRESS_POSTALCODE":  if ( contact.BusinessAddress != null                                    ) oValue = Sql.ToDBString(contact.BusinessAddress.PostalCode     );  break;
							case "PRIMARY_ADDRESS_COUNTRY"   :  if ( contact.BusinessAddress != null                                    ) oValue = Sql.ToDBString(contact.BusinessAddress.CountryOrRegion);  break;
							case "ALT_ADDRESS_STREET"        :  if ( contact.OtherAddress    != null                                    ) oValue = Sql.ToDBString(contact.OtherAddress   .Street         );  break;
							case "ALT_ADDRESS_CITY"          :  if ( contact.OtherAddress    != null                                    ) oValue = Sql.ToDBString(contact.OtherAddress   .City           );  break;
							case "ALT_ADDRESS_STATE"         :  if ( contact.OtherAddress    != null                                    ) oValue = Sql.ToDBString(contact.OtherAddress   .State          );  break;
							case "ALT_ADDRESS_POSTALCODE"    :  if ( contact.OtherAddress    != null                                    ) oValue = Sql.ToDBString(contact.OtherAddress   .PostalCode     );  break;
							case "ALT_ADDRESS_COUNTRY"       :  if ( contact.OtherAddress    != null                                    ) oValue = Sql.ToDBString(contact.OtherAddress   .CountryOrRegion);  break;
							// 03/26/2010 Paul.  We need to make sure to set the Sync flag. 
							case "SYNC_CONTACT"              :  oValue = true;  break;
							// 03/27/2010 Paul.  We need to set the Modified User ID in order to set the SYNC_CONTACT flag. 
							case "MODIFIED_USER_ID"          :  oValue = gUSER_ID;  break;
						}
						// 01/28/2012 Paul.  ACCOUNT_NAME does not exist in the spCONTACTS_Update stored procedure.  It is a special case that requires a lookup. 
						if ( sColumnName == "ACCOUNT_ID" )
						{
							string sACCOUNT_NAME = String.Empty;
							Guid   gACCOUNT_ID   = Sql.ToGuid(par.Value);
							if ( !Sql.IsEmptyGuid(gACCOUNT_ID) )
								sACCOUNT_NAME = Modules.ItemName("Accounts", gACCOUNT_ID);
							if ( String.Compare(sACCOUNT_NAME, Sql.ToString(contact.CompanyName), true) != 0 )
							{
								gACCOUNT_ID   = Guid.Empty;
								sACCOUNT_NAME = Sql.ToString(contact.CompanyName);
								if ( !Sql.IsEmptyString(sACCOUNT_NAME) )
								{
									IDbConnection con = spCONTACTS_Update.Connection;
									string sSQL ;
									sSQL = "select ID                   " + ControlChars.CrLf
									     + "  from vwACCOUNTS           " + ControlChars.CrLf
									     + " where NAME = @NAME         " + ControlChars.CrLf
									     + " order by DATE_MODIFIED desc" + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										if ( trn != null )
											cmd.Transaction = trn;
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@NAME", sACCOUNT_NAME);
										gACCOUNT_ID = Sql.ToGuid(cmd.ExecuteScalar());
										if ( Sql.IsEmptyGuid(gACCOUNT_ID) && bCreateAccount )
										{
											// 01/28/2012 Paul.  If the account does not exist, then create it. 
											SqlProcs.spACCOUNTS_Update
												( ref gACCOUNT_ID
												, gUSER_ID      // ASSIGNED_USER_ID
												, sACCOUNT_NAME
												, String.Empty  // ACCOUNT_TYPE
												, Guid.Empty    // PARENT_ID
												, String.Empty  // INDUSTRY
												, String.Empty  // ANNUAL_REVENUE
												, ( contact.BusinessPhones  != null && contact.BusinessPhones.Count > 1 ) ? Sql.ToString(contact.BusinessPhones[1]              ) : String.Empty
												, ( contact.BusinessAddress != null                                     ) ? Sql.ToString(contact.BusinessAddress.Street         ) : String.Empty
												, ( contact.BusinessAddress != null                                     ) ? Sql.ToString(contact.BusinessAddress.City           ) : String.Empty
												, ( contact.BusinessAddress != null                                     ) ? Sql.ToString(contact.BusinessAddress.State          ) : String.Empty
												, ( contact.BusinessAddress != null                                     ) ? Sql.ToString(contact.BusinessAddress.PostalCode     ) : String.Empty
												, ( contact.BusinessAddress != null                                     ) ? Sql.ToString(contact.BusinessAddress.CountryOrRegion) : String.Empty
												, "Account created from Exchange contact " + (contact.FileAs != null ? Sql.ToString(contact.FileAs) : String.Empty)
												, String.Empty  // RATING
												, ( contact.BusinessPhones != null && contact.BusinessPhones.Count  > 0 ) ? Sql.ToString(contact.BusinessPhones[0]               ) : String.Empty  // PHONE_OFFICE
												, String.Empty  // PHONE_ALTERNATE
												, ( contact.EmailAddresses != null && contact.EmailAddresses.Count  > 0 ) ? Sql.ToString(contact.EmailAddresses[0].Address       ) : String.Empty
												, String.Empty  // EMAIL2
												, String.Empty  // WEBSITE
												, String.Empty  // OWNERSHIP
												, String.Empty  // EMPLOYEES
												, String.Empty  // SIC_CODE
												, String.Empty  // TICKER_SYMBOL
												, String.Empty  // SHIPPING_ADDRESS_STREET
												, String.Empty  // SHIPPING_ADDRESS_CITY
												, String.Empty  // SHIPPING_ADDRESS_STATE
												, String.Empty  // SHIPPING_ADDRESS_POSTALCODE
												, String.Empty  // SHIPPING_ADDRESS_COUNTRY
												, String.Empty  // ACCOUNT_NUMBER
												, gTEAM_ID      // TEAM_ID
												, String.Empty  // TEAM_SET_LIST
												, false         // EXCHANGE_FOLDER
												// 08/07/2015 Paul.  Add picture. 
												, String.Empty  // PICTURE
												// 05/12/2016 Paul.  Add Tags module. 
												, String.Empty  // TAG_SET_NAME
												// 06/07/2017 Paul.  Add NAICSCodes module. 
												, String.Empty  // NAICS_SET_NAME
												// 10/27/2017 Paul.  Add Accounts as email source. 
												, false         // DO_NOT_CALL
												, false         // EMAIL_OPT_OUT
												, false         // INVALID_EMAIL
												// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
												, String.Empty  // ASSIGNED_SET_LIST
												, trn
												);
										}
									}
								}
								par.Value = gACCOUNT_ID;
								bChanged = true;
							}
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						else if ( oValue != null )
						{
							if ( !bChanged )
							{
								switch ( par.DbType )
								{
									case DbType.Guid    :  if ( Sql.ToGuid    (par.Value) != Sql.ToGuid    (oValue) ) bChanged = true;  break;
									case DbType.Int16   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int32   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int64   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Double  :  if ( Sql.ToDouble  (par.Value) != Sql.ToDouble  (oValue) ) bChanged = true;  break;
									case DbType.Decimal :  if ( Sql.ToDecimal (par.Value) != Sql.ToDecimal (oValue) ) bChanged = true;  break;
									case DbType.Boolean :  if ( Sql.ToBoolean (par.Value) != Sql.ToBoolean (oValue) ) bChanged = true;  break;
									case DbType.DateTime:  if ( Sql.ToDateTime(par.Value) != Sql.ToDateTime(oValue) ) bChanged = true;  break;
									default             :  if ( Sql.ToString  (par.Value) != Sql.ToString  (oValue) ) bChanged = true;  break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
						// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}

		public void DeleteContact(Guid gUSER_ID, string sREMOTE_KEY)
		{
			string sEXCHANGE_ALIAS = String.Empty;;
			try
			{
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
				// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
				string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"     ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret" ]);
				bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365AccessToken token = this.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gUSER_ID, false);
				Spring.Social.Office365.Api.IOffice365 service = CreateApi(token.access_token);
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					String sSQL = String.Empty;
					sSQL = "select EXCHANGE_ALIAS              " + ControlChars.CrLf
					     + "  from vwEXCHANGE_USERS            " + ControlChars.CrLf
					     + " where ASSIGNED_USER_ID  = @USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
						sEXCHANGE_ALIAS = Sql.ToString(cmd.ExecuteScalar());
					}
					
					sSQL = "select ID                                            " + ControlChars.CrLf
					     + "  from vwCONTACTS_SYNC                               " + ControlChars.CrLf
					     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
					     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
					     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
						Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
						Guid gID = Sql.ToGuid(cmd.ExecuteScalar());
						if ( !Sql.IsEmptyGuid(gID) )
						{
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Office365Sync.DeleteContact: Unsyncing contact for " + sEXCHANGE_ALIAS + " to " + gID.ToString());
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gID, sREMOTE_KEY, "Exchange", trn);
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
				}
			}
			catch(Exception ex)
			{
				string sError = "Office365Sync.DeleteContact: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
		}

		// 11/22/2023 Paul.  When unsyncing, we need to immediately clear the remote flag. 
		public void UnsyncContact(Guid gUSER_ID, string sEXCHANGE_ALIAS, Guid gCONTACT_ID, string sREMOTE_KEY)
		{
			try
			{
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
				string sOAUTH_CLIENT_ID       = Sql.ToString(Application["CONFIG.Exchange.ClientID"         ]);
				string sOAUTH_CLIENT_SECRET   = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"     ]);
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				string sCONTACTS_CATEGORY     = Sql.ToString(Application["CONFIG.Exchange.Contacts.Category"]);
				Office365AccessToken token = this.Office365RefreshAccessToken( sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gUSER_ID, false);
				Spring.Social.Office365.Api.IOffice365 service = CreateApi(token.access_token);
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
					if ( bVERBOSE_STATUS )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Office365Sync.UnsyncContact: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + ".");
					
					service.ContactOperations.Unsync(sREMOTE_KEY, sCONTACTS_CATEGORY);
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gCONTACT_ID, sREMOTE_KEY, "Exchange", trn);
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
			catch(Exception ex)
			{
				string sError = "Office365Sync.UnsyncContact: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
		}

		public void ImportContact(Guid gUSER_ID, string sREMOTE_KEY)
		{
			string sEXCHANGE_ALIAS = String.Empty;;
			try
			{
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
				// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
				string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365AccessToken token = this.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gUSER_ID, false);
				Spring.Social.Office365.Api.IOffice365 service = CreateApi(token.access_token);
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select EXCHANGE_ALIAS              " + ControlChars.CrLf
					     + "  from vwEXCHANGE_USERS            " + ControlChars.CrLf
					     + " where ASSIGNED_USER_ID  = @USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
						sEXCHANGE_ALIAS = Sql.ToString(cmd.ExecuteScalar());
					}
					
					bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
					if ( bVERBOSE_STATUS )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Office365Sync.ImportContact: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + ".");
					
					StringBuilder sbErrors = new StringBuilder();
					Spring.Social.Office365.Api.Contact contact = service.ContactOperations.GetById(sREMOTE_KEY);
					this.ImportContact(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, contact, sbErrors);
					if ( sbErrors.Length > 0 )
						throw(new Exception(sbErrors.ToString()));
				}
			}
			catch(Exception ex)
			{
				string sError = "Office365Sync.ImportContact: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
		}

		public void ImportContact(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, Spring.Social.Office365.Api.Contact contact, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.Exchange.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid   (Session["TEAM_ID"]);
			// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
			//string sCRM_FOLDER_NAME     = Sql.ToString (Application["CONFIG.Exchange.CrmFolderName"     ]);
			//if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
			//	sCRM_FOLDER_NAME = "SplendidCRM";
			// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
			string sCONTACTS_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Contacts.Category"]);
			
			IDbCommand spCONTACTS_Update = SqlProcs.Factory(con, "spCONTACTS_Update");

			string   sREMOTE_KEY                = contact.Id;
			// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
			DateTime dtREMOTE_DATE_MODIFIED_UTC = (contact.LastModifiedDateTime.HasValue ? contact.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
			DateTime dtREMOTE_DATE_MODIFIED     = (contact.LastModifiedDateTime.HasValue ? TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local) : DateTime.MinValue);

			String sSQL = String.Empty;
			sSQL = "select SYNC_ID                                       " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_DATE_MODIFIED_UTC                  " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_DATE_MODIFIED_UTC                 " + ControlChars.CrLf
			     + "     , SYNC_CONTACT                                  " + ControlChars.CrLf
			     + "     , ID                                            " + ControlChars.CrLf
			     + "     , DATE_MODIFIED_UTC                             " + ControlChars.CrLf
			     + "  from vwCONTACTS_SYNC                               " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
			     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf;
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
				Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					string sSYNC_ACTION   = String.Empty;
					Guid   gID            = Guid.Empty;
					Guid   gSYNC_LOCAL_ID = Guid.Empty;
					using ( DataTable dt = new DataTable() )
					{
						da.Fill(dt);
						if ( dt.Rows.Count > 0 )
						{
							DataRow row = dt.Rows[0];
							gID                                      = Sql.ToGuid    (row["ID"                           ]);
							gSYNC_LOCAL_ID                           = Sql.ToGuid    (row["SYNC_LOCAL_ID"                ]);
							DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
							DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
							DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
							bool     bSYNC_CONTACT                   = Sql.ToBoolean (row["SYNC_CONTACT"                 ]);
							// 03/24/2010 Paul.  Exchange Record has already been mapped for this user. 
							// 03/28/2010 Paul.  If the ID is NULL and the LOCAL_ID is NOT NULL, then the local item must have been deleted. 
							// 03/29/2010 Paul.  If ID and LOCAL_ID are valid, but SYNC_CONTACT is not, then the user has stopped syncing the contact. 
							// 01/12/2021 Paul.  A deleted message will only return the "@removed" property. 
							if ( contact.Deleted )
							{
								sSYNC_ACTION = "remote deleted";
							}
							else if ( (Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID)) || (!Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID) && !bSYNC_CONTACT) )
							{
								sSYNC_ACTION = "local deleted";
							}
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								if ( sCONFLICT_RESOLUTION == "remote" )
								{
									// 03/24/2010 Paul.  Remote is the winner of conflicts. 
									sSYNC_ACTION = "remote changed";
								}
								else if ( sCONFLICT_RESOLUTION == "local" )
								{
									// 03/24/2010 Paul.  Local is the winner of conflicts. 
									sSYNC_ACTION = "local changed";
								}
								// 12/25/2020 Paul.  Remvoe the 1 hour window as it is preventing a sync. 
								else if ( dtREMOTE_DATE_MODIFIED_UTC > dtDATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "remote changed";
								}
								// 12/25/2020 Paul.  Remvoe the 1 hour window as it is preventing a sync. 
								else if ( dtDATE_MODIFIED_UTC > dtREMOTE_DATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "local changed";
								}
								else
								{
									sSYNC_ACTION = "prompt change";
								}
								
							}
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Remote Record has changed, but Local has not. 
								sSYNC_ACTION = "remote changed";
							}
							else if ( dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Local Record has changed, but Remote has not. 
								sSYNC_ACTION = "local changed";
							}
						}
						// 01/12/2021 Paul.  Don't treat as new if category not assigned. 
						// 01/12/2021 Paul.  Office 365 does not provide a way to set the category in the UI, so we must capture all or no new contacts. 
						// 01/13/2021 Paul.  Outlook 365 web site does not support categories, but Outlook windows client does. Outlook 365 will create empty array for Categories. 
						else if ( Sql.IsEmptyString(sCONTACTS_CATEGORY) || contact.Categories == null || contact.Categories.Count == 0 || contact.Categories.Contains(sCONTACTS_CATEGORY) )
						{
							sSYNC_ACTION = "remote new";
							
							// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to Exchange. 
							// 03/28/2010 Paul.  We need to prevent duplicate Exchange entries from attaching to an existing mapped Contact ID. 
							cmd.Parameters.Clear();
							sSQL = "select vwCONTACTS.ID             " + ControlChars.CrLf
							     + "  from            vwCONTACTS     " + ControlChars.CrLf
							     + "  left outer join vwCONTACTS_SYNC" + ControlChars.CrLf
							     + "               on vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_LOCAL_ID         = vwCONTACTS.ID         " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
							if ( contact.EmailAddresses.Count > 0 && !Sql.IsEmptyString(contact.EmailAddresses[0].Address) )
							{
								Sql.AppendParameter(cmd, Sql.ToString(contact.EmailAddresses[0].Address), "EMAIL1");
							}
							else
							{
								if ( Sql.IsEmptyString(contact.GivenName) && Sql.IsEmptyString(contact.Surname) )
								{
									Sql.AppendParameter(cmd, Sql.ToString(contact.DisplayName), "NAME");
								}
								else
								{
									Sql.AppendParameter(cmd, Sql.ToString(contact.GivenName), "FIRST_NAME");
									Sql.AppendParameter(cmd, Sql.ToString(contact.Surname  ), "LAST_NAME" );
								}
							}
							cmd.CommandText += "   and vwCONTACTS_SYNC.ID is null" + ControlChars.CrLf;
							gID = Sql.ToGuid(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyGuid(gID) )
							{
								// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to Exchange. 
								sSYNC_ACTION = "local new";
							}
						}
						else
						{
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Ignoring uncategorized contact " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " from " + sEXCHANGE_ALIAS);
						}
					}
					using ( DataTable dt = new DataTable() )
					{
						DataRow row = null;
						Guid gASSIGNED_USER_ID = Guid.Empty;
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" || sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new" )
						{
							if ( !Sql.IsEmptyGuid(gID) )
							{
								cmd.Parameters.Clear();
								sSQL = "select *         " + ControlChars.CrLf
								     + "  from vwCONTACTS" + ControlChars.CrLf
								     + " where ID = @ID  " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
								{
									row = dt.Rows[0];
									gASSIGNED_USER_ID = Sql.ToGuid(row["ASSIGNED_USER_ID"]);
								}
							}
						}
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" )
						{
							try
							{
								contact = service.ContactOperations.GetById(sREMOTE_KEY);
							}
							catch(Exception ex)
							{
								string sError = "Error retrieving " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Retrieving contact " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " from " + sEXCHANGE_ALIAS);
									
									spCONTACTS_Update.Transaction = trn;
									// 12/12/2011 Paul.  Move population logic to a static method. 
									// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
									// 01/28/2012 Paul.  The transaction is necessary so that an account can be created. 
									bool bChanged = BuildCONTACTS_Update(Session, spCONTACTS_Update, row, contact, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID, true, trn);
									if ( bChanged )
									{
										Sql.Trace(spCONTACTS_Update);
										spCONTACTS_Update.ExecuteNonQuery();
										IDbDataParameter parID = Sql.FindParameter(spCONTACTS_Update, "@ID");
										gID = Sql.ToGuid(parID.Value);
									}
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									// 02/20/2013 Paul.  Log inner error. 
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
									throw;
								}
							}
						}
						else if ( (sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new") && !Sql.IsEmptyGuid(gID) )
						{
							// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to Exchange. 
							if ( dt.Rows.Count > 0 )
							{
								row = dt.Rows[0];
								if ( SplendidInit.bEnableACLFieldSecurity )
								{
									bool bApplyACL = false;
									foreach ( DataColumn col in dt.Columns )
									{
										Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Contacts", col.ColumnName, gASSIGNED_USER_ID);
										if ( !acl.IsReadable() )
										{
											row[col.ColumnName] = DBNull.Value;
											bApplyACL = true;
										}
									}
									if ( bApplyACL )
										dt.AcceptChanges();
								}
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Syncing contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sEXCHANGE_ALIAS);
									// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
									// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
									// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
									// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
									bool bChanged = this.SetExchangeContact(contact, row, sbChanges, sCONTACTS_CATEGORY);
									if ( bChanged )
									{
										if ( Sql.IsEmptyString(contact.Id) )
										{
											contact = service.ContactOperations.Insert(contact);
											contact = service.ContactOperations.GetById(contact.Id);
											sREMOTE_KEY = contact.Id;
										}
										else
										{
											service.ContactOperations.Update(contact);
											contact = service.ContactOperations.GetById(contact.Id);
										}
									}
									// 03/25/2010 Paul.  Update the modified date after the save. 
									// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
									dtREMOTE_DATE_MODIFIED_UTC = (contact.LastModifiedDateTime.HasValue ? contact.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
									dtREMOTE_DATE_MODIFIED     = (contact.LastModifiedDateTime.HasValue ? TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local) : DateTime.MinValue);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 03/26/2010 Paul.  Make sure to set the Sync flag. 
											// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
											// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
											SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
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
									// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
									string sError = "Error saving " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + " to " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
									sError += sbChanges.ToString();
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
						else if ( sSYNC_ACTION == "local deleted" )
						{
							try
							{
								// 03/28/2010 Paul.  Load the full contact so that we can modify just the one field. 
								contact = service.ContactOperations.GetById(sREMOTE_KEY);
								// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
								// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
								// 09/02/2018 Paul.  Provide an option to delete the created record. 
								if ( !Sql.IsEmptyString(sCONTACTS_CATEGORY) && !Sql.ToBoolean(Application["CONFIG.Exchange.Contacts.Delete"]) )
								{
									// 01/12/2021 Paul.  Office 365 does not support contact categories. 
									// 01/13/2021 Paul.  Outlook 365 web site does not support categories, but Outlook windows client does. Outlook 365 will create empty array for Categories. 
									if ( contact.Categories.Contains(sCONTACTS_CATEGORY) )
									{
										contact.Categories.Remove(sCONTACTS_CATEGORY);
										service.ContactOperations.Update(contact);
									}
								}
								else
								{
									// 09/02/2013 Paul.  If the category is empty, then delete the contact. 
									service.ContactOperations.Delete(sREMOTE_KEY);
								}
							}
							catch(Exception ex)
							{
								string sError = "Error clearing Exchange categories for " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " from " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							try
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Deleting " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " from " + sEXCHANGE_ALIAS);
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
										SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sREMOTE_KEY, "Exchange", trn);
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
								string sError = "Error deleting " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " from " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
						}
						// 01/12/2021 Paul.  A deleted message will only return the "@removed" property. 
						else if ( sSYNC_ACTION == "remote deleted" )
						{
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Unsyncing contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " for " + sEXCHANGE_ALIAS);
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gID, sREMOTE_KEY, "Exchange", trn);
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
				}
			}
		}
		#endregion

		#region Sync Appointments
		// 01/15/2012 Paul.  We need to check for added or removed participants. 
		private DataTable AppointmentEmails(IDbConnection con, Guid gID)
		{
			DataTable dtAppointmentEmails = new DataTable();
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					string sSQL;
					// 01/15/2012 Paul.  An Exchange contact can be created without an email. 
					// 03/11/2012 Paul.  ExchangeSync needs the name in its check for added or removed attendees. 
					// 03/11/2012 Paul.  Exchange requires a valid Email address. 
					sSQL = "select EMAIL1               " + ControlChars.CrLf
					     + "     , NAME                 " + ControlChars.CrLf
					     + "     , REQUIRED             " + ControlChars.CrLf
					     + "     , ACCEPT_STATUS        " + ControlChars.CrLf
					     + "     , ASSIGNED_USER_ID     " + ControlChars.CrLf
					     + "  from vwAPPOINTMENTS_EMAIL1" + ControlChars.CrLf
					     + " where APPOINTMENT_ID = @ID " + ControlChars.CrLf
					     + "   and EMAIL1 is not null   " + ControlChars.CrLf;
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gID);
					
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dtAppointmentEmails);
				}
			}
			return dtAppointmentEmails;
		}

		// 01/15/2012 Paul.  We need to check for added or removed participants. 
		// 07/26/2012 James.  Add the ability to disable participants. 
		// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
		private bool SetExchangeAppointment(Spring.Social.Office365.Api.Event appointment, DataRow row, DataTable dtAppointmentEmails, StringBuilder sbChanges, bool bDISABLE_PARTICIPANTS, string sCALENDAR_CATEGORY)
		{
			bool bChanged = false;
			if ( Sql.IsEmptyString(appointment.Id) )
			{
				// 03/28/2010 Paul.  You must load or assign this property before you can read its value. 
				// So set all the fields to empty values. 
				// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
				// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
				if ( !Sql.IsEmptyString(sCALENDAR_CATEGORY) )
				{
					if ( appointment.Categories == null )
						appointment.Categories = new List<String>();
					appointment.Categories.Add(sCALENDAR_CATEGORY);
				}
				appointment.Subject                    = Sql.ToString  (row["NAME"         ]);
				if ( !Sql.IsEmptyString(row["LOCATION"     ]) )
				{
					appointment.Location = new Spring.Social.Office365.Api.Location();
					appointment.Location.DisplayName = Sql.ToString  (row["LOCATION"     ]);
				}
				// 07/26/2012 Paul.  We need to set the body type. 
				string   sDESCRIPTION = Sql.ToString  (row["DESCRIPTION"]);
				if ( !Sql.IsEmptyString(sDESCRIPTION) )
				{
					appointment.Body = new Spring.Social.Office365.Api.ItemBody();
					appointment.Body.Content = sDESCRIPTION;
					// 06/22/2018 Paul.  Might include namespaces. 
					appointment.Body.ContentType = sDESCRIPTION.StartsWith("<html") ? "html" : "text";
				}
				// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  Exchange stores the reminder in minutes. 
				// 02/20/2013 Paul.  Don't set the reminder for old appointments, but include appointments for today. 
				// 03/19/2013 Paul.  Make sure to use the IsReminderSet flag to prevent reminder when not set in CRM. 
				// http://msdn.microsoft.com/en-us/library/ms528181(v=exchg.10).aspx
				if ( Sql.ToDateTime(row["DATE_START"]) >= DateTime.Now && (Sql.ToInteger(row["REMINDER_TIME"]) > 0) )
				{
					appointment.IsReminderOn = true;
					// 03/19/2013 Paul.  IsReminderSet is set to true by default. 
					appointment.ReminderMinutesBeforeStart = Sql.ToInteger(row["REMINDER_TIME"]) / 60;
				}
				else
				{
					appointment.IsReminderOn = false;
				}
				// 12/06/2020 Paul.  ToDateTimeTimeZone() should set the TimeZone property. 
				//// 03/30/2010 Paul.  We still get TimeZone is Invalid if we specify a TimeZoneInfo.Utc. 
				//// 03/30/2010 Paul.  We need to set the TimeZone to Local, otherwise we will get an exception "TimeZone is invalid". 
				//appointment.StartTimeZone              = TimeZoneInfo.Local;
				//// 08/31/2017 Paul.  We need to also set the EndTimeZone, otherwise we get "EndDate is earlier than StartDate" on some systems. 
				//// 02/12/2018 Paul.  The property EndTimeZone is valid only for Exchange 2010 or later versions. 
				//if ( appointment.Service.RequestedServerVersion != ExchangeVersion.Exchange2007_SP1 )
				//	appointment.EndTimeZone                = TimeZoneInfo.Local;
				appointment.Start                      = Spring.Social.Office365.Api.DateTimeTimeZone.ToDateTimeTimeZone(Sql.ToDateTime(row["DATE_START"   ]), TimeZoneInfo.Local);
				appointment.End                        = Spring.Social.Office365.Api.DateTimeTimeZone.ToDateTimeTimeZone(Sql.ToDateTime(row["DATE_END"     ]), TimeZoneInfo.Local);
				// 03/10/2013 Paul.  Add ALL_DAY_EVENT. 
				appointment.IsAllDay                   = Sql.ToBoolean (row["ALL_DAY_EVENT"]);
				appointment.Sensitivity                = "normal";
				// 03/23/2013 Paul.  Add recurrence data. 
				string sREPEAT_TYPE = Sql.ToString(row["REPEAT_TYPE"]);
				if ( !Sql.IsEmptyString(sREPEAT_TYPE) )
				{
					int      nREPEAT_COUNT    = Sql.ToInteger (row["REPEAT_COUNT"   ]);
					int      nREPEAT_INTERVAL = Sql.ToInteger (row["REPEAT_INTERVAL"]);
					DateTime dtREPEAT_UNTIL   = Sql.ToDateTime(row["REPEAT_UNTIL"   ]);
					// http://msdn.microsoft.com/en-us/library/exchange/dd633694(v=exchg.80).aspx
					switch ( sREPEAT_TYPE )
					{
						case "Daily":
							//appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern(appointment.Start, nREPEAT_INTERVAL);
							appointment.Recurrence = new Spring.Social.Office365.Api.PatternedRecurrence();
							appointment.Recurrence.Pattern          = new Spring.Social.Office365.Api.RecurrencePattern();
							appointment.Recurrence.Pattern.Type     = "daily";
							appointment.Recurrence.Pattern.Interval = nREPEAT_INTERVAL;
							appointment.Recurrence.Range            = new Spring.Social.Office365.Api.RecurrenceRange();
							appointment.Recurrence.Range.StartDate  = appointment.Start.ToDateTime();
							// https://docs.microsoft.com/en-us/graph/api/resources/recurrencerange?view=graph-rest-1.0
							appointment.Recurrence.Range.Type = "noEnd";
							if ( dtREPEAT_UNTIL != DateTime.MinValue )
							{
								appointment.Recurrence.Range.Type    = "endDate";
								appointment.Recurrence.Range.EndDate = dtREPEAT_UNTIL;
							}
							else
							{
								appointment.Recurrence.Range.EndDate = null;
							}
							if ( nREPEAT_COUNT > 0 )
							{
								appointment.Recurrence.Range.Type                = "numbered";
								appointment.Recurrence.Range.NumberOfOccurrences = nREPEAT_COUNT;
							}
							else
							{
								appointment.Recurrence.Range.NumberOfOccurrences = null;
							}
							break;
						case "Weekly":
							string sREPEAT_DOW = Sql.ToString(row["REPEAT_DOW"]);
							if ( !Sql.IsEmptyString(sREPEAT_DOW) )
							{
								//Microsoft.Exchange.WebServices.Data.DayOfTheWeek[] days = new Microsoft.Exchange.WebServices.Data.DayOfTheWeek[sREPEAT_DOW.Length];
								List<String> days = new List<String>();
								for ( int n = 0; n < sREPEAT_DOW.Length; n++ )
								{
									//days[n] = (DayOfTheWeek) Sql.ToInteger(sREPEAT_DOW.Substring(n, 1));
									switch ( sREPEAT_DOW.Substring(n, 1) )
									{
										case "0":  days.Add("sunday"   );  break;
										case "1":  days.Add("monday"   );  break;
										case "2":  days.Add("tuesday"  );  break;
										case "3":  days.Add("wednesday");  break;
										case "4":  days.Add("thursday" );  break;
										case "5":  days.Add("friday"   );  break;
										case "6":  days.Add("saturday" );  break;
									}
								}
								if ( days.Count > 0 )
								{
									//appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern(appointment.Start, nREPEAT_INTERVAL, days);
									appointment.Recurrence = new Spring.Social.Office365.Api.PatternedRecurrence();
									appointment.Recurrence.Pattern                = new Spring.Social.Office365.Api.RecurrencePattern();
									appointment.Recurrence.Pattern.Type           = "weekly";
									appointment.Recurrence.Pattern.Interval       = nREPEAT_INTERVAL;
									appointment.Recurrence.Pattern.DaysOfWeek     = days;
									appointment.Recurrence.Pattern.FirstDayOfWeek = days[0];
									appointment.Recurrence.Range                  = new Spring.Social.Office365.Api.RecurrenceRange();
									appointment.Recurrence.Range.Type             = "noEnd";
									if ( dtREPEAT_UNTIL != DateTime.MinValue )
									{
										appointment.Recurrence.Range.Type    = "endDate";
										appointment.Recurrence.Range.EndDate = dtREPEAT_UNTIL;
									}
									else
									{
										appointment.Recurrence.Range.EndDate = null;
									}
									if ( nREPEAT_COUNT > 0 )
									{
										appointment.Recurrence.Range.Type                = "numbered";
										appointment.Recurrence.Range.NumberOfOccurrences = nREPEAT_COUNT;
									}
									else
									{
										appointment.Recurrence.Range.NumberOfOccurrences = null;
									}
								}
							}
							break;
						case "Monthly":
							//appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern(appointment.Start, nREPEAT_INTERVAL, appointment.Start.Day);
							appointment.Recurrence = new Spring.Social.Office365.Api.PatternedRecurrence();
							appointment.Recurrence.Pattern            = new Spring.Social.Office365.Api.RecurrencePattern();
							appointment.Recurrence.Pattern.Type       = "absoluteMonthly";
							appointment.Recurrence.Pattern.Interval   = nREPEAT_INTERVAL;
							appointment.Recurrence.Pattern.DayOfMonth = appointment.Start.ToDateTime().Day;
							appointment.Recurrence.Range              = new Spring.Social.Office365.Api.RecurrenceRange();
							appointment.Recurrence.Range.StartDate    = appointment.Start.ToDateTime();
							appointment.Recurrence.Range.Type         = "noEnd";
							if ( dtREPEAT_UNTIL != DateTime.MinValue )
							{
								appointment.Recurrence.Range.Type    = "endDate";
								appointment.Recurrence.Range.EndDate = dtREPEAT_UNTIL;
							}
							else
							{
								appointment.Recurrence.Range.EndDate = null;
							}
							if ( nREPEAT_COUNT > 0 )
							{
								appointment.Recurrence.Range.Type                = "numbered";
								appointment.Recurrence.Range.NumberOfOccurrences = nREPEAT_COUNT;
							}
							else
							{
								appointment.Recurrence.Range.NumberOfOccurrences = null;
							}
							break;
						case "Yearly":
							//appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.YearlyPattern(appointment.Start, (Microsoft.Exchange.WebServices.Data.Month) appointment.Start.Month, appointment.Start.Day);
							appointment.Recurrence = new Spring.Social.Office365.Api.PatternedRecurrence();
							appointment.Recurrence.Pattern            = new Spring.Social.Office365.Api.RecurrencePattern();
							appointment.Recurrence.Pattern.Type       = "absoluteYearly";
							appointment.Recurrence.Pattern.Interval   = nREPEAT_INTERVAL;
							appointment.Recurrence.Pattern.DayOfMonth = appointment.Start.ToDateTime().Day;
							appointment.Recurrence.Pattern.Month      = appointment.Start.ToDateTime().Month;
							appointment.Recurrence.Range              = new Spring.Social.Office365.Api.RecurrenceRange();
							appointment.Recurrence.Range.StartDate    = appointment.Start.ToDateTime();
							appointment.Recurrence.Range.Type         = "noEnd";
							if ( dtREPEAT_UNTIL != DateTime.MinValue )
							{
								appointment.Recurrence.Range.Type    = "endDate";
								appointment.Recurrence.Range.EndDate = dtREPEAT_UNTIL;
							}
							else
							{
								appointment.Recurrence.Range.EndDate = null;
							}
							if ( nREPEAT_COUNT > 0 )
							{
								appointment.Recurrence.Range.Type                = "numbered";
								appointment.Recurrence.Range.NumberOfOccurrences = nREPEAT_COUNT;
							}
							else
							{
								appointment.Recurrence.Range.NumberOfOccurrences = null;
							}
							break;
					}
				}
				
				// 01/15/2012 Paul.  We need to check for added or removed participants. 
				// 07/26/2012 James.  Add the ability to disable participants. 
				if ( !bDISABLE_PARTICIPANTS )
				{
					if ( dtAppointmentEmails.Rows.Count > 0 )
					{
						if ( appointment.Attendees == null )
							appointment.Attendees = new List<Spring.Social.Office365.Api.Attendee>();
						foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
						{
							string sNAME     = Sql.ToString (rowEmail["NAME"    ]);
							string sEMAIL1   = Sql.ToString (rowEmail["EMAIL1"  ]);
							bool   bREQUIRED = Sql.ToBoolean(rowEmail["REQUIRED"]);
							Spring.Social.Office365.Api.Attendee guest = new Spring.Social.Office365.Api.Attendee(sNAME, sEMAIL1);
							guest.Type = (bREQUIRED ? "required" : "optional");
							appointment.Attendees.Add(guest);
						}
					}
				}
				bChanged = true;
			}
			else
			{
				// 03/29/2010 Paul.  Lets not always add the SplendidCRM category, but only do it during creation. 
				// This should not be an issue as we currently do not lookup the Exchange user when creating a appointment that originated from the CRM. 
				// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
				//if ( !appointment.Categories.Contains(sCRM_FOLDER_NAME) )
				//{
				//	appointment.Categories.Add(sCRM_FOLDER_NAME);
				//	bChanged = true;
				//}
				// 12/25/2020 Paul.  Instead of cleaning text, use Prefer: outlook.body-content-type request header. 
				string sBody   = (appointment.Body == null ? String.Empty : appointment.Body.Content);

				// 03/28/2010 Paul.  When updating the description, we need to maintain the HTML flag. 
				string   sDESCRIPTION = Sql.ToString  (row["DESCRIPTION"]);
				// 03/29/2010 Paul.  Exchange will use UTC. 
				// 05/09/2018 Paul.  We still return dates as UTC, so still compare that way, but set using local time. 
				DateTime dtDATE_START = Sql.ToDateTime(row["DATE_START" ]).ToUniversalTime();
				DateTime dtDATE_END   = Sql.ToDateTime(row["DATE_END"   ]).ToUniversalTime();
				// 06/22/2018 Paul.  Might include namespaces. 
				// 03/28/2010 Paul.  An empty Email Address will cause an exception when calling Appointment.Bind(); 
				if ( sBody != sDESCRIPTION )
				{
					if ( appointment.Body == null )
						appointment.Body = new Api.ItemBody();
					appointment.Body.Content     = sDESCRIPTION;
					appointment.Body.ContentType = sDESCRIPTION.StartsWith("<html") ? "html" : "text";
					bChanged = true; sbChanges.AppendLine("DESCRIPTION"   + " changed.");
				}
				if ( Sql.ToString  (appointment.Subject )   != Sql.ToString  (row["NAME"      ])   )
				{
					appointment.Subject                    = Sql.ToString(row["NAME"    ])               ;
					bChanged = true; sbChanges.AppendLine("NAME"          + " changed.");
				}
				string sLocation = appointment.Location != null ? Sql.ToString(appointment.Location.DisplayName) : String.Empty;
				if ( sLocation != Sql.ToString  (row["LOCATION"  ])   )
				{
					if ( appointment.Location == null )
						appointment.Location = new Spring.Social.Office365.Api.Location();
					appointment.Location.DisplayName = Sql.ToString(row["LOCATION"]);
					bChanged = true; sbChanges.AppendLine("LOCATION"      + " changed.");
				}
				if ( Sql.ToDateTime(appointment.Start   )   != dtDATE_START )
				{
					// 07/14/2014 Paul.  StartTimeZone required when setting the Start, End, IsAllDayEvent, or Recurrence properties. You must load or assign this property before attempting to update the appointment.
					// 05/09/2018 Paul.  We still return dates as UTC, so still compare that way, but set using local time. 
					// 12/06/2020 Paul.  ToDateTimeTimeZone() should set the TimeZone property. 
					//appointment.StartTimeZone = TimeZoneInfo.Local;
					dtDATE_START = Sql.ToDateTime(row["DATE_START" ]);
					appointment.Start = Spring.Social.Office365.Api.DateTimeTimeZone.ToDateTimeTimeZone(dtDATE_START, TimeZoneInfo.Local);
					bChanged = true;
					sbChanges.AppendLine("DATE_START"    + " changed. " + dtDATE_START.ToString());
				}
				if ( Sql.ToDateTime(appointment.End     )   != dtDATE_END )
				{
					// 08/31/2017 Paul.  We need to also set the EndTimeZone, otherwise we get "EndDate is earlier than StartDate" on some systems. 
					// 04/09/2018 Paul.  The property EndTimeZone is valid only for Exchange 2010 or later versions. 
					// 05/09/2018 Paul.  We still return dates as UTC, so still compare that way, but set using local time. 
					// 12/06/2020 Paul.  ToDateTimeTimeZone() should set the TimeZone property. 
					//if ( appointment.Service.RequestedServerVersion != ExchangeVersion.Exchange2007_SP1 )
					//	appointment.EndTimeZone = TimeZoneInfo.Local;
					dtDATE_END   = Sql.ToDateTime(row["DATE_END"   ]);
					if ( dtDATE_END < dtDATE_START )
					{
						dtDATE_END = dtDATE_START;
						dtDATE_END = dtDATE_END.AddHours  (Sql.ToInteger(row["DURATION_HOURS"  ]));
						dtDATE_END = dtDATE_END.AddMinutes(Sql.ToInteger(row["DURATION_MINUTES"]));
					}
					appointment.End = Spring.Social.Office365.Api.DateTimeTimeZone.ToDateTimeTimeZone(dtDATE_END, TimeZoneInfo.Local);
					bChanged = true;
					sbChanges.AppendLine("DATE_END"      + " changed. " + dtDATE_END.ToString());
				}
				// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  Exchange stores the reminder in minutes. 
				// 03/19/2013 Paul.  Make sure to use the IsReminderSet flag to prevent reminder when not set in CRM. 
				// http://msdn.microsoft.com/en-us/library/ms528181(v=exchg.10).aspx
				if ( appointment.ReminderMinutesBeforeStart != Sql.ToInteger(row["REMINDER_TIME"]) / 60 )
				{
					// 03/19/2013 Paul.  You should not attempt to access ReminderMinutesBeforeStart without first verifying that ReminderSet is True. If ReminderSet is False, reading or writing ReminderMinutesBeforeStart returns CdoE_NOT_FOUND. 
					appointment.IsReminderOn = (Sql.ToDateTime(row["DATE_START"]) >= DateTime.Now) && (Sql.ToInteger(row["REMINDER_TIME"]) > 0);
					if ( appointment.IsReminderOn.HasValue && appointment.IsReminderOn.Value )
						appointment.ReminderMinutesBeforeStart = Sql.ToInteger(row["REMINDER_TIME"]) / 60;
					bChanged = true;
					sbChanges.AppendLine("REMINDER_TIME" + " changed.");
				}
				// 03/23/2013 Paul.  Add recurrence data. 
				string sREPEAT_TYPE = Sql.ToString(row["REPEAT_TYPE"]);
				if ( !Sql.IsEmptyString(sREPEAT_TYPE) )
				{
					int      nREPEAT_COUNT    = Sql.ToInteger (row["REPEAT_COUNT"   ]);
					int      nREPEAT_INTERVAL = Sql.ToInteger (row["REPEAT_INTERVAL"]);
					DateTime dtREPEAT_UNTIL   = Sql.ToDateTime(row["REPEAT_UNTIL"   ]);
					// http://msdn.microsoft.com/en-us/library/exchange/dd633694(v=exchg.80).aspx
					switch ( sREPEAT_TYPE )
					{
						case "Daily":
							if ( appointment.Recurrence == null || appointment.Recurrence.Pattern == null || appointment.Recurrence.Range == null || appointment.Recurrence.Pattern.Type != "daily" )
							{
								//appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern(appointment.Start, nREPEAT_INTERVAL);
								appointment.Recurrence = new Spring.Social.Office365.Api.PatternedRecurrence();
								appointment.Recurrence.Pattern          = new Spring.Social.Office365.Api.RecurrencePattern();
								appointment.Recurrence.Pattern.Type     = "daily";
								appointment.Recurrence.Pattern.Interval = nREPEAT_INTERVAL;
								appointment.Recurrence.Range            = new Spring.Social.Office365.Api.RecurrenceRange();
								appointment.Recurrence.Range.StartDate  = appointment.Start.ToDateTime();
								appointment.Recurrence.Range.Type       = "noEnd";
								if ( dtREPEAT_UNTIL != DateTime.MinValue )
								{
									appointment.Recurrence.Range.Type    = "endDate";
									appointment.Recurrence.Range.EndDate = dtREPEAT_UNTIL;
								}
								else
								{
									appointment.Recurrence.Range.EndDate = null;
								}
								if ( nREPEAT_COUNT > 0 )
								{
									appointment.Recurrence.Range.Type                = "numbered";
									appointment.Recurrence.Range.NumberOfOccurrences = nREPEAT_COUNT;
								}
								else
								{
									appointment.Recurrence.Range.NumberOfOccurrences = null;
								}
								bChanged = true;
								sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
							}
							else if ( appointment.Recurrence.Pattern.Type == "daily" )
							{
								if ( appointment.Recurrence.Range.StartDate != appointment.Start.ToDateTime() )
								{
									appointment.Recurrence.Range.StartDate = appointment.Start.ToDateTime();
									bChanged = true;
								}
								if ( appointment.Recurrence.Pattern.Interval != nREPEAT_INTERVAL )
								{
									appointment.Recurrence.Pattern.Interval = nREPEAT_INTERVAL;
									bChanged = true;
									sbChanges.AppendLine("REPEAT_INTERVAL" + " changed.");
								}
							}
							break;
						case "Weekly":
							string sREPEAT_DOW = Sql.ToString(row["REPEAT_DOW"]);
							if ( !Sql.IsEmptyString(sREPEAT_DOW) )
							{
								List<String> days = new List<String>();
								for ( int n = 0; n < sREPEAT_DOW.Length; n++ )
								{
									//days[n] = (DayOfTheWeek) Sql.ToInteger(sREPEAT_DOW.Substring(n, 1));
									switch ( sREPEAT_DOW.Substring(n, 1) )
									{
										case "0":  days.Add("sunday"   );  break;
										case "1":  days.Add("monday"   );  break;
										case "2":  days.Add("tuesday"  );  break;
										case "3":  days.Add("wednesday");  break;
										case "4":  days.Add("thursday" );  break;
										case "5":  days.Add("friday"   );  break;
										case "6":  days.Add("saturday" );  break;
									}
								}
								if ( days.Count > 0 )
								{
									if ( appointment.Recurrence == null || appointment.Recurrence.Pattern == null || appointment.Recurrence.Range == null || appointment.Recurrence.Pattern.Type != "weekly" )
									{
										appointment.Recurrence = new Spring.Social.Office365.Api.PatternedRecurrence();
										appointment.Recurrence.Pattern                = new Spring.Social.Office365.Api.RecurrencePattern();
										appointment.Recurrence.Pattern.Type           = "weekly";
										appointment.Recurrence.Pattern.Interval       = nREPEAT_INTERVAL;
										appointment.Recurrence.Pattern.DaysOfWeek     = days;
										appointment.Recurrence.Pattern.FirstDayOfWeek = days[0];
										appointment.Recurrence.Range                  = new Spring.Social.Office365.Api.RecurrenceRange();
										appointment.Recurrence.Range.Type             = "noEnd";
										if ( dtREPEAT_UNTIL != DateTime.MinValue )
										{
											appointment.Recurrence.Range.Type    = "endDate";
											appointment.Recurrence.Range.EndDate = dtREPEAT_UNTIL;
										}
										else
										{
											appointment.Recurrence.Range.EndDate = null;
										}
										if ( nREPEAT_COUNT > 0 )
										{
											appointment.Recurrence.Range.Type                = "numbered";
											appointment.Recurrence.Range.NumberOfOccurrences = nREPEAT_COUNT;
										}
										else
										{
											appointment.Recurrence.Range.NumberOfOccurrences = null;
										}
										bChanged = true;
										sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
									}
									else if ( appointment.Recurrence.Pattern.Type == "weekly" )
									{
										if ( appointment.Recurrence.Range.StartDate != appointment.Start.ToDateTime() )
										{
											appointment.Recurrence.Range.StartDate = appointment.Start.ToDateTime();
											bChanged = true;
										}
										if ( appointment.Recurrence.Pattern.Interval != nREPEAT_INTERVAL )
										{
											appointment.Recurrence.Pattern.Interval = nREPEAT_INTERVAL;
											bChanged = true;
											sbChanges.AppendLine("REPEAT_INTERVAL" + " changed.");
										}
										string sEXCHANGE_DOW = String.Empty;
										if ( appointment.Recurrence.Pattern.DaysOfWeek != null )
										{
											foreach ( string sDay in appointment.Recurrence.Pattern.DaysOfWeek )
											{
												switch ( sDay )
												{
													case "sunday"   :  sEXCHANGE_DOW += "0";  break;
													case "monday"   :  sEXCHANGE_DOW += "1";  break;
													case "tuesday"  :  sEXCHANGE_DOW += "2";  break;
													case "wednesday":  sEXCHANGE_DOW += "3";  break;
													case "thursday" :  sEXCHANGE_DOW += "4";  break;
													case "friday"   :  sEXCHANGE_DOW += "5";  break;
													case "saturday" :  sEXCHANGE_DOW += "6";  break;
												}
											}
										}
										if ( sEXCHANGE_DOW != sREPEAT_DOW )
										{
											appointment.Recurrence.Pattern.DaysOfWeek     = days;
											appointment.Recurrence.Pattern.FirstDayOfWeek = days[0];
											bChanged = true;
											sbChanges.AppendLine("REPEAT_DOW" + " changed.");
										}
									}
								}
							}
							break;
						case "Monthly":
							if ( appointment.Recurrence == null || appointment.Recurrence.Pattern == null || appointment.Recurrence.Range == null || appointment.Recurrence.Pattern.Type != "absoluteMonthly" )
							{
								appointment.Recurrence = new Spring.Social.Office365.Api.PatternedRecurrence();
								appointment.Recurrence.Pattern            = new Spring.Social.Office365.Api.RecurrencePattern();
								appointment.Recurrence.Pattern.Type       = "monthly";
								appointment.Recurrence.Pattern.Interval   = nREPEAT_INTERVAL;
								appointment.Recurrence.Pattern.DayOfMonth = appointment.Start.ToDateTime().Day;
								appointment.Recurrence.Range              = new Spring.Social.Office365.Api.RecurrenceRange();
								appointment.Recurrence.Range.StartDate    = appointment.Start.ToDateTime();
								appointment.Recurrence.Range.Type         = "noEnd";
								if ( dtREPEAT_UNTIL != DateTime.MinValue )
								{
									appointment.Recurrence.Range.Type    = "endDate";
									appointment.Recurrence.Range.EndDate = dtREPEAT_UNTIL;
								}
								else
								{
									appointment.Recurrence.Range.EndDate = null;
								}
								if ( nREPEAT_COUNT > 0 )
								{
									appointment.Recurrence.Range.Type                = "numbered";
									appointment.Recurrence.Range.NumberOfOccurrences = nREPEAT_COUNT;
								}
								else
								{
									appointment.Recurrence.Range.NumberOfOccurrences = null;
								}
								bChanged = true;
								sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
							}
							else if ( appointment.Recurrence.Pattern.Type == "absoluteMonthly" )
							{
								if ( appointment.Recurrence.Range.StartDate != appointment.Start.ToDateTime() )
								{
									appointment.Recurrence.Range.StartDate = appointment.Start.ToDateTime();
									bChanged = true;
								}
								if ( appointment.Recurrence.Pattern.Interval != nREPEAT_INTERVAL )
								{
									appointment.Recurrence.Pattern.Interval = nREPEAT_INTERVAL;
									bChanged = true;
									sbChanges.AppendLine("REPEAT_INTERVAL" + " changed.");
								}
								if ( appointment.Recurrence.Pattern.DayOfMonth != appointment.Start.ToDateTime().Day )
								{
									appointment.Recurrence.Pattern.DayOfMonth = appointment.Start.ToDateTime().Day;
									bChanged = true;
								}
							}
							break;
						case "Yearly":
							if ( appointment.Recurrence == null || appointment.Recurrence.Pattern == null || appointment.Recurrence.Range == null || appointment.Recurrence.Pattern.Type != "absoluteYearly" )
							{
								appointment.Recurrence = new Spring.Social.Office365.Api.PatternedRecurrence();
								appointment.Recurrence.Pattern            = new Spring.Social.Office365.Api.RecurrencePattern();
								appointment.Recurrence.Pattern.Type       = "absoluteYearly";
								appointment.Recurrence.Pattern.Interval   = nREPEAT_INTERVAL;
								appointment.Recurrence.Pattern.DayOfMonth = appointment.Start.ToDateTime().Day;
								appointment.Recurrence.Pattern.Month      = appointment.Start.ToDateTime().Month;
								appointment.Recurrence.Range              = new Spring.Social.Office365.Api.RecurrenceRange();
								appointment.Recurrence.Range.StartDate    = appointment.Start.ToDateTime();
								appointment.Recurrence.Range.Type         = "noEnd";
								if ( dtREPEAT_UNTIL != DateTime.MinValue )
								{
									appointment.Recurrence.Range.Type    = "endDate";
									appointment.Recurrence.Range.EndDate = dtREPEAT_UNTIL;
								}
								else
								{
									appointment.Recurrence.Range.EndDate = null;
								}
								if ( nREPEAT_COUNT > 0 )
								{
									appointment.Recurrence.Range.Type                = "numbered";
									appointment.Recurrence.Range.NumberOfOccurrences = nREPEAT_COUNT;
								}
								else
								{
									appointment.Recurrence.Range.NumberOfOccurrences = null;
								}
								bChanged = true;
								sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
							}
							else if ( appointment.Recurrence.Pattern.Type == "absoluteYearly" )
							{
								if ( appointment.Recurrence.Range.StartDate != appointment.Start.ToDateTime() )
								{
									appointment.Recurrence.Range.StartDate = appointment.Start.ToDateTime();
									bChanged = true;
								}
								if ( appointment.Recurrence.Pattern.Month != appointment.Start.ToDateTime().Month )
								{
									appointment.Recurrence.Pattern.Month = appointment.Start.ToDateTime().Month;
									bChanged = true;
								}
								if ( appointment.Recurrence.Pattern.DayOfMonth != appointment.Start.ToDateTime().Day )
								{
									appointment.Recurrence.Pattern.DayOfMonth = appointment.Start.ToDateTime().Day;
									bChanged = true;
								}
							}
							break;
					}
					// 06/22/2018 Paul.  The Recurrence property might not be loaded. 
					try
					{
						if ( appointment.Recurrence != null )
						{
							// 03/27/2013 Paul.  Set EndDate first as it will reset NumberOfOccurrences. 
							// http://msdn.microsoft.com/en-us/library/exchange/dd633684(v=exchg.80).aspx
							DateTime dtEndDate = DateTime.MinValue;
							if ( appointment.Recurrence.Range != null && appointment.Recurrence.Range.EndDate.HasValue )
								dtEndDate = appointment.Recurrence.Range.EndDate.Value;
							if ( dtEndDate != dtREPEAT_UNTIL )
							{
								try
								{
									if ( appointment.Recurrence.Range == null )
									{
										appointment.Recurrence.Range = new Api.RecurrenceRange();
									}
									if ( dtREPEAT_UNTIL != DateTime.MinValue )
										appointment.Recurrence.Range.EndDate = dtREPEAT_UNTIL;
									else
										appointment.Recurrence.Range.EndDate = null;
									bChanged = true;
									sbChanges.AppendLine("REPEAT_UNTIL" + " changed.");
								}
								catch
								{
								}
							}
							int nNumberOfOccurrences = 0;
							if ( appointment.Recurrence.Range != null && appointment.Recurrence.Range.NumberOfOccurrences.HasValue )
								nNumberOfOccurrences = appointment.Recurrence.Range.NumberOfOccurrences.Value;
							if ( nNumberOfOccurrences != nREPEAT_COUNT )
							{
								try
								{
									if ( appointment.Recurrence.Range == null )
									{
										appointment.Recurrence.Range = new Api.RecurrenceRange();
									}
									if ( nREPEAT_COUNT > 0 )
										appointment.Recurrence.Range.NumberOfOccurrences = nREPEAT_COUNT;
									else
										appointment.Recurrence.Range.NumberOfOccurrences = null;
									bChanged = true;
									sbChanges.AppendLine("REPEAT_COUNT" + " changed.");
								}
								catch
								{
								}
							}
						}
					}
					catch
					{
					}
				}
				else
				{
					// 06/22/2018 Paul.  The Recurrence property might not be loaded. 
					try
					{
						if ( appointment.Recurrence != null )
						{
							appointment.Recurrence = null;
							bChanged = true;
							sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
						}
					}
					catch
					{
					}
				}

				// 01/15/2012 Paul.  We need to check for added or removed participants. 
				// 07/26/2012 James.  Add the ability to disable participants. 
				if ( !bDISABLE_PARTICIPANTS )
				{
					if ( dtAppointmentEmails.Rows.Count > 0 )
					{
						bool bParticipantsChanged = false;
						foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
						{
							bool bEmailFound = false;
							string sEMAIL1 = Sql.ToString(rowEmail["EMAIL1"]);
							foreach ( Spring.Social.Office365.Api.Attendee guest in appointment.Attendees )
							{
								if ( guest.EmailAddress != null && sEMAIL1 == guest.EmailAddress.Address )
								{
									bEmailFound = true;
									bool bREQUIRED = (guest.Type == "required");
									if ( bREQUIRED != Sql.ToBoolean(rowEmail["REQUIRED"]) )
									{
										bParticipantsChanged = true;
										break;
									}
									break;
								}
							}
							if ( !bEmailFound )
							{
								bParticipantsChanged = true;
								break;
							}
						}
						foreach ( Spring.Social.Office365.Api.Attendee guest in appointment.Attendees )
						{
							bool bEmailFound = false;
							foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
							{
								string sEMAIL1 = Sql.ToString(rowEmail["EMAIL1"]);
								if ( guest.EmailAddress != null && sEMAIL1 == guest.EmailAddress.Address )
								{
									bEmailFound = true;
									break;
								}
							}
							if ( !bEmailFound )
							{
								bParticipantsChanged = true;
								break;
							}
						}
						if ( bParticipantsChanged )
						{
							if ( appointment.Attendees == null )
								appointment.Attendees = new List<Spring.Social.Office365.Api.Attendee>();
							else
								appointment.Attendees.Clear();
							foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
							{
								string sNAME     = Sql.ToString (rowEmail["NAME"    ]);
								string sEMAIL1   = Sql.ToString (rowEmail["EMAIL1"  ]);
								bool   bREQUIRED = Sql.ToBoolean(rowEmail["REQUIRED"]);
								Spring.Social.Office365.Api.Attendee guest = new Spring.Social.Office365.Api.Attendee(sNAME, sEMAIL1);
								guest.Type = (bREQUIRED ? "required" : "optional");
								appointment.Attendees.Add(guest);
							}
							sbChanges.AppendLine("PARTICIPANTS" + " changed.");
						}
					}
					else
					{
						if ( appointment.Attendees != null && appointment.Attendees.Count > 0 )
						{
							appointment.Attendees.Clear();
							sbChanges.AppendLine("PARTICIPANTS" + " changed.");
						}
					}
				}
			}
			return bChanged;
		}

		public void SyncAppointments(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			// 07/26/2012 James.  Add the ability to disable participants. 
			bool bDISABLE_PARTICIPANTS = Sql.ToBoolean(Application["CONFIG.Exchange.DisableParticipants"]);
			bool bVERBOSE_STATUS       = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"      ]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + sEXCHANGE_ALIAS + " to " + gUSER_ID.ToString());
			// 02/20/2013 Paul.  Reduced the number of days to go back. 
			int  nAPPOINTMENT_AGE_DAYS = Sql.ToInteger(Application["CONFIG.Exchange.AppointmentAgeDays" ]);
			if ( nAPPOINTMENT_AGE_DAYS == 0 )
				nAPPOINTMENT_AGE_DAYS = 7;
			
			string sCONFLICT_RESOLUTION = Sql.ToString(Application["CONFIG.Exchange.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
			//string sCRM_FOLDER_NAME     = Sql.ToString(Application["CONFIG.Exchange.CrmFolderName"     ]);
			//if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
			//	sCRM_FOLDER_NAME = "SplendidCRM";
			// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
			string sCALENDAR_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Calendar.Category"]);
			
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				
				try
				{
					string sSQL = String.Empty;
					// 04/05/2010 Paul.  When the Watermark is empty, no events will be created for existing items.  In that case, poll the folder 
					// 04/16/2018 Paul.  This condition makes no sense as it prevents normal processing of items unless SyncAll has been pressed on the admin page. 
					//if ( bSyncAll )
					{
						DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.MinValue;
						if ( !bSyncAll )
						{
							// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
							// 06/26/2018 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. 
							sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
							     + "  from vwAPPOINTMENTS_SYNC                           " + ControlChars.CrLf
							     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf;
							//     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								//Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
								dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.SpecifyKind(Sql.ToDateTime(cmd.ExecuteScalar()), DateTimeKind.Utc);
							}
						}
						// 03/29/2010 Paul.  We do not want to sync with old appointments, so place a 3-month limit. 
						// 02/20/2013 Paul.  Reduced the number of days to go back. 
						if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC == DateTime.MinValue )
							dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.UtcNow.AddDays(-nAPPOINTMENT_AGE_DAYS);
						
						// 07/07/2015 Paul.  Allow the page size to be customized. 
						int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Appointments.PageSize"]);
						IList<Spring.Social.Office365.Api.Event> items = service.EventOperations.GetModified(sCALENDAR_CATEGORY, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC, nPageSize);
						if ( items.Count > 0 )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + items.Count.ToString() + " appointments to retrieve from " + sEXCHANGE_ALIAS);
						foreach ( Spring.Social.Office365.Api.Event appointment in items )
						{
							this.ImportAppointment(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, appointment, sbErrors);
						}
					}
					
					// 03/26/2010 Paul.  Join to vwAPPOINTMENTS_USERS so that we only get appointments that are marked as Sync. 
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					// 06/22/2018 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. 
					sSQL = "select vwAPPOINTMENTS.*                                                                   " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_ID                                                        " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_REMOTE_KEY                                                " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                   " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                  " + ControlChars.CrLf
					     + "  from            vwAPPOINTMENTS                                                          " + ControlChars.CrLf
					     + "       inner join vwAPPOINTMENTS_USERS                                                    " + ControlChars.CrLf
					     + "               on vwAPPOINTMENTS_USERS.APPOINTMENT_ID       = vwAPPOINTMENTS.ID           " + ControlChars.CrLf
					     + "              and vwAPPOINTMENTS_USERS.USER_ID              = @SYNC_USER_ID               " + ControlChars.CrLf
					     + "  left outer join vwAPPOINTMENTS_SYNC                                                     " + ControlChars.CrLf
					     + "               on vwAPPOINTMENTS_SYNC.SYNC_SERVICE_NAME     = N'Exchange'                 " + ControlChars.CrLf
					     + "              and vwAPPOINTMENTS_SYNC.SYNC_LOCAL_ID         = vwAPPOINTMENTS.ID           " + ControlChars.CrLf
					//     + "              and vwAPPOINTMENTS_SYNC.SYNC_ASSIGNED_USER_ID = vwAPPOINTMENTS_USERS.USER_ID" + ControlChars.CrLf
					;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 05/02/2018 Paul.  This could be very slow, so give it a few minutes. 
						cmd.CommandTimeout = 5 * 60;
						Sql.AddParameter(cmd, "@SYNC_USER_ID", gUSER_ID);
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Appointments", "view");
						
						// 03/28/2010 Paul.  All that is important is that the current date is greater than the last sync date. 
						// 03/29/2010 Paul.  We do not want to sync with old appointments, so place a 3-month limit. 
						// 05/09/2018 Paul.  System updates can modify the UTC date, so make sure that age is outside that filter. 
						cmd.CommandText += "   and (vwAPPOINTMENTS_SYNC.ID is null or vwAPPOINTMENTS.DATE_MODIFIED_UTC > vwAPPOINTMENTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC)" + ControlChars.CrLf;
						cmd.CommandText += "   and vwAPPOINTMENTS.DATE_MODIFIED > @DATE_MODIFIED" + ControlChars.CrLf;
						// 02/20/2013 Paul.  Reduced the number of days to go back. 
						Sql.AddParameter(cmd, "@DATE_MODIFIED", DateTime.Now.AddDays(-nAPPOINTMENT_AGE_DAYS));
						cmd.CommandText += " order by vwAPPOINTMENTS.DATE_MODIFIED_UTC" + ControlChars.CrLf;
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + dt.Rows.Count.ToString() + " appointments to send to " + sEXCHANGE_ALIAS);
								foreach ( DataRow row in dt.Rows )
								{
									Guid     gID                             = Sql.ToGuid    (row["ID"                           ]);
									Guid     gASSIGNED_USER_ID               = Sql.ToGuid    (row["ASSIGNED_USER_ID"             ]);
									Guid     gSYNC_ID                        = Sql.ToGuid    (row["SYNC_ID"                      ]);
									string   sSYNC_REMOTE_KEY                = Sql.ToString  (row["SYNC_REMOTE_KEY"              ]);
									DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
									DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
									DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
									string   sSYNC_ACTION                    = Sql.IsEmptyGuid(gSYNC_ID) ? "local new" : "local changed";
									if ( SplendidInit.bEnableACLFieldSecurity )
									{
										bool bApplyACL = false;
										foreach ( DataColumn col in dt.Columns )
										{
											Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Appointments", col.ColumnName, gASSIGNED_USER_ID);
											if ( !acl.IsReadable() )
											{
												row[col.ColumnName] = DBNull.Value;
												bApplyACL = true;
											}
										}
										if ( bApplyACL )
											dt.AcceptChanges();
									}
									StringBuilder sbChanges = new StringBuilder();
									try
									{
										Spring.Social.Office365.Api.Event appointment = null;
										if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Sending new appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS);
											appointment = new Spring.Social.Office365.Api.Event();
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											DataTable dtAppointmentEmails = AppointmentEmails(con, Sql.ToGuid(row["ID"]));
											// 07/26/2012 James.  Add the ability to disable participants. 
											// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
											// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
											this.SetExchangeAppointment(appointment, row, dtAppointmentEmails, sbChanges, bDISABLE_PARTICIPANTS, sCALENDAR_CATEGORY);
											// 03/17/2013 Paul.  We don't want Exchange sending meeting notices.  The CRM will do that if instructed by the user. 
											// 09/17/2017 Paul.  Provide a way to turn on Exchange notices for appointments. 
											bool bAPPOINTMENT_SENDTOALL = Sql.ToBoolean(Application["CONFIG.Exchange.AppointmentSendToAll"]);
											appointment.ResponseRequested = bAPPOINTMENT_SENDTOALL;
											appointment = service.EventOperations.Insert(appointment);
											sSYNC_REMOTE_KEY = appointment.Id;
										}
										else
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Binding appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS);
											
											// 03/28/2010 Paul.  Instead of binding, use FindItems as the appointment may have been deleted in Exchange. 
											// 03/28/2010 Paul.  FindItems is generating an exception: The specified value is invalid for property. 
											//ItemView ivAppointments = new ItemView(1, 0);
											//filter = new SearchFilter.IsEqualTo(AppointmentSchema.Id, sSYNC_REMOTE_KEY);
											//results = service.FindItems(WellKnownFolderName.Appointments, filter, ivAppointments);
											//if ( results.Items.Count > 0 )
											try
											{
												//appointment = results.Items[0] as Appointment;
												appointment = service.EventOperations.GetById(sSYNC_REMOTE_KEY);
												// 03/28/2010 Paul.  We need to double-check for conflicts. 
												DateTime dtREMOTE_DATE_MODIFIED_UTC = (appointment.LastModifiedDateTime.HasValue ? appointment.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
												// 01/12/2021 Paul.  A deleted message will only return the "@removed" property. 
												if ( appointment.Deleted )
												{
													sSYNC_ACTION = "remote deleted";
												}
												else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
												{
													if ( sCONFLICT_RESOLUTION == "remote" )
													{
														// 03/24/2010 Paul.  Remote is the winner of conflicts. 
														sSYNC_ACTION = "remote changed";
													}
													else if ( sCONFLICT_RESOLUTION == "local" )
													{
														// 03/24/2010 Paul.  Local is the winner of conflicts. 
														sSYNC_ACTION = "local changed";
													}
														// 12/25/2020 Paul.  Remvoe the 1 hour window as it is preventing a sync. 
													else if ( dtREMOTE_DATE_MODIFIED_UTC > dtDATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "remote changed";
													}
													// 12/25/2020 Paul.  Remvoe the 1 hour window as it is preventing a sync. 
													else if ( dtDATE_MODIFIED_UTC > dtREMOTE_DATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "local changed";
													}
													else
													{
														sSYNC_ACTION = "prompt change";
													}
												}
												// 03/29/2010 Paul.  If we find the appointment, but the Categories no longer contains SplendidCRM, 
												// then the user must have stopped the syncing. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												if ( !Sql.IsEmptyString(sCALENDAR_CATEGORY) && appointment.Categories != null && !appointment.Categories.Contains(sCALENDAR_CATEGORY) )
												{
													sSYNC_ACTION = "remote deleted";
												}
											}
											catch(Exception ex)
											{
												string sError = "Error retrieving Exchange appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
												sError += Utils.ExpandException(ex) + ControlChars.CrLf;
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
												sbErrors.AppendLine(sError);
												sSYNC_ACTION = "remote deleted";
											}
											if ( sSYNC_ACTION == "local changed" )
											{
												// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
												// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
												DataTable dtAppointmentEmails = AppointmentEmails(con, Sql.ToGuid(row["ID"]));
												// 07/26/2012 James.  Add the ability to disable participants. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												bool bChanged = this.SetExchangeAppointment(appointment, row, dtAppointmentEmails, sbChanges, bDISABLE_PARTICIPANTS, sCALENDAR_CATEGORY);
												if ( bChanged )
												{
													if ( bVERBOSE_STATUS )
														SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Sending appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS);
													// 03/17/2013 Paul.  We don't want Exchange sending meeting notices.  The CRM will do that if instructed by the user. 
													appointment.ResponseRequested = false;
													appointment = service.EventOperations.Update(appointment);
												}
											}
										}
										if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
										{
											if ( appointment != null )
											{
												// 03/25/2010 Paul.  Update the modified date after the save. 
												// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
												DateTime dtREMOTE_DATE_MODIFIED_UTC = (appointment.LastModifiedDateTime.HasValue ? appointment.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
												DateTime dtREMOTE_DATE_MODIFIED     = (appointment.LastModifiedDateTime.HasValue ? TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local) : DateTime.MinValue);
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														// 03/26/2010 Paul.  Make sure to set the Sync flag. 
														// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
														// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
														SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sSYNC_REMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
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
										else if ( sSYNC_ACTION == "remote deleted" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Unsyncing appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " for " + sEXCHANGE_ALIAS);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gID, sSYNC_REMOTE_KEY, "Exchange", trn);
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
									catch(Exception ex)
									{
										// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
										string sError = "Error creating Exchange appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
										sError += sbChanges.ToString();
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
									}
								}
							}
						}
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					sbErrors.AppendLine(Utils.ExpandException(ex));
				}
			}
		}

		/*
		// 12/25/2020 Paul.  Instead of cleaning body, use Prefer: outlook.body-content-type request header. 
		public string CleanItemBody(Api.ItemBody itemBody)
		{
			string sBody = String.Empty;
			if ( itemBody != null && !Sql.IsEmptyString(itemBody.Content) )
			{
				sBody = itemBody.Content;
				if ( itemBody.ContentType == "html" )
				{
					sBody = sBody.Replace("<html>", String.Empty);
					sBody = sBody.Replace("</html>", String.Empty);
					sBody = sBody.Replace("<head>", String.Empty);
					sBody = sBody.Replace("</head>", String.Empty);
					sBody = sBody.Replace("<body>", String.Empty);
					sBody = sBody.Replace("</body>", String.Empty);
					sBody = sBody.Replace("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">", String.Empty);
					sBody = sBody.Replace("<meta content=\"text/html; charset=us-ascii\">", String.Empty);
					sBody = sBody.Trim();
				}
			}
			return sBody;
		}
		*/

		// 12/27/2011 Paul.  Move population logic to a static method. 
		// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
		public bool BuildAPPOINTMENTS_Update(ExchangeSession Session, IDbCommand spAPPOINTMENTS_Update, DataRow row, Spring.Social.Office365.Api.Event appointment, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID)
		{
			bool bChanged = false;
			// 03/25/2010 Paul.  We start with the existing record values so that we can apply ACL Field Security rules. 
			if ( row != null && row.Table != null )
			{
				foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					// 03/28/2010 Paul.  We must assign a value to all parameters. 
					string sParameterName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
					if ( row.Table.Columns.Contains(sParameterName) )
						par.Value = row[sParameterName];
					else
						par.Value = DBNull.Value;
				}
			}
			else
			{
				bChanged = true;
				foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					string sParameterName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
					if ( sParameterName == "TEAM_ID" )
						par.Value = gTEAM_ID;
					else if ( sParameterName == "ASSIGNED_USER_ID" )
						par.Value = gUSER_ID;
					// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
					else if ( sParameterName == "MODIFIED_USER_ID" )
						par.Value = gUSER_ID;
					else
						par.Value = DBNull.Value;
				}
			}
			TimeSpan tsDURATION = (appointment.End.ToDateTime() - appointment.Start.ToDateTime());
			foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Appointments", sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							// 01/14/2021 Paul.  Trim the body as the Outlook web site defaults to a new line. 
							case "DESCRIPTION"               :  oValue = Sql.ToDBString  (appointment.Body     != null ? Sql.ToString(appointment.Body.Content).Trim(): String.Empty);  break;
							case "NAME"                      :  oValue = Sql.ToDBString  (appointment.Subject            );  break;
							// 01/08/2021 Paul.  Get the display name of the location, not the object name. 
							case "LOCATION"                  :  oValue = Sql.ToDBString  (appointment.Location != null ? appointment.Location.DisplayName : String.Empty);  break;
							case "DATE_TIME"                 :  oValue = Sql.ToDBDateTime(appointment.Start.ToDateTime().ToLocalTime());  break;
							case "DURATION_HOURS"            :  oValue = tsDURATION.Hours                                 ;  break;
							case "DURATION_MINUTES"          :  oValue = tsDURATION.Minutes                               ;  break;
							// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  Exchange stores the reminder in minutes. 
							// 03/19/2013 Paul.  Use IsReminderSet from Exchange. 
							// http://msdn.microsoft.com/en-us/library/ms528181(v=exchg.10).aspx
							case "REMINDER_TIME"             :  oValue = (appointment.IsReminderOn.HasValue && appointment.IsReminderOn.Value && appointment.ReminderMinutesBeforeStart.HasValue ? appointment.ReminderMinutesBeforeStart.Value * 60 : 0);  break;
							case "MODIFIED_USER_ID"          :  oValue = gUSER_ID;  break;
							// 03/10/2013 Paul.  Add ALL_DAY_EVENT. 
							case "ALL_DAY_EVENT"             :  oValue = (appointment.IsAllDay.HasValue && appointment.IsAllDay.Value);  break;
							// 03/23/2013 Paul.  Add recurrence data. 
							case "REPEAT_TYPE"               :
								// 01/14/2021 Paul.  Default should be null and not empty string. 
								oValue = DBNull.Value;
								if ( appointment.Recurrence != null && appointment.Recurrence.Pattern != null )
								{
									if ( String.Compare(appointment.Recurrence.Pattern.Type, "Daily", true) == 0 )
										oValue = "Daily";
									else if ( String.Compare(appointment.Recurrence.Pattern.Type, "Weekly", true) == 0 )
										oValue = "Weekly";
									else if ( String.Compare(appointment.Recurrence.Pattern.Type, "absoluteMonthly", true) == 0 )
										oValue = "Monthly";
									else if ( String.Compare(appointment.Recurrence.Pattern.Type, "absoluteYearly", true) == 0 )
										oValue = "Yearly";
								}
								break;
							case "REPEAT_INTERVAL"           :
								oValue = 0;
								if ( appointment.Recurrence != null && appointment.Recurrence.Pattern != null && appointment.Recurrence.Pattern.Interval.HasValue )
								{
									oValue = appointment.Recurrence.Pattern.Interval.Value;
								}
								break;
							case "REPEAT_DOW"                :
								// 01/14/2021 Paul.  Default should be null and not empty string. 
								oValue = DBNull.Value;
								if ( appointment.Recurrence != null && appointment.Recurrence.Pattern != null )
								{
									if ( String.Compare(appointment.Recurrence.Pattern.Type, "Weekly", true) == 0 && appointment.Recurrence.Pattern.DaysOfWeek != null && appointment.Recurrence.Pattern.DaysOfWeek.Count > 0 )
									{
										string sEXCHANGE_DOW = String.Empty;
										for ( int n = 0; n < appointment.Recurrence.Pattern.DaysOfWeek.Count; n++ )
										{
											int nDay = 0;
											switch ( appointment.Recurrence.Pattern.DaysOfWeek[n] )
											{
												case "sunday"   :  nDay = 0;  break;
												case "monday"   :  nDay = 1;  break;
												case "tuesday"  :  nDay = 2;  break;
												case "wednesday":  nDay = 3;  break;
												case "thursday" :  nDay = 4;  break;
												case "friday"   :  nDay = 5;  break;
												case "saturday" :  nDay = 6;  break;
											}
											sEXCHANGE_DOW += nDay.ToString();
										}
										oValue = sEXCHANGE_DOW;
									}
								}
								break;
							case "REPEAT_UNTIL"              :
								oValue = DBNull.Value;
								if ( appointment.Recurrence != null && appointment.Recurrence.Range != null )
								{
									if ( appointment.Recurrence.Range.EndDate.HasValue )
										oValue = appointment.Recurrence.Range.EndDate.Value;
								}
								break;
							case "REPEAT_COUNT"              :
								oValue = 0;
								if ( appointment.Recurrence != null && appointment.Recurrence.Range != null )
								{
									if ( appointment.Recurrence.Range.NumberOfOccurrences.HasValue )
										oValue = appointment.Recurrence.Range.NumberOfOccurrences.Value;
								}
								break;
						}
						// 02/28/2012 Paul.  Only set the parameter value if the value is being set. 
						if ( oValue != null )
						{
							if ( !bChanged )
							{
								switch ( par.DbType )
								{
									case DbType.Guid    :  if ( Sql.ToGuid    (par.Value) != Sql.ToGuid    (oValue) ) bChanged = true;  break;
									case DbType.Int16   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int32   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int64   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Double  :  if ( Sql.ToDouble  (par.Value) != Sql.ToDouble  (oValue) ) bChanged = true;  break;
									case DbType.Decimal :  if ( Sql.ToDecimal (par.Value) != Sql.ToDecimal (oValue) ) bChanged = true;  break;
									case DbType.Boolean :  if ( Sql.ToBoolean (par.Value) != Sql.ToBoolean (oValue) ) bChanged = true;  break;
									case DbType.DateTime:  if ( Sql.ToDateTime(par.Value) != Sql.ToDateTime(oValue) ) bChanged = true;  break;
									default             :  if ( Sql.ToString  (par.Value) != Sql.ToString  (oValue) ) bChanged = true;  break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
						// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}

		public void DeleteAppointment(Guid gUSER_ID, string sREMOTE_KEY)
		{
			string sEXCHANGE_ALIAS = String.Empty;;
			try
			{
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
				// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
				string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"     ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret" ]);
				bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365AccessToken token = this.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gUSER_ID, false);
				Spring.Social.Office365.Api.IOffice365 service = CreateApi(token.access_token);
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					String sSQL = String.Empty;
					sSQL = "select EXCHANGE_ALIAS              " + ControlChars.CrLf
					     + "  from vwEXCHANGE_USERS            " + ControlChars.CrLf
					     + " where ASSIGNED_USER_ID  = @USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
						sEXCHANGE_ALIAS = Sql.ToString(cmd.ExecuteScalar());
					}
					
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					// 06/22/2018 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. 
					sSQL = "select ID                                            " + ControlChars.CrLf
					     + "  from vwAPPOINTMENTS_SYNC                           " + ControlChars.CrLf
					     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
					//     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
					     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						//Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
						Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
						Guid gID = Sql.ToGuid(cmd.ExecuteScalar());
						if ( !Sql.IsEmptyGuid(gID) )
						{
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "DeleteAppointment: Unsyncing appointment for " + sEXCHANGE_ALIAS + " to " + gID.ToString());
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gID, sREMOTE_KEY, "Exchange", trn);
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
				}
			}
			catch(Exception ex)
			{
				string sError = "Office365Sync.DeleteAppointment: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
		}

		public void ImportAppointment(Guid gUSER_ID, string sREMOTE_KEY)
		{
			string sEXCHANGE_ALIAS = String.Empty;;
			try
			{
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
				// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
				string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365AccessToken token = this.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gUSER_ID, false);
				Spring.Social.Office365.Api.IOffice365 service = CreateApi(token.access_token);
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select EXCHANGE_ALIAS              " + ControlChars.CrLf
					     + "  from vwEXCHANGE_USERS            " + ControlChars.CrLf
					     + " where ASSIGNED_USER_ID  = @USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
						sEXCHANGE_ALIAS = Sql.ToString(cmd.ExecuteScalar());
					}
					bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
					if ( bVERBOSE_STATUS )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Office365Sync.ImportAppointment: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + ".");
					
					StringBuilder sbErrors = new StringBuilder();
					Spring.Social.Office365.Api.Event appointment = service.EventOperations.GetById(sREMOTE_KEY);
					this.ImportAppointment(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, appointment, sbErrors);
					if ( sbErrors.Length > 0 )
						throw(new Exception(sbErrors.ToString()));
				}
			}
			catch(Exception ex)
			{
				string sError = "Office365Sync.ImportAppointment: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
		}

		public void ImportAppointment(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, Spring.Social.Office365.Api.Event appointment, StringBuilder sbErrors)
		{
			// 07/26/2012 James.  Add the ability to disable participants. 
			bool   bDISABLE_PARTICIPANTS = Sql.ToBoolean(Application["CONFIG.Exchange.DisableParticipants"]);
			bool   bVERBOSE_STATUS       = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"      ]);
			string sCONFLICT_RESOLUTION  = Sql.ToString (Application["CONFIG.Exchange.ConflictResolution" ]);
			Guid   gTEAM_ID              = Sql.ToGuid   (Session["TEAM_ID"]);
			// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
			//string sCRM_FOLDER_NAME     = Sql.ToString  (Application["CONFIG.Exchange.CrmFolderName"      ]);
			//if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
			//	sCRM_FOLDER_NAME = "SplendidCRM";
			// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
			string sCALENDAR_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Calendar.Category"]);
			
			IDbCommand spAPPOINTMENTS_Update = SqlProcs.Factory(con, "spAPPOINTMENTS_Update");
			
			string   sREMOTE_KEY                = appointment.Id;
			// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
			DateTime dtREMOTE_DATE_MODIFIED_UTC = (appointment.LastModifiedDateTime.HasValue ? appointment.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
			DateTime dtREMOTE_DATE_MODIFIED     = (appointment.LastModifiedDateTime.HasValue ? TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local) : DateTime.MinValue);

			String sSQL = String.Empty;
			// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
			// 06/22/2018 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. 
			sSQL = "select SYNC_ID                                       " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_DATE_MODIFIED_UTC                  " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_DATE_MODIFIED_UTC                 " + ControlChars.CrLf
			     + "     , SYNC_APPOINTMENT                              " + ControlChars.CrLf
			     + "     , ID                                            " + ControlChars.CrLf
			     + "     , DATE_MODIFIED_UTC                             " + ControlChars.CrLf
			     + "  from vwAPPOINTMENTS_SYNC                           " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
			//     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
			     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf;
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				//Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
				Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					string sSYNC_ACTION   = String.Empty;
					Guid   gID            = Guid.Empty;
					Guid   gSYNC_LOCAL_ID = Guid.Empty;
					using ( DataTable dt = new DataTable() )
					{
						da.Fill(dt);
						if ( dt.Rows.Count > 0 )
						{
							DataRow row = dt.Rows[0];
							gID                                      = Sql.ToGuid    (row["ID"                           ]);
							gSYNC_LOCAL_ID                           = Sql.ToGuid    (row["SYNC_LOCAL_ID"                ]);
							DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
							DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
							DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
							bool     bSYNC_APPOINTMENT               = Sql.ToBoolean (row["SYNC_APPOINTMENT"             ]);
							// 03/24/2010 Paul.  Exchange Record has already been mapped for this user. 
							// 03/28/2010 Paul.  If the ID is NULL and the LOCAL_ID is NOT NULL, then the local item must have been deleted. 
							// 03/29/2010 Paul.  If ID and LOCAL_ID are valid, but SYNC_APPOINTMENT is not, then the user has stopped syncing the contact. 
							// 01/12/2021 Paul.  A deleted message will only return the "@removed" property. 
							if ( appointment.Deleted )
							{
								sSYNC_ACTION = "remote deleted";
							}
							else if ( (Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID)) || (!Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID) && !bSYNC_APPOINTMENT) )
							{
								sSYNC_ACTION = "local deleted";
							}
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								if ( sCONFLICT_RESOLUTION == "remote" )
								{
									// 03/24/2010 Paul.  Remote is the winner of conflicts. 
									sSYNC_ACTION = "remote changed";
								}
								else if ( sCONFLICT_RESOLUTION == "local" )
								{
									// 03/24/2010 Paul.  Local is the winner of conflicts. 
									sSYNC_ACTION = "local changed";
								}
								// 12/25/2020 Paul.  Remvoe the 1 hour window as it is preventing a sync. 
								else if ( dtREMOTE_DATE_MODIFIED_UTC > dtDATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "remote changed";
								}
								// 12/25/2020 Paul.  Remvoe the 1 hour window as it is preventing a sync. 
								else if ( dtDATE_MODIFIED_UTC > dtREMOTE_DATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "local changed";
								}
								else
								{
									sSYNC_ACTION = "prompt change";
								}
								
							}
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Remote Record has changed, but Local has not. 
								sSYNC_ACTION = "remote changed";
							}
							else if ( dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Local Record has changed, but Remote has not. 
								sSYNC_ACTION = "local changed";
							}
						}
						// 01/12/2021 Paul.  Don't treat as new if category not assigned. 
						else if ( appointment.Categories != null && appointment.Categories.Contains(sCALENDAR_CATEGORY) )
						{
							sSYNC_ACTION = "remote new";
							
							// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to Exchange. 
							// 03/28/2010 Paul.  We need to prevent duplicate Exchange entries from attaching to an existing mapped Appointment ID. 
							// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
							// 06/22/2018 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. 
							cmd.Parameters.Clear();
							sSQL = "select vwAPPOINTMENTS.ID             " + ControlChars.CrLf
							     + "  from            vwAPPOINTMENTS     " + ControlChars.CrLf
							     + "  left outer join vwAPPOINTMENTS_SYNC" + ControlChars.CrLf
							     + "               on vwAPPOINTMENTS_SYNC.SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
							//     + "              and vwAPPOINTMENTS_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_LOCAL_ID         = vwAPPOINTMENTS.ID     " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							// 12/25/2020 Paul.  Don't need @SYNC_ASSIGNED_USER_ID. 
							//Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Appointments", "view");
							
							Sql.AppendParameter(cmd, Sql.ToString(appointment.Subject), "NAME"      );
							Sql.AppendParameter(cmd, appointment.Start.ToDateTime().ToLocalTime()  , "DATE_START");
							cmd.CommandText += "   and vwAPPOINTMENTS_SYNC.ID is null" + ControlChars.CrLf;
							gID = Sql.ToGuid(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyGuid(gID) )
							{
								// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to Exchange. 
								sSYNC_ACTION = "local new";
							}
						}
						else
						{
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportAppointment: Ignoring uncategorized appointment " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToDateTime().ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS);
						}
					}
					using ( DataTable dt = new DataTable() )
					{
						DataRow row = null;
						Guid gASSIGNED_USER_ID = Guid.Empty;
						// 01/15/2012 Paul.  Add the user to the meeting. 
						string sAPPOINTMENT_TYPE = String.Empty;
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" || sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new" )
						{
							if ( !Sql.IsEmptyGuid(gID) )
							{
								cmd.Parameters.Clear();
								sSQL = "select *             " + ControlChars.CrLf
								     + "  from vwAPPOINTMENTS" + ControlChars.CrLf
								     + " where ID = @ID      " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
								{
									row = dt.Rows[0];
									sAPPOINTMENT_TYPE = Sql.ToString(row["APPOINTMENT_TYPE"]);
									gASSIGNED_USER_ID = Sql.ToGuid  (row["ASSIGNED_USER_ID"]);
								}
							}
						}
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" )
						{
							try
							{
								// 03/28/2010 Paul.  Reload the full appointment so that it will include the Body. 
								// 03/28/2010 Paul.  The binding can fail if the appointment does not define the FileAs field. 
								appointment = service.EventOperations.GetById(sREMOTE_KEY);
								// 11/18/2014 Paul.  Get body as plain text. 
								// 12/07/2020 Paul TODO.  Microsoft Graph does not seem to have a plain text property. 
								/*
								if ( Sql.ToBoolean(Application["CONFIG.Exchange.Appointment.PlainText"]) )
								{
									Microsoft.Exchange.WebServices.Data.PropertySet psPlainText = new Microsoft.Exchange.WebServices.Data.PropertySet(Microsoft.Exchange.WebServices.Data.BasePropertySet.FirstClassProperties, Microsoft.Exchange.WebServices.Data.AppointmentSchema.Body);
									psPlainText.RequestedBodyType = Microsoft.Exchange.WebServices.Data.BodyType.Text;
									// 11/18/2014 Paul.  We are not getting the full item here, so just grab the body. 
									try
									{
										Microsoft.Exchange.WebServices.Data.Appointment appointment1 = Microsoft.Exchange.WebServices.Data.Appointment.Bind(service, sREMOTE_KEY, psPlainText);
										appointment.Body.BodyType = appointment1.Body.BodyType;
										appointment.Body.Text     = appointment1.Body.Text    ;
										//SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sItemID + ControlChars.CrLf + "BodyText: " + appointment.Body.Text);
									}
									catch
									{
									}
								}
								*/
							}
							catch(Exception ex)
							{
								string sError = "Error retrieving " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToDateTime().ToLocalTime().ToString()) + " for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							// 01/15/2012 Paul.  We need to check for added or removed participants. 
							// 04/02/2012 Paul.  Add Calls/Leads relationship. 
							Dictionary<string, Guid> dictLeads       = new Dictionary<string,Guid>();
							Dictionary<string, Guid> dictContacts    = new Dictionary<string,Guid>();
							Dictionary<string, Guid> dictUsers       = new Dictionary<string,Guid>();
							List<string>             lstParticipants = new List<string>();
							DataTable dtUSERS = new DataTable();
							// 07/26/2012 James.  Add the ability to disable participants. 
							if ( !bDISABLE_PARTICIPANTS )
							{
								if ( appointment.Attendees != null )
								{
									foreach ( Spring.Social.Office365.Api.Attendee guest in appointment.Attendees )
									{
										lstParticipants.Add(guest.EmailAddress.Address.ToLower());
									}
								}
								
								cmd.Parameters.Clear();
								sSQL = "select APPOINTMENT_ID         " + ControlChars.CrLf
								     + "     , APPOINTMENT_TYPE       " + ControlChars.CrLf
								     + "     , CONTACT_ID             " + ControlChars.CrLf
								     + "     , CONTACT_NAME           " + ControlChars.CrLf
								     + "     , EMAIL1                 " + ControlChars.CrLf
								     + "  from vwAPPOINTMENTS_CONTACTS" + ControlChars.CrLf
								     + " where APPOINTMENT_ID = @ID   " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtCONTACTS = new DataTable() )
								{
									da.Fill(dtCONTACTS);
									foreach ( DataRow rowContact in dtCONTACTS.Rows )
									{
										Guid   gAPPOINTMENT_CONTACT_ID = Sql.ToGuid  (rowContact["CONTACT_ID"]);
										string sAPPOINTMENT_EMAIL1     = Sql.ToString(rowContact["EMAIL1"    ]).ToLower();
										if ( !Sql.IsEmptyString(sAPPOINTMENT_EMAIL1) && !dictContacts.ContainsKey(sAPPOINTMENT_EMAIL1) )
											dictContacts.Add(sAPPOINTMENT_EMAIL1, gAPPOINTMENT_CONTACT_ID);
									}
								}
								
								// 04/02/2012 Paul.  Add Calls/Leads relationship. 
								cmd.Parameters.Clear();
								sSQL = "select APPOINTMENT_ID         " + ControlChars.CrLf
								     + "     , APPOINTMENT_TYPE       " + ControlChars.CrLf
								     + "     , LEAD_ID                " + ControlChars.CrLf
								     + "     , LEAD_NAME              " + ControlChars.CrLf
								     + "     , EMAIL1                 " + ControlChars.CrLf
								     + "  from vwAPPOINTMENTS_LEADS   " + ControlChars.CrLf
								     + " where APPOINTMENT_ID = @ID   " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtLEADS = new DataTable() )
								{
									da.Fill(dtLEADS);
									foreach ( DataRow rowLead in dtLEADS.Rows )
									{
										Guid   gAPPOINTMENT_LEAD_ID = Sql.ToGuid  (rowLead["LEAD_ID"]);
										string sAPPOINTMENT_EMAIL1  = Sql.ToString(rowLead["EMAIL1" ]).ToLower();
										if ( !Sql.IsEmptyString(sAPPOINTMENT_EMAIL1) && !dictLeads.ContainsKey(sAPPOINTMENT_EMAIL1) )
											dictLeads.Add(sAPPOINTMENT_EMAIL1, gAPPOINTMENT_LEAD_ID);
									}
								}
								
								cmd.Parameters.Clear();
								// 02/20/2013 Paul.  Invalid column name 'USER_ID'.  Use ASSIGNED_USER_ID instead. 
								sSQL = "select vwAPPOINTMENTS_USERS.APPOINTMENT_ID      " + ControlChars.CrLf
								     + "     , vwAPPOINTMENTS_USERS.USER_ID             " + ControlChars.CrLf
								     + "     , vwEXCHANGE_USERS.EXCHANGE_ALIAS          " + ControlChars.CrLf
								     + "     , vwEXCHANGE_USERS.EXCHANGE_EMAIL          " + ControlChars.CrLf
								     + "  from      vwAPPOINTMENTS_USERS                " + ControlChars.CrLf
								     + " inner join vwEXCHANGE_USERS                    " + ControlChars.CrLf
								     + "         on vwEXCHANGE_USERS.ASSIGNED_USER_ID = vwAPPOINTMENTS_USERS.USER_ID" + ControlChars.CrLf
								     + " where vwAPPOINTMENTS_USERS.APPOINTMENT_ID = @ID" + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dtUSERS);
								foreach ( DataRow rowUser in dtUSERS.Rows )
								{
									Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"            ]);
									string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EXCHANGE_EMAIL"     ]).ToLower();
									string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["EXCHANGE_ALIAS"     ]).ToLower();
									if ( !Sql.IsEmptyString(sAPPOINTMENT_EMAIL1) && !dictUsers.ContainsKey(sAPPOINTMENT_EMAIL1) )
										dictUsers.Add(sAPPOINTMENT_EMAIL1, gAPPOINTMENT_USER_ID);
									if ( !Sql.IsEmptyString(sAPPOINTMENT_USERNAME) && !dictUsers.ContainsKey(sAPPOINTMENT_USERNAME) )
										dictUsers.Add(sAPPOINTMENT_USERNAME, gAPPOINTMENT_USER_ID);
								}
							}
							
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportAppointment: Retrieving appointment " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToDateTime().ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS);
									
									spAPPOINTMENTS_Update.Transaction = trn;
									// 12/27/2011 Paul.  Move population logic to a static method. 
									// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
									bool bChanged = BuildAPPOINTMENTS_Update(Session, spAPPOINTMENTS_Update, row, appointment, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID);
									if ( !bChanged )
									{
										// 07/26/2012 James.  Add the ability to disable participants. 
										if ( !bDISABLE_PARTICIPANTS )
										{
											foreach ( string sEmail in lstParticipants )
											{
												// 04/02/2012 Paul.  Add Calls/Leads relationship. 
												if ( !dictContacts.ContainsKey(sEmail) && !dictLeads.ContainsKey(sEmail) )
													bChanged = true;
											}
											foreach ( string sEmail in dictContacts.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
													bChanged = true;
											}
											// 04/02/2012 Paul.  Add Calls/Leads relationship. 
											foreach ( string sEmail in dictLeads.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
													bChanged = true;
											}
											foreach ( DataRow rowUser in dtUSERS.Rows )
											{
												Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"            ]);
												// 02/20/2013 Paul.  Correct field names for Exchange Sync.  Not Google Apps. 
												string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EXCHANGE_EMAIL"     ]).ToLower();
												string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["EXCHANGE_ALIAS"     ]).ToLower();
												if ( gAPPOINTMENT_USER_ID != gUSER_ID && !lstParticipants.Contains(sAPPOINTMENT_EMAIL1) && !lstParticipants.Contains(sAPPOINTMENT_USERNAME) )
												{
													bChanged = true;
												}
											}
										}
									}
									if ( bChanged )
									{
										Sql.Trace(spAPPOINTMENTS_Update);
										// 05/09/2018 Paul.  Noticing some timeouts. Just wait for up to 10 min. 
										spAPPOINTMENTS_Update.CommandTimeout = 10 * 60;
										spAPPOINTMENTS_Update.ExecuteNonQuery();
										IDbDataParameter parID = Sql.FindParameter(spAPPOINTMENTS_Update, "@ID");
										gID = Sql.ToGuid(parID.Value);
									
										// 07/26/2012 James.  Add the ability to disable participants. 
										if ( !bDISABLE_PARTICIPANTS )
										{
											// 01/15/2012 Paul.  We need to add the current user to the appointment so that the SYNC_APPOINTMENT will be true. 
											// If the end-user removes himself from the meeting, SYNC_APPOINTMENT will be false and the appointment will be treated as local deleted. 
											if ( sAPPOINTMENT_TYPE == "Meetings" || Sql.IsEmptyString(sAPPOINTMENT_TYPE) )
												SqlProcs.spMEETINGS_USERS_Update(gID, gUSER_ID, true, String.Empty, trn);
											else if ( sAPPOINTMENT_TYPE == "Calls" )
												SqlProcs.spCALLS_USERS_Update(gID, gUSER_ID, true, String.Empty, trn);
									
											// 01/15/2012 Paul.  We need to check for added or removed participants. 
											if ( appointment.Attendees != null )
											{
												foreach ( Spring.Social.Office365.Api.Attendee guest in appointment.Attendees )
												{
													string sEmail         = guest.EmailAddress.Address.ToLower();
													bool   bREQUIRED      = false;
													string sACCEPT_STATUS = String.Empty;
													if ( guest.Status != null )
													{
														switch ( guest.Status.Response )
														{
															case "organizer"          :  sACCEPT_STATUS = "accept"   ;  break;
															case "accepted"           :  sACCEPT_STATUS = "accept"   ;  break;
															case "declined"           :  sACCEPT_STATUS = "decline"  ;  break;
															case "tentativelyAccepted":  sACCEPT_STATUS = "tentative";  break;
															case "notResponded"       :  sACCEPT_STATUS = "none"     ;  break;
														}
													}
													if ( guest.Type != null )
													{
														if ( guest.Type == "required" )
															bREQUIRED = true;
													}
													// 01/10/2012 Paul.  iCloud can have contacts without an email. 
													Guid gCONTACT_ID = Guid.Empty;
													SqlProcs.spAPPOINTMENTS_RELATED_Update(gID, sEmail, bREQUIRED, sACCEPT_STATUS, String.Empty, ref gCONTACT_ID, trn);
												}
											}
											foreach ( string sEmail in dictContacts.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
												{
													Guid gAPPOINTMENT_CONTACT_ID = dictContacts[sEmail];
													SqlProcs.spAPPOINTMENTS_CONTACTS_Delete(gID, gAPPOINTMENT_CONTACT_ID, trn);
												}
											}
											// 04/02/2012 Paul.  Add Calls/Leads relationship. 
											foreach ( string sEmail in dictLeads.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
												{
													Guid gAPPOINTMENT_LEAD_ID = dictLeads[sEmail];
													SqlProcs.spAPPOINTMENTS_LEADS_Delete(gID, gAPPOINTMENT_LEAD_ID, trn);
												}
											}
											foreach ( DataRow rowUser in dtUSERS.Rows )
											{
												Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"            ]);
												// 02/20/2013 Paul.  Correct field names for Exchange Sync.  Not Google Apps. 
												string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EXCHANGE_EMAIL"     ]).ToLower();
												string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["EXCHANGE_ALIAS"     ]).ToLower();
												// 01/14/2012 Paul.  Make sure not to remove this user. 
												if ( gAPPOINTMENT_USER_ID != gUSER_ID && !lstParticipants.Contains(sAPPOINTMENT_EMAIL1) && !lstParticipants.Contains(sAPPOINTMENT_USERNAME) )
												{
													SqlProcs.spAPPOINTMENTS_USERS_Delete(gID, gAPPOINTMENT_USER_ID, trn);
												}
											}
										}
									}
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									// 02/20/2013 Paul.  Log inner error. 
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
									throw;
								}
							}
						}
						else if ( (sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new") && !Sql.IsEmptyGuid(gID) )
						{
							// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to Exchange. 
							if ( dt.Rows.Count > 0 )
							{
								row = dt.Rows[0];
								if ( SplendidInit.bEnableACLFieldSecurity )
								{
									bool bApplyACL = false;
									foreach ( DataColumn col in dt.Columns )
									{
										Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Appointments", col.ColumnName, gASSIGNED_USER_ID);
										if ( !acl.IsReadable() )
										{
											row[col.ColumnName] = DBNull.Value;
											bApplyACL = true;
										}
									}
									if ( bApplyACL )
										dt.AcceptChanges();
								}
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportAppointment: Syncing appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS);
									// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
									// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
									DataTable dtAppointmentEmails = AppointmentEmails(con, Sql.ToGuid(row["ID"]));
									// 07/26/2012 James.  Add the ability to disable participants. 
									// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
									// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
									bool bChanged = this.SetExchangeAppointment(appointment, row, dtAppointmentEmails, sbChanges, bDISABLE_PARTICIPANTS, sCALENDAR_CATEGORY);
									if ( bChanged )
									{
										// 03/17/2013 Paul.  We don't want Exchange sending meeting notices.  The CRM will do that if instructed by the user. 
										appointment.ResponseRequested = false;
										appointment = service.EventOperations.Update(appointment);
									}
									// 03/25/2010 Paul.  Update the modified date after the save. 
									// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
									dtREMOTE_DATE_MODIFIED_UTC = (appointment.LastModifiedDateTime.HasValue ? appointment.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
									dtREMOTE_DATE_MODIFIED     = (appointment.LastModifiedDateTime.HasValue ? TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local) : DateTime.MinValue);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 03/26/2010 Paul.  Make sure to set the Sync flag. 
											// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
											// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
											SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
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
									// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
									string sError = "Error saving " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
									sError += sbChanges.ToString();
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
						else if ( sSYNC_ACTION == "local deleted" )
						{
							try
							{
								// 03/28/2010 Paul.  Load the full appointment so that we can modify just the one field. 
								appointment = service.EventOperations.GetById(appointment.Id);
								// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
								// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
								// 09/02/2018 Paul.  Provide an option to delete the created record. 
								if ( !Sql.IsEmptyString(sCALENDAR_CATEGORY) && !Sql.ToBoolean(Application["CONFIG.Exchange.Appointments.Delete"]) )
								{
									appointment.Categories.Remove(sCALENDAR_CATEGORY);
									// 03/17/2013 Paul.  We don't want Exchange sending meeting notices.  The CRM will do that if instructed by the user. 
									//appointment.Update(ConflictResolutionMode.AlwaysOverwrite, SendInvitationsOrCancellationsMode.SendToNone);
									service.EventOperations.Update(appointment);
								}
								else
								{
									// 09/02/2013 Paul.  If the category is empty, then delete the appointment. 
									service.EventOperations.Delete(appointment.Id);
								}
							}
							catch(Exception ex)
							{
								string sError = "Error clearing Exchange categories for " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToDateTime().ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							try
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportAppointment: Deleting " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToDateTime().ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS);
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
										SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sREMOTE_KEY, "Exchange", trn);
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
								string sError = "Error deleting " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToDateTime().ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
						}
						else if ( sSYNC_ACTION == "remote deleted" )
						{
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Unsyncing appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " for " + sEXCHANGE_ALIAS);
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gID, sREMOTE_KEY, "Exchange", trn);
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
				}
			}
		}
		#endregion

		#region Sync Folders
		public void ImportMessage(Guid gUSER_ID, string sPARENT_KEY, string sREMOTE_KEY)
		{
			string sEXCHANGE_ALIAS = String.Empty;;
			try
			{
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
				// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
				string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"     ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret" ]);
				bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365AccessToken token = this.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gUSER_ID, false);
				Spring.Social.Office365.Api.IOffice365 service = CreateApi(token.access_token);
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select EXCHANGE_ALIAS              " + ControlChars.CrLf
					     + "  from vwEXCHANGE_USERS            " + ControlChars.CrLf
					     + " where ASSIGNED_USER_ID  = @USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
						sEXCHANGE_ALIAS = Sql.ToString(cmd.ExecuteScalar());
					}
					StringBuilder sbErrors = new StringBuilder();
					DataTable dtUserFolders = SplendidCache.ExchangeFolders(gUSER_ID);
					DataView vwUserFolders = new DataView(dtUserFolders);
					vwUserFolders.RowFilter = "REMOTE_KEY = \'" + sPARENT_KEY + "\'";
					if ( vwUserFolders.Count == 1 )
					{
						string  sMODULE_NAME       = Sql.ToString (vwUserFolders[0]["MODULE_NAME"      ]);
						Boolean bWELL_KNOWN_FOLDER = Sql.ToBoolean(vwUserFolders[0]["WELL_KNOWN_FOLDER"]);
						string  sPARENT_NAME       = Sql.ToString (vwUserFolders[0]["PARENT_NAME"      ]);
						Guid    gPARENT_ID         = Sql.ToGuid   (vwUserFolders[0]["PARENT_ID"        ]);

						if ( bVERBOSE_STATUS )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Office365Sync.ImportMessage: for " + sEXCHANGE_ALIAS + " module " + sMODULE_NAME + " to " + sREMOTE_KEY + ".");
					
						Spring.Social.Office365.Api.Message email = service.MailOperations.GetById(sREMOTE_KEY);
						// 01/12/2021 Paul.  If the message id deleted, just ignore the event. 
						if ( !email.Deleted )
						{
							if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Sent Items" )
							{
								// 10/28/2022 Paul.  Don't need entire email if we are going to GetById. 
								this.ImportSentItem(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, sREMOTE_KEY, sbErrors);
							}
							else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Inbox" )
							{
								// 10/28/2022 Paul.  Don't need entire email if we are going to GetById. 
								this.ImportInbox(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, sREMOTE_KEY, sbErrors);
							}
							else
							{
								this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
							}
						}
						else
						{
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportMessage: Deleted message in folder [" + sMODULE_NAME + "]" + sPARENT_KEY + " for user " + sEXCHANGE_ALIAS + " and resource " + sREMOTE_KEY);
						}
					}
					else
					{
						if ( bVERBOSE_STATUS )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportMessage: Could not find parent " + sPARENT_KEY + " for user " + sEXCHANGE_ALIAS + " and resource " + sREMOTE_KEY);
					}
					if ( sbErrors.Length > 0 )
						throw(new Exception(sbErrors.ToString()));
				}
			}
			catch(Exception ex)
			{
				string sError = "Office365Sync.ImportMessage: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
		}

		// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
		public void SyncSentItems(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			
			try
			{
				Spring.Social.Office365.Api.MailFolder fldSentItems = service.FolderOperations.GetWellKnownFolder("sentitems");
				if ( bSyncAll || dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
				{
					string filter = String.Empty;
					if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
					{
						// 03/28/2010 Paul.  The Greater Than filter does not appear to be working. 
						// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
						// 03/28/2010 Paul.  IsGreaterThan is being treated as IsGreaterThanOrEqualTo. 
						// https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings?redirectedfrom=MSDN#Roundtrip
						filter = "lastModifiedDateTime ge " + DateTime.SpecifyKind(dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(600), DateTimeKind.Utc).ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat);
					}
					int nImportCount = 0;
					int nPageOffset = 0;
					// 07/07/2015 Paul.  Allow the page size to be customized. 
					int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Messages.PageSize"]);
					if ( nPageSize <= 0 )
						nPageSize = 100;
					Spring.Social.Office365.Api.MessagePagination results = null;
					do
					{
						// 03/31/2010 Paul.  IdOnly is expected to be very fast. 
						// 03/13/2012 Paul.  There can be lots of records, so get the most recent first when getting all. 
						// Otherwise, get based on ascending date. 
						string sort = "receivedDateTime asc";
						if ( Sql.IsEmptyString(filter) )
							sort = "receivedDateTime desc";
						// 10/28/2022 Paul.  Change name to reflect function.  The entire message is not returned, just the ids. 
						// ImportSentItem will get entire message, so we only need Ids at this point. 
						results = service.FolderOperations.GetMessageIds(fldSentItems.Id, filter, sort, nPageOffset, nPageSize);
						if ( results.messages.Count > 0 )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncSentItems: " + results.messages.Count.ToString() + " Sent Items messages to retrieve for " + sEXCHANGE_ALIAS);
						
						foreach ( Spring.Social.Office365.Api.Message email in results.messages )
						{
							// 12/06/2020 Paul.  Not sure how to put a note into a mail folder, so assume that it cannot be done. 
							//if ( itemMessage is Spring.Social.Office365.Api.Message )
							{
								// 10/28/2022 Paul.  Don't need entire email if we are going to GetById. 
								this.ImportSentItem(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, email.Id, sbErrors);
								nImportCount++;
							}
						}
						nPageOffset += nPageSize;
					}
					while ( nPageOffset < results.count );
					// 04/25/2010 Paul.  We need some status on the Sync page. 
					if ( nImportCount > 0 && bVERBOSE_STATUS )
					{
						sbErrors.AppendLine(nImportCount.ToString() + " messages received in Sent Items for " + sEXCHANGE_ALIAS + "<br />");
					}
				}
			}
			catch(Exception ex)
			{
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				sbErrors.AppendLine(Utils.ExpandException(ex));
			}
		}

		// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
		public void SyncInbox(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			
			try
			{
				Spring.Social.Office365.Api.MailFolder fldInbox = service.FolderOperations.GetWellKnownFolder("inbox");
				if ( bSyncAll || dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
				{
					string filter = String.Empty;
					if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
					{
						// 03/28/2010 Paul.  The Greater Than filter does not appear to be working. 
						// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
						// 03/28/2010 Paul.  IsGreaterThan is being treated as IsGreaterThanOrEqualTo. 
						// https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings?redirectedfrom=MSDN#Roundtrip
						filter = "lastModifiedDateTime ge " + DateTime.SpecifyKind(dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(600), DateTimeKind.Utc).ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat);
					}
					int nImportCount = 0;
					int nPageOffset = 0;
					// 07/07/2015 Paul.  Allow the page size to be customized. 
					int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Messages.PageSize"]);
					if ( nPageSize <= 0 )
						nPageSize = 100;
					Spring.Social.Office365.Api.MessagePagination results = null;
					do
					{
						// 03/31/2010 Paul.  IdOnly is expected to be very fast. 
						// 03/13/2012 Paul.  There can be lots of records, so get the most recent first when getting all. 
						// Otherwise, get based on ascending date. 
						string sort = "receivedDateTime asc";
						if ( Sql.IsEmptyString(filter) )
							sort = "receivedDateTime desc";
						// 10/28/2022 Paul.  Change name to reflect function.  The entire message is not returned, just the ids. 
						// ImportInbox will get entire message, so we only need Ids at this point. 
						results = service.FolderOperations.GetMessageIds(fldInbox.Id, filter, sort, nPageOffset, nPageSize);
						if ( results.messages.Count > 0 )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncInbox: " + results.messages.Count.ToString() + " Inbox messages to retrieve for " + sEXCHANGE_ALIAS);
						
						foreach ( Spring.Social.Office365.Api.Message email in results.messages )
						{
							// 12/06/2020 Paul.  Not sure how to put a note into a mail folder, so assume that it cannot be done. 
							//if ( itemMessage is EmailMessage )
							{
								// 10/28/2022 Paul.  Don't need entire email if we are going to GetById. 
								this.ImportInbox(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, email.Id, sbErrors);
								nImportCount++;
							}
						}
						nPageOffset += nPageSize;
					}
					while ( nPageOffset < results.count );
					// 04/25/2010 Paul.  We need some status on the Sync page. 
					if ( nImportCount > 0 && bVERBOSE_STATUS )
					{
						sbErrors.AppendLine(nImportCount.ToString() + " messages received in Inbox for " + sEXCHANGE_ALIAS + "<br />");
					}
				}
			}
			catch(Exception ex)
			{
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				sbErrors.AppendLine(Utils.ExpandException(ex));
			}
		}

		public void SyncModuleFolders(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, IDbConnection con, Spring.Social.Office365.Api.MailFolder fldExchangeRoot, ref Spring.Social.Office365.Api.MailFolder fldSplendidRoot, ref Spring.Social.Office365.Api.MailFolder fldModuleFolder, string sMODULE_NAME, Guid gPARENT_ID, string sPARENT_NAME, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS  = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			string sCRM_FOLDER_NAME = Sql.ToString (Application["CONFIG.Exchange.CrmFolderName"]);
			string sCULTURE         = L10N.NormalizeCulture(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
				sCRM_FOLDER_NAME = "SplendidCRM";
			
			try
			{
				if ( fldSplendidRoot == null )
				{
					IList<Spring.Social.Office365.Api.MailFolder> fResults = service.FolderOperations.GetChildFolders(fldExchangeRoot.Id, sCRM_FOLDER_NAME);
					// 04/01/2010 Paul.  The correct Mailbox folder is MsgFolderRoot. 
					// 03/31/2010 Paul.  If the SplendidRoot folder does not exist, then create it. 
					bool bSplendidRootCreated = false;
					if ( fResults.Count == 0 )
					{
						fldSplendidRoot = service.FolderOperations.Insert(fldExchangeRoot.Id, sCRM_FOLDER_NAME);
						bSplendidRootCreated = true;
					}
					else
					{
						fldSplendidRoot = fResults[0];
					}
					if ( bSyncAll || bSplendidRootCreated )
					{
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spEXCHANGE_FOLDERS_Update(gUSER_ID, fldSplendidRoot.Id, String.Empty, Guid.Empty, String.Empty, false, trn);
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
				
				if ( fldSplendidRoot != null && !Sql.IsEmptyString(fldSplendidRoot.Id) && !Sql.IsEmptyString(sMODULE_NAME) )
				{
					if ( fldModuleFolder == null )
					{
						string sMODULE_DISPLAY_NAME = String.Empty;
						sMODULE_DISPLAY_NAME = L10N.Term(Application, sCULTURE, ".moduleList." + sMODULE_NAME);
						if ( Sql.IsEmptyString(sMODULE_DISPLAY_NAME) || sMODULE_DISPLAY_NAME.StartsWith(".") )
							sMODULE_DISPLAY_NAME = sMODULE_NAME;
						
						IList<Spring.Social.Office365.Api.MailFolder> fResults = service.FolderOperations.GetChildFolders(fldSplendidRoot.Id, sMODULE_DISPLAY_NAME);
						// 03/31/2010 Paul.  If the Module folder does not exist, then create it. 
						bool bModuleFolderCreated = false;
						if ( fResults.Count == 0 )
						{
							fldModuleFolder = service.FolderOperations.Insert(fldSplendidRoot.Id, sMODULE_DISPLAY_NAME);
							bModuleFolderCreated = true;
						}
						else
						{
							fldModuleFolder = fResults[0];
						}
						if ( bSyncAll || bModuleFolderCreated )
						{
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spEXCHANGE_FOLDERS_Update(gUSER_ID, fldModuleFolder.Id, sMODULE_NAME, Guid.Empty, String.Empty, false, trn);
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
					Spring.Social.Office365.Api.MailFolder fldRecordFolder = null;
					// 04/04/2010 Paul  Create the Record Folder, but make sure not do create at the root. 
					if ( fldModuleFolder != null && !Sql.IsEmptyString(fldModuleFolder.Id) )
					{
						// 07/08/2023 Paul.  We were not importing from module folder due to parent filter. 
						if ( !Sql.IsEmptyGuid(gPARENT_ID) && !Sql.IsEmptyString(sPARENT_NAME) )
						{
							IList<Spring.Social.Office365.Api.MailFolder> fResults = service.FolderOperations.GetChildFolders(fldModuleFolder.Id, sPARENT_NAME);
							// 03/31/2010 Paul.  If the Record folder does not exist, then create it. 
							bool bRecordFolderCreated = false;
							if ( fResults.Count == 0 )
							{
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncModuleFolders: Create folder " + sPARENT_NAME + " in " + sMODULE_NAME);
								fldRecordFolder = service.FolderOperations.Insert(fldModuleFolder.Id, sPARENT_NAME);
								bRecordFolderCreated = true;
							}
							else
							{
								fldRecordFolder = fResults[0];
							}
							if ( bSyncAll || bRecordFolderCreated )
							{
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										SqlProcs.spEXCHANGE_FOLDERS_Update(gUSER_ID, fldRecordFolder.Id, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, false, trn);
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
						// 04/05/2010 Paul.  When the Watermark is empty, no events will be created for existing items.  In that case, poll each folder 
						if ( bSyncAll )
						{
							string sSQL = String.Empty;
							// 04/01/2010 Paul.  Exchange will update the LastModifiedTime message field anytime the messages is moved. 
							// This means that we can rely upon the SYNC_REMOTE_DATE_MODIFIED_UTC, but would have to be folder specific. 
							DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.MinValue;
							// 04/25/2010 Paul.  This code is not used anymore.  When we subscribe, we do not want to also scan all folders. 
							// So, the only time we get to this part of the code is when SyncAll is specified.  
							// However, if we have selected SyncAll, then the modified date should not be included in the filter. 
							//if ( !bSyncAll )
							//{
							//	// 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
							//	sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
							//	     + "  from vwEMAIL_CLIENT_SYNC                           " + ControlChars.CrLf
							//	     + " where SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
							//	using ( IDbCommand cmd = con.CreateCommand() )
							//	{
							//		cmd.CommandText = sSQL;
							//		Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
							//		// 04/01/2010 Paul.  The Module Name is optional. 
							//		if ( !Sql.IsEmptyString(sMODULE_NAME) )
							//			Sql.AppendParameter(cmd, sMODULE_NAME, "SYNC_MODULE_NAME");
							//		else
							//			cmd.CommandText = "   and SYNC_MODULE_NAME is null" + ControlChars.CrLf;
							//		// 04/04/2010 Paul.  The Parent ID is optional. 
							//		if ( !Sql.IsEmptyGuid(gPARENT_ID) )
							//			Sql.AppendParameter(cmd, gPARENT_ID, "SYNC_PARENT_ID");
							//		else
							//			cmd.CommandText = "   and SYNC_PARENT_ID is null" + ControlChars.CrLf;
							//		dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(cmd.ExecuteScalar());
							//	}
							//}
							
							string filter = String.Empty;
							if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
							{
								// 03/28/2010 Paul.  The Greater Than filter does not appear to be working. 
								// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
								// 03/28/2010 Paul.  IsGreaterThan is being treated as IsGreaterThanOrEqualTo. 
								// https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings?redirectedfrom=MSDN#Roundtrip
								filter = "lastModifiedDateTime ge " + DateTime.SpecifyKind(dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(600), DateTimeKind.Utc).ToString(Spring.Social.Office365.Api.DateTimeTimeZone.DateTimeFormat);
							}
							
							int nImportCount = 0;
							int nPageOffset = 0;
							// 07/07/2015 Paul.  Allow the page size to be customized. 
							int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Messages.PageSize"]);
							if ( nPageSize <= 0 )
								nPageSize = 100;
							Spring.Social.Office365.Api.MessagePagination results = null;
							do
							{
								// 03/31/2010 Paul.  IdOnly is expected to be very fast. 
								string sort = "receivedDateTime asc";
								// 10/28/2022 Paul.  Change name to reflect function.  The entire message is not returned, just the ids. 
								// 07/08/2023 Paul.  We were not importing from module folder due to parent filter. 
								if ( fldRecordFolder != null && !Sql.IsEmptyString(fldRecordFolder.Id) )
								{
									results = service.FolderOperations.GetMessageIds(fldRecordFolder.Id, filter, sort, nPageOffset, nPageSize);
								}
								else
								{
									results = service.FolderOperations.GetMessageIds(fldModuleFolder.Id, filter, sort, nPageOffset, nPageSize);
								}
								// 04/25/2010 Paul.  Include parent name in status message. 
								if ( results.messages.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncModuleFolders: " + results.messages.Count.ToString() + " " + sMODULE_NAME + (Sql.IsEmptyString(sPARENT_NAME) ? String.Empty : " - " + sPARENT_NAME) + " messages to retrieve for " + sEXCHANGE_ALIAS);
								
								for ( int i = 0; i < results.messages.Count; i++ )
								{
									// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
									// 12/06/2020 Paul.  Not sure how to put a note into a mail folder, so assume that it cannot be done. 
									//if ( email is EmailMessage )
									{
										Spring.Social.Office365.Api.Message email = service.MailOperations.GetById(results.messages[i].Id);
										this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
									}
									nImportCount++;
								}
								nPageOffset += nPageSize;
							}
							while ( nPageOffset < results.count );
							// 04/25/2010 Paul.  We need some status on the Sync page. 
							if ( nImportCount > 0 && bVERBOSE_STATUS )
							{
								sbErrors.AppendLine(nImportCount.ToString() + " messages received in " + sMODULE_NAME + (Sql.IsEmptyString(sPARENT_NAME) ? String.Empty : " - " + sPARENT_NAME) + " for " + sEXCHANGE_ALIAS + "<br />");
							}
						}
					}
				}
				
			}
			catch(Exception ex)
			{
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				sbErrors.AppendLine(Utils.ExpandException(ex));
			}
		}

		// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
		// 10/28/2022 Paul.  Don't need entire email if we are going to GetById. 
		public void ImportSentItem(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, string sEmailId, StringBuilder sbErrors)
		{
			bool bLoadSuccessful = false;
			string sDESCRIPTION = String.Empty;
			Spring.Social.Office365.Api.Message email = null;
			try
			{
				email = service.MailOperations.GetById(sEmailId);
				bLoadSuccessful = true;
			}
			catch(Exception ex)
			{
				string sError = "Error loading email for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				sbErrors.AppendLine(sError);
			}
			if ( bLoadSuccessful )
			{
				List<string> arrRecipients = new List<string>();
				if ( email.ToRecipients != null && email.ToRecipients.Count > 0 )
				{
					foreach ( Spring.Social.Office365.Api.Recipient addr in email.ToRecipients )
					{
						arrRecipients.Add(addr.EmailAddress.Address);
					}
				}
				if ( email.CcRecipients != null && email.CcRecipients.Count > 0 )
				{
					foreach ( Spring.Social.Office365.Api.Recipient addr in email.CcRecipients )
					{
						arrRecipients.Add(addr.EmailAddress.Address);
					}
				}
				// 04/26/2018 Paul.  As a failsafe, exit if no recipients found. 
				if ( arrRecipients.Count == 0 )
					return;
				
				string sSQL = String.Empty;
				//sSQL = "select PARENT_ID              " + ControlChars.CrLf
				//     + "     , MODULE                 " + ControlChars.CrLf
				//     + "     , EMAIL1                 " + ControlChars.CrLf
				//     + "  from vwPARENTS_EMAIL_ADDRESS" + ControlChars.CrLf
				//     + " where 1 = 0                  " + ControlChars.CrLf;
				
				// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
				// 04/26/2018 Paul.  We need to apply each module security rule separately. 
				string sMODULE_NAME = "Accounts";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, arrRecipients.ToArray(), "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 03/11/2012 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Contacts";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, arrRecipients.ToArray(), "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 03/11/2012 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Leads";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, arrRecipients.ToArray(), "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 03/11/2012 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Prospects";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, arrRecipients.ToArray(), "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 03/11/2012 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
			}
		}

		// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
		// 10/28/2022 Paul.  Don't need entire email if we are going to GetById. 
		public void ImportInbox(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, string sEmailId, StringBuilder sbErrors)
		{
			bool bLoadSuccessful = false;
			string sDESCRIPTION = String.Empty;
			Spring.Social.Office365.Api.Message email = null;
			try
			{
				email = service.MailOperations.GetById(sEmailId);
				bLoadSuccessful = true;
			}
			catch(Exception ex)
			{
				string sError = "Error loading email for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				sbErrors.AppendLine(sError);
			}
			if ( bLoadSuccessful )
			{
				string sSQL = String.Empty;
				// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
				// 04/26/2018 Paul.  We need to apply each module security rule separately. 
				string sMODULE_NAME = "Accounts";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, email.From.EmailAddress.Address, "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 07/05/2017 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Contacts";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, email.From.EmailAddress.Address, "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 07/05/2017 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Leads";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, email.From.EmailAddress.Address, "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 07/05/2017 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Prospects";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, email.From.EmailAddress.Address, "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 07/05/2017 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, service, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
			}
		}

		// 04/26/2018 Paul.  We need to apply each module security rule separately. 
		public Guid RecipientByEmail(ExchangeSession Session, IDbConnection con, Guid gUSER_ID, string sEMAIL)
		{
			Guid gRECIPIENT_ID = Guid.Empty;
			string sSQL = String.Empty;
			string sMODULE_NAME = "Contacts";
			if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) && Sql.IsEmptyGuid(gRECIPIENT_ID) )
			{
				string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
				sSQL = "select ID              " + ControlChars.CrLf
				     + "     , EMAIL1          " + ControlChars.CrLf
				     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
					ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
					Sql.AppendParameter(cmd, sEMAIL, "EMAIL1");
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							// 06/22/2018 Paul.  Correct field name. PARENT_ID was wrong. 
							gRECIPIENT_ID = Sql.ToGuid(rdr["ID"]);
						}
					}
				}
			}
			sMODULE_NAME = "Leads";
			if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) && Sql.IsEmptyGuid(gRECIPIENT_ID) )
			{
				string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
				sSQL = "select ID              " + ControlChars.CrLf
				     + "     , EMAIL1          " + ControlChars.CrLf
				     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
					ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
					Sql.AppendParameter(cmd, sEMAIL, "EMAIL1");
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							// 06/22/2018 Paul.  Correct field name. PARENT_ID was wrong. 
							gRECIPIENT_ID = Sql.ToGuid(rdr["ID"]);
						}
					}
				}
			}
			sMODULE_NAME = "Prospects";
			if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) && Sql.IsEmptyGuid(gRECIPIENT_ID) )
			{
				string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
				sSQL = "select ID              " + ControlChars.CrLf
				     + "     , EMAIL1          " + ControlChars.CrLf
				     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
					ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
					Sql.AppendParameter(cmd, sEMAIL, "EMAIL1");
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							// 06/22/2018 Paul.  Correct field name. PARENT_ID was wrong. 
							gRECIPIENT_ID = Sql.ToGuid(rdr["ID"]);
						}
					}
				}
			}
			return gRECIPIENT_ID;
		}

		public void ImportMessage(ExchangeSession Session, Spring.Social.Office365.Api.IOffice365 service, IDbConnection con, string sMODULE_NAME, Guid gPARENT_ID, string sEXCHANGE_ALIAS, Guid gUSER_ID, Spring.Social.Office365.Api.Message email, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			Guid   gTEAM_ID        = Sql.ToGuid(Session["TEAM_ID"]);
			long   lUploadMaxSize  = Sql.ToLong(Application["CONFIG.upload_maxsize"]);
			string sCULTURE        = L10N.NormalizeCulture(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			
			IDbCommand spEMAILS_Update = SqlProcs.Factory(con, "spEMAILS_Update");
			// 04/05/2010 Paul.  Need to be able to disable Account creation. This is because the email may come from a personal email address.
			IDbCommand spModule_Update = null;
			if ( !Sql.IsEmptyString(sMODULE_NAME) && Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".ExchangeCreateParent"]) )
			{
				string sMODULE_TABLE = Modules.TableName(sMODULE_NAME);
				if ( !Sql.IsEmptyString(sMODULE_TABLE) )
				{
					try
					{
						spModule_Update = SqlProcs.Factory(con, "sp" + sMODULE_TABLE + "_Update");
					}
					catch(Exception ex)
					{
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					}
				}
			}
			
			Guid gX_SplendidCRM_ID = Guid.Empty;
			string sInternetMessageId = email.InternetMessageId;
			try
			{
				if ( email.SingleValueExtendedProperties != null && email.SingleValueExtendedProperties.Count > 0 )
				{
					string sPropertyId = "String {" + ExchangeUtils.SPLENDIDCRM_PROPERTY_SET_ID.ToString() + "} Name " + ExchangeUtils.SPLENDIDCRM_PROPERTY_NAME;
					foreach ( Spring.Social.Office365.Api.SingleValueLegacyExtendedProperty prop in email.SingleValueExtendedProperties )
					{
						if ( prop.Id == sPropertyId )
						{
							gX_SplendidCRM_ID = Sql.ToGuid(prop.Value);
							break;
						}
					}
				}
			}
			catch
			{
			}

			string sREMOTE_KEY = email.Id;
			string sSQL = String.Empty;
			// 07/24/2010 Paul.  We have a problem in the the REMOTE_KEY is case-significant, but the query is not. 
			// This is the reason why some messages are not getting imported into the CRM. 
			// 07/24/2010 Paul.  Instead of managing collation in code, it is better to change the collation on the field in the database. 
			// 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
			sSQL = "select SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "  from vwEMAIL_CLIENT_SYNC                           " + ControlChars.CrLf
			     + " where SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
			     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " // Sql.CaseSensitiveCollation(con)
			     + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
				Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
				Guid gEMAIL_ID = Sql.ToGuid(cmd.ExecuteScalar());
				// 03/23/2016 Paul.  Email may have already been imported using the OfficeAddin. 
				if ( Sql.IsEmptyGuid(gEMAIL_ID) )
				{
					cmd.Parameters.Clear();
					if ( !Sql.IsEmptyString(sInternetMessageId) )
					{
						// 07/19/2018 Paul.  Send does not return an message ID, so we need to set an extended property, then retrieve it later. 
						// 07/19/2018 Paul.  We will need to change vwEMAILS_Inbound to allow MESSAGE_ID to be null so we can find Sent Items. 
						sSQL = "select ID                      " + ControlChars.CrLf
						     + "  from vwEMAILS_Inbound        " + ControlChars.CrLf
						     + " where MESSAGE_ID = @MESSAGE_ID" + ControlChars.CrLf
						     + "    or ID         = @ID        " + ControlChars.CrLf;
						cmd.CommandText = sSQL;
						cmd.CommandTimeout = 0;
						// 11/14/2017 Paul.  email.InternetMessageId needs to be loaded in advance as it is not part of the FirstClassProperties. 
						Sql.AddParameter(cmd, "@MESSAGE_ID", sInternetMessageId);
						Sql.AddParameter(cmd, "@ID"        , gX_SplendidCRM_ID );
						gEMAIL_ID = Sql.ToGuid(cmd.ExecuteScalar());
						// 03/23/2016 Paul.  If email found in the system, then just add to the sync table. 
						if ( !Sql.IsEmptyGuid(gEMAIL_ID) )
						{
							DateTime dtREMOTE_DATE_MODIFIED_UTC = (email.LastModifiedDateTime.HasValue ? email.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
							DateTime dtREMOTE_DATE_MODIFIED     = (email.LastModifiedDateTime.HasValue ? TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local) : DateTime.MinValue);
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spEMAIL_CLIENT_SYNC_Update(gUSER_ID, gEMAIL_ID, sREMOTE_KEY, sMODULE_NAME, gPARENT_ID, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, trn);
									SqlProcs.spEMAILS_InsertRelated(gEMAIL_ID, sMODULE_NAME, gPARENT_ID, trn);
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
									throw;
								}
							}
						}
					}
				}
				if ( Sql.IsEmptyGuid(gEMAIL_ID) )
				{
					bool bLoadSuccessful = false;
					string sDESCRIPTION = String.Empty;
					try
					{
						email = service.MailOperations.GetById(email.Id);
						// 06/04/2010 Paul.  First load the plain-text body, then load the reset of the properties. 
						// 06/04/2010 Paul.  Can't use the same object to load the text body. 
						// 12/25/2020 Paul.  The plain text body is returned in BodyPreview. 
						sDESCRIPTION = email.BodyPreview;
						bLoadSuccessful = true;
					}
					catch(Exception ex)
					{
						string sError = "Error loading email for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
						sError += Utils.ExpandException(ex) + ControlChars.CrLf;
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
						sbErrors.AppendLine(sError);
					}
					if ( bLoadSuccessful )
					{
						DateTime dtREMOTE_DATE_MODIFIED_UTC = (email.LastModifiedDateTime.HasValue ? email.LastModifiedDateTime.Value.UtcDateTime : DateTime.MinValue);
						DateTime dtREMOTE_DATE_MODIFIED     = (email.LastModifiedDateTime.HasValue ? TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local) : DateTime.MinValue);
						
						Guid   gCONTACT_ID     = Guid.Empty;
						Guid   gSENDER_USER_ID = Guid.Empty;
						string sPARENT_TYPE    = String.Empty;
						string sACCOUNT_NAME   = email.From.EmailAddress.Address;
						string sACCOUNT_DOMAIN = email.From.EmailAddress.Address;
						if ( sACCOUNT_NAME.Contains("@") )
						{
							sACCOUNT_NAME   = sACCOUNT_NAME.Split('@')[1];
							sACCOUNT_DOMAIN = "%@" + sACCOUNT_NAME.ToLower();
							// 04/22/2010 Paul.  Don't match the company for popular free email systems. 
							// 04/25/2010 Paul.  Provide a way to add excluded domains. 
							string sEXCLUDED_ACCOUNT_DOMAINS = Sql.ToString(Application["CONFIG.Exchange.ExcludedAccountDomains"]);
							if ( Sql.IsEmptyString(sEXCLUDED_ACCOUNT_DOMAINS) )
								sEXCLUDED_ACCOUNT_DOMAINS = "@yahoo.com;@hotmail.com;@gmail.com";
							string[] arrEXCLUDED_ACCOUNT_DOMAINS = sEXCLUDED_ACCOUNT_DOMAINS.Split(';');
							foreach ( string sEXCLUDED_DOMAIN in arrEXCLUDED_ACCOUNT_DOMAINS )
							{
								if ( !Sql.IsEmptyString(sEXCLUDED_DOMAIN) && sACCOUNT_DOMAIN.EndsWith(sEXCLUDED_DOMAIN) )
								{
									sACCOUNT_DOMAIN = String.Empty;
									break;
								}
							}
						}
						// 04/07/2010 Paul.  A domain name may have multiple parts.  Use the second-to-last as the account name. 
						string[] arrACCOUNT_NAME = sACCOUNT_NAME.Split('.');
						if ( arrACCOUNT_NAME.Length >= 2 )
							sACCOUNT_NAME = sACCOUNT_NAME.Split('.')[arrACCOUNT_NAME.Length - 2];
						else
							sACCOUNT_NAME = sACCOUNT_NAME.Split('.')[0];
						if ( Sql.IsEmptyGuid(gPARENT_ID) )
						{
							// 03/31/2010 Paul.  Lookup the Account outside the transaction. 
							if ( sMODULE_NAME == "Accounts" && Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
							{
								// 03/31/2010 Paul.  First lookup the Contact for the Account, then the Account by email, then the Account by name. 
								// 04/22/2010 Paul.  Make sure not to get a hit on null fields. 
								// 04/26/2018 Paul.  We need to apply each module security rule separately. 
								if ( Sql.IsEmptyGuid(gPARENT_ID) )
								{
									// 01/10/2021 Paul.  If we are going to reuse cmd, then we need to clear parameters before each new query. 
									cmd.Parameters.Clear();
									sSQL = "select ACCOUNT_ID as ID           " + ControlChars.CrLf
									     + "  from vwCONTACTS                 " + ControlChars.CrLf;
									cmd.CommandText = sSQL;
									// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
									ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
									Sql.AppendParameter(cmd, email.From.EmailAddress.Address, "EMAIL1");
									cmd.CommandText += "   and ACCOUNT_ID is not null" + ControlChars.CrLf;
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
									// 05/30/2023 Paul.  If failed on EMAIL1, try EMAIL2. 
									if ( Sql.IsEmptyGuid(gPARENT_ID) )
									{
										try
										{
											IDbDataParameter parEMAIL1 = Sql.FindParameter(cmd, "EMAIL1");
											parEMAIL1.ParameterName = "EMAIL2";
											using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
											{
												if ( rdr.Read() )
												{
													sPARENT_TYPE = sMODULE_NAME;
													gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
												}
											}
										}
										catch(Exception ex)
										{
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), ex.Message);
										}
									}
								}
								if ( Sql.IsEmptyGuid(gPARENT_ID) )
								{
									// 01/10/2021 Paul.  If we are going to reuse cmd, then we need to clear parameters before each new query. 
									cmd.Parameters.Clear();
									sSQL = "select ID                         " + ControlChars.CrLf
									     + "  from vwACCOUNTS                 " + ControlChars.CrLf;
									cmd.CommandText = sSQL;
									// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
									ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Accounts", "view");
									Sql.AppendParameter(cmd, email.From.EmailAddress.Address, "EMAIL1");
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
									// 05/30/2023 Paul.  If failed on EMAIL1, try EMAIL2. 
									if ( Sql.IsEmptyGuid(gPARENT_ID) )
									{
										try
										{
											IDbDataParameter parEMAIL1 = Sql.FindParameter(cmd, "EMAIL1");
											parEMAIL1.ParameterName = "EMAIL2";
											using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
											{
												if ( rdr.Read() )
												{
													sPARENT_TYPE = sMODULE_NAME;
													gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
												}
											}
										}
										catch(Exception ex)
										{
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), ex.Message);
										}
									}
								}
								if ( Sql.IsEmptyGuid(gPARENT_ID) && !Sql.IsEmptyString(sACCOUNT_DOMAIN) )
								{
									// 01/10/2021 Paul.  If we are going to reuse cmd, then we need to clear parameters before each new query. 
									cmd.Parameters.Clear();
									sSQL = "select ID                         " + ControlChars.CrLf
									     + "  from vwACCOUNTS                 " + ControlChars.CrLf;
									cmd.CommandText = sSQL;
									// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
									ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Accounts", "view");
									cmd.CommandText += "   and EMAIL1 like @ACCOUNT_DOMAIN" + ControlChars.CrLf;
									cmd.CommandText += "   and EMAIL1 is not null         " + ControlChars.CrLf;
									Sql.AddParameter(cmd, "@ACCOUNT_DOMAIN", sACCOUNT_DOMAIN   );
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
								}
								if ( Sql.IsEmptyGuid(gPARENT_ID) )
								{
									// 01/10/2021 Paul.  If we are going to reuse cmd, then we need to clear parameters before each new query. 
									cmd.Parameters.Clear();
									sSQL = "select ID                         " + ControlChars.CrLf
									     + "  from vwACCOUNTS                 " + ControlChars.CrLf;
									cmd.CommandText = sSQL;
									// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
									ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Accounts", "view");
									Sql.AppendParameter(cmd, sACCOUNT_NAME, "NAME");
									cmd.CommandText += "   and NAME is not null" + ControlChars.CrLf;
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
								}
							}
							else if ( sMODULE_NAME == "Leads" && Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
							{
								cmd.Parameters.Clear();
								sSQL = "select ID                      " + ControlChars.CrLf
								     + "  from vwLEADS                 " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
								ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Leads", "view");
								Sql.AppendParameter(cmd, email.From.EmailAddress.Address, "EMAIL1");
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									if ( rdr.Read() )
									{
										sPARENT_TYPE = sMODULE_NAME;
										gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
									}
								}
								// 05/30/2023 Paul.  If failed on EMAIL1, try EMAIL2. 
								if ( Sql.IsEmptyGuid(gPARENT_ID) )
								{
									try
									{
										IDbDataParameter parEMAIL1 = Sql.FindParameter(cmd, "EMAIL1");
										parEMAIL1.ParameterName = "EMAIL2";
										using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
										{
											if ( rdr.Read() )
											{
												sPARENT_TYPE = sMODULE_NAME;
												gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
											}
										}
									}
									catch(Exception ex)
									{
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), ex.Message);
									}
								}
							}
						}
						else
						{
							// 04/06/2010 Paul.  Make sure to set the parent type to the Module Name. 
							sPARENT_TYPE = sMODULE_NAME;
						}
						// 04/01/2010 Paul.  Always lookup and assign the contact. 
						// 04/06/2010 Paul.  The PARENT_ID is only set if the Module is Contacts. 
						// 04/22/2010 Paul.  Always lookup the Contact, even when dropping onto a specific parent folder. 
						cmd.Parameters.Clear();
						if ( Sql.ToBoolean(Application["Modules.Contacts.Valid"]) )
						{
							sSQL = "select ID                      " + ControlChars.CrLf
							     + "  from vwCONTACTS              " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
							Sql.AppendParameter(cmd, email.From.EmailAddress.Address, "EMAIL1");
							using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
							{
								if ( rdr.Read() )
								{
									gCONTACT_ID = Sql.ToGuid(rdr["ID"]);
									if ( sMODULE_NAME == "Contacts" && Sql.IsEmptyGuid(gPARENT_ID) )
									{
										sPARENT_TYPE = sMODULE_NAME;
										gPARENT_ID   = gCONTACT_ID;
									}
								}
							}
							// 05/30/2023 Paul.  If failed on EMAIL1, try EMAIL2. 
							if ( Sql.IsEmptyGuid(gPARENT_ID) )
							{
								try
								{
									IDbDataParameter parEMAIL1 = Sql.FindParameter(cmd, "EMAIL1");
									parEMAIL1.ParameterName = "EMAIL2";
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
								}
								catch(Exception ex)
								{
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), ex.Message);
								}
							}
						}
						
						// 04/01/2012 Paul.  Add Calls/Leads relationship, but only if the contact does not exist. 
						if ( Sql.IsEmptyGuid(gCONTACT_ID) && Sql.ToBoolean(Application["Modules.Leads.Valid"]) )
						{
							cmd.Parameters.Clear();
							sSQL = "select ID                      " + ControlChars.CrLf
							     + "  from vwLEADS                 " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Leads", "view");
							Sql.AppendParameter(cmd, email.From.EmailAddress.Address, "EMAIL1");
							using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
							{
								if ( rdr.Read() )
								{
									Guid gLEAD_ID = Sql.ToGuid(rdr["ID"]);
									if ( sMODULE_NAME == "Leads" && Sql.IsEmptyGuid(gPARENT_ID) )
									{
										sPARENT_TYPE = sMODULE_NAME;
										gPARENT_ID   = gLEAD_ID;
									}
								}
							}
							// 05/30/2023 Paul.  If failed on EMAIL1, try EMAIL2. 
							if ( Sql.IsEmptyGuid(gPARENT_ID) )
							{
								try
								{
									IDbDataParameter parEMAIL1 = Sql.FindParameter(cmd, "EMAIL1");
									parEMAIL1.ParameterName = "EMAIL2";
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
								}
								catch(Exception ex)
								{
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), ex.Message);
								}
							}
						}
						
						// 04/22/2010 Paul.  Make sure not to create a Contact if the Sender is a CRM User. 
						cmd.Parameters.Clear();
						sSQL = "select ID              " + ControlChars.CrLf
						     + "  from vwUSERS         " + ControlChars.CrLf
						     + " where EMAIL1 = @EMAIL1" + ControlChars.CrLf
						     + "    or EMAIL2 = @EMAIL2" + ControlChars.CrLf;
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@EMAIL1", email.From.EmailAddress.Address);
						Sql.AddParameter(cmd, "@EMAIL2", email.From.EmailAddress.Address);
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								gSENDER_USER_ID = Sql.ToGuid(rdr["ID"]);
							}
						}
						
						string sREPLY_TO_NAME = String.Empty;
						string sREPLY_TO_ADDR = String.Empty;
						if ( email.ReplyTo != null && email.ReplyTo.Count > 0 )
						{
							sREPLY_TO_NAME = email.ReplyTo[0].EmailAddress.Name   ;
							sREPLY_TO_ADDR = email.ReplyTo[0].EmailAddress.Address;
						}
						
						StringBuilder sbTO_ADDRS_IDS    = new StringBuilder();
						StringBuilder sbTO_ADDRS_NAMES  = new StringBuilder();
						StringBuilder sbTO_ADDRS_EMAILS = new StringBuilder();
						if ( email.ToRecipients != null && email.ToRecipients.Count > 0 )
						{
							foreach ( Spring.Social.Office365.Api.Recipient addr in email.ToRecipients )
							{
								if ( sbTO_ADDRS_NAMES .Length > 0 ) sbTO_ADDRS_NAMES .Append(';');
								if ( sbTO_ADDRS_EMAILS.Length > 0 ) sbTO_ADDRS_EMAILS.Append(';');
								sbTO_ADDRS_NAMES .Append(addr.EmailAddress.Name   );
								sbTO_ADDRS_EMAILS.Append(addr.EmailAddress.Address);
								// 07/18/2010 Paul.  Exchange, Imap and Pop3 utils will all use this method to lookup a contact by email. 
								// 08/30/2010 Paul.  The previous method only returned Contacts, where as this new method returns Contacts, Leads and Prospects. 
								// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
								Guid gRECIPIENT_ID = this.RecipientByEmail(Session, con, gUSER_ID, addr.EmailAddress.Address);
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
							foreach ( Spring.Social.Office365.Api.Recipient addr in email.CcRecipients )
							{
								if ( sbCC_ADDRS_NAMES .Length > 0 ) sbCC_ADDRS_NAMES .Append(';');
								if ( sbCC_ADDRS_EMAILS.Length > 0 ) sbCC_ADDRS_EMAILS.Append(';');
								sbCC_ADDRS_NAMES .Append(addr.EmailAddress.Name   );
								sbCC_ADDRS_EMAILS.Append(addr.EmailAddress.Address);
								// 07/18/2010 Paul.  Exchange, Imap and Pop3 utils will all use this method to lookup a contact by email. 
								// 08/30/2010 Paul.  The previous method only returned Contacts, where as this new method returns Contacts, Leads and Prospects. 
								// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
								Guid gRECIPIENT_ID = this.RecipientByEmail(Session, con, gUSER_ID, addr.EmailAddress.Address);
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
							foreach ( Spring.Social.Office365.Api.Recipient addr in email.BccRecipients )
							{
								if ( sbBCC_ADDRS_NAMES .Length > 0 ) sbBCC_ADDRS_NAMES .Append(';');
								if ( sbBCC_ADDRS_EMAILS.Length > 0 ) sbBCC_ADDRS_EMAILS.Append(';');
								sbBCC_ADDRS_NAMES .Append(addr.EmailAddress.Name   );
								sbBCC_ADDRS_EMAILS.Append(addr.EmailAddress.Address);
								// 07/18/2010 Paul.  Exchange, Imap and Pop3 utils will all use this method to lookup a contact by email. 
								// 08/30/2010 Paul.  The previous method only returned Contacts, where as this new method returns Contacts, Leads and Prospects. 
								// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
								Guid gRECIPIENT_ID = this.RecipientByEmail(Session, con, gUSER_ID, addr.EmailAddress.Address);
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
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportMessage: Retrieving email " + Sql.ToString(email.Subject) + " " + Sql.ToString(email.DateTimeReceived.ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS);
								
								if ( Sql.IsEmptyGuid(gPARENT_ID) && !Sql.IsEmptyString(sMODULE_NAME) && spModule_Update != null )
								{
									string sNAME       = email.From.EmailAddress.Name;
									string sFIRST_NAME = String.Empty;
									string sLAST_NAME  = String.Empty;
									if ( sNAME.Contains("@") )
										sNAME = sNAME.Split('@')[0];
									sNAME = sNAME.Replace('.', ' ');
									sNAME = sNAME.Replace('_', ' ');
									string[] arrNAME = sNAME.Split(' ');
									if ( arrNAME.Length > 1 )
									{
										sFIRST_NAME = arrNAME[0];
										sLAST_NAME  = arrNAME[arrNAME.Length - 1];
									}
									else
									{
										sLAST_NAME = sNAME;
									}
									
									spModule_Update.Transaction = trn;
									foreach(IDbDataParameter par in spModule_Update.Parameters)
									{
										// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
										string sParameterName = Sql.ExtractDbName(spModule_Update, par.ParameterName).ToUpper();
										if ( sParameterName == "TEAM_ID" )
											par.Value = gTEAM_ID;
										else if ( sParameterName == "ASSIGNED_USER_ID" )
											par.Value = gUSER_ID;
										// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
										else if ( sParameterName == "MODIFIED_USER_ID" )
											par.Value = gUSER_ID;
										else
											par.Value = DBNull.Value;
										switch ( sParameterName )
										{
											case "NAME"      :  par.Value = (sMODULE_NAME == "Accounts") ? sACCOUNT_NAME : Sql.ToDBString(email.Subject);  break;
											case "FIRST_NAME":  par.Value = Sql.ToDBString(sFIRST_NAME       );  break;
											case "LAST_NAME" :  par.Value = Sql.ToDBString(sLAST_NAME        );  break;
											case "EMAIL1"    :  par.Value = Sql.ToDBString(email.From.EmailAddress.Address);  break;
											// 03/06/2012 Paul.  The default Lead Source should be set to Email. 
											case "LEAD_SOURCE":
												if ( sMODULE_NAME == "Leads" )
													par.Value = "Email";
												break;
											// 03/06/2012 Paul.  The default Status should be set to In Process. 
											case "STATUS":
												if ( sMODULE_NAME == "Leads" )
													par.Value = "In Process";
												break;
										}
									}
									Sql.Trace(spModule_Update);
									spModule_Update.ExecuteNonQuery();
									IDbDataParameter parPARENT_ID = Sql.FindParameter(spModule_Update, "@ID");
									sPARENT_TYPE = sMODULE_NAME;
									gPARENT_ID   = Sql.ToGuid(parPARENT_ID.Value);
									// 04/01/2010 Paul.  When creating an account, also create a contact. 
									// 04/22/2010 Paul.  Make sure not to create a Contact if the Sender is a CRM User. 
									if ( sMODULE_NAME == "Accounts" && Sql.IsEmptyGuid(gCONTACT_ID) && Sql.IsEmptyGuid(gSENDER_USER_ID) )
									{
										// 01/16/2012 Paul.  Assigned User ID and Team ID are now parameters. 
										// 02/20/2013 Paul.  The context is not available, so use local variables. 
										SqlProcs.spCONTACTS_New
											( ref gCONTACT_ID
											, sFIRST_NAME
											, sLAST_NAME
											, String.Empty
											, email.From.EmailAddress.Address
											, gUSER_ID
											, gTEAM_ID
											, String.Empty
											// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
											, String.Empty   // ASSIGNED_SET_LIST
											, trn
											);
									}
								}
								spEMAILS_Update.Transaction = trn;
								foreach(IDbDataParameter par in spEMAILS_Update.Parameters)
								{
									// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
									string sParameterName = Sql.ExtractDbName(spEMAILS_Update, par.ParameterName).ToUpper();
									if ( sParameterName == "TEAM_ID" )
										par.Value = gTEAM_ID;
									else if ( sParameterName == "ASSIGNED_USER_ID" )
										par.Value = gUSER_ID;
									// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
									else if ( sParameterName == "MODIFIED_USER_ID" )
										par.Value = gUSER_ID;
									else
										par.Value = DBNull.Value;
								}
								
								foreach(IDbDataParameter par in spEMAILS_Update.Parameters)
								{
									Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
									// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
									string sColumnName = Sql.ExtractDbName(spEMAILS_Update, par.ParameterName).ToUpper();
									if ( SplendidInit.bEnableACLFieldSecurity )
									{
										acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Emails", sColumnName, gUSER_ID);
									}
									if ( acl.IsWriteable() )
									{
										try
										{
											StringBuilder sDisplayTo  = new StringBuilder();
											StringBuilder sDisplayCc  = new StringBuilder();
											StringBuilder sDisplayBcc = new StringBuilder();
											if ( email.ToRecipients != null )
											{
												foreach ( Spring.Social.Office365.Api.Recipient recipient in email.ToRecipients )
												{
													if ( sDisplayTo.Length > 0 )
														sDisplayTo.Append("; ");
													if ( !Sql.IsEmptyString(recipient.EmailAddress.Name) )
														sDisplayTo.Append(recipient.EmailAddress.Name);
													sDisplayTo.Append("<" + recipient.EmailAddress.Address + ">");
												}
											}
											if ( email.CcRecipients != null )
											{
												foreach ( Spring.Social.Office365.Api.Recipient recipient in email.CcRecipients )
												{
													if ( sDisplayCc.Length > 0 )
														sDisplayCc.Append("; ");
													if ( !Sql.IsEmptyString(recipient.EmailAddress.Name) )
														sDisplayCc.Append(recipient.EmailAddress.Name);
													sDisplayCc.Append("<" + recipient.EmailAddress.Address + ">");
												}
											}
											if ( email.BccRecipients != null )
											{
												foreach ( Spring.Social.Office365.Api.Recipient recipient in email.BccRecipients )
												{
													if ( sDisplayBcc.Length > 0 )
														sDisplayBcc.Append("; ");
													if ( !Sql.IsEmptyString(recipient.EmailAddress.Name) )
														sDisplayBcc.Append(recipient.EmailAddress.Name);
													sDisplayBcc.Append("<" + recipient.EmailAddress.Address + ">");
												}
											}
											switch ( sColumnName )
											{
												case "MODIFIED_USER_ID"  :  par.Value = gUSER_ID;  break;
												// 01/18/2021 Paul.  DateTimeOffice already has a LocalDateTime variable. 
												case "DATE_TIME"         :  par.Value = (email.From.EmailAddress.Address == Sql.ToString(Session["EXCHANGE_EMAIL"]) && email.SentDateTime.HasValue ? Sql.ToDBDateTime(email.SentDateTime.Value.LocalDateTime) : (email.ReceivedDateTime.HasValue ? Sql.ToDBDateTime(email.ReceivedDateTime.Value.LocalDateTime) : DateTime.MinValue));  break;
												case "TYPE"              :  par.Value = "archived"                                   ;  break;
												case "NAME"              :  par.Value = Sql.ToDBString(email.Subject                );  break;
												case "DESCRIPTION"       :  par.Value = Sql.ToDBString(sDESCRIPTION                 );  break;
												case "DESCRIPTION_HTML"  :  par.Value = Sql.ToDBString(email.Body != null ? email.Body.Content : String.Empty);  break;
												case "PARENT_TYPE"       :  par.Value = Sql.ToDBString(sPARENT_TYPE                 );  break;
												case "PARENT_ID"         :  par.Value = Sql.ToDBGuid  (gPARENT_ID                   );  break;
												// 11/14/2017 Paul.  email.InternetMessageId needs to be loaded in advance as it is not part of the FirstClassProperties. 
												case "MESSAGE_ID"        :  par.Value = Sql.ToDBString(sInternetMessageId           );  break;
												case "FROM_NAME"         :  par.Value = Sql.ToDBString(email.From.EmailAddress.Name   );  break;
												case "FROM_ADDR"         :  par.Value = Sql.ToDBString(email.From.EmailAddress.Address);  break;
												case "REPLY_TO_NAME"     :  par.Value = Sql.ToDBString(sREPLY_TO_NAME               );  break;
												case "REPLY_TO_ADDR"     :  par.Value = Sql.ToDBString(sREPLY_TO_ADDR               );  break;
												case "TO_ADDRS"          :  par.Value = Sql.ToDBString(sDisplayTo.ToString()        );  break;
												case "CC_ADDRS"          :  par.Value = Sql.ToDBString(sDisplayCc.ToString()        );  break;
												case "BCC_ADDRS"         :  par.Value = Sql.ToDBString(sDisplayBcc.ToString()       );  break;
												case "TO_ADDRS_IDS"      :  par.Value = Sql.ToDBString(sbTO_ADDRS_IDS    .ToString());  break;
												case "TO_ADDRS_NAMES"    :  par.Value = Sql.ToDBString(sbTO_ADDRS_NAMES  .ToString());  break;
												case "TO_ADDRS_EMAILS"   :  par.Value = Sql.ToDBString(sbTO_ADDRS_EMAILS .ToString());  break;
												case "CC_ADDRS_IDS"      :  par.Value = Sql.ToDBString(sbCC_ADDRS_IDS    .ToString());  break;
												case "CC_ADDRS_NAMES"    :  par.Value = Sql.ToDBString(sbCC_ADDRS_NAMES  .ToString());  break;
												case "CC_ADDRS_EMAILS"   :  par.Value = Sql.ToDBString(sbCC_ADDRS_EMAILS .ToString());  break;
												case "BCC_ADDRS_IDS"     :  par.Value = Sql.ToDBString(sbBCC_ADDRS_IDS   .ToString());  break;
												case "BCC_ADDRS_NAMES"   :  par.Value = Sql.ToDBString(sbBCC_ADDRS_NAMES .ToString());  break;
												case "BCC_ADDRS_EMAILS"  :  par.Value = Sql.ToDBString(sbBCC_ADDRS_EMAILS.ToString());  break;
												//case "INTERNET_HEADERS"  :  par.Value = Sql.ToDBString(email.InternetMessageHeaders.ToString() );  break;
											}
										}
										catch
										{
											// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
										}
									}
								}
								Sql.Trace(spEMAILS_Update);
								spEMAILS_Update.ExecuteNonQuery();
								IDbDataParameter parEMAIL_ID = Sql.FindParameter(spEMAILS_Update, "@ID");
								gEMAIL_ID = Sql.ToGuid(parEMAIL_ID.Value);
								// 04/01/2010 Paul.  Always add the current user to the email. 
								SqlProcs.spEMAILS_USERS_Update(gEMAIL_ID, gUSER_ID, trn);
								// 04/01/2010 Paul.  Always lookup and assign the contact. 
								if ( !Sql.IsEmptyGuid(gCONTACT_ID) )
								{
									SqlProcs.spEMAILS_CONTACTS_Update(gEMAIL_ID, gCONTACT_ID, trn);
								}
								if ( email.HasAttachments.HasValue && email.HasAttachments.Value )
								{
									// 03/31/2010 Paul.  Web do not need to load the attachments separately. 
									// email.Load(new PropertySet(ItemSchema.Attachments));
									foreach ( Spring.Social.Office365.Api.Attachment attach in email.Attachments )
									{
										if ( attach.ODataType == "#microsoft.graph.fileAttachment" )
										{
											Spring.Social.Office365.Api.Attachment file = attach;
											//file.Load();
											if ( file.ContentBytes != null )
											{
												// 04/01/2010 Paul.  file.Size is only available on Exchange 2010. 
												long lFileSize = file.ContentBytes.Length;  // file.Size;
												if ( (lUploadMaxSize == 0) || (lFileSize <= lUploadMaxSize) )
												{
													string sFILENAME       = Path.GetFileName (file.Name);
													if ( Sql.IsEmptyString(sFILENAME) )
														sFILENAME = file.Name;
													string sFILE_EXT       = Path.GetExtension(sFILENAME);
													string sFILE_MIME_TYPE = file.ContentType;
													
													Guid gNOTE_ID = Guid.Empty;
													// 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
													SqlProcs.spNOTES_Update
														( ref gNOTE_ID
														, L10N.Term(Application, sCULTURE, "Emails.LBL_EMAIL_ATTACHMENT") + ": " + sFILENAME
														, "Emails"   // Parent Type
														, gEMAIL_ID  // Parent ID
														, Guid.Empty
														, String.Empty
														, gTEAM_ID
														, String.Empty
														, gUSER_ID
														// 05/17/2017 Paul.  Add Tags module. 
														, String.Empty  // TAG_SET_NAME
														// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
														, false         // IS_PRIVATE
														// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
														, String.Empty  // ASSIGNED_SET_LIST
														, trn
														);
													
													Guid gNOTE_ATTACHMENT_ID = Guid.Empty;
													SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, file.Name, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
													//SqlProcs.spNOTES_ATTACHMENT_Update(gNOTE_ATTACHMENT_ID, file.Content, trn);
													// 11/22/2014 Paul.  Use our method to chunk for Oracle. 
													NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, file.ContentBytes, trn);
												}
											}
										}
									}
								}
								// 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
								SqlProcs.spEMAIL_CLIENT_SYNC_Update(gUSER_ID, gEMAIL_ID, sREMOTE_KEY, sMODULE_NAME, gPARENT_ID, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, trn);
								trn.Commit();
							}
							catch(Exception ex)
							{
								trn.Rollback();
								// 02/20/2013 Paul.  Log inner error. 
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
								throw;
							}
						}
					}
				}
			}
		}
		#endregion
	}
}
