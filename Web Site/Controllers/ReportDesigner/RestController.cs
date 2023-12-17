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
using System.IO;
using System.Xml;
using System.Data;
using System.Data.Common;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.ReportDesigner
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("ReportDesigner/Rest.svc")]
	public partial class RestController : ControllerBase
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
		private OrderUtils           OrderUtils         ;
		private QueryDesigner        QueryDesigner      ;
		private SplendidCRM.Crm.Modules          Modules              ;
		private ReportsAttachmentView            ReportsAttachmentView;

		public RestController(IHttpContextAccessor httpContextAccessor, IWebHostEnvironment hostingEnvironment, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, RestUtil RestUtil, XmlUtil XmlUtil, OrderUtils OrderUtils, QueryDesigner QueryDesigner, SplendidCRM.Crm.Modules Modules, ReportsAttachmentView ReportsAttachmentView)
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
			this.OrderUtils          = OrderUtils         ;
			this.QueryDesigner       = QueryDesigner      ;
			this.Modules             = Modules            ;
			this.ReportsAttachmentView = ReportsAttachmentView;
		}

		#region Get
		[DotNetLegacyData]
		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetModules()
		{
			TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			int  nACLACCESS = Security.GetUserAccess("Reports", "edit");
			if ( !Sql.ToBoolean(Application["Modules." + "Reports" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			Dictionary<string, object> dict = Session["ReportDesigner.Modules"] as Dictionary<string, object>;
#if DEBUG
			dict = null;
#endif
			if ( dict == null )
			{
				try
				{
					if ( Security.IsAuthenticated() )
					{
						string sBaseURI = String.Empty;  //Request.Url.Scheme + "://" + Request.Url.Host + Request.Url.AbsolutePath;
						dict = new Dictionary<string, object>();
						List<Dictionary<string, object>> results = new List<Dictionary<string, object>>();
						dict.Add( "results", results );

						List<string> lstModules = new List<string>();
						List<string> lstDetailViews = new List<string>();
						Dictionary<string, string> hashModuleNames = new Dictionary<string, string>();
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							// 04/17/2018 Paul.  Add CustomReportView to simplify reporting. 
							sSQL = "select MODULE_NAME  as ModuleName  " + ControlChars.CrLf
							     + "     , DISPLAY_NAME as DisplayName " + ControlChars.CrLf
							     + "     , TABLE_NAME   as TableName   " + ControlChars.CrLf
							     + "     , 'ID'         as PrimaryField" + ControlChars.CrLf
							     + "     , 0            as Relationship" + ControlChars.CrLf
							     + "     , 0            as CustomReportView" + ControlChars.CrLf
							     + "  from vwMODULES_Reporting         " + ControlChars.CrLf
							     + " where USER_ID    = @USER_ID       " + ControlChars.CrLf
							     + "   and TABLE_NAME is not null      " + ControlChars.CrLf
							     + " order by TABLE_NAME               " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter( cmd, "@USER_ID", Security.USER_ID );
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									( (IDbDataAdapter) da ).SelectCommand = cmd;
									using ( DataTable dt = new DataTable() )
									{
										da.Fill( dt );
										//dict = ToJson(sBaseURI, "Modules", dt, T10n);
										foreach ( DataRow row in dt.Rows )
										{
											string sModuleName = Sql.ToString( row["ModuleName"] );
											string sDisplayName = L10n.Term( Sql.ToString( row["DisplayName"] ) );
											lstModules.Add( sModuleName );
											// 01/08/2015 Paul.  Activities module combines Calls, Meetings, Tasks, Notes and Emails. 
											if ( sModuleName == "Calls" || sModuleName == "Meetings" || sModuleName == "Tasks" || sModuleName == "Notes" || sModuleName == "Emails" )
											{
												if ( !hashModuleNames.ContainsKey("Activities") )
												{
													lstModules.Add( "Activities" );
													hashModuleNames.Add( "Activities", sDisplayName );
												}
											}
											lstDetailViews.Add( sModuleName + ".DetailView" );
											hashModuleNames.Add( sModuleName, sDisplayName );
											row["DisplayName"] = sDisplayName;
											
											Dictionary<string, object> drow = new Dictionary<string, object>();
											for ( int i = 0; i < dt.Columns.Count; i++ )
											{
												drow.Add( dt.Columns[i].ColumnName, row[i] );
											}
											results.Add( drow );
										}
									}
								}
							}
							
							// 04/17/2018 Paul.  Add CustomReportView to simplify reporting. 
							sSQL = "select MODULE_NAME        as ModuleName  " + ControlChars.CrLf
							     + "     , ''                 as DisplayName " + ControlChars.CrLf
							     + "     , TABLE_NAME         as TableName   " + ControlChars.CrLf
							     + "     , PRIMARY_FIELD      as PrimaryField" + ControlChars.CrLf
							     + "     , 1                  as Relationship" + ControlChars.CrLf
							     + "     , DETAIL_NAME        as RelatedName " + ControlChars.CrLf
							     + "     , 0                  as CustomReportView" + ControlChars.CrLf
							     + "  from vwDETAILVIEWS_RELATIONSHIPS       " + ControlChars.CrLf
							     + " where TABLE_NAME is not null            " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AppendParameter(cmd, lstModules.ToArray(), "MODULE_NAME");
								Sql.AppendParameter(cmd, lstDetailViews.ToArray(), "DETAIL_NAME");
								cmd.CommandText += " order by DETAIL_NAME, RELATIONSHIP_ORDER" + ControlChars.CrLf;
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dt = new DataTable() )
									{
										da.Fill(dt);
										//dict = ToJson(sBaseURI, "Modules", dt, T10n);
										foreach ( DataRow row in dt.Rows )
										{
											string sRelatedName = Sql.ToString(row["RelatedName"]).Replace(".DetailView", "");
											string sModuleName  = Sql.ToString(row["ModuleName" ]);
											string sTableName   = Sql.ToString(row["TableName"  ]);
											if ( sTableName.StartsWith("vw") || sTableName.StartsWith("VW") )
												sTableName = sTableName.Substring(2);
											row["TableName"  ] = sTableName;
											row["DisplayName"] = hashModuleNames[sRelatedName] + " " + hashModuleNames[sModuleName];
											
											Dictionary<string, object> drow = new Dictionary<string, object>();
											for ( int i = 0; i < dt.Columns.Count; i++ )
											{
												drow.Add( dt.Columns[i].ColumnName, row[i] );
											}
											results.Add( drow );
										}
									}
								}
							}
							
							// 04/17/2018 Paul.  Add CustomReportView to simplify reporting. 
							sSQL = "select MODULE_NAME        as ModuleName      " + ControlChars.CrLf
							     + "     , NAME               as DisplayName     " + ControlChars.CrLf
							     + "     , VIEW_NAME          as TableName       " + ControlChars.CrLf
							     + "     , PRIMARY_FIELD      as PrimaryField    " + ControlChars.CrLf
							     + "     , 0                  as Relationship    " + ControlChars.CrLf
							     + "     , 1                  as CustomReportView" + ControlChars.CrLf
							     + "  from vwMODULES_REPORT_VIEWS                " + ControlChars.CrLf
							     + " where 1 = 1                                 " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AppendParameter(cmd, lstModules.ToArray(), "MODULE_NAME");
								cmd.CommandText += " order by DisplayName" + ControlChars.CrLf;
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dt = new DataTable() )
									{
										da.Fill(dt);
										foreach ( DataRow row in dt.Rows )
										{
											string sTableName = Sql.ToString(row["TableName"]);
											if ( sTableName.StartsWith("vw") || sTableName.StartsWith("VW") )
												sTableName = sTableName.Substring(2);
											row["TableName"] = sTableName;
											
											Dictionary<string, object> drow = new Dictionary<string, object>();
											for ( int i = 0; i < dt.Columns.Count; i++ )
											{
												drow.Add( dt.Columns[i].ColumnName, row[i] );
											}
											results.Add( drow );
										}
									}
								}
							}
							
							//Dictionary<string, object> d             = dict["d"] as Dictionary<string, object>;
							//List<Dictionary<string, object>> results = d["results"] as List<Dictionary<string, object>>;
							for ( int i = 0; i < results.Count; i++ )
							{
								sSQL = "select ColumnName as ColumnName" + ControlChars.CrLf
									 + "     , ColumnType as ColumnType" + ControlChars.CrLf
									 + "     , CsType     as DataType  " + ControlChars.CrLf
									 + "     , length     as DataLength" + ControlChars.CrLf
									 + "     , prec       as Precision " + ControlChars.CrLf
									 + "     , max_length as MaxLength " + ControlChars.CrLf
									 + "  from vwSqlColumns            " + ControlChars.CrLf
									 + " where ObjectName = @OBJECTNAME" + ControlChars.CrLf
									 + " order by colid                " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									Dictionary<string, object> module = results[i];
									string sModuleName = Sql.ToString( module["ModuleName"] );
									string sTableName = Sql.ToString( module["TableName"] );
									// 02/20/2016 Paul.  Make sure to use upper case for Oracle. 
									Sql.AddParameter( cmd, "@OBJECTNAME", Sql.MetadataName(cmd, "vw" + sTableName));
									using ( DbDataAdapter da = dbf.CreateDataAdapter() )
									{
										( (IDbDataAdapter) da ).SelectCommand = cmd;
										using ( DataTable dtColumns = new DataTable() )
										{
											da.Fill( dtColumns );
											dtColumns.Columns.Add( "DisplayName", typeof( System.String ) );
											dtColumns.Columns.Add( "TableName", typeof( System.String ) );

											//module.Add("Fields", RowsToDictionary(sBaseURI, "Fields", dtColumns, T10n));
											List<Dictionary<string, object>> objs = new List<Dictionary<string, object>>();
											foreach ( DataRow row in dtColumns.Rows )
											{
												row["TableName"] = sTableName;
												row["DisplayName"] = Utils.TableColumnName( L10n, sModuleName, Sql.ToString( row["ColumnName"] ) );

												Dictionary<string, object> drow = new Dictionary<string, object>();
												for ( int j = 0; j < dtColumns.Columns.Count; j++ )
												{
													drow.Add( dtColumns.Columns[j].ColumnName, row[j] );
												}
												objs.Add( drow );
											}
											module.Add( "Fields", objs );
										}
									}
								}
							}
						}
						Session["ReportDesigner.Modules"] = dict;
					}
				}
				catch ( Exception ex )
				{
					SplendidError.SystemError( new StackTrace( true ).GetFrame( 0 ), ex );
				}
			}
			return dict;
		}

		// 07/04/2016 Paul.  We need a separate method for workflow modules. 
		[DotNetLegacyData]
		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetBusinessProcessModules()
		{
			L10N L10n       = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess("Reports", "edit");
			if ( !Sql.ToBoolean(Application["Modules." + "Reports" + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + "Reports"));
			}
			Dictionary<string, object> dict = Session["ReportDesigner.BusinessProcessModules"] as Dictionary<string, object>;
#if DEBUG
			dict = null;
#endif
			if ( dict == null )
			{
				try
				{
					if ( Security.IsAuthenticated() )
					{
						string sBaseURI = String.Empty;  //Request.Url.Scheme + "://" + Request.Url.Host + Request.Url.AbsolutePath;

						TimeZone T10n = TimeZone.CreateTimeZone(Sql.ToGuid(Application["CONFIG.default_timezone"]));

						dict = new Dictionary<string, object>();
						List<Dictionary<string, object>> results = new List<Dictionary<string, object>>();
						dict.Add("results", results);

						List<string> lstModules     = new List<string>();
						List<string> lstDetailViews = new List<string>();
						Dictionary<string, string> hashModuleNames = new Dictionary<string, string>();
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select MODULE_NAME  as ModuleName  " + ControlChars.CrLf
								 + "     , DISPLAY_NAME as DisplayName " + ControlChars.CrLf
								 + "     , TABLE_NAME   as TableName   " + ControlChars.CrLf
								 + "     , 'ID'         as PrimaryField" + ControlChars.CrLf
								 + "     , 0            as Relationship" + ControlChars.CrLf
								 + "  from vwMODULES_BusinessProcess   " + ControlChars.CrLf
								 + " where TABLE_NAME is not null      " + ControlChars.CrLf
								 + " order by TABLE_NAME               " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									( (IDbDataAdapter) da ).SelectCommand = cmd;
									using ( DataTable dt = new DataTable() )
									{
										da.Fill(dt);
										//dict = ToJson(sBaseURI, "Modules", dt, T10n);
										foreach ( DataRow row in dt.Rows )
										{
											string sModuleName  = Sql.ToString(row["ModuleName"]);
											string sDisplayName = L10n.Term(Sql.ToString(row["DisplayName"]));
											lstModules.Add(sModuleName);
											// 01/08/2015 Paul.  Activities module combines Calls, Meetings, Tasks, Notes and Emails. 
											if ( sModuleName == "Calls" || sModuleName == "Meetings" || sModuleName == "Tasks" || sModuleName == "Notes" || sModuleName == "Emails" )
											{
												if ( !hashModuleNames.ContainsKey("Activities") )
												{
													lstModules     .Add("Activities");
													hashModuleNames.Add("Activities", sDisplayName);
												}
											}
											lstDetailViews .Add(sModuleName + ".DetailView");
											hashModuleNames.Add(sModuleName, sDisplayName);
											row["DisplayName"] = sDisplayName;
											
											Dictionary<string, object> drow = new Dictionary<string, object>();
											for ( int i = 0; i < dt.Columns.Count; i++ )
											{
												drow.Add(dt.Columns[i].ColumnName, row[i]);
											}
											results.Add( drow );
										}
									}
								}
							}
							
							//Dictionary<string, object> d             = dict["d"] as Dictionary<string, object>;
							//List<Dictionary<string, object>> results = d["results"] as List<Dictionary<string, object>>;
							for ( int i = 0; i < results.Count; i++ )
							{
								sSQL = "select ColumnName as ColumnName" + ControlChars.CrLf
									 + "     , ColumnType as ColumnType" + ControlChars.CrLf
									 + "     , CsType     as DataType  " + ControlChars.CrLf
									 + "     , length     as DataLength" + ControlChars.CrLf
									 + "     , prec       as Precision " + ControlChars.CrLf
									 + "     , max_length as MaxLength " + ControlChars.CrLf
									 + "  from vwSqlColumns            " + ControlChars.CrLf
									 + " where ObjectName = @OBJECTNAME" + ControlChars.CrLf
									 + " order by colid                " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									Dictionary<string, object> module = results[i];
									string sModuleName = Sql.ToString(module["ModuleName"]);
									string sTableName  = Sql.ToString(module["TableName" ]);
									// 02/20/2016 Paul.  Make sure to use upper case for Oracle. 
									Sql.AddParameter( cmd, "@OBJECTNAME", Sql.MetadataName(cmd, "vw" + sTableName));
									using ( DbDataAdapter da = dbf.CreateDataAdapter() )
									{
										((IDbDataAdapter) da).SelectCommand = cmd;
										using ( DataTable dtColumns = new DataTable() )
										{
											da.Fill(dtColumns);
											dtColumns.Columns.Add("DisplayName", typeof(System.String));
											dtColumns.Columns.Add("TableName"  , typeof(System.String));

											//module.Add("Fields", RowsToDictionary(sBaseURI, "Fields", dtColumns, T10n));
											List<Dictionary<string, object>> objs = new List<Dictionary<string, object>>();
											foreach ( DataRow row in dtColumns.Rows )
											{
												row["TableName"  ] = sTableName;
												row["DisplayName"] = Utils.TableColumnName(L10n, sModuleName, Sql.ToString(row["ColumnName"]));

												Dictionary<string, object> drow = new Dictionary<string, object>();
												for ( int j = 0; j < dtColumns.Columns.Count; j++ )
												{
													drow.Add( dtColumns.Columns[j].ColumnName, row[j] );
												}
												objs.Add(drow);
											}
											module.Add("Fields", objs);
										}
									}
								}
							}
						}
						Session["ReportDesigner.BusinessProcessModules"] = dict;
					}
				}
				catch ( Exception ex )
				{
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				}
			}
			return dict;
		}

		// 03/31/2020 Paul.  Separate out GetReportDesign so that it can be called from the React Client. 
		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public IActionResult GetReportDesign([FromQuery] Guid ID)
		{
			string sMessage = String.Empty;
			if ( Security.IsAuthenticated() )
			{
				bool bDebug = Sql.ToBoolean(Application["CONFIG.show_sql"]);
#if DEBUG
				bDebug = true;
#endif
				using ( DataTable dtSYNC_TABLES = SplendidCache.RestTables("REPORTS", false) )
				{
					if ( dtSYNC_TABLES != null && dtSYNC_TABLES.Rows.Count > 0 )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select *"              + ControlChars.CrLf
							     + "  from vwREPORTS_Edit" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Security.Filter(cmd, "Reports", "edit", "ASSIGNED_USER_ID", true);
								Sql.AppendParameter(cmd, ID, "ID", false);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dtCurrent = new DataTable() )
									{
										da.Fill(dtCurrent);
										// 10/31/2017 Paul.  Provide a way to inject Record level ACL. 
										if ( dtCurrent.Rows.Count > 0 && (Security.GetRecordAccess(dtCurrent.Rows[0], "Reports", "edit", "ASSIGNED_USER_ID") >= 0) )
										{
											DataRow rdr = dtCurrent.Rows[0];
											string sRDL = Sql.ToString(rdr["RDL"]);
											
											RdlDocument rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
											string sResponse = QueryDesigner.GetReportDesign(rdl, null, sRDL, L10n, bDebug);
											byte[] byResponse = Encoding.UTF8.GetBytes( sResponse );
											Response.ContentType = "text/xml";
											return File(byResponse, Response.ContentType);
										}
										else
										{
											throw(new Exception(L10n.Term("ACL.LBL_NO_ACCESS")));
										}
									}
								}
							}
						}
					}
					else
					{
						// 08/02/2019 Paul.  We want to see the error in the React Client. 
						sMessage = "REPORTS cannot be accessed.";
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), sMessage);
						throw(new Exception(sMessage));
					}
				}
			}
			byte[] data = System.Text.Encoding.UTF8.GetBytes(sMessage);
			Response.ContentType = "text/plain";
			return File(data, Response.ContentType);
		}

		[DotNetLegacyData]
		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public async Task<Guid> CreateAttachment(Guid ID, string AttachmentType)
		{
			Guid gNOTE_ID = Guid.Empty;
			if ( Security.IsAuthenticated() )
			{
				TimeZone T10n = TimeZone.CreateTimeZone(Sql.ToGuid(Session["USER_SETTINGS/TIMEZONE"]));
				bool bDebug = Sql.ToBoolean(Application["CONFIG.show_sql"]);
#if DEBUG
				bDebug = true;
#endif
				using ( DataTable dtSYNC_TABLES = SplendidCache.RestTables("REPORTS", false) )
				{
					if ( dtSYNC_TABLES != null && dtSYNC_TABLES.Rows.Count > 0 )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select *"              + ControlChars.CrLf
							     + "  from vwREPORTS_Edit" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Security.Filter(cmd, "Reports", "edit", "ASSIGNED_USER_ID", true);
								Sql.AppendParameter(cmd, ID, "ID", false);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dtCurrent = new DataTable() )
									{
										da.Fill(dtCurrent);
										// 10/31/2017 Paul.  Provide a way to inject Record level ACL. 
										if ( dtCurrent.Rows.Count > 0 && (Security.GetRecordAccess(dtCurrent.Rows[0], "Reports", "edit", "ASSIGNED_USER_ID") >= 0) )
										{
											DataRow rdr = dtCurrent.Rows[0];
											string sREPORT_NAME = Sql.ToString(rdr["NAME"       ]);
											string sMODULE_NAME = Sql.ToString(rdr["MODULE_NAME"]);
											string sRDL         = Sql.ToString(rdr["RDL"        ]);
											string sDESCRIPTION = sREPORT_NAME + " " + DateTime.Now.ToString();
											
											string sRENDER_FORMAT = "PDF";
											switch ( AttachmentType )
											{
												case "Attachment"      :  sRENDER_FORMAT = "PDF"         ;  break;
												case "Attachment-PDF"  :  sRENDER_FORMAT = "PDF"         ;  break;
												// 02/05/2021 Paul.  Use EXCELOPENXML instead of EXCEL. 
												case "Attachment-Excel":  sRENDER_FORMAT = "EXCELOPENXML";  break;
												// 02/05/2021 Paul.  Use WORDOPENXML instead of WORD. 
												case "Attachment-Word" :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
												case "Attachment-Image":  sRENDER_FORMAT = "IMAGE"       ;  break;
												case "PDF"             :  sRENDER_FORMAT = "PDF"         ;  break;
												case "Excel"           :  sRENDER_FORMAT = "EXCELOPENXML";  break;
												case "Word"            :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
												case "Image"           :  sRENDER_FORMAT = "IMAGE"       ;  break;
											}
											gNOTE_ID = await ReportsAttachmentView.SendAsAttachment(null, L10n, T10n, ID, sRDL, sRENDER_FORMAT, sMODULE_NAME, Guid.Empty, sREPORT_NAME, sDESCRIPTION);
										}
										else
										{
											throw(new Exception(L10n.Term("ACL.LBL_NO_ACCESS")));
										}
									}
								}
							}
						}
					}
					else
					{
						// 08/02/2019 Paul.  We want to see the error in the React Client. 
						string sMessage = "REPORTS cannot be accessed.";
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), sMessage);
						throw(new Exception(sMessage));
					}
				}
			}
			return gNOTE_ID;
		}
		
		[DotNetLegacyData]
		[HttpPost("[action]")]
		public async Task<Guid> SendAsAttachment([FromBody] Dictionary<string, object> dict)
		{
			Guid gNOTE_ID = Guid.Empty;
			if ( Security.IsAuthenticated() )
			{
				Guid   ID             = Guid.Empty;
				string AttachmentType = String.Empty;
				string sRENDER_FORMAT = "PDF";
				Dictionary<string, string> dictParameters = new Dictionary<string, string>();
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "ID"            :  ID             = Sql.ToGuid  (dict[sKey]);  break;
						case "AttachmentType":  AttachmentType = Sql.ToString(dict[sKey]);  break;
						case "RENDER_FORMAT" :  sRENDER_FORMAT = Sql.ToString(dict[sKey]);  break;
					}
					dictParameters[sKey] = Sql.ToString(dict[sKey]);
				}

				L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
				TimeZone T10n = TimeZone.CreateTimeZone(Sql.ToGuid(Session["USER_SETTINGS/TIMEZONE"]));
				bool bDebug = Sql.ToBoolean(Application["CONFIG.show_sql"]);
