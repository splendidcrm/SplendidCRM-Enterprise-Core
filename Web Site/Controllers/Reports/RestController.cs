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
using System.Xml;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using System.Collections;
using System.Collections.Generic;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Reports
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Reports/Rest.svc")]
	public partial class RestController : ControllerBase
	{
		private IHttpContextAccessor httpContextAccessor;
		private IWebHostEnvironment  hostingEnvironment ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SqlProcs             SqlProcs           ;
		private SplendidCache        SplendidCache      ;
		private XmlUtil              XmlUtil            ;
		private QueryBuilder         QueryBuilder       ;

		public RestController(IHttpContextAccessor httpContextAccessor, IWebHostEnvironment hostingEnvironment, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidCache SplendidCache, XmlUtil XmlUtil, QueryBuilder QueryBuilder)
		{
			this.httpContextAccessor = httpContextAccessor;
			this.hostingEnvironment  = hostingEnvironment ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidCache       = SplendidCache      ;
			this.XmlUtil             = XmlUtil            ;
			this.QueryBuilder        = QueryBuilder       ;
		}

		#region Get
		private List<Dictionary<string, object>> ReportingModules(string sBaseURI, SplendidCRM.TimeZone T10n, string Modules)
		{
			string[] arrModules = null;
			if ( !Sql.IsEmptyString(Modules) )
			{
				arrModules = Modules.Replace(" ", "").Split(',');
			}
			DataView vwModules = new DataView(SplendidCache.ReportingModules());
			if ( arrModules != null && arrModules.Length > 0 )
			{
				vwModules.RowFilter = "MODULE_NAME in ('" + String.Join("', '", arrModules) + "')";
			}
			vwModules.Sort = "DISPLAY_NAME";
			
			List<Dictionary<string, object>> list = RestUtil.RowsToDictionary(sBaseURI, "Reports", vwModules, T10n);
			return list;
		}

		private List<Dictionary<string, object>> ReportingFilterColumns(string sBaseURI, SplendidCRM.TimeZone T10n, L10N L10n, string MODULE_NAME, string TABLE_ALIAS)
		{
			string sModule     = MODULE_NAME;
			string sTableAlias = TABLE_ALIAS;
			string sMODULE_TABLE = Sql.ToString(Application["Modules." + sModule + ".TableName"]);
			DataTable dtColumns = SplendidCache.ReportingFilterColumns(sMODULE_TABLE).Copy();
			foreach(DataRow row in dtColumns.Rows)
			{
				row["NAME"] = sTableAlias + "." + Sql.ToString(row["NAME"]);
				// 07/04/2006 Paul.  Some columns have global terms. 
				row["DISPLAY_NAME"] = Utils.TableColumnName(L10n, sModule, Sql.ToString(row["DISPLAY_NAME"]));
			}
			// 06/21/2006 Paul.  Do not sort the columns  We want it to remain sorted by COLID. This should keep the NAME at the top. 
			List<Dictionary<string, object>> list = RestUtil.RowsToDictionary(sBaseURI, "Reports", dtColumns, T10n);
			return list;
		}

		private Dictionary<string, object> ModuleFilterSource(string sBaseURI, SplendidCRM.TimeZone T10n, L10N L10n, string MODULE_NAME, string RELATED)
		{
			bool bDebug = Sql.ToBoolean(Application["CONFIG.show_sql"]);
			Dictionary<string, object> dict = Session["ReportBuilder.ModuleFilterSource." + MODULE_NAME] as Dictionary<string, object>;
#if DEBUG
			dict = null;
#endif
			if ( dict == null )
			{
				string sModule = MODULE_NAME;
				DataView vwRelationships = new DataView(SplendidCache.ReportingRelationships());
				vwRelationships.RowFilter = "       RELATIONSHIP_TYPE = 'one-to-many' " + ControlChars.CrLf
				                          + "   and RHS_MODULE        = \'" + sModule + "\'" + ControlChars.CrLf;
				// 06/10/2006 Paul.  Filter by the modules that the user has access to. 
				Sql.AppendParameter(vwRelationships, SplendidCache.ReportingModulesList(), "RHS_MODULE", false);
				vwRelationships.Sort = "RHS_KEY";

				XmlDocument xmlRelationships = new XmlDocument();
				xmlRelationships.AppendChild(xmlRelationships.CreateElement("Relationships"));
			
				XmlNode xRelationship = xmlRelationships.CreateElement("Relationship");
				xmlRelationships.DocumentElement.AppendChild(xRelationship);

				string sMODULE_TABLE = Sql.ToString(Application["Modules." + sModule + ".TableName"]);
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_NAME", sModule      );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_MODULE"       , sModule      );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_TABLE"        , sMODULE_TABLE);
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_KEY"          , String.Empty );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_MODULE"       , String.Empty );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_TABLE"        , String.Empty );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_KEY"          , String.Empty );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_TYPE", String.Empty );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_ALIAS"     , sMODULE_TABLE);
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_NAME"      , sModule + " " + sMODULE_TABLE);
				// 07/29/2008 Paul.  The module name needs to be translated as it will be used in the field headers. 
				if ( bDebug )
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"     , "[" + L10n.Term(".moduleList." + sModule) + " " + sMODULE_TABLE + "] " + L10n.Term(".moduleList." + sModule));
				else
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"     , L10n.Term(".moduleList." + sModule));
			
				foreach(DataRowView row in vwRelationships)
				{
					string sRELATIONSHIP_NAME = Sql.ToString(row["RELATIONSHIP_NAME"]);
					string sLHS_MODULE        = Sql.ToString(row["LHS_MODULE"       ]);
					string sLHS_TABLE         = Sql.ToString(row["LHS_TABLE"        ]).ToUpper();
					string sLHS_KEY           = Sql.ToString(row["LHS_KEY"          ]).ToUpper();
					string sRHS_MODULE        = Sql.ToString(row["RHS_MODULE"       ]);
					string sRHS_TABLE         = Sql.ToString(row["RHS_TABLE"        ]).ToUpper();
					string sRHS_KEY           = Sql.ToString(row["RHS_KEY"          ]).ToUpper();
					// 07/13/2006 Paul.  It may seem odd the way we are combining LHS_TABLE and RHS_KEY,  but we do it this way for a reason.  
					// The table alias to get to an Email Assigned User ID will be USERS_ASSIGNED_USER_ID. 
					string sMODULE_NAME       = sLHS_MODULE + " " + sLHS_TABLE + "_" + sRHS_KEY;
					// 11/15/2013 Paul.  The module name needs to be translated as it will be used in the field headers. 
					string sDISPLAY_NAME      = L10n.Term(".moduleList." + sRHS_MODULE);
				
					// 07/09/2007 Paul.  Fixes from Version 1.2 on 04/17/2007 were not included in Version 1.4 tree.
					switch ( sRHS_KEY.ToUpper() )
					{
						// 04/17/2007 Paul.  CREATED_BY was renamed CREATED_BY_ID in all views a long time ago. It is just now being fixed here. 
						case "CREATED_BY_ID":
							sDISPLAY_NAME = L10n.Term(".moduleList." + sRHS_MODULE) + ": " + L10n.Term(".LBL_CREATED_BY_USER");
							break;
						case "MODIFIED_USER_ID":
							sDISPLAY_NAME = L10n.Term(".moduleList." + sRHS_MODULE) + ": " + L10n.Term(".LBL_MODIFIED_BY_USER");
							break;
						case "ASSIGNED_USER_ID":
							sDISPLAY_NAME = L10n.Term(".moduleList." + sRHS_MODULE) + ": " + L10n.Term(".LBL_ASSIGNED_TO_USER");
							break;
						// 04/17/2007 Paul.  PARENT_ID is a special case where we want to know the type of the parent. 
						case "PARENT_ID":
							sDISPLAY_NAME = L10n.Term(".moduleList." + sRHS_MODULE) + ": " + L10n.Term(".moduleList." + sLHS_MODULE) + " " + L10n.Term(".LBL_PARENT_ID");
							break;
						default:
							sDISPLAY_NAME = L10n.Term(".moduleList." + sRHS_MODULE) + ": " + Utils.TableColumnName(L10n, sRHS_MODULE, sRHS_KEY);
							break;
					}
					if ( bDebug )
					{
						sDISPLAY_NAME = "[" + sMODULE_NAME + "] " + sDISPLAY_NAME;
					}
				
					xRelationship = xmlRelationships.CreateElement("Relationship");
					xmlRelationships.DocumentElement.AppendChild(xRelationship);
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_NAME", sRELATIONSHIP_NAME);
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_MODULE"       , sLHS_MODULE       );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_TABLE"        , sLHS_TABLE        );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_KEY"          , sLHS_KEY          );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_MODULE"       , sRHS_MODULE       );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_TABLE"        , sRHS_TABLE        );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_KEY"          , sRHS_KEY          );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_TYPE", "one-to-many"     );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_ALIAS"     , sLHS_TABLE + "_" + sRHS_KEY);  // This is just the alias. 
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_NAME"      , sMODULE_NAME      );  // Module name includes the alias. 
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"     , sDISPLAY_NAME     );
				}
				if ( !Sql.IsEmptyString(RELATED) )
				{
					xRelationship = xmlRelationships.CreateElement("Relationship");
					xmlRelationships.DocumentElement.AppendChild(xRelationship);
					string sRELATED_MODULE    = RELATED.Split(' ')[0];
					string sRELATED_ALIAS     = RELATED.Split(' ')[1];
					// 10/26/2011 Paul.  Add the relationship so that we can have a unique lookup. 
					string sRELATIONSHIP_NAME = RELATED.Split(' ')[2];
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_NAME", sRELATIONSHIP_NAME);
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_MODULE"       , sRELATED_MODULE   );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_TABLE"        , sRELATED_ALIAS    );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_KEY"          , String.Empty      );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_MODULE"       , String.Empty      );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_TABLE"        , String.Empty      );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_KEY"          , String.Empty      );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_TYPE", "many-to-many"    );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_ALIAS"     , sRELATED_ALIAS    );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_NAME"      , sRELATED_MODULE + " " + sRELATED_ALIAS);
					// 07/29/2008 Paul.  The module name needs to be translated as it will be used in the field headers. 
					if ( bDebug )
						XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"     , "[" + L10n.Term(".moduleList." + sRELATED_MODULE) + " " + sRELATED_ALIAS + "] " + L10n.Term(".moduleList." + sRELATED_MODULE));
					else
						XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"     , L10n.Term(".moduleList." + sRELATED_MODULE));
				}

				DataTable dtModuleColumnSource = XmlUtil.CreateDataTable(xmlRelationships.DocumentElement, "Relationship", new string[] {"MODULE_NAME", "DISPLAY_NAME"});
				List<Dictionary<string, object>> list = RestUtil.RowsToDictionary(sBaseURI, "Reports", dtModuleColumnSource, T10n);
				dict = new Dictionary<string, object>();
				dict.Add("results", list);
				dict.Add("Relationships", xmlRelationships.OuterXml);
				Session["ReportBuilder.ModuleFilterSource." + MODULE_NAME] = dict;
			}
			return dict;
		}

		private Dictionary<string, object> ModuleRelationships(string sBaseURI, SplendidCRM.TimeZone T10n, L10N L10n, string MODULE_NAME)
		{
			bool bDebug = Sql.ToBoolean(Application["CONFIG.show_sql"]);
			Dictionary<string, object> dict = Session["ReportBuilder.ModuleRelationships." + MODULE_NAME] as Dictionary<string, object>;
#if DEBUG
			dict = null;
#endif
			if ( dict == null )
			{
				dict = new Dictionary<string, object>();
				string sModule = MODULE_NAME;
				DataView vwRelationships = new DataView(SplendidCache.ReportingRelationships());
				vwRelationships.RowFilter = "       RELATIONSHIP_TYPE = 'many-to-many' " + ControlChars.CrLf
				                          + "   and LHS_MODULE        = \'" + sModule + "\'" + ControlChars.CrLf;
				// 06/10/2006 Paul.  Filter by the modules that the user has access to. 
				Sql.AppendParameter(vwRelationships, SplendidCache.ReportingModulesList(), "RHS_MODULE", false);

				XmlDocument xmlRelationships = new XmlDocument();
				xmlRelationships.AppendChild(xmlRelationships.CreateElement("Relationships"));
				
				XmlNode xRelationship = null;
				foreach(DataRowView row in vwRelationships)
				{
					string sRELATIONSHIP_NAME              = Sql.ToString(row["RELATIONSHIP_NAME"             ]);
					string sLHS_MODULE                     = Sql.ToString(row["LHS_MODULE"                    ]);
					string sLHS_TABLE                      = Sql.ToString(row["LHS_TABLE"                     ]).ToUpper();
					string sLHS_KEY                        = Sql.ToString(row["LHS_KEY"                       ]).ToUpper();
					string sRHS_MODULE                     = Sql.ToString(row["RHS_MODULE"                    ]);
					string sRHS_TABLE                      = Sql.ToString(row["RHS_TABLE"                     ]).ToUpper();
					string sRHS_KEY                        = Sql.ToString(row["RHS_KEY"                       ]).ToUpper();
					string sJOIN_TABLE                     = Sql.ToString(row["JOIN_TABLE"                    ]).ToUpper();
					string sJOIN_KEY_LHS                   = Sql.ToString(row["JOIN_KEY_LHS"                  ]).ToUpper();
					string sJOIN_KEY_RHS                   = Sql.ToString(row["JOIN_KEY_RHS"                  ]).ToUpper();
					// 11/20/2008 Paul.  Quotes, Orders and Invoices have a relationship column. 
					string sRELATIONSHIP_ROLE_COLUMN       = Sql.ToString(row["RELATIONSHIP_ROLE_COLUMN"      ]).ToUpper();
					string sRELATIONSHIP_ROLE_COLUMN_VALUE = Sql.ToString(row["RELATIONSHIP_ROLE_COLUMN_VALUE"]);
					string sMODULE_NAME       = sRHS_MODULE + " " + sRHS_TABLE;
					string sDISPLAY_NAME      = L10n.Term(".moduleList." + sRHS_MODULE);
					// 10/26/2011 Paul.  Use the join table so that the display is more descriptive. 
					if ( !Sql.IsEmptyString(sJOIN_TABLE) )
						sDISPLAY_NAME = Sql.CamelCaseModules(L10n, sJOIN_TABLE);
					if ( bDebug )
					{
						sDISPLAY_NAME = "[" + sMODULE_NAME + "] " + sDISPLAY_NAME;
					}
					// 02/18/2009 Paul.  Include the relationship column if provided. 
					// 10/26/2011 Paul.  Include the role. 
					if ( !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN) && !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN_VALUE) && sRELATIONSHIP_ROLE_COLUMN_VALUE != sModule )
						sDISPLAY_NAME += " " + sRELATIONSHIP_ROLE_COLUMN_VALUE;
					// 10/26/2011 Paul.  Add the relationship so that we can have a unique lookup. 
					sMODULE_NAME += " " + sRELATIONSHIP_NAME;
					
					xRelationship = xmlRelationships.CreateElement("Relationship");
					xmlRelationships.DocumentElement.AppendChild(xRelationship);
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_NAME"             , sRELATIONSHIP_NAME             );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_MODULE"                    , sLHS_MODULE                    );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_TABLE"                     , sLHS_TABLE                     );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_KEY"                       , sLHS_KEY                       );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_MODULE"                    , sRHS_MODULE                    );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_TABLE"                     , sRHS_TABLE                     );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_KEY"                       , sRHS_KEY                       );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "JOIN_TABLE"                    , sJOIN_TABLE                    );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "JOIN_KEY_LHS"                  , sJOIN_KEY_LHS                  );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "JOIN_KEY_RHS"                  , sJOIN_KEY_RHS                  );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_TYPE"             , "many-to-many"                 );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_NAME"                   , sMODULE_NAME                   );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"                  , sDISPLAY_NAME                  );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_ROLE_COLUMN"      , sRELATIONSHIP_ROLE_COLUMN      );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_ROLE_COLUMN_VALUE", sRELATIONSHIP_ROLE_COLUMN_VALUE);
				}

				DataTable dtModules = XmlUtil.CreateDataTable(xmlRelationships.DocumentElement, "Relationship", new string[] {"MODULE_NAME", "DISPLAY_NAME"});
				DataView vwModules = new DataView(dtModules);
				vwModules.Sort = "DISPLAY_NAME";
				List<Dictionary<string, object>> list = RestUtil.RowsToDictionary(sBaseURI, "Reports", vwModules, T10n);
				dict = new Dictionary<string, object>();
				dict.Add("results", list);
				dict.Add("RelatedModules", xmlRelationships.OuterXml);
				Session["ReportBuilder.ModuleRelationships." + MODULE_NAME] = dict;
			}
			return dict;
		}

		private Dictionary<string, object> ReportingFilterColumnsListName()
		{
			Dictionary<string, object> dict = new Dictionary<string, object>();
			DataTable dt = SplendidCache.GetAllReportingFilterColumnsListName();
			foreach ( DataRow row in dt.Rows )
			{
				string sObjectName = Sql.ToString(row["ObjectName"]).ToUpper();
				string sDATA_FIELD = Sql.ToString(row["DATA_FIELD"]).ToUpper();
				string sLIST_NAME  = Sql.ToString(row["LIST_NAME" ]);
				if ( sObjectName.StartsWith("VW") )
				{
					sObjectName = sObjectName.Substring(2);
				}
				if ( !dict.ContainsKey(sObjectName + "." + sDATA_FIELD) )
					dict.Add(sObjectName + "." + sDATA_FIELD, sLIST_NAME);
			}
			return dict;
		}

		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetModuleRelationships(string MODULE_NAME)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Reports", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Reports" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			Dictionary<string, object> dict = new Dictionary<string, object>();
			Dictionary<string, object> results = ModuleRelationships(sBaseURI, T10n, L10n, MODULE_NAME);
			dict.Add("d", results);
			
			return dict;
		}

		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetModuleFilterSource(string MODULE_NAME, string RELATED)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Reports", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Reports" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			Dictionary<string, object> dict = new Dictionary<string, object>();
			Dictionary<string, object> results = ModuleFilterSource(sBaseURI, T10n, L10n, MODULE_NAME, RELATED);
			dict.Add("d", results);
			
			return dict;
		}

		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetReportingFilterColumns(string MODULE_NAME, string TABLE_ALIAS)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Reports", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Reports" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			List<Dictionary<string, object>> list = ReportingFilterColumns(sBaseURI, T10n, L10n, MODULE_NAME, TABLE_ALIAS);
			Dictionary<string, object> dict = new Dictionary<string, object>();
			Dictionary<string, object> results = new Dictionary<string, object>();
			dict.Add("d", results);
			results.Add("results", list);
			
			return dict;
		}

		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetModuleColumns(string MODULE_NAME)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Reports", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Reports" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			// 05/24/2011 Paul.  Use the view so that custom fields will be included. 
			string sMODULE_TABLE = Sql.ToString(Application["Modules." + MODULE_NAME + ".TableName"]);
			DataTable dtRuleColumns = SplendidCache.SqlColumns("vw" + sMODULE_TABLE + "_List");
			Dictionary<string, object> dict = RestUtil.ToJson(sBaseURI, "Reports", dtRuleColumns, T10n);
			
			return dict;
		}

		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetReportingModules(string Modules)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Reports", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Reports" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			List<Dictionary<string, object>> list = ReportingModules(sBaseURI, T10n, Modules);
			Dictionary<string, object> dict = new Dictionary<string, object>();
			Dictionary<string, object> results = new Dictionary<string, object>();
			dict.Add("d", results);
			results.Add("results", list);
			
			return dict;
		}

		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetQueryBuilderState(string Modules, string MODULE_NAME, string RELATED)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Reports", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Reports" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			Dictionary<string, object> d       = new Dictionary<string, object>();
			Dictionary<string, object> results = new Dictionary<string, object>();
			d.Add("d", results);
			
			List<Dictionary<string, object>> MODULES_LIST = ReportingModules(sBaseURI, T10n, Modules);
			results.Add("MODULES_LIST", MODULES_LIST);
			
			string sMODULE_TABLE = Sql.ToString(Application["Modules." + MODULE_NAME + ".TableName"]);
			DataTable dtRuleColumns = SplendidCache.SqlColumns("vw" + sMODULE_TABLE + "_List");
			List<Dictionary<string, object>> RULE_COLUMN_LIST = RestUtil.RowsToDictionary(sBaseURI, "Reports", dtRuleColumns, T10n);
			results.Add("RULE_COLUMN_LIST", RULE_COLUMN_LIST);
			
			Dictionary<string, object> dictModuleFilterSource = ModuleFilterSource(sBaseURI, T10n, L10n, MODULE_NAME, RELATED);
			List<Dictionary<string, object>> FILTER_COLUMN_SOURCE_LIST = dictModuleFilterSource["results"] as List<Dictionary<string, object>>;
			string sRelationships = dictModuleFilterSource["Relationships"] as string;
			results.Add("FILTER_COLUMN_SOURCE_LIST", FILTER_COLUMN_SOURCE_LIST);
			results.Add("Relationships", sRelationships);
			
			string sTABLE_ALIAS = Sql.ToString(Application["Modules." + MODULE_NAME + ".TableName"]);
			List<Dictionary<string, object>> FILTER_COLUMN_LIST = ReportingFilterColumns(sBaseURI, T10n, L10n, MODULE_NAME, sTABLE_ALIAS);
			results.Add("FILTER_COLUMN_LIST", FILTER_COLUMN_LIST);

			Dictionary<string, object> dictModuleRelationships = ModuleRelationships(sBaseURI, T10n, L10n, MODULE_NAME);
			string sRelatedModules = dictModuleRelationships["RelatedModules"] as string;
			List<Dictionary<string, object>> RELATED_LIST = dictModuleRelationships["results"] as List<Dictionary<string, object>>;
			results.Add("RELATED_LIST", RELATED_LIST);
			results.Add("RelatedModules", sRelatedModules);
			
			Dictionary<string, object> dictColumnsListName = ReportingFilterColumnsListName();
			results.Add("FILTER_COLUMN_LIST_NAMES", dictColumnsListName);
			
			return d;
		}

		[HttpPost("[action]")]
		public Dictionary<string, object> BuildReportSQL([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "Reports";
			L10N L10n       = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			bool bPrimaryKeyOnly   = true ;
			bool bUseSQLParameters = false;
			bool bDesignChart      = false;
			bool bUserSpecific     = false;
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, bDesignChart);
			string sMODULE  = String.Empty;
			string sRELATED = String.Empty;
			Dictionary<string, object> dictFilterXml         = null;
			Dictionary<string, object> dictRelatedModuleXml  = null;
			Dictionary<string, object> dictRelationshipXml   = null;
			Dictionary<string, object> dictDisplayColumnsXml = null;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "MODULE"           :  sMODULE               = Sql.ToString (dict[sColumnName]);  break;
					case "RELATED"          :  sRELATED              = Sql.ToString (dict[sColumnName]);  break;
					case "PrimaryKeyOnly"   :  bPrimaryKeyOnly       = Sql.ToBoolean(dict[sColumnName]);  break;
					case "UseSQLParameters" :  bUseSQLParameters     = Sql.ToBoolean(dict[sColumnName]);  break;
					case "DesignChart"      :  bDesignChart          = Sql.ToBoolean(dict[sColumnName]);  break;
					case "UserSpecific"     :  bUserSpecific         = Sql.ToBoolean(dict[sColumnName]);  break;
					case "filterXml"        :  dictFilterXml         = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relatedModuleXml" :  dictRelatedModuleXml  = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relationshipXml"  :  dictRelationshipXml   = dict[sColumnName] as Dictionary<string, object>;  break;
					case "displayColumnsXml":  dictDisplayColumnsXml = dict[sColumnName] as Dictionary<string, object>;  break;
				}
			}
			rdl.SetCustomProperty              ("Module"        , sMODULE );
			rdl.SetCustomProperty              ("Related"       , sRELATED);
			// 06/02/2021 Paul.  React client needs to share code. 
			rdl.SetFiltersCustomProperty       (dictFilterXml       );
			rdl.SetRelatedModuleCustomProperty (dictRelatedModuleXml);
			rdl.SetRelationshipCustomProperty  (dictRelationshipXml );
			rdl.SetDisplayColumnsCustomProperty(dictDisplayColumnsXml);
			
			Hashtable hashAvailableModules = new Hashtable();
			StringBuilder sbErrors = new StringBuilder();
			string sReportSQL = String.Empty;
			sReportSQL = QueryBuilder.BuildReportSQL(Application, rdl, bPrimaryKeyOnly, bUseSQLParameters, bDesignChart, bUserSpecific, sMODULE, sRELATED, hashAvailableModules, sbErrors);
			if ( sbErrors.Length > 0 )
				throw(new Exception(sbErrors.ToString()));
			Dictionary<string, object> d = new Dictionary<string, object>();
			d.Add("d", sReportSQL);
			return d;
		}

		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public async Task<Dictionary<string, object>> GetReportParameters(Guid ID)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Reports", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Reports" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			DataTable dtReportParameters = null;
			DataTable dtEditView         = null;
			if ( !Sql.IsEmptyGuid(ID) )
			{
				DataTable dtReport = SplendidCache.Report(ID);
				if ( dtReport != null && dtReport.Rows.Count > 0 )
				{
					DataRow rdr = dtReport.Rows[0];
					string sRDL              = Sql.ToString(rdr["RDL"             ]);
					string sMODULE_NAME      = Sql.ToString(rdr["MODULE_NAME"     ]);
					string sREPORT_NAME      = Sql.ToString(rdr["NAME"            ]);
					Guid   gASSIGNED_USER_ID = Sql.ToGuid  (rdr["ASSIGNED_USER_ID"]);
					// 07/01/2023 Paul.  Make a copy of the data so we can modify it. 
					dtReportParameters = SplendidCache.ReportParameters(ID, Security.USER_ID).Copy();
					if ( dtReportParameters != null && dtReportParameters.Rows.Count > 0 )
					{
						dtEditView = SplendidCache.ReportParametersEditView(ID, Security.USER_ID);
						// 07/01/2023 Paul.  We need to process the calculated parameters before sending to React. 
						foreach ( DataRow row in dtReportParameters.Rows )
						{
							string sValue = Sql.ToString(row["DEFAULT_VALUE"]);
							if ( sValue.StartsWith("=") )
							{
								// 07/02/2023 Paul.  Use Roslyn to compile https://github.com/dotnet/roslyn. 
								Microsoft.CodeAnalysis.Scripting.ScriptOptions options = Microsoft.CodeAnalysis.Scripting.ScriptOptions.Default.AddImports("System");
								var value = await Microsoft.CodeAnalysis.CSharp.Scripting.CSharpScript.EvaluateAsync(sValue.Substring(1), options);
								if ( value.GetType().FullName == "System.DateTime" )
									sValue = RestUtil.ToJsonDate(T10n.FromServerTime(value));
								else
									sValue = Sql.ToString(value);
								row["DEFAULT_VALUE"] = sValue;
							}
						}
					}
				}
			}
			Dictionary<string, object> dict    = new Dictionary<string, object>();
			Dictionary<string, object> results = new Dictionary<string, object>();
			results.Add("Parameters", RestUtil.RowsToDictionary(sBaseURI, "ReportParameters", dtReportParameters, T10n));
			results.Add("Layout"    , RestUtil.RowsToDictionary(sBaseURI, "EditViews"       , dtEditView        , T10n));
			dict.Add("d", results);
			return dict;
		}
		#endregion
	}
}
