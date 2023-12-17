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
using System.Data;
using System.Workflow.Runtime.Tracking;
using System.Workflow.ComponentModel;
//using System.Diagnostics;

namespace SplendidCRM
{
    // Writing Tracking Services for Windows Workflow Foundation
    // http://msdn.microsoft.com/en-us/library/aa730873(VS.80).aspx
    // Monitoring Workflows with WF for Enhanced Application Data Visibility
    // http://msdn2.microsoft.com/en-us/library/cc299397.aspx
    // Creating Custom Tracking Services
    // http://msdn.microsoft.com/en-us/library/ms735912(VS.85).aspx
    public class SplendidTrackingService : TrackingService
	{
		private DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application         = new HttpApplicationState();
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;

		public SplendidTrackingService(Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError)
		{
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
		}

		protected override TrackingProfile GetProfile(Guid workflowInstanceId)
		{
			TrackingProfile profile = null;
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select TRACKING_PROFILE_XML                        " + ControlChars.CrLf
					     + "  from vwWWF_TRACKING_PROFILE_INST                 " + ControlChars.CrLf
					     + " where WORKFLOW_INSTANCE_ID = @WORKFLOW_INSTANCE_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@WORKFLOW_INSTANCE_ID", workflowInstanceId);
						using ( IDataReader rdr = cmd.ExecuteReader() )
						{
							if ( rdr.Read() )
							{
								string sTRACKING_PROFILE_XML = Sql.ToString(rdr["TRACKING_PROFILE_XML"]);
								using ( StringReader rsr = new StringReader(sTRACKING_PROFILE_XML) )
								{
									profile = new TrackingProfileSerializer().Deserialize(rsr);
								}
							}
							else
							{
								//throw(new Exception("Could not obtain a tracking profile for workflowInstanceId " + workflowInstanceId.ToString()));
								profile = GetDefaultProfile();
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
			return profile;
		}

		protected override TrackingProfile GetProfile(Type workflowType, Version profileVersionId)
		{
			TrackingProfile profile = null;
			try
			{
				if ( workflowType == null )
				{
					throw new ArgumentNullException("workflowType");
				}

				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select TRACKING_PROFILE_XML                    " + ControlChars.CrLf
					     + "  from vwWWF_TRACKING_PROFILES_XML             " + ControlChars.CrLf
					     + " where TYPE_FULL_NAME     = @TYPE_FULL_NAME    " + ControlChars.CrLf
					     + "   and ASSEMBLY_FULL_NAME = @ASSEMBLY_FULL_NAME" + ControlChars.CrLf
					     + "   and VERSION            = @VERSION           " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@TYPE_FULL_NAME"    , workflowType.FullName         );
						Sql.AddParameter(cmd, "@ASSEMBLY_FULL_NAME", workflowType.Assembly.FullName);
						Sql.AddParameter(cmd, "@VERSION"           , profileVersionId.ToString()   );
						using ( IDataReader rdr = cmd.ExecuteReader() )
						{
							if ( rdr.Read() )
							{
								string sTRACKING_PROFILE_XML = Sql.ToString(rdr["TRACKING_PROFILE_XML"]);
								using ( StringReader rsr = new StringReader(sTRACKING_PROFILE_XML) )
								{
									profile = new TrackingProfileSerializer().Deserialize(rsr);
								}
							}
							else
							{
								//throw(new Exception("Could not obtain a tracking profile for " + workflowType.FullName + ", " + workflowType.Assembly.FullName + ", " + profileVersionId));
								profile = GetDefaultProfile();
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
			return profile;
		}

		protected override bool TryGetProfile(Type workflowType, out TrackingProfile profile)
		{
			profile = null;
			try
			{
				if ( workflowType == null )
				{
					throw new ArgumentNullException("workflowType");
				}

				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							Guid gTRACKING_PROFILE_ID = Guid.Empty;
							SqlProcs.spWWF_TRACKING_PROFILES_InsertOnly(ref gTRACKING_PROFILE_ID, workflowType.FullName, workflowType.Assembly.FullName, trn);
							trn.Commit();
						}
						catch(Exception ex)
						{
							trn.Rollback();
							throw(new Exception(ex.Message, ex.InnerException));
						}
					}
					string sSQL;
					sSQL = "select TRACKING_PROFILE_XML                    " + ControlChars.CrLf
					     + "  from vwWWF_TRACKING_PROFILES_XML             " + ControlChars.CrLf
					     + " where TYPE_FULL_NAME     = @TYPE_FULL_NAME    " + ControlChars.CrLf
					     + "   and ASSEMBLY_FULL_NAME = @ASSEMBLY_FULL_NAME" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@TYPE_FULL_NAME"    , workflowType.FullName         );
						Sql.AddParameter(cmd, "@ASSEMBLY_FULL_NAME", workflowType.Assembly.FullName);
						using ( IDataReader rdr = cmd.ExecuteReader() )
						{
							if ( rdr.Read() )
							{
								string sTRACKING_PROFILE_XML = Sql.ToString(rdr["TRACKING_PROFILE_XML"]);
								using ( StringReader rsr = new StringReader(sTRACKING_PROFILE_XML) )
								{
									profile = new TrackingProfileSerializer().Deserialize(rsr);
								}
							}
							else
							{
								// 10/04/2008 Paul.  The profile may not exist, so don't throw an exception if it does not. 
								//throw(new Exception("Could not obtain a tracking profile for " + workflowType.FullName + ", " + workflowType.Assembly.FullName));
								// 10/05/2008 Paul.  If we don't return a profile, then there will be no tracking. 
								profile = GetDefaultProfile();
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
			return (profile != null);
		}

		protected override bool TryReloadProfile(Type workflowType, Guid workflowInstanceId, out TrackingProfile profile)
		{
			profile = null;
			try
			{
				if ( workflowType == null )
				{
					throw new ArgumentNullException("workflowType");
				}

				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select TRACKING_PROFILE_XML                        " + ControlChars.CrLf
					     + "  from vwWWF_TRACKING_PROFILE_INST                 " + ControlChars.CrLf
					     + " where WORKFLOW_INSTANCE_ID = @WORKFLOW_INSTANCE_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@WORKFLOW_INSTANCE_ID", workflowInstanceId);
						using ( IDataReader rdr = cmd.ExecuteReader() )
						{
							if ( rdr.Read() )
							{
								string sTRACKING_PROFILE_XML = Sql.ToString(rdr["TRACKING_PROFILE_XML"]);
								using ( StringReader rsr = new StringReader(sTRACKING_PROFILE_XML) )
								{
									profile = new TrackingProfileSerializer().Deserialize(rsr);
								}
							}
							else
							{
								//throw(new Exception("Could not obtain a tracking profile for workflowInstanceId " + workflowInstanceId.ToString()));
								profile = GetDefaultProfile();
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
			return (profile != null);
		}
	
		private TrackingProfile GetDefaultProfile()
		{
			TrackingProfile profile = null;
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select TRACKING_PROFILE_XML    " + ControlChars.CrLf
					     + "  from WWF_TRACKING_PROFILE_DEF" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						using ( IDataReader rdr = cmd.ExecuteReader() )
						{
							if ( rdr.Read() )
							{
								string sTRACKING_PROFILE_XML = Sql.ToString(rdr["TRACKING_PROFILE_XML"]);
								using ( StringReader rsr = new StringReader(sTRACKING_PROFILE_XML) )
								{
									profile = new TrackingProfileSerializer().Deserialize(rsr);
								}
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new System.Diagnostics.StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
			}
			if ( profile == null )
			{
				// http://msdn.microsoft.com/en-us/library/ms735912(VS.85).aspx
				profile = new TrackingProfile();
				//profile.Version = new Version("3.0.0");

				// Add activity track points.
				ActivityTrackPoint atp = new ActivityTrackPoint();
				ActivityTrackingLocation activityLocation = new ActivityTrackingLocation(typeof(Activity));
				activityLocation.MatchDerivedTypes = true;
				foreach ( ActivityExecutionStatus s in Enum.GetValues(typeof(ActivityExecutionStatus)) )
				{
					activityLocation.ExecutionStatusEvents.Add(s);
				}
				atp.MatchingLocations.Add(activityLocation);
				profile.ActivityTrackPoints.Add(atp);

				// Add instance track points.
				WorkflowTrackPoint wtp = new WorkflowTrackPoint();
				WorkflowTrackingLocation workflowLocation = new WorkflowTrackingLocation();
				wtp.MatchingLocation = workflowLocation;
				foreach ( TrackingWorkflowEvent workflowEvent in Enum.GetValues(typeof(TrackingWorkflowEvent)) )
				{
					wtp.MatchingLocation.Events.Add(workflowEvent);
				}
				profile.WorkflowTrackPoints.Add(wtp);

				// Create instance of User Track point
				UserTrackPoint utp = new UserTrackPoint();
				UserTrackingLocation userTrackingLocation = new UserTrackingLocation(typeof(string), typeof(Activity));
				// Set the MatchedDerivedTypes property to true to match the activities derived from the reference activity type.
				userTrackingLocation.MatchDerivedActivityTypes = true;
				utp.MatchingLocations.Add(userTrackingLocation);

				// Add user track points to tracking profile
				profile.UserTrackPoints.Add(utp);
			}
			return profile;
		}

		protected override TrackingChannel GetTrackingChannel(TrackingParameters parameters)
		{
			SplendidTrackingChannel channel = new SplendidTrackingChannel(Sql, SqlProcs, SplendidError, parameters);
			return channel;
		}
	}
}
