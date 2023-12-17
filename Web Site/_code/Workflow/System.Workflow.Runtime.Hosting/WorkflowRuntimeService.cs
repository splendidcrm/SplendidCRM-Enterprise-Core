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
using System.Diagnostics;
using System.Globalization;
using System.Workflow.Runtime;

namespace System.Workflow.Runtime.Hosting
{
	public enum WorkflowRuntimeServiceState
	{
		Stopped,
		Starting,
		Started,
		Stopping
	}

	public abstract class WorkflowRuntimeService
	{
		private WorkflowRuntime _runtime;
		private WorkflowRuntimeServiceState state = WorkflowRuntimeServiceState.Stopped;
		public event EventHandler<ServicesExceptionNotHandledEventArgs> ServicesExceptionNotHandled;

		protected WorkflowRuntime Runtime
		{
			get
			{
				return _runtime;
			}
		}

		public void SetRuntime(WorkflowRuntime runtime)
		{
			if (runtime == null && _runtime != null)
			{
				_runtime.Started -= this.HandleStarted;
				_runtime.Stopped -= this.HandleStopped;
			}
			_runtime = runtime;
			if (runtime != null)
			{
				_runtime.Started += this.HandleStarted;
				_runtime.Stopped += this.HandleStopped;
			}
		}

		protected WorkflowRuntimeServiceState State
		{
			get { return state; }
		}
 
		virtual internal protected void Start()
		{
			if (_runtime == null)
				throw new InvalidOperationException(String.Format(CultureInfo.CurrentCulture, "ExecutionStringManager.ServiceNotAddedToRuntime", this.GetType().Name));
			if (state.Equals(WorkflowRuntimeServiceState.Started))
				throw new InvalidOperationException(String.Format(CultureInfo.CurrentCulture, "ExecutionStringManager.ServiceAlreadyStarted", this.GetType().Name));
 
			state = WorkflowRuntimeServiceState.Starting;
		}
 
		virtual internal protected void Stop()
		{
			if (_runtime == null)
				throw new InvalidOperationException(String.Format(CultureInfo.CurrentCulture, "ExecutionStringManager.ServiceNotAddedToRuntime", this.GetType().Name));
			if (state.Equals(WorkflowRuntimeServiceState.Stopped))
				throw new InvalidOperationException(String.Format(CultureInfo.CurrentCulture, "ExecutionStringManager.ServiceNotStarted", this.GetType().Name));
 
			state = WorkflowRuntimeServiceState.Stopping;
		}
 
		virtual protected void OnStarted()
		{ }
 
		virtual protected void OnStopped()
		{ }
 
		private void HandleStarted(object source, WorkflowRuntimeEventArgs e)
		{
			state = WorkflowRuntimeServiceState.Started;
			this.OnStarted();
		}
 
		private void HandleStopped(object source, WorkflowRuntimeEventArgs e)
		{
			state = WorkflowRuntimeServiceState.Stopped;
			this.OnStopped();
		}

		internal void RaiseServicesExceptionNotHandledEvent(Exception exception, Guid instanceId)
		{
			EventHandler<ServicesExceptionNotHandledEventArgs> handler = ServicesExceptionNotHandled;
			if (handler != null)
				handler(this, new ServicesExceptionNotHandledEventArgs(exception, instanceId));
		}
	}
}
