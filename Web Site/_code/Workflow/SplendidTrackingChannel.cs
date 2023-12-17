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
using System.Text;
using System.Xml;
using System.Web;
using System.Data;
using System.Globalization;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Workflow.Runtime;
using System.Workflow.Runtime.Tracking;
using System.Workflow.ComponentModel;
//using System.Workflow.ComponentModel.Serialization;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
//using System.Diagnostics;

namespace SplendidCRM
{
	// Writing Tracking Services for Windows Workflow Foundation
	// http://msdn.microsoft.com/en-us/library/aa730873(VS.80).aspx
	// Monitoring Workflows with WF for Enhanced Application Data Visibility
	// http://msdn2.microsoft.com/en-us/library/cc299397.aspx
	// Creating Custom Tracking Services
	// http://msdn.microsoft.com/en-us/library/ms735912(VS.85).aspx
	public class SplendidTrackingChannel : System.Workflow.Runtime.Tracking.TrackingChannel  //, System.Workflow.Runtime.IPendingWork
	{
		private DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;

		private TrackingParameters   parameters ;
		private Guid                 gWORKFLOW_INSTANCE_INTERNAL_ID;
		private MD5                  md5;

		#region TrackingChannel Members
		public SplendidTrackingChannel(Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, TrackingParameters parameters)
		{
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;

			this.parameters  = parameters;
			// 11/13/2008 Paul.  We are having a problem with Send() being called before SendWorkflowDefinition(). 
			// So define the internal ID in the constructor. 
			// C:/Web.net/SplendidCRM6/_code/Workflow/SplendidTrackingChannel.cs Line141, Void Send(System.Workflow.Runtime.Tracking.TrackingRecord). 
			// Cannot insert the value NULL into column 'WORKFLOW_INSTANCE_INTERNAL_ID', table 'WWF_INSTANCE_EVENTS'; column does not allow nulls. INSERT fails.
			this.gWORKFLOW_INSTANCE_INTERNAL_ID = Guid.NewGuid();
			this.md5 = new MD5CryptoServiceProvider();
		}

		protected internal override void InstanceCompletedOrTerminated()
		{
		}

		protected internal override void Send(TrackingRecord record)
		{
			try
			{
				/*
				bool bTransactional = record.Annotations.Contains("Transactional");
				bTransactional = false;
				if ( bTransactional )
				{
					BinaryFormatter bf  = new BinaryFormatter();
					bf.Context = new StreamingContext(StreamingContextStates.Clone);
					if ( record is WorkflowTrackingRecord )
					{
						//CloneDataItems(record as WorkflowTrackingRecord);
						if ( record.EventArgs != null )
						{
							using ( MemoryStream stm = new MemoryStream(0x400) )
							{
								try
								{
									stm.Seek(0, 0);
									bf.Serialize(stm, record.EventArgs);
									stm.Seek(0, 0);
									record.EventArgs = (EventArgs) bf.Deserialize(stm);
								}
								catch
								{
								}
							}
						}
					}
					else if ( record is ActivityTrackingRecord )
					{
						//CloneDataItems(record as ActivityTrackingRecord);
						foreach ( TrackingDataItem item in (record as ActivityTrackingRecord).Body )
						{
							using ( MemoryStream stm = new MemoryStream(0x400) )
							{
								stm.Seek(0, 0);
								bf.Serialize(stm, item.Data);
								stm.Seek(0, 0);
								item.Data = bf.Deserialize(stm);
							}
						}
					}
					else if ( record is UserTrackingRecord )
					{
						//CloneDataItems(record as UserTrackingRecord);
						foreach ( TrackingDataItem item in (record as UserTrackingRecord).Body )
						{
							using ( MemoryStream stm = new MemoryStream(0x400) )
							{
								stm.Seek(0, 0);
								bf.Serialize(stm, item.Data);
								stm.Seek(0, 0);
								item.Data = bf.Deserialize(stm);
							}
						}
					}
					WorkflowEnvironment.WorkBatch.Add(this, record);
				}
				else
				*/
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
								if ( record is WorkflowTrackingRecord )
								{
									if ( (record as WorkflowTrackingRecord).TrackingWorkflowEvent == TrackingWorkflowEvent.Created )
									{
										SendWorkflowDefinition(trn);
									}
									SendWorkflowTrackingRecord(record as WorkflowTrackingRecord, trn);
								}
								else if ( record is ActivityTrackingRecord )
								{
									SendActivityTrackingRecord(record as ActivityTrackingRecord, trn);
								}
								else if ( record is UserTrackingRecord )
								{
									SendUserTrackingRecord(record as UserTrackingRecord, trn);
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
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception(ex.Message, ex.InnerException));
			}
		}
		#endregion

