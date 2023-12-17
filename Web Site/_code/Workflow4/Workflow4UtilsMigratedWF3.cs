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
using System.Xml.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Concurrent;
using Microsoft.VisualBasic.Activities;
using System.Diagnostics;
using System.Xaml;
using System.Activities;
using System.Activities.XamlIntegration;
using System.Activities.DurableInstancing;
using System.Activities.Runtime.DurableInstancing;
using System.Activities.Validation;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Caching.Memory;

using Spring.Social.Office365;

namespace SplendidCRM
{
	// 10/15/2023 Paul.  Use WF4 to run WF3 migrated code. 
	public class Workflow4UtilsMigratedWF3
	{
		private IWebHostEnvironment   hostingEnvironment   ;
		private IMemoryCache          memoryCache          ;
		private DbProviderFactories   DbProviderFactories   = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState  Application           = new HttpApplicationState();
		private HttpSessionState      Session              ;
		private Security              Security             ;
		private Sql                   Sql                  ;
		private SqlProcs              SqlProcs             ;
		private SplendidError         SplendidError        ;
		private SplendidCache         SplendidCache        ;
		private SplendidDynamic       SplendidDynamic      ;
		private EmailUtils            EmailUtils           ;
		private XmlUtil               XmlUtil              ;
		private Crm.Modules           Modules              ;
		private Crm.NoteAttachments   NoteAttachments      ;
		private Workflow4BuildXaml    Workflow4BuildXaml   ;
		private ReportsAttachmentView ReportsAttachmentView;
		private SyncError             SyncError            ;
		private ExchangeSecurity      ExchangeSecurity     ;
		private ExchangeUtils         ExchangeUtils        ;
		private GoogleApps            GoogleApps           ;
		private Office365Sync         Office365Sync        ;
		private ExchangeSync          ExchangeSync         ;
		private GoogleSync            GoogleSync           ;
		private iCloudSync            iCloudSync           ;
		private WorkflowBuilder       WorkflowBuilder      ;
		private Workflow4Utils        Workflow4Utils       ;

		public  static bool bInsideWorkflow = false;
		private static int  nWorkflowBusyEvents = 0;
		private static ConcurrentDictionary<string, string> dictXomlToXaml = new ConcurrentDictionary<string,string>();

		public Workflow4UtilsMigratedWF3(IWebHostEnvironment hostingEnvironment, IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SplendidDynamic SplendidDynamic, EmailUtils EmailUtils, XmlUtil XmlUtil, Crm.Modules Modules, Crm.NoteAttachments NoteAttachments, Workflow4BuildXaml Workflow4BuildXaml, ReportsAttachmentView ReportsAttachmentView, SyncError SyncError, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, GoogleApps GoogleApps, Office365Sync Office365Sync, ExchangeSync ExchangeSync, GoogleSync GoogleSync, iCloudSync iCloudSync, WorkflowBuilder WorkflowBuilder, Workflow4Utils Workflow4Utils)
		{
			this.memoryCache           = memoryCache          ;
			this.hostingEnvironment    = hostingEnvironment   ;
			this.Session               = Session              ;
			this.Security              = Security             ;
			this.Sql                   = Sql                  ;
			this.SqlProcs              = SqlProcs             ;
			this.SplendidError         = SplendidError        ;
			this.SplendidCache         = SplendidCache        ;
			this.SplendidDynamic       = SplendidDynamic      ;
			this.EmailUtils            = EmailUtils           ;
			this.XmlUtil               = XmlUtil              ;
			this.Modules               = Modules              ;
			this.NoteAttachments       = NoteAttachments      ;
			this.Workflow4BuildXaml    = Workflow4BuildXaml   ;
			this.ReportsAttachmentView = ReportsAttachmentView;
			this.SyncError             = SyncError            ;
			this.ExchangeSecurity      = ExchangeSecurity     ;
			this.ExchangeUtils         = ExchangeUtils        ;
			this.GoogleApps            = GoogleApps           ;
			this.Office365Sync         = Office365Sync        ;
			this.ExchangeSync          = ExchangeSync         ;
			this.GoogleSync            = GoogleSync           ;
			this.iCloudSync            = iCloudSync           ;
			this.WorkflowBuilder       = WorkflowBuilder      ;
			this.Workflow4Utils        = Workflow4Utils       ;
		}
		
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
					System.Reflection.Assembly asm     = System.Reflection.Assembly.GetExecutingAssembly();
					System.Version             version = asm.GetName().Version;
					VisualBasicSettings vbSettings = new VisualBasicSettings();
					vbSettings.ImportReferences.Add(new VisualBasicImportReference
					{
						Assembly = "SplendidCRM",
						Import   = "SplendidCRM"
					});
				
