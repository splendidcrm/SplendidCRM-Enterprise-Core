/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
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
 *********************************************************************************************************************/
using System;
using System.Xml;
using System.Text;
using System.Text.Json;
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using System.Xaml;
using System.Activities;
using System.Activities.Validation;
using System.Activities.XamlIntegration;
using Microsoft.VisualBasic.Activities;
using System.Diagnostics;
using System.Reflection;

namespace SplendidCRM
{
	public class Workflow4BuildXaml
	{
		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private SplendidCache        SplendidCache      ;
		private XmlUtil              XmlUtil            ;
		private QueryDesigner        QueryDesigner      ;

		public Workflow4BuildXaml(HttpSessionState Session, SplendidCache SplendidCache, XmlUtil XmlUtil, QueryDesigner QueryDesigner)
		{
			this.Session             = Session            ;
			this.SplendidCache       = SplendidCache      ;
			this.XmlUtil             = XmlUtil            ;
			this.QueryDesigner       = QueryDesigner      ;
		}

		private List<string> AvailableTables()
		{
			List<string> lstTables      = new List<string>();
			List<string> lstModules     = new List<string>();
			List<string> lstDetailViews = new List<string>();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				sSQL = "select MODULE_NAME  as ModuleName  " + ControlChars.CrLf
				     + "     , TABLE_NAME   as TableName   " + ControlChars.CrLf
				     + "  from vwMODULES_Workflow          " + ControlChars.CrLf
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
							da.Fill( dt );
							foreach ( DataRow row in dt.Rows )
							{
								string sTableName  = Sql.ToString( row["TableName" ]);
								string sModuleName = Sql.ToString( row["ModuleName"]);
								lstTables .Add(sTableName );
								lstModules.Add(sModuleName);
								lstDetailViews.Add( sModuleName + ".DetailView" );
							}
						}
					}
				}
			}
			return lstTables;
		}

		private string ApplyAuditTable(string sTYPE, string sBASE_MODULE_TABLE, string sRELATIONSHIP_TABLE)
		{
			string sTABLE_NAME = sBASE_MODULE_TABLE;
			if ( sTYPE == "normal" )
			{
				if ( sBASE_MODULE_TABLE == sRELATIONSHIP_TABLE )
					sTABLE_NAME = sBASE_MODULE_TABLE + "_AUDIT";
			}
			return sTABLE_NAME;
		}

		public string BuildReportSQL(string sBPMN)
		{
			string sFILTER_SQL = String.Empty;
			BpmnDocument bpmn = new BpmnDocument(XmlUtil);
			bpmn.LoadBpmn(sBPMN);
			XmlNode xProcess = bpmn.DocumentElement.SelectSingleNode("bpmn2:process", bpmn.NamespaceManager);
			if ( xProcess != null )
			{
				XmlNode xStartEvent = xProcess.SelectSingleNode("bpmn2:startEvent", bpmn.NamespaceManager);
				if ( xStartEvent != null )
				{
					string sBASE_MODULE           = bpmn.SelectNodeAttribute(xStartEvent, "crm:BASE_MODULE");
					string sMODULE_TABLE          = Sql.ToString(Application["Modules." + sBASE_MODULE + ".TableName"]);
					string sTYPE                  = "normal";
					string sJOB_INTERVAL          = String.Empty;
					string sFREQUENCY_LIMIT_UNITS = String.Empty;
					int    nFREQUENCY_LIMIT_VALUE = 0;
					
					if ( Sql.IsEmptyString(sBASE_MODULE) )
						throw(new Exception("Base Module is empty."));
					
					XmlNode xTimerEvent = xStartEvent.SelectSingleNode("bpmn2:timerEventDefinition", bpmn.NamespaceManager);
					if ( xTimerEvent == null )
					{
						sTYPE = "normal";
					}
					else
					{
						sTYPE                  = "time";
						sJOB_INTERVAL          =               bpmn.SelectNodeAttribute(xTimerEvent, "crm:JOB_INTERVAL"         ) ;
						sFREQUENCY_LIMIT_UNITS =               bpmn.SelectNodeAttribute(xTimerEvent, "crm:FREQUENCY_LIMIT_UNITS") ;
						nFREQUENCY_LIMIT_VALUE = Sql.ToInteger(bpmn.SelectNodeAttribute(xTimerEvent, "crm:FREQUENCY_LIMIT_VALUE"));
						
						if ( Sql.IsEmptyString(sJOB_INTERVAL) )
							throw(new Exception("JOB_INTERVAL is missing from TimerEventDefinition."));
						if ( !Sql.IsEmptyString(sFREQUENCY_LIMIT_UNITS) && nFREQUENCY_LIMIT_VALUE <= 0 )
							throw(new Exception("FREQUENCY_LIMIT_VALUE must be > 0 when FREQUENCY_LIMIT_UNITS is specified."));
					}
					
					XmlNode xExtensionElements = xStartEvent.SelectSingleNode("bpmn2:extensionElements", bpmn.NamespaceManager);
					if ( xExtensionElements != null )
					{
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
							sFILTER_SQL = this.BuildReportSQL(sReportJson, sMODULE_TABLE, sTYPE, sFREQUENCY_LIMIT_UNITS, nFREQUENCY_LIMIT_VALUE);
						}
					}
				}
			}
			return sFILTER_SQL;
		}

		public string BuildReportSQL(string sJson, string sBASE_MODULE_TABLE, string sTYPE, string sFREQUENCY_LIMIT_UNITS, int nFREQUENCY_LIMIT_VALUE)
		{
			ReportDesign rd = JsonSerializer.Deserialize<ReportDesign>(sJson);
			
			bool bIsOracle     = false;
			bool bIsDB2        = false;
			bool bIsMySQL      = false;
			bool bIsPostgreSQL = false;
			string sSplendidProvider = Sql.ToString(Application["SplendidProvider"]);
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					bIsOracle     = Sql.IsOracle    (cmd);
					bIsDB2        = Sql.IsDB2       (cmd);
					bIsMySQL      = Sql.IsMySQL     (cmd);
					bIsPostgreSQL = Sql.IsPostgreSQL(cmd);
				}
			}
			
			string sReportSQL = String.Empty;
			StringBuilder sb         = new StringBuilder();
			StringBuilder sbACLWhere = new StringBuilder();
			StringBuilder sbErrors   = new StringBuilder();
			L10N L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			if ( rd != null && rd.Tables != null )
			{
				bool bBaseTableFound = false;
				List<string> lstAvailableTables = AvailableTables();
				Dictionary<string, int> oUsedTables  = new Dictionary<string, int>();
				for ( int i = 0; i < rd.Tables.Length; i++ )
				{
					if ( sBASE_MODULE_TABLE == rd.Tables[i].TableName )
						bBaseTableFound = true;
					oUsedTables[rd.Tables[i].TableName] = 0;
					if ( !lstAvailableTables.Contains(rd.Tables[i].TableName) )
					{
						throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + rd.Tables[i].TableName));
					}
				}
				if ( !bBaseTableFound )
				{
					throw(new Exception("Base Module/Table must be included in the filter."));
				}
				
				if ( sTYPE == "time" )
					sb.AppendLine("select " + sBASE_MODULE_TABLE + ".ID");
				else
					sb.AppendLine("select *");
				
				if ( rd.Relationships != null && rd.Relationships.Length > 0 )
				{
					for ( int i = 0; i < rd.Relationships.Length; i++ )
					{
						string sJoinType       = String.Empty;
						string sJoinTypeSpacer = String.Empty;
						ReportDesign.ReportRelationship oReportRelationship = rd.Relationships[i];
						switch ( oReportRelationship.JoinType )
						{
							case "inner"      :  sJoinType = " inner join "      ;  sJoinTypeSpacer = "        "      ;  break;
							case "left outer" :  sJoinType = "  left outer join ";  sJoinTypeSpacer = "              ";  break;
							case "right outer":  sJoinType = " right outer join ";  sJoinTypeSpacer = "              ";  break;
							case "full outer" :  sJoinType = "  full outer join ";  sJoinTypeSpacer = "              ";  break;
						}
						if ( i == 0 )
						{
							if ( !Sql.IsEmptyString(oReportRelationship.LeftTableName) && !Sql.IsEmptyString(oReportRelationship.RightTableName) )
							{
								sb.AppendLine("  from vw" + ApplyAuditTable(sTYPE, sBASE_MODULE_TABLE, oReportRelationship.LeftTableName) + " " + oReportRelationship.LeftTableName);
								// 02/24/2015 Paul.  Need to prime the object list before incrementing. 
								if ( !oUsedTables.ContainsKey(oReportRelationship.LeftTableName) )
									oUsedTables[oReportRelationship.LeftTableName] = 0;
								oUsedTables[oReportRelationship.LeftTableName] += 1;
								sb.AppendLine(sJoinType + "vw" + ApplyAuditTable(sTYPE, sBASE_MODULE_TABLE, oReportRelationship.RightTableName) + " " + oReportRelationship.RightTableName);
								// 02/24/2015 Paul.  Need to prime the object list before incrementing. 
								if ( !oUsedTables.ContainsKey(oReportRelationship.RightTableName) )
									oUsedTables[oReportRelationship.RightTableName] = 0;
								oUsedTables[oReportRelationship.RightTableName] += 1;
								if ( oReportRelationship.JoinFields == null || oReportRelationship.JoinFields.Length == 0 )
								{
									sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_JOIN_FIELDS").Replace("{0}", oReportRelationship.LeftTableName).Replace("{1}", oReportRelationship.RightTableName) + "<br />");
								}
								else
								{
									for ( int j = 0; j < oReportRelationship.JoinFields.Length; j++ )
									{
										ReportDesign.ReportJoinField oJoinField = oReportRelationship.JoinFields[j];
										sb.AppendLine(sJoinTypeSpacer + (j == 0 ? " on " : "and ") + oJoinField.RightFieldName + " " + oJoinField.OperatorType + " " + oJoinField.LeftFieldName);
									}
								}
							}
						}
						else if ( oUsedTables[oReportRelationship.LeftTableName] > 0 && oUsedTables[oReportRelationship.RightTableName] > 0 )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_COMBINE_RELATIONSHIPS").Replace("{0}", oReportRelationship.LeftTableName).Replace("{1}", oReportRelationship.RightTableName) + "<br />");
						}
						else if ( oUsedTables[oReportRelationship.LeftTableName] > 0 )
						{
							sb.AppendLine(sJoinType + "vw" + ApplyAuditTable(sTYPE, sBASE_MODULE_TABLE, oReportRelationship.RightTableName) + " " + oReportRelationship.RightTableName);
							// 02/24/2015 Paul.  Need to prime the object list before incrementing. 
							if ( !oUsedTables.ContainsKey(oReportRelationship.RightTableName) )
								oUsedTables[oReportRelationship.RightTableName] = 0;
							oUsedTables[oReportRelationship.RightTableName] += 1;
							if ( oReportRelationship.JoinFields == null || oReportRelationship.JoinFields.Length == 0 )
							{
								sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_JOIN_FIELDS").Replace("{0}", oReportRelationship.LeftTableName).Replace("{1}", oReportRelationship.RightTableName) + "<br />");
							}
							else
							{
								for ( int j = 0; j < oReportRelationship.JoinFields.Length; j++ )
								{
									ReportDesign.ReportJoinField oJoinField = oReportRelationship.JoinFields[j];
									sb.AppendLine(sJoinTypeSpacer + (j == 0 ? " on " : "and ") + oJoinField.RightFieldName + " " + oJoinField.OperatorType + " " + oJoinField.LeftFieldName);
								}
							}
						}
						else if ( oUsedTables[oReportRelationship.RightTableName] > 0 )
						{
							// 01/06/2014 Paul.  If left table does not exist in query, then switch the join type. 
							switch ( oReportRelationship.JoinType )
							{
								case "left outer" :  sJoinType = " right outer join ";  break;
								case "right outer":  sJoinType = "  left outer join ";  break;
							}
							sb.AppendLine(sJoinType + "vw" + ApplyAuditTable(sTYPE, sBASE_MODULE_TABLE, oReportRelationship.LeftTableName) + ' ' + oReportRelationship.LeftTableName);
							// 02/24/2015 Paul.  Need to prime the object list before incrementing. 
							if ( !oUsedTables.ContainsKey(oReportRelationship.LeftTableName) )
								oUsedTables[oReportRelationship.LeftTableName] = 0;
							oUsedTables[oReportRelationship.LeftTableName] += 1;
							if ( oReportRelationship.JoinFields == null || oReportRelationship.JoinFields.Length == 0 )
							{
								sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_JOIN_FIELDS").Replace("{0}", oReportRelationship.LeftTableName).Replace("{1}", oReportRelationship.RightTableName) + "<br />");
							}
							else
							{
								for ( int j = 0; j < oReportRelationship.JoinFields.Length; j++ )
								{
									ReportDesign.ReportJoinField oJoinField = oReportRelationship.JoinFields[j];
									sb.AppendLine(sJoinTypeSpacer + (j == 0 ? " on " : "and ") + oJoinField.RightFieldName + " " + oJoinField.OperatorType + " " + oJoinField.LeftFieldName);
								}
							}
						}
					}
				}
				else
				{
					oUsedTables[sBASE_MODULE_TABLE] += 1;
					sb.AppendLine("  from            vw" + ApplyAuditTable(sTYPE, sBASE_MODULE_TABLE, sBASE_MODULE_TABLE) + " " + sBASE_MODULE_TABLE);
				}
				if ( rd.AppliedFilters != null && rd.AppliedFilters.Length > 0 )
				{
					// 07/17/2016 Paul.  Add support for changed to support workflow. 
					// Look for the first occurence of a changed field, then add the audit join. 
					for ( int i = 0; i < rd.AppliedFilters.Length; i++ )
					{
						ReportDesign.ReportFilter oReportFilter = rd.AppliedFilters[i];
						// 07/17/2016 Paul.  Change event only applies to first table. 
						if ( oReportFilter.Operator == "changed" && oReportFilter.TableName == sBASE_MODULE_TABLE )
						{
							oUsedTables[sBASE_MODULE_TABLE] += 1;
							//  left outer join vwACCOUNTS_AUDIT      ACCOUNTS_AUDIT_OLD
							//               on ACCOUNTS_AUDIT_OLD.ID = ACCOUNTS.ID
							//              and ACCOUNTS_AUDIT_OLD.AUDIT_VERSION = (select max(vwACCOUNTS_AUDIT.AUDIT_VERSION)
							//                                                  from vwACCOUNTS_AUDIT
							//                                                 where vwACCOUNTS_AUDIT.ID            =  ACCOUNTS.ID
							//                                                   and vwACCOUNTS_AUDIT.AUDIT_VERSION <  ACCOUNTS.AUDIT_VERSION
							//                                                   and vwACCOUNTS_AUDIT.AUDIT_TOKEN   <> ACCOUNTS.AUDIT_TOKEN
							//                                               )
							sb.AppendLine("  left outer join vw" + oReportFilter.TableName + "_AUDIT        "   + oReportFilter.TableName + "_AUDIT_OLD");
							sb.AppendLine("               on "   + oReportFilter.TableName + "_AUDIT_OLD.ID = " + oReportFilter.TableName + ".ID");
							sb.AppendLine("              and "   + oReportFilter.TableName + "_AUDIT_OLD.AUDIT_VERSION = (select max(vw" + oReportFilter.TableName + "_AUDIT.AUDIT_VERSION)");
							sb.AppendLine("                                                  from vw" + oReportFilter.TableName + "_AUDIT");
							sb.AppendLine("                                                 where vw" + oReportFilter.TableName + "_AUDIT.ID            =  " + oReportFilter.TableName + ".ID");
							sb.AppendLine("                                                   and vw" + oReportFilter.TableName + "_AUDIT.AUDIT_VERSION <  " + oReportFilter.TableName + ".AUDIT_VERSION");
							sb.AppendLine("                                                   and vw" + oReportFilter.TableName + "_AUDIT.AUDIT_TOKEN   <> " + oReportFilter.TableName + ".AUDIT_TOKEN");
							sb.AppendLine("                                               )");
							break;
						}
					}
				}
				bool bUseWhereClause = true;
				if ( sTYPE == "time" )
				{
					if ( nFREQUENCY_LIMIT_VALUE > 0 )
					{
						bUseWhereClause = false;
						if ( sFREQUENCY_LIMIT_UNITS == "records" )
						{
							// 04/22/2018 Paul.  We should be using BUSINESS_PROCESSES_RUN and @BUSINESS_PROCESS_ID instead of WORKFLOW_RUN and @WORKFLOW_ID. 
							sb.AppendLine(" where " + nFREQUENCY_LIMIT_VALUE.ToString() + " > (select count(*)");
							sb.AppendLine("               from BUSINESS_PROCESSES_RUN");
							sb.AppendLine("              where BUSINESS_PROCESS_ID = @BUSINESS_PROCESS_ID");
							sb.AppendLine("                and AUDIT_ID    = " + sBASE_MODULE_TABLE + ".ID");
							sb.AppendLine("            )");
						}
						else
						{
							string fnPrefix = "dbo.";
							if ( bIsOracle || bIsDB2 || bIsMySQL || bIsPostgreSQL )
							{
								fnPrefix = "";
							}
							// 04/22/2018 Paul.  We should be using BUSINESS_PROCESSES_RUN and @BUSINESS_PROCESS_ID instead of WORKFLOW_RUN and @WORKFLOW_ID. 
							sb.AppendLine(" where not exists(select *");
							sb.AppendLine("                    from BUSINESS_PROCESSES_RUN");
							sb.AppendLine("                   where BUSINESS_PROCESS_ID = @BUSINESS_PROCESS_ID");
							sb.AppendLine("                     and AUDIT_ID    = " + sBASE_MODULE_TABLE + ".ID");
							sb.AppendLine("                     and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " < " + fnPrefix + "fnDateAdd('" + sFREQUENCY_LIMIT_UNITS + "', " + nFREQUENCY_LIMIT_VALUE.ToString() + ", BUSINESS_PROCESSES_RUN.DATE_ENTERED)");
							sb.AppendLine("                 )");
						}
					}
				}
				else
				{
					bUseWhereClause = false;
					sb.AppendLine(" where " + sBASE_MODULE_TABLE + ".AUDIT_ID = @AUDIT_ID");
				}
				if ( rd.AppliedFilters != null && rd.AppliedFilters.Length > 0 )
				{
					for ( int i = 0; i < rd.AppliedFilters.Length; i++ )
					{
						ReportDesign.ReportFilter oReportFilter = rd.AppliedFilters[i];
						
						// 04/22/2018 Paul.  We need to use the view and not the base table so as to include custom fields. 
						DataView vwColumns = SplendidCache.SqlColumns("vw" + oReportFilter.TableName).DefaultView;
						if ( Sql.IsEmptyString(oReportFilter.ColumnName) )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_FIELD").Replace("{0}", i.ToString()) + "<br />");
						}
						else if ( oReportFilter.Operator == null || oReportFilter.Operator == String.Empty )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName) + "<br />");
						}
						// 07/17/2016 Paul.  Add support for changed to support workflow. 
						// 08/17/2018 Paul.  Need to include empty and not_empty for workflow mode. 
						else if ( oReportFilter.Value == null && (oReportFilter.Operator != "empty" && oReportFilter.Operator != "not_empty" && oReportFilter.Operator != "is null" && oReportFilter.Operator != "is not null" && oReportFilter.Operator != "changed") && !oReportFilter.Parameter )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName) + "<br />");
						}
						else if ( Sql.IsEmptyString(oReportFilter.Value) && (QueryDesigner.IsNumericField(vwColumns, oReportFilter.ColumnName) || QueryDesigner.IsDateField(vwColumns, oReportFilter.ColumnName) || QueryDesigner.IsBooleanField(vwColumns, oReportFilter.ColumnName)) && !oReportFilter.Parameter )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName) + "<br />");
						}
						else
						{
							// 02/11/2018 Paul.  Workflow mode uses older style of operators. 
							vwColumns.RowFilter = "ColumnName = '" + oReportFilter.ColumnName + "'";
							if ( vwColumns.Count == 0 )
							{
								sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_FIELD").Replace("{0}", i.ToString()) + " " + oReportFilter.ColumnName + "<br />");
								continue;
							}
							string sCAT_SEP          = (bIsOracle ? " || " : " + ");
							string sOPERATOR         = oReportFilter.Operator;
							string sSEARCH_TEXT1     = "\'" + Sql.EscapeSQL(Sql.ToString(oReportFilter.Value)) + "\'";
							string sCOMMON_DATA_TYPE = Sql.ToString(vwColumns[0]["CsType"]).ToLower();
							if ( sCOMMON_DATA_TYPE == "ansistring" )
								sCOMMON_DATA_TYPE = "string";
							
							if ( bUseWhereClause )
							{
								sb.Append(" where ");
								bUseWhereClause = false;
							}
							else
							{
								sb.Append("   and ");
							}
							// 07/17/2016 Paul.  Add support for changed to support workflow. 
							if ( oReportFilter.Operator == "changed" )
							{
								// 07/17/2016 Paul.  Change event only applies to first table. 
								if ( oReportFilter.TableName == rd.Tables[0].TableName )
								{
									//   and (ACCOUNTS_AUDIT_OLD.AUDIT_ID is null or (not(ACCOUNTS.ASSIGNED_USER_ID is null and ACCOUNTS_AUDIT_OLD.ASSIGNED_USER_ID is null) and (ACCOUNTS.ASSIGNED_USER_ID <> ACCOUNTS_AUDIT_OLD.ASSIGNED_USER_ID or ACCOUNTS.ASSIGNED_USER_ID is null or ACCOUNTS_AUDIT_OLD.ASSIGNED_USER_ID is null)))
									sb.Append("(" + oReportFilter.TableName + "_AUDIT_OLD.AUDIT_ID is null or (not(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + " is null and " + oReportFilter.TableName + "_AUDIT_OLD." + oReportFilter.ColumnName + " is null    ) and (" + oReportFilter.TableName + "." + oReportFilter.ColumnName + " <> " + oReportFilter.TableName + "_AUDIT_OLD." + oReportFilter.ColumnName + " or " + oReportFilter.TableName + "." + oReportFilter.ColumnName + " is null or " + oReportFilter.TableName + "_AUDIT_OLD." + oReportFilter.ColumnName + " is null)))");
								}
							}
							// 08/17/2018 Paul.  Need to include empty and not_empty for workflow mode. 
							else if ( oReportFilter.Operator == "empty" || oReportFilter.Operator == "is null" )
							{
								sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
								sb.Append("is null");
							}
							else if ( oReportFilter.Operator == "not_empty" || oReportFilter.Operator == "is not null" )
							{
								sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
								sb.Append("is not null");
							}
							// 02/11/2018 Paul.  Workflow mode uses older style of operators. 
							else if ( oReportFilter.Operator == "in" || oReportFilter.Operator == "one_of" )
							{
								if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray )
								{
									sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
									sb.Append(" in (");
									object[] arrValue = oReportFilter.Value as object[];
									for ( int j = 0; j < arrValue.Length; j++ )
									{
										if ( j > 0 )
											sb.Append(", ");
										sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[j])) + "\'");
									}
									sb.Append(")");
								}
								else
								{
									sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_INVALID_ARRAY_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName).Replace("{1}", Sql.ToString(L10n.Term("report_filter_operator_dom", oReportFilter.Operator))) + "<br />");
								}
							}
							else if ( oReportFilter.Operator == "not in" )
							{
								if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray )
								{
									// 02/25/2015 Paul.  Filters that use NOT should protect against NULL values. 
									sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N\'\') ");
									sb.Append(" not in (");
									object[] arrValue = oReportFilter.Value as object[];
									for ( int j = 0; j < arrValue.Length; j++ )
									{
										if ( j > 0 )
											sb.Append(", ");
										sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[j])) + "\'");
									}
									sb.Append(")");
								}
								else
								{
									sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_INVALID_ARRAY_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName).Replace("{1}", Sql.ToString(L10n.Term("report_filter_operator_dom", oReportFilter.Operator))) + "<br />");
								}
							}
							// 02/24/2015 Paul.  Add support for between filter clause. 
							else if ( oReportFilter.Operator == "between" )
							{
								if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray && (oReportFilter.Value as object[]).Length >= 2 )
								{
									object[] arrValue = oReportFilter.Value as object[];
									sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
									sb.Append(oReportFilter.Operator + " ");
									sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[0])) + "\'");
									sb.Append(" and ");
									sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[1])) + "\'");
								}
								else
								{
									sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName).Replace("{1}", Sql.ToString(L10n.Term("report_filter_operator_dom", oReportFilter.Operator))) + "<br />");
								}
							}
							// 02/11/2018 Paul.  Workflow mode uses older style of operators. 
							else if ( oReportFilter.Operator == "between_dates" )
							{
								if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray && (oReportFilter.Value as object[]).Length >= 2 )
								{
									string fnPrefix = "dbo.";
									if ( bIsOracle || bIsDB2 || bIsMySQL || bIsPostgreSQL )
									{
										fnPrefix = "";
									}
									object[] arrValue = oReportFilter.Value as object[];
									sb.Append(fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");
									sb.Append(" between ");
									sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[0])) + "\'");
									sb.Append(" and ");
									sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[1])) + "\'");
								}
								else
								{
									sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName).Replace("{1}", Sql.ToString(L10n.Term("report_filter_operator_dom", oReportFilter.Operator))) + "<br />");
								}
							}
							else if ( oReportFilter.Value == null )
							{
								sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName) + "<br />");
							}
							else if ( oReportFilter.Operator == "like" )
							{
								sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
								sb.Append(oReportFilter.Operator);
								sb.Append(" ");
								// 06/14/2015 Paul.  We want to allow the original like syntax which uses % for any chars and _ for any single char. 
								sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(oReportFilter.Value)) + "\'");
							}
							else if ( oReportFilter.Operator == "not like" )
							{
								// 02/25/2015 Paul.  Filters that use NOT should protect against NULL values. 
								sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N\'\') ");
								sb.Append(oReportFilter.Operator);
								sb.Append(" ");
								// 06/14/2015 Paul.  We want to allow the original like syntax which uses % for any chars and _ for any single char. 
								sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(oReportFilter.Value)) + "\'");
							}
							else if ( oReportFilter.Operator == "<>" )
							{
								// 02/25/2015 Paul.  Filters that use NOT should protect against NULL values. 
								sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N\'\') ");
								sb.Append(oReportFilter.Operator);
								sb.Append(" ");
								sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(oReportFilter.Value)) + "\'");
							}
							// 02/11/2018 Paul.  Workflow mode uses older style of operators. 
							else if ( sCOMMON_DATA_TYPE == "string" )
							{
								// 04/22/2018 Paul.  Include enum is operator. 
								if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray )
								{
									object[] arrValue = oReportFilter.Value as object[];
									if ( arrValue.Length == 0 )
									{
										sSEARCH_TEXT1 = String.Empty;
										sOPERATOR = "empty";
									}
									else
									{
										if ( Sql.IsEmptyString(arrValue[0]) )
										{
											sSEARCH_TEXT1 = String.Empty;
											sOPERATOR = "empty";
										}
										else
										{
											sSEARCH_TEXT1 = "\'" + Sql.EscapeSQL(Sql.ToString(arrValue[0])) + "\'";
										}
									}
								}
								switch ( sOPERATOR )
								{
									// 04/22/2018 Paul.  Include enum is operator. 
									case "is"             :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " = "    + sSEARCH_TEXT1);  break;
									case "equals"         :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " = "    + sSEARCH_TEXT1);  break;
									case "less"           :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " < "    + sSEARCH_TEXT1);  break;
									case "less_equal"     :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " <= "   + sSEARCH_TEXT1);  break;
									case "greater"        :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " > "    + sSEARCH_TEXT1);  break;
									case "greater_equal"  :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " >= "   + sSEARCH_TEXT1);  break;
									case "contains"       :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
									case "starts_with"    :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " like " +                     sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
									case "ends_with"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1);  break;
									case "like"           :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
									case "empty"          :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is null"    );  break;
									case "not_empty"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is not null");  break;
									case "not_equals_str" :  sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N'')" + " <> "   + sSEARCH_TEXT1);  break;
									case "not_contains"   :  sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N'')" + " not like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
									case "not_starts_with":  sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N'')" + " not like " +                     sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
									case "not_ends_with"  :  sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N'')" + " not like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1);  break;
									case "not_like"       :  sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N'')" + " not like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
									default               :  sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNKNOWN_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName + " " + sOPERATOR) + "<br />"); break;
								}
							}
							else if ( sCOMMON_DATA_TYPE == "datetime" )
							{
								string fnPrefix = "dbo.";
								if ( bIsOracle || bIsDB2 || bIsMySQL || bIsPostgreSQL )
								{
									fnPrefix = "";
								}
								switch ( sOPERATOR )
								{
									case "on"               :  sb.Append(fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ") = "  + sSEARCH_TEXT1);  break;
									case "before"           :  sb.Append(fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ") < "  + sSEARCH_TEXT1);  break;
									case "after"            :  sb.Append(fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ") > "  + sSEARCH_TEXT1);  break;
									case "not_equals_str"   :  sb.Append(fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ") <> " + sSEARCH_TEXT1);  break;
									//case "between_dates"    :  sb.Append(fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ") between " + " @" + oReportFilter.ColumnName + "_AFTER" + " and " + "@" + oReportFilter.ColumnName + "_BEFORE");  break;
									// 04/19/2018 Paul.  Convert TODAY() to database-specific syntax. 
									case "tp_days_after"    :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('day', "    +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + "))");  break;
									case "tp_weeks_after"   :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('week', "   +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + "))");  break;
									case "tp_months_after"  :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('month', "  +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + "))");  break;
									case "tp_years_after"   :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('year', "   +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + "))");  break;
									case "tp_days_before"   :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('day', "    + "-" + sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")) and " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									case "tp_weeks_before"  :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('week', "   + "-" + sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")) and " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									case "tp_months_before" :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('month', "  + "-" + sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")) and " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									case "tp_years_before"  :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('year', "   + "-" + sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")) and " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									case "tp_minutes_after" :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('minute', " +       sSEARCH_TEXT1        + ", " + oReportFilter.TableName + "." + oReportFilter.ColumnName                             + ") and " + fnPrefix + "fnDateAdd('minute', " + "1+" + sSEARCH_TEXT1 + ", " + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									case "tp_hours_after"   :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('hour', "   +       sSEARCH_TEXT1        + ", " + oReportFilter.TableName + "." + oReportFilter.ColumnName                             + ") and " + fnPrefix + "fnDateAdd('hour', "   + "1+" + sSEARCH_TEXT1 + ", " + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									case "tp_minutes_before":  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('minute', " + "-" + sSEARCH_TEXT1 + "-1" + ", " + oReportFilter.TableName + "." + oReportFilter.ColumnName                             + ") and " + fnPrefix + "fnDateAdd('minute', " + "-"  + sSEARCH_TEXT1 + ", " + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									case "tp_hours_before"  :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('hour', "   + "-" + sSEARCH_TEXT1 + "-1" + ", " + oReportFilter.TableName + "." + oReportFilter.ColumnName                             + ") and " + fnPrefix + "fnDateAdd('hour', "   + "-"  + sSEARCH_TEXT1 + ", " + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									case "tp_days_old"      :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('day', "    +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + "))");  break;
									case "tp_weeks_old"     :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('week', "   +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + "))");  break;
									case "tp_months_old"    :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('month', "  +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + "))");  break;
									case "tp_years_old"     :  sb.Append(RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('year', "   +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + "))");  break;
									default                 :  sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNKNOWN_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName + " " + sOPERATOR) + "<br />"); break;
								}
							}
							else if ( sCOMMON_DATA_TYPE == "int16" || sCOMMON_DATA_TYPE == "int32" || sCOMMON_DATA_TYPE == "int64" )
							{
								switch ( sOPERATOR )
								{
									case "equals"       :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " = "    + sSEARCH_TEXT1);  break;
									case "less"         :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " < "    + sSEARCH_TEXT1);  break;
									case "greater"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " > "    + sSEARCH_TEXT1);  break;
									case "not_equals"   :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " <> "   + sSEARCH_TEXT1);  break;
									//case "between"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " between "   + " @" + oReportFilter.ColumnName + "_AFTER" + " and " + "@" + oReportFilter.ColumnName + "_BEFORE");  break;
									case "empty"        :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is null"    );  break;
									case "not_empty"    :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is not null");  break;
									case "less_equal"   :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " <= "    + sSEARCH_TEXT1);  break;
									case "greater_equal":  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " >= "    + sSEARCH_TEXT1);  break;
									default             :  sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNKNOWN_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName + " " + sOPERATOR) + "<br />"); break;
								}
							}
							else if ( sCOMMON_DATA_TYPE == "decimal" )
							{
								switch ( sOPERATOR )
								{
									case "equals"       :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " = "    + sSEARCH_TEXT1);  break;
									case "less"         :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " < "    + sSEARCH_TEXT1);  break;
									case "greater"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " > "    + sSEARCH_TEXT1);  break;
									case "not_equals"   :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " <> "   + sSEARCH_TEXT1);  break;
									//case "between"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " between "   + " @" + oReportFilter.ColumnName + "_AFTER" + " and " + "@" + oReportFilter.ColumnName + "_BEFORE");  break;
									case "empty"        :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is null"    );  break;
									case "not_empty"    :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is not null");  break;
									case "less_equal"   :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " <= "    + sSEARCH_TEXT1);  break;
									case "greater_equal":  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " >= "    + sSEARCH_TEXT1);  break;
									default             :  sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNKNOWN_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName + " " + sOPERATOR) + "<br />"); break;
								}
							}
							else if ( sCOMMON_DATA_TYPE == "float" )
							{
								switch ( sOPERATOR )
								{
									case "equals"       :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " = "    + sSEARCH_TEXT1);  break;
									case "less"         :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " < "    + sSEARCH_TEXT1);  break;
									case "greater"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " > "    + sSEARCH_TEXT1);  break;
									case "not_equals"   :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " <> "   + sSEARCH_TEXT1);  break;
									//case "between"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " between "   + " @" + oReportFilter.ColumnName + "_AFTER" + " and " + "@" + oReportFilter.ColumnName + "_BEFORE");  break;
									case "empty"        :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is null"    );  break;
									case "not_empty"    :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is not null");  break;
									case "less_equal"   :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " <= "    + sSEARCH_TEXT1);  break;
									case "greater_equal":  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " >= "    + sSEARCH_TEXT1);  break;
									default             :  sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNKNOWN_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName + " " + sOPERATOR) + "<br />"); break;
								}
							}
							else if ( sCOMMON_DATA_TYPE == "bool" )
							{
								switch ( sOPERATOR )
								{
									case "equals"    :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " = "    + sSEARCH_TEXT1);  break;
									case "empty"     :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is null"    );  break;
									case "not_empty" :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is not null");  break;
									default          :  sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNKNOWN_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName + " " + sOPERATOR) + "<br />"); break;
								}
							}
							else if ( sCOMMON_DATA_TYPE == "guid" )
							{
								switch ( sOPERATOR )
								{
									case "is"             :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " = "    + sSEARCH_TEXT1);  break;
									case "equals"         :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " = "    + sSEARCH_TEXT1);  break;
									case "contains"       :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
									case "starts_with"    :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " like " +                     sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
									case "ends_with"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1);  break;
									case "not_equals_str" :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " <> "   + sSEARCH_TEXT1);  break;
									case "empty"          :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is null"    );  break;
									case "not_empty"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is not null");  break;
									//case "one_of"         :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " in (@" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									default               :  sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNKNOWN_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName + " " + sOPERATOR) + "<br />"); break;
								}
							}
							else if ( sCOMMON_DATA_TYPE == "enum" )
							{
								switch ( sOPERATOR )
								{
									// 02/09/2007 Paul.  enum uses is instead of equals operator. 
									case "is"             :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " = "   + sSEARCH_TEXT1);  break;
									//case "one_of"         :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " in (@" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ")");  break;
									case "empty"          :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is null"    );  break;
									case "not_empty"      :  sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " is not null");  break;
									default               :  sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNKNOWN_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName + " " + sOPERATOR) + "<br />"); break;
								}
							}
							else
							{
								sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
								sb.Append(oReportFilter.Operator);
								sb.Append(" ");
								sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(oReportFilter.Value)) + "\'");
							}
							sb.AppendLine();
						}
					}
				}
				if ( rd.SelectedFields != null )
				{
					int nOrderBy = 0;
					for ( int i = 0; i < rd.SelectedFields.Length; i++ )
					{
						ReportDesign.ReportField oReportField = rd.SelectedFields[i];
						if ( !Sql.IsEmptyString(oReportField.SortDirection) )
						{
							sb.Append(nOrderBy == 0 ? " order by " : ", ");
							sb.Append(oReportField.FieldName + ' ' + oReportField.SortDirection);
							nOrderBy++;
						}
					}
					if ( nOrderBy > 0 )
						sb.AppendLine();
				}
				
				string sUnusedTables = String.Empty;
				foreach ( string sTableName in oUsedTables.Keys )
				{
					if ( oUsedTables[sTableName] == 0 )
					{
						if ( sUnusedTables.Length > 0 )
							sUnusedTables += ", ";
						sUnusedTables += sTableName;
					}
				}
				if ( sUnusedTables.Length > 0 )
				{
					sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNRELATED_ERROR").Replace("{0}", sUnusedTables));
				}
			}
			sReportSQL = sb.ToString();
			// 04/22/2018 Paul.  Alert when error is found.  Otherwise error is ignored. 
			if ( sbErrors.Length > 0 )
			{
				throw(new Exception(sbErrors.ToString()));
			}
			return sReportSQL;
		}

		// 07/26/2016 Paul.  WF 4.0: NullReferenceException in ActivityXamlServices.Load
		// https://mhusseini.wordpress.com/2014/05/20/nullreferenceexception-in-activityxamlservices-load/
		public System.Activities.Activity Load(XamlReader xamlReader, ActivityXamlServicesSettings settings)
		{
			if ( xamlReader == null )
			{
				throw(new Exception("xamlReader is null"));
			}
			if ( settings == null )
			{
				throw(new Exception("settings is null"));
			}

			//System.Activities.XamlIntegration.DynamicActivityXamlReader dynamicActivityReader = new System.Activities.XamlIntegration.DynamicActivityXamlReader(xamlReader);
			//object xamlObject = XamlServices.Load(dynamicActivityReader);
			//Activity result = xamlObject as Activity;
			Type readerType = typeof(ActivityXamlServices).Assembly.GetType("System.Activities.XamlIntegration.DynamicActivityXamlReader");
			XamlReader dynamicActivityReader = Activator.CreateInstance(readerType, xamlReader) as XamlReader;
			
			object xamlObject = XamlServices.Load(dynamicActivityReader);
			System.Activities.Activity result = xamlObject as System.Activities.Activity;
			if ( result == null )
			{
				throw(new Exception("ActivityXamlServicesRequiresActivity " + xamlObject != null ? xamlObject.GetType().FullName : string.Empty));
			}

			DynamicActivity dynamicActivity = xamlObject as DynamicActivity;
			dynamicActivity.Name = "SplendidCRM.Workflow4";
			if ( dynamicActivity != null && settings.CompileExpressions )
			{
				// 09/01/2023 Paul.  Compile is now public.  CoreWF requires settings, not LocationReferenceEnvironment. 
				try
				{
					ActivityXamlServices.Compile(dynamicActivity, settings);
				}
				catch(Exception ex)
				{
					System.Diagnostics.Debug.WriteLine("Workflow4BuildXaml.Load: " + ex.Message);
					throw;
				}
				//System.Reflection.MethodInfo method = typeof(ActivityXamlServices).GetMethod("Compile", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static);
				//method.Invoke(null, new object[] { dynamicActivity, settings.LocationReferenceEnvironment });
			}
			return result;
		}

		public void ValidateXaml(string sXAML)
		{
			System.Reflection.Assembly asm = System.Reflection.Assembly.GetExecutingAssembly();
			XamlXmlReaderSettings xamlSettings = new XamlXmlReaderSettings()
			{
				//BaseUri = new Uri("http://schemas.microsoft.com/netfx/2009/xaml/activities"),
				LocalAssembly = asm
			};
			VisualBasicSettings vbSettings = new VisualBasicSettings();
			vbSettings.ImportReferences.Add(new VisualBasicImportReference
			{
				Assembly = "SplendidCRM",
				Import   = "SplendidCRM"
			});
			using ( System.IO.StringReader stm = new System.IO.StringReader(sXAML) )
			{
				using ( XamlXmlReader rdr = new XamlXmlReader(stm, xamlSettings) )
				{
					ActivityXamlServicesSettings actSettings = new ActivityXamlServicesSettings { CompileExpressions = true };
					// 07/26/2016 Paul.  WF 4.0: NullReferenceException in ActivityXamlServices.Load
					// https://mhusseini.wordpress.com/2014/05/20/nullreferenceexception-in-activityxamlservices-load/
					//DynamicActivity workflow = ActivityXamlServices.Load(rdr, actSettings) as DynamicActivity;
					DynamicActivity workflow = this.Load(rdr, actSettings) as DynamicActivity;

					// 07/17/2016 Paul.  Must set VisualBasic.SetSettings otherwise validation will fail with definition of WF4Recipient.  
					VisualBasic.SetSettings(workflow, vbSettings);
					
					ValidationResults results = ActivityValidationServices.Validate(workflow);
					foreach (System.Activities.Validation.ValidationError warning in results.Warnings)
					{
						Debug.WriteLine(warning.ToString());
					}
					if ( results.Errors.Count > 0 )
					{
						StringBuilder sb = new StringBuilder();
						foreach ( System.Activities.Validation.ValidationError error in results.Errors )
						{
							sb.AppendLine(error.ToString() + "<br />");
						}
						throw(new Exception(sb.ToString()));
					}
				}
			}
		}

		public string CsTypeToXamlType(string sCsType)
		{
			string sTYPE   = "x:String";
			// Built-in Types for Common XAML Language Primitives
			// https://msdn.microsoft.com/en-us/library/ee792002(v=vs.110).aspx
			switch ( sCsType )
			{
				case "Guid"      :  sTYPE = "s:Guid"    ;  break;
				case "DateTime"  :  sTYPE = "s:DateTime";  break;
				case "Int64"     :  sTYPE = "x:Int64"   ;  break;
				case "Int32"     :  sTYPE = "x:Int32"   ;  break;
				case "Int16"     :  sTYPE = "x:Int16"   ;  break;
				case "short"     :  sTYPE = "x:Int16"   ;  break;
				case "ansistring":  sTYPE = "x:String"  ;  break;
				case "string"    :  sTYPE = "x:String"  ;  break;
				case "String"    :  sTYPE = "x:String"  ;  break;
				case "enum"      :  sTYPE = "x:String"  ;  break;
				case "bool"      :  sTYPE = "x:Boolean" ;  break;
				case "float"     :  sTYPE = "x:Double"  ;  break;
				case "Double"    :  sTYPE = "x:Double"  ;  break;
				case "decimal"   :  sTYPE = "x:Decimal" ;  break;
				case "Decimal"   :  sTYPE = "x:Decimal" ;  break;
				case "byte[]"    :  sTYPE = "x:Array"   ;  break;
			}
			return sTYPE;
		}

		public string ConvertBpmnToXaml(string sBPMN)
		{
			string sXAML = String.Empty;
			BpmnDocument bpmn = new BpmnDocument(XmlUtil);
			bpmn.LoadBpmn(sBPMN);
			XmlNode xProcess = bpmn.DocumentElement.SelectSingleNode("bpmn2:process", bpmn.NamespaceManager);
			if ( xProcess != null )
			{
				XmlNode xStartEvent = xProcess.SelectSingleNode("bpmn2:startEvent", bpmn.NamespaceManager);
				if ( xStartEvent != null )
				{
					string sBASE_MODULE  = bpmn.SelectNodeAttribute(xStartEvent, "crm:BASE_MODULE");
					sXAML = ConvertBpmnToXaml(bpmn, xProcess, sBASE_MODULE);
				}
			}
			return sXAML;
		}

		private string ConvertBpmnToXaml(BpmnDocument bpmn, XmlNode xBpmnProcess, string sBASE_MODULE)
		{
			XamlDocument xaml = new XamlDocument(XmlUtil);
			XmlElement xActivity = xaml.CreateRootActivity();
			
			XmlElement xMembers = xaml.CreateMembers(xActivity);
			xaml.CreateProperty(xMembers, "BUSINESS_PROCESS_ID", "InArgument(s:Guid)"  );
			xaml.CreateProperty(xMembers, "AUDIT_ID"           , "InArgument(s:Guid)"  );
			xaml.CreateProperty(xMembers, "ID"                 , "InArgument(s:Guid)"  );
			xaml.CreateProperty(xMembers, "BASE_MODULE"        , "InArgument(x:String)");
			DataTable dtFields = SplendidCache.WorkflowFilterColumns(sBASE_MODULE);
			foreach ( DataRow row in dtFields.Rows )
			{
				string sNAME   = Sql.ToString(row["NAME"  ]);
				string sCsType = Sql.ToString(row["CsType"]);
				string sTYPE   = CsTypeToXamlType(sCsType);
				if ( sNAME == "BUSINESS_PROCESS_ID" || sNAME == "AUDIT_ID" || sNAME == "ID" || sNAME == "BASE_MODULE" )
					continue;
				xaml.CreateProperty(xMembers, sNAME, "InArgument(" + sTYPE + ")");
#if DEBUG
				//break;
#endif
			}
			Guid gPROCESS_USER_ID  = Sql.ToGuid(bpmn.SelectNodeAttribute(xBpmnProcess, "crm:PROCESS_USER_ID" ));
			
			XmlElement xParallel = xaml.CreateParallel(xActivity);
			List<string> lstEventsFound = new List<string>();
			XmlNodeList nlStartEvents = bpmn.SelectNodesNS(xBpmnProcess, "bpmn2:startEvent");
			foreach ( XmlNode xBpmnStartEvent in nlStartEvents )
			{
				string sBpmnID = bpmn.SelectNodeAttribute(xBpmnStartEvent, "id");
				XmlElement xFlowchart = xaml.CreateFlowchart(xParallel, sBpmnID);
				XmlElement xFlowchartVariables = xaml.CreateFlowchartVariables(xFlowchart);

				XmlNodeList nlVariables = xBpmnProcess.SelectNodes("bpmn2:extensionElements/crm:crmProcessVariables/crm:crmVariable", bpmn.NamespaceManager);
				if ( nlVariables.Count > 0 )
				{
					foreach ( XmlNode xVariable in nlVariables )
					{
						string sVARIABLE_NAME    = bpmn.SelectNodeAttribute(xVariable, "VARIABLE_NAME"   );
						string sVARIABLE_TYPE    = bpmn.SelectNodeAttribute(xVariable, "VARIABLE_TYPE"   );
						string sVARIABLE_DEFAULT = bpmn.SelectNodeAttribute(xVariable, "VARIABLE_DEFAULT");
						string sTYPE  = CsTypeToXamlType(sVARIABLE_TYPE);
						xaml.CreateVariable(xFlowchartVariables, sVARIABLE_NAME, sTYPE, sVARIABLE_DEFAULT);
					}
				}
				xaml.CreateVariable(xFlowchartVariables, "PROCESS_USER_ID", "s:Guid", gPROCESS_USER_ID.ToString());
				if ( !lstEventsFound.Contains(sBpmnID) )
				{
					XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStartEvent);  // bpmn2:outgoing
					if ( xBpmnNextStep != null )
					{
						string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
						if ( !lstEventsFound.Contains(sBpmnNextStepID) )
						{
							xaml.CreateFlowchartStartNode(xFlowchart, sBpmnNextStepID);
							ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
						}
					}
				}
				// 08/24/2016 Paul.  To ensure that the flowchart does not proceed to the next step after an End, jump to an end that is always created. 
				XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, "SplendidCRM_EndStep");
				xaml.CreateEndActivity(xFlowStep);
			}
			return xaml.OutputFormatted();
		}

		private void ConvertBpmnEvent(List<string> lstEventsFound, XmlElement xFlowchart, XmlElement xFlowchartVariables, XmlNode xBpmnStep, string sBASE_MODULE)
		{
			XamlDocument xaml = xFlowchart.OwnerDocument as XamlDocument;
			BpmnDocument bpmn = xBpmnStep.OwnerDocument as BpmnDocument;
			string sBpmnStepID = bpmn.SelectNodeAttribute(xBpmnStep, "id");
			lstEventsFound.Add(sBpmnStepID);
			#region bpmn2:intermediateThrowEvent
			if ( xBpmnStep.Name == "bpmn2:intermediateThrowEvent" )
			{
				XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
				XmlNode xBpmnMessageEventDefinition = xBpmnStep.SelectSingleNode("bpmn2:messageEventDefinition", bpmn.NamespaceManager);
				if ( xBpmnMessageEventDefinition != null )
				{
					ConvertBpmnMessageEvent(xFlowStep, xBpmnStep, xBpmnMessageEventDefinition);
				}
				//XmlNode xBpmnEscalationEventDefinition = xBpmnStep.SelectSingleNode("bpmn2:escalationEventDefinition", bpmn.NamespaceManager);
				//if ( xBpmnEscalationEventDefinition != null )
				//{
				//	ConvertBpmnEscalationEvent(xFlowStep, xFlowchartVariables, xBpmnStep, xBpmnEscalationEventDefinition);
				//}
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					xaml.CreateFlowStepNext(xFlowStep, sBpmnNextStepID);
					if ( !lstEventsFound.Contains(sBpmnNextStepID) )
						ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			#endregion
			#region bpmn2:intermediateCatchEvent
			else if ( xBpmnStep.Name == "bpmn2:intermediateCatchEvent" )
			{
				XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
				XmlNode xBpmnTimerEventDefinition = xBpmnStep.SelectSingleNode("bpmn2:timerEventDefinition", bpmn.NamespaceManager);
				if ( xBpmnTimerEventDefinition != null )
				{
					ConvertBpmnTimerEvent(xFlowStep, xBpmnStep, xBpmnTimerEventDefinition);
				}
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					xaml.CreateFlowStepNext(xFlowStep, sBpmnNextStepID);
					if ( !lstEventsFound.Contains(sBpmnNextStepID) )
						ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			#endregion
			#region bpmn2:exclusiveGateway
			else if ( xBpmnStep.Name == "bpmn2:exclusiveGateway" )
			{
				XmlNodeList nlOutgoingRef = bpmn.SelectNodesNS(xBpmnStep, "bpmn2:outgoing");
				XmlNodeList nlIncomingRef = bpmn.SelectNodesNS(xBpmnStep, "bpmn2:incoming");
				if ( nlIncomingRef.Count == 1 && nlOutgoingRef.Count > 1 )
				{
					// 07/26/2016 Paul.  FlowDecision causes validation error "Object reference not set to an instance of an object."
#if false
					XmlElement xFlowSwitch = xaml.CreateFlowSwitch(xFlowchart, sBpmnStepID);
					Dictionary<string, string> dictConditions = new Dictionary<string,string>();
					foreach ( XmlNode xBpmnOutgoing in nlOutgoingRef )
					{
						string sSequenceFlowID = xBpmnOutgoing.InnerText;
						XmlNode xSequenceFlow = bpmn.DocumentElement.SelectSingleNode("//bpmn2:sequenceFlow[@id='" + sSequenceFlowID + "']", bpmn.NamespaceManager);
						if ( xSequenceFlow != null )
						{
							string sConditionExpression = String.Empty;
							XmlNode xCondition = xSequenceFlow.SelectSingleNode("bpmn2:conditionExpression", bpmn.NamespaceManager);
							if ( xCondition != null )
							{
								sConditionExpression = xCondition.InnerText;
								if ( !Sql.IsEmptyString(sConditionExpression) )
									dictConditions.Add(sSequenceFlowID, sConditionExpression);
							}
							string sBpmnNextStepID = bpmn.SelectNodeAttribute(xSequenceFlow, "targetRef");
							XmlNode xBpmnNextStep = bpmn.DocumentElement.SelectSingleNode("//*[@id='" + sBpmnNextStepID + "']", bpmn.NamespaceManager);
							if ( xBpmnNextStep != null )
							{
								XmlElement xFlowSwitchStep = null;
								if ( Sql.IsEmptyString(sConditionExpression) )
								{
									xFlowSwitchStep = xaml.CreateFlowStepDefault(xFlowSwitch, sBpmnNextStepID);
								}
								else
								{
									xFlowSwitchStep = xaml.CreateFlowStep(xFlowSwitch, sSequenceFlowID, sSequenceFlowID);
									xaml.CreateFlowStepNext(xFlowSwitchStep, sBpmnNextStepID);
								}
								if ( !lstEventsFound.Contains(sBpmnNextStepID) )
									ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
							}
						}
					}
					StringBuilder sbExpression = new StringBuilder();
					XmlAttribute xExpression = xaml.CreateAttribute("Expression");
					foreach ( string sConditionID in dictConditions.Keys )
					{
						string sConditionExpression = dictConditions[sConditionID];
						sbExpression.Append("(" + sConditionExpression + ") ? \"" + sConditionID + "\" : ");
					}
					sbExpression.Append("String.Empty");
					//foreach ( string sConditionID in dictConditions.Keys )
					//{
					//	sbExpression.Append(")");
					//}
					xFlowSwitch.Attributes.Append(xExpression);
#else
					bool bFirstFLowDecision = true;
					XmlElement xLastGatewayParent = xFlowchart;
					foreach ( XmlNode xBpmnOutgoing in nlOutgoingRef )
					{
						string sSequenceFlowID = xBpmnOutgoing.InnerText;
						XmlNode xSequenceFlow = bpmn.DocumentElement.SelectSingleNode("//bpmn2:sequenceFlow[@id='" + sSequenceFlowID + "']", bpmn.NamespaceManager);
						if ( xSequenceFlow != null )
						{
							string sCondition = String.Empty;
							XmlNode xCondition = xSequenceFlow.SelectSingleNode("bpmn2:conditionExpression", bpmn.NamespaceManager);
							if ( xCondition != null )
							{
								sCondition = xCondition.InnerText;
							}
							// 07/26/2016 Paul.  In first pass we only process outputs with a condition. 
							if ( Sql.IsEmptyString(sCondition) )
							{
								continue;
							}
							string sBpmnNextStepID = bpmn.SelectNodeAttribute(xSequenceFlow, "targetRef");
							XmlNode xBpmnNextStep = bpmn.DocumentElement.SelectSingleNode("//*[@id='" + sBpmnNextStepID + "']", bpmn.NamespaceManager);
							if ( xBpmnNextStep != null )
							{
								// 07/26/2016 Paul.  The CreateFlowDecision() method will return the FlowDecision.False element. 
								string sFlowDecisionName = sBpmnStepID + "_" + sSequenceFlowID;
								if ( bFirstFLowDecision )
								{
									sFlowDecisionName = sBpmnStepID;
									bFirstFLowDecision = false;
								}
								xLastGatewayParent = xaml.CreateFlowDecision(xLastGatewayParent, sFlowDecisionName, sSequenceFlowID, sCondition, sBpmnNextStepID);
								if ( !lstEventsFound.Contains(sBpmnNextStepID) )
									ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
							}
						}
					}
					foreach ( XmlNode xBpmnOutgoing in nlOutgoingRef )
					{
						string sSequenceFlowID = xBpmnOutgoing.InnerText;
						XmlNode xSequenceFlow = bpmn.DocumentElement.SelectSingleNode("//bpmn2:sequenceFlow[@id='" + sSequenceFlowID + "']", bpmn.NamespaceManager);
						if ( xSequenceFlow != null )
						{
							string sCondition = String.Empty;
							XmlNode xCondition = xSequenceFlow.SelectSingleNode("bpmn2:conditionExpression", bpmn.NamespaceManager);
							if ( xCondition != null )
							{
								sCondition = xCondition.InnerText;
							}
							// 07/26/2016 Paul.  In second pass we only process first output with no condition. 
							if ( !Sql.IsEmptyString(sCondition) )
							{
								continue;
							}
							string sBpmnNextStepID = bpmn.SelectNodeAttribute(xSequenceFlow, "targetRef");
							XmlNode xBpmnNextStep = bpmn.DocumentElement.SelectSingleNode("//*[@id='" + sBpmnNextStepID + "']", bpmn.NamespaceManager);
							if ( xBpmnNextStep != null )
							{
#if true
								xaml.CreateReference(xLastGatewayParent, sBpmnNextStepID);
#else
								XmlElement xFlowStep = xaml.CreateFlowStep(xLastGatewayParent, sSequenceFlowID);
								xaml.CreateNopActivity(xFlowStep);
								xaml.CreateFlowStepNext(xFlowStep, sBpmnNextStepID);
#endif
								if ( !lstEventsFound.Contains(sBpmnNextStepID) )
									ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
								break;
							}
						}
					}
#endif
				}
				else
				{
					// 07/25/2016 Paul.  This is a Join gateway. 
					XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
					if ( xBpmnNextStep != null )
					{
						// 07/25/2016 Paul.  Create an empty step.  We may need to add an activity that does nothing. 
						XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
						string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
						xaml.CreateFlowStepNext(xFlowStep, sBpmnNextStepID);
						if ( !lstEventsFound.Contains(sBpmnNextStepID) )
							ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
					}
				}
			}
			#endregion
			#region bpmn2:eventBasedGateway
			else if ( xBpmnStep.Name == "bpmn2:eventBasedGateway" )
			{
				XmlNodeList nlOutgoingRef = bpmn.SelectNodesNS(xBpmnStep, "bpmn2:outgoing");
				XmlNodeList nlIncomingRef = bpmn.SelectNodesNS(xBpmnStep, "bpmn2:incoming");
				if ( nlIncomingRef.Count == 1 && nlOutgoingRef.Count > 1 )
				{
					XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
					
					string sEventList = String.Empty;
					// 08/24/2016 Paul.  The EventGateway will return the join Event Gateway so that we can continue the conversion. 
					string sBpmnJoinEventGatewayID = ConvertBpmnEventGateway(lstEventsFound, xFlowStep, xFlowchartVariables, xBpmnStep, ref sEventList, sBASE_MODULE);
					XmlNode xBpmnJoinStep = bpmn.DocumentElement.SelectSingleNode("//*[@id='" + sBpmnJoinEventGatewayID + "']", bpmn.NamespaceManager);
					XmlElement xJoinFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnJoinEventGatewayID);
					lstEventsFound.Add(sBpmnJoinEventGatewayID);
					// 08/26/2016 Paul.  In this join gateway, we will want to mark as skipped any user tasks that were not processed. 
					xaml.CreateEndEventGatewayActivity(xJoinFlowStep, sEventList);
					
					XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnJoinStep);  // bpmn2:outgoing
					if ( xBpmnNextStep != null )
					{
						string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
						xaml.CreateFlowStepNext(xJoinFlowStep, sBpmnNextStepID);
						if ( !lstEventsFound.Contains(sBpmnNextStepID) )
							ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
					}
				}
				else
				{
					// 07/25/2016 Paul.  This is a Join gateway. 
					// 07/25/2016 Paul.  Create an empty step.  We may need to add an activity that does nothing. 
					XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
					// 08/25/2016 Paul.  An empty step does not generate an error. 
					//xaml.CreateNopActivity(xFlowStep);
					XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
					if ( xBpmnNextStep != null )
					{
						string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
						xaml.CreateFlowStepNext(xFlowStep, sBpmnNextStepID);
						if ( !lstEventsFound.Contains(sBpmnNextStepID) )
							ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
					}
				}
			}
			#endregion
			#region bpmn2:task
			else if ( xBpmnStep.Name == "bpmn2:task" )
			{
				XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
				ConvertBpmnTask(xFlowStep, xFlowchartVariables, xBpmnStep, sBASE_MODULE);
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					xaml.CreateFlowStepNext(xFlowStep, sBpmnNextStepID);
					if ( !lstEventsFound.Contains(sBpmnNextStepID) )
						ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			#endregion
			#region bpmn2:userTask
			else if ( xBpmnStep.Name == "bpmn2:userTask" )
			{
				XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
				ConvertBpmnUserTask(xFlowStep, xFlowchartVariables, xBpmnStep);
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					xaml.CreateFlowStepNext(xFlowStep, sBpmnNextStepID);
					if ( !lstEventsFound.Contains(sBpmnNextStepID) )
						ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			#endregion
			#region bpmn2:businessRuleTask
			else if ( xBpmnStep.Name == "bpmn2:businessRuleTask" )
			{
				XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
				ConvertBpmnBusinessRuleTask(xFlowStep, xFlowchartVariables, xBpmnStep);
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					xaml.CreateFlowStepNext(xFlowStep, sBpmnNextStepID);
					if ( !lstEventsFound.Contains(sBpmnNextStepID) )
						ConvertBpmnEvent(lstEventsFound, xFlowchart, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			#endregion
			#region bpmn2:endEvent
			else if ( xBpmnStep.Name == "bpmn2:endEvent" )
			{
				XmlElement xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
				XmlNode xBpmnMessageEventDefinition = xBpmnStep.SelectSingleNode("bpmn2:messageEventDefinition", bpmn.NamespaceManager);
				if ( xBpmnMessageEventDefinition != null )
				{
					ConvertBpmnMessageEvent(xFlowStep, xBpmnStep, xBpmnMessageEventDefinition);
				}
				else
				{
					// 08/25/2016 Paul.  An empty step does not generate an error. 
					//xaml.CreateNopActivity(xFlowStep);
				}
				// 07/14/2016 Paul.  An EndEvent should not have any outgoing events. 
				// 08/24/2016 Paul.  To ensure that the flowchart does not proceed to the next step after an End, jump to an end that is always created. 
				xaml.CreateFlowStepNext(xFlowStep, "SplendidCRM_EndStep");
			}
			#endregion
			else
			{
				throw(new Exception(xBpmnStep.Name + " is not a supported event."));
			}
		}

		private string FindJoinEventGateway(List<string> lstEventsFound, BpmnDocument bpmn, XmlNode xBpmnStep)
		{
			string sJoinEventGatewayID = String.Empty;
			string sBpmnStepID = bpmn.SelectNodeAttribute(xBpmnStep, "id");
			lstEventsFound.Add(sBpmnStepID);
			
			XmlNodeList nlOutgoingRef = bpmn.SelectNodesNS(xBpmnStep, "bpmn2:outgoing");
			foreach ( XmlNode xBpmnOutgoing in nlOutgoingRef )
			{
				string sSequenceFlowID = xBpmnOutgoing.InnerText;
				XmlNode xSequenceFlow = bpmn.DocumentElement.SelectSingleNode("//bpmn2:sequenceFlow[@id='" + sSequenceFlowID + "']", bpmn.NamespaceManager);
				if ( xSequenceFlow != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xSequenceFlow, "targetRef");
					XmlNode xBpmnNextStep = bpmn.DocumentElement.SelectSingleNode("//*[@id='" + sBpmnNextStepID + "']", bpmn.NamespaceManager);
					if ( xBpmnNextStep != null )
					{
						if ( xBpmnNextStep.Name == "bpmn2:eventBasedGateway" )
						{
							sJoinEventGatewayID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
							break;
						}
						else if ( !lstEventsFound.Contains(sBpmnNextStepID) )
						{
							return FindJoinEventGateway(lstEventsFound, bpmn, xBpmnNextStep);
						}
					}
				}
			}
			return sJoinEventGatewayID;
		}

		private void ConvertBpmnBranchEvent(List<string> lstEventsFound, string sJoinEventGatewayID, XmlElement xBranchSequence, XmlElement xFlowchartVariables, XmlNode xBpmnStep, string sBASE_MODULE)
		{
			XamlDocument xaml = xBranchSequence.OwnerDocument as XamlDocument;
			BpmnDocument bpmn = xBpmnStep.OwnerDocument as BpmnDocument;
			string sBpmnStepID = bpmn.SelectNodeAttribute(xBpmnStep, "id");
			lstEventsFound.Add(sBpmnStepID);
			if ( xBpmnStep.Name == "bpmn2:intermediateThrowEvent" )
			{
				XmlNode xBpmnMessageEventDefinition = xBpmnStep.SelectSingleNode("bpmn2:messageEventDefinition", bpmn.NamespaceManager);
				if ( xBpmnMessageEventDefinition != null )
				{
					ConvertBpmnMessageEvent(xBranchSequence, xBpmnStep, xBpmnMessageEventDefinition);
				}
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					if ( !lstEventsFound.Contains(sBpmnNextStepID) && sJoinEventGatewayID != sBpmnNextStepID )
						ConvertBpmnBranchEvent(lstEventsFound, sJoinEventGatewayID, xBranchSequence, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			else if ( xBpmnStep.Name == "bpmn2:intermediateCatchEvent" )
			{
				XmlNode xBpmnTimerEventDefinition = xBpmnStep.SelectSingleNode("bpmn2:timerEventDefinition", bpmn.NamespaceManager);
				if ( xBpmnTimerEventDefinition != null )
				{
					ConvertBpmnTimerEvent(xBranchSequence, xBpmnStep, xBpmnTimerEventDefinition);
				}
				else
				{
					throw(new Exception("A Timer Event is the only kind of Intermediate Catch Event that is allowed in a Event-Based Gateway branch."));
				}
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					if ( !lstEventsFound.Contains(sBpmnNextStepID) && sJoinEventGatewayID != sBpmnNextStepID )
						ConvertBpmnBranchEvent(lstEventsFound, sJoinEventGatewayID, xBranchSequence, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			else if ( xBpmnStep.Name == "bpmn2:exclusiveGateway" )
			{
				throw(new Exception("Exclusive Gateway is not allow in a branch of an Event-Based Gateway."));
			}
			else if ( xBpmnStep.Name == "bpmn2:eventBasedGateway" )
			{
				throw(new Exception("Event-Based Gateway is not allow in a branch of an Event-Based Gateway."));
			}
			else if ( xBpmnStep.Name == "bpmn2:task" )
			{
				ConvertBpmnTask(xBranchSequence, xFlowchartVariables, xBpmnStep, sBASE_MODULE);
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					if ( !lstEventsFound.Contains(sBpmnNextStepID) && sJoinEventGatewayID != sBpmnNextStepID )
						ConvertBpmnBranchEvent(lstEventsFound, sJoinEventGatewayID, xBranchSequence, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			else if ( xBpmnStep.Name == "bpmn2:userTask" )
			{
				ConvertBpmnUserTask(xBranchSequence, xFlowchartVariables, xBpmnStep);
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					if ( !lstEventsFound.Contains(sBpmnNextStepID) && sJoinEventGatewayID != sBpmnNextStepID )
						ConvertBpmnBranchEvent(lstEventsFound, sJoinEventGatewayID, xBranchSequence, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			else if ( xBpmnStep.Name == "bpmn2:businessRuleTask" )
			{
				ConvertBpmnBusinessRuleTask(xBranchSequence, xFlowchartVariables, xBpmnStep);
				
				XmlNode xBpmnNextStep = bpmn.SelectNextStep(xBpmnStep);  // bpmn2:outgoing
				if ( xBpmnNextStep != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xBpmnNextStep, "id");
					if ( !lstEventsFound.Contains(sBpmnNextStepID) && sJoinEventGatewayID != sBpmnNextStepID )
						ConvertBpmnBranchEvent(lstEventsFound, sJoinEventGatewayID, xBranchSequence, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
				}
			}
			else if ( xBpmnStep.Name == "bpmn2:endEvent" )
			{
				throw(new Exception(sBpmnStepID + " is not allow in a branch of an Event-Based Gateway."));
			}
			else
			{
				throw(new Exception(xBpmnStep.Name + " is not a supported event."));
			}
		}

		private string ConvertBpmnEventGateway(List<string> lstEventsFound, XmlElement xFlowStep, XmlElement xFlowchartVariables, XmlNode xBpmnStep, ref string sEventList, string sBASE_MODULE)
		{
			XamlDocument xaml = xFlowStep.OwnerDocument as XamlDocument;
			BpmnDocument bpmn = xBpmnStep.OwnerDocument as BpmnDocument;
			
			string sBpmnStepID = bpmn.SelectNodeAttribute(xBpmnStep, "id");
			XmlNodeList nlOutgoingRef = bpmn.SelectNodesNS(xBpmnStep, "bpmn2:outgoing");
			
			string sBpmnJoinEventGatewayID = String.Empty;
			List<string> lstFindHelper = new List<string>();
			lstFindHelper.Add(sBpmnStepID);
			foreach ( XmlNode xBpmnOutgoing in nlOutgoingRef )
			{
				string sBranchJoinEventGatewayID = String.Empty;
				string sSequenceFlowID = xBpmnOutgoing.InnerText;
				XmlNode xSequenceFlow = bpmn.DocumentElement.SelectSingleNode("//bpmn2:sequenceFlow[@id='" + sSequenceFlowID + "']", bpmn.NamespaceManager);
				if ( xSequenceFlow != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xSequenceFlow, "targetRef");
					XmlNode xBpmnNextStep = bpmn.DocumentElement.SelectSingleNode("//*[@id='" + sBpmnNextStepID + "']", bpmn.NamespaceManager);
					if ( xBpmnNextStep != null )
					{
						sBranchJoinEventGatewayID = FindJoinEventGateway(lstFindHelper, bpmn, xBpmnNextStep);
					}
				}
				if ( Sql.IsEmptyString(sBranchJoinEventGatewayID) )
				{
					throw(new Exception("All branches of Event-Based Gateway " + sBpmnStepID + " should end with a joining Event-Based Gateway."));
				}
				if ( Sql.IsEmptyString(sBpmnJoinEventGatewayID) )
				{
					sBpmnJoinEventGatewayID = sBranchJoinEventGatewayID;
				}
				else if ( sBpmnJoinEventGatewayID != sBranchJoinEventGatewayID )
				{
					throw(new Exception("All branches of Event-Based Gateway " + sBpmnStepID + " should end with the same joining Event-Based Gateway."));
				}
			}
			if ( Sql.IsEmptyString(sBpmnJoinEventGatewayID) )
			{
				throw(new Exception("Event-Based Gateway " + sBpmnStepID + " should end with a joining Event-Based Gateway."));
			}
			lstFindHelper.Remove(sBpmnStepID);
			sEventList = String.Join(",", lstFindHelper.ToArray());
			
			XmlElement xPick = xaml.CreatePick(xFlowStep);
			foreach ( XmlNode xBpmnOutgoing in nlOutgoingRef )
			{
				string sSequenceFlowID = xBpmnOutgoing.InnerText;
				XmlNode xSequenceFlow = bpmn.DocumentElement.SelectSingleNode("//bpmn2:sequenceFlow[@id='" + sSequenceFlowID + "']", bpmn.NamespaceManager);
				if ( xSequenceFlow != null )
				{
					string sBpmnNextStepID = bpmn.SelectNodeAttribute(xSequenceFlow, "targetRef");
					if ( sBpmnJoinEventGatewayID == sBpmnNextStepID )
					{
						throw(new Exception("All branches of Event-Based Gateway " + sBpmnStepID + " must contain a task or a timer."));
					}
					XmlNode xBpmnNextStep = bpmn.DocumentElement.SelectSingleNode("//*[@id='" + sBpmnNextStepID + "']", bpmn.NamespaceManager);
					if ( xBpmnNextStep != null )
					{
						string sBpmnNextStepName = bpmn.SelectNodeAttribute(xBpmnNextStep, "name");
						if ( Sql.IsEmptyString(sBpmnNextStepName) )
							sBpmnNextStepName = sBpmnNextStepID + "_Branch";
						XmlElement xPickBranch = xaml.CreatePickBranch(xPick, sBpmnNextStepName);
						XmlElement xPickBranchTrigger = xaml.CreatePickBranchTrigger(xPickBranch);
						
						XmlElement xBranchSequence = xaml.CreateSequence(xPickBranchTrigger, sBpmnNextStepID + "_PickBranch");
						lstFindHelper = new List<string>();
						ConvertBpmnBranchEvent(lstFindHelper, sBpmnJoinEventGatewayID, xBranchSequence, xFlowchartVariables, xBpmnNextStep, sBASE_MODULE);
					}
				}
			}
			xaml.CreateFlowStepNext(xFlowStep, sBpmnJoinEventGatewayID);
			return sBpmnJoinEventGatewayID;
		}

		private void ConvertBpmnTask(XmlElement xFlowStep, XmlElement xFlowchartVariables, XmlNode xBpmnStep, string sBASE_MODULE)
		{
			XamlDocument xaml = xFlowStep.OwnerDocument as XamlDocument;
			BpmnDocument bpmn = xBpmnStep.OwnerDocument as BpmnDocument;
			string sBpmnStepID = bpmn.SelectNodeAttribute(xBpmnStep, "id");

			string sMODULE_NAME  = bpmn.SelectNodeAttribute(xBpmnStep, "crm:MODULE_NAME" );
			string sOPERATION    = bpmn.SelectNodeAttribute(xBpmnStep, "crm:OPERATION"   );
			string sFIELD_PREFIX = bpmn.SelectNodeAttribute(xBpmnStep, "crm:FIELD_PREFIX");
			string sSOURCE_ID    = bpmn.SelectNodeAttribute(xBpmnStep, "crm:SOURCE_ID"   );
			// 07/24/2016 Paul.  The variables need to be put in the flowchart so that they can bet used flowchart wide. 
			XmlElement xSequence = xaml.CreateSequence(xFlowStep , sBpmnStepID + "_Sequence");
			//XmlElement xSequenceVariables = xaml.CreateSequenceVariables(xSequence);
			if ( Sql.IsEmptyString(sOPERATION) )
				sOPERATION = "load_module";
			if ( Sql.IsEmptyString(sMODULE_NAME) )
				throw(new Exception("Module has not been specified."));
			
			//xaml.CreateDumpPropertiesActivity(xSequence);
			if ( sOPERATION == "load_module" )
			{
				string sFIELD_LIST = String.Empty;
				List<string> lstFields = new List<string>();
				XmlNodeList nlProperties = xBpmnStep.SelectNodes("bpmn2:extensionElements/camunda:properties/camunda:property", bpmn.NamespaceManager);
				if ( nlProperties.Count > 0 )
				{
					foreach ( XmlNode xProperty in nlProperties )
					{
						string sNAME  = bpmn.SelectNodeAttribute(xProperty, "name").ToUpper();
						lstFields.Add(sNAME);
					}
					sFIELD_LIST = String.Join(",", lstFields.ToArray());
				}
				// 09/02/2016 Paul.  We want to make it easier to load a module by leaving the prefix blank. 
				if ( !Sql.IsEmptyString(sFIELD_PREFIX) || sBASE_MODULE != sMODULE_NAME )
				{
					DataTable dtFields = SplendidCache.WorkflowFilterColumns(sMODULE_NAME);
					foreach ( DataRow row in dtFields.Rows )
					{
						string sNAME   = Sql.ToString(row["NAME"  ]);
						string sCsType = Sql.ToString(row["CsType"]);
						string sTYPE   = CsTypeToXamlType(sCsType);
						if ( lstFields.Count == 0 || lstFields.Contains(sNAME.ToUpper()) )
							xaml.CreateVariable(xFlowchartVariables, sFIELD_PREFIX + sNAME, sTYPE, String.Empty);
					}
				}
				if ( sSOURCE_ID.StartsWith("\"") || sSOURCE_ID.EndsWith("\"") )
					sSOURCE_ID = sSOURCE_ID.Substring(1, sSOURCE_ID.Length - 2);
				else if ( !sSOURCE_ID.StartsWith("[") && !sSOURCE_ID.EndsWith("[") )
					sSOURCE_ID = "[" + sSOURCE_ID + "]";
				XmlElement xLoadModule = xaml.CreateLoadModuleActivity(xSequence, sMODULE_NAME, sOPERATION, sFIELD_PREFIX, sSOURCE_ID, sFIELD_LIST);
			}
			else if ( sOPERATION == "save_module" )
			{
				XmlElement xSequenceVariables = xaml.CreateSequenceVariables(xSequence);
				DataView vwFields = new DataView(SplendidCache.WorkflowFilterColumns(sMODULE_NAME));
				sFIELD_PREFIX = sBpmnStepID + "_";
				if ( sSOURCE_ID.StartsWith("\"") || sSOURCE_ID.EndsWith("\"") )
					sSOURCE_ID = sSOURCE_ID.Substring(1, sSOURCE_ID.Length - 2);
				else if ( !sSOURCE_ID.StartsWith("[") && !sSOURCE_ID.EndsWith("[") )
					sSOURCE_ID = "[" + sSOURCE_ID + "]";
				XmlNodeList nlProperties = xBpmnStep.SelectNodes("bpmn2:extensionElements/camunda:properties/camunda:property", bpmn.NamespaceManager);
				if ( nlProperties.Count == 0 )
				{
					throw(new Exception("Fields not found in " + xBpmnStep.Name));
				}
				else
				{
					foreach ( XmlNode xProperty in nlProperties )
					{
						string sNAME  = bpmn.SelectNodeAttribute(xProperty, "name" );
						string sVALUE = bpmn.SelectNodeAttribute(xProperty, "value");
						// 07/28/2016 Paul.  ID must be set in Source ID property. 
						if ( sNAME.ToUpper() == "ID" )
							continue;
						vwFields.RowFilter = "NAME = '" + sNAME + "'";
						if ( vwFields.Count > 0 )
						{
							string sCsType = Sql.ToString(vwFields[0]["CsType"]);
							string sTYPE   = CsTypeToXamlType(sCsType);
							xaml.CreateVariable(xSequenceVariables, sFIELD_PREFIX + sNAME, sTYPE, String.Empty);
							xaml.CreateAssignActivity(xSequence, sTYPE, sFIELD_PREFIX + sNAME, sVALUE);
						}
					}
				}
				XmlElement xSaveModule = xaml.CreateSaveModuleActivity(xSequence, sMODULE_NAME, sOPERATION, sFIELD_PREFIX, sSOURCE_ID);
			}
			else if ( sOPERATION == "assign_module" )
			{
				XmlElement xSequenceVariables = xaml.CreateSequenceVariables(xSequence);
				DataView vwFields = new DataView(SplendidCache.WorkflowFilterColumns(sMODULE_NAME));
				if ( sSOURCE_ID.StartsWith("\"") || sSOURCE_ID.EndsWith("\"") )
					sSOURCE_ID = sSOURCE_ID.Substring(1, sSOURCE_ID.Length - 2);
				else if ( !sSOURCE_ID.StartsWith("[") && !sSOURCE_ID.EndsWith("[") )
					sSOURCE_ID = "[" + sSOURCE_ID + "]";
				string sUSER_ASSIGNMENT_METHOD  = bpmn.SelectNodeAttribute(xBpmnStep, "crm:USER_ASSIGNMENT_METHOD" );
				string sSTATIC_ASSIGNED_USER_ID = bpmn.SelectNodeAttribute(xBpmnStep, "crm:STATIC_ASSIGNED_USER_ID");
				string sSTATIC_ASSIGNED_TEAM_ID = bpmn.SelectNodeAttribute(xBpmnStep, "crm:STATIC_ASSIGNED_TEAM_ID");
				string sDYNAMIC_PROCESS_TEAM_ID = bpmn.SelectNodeAttribute(xBpmnStep, "crm:DYNAMIC_PROCESS_TEAM_ID");
				string sDYNAMIC_PROCESS_ROLE_ID = bpmn.SelectNodeAttribute(xBpmnStep, "crm:DYNAMIC_PROCESS_ROLE_ID");
				if ( Sql.IsEmptyString(sUSER_ASSIGNMENT_METHOD) )
					sUSER_ASSIGNMENT_METHOD = "Round Robin Team";
				switch ( sUSER_ASSIGNMENT_METHOD )
				{
					case "Round Robin Team":
						if ( Sql.IsEmptyString(sDYNAMIC_PROCESS_TEAM_ID) )
							throw(new Exception("Round Robin Team was not specified for " + sBpmnStepID));
						break;
					case "Round Robin Role":
						if ( Sql.IsEmptyString(sDYNAMIC_PROCESS_ROLE_ID) )
							throw(new Exception("Round Robin Role was not specified for " + sBpmnStepID));
						break;
					case "Static User":
						if ( Sql.IsEmptyString(sSTATIC_ASSIGNED_USER_ID) )
							throw(new Exception("Static User was not specified for " + sBpmnStepID));
						break;
					case "Static Team":
						if ( Sql.IsEmptyString(sSTATIC_ASSIGNED_TEAM_ID) )
							throw(new Exception("Static Team was not specified for " + sBpmnStepID));
						break;
				}
				XmlElement xAssignModule = xaml.CreateAssignModuleActivity(xSequence, sMODULE_NAME, sOPERATION, sSOURCE_ID, sUSER_ASSIGNMENT_METHOD, sSTATIC_ASSIGNED_USER_ID, sSTATIC_ASSIGNED_TEAM_ID, sDYNAMIC_PROCESS_TEAM_ID, sDYNAMIC_PROCESS_ROLE_ID);
			}
			//xaml.CreateDumpPropertiesActivity(xSequence);
		}

		private void ConvertBpmnTimerEvent(XmlElement xFlowStep, XmlNode xBpmnStep, XmlNode xBpmnTimerEventDefinition)
		{
			XamlDocument xaml = xFlowStep.OwnerDocument as XamlDocument;
			BpmnDocument bpmn = xBpmnStep.OwnerDocument as BpmnDocument;
			string sBpmnStepID = bpmn.SelectNodeAttribute(xBpmnStep, "id");
			
			string sDURATION = bpmn.SelectNodeAttribute(xBpmnTimerEventDefinition, "crm:DURATION");
			// 09/05/2016 Paul.  WF4 does not allow invalid values. 
			string[] arrDURATION = sDURATION.Split(':');
			int nDays    = 0;
			int nHours   = 0;
			int nMinutes = 0;
			int nSeconds = 0;
			if ( arrDURATION.Length > 0 ) nDays    = Sql.ToInteger(arrDURATION[0]);
			if ( arrDURATION.Length > 1 ) nHours   = Sql.ToInteger(arrDURATION[1]);
			if ( arrDURATION.Length > 2 ) nMinutes = Sql.ToInteger(arrDURATION[2]);
			if ( arrDURATION.Length > 3 ) nSeconds = Sql.ToInteger(arrDURATION[3]);
			if ( nSeconds >= 60 )
			{
				nMinutes += nSeconds / 60;
				nSeconds  = nSeconds % 60;
			}
			if ( nMinutes >= 60 )
			{
				nHours   += nMinutes / 60;
				nMinutes  = nMinutes % 60;
			}
			if ( nHours >= 24 )
			{
				nDays  += nHours / 24;
				nHours  = nHours % 24;
			}
			sDURATION = nDays.ToString("00") + ":" + nHours.ToString("00") + ":" + nMinutes.ToString("00") + ":" + nSeconds.ToString("00");
			xaml.CreateDelayActivity(xFlowStep, sDURATION);
		}

		private void ConvertBpmnMessageEvent(XmlElement xFlowStep, XmlNode xBpmnStep, XmlNode xBpmnMessageEventDefinition)
		{
			XamlDocument xaml = xFlowStep.OwnerDocument as XamlDocument;
			BpmnDocument bpmn = xBpmnStep.OwnerDocument as BpmnDocument;
			string sBpmnStepID = bpmn.SelectNodeAttribute(xBpmnStep, "id");
			
			string sALERT_TYPE           =              bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:ALERT_TYPE"          );
			string sSOURCE_TYPE          =              bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:SOURCE_TYPE"         );
			string sALERT_SUBJECT        =              bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:ALERT_SUBJECT"       );
			// 10/01/2016 Paul.  SelectNodeValue() can return null, so make sure to convert to a string. 
			string sALERT_TEXT           = Sql.ToString(bpmn.SelectNodeValue    (xBpmnMessageEventDefinition, "crm:ALERT_TEXT"          ));
			Guid   gCUSTOM_TEMPLATE_ID   = Sql.ToGuid  (bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:CUSTOM_TEMPLATE_ID"  ));
			string sCUSTOM_TEMPLATE_NAME =              bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:CUSTOM_TEMPLATE_NAME");
			Guid   gASSIGNED_USER_ID     = Sql.ToGuid  (bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:ASSIGNED_USER_ID"    ));
			string sASSIGNED_USER_NAME   =              bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:ASSIGNED_USER_NAME"  );
			Guid   gTEAM_ID              = Sql.ToGuid  (bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:TEAM_ID"             ));
			string sTEAM_NAME            =              bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:TEAM_NAME"           );
			string sTEAM_SET_LIST        =              bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:TEAM_SET_LIST"       );
			string sTEAM_SET_NAME        =              bpmn.SelectNodeAttribute(xBpmnMessageEventDefinition, "crm:TEAM_SET_NAME"       );
			if ( Sql.IsEmptyString(sALERT_TYPE) )
				sALERT_TYPE = "Email";
			if ( Sql.IsEmptyString(sSOURCE_TYPE) )
				sSOURCE_TYPE = "normal_message";
			
			XmlNodeList nlRecipients = xBpmnStep.SelectNodes("bpmn2:extensionElements/crm:crmMessageRecipients/crm:crmRecipient", bpmn.NamespaceManager);
			if ( nlRecipients.Count == 0 )
			{
				throw(new Exception("crmRecipients not found in " + xBpmnStep.Name));
			}
			else
			{
				// 07/20/2016 Paul.  Create a new Sequence for the message event so that we can store the variables. 
				XmlElement xSequence = xaml.CreateSequence(xFlowStep, sBpmnStepID);
				XmlElement xSequenceVariables = xaml.CreateSequenceVariables(xSequence);
				// 09/28/2016 Paul.  We need to escape curly brackets as they are a XAML primative. 
				// Character ':' was unexpected in string '::future::Orders::name::'. Invalid XAML type name. 
				// https://msdn.microsoft.com/en-us/library/ms744986.aspx
				// 09/29/22016 Paul.  Expression is fine. 
				if ( sALERT_SUBJECT.Contains("{") && !sALERT_SUBJECT.StartsWith("=") )
					sALERT_SUBJECT = "{}" + sALERT_SUBJECT;
				if ( sALERT_TEXT.Contains("{") && !sALERT_TEXT.StartsWith("=") )
					sALERT_TEXT = "{}" + sALERT_TEXT;
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ALERT_TYPE"          , "x:String"                  , Sql.ToString(sALERT_TYPE          ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "SOURCE_TYPE"         , "x:String"                  , Sql.ToString(sSOURCE_TYPE         ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ALERT_SUBJECT"       , "x:String"                  , Sql.ToString(sALERT_SUBJECT       ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ALERT_TEXT"          , "x:String"                  , Sql.ToString(sALERT_TEXT          ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "CUSTOM_TEMPLATE_ID"  , "s:Guid"                    , Sql.ToString(gCUSTOM_TEMPLATE_ID  ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "CUSTOM_TEMPLATE_NAME", "x:String"                  , Sql.ToString(sCUSTOM_TEMPLATE_NAME));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ASSIGNED_USER_ID"    , "s:Guid"                    , Sql.ToString(gASSIGNED_USER_ID    ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ASSIGNED_USER_NAME"  , "x:String"                  , Sql.ToString(sASSIGNED_USER_NAME  ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "TEAM_ID"             , "s:Guid"                    , Sql.ToString(gTEAM_ID             ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "TEAM_NAME"           , "x:String"                  , Sql.ToString(sTEAM_NAME           ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "TEAM_SET_LIST"       , "x:String"                  , Sql.ToString(sTEAM_SET_LIST       ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "TEAM_SET_NAME"       , "x:String"                  , Sql.ToString(sTEAM_SET_NAME       ));
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "RECIPIENTS"          , "scg:List(crm:WF4Recipient)", "[New List(Of WF4Recipient)]"      );
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "REPORTS"             , "scg:List(crm:WF4Report)"   , "[New List(Of WF4Report)]"         );
				
				foreach ( XmlNode xRecipient in nlRecipients )
				{
					string sSEND_TYPE       =            bpmn.SelectNodeAttribute(xRecipient, "SEND_TYPE"      );
					string sRECIPIENT_TYPE  =            bpmn.SelectNodeAttribute(xRecipient, "RECIPIENT_TYPE" );
					Guid   gRECIPIENT_ID    = Sql.ToGuid(bpmn.SelectNodeAttribute(xRecipient, "RECIPIENT_ID"   ));
					string sRECIPIENT_NAME  =            bpmn.SelectNodeAttribute(xRecipient, "RECIPIENT_NAME" );
					string sRECIPIENT_FIELD =            bpmn.SelectNodeAttribute(xRecipient, "RECIPIENT_FIELD");
					string sRECIPIENT_TABLE = String.Empty;
					if ( !(sRECIPIENT_TYPE == "Roles" || sRECIPIENT_TYPE == "Users" || sRECIPIENT_TYPE == "Teams") )
					{
						string sRECIPIENT_MODULE = sRECIPIENT_TYPE.Replace("_AUDIT", String.Empty);
						sRECIPIENT_TABLE = Sql.ToString(Application["Modules." + sRECIPIENT_MODULE + ".TableName"]);
						if ( sRECIPIENT_TYPE.EndsWith("_AUDIT") )
						{
							sRECIPIENT_TABLE += "_AUDIT";
						}
					}
					xaml.CreateRecipientActivity(xSequence, sBpmnStepID, sSEND_TYPE, sRECIPIENT_TYPE, gRECIPIENT_ID, sRECIPIENT_NAME, sRECIPIENT_TABLE, sRECIPIENT_FIELD);
				}
				XmlNodeList nlReports = xBpmnStep.SelectNodes("bpmn2:extensionElements/crm:crmMessageReports/crm:crmReport", bpmn.NamespaceManager);
				foreach ( XmlNode xBpmnReport in nlReports )
				{
					string sBpmnReportID      =            bpmn.SelectNodeAttribute(xBpmnReport, "id"               );
					Guid   gREPORT_ID         = Sql.ToGuid(bpmn.SelectNodeAttribute(xBpmnReport, "REPORT_ID"        ));
					string sREPORT_NAME       =            bpmn.SelectNodeAttribute(xBpmnReport, "REPORT_NAME"      );
					string sRENDER_FORMAT     =            bpmn.SelectNodeAttribute(xBpmnReport, "RENDER_FORMAT"    );
					Guid   gSCHEDULED_USER_ID = Sql.ToGuid(bpmn.SelectNodeAttribute(xBpmnReport, "SCHEDULED_USER_ID"));
						
					// 07/16/2016 Paul.  We need to create a parameters variable for each report. 
					string sREPORT_PARAMETERS_VARIABLE = "REPORT_PARAMETERS_" + sBpmnReportID;
					// 12/09/2017 Paul.  Correct the name of the parameters variable. 
					xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + sREPORT_PARAMETERS_VARIABLE, "scg:List(crm:WF4ReportParameter)", "[New List(Of WF4ReportParameter)]");
					XmlNodeList nlReportParameters = xBpmnReport.SelectNodes("camunda:properties/camunda:property", bpmn.NamespaceManager);
					if ( nlReportParameters.Count > 0 )
					{
						foreach ( XmlNode xBpmnReportParameter in nlReportParameters )
						{
							string sNAME  = bpmn.SelectNodeAttribute(xBpmnReportParameter, "name" );
							string sVALUE = bpmn.SelectNodeAttribute(xBpmnReportParameter, "value");
							if ( !Sql.IsEmptyString(sNAME) )
							{
								xaml.CreateReportParameterActivity(xSequence, sBpmnStepID, sNAME, sVALUE, sREPORT_PARAMETERS_VARIABLE);
							}
						}
					}
					xaml.CreateReportActivity(xSequence, sBpmnStepID, gREPORT_ID, sREPORT_NAME, sRENDER_FORMAT, gSCHEDULED_USER_ID, sREPORT_PARAMETERS_VARIABLE);
				}
				xaml.CreateAlertActivity(xSequence, sBpmnStepID);
			}
		}

		private void ConvertBpmnUserTask(XmlElement xFlowStep, XmlNode xFlowchartVariables, XmlNode xBpmnStep)
		{
			XamlDocument xaml = xFlowStep.OwnerDocument as XamlDocument;
			BpmnDocument bpmn = xBpmnStep.OwnerDocument as BpmnDocument;
			string sBpmnStepID = bpmn.SelectNodeAttribute(xBpmnStep, "id");
			
			string sACTIVITY_NAME           =               bpmn.SelectNodeAttribute(xBpmnStep, "name"                         );
			string sAPPROVAL_VARIABLE_NAME  =               bpmn.SelectNodeAttribute(xBpmnStep, "crm:APPROVAL_VARIABLE_NAME"   );
			string sUSER_TASK_TYPE          =               bpmn.SelectNodeAttribute(xBpmnStep, "crm:USER_TASK_TYPE"           );
			bool   bCHANGE_ASSIGNED_USER    = Sql.ToBoolean(bpmn.SelectNodeAttribute(xBpmnStep, "crm:CHANGE_ASSIGNED_USER"     ));
			Guid   gCHANGE_ASSIGNED_TEAM_ID = Sql.ToGuid   (bpmn.SelectNodeAttribute(xBpmnStep, "crm:CHANGE_ASSIGNED_TEAM_ID"  ));
			bool   bCHANGE_PROCESS_USER     = Sql.ToBoolean(bpmn.SelectNodeAttribute(xBpmnStep, "crm:CHANGE_PROCESS_USER"      ));
			Guid   gCHANGE_PROCESS_TEAM_ID  = Sql.ToGuid   (bpmn.SelectNodeAttribute(xBpmnStep, "crm:CHANGE_PROCESS_TEAM_ID"   ));
			string sUSER_ASSIGNMENT_METHOD  =               bpmn.SelectNodeAttribute(xBpmnStep, "crm:USER_ASSIGNMENT_METHOD"   );
			Guid   gSTATIC_ASSIGNED_USER_ID = Sql.ToGuid   (bpmn.SelectNodeAttribute(xBpmnStep, "crm:STATIC_ASSIGNED_USER_ID"  ));
			Guid   gDYNAMIC_PROCESS_TEAM_ID = Sql.ToGuid   (bpmn.SelectNodeAttribute(xBpmnStep, "crm:DYNAMIC_PROCESS_TEAM_ID"  ));
			Guid   gDYNAMIC_PROCESS_ROLE_ID = Sql.ToGuid   (bpmn.SelectNodeAttribute(xBpmnStep, "crm:DYNAMIC_PROCESS_ROLE_ID"  ));
			string sDURATION_UNITS          =               bpmn.SelectNodeAttribute(xBpmnStep, "crm:DURATION_UNITS"           );
			int    nDURATION_VALUE          = Sql.ToInteger(bpmn.SelectNodeAttribute(xBpmnStep, "crm:DURATION_VALUE"           ));
			
			StringBuilder sbREAD_ONLY_FIELDS = new StringBuilder();
			XmlNodeList nlReadOnlyFields = xBpmnStep.SelectNodes("bpmn2:extensionElements/crm:crmReadOnlyFields/camunda:property", bpmn.NamespaceManager);
			if ( nlReadOnlyFields.Count > 0 )
			{
				UniqueStringCollection arrREAD_ONLY_FIELDS = new UniqueStringCollection();
				foreach ( XmlNode xReadOnlyField in nlReadOnlyFields )
				{
					string sNAME = bpmn.SelectNodeAttribute(xReadOnlyField, "name" ).Trim();
					if ( !Sql.IsEmptyString(sNAME) )
						arrREAD_ONLY_FIELDS.Add(sNAME);
				}
				foreach ( string sField in arrREAD_ONLY_FIELDS )
				{
					if ( sbREAD_ONLY_FIELDS.Length > 0 )
						sbREAD_ONLY_FIELDS.Append(",");
					sbREAD_ONLY_FIELDS.Append(sField);
				}
			}
			StringBuilder sbREQUIRED_FIELDS = new StringBuilder();
			XmlNodeList nlRequiredFields = xBpmnStep.SelectNodes("bpmn2:extensionElements/crm:crmRequiredFields/camunda:property", bpmn.NamespaceManager);
			if ( nlRequiredFields.Count > 0 )
			{
				UniqueStringCollection arrREQUIRED_FIELDS = new UniqueStringCollection();
				foreach ( XmlNode xRequiredField in nlRequiredFields )
				{
					string sNAME = bpmn.SelectNodeAttribute(xRequiredField, "name" ).Trim();
					if ( !Sql.IsEmptyString(sNAME) )
						arrREQUIRED_FIELDS.Add(sNAME);
				}
				foreach ( string sField in arrREQUIRED_FIELDS )
				{
					if ( sbREQUIRED_FIELDS.Length > 0 )
						sbREQUIRED_FIELDS.Append(",");
					sbREQUIRED_FIELDS.Append(sField);
				}
			}
			
			if ( Sql.IsEmptyString(sAPPROVAL_VARIABLE_NAME) )
				sAPPROVAL_VARIABLE_NAME = "APPROVAL_RESPONSE";
			if ( Sql.IsEmptyString(sUSER_TASK_TYPE) )
				sUSER_TASK_TYPE = "Approve/Reject";
			if ( Sql.IsEmptyString(sUSER_ASSIGNMENT_METHOD) )
				sUSER_ASSIGNMENT_METHOD = "Current Process User";
			
			xaml.CreateVariable(xFlowchartVariables, sAPPROVAL_VARIABLE_NAME, "x:String" , String.Empty);
			
			// 07/20/2016 Paul.  Create a new Sequence for the event so that we can store the variables. 
			XmlElement xSequence = xaml.CreateSequence(xFlowStep, sBpmnStepID);
			XmlElement xSequenceVariables = xaml.CreateSequenceVariables(xSequence);
			
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ACTIVITY_NAME"            , "x:String" , Sql.ToString(sACTIVITY_NAME            ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "USER_TASK_TYPE"           , "x:String" , Sql.ToString(sUSER_TASK_TYPE           ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "CHANGE_ASSIGNED_USER"     , "x:Boolean", Sql.ToString(bCHANGE_ASSIGNED_USER     ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "CHANGE_ASSIGNED_TEAM_ID"  , "s:Guid"   , Sql.ToString(gCHANGE_ASSIGNED_TEAM_ID  ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "CHANGE_PROCESS_USER"      , "x:Boolean", Sql.ToString(bCHANGE_PROCESS_USER      ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "CHANGE_PROCESS_TEAM_ID"   , "s:Guid"   , Sql.ToString(gCHANGE_PROCESS_TEAM_ID   ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "USER_ASSIGNMENT_METHOD"   , "x:String" , Sql.ToString(sUSER_ASSIGNMENT_METHOD   ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "STATIC_ASSIGNED_USER_ID"  , "s:Guid"   , Sql.ToString(gSTATIC_ASSIGNED_USER_ID  ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "DYNAMIC_PROCESS_TEAM_ID"  , "s:Guid"   , Sql.ToString(gDYNAMIC_PROCESS_TEAM_ID  ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "DYNAMIC_PROCESS_ROLE_ID"  , "s:Guid"   , Sql.ToString(gDYNAMIC_PROCESS_ROLE_ID  ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "READ_ONLY_FIELDS"         , "x:String" , sbREAD_ONLY_FIELDS.ToString());
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "REQUIRED_FIELDS"          , "x:String" , sbREQUIRED_FIELDS .ToString());
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "DURATION_UNITS"           , "x:String" , Sql.ToString(sDURATION_UNITS           ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "DURATION_VALUE"           , "x:Int32"  , Sql.ToString(nDURATION_VALUE           ));
			
			xaml.CreateApprovalActivity(xSequence, sBpmnStepID, sAPPROVAL_VARIABLE_NAME);
		}

		private Dictionary<string, string> GetActivityFields(string sACTIVITY_NAME)
		{
			Assembly asm = Assembly.GetExecutingAssembly();
			Dictionary<string, string> dict = new Dictionary<string, string>();
			FieldInfo[] fields = asm.GetType(sACTIVITY_NAME, true, true).GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
			foreach ( FieldInfo field in fields )
			{
				Debug.WriteLine(field.Name + " " + field.FieldType.ToString());
				if ( field.FieldType.GenericTypeArguments != null && field.FieldType.GenericTypeArguments.Length > 0 )
				{
					switch ( field.FieldType.BaseType.FullName )
					{
						case "System.Activities.InArgument":
						case "System.Activities.OutArgument":
						case "System.Activities.InOutArgument":
						{
							string sName = field.Name;
							string sType = field.FieldType.GenericTypeArguments[0].Name;
							if ( sName.StartsWith("<") )
							{
								int nEnd = sName.IndexOf(">");
								sName = sName.Substring(1, nEnd - 1);
							}
							dict.Add(sName, sType);
							break;
						}
					}
				}
			}
			return dict;
		}

		private Dictionary<string, string> GetProcedureFields(string sPROCEDURE_NAME)
		{
			Dictionary<string, string> dict = new Dictionary<string, string>();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				sSQL = "select ColumnName              " + ControlChars.CrLf
				     + "     , CsType                  " + ControlChars.CrLf
				     + "  from vwSqlColumns            " + ControlChars.CrLf
				     + " where ObjectName = @OBJECTNAME" + ControlChars.CrLf
				     + " order by colid                " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@OBJECTNAME", Sql.MetadataName(cmd, sPROCEDURE_NAME));
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						( (IDbDataAdapter) da ).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill( dt );
							foreach ( DataRow row in dt.Rows )
							{
								string sName = Sql.ToString(row["ColumnName"]).Replace("@", String.Empty);
								string sType = Sql.ToString(row["CsType"    ]);
								dict.Add(sName, sType);
							}
						}
					}
				}
			}
			return dict;
		}

		private void ConvertBpmnBusinessRuleTask(XmlElement xFlowStep, XmlElement xFlowchartVariables, XmlNode xBpmnStep)
		{
			XamlDocument xaml = xFlowStep.OwnerDocument as XamlDocument;
			BpmnDocument bpmn = xBpmnStep.OwnerDocument as BpmnDocument;
			string sBpmnStepID = bpmn.SelectNodeAttribute(xBpmnStep, "id");
			
			string sBUSINESS_RULE_OPERATION = bpmn.SelectNodeAttribute(xBpmnStep, "crm:BUSINESS_RULE_OPERATION");
			string sACTIVITY_NAME           = bpmn.SelectNodeAttribute(xBpmnStep, "crm:ACTIVITY_NAME"          );
			string sPROCEDURE_NAME          = bpmn.SelectNodeAttribute(xBpmnStep, "crm:PROCEDURE_NAME"         );
			// 08/14/2016 Paul.  The output variables need to be put in the flowchart so that they can bet used flowchart wide. 
			XmlElement xSequence = xaml.CreateSequence(xFlowStep , sBpmnStepID + "_Sequence");
			
			Dictionary<string, string> dictFields = null;
			if ( sBUSINESS_RULE_OPERATION == "call_c#_activity" && !Sql.IsEmptyString(sACTIVITY_NAME) )
			{
				dictFields = GetActivityFields("SplendidCRM." + sACTIVITY_NAME);
			}
			else if ( sBUSINESS_RULE_OPERATION == "call_sql_procedure" && !Sql.IsEmptyString(sPROCEDURE_NAME) )
			{
				dictFields = GetProcedureFields(sPROCEDURE_NAME);
			}
			
			//xaml.CreateDumpPropertiesActivity(xSequence);
			string sFIELD_PREFIX = sBpmnStepID + "_";
			XmlNodeList nlInputParameters  = xBpmnStep.SelectNodes("bpmn2:extensionElements/camunda:inputOutput/camunda:inputParameter" , bpmn.NamespaceManager);
			XmlNodeList nlOutputParameters = xBpmnStep.SelectNodes("bpmn2:extensionElements/camunda:inputOutput/camunda:outputParameter", bpmn.NamespaceManager);
			if ( sBUSINESS_RULE_OPERATION == "call_sql_procedure" || sBUSINESS_RULE_OPERATION == "call_c#_activity" )
			{
				XmlElement xSequenceVariables = xaml.CreateSequenceVariables(xSequence);
				foreach ( XmlNode xParameter in nlInputParameters )
				{
					string sNAME   = bpmn.SelectNodeAttribute(xParameter, "name" );
					string sCsType = "string";
					string sVALUE  = xParameter.InnerText;
					if ( dictFields.ContainsKey(sNAME) )
					{
						sCsType = dictFields[sNAME];
					}
					string sTYPE   = CsTypeToXamlType(sCsType);
					// 08/14/2016 Paul.  We use a sequence variable for input so that we can use a C# expression (with an Assign activity). 
					xaml.CreateVariable(xSequenceVariables, sFIELD_PREFIX + sNAME, sTYPE, String.Empty);
					xaml.CreateAssignActivity(xSequence, sTYPE, sFIELD_PREFIX + sNAME, sVALUE);
				}
				foreach ( XmlNode xParameter in nlOutputParameters )
				{
					string sNAME   = bpmn.SelectNodeAttribute(xParameter, "name" );
					// 12/09/2017 Paul.  Type is not available from the UI.  Use same lookup as for input parameters. 
					string sCsType = "string";
					string sVALUE  = xParameter.InnerText;
					if ( dictFields.ContainsKey(sNAME) )
					{
						sCsType = dictFields[sNAME];
					}
					string sTYPE   = CsTypeToXamlType(sCsType);
					// 08/14/2016 Paul.  We use a sequence variable for input so that we can use a C# expression (with an Assign activity). 
					xaml.CreateVariable(xSequenceVariables, sFIELD_PREFIX + sNAME, sTYPE, String.Empty);
				}
			}
			
			if ( sBUSINESS_RULE_OPERATION == "call_sql_procedure" )
			{
				XmlElement xSqlProcedure = xaml.CreateElement("crm", "WF4SqlProcedureActivity", xaml.CrmNamespace);
				xSequence.AppendChild(xSqlProcedure);
				xaml.CreateAttributeValue(xSqlProcedure, "PROCEDURE_NAME", sPROCEDURE_NAME);
				xaml.CreateAttributeValue(xSqlProcedure, "FIELD_PREFIX"  , sFIELD_PREFIX  );
			}
			else if ( sBUSINESS_RULE_OPERATION == "call_c#_activity" )
			{
				XmlElement xCustomActivity = xaml.CreateElement("crm", sACTIVITY_NAME, xaml.CrmNamespace);
				xSequence.AppendChild(xCustomActivity);
				foreach ( XmlNode xParameter in nlInputParameters )
				{
					string sNAME = bpmn.SelectNodeAttribute(xParameter, "name");
					xaml.CreateAttributeValueReference(xCustomActivity, sNAME, sFIELD_PREFIX + sNAME);
				}
				foreach ( XmlNode xParameter in nlOutputParameters )
				{
					string sNAME = bpmn.SelectNodeAttribute(xParameter, "name");
					xaml.CreateAttributeValueReference(xCustomActivity, sNAME, sFIELD_PREFIX + sNAME);
				}
			}
			else if ( sBUSINESS_RULE_OPERATION == "assign_activity" )
			{
				string sASSIGN_FIELD      = bpmn.SelectNodeAttribute(xBpmnStep, "crm:ASSIGN_FIELD"     );
				string sASSIGN_TYPE       = bpmn.SelectNodeAttribute(xBpmnStep, "crm:ASSIGN_TYPE"      );
				string sASSIGN_EXPRESSION = bpmn.SelectNodeAttribute(xBpmnStep, "crm:ASSIGN_EXPRESSION");
				if ( Sql.IsEmptyString(sASSIGN_TYPE) )
					sASSIGN_TYPE = "string";
				string sTYPE   = CsTypeToXamlType(sASSIGN_TYPE);
				xaml.CreateAssignActivity(xSequence, sTYPE, sASSIGN_FIELD, sASSIGN_EXPRESSION);
			}
			else if ( sBUSINESS_RULE_OPERATION == "switch_activity" )
			{
				string sASSIGN_FIELD      = bpmn.SelectNodeAttribute(xBpmnStep, "crm:ASSIGN_FIELD"     );
				string sASSIGN_TYPE       = bpmn.SelectNodeAttribute(xBpmnStep, "crm:ASSIGN_TYPE"      );
				string sSWITCH_FIELD      = bpmn.SelectNodeAttribute(xBpmnStep, "crm:SWITCH_FIELD"     );
				string sSWITCH_DEFAULT    = bpmn.SelectNodeAttribute(xBpmnStep, "crm:SWITCH_DEFAULT"   );
				if ( Sql.IsEmptyString(sASSIGN_TYPE) )
					sASSIGN_TYPE = "string";
				string sTYPE   = CsTypeToXamlType(sASSIGN_TYPE);
				XmlElement xSwitch = xaml.CreateSwitchActivity(xSequence, sTYPE, sASSIGN_FIELD, sSWITCH_FIELD, sSWITCH_DEFAULT);
				
				XmlNodeList nlProperties = xBpmnStep.SelectNodes("bpmn2:extensionElements/camunda:properties/camunda:property", bpmn.NamespaceManager);
				if ( nlProperties.Count > 0 )
				{
					foreach ( XmlNode xProperty in nlProperties )
					{
						string sNAME  = bpmn.SelectNodeAttribute(xProperty, "name" );
						string sVALUE = bpmn.SelectNodeAttribute(xProperty, "value");
						xaml.CreateSwitchAssignActivity(xSwitch, sTYPE, sASSIGN_FIELD, sNAME, sVALUE);
					}
				}
			}
			if ( sBUSINESS_RULE_OPERATION == "call_sql_procedure" || sBUSINESS_RULE_OPERATION == "call_c#_activity" )
			{
				// 08/14/2016 Paul.  The output variables need to be put in the flowchart so that they can bet used flowchart wide. 
				// The output variable name will be the value property. 
				foreach ( XmlNode xParameter in nlOutputParameters )
				{
					string sNAME   = bpmn.SelectNodeAttribute(xParameter, "name" );
					// 12/09/2017 Paul.  Type is not available from the UI.  Use same lookup as for input parameters. 
					string sCsType = "string";
					string sVALUE  = xParameter.InnerText;
					if ( dictFields.ContainsKey(sNAME) )
					{
						sCsType = dictFields[sNAME];
					}
					string sTYPE   = CsTypeToXamlType(sCsType);
					xaml.CreateVariable(xFlowchartVariables, sVALUE, sTYPE, String.Empty);
					// 12/09/2017 Paul.  Use the equals prefix so that it is treated as a CSharpValue. 
					xaml.CreateAssignActivity(xSequence, sTYPE, sVALUE, "=" + sFIELD_PREFIX + sNAME);
				}
			}
			//xaml.CreateDumpPropertiesActivity(xSequence);
		}
	}
}