		#region IPendingWork Members
		/*
		public void Commit(System.Transactions.Transaction transaction, System.Collections.ICollection items)
		{
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory(Context.Application);
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SendWorkflowDefinition(trn);
							foreach ( object record in items )
							{
								if ( record is WorkflowTrackingRecord )
								{
									SendWorkflowTrackingRecord(record as WorkflowTrackingRecord, trn);
								}
								else if ( record is ActivityTrackingRecord )
								{
									SendActivityTrackingRecord(record as ActivityTrackingRecord, trn);
								}
								else if ( record is UserTrackingRecord )
								{
									SendUserTrackingRecord(record as UserTrackingRecord, trn);
								}
							}
							trn.Commit();
						}
						catch(Exception ex)
						{
							trn.Rollback();
							SplendidError.SystemMessage(Context, "Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
							throw(new Exception(ex.Message, ex.InnerException));
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage(Context, "Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception(ex.Message, ex.InnerException));
			}
		}

		public void Complete(bool succeeded, System.Collections.ICollection items)
		{
		}

		public bool MustCommit(System.Collections.ICollection items)
		{
			return true;
		}
		*/
		#endregion

		#region Send Helpers
		private void SendEventAnnotations(Guid gEVENT_ID, string sEVENT_TYPE, TrackingAnnotationCollection arrAnnotations, IDbTransaction trn)
		{
			if ( arrAnnotations != null )
			{
				foreach ( string sANNOTATION in arrAnnotations )
				{
					Guid gANNOTATION_ID = Guid.Empty;
					SqlProcs.spWWF_EVENT_ANNOTATIONS_Insert(ref gANNOTATION_ID, gWORKFLOW_INSTANCE_INTERNAL_ID, gEVENT_ID, sEVENT_TYPE, sANNOTATION, trn);
				}
			}
		}

		private void SendDataItemAnnotations(Guid gEVENT_ID, TrackingAnnotationCollection arrAnnotations, IDbTransaction trn)
		{
			if ( arrAnnotations != null )
			{
				foreach ( string sANNOTATION in arrAnnotations )
				{
					Guid gANNOTATION_ID = Guid.Empty;
					SqlProcs.spWWF_DATA_ITEM_ANNOTATIONS_Insert(ref gANNOTATION_ID, gWORKFLOW_INSTANCE_INTERNAL_ID, gEVENT_ID, sANNOTATION, trn);
				}
			}
		}

		private void SendTrackingDataItems(Guid gEVENT_ID, string sEVENT_TYPE, IList<TrackingDataItem> items, IDbTransaction trn)
		{
			if ( items != null )
			{
				foreach ( TrackingDataItem item in items )
				{
					Guid   gITEM_ID                     = Guid.Empty;
					string sFIELD_NAME                  = item.FieldName;
					string sFIELD_TYPE_FULL_NAME        = String.Empty;
					string sFIELD_ASSEMBLY_FULL_NAME    = String.Empty;
					string sFIELD_DATA_STR              = String.Empty;
					byte[] byFIELD_DATA_BLOB            = null;
					bool   bFIELD_DATA_NON_SERIALIZABLE = false;
					if ( item.Data != null )
					{
						sFIELD_TYPE_FULL_NAME        = item.Data.GetType().FullName;
						sFIELD_ASSEMBLY_FULL_NAME    = item.Data.GetType().Assembly.FullName;
						sFIELD_DATA_STR              = item.Data.ToString();
						try
						{
							using ( MemoryStream stm = new MemoryStream() )
							{
								BinaryFormatter bf = new BinaryFormatter();
								bf.Context = new StreamingContext(StreamingContextStates.Clone);
								bf.Serialize(stm, item.Data);
								byFIELD_DATA_BLOB = stm.ToArray();
							}
						}
						catch
						{
							bFIELD_DATA_NON_SERIALIZABLE = true;
						}
					}

					SqlProcs.spWWF_TRACKING_DATA_ITEMS_Insert(ref gITEM_ID, gWORKFLOW_INSTANCE_INTERNAL_ID, gEVENT_ID, sEVENT_TYPE, sFIELD_NAME, sFIELD_TYPE_FULL_NAME, sFIELD_ASSEMBLY_FULL_NAME, sFIELD_DATA_STR, byFIELD_DATA_BLOB, bFIELD_DATA_NON_SERIALIZABLE, trn);
					SendDataItemAnnotations(gITEM_ID, item.Annotations, trn);
				}
			}
		}
		#endregion

