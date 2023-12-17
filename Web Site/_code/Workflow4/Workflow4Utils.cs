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
using System.Collections.Generic;
using System.Security.Cryptography;
using Microsoft.VisualBasic.Activities;
using System.Xaml;
using System.Activities;
using System.Activities.XamlIntegration;
using System.Activities.DurableInstancing;
using System.Activities.Runtime.DurableInstancing;
//using System.Runtime.Serialization;
using System.Activities.Validation;

using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Caching.Memory;
using System.Diagnostics;

using Spring.Social.Office365;

namespace SplendidCRM
{
	public class Workflow4Utils
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

		public  static bool bInsideWorkflow = false;
		private static int  nWorkflowBusyEvents = 0;

		public Workflow4Utils(IWebHostEnvironment hostingEnvironment, IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SplendidDynamic SplendidDynamic, EmailUtils EmailUtils, XmlUtil XmlUtil, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, Workflow4BuildXaml Workflow4BuildXaml, ReportsAttachmentView ReportsAttachmentView, SyncError SyncError, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, GoogleApps GoogleApps, Office365Sync Office365Sync, ExchangeSync ExchangeSync, GoogleSync GoogleSync, iCloudSync iCloudSync)
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
		}
		
		public static byte[] ComputeHash(byte[] buffer)
		{
			using ( MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider() )
			{
				byte[] binMD5 = md5.ComputeHash(buffer);
				return binMD5;
			}
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
					Workflow4AppEvents appEvents = new Workflow4AppEvents(Sql, SqlProcs, SplendidError);
					
					// http://www.help-doing.com/cp/PersistenceplusinplusWFplus-c.shtml
					XName WFHostTypeName = XName.Get("SplendidHost");
					
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL ;
						// 06/23/2016 Paul.  A Business Process is just like a Workflow with record and timed events. 
						#region vwBUSINESS_PROCESSES_RunTimed
						try
						{
							using ( DataTable dt = new DataTable() )
							{
								sSQL = "select *                            " + ControlChars.CrLf
								     + "  from vwBUSINESS_PROCESSES_RunTimed" + ControlChars.CrLf
								     + " order by NEXT_RUN                  " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
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
									DateTime dtLAST_RUN   = Sql.ToDateTime(row["NEXT_RUN"   ]);
									try
									{
										using ( DataTable dtTimedEvents = new DataTable() )
										{
											using ( IDbCommand cmd = con.CreateCommand() )
											{
												cmd.CommandText = sFILTER_SQL;
												cmd.CommandTimeout = 0;
												if ( sFILTER_SQL.Contains("@BUSINESS_PROCESS_ID") )
													Sql.AddParameter(cmd, "@BUSINESS_PROCESS_ID", gWORKFLOW_ID);
												
												using ( DbDataAdapter da = dbf.CreateDataAdapter() )
												{
													((IDbDataAdapter)da).SelectCommand = cmd;
													da.Fill(dtTimedEvents);
												}
											}
											if ( dtTimedEvents.Rows.Count > 0 )
											{
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														foreach ( DataRow rowTimed in dtTimedEvents.Rows )
														{
															Guid gAUDIT_ID = Sql.ToGuid(rowTimed["ID"]);
															SqlProcs.spBUSINESS_PROCESSES_RUN_InsertOnly(gWORKFLOW_ID, gAUDIT_ID, sBASE_MODULE, "Ready", trn);
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
										using ( IDbTransaction trn = Sql.BeginTransaction(con) )
										{
											try
											{
												SqlProcs.spBUSINESS_PROCESSES_UpdateLastRun(gWORKFLOW_ID, dtLAST_RUN, trn);
												trn.Commit();
											}
											catch(Exception ex)
											{
												trn.Rollback();
												SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
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

						// 06/23/2016 Paul.  A Business Process is just like a Workflow with record and timed events. 
						sSQL = "select ID                            " + ControlChars.CrLf
						     + "     , BUSINESS_PROCESS_ID           " + ControlChars.CrLf
						     + "     , AUDIT_ID                      " + ControlChars.CrLf
						     + "     , AUDIT_TABLE                   " + ControlChars.CrLf
						     + "     , TYPE                          " + ControlChars.CrLf
						     + "     , XAML                          " + ControlChars.CrLf
						     + "  from vwBUSINESS_PROCESSES_RUN_Ready" + ControlChars.CrLf
						     + " order by BUSINESS_PROCESS_VERSION   " + ControlChars.CrLf;
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
											SplendidError.SystemMessage("Warning", new System.Diagnostics.StackTrace(true).GetFrame(0), "Business Process Events: Busy Events threshold reached during Run.");
											break;
										}
										Guid   gBUSINESS_PROCESS_RUN_ID = Sql.ToGuid  (row["ID"                 ]);
										Guid   gBUSINESS_PROCESS_ID     = Sql.ToGuid  (row["BUSINESS_PROCESS_ID"]);
										Guid   gAUDIT_ID                = Sql.ToGuid  (row["AUDIT_ID"           ]);
										string sAUDIT_TABLE             = Sql.ToString(row["AUDIT_TABLE"        ]);
										string sTYPE                    = Sql.ToString(row["TYPE"               ]);
										string sXAML                    = Sql.ToString(row["XAML"               ]);
										// 06/24/2016 Paul.  The AUDIT_TABLE field contains the module name for a timed workflow. 
										if ( sTYPE == "time" )
										{
											sAUDIT_TABLE = Modules.TableName(sAUDIT_TABLE);
										}
										using ( IDbTransaction trn = Sql.BeginTransaction(con) )
										{
											try
											{
												SqlProcs.spBUSINESS_PROCESSES_RUN_UpdateStatus(gBUSINESS_PROCESS_RUN_ID, "Loading", trn);
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
														System.Diagnostics.Debug.WriteLine(warning.ToString());
													}
													if ( results.Errors.Count > 0 )
													{
														StringBuilder sb = new StringBuilder();
														foreach ( System.Activities.Validation.ValidationError error in results.Errors )
														{
															sb.AppendLine(error.ToString() + "<br />");
														}
														SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sb.ToString());
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Failed to Load", sb.ToString(), trn);
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
													SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sError);
													using ( IDbTransaction trn = Sql.BeginTransaction(con) )
													{
														try
														{
															SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Failed to Load", sError, trn);
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
														SplendidWorkflowIdentity identity = new SplendidWorkflowIdentity(version, sXAML, gBUSINESS_PROCESS_ID);
														List<WorkflowIdentity> identityCollection = new List<WorkflowIdentity>()
														{
															identity
														};
														// 08/31/2016 Paul.  It seems like we need a separate store for each CreateInstanceHandle(). 
														SplendidInstanceStore store = new SplendidInstanceStore(Sql, SqlProcs);
														//SqlWorkflowInstanceStore store = new SqlWorkflowInstanceStore(Sql.ToString(Application["ConnectionString"]));
														System.Activities.Runtime.DurableInstancing.InstanceHandle handleCreate = store.CreateInstanceHandle();
														InstanceView view = store.Execute(handleCreate, new CreateWorkflowOwnerWithIdentityCommand()
														{
															InstanceOwnerMetadata =  // IDictionary<System.Xml.Linq.XName, InstanceValue> 
															{
																  { WorkflowNamespace.WorkflowHostType      , new InstanceValue(WFHostTypeName      ) }
																, { Workflow45Namespace.DefinitionIdentities, new InstanceValue(identityCollection  ) }
																, { Workflow45Namespace.DefinitionIdentity  , new InstanceValue(identity            ) }
																, { Workflow45Namespace.DefinitionXAML      , new InstanceValue(sXAML               ) }
																, { Workflow45Namespace.BusinessProcessID   , new InstanceValue(gBUSINESS_PROCESS_ID) }
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
														if ( dictParameters.ContainsKey("BUSINESS_PROCESS_ID") ) dictParameters["BUSINESS_PROCESS_ID"] = gBUSINESS_PROCESS_ID;
														if ( dictParameters.ContainsKey("BASE_MODULE"        ) ) dictParameters["BASE_MODULE"        ] = sBASE_MODULE        ;
														
														LoadModuleData(dictParameters, sAUDIT_TABLE, gAUDIT_ID, (sTYPE == "time"));
														wfApp = new WorkflowApplication(workflow, dictParameters, identity)
														{
															  InstanceStore        = store
															, PersistableIdle      = appEvents.OnIdleAndPersistable
															, Completed            = appEvents.OnWorkflowCompleted
															, Aborted              = appEvents.OnWorkflowAborted
															, Unloaded             = appEvents.OnWorkflowUnloaded
															, OnUnhandledException = appEvents.OnWorkflowException
														};
														SplendidTrackingParticipant tracking = new SplendidTrackingParticipant(Sql, SqlProcs);
														wfApp.Extensions.Add(tracking);
														SplendidApplicationService sa = new SplendidApplicationService(hostingEnvironment, memoryCache, Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, SplendidDynamic, EmailUtils, XmlUtil, Modules, NoteAttachments, ReportsAttachmentView, SyncError, ExchangeSecurity, ExchangeUtils, GoogleApps, Office365Sync, ExchangeSync, GoogleSync, iCloudSync);
														wfApp.Extensions.Add(sa);
														appEvents.Add(wfApp.Id, wfApp);
														// 06/24/2016 Paul.  spBUSINESS_PROCESSES_RUN_Start will associate this RUN reocrd with the Workflow Instance ID. 
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																SqlProcs.spBUSINESS_PROCESSES_RUN_Start(gBUSINESS_PROCESS_RUN_ID, wfApp.Id, trn);
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
														SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sError);
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Failed to Load", sError, trn);
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
																SqlProcs.spBUSINESS_PROCESSES_RUN_UpdateStatus(gBUSINESS_PROCESS_RUN_ID, "Started", trn);
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
														SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sError);
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Failed to Start", sError, trn);
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
						// 10/15/2023 Paul.  WF3 does not use next events. 
						#region SplendidInstanceStore.NextEvents
#if false
						// 06/24/2016 Paul.  Resume existing workflows. 
						while ( SplendidInstanceStore.NextEvents() > 0 )
						{
							// 05/24/2009 Paul.  We need a way to exit long-running loops. 
							// While we could use a SQL top caluse, using the busy events might work better. 
							// 05/24/2009 Paul.  Running a workflow can take a while, so allow more busy events. 
							if ( nWorkflowBusyEvents >= 2*nMaxWorkflowBusyEvents )
							{
								nWorkflowBusyEvents = 0;
								SplendidError.SystemMessage("Warning", new System.Diagnostics.StackTrace(true).GetFrame(0), "Business Process Events: Busy Events threshold reached during Run.");
								break;
							}
							Guid   gINSTANCE_ID             = Guid.Empty;
							Guid   gAUDIT_ID                = Guid.Empty;
							Guid   gBUSINESS_PROCESS_ID     = Guid.Empty;
							Guid   gBUSINESS_PROCESS_RUN_ID = Guid.Empty;
							string sBLOCKING_BOOKMARKS      = String.Empty;
							string sXAML                    = String.Empty;
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spWF4_INSTANCES_RUNNABLE_Next(ref gINSTANCE_ID, ref gAUDIT_ID, ref gBUSINESS_PROCESS_ID, ref gBUSINESS_PROCESS_RUN_ID, ref sBLOCKING_BOOKMARKS, ref sXAML, trn);
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
									SqlProcs.spBUSINESS_PROCESSES_RUN_UpdateStatus(gBUSINESS_PROCESS_RUN_ID, "Resuming", trn);
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
										foreach (System.Activities.Validation.ValidationError warning in results.Warnings)
										{
											System.Diagnostics.Debug.WriteLine(warning.ToString());
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
									catch(Exception ex)
									{
										string sError = Utils.ExpandException(ex);
										SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sError);
										using ( IDbTransaction trn = Sql.BeginTransaction(con) )
										{
											try
											{
												SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Failed to Resume/Parse", sError, trn);
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
											SplendidWorkflowIdentity identity = new SplendidWorkflowIdentity(version, sXAML, gBUSINESS_PROCESS_ID);
											List<WorkflowIdentity> identityCollection = new List<WorkflowIdentity>()
											{
												identity
											};
											// 08/31/2016 Paul.  It seems like we need a separate store for each CreateInstanceHandle(). 
											SplendidInstanceStore store = new SplendidInstanceStore(Sql, SqlProcs);
											//SqlWorkflowInstanceStore store = new SqlWorkflowInstanceStore(Sql.ToString(Application["ConnectionString"]));
											System.Activities.Runtime.DurableInstancing.InstanceHandle handleCreate = store.CreateInstanceHandle();
											InstanceView view = store.Execute(handleCreate, new CreateWorkflowOwnerWithIdentityCommand()
											{
												InstanceOwnerMetadata =  // IDictionary<System.Xml.Linq.XName, InstanceValue> 
												{
													  { WorkflowNamespace.WorkflowHostType      , new InstanceValue(WFHostTypeName      ) }
													, { Workflow45Namespace.DefinitionIdentities, new InstanceValue(identityCollection  ) }
													, { Workflow45Namespace.DefinitionIdentity  , new InstanceValue(identity            ) }
													, { Workflow45Namespace.DefinitionXAML      , new InstanceValue(sXAML               ) }
													, { Workflow45Namespace.BusinessProcessID   , new InstanceValue(gBUSINESS_PROCESS_ID) }
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
											SplendidTrackingParticipant tracking = new SplendidTrackingParticipant(Sql, SqlProcs);
											wfApp.Extensions.Add(tracking);
											SplendidApplicationService sa = new SplendidApplicationService(hostingEnvironment, memoryCache, Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, SplendidDynamic, EmailUtils, XmlUtil, Modules, NoteAttachments, ReportsAttachmentView, SyncError, ExchangeSecurity, ExchangeUtils, GoogleApps, Office365Sync, ExchangeSync, GoogleSync, iCloudSync);
											wfApp.Extensions.Add(sa);
											wfApp.Load(gINSTANCE_ID);
											appEvents.Add(wfApp.Id, wfApp);
											bWorkflowCreated = true;
										}
										catch(Exception ex)
										{
											string sError = Utils.ExpandException(ex);
											SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sError);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Failed to Resume/Load", sError, trn);
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
													SqlProcs.spBUSINESS_PROCESSES_RUN_UpdateStatus(gBUSINESS_PROCESS_RUN_ID, "Resumed", trn);
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
											SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sError);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Failed to Resume", sError, trn);
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
					SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
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

		public void Terminate(Guid gINSTANCE_ID, string sReason)
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
			Workflow4AppEvents appEvents = new Workflow4AppEvents(Sql, SqlProcs, SplendidError);
				
			// http://www.help-doing.com/cp/PersistenceplusinplusWFplus-c.shtml
			XName WFHostTypeName = XName.Get("SplendidHost");
				
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				Guid   gAUDIT_ID                = Guid.Empty;
				Guid   gBUSINESS_PROCESS_ID     = Guid.Empty;
				Guid   gBUSINESS_PROCESS_RUN_ID = Guid.Empty;
				string sBLOCKING_BOOKMARKS      = String.Empty;
				string sXAML                    = String.Empty;
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spWF4_INSTANCES_RUNNABLE_Get(gINSTANCE_ID, ref gAUDIT_ID, ref gBUSINESS_PROCESS_ID, ref gBUSINESS_PROCESS_RUN_ID, ref sBLOCKING_BOOKMARKS, ref sXAML, trn);
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
					}
				}
				// 06/18/2017 Paul.  We can't load a completed workflow. 
				bool bIS_COMPLETED = false;
				try
				{
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandType = CommandType.Text;
						cmd.CommandText = "select IS_COMPLETED from vwWF4_INSTANCES where ID = @ID";
						Sql.AddParameter(cmd, "@ID", gINSTANCE_ID);
						bIS_COMPLETED = Sql.ToBoolean(cmd.ExecuteScalar());
					}
				}
				catch
				{
				}
				// 06/18/2017 Paul.  We are going to block a second attempt to terminate. 
				if ( bIS_COMPLETED )
				{
					return;
				}
				if ( appEvents.IsLoaded(gINSTANCE_ID) )
				{
					WorkflowApplication wfApp = appEvents.GetLoadedWorkflow(gINSTANCE_ID);
					wfApp.Terminate(sReason);
				}
				else if ( !Sql.IsEmptyGuid(gBUSINESS_PROCESS_RUN_ID) )
				{
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
									System.Diagnostics.Debug.WriteLine(warning.ToString());
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
							catch(Exception ex)
							{
								string sError = Utils.ExpandException(ex);
								SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sError);
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Failed to Resume/Parse", sError, trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
									}
								}
								throw;
							}
							if ( workflow != null )
							{
								try
								{
									SplendidWorkflowIdentity identity = new SplendidWorkflowIdentity(version, sXAML, gBUSINESS_PROCESS_ID);
									List<WorkflowIdentity> identityCollection = new List<WorkflowIdentity>()
									{
										identity
									};
									// 08/31/2016 Paul.  It seems like we need a separate store for each CreateInstanceHandle(). 
									SplendidInstanceStore store = new SplendidInstanceStore(Sql, SqlProcs);
									//SqlWorkflowInstanceStore store = new SqlWorkflowInstanceStore(Sql.ToString(Application["ConnectionString"]));
									System.Activities.Runtime.DurableInstancing.InstanceHandle handleCreate = store.CreateInstanceHandle();
									InstanceView view = store.Execute(handleCreate, new CreateWorkflowOwnerWithIdentityCommand()
									{
										InstanceOwnerMetadata =  // IDictionary<System.Xml.Linq.XName, InstanceValue> 
										{
											  { WorkflowNamespace.WorkflowHostType      , new InstanceValue(WFHostTypeName      ) }
											, { Workflow45Namespace.DefinitionIdentities, new InstanceValue(identityCollection  ) }
											, { Workflow45Namespace.DefinitionIdentity  , new InstanceValue(identity            ) }
											, { Workflow45Namespace.DefinitionXAML      , new InstanceValue(sXAML               ) }
											, { Workflow45Namespace.BusinessProcessID   , new InstanceValue(gBUSINESS_PROCESS_ID) }
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
									SplendidTrackingParticipant tracking = new SplendidTrackingParticipant(Sql, SqlProcs);
									wfApp.Extensions.Add(tracking);
									SplendidApplicationService sa = new SplendidApplicationService(hostingEnvironment, memoryCache, Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, SplendidDynamic, EmailUtils, XmlUtil, Modules, NoteAttachments, ReportsAttachmentView, SyncError, ExchangeSecurity, ExchangeUtils, GoogleApps, Office365Sync, ExchangeSync, GoogleSync, iCloudSync);
									wfApp.Extensions.Add(sa);
									wfApp.Load(gINSTANCE_ID);
									appEvents.Add(wfApp.Id, wfApp);
									bWorkflowCreated = true;
								}
								catch(Exception ex)
								{
									string sError = Utils.ExpandException(ex);
									SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sError);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(Guid.Empty, gINSTANCE_ID, "Failed to Resume/Load", sError, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
										}
									}
									throw;
								}
							}
							if ( bWorkflowCreated )
							{
								try
								{
									wfApp.Terminate(sReason);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Terminated", sReason, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								catch(Exception ex)
								{
									string sError = Utils.ExpandException(ex);
									SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), sError);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spBUSINESS_PROCESSES_RUN_Failed(gBUSINESS_PROCESS_RUN_ID, Guid.Empty, "Failed to Terminate", sError, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
										}
									}
									throw;
								}
							}
						}
					}
				}
			}
		}

		// 10/15/2023 Paul.   Give access to MigratedWF3 class. 
		public void LoadModuleData(Dictionary<string, object> dictParameters, string sTABLE_NAME, Guid gID, bool bTimed)
		{
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL = String.Empty;
				sSQL = "select * "               + ControlChars.CrLf
				     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
				if ( bTimed )
					sSQL += " where ID = @ID" + ControlChars.CrLf;
				else
					sSQL += " where AUDIT_ID = @AUDIT_ID" + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					if ( bTimed )
						Sql.AddParameter(cmd, "@ID", gID);
					else
						Sql.AddParameter(cmd, "@AUDIT_ID", gID);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							for ( int nColumn=0 ; nColumn < rdr.FieldCount ; nColumn++ )
							{
								string sFieldName = rdr.GetName(nColumn);
								if ( !dictParameters.ContainsKey(sFieldName) || rdr.IsDBNull(nColumn) )
									continue;
								else if ( rdr.GetFieldType(nColumn) == typeof(System.String  ) ) dictParameters[sFieldName] = rdr.GetString  (nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(System.Guid    ) ) dictParameters[sFieldName] = rdr.GetGuid    (nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(System.DateTime) ) dictParameters[sFieldName] = rdr.GetDateTime(nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(System.Decimal ) ) dictParameters[sFieldName] = rdr.GetDecimal (nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(System.Boolean ) ) dictParameters[sFieldName] = rdr.GetBoolean (nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(System.Int16   ) ) dictParameters[sFieldName] = rdr.GetInt16   (nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(System.Int32   ) ) dictParameters[sFieldName] = rdr.GetInt32   (nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(System.Int64   ) ) dictParameters[sFieldName] = rdr.GetInt64   (nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(System.Single  ) ) dictParameters[sFieldName] = rdr.GetDouble  (nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(System.Double  ) ) dictParameters[sFieldName] = rdr.GetDouble  (nColumn);
								else if ( rdr.GetFieldType(nColumn) == typeof(byte[]         ) )
								{
									long   lTotalLength     = rdr.GetBytes(nColumn, 0, null, 0, 0);
									long   lBytesRead       = 0;
									int    lCurrentPosition = 0;
									int    lChunkSize       = 64 * 1024;
									byte[] byData           = new byte[lTotalLength];
									while ( lBytesRead < lTotalLength )
									{
										lBytesRead += rdr.GetBytes(nColumn, lCurrentPosition, byData, lCurrentPosition, lChunkSize);
										lCurrentPosition += lChunkSize;
									}
									dictParameters[sFieldName] = byData;
								}
							}
						}
					}
				}
			}
		}

		public static void RoundRobinUser(Sql Sql, SqlProcs SqlProcs, IDbConnection con, List<Guid> arrUsers, Guid gBUSINESS_PROCESS_ID, ref Guid gPROCESS_USER_ID)
		{
			if ( arrUsers.Count > 0 )
			{
				Guid gLAST_USER_ID = Guid.Empty;
				string sSQL = String.Empty;
				sSQL = "select LAST_USER_ID        " + ControlChars.CrLf
				     + "  from vwBUSINESS_PROCESSES" + ControlChars.CrLf
				     + " where ID = @ID            " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gBUSINESS_PROCESS_ID);
					gLAST_USER_ID = Sql.ToGuid(cmd.ExecuteScalar());
				}
				int nNextUser = 0;
				if ( !Sql.IsEmptyGuid(gLAST_USER_ID) )
				{
					for ( int i = 0; i < arrUsers.Count; i++ )
					{
						if ( arrUsers[i] == gLAST_USER_ID )
						{
							nNextUser = i + 1;
							// 08/02/2016 Paul.  If at end of list, then round to top. 
							if ( nNextUser >= arrUsers.Count )
								nNextUser = 0;
							break;
						}
					}
				}
				gPROCESS_USER_ID = arrUsers[nNextUser];
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spBUSINESS_PROCESSES_UpdLastUser
							( gBUSINESS_PROCESS_ID
							, gPROCESS_USER_ID
							, trn
							);
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
			}
		}

		public static void NextDynamicTeam(Sql Sql, SqlProcs SqlProcs, IDbConnection con, bool bEnableTeamHierarchy, Guid gBUSINESS_PROCESS_ID, Guid gTEAM_ID, ref Guid gPROCESS_USER_ID)
		{
			List<Guid> arrUsers = new List<Guid>();
			string sSQL = String.Empty;
			if ( !bEnableTeamHierarchy )
			{
				sSQL = "select MEMBERSHIP_USER_ID           " + ControlChars.CrLf
				     + "  from vwTEAM_MEMBERSHIPS           " + ControlChars.CrLf
				     + " where MEMBERSHIP_TEAM_ID = @TEAM_ID" + ControlChars.CrLf
				     + " order by DATE_ENTERED              " + ControlChars.CrLf;
			}
			else
			{
				if ( Sql.IsOracle(con) )
				{
					sSQL = "select MEMBERSHIP_USER_ID           " + ControlChars.CrLf
					     + "  from table(fnTEAM_HIERARCHY_USERS(@TEAM_ID)) vwTEAM_MEMBERSHIPS" + ControlChars.CrLf
					     + " order by DATE_ENTERED              " + ControlChars.CrLf;
				}
				else
				{
					string fnPrefix = (Sql.IsSQLServer(con) ? "dbo." : String.Empty);
					sSQL = "select MEMBERSHIP_USER_ID           " + ControlChars.CrLf
					     + "  from " + fnPrefix + "fnTEAM_HIERARCHY_USERS(@TEAM_ID) vwTEAM_MEMBERSHIPS" + ControlChars.CrLf
					     + " order by DATE_ENTERED              " + ControlChars.CrLf;
				}
			}
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@TEAM_ID", gTEAM_ID);
				using ( IDataReader rdr = cmd.ExecuteReader() )
				{
					while ( rdr.Read() )
					{
						arrUsers.Add(Sql.ToGuid(rdr[0]));
					}
				}
			}
			RoundRobinUser(Sql, SqlProcs, con, arrUsers, gBUSINESS_PROCESS_ID, ref gPROCESS_USER_ID);
		}

		public static void NextDynamicRole(Sql Sql, SqlProcs SqlProcs, IDbConnection con, Guid gBUSINESS_PROCESS_ID, Guid gROLE_ID, ref Guid gPROCESS_USER_ID)
		{
			List<Guid> arrUsers = new List<Guid>();
			string sSQL = String.Empty;
			sSQL = "select vwUSERS_ACL_ROLES.USER_ID                              " + ControlChars.CrLf
			     + "  from vwUSERS_ACL_ROLES                                      " + ControlChars.CrLf
			     + " inner join vwUSERS_ASSIGNED_TO                               " + ControlChars.CrLf
			     + "         on vwUSERS_ASSIGNED_TO.ID = vwUSERS_ACL_ROLES.USER_ID" + ControlChars.CrLf
			     + " where ROLE_ID = @ROLE_ID                                     " + ControlChars.CrLf
			     + " order by vwUSERS_ASSIGNED_TO.DATE_ENTERED                    " + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@ROLE_ID", gROLE_ID);
				using ( IDataReader rdr = cmd.ExecuteReader() )
				{
					while ( rdr.Read() )
					{
						arrUsers.Add(Sql.ToGuid(rdr[0]));
					}
				}
			}
			RoundRobinUser(Sql, SqlProcs, con, arrUsers, gBUSINESS_PROCESS_ID, ref gPROCESS_USER_ID);
		}

	}
}
