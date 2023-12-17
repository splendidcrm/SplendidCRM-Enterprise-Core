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
using System.Web;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Threading;
using System.Transactions;
using System.Workflow.Runtime;
using System.Workflow.Runtime.Hosting;
using System.Workflow.Runtime.Tracking;
using System.Workflow.ComponentModel;
//using System.Diagnostics;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for SplendidPersistenceService.
	/// </summary>
	public class SplendidPersistenceService : WorkflowPersistenceService, IDisposable
	{
		private DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;

		private readonly bool        bUnloadOnIdle              ;
		private readonly TimeSpan    tsInstanceOwnershipDuration;
		//private readonly TimeSpan    tsLoadingInterval          ;
		private readonly Guid        gOWNER_ID                  ;
		private Timer                tExpiredWorkflows          ;
		private bool                 bInsideTimer = false;

		private DateTime OWNED_UNTIL
		{
			get
			{
				// 07/16/2008 Paul.  OWNED_UNTIL is null when owned forever. 
				return (this.tsInstanceOwnershipDuration == TimeSpan.MaxValue) ? DateTime.MinValue : DateTime.Now + this.tsInstanceOwnershipDuration;
			}
		}

		public SplendidPersistenceService(Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, bool bUnloadOnIdle, TimeSpan tsInstanceOwnershipDuration) //, TimeSpan tsLoadingInterval)
		{
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;

			this.bUnloadOnIdle               = bUnloadOnIdle;
			this.tsInstanceOwnershipDuration = tsInstanceOwnershipDuration;
			//this.tsLoadingInterval           = tsLoadingInterval;
			this.gOWNER_ID                   = Guid.NewGuid();
			
			// 07/17/2008 Paul.  Use the main SplendidCRM Scheduler instead of a separate timer. 
			//if ( tsLoadingInterval > TimeSpan.Zero )
			//{
			//	tExpiredWorkflows = new Timer(OnTimer, null, tsLoadingInterval, tsLoadingInterval);
			//}
		}

		// WorkflowPersistenceService
		protected internal override Activity LoadCompletedContextActivity(Guid scopeId, Activity outerActivity)
		{
			Activity activity = null;
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select ID                    " + ControlChars.CrLf
					     + "  from vwWWF_COMPLETED_SCOPES" + ControlChars.CrLf
					     + " where ID = @ID              " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@ID", scopeId);
						Guid gID = Sql.ToGuid(cmd.ExecuteScalar());
						if ( !Sql.IsEmptyGuid(gID) )
						{
							byte[] byActivityState = null;
							// 09/18/2009 Paul.  PostgreSQL does not require that we stream the bytes, so lets explore doing this for all platforms. 
							if ( Sql.StreamBlobs(con) )
							{
								byActivityState = Sql.ReadImage(gID, con, "spWWF_COMPLETED_SCOPES_ReadOffset");
							}
							else
							{
								cmd.Parameters.Clear();
								// 09/17/2009 Paul.  Azure does not support updatetext, so we need direct way to update the field. 
								sSQL = "select STATE                       " + ControlChars.CrLf
								     + "  from vwWWF_COMPLETED_SCOPES_STATE" + ControlChars.CrLf
								     + " where ID = @ID                    " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								object oBlob = cmd.ExecuteScalar();
								byActivityState = Sql.ToByteArray(oBlob);
							}
							activity = RestoreFromDefaultSerializedForm(byActivityState, outerActivity);
						}
						else
						{
							throw(new Exception("Workflow Scope ID could not be loaded " + scopeId.ToString()));
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				base.RaiseServicesExceptionNotHandledEvent(ex, Guid.Empty);
				throw(new Exception(ex.Message, ex.InnerException));
			}
			return activity;
		}

		protected internal override Activity LoadWorkflowInstanceState(Guid instanceId)
		{
			Activity activity = null;
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					bool bLOCK_SUCCESSFUL = false;
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spWWF_INSTANCE_STATES_Lock(instanceId, this.gOWNER_ID, this.OWNED_UNTIL, ref bLOCK_SUCCESSFUL, trn);
							trn.Commit();
						}
						catch(Exception ex)
						{
							trn.Rollback();
							throw(new Exception(ex.Message, ex.InnerException));
						}
					}
					if ( bLOCK_SUCCESSFUL )
					{
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							byte[] byInstanceState = null;
							// 09/18/2009 Paul.  PostgreSQL does not require that we stream the bytes, so lets explore doing this for all platforms. 
							if ( Sql.StreamBlobs(con) )
							{
								byInstanceState = Sql.ReadImage(instanceId, con, "spWWF_INSTANCE_STATES_ReadOffset");
							}
							else
							{
								cmd.Parameters.Clear();
								// 09/17/2009 Paul.  Azure does not support updatetext, so we need direct way to update the field. 
								string sSQL = String.Empty;
								sSQL = "select STATE                       " + ControlChars.CrLf
								     + "  from vwWWF_INSTANCE_STATES_STATE " + ControlChars.CrLf
								     + " where ID = @ID                    " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", instanceId);
								object oBlob = cmd.ExecuteScalar();
								byInstanceState = Sql.ToByteArray(oBlob);
							}
							activity = RestoreFromDefaultSerializedForm(byInstanceState, null);
						}
					}
					else
					{
						throw(new Exception("Workflow Instance State ID could not be loaded " + instanceId.ToString()));
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				base.RaiseServicesExceptionNotHandledEvent(ex, instanceId);
				throw(new Exception(ex.Message, ex.InnerException));
			}
			return activity;
		}

		protected internal override void SaveCompletedContextActivity(Activity activity)
		{
			try
			{
				Guid   gSCOPE_ID = (Guid) activity.GetValue(Activity.ActivityContextGuidProperty);
				byte[] bySTATE   = GetDefaultSerializedForm(activity);
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spWWF_COMPLETED_SCOPES_Update(ref gSCOPE_ID, WorkflowEnvironment.WorkflowInstanceId, trn);
							// 09/17/2009 Paul.  PostgreSQL does not require that we stream the bytes, so lets explore doing this for all platforms. 
							if ( Sql.StreamBlobs(con) )
							{
								using ( MemoryStream stm = new MemoryStream(bySTATE) )
								{
									const int BUFFER_LENGTH = 4*1024;
									byte[] binFILE_POINTER = new byte[16];
									
									SqlProcs.spWWF_COMPLETED_SCOPES_InitPointer(gSCOPE_ID, ref binFILE_POINTER, trn);
									using ( BinaryReader reader = new BinaryReader(stm) )
									{
										int nFILE_OFFSET = 0 ;
										byte[] binBYTES = reader.ReadBytes(BUFFER_LENGTH);
										while ( binBYTES.Length > 0 )
										{
											SqlProcs.spWWF_COMPLETED_SCOPES_WriteOffset(gSCOPE_ID, binFILE_POINTER, nFILE_OFFSET, binBYTES, trn);
											nFILE_OFFSET += binBYTES.Length;
											binBYTES = reader.ReadBytes(BUFFER_LENGTH);
										}
									}
								}
							}
							else
							{
								// 09/17/2009 Paul.  Azure does not support updatetext, so we need direct way to update the field. 
								SqlProcs.spWWF_COMPLETED_SCOPES_STATE_Update(gSCOPE_ID, bySTATE, trn);
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
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				base.RaiseServicesExceptionNotHandledEvent(ex, Guid.Empty);
				throw(new Exception(ex.Message, ex.InnerException));
			}
		}

		protected internal override void SaveWorkflowInstanceState(Activity rootActivity, bool unlock)
		{
			try
			{
				Guid     gID          = WorkflowEnvironment.WorkflowInstanceId ;
				string   sSTATUS      = GetWorkflowStatus        (rootActivity).ToString();
				bool     bBLOCKED     = GetIsBlocked             (rootActivity);
				string   sINFO        = GetSuspendOrTerminateInfo(rootActivity);
				byte[]   bySTATE      = GetDefaultSerializedForm (rootActivity);
				DateTime dtNEXT_TIMER = DateTime.MinValue;

				TimerEventSubscriptionCollection tesc = rootActivity.GetValue(TimerEventSubscriptionCollection.TimerCollectionProperty) as TimerEventSubscriptionCollection;
				if ( tesc != null )
				{
					TimerEventSubscription tes = tesc.Peek();
					if ( tes != null )
						dtNEXT_TIMER = tes.ExpiresAt.ToLocalTime();  // 07/16/2008 Paul.  ExpiresAt is in UTC. 
				}

				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							int nRESULT = 0;
							SqlProcs.spWWF_INSTANCE_STATES_Update(ref gID, this.gOWNER_ID, sSTATUS, unlock, bBLOCKED, this.OWNED_UNTIL, dtNEXT_TIMER, sINFO, ref nRESULT, trn);
							if ( nRESULT == -2 )
							{
								throw(new WorkflowOwnershipException(gID));
							}
							else if ( sSTATUS != "Completed" && sSTATUS != "Terminated" )
							{
								// 09/17/2009 Paul.  PostgreSQL does not require that we stream the bytes, so lets explore doing this for all platforms. 
								if ( Sql.StreamBlobs(con) )
								{
									using ( MemoryStream stm = new MemoryStream(bySTATE) )
									{
										const int BUFFER_LENGTH = 4*1024;
										byte[] binFILE_POINTER = new byte[16];
										
										SqlProcs.spWWF_INSTANCE_STATES_InitPointer(gID, ref binFILE_POINTER, trn);
										using ( BinaryReader reader = new BinaryReader(stm) )
										{
											int nFILE_OFFSET = 0 ;
											byte[] binBYTES = reader.ReadBytes(BUFFER_LENGTH);
											while ( binBYTES.Length > 0 )
											{
												SqlProcs.spWWF_INSTANCE_STATES_WriteOffset(gID, binFILE_POINTER, nFILE_OFFSET, binBYTES, trn);
												nFILE_OFFSET += binBYTES.Length;
												binBYTES = reader.ReadBytes(BUFFER_LENGTH);
											}
										}
									}
								}
								else
								{
									// 09/17/2009 Paul.  Azure does not support updatetext, so we need direct way to update the field. 
									SqlProcs.spWWF_INSTANCE_STATES_STATE_Update(gID, bySTATE, trn);
								}
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
			catch(Exception ex)
			{
				// 09/20/2013 Paul.  Restarting the app can cause a workflow ownership excpetion.  Just ignore the exception. 
				if ( !ex.Message.StartsWith("This workflow is not owned by the WorkflowRuntime.") )
				{
					SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
					base.RaiseServicesExceptionNotHandledEvent(ex, WorkflowEnvironment.WorkflowInstanceId);
					throw(new Exception(ex.Message, ex.InnerException));
				}
			}
		}

		protected internal override bool UnloadOnIdle(Activity activity)
		{
			return this.bUnloadOnIdle;
		}

		protected internal override void UnlockWorkflowInstanceState(Activity rootActivity)
		{
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spWWF_INSTANCE_STATES_Unlock(WorkflowEnvironment.WorkflowInstanceId, this.gOWNER_ID, trn);
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
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				base.RaiseServicesExceptionNotHandledEvent(ex, Guid.Empty);
				throw(new Exception(ex.Message, ex.InnerException));
			}
		}

		public void OnTimer(Object sender)
		{
			// 07/16/2008 Paul.  In case the timer takes a long time, only allow one timer event to be processed. 
			if ( !bInsideTimer )
			{
				bInsideTimer = true;
				try
				{
					if ( base.State == WorkflowRuntimeServiceState.Started )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select ID                           " + ControlChars.CrLf
							     + "  from vwWWF_INSTANCE_STATES_Expired" + ControlChars.CrLf;
							using ( DataTable dt = new DataTable() )
							{
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									using ( DbDataAdapter da = dbf.CreateDataAdapter() )
									{
										((IDbDataAdapter)da).SelectCommand = cmd;
										da.Fill(dt);
									}
								}
								foreach ( DataRow row in dt.Rows )
								{
									Guid gID = Sql.ToGuid(row["ID"]);
									if ( !Sql.IsEmptyGuid(gID) )
									{
										try
										{
											base.Runtime.GetWorkflow(gID).Load();
										}
										catch(WorkflowOwnershipException)
										{
											// 07/16/2008 Paul.  Some exceptions are safe to ignore. 
											continue;
										}
										catch(ObjectDisposedException ex)
										{
											SplendidError.SystemMessage("Warning", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
											base.RaiseServicesExceptionNotHandledEvent(ex, gID);
											throw(new Exception(ex.Message, ex.InnerException));
										}
										catch(InvalidOperationException ex)
										{
											if ( !ex.Data.Contains("WorkflowNotFound") )
											{
												SplendidError.SystemMessage("Warning", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex) + " " + gID.ToString());
												base.RaiseServicesExceptionNotHandledEvent(ex, gID);
											}
											continue;
										}
										catch(Exception ex)
										{
											// 07/16/2008 Paul.  Ignore most exceptions. 
											SplendidError.SystemMessage("Warning", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
											base.RaiseServicesExceptionNotHandledEvent(ex, gID);
											continue;
										}
									}
								}
							}
						}
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				}
				finally
				{
					bInsideTimer = false;
				}
			}
		}

		protected override void OnStarted()
		{
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select ID                            " + ControlChars.CrLf
					     + "  from vwWWF_INSTANCE_STATES_Nonblock" + ControlChars.CrLf;
					using ( DataTable dt = new DataTable() )
					{
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
							}
						}
						// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								foreach ( DataRow row in dt.Rows )
								{
									Guid gID = Sql.ToGuid(row["ID"]);
									bool bLOCK_SUCCESSFUL = false;
									SqlProcs.spWWF_INSTANCE_STATES_Lock(gID, this.gOWNER_ID, this.OWNED_UNTIL, ref bLOCK_SUCCESSFUL, trn);
									if ( !bLOCK_SUCCESSFUL )
									{
										// 07/16/2008 Paul.  Just in case we were not able to lock it fast enough, just skip the load. 
										// Another option is to include the select in the transaction, but that seems like a major performance issue. 
										row["ID"] = Guid.Empty;
									}
								}
								trn.Commit();
							}
							catch(Exception ex)
							{
								trn.Rollback();
								throw(new Exception(ex.Message, ex.InnerException));
							}
						}
						foreach ( DataRow row in dt.Rows )
						{
							Guid gID = Sql.ToGuid(row["ID"]);
							if ( !Sql.IsEmptyGuid(gID) )
								base.Runtime.GetWorkflow(gID).Load();
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				base.RaiseServicesExceptionNotHandledEvent(ex, Guid.Empty);
				// 06/26/2010 Paul.  Adding the ATTACHMENTS to the AlertActivity is causing lots of persistence exceptions. 
				// Lets log the error but not throw the exception. 
				//throw(new Exception(ex.Message, ex.InnerException));
			}
		}

		protected internal override void Stop()
		{
			try
			{
				if ( tExpiredWorkflows != null )
				{
					tExpiredWorkflows.Dispose();
					tExpiredWorkflows = null;
				}
				base.Stop();
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				base.RaiseServicesExceptionNotHandledEvent(ex, Guid.Empty);
				throw(new Exception(ex.Message, ex.InnerException));
			}
		}

		// IDisposable
		public void Dispose()
		{
			Dispose(true);
			GC.SuppressFinalize(this);
		}

		protected virtual void Dispose(bool disposing)
		{
			if ( disposing )
			{
				if ( tExpiredWorkflows != null )
				{
					tExpiredWorkflows.Dispose();
					tExpiredWorkflows = null;
				}
			}
		}
	}
}