		#region Recursive Send Helplers
		private void SendActivity(Guid gWORKFLOW_TYPE_ID, Activity activity, IDbTransaction trn)
		{
			string sQUALIFIED_NAME              = activity.QualifiedName;
			string sACTIVITY_TYPE_FULL_NAME     = activity.GetType().FullName;
			string sACTIVITY_ASSEMBLY_FULL_NAME = activity.GetType().Assembly.FullName;
			string sPARENT_QUALIFIED_NAME       = (activity.Parent == null) ? String.Empty : activity.Parent.QualifiedName;
			
			Guid gID = Guid.Empty;
			SqlProcs.spWWF_ACTIVITIES_Insert(ref gID, gWORKFLOW_TYPE_ID, sQUALIFIED_NAME, sACTIVITY_TYPE_FULL_NAME, sACTIVITY_ASSEMBLY_FULL_NAME, sPARENT_QUALIFIED_NAME, trn);
			CompositeActivity parent = activity as CompositeActivity;
			if ( parent != null )
			{
				if ( parent.Activities != null )
				{
					foreach ( Activity child in parent.Activities )
					{
						if ( child.Enabled )
							SendActivity(gWORKFLOW_TYPE_ID, child, trn);
					}
				}
			}
		}

		private void SendAddedActivityAction(Guid gWORKFLOW_INSTANCE_EVENT_ID, Activity activity, int nOrder, IDbTransaction trn)
		{
			string sQUALIFIED_NAME              = activity.QualifiedName;
			string sACTIVITY_TYPE_FULL_NAME     = activity.GetType().FullName;
			string sACTIVITY_ASSEMBLY_FULL_NAME = activity.GetType().Assembly.FullName;
			string sPARENT_QUALIFIED_NAME       = (activity.Parent == null) ? String.Empty : activity.Parent.QualifiedName;
			string sADDED_ACTIVITY_ACTION       = XomlUtils.GetXomlDocument(activity);
			int    nADDED_ACTIVITY_ORDER        = nOrder;
			
			Guid gID = Guid.Empty;
			SqlProcs.spWWF_ADDED_ACTIVITIES_Insert(ref gID, gWORKFLOW_INSTANCE_INTERNAL_ID, gWORKFLOW_INSTANCE_EVENT_ID, sACTIVITY_TYPE_FULL_NAME, sACTIVITY_ASSEMBLY_FULL_NAME, sQUALIFIED_NAME, sPARENT_QUALIFIED_NAME, sADDED_ACTIVITY_ACTION, nADDED_ACTIVITY_ORDER, trn);
			CompositeActivity parent = activity as CompositeActivity;
			if ( parent != null )
			{
				if ( parent.Activities != null )
				{
					foreach ( Activity child in parent.Activities )
					{
						SendAddedActivityAction(gWORKFLOW_INSTANCE_EVENT_ID, child, -1, trn);
					}
				}
			}
		}

