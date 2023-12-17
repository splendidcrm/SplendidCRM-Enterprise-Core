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
using System.Workflow.ComponentModel;

namespace System.Workflow.Runtime
{
	public class TimerEventSubscriptionCollection //: ICollection
	{
		public readonly static DependencyProperty TimerCollectionProperty;  // = DependencyProperty.RegisterAttached("TimerCollection", typeof(TimerEventSubscriptionCollection), typeof(TimerEventSubscriptionCollection));
 
		private object locker = new Object();
		private KeyedPriorityQueue<Guid, TimerEventSubscription, DateTime> queue = new KeyedPriorityQueue<Guid, TimerEventSubscription, DateTime>();
#pragma warning disable 0414
		private bool suspended = false; // no longer used but required for binary compatibility of serialization format
#pragma warning restore 0414
		[NonSerialized]
		private IWorkflowCoreRuntime executor;
		private Guid instanceId;
 
		internal TimerEventSubscriptionCollection(IWorkflowCoreRuntime executor, Guid instanceId)
		{
			this.executor = executor;
			this.instanceId = instanceId;
			this.queue.FirstElementChanged += OnFirstElementChanged;
		}
 
		internal void Enqueue(TimerEventSubscription timerEventSubscription)
		{
			lock (locker)
			{
				queue.Enqueue(timerEventSubscription.SubscriptionId, timerEventSubscription, timerEventSubscription.ExpiresAt);
			}
		}
 
		internal IWorkflowCoreRuntime Executor
		{
			get { return executor; }
			set { executor = value; }
		}
 
		public TimerEventSubscription Peek()
		{
			lock (locker)
			{
				return queue.Peek();
			}
		}
 
		internal TimerEventSubscription Dequeue()
		{
			lock (locker)
			{
				TimerEventSubscription retval = queue.Dequeue();
				return retval;
			}
		}
 
		public void Remove(Guid timerSubscriptionId)
		{
			lock (locker)
			{
				queue.Remove(timerSubscriptionId);
			}
		}
 
		private void OnFirstElementChanged(object source, KeyedPriorityQueueHeadChangedEventArgs<TimerEventSubscription> e)
		{
			throw(new Exception("TimerEventSubscriptionCollection.OnFirstElementChanged: Not implemented"));
			/*
			lock (locker)
			{
				ITimerService timerService = this.executor.GetService(typeof(ITimerService)) as ITimerService;
				if (e.NewFirstElement != null && executor != null)
				{
					timerService.ScheduleTimer(executor.ProcessTimersCallback, e.NewFirstElement.WorkflowInstanceId, e.NewFirstElement.ExpiresAt, e.NewFirstElement.SubscriptionId);
				}
				if (e.OldFirstElement != null)
				{
					timerService.CancelTimer(e.OldFirstElement.SubscriptionId);
				}
			}
			*/
		}
 
		internal void SuspendDelivery()
		{
			throw(new Exception("TimerEventSubscriptionCollection.SuspendDelivery: Not implemented"));
			/*
			lock (locker)
			{
				WorkflowSchedulerService schedulerService = this.executor.GetService(typeof(WorkflowSchedulerService)) as WorkflowSchedulerService;
				TimerEventSubscription sub = queue.Peek();
				if (sub != null)
				{
					schedulerService.Cancel(sub.SubscriptionId);
				}
			}
			*/
		}
 
		internal void ResumeDelivery()
		{
			throw(new Exception("TimerEventSubscriptionCollection.ResumeDelivery: Not implemented"));
			/*
			lock (locker)
			{
				WorkflowSchedulerService schedulerService = this.executor.GetService(typeof(WorkflowSchedulerService)) as WorkflowSchedulerService;
				TimerEventSubscription sub = queue.Peek();
				if (sub != null)
				{
					schedulerService.Schedule(executor.ProcessTimersCallback, sub.WorkflowInstanceId, sub.ExpiresAt, sub.SubscriptionId);
				}
			}
			*/
		}
 
		public void Add(TimerEventSubscription item)
		{
			if (item == null)
				throw new ArgumentNullException("item");
			this.Enqueue(item);
		}
 
 
		public void Remove(TimerEventSubscription item)
		{
			if (item == null)
				throw new ArgumentNullException("item");
			this.Remove(item.SubscriptionId);
		}
 
		#region ICollection Members
 
		public void CopyTo(Array array, int index)
		{
			TimerEventSubscription[] tes = null;
			lock (locker)
			{
				tes = new TimerEventSubscription[queue.Count];
				queue.Values.CopyTo(tes, 0);
			}
			if (tes != null)
				tes.CopyTo(array, index);
		}
 
		public int Count
		{
			get
			{
				return queue.Count;
			}
		}
 
		public bool IsSynchronized
		{
			get
			{
				return true;
			}
		}
 
		public object SyncRoot
		{
			get
			{
				return locker;
			}
		}
 
		#endregion
 
		/*
		public IEnumerator GetEnumerator()
		{
			return queue.Values.GetEnumerator();
		}
		*/
	}
}
