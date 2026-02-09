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
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using SplendidCRM;

namespace SplendidCRM.Controllers.Administration.ReplicationTables
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/ReplicationTables/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "ReplicationTables";
		private IMemoryCache         memoryCache        ;
		private SplendidCRM.DbReplicationFactories  DbReplicationFactories = new SplendidCRM.DbReplicationFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SplendidError        SplendidError      ;
		private RestUtil             RestUtil           ;
		private ReplicationExternalDB ReplicationExternalDB;

		public RestController(IMemoryCache memoryCache, HttpSessionState Session, Security Security, SplendidError SplendidError, RestUtil RestUtil, ReplicationExternalDB ReplicationExternalDB)
		{
			this.memoryCache         = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = new Sql(Session, Security);
			this.SplendidError       = SplendidError      ;
			this.RestUtil            = RestUtil           ;
			this.ReplicationExternalDB   = ReplicationExternalDB  ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public void RunSync([FromQuery] string TABLE_NAME, [FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "ReplicationTables";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			try
			{
				DbProviderFactory dbfReplication = DbReplicationFactories.GetFactory();
				if ( !Sql.IsEmptyString(Application["ReplicationConnectionString"]) )
				{
					string sTABLE_NAME = Sql.ToString(TABLE_NAME);
#if DEBUG
					ReplicationExternalDB.RunReplication(sTABLE_NAME);
#else
					ReplicationBackground background = new ReplicationBackground(sTABLE_NAME);
					System.Threading.Thread t = new System.Threading.Thread(background.Start);
					t.Start();
#endif
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public void BulkRunSync([FromBody] Dictionary<string, object> dict)
		{
			ArrayList arrTABLE_NAME = dict["NAME_LIST"] as ArrayList;
			string sModuleName = "ReplicationTables";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			try
			{
				DbProviderFactory dbfReplication = DbReplicationFactories.GetFactory();
				if ( !Sql.IsEmptyString(Application["ReplicationConnectionString"]) )
				{
					foreach ( string sTABLE_NAME in arrTABLE_NAME )
					{
						ReplicationBackground background = new ReplicationBackground(ReplicationExternalDB, sTABLE_NAME);
						System.Threading.Thread t = new System.Threading.Thread(background.Start);
						t.Start();
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public void UpdateStats([FromQuery] string TABLE_NAME, [FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "ReplicationTables";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			try
			{
				DbProviderFactory dbfReplication = DbReplicationFactories.GetFactory();
				if ( !Sql.IsEmptyString(Application["ReplicationConnectionString"]) )
				{
					string sTABLE_NAME = Sql.ToString(TABLE_NAME);
					ReplicationExternalDB.UpdateStats(sTABLE_NAME);
				}
				else
				{
					throw(new Exception("Replication not configured"));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public void BulkUpdateStats([FromBody] Dictionary<string, object> dict)
		{
			ArrayList arrTABLE_NAME = dict["NAME_LIST"] as ArrayList;
			string sModuleName = "ReplicationTables";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			try
			{
				DbProviderFactory dbfReplication = DbReplicationFactories.GetFactory();
				if ( !Sql.IsEmptyString(Application["ReplicationConnectionString"]) )
				{
					StringBuilder sbErrors = new StringBuilder();
					foreach ( string sTABLE_NAME in arrTABLE_NAME )
					{
						try
						{
							ReplicationExternalDB.UpdateStats(sTABLE_NAME);
						}
						catch(Exception ex)
						{
							sbErrors.AppendLine(ex.Message);
						}
					}
					if ( sbErrors.Length > 0 )
					{
						throw(new Exception(sbErrors.ToString()));
					}
				}
				else
				{
					throw(new Exception("Replication not configured"));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
		}

		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetByTableName(string TABLE_NAME)
		{
			// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
			if ( !Security.IsAuthenticated() || !(Security.IS_ADMIN || Security.IS_ADMIN_DELEGATE) )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			
			string ModuleName = "ReplicationTables";
			string sTABLE_NAME = Sql.ToString(Application["Modules." + ModuleName + ".TableName"]);
			if ( !Sql.IsEmptyString(ModuleName) )
			{
				bool bIsAdmin = Sql.ToBoolean(Application["Modules." + ModuleName + ".IsAdmin"]);
				if ( bIsAdmin && Security.AdminUserAccess(ModuleName, "access") >= 0 )
				{
					string sFILTER = "TABLE_NAME eq '" + Sql.EscapeSQL(TABLE_NAME) + "'";
					long lTotalCount = 0;
					// 10/26/2019 Paul.  Return the SQL to the React Client. 
					StringBuilder sbDumpSQL = new StringBuilder();
					// 12/16/2019 Paul.  Moved GetTable to ~/_code/RestUtil.cs
					// 10/16/2020 Paul.  Use AccessMode.list so that we use the _List view if available. 
					DataTable dt = RestUtil.GetAdminTable(sTABLE_NAME, 0, 1, sFILTER, String.Empty, String.Empty, null, null, ref lTotalCount, null, AccessMode.edit, sbDumpSQL);
					if ( dt == null || dt.Rows.Count == 0 )
						throw(new Exception("Table not found: " + ModuleName + " " + TABLE_NAME));
			
					Guid     gTIMEZONE         = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
					TimeZone T10n              = TimeZone.CreateTimeZone(gTIMEZONE);
					// 04/01/2020 Paul.  Move json utils to RestUtil. 
					string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
					Dictionary<string, object> dict = RestUtil.ToJson(sBaseURI, ModuleName, dt.Rows[0], T10n);
					
					// 10/26/2019 Paul.  Return the SQL to the React Client. 
					if ( Sql.ToBoolean(Application["CONFIG.show_sql"]) )
					{
						dict.Add("__sql", sbDumpSQL.ToString());
					}
					return dict;
				}
				else
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
			}
			else
			{
				throw(new Exception("Unsupported table: " + sTABLE_NAME));
			}
		}
	}
}
