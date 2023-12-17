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
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Web;
using System.Net;
using System.Net.Mail;
using System.Diagnostics;
using System.Xml;
using System.Collections.Generic;
using System.Workflow.Runtime;
using System.Workflow.ComponentModel;
using System.Workflow.ComponentModel.Compiler;
//using System.Workflow.ComponentModel.Serialization;

namespace SplendidCRM
{
	public class WorkflowUtils
	{
		private DbProviderFactories       DbProviderFactories       = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState      Application               = new HttpApplicationState();
		private AppSettings               AppSettings               = new AppSettings();
		private Sql                       Sql                      ;
		private Utils                     Utils                    ;
		private SqlProcs                  SqlProcs                 ;
		private SplendidError             SplendidError            ;
		private WorkflowInit              WorkflowInit             ;
		private Workflow4Utils            Workflow4Utils           ;
		private Workflow4UtilsMigratedWF3 Workflow4UtilsMigratedWF3;

		// 04/23/2010 Paul.  Make the inside flag public so that we can access from the SystemCheck. 
		public  static bool bInsideWorkflow = false;
		private static int  nWorkflowBusyEvents = 0;

		public WorkflowUtils(Sql Sql, SqlProcs SqlProcs, Utils Utils, SplendidError SplendidError, WorkflowInit WorkflowInit, Workflow4Utils Workflow4Utils, Workflow4UtilsMigratedWF3 Workflow4UtilsMigratedWF3)
		{
			this.Sql                       = Sql                      ;
			this.Utils                     = Utils                    ;
			this.SqlProcs                  = SqlProcs                 ;
			this.SplendidError             = SplendidError            ;
			this.WorkflowInit              = WorkflowInit             ;
			this.Workflow4Utils            = Workflow4Utils           ;
			this.Workflow4UtilsMigratedWF3 = Workflow4UtilsMigratedWF3;
		}

		// 10/27/2008 Paul.  Pass the context instead of the Application so that more information will be available to the error handling. 
		public void OnTimer()
		{
			// 12/30/2007 Paul.  Workflow events always get processed. 
			// 07/26/2008 Paul.  Provide a way to disable workflow. 
			bool bEnableWorkflow = Sql.ToBoolean(Application["CONFIG.enable_workflow"]);
			if ( bEnableWorkflow )
			{
				// 10/24/2009 Paul.  If multiple apps connect to the same database, make sure that only one is the job server. 
				// This is primarily for load-balanced sites. 
				int nSplendidWorkflowServerFlag = Sql.ToInteger(Application["SplendidWorkflowServerFlag"]);
				if ( nSplendidWorkflowServerFlag == 0 )
				{
					string sSplendidWorkflowServer = AppSettings["SplendidWorkflowServer"];
					// 09/17/2009 Paul.  If we are running in Azure, then assume that this is the only instance. 
					string sMachineName = sSplendidWorkflowServer;
					try
					{
						// 09/17/2009 Paul.  Azure does not support MachineName.  Just ignore the error. 
						sMachineName = System.Environment.MachineName;
					}
					catch
					{
					}
					if ( Sql.IsEmptyString(sSplendidWorkflowServer) || String.Compare(sMachineName, sSplendidWorkflowServer, true) == 0 )
					{
						nSplendidWorkflowServerFlag = 1;
						SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sMachineName + " is a Splendid Workflow Server.");
					}
					else
					{
						nSplendidWorkflowServerFlag = -1;
						SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sMachineName + " is not a Splendid Workflow Server.");
					}
					Application["SplendidWorkflowServerFlag"] = nSplendidWorkflowServerFlag;
				}
				if ( nSplendidWorkflowServerFlag > 0 )
				{
					// 10/29/2023 Paul.  CoreWF only supports WF4, not WF3, so use migration code. 
					//this.Process();
					// 10/15/2023 Paul.  Use WF4 to run WF3 migrated code. 
					Workflow4UtilsMigratedWF3.Process();
					// 06/23/2016 Paul.  A Business Process is just like a Workflow with record and timed events. 
					Workflow4Utils.Process();
				}
			}
		}

		// 10/27/2008 Paul.  Pass the context instead of the Application so that more information will be available to the error handling. 
		// 10/29/2023 Paul.  CoreWF only supports WF4, not WF3, so use migration code. 
