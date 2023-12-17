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
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Net;
using System.Xml;
using System.Diagnostics;
using System.Runtime.Serialization.Json;
using SplendidCRM;

using Microsoft.AspNetCore.Http;

// 12/26/2022 Paul.  Add support for Microsoft Teams. 
namespace Spring.Social.MicrosoftTeams
{
	public class MicrosoftTeamsSync
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private SyncError            SyncError          ;

		// https://graphpermissions.merill.net/permission/Chat.ReadBasic.All
		public const string scope = "openid offline_access Team.ReadBasic.All Channel.ReadBasic.All ChannelMessage.ReadWrite"; // Chat.Read.All";  // Teamwork.Migrate.All 
		public  static bool bInsideSyncAll      = false;

		public MicrosoftTeamsSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
		}

		public bool MicrosoftTeamsEnabled()
		{
			string sClientID         = Sql.ToString(Application["CONFIG.MicrosoftTeams.ClientID"    ]);
			string sClientSecret     = Sql.ToString(Application["CONFIG.MicrosoftTeams.ClientSecret"]);
			bool   bMicrosoftTeamsEnabled = !Sql.IsEmptyString(sClientSecret) && !Sql.IsEmptyString(sClientID);
			return bMicrosoftTeamsEnabled;
		}

		public Guid MicrosoftTeamsUserID()
		{
			Guid gMICROSOFTTEAMS_USER_ID = Sql.ToGuid(Application["CONFIG.MicrosoftTeams.UserID"]);
			if ( Sql.IsEmptyGuid(gMICROSOFTTEAMS_USER_ID) )
				gMICROSOFTTEAMS_USER_ID = new Guid("00000000-0000-0000-0000-000000000014");  // Use special MicrosoftTeams user. 
			return gMICROSOFTTEAMS_USER_ID;
		}

		public Spring.Social.MicrosoftTeams.Api.IMicrosoftTeams CreateApi(string sOAuthAccessToken)
		{
			Spring.Social.MicrosoftTeams.Api.IMicrosoftTeams microsoftTeams = null;
			string sMicrosoftTeamsClientID     = Sql.ToString(Application["CONFIG.MicrosoftTeams.ClientID"        ]);
			string sMicrosoftTeamsClientSecret = Sql.ToString(Application["CONFIG.MicrosoftTeams.ClientSecret"    ]);
			// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
			string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.MicrosoftTeams.DirectoryTenantID"]);
			Spring.Social.MicrosoftTeams.Connect.MicrosoftTeamsServiceProvider microsoftTeamsServiceProvider = new Spring.Social.MicrosoftTeams.Connect.MicrosoftTeamsServiceProvider(sOAuthDirectoryTenatID, sMicrosoftTeamsClientID, sMicrosoftTeamsClientSecret);
			microsoftTeams = microsoftTeamsServiceProvider.GetApi(sOAuthAccessToken);
			return microsoftTeams;
		}

		// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
		public Office365AccessToken AcquireAccessToken(HttpRequest Request, string sOAuthDirectoryTenatID, string sOAuthClientID, string sOAuthClientSecret, string sAuthorizationCode, string sRedirect)
		{
			Office365AccessToken token       = null;
			string sOAuthAccessToken  = String.Empty;
			string sOAuthRefreshToken = String.Empty;
			string sOAuthExpiresAt    = String.Empty;
			Guid   gMICROSOFTTEAMS_USER_ID = MicrosoftTeamsUserID();
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
						// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
						if ( Sql.IsEmptyString(sOAuthDirectoryTenatID) )
							sOAuthDirectoryTenatID = "common";
						WebRequest webRequest = WebRequest.Create("https://login.microsoftonline.com/" + sOAuthDirectoryTenatID + "/oauth2/v2.0/token");
						webRequest.ContentType = "application/x-www-form-urlencoded";
						webRequest.Method = "POST";
						string scope = Spring.Social.MicrosoftTeams.MicrosoftTeamsSync.scope;
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
								SqlProcs.spOAUTH_TOKENS_Delete(gMICROSOFTTEAMS_USER_ID, "MicrosoftTeams", trn);
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
					Application["CONFIG.MicrosoftTeams.OAuthAccessToken" ] = sOAuthAccessToken ;
					Application["CONFIG.MicrosoftTeams.OAuthRefreshToken"] = sOAuthRefreshToken;
					Application["CONFIG.MicrosoftTeams.OAuthExpiresAt"   ] = sOAuthExpiresAt   ;
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							// 01/19/2017 Paul.  Name must match SEND_TYPE. 
							SqlProcs.spOAUTH_TOKENS_Update(gMICROSOFTTEAMS_USER_ID, "MicrosoftTeams", sOAuthAccessToken, String.Empty, dtOAuthExpiresAt, sOAuthRefreshToken, trn);
							SqlProcs.spCONFIG_Update("system", "MicrosoftTeams.OAuthAccessToken"  , Sql.ToString(Application["CONFIG.MicrosoftTeams.OAuthAccessToken"  ]), trn);
							SqlProcs.spCONFIG_Update("system", "MicrosoftTeams.OAuthRefreshToken" , Sql.ToString(Application["CONFIG.MicrosoftTeams.OAuthRefreshToken" ]), trn);
							SqlProcs.spCONFIG_Update("system", "MicrosoftTeams.OAuthExpiresAt"    , Sql.ToString(Application["CONFIG.MicrosoftTeams.OAuthExpiresAt"    ]), trn);
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
				Application.Remove("CONFIG.MicrosoftTeams.OAuthAccessToken" );
				Application.Remove("CONFIG.MicrosoftTeams.OAuthRefreshToken");
				Application.Remove("CONFIG.MicrosoftTeams.OAuthExpiresAt"   );
				throw;
			}
			return token;
		}

		public bool RefreshAccessToken(StringBuilder sbErrors)
		{
			bool bSuccess = false;
			string sMicrosoftTeamsClientID     = Sql.ToString(Application["CONFIG.MicrosoftTeams.ClientID"         ]);
			string sMicrosoftTeamsClientSecret = Sql.ToString(Application["CONFIG.MicrosoftTeams.ClientSecret "    ]);
			string sOAuthAccessToken           = Sql.ToString(Application["CONFIG.MicrosoftTeams.OAuthAccessToken" ]);
			string sOAuthRefreshToken          = Sql.ToString(Application["CONFIG.MicrosoftTeams.OAuthRefreshToken"]);
			string sOAuthExpiresAt             = Sql.ToString(Application["CONFIG.MicrosoftTeams.OAuthExpiresAt"   ]);
			Guid   gMICROSOFTTEAMS_USER_ID = MicrosoftTeamsUserID();
			try
			{
				DateTime dtOAuthExpiresAt = Sql.ToDateTime(sOAuthExpiresAt);
				if ( Sql.IsEmptyString(sOAuthAccessToken) || dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now.AddHours(1) > dtOAuthExpiresAt )
				{
					/*
					Spring.Social.MicrosoftTeams.Connect.MicrosoftTeamsServiceProvider microsoftTeamsServiceProvider = new Spring.Social.MicrosoftTeams.Connect.MicrosoftTeamsServiceProvider(sMicrosoftTeamsClientID, sMicrosoftTeamsClientSecret);
					Spring.Social.OAuth2.OAuth2Parameters parameters = new Spring.Social.OAuth2.OAuth2Parameters();
					if ( !Sql.IsEmptyString(sRedirect) )
						parameters.Add("redirect_uri=", sRedirect);
					// https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow
					//	POST /{tenant}/oauth2/v2.0/token HTTP/1.1
					//	Host: https://login.microsoftonline.com
					//	Content-Type: application/x-www-form-urlencoded
					//
					//	client_id=535fb089-9ff3-47b6-9bfb-4f1264799865
					//	&scope=https%3A%2F%2Fgraph.microsoft.com%2Fmail.read
					//	&refresh_token=OAAABAAAAiL9Kn2Z27UubvWFPbm0gLWQJVzCTE9UkP3pSx1aXxUjq...
					//	&grant_type=refresh_token
					//	&client_secret=sampleCredentia1s
					microsoftTeamsServiceProvider.OAuthOperations.RefreshAccessAsync(sOAuthRefreshToken, scope, parameters)
						.ContinueWith<Spring.Social.OAuth2.AccessGrant>(task =>
						{
							if ( task.Status == System.Threading.Tasks.TaskStatus.RanToCompletion && task.Result != null )
							{
								DateTime dtExpires = (task.Result.ExpireTime.HasValue ? task.Result.ExpireTime.Value.ToLocalTime() : DateTime.Now.AddHours(8));
								sOAuthAccessToken  = task.Result.AccessToken     ;
								sOAuthRefreshToken = task.Result.RefreshToken    ;
								sOAuthExpiresAt    = dtExpires.ToShortDateString() + " " + dtExpires.ToShortTimeString();
							}
							else
							{
#if !DEBUG
								Application.Remove("CONFIG.MicrosoftTeams.OAuthAccessToken" );
								Application.Remove("CONFIG.MicrosoftTeams.OAuthRefreshToken");
								Application.Remove("CONFIG.MicrosoftTeams.OAuthExpiresAt"   );
#endif
								throw(new Exception("Could not refresh MicrosoftTeams access token.", task.Exception));
							}
							return null;
						}).Wait();
					*/
					WebRequest webRequest = WebRequest.Create("https://login.microsoftonline.com/common/oauth2/v2.0/token");
					webRequest.ContentType = "application/x-www-form-urlencoded";
					webRequest.Method = "POST";
					string scope = Spring.Social.MicrosoftTeams.MicrosoftTeamsSync.scope;
					string requestDetails = "grant_type=refresh_token&scope=" + HttpUtility.UrlEncode(scope) + "&refresh_token=" + HttpUtility.UrlEncode(sOAuthRefreshToken) + "&client_id=" + sMicrosoftTeamsClientID + "&client_secret=" + HttpUtility.UrlEncode(sMicrosoftTeamsClientSecret);
					byte[] bytes = System.Text.Encoding.ASCII.GetBytes(requestDetails);
					webRequest.ContentLength = bytes.Length;
					using ( Stream outputStream = webRequest.GetRequestStream() )
					{
						outputStream.Write(bytes, 0, bytes.Length);
					}
					using ( WebResponse webResponse = webRequest.GetResponse() )
					{
						DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(Office365AccessToken));
						Office365AccessToken token = (Office365AccessToken)serializer.ReadObject(webResponse.GetResponseStream());
						sOAuthAccessToken  = token.access_token;
						sOAuthRefreshToken = token.refresh_token;
						dtOAuthExpiresAt   = DateTime.Now.AddSeconds(token.ExpiresInSeconds);
						sOAuthExpiresAt    = dtOAuthExpiresAt.ToShortDateString() + " " + dtOAuthExpiresAt.ToShortTimeString();
					}
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								Application["CONFIG.MicrosoftTeams.OAuthAccessToken"  ] = sOAuthAccessToken ;
								Application["CONFIG.MicrosoftTeams.OAuthRefreshToken" ] = sOAuthRefreshToken;
								Application["CONFIG.MicrosoftTeams.OAuthExpiresAt"    ] = sOAuthExpiresAt   ;
								SqlProcs.spCONFIG_Update("system", "MicrosoftTeams.OAuthAccessToken"  , Sql.ToString(Application["CONFIG.MicrosoftTeams.OAuthAccessToken"  ]), trn);
								SqlProcs.spCONFIG_Update("system", "MicrosoftTeams.OAuthRefreshToken" , Sql.ToString(Application["CONFIG.MicrosoftTeams.OAuthRefreshToken" ]), trn);
								SqlProcs.spCONFIG_Update("system", "MicrosoftTeams.OAuthExpiresAt"    , Sql.ToString(Application["CONFIG.MicrosoftTeams.OAuthExpiresAt"    ]), trn);
								SqlProcs.spOAUTH_TOKENS_Update(gMICROSOFTTEAMS_USER_ID, "MicrosoftTeams", sOAuthAccessToken, String.Empty, dtOAuthExpiresAt, sOAuthRefreshToken, trn);
								trn.Commit();
								bSuccess = true;
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
			catch(Exception ex)
			{
				sbErrors.Append(Utils.ExpandException(ex));
			}
			return bSuccess;
		}

		public bool ValidateMicrosoftTeams(string sOAuthDirectoryTenatID, string sOAuthClientID, string sOAuthClientSecret, string sOAuthAccessToken, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.MicrosoftTeams.Api.IMicrosoftTeams microsoftTeams = null;
				Spring.Social.MicrosoftTeams.Connect.MicrosoftTeamsServiceProvider microsoftTeamsServiceProvider = new Spring.Social.MicrosoftTeams.Connect.MicrosoftTeamsServiceProvider(sOAuthDirectoryTenatID, sOAuthClientID, sOAuthClientSecret);
				microsoftTeams = microsoftTeamsServiceProvider.GetApi(sOAuthAccessToken);
				IList<Spring.Social.MicrosoftTeams.Api.Team> teams = microsoftTeams.TeamOperations.GetAll();
#if DEBUG
				foreach ( Spring.Social.MicrosoftTeams.Api.Team team in teams )
				{
					Debug.WriteLine(team.Id + " " + team.DisplayName + ": " + team.Description);
				}
#endif
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}
	}
}
