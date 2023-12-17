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
using System.Data;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Authorization;

using SplendidCRM.Administration.Workflows;
using System.Xml;
using Microsoft.Extensions.Hosting.Internal;
using Microsoft.AspNetCore.Hosting;

namespace SplendidCRM.Controllers.Administration.Workflows
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/Workflows/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "Workflows";
		private IHttpContextAccessor httpContextAccessor;
		private IWebHostEnvironment  hostingEnvironment ;
		private IMemoryCache         memoryCache        ;
		private DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private L10N                 L10n               ;
		private TimeZone             TimeZone           = new TimeZone();
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private RestUtil             RestUtil           ;
		private XmlUtil              XmlUtil            ;
		private WorkflowBuilder      WorkflowBuilder    ;

		public RestController(IHttpContextAccessor httpContextAccessor, IWebHostEnvironment hostingEnvironment, IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, RestUtil RestUtil, XmlUtil XmlUtil, WorkflowBuilder WorkflowBuilder)
		{
			this.httpContextAccessor = httpContextAccessor;
			this.hostingEnvironment  = hostingEnvironment ;
			this.memoryCache         = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.RestUtil            = RestUtil           ;
			this.XmlUtil             = XmlUtil            ;
			this.WorkflowBuilder     = WorkflowBuilder    ;
		}

		#region GetQueryBuilderState
		private List<Dictionary<string, object>> WorkflowFilterColumns(string sBaseURI, TimeZone T10n, L10N L10n, string MODULE_NAME, string TABLE_ALIAS)
		{
			string sModule     = MODULE_NAME;
			string sTableAlias = TABLE_ALIAS;
			string sMODULE_TABLE = Sql.ToString(Application["Modules." + sModule + ".TableName"]);
			// 07/22/2008 Paul.  We need to get the columns for the audit table. 
			// 11/08/2009 Paul.  We also need to use the audit table when referring to the base table. 
			// This is to prevent the inclusion of addtional fields in the base view, such as CITY in the vwACCOUNTS view. 
			if ( sTableAlias.EndsWith("_AUDIT_OLD") || sTableAlias == sMODULE_TABLE )
				sMODULE_TABLE += "_AUDIT";
			DataTable dtColumns = SplendidCache.WorkflowFilterColumns(sMODULE_TABLE).Copy();
			foreach(DataRow row in dtColumns.Rows)
			{
				row["NAME"] = sTableAlias + "." + Sql.ToString(row["NAME"]);
				// 07/04/2006 Paul.  Some columns have global terms. 
				row["DISPLAY_NAME"] = Utils.TableColumnName(L10n, sModule, Sql.ToString(row["DISPLAY_NAME"]));
			}
			DataView vwColumns = new DataView(dtColumns);
			vwColumns.Sort = "DISPLAY_NAME";
			// 06/21/2006 Paul.  Do not sort the columns  We want it to remain sorted by COLID. This should keep the NAME at the top. 
			List<Dictionary<string, object>> list = RestUtil.RowsToDictionary(sBaseURI, "Workflow", vwColumns, T10n);
			return list;
		}

		private Dictionary<string, object> ModuleFilterSource(string sBaseURI, TimeZone T10n, L10N L10n, string MODULE_NAME, string RELATED, string TYPE)
		{
			bool bDebug = Sql.ToBoolean(Application["CONFIG.show_sql"]);
			Dictionary<string, object> dict = Session["WorkflowFilterBuilder.ModuleFilterSource." + MODULE_NAME] as Dictionary<string, object>;
#if DEBUG
			dict = null;
#endif
			if ( dict == null )
			{
				string sModule = MODULE_NAME;
				DataView vwRelationships = new DataView(SplendidCache.ReportingRelationships());
				vwRelationships.RowFilter = "       RELATIONSHIP_TYPE = 'one-to-many' " + ControlChars.CrLf
				                          + "   and RHS_MODULE        = \'" + sModule + "\'" + ControlChars.CrLf;
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
				// 11/15/2013 Paul.  The module name needs to be translated as it will be used in the field headers. 
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
					// 11/15/2013 Paul.  The module name needs to be translated as it will be used in the field headers. 
					if ( bDebug )
						XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"     , "[" + L10n.Term(".moduleList." + sRELATED_MODULE) + " " + sRELATED_ALIAS + "] " + L10n.Term(".moduleList." + sRELATED_MODULE));
					else
						XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"     , L10n.Term(".moduleList." + sRELATED_MODULE));
				}

				// 11/16/2008 Paul.  Time-based workflows reference the base module, not the audit table. 
				if ( TYPE.ToLower() != "time" )
				{
					// 07/22/2008 Paul.  Add a relationship to the AUDIT table for the old/previous value. 
					xRelationship = xmlRelationships.CreateElement("Relationship");
					xmlRelationships.DocumentElement.AppendChild(xRelationship);

					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_NAME", sModule.ToLower() + "_audit_old");
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_MODULE"       , sModule      );
					// 11/17/2008 Paul.  Use new audit views so that custom fields will be included. 
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_TABLE"        , "vw" + sMODULE_TABLE + "_AUDIT");
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_KEY"          , "ID"         );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_MODULE"       , sModule      );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_TABLE"        , sMODULE_TABLE);
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_KEY"          , "ID"         );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_TYPE", String.Empty );
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_ALIAS"     , sMODULE_TABLE + "_AUDIT_OLD");
					XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_NAME"      , sModule + " " + sMODULE_TABLE + "_AUDIT_OLD");
					// 11/15/2013 Paul.  The module name needs to be translated as it will be used in the field headers. 
					if ( bDebug )
						XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"     , "[" + L10n.Term(".moduleList." + sModule) + " " + sMODULE_TABLE + "_AUDIT_OLD" + "] " + L10n.Term(".moduleList." + sModule) + ": Audit Old");
					else
						XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"     , L10n.Term(".moduleList." + sModule) + ": Audit Old");
				}

				DataTable dtModuleColumnSource = XmlUtil.CreateDataTable(xmlRelationships.DocumentElement, "Relationship", new string[] {"MODULE_NAME", "DISPLAY_NAME"});
				List<Dictionary<string, object>> list = RestUtil.RowsToDictionary(sBaseURI, "Reports", dtModuleColumnSource, T10n);
				dict = new Dictionary<string, object>();
				dict.Add("results", list);
				dict.Add("Relationships", xmlRelationships.OuterXml);
				Session["WorkflowFilterBuilder.ModuleFilterSource." + MODULE_NAME] = dict;
			}
			return dict;
		}

		private Dictionary<string, object> ModuleRelationships(string sBaseURI, TimeZone T10n, L10N L10n, string MODULE_NAME)
		{
			bool bDebug = Sql.ToBoolean(Application["CONFIG.show_sql"]);
			Dictionary<string, object> dict = Session["WorkflowFilterBuilder.ModuleRelationships." + MODULE_NAME] as Dictionary<string, object>;
#if DEBUG
			dict = null;
#endif
			if ( dict == null )
			{
				dict = new Dictionary<string, object>();
				string BaseModule = MODULE_NAME;
				DataView vwRelationships = new DataView(SplendidCache.ReportingRelationships());
				vwRelationships.RowFilter = "(RELATIONSHIP_TYPE = 'many-to-many' and LHS_MODULE = \'" + BaseModule + "\')" + ControlChars.CrLf
				                          + " or (RELATIONSHIP_TYPE = 'one-to-many' and LHS_MODULE = \'" + BaseModule + "\')" + ControlChars.CrLf;

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
					// 11/25/2008 Paul.  Be careful to only switch when necessary.  Parent accounts should not be switched. 
					if ( sLHS_MODULE != BaseModule && sRHS_MODULE == BaseModule )
					{
						sLHS_MODULE        = Sql.ToString(row["RHS_MODULE"       ]);
						sLHS_TABLE         = Sql.ToString(row["RHS_TABLE"        ]).ToUpper();
						sLHS_KEY           = Sql.ToString(row["RHS_KEY"          ]).ToUpper();
						sRHS_MODULE        = Sql.ToString(row["LHS_MODULE"       ]);
						sRHS_TABLE         = Sql.ToString(row["LHS_TABLE"        ]).ToUpper();
						sRHS_KEY           = Sql.ToString(row["LHS_KEY"          ]).ToUpper();
						sJOIN_TABLE        = Sql.ToString(row["JOIN_TABLE"       ]).ToUpper();
						sJOIN_KEY_LHS      = Sql.ToString(row["JOIN_KEY_RHS"     ]).ToUpper();
						sJOIN_KEY_RHS      = Sql.ToString(row["JOIN_KEY_LHS"     ]).ToUpper();
					}
					string sMODULE_NAME  = sRHS_MODULE + " " + sRHS_TABLE;
					string sDISPLAY_NAME = L10n.Term(".moduleList." + sRHS_MODULE);
					// 10/22/2008 Paul.  An account can be related to an account, but we need to make sure that it gets a separate activity name. 
					if ( sRHS_MODULE == BaseModule )
						sMODULE_NAME += "_REL";
					// 10/26/2011 Paul.  Use the join table so that the display is more descriptive. 
					if ( !Sql.IsEmptyString(sJOIN_TABLE) )
						sDISPLAY_NAME = Sql.CamelCaseModules(L10n, sJOIN_TABLE);
					if ( bDebug )
					{
						sDISPLAY_NAME = "[" + sMODULE_NAME + "] " + sDISPLAY_NAME;
					}
					// 02/18/2009 Paul.  Include the relationship column if provided. 
					// 10/26/2011 Paul.  Include the role. 
					if ( !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN) && !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN_VALUE) && sRELATIONSHIP_ROLE_COLUMN_VALUE != BaseModule )
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
				Session["WorkflowFilterBuilder.ModuleRelationships." + MODULE_NAME] = dict;
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

		[DotNetLegacyData]
		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetModuleRelationships(string MODULE_NAME)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Workflows", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Workflows" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			Dictionary<string, object> dict = new Dictionary<string, object>();
			Dictionary<string, object> results = ModuleRelationships(sBaseURI, T10n, L10n, MODULE_NAME);
			dict.Add("d", results);
			return dict;
		}

		[DotNetLegacyData]
		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetModuleFilterSource(string MODULE_NAME, string RELATED, string TYPE)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Workflows", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Workflows" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			Dictionary<string, object> dict = new Dictionary<string, object>();
			Dictionary<string, object> results = ModuleFilterSource(sBaseURI, T10n, L10n, MODULE_NAME, RELATED, TYPE);
			dict.Add("d", results);
			
			return dict;
		}

		[DotNetLegacyData]
		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetWorkflowFilterColumns(string MODULE_NAME, string TABLE_ALIAS)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Workflows", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Workflows" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			List<Dictionary<string, object>> list = WorkflowFilterColumns(sBaseURI, T10n, L10n, MODULE_NAME, TABLE_ALIAS);
			Dictionary<string, object> dict = new Dictionary<string, object>();
			Dictionary<string, object> results = new Dictionary<string, object>();
			dict.Add("d", results);
			results.Add("results", list);
			
			return dict;
		}

		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetQueryBuilderState(string Modules, string MODULE_NAME, string RELATED, string TYPE)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Workflows", "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + "Workflows" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			
			Dictionary<string, object> d       = new Dictionary<string, object>();
			Dictionary<string, object> results = new Dictionary<string, object>();
			d.Add("d", results);
			
			List<Dictionary<string, object>> MODULES_LIST = RestUtil.RowsToDictionary(sBaseURI, "WorkflowModules", SplendidCache.WorkflowModules(), T10n);
			results.Add("MODULES_LIST", MODULES_LIST);
			
			Dictionary<string, object> dictModuleFilterSource = ModuleFilterSource(sBaseURI, T10n, L10n, Sql.ToString(MODULE_NAME), Sql.ToString(RELATED), Sql.ToString(TYPE));
			List<Dictionary<string, object>> FILTER_COLUMN_SOURCE_LIST = dictModuleFilterSource["results"] as List<Dictionary<string, object>>;
			string sRelationships = dictModuleFilterSource["Relationships"] as string;
			results.Add("FILTER_COLUMN_SOURCE_LIST", FILTER_COLUMN_SOURCE_LIST);
			results.Add("Relationships", sRelationships);
			
			string sTABLE_ALIAS = Sql.ToString(Application["Modules." + MODULE_NAME + ".TableName"]);
			List<Dictionary<string, object>> FILTER_COLUMN_LIST = WorkflowFilterColumns(sBaseURI, T10n, L10n, MODULE_NAME, sTABLE_ALIAS);
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

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string BuildReportSQL([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "Reports";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			string sNAME                 = String.Empty;
			string sTYPE                 = String.Empty;
			string sBASE_MODULE          = String.Empty;
			string sRELATED              = String.Empty;
			string sFREQUENCY_VALUE      = String.Empty;
			string sFREQUENCY_INTERVAL   = String.Empty;
			Dictionary<string, object> dictFilterXml        = null;
			Dictionary<string, object> dictRelatedModuleXml = null;
			Dictionary<string, object> dictRelationshipXml  = null;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "NAME"                :  sNAME                 = Sql.ToString(dict[sColumnName]);  break;
					case "TYPE"                :  sTYPE                 = Sql.ToString(dict[sColumnName]);  break;
					// 06/05/2021 Paul.  Keep using MODULE to match Reports. 
					case "MODULE"              :  sBASE_MODULE          = Sql.ToString(dict[sColumnName]);  break;
					case "RELATED"             :  sRELATED              = Sql.ToString(dict[sColumnName]);  break;
					case "FREQUENCY_VALUE"     :  sFREQUENCY_VALUE      = Sql.ToString(dict[sColumnName]);  break;
					case "FREQUENCY_INTERVAL"  :  sFREQUENCY_INTERVAL   = Sql.ToString(dict[sColumnName]);  break;
					case "filterXml"           :  dictFilterXml         = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relatedModuleXml"    :  dictRelatedModuleXml  = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relationshipXml"     :  dictRelationshipXml   = dict[sColumnName] as Dictionary<string, object>;  break;
				}
			}
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, false);
			rdl.SetCustomProperty             ("Module"           , sBASE_MODULE       );
			rdl.SetCustomProperty             ("Related"          , sRELATED           );
			rdl.SetCustomProperty             ("FrequencyValue"   , sFREQUENCY_VALUE   );
			rdl.SetCustomProperty             ("FrequencyInterval", sFREQUENCY_INTERVAL);
			// 06/02/2021 Paul.  React client needs to share code. 
			rdl.SetFiltersCustomProperty      (dictFilterXml       );
			rdl.SetRelatedModuleCustomProperty(dictRelatedModuleXml);
			rdl.SetRelationshipCustomProperty (dictRelationshipXml );

			Hashtable hashAvailableModules = new Hashtable();
			StringBuilder sbErrors = new StringBuilder();
			string sReportSQL = String.Empty;
			sReportSQL = EditView.BuildReportSQL(Security, XmlUtil, rdl, sBASE_MODULE, sRELATED, sTYPE, sFREQUENCY_INTERVAL, sFREQUENCY_VALUE, sbErrors);
			if ( sbErrors.Length > 0 )
				throw(new Exception(sbErrors.ToString()));
			return sReportSQL;
		}
		#endregion

		#region Get
		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetWorkflowModules()
		{
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess("Workflows", "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}

			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;

			DataTable dt = SplendidCache.WorkflowModules();
			Guid     gTIMEZONE         = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			TimeZone T10n              = TimeZone.CreateTimeZone(gTIMEZONE);
			Dictionary<string, object> dictResponse = RestUtil.ToJson(sBaseURI, "WorkflowModules", dt, T10n);
			dictResponse.Add("__total", dt.Rows.Count);
			return dictResponse;
		}

		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetRelatedModules(string BASE_MODULE)
		{
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess("Workflows", "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}

			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;

			DataView vwRelationships = new DataView(SplendidCache.WorkflowRelationships());
			// 11/25/2008 Paul.  Only show one-to-many as we can only lookup one value. 
			// 06/04/2021 Paul.  Let the client filter by RELATIONSHIP_MANY = 0. 
			vwRelationships.RowFilter = "BASE_MODULE = \'" + BASE_MODULE + "\'" + ControlChars.CrLf;
			vwRelationships.Sort = "DISPLAY_NAME";

			Guid     gTIMEZONE         = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			TimeZone T10n              = TimeZone.CreateTimeZone(gTIMEZONE);
			Dictionary<string, object> dictResponse = RestUtil.ToJson(sBaseURI, "RelatedModules", vwRelationships, T10n);
			dictResponse.Add("__total", vwRelationships.Count);
			return dictResponse;
		}

		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> WorkflowFilterColumns(string MODULE_NAME)
		{
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess("Workflows", "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}

			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;

			string sMODULE_TABLE = Sql.ToString(Application["Modules." + MODULE_NAME + ".TableName"]);
			DataTable dtColumns = SplendidCache.WorkflowFilterColumns(sMODULE_TABLE).Copy();
			foreach(DataRow row in dtColumns.Rows)
			{
				row["DISPLAY_NAME"] = Utils.TableColumnName(L10n, MODULE_NAME, Sql.ToString(row["DISPLAY_NAME"]));
			}

			Guid     gTIMEZONE         = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			TimeZone T10n              = TimeZone.CreateTimeZone(gTIMEZONE);
			Dictionary<string, object> dictResponse = RestUtil.ToJson(sBaseURI, "WorkflowFilterColumns", dtColumns, T10n);
			dictResponse.Add("__total", dtColumns.Rows.Count);
			return dictResponse;
		}
		#endregion

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public Guid UpdateModule([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "Workflows";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			string sTableName = Sql.ToString(Application["Modules." + sModuleName + ".TableName"]);
			if ( Sql.IsEmptyString(sTableName) )
				throw(new Exception("Unknown module: " + sModuleName));
			
			string sNAME                 = String.Empty;
			string sTYPE                 = String.Empty;
			string sBASE_MODULE          = String.Empty;
			string sRELATED              = String.Empty;
			string sFREQUENCY_VALUE      = String.Empty;
			string sFREQUENCY_INTERVAL   = String.Empty;
			Dictionary<string, object> dictFilterXml        = null;
			Dictionary<string, object> dictRelatedModuleXml = null;
			Dictionary<string, object> dictRelationshipXml  = null;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "NAME"                :  sNAME                 = Sql.ToString(dict[sColumnName]);  break;
					case "TYPE"                :  sTYPE                 = Sql.ToString(dict[sColumnName]);  break;
					case "BASE_MODULE"         :  sBASE_MODULE          = Sql.ToString(dict[sColumnName]);  break;
					case "RELATED"             :  sRELATED              = Sql.ToString(dict[sColumnName]);  break;
					case "FREQUENCY_VALUE"     :  sFREQUENCY_VALUE      = Sql.ToString(dict[sColumnName]);  break;
					case "FREQUENCY_INTERVAL"  :  sFREQUENCY_INTERVAL   = Sql.ToString(dict[sColumnName]);  break;
					case "filterXml"           :  dictFilterXml         = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relatedModuleXml"    :  dictRelatedModuleXml  = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relationshipXml"     :  dictRelationshipXml   = dict[sColumnName] as Dictionary<string, object>;  break;
				}
			}
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, false);
			rdl.SetCustomProperty             ("Module"           , sBASE_MODULE       );
			rdl.SetCustomProperty             ("Related"          , sRELATED           );
			rdl.SetCustomProperty             ("FrequencyValue"   , sFREQUENCY_VALUE   );
			rdl.SetCustomProperty             ("FrequencyInterval", sFREQUENCY_INTERVAL);
			// 06/02/2021 Paul.  React client needs to share code. 
			rdl.SetFiltersCustomProperty      (dictFilterXml       );
			rdl.SetRelatedModuleCustomProperty(dictRelatedModuleXml);
			rdl.SetRelationshipCustomProperty (dictRelationshipXml );

			Hashtable hashAvailableModules = new Hashtable();
			StringBuilder sbErrors = new StringBuilder();
			string sReportSQL = String.Empty;
			sReportSQL = EditView.BuildReportSQL(Security, XmlUtil, rdl, sBASE_MODULE, sRELATED, sTYPE, sFREQUENCY_INTERVAL, sFREQUENCY_VALUE, sbErrors);
			if ( sbErrors.Length > 0 )
				throw(new Exception(sbErrors.ToString()));

			string sMODULE_TABLE = Sql.ToString(Application["Modules." + sBASE_MODULE + ".TableName"]);
			string sAUDIT_TABLE  = sMODULE_TABLE + "_AUDIT";
			dict["AUDIT_TABLE"] = sAUDIT_TABLE;
			dict["FILTER_SQL" ] = sReportSQL;
			dict["FILTER_XML" ] = rdl.OuterXml;
			// 06/21/2021 Paul.  Move bExcludeSystemTables to method parameter so that it can be used by admin REST methods. 
			Guid gID = RestUtil.UpdateTable(sTableName, dict, false);
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Clear(gID, trn);
						EditView.BuildTriggers(SqlProcs, XmlUtil, rdl, sBASE_MODULE, gID, sbErrors, trn);
						if ( sbErrors.Length > 0 )
							throw(new Exception(sbErrors.ToString()));
						WorkflowBuilder.UpdateMasterWorkflowXoml(gID, trn);
						trn.Commit();
					}
					catch(Exception ex)
					{
						trn.Rollback();
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
						throw;
					}
				}
			}

			// 04/28/2019 Paul.  Add tracker for React client. 
			string sName = Sql.ToString(dict["NAME"]);
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
			return gID;
		}
	}
}
