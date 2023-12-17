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
using System.Activities.Hosting;
using System.Workflow.ComponentModel;

namespace System.Workflow.Runtime
{
	class WorkflowExecutor : IWorkflowCoreRuntime, IServiceProvider //, ISupportInterop
	{
		internal readonly static DependencyProperty WorkflowExecutorProperty; // = DependencyProperty.RegisterAttached("WorkflowExecutor", typeof(IWorkflowCoreRuntime), typeof(WorkflowExecutor), new PropertyMetadata(DependencyPropertyOptions.NonSerialized));
		internal readonly static DependencyProperty TransientBatchProperty; // = DependencyProperty.RegisterAttached("TransientBatch", typeof(IWorkBatch), typeof(WorkflowExecutor), new PropertyMetadata(null, DependencyPropertyOptions.NonSerialized, new GetValueOverride(GetTransientBatch), null));
		internal readonly static DependencyProperty TransactionalPropertiesProperty; // = DependencyProperty.RegisterAttached("TransactionalProperties", typeof(TransactionalProperties), typeof(WorkflowExecutor), new PropertyMetadata(DependencyPropertyOptions.NonSerialized));
		internal readonly static DependencyProperty WorkflowInstanceIdProperty; // = DependencyProperty.RegisterAttached("WorkflowInstanceId", typeof(Guid), typeof(WorkflowExecutor), new PropertyMetadata(Guid.NewGuid()));
		internal readonly static DependencyProperty IsBlockedProperty; // = DependencyProperty.RegisterAttached("IsBlocked", typeof(bool), typeof(WorkflowExecutor), new PropertyMetadata(false));
		internal readonly static DependencyProperty WorkflowStatusProperty; // = DependencyProperty.RegisterAttached("WorkflowStatus", typeof(WorkflowStatus), typeof(WorkflowExecutor), new PropertyMetadata(WorkflowStatus.Created));
		internal readonly static DependencyProperty SuspendOrTerminateInfoProperty; // = DependencyProperty.RegisterAttached("SuspendOrTerminateInfo", typeof(string), typeof(WorkflowExecutor));
 
		// Persisted state properties
		private static DependencyProperty ContextIdProperty; // = DependencyProperty.RegisterAttached("ContextId", typeof(int), typeof(WorkflowExecutor), new PropertyMetadata(new Int32()));
		private static DependencyProperty TrackingCallingStateProperty; // = DependencyProperty.RegisterAttached("TrackingCallingState", typeof(TrackingCallingState), typeof(WorkflowExecutor));
		internal static DependencyProperty TrackingListenerBrokerProperty; // = DependencyProperty.RegisterAttached("TrackingListenerBroker", typeof(TrackingListenerBroker), typeof(WorkflowExecutor));
		private static DependencyProperty IsSuspensionRequestedProperty; // = DependencyProperty.RegisterAttached("IsSuspensionRequested", typeof(bool), typeof(WorkflowExecutor), new PropertyMetadata(false));
		private static DependencyProperty IsIdleProperty; // = DependencyProperty.RegisterAttached("IsIdle", typeof(bool), typeof(WorkflowExecutor), new PropertyMetadata(false));

		Activity rootActivity;
		
		public WorkflowInstance WorkflowInstance;

		object IServiceProvider.GetService(Type serviceType)
		{
			throw(new Exception("WorkflowExecutor.GetService: Not implemented"));
			//return ((IWorkflowCoreRuntime)this).GetService(this.rootActivity, serviceType);
		}
	}
}
