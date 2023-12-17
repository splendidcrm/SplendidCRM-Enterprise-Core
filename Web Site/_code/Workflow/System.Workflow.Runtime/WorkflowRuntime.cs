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
using System.Collections.Generic;
using System.Globalization;
using System.Workflow.ComponentModel;
using System.Workflow.Runtime.Hosting;
using System.Xml;

namespace System.Workflow.Runtime
{
	public class WorkflowRuntime : IServiceProvider
	{
		private object _servicesLock = new object();
		private object _startStopLock = new object();
		private bool _startedServices;
		private Dictionary<Type, List<object>> _services = new Dictionary<Type, List<object>>();

		public event EventHandler<ServicesExceptionNotHandledEventArgs> ServicesExceptionNotHandled;
		public event EventHandler<WorkflowRuntimeEventArgs> Stopped;
		public event EventHandler<WorkflowRuntimeEventArgs> Started;

		public void AddService(object service)
		{
			lock (_startStopLock)
			{
				AddServiceImpl(service);
			}
		}

		private void AddServiceImpl(object service)
		{
			lock (_servicesLock)
			{
				Type basetype = service.GetType();
				foreach (Type t in basetype.GetInterfaces())
				{
					List<object> al;
					if (_services.ContainsKey(t))
					{
						al = _services[t];
					}
					else
					{
						al = new List<object>();
						_services.Add(t, al);
					}
					al.Add(service);
				}
 
				while (basetype != null)
				{
					List<object> al = null;
					if (_services.ContainsKey(basetype))
					{
						al = _services[basetype];
					}
					else
					{
						al = new List<object>();
						_services.Add(basetype, al);
					}
					al.Add(service);
					basetype = basetype.BaseType;
				}
			}

			WorkflowRuntimeService wrs = service as WorkflowRuntimeService;
			if (wrs != null)
			{
				wrs.SetRuntime(this);
				if (_startedServices)
					wrs.Start();
			}
		}

		public void RemoveService(object service)
		{
			if (service == null)
				throw new ArgumentNullException("service");
 
			lock (_startStopLock)
			{
				lock (_servicesLock)
				{
					Type type = service.GetType();
					foreach (List<object> al in _services.Values)
					{
						if (al.Contains(service))
						{
							al.Remove(service);
						}
					}
				}
				WorkflowRuntimeService wrs = service as WorkflowRuntimeService;
				if (wrs != null)
				{
					if (_startedServices)
						wrs.Stop();
 
					wrs.SetRuntime(null);
				}
			}
		}

		public T GetService<T>()
		{
			return (T) GetService(typeof(T));
		}

		public object GetService(Type serviceType)
		{
			if (serviceType == null)
				throw new ArgumentNullException("serviceType");
 
			lock (_servicesLock)
			{
				object retval = null;
 
				if (_services.ContainsKey(serviceType))
				{
					List<object> al = _services[serviceType];
 
					if (al.Count > 1)
						throw new InvalidOperationException(String.Format(CultureInfo.CurrentCulture, "ExecutionStringManager.MoreThanOneService", serviceType.ToString()));
 
					if (al.Count == 1)
						retval = al[0];
				}
 
				return retval;
			}
		}

		public void StartRuntime()
		{
		}

		public void StopRuntime()
		{
		}

		public WorkflowInstance GetWorkflow(Guid instanceId)
		{
			WorkflowExecutor executor = Load(instanceId, null, null);
			return executor.WorkflowInstance;
		}

		WorkflowExecutor Load(WorkflowInstance instance)
		{
			throw(new Exception("WorkflowRuntime.Load: Not implemented"));
			//return Load(instance.InstanceId, null, instance);
		}

		internal WorkflowExecutor Load(Guid key, CreationContext context, WorkflowInstance workflowInstance)
		{
			throw(new Exception("WorkflowRuntime.Load: Not implemented"));
		}

		internal Activity GetWorkflowDefinition(Type workflowType)
		{
			throw(new Exception("WorkflowRuntime.GetWorkflowDefinition: Not implemented"));
		}
 
		public WorkflowInstance CreateWorkflow(Type workflowType)
		{
			throw(new Exception("WorkflowRuntime.CreateWorkflow: Not implemented"));
		}
 
		public WorkflowInstance CreateWorkflow(Type workflowType, Dictionary<string, object> namedArgumentValues)
		{
			return CreateWorkflow(workflowType, namedArgumentValues, Guid.NewGuid());
		}
 
		public WorkflowInstance CreateWorkflow(XmlReader workflowDefinitionReader)
		{
			if (workflowDefinitionReader == null)
				throw new ArgumentNullException("WorkflowRuntime.CreateWorkflow: workflowDefinitionReader is null");
 
			return CreateWorkflow(workflowDefinitionReader, null, null);
		}
 
		public WorkflowInstance CreateWorkflow(XmlReader workflowDefinitionReader, XmlReader rulesReader, Dictionary<string, object> namedArgumentValues)
		{
			return CreateWorkflow(workflowDefinitionReader, rulesReader, namedArgumentValues, Guid.NewGuid());
		}
 
		public WorkflowInstance CreateWorkflow(Type workflowType, Dictionary<string, object> namedArgumentValues, Guid instanceId)
		{
			throw(new Exception("WorkflowRuntime.CreateWorkflow: Not implemented"));
		}
 
		public WorkflowInstance CreateWorkflow(XmlReader workflowDefinitionReader, XmlReader rulesReader, Dictionary<string, object> namedArgumentValues, Guid instanceId)
		{
			throw(new Exception("WorkflowRuntime.CreateWorkflow: Not implemented"));
		}

	}
}
