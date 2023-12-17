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
using System.Xml;
using System.Web;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Activities.Tracking;
using System.Runtime.Serialization;
using System.Diagnostics;
// https://github.com/dmitrykolchev/NetDataContractSerializer
using Compat.Runtime.Serialization;

namespace SplendidCRM
{
	// 10/15/2023 Paul.  Use WF4 to run WF3 migrated code. 
	public class SplendidTrackingParticipantWF3 : TrackingParticipant
	{
		private DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;

		const string itemsTag      = "items";
		const string itemTag       = "item";
		const string nameAttribute = "name";
		const string typeAttribute = "type";

		private NetDataContractSerializer variableSerializer;

		public SplendidTrackingParticipantWF3(Sql Sql, SqlProcs SqlProcs)
		{
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.TrackingProfile = new TrackingProfile
			{
				Queries =
				{ new ActivityStateQuery      { States = { "*" } }
				, new WorkflowInstanceQuery   { States = { "*" } }
				, new BookmarkResumptionQuery { Name   = "*" }
				, new CustomTrackingQuery     { ActivityName = "*", Name   = "*" }
				, new ActivityScheduledQuery  { ActivityName = "*", ChildActivityName = "*" }
				, new CancelRequestedQuery    { ActivityName = "*", ChildActivityName = "*" }
				, new FaultPropagationQuery   { FaultHandlerActivityName = "*", FaultSourceActivityName = "*" }
				}
			};
		}

		// 09/03/2016 Paul.  We do not need to capture the type name for CSharpValue<Boolean> as it is not useful and there are lots of them. 
		// Microsoft.CSharp.Activities.CSharpValue`1[[System.Boolean, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089]]
		private string CleansedTypeName(ActivityInfo activity)
		{
			string sTypeName = String.Empty;
			if ( activity != null )
			{
				if ( activity.Name != "CSharpValue<Boolean>" && activity.Name != "Delay" && activity.Name != "Assign" && activity.Name != "Sequence" && activity.Name != "Pick" )
					sTypeName = activity.TypeName;
			}
			return sTypeName;
		}