					XamlXmlReaderSettings xamlSettings = new XamlXmlReaderSettings()
					{
						//BaseUri = new Uri("http://schemas.microsoft.com/netfx/2009/xaml/activities"),
						LocalAssembly = asm
					};
					Workflow4AppEventsMigratedWF3 appEvents = new Workflow4AppEventsMigratedWF3(Sql, SqlProcs, SplendidError);
					
					// http://www.help-doing.com/cp/PersistenceplusinplusWFplus-c.shtml
					XName WFHostTypeName = XName.Get("SplendidHost");
					
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL ;
						#region vwWORKFLOWS_RunTimed
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
						#endregion
						#region vwWORKFLOW_EVENTS
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
						#endregion
						#region vwWORKFLOW_RUN_Ready
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
											SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Business Process Events: Busy Events threshold reached during Run.");
											break;
										}
										Guid   gWORKFLOW_RUN_ID = Sql.ToGuid  (row["ID"         ]);
										Guid   gWORKFLOW_ID     = Sql.ToGuid  (row["WORKFLOW_ID"]);
										Guid   gAUDIT_ID        = Sql.ToGuid  (row["AUDIT_ID"   ]);
										string sAUDIT_TABLE     = Sql.ToString(row["AUDIT_TABLE"]);
										string sTYPE            = Sql.ToString(row["TYPE"       ]);
										string sXOML            = Sql.ToString(row["XOML"       ]);
										// 10/15/2023 Paul.  Convert XAML dynamically, and cache result. 
										string sXAML            = dictXomlToXaml.ContainsKey(sXOML) ? dictXomlToXaml[sXOML] : String.Empty;
										if ( Sql.IsEmptyString(sXAML) )
										{
											sXAML = WorkflowBuilder.BuildWF4Xaml(gWORKFLOW_ID);
											dictXomlToXaml[sXOML] = sXAML;
										}
										
										// 06/24/2016 Paul.  The AUDIT_TABLE field contains the module name for a timed workflow. 
										if ( sTYPE == "time" )
										{
											sAUDIT_TABLE = Modules.TableName(sAUDIT_TABLE);
										}
										using ( IDbTransaction trn = Sql.BeginTransaction(con) )
										{
											try
											{
												SqlProcs.spWORKFLOW_RUN_UpdateStatus(gWORKFLOW_RUN_ID, "Loading", trn);
												trn.Commit();
											}
											catch(Exception ex)
											{
												trn.Rollback();
												throw(new Exception(ex.Message, ex.InnerException));
											}
										}
										
