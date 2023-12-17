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
using System.IO.Compression;
using System.Globalization;
using System.Workflow.Runtime;
using System.Workflow.ComponentModel;
//using System.Diagnostics;

namespace System.Workflow.Runtime.Hosting
{
	public abstract class WorkflowPersistenceService : WorkflowRuntimeService
	{
		internal protected abstract void SaveWorkflowInstanceState(Activity rootActivity, bool unlock);
		internal protected abstract void UnlockWorkflowInstanceState(Activity rootActivity);
		internal protected abstract Activity LoadWorkflowInstanceState(Guid instanceId);
		internal protected abstract void SaveCompletedContextActivity(Activity activity);
		internal protected abstract Activity LoadCompletedContextActivity(Guid scopeId, Activity outerActivity);
		internal protected abstract bool UnloadOnIdle(Activity activity);

		static protected Activity RestoreFromDefaultSerializedForm(Byte[] activityBytes, Activity outerActivity)
		{
			DateTime startTime = DateTime.Now;
			Activity state;
 
			MemoryStream stream = new MemoryStream(activityBytes);
			stream.Position = 0;
 
			using (GZipStream gzs = new GZipStream(stream, CompressionMode.Decompress, true))
			{
				state = Activity.Load(gzs, outerActivity);
			}
			return state;
		}

		static protected byte[] GetDefaultSerializedForm(Activity activity)
		{
			DateTime startTime = DateTime.Now;
			Byte[] result;
 
			using (MemoryStream stream = new MemoryStream(10240))
			{
				stream.Position = 0;
				activity.Save(stream);
				using (MemoryStream compressedStream = new MemoryStream((int)stream.Length))
				{
					using (GZipStream gzs = new GZipStream(compressedStream, CompressionMode.Compress, true))
					{
						gzs.Write(stream.GetBuffer(), 0, (int)stream.Length);
					}
 
					ActivityExecutionContextInfo executionContextInfo = (ActivityExecutionContextInfo)activity.GetValue(Activity.ActivityExecutionContextInfoProperty);
					TimeSpan timeElapsed = DateTime.Now - startTime;
 
					result = compressedStream.GetBuffer();
					Array.Resize<Byte>(ref result, Convert.ToInt32(compressedStream.Length));
				}
			}
			return result;
		}

		static protected internal bool GetIsBlocked(Activity rootActivity)
		{
			return (bool)rootActivity.GetValue(WorkflowExecutor.IsBlockedProperty);
		}

		static protected internal string GetSuspendOrTerminateInfo(Activity rootActivity)
		{
			return (string)rootActivity.GetValue(WorkflowExecutor.SuspendOrTerminateInfoProperty);
		}

		static protected internal WorkflowStatus GetWorkflowStatus(Activity rootActivity)
		{
			return (WorkflowStatus)rootActivity.GetValue(WorkflowExecutor.WorkflowStatusProperty);
		}
	}
}
