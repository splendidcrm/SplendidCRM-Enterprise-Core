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
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Authorization;

using SplendidCRM;
using System.Xml;

namespace SplendidCRM.Controllers.Administration.BusinessProcesses
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/BusinessProcesses/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "BusinessProcesses";
		private IMemoryCache         memoryCache        ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private L10N                 L10n               ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private XmlUtil              XmlUtil            ;
		private Workflow4BuildXaml   Workflow4BuildXaml ;

		public RestController(IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, XmlUtil XmlUtil, Workflow4BuildXaml Workflow4BuildXaml)
		{
			this.memoryCache         = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.XmlUtil             = XmlUtil            ;
			this.Workflow4BuildXaml  = Workflow4BuildXaml ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public Guid UpdateModule([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "BusinessProcesses";
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			string sTableName = Sql.ToString(Application["Modules." + sModuleName + ".TableName"]);
			if ( Sql.IsEmptyString(sTableName) )
				throw(new Exception("Unknown module: " + sModuleName));
			
			Guid   gID                    = Guid.Empty;
			Guid   gASSIGNED_USER_ID      = Guid.Empty;
			string sNAME                  = String.Empty;
			string sBASE_MODULE           = String.Empty;
			string sMODULE_TABLE          = String.Empty;
			string sAUDIT_TABLE           = String.Empty;
			bool   bSTATUS                = false;
			string sTYPE                  = String.Empty;
			string sRECORD_TYPE           = String.Empty;
			string sJOB_INTERVAL          = String.Empty; 
			string sFILTER_SQL            = String.Empty; 
			string sDESCRIPTION           = String.Empty;
			string sBPMN                  = String.Empty;
			string sSVG                   = String.Empty;
			string sXAML                  = String.Empty;
			string sFREQUENCY_LIMIT_UNITS = String.Empty;
			int    nFREQUENCY_LIMIT_VALUE = 0;
			
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "ID"  :  gID   = Sql.ToGuid  (dict[sColumnName]);  break;
					case "BPMN":  sBPMN = Sql.ToString(dict[sColumnName]);  break;
					case "SVG" :  sSVG  = Sql.ToString(dict[sColumnName]);  break;
				}
			}
			
			// <bpmn2:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn2="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xsi:schemaLocation="http://www.omg.org/spec/BPMN/20100524/MODEL BPMN20.xsd" id="sample-diagram" targetNamespace="http://bpmn.io/schema/bpmn">
			//   <bpmn2:process id="Process_1" isExecutable="false">
			//     <bpmn2:startEvent id="StartEvent_1">
			//       <bpmn2:timerEventDefinition />
			//     </bpmn2:startEvent>
			//   </bpmn2:process>
			
			// Standard options are timeDate, timeCycle, timeDuration
			//    <bpmn2:startEvent id="StartEvent_1">
			//      <bpmn2:timerEventDefinition>
			//        <bpmn2:timeCycle xsi:type="bpmn2:tFormalExpression">3</bpmn2:timeCycle>
			//      </bpmn2:timerEventDefinition>
			//    </bpmn2:startEvent>
			
			// <bpmn2:timerEventDefinition crm:JOB_INTERVAL="0::6::*::*::*" crm:FREQUENCY_LIMIT_UNITS="days" crm:FREQUENCY_LIMIT_VALUE="2" />
			
			BpmnDocument bpmn = new BpmnDocument(XmlUtil);
			bpmn.LoadBpmn(sBPMN);
			XmlNodeList nlProcesses = bpmn.SelectNodesNS("bpmn2:process");
			if ( nlProcesses.Count == 0 )
				throw(new Exception("Process not found"));
			else if ( nlProcesses.Count > 1 )
				throw(new Exception("Only one Process is allowed"));
			else
			{
				string sSTATUS = String.Empty;
				XmlNode xProcess = nlProcesses.Item(0);
				sNAME             =               bpmn.SelectNodeAttribute(xProcess, "name"                );
				gASSIGNED_USER_ID = Sql.ToGuid   (bpmn.SelectNodeAttribute(xProcess, "crm:ASSIGNED_USER_ID"));
				bSTATUS           = Sql.ToBoolean(bpmn.SelectNodeAttribute(xProcess, "crm:PROCESS_STATUS"  ));
				// 10/01/2016 Paul.  SelectNodeValue() can return null, so make sure to convert to a string. 
				sDESCRIPTION      = Sql.ToString (bpmn.SelectNodeValue    (xProcess, "bpmn2:documentation" ));
				
				if ( Sql.IsEmptyString(sNAME) )
					throw(new Exception("Process name is empty."));
				XmlNodeList nlStartEvents = bpmn.SelectNodesNS(xProcess, "bpmn2:startEvent");
				if ( nlStartEvents.Count == 0 )
					throw(new Exception("StartEvent not found"));
				else if ( nlStartEvents.Count > 1 )
					throw(new Exception("Only one StartEvent is allowed"));
				else
				{
					XmlNode xStartEvent = nlStartEvents.Item(0);
					sBASE_MODULE  = bpmn.SelectNodeAttribute(xStartEvent, "crm:BASE_MODULE");
					sRECORD_TYPE  = bpmn.SelectNodeAttribute(xStartEvent, "crm:RECORD_TYPE");
					sMODULE_TABLE = Sql.ToString(Application["Modules." + sBASE_MODULE + ".TableName"]);
					sAUDIT_TABLE  = sMODULE_TABLE + "_AUDIT";
					
					if ( Sql.IsEmptyString(sRECORD_TYPE) )
						sRECORD_TYPE = "all";
					if ( Sql.IsEmptyString(sBASE_MODULE) )
						throw(new Exception("Base Module is empty."));
					
					XmlNodeList nlTimerEvent = bpmn.SelectNodesNS(xStartEvent, "bpmn2:timerEventDefinition");
					if ( nlTimerEvent.Count > 1 )
					{
						throw(new Exception("Only one TimerEventDefinition is allowed"));
					}
					else if ( nlTimerEvent.Count == 0 )
					{
						sTYPE = "normal";
					}
					else
					{
						XmlNode xTimerEvent = nlTimerEvent.Item(0);
						sTYPE                  = "time";
						sJOB_INTERVAL          =               bpmn.SelectNodeAttribute(xTimerEvent, "crm:JOB_INTERVAL"         ) ;
						sFREQUENCY_LIMIT_UNITS =               bpmn.SelectNodeAttribute(xTimerEvent, "crm:FREQUENCY_LIMIT_UNITS") ;
						nFREQUENCY_LIMIT_VALUE = Sql.ToInteger(bpmn.SelectNodeAttribute(xTimerEvent, "crm:FREQUENCY_LIMIT_VALUE"));
								
						if ( Sql.IsEmptyString(sJOB_INTERVAL) )
							throw(new Exception("JOB_INTERVAL is missing from TimerEventDefinition."));
						if ( !Sql.IsEmptyString(sFREQUENCY_LIMIT_UNITS) && nFREQUENCY_LIMIT_VALUE <= 0 )
							throw(new Exception("FREQUENCY_LIMIT_VALUE must be > 0 when FREQUENCY_LIMIT_UNITS is specified."));
					}
					
					XmlNodeList nlExtensionElements = bpmn.SelectNodesNS(xStartEvent, "bpmn2:extensionElements");
					if ( nlExtensionElements.Count == 0 )
					{
						throw(new Exception("ExtensionElements not found with crmModuleFilter"));
					}
					else
					{
						XmlNode xExtensionElements = nlExtensionElements.Item(0);
						XmlNodeList nlModuleFilter = bpmn.SelectNodesNS(xExtensionElements, "crm:crmModuleFilter");
						if ( nlModuleFilter.Count > 1 )
						{
							throw(new Exception("Only one crmModuleFilter is allowed"));
						}
						else if ( nlModuleFilter.Count == 0 )
						{
							throw(new Exception("crmModuleFilter not found"));
						}
						else
						{
							XmlNode xModuleFilter = nlModuleFilter.Item(0);
							string sReportJson = xModuleFilter.InnerText;
							if ( Sql.IsEmptyString(sReportJson) )
							{
								throw(new Exception("crmModuleFilter report definition not found"));
							}
							// 07/14/2016 Paul.  We don't need to get and recalculate the SQL, but to ensure integrity, we are going to rely upon the BuildReportSQL() version. 
							sFILTER_SQL = bpmn.SelectNodeAttribute(xModuleFilter, "MODULE_FILTER_SQL") ;
							sFILTER_SQL = Workflow4BuildXaml.BuildReportSQL(sReportJson, sMODULE_TABLE, sTYPE, sFREQUENCY_LIMIT_UNITS, nFREQUENCY_LIMIT_VALUE);
						}
					}
				}
			}
			sXAML = Workflow4BuildXaml.ConvertBpmnToXaml(sBPMN);
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							// 07/30/2016 Paul.  Make the default false so that the process needs to be manually activated. 
							SqlProcs.spBUSINESS_PROCESSES_Update
								( ref gID          
								, gASSIGNED_USER_ID
								, sNAME            
								, sBASE_MODULE     
								, sAUDIT_TABLE     
								, bSTATUS          
								, sTYPE            
								, sRECORD_TYPE     
								, sJOB_INTERVAL    
								, sDESCRIPTION     
								, sFILTER_SQL      
								, sBPMN            
								, sSVG             
								, sXAML            
								, trn              
								);
							SqlProcs.spTRACKER_Update
								( Security.USER_ID
								, sModuleName
								, gID
								, sNAME
								, "save"
								, trn
								);
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