#if false
		public void Process()
		{
			if ( !bInsideWorkflow )
			{
				bInsideWorkflow = true;
				// 05/24/2009 Paul.  We need a way to exit long-running loops. 
				// While we could use a SQL top caluse, using the busy events might work better. 
				//. 05/24/2009 Paul.  The workflow timer will fire every 30 seconds, so lets set the max to 3 busy events (1 minute 30 seconds). 
				nWorkflowBusyEvents = 0;
				int nMaxWorkflowBusyEvents = 3;
				try
				{
					// 08/31/2023 Paul.  Get runtime later so we can process WWF4 events. 
					//WorkflowRuntime runtime = WorkflowInit.GetRuntime();
					//if ( runtime != null )
					//{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL ;
							try
							{
								// 11/16/2008 Paul.  Run the time-based workflows first as the events are not time-sensitive
								using ( DataTable dt = new DataTable() )
								{
									sSQL = "select *                   " + ControlChars.CrLf
									     + "  from vwWORKFLOWS_RunTimed" + ControlChars.CrLf
									     + " order by NEXT_RUN         " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										// 11/16/2008 Paul.  The workflow query should always be very fast. 
										// In the off chance that there is a problem, abort after 15 seconds. 
										cmd.CommandTimeout = 15;

										using ( DbDataAdapter da = dbf.CreateDataAdapter() )
										{
											((IDbDataAdapter)da).SelectCommand = cmd;
											da.Fill(dt);
										}
									}
									foreach ( DataRow row in dt.Rows )
									{
										Guid     gWORKFLOW_ID = Sql.ToGuid    (row["ID"         ]);
										string   sNAME        = Sql.ToString  (row["NAME"       ]);
										string   sBASE_MODULE = Sql.ToString  (row["BASE_MODULE"]);
										string   sFILTER_SQL  = Sql.ToString  (row["FILTER_SQL" ]);
										// 01/31/2008 Paul.  Next run becomes last run. 
										DateTime dtLAST_RUN   = Sql.ToDateTime(row["NEXT_RUN"   ]);
										try
										{
											using ( DataTable dtTimedEvents = new DataTable() )
											{
												using ( IDbCommand cmd = con.CreateCommand() )
												{
													cmd.CommandText = sFILTER_SQL;
													cmd.CommandTimeout = 0;
													// 11/16/2008 Paul.  The Workflow ID might be required to prevent multiple runs. 
													if ( sFILTER_SQL.Contains("@WORKFLOW_ID") )
														Sql.AddParameter(cmd, "@WORKFLOW_ID", gWORKFLOW_ID);

													using ( DbDataAdapter da = dbf.CreateDataAdapter() )
													{
														((IDbDataAdapter)da).SelectCommand = cmd;
														da.Fill(dtTimedEvents);
													}
												}
												if ( dtTimedEvents.Rows.Count > 0 )
												{
													// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
													using ( IDbTransaction trn = Sql.BeginTransaction(con) )
													{
														try
														{
															foreach ( DataRow rowTimed in dtTimedEvents.Rows )
															{
																// 11/16/2008 Paul.  Use the AUDIT_ID field even though this is a timed workflow. 
																Guid gAUDIT_ID = Sql.ToGuid(rowTimed["ID"]);
																SqlProcs.spWORKFLOW_RUN_InsertOnly(gWORKFLOW_ID, gAUDIT_ID, sBASE_MODULE, "Ready", trn);
															}
															trn.Commit();
														}
														catch(Exception ex)
														{
															trn.Rollback();
															throw(new Exception(ex.Message, ex.InnerException));
														}
													}
												}
											}
										}
										finally
										{
											// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 11/16/2008 Paul.  Make sure the Last Run value is updated after the operation.
													SqlProcs.spWORKFLOWS_UpdateLastRun(gWORKFLOW_ID, dtLAST_RUN, trn);
													trn.Commit();
												}
												catch(Exception ex)
												{
													trn.Rollback();
													SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
												}
											}
										}
									}
								}
							}
							catch(Exception ex)
							{
								throw(new Exception(ex.Message, ex.InnerException));
							}

							// 11/19/2008 Paul.  Pull the event processing out of the ProcessAll stored procedure 
							// so that a single SQL failure would not block all workflows. 
							/*
							// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.Transaction = trn;
										cmd.CommandType = CommandType.StoredProcedure;
										cmd.CommandText = "spWORKFLOW_EVENTS_ProcessAll";
										cmd.CommandTimeout = 0;  // 07/26/2008 Paul.  Run forever. 
										cmd.ExecuteNonQuery();
									}
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									throw(new Exception(ex.Message, ex.InnerException));
								}
							}
							*/
							sSQL = "select ID                  " + ControlChars.CrLf
							     + "     , AUDIT_ID            " + ControlChars.CrLf
							     + "     , AUDIT_TABLE         " + ControlChars.CrLf
							     + "     , AUDIT_ACTION        " + ControlChars.CrLf
							     + "     , AUDIT_TOKEN         " + ControlChars.CrLf
							     + "     , AUDIT_PARENT_ID     " + ControlChars.CrLf
							     + "     , AUDIT_VERSION       " + ControlChars.CrLf
							     + "  from vwWORKFLOW_EVENTS   " + ControlChars.CrLf
							     + " order by AUDIT_VERSION asc" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
					
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dt = new DataTable() )
									{
										da.Fill(dt);
										DataView vwWORKFLOW_EVENTS = new DataView(dt);
										foreach ( DataRow row in dt.Rows )
										{
											// 05/24/2009 Paul.  We need a way to exit long-running loops. 
											// While we could use a SQL top caluse, using the busy events might work better. 
											if ( nWorkflowBusyEvents >= nMaxWorkflowBusyEvents )
											{
												SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Workflow Events: Busy Events threshold reached during Process Event.");
												nWorkflowBusyEvents = 0;
												break;
											}
											// 12/03/2008 Paul.  We may have deleted rows, so make sure to skip them. 
											// A row gets deleted when we roll-up events within the same transaction. (See invoices comment below.)
											if ( row.RowState != DataRowState.Deleted )
											{
												Guid   gID              = Sql.ToGuid   (row["ID"             ]);
												Guid   gAUDIT_ID        = Sql.ToGuid   (row["AUDIT_ID"       ]);
												string sAUDIT_TABLE     = Sql.ToString (row["AUDIT_TABLE"    ]);
												int    nAUDIT_ACTION    = Sql.ToInteger(row["AUDIT_ACTION"   ]);
												string sAUDIT_TOKEN     = Sql.ToString (row["AUDIT_TOKEN"    ]);
												Guid   gAUDIT_PARENT_ID = Sql.ToGuid   (row["AUDIT_PARENT_ID"]);
												try
												{
													// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
													using ( IDbTransaction trn = Sql.BeginTransaction(con) )
													{
														try
														{
															vwWORKFLOW_EVENTS.RowFilter = "AUDIT_TOKEN = '" + sAUDIT_TOKEN + "' and AUDIT_TABLE = '" + sAUDIT_TABLE + "' and AUDIT_PARENT_ID = '" + gAUDIT_PARENT_ID.ToString() +"' and ID <> '" + gID + "'" ;
															if ( vwWORKFLOW_EVENTS.Count > 0 )
															{
																// 12/03/2008 Paul.  If there are sibling events, then use the AUDIT_ID of the last event. 
																// Make sure to keep the first AUDIT_ACTION so that an insert will not be converted to an update. 
																foreach ( DataRowView rowSibling in vwWORKFLOW_EVENTS )
																{
																	Guid gSIBLING_ID = Sql.ToGuid(rowSibling["ID"]);
																	gAUDIT_ID = Sql.ToGuid(rowSibling["AUDIT_ID"]);
																	// 12/03/2008 Paul.  I've noticed that we can get an update event before the insert event. 
																	// This should not occur, but it does so we need to convert the update to an insert. 
																	nAUDIT_ACTION = Math.Min(nAUDIT_ACTION, Sql.ToInteger(rowSibling["AUDIT_ACTION"]));
																	SqlProcs.spWORKFLOW_EVENTS_Delete(gSIBLING_ID, trn);
																	// 12/03/2008 Paul.  We also need to mark the local record as deleted, otherwise the event would still fire. 
																	rowSibling.Delete();
																}
															}
															// 12/03/2008 Paul.  Invoices have a problem whereby multiple updates occur within the same transaction. 
															// More specifically, when an invoice is saved, spINVOICES_UpdateAmountDue is called, which causes a second audit/update record. 
															// We need to make sure to only fire one workflow event even though the record has multiple within the same transaction.
															SqlProcs.spWORKFLOW_EVENTS_ProcessEvent   (gAUDIT_ID, sAUDIT_TABLE, nAUDIT_ACTION, sAUDIT_TOKEN, trn);
															// 06/23/2016 Paul.  Business Processes use the same WORKFLOW_EVENTS record, but populates BUSINESS_PROCESSES_RUN. 
															SqlProcs.spBUSINESS_PROCESSES_ProcessEvent(gAUDIT_ID, sAUDIT_TABLE, nAUDIT_ACTION, sAUDIT_TOKEN, trn);
															SqlProcs.spWORKFLOW_EVENTS_Delete(gID, trn);
															trn.Commit();
														}
														catch(Exception ex)
														{
															trn.Rollback();
															throw(new Exception(ex.Message, ex.InnerException));
														}
													}
												}
												catch(Exception ex)
												{
													StringBuilder sbError = new StringBuilder();
													sbError.AppendLine("WORKFLOW_EVENTS_ProcessEvent '" + gAUDIT_ID.ToString() + "', '" + sAUDIT_TABLE + "', " + nAUDIT_ACTION.ToString() + ", '" + sAUDIT_TOKEN + "';");
													sbError.AppendLine(Utils.ExpandException(ex));
													SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sbError.ToString());
													
													// 11/19/2008 Paul.  If there was a failure, we need to delete the event, 
													// otherwise we will get an error message every 30 seconds.  Otherwise, continue processing events. 
													// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
													using ( IDbTransaction trn = Sql.BeginTransaction(con) )
													{
														try
														{
															// 12/03/2008 Paul.  We need to delete any sibling events. 
															vwWORKFLOW_EVENTS.RowFilter = "AUDIT_TOKEN = '" + sAUDIT_TOKEN + "' and AUDIT_TABLE = '" + sAUDIT_TABLE + "' and AUDIT_PARENT_ID = '" + gAUDIT_PARENT_ID.ToString() +"' and ID <> '" + gID + "'" ;
															if ( vwWORKFLOW_EVENTS.Count > 0 )
															{
																foreach ( DataRowView rowSibling in vwWORKFLOW_EVENTS )
																{
																	Guid gSIBLING_ID = Sql.ToGuid(rowSibling["ID"]);
																	SqlProcs.spWORKFLOW_EVENTS_Delete(gSIBLING_ID, trn);
																	rowSibling.Delete();
																}
															}
															SqlProcs.spWORKFLOW_EVENTS_Delete(gID, trn);
															trn.Commit();
														}
														catch(Exception ex2)
														{
															trn.Rollback();
															SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex2));
														}
													}
												}
											}
										}
									}
								}
							}
							
							// 08/31/2023 Paul.  Get runtime later so we can process WWF4 events. 
							WorkflowRuntime runtime = WorkflowInit.GetRuntime();
							if ( runtime != null )
							{
								sSQL = "select ID                  " + ControlChars.CrLf
								     + "     , WORKFLOW_ID         " + ControlChars.CrLf
								     + "     , AUDIT_ID            " + ControlChars.CrLf
								     + "     , AUDIT_TABLE         " + ControlChars.CrLf
								     + "     , TYPE                " + ControlChars.CrLf
								     + "     , XOML                " + ControlChars.CrLf
								     + "  from vwWORKFLOW_RUN_Ready" + ControlChars.CrLf
								     + " order by WORKFLOW_VERSION " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									
									using ( DbDataAdapter da = dbf.CreateDataAdapter() )
									{
										((IDbDataAdapter)da).SelectCommand = cmd;
										using ( DataTable dt = new DataTable() )
										{
											da.Fill(dt);
											foreach ( DataRow row in dt.Rows )
											{
												// 05/24/2009 Paul.  We need a way to exit long-running loops. 
												// While we could use a SQL top caluse, using the busy events might work better. 
												// 05/24/2009 Paul.  Running a workflow can take a while, so allow more busy events. 
												if ( nWorkflowBusyEvents >= 2*nMaxWorkflowBusyEvents )
												{
													nWorkflowBusyEvents = 0;
													SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Workflow Events: Busy Events threshold reached during Run.");
													break;
												}
												Guid   gID          = Sql.ToGuid  (row["ID"         ]);
												Guid   gWORKFLOW_ID = Sql.ToGuid  (row["WORKFLOW_ID"]);
												Guid   gAUDIT_ID    = Sql.ToGuid  (row["AUDIT_ID"   ]);
												string sAUDIT_TABLE = Sql.ToString(row["AUDIT_TABLE"]);
												string sTYPE        = Sql.ToString(row["TYPE"       ]);
												string sXOML        = Sql.ToString(row["XOML"       ]);
												// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														SqlProcs.spWORKFLOW_RUN_UpdateStatus(gID, "Loading", trn);
														trn.Commit();
													}
													catch(Exception ex)
													{
														trn.Rollback();
														throw(new Exception(ex.Message, ex.InnerException));
													}
												}
												
												WorkflowInstance inst = null;
												using ( StringReader stm = new StringReader(sXOML) )
												{
													using ( XmlReader rdr = XmlReader.Create(stm) )
													{
														bool bWorkflowCreated = false;
														try
														{
															// 10/05/2008 Paul.  Use separate try/catch for create and start so that we log the appropriate failure. 
															Dictionary<string, object> dictParameters = new Dictionary<string, object>();
															// 11/16/2008 Paul.  We need to distinguish between normal and time-based workflows. 
															if ( String.Compare(sTYPE, "time", true) == 0 )
																dictParameters.Add("ID", gAUDIT_ID);
															else
																dictParameters.Add("AUDIT_ID", gAUDIT_ID);
															inst = runtime.CreateWorkflow(rdr, null, dictParameters);
															// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
															using ( IDbTransaction trn = Sql.BeginTransaction(con) )
															{
																try
																{
																	SqlProcs.spWORKFLOW_RUN_Start(gID, inst.InstanceId, trn);
																	trn.Commit();
																	bWorkflowCreated = true;
																}
																catch(Exception ex)
																{
																	trn.Rollback();
																	throw(new Exception(ex.Message, ex.InnerException));
																}
															}
														}
														catch(WorkflowValidationFailedException ex)
														{
															StringBuilder sb = new StringBuilder();
															foreach ( System.Workflow.ComponentModel.Compiler.ValidationError error in ex.Errors )
															{
																sb.AppendLine(error.ToString() + "<br />");
															}
															SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sb.ToString());
															// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
															using ( IDbTransaction trn = Sql.BeginTransaction(con) )
															{
																try
																{
																	SqlProcs.spWORKFLOW_RUN_Failed(gID, "Failed to Load", sb.ToString(), trn);
																	trn.Commit();
																}
																catch
																{
																	trn.Rollback();
																}
															}
														}
														catch(Exception ex)
														{
															string sError = Utils.ExpandException(ex);
															SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
															// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
															using ( IDbTransaction trn = Sql.BeginTransaction(con) )
															{
																try
																{
																	SqlProcs.spWORKFLOW_RUN_Failed(gID, "Failed to Load", sError, trn);
																	trn.Commit();
																}
																catch
																{
																	trn.Rollback();
																}
															}
														}
														if ( bWorkflowCreated )
														{
															try
															{
																// 10/05/2008 Paul.  Use separate try/catch for create and start so that we log the appropriate failure. 
																inst.Start();
																// 10/05/2008 Paul.  Started state should be set via workflow tracking. 
																/*
																// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
																using ( IDbTransaction trn = Sql.BeginTransaction(con) )
																{
																	try
																	{
																		SqlProcs.spWORKFLOW_RUN_UpdateStatus(gID, "Started", trn);
																		trn.Commit();
																	}
																	catch(Exception ex)
																	{
																		trn.Rollback();
																		throw(new Exception(ex.Message, ex.InnerException));
																	}
																}
																*/
															}
															catch(WorkflowValidationFailedException ex)
															{
																StringBuilder sb = new StringBuilder();
																foreach ( System.Workflow.ComponentModel.Compiler.ValidationError error in ex.Errors )
																{
																	sb.AppendLine(error.ToString() + "<br />");
																}
																SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sb.ToString());
																// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
																using ( IDbTransaction trn = Sql.BeginTransaction(con) )
																{
																	try
																	{
																		SqlProcs.spWORKFLOW_RUN_Failed(gID, "Failed to Start", sb.ToString(), trn);
																		trn.Commit();
																	}
																	catch
																	{
																		trn.Rollback();
																	}
																}
															}
															catch(Exception ex)
															{
																string sError = Utils.ExpandException(ex);
																SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
																// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
																using ( IDbTransaction trn = Sql.BeginTransaction(con) )
																{
																	try
																	{
																		SqlProcs.spWORKFLOW_RUN_Failed(gID, "Failed to Start", sError, trn);
																		trn.Commit();
																	}
																	catch
																	{
																		trn.Rollback();
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					//}
					//else
					//{
					//	// 08/31/2023 Paul.  Start inside hosted service. 
					//	//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "WorkflowInit.GetRuntime returned null.  The Workflow runtime will be restarted. ");
					//	//WorkflowInit.StartRuntime();
					//}
				}
				catch(Exception ex)
				{
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				}
				finally
				{
					bInsideWorkflow = false;
				}
			}
			else
			{
				nWorkflowBusyEvents++;
			}
		}
#endif
	}
}