#if DEBUG
				bDebug = true;
#endif
				using ( DataTable dtSYNC_TABLES = SplendidCache.RestTables("REPORTS", false) )
				{
					if ( dtSYNC_TABLES != null && dtSYNC_TABLES.Rows.Count > 0 )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select *"              + ControlChars.CrLf
							     + "  from vwREPORTS_Edit" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Security.Filter(cmd, "Reports", "edit", "ASSIGNED_USER_ID", true);
								Sql.AppendParameter(cmd, ID, "ID", false);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dtCurrent = new DataTable() )
									{
										da.Fill(dtCurrent);
										// 10/31/2017 Paul.  Provide a way to inject Record level ACL. 
										if ( dtCurrent.Rows.Count > 0 && (Security.GetRecordAccess(dtCurrent.Rows[0], "Reports", "edit", "ASSIGNED_USER_ID") >= 0) )
										{
											DataRow rdr = dtCurrent.Rows[0];
											string   sREPORT_NAME           = Sql.ToString  (rdr["NAME"         ]);
											string   sMODULE_NAME           = Sql.ToString  (rdr["MODULE_NAME"  ]);
											string   sRDL                   = Sql.ToString  (rdr["RDL"          ]);
											DateTime dtREPORT_DATE_MODIFIED = Sql.ToDateTime(rdr["DATE_MODIFIED"]);
											
											switch ( AttachmentType )
											{
												case "Attachment"      :  sRENDER_FORMAT = "PDF"         ;  break;
												case "Attachment-PDF"  :  sRENDER_FORMAT = "PDF"         ;  break;
												// 02/05/2021 Paul.  Use EXCELOPENXML instead of EXCEL. 
												case "Attachment-Excel":  sRENDER_FORMAT = "EXCELOPENXML";  break;
												// 02/05/2021 Paul.  Use WORDOPENXML instead of WORD. 
												case "Attachment-Word" :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
												case "Attachment-Image":  sRENDER_FORMAT = "IMAGE"       ;  break;
												case "PDF"             :  sRENDER_FORMAT = "PDF"         ;  break;
												case "Excel"           :  sRENDER_FORMAT = "EXCELOPENXML";  break;
												case "Word"            :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
												case "Image"           :  sRENDER_FORMAT = "IMAGE"       ;  break;
											}
											Guid gSOURCE_ID = Guid.Empty;
											if ( sMODULE_NAME == "Quotes" || sMODULE_NAME == "Orders" || sMODULE_NAME == "Invoices" || sMODULE_NAME == "Payments" || sMODULE_NAME == "Contracts" )
											{
												string sMODULE_FIELD_ID   = String.Empty;
												// 06/27/2010 Paul.  Use new TableName function. 
												string sMODULE_TABLE_NAME = Modules.TableName(sMODULE_NAME);
												if ( sMODULE_TABLE_NAME.EndsWith("IES") )
													sMODULE_FIELD_ID = sMODULE_TABLE_NAME.Substring(0, sMODULE_TABLE_NAME.Length - 3) + "Y_ID";
												else if ( sMODULE_TABLE_NAME.EndsWith("S") )
													sMODULE_FIELD_ID = sMODULE_TABLE_NAME.Substring(0, sMODULE_TABLE_NAME.Length - 1) + "_ID";
												else
													sMODULE_FIELD_ID = sMODULE_TABLE_NAME + "_ID";
												if ( dict.ContainsKey(sMODULE_FIELD_ID) )
												{
													gSOURCE_ID = Sql.ToGuid(dict[sMODULE_FIELD_ID]);
												}
											}
											string sNOTE_NAME = ID.ToString();
											if ( !Sql.IsEmptyGuid(gSOURCE_ID) )
												sNOTE_NAME += "," + gSOURCE_ID.ToString();
											gNOTE_ID = await ReportsAttachmentView.RunReport(dictParameters, L10n, T10n, ID, sRDL, sRENDER_FORMAT, sMODULE_NAME, sREPORT_NAME, dtREPORT_DATE_MODIFIED, gSOURCE_ID, sNOTE_NAME, null);
										}
										else
										{
											throw(new Exception(L10n.Term("ACL.LBL_NO_ACCESS")));
										}
									}
								}
							}
						}
					}
					else
					{
						// 08/02/2019 Paul.  We want to see the error in the React Client. 
						string sMessage = "REPORTS cannot be accessed.";
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), sMessage);
						throw(new Exception(sMessage));
					}
				}
			}
			return gNOTE_ID;
		}
		
		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public IActionResult GetChartDesign(Guid ID)
		{
			string sModuleName = "Charts";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			string sMessage = String.Empty;
			if ( Security.IsAuthenticated() )
			{
				bool bDebug = Sql.ToBoolean(Application["CONFIG.show_sql"]);
#if DEBUG
				bDebug = true;
#endif
				using ( DataTable dtSYNC_TABLES = SplendidCache.RestTables("CHARTS", false) )
				{
					if ( dtSYNC_TABLES != null && dtSYNC_TABLES.Rows.Count > 0 )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select *"              + ControlChars.CrLf
							     + "  from vwCHARTS_Edit" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Security.Filter(cmd, sModuleName, "edit", "ASSIGNED_USER_ID", true);
								Sql.AppendParameter(cmd, ID, "ID", false);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dtCurrent = new DataTable() )
									{
										da.Fill(dtCurrent);
										// 10/31/2017 Paul.  Provide a way to inject Record level ACL. 
										if ( dtCurrent.Rows.Count > 0 && (Security.GetRecordAccess(dtCurrent.Rows[0], "Reports", "edit", "ASSIGNED_USER_ID") >= 0) )
										{
											DataRow rdr = dtCurrent.Rows[0];
											string sRDL = Sql.ToString(rdr["RDL"]);
											
											RdlDocument rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
											string sResponse = QueryDesigner.GetReportDesign(rdl, null, sRDL, L10n, bDebug);
											byte[] byResponse = Encoding.UTF8.GetBytes( sResponse );
											Response.ContentType = "text/xml";
											return File(byResponse, Response.ContentType);
										}
										else
										{
											throw(new Exception(L10n.Term("ACL.LBL_NO_ACCESS")));
										}
									}
								}
							}
						}
					}
					else
					{
						// 08/02/2019 Paul.  We want to see the error in the React Client. 
						sMessage = "CHARTS cannot be accessed.";
						SplendidError.SystemError(new StackTrace(true).GetFrame(0), sMessage);
						throw(new Exception(sMessage));
					}
				}
			}
			byte[] data = System.Text.Encoding.UTF8.GetBytes(sMessage);
			Response.ContentType = "text/plain";
			return File(data, Response.ContentType);
		}

		#endregion

		private void UpdateReportProperties(RdlDocument rdl, Dictionary<string, object> dict)
		{
			string sREPORT_TYPE = "tabular";
			// 02/11/2010 Paul.  The Report Name is important, so store in the Custom area. 
			// 03/27/2020 Paul.  Convert to dynamic layout to support React Client. 
			rdl.SetCustomProperty("ReportType"          , sREPORT_TYPE);
			rdl.SetCustomProperty("ReportName"          , (dict.ContainsKey("NAME"                ) ? Sql.ToString(dict["NAME"                ]) : String.Empty));
			rdl.SetCustomProperty("AssignedUserID"      , (dict.ContainsKey("ASSIGNED_USER_ID"    ) ? Sql.ToString(dict["ASSIGNED_USER_ID"    ]) : String.Empty));
			rdl.SetSingleNode    ("Author"              , (dict.ContainsKey("ASSIGNED_TO_NAME"    ) ? Sql.ToString(dict["ASSIGNED_TO_NAME"    ]) : String.Empty));
			rdl.SetSingleNode    ("Width"               , (dict.ContainsKey("PAGE_WIDTH"          ) ? Sql.ToString(dict["PAGE_WIDTH"          ]) : String.Empty));
			rdl.SetSingleNode    ("PageWidth"           , (dict.ContainsKey("PAGE_WIDTH"          ) ? Sql.ToString(dict["PAGE_WIDTH"          ]) : String.Empty));
			rdl.SetSingleNode    ("PageHeight"          , (dict.ContainsKey("PAGE_HEIGHT"         ) ? Sql.ToString(dict["PAGE_HEIGHT"         ]) : String.Empty));
			// 12/04/2010 Paul.  Add support for Business Rules Framework to Reports. 
			rdl.SetCustomProperty("PRE_LOAD_EVENT_ID"   , (dict.ContainsKey("PRE_LOAD_EVENT_ID"   ) ? Sql.ToString(dict["PRE_LOAD_EVENT_ID"   ]) : String.Empty));
			rdl.SetCustomProperty("PRE_LOAD_EVENT_NAME" , (dict.ContainsKey("PRE_LOAD_EVENT_NAME" ) ? Sql.ToString(dict["PRE_LOAD_EVENT_NAME" ]) : String.Empty));
			rdl.SetCustomProperty("POST_LOAD_EVENT_ID"  , (dict.ContainsKey("POST_LOAD_EVENT_ID"  ) ? Sql.ToString(dict["POST_LOAD_EVENT_ID"  ]) : String.Empty));
			rdl.SetCustomProperty("POST_LOAD_EVENT_NAME", (dict.ContainsKey("POST_LOAD_EVENT_NAME") ? Sql.ToString(dict["POST_LOAD_EVENT_NAME"]) : String.Empty));
		}

		#region Update
		[HttpPost("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Guid UpdateModule([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "Reports";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			string sTableName = Sql.ToString(Application["Modules." + sModuleName + ".TableName"]);
			if ( Sql.IsEmptyString(sTableName) )
				throw(new Exception("Unknown module: " + sModuleName));
			if ( !dict.ContainsKey("ReportDesign") )
				throw(new Exception("Missing ReportDesign"));
			
			bool bDesignChart = false;
			string sReportDesign = Sql.ToString(dict["ReportDesign"]);
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, bDesignChart);
			bool bPrimaryKeyOnly   = false;
			bool bUseSQLParameters = true ;
			bool bUserSpecific     = false;
			int  nSelectedColumns  = 0    ;
			UpdateReportProperties(rdl, dict);
			ReportDesign rd = JsonSerializer.Deserialize<ReportDesign>(sReportDesign);
			QueryDesigner.DisplayColumnsUpdate(rdl, rd);
			QueryDesigner.UpdateDataTable(rdl);
			string sReportSQL = QueryDesigner.BuildReportSQL(Application, L10n, rdl, rd, bPrimaryKeyOnly, bUseSQLParameters, bUserSpecific, ref nSelectedColumns);
			dict["RDL"] = rdl.OuterXml;
			// 02/09/2022 Paul.  If MODULE_NAME not specified, then use the first table in query. 
			if ( !dict.ContainsKey("MODULE_NAME") || Sql.IsEmptyString(dict["MODULE_NAME"]) )
			{
				if ( rd.Tables != null && rd.Tables.Length > 0 )
				{
					dict["MODULE_NAME"] = rd.Tables[0].ModuleName;
				}
			}

			Guid gID = RestUtil.UpdateTable(sTableName, dict);
			SplendidCache.ClearReports();

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

		[HttpPost("[action]")]
		public async Task SubmitSignature()
		{
			string sRequest = String.Empty;
			using ( StreamReader stmRequest = new StreamReader(Request.Body, System.Text.Encoding.UTF8) )
			{
				sRequest = stmRequest.ReadToEnd();
			}
			Dictionary<string, object> dict = JsonSerializer.Deserialize<Dictionary<string, object>>(sRequest);

			string sModuleName = "Reports";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			TimeZone T10n = TimeZone.CreateTimeZone(Sql.ToGuid(Application["CONFIG.default_timezone"]));
			Guid   gPARENT_ID   = (dict.ContainsKey("PARENT_ID"  ) ? Sql.ToGuid  (dict["PARENT_ID"  ]) : Guid.Empty  );
			string sPARENT_NAME = (dict.ContainsKey("PARENT_NAME") ? Sql.ToString(dict["PARENT_NAME"]) : String.Empty);
			if ( Sql.IsEmptyGuid(gPARENT_ID) )
			{
				throw(new Exception("Missing PARENT_ID"));
			}
			if ( Sql.IsEmptyString(sPARENT_NAME) )
			{
				throw(new Exception("Missing PARENT_NAME"));
			}
			SignedPDFData pdfData = await OrderUtils.CreateSignedPDF(L10n, T10n, sPARENT_NAME, gPARENT_ID, sRequest);
			Guid gIMAGE_ID           = pdfData.gIMAGE_ID          ;
			Guid gNOTE_ID            = pdfData.gNOTE_ID           ;
			Guid gNOTE_ATTACHMENT_ID = pdfData.gNOTE_ATTACHMENT_ID;
			Guid gREPORT_ID          = pdfData.gREPORT_ID         ;

			// 03/31/2016 Paul.  Change status to signed.  We are not going to put into the same transaction as the PDF generation is long-running. 
			switch ( sPARENT_NAME )
			{
				case "Contracts":  SqlProcs.spCONTRACTS_UpdateStatus(gPARENT_ID, "signed");  break;
				case "Quotes"   :  SqlProcs.spQUOTES_UpdateStage    (gPARENT_ID, "signed");  break;
				case "Orders"   :  SqlProcs.spORDERS_UpdateStage    (gPARENT_ID, "signed");  break;
				case "Invoices" :  SqlProcs.spINVOICES_UpdateStage  (gPARENT_ID, "signed");  break;
			}
		}
		#endregion
	}
}
