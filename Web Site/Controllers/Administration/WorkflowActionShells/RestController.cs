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
using DocumentFormat.OpenXml.Presentation;
using System.Data.Common;
using System.IO;
using System.Workflow.ComponentModel.Compiler;
using System.Workflow.Runtime;

namespace SplendidCRM.Controllers.Administration.WorkflowActionShells
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/WorkflowActionShells/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "WorkflowActionShells";
		private IHttpContextAccessor httpContextAccessor;
		private IWebHostEnvironment  hostingEnvironment ;
		private IMemoryCache         memoryCache        ;
		private DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private L10N                 L10n               ;
		private TimeZone             TimeZone           = new TimeZone();
		private Crm.Config           Config             = new Crm.Config();
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private RestUtil             RestUtil           ;
		private XmlUtil              XmlUtil            ;
		private WorkflowInit         WorkflowInit       ;
		private WorkflowBuilder      WorkflowBuilder    ;

		public RestController(IHttpContextAccessor httpContextAccessor, IWebHostEnvironment hostingEnvironment, IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, RestUtil RestUtil, XmlUtil XmlUtil, WorkflowInit WorkflowInit, WorkflowBuilder WorkflowBuilder)
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
			this.WorkflowInit        = WorkflowInit       ;
			this.WorkflowBuilder     = WorkflowBuilder    ;
		}

		private XomlDocument BuildWorkflowXOML(HttpApplicationState Application, RdlDocument rdl, string BaseModule, Guid gPARENT_ID, string sWORKFLOW_TYPE, StringBuilder sbErrors)
		{
			// 08/09/2008 Paul.  The primary location for the WORKFLOW_ID will be in the SplendidSequentialWorkflow
			XomlDocument xoml = new XomlDocument(XmlUtil, "Workflow1", gPARENT_ID);
			if ( xoml.DocumentElement != null )
			{
				try
				{
					string sMODULE_TABLE = Sql.ToString(Application["Modules." + BaseModule + ".TableName"]);
					// 11/16/2008 Paul.  Time-based workflows reference the base module, not the audit table. 
					WorkflowBuilder.BuildActionXOML(xoml, null, rdl, sWORKFLOW_TYPE, BaseModule, sMODULE_TABLE, 1);
				}
				catch(Exception ex)
				{
					sbErrors.Append(ex.Message);
				}

				// 11/06/2023 Paul.  We cannot validate WF3 XOML. 
				/*
				try
				{
					Activity rootActivity = null;
					using ( StringReader stm = new StringReader(xoml.OuterXml) )
					{
						using ( XmlReader rdr = XmlReader.Create(stm) )
						{
							WorkflowMarkupSerializer xomlSerializer = new WorkflowMarkupSerializer();
							rootActivity = xomlSerializer.Deserialize(rdr) as Activity;
						}
					}
					WorkflowRuntime runtime = WorkflowInit.GetRuntime();
					Dictionary<string, object> dictParameters = new Dictionary<string, object>();
					//Guid gAUDIT_ID = new Guid("6BC0188C-4F1D-42FE-A303-002B1BC123CE");
					//dictParameters.Add("AUDIT_ID", gAUDIT_ID);
					WorkflowInstance inst = null;
					using ( StringReader stm = new StringReader(xoml.OuterXml) )
					{
						using ( XmlReader rdr = XmlReader.Create(stm) )
						{
							inst = runtime.CreateWorkflow(rdr, null, dictParameters);
						}
					}
				}
				catch(WorkflowValidationFailedException ex)
				{
					foreach ( var error in ex.Errors )
					{
						sbErrors.AppendLine(error.ToString() + "<br />");
					}
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), sbErrors.ToString());
				}
				catch(Exception ex)
				{
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
					sbErrors.Append("BuildWorkflowXOML: " + ex.Message);
				}
				*/
			}
			return xoml;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string BuildActionXOML([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "WorkflowActionShells";
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
			string sACTION_TYPE          = String.Empty;
			string sBASE_MODULE          = String.Empty;
			string sRELATED              = String.Empty;
			Guid   gPARENT_ID            = Guid.Empty;
			Dictionary<string, object> dictFilterXml        = null;
			Dictionary<string, object> dictRelatedModuleXml = null;
			Dictionary<string, object> dictRelationshipXml  = null;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "NAME"                :  sNAME                 = Sql.ToString(dict[sColumnName]);  break;
					case "BASE_MODULE"         :  sBASE_MODULE          = Sql.ToString(dict[sColumnName]);  break;
					case "RELATED"             :  sRELATED              = Sql.ToString(dict[sColumnName]);  break;
					case "ACTION_TYPE"         :  sACTION_TYPE          = Sql.ToString(dict[sColumnName]);  break;
					case "PARENT_ID"           :  gPARENT_ID            = Sql.ToGuid  (dict[sColumnName]);  break;
					case "filterXml"           :  dictFilterXml         = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relatedModuleXml"    :  dictRelatedModuleXml  = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relationshipXml"     :  dictRelationshipXml   = dict[sColumnName] as Dictionary<string, object>;  break;
				}
			}
			if ( Sql.IsEmptyGuid(gPARENT_ID) )
			{
				throw(new Exception("Missing PARENT_ID"));
			}
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, false);
			rdl.SetCustomProperty               ("Module"            , sBASE_MODULE);
			rdl.SetCustomProperty               ("Related"           , sRELATED    );
			// 06/02/2021 Paul.  React client needs to share code. 
			rdl.SetWorkflowFiltersCustomProperty(dictFilterXml       );
			rdl.SetRelatedModuleCustomProperty  (dictRelatedModuleXml);
			rdl.SetRelationshipCustomProperty   (dictRelationshipXml );

			string sXOML          = String.Empty;
			string sWORKFLOW_TYPE = String.Empty;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				sSQL = "select BASE_MODULE" + ControlChars.CrLf
				     + "     , TYPE       " + ControlChars.CrLf
				     + "  from vwWORKFLOWS" + ControlChars.CrLf
				     + " where ID = @ID   " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gPARENT_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							sBASE_MODULE   = Sql.ToString(rdr["BASE_MODULE"]);
							sWORKFLOW_TYPE = Sql.ToString(rdr["TYPE"       ]);
						}
						else
						{
							throw(new Exception("Workflow does not exist for " + gPARENT_ID.ToString()));
						}
					}
				}
				
				StringBuilder sbErrors = new StringBuilder();
				XomlDocument xoml = BuildWorkflowXOML(Application, rdl, sBASE_MODULE, gPARENT_ID, sWORKFLOW_TYPE, sbErrors);
				if ( sbErrors.Length > 0 )
					throw(new Exception(sbErrors.ToString()));

				sXOML = xoml.OuterXml;
			}
			return sXOML;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public Guid UpdateModule([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "WorkflowActionShells";
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
			string sACTION_TYPE          = String.Empty;
			string sBASE_MODULE          = String.Empty;
			string sRELATED              = String.Empty;
			Guid   gPARENT_ID            = Guid.Empty;
			Dictionary<string, object> dictFilterXml        = null;
			Dictionary<string, object> dictRelatedModuleXml = null;
			Dictionary<string, object> dictRelationshipXml  = null;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "NAME"                :  sNAME                 = Sql.ToString(dict[sColumnName]);  break;
					case "BASE_MODULE"         :  sBASE_MODULE          = Sql.ToString(dict[sColumnName]);  break;
					case "RELATED"             :  sRELATED              = Sql.ToString(dict[sColumnName]);  break;
					case "ACTION_TYPE"         :  sACTION_TYPE          = Sql.ToString(dict[sColumnName]);  break;
					case "PARENT_ID"           :  gPARENT_ID            = Sql.ToGuid  (dict[sColumnName]);  break;
					case "filterXml"           :  dictFilterXml         = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relatedModuleXml"    :  dictRelatedModuleXml  = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relationshipXml"     :  dictRelationshipXml   = dict[sColumnName] as Dictionary<string, object>;  break;
				}
			}
			if ( Sql.IsEmptyGuid(gPARENT_ID) )
			{
				throw(new Exception("Missing PARENT_ID"));
			}
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, false);
			rdl.SetCustomProperty               ("Module"            , sBASE_MODULE);
			rdl.SetCustomProperty               ("Related"           , sRELATED    );
			// 06/02/2021 Paul.  React client needs to share code. 
			rdl.SetWorkflowFiltersCustomProperty(dictFilterXml       );
			rdl.SetRelatedModuleCustomProperty  (dictRelatedModuleXml);
			rdl.SetRelationshipCustomProperty   (dictRelationshipXml );

			Guid   gID            = Guid.Empty;
			string sWORKFLOW_TYPE = String.Empty;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				sSQL = "select BASE_MODULE" + ControlChars.CrLf
				     + "     , TYPE       " + ControlChars.CrLf
				     + "  from vwWORKFLOWS" + ControlChars.CrLf
				     + " where ID = @ID   " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gPARENT_ID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							sBASE_MODULE   = Sql.ToString(rdr["BASE_MODULE"]);
							sWORKFLOW_TYPE = Sql.ToString(rdr["TYPE"       ]);
						}
						else
						{
							throw(new Exception("Workflow does not exist for " + gPARENT_ID.ToString()));
						}
					}
				}
				
				StringBuilder sbErrors = new StringBuilder();
				XomlDocument xoml = BuildWorkflowXOML(Application, rdl, sBASE_MODULE, gPARENT_ID, sWORKFLOW_TYPE, sbErrors);
				if ( sbErrors.Length > 0 )
					throw(new Exception(sbErrors.ToString()));

				dict["RDL" ] = rdl.OuterXml;
				dict["XOML"] = xoml.OuterXml;
				// 06/21/2021 Paul.  Move bExcludeSystemTables to method parameter so that it can be used by admin REST methods. 
				gID = RestUtil.UpdateTable(sTableName, dict, false);
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Clear(gID, trn);
						WorkflowBuilder.UpdateMasterWorkflowXoml(gPARENT_ID, trn);
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
