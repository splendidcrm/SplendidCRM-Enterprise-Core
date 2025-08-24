/*
 * Copyright (C) 2025 SplendidCRM Software, Inc. All Rights Reserved. 
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
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Threading.Tasks;

using DuoUniversal;
using static SplendidCRM.Controllers.RestController;
using Microsoft.AspNetCore.Http;

// 08/07/2025 Paul.  Add support for DuoUniversal. 
namespace SplendidCRM.Controllers.Administration.Duo
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/DuoUniversal/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "DuoUniversal";
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpContext          Context            ;
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private SplendidCRM.Crm.Config           Config           = new SplendidCRM.Crm.Config();

		public RestController(IHttpContextAccessor httpContextAccessor, HttpSessionState Session, Security Security, SplendidError SplendidError)
		{
			this.Context             = httpContextAccessor.HttpContext;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = new Sql(Session, Security);
			this.SplendidError       = SplendidError      ;
		}


		private string GetDuoRedirectUrl()
		{
			string sServerScheme    = Sql.ToString(Application["ServerScheme"   ]);
			string sServerName      = Sql.ToString(Application["ServerName"     ]);
			string sApplicationPath = Sql.ToString(Application["ApplicationPath"]);
			string sServerPort      = Sql.ToString(Application["ServerPort"     ]);
			string sSiteURL         = sServerScheme + "://" + sServerName + sServerPort + sApplicationPath;
			if ( !sSiteURL.StartsWith("http") )
				sSiteURL = "http://" + sSiteURL;
			if ( !sSiteURL.EndsWith("/") )
				sSiteURL += "/";

			string sRedirectURL = sSiteURL;
			if ( sServerName != "localhost" )
			{
				sRedirectURL  = Config.SiteURL();
			}
			sRedirectURL += "React/Administration/DuoUniversal/ConfigView";
			return sRedirectURL;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public async Task<string> Test([FromBody] Dictionary<string, object> dict)
		{
			// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}

			string sCLIENT_ID     = String.Empty;
			string sCLIENT_SECRET = String.Empty;
			string sAPI_HOST_URL  = String.Empty;
			foreach ( string sKey in dict.Keys )
			{
				switch ( sKey )
				{
					case "DuoUniversal.ClientID"    :  sCLIENT_ID       = Sql.ToString (dict[sKey]);  break;
					case "DuoUniversal.ClientSecret":  sCLIENT_SECRET   = Sql.ToString (dict[sKey]);  break;
					case "DuoUniversal.ApiHostURL"  :  sAPI_HOST_URL    = Sql.ToString (dict[sKey]);  break;
				}
			}
			if ( sCLIENT_SECRET == Sql.sEMPTY_PASSWORD )
			{
				sCLIENT_SECRET = Sql.ToString (Application["CONFIG.DuoUniversal.ClientSecret"]);
			}
			if ( sAPI_HOST_URL == Sql.sEMPTY_PASSWORD )
			{
				sAPI_HOST_URL = Sql.ToString (Application["CONFIG.DuoUniversal.ApiHostURL"]);
			}

			string sRedirectURL = GetDuoRedirectUrl();
			Client duoClient = new DuoUniversal.ClientBuilder(sCLIENT_ID, sCLIENT_SECRET, sAPI_HOST_URL, sRedirectURL).Build();
			bool healthy = await duoClient.DoHealthCheck();
			if ( healthy )
			{
				string state = DuoUniversal.Client.GenerateState();
				Session["DuoUniversal.state"   ] = state;
				Session["DuoUniversal.username"] = Security.USER_NAME;
				string promptUri = duoClient.GenerateAuthUri(Security.USER_NAME, state);
				return promptUri;
			}
			else
			{
				throw(new Exception(L10n.Term("DuoUniversal.ERR_FAILED_HEALTH_CHECK")));
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public async Task<string> Verify([FromBody] LoginDuoParameters input)
		{
			HttpRequest request = Context.Request;
			// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}

			string sResult        = L10n.Term("DuoUniversal.LBL_TEST_FAILED");
			string sCLIENT_ID     = Sql.ToString (Application["CONFIG.DuoUniversal.ClientID"     ]);
			string sCLIENT_SECRET = Sql.ToString (Application["CONFIG.DuoUniversal.ClientSecret" ]);
			string sAPI_HOST_URL  = Sql.ToString (Application["CONFIG.DuoUniversal.ApiHostURL"   ]);
			
			string sDuoUniversalReceievedState = Sql.ToString(input.state);
			string sDuoUniversalReceivedCode   = Sql.ToString(input.code );
			if ( !Sql.IsEmptyString(sDuoUniversalReceievedState) && !Sql.IsEmptyString(sDuoUniversalReceivedCode) )
			{
				string sDuoUniversalSessionState    = Sql.ToString(Session["DuoUniversal.state"   ]);
				string sDuoUniversalSessionUsername = Sql.ToString(Session["DuoUniversal.username"]);
				Session.Remove("DuoUniversal.state"   );
				Session.Remove("DuoUniversal.username");
				if ( !Sql.IsEmptyString(sDuoUniversalSessionUsername) && !Sql.IsEmptyString(sDuoUniversalSessionState) )
				{
					if ( sDuoUniversalSessionState == sDuoUniversalReceievedState )
					{
						string sRedirectURL = GetDuoRedirectUrl();
						Client duoClient = new DuoUniversal.ClientBuilder(sCLIENT_ID, sCLIENT_SECRET, sAPI_HOST_URL, sRedirectURL).Build();
						IdToken token = await duoClient.ExchangeAuthorizationCodeFor2faResult(sDuoUniversalReceivedCode, sDuoUniversalSessionUsername);
						if ( token.AuthResult.Result == "allow" )
						{
							sResult = L10n.Term("DuoUniversal.LBL_TEST_SUCCESSFUL");
						}
						else
						{
							throw(new Exception(L10n.Term("DuoUniversal.ERR_LOGIN_DENIED")));
						}
					}
					else
					{
						throw(new Exception(L10n.Term("DuoUniversal.ERR_INVALID_SESSION_STATE")));
					}
				}
				else
				{
					throw(new Exception(L10n.Term("DuoUniversal.ERR_LOGIN_SESSION_HAS_EXPIRED")));
				}
			}
			return sResult;
		}
	}
}
