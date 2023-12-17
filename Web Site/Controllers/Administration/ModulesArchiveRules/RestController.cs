/*
 * Copyright (C) 2013-2023 SplendidCRM Software, Inc. All Rights Reserved. 
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
using System.Data;
using System.Data.Common;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Administration.ModulesArchiveRules
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/ModulesArchiveRules/Rest.svc")]
	public class RestController : ControllerBase
	{
		private IHttpContextAccessor httpContextAccessor;
		private IWebHostEnvironment  hostingEnvironment ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private RestUtil             RestUtil           ;
		private XmlUtil              XmlUtil            ;
		private QueryBuilder         QueryBuilder       ;
		private SplendidCRM.Crm.Modules          Modules          ;

		public RestController(IHttpContextAccessor httpContextAccessor, IWebHostEnvironment hostingEnvironment, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, RestUtil RestUtil, XmlUtil XmlUtil, QueryBuilder QueryBuilder, SplendidCRM.Crm.Modules Modules)
		{
			this.httpContextAccessor = httpContextAccessor;
			this.hostingEnvironment  = hostingEnvironment ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.RestUtil            = RestUtil           ;
			this.XmlUtil             = XmlUtil            ;
			this.QueryBuilder        = QueryBuilder       ;
			this.Modules             = Modules            ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public Guid UpdateModule([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "ModulesArchiveRules";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			string sTableName = Sql.ToString(Application["Modules." + sModuleName + ".TableName"]);
			if ( Sql.IsEmptyString(sTableName) )
				throw(new Exception("Unknown module: " + sModuleName));

			bool bPrimaryKeyOnly   = true ;
			bool bUseSQLParameters = false;
			bool bDesignChart      = false;
			bool bUserSpecific     = false;
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, bDesignChart);
			Guid   gID                = Guid.Empty  ;
			string sNAME              = String.Empty;
			string sMODULE            = String.Empty;
			string sRELATED           = String.Empty;
			Dictionary<string, object> dictFilterXml        = null;
			Dictionary<string, object> dictRelatedModuleXml = null;
			Dictionary<string, object> dictRelationshipXml  = null;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "ID"               :  gID                  = Sql.ToGuid  (dict[sColumnName]);  break;
					case "NAME"             :  sNAME                = Sql.ToString(dict[sColumnName]);  break;
					// 02/09/2022 Paul.  Keep using MODULE to match Reports. 
					case "MODULE"           :  sMODULE              = Sql.ToString(dict[sColumnName]);  break;
					// 08/12/2023 Paul.  Must keep MODULE_NAME as that is what is used by RulesWizard.EditView. 
					case "MODULE_NAME"      :  sMODULE              = Sql.ToString(dict[sColumnName]);  break;
					case "filterXml"        :  dictFilterXml        = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relatedModuleXml" :  dictRelatedModuleXml = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relationshipXml"  :  dictRelationshipXml  = dict[sColumnName] as Dictionary<string, object>;  break;
				}
			}
			// 05/16/2021 Paul.  Precheck access to filter module. 
			nACLACCESS = Security.GetUserAccess(sMODULE, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sMODULE + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sMODULE));
			}
			rdl.SetCustomProperty             ("Module"        , sMODULE     );
			rdl.SetCustomProperty             ("Related"       , sRELATED    );
			// 06/02/2021 Paul.  React client needs to share code. 
			rdl.SetFiltersCustomProperty      (dictFilterXml       );
			rdl.SetRelatedModuleCustomProperty(dictRelatedModuleXml);
			rdl.SetRelationshipCustomProperty (dictRelationshipXml );
			
			Hashtable hashAvailableModules = new Hashtable();
			StringBuilder sbErrors = new StringBuilder();
			string sReportSQL = String.Empty;
			sReportSQL = QueryBuilder.BuildReportSQL(Application, rdl, bPrimaryKeyOnly, bUseSQLParameters, bDesignChart, bUserSpecific, sMODULE, sRELATED, hashAvailableModules, sbErrors);
			if ( sbErrors.Length > 0 )
				throw(new Exception(sbErrors.ToString()));
			
			rdl.SetDataSetFields(hashAvailableModules);
			rdl.SetSingleNode("DataSets/DataSet/Query/CommandText", sReportSQL);
			// 06/06/2021 Paul.  Keys may already exist in dictionary, so assign instead. 
			dict["FILTER_SQL"] = sReportSQL  ;
			dict["FILTER_XML"] = rdl.OuterXml;

			// 06/21/2021 Paul.  Move bExcludeSystemTables to method parameter so that it can be used by admin REST methods. 
			gID = RestUtil.UpdateTable(sTableName, dict, false);
			if ( dict.ContainsKey("NAME") )
			{
				string sName = String.Empty;
				if ( dict.ContainsKey("NAME") )
					sName = Sql.ToString(dict["NAME"]);
				try
				{
					if ( !Sql.IsEmptyString(sName) )
						SqlProcs.spTRACKER_Update(Security.USER_ID, sModuleName, gID, sName, "save");
				}
				catch(Exception ex)
				{
					// 04/28/2019 Paul.  There is no compelling reason to send this error to the user. 
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				}
			}
			return gID;
		}

		[HttpPost("[action]")]
		public Dictionary<string, object> GetPreviewFilter([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "ModulesArchiveRules";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			string sTableName = Sql.ToString(Application["Modules." + sModuleName + ".TableName"]);
			if ( Sql.IsEmptyString(sTableName) )
				throw(new Exception("Unknown module: " + sModuleName));

			bool bPrimaryKeyOnly   = true ;
			bool bUseSQLParameters = false;
			bool bDesignChart      = false;
			bool bUserSpecific     = false;
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, bDesignChart);
			Guid   gID                = Guid.Empty  ;
			string sNAME              = String.Empty;
			string sMODULE            = String.Empty;
			string sRELATED           = String.Empty;
			Dictionary<string, object> dictFilterXml        = null;
			Dictionary<string, object> dictRelatedModuleXml = null;
			Dictionary<string, object> dictRelationshipXml  = null;
			int    nSKIP              = Sql.ToInteger(Request.Query["$skip"     ]);
			int    nTOP               = Sql.ToInteger(Request.Query["$top"      ]);
			string sORDER_BY          = Sql.ToString (Request.Query["$orderby"  ]);
			string sSELECT            = Sql.ToString (Request.Query["$select"   ]);
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "NAME"             :  sNAME                = Sql.ToString(dict[sColumnName]);  break;
					// 02/09/2022 Paul.  Keep using MODULE to match Reports. 
					case "MODULE"           :  sMODULE              = Sql.ToString(dict[sColumnName]);  break;
					// 08/12/2023 Paul.  Must keep MODULE_NAME as that is what is used by RulesWizard.EditView. 
					case "MODULE_NAME"      :  sMODULE              = Sql.ToString(dict[sColumnName]);  break;
					case "filterXml"        :  dictFilterXml        = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relatedModuleXml" :  dictRelatedModuleXml = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relationshipXml"  :  dictRelationshipXml  = dict[sColumnName] as Dictionary<string, object>;  break;
					case "$skip"            :  nSKIP                = Sql.ToInteger(dict[sColumnName]);  break;
					case "$top"             :  nTOP                 = Sql.ToInteger(dict[sColumnName]);  break;
					case "$orderby"         :  sORDER_BY            = Sql.ToString (dict[sColumnName]);  break;
					case "$select"          :  sSELECT              = Sql.ToString (dict[sColumnName]);  break;
				}
			}
			// 05/16/2021 Paul.  Precheck access to filter module. 
			nACLACCESS = Security.AdminUserAccess(sMODULE, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sMODULE + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sMODULE));
			}
			rdl.SetCustomProperty              ("Module"        , sMODULE );
			rdl.SetCustomProperty              ("Related"       , sRELATED);
			// 06/02/2021 Paul.  React client needs to share code. 
			rdl.SetFiltersCustomProperty       (dictFilterXml       );
			rdl.SetRelatedModuleCustomProperty (dictRelatedModuleXml);
			rdl.SetRelationshipCustomProperty  (dictRelationshipXml );
			
			Hashtable hashAvailableModules = new Hashtable();
			StringBuilder sbErrors = new StringBuilder();
			string sReportSQL = String.Empty;
			sReportSQL = QueryBuilder.BuildReportSQL(Application, rdl, bPrimaryKeyOnly, bUseSQLParameters, bDesignChart, bUserSpecific, sMODULE, sRELATED, hashAvailableModules, sbErrors);
			if ( sbErrors.Length > 0 )
				throw(new Exception(sbErrors.ToString()));
			
			long     lTotalCount = 0;
			Guid     gTIMEZONE         = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone T10n              = TimeZone.CreateTimeZone(gTIMEZONE);
			string   sBaseURI    = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value.Replace("/GetModuleList", "/GetModuleItem");
			
			Regex r = new Regex(@"[^A-Za-z0-9_]");
			UniqueStringCollection arrSELECT = new UniqueStringCollection();
			sSELECT = sSELECT.Replace(" ", "");
			if ( !Sql.IsEmptyString(sSELECT) )
			{
				foreach ( string s in sSELECT.Split(',') )
				{
					string sColumnName = r.Replace(s, "");
					if ( !Sql.IsEmptyString(sColumnName) )
						arrSELECT.Add(sColumnName);
				}
			}
			
			string sLastCommand = String.Empty;
			StringBuilder sbDumpSQL = new StringBuilder();
			DataTable dt = new DataTable();
			string sTABLE_NAME = Modules.TableName(sMODULE);
			string sVIEW_NAME = "vw" + sTABLE_NAME + "_List";
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					string sSelectSQL = String.Empty;
					if ( arrSELECT != null && arrSELECT.Count > 0 )
					{
						foreach ( string sColumnName in arrSELECT )
						{
							if ( Sql.IsEmptyString(sSelectSQL) )
								sSelectSQL += "select " + sVIEW_NAME + "." + sColumnName + ControlChars.CrLf;
							else
								sSelectSQL += "     , " + sVIEW_NAME + "." + sColumnName + ControlChars.CrLf;
						}
					}
					else
					{
						sSelectSQL = "select " + sVIEW_NAME + ".*" + ControlChars.CrLf;
					}
					cmd.CommandText = sSelectSQL;
					cmd.CommandText += "  from " + sVIEW_NAME + ControlChars.CrLf;
					Security.Filter(cmd, sMODULE, "list");
					if ( !Sql.IsEmptyString(sReportSQL) )
					{
						cmd.CommandText += "   and ID in " + ControlChars.CrLf 
						                + "(" + sReportSQL + ")" + ControlChars.CrLf;
					}
					if ( Sql.IsEmptyString(sORDER_BY.Trim()) )
					{
						sORDER_BY = " order by " + sVIEW_NAME + ".DATE_MODIFIED_UTC" + ControlChars.CrLf;
					}
					else
					{
						r = new Regex(@"[^A-Za-z0-9_, ]");
						sORDER_BY = " order by " + r.Replace(sORDER_BY, "") + ControlChars.CrLf;
					}
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						dt = new DataTable(sTABLE_NAME);
						if ( nTOP > 0 )
						{
							lTotalCount = -1;
							if ( cmd.CommandText.StartsWith(sSelectSQL) )
							{
								string sOriginalSQL = cmd.CommandText;
								cmd.CommandText = "select count(*) " + ControlChars.CrLf + cmd.CommandText.Substring(sSelectSQL.Length);
								sLastCommand += Sql.ExpandParameters(cmd) + ';' + ControlChars.CrLf;
								lTotalCount = Sql.ToLong(cmd.ExecuteScalar());
								cmd.CommandText = sOriginalSQL;
							}
							if ( nSKIP > 0 )
							{
								int nCurrentPageIndex = nSKIP / nTOP;
								Sql.PageResults(cmd, sTABLE_NAME, sORDER_BY, nCurrentPageIndex, nTOP);
								sLastCommand += Sql.ExpandParameters(cmd);
								da.Fill(dt);
							}
							else
							{
								cmd.CommandText += sORDER_BY;
								using ( DataSet ds = new DataSet() )
								{
									ds.Tables.Add(dt);
									sLastCommand += Sql.ExpandParameters(cmd);
									da.Fill(ds, 0, nTOP, sTABLE_NAME);
								}
							}
						}
						else
						{
							cmd.CommandText += sORDER_BY;
							sLastCommand = Sql.ExpandParameters(cmd);
							da.Fill(dt);
							lTotalCount = dt.Rows.Count;
						}
						sbDumpSQL.Append(sLastCommand);
					}
				}
			}
			
			Dictionary<string, object> dictResponse = RestUtil.ToJson(sBaseURI, sMODULE, dt, T10n);
			dictResponse.Add("__total", lTotalCount);
			if ( Sql.ToBoolean(Application["CONFIG.show_sql"]) )
			{
				dictResponse.Add("__sql", sbDumpSQL.ToString());
			}
			return dictResponse;
		}
	}
}