										DynamicActivity workflow = null;
										using ( StringReader stm = new StringReader(sXAML) )
										{
											using ( XamlXmlReader rdr = new XamlXmlReader(stm, xamlSettings) )
											{
												bool bWorkflowCreated = false;
												WorkflowApplication wfApp = null;
												try
												{
													ActivityXamlServicesSettings actSettings = new ActivityXamlServicesSettings { CompileExpressions = true };
													// 07/26/2016 Paul.  WF 4.0: NullReferenceException in ActivityXamlServices.Load
													// https://mhusseini.wordpress.com/2014/05/20/nullreferenceexception-in-activityxamlservices-load/
													//workflow = ActivityXamlServices.Load(rdr, actSettings) as DynamicActivity;
													workflow = Workflow4BuildXaml.Load(rdr, actSettings) as DynamicActivity;
													
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
														SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sb.ToString());
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																SqlProcs.spWORKFLOW_RUN_Failed(gWORKFLOW_RUN_ID, "Failed to Load", sb.ToString(), trn);
																trn.Commit();
															}
															catch
															{
																trn.Rollback();
															}
														}
														workflow = null;
													}
												}
												catch(Exception ex)
												{
													string sError = Utils.ExpandException(ex);
													SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
													using ( IDbTransaction trn = Sql.BeginTransaction(con) )
													{
														try
														{
															SqlProcs.spWORKFLOW_RUN_Failed(gWORKFLOW_RUN_ID, "Failed to Load", sError, trn);
															trn.Commit();
														}
														catch
														{
															trn.Rollback();
														}
													}
													workflow = null;
												}
												if ( workflow != null )
												{
													try
													{
														SplendidWorkflowIdentity identity = new SplendidWorkflowIdentity(version, sXAML, gWORKFLOW_ID);
														List<WorkflowIdentity> identityCollection = new List<WorkflowIdentity>()
														{
															identity
														};
														// 08/31/2016 Paul.  It seems like we need a separate store for each CreateInstanceHandle(). 
														SplendidInstanceStore store = new SplendidInstanceStore(Sql, SqlProcs);
														//SqlWorkflowInstanceStore store = new SqlWorkflowInstanceStore(Sql.ToString(Context.Application["ConnectionString"]));
														System.Activities.Runtime.DurableInstancing.InstanceHandle handleCreate = store.CreateInstanceHandle();
														InstanceView view = store.Execute(handleCreate, new CreateWorkflowOwnerWithIdentityCommand()
														{
															InstanceOwnerMetadata =  // IDictionary<System.Xml.Linq.XName, InstanceValue> 
															{
																  { WorkflowNamespace.WorkflowHostType      , new InstanceValue(WFHostTypeName      ) }
																, { Workflow45Namespace.DefinitionIdentities, new InstanceValue(identityCollection  ) }
																, { Workflow45Namespace.DefinitionIdentity  , new InstanceValue(identity            ) }
																, { Workflow45Namespace.DefinitionXAML      , new InstanceValue(sXAML               ) }
																, { Workflow45Namespace.BusinessProcessID   , new InstanceValue(gWORKFLOW_ID        ) }
															}
														}, TimeSpan.FromSeconds(30));
														store.DefaultInstanceOwner = view.InstanceOwner;
														handleCreate.Free();
														
														Dictionary<string, object> dictParameters = new Dictionary<string, object>();
														foreach ( DynamicActivityProperty prop in workflow.Properties )
														{
															Type type = prop.Type.GenericTypeArguments[0];
															if      ( type == typeof(System.String  ) ) dictParameters.Add(prop.Name, String.Empty     );
															else if ( type == typeof(System.Guid    ) ) dictParameters.Add(prop.Name, Guid.Empty       );
															else if ( type == typeof(System.DateTime) ) dictParameters.Add(prop.Name, DateTime.MinValue);
															else if ( type == typeof(System.Decimal ) ) dictParameters.Add(prop.Name, Decimal.Zero     );
															else if ( type == typeof(System.Boolean ) ) dictParameters.Add(prop.Name, false            );
															else if ( type == typeof(System.Int16   ) ) dictParameters.Add(prop.Name, 0                );
															else if ( type == typeof(System.Int32   ) ) dictParameters.Add(prop.Name, 0                );
															else if ( type == typeof(System.Int64   ) ) dictParameters.Add(prop.Name, 0                );
															else if ( type == typeof(System.Single  ) ) dictParameters.Add(prop.Name, 0.0f             );
															else if ( type == typeof(System.Double  ) ) dictParameters.Add(prop.Name, 0.0d             );
															else if ( type == typeof(byte[]         ) ) dictParameters.Add(prop.Name, new byte[0]{}    );
															else dictParameters.Add(prop.Name, String.Empty);
														}
														string sBASE_MODULE = Modules.ModuleName(sAUDIT_TABLE.Replace("_AUDIT", String.Empty));
														// 11/11/2023 Paul.  WF3 to WF4 will use WORKFLOW_ID instead of BUSINESS_PROCESS_ID. 
														if ( dictParameters.ContainsKey("WORKFLOW_ID") ) dictParameters["WORKFLOW_ID"] = gWORKFLOW_ID;
														if ( dictParameters.ContainsKey("BASE_MODULE") ) dictParameters["BASE_MODULE"] = sBASE_MODULE;
														
														Workflow4Utils.LoadModuleData(dictParameters, sAUDIT_TABLE, gAUDIT_ID, (sTYPE == "time"));
														wfApp = new WorkflowApplication(workflow, dictParameters, identity)
														{
															  InstanceStore        = store
															, PersistableIdle      = appEvents.OnIdleAndPersistable
															, Completed            = appEvents.OnWorkflowCompleted
															, Aborted              = appEvents.OnWorkflowAborted
															, Unloaded             = appEvents.OnWorkflowUnloaded
															, OnUnhandledException = appEvents.OnWorkflowException
														};
														SplendidTrackingParticipantWF3 tracking = new SplendidTrackingParticipantWF3(Sql, SqlProcs);
														wfApp.Extensions.Add(tracking);
														SplendidApplicationService sa = new SplendidApplicationService(hostingEnvironment, memoryCache, Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, SplendidDynamic, EmailUtils, XmlUtil, Modules, NoteAttachments, ReportsAttachmentView, SyncError, ExchangeSecurity, ExchangeUtils, GoogleApps, Office365Sync, ExchangeSync, GoogleSync, iCloudSync);
														wfApp.Extensions.Add(sa);
														appEvents.Add(wfApp.Id, wfApp);
														// 06/24/2016 Paul.  spWORKFLOW_RUN_Start will associate this RUN reocrd with the Workflow Instance ID. 
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																SqlProcs.spWORKFLOW_RUN_Start(gWORKFLOW_RUN_ID, wfApp.Id, trn);
																Guid   gWORKFLOW_INSTANCE_INTERNAL_ID = Guid.Empty;
																Guid   gWORKFLOW_INSTANCE_ID          = wfApp.Id;
																string sTYPE_FULL_NAME                = "SplendidCRM";
																string sASSEMBLY_FULL_NAME            = asm.FullName;
																Guid   gCONTEXT_ID                    = gWORKFLOW_INSTANCE_ID;
																Guid   gCALLER_INSTANCE_ID            = Guid.Empty;
																string sbCallPath                     = String.Empty;
																Guid   gCALLER_CONTEXT_ID             = Guid.Empty;
																Guid   gCALLER_PARENT_CONTEXT_ID      = Guid.Empty;
																SqlProcs.spWWF_INSTANCES_Insert(ref gWORKFLOW_INSTANCE_INTERNAL_ID, gWORKFLOW_INSTANCE_ID, sTYPE_FULL_NAME, sASSEMBLY_FULL_NAME, gCONTEXT_ID, gCALLER_INSTANCE_ID, sbCallPath.ToString(), gCALLER_CONTEXT_ID, gCALLER_PARENT_CONTEXT_ID, trn);
																trn.Commit();
															}
															catch(Exception ex)
															{
																trn.Rollback();
																throw(new Exception(ex.Message, ex.InnerException));
															}
														}
														bWorkflowCreated = true;
													}
													catch(Exception ex)
													{
														string sError = Utils.ExpandException(ex);
														SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																SqlProcs.spWORKFLOW_RUN_Failed(gWORKFLOW_RUN_ID, "Failed to Load", sError, trn);
																trn.Commit();
															}
															catch
															{
																trn.Rollback();
															}
														}
													}
												}
												if ( bWorkflowCreated )
												{
													try
													{
														wfApp.Persist();
														wfApp.Run();
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																SqlProcs.spWORKFLOW_RUN_UpdateStatus(gWORKFLOW_RUN_ID, "Started", trn);
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
														string sError = Utils.ExpandException(ex);
														SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																SqlProcs.spWORKFLOW_RUN_Failed(gWORKFLOW_RUN_ID, "Failed to Start", sError, trn);
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
						#endregion
						// 10/15/2023 Paul.  WF3 does not use next events. 
						#region SplendidInstanceStore.NextEvents
#if false
						// 06/24/2016 Paul.  Resume existing workflows. 
						while ( SplendidInstanceStore.NextEvents(Context.Application) > 0 )
						{
							// 05/24/2009 Paul.  We need a way to exit long-running loops. 
							// While we could use a SQL top caluse, using the busy events might work better. 
							// 05/24/2009 Paul.  Running a workflow can take a while, so allow more busy events. 
							if ( nWorkflowBusyEvents >= 2*nMaxWorkflowBusyEvents )
							{
								nWorkflowBusyEvents = 0;
								SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Business Process Events: Busy Events threshold reached during Run.");
								break;
							}
							Guid   gINSTANCE_ID             = Guid.Empty;
							Guid   gAUDIT_ID                = Guid.Empty;
							Guid   gWORKFLOW_ID             = Guid.Empty;
							Guid   gWORKFLOW_RUN_ID         = Guid.Empty;
							string sBLOCKING_BOOKMARKS      = String.Empty;
							string sXAML                    = String.Empty;
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spWF4_INSTANCES_RUNNABLE_Next(ref gINSTANCE_ID, ref gAUDIT_ID, ref gWORKFLOW_ID, ref gWORKFLOW_RUN_ID, ref sBLOCKING_BOOKMARKS, ref sXAML, trn);
									trn.Commit();
								}
								catch
								{
									trn.Rollback();
								}
							}
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spWORKFLOW_RUN_UpdateStatus(gWORKFLOW_RUN_ID, "Resuming", trn);
									trn.Commit();
								}
								catch
								{
									trn.Rollback();
								}
							}
							// 07/22/2016 Paul.  If the instance is currently in memory, then we do not need to reload. 
							if ( appEvents.IsLoaded(gINSTANCE_ID) )
							{
								continue;
							}
							
							DynamicActivity workflow = null;
							using ( StringReader stm = new StringReader(sXAML) )
							{
								using ( XamlXmlReader rdr = new XamlXmlReader(stm, xamlSettings) )
								{
									bool bWorkflowCreated = false;
									WorkflowApplication wfApp = null;
									try
									{
										ActivityXamlServicesSettings actSettings = new ActivityXamlServicesSettings { CompileExpressions = true };
										// 07/26/2016 Paul.  WF 4.0: NullReferenceException in ActivityXamlServices.Load
										// https://mhusseini.wordpress.com/2014/05/20/nullreferenceexception-in-activityxamlservices-load/
										//workflow = ActivityXamlServices.Load(rdr, actSettings) as DynamicActivity;
										workflow = Workflow4BuildXaml.Load(rdr, actSettings) as DynamicActivity;
										// 07/17/2016 Paul.  Must set VisualBasic.SetSettings otherwise validation will fail with definition of WF4Recipient.  
										VisualBasic.SetSettings(workflow, vbSettings);
										
										ValidationResults results = ActivityValidationServices.Validate(workflow);
										foreach (ValidationError warning in results.Warnings)
										{
											Debug.WriteLine(warning.ToString());
										}
										if ( results.Errors.Count > 0 )
										{
											StringBuilder sb = new StringBuilder();
											foreach ( ValidationError error in results.Errors )
											{
												sb.AppendLine(error.ToString() + "<br />");
											}
											throw(new Exception(sb.ToString()));
										}
									}
									catch(Exception ex)
									{
										string sError = Utils.ExpandException(ex);
										SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										using ( IDbTransaction trn = Sql.BeginTransaction(con) )
										{
											try
											{
												SqlProcs.spWORKFLOW_RUN_Failed(gWORKFLOW_RUN_ID, "Failed to Resume/Parse", sError, trn);
												trn.Commit();
											}
											catch
											{
												trn.Rollback();
											}
										}
										workflow = null;
									}
									if ( workflow != null )
									{
										try
										{
											SplendidWorkflowIdentity identity = new SplendidWorkflowIdentity(version, sXAML, gWORKFLOW_ID);
											List<WorkflowIdentity> identityCollection = new List<WorkflowIdentity>()
											{
												identity
											};
											// 08/31/2016 Paul.  It seems like we need a separate store for each CreateInstanceHandle(). 
											SplendidInstanceStore store = new SplendidInstanceStore(Context);
											//SqlWorkflowInstanceStore store = new SqlWorkflowInstanceStore(Sql.ToString(Context.Application["ConnectionString"]));
											InstanceHandle handleCreate = store.CreateInstanceHandle();
											InstanceView view = store.Execute(handleCreate, new CreateWorkflowOwnerWithIdentityCommand()
											{
												InstanceOwnerMetadata =  // IDictionary<System.Xml.Linq.XName, InstanceValue> 
												{
													  { WorkflowNamespace.WorkflowHostType      , new InstanceValue(WFHostTypeName      ) }
													, { Workflow45Namespace.DefinitionIdentities, new InstanceValue(identityCollection  ) }
													, { Workflow45Namespace.DefinitionIdentity  , new InstanceValue(identity            ) }
													, { Workflow45Namespace.DefinitionXAML      , new InstanceValue(sXAML               ) }
													, { Workflow45Namespace.BusinessProcessID   , new InstanceValue(gWORKFLOW_ID        ) }
												}
											}, TimeSpan.FromSeconds(30));
											store.DefaultInstanceOwner = view.InstanceOwner;
											handleCreate.Free();
											
											wfApp = new WorkflowApplication(workflow/*, /*dictParameters*/, identity)
											{
												  InstanceStore        = store
												, PersistableIdle      = appEvents.OnIdleAndPersistable
												, Completed            = appEvents.OnWorkflowCompleted
												, Aborted              = appEvents.OnWorkflowAborted
												, Unloaded             = appEvents.OnWorkflowUnloaded
												, OnUnhandledException = appEvents.OnWorkflowException
											};
											SplendidTrackingParticipantWF3 tracking = new SplendidTrackingParticipantWF3(Context);
											wfApp.Extensions.Add(tracking);
											SplendidApplicationService sa = new SplendidApplicationService(Context);
											wfApp.Extensions.Add(sa);
											wfApp.Load(gINSTANCE_ID);
											appEvents.Add(wfApp.Id, wfApp);
											bWorkflowCreated = true;
										}
										catch(Exception ex)
										{
											string sError = Utils.ExpandException(ex);
											SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													SqlProcs.spWORKFLOW_RUN_Failed(gWORKFLOW_RUN_ID, "Failed to Resume/Load", sError, trn);
													trn.Commit();
												}
												catch
												{
													trn.Rollback();
												}
											}
										}
									}
									if ( bWorkflowCreated )
									{
										try
										{
											// <Bookmarks />
											WF4ApprovalResponse resp = new WF4ApprovalResponse();
											resp.XML = sBLOCKING_BOOKMARKS;
											if ( !Sql.IsEmptyString(sBLOCKING_BOOKMARKS) )
											{
												System.Xml.XmlDocument xml = new System.Xml.XmlDocument();
												xml.LoadXml(sBLOCKING_BOOKMARKS);
												resp.BookmarkName     =            XmlUtil.SelectAttribute (xml, "Bookmarks/Bookmark", "BookmarkName");
												resp.USER_ID          = Sql.ToGuid(XmlUtil.SelectAttribute (xml, "Bookmarks/Bookmark", "USER_ID"     ));
												resp.RESPONSE         =            XmlUtil.SelectSingleNode(xml as System.Xml.XmlNode, "Bookmarks/Bookmark");
											}
											// 09/05/2016 Paul.  Mark as resumed before resuming as action may be very quick. 
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													SqlProcs.spWORKFLOW_RUN_UpdateStatus(gWORKFLOW_RUN_ID, "Resumed", trn);
													trn.Commit();
												}
												catch(Exception ex)
												{
													trn.Rollback();
													throw(new Exception(ex.Message, ex.InnerException));
												}
											}
											if ( Sql.IsEmptyString(resp.BookmarkName) )
											{
												wfApp.Run();
											}
											else
											{
												wfApp.ResumeBookmark(resp.BookmarkName, resp);
											}
										}
										catch(Exception ex)
										{
											string sError = Utils.ExpandException(ex);
											SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													SqlProcs.spWORKFLOW_RUN_Failed(gWORKFLOW_RUN_ID, "Failed to Resume", sError, trn);
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
#endif
						#endregion
					}
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
				Debug.WriteLine("Workflow4UtilsMigratedWF3.Process Busy: " + nWorkflowBusyEvents.ToString());
			}
		}

	}
}
