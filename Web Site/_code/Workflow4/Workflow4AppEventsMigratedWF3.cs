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
using System.Data;
using System.Collections.Concurrent;
using System.Activities;
using Microsoft.AspNetCore.Http;
using System.Diagnostics;

namespace SplendidCRM
{
	// 10/15/2023 Paul.  Use WF4 to run WF3 migrated code. 
	public class Workflow4AppEventsMigratedWF3
	{
		private DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;

		private static ConcurrentDictionary<Guid, WorkflowApplication> runningWorkflows = new ConcurrentDictionary<Guid,WorkflowApplication>();

		public Workflow4AppEventsMigratedWF3(Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError)
		{
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
		}

		public void Add(Guid gINSTANCE_ID, WorkflowApplication workflow)
		{
			runningWorkflows.TryAdd(gINSTANCE_ID, workflow);
		}

		public WorkflowApplication GetLoadedWorkflow(Guid gINSTANCE_ID)
		{
			WorkflowApplication wfApp = null;
			if ( runningWorkflows != null )
				wfApp = runningWorkflows[gINSTANCE_ID];
			return wfApp;
		}

		public bool IsLoaded(Guid gINSTANCE_ID)
		{
			bool bIsLoaded = (runningWorkflows != null && runningWorkflows.ContainsKey(gINSTANCE_ID));
			return bIsLoaded;
		}

		public void OnWorkflowCompleted(WorkflowApplicationCompletedEventArgs e)
		{
			Guid gINSTANCE_ID = e.InstanceId;
			if ( runningWorkflows != null && runningWorkflows.ContainsKey(gINSTANCE_ID))
			{
				WorkflowApplication workflowApp;
				runningWorkflows.TryRemove(gINSTANCE_ID, out workflowApp);
			}
			Debug.WriteLine("OnWorkflowCompleted_MigratedWF3: " + gINSTANCE_ID.ToString() + " " + e.CompletionState);
		}

		public PersistableIdleAction OnIdleAndPersistable(WorkflowApplicationIdleEventArgs e)
		{
			return PersistableIdleAction.Unload;
		}

		public void OnWorkflowAborted(WorkflowApplicationAbortedEventArgs e)
		{
			Guid gINSTANCE_ID = e.InstanceId;
			if ( runningWorkflows != null && runningWorkflows.ContainsKey(gINSTANCE_ID) )
			{
				WorkflowApplication workflowApp;
				runningWorkflows.TryRemove(gINSTANCE_ID, out workflowApp);
			}
			Debug.WriteLine("OnWorkflowAborted_MigratedWF3: " + gINSTANCE_ID.ToString() + " " + e.Reason);
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
							string sReason = Utils.ExpandException(e.Reason);
							SqlProcs.spWORKFLOW_RUN_FailedByInstance(gINSTANCE_ID, "Aborted", sReason, trn);
							Guid gTRACKING_ID = Guid.Empty;
							SqlProcs.spWWF_INSTANCE_EVENTS_Insert(ref gTRACKING_ID, gINSTANCE_ID, "Aborted", 0, DateTime.Now, null, null, null, sReason, trn);
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
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
			}
		}

		public void OnWorkflowUnloaded(WorkflowApplicationEventArgs e)
		{
			Guid gINSTANCE_ID = e.InstanceId;
			if ( runningWorkflows != null && runningWorkflows.ContainsKey(gINSTANCE_ID) )
			{
				WorkflowApplication workflowApp;
				runningWorkflows.TryRemove(gINSTANCE_ID, out workflowApp);
			}
			Debug.WriteLine("OnWorkflowUnloaded_MigratedWF3: " + gINSTANCE_ID.ToString());
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
							SqlProcs.spWORKFLOW_RUN_UpdateStatus(gINSTANCE_ID, "Unloaded", trn);
							Guid gTRACKING_ID = Guid.Empty;
							SqlProcs.spWWF_INSTANCE_EVENTS_Insert(ref gTRACKING_ID, gINSTANCE_ID, "Completed", 0, DateTime.Now, null, null, null, null, trn);
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
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
			}
		}

		public UnhandledExceptionAction OnWorkflowException(WorkflowApplicationUnhandledExceptionEventArgs e)
		{
			//log the exception here using e.UnhandledException 
			// http://stackoverflow.com/questions/3281891/windows-workflow-4-difference-between-workflowapplication-cancel-terminate-an
			/*
			Terminate : 
			*	the Completed event of the workflow application will be triggered
			*	the CompletionState (WorkflowApplicationCompletedEventArgs) is Faulted
			*	the Unloaded event of the workflow application will be triggered
			*	the workflow completes
			*	OnBodyCompleted on the activity will be called

			Cancel:
			*	the Completed event of the workflow application will be triggered
			*	the CompletionState (WorkflowApplicationCompletedEventArgs) is Cancelled
			*	the Unloaded event of the workflow application will be triggered
			*	the workflow completes
			*	OnBodyCompleted on the activity will be called

			Abort:
			*	the Aborted event of the workflow application will be triggered
			*	the workflow does not complete
			*/

			//e.ExceptionSource
			//e.ExceptionSourceInstanceId
			//e.UnhandledException

			Guid gINSTANCE_ID = e.InstanceId;
			Debug.WriteLine("OnWorkflowException_MigratedWF3: " + gINSTANCE_ID.ToString());
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
							string sMESSAGE = Utils.ExpandException(e.UnhandledException);
							SqlProcs.spWORKFLOW_RUN_FailedByInstance(gINSTANCE_ID, "Faulted", sMESSAGE, trn);
							Guid gTRACKING_ID = Guid.Empty;
							SqlProcs.spWWF_INSTANCE_EVENTS_Insert(ref gTRACKING_ID, gINSTANCE_ID, "Faulted", 0, DateTime.Now, null, null, null, sMESSAGE, trn);
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
			}
			return UnhandledExceptionAction.Terminate;
		}
	}

}