		protected override void Track(TrackingRecord record, TimeSpan timeout)
		{
			try
			{
				// https://mohammedatef.wordpress.com/2010/09/26/workflow-foundation-4-0-tracking/
				if ( record is WorkflowInstanceRecord )
				{
					WorkflowInstanceRecord workflowInstanceRecord = record as WorkflowInstanceRecord;
					// WorkflowInstanceStates: Aborted, Canceled, Completed, Deleted, Idle, Persisted, Resumed, Started, Suspended, Terminated, UnhandledException, Unloaded, Suspended, Updated, UpdateFailed. 
					//Debug.WriteLine("SplendidTrackingParticipant.Track: Activity InstanceID: " + workflowInstanceRecord.InstanceId + " : WorkflowInstanceState: " + workflowInstanceRecord.State);
					string sAnnotations = PrepareAnnotations(record.Annotations);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								/*
								SqlProcs.spWF4_TRACKING_WORKFLOW_INSTANCE_Insert
									(  record.InstanceId        
									,  record.EventTime         
									,  record.RecordNumber      
									,  sAnnotations             
									,  workflowInstanceRecord.ActivityDefinitionId
									,  workflowInstanceRecord.State               
									, (workflowInstanceRecord.WorkflowDefinitionIdentity != null ? workflowInstanceRecord.WorkflowDefinitionIdentity.Name    : String.Empty)
									, (workflowInstanceRecord.WorkflowDefinitionIdentity != null ? workflowInstanceRecord.WorkflowDefinitionIdentity.Package : String.Empty)
									, (workflowInstanceRecord.WorkflowDefinitionIdentity != null && workflowInstanceRecord.WorkflowDefinitionIdentity.Version != null ? workflowInstanceRecord.WorkflowDefinitionIdentity.Version.ToString() : String.Empty)
									, trn
									);
								*/
								Guid     gID                            = Guid.Empty                  ;
								Guid     gWORKFLOW_INSTANCE_INTERNAL_ID = record.InstanceId           ;
								string   sTRACKING_WORKFLOW_EVENT       = workflowInstanceRecord.State;
								int      nEVENT_ORDER                   = (int)record.RecordNumber    ;
								// 10/29/2023 Paul.  WF4 is using UTC time instead of local time. 
								DateTime dtEVENT_DATE_TIME              = record.EventTime.ToLocalTime();;
								string   sEVENT_ARG_TYPE_FULL_NAME      = String.Empty                ;
								string   sEVENT_ARG_ASSEMBLY_FULL_NAME  = String.Empty                ;
								byte[]   byEVENT_ARG                    = null                        ;
								string   sDESCRIPTION                   = sAnnotations                ;
								SqlProcs.spWWF_INSTANCE_EVENTS_Insert(ref gID, gWORKFLOW_INSTANCE_INTERNAL_ID, sTRACKING_WORKFLOW_EVENT, nEVENT_ORDER, dtEVENT_DATE_TIME, sEVENT_ARG_TYPE_FULL_NAME, sEVENT_ARG_ASSEMBLY_FULL_NAME, byEVENT_ARG, sDESCRIPTION, trn);
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
				else if ( record is ActivityStateRecord )
				{
					ActivityStateRecord activityStateRecord = record as ActivityStateRecord;
					// ActivityStates: Canceled, Closed, Executing, Faulted. 
					//Debug.WriteLine("SplendidTrackingParticipantWF3.Track: Activity DisplayName: " + activityStateRecord.Activity.Name + " : ActivityState: " + activityStateRecord.State);
				
					IDictionary<String, object> variables = activityStateRecord.Variables;
					if ( variables.Count > 0 )
					{
						Debug.WriteLine("\n\tVariables:");
						foreach ( KeyValuePair<string, object> variable in variables )
						{
							Debug.WriteLine(String.Format("\t\tName: {0} Value: {1}", variable.Key, variable.Value));
						}
					}
				
					IDictionary<String, object> arguments = activityStateRecord.Arguments;
					if ( arguments.Count > 0 )
					{
						Debug.WriteLine("\n\tArguments:");
						foreach ( KeyValuePair<string, object> argument in arguments )
						{
							Debug.WriteLine(String.Format("\t\tName: {0} Value: {1}", argument.Key, argument.Value));
						}
					}
					string sAnnotations        = PrepareAnnotations(record.Annotations);
					string sVariables          = PrepareDictionary(activityStateRecord.Variables);
					string sArguments          = PrepareDictionary(activityStateRecord.Arguments);
					string sActivityId         = String.Empty;
					string sActivityInstanceId = String.Empty;
					string sActivityName       = String.Empty;
					string sActivityTypeName   = String.Empty;
					if ( activityStateRecord.Activity != null )
					{
						sActivityId         = activityStateRecord.Activity.Id        ;
						sActivityInstanceId = activityStateRecord.Activity.InstanceId;
						sActivityName       = activityStateRecord.Activity.Name      ;
						// 08/30/2016 Paul.  Don't know how to get the ExpressionText from the ActivityInfo field. 
						sActivityTypeName   = CleansedTypeName(activityStateRecord.Activity);
					}
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								/*
								SqlProcs.spWF4_TRACKING_ACTIVITY_STATE_Insert
									( record.InstanceId        
									, record.EventTime         
									, record.RecordNumber      
									, sAnnotations             
									, activityStateRecord.State
									, sVariables               
									, sArguments               
									, sActivityId              
									, sActivityInstanceId      
									, sActivityName            
									, sActivityTypeName        
									, trn
									);
								*/
								Guid     gID                            = Guid.Empty               ;
								Guid     gWORKFLOW_INSTANCE_INTERNAL_ID = record.InstanceId        ;
								Int32    nEVENT_ORDER                   = (int)record.RecordNumber ;
								Guid     gACTIVITY_INSTANCE_ID          = record.InstanceId        ;
								string   sQUALIFIED_NAME                = sActivityName            ;
								Guid     gCONTEXT_ID                    = record.InstanceId        ;
								Guid     gPARENT_CONTEXT_ID             = Guid.Empty               ;
								DateTime dtEVENT_DATE_TIME              = record.EventTime         ;
								string   sEXECUTION_STATUS              = activityStateRecord.State;

								SqlProcs.spWWF_ACTIVITY_STATUS_EVENTS_Insert(ref gID, gWORKFLOW_INSTANCE_INTERNAL_ID, ref gACTIVITY_INSTANCE_ID, sQUALIFIED_NAME, gCONTEXT_ID, gPARENT_CONTEXT_ID, nEVENT_ORDER, dtEVENT_DATE_TIME, sEXECUTION_STATUS, trn);
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
				else if ( record is BookmarkResumptionRecord )
				{
					BookmarkResumptionRecord bookmarkRecord = record as BookmarkResumptionRecord;
					//Debug.WriteLine("SplendidTrackingParticipantWF3.Track: BookmarkName " + bookmarkRecord.BookmarkName);
				
					string sAnnotations = PrepareAnnotations(record.Annotations);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spWF4_TRACKING_BOOKMARKS_Insert
									(  record.InstanceId           
									,  record.EventTime            
									,  record.RecordNumber         
									,  sAnnotations                
									,  bookmarkRecord.BookmarkName 
									,  bookmarkRecord.BookmarkScope
									, (bookmarkRecord.Owner != null ? bookmarkRecord.Owner.Id         : String.Empty)
									, (bookmarkRecord.Owner != null ? bookmarkRecord.Owner.InstanceId : String.Empty)
									, (bookmarkRecord.Owner != null ? bookmarkRecord.Owner.Name       : String.Empty)
									, (bookmarkRecord.Owner != null ? CleansedTypeName(bookmarkRecord.Owner) : String.Empty)
									, null  // bookmarkRecord.Payload
									, trn
									);
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
				else if ( record is CustomTrackingRecord )
				{
					CustomTrackingRecord customTrackingRecord = record as CustomTrackingRecord;
					//Debug.WriteLine("SplendidTrackingParticipantWF3.Track: CustomTrackingName " + customTrackingRecord.Name);
					IDictionary<String, object> dataRecords = customTrackingRecord.Data;
					if ( dataRecords.Count > 0 )
					{
						Debug.WriteLine("\n\tData:");
						foreach ( KeyValuePair<string, object> data in dataRecords )
						{
							Debug.WriteLine(String.Format("\t\tName: {0} Value: {1}", data.Key, data.Value));
						}
					}
					string sAnnotations = PrepareAnnotations(record.Annotations);
					string sDataRecords = PrepareDictionary(customTrackingRecord.Data);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spWF4_TRACKING_CUSTOM_Insert
									(  record.InstanceId        
									,  record.EventTime         
									,  record.RecordNumber      
									,  sAnnotations             
									,  customTrackingRecord.Name
									,  sDataRecords             
									, (customTrackingRecord.Activity != null ? customTrackingRecord.Activity.Id         : String.Empty)
									, (customTrackingRecord.Activity != null ? customTrackingRecord.Activity.InstanceId : String.Empty)
									, (customTrackingRecord.Activity != null ? customTrackingRecord.Activity.Name       : String.Empty)
									, (customTrackingRecord.Activity != null ? CleansedTypeName(customTrackingRecord.Activity) : String.Empty)
									, trn
									);
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
				else if (record is ActivityScheduledRecord)
				{
					// 09/03/2016 Paul.  The scheduled record is not useful. 
					/*
					ActivityScheduledRecord activityScheduledRecord = record as ActivityScheduledRecord;
					string sAnnotations = PrepareAnnotations(record.Annotations);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spWF4_TRACKING_ACTIVITY_SCHEDULE_Insert
									(  record.InstanceId    
									,  record.EventTime     
									,  record.RecordNumber  
									,  sAnnotations         
									, (activityScheduledRecord.Activity != null ? activityScheduledRecord.Activity.Id         : String.Empty)
									, (activityScheduledRecord.Activity != null ? activityScheduledRecord.Activity.InstanceId : String.Empty)
									, (activityScheduledRecord.Activity != null ? activityScheduledRecord.Activity.Name       : String.Empty)
									, (activityScheduledRecord.Activity != null ? CleansedTypeName(activityScheduledRecord.Activity) : String.Empty)
									, (activityScheduledRecord.Child    != null ? activityScheduledRecord.Child.Id            : String.Empty)
									, (activityScheduledRecord.Child    != null ? activityScheduledRecord.Child.InstanceId    : String.Empty)
									, (activityScheduledRecord.Child    != null ? activityScheduledRecord.Child.Name          : String.Empty)
									, (activityScheduledRecord.Child    != null ? CleansedTypeName(activityScheduledRecord.Child) : String.Empty)
									, trn
									);
								trn.Commit();
							}
							catch(Exception ex)
							{
								trn.Rollback();
								throw(new Exception(ex.Message, ex.InnerException));
							}
						}
					}
					*/
				}
				else if (record is CancelRequestedRecord)
				{
					CancelRequestedRecord cancelRequestedRecord = record as CancelRequestedRecord;
					string sAnnotations = PrepareAnnotations(record.Annotations);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spWF4_TRACKING_CANCEL_REQUESTED_Insert
									(  record.InstanceId    
									,  record.EventTime     
									,  record.RecordNumber  
									,  sAnnotations         
									, (cancelRequestedRecord.Activity != null ? cancelRequestedRecord.Activity.Id         : String.Empty)
									, (cancelRequestedRecord.Activity != null ? cancelRequestedRecord.Activity.InstanceId : String.Empty)
									, (cancelRequestedRecord.Activity != null ? cancelRequestedRecord.Activity.Name       : String.Empty)
									, (cancelRequestedRecord.Activity != null ? CleansedTypeName(cancelRequestedRecord.Activity) : String.Empty)
									, (cancelRequestedRecord.Child    != null ? cancelRequestedRecord.Child.Id            : String.Empty)
									, (cancelRequestedRecord.Child    != null ? cancelRequestedRecord.Child.InstanceId    : String.Empty)
									, (cancelRequestedRecord.Child    != null ? cancelRequestedRecord.Child.Name          : String.Empty)
									, (cancelRequestedRecord.Child    != null ? CleansedTypeName(cancelRequestedRecord.Child) : String.Empty)
									, trn
									);
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
				else if (record is FaultPropagationRecord)
				{
					FaultPropagationRecord faultPropagationRecord = record as FaultPropagationRecord;
					string sAnnotations = PrepareAnnotations(record.Annotations);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spWF4_TRACKING_FAULT_PROPAGATION_Insert
									(  faultPropagationRecord.InstanceId   
									,  faultPropagationRecord.EventTime    
									,  faultPropagationRecord.RecordNumber 
									,  sAnnotations                        
									, (faultPropagationRecord.Fault        != null ? faultPropagationRecord.Fault.Message           : String.Empty)
									, (faultPropagationRecord.Fault        != null ? faultPropagationRecord.Fault.StackTrace        : String.Empty)
									,  faultPropagationRecord.IsFaultSource
									, (faultPropagationRecord.FaultHandler != null ? faultPropagationRecord.FaultHandler.Id         : String.Empty)
									, (faultPropagationRecord.FaultHandler != null ? faultPropagationRecord.FaultHandler.InstanceId : String.Empty)
									, (faultPropagationRecord.FaultHandler != null ? faultPropagationRecord.FaultHandler.Name       : String.Empty)
									, (faultPropagationRecord.FaultHandler != null ? CleansedTypeName(faultPropagationRecord.FaultHandler) : String.Empty)
									, (faultPropagationRecord.FaultSource  != null ? faultPropagationRecord.FaultSource.Id          : String.Empty)
									, (faultPropagationRecord.FaultSource  != null ? faultPropagationRecord.FaultSource.InstanceId  : String.Empty)
									, (faultPropagationRecord.FaultSource  != null ? faultPropagationRecord.FaultSource.Name        : String.Empty)
									, (faultPropagationRecord.FaultSource  != null ? CleansedTypeName(faultPropagationRecord.FaultSource) : String.Empty)
									, trn
									);
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
				Debug.WriteLine(ex.Message);
			}
		}

		// 06/20/2016 Paul.  From EtwTrackingParticipant.cs 
		private string PrepareAnnotations(IDictionary<string, string> data)
		{
			string stringTypeName = typeof(string).FullName;

			StringBuilder builder = new StringBuilder();
			XmlWriterSettings settings = new XmlWriterSettings()
			{
				OmitXmlDeclaration = true
			};
			using (XmlWriter writer = XmlWriter.Create(builder, settings))
			{
				writer.WriteStartElement(itemsTag);
				if ( data != null )
				{
					foreach (KeyValuePair<string, string> item in data)
					{
						writer.WriteStartElement(itemTag);
						writer.WriteAttributeString(nameAttribute, item.Key);
						writer.WriteAttributeString(typeAttribute, stringTypeName);
						if ( item.Value == null )
						{
							writer.WriteValue(string.Empty);
						}
						else
						{
							writer.WriteValue(item.Value);
						}
						writer.WriteEndElement();
					}
				}
				writer.WriteEndElement();
				writer.Flush();
				return builder.ToString();
			}
		}

		// 06/20/2016 Paul.  From EtwTrackingParticipant.cs 
		private string PrepareDictionary(IDictionary<string, object> data)
		{
			StringBuilder builder = new StringBuilder();
			XmlWriterSettings settings = new XmlWriterSettings()
			{
				OmitXmlDeclaration = true
			};
			using (XmlWriter writer = XmlWriter.Create(builder, settings))
			{
				writer.WriteStartElement(itemsTag);
				if ( data != null )
				{
					foreach (KeyValuePair<string, object> item in data)
					{
						writer.WriteStartElement(itemTag);
						writer.WriteAttributeString(nameAttribute, item.Key);
						if ( item.Value == null )
						{
							writer.WriteAttributeString(typeAttribute, string.Empty);
							writer.WriteValue(string.Empty);
						}
						else
						{
							Type valueType = item.Value.GetType();
							writer.WriteAttributeString(typeAttribute, valueType.FullName);

							if ( valueType == typeof(int)    || valueType == typeof(float) || valueType == typeof(double) ||
							     valueType == typeof(long)   || valueType == typeof(bool)  || valueType == typeof(uint)   ||
							     valueType == typeof(ushort) || valueType == typeof(short) || valueType == typeof(ulong)  ||
							     valueType == typeof(string) || valueType == typeof(DateTimeOffset))
							{
								writer.WriteValue(item.Value);
							}
							else if ( valueType == typeof(Guid) )
							{
								Guid value = (Guid)item.Value;
								writer.WriteValue(value.ToString());
							}
							else if ( valueType == typeof(DateTime) )
							{
								DateTime date = ((DateTime)item.Value).ToUniversalTime();
								writer.WriteValue(date);
							}
							else
							{
								if ( this.variableSerializer == null )
								{
									this.variableSerializer = new NetDataContractSerializer();
								}
								this.variableSerializer.WriteObject(writer, item.Value);
							}
						}
						writer.WriteEndElement();
					}
				}
				writer.WriteEndElement();
				writer.Flush();
				return builder.ToString();
			}
		}
	}
}
