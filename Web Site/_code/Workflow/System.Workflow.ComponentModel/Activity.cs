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
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

namespace System.Workflow.ComponentModel
{
	public class Activity : DependencyObject
	{
		#pragma warning disable 649,169,67,414
		private static DependencyProperty NameProperty;  //  = DependencyProperty.Register("Name", typeof(string), typeof(Activity), new PropertyMetadata("", DependencyPropertyOptions.Metadata, new ValidationOptionAttribute(ValidationOption.Required)));
		private static DependencyProperty DescriptionProperty;  //  = DependencyProperty.Register("Description", typeof(string), typeof(Activity), new PropertyMetadata("", DependencyPropertyOptions.Metadata));
		private static DependencyProperty EnabledProperty;  //  = DependencyProperty.Register("Enabled", typeof(bool), typeof(Activity), new PropertyMetadata(true, DependencyPropertyOptions.Metadata));
		private static DependencyProperty QualifiedNameProperty;  //  = DependencyProperty.Register("QualifiedName", typeof(string), typeof(Activity), new PropertyMetadata(DependencyPropertyOptions.Metadata | DependencyPropertyOptions.ReadOnly));
		private static DependencyProperty DottedPathProperty;  //  = DependencyProperty.Register("DottedPath", typeof(string), typeof(Activity), new PropertyMetadata(DependencyPropertyOptions.Metadata | DependencyPropertyOptions.ReadOnly));
		internal static readonly DependencyProperty WorkflowXamlMarkupProperty;  //  = DependencyProperty.Register("WorkflowXamlMarkup", typeof(string), typeof(Activity));
		internal static readonly DependencyProperty WorkflowRulesMarkupProperty;  //  = DependencyProperty.Register("WorkflowRulesMarkup", typeof(string), typeof(Activity));
 
		internal static readonly DependencyProperty SynchronizationHandlesProperty;  //  = DependencyProperty.Register("SynchronizationHandles", typeof(ICollection<String>), typeof(Activity), new PropertyMetadata(DependencyPropertyOptions.Metadata));
 
		internal static readonly DependencyProperty ActivityExecutionContextInfoProperty;  // = DependencyProperty.RegisterAttached("ActivityExecutionContextInfo", typeof(ActivityExecutionContextInfo), typeof(Activity));
		public static readonly DependencyProperty ActivityContextGuidProperty;  // = DependencyProperty.RegisterAttached("ActivityContextGuid", typeof(Guid), typeof(Activity), new PropertyMetadata(Guid.Empty));
		internal static readonly DependencyProperty CompletedExecutionContextsProperty;  // = DependencyProperty.RegisterAttached("CompletedExecutionContexts", typeof(IList), typeof(Activity));
		internal static readonly DependencyProperty ActiveExecutionContextsProperty;  // = DependencyProperty.RegisterAttached("ActiveExecutionContexts", typeof(IList), typeof(Activity));
		internal static readonly DependencyProperty CompletedOrderIdProperty;  //  = DependencyProperty.Register("CompletedOrderId", typeof(int), typeof(Activity), new PropertyMetadata(new Int32()));
		private static readonly DependencyProperty SerializedStreamLengthProperty;  // = DependencyProperty.RegisterAttached("SerializedStreamLength", typeof(long), typeof(Activity), new PropertyMetadata(DependencyPropertyOptions.NonSerialized));
 
		// activity runtime state
		internal static readonly DependencyProperty ExecutionStatusProperty;  // = DependencyProperty.RegisterAttached("ExecutionStatus", typeof(ActivityExecutionStatus), typeof(Activity), new PropertyMetadata(ActivityExecutionStatus.Initialized, new Attribute[] { new BrowsableAttribute(false), new DesignerSerializationVisibilityAttribute(DesignerSerializationVisibility.Hidden) }));
		internal static readonly DependencyProperty ExecutionResultProperty;  // = DependencyProperty.RegisterAttached("ExecutionResult", typeof(ActivityExecutionResult), typeof(Activity), new PropertyMetadata(ActivityExecutionResult.None, new Attribute[] { new BrowsableAttribute(false), new DesignerSerializationVisibilityAttribute(DesignerSerializationVisibility.Hidden) }));
		internal static readonly DependencyProperty WasExecutingProperty;  // = DependencyProperty.RegisterAttached("WasExecuting", typeof(bool), typeof(Activity), new PropertyMetadata(false, new Attribute[] { new BrowsableAttribute(false), new DesignerSerializationVisibilityAttribute(DesignerSerializationVisibility.Hidden) }));
 
		// lock count on status change property
		private static readonly DependencyProperty LockCountOnStatusChangeProperty;  // = DependencyProperty.RegisterAttached("LockCountOnStatusChange", typeof(int), typeof(Activity), new PropertyMetadata(new Int32()));
		internal static readonly DependencyProperty HasPrimaryClosedProperty;  // = DependencyProperty.RegisterAttached("HasPrimaryClosed", typeof(bool), typeof(Activity), new PropertyMetadata(false));
 
		// nested activity collection used at serialization time
		private static readonly DependencyProperty NestedActivitiesProperty;  // = DependencyProperty.RegisterAttached("NestedActivities", typeof(IList<Activity>), typeof(Activity));
 
		// Workflow Definition property, should only be visible to runtime
		internal static readonly DependencyProperty WorkflowDefinitionProperty;  // = DependencyProperty.RegisterAttached("WorkflowDefinition", typeof(Activity), typeof(Activity), new PropertyMetadata(DependencyPropertyOptions.NonSerialized));
 
		// Workflow Runtime property, should only be visible to runtime
		internal static readonly DependencyProperty WorkflowRuntimeProperty;  // = DependencyProperty.RegisterAttached("WorkflowRuntime", typeof(IServiceProvider), typeof(Activity), new PropertyMetadata(DependencyPropertyOptions.NonSerialized));
 
		internal static Hashtable ContextIdToActivityMap = null;
		internal static Activity DefinitionActivity = null;
		internal static ArrayList ActivityRoots = null;
 
		private static readonly BinaryFormatter binaryFormatter = null;
		//private static ActivityResolveEventHandler activityDefinitionResolve = null;
		//private static WorkflowChangeActionsResolveEventHandler workflowChangeActionsResolve = null;
 
		private string cachedDottedPath = null;
 
		private IWorkflowCoreRuntime workflowCoreRuntime = null;
 
		internal CompositeActivity parent = null;
 
		private static object staticSyncRoot = new object();
 
		internal static readonly DependencyProperty CustomActivityProperty;  //  = DependencyProperty.Register("CustomActivity", typeof(bool), typeof(Activity), new PropertyMetadata(DependencyPropertyOptions.Metadata));
		internal static Type ActivityType = null;

		public string QualifiedName;
		public bool Enabled;
		#pragma warning restore 649,169,67,414

		public CompositeActivity Parent
		{
			get
			{
				return this.parent;
			}
		}

		public static Activity Load(Stream stream, Activity outerActivity)
		{
			return Load(stream, outerActivity, binaryFormatter);
		}

		public static Activity Load(Stream stream, Activity outerActivity, IFormatter formatter)
		{
			Activity returnActivity = null;
			return returnActivity;
		}

		public void Save(Stream stream)
		{
			throw(new Exception("Activity.Save: Not implemented"));
		}
	}
}
