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
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Threading.Tasks;

namespace SplendidCRM.Controllers.Administration.Watson
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/Watson/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "Watson";
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private Spring.Social.Watson.WatsonSync WatsonSync;
		private IBackgroundTaskQueue taskQueue          ;

		public RestController(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, Spring.Social.Watson.WatsonSync WatsonSync, IBackgroundTaskQueue taskQueue)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.WatsonSync          = WatsonSync         ;
			this.taskQueue           = taskQueue          ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Test([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if (!Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0)
				{
					throw (new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}

				// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
				// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
				string sOAUTH_REGION         = String.Empty;
				string sOAUTH_POD_NUMBER     = String.Empty;
				string sOAUTH_CLIENT_ID      = String.Empty;
				string sOAUTH_CLIENT_SECRET  = String.Empty;
				string sOAUTH_ACCESS_TOKEN   = String.Empty;
				foreach (string sKey in dict.Keys)
				{
					switch (sKey)
					{
						// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
						// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
						case "Watson.Region":
							sOAUTH_REGION = Sql.ToString(dict[sKey]);
							break;
						case "Watson.PodNumber":
							sOAUTH_POD_NUMBER = Sql.ToString(dict[sKey]);
							break;
						case "Watson.ClientID":
							sOAUTH_CLIENT_ID = Sql.ToString(dict[sKey]);
							break;
						case "Watson.ClientSecret":
							sOAUTH_CLIENT_SECRET = Sql.ToString(dict[sKey]);
							break;
						case "Watson.OAuthAccessToken":
							sOAUTH_ACCESS_TOKEN = Sql.ToString(dict[sKey]);
							break;
					}
				}
				// 03/10/2021 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
				if (Sql.IsEmptyString(sOAUTH_CLIENT_ID) || sOAUTH_CLIENT_ID == Sql.sEMPTY_PASSWORD)
				{
					sOAUTH_CLIENT_ID = Sql.ToString(Application["CONFIG.Watson.ClientID"]);
				}
				if (Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) || sOAUTH_CLIENT_SECRET == Sql.sEMPTY_PASSWORD)
				{
					sOAUTH_CLIENT_SECRET = Sql.ToString(Application["CONFIG.Watson.ClientSecret"]);
				}
				if (Sql.IsEmptyString(sOAUTH_ACCESS_TOKEN) || sOAUTH_ACCESS_TOKEN == Sql.sEMPTY_PASSWORD)
				{
					sOAUTH_ACCESS_TOKEN = Sql.ToString(Application["CONFIG.Watson.OAuthAccessToken"]);
				}
				// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
				// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
				WatsonSync.ValidateWatson(sOAUTH_REGION, sOAUTH_POD_NUMBER, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, sOAUTH_ACCESS_TOKEN, sbErrors);
				if (sbErrors.Length == 0)
				{
					sbErrors.Append(L10n.Term("Watson.LBL_TEST_SUCCESSFUL"));
				}
			}
			catch (Exception ex)
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
				if (!Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0)
				{
					throw (new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}

#if false
				WatsonSync.Sync();
#else
				await taskQueue.QueueBackgroundWorkItemAsync(WatsonSync.Sync);
				sbErrors.Append(L10n.Term("Watson.LBL_SYNC_BACKGROUND"));
#endif
			}
			catch (Exception ex)
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
				if (!Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0)
				{
					throw (new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}

#if false
				WatsonSync.SyncAll();
#else
				await taskQueue.QueueBackgroundWorkItemAsync(WatsonSync.SyncAll);
				sbErrors.Append(L10n.Term("Watson.LBL_SYNC_BACKGROUND"));
#endif
			}
			catch (Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string RefreshToken()
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if (!Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0)
				{
					throw (new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}

				WatsonSync.RefreshAccessToken(sbErrors);

				if (sbErrors.Length == 0)
					sbErrors.Append(L10n.Term("Watson.LBL_TEST_SUCCESSFUL"));
			}
			catch (Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string GetAccessToken([FromBody] Dictionary<string, object> dict)
		{
			string sOAUTH_REFRESH_TOKEN = String.Empty;
			StringBuilder sbErrors = new StringBuilder();
			try
			{

				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if (!Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0)
				{
					throw (new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}

				string sCode          = String.Empty;
				string sRedirectURL   = String.Empty;
				foreach (string sColumnName in dict.Keys)
				{
					switch (sColumnName)
					{
						case "code":
							sCode = Sql.ToString(dict[sColumnName]);
							break;
						case "redirect_url":
							sRedirectURL = Sql.ToString(dict[sColumnName]);
							break;
					}
				}

				string sOAUTH_REGION        = Sql.ToString(Application["CONFIG.Watson.Region"          ]);
				string sOAUTH_POD_NUMBER    = Sql.ToString(Application["CONFIG.Watson.PodNumber"       ]);
				string sOAUTH_CLIENT_ID     = Sql.ToString(Application["CONFIG.Watson.ClientID"        ]);
				string sOAUTH_CLIENT_SECRET = Sql.ToString(Application["CONFIG.Watson.ClientSecret"    ]);
				string sOAUTH_ACCESS_TOKEN  = Sql.ToString(Application["CONFIG.Watson.OAuthAccessToken"]);
				//HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create("https://api" + sOAUTH_POD_NUMBER + ".silverpop.com/oauth/token");
				// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
				// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
				HttpWebRequest objRequest = (HttpWebRequest) WebRequest.Create("https://api-campaign-" + sOAUTH_REGION + "-" + sOAUTH_POD_NUMBER + ".goacoustic.com/oauth/token");
				objRequest.Headers.Add("cache-control", "no-cache");
				objRequest.KeepAlive = false;
				objRequest.AllowAutoRedirect = false;
				objRequest.Timeout = 120000;  // 120 seconds
				objRequest.ContentType = "application/x-www-form-urlencoded";
				objRequest.Method = "POST";

				sRedirectURL = Request.Scheme + "://" + Request.Host.Host + Sql.ToString(Application["rootURL"]) + "Administration/Watson/ConfigView";
				string sData = "grant_type=authorization_code&client_id=" + sOAUTH_CLIENT_ID + "&client_secret=" + sOAUTH_CLIENT_SECRET + "&code=" + sCode + "&redirect_uri=" + HttpUtility.UrlEncode(sRedirectURL);
				objRequest.ContentLength = sData.Length;
				using (StreamWriter stm = new StreamWriter(objRequest.GetRequestStream(), System.Text.Encoding.ASCII))
				{
					stm.Write(sData);
				}

				using (HttpWebResponse objResponse = (HttpWebResponse) objRequest.GetResponse())
				{
					if (objResponse != null)
					{
						if (objResponse.StatusCode != HttpStatusCode.OK && objResponse.StatusCode != HttpStatusCode.Found)
						{
							throw (new Exception(objResponse.StatusCode + " " + objResponse.StatusDescription));
						}
						else
						{
							using (StreamReader stm = new StreamReader(objResponse.GetResponseStream()))
							{
								string sResponse = stm.ReadToEnd();
								Spring.Social.Watson.RefreshToken token = JsonSerializer.Deserialize<Spring.Social.Watson.RefreshToken>(sResponse);
								sOAUTH_REFRESH_TOKEN = token.refresh_token;
								Application["CONFIG.Watson.OAuthRefreshToken"] = sOAUTH_REFRESH_TOKEN;
								SqlProcs.spCONFIG_Update("system", "Watson.OAuthRefreshToken", Sql.ToString(Application["CONFIG.Watson.OAuthRefreshToken"]));
							}
						}
					}
				}
			}
			catch (Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw (new Exception(ex.Message));
			}
			return sOAUTH_REFRESH_TOKEN;
		}

		[HttpGet("[action]")]
		public string GetDatabaseName(string DatabaseID)
		{
			if (!Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0)
			{
				throw (new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}

			string sDatabaseName = String.Empty;
			StringBuilder sbErrors = new StringBuilder();
			WatsonSync.RefreshAccessToken(sbErrors);
			if (sbErrors.Length == 0)
			{
				Spring.Social.Watson.Api.IWatson watson = WatsonSync.CreateApi();
				Spring.Social.Watson.Api.Database database = watson.DatabaseOperations.GetById(DatabaseID);
				sDatabaseName = database.NAME;
			}
			else
			{
				throw (new Exception(sbErrors.ToString()));
			}
			return sDatabaseName;
		}

		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetDatabaseList()
		{
			;
			if (!Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0)
			{
				throw (new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}

			IList<Spring.Social.Watson.Api.Database> databases = new List<Spring.Social.Watson.Api.Database>();
			bool bWatsonEnabled = WatsonSync.WatsonEnabled();
			if (bWatsonEnabled)
			{
				StringBuilder sbErrors = new StringBuilder();
				WatsonSync.RefreshAccessToken(sbErrors);
				if (sbErrors.Length == 0)
				{
					Spring.Social.Watson.Api.IWatson watson = WatsonSync.CreateApi();
					databases = watson.DatabaseOperations.GetAll();
				}
				else
				{
					throw (new Exception(sbErrors.ToString()));
				}
			}
			Dictionary<string, object> d = new Dictionary<string, object>();
			d.Add("d", databases);
			return d;
		}
	}
}
