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
using System.Web;
using System.Data;
using System.Reflection;
using System.Workflow.Runtime;
using System.Workflow.ComponentModel.Compiler;
using System.Diagnostics;

using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.JSInterop;

using Spring.Social.Office365;

namespace SplendidCRM
{
	public class WorkflowInit
	{
		private static WorkflowRuntime _runtime = null;

		private IWebHostEnvironment   hostingEnvironment   ;
		private IMemoryCache          memoryCache          ;
		private DbProviderFactories   DbProviderFactories   = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState  Application           = new HttpApplicationState();
		public  HttpSessionState      Session              ;
		public  Security              Security             ;
		private Sql                   Sql                  ;
		private SqlProcs              SqlProcs             ;
		private SplendidError         SplendidError        ;
		private SplendidCache         SplendidCache        ;
		private SplendidDynamic       SplendidDynamic      ;
		private EmailUtils            EmailUtils           ;
		public  XmlUtil               XmlUtil              ;
		private Crm.Modules           Modules              ;
		private Crm.NoteAttachments   NoteAttachments      ;
		private ReportsAttachmentView ReportsAttachmentView;
		public  SyncError             SyncError            ;
		public  ExchangeSecurity      ExchangeSecurity     ;
		private ExchangeUtils         ExchangeUtils        ;
		private GoogleApps            GoogleApps           ;
		private Office365Sync         Office365Sync        ;
		private ExchangeSync          ExchangeSync         ;
		private GoogleSync            GoogleSync           ;
		private iCloudSync            iCloudSync           ;

		public WorkflowInit(IWebHostEnvironment hostingEnvironment, IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SplendidDynamic SplendidDynamic, EmailUtils EmailUtils, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, ReportsAttachmentView ReportsAttachmentView, SyncError SyncError, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, GoogleApps GoogleApps, Spring.Social.Office365.Office365Sync Office365Sync, ExchangeSync ExchangeSync, GoogleSync GoogleSync, iCloudSync iCloudSync)
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
			this.Modules               = Modules              ;
			this.NoteAttachments       = NoteAttachments      ;
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

		public void StartRuntime()
		{
			//string sConnectionString = Sql.ToString(Application["ConnectionString"]);
			WorkflowRuntime runtime = new WorkflowRuntime();
			// 10/09/2008 Paul.  Capture not handled exceptions. 
			runtime.ServicesExceptionNotHandled += new EventHandler<ServicesExceptionNotHandledEventArgs>(ExceptionNotHandled);

			SplendidTrackingService ts = new SplendidTrackingService(Sql, SqlProcs, SplendidError);
			//SqlTrackingService ts = new SqlTrackingService(sConnectionString);
			//ts.UseDefaultProfile = true;
			//ts.IsTransactional = true;
			Application["SplendidTrackingService"   ] = ts;

			TimeSpan tsInstanceOwnershipDuration = new TimeSpan(0, 0, 60);
			TimeSpan tsLoadingInterval           = new TimeSpan(0, 0, 60);
			SplendidPersistenceService ps = new SplendidPersistenceService(Sql, SqlProcs, SplendidError, true, tsInstanceOwnershipDuration);  //, tsLoadingInterval);
			//SqlWorkflowPersistenceService ps = new SqlWorkflowPersistenceService(sConnectionString);
			Application["SplendidPersistenceService"] = ps;

			// 07/15/2008 Paul.  Shared connection was required to get tracking to work.
			//SharedConnectionWorkflowCommitWorkBatchService sc = new SharedConnectionWorkflowCommitWorkBatchService(sConnectionString);
			//Application["SplendidSharedConnection"] = sc;

			// 07/29/2008 Paul.  Add this DLL to the services available to the workflow runtime. 
			TypeProvider tp = new TypeProvider(runtime);
			Assembly asm = Assembly.GetExecutingAssembly();
			#pragma warning disable 618
			//Assembly asm = Assembly.LoadWithPartialName("SplendidWorkflows");
			#pragma warning restore 618
			tp.AddAssembly(asm);
			runtime.AddService(tp);

			SplendidApplicationService sa = new SplendidApplicationService(hostingEnvironment, memoryCache, Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, SplendidDynamic, EmailUtils, XmlUtil, Modules, NoteAttachments, ReportsAttachmentView, SyncError, ExchangeSecurity, ExchangeUtils, GoogleApps, Office365Sync, ExchangeSync, GoogleSync, iCloudSync);
			runtime.AddService(sa);

			runtime.AddService(ts);
			runtime.AddService(ps);
			//runtime.AddService(sc);
			runtime.StartRuntime();
			_runtime = runtime;
		}

		private void ExceptionNotHandled(object sender, ServicesExceptionNotHandledEventArgs e)
		{
			try
			{
				WorkflowRuntime runtime = sender as WorkflowRuntime;
				if ( runtime != null )
				{
					SplendidApplicationService app = runtime.GetService<SplendidApplicationService>();
					
					string sError = Utils.ExpandException(e.Exception);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
					
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spWORKFLOW_RUN_FailedByInstance(e.WorkflowInstanceId, "Exception Not Handled", sError, trn);
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
			catch
			{
			}
		}

		public void StopRuntime()
		{
			WorkflowRuntime runtime = _runtime;
			if ( runtime != null )
			{
				// 09/21/2013 Paul.  Changing a file can cause .NET 4.0 to restart the app and generate an exception when stopping the runtime. 
				// Just ignore the error as the app is being restarted. 
				try
				{
					runtime.StopRuntime();
					SplendidTrackingService ts = Application["SplendidTrackingService"] as SplendidTrackingService;
					//TrackingService ts = Application["SplendidTrackingService"] as TrackingService;
					if ( ts != null )
					{
						runtime.RemoveService(ts);
						Application.Remove("SplendidTrackingService");
					}

					SplendidPersistenceService ps = Application["SplendidPersistenceService"] as SplendidPersistenceService;
					//WorkflowPersistenceService ps = Application["SplendidPersistenceService"] as WorkflowPersistenceService;
					if ( ps != null )
					{
						runtime.RemoveService(ps);
						Application.Remove("SplendidPersistenceService");
					}

					SplendidApplicationService sa = runtime.GetService<SplendidApplicationService>();
					if ( sa != null )
					{
						runtime.RemoveService(sa);
					}

					TypeProvider tp = runtime.GetService<TypeProvider>();
					if ( tp != null )
						runtime.RemoveService(sa);

					//SharedConnectionWorkflowCommitWorkBatchService sc = Application["SplendidSharedConnection"] as SharedConnectionWorkflowCommitWorkBatchService;
					//if ( sc != null )
					//{
					//	runtime.RemoveService(sc);
					//	Application.Remove("SplendidSharedConnection");
					//}
				}
				catch
				{
				}
				Application.Remove("WorkflowRuntime");
			}
		}

		public WorkflowRuntime GetRuntime()
		{
			return _runtime;
		}

	}
}