		private void SendRemovedActivityAction(Guid gWORKFLOW_INSTANCE_EVENT_ID, Activity activity, int nOrder, IDbTransaction trn)
		{
			string sQUALIFIED_NAME              = activity.QualifiedName;
			string sACTIVITY_TYPE_FULL_NAME     = activity.GetType().FullName;
			string sACTIVITY_ASSEMBLY_FULL_NAME = activity.GetType().Assembly.FullName;
			string sPARENT_QUALIFIED_NAME       = (activity.Parent == null) ? String.Empty : activity.Parent.QualifiedName;
			string sREMOVED_ACTIVITY_ACTION     = XomlUtils.GetXomlDocument(activity);
			int    nREMOVED_ACTIVITY_ORDER      = nOrder;
			
			Guid gID = Guid.Empty;
			SqlProcs.spWWF_REMOVED_ACTIVITIES_Insert(ref gID, gWORKFLOW_INSTANCE_INTERNAL_ID, gWORKFLOW_INSTANCE_EVENT_ID, sQUALIFIED_NAME, sPARENT_QUALIFIED_NAME, sREMOVED_ACTIVITY_ACTION, nREMOVED_ACTIVITY_ORDER, trn);
			CompositeActivity parent = activity as CompositeActivity;
			if ( parent != null )
			{
				if ( parent.Activities != null )
				{
					foreach ( Activity child in parent.Activities )
					{
						SendRemovedActivityAction(gWORKFLOW_INSTANCE_EVENT_ID, child, -1, trn);
					}
				}
			}
		}
		#endregion

		private void SendWorkflowDefinition(IDbTransaction trn)
		{
			bool   bIS_INSTANCE_TYPE         = XomlUtils.IsXomlWorkflow(parameters.RootActivity);
			Guid   gWORKFLOW_INSTANCE_ID     = parameters.InstanceId;
			string sTYPE_FULL_NAME           = bIS_INSTANCE_TYPE ? parameters.InstanceId.ToString() : parameters.WorkflowType.FullName;
			string sASSEMBLY_FULL_NAME       = bIS_INSTANCE_TYPE ? parameters.InstanceId.ToString() : parameters.WorkflowType.Assembly.FullName;
			Guid   gCONTEXT_ID               = parameters.ContextGuid;
			Guid   gCALLER_INSTANCE_ID       = parameters.CallerInstanceId;
			Guid   gCALLER_CONTEXT_ID        = parameters.CallerContextGuid;
			Guid   gCALLER_PARENT_CONTEXT_ID = parameters.CallerParentContextGuid;
			string sWORKFLOW_DEFINITION      = XomlUtils.GetXomlDocument(parameters.RootActivity);
			
			StringBuilder sbCallPath = new StringBuilder();
			if ( parameters.CallPath != null )
			{
				foreach ( string sPath in parameters.CallPath )
				{
					if ( sbCallPath.Length > 0 )
						sbCallPath.Append(".");
					sbCallPath.Append(sPath);
				}
			}
			Guid gWORKFLOW_TYPE_ID  = Guid.Empty;
			bool bDEFINITION_EXISTS = false;
			SqlProcs.spWWF_DEFINITIONS_Insert(ref gWORKFLOW_TYPE_ID, ref bDEFINITION_EXISTS, sTYPE_FULL_NAME, sASSEMBLY_FULL_NAME, bIS_INSTANCE_TYPE, sWORKFLOW_DEFINITION, trn);
			if ( !bDEFINITION_EXISTS )
			{
				SendActivity(gWORKFLOW_TYPE_ID, parameters.RootActivity, trn);
			}

			// 06/30/2008 Paul.  Returns gWORKFLOW_INSTANCE_INTERNAL_ID. 
			SqlProcs.spWWF_INSTANCES_Insert(ref gWORKFLOW_INSTANCE_INTERNAL_ID, gWORKFLOW_INSTANCE_ID, sTYPE_FULL_NAME, sASSEMBLY_FULL_NAME, gCONTEXT_ID, gCALLER_INSTANCE_ID, sbCallPath.ToString(), gCALLER_CONTEXT_ID, gCALLER_PARENT_CONTEXT_ID, trn);
			// 09/16/2015 Paul.  Change to Debug as it is automatically not included in a release build. 
			System.Diagnostics.Debug.WriteLine("WORKFLOW_INSTANCE_ID          = " + gWORKFLOW_INSTANCE_ID.ToString());
			System.Diagnostics.Debug.WriteLine("WORKFLOW_INSTANCE_INTERNAL_ID = " + gWORKFLOW_INSTANCE_INTERNAL_ID.ToString());
		}

