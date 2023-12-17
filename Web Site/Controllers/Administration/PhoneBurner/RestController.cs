/*
 * Copyright (C) 2019-2023 SplendidCRM Software, Inc. All Rights Reserved. 
 *
 * Any use of the contents of this file are subject to the SplendidCRM Professional Source Code License 
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
 */
using System;
using System.IO;
using System.Net;
using System.Web;
using System.Text;
using System.Text.Json;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Caching.Memory;

namespace SplendidCRM.Controllers.Administration.PhoneBurner
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/PhoneBurner/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "PhoneBurner";
		private IMemoryCache         memoryCache        ;
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private SyncError            SyncError          ;
		private Crm.Modules          Modules            ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private Spring.Social.PhoneBurner.PhoneBurnerSync PhoneBurnerSync;
		private IBackgroundTaskQueue taskQueue          ;

		public RestController(IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SyncError SyncError, SplendidCRM.Crm.Modules Modules, ExchangeSecurity ExchangeSecurity, Spring.Social.PhoneBurner.PhoneBurnerSync PhoneBurnerSync, IBackgroundTaskQueue taskQueue)
		{
			this.memoryCache         = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.SyncError           = SyncError          ;
			this.Modules             = Modules            ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.PhoneBurnerSync     = PhoneBurnerSync    ;
			this.taskQueue           = taskQueue          ;
			//ExchangeSecurity, SyncError, Modules
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Test([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				string sOAUTH_CLIENT_ID      = String.Empty;
				string sOAUTH_CLIENT_SECRET  = String.Empty;
				string sOAUTH_ACCESS_TOKEN   = String.Empty;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "PhoneBurner.ClientID"        :  sOAUTH_CLIENT_ID     = Sql.ToString (dict[sKey]);  break;
						case "PhoneBurner.ClientSecret"    :  sOAUTH_CLIENT_SECRET = Sql.ToString (dict[sKey]);  break;
						case "PhoneBurner.OAuthAccessToken":  sOAUTH_ACCESS_TOKEN  = Sql.ToString (dict[sKey]);  break;
					}
				}
				// 01/18/2021 Paul.  ClientSecret and AccessToken will be empty as they are not typically sent to React Client. 
				if ( sOAUTH_CLIENT_ID == Sql.sEMPTY_PASSWORD || Sql.IsEmptyString(sOAUTH_CLIENT_ID) )
				{
					sOAUTH_CLIENT_ID = Sql.ToString(Application["CONFIG.PhoneBurner.ClientID"]);
				}
				if ( sOAUTH_CLIENT_SECRET == Sql.sEMPTY_PASSWORD || Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) )
				{
					sOAUTH_CLIENT_SECRET = Sql.ToString(Application["CONFIG.PhoneBurner.ClientSecret"]);
				}
				if ( sOAUTH_ACCESS_TOKEN == Sql.sEMPTY_PASSWORD || Sql.IsEmptyString(sOAUTH_ACCESS_TOKEN) )
				{
					sOAUTH_ACCESS_TOKEN = Sql.ToString(Application["CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthAccessToken"]);
				}
				PhoneBurnerSync.ValidatePhoneBurner(sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, sOAUTH_ACCESS_TOKEN, sbErrors);
				if ( sbErrors.Length == 0 )
				{
					sbErrors.Append(L10n.Term("PhoneBurner.LBL_TEST_SUCCESSFUL"));
				}
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public async Task<string> Sync([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
#if false
				PhoneBurnerSync.Sync();
#else
				await taskQueue.QueueBackgroundWorkItemAsync(PhoneBurnerSync.Sync);
				sbErrors.Append(L10n.Term("PhoneBurner.LBL_SYNC_BACKGROUND"));
#endif
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public async Task<string> SyncAll([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
#if false
				PhoneBurnerSync.SyncAll();
#else
				await taskQueue.QueueBackgroundWorkItemAsync(PhoneBurnerSync.SyncAll);
				sbErrors.Append(L10n.Term("PhoneBurner.LBL_SYNC_BACKGROUND"));
#endif
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public Spring.Social.PhoneBurner.RefreshToken GetAccessToken([FromBody] Dictionary<string, object> dict)
		{
			Spring.Social.PhoneBurner.RefreshToken token = null;
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				string sCode          = String.Empty;
				string sRedirectURL   = String.Empty;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "code"         :  sCode         = Sql.ToString (dict[sColumnName]);  break;
						case "redirect_url" :  sRedirectURL  = Sql.ToString (dict[sColumnName]);  break;
					}
				}
				
				string sOAUTH_CLIENT_ID     = Sql.ToString(Application["CONFIG.PhoneBurner.ClientID"        ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString(Application["CONFIG.PhoneBurner.ClientSecret"    ]);
				// https://www.phoneburner.com/developer/authentication
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create("https://www.phoneburner.com/oauth/accesstoken");
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.KeepAlive         = false;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout           = 120000;  // 120 seconds
				objRequest.ContentType       = "application/x-www-form-urlencoded";
				objRequest.Method            = "POST";
				
				// 09/12/2020 Paul.  React does not have a good way to expose a method, so just redirect with the code in the url. 
				//if ( Sql.IsEmptyString(RedirectURL) )
					sRedirectURL = Request.Scheme + "://" + Request.Host.Host + Sql.ToString(Application["rootURL"]) + "Administration/PhoneBurner/OAuthLanding.aspx";
				string sData = "grant_type=authorization_code&client_id=" + sOAUTH_CLIENT_ID + "&client_secret=" + sOAUTH_CLIENT_SECRET + "&code=" + sCode + "&redirect_uri=" + HttpUtility.UrlEncode(sRedirectURL);
				objRequest.ContentLength = sData.Length;
				using ( StreamWriter stm = new StreamWriter(objRequest.GetRequestStream(), System.Text.Encoding.ASCII) )
				{
					stm.Write(sData);
				}
				
				string sResponse = String.Empty;
				using ( HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse() )
				{
					if ( objResponse != null )
					{
						if ( objResponse.StatusCode != HttpStatusCode.OK && objResponse.StatusCode != HttpStatusCode.Found )
						{
							throw(new Exception(objResponse.StatusCode + " " + objResponse.StatusDescription));
						}
						else
						{
							using ( StreamReader stm = new StreamReader(objResponse.GetResponseStream()) )
							{
								sResponse = stm.ReadToEnd();
								token = JsonSerializer.Deserialize<Spring.Social.PhoneBurner.RefreshToken>(sResponse);
								DateTime dtOAUTH_EXPIRES_AT = DateTime.Now.AddSeconds(token.expires_in);
								token.expires_at = RestUtil.ToJsonDate(dtOAUTH_EXPIRES_AT);
								// 09/12/2020 Paul.  PhoneBurner users each have their own account. 
								SqlProcs.spOAUTH_TOKENS_Update(Security.USER_ID, "PhoneBurner", token.access_token, String.Empty, dtOAUTH_EXPIRES_AT, token.refresh_token);
								Application["CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthAccessToken" ] = token.access_token ;
								Application["CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthRefreshToken"] = token.refresh_token;
								Application["CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthExpiresAt"   ] = dtOAUTH_EXPIRES_AT.ToShortDateString() + " " + dtOAUTH_EXPIRES_AT.ToShortTimeString();
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw(new Exception(ex.Message));
			}
			return token;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public Spring.Social.PhoneBurner.RefreshToken RefreshToken()
		{
			Spring.Social.PhoneBurner.RefreshToken token = null;
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
			
				PhoneBurnerSync.RefreshAccessToken(sbErrors);
				if ( sbErrors.Length == 0 )
				{
					token = new Spring.Social.PhoneBurner.RefreshToken();
					token.access_token  = Sql.ToString (Application["CONFIG.PhoneBurner.OAuthAccessToken" ]);
					token.refresh_token = Sql.ToString (Application["CONFIG.PhoneBurner.OAuthRefreshToken"]);
					token.expires_at    = Sql.ToString (Application["CONFIG.PhoneBurner.OAuthExpiresAt"   ]);
				}
				else
				{
					throw(new Exception(sbErrors.ToString()));
				}
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw(new Exception(ex.Message));
			}
			return token;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string IsAuthenticated()
		{
			string sOAUTH_EXPIRES_AT = String.Empty;
			try
			{
				Guid     gTIMEZONE = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
				TimeZone T10n      = TimeZone.CreateTimeZone(gTIMEZONE);
				if ( !Security.IsAuthenticated() )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				DateTime dtOAUTH_EXPIRES_AT = DateTime.MinValue;
				try
				{
					if ( !Sql.IsEmptyString(Application["CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthExpiresAt"]) )
					{
						dtOAUTH_EXPIRES_AT = Sql.ToDateTime(Application["CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthExpiresAt"]);
					}
				}
				catch
				{
				}
				if ( dtOAUTH_EXPIRES_AT < DateTime.Now )
				{
					Application.Remove("CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthAccessToken" );
					Application.Remove("CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthRefreshToken");
					Application.Remove("CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthExpiresAt"   );
				}
				else
				{
					sOAUTH_EXPIRES_AT  = RestUtil.ToJsonDate(dtOAUTH_EXPIRES_AT);
				}
				dtOAUTH_EXPIRES_AT = SplendidCache.GetOAuthTokenExpiresAt("PhoneBurner", Security.USER_ID);
				if ( dtOAUTH_EXPIRES_AT != DateTime.MinValue )
				{
					sOAUTH_EXPIRES_AT  = RestUtil.ToJsonDate(dtOAUTH_EXPIRES_AT);
				}
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw(new Exception(ex.Message));
			}
			return sOAUTH_EXPIRES_AT;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string BeginDialSession([FromBody] Dictionary<string, object> dict)
		{
			string redirect_url = String.Empty;
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if ( !Security.IsAuthenticated() )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				DateTime dtOAUTH_EXPIRES_AT = DateTime.MinValue;
				try
				{
					if ( !Sql.IsEmptyString(Application["CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthExpiresAt"]) )
					{
						dtOAUTH_EXPIRES_AT = Sql.ToDateTime(Application["CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthExpiresAt"]);
					}
				}
				catch
				{
				}
				if ( dtOAUTH_EXPIRES_AT < DateTime.Now )
				{
					Application.Remove("CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthAccessToken" );
					Application.Remove("CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthRefreshToken");
					Application.Remove("CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthExpiresAt"   );
				}
				string sOAuthAccessToken = Sql.ToString(Application["CONFIG.PhoneBurner." + Security.USER_ID.ToString() + ".OAuthAccessToken" ]);
				if ( Sql.IsEmptyString(sOAuthAccessToken) )
				{
					throw(new Exception(L10n.Term("PhoneBurner.ERR_AUTHORIZATION_EXPIRED")));
				}
				
				string sMODULE_NAME = "Contacts";
				List<string> arrID = new List<string>();
				if ( dict.ContainsKey("MODULE_NAME") )
					sMODULE_NAME = Sql.ToString(dict["MODULE_NAME"]);
				if ( dict.ContainsKey("ID") )
				{
					if ( dict["ID"] is System.Collections.ArrayList )
					{
						System.Collections.ArrayList lst = dict["ID"] as System.Collections.ArrayList;
						foreach ( string item in lst )
						{
							arrID.Add(item);
						}
					}
				}
				
				if ( arrID.Count == 0 )
				{
					throw(new Exception(L10n.Term(".LBL_LISTVIEW_NO_SELECTED")));
				}
				Spring.Social.PhoneBurner.DialSession dialSession = new Spring.Social.PhoneBurner.DialSession(memoryCache, Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, Modules, PhoneBurnerSync);
				redirect_url = dialSession.CreateSession(Security.USER_ID, sMODULE_NAME, arrID);
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw(new Exception(ex.Message));
			}
			return redirect_url;
		}

	}
}
