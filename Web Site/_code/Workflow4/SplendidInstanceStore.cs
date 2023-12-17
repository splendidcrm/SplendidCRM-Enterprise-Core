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
using System.Xml.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using System.Activities.DurableInstancing;
using System.Runtime;
using System.Activities.Runtime.DurableInstancing;
using System.Activities.Hosting;
using System.Activities;

namespace SplendidCRM
{
	public class SplendidInstanceStore : InstanceStore
	{
		private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;

		// 06/19/2016-2023 Paul.  We do not need to manage multiple instance stores, so use a single static ID. 
		private static Guid    gInstanceOwnerID = new Guid("5DF2D56E-7204-4CFE-91EA-3AF3C7419B17");

		public SplendidInstanceStore(Sql Sql, SqlProcs SqlProcs)
		{
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
		}

		protected override bool TryCommand(InstancePersistenceContext context, InstancePersistenceCommand command, TimeSpan timeout)
		{
			System.Diagnostics.Debug.WriteLine("SplendidInstanceStore.TryCommand: " + command.GetType().Name);
			return EndTryCommand(BeginTryCommand(context, command, timeout, null, null));
		}

		public static int NextEvents()
		{
			// select * from [System.Activities.DurableInstancing].InstancesTable [it] where [it].PendingTimer <= @yourDateTime
			int nEvents = 0;
			DbProviderFactories  DbProviderFactories = new DbProviderFactories();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL ;
				sSQL = "select count(*)                     " + ControlChars.CrLf
				     + "  from vwWF4_INSTANCES_RUNNABLE_Next" + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					nEvents = Sql.ToInteger(cmd.ExecuteScalar());
				}
			}
			return nEvents;
		}

		public DataTable BlockingBookmarks()
		{
			DataTable dt = new DataTable();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL ;
				sSQL = "select *                       " + ControlChars.CrLf
				     + "  from vwWF4_INSTANCES_Blocking" + ControlChars.CrLf
				     + " order by DATE_MODIFIED_UTC    " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						da.Fill(dt);
					}
				}
			}
			return dt;
		}

		public static string ToXaml(System.Activities.Activity activity)
		{
			StringBuilder sbXaml = new StringBuilder();
			using (XmlWriter xmlWriter = XmlWriter.Create(sbXaml, new XmlWriterSettings { Indent = true, OmitXmlDeclaration = true }) )
			{
				using ( System.Xaml.XamlWriter xamlWriter = new System.Xaml.XamlXmlWriter(xmlWriter, new System.Xaml.XamlSchemaContext()) )
				{
					using ( System.Xaml.XamlWriter xamlServicesWriter = System.Activities.XamlIntegration.ActivityXamlServices.CreateBuilderWriter(xamlWriter) )
					{
						System.Activities.ActivityBuilder activityBuilder = new System.Activities.ActivityBuilder 
						{
							Implementation = activity
						};
						System.Xaml.XamlServices.Save(xamlServicesWriter, activityBuilder);
					}
				}
			}
			return sbXaml.ToString();
		}

		public static void GetIdentityMetadata(InstancePersistenceCommand command, ref string sName, ref string sPackage, ref string sVersion, ref string sXAML, ref Guid gXAML_HASH, ref Guid gCRM_ID)
		{
			sName      = String.Empty;
			sPackage   = String.Empty;
			sVersion   = String.Empty;
			sXAML      = String.Empty;
			gXAML_HASH = Guid.Empty;
			gCRM_ID    = Guid.Empty;
			if ( command is CreateWorkflowOwnerWithIdentityCommand )
			{
				InstanceValue instanceValue = null;
				CreateWorkflowOwnerWithIdentityCommand ownerCommand = command as CreateWorkflowOwnerWithIdentityCommand;
				if ( ownerCommand.InstanceOwnerMetadata.TryGetValue(Workflow45Namespace.DefinitionXAML, out instanceValue) )
				{
					if ( instanceValue.Value != null )
					{
						sXAML = instanceValue.Value as String;
					}
				}
				instanceValue = null;
				if ( ownerCommand.InstanceOwnerMetadata.TryGetValue(Workflow45Namespace.BusinessProcessID, out instanceValue) )
				{
					if ( instanceValue.Value != null )
					{
						gCRM_ID = Sql.ToGuid(instanceValue.Value);
					}
				}
				if ( Sql.IsEmptyString(sXAML) )
				{
					instanceValue = null;
					if ( ownerCommand.InstanceOwnerMetadata.TryGetValue(Workflow45Namespace.DefinitionIdentity, out instanceValue))
					{
						if ( !instanceValue.IsDeletedValue && instanceValue.Value != null && instanceValue.Value is SplendidWorkflowIdentity )
						{
							WorkflowIdentity identity = instanceValue.Value as SplendidWorkflowIdentity;
							sName    = (identity as SplendidWorkflowIdentity).Name   ;
							sPackage = (identity as SplendidWorkflowIdentity).Package;
							sVersion = (identity as SplendidWorkflowIdentity).Version.ToString();
							sXAML    = (identity as SplendidWorkflowIdentity).XAML   ;
							gCRM_ID  = (identity as SplendidWorkflowIdentity).CRM_ID ;
						}
					}
					if ( Sql.IsEmptyString(sXAML) )
					{
						InstanceValue instanceValueIdentityCollection = null;
						if ( ownerCommand.InstanceOwnerMetadata.TryGetValue(Workflow45Namespace.DefinitionIdentities, out instanceValueIdentityCollection) )
						{
							if ( instanceValueIdentityCollection.Value != null && instanceValueIdentityCollection.Value is IList<WorkflowIdentity> )
							{
								IList<WorkflowIdentity> identityCollection = instanceValueIdentityCollection.Value as IList<WorkflowIdentity>;
								foreach ( WorkflowIdentity identity in identityCollection )
								{
									if ( identity is SplendidWorkflowIdentity )
									{
										sName    = (identity as SplendidWorkflowIdentity).Name   ;
										sPackage = (identity as SplendidWorkflowIdentity).Package;
										sVersion = (identity as SplendidWorkflowIdentity).Version.ToString();
										sXAML    = (identity as SplendidWorkflowIdentity).XAML   ;
										gCRM_ID  = (identity as SplendidWorkflowIdentity).CRM_ID ;
										break;
									}
								}
							}
						}
					}
				}
			}
			else if ( command is SaveWorkflowCommand )
			{
				InstanceValue instanceValue = null;
				SaveWorkflowCommand saveCommand = command as SaveWorkflowCommand;
				if ( saveCommand.InstanceMetadataChanges.TryGetValue(Workflow45Namespace.DefinitionXAML, out instanceValue) )
				{
					if ( instanceValue.Value != null )
					{
						sXAML = instanceValue.Value as String;
					}
				}
				instanceValue = null;
				if ( saveCommand.InstanceMetadataChanges.TryGetValue(Workflow45Namespace.BusinessProcessID, out instanceValue) )
				{
					if ( instanceValue.Value != null )
					{
						gCRM_ID = Sql.ToGuid(instanceValue.Value);
					}
				}
				if ( Sql.IsEmptyString(sXAML) )
				{
					instanceValue = null;
					if ( saveCommand.InstanceMetadataChanges.TryGetValue(Workflow45Namespace.DefinitionIdentity, out instanceValue))
					{
						if ( !instanceValue.IsDeletedValue && instanceValue.Value != null && instanceValue.Value is SplendidWorkflowIdentity )
						{
							WorkflowIdentity identity = instanceValue.Value as SplendidWorkflowIdentity;
							sName    = (identity as SplendidWorkflowIdentity).Name   ;
							sPackage = (identity as SplendidWorkflowIdentity).Package;
							sVersion = (identity as SplendidWorkflowIdentity).Version.ToString();
							sXAML    = (identity as SplendidWorkflowIdentity).XAML   ;
							gCRM_ID  = (identity as SplendidWorkflowIdentity).CRM_ID ;
						}
					}
					if ( Sql.IsEmptyString(sXAML) )
					{
						InstanceValue instanceValueIdentityCollection = null;
						if ( saveCommand.InstanceMetadataChanges.TryGetValue(Workflow45Namespace.DefinitionIdentities, out instanceValueIdentityCollection) )
						{
							if ( instanceValueIdentityCollection.Value != null && instanceValueIdentityCollection.Value is IList<WorkflowIdentity> )
							{
								IList<WorkflowIdentity> identityCollection = instanceValueIdentityCollection.Value as IList<WorkflowIdentity>;
								foreach ( WorkflowIdentity identity in identityCollection )
								{
									if ( identity is SplendidWorkflowIdentity )
									{
										sName    = (identity as SplendidWorkflowIdentity).Name   ;
										sPackage = (identity as SplendidWorkflowIdentity).Package;
										sVersion = (identity as SplendidWorkflowIdentity).Version.ToString();
										sXAML    = (identity as SplendidWorkflowIdentity).XAML   ;
										gCRM_ID  = (identity as SplendidWorkflowIdentity).CRM_ID ;
										break;
									}
								}
							}
						}
					}
				}
			}
			if ( !Sql.IsEmptyString(sXAML) )
			{
				byte[] byXAML = Encoding.Unicode.GetBytes(sXAML);
				gXAML_HASH = new Guid(Workflow4Utils.ComputeHash(byXAML));
			}
		}

		protected override IAsyncResult BeginTryCommand(InstancePersistenceContext context, InstancePersistenceCommand command, TimeSpan timeout, AsyncCallback callback, object state)
		{
			IDictionary<XName, InstanceValue> instanceStateData = null;
			if ( command is CreateWorkflowOwnerCommand )
			{
				//context.BindInstanceOwner(SplendidInstanceStore.gInstanceOwnerID, Guid.NewGuid());
				throw(new Exception("Must use CreateWorkflowOwnerWithIdentityCommand and must include XAML."));
			}
			else if ( command is CreateWorkflowOwnerWithIdentityCommand )
			{
				string sDefinitionName           = String.Empty;
				string sDefinitionPackage        = String.Empty;
				string sDefinitionVersion        = String.Empty;
				string sDefinitionXAML           = String.Empty;
				Guid   gDEFINITION_IDENTITY_HASH = Guid.Empty;
				Guid   gSURROGATE_IDENTITY_ID    = Guid.Empty;  // This is the CRM_ID. 
				GetIdentityMetadata(command, ref sDefinitionName, ref sDefinitionPackage, ref sDefinitionVersion, ref sDefinitionXAML, ref gDEFINITION_IDENTITY_HASH, ref gSURROGATE_IDENTITY_ID);
				if ( Sql.IsEmptyString(sDefinitionXAML) )
					throw(new Exception("Must provide XAML with Identity."));
				
				//  06/21/2016 Paul.  context.InstanceView.InstanceId is null at this stage, so all we can do is create the definition. 
				context.BindInstanceOwner(SplendidInstanceStore.gInstanceOwnerID, Guid.NewGuid());
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							Guid gDEFINITION_IDENTITY_ID = Guid.Empty;
							SqlProcs.spWF4_DEFINITION_IDENTITY_Insert
								( ref gDEFINITION_IDENTITY_ID
								, gSURROGATE_IDENTITY_ID
								, gDEFINITION_IDENTITY_HASH
								, sDefinitionName   
								, sDefinitionPackage
								, sDefinitionVersion
								, sDefinitionXAML   
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
			else if ( command is SaveWorkflowCommand )
			{
				SaveWorkflowCommand saveCommand = (SaveWorkflowCommand)command;
				instanceStateData = saveCommand.InstanceData;
				
				string sDefinitionName           = String.Empty;
				string sDefinitionPackage        = String.Empty;
				string sDefinitionVersion        = String.Empty;
				string sDefinitionXAML           = String.Empty;
				Guid   gDEFINITION_IDENTITY_HASH = Guid.Empty;
				Guid   gSURROGATE_IDENTITY_ID    = Guid.Empty;  // This is the CRM_ID. 
				GetIdentityMetadata(command, ref sDefinitionName, ref sDefinitionPackage, ref sDefinitionVersion, ref sDefinitionXAML, ref gDEFINITION_IDENTITY_HASH, ref gSURROGATE_IDENTITY_ID);
				
				string suspensionReason          = String.Empty;
				string suspensionExceptionName   = String.Empty;
				short  suspensionStateChange     = (short) GetSuspensionReason(saveCommand, out suspensionReason, out suspensionExceptionName);
				long   timerDurationMilliseconds = GetPendingTimerExpiration(saveCommand);
				
				ArraySegment<byte>[] dataProperties     = SerializationUtilities.SerializePropertyBag        (instanceStateData   );
				ArraySegment<byte>   metadataProperties = SerializationUtilities.SerializeMetadataPropertyBag(saveCommand, context);
				byte[] byPRIMITIVE_DATA_PROPERTIES      = dataProperties[0] .Array;  // SerializationUtilities.SerializePropertyBag(instanceStateData, false, false);
				byte[] byCOMPLEX_DATA_PROPERTIES        = dataProperties[1] .Array;  // SerializationUtilities.SerializePropertyBag(instanceStateData, true , false);
				byte[] byWRITE_ONLY_PRIMITIVE_DATA_PROP = dataProperties[2] .Array;  // SerializationUtilities.SerializePropertyBag(instanceStateData, false, true );
				byte[] byWRITE_ONLY_COMPLEX_DATA_PROP   = dataProperties[3] .Array;  // SerializationUtilities.SerializePropertyBag(instanceStateData, true , true );
				byte[] byMETADATA_PROPERTIES            = metadataProperties.Array;  // SerializationUtilities.SerializeMetadataPropertyBag(saveCommand, context);
				bool   bMetadataConsistency             = (context.InstanceView.InstanceMetadataConsistency == InstanceValueConsistency.None);
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							SqlProcs.spWF4_INSTANCES_Update
								( context.InstanceView.InstanceId
								, gSURROGATE_IDENTITY_ID                  // SURROGATE_IDENTITY_ID         
								, gDEFINITION_IDENTITY_HASH               // DEFINITION_IDENTITY_HASH      
								, SplendidInstanceStore.gInstanceOwnerID  // SURROGATE_LOCK_OWNER_ID       
								, byPRIMITIVE_DATA_PROPERTIES             // PRIMITIVE_DATA_PROPERTIES     
								, byCOMPLEX_DATA_PROPERTIES               // COMPLEX_DATA_PROPERTIES       
								, byWRITE_ONLY_PRIMITIVE_DATA_PROP        // WRITE_ONLY_PRIMITIVE_DATA_PROP
								, byWRITE_ONLY_COMPLEX_DATA_PROP          // WRITE_ONLY_COMPLEX_DATA_PROP  
								, byMETADATA_PROPERTIES                   // METADATA_PROPERTIES           
								, bMetadataConsistency                    // METADATA_CONSISTENCY          
								, 0                                       // ENCODING_OPTION               
								, context.InstanceVersion                 // VERSION                       
								, timerDurationMilliseconds               // TIMER_DURATION_MILLISECONDS   
								, GetExpirationTime(saveCommand)          // PENDING_TIMER                 
								, GetWorkflowHostType(saveCommand)        // WORKFLOW_HOST_TYPE            
								, Guid.Empty                              // SERVICE_DEPLOYMENT_ID         
								, suspensionExceptionName                 // SUSPENSION_EXCEPTION_NAME     
								, suspensionReason                        // SUSPENSION_REASON             
								, GetBlockingBookmarks(saveCommand)       // BLOCKING_BOOKMARKS            
								, System.Environment.MachineName          // LAST_MACHINE_RUN_ON           
								, GetExecutionStatus(saveCommand)         // EXECUTION_STATUS              
								, false                                   // IS_INITIALIZED                
								, suspensionStateChange                   // SUSPENSION_STATE_CHANGE       
								, IsReadyToRun(saveCommand)               // IS_READY_TO_RUN               
								, saveCommand.CompleteInstance            // IS_COMPLETED                  
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
			//The LoadWorkflow command instructs the instance store to lock and load the instance bound to the identifier in the instance handle
			else if ( command is LoadWorkflowCommand )
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL ;
					sSQL = "select *              " + ControlChars.CrLf
					     + "  from vwWF4_INSTANCES" + ControlChars.CrLf
					     + " where ID = @ID       " + ControlChars.CrLf;
					//     + "   and SURROGATE_LOCK_OWNER_ID = @SURROGATE_LOCK_OWNER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@ID"                     , context.InstanceView.InstanceId       );
						//Sql.AddParameter(cmd, "@SURROGATE_LOCK_OWNER_ID", SplendidInstanceStore.gInstanceOwnerID);
						using ( DataTable dt = new DataTable() )
						{
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
								{
									DataRow row = dt.Rows[0];
									Guid   instanceId            = Sql.ToGuid(row["ID"]);
									byte[] byPrimitiveProperties = Sql.ToByteArray(row["PRIMITIVE_DATA_PROPERTIES"]);
									byte[] byComplexProperties   = Sql.ToByteArray(row["COMPLEX_DATA_PROPERTIES"  ]);
									byte[] byMetadataProperties  = Sql.ToByteArray(row["METADATA_PROPERTIES"      ]);
									bool isInitialized           = Sql.ToBoolean  (row["IS_INITIALIZED"           ]);
									if ( !context.InstanceView.IsBoundToInstance )
									{
										context.BindInstance(instanceId);
									}
									if ( !context.InstanceView.IsBoundToInstanceOwner )
									{
										context.BindInstanceOwner(SplendidInstanceStore.gInstanceOwnerID, Guid.NewGuid());
									}
									instanceStateData = SerializationUtilities.DeserializePropertyBag(byPrimitiveProperties, byComplexProperties);
									IDictionary<XName, InstanceValue> instanceMetadata  = SerializationUtilities.DeserializeMetadataPropertyBag(byMetadataProperties);
									
									context.LoadedInstance(isInitialized ? InstanceState.Initialized : InstanceState.Uninitialized, instanceStateData, instanceMetadata, null, null);
								}
							}
						}
					}
				}
			}
			else if ( command is DeleteWorkflowOwnerCommand )
			{
				// 06/22/2016 Paul.  Nothing special to do during delete. 
				// This would be a good place to manage an internal dictionary of workflows. 
			}
			else
			{
				System.Diagnostics.Debug.WriteLine("SplendidInstanceStore.BeginTryCommand: Unknown command " + command.GetType().Name);
			}
			return new CompletedAsyncResult<bool>(true, callback, state);
		}

		protected override bool EndTryCommand(IAsyncResult result)
		{
			return CompletedAsyncResult<bool>.End(result);
		}

		enum SuspensionStateChange
		{
			NoChange = 0,
			SuspendInstance = 1,
			UnsuspendInstance = 2
		};

		private static SuspensionStateChange GetSuspensionReason(SaveWorkflowCommand saveWorkflowCommand, out string suspensionReason, out string suspensionExceptionName)
		{
			IDictionary<XName, InstanceValue> instanceMetadataChanges = saveWorkflowCommand.InstanceMetadataChanges;
			SuspensionStateChange suspensionStateChange = SuspensionStateChange.NoChange;
			InstanceValue propertyValue;
			suspensionReason        = null;
			suspensionExceptionName = null;

			if ( instanceMetadataChanges.TryGetValue(WorkflowServiceNamespace.SuspendReason, out propertyValue) )
			{
				if ( !propertyValue.IsDeletedValue )
				{
					suspensionStateChange = SuspensionStateChange.SuspendInstance;
					suspensionReason = Sql.ToString(propertyValue.Value);

					if ( instanceMetadataChanges.TryGetValue(WorkflowServiceNamespace.SuspendException, out propertyValue) && !propertyValue.IsDeletedValue )
					{
						suspensionExceptionName = ((Exception)propertyValue.Value).GetType().ToString();
					}
				}
				else
				{
					suspensionStateChange = SuspensionStateChange.UnsuspendInstance;
				}
			}

			return suspensionStateChange;
		}

		private static bool IsReadyToRun(SaveWorkflowCommand saveWorkflowCommand)
		{
			InstanceValue statusPropertyValue;
			if ( saveWorkflowCommand.InstanceData.TryGetValue(SqlWorkflowInstanceStoreConstants.StatusPropertyName, out statusPropertyValue) && (Sql.ToString(statusPropertyValue.Value)) == SqlWorkflowInstanceStoreConstants.ExecutingStatusPropertyValue )
			{
				return true;
			}
			return false;
		}

		private static string GetBlockingBookmarks(SaveWorkflowCommand saveWorkflowCommand)
		{
			string sBlockingBookmarks = null;
			InstanceValue binaryBlockingBookmarks;

			if ( saveWorkflowCommand.InstanceData.TryGetValue(SqlWorkflowInstanceStoreConstants.BinaryBlockingBookmarksPropertyName, out binaryBlockingBookmarks) )
			{
				StringBuilder bookmarkListBuilder = new StringBuilder(SqlWorkflowInstanceStoreConstants.DefaultStringBuilderCapacity);
				IEnumerable<BookmarkInfo> activeBookmarks = binaryBlockingBookmarks.Value as IEnumerable<BookmarkInfo>;

				XmlWriterSettings settings = new XmlWriterSettings()
				{
					OmitXmlDeclaration = true
				};
				using ( XmlWriter writer = XmlWriter.Create(bookmarkListBuilder, settings) )
				{
					writer.WriteStartElement("Bookmarks");
					foreach ( BookmarkInfo bookmarkInfo in activeBookmarks )
					{
						writer.WriteStartElement("Bookmark");
						writer.WriteAttributeString("BookmarkName"    , bookmarkInfo.BookmarkName    );
						writer.WriteAttributeString("OwnerDisplayName", bookmarkInfo.OwnerDisplayName);
						if ( bookmarkInfo.ScopeInfo != null )
						{
							writer.WriteStartElement("BookmarkScopeInfo");
							writer.WriteAttributeString("Id"           , bookmarkInfo.ScopeInfo.Id.ToString());
							writer.WriteAttributeString("IsInitialized", bookmarkInfo.ScopeInfo.IsInitialized.ToString());
							writer.WriteAttributeString("TemporaryId"  , bookmarkInfo.ScopeInfo.TemporaryId);
							writer.WriteEndElement();
						}
						writer.WriteEndElement();
					}
					writer.WriteEndElement();
					writer.Flush();
					sBlockingBookmarks = bookmarkListBuilder.ToString();
				}
			}
			return sBlockingBookmarks;
		}

		private static string GetExecutionStatus(SaveWorkflowCommand saveWorkflowCommand)
		{
			string sStatus = null;
			InstanceValue executionStatusProperty;

			if ( saveWorkflowCommand.InstanceData.TryGetValue(SqlWorkflowInstanceStoreConstants.StatusPropertyName, out executionStatusProperty) )
			{
				sStatus = Sql.ToString(executionStatusProperty.Value);
			}
			return sStatus;
		}

		private static long GetPendingTimerExpiration(SaveWorkflowCommand saveWorkflowCommand)
		{
			InstanceValue pendingTimerExpirationPropertyValue;
			if ( saveWorkflowCommand.InstanceData.TryGetValue(SqlWorkflowInstanceStoreConstants.PendingTimerExpirationPropertyName, out pendingTimerExpirationPropertyValue) )
			{
				DateTime pendingTimerExpiration = ((DateTime)pendingTimerExpirationPropertyValue.Value).ToUniversalTime();
				TimeSpan datetimeOffset = pendingTimerExpiration - DateTime.UtcNow;

				return (long) datetimeOffset.TotalMilliseconds;
			}
			return 0;
		}

		private static DateTime GetExpirationTime(SaveWorkflowCommand saveWorkflowCommand)
		{
			InstanceValue pendingTimerExpirationPropertyValue;
			if ( saveWorkflowCommand.InstanceData.TryGetValue(SqlWorkflowInstanceStoreConstants.PendingTimerExpirationPropertyName, out pendingTimerExpirationPropertyValue) )
			{
				DateTime pendingTimerExpiration = ((DateTime)pendingTimerExpirationPropertyValue.Value).ToUniversalTime();
				return pendingTimerExpiration;
			}
			return DateTime.MinValue;
		}

		private static Guid GetWorkflowHostType(SaveWorkflowCommand saveWorkflowCommand)
		{
			InstanceValue instanceValue;
			if ( saveWorkflowCommand.InstanceMetadataChanges.TryGetValue(WorkflowNamespace.WorkflowHostType, out instanceValue) )
			{
				XName workflowHostType = instanceValue.Value as XName;

				if ( workflowHostType == null )
				{
					throw new InstancePersistenceCommandException("InvalidMetadataValue WorkflowHostType " + typeof(XName).Name);
				}
				byte[] workflowHostTypeBuffer = System.Text.Encoding.Unicode.GetBytes(((XName)instanceValue.Value).ToString());
				return new Guid(Workflow4Utils.ComputeHash(workflowHostTypeBuffer));
			}
			return Guid.Empty;
		}
	}
}