		private void SendActivityTrackingRecord(ActivityTrackingRecord record, IDbTransaction trn)
		{
			string   sEVENT_TYPE                    = "Activity"               ;
			Guid     gID                            = Guid.Empty               ;
			Int32    nEVENT_ORDER                   = record.EventOrder        ;
			Guid     gACTIVITY_INSTANCE_ID          = Guid.Empty               ;
			string   sQUALIFIED_NAME                = record.QualifiedName     ;
			Guid     gCONTEXT_ID                    = record.ContextGuid       ;
			Guid     gPARENT_CONTEXT_ID             = record.ParentContextGuid ;
			DateTime dtEVENT_DATE_TIME              = record.EventDateTime     ;
			string   sEXECUTION_STATUS              = Enum.GetName(typeof(ActivityExecutionStatus), record.ExecutionStatus);

			SqlProcs.spWWF_ACTIVITY_STATUS_EVENTS_Insert(ref gID, gWORKFLOW_INSTANCE_INTERNAL_ID, ref gACTIVITY_INSTANCE_ID, sQUALIFIED_NAME, gCONTEXT_ID, gPARENT_CONTEXT_ID, nEVENT_ORDER, dtEVENT_DATE_TIME, sEXECUTION_STATUS, trn);
			SendEventAnnotations (gID, sEVENT_TYPE, record.Annotations, trn);
			SendTrackingDataItems(gID, sEVENT_TYPE, record.Body       , trn);
		}

		private void SendWorkflowTrackingRecord(WorkflowTrackingRecord record, IDbTransaction trn)
		{
			string   sEVENT_TYPE                    = "Workflow"               ;
			Guid     gID                            = Guid.Empty               ;
			string   sTRACKING_WORKFLOW_EVENT       = Enum.GetName(typeof(TrackingWorkflowEvent), record.TrackingWorkflowEvent);
			Int32    nEVENT_ORDER                   = record.EventOrder        ;
			DateTime dtEVENT_DATE_TIME              = record.EventDateTime     ;
			string   sEVENT_ARG_TYPE_FULL_NAME      = String.Empty;
			string   sEVENT_ARG_ASSEMBLY_FULL_NAME  = String.Empty;
			byte[]   byEVENT_ARG                    = null                     ;
			string   sDESCRIPTION                   = String.Empty;

			BinaryFormatter bf = new BinaryFormatter();
			bf.Context = new StreamingContext(StreamingContextStates.Clone);
			if ( record.EventArgs != null )
			{
				sEVENT_ARG_TYPE_FULL_NAME      = record.EventArgs.GetType().FullName;
				sEVENT_ARG_ASSEMBLY_FULL_NAME  = record.EventArgs.GetType().Assembly.FullName;
				try
				{
					if ( record.TrackingWorkflowEvent == TrackingWorkflowEvent.Exception )
					{
						TrackingWorkflowExceptionEventArgs ex = record.EventArgs as TrackingWorkflowExceptionEventArgs;
						sDESCRIPTION = Utils.ExpandException(ex.Exception);
					}
					else if ( record.TrackingWorkflowEvent == TrackingWorkflowEvent.Terminated )
					{
						TrackingWorkflowTerminatedEventArgs ex = record.EventArgs as TrackingWorkflowTerminatedEventArgs;
						sDESCRIPTION = Utils.ExpandException(ex.Exception);
					}
					using ( MemoryStream stm = new MemoryStream() )
					{
						bf.Context = new StreamingContext(StreamingContextStates.Clone);
						bf.Serialize(stm, record.EventArgs);
						byEVENT_ARG = stm.ToArray();
					}
				}
				catch
				{
					// 06/29/2008 Paul.  If the event args are not serializable, then we may need to get the exception details. 
					Exception eWorkflow = null;
					switch ( record.TrackingWorkflowEvent )
					{
						case TrackingWorkflowEvent.Terminated:
							eWorkflow = (record.EventArgs as TrackingWorkflowTerminatedEventArgs).Exception;
							break;

						case TrackingWorkflowEvent.Exception:
							eWorkflow = (record.EventArgs as TrackingWorkflowExceptionEventArgs).Exception;
							break;
					}

					if ( eWorkflow != null )
					{
						try
						{
							using ( MemoryStream stm = new MemoryStream() )
							{
								bf.Serialize(stm, eWorkflow);
								byEVENT_ARG = stm.ToArray();
							}
						}
						catch
						{
						}
					}
				}
			}

			SqlProcs.spWWF_INSTANCE_EVENTS_Insert(ref gID, gWORKFLOW_INSTANCE_INTERNAL_ID, sTRACKING_WORKFLOW_EVENT, nEVENT_ORDER, dtEVENT_DATE_TIME, sEVENT_ARG_TYPE_FULL_NAME, sEVENT_ARG_ASSEMBLY_FULL_NAME, byEVENT_ARG, sDESCRIPTION, trn);
			SendEventAnnotations(gID, sEVENT_TYPE, record.Annotations, trn);
			if ( record.TrackingWorkflowEvent == TrackingWorkflowEvent.Changed )
			{
				if ( record.EventArgs != null && record.EventArgs is TrackingWorkflowChangedEventArgs )
				{
					TrackingWorkflowChangedEventArgs twcea = record.EventArgs as TrackingWorkflowChangedEventArgs;
					for ( int nOrder = 0; nOrder < twcea.Changes.Count; nOrder++ )
					{
						WorkflowChangeAction action = twcea.Changes[nOrder];
						if ( action is AddedActivityAction )
						{
							Activity activity = (action as AddedActivityAction).AddedActivity;
							SendAddedActivityAction(gID, activity, nOrder, trn);
						}
						else if ( action is RemovedActivityAction )
						{
							Activity activity = (action as RemovedActivityAction).OriginalRemovedActivity;
							SendRemovedActivityAction(gID, activity, nOrder, trn);
						}
					}
				}
			}
		}

		private void SendUserTrackingRecord(UserTrackingRecord record, IDbTransaction trn)
		{
			string   sEVENT_TYPE                    = "User"                   ;
			Guid     gID                            = Guid.Empty               ;
			Int32    nEVENT_ORDER                   = record.EventOrder        ;
			Guid     gACTIVITY_INSTANCE_ID          = Guid.Empty               ;
			string   sQUALIFIED_NAME                = record.QualifiedName     ;
			Guid     gCONTEXT_ID                    = record.ContextGuid       ;
			Guid     gPARENT_CONTEXT_ID             = record.ParentContextGuid ;
			DateTime dtEVENT_DATE_TIME              = record.EventDateTime     ;
			string   sUSER_DATA_KEY                 = record.UserDataKey       ;
			string   sUSER_DATA_TYPE_FULL_NAME      = String.Empty             ;
			string   sUSER_DATA_ASSEMBLY_FULL_NAME  = String.Empty             ;
			string   sUSER_DATA_STR                 = String.Empty             ;
			byte[]   byUSER_DATA_BLOB               = null                     ;
			bool     bUSER_DATA_NON_SERIALIZABLE    = false                    ;
			string   sDESCRIPTION                   = String.Empty             ;

			// 06/28/2008 Paul.  Attempt to serialize the user data. 
			if ( record.UserData != null )
			{
				sUSER_DATA_TYPE_FULL_NAME      = record.UserData.GetType().FullName;
				sUSER_DATA_ASSEMBLY_FULL_NAME  = record.UserData.GetType().Assembly.FullName;
				sUSER_DATA_STR                 = record.UserData.ToString()  ;
				try
				{
					using ( MemoryStream stm = new MemoryStream() )
					{
						BinaryFormatter bf = new BinaryFormatter();
						bf.Context = new StreamingContext(StreamingContextStates.Clone);
						bf.Serialize(stm, record.UserData);
						byUSER_DATA_BLOB = stm.ToArray();
					}
				}
				catch
				{
					bUSER_DATA_NON_SERIALIZABLE = true;
				}
			}
			SqlProcs.spWWF_USER_EVENTS_Insert(ref gID, gWORKFLOW_INSTANCE_INTERNAL_ID, ref gACTIVITY_INSTANCE_ID, sQUALIFIED_NAME, gCONTEXT_ID, gPARENT_CONTEXT_ID, nEVENT_ORDER, dtEVENT_DATE_TIME, sUSER_DATA_KEY, sUSER_DATA_TYPE_FULL_NAME, sUSER_DATA_ASSEMBLY_FULL_NAME, sUSER_DATA_STR, byUSER_DATA_BLOB, bUSER_DATA_NON_SERIALIZABLE, sDESCRIPTION, trn);
			SendEventAnnotations (gID, sEVENT_TYPE, record.Annotations, trn);
			SendTrackingDataItems(gID, sEVENT_TYPE, record.Body       , trn);
		}

	}
}
