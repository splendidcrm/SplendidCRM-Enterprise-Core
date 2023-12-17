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
using System.Text;
using System.Data;
using System.Data.Common;
using System.Activities;
using System.ComponentModel;
using System.Diagnostics;

namespace SplendidCRM
{
	public class WF4ApprovalActivity : NativeActivity<string>
	{
		// 07/28/2016 Paul.  BUSINESS_PROCESS_ID, AUDIT_ID and PROCESS_USER_ID are a workflow globals, so skip the part where we manually assign in XAML. 
		//public InArgument<Guid  >  BUSINESS_PROCESS_ID   { get; set; }
		//public InArgument<Guid  >  AUDIT_ID              { get; set; }
		//public InArgument<Guid  >  PROCESS_USER_ID       { get; set; }
		public InArgument<string>  ACTIVITY_NAME           { get; set; }
		public InArgument<string>  BOOKMARK_NAME           { get; set; }
		public InArgument<string>  PARENT_TYPE             { get; set; }
		public InArgument<Guid  >  PARENT_ID               { get; set; }
		public InArgument<string>  USER_TASK_TYPE          { get; set; }  // Approve/Reject, Route
		public InArgument<bool  >  CHANGE_ASSIGNED_USER    { get; set; }
		public InArgument<Guid  >  CHANGE_ASSIGNED_TEAM_ID { get; set; }
		public InArgument<bool  >  CHANGE_PROCESS_USER     { get; set; }
		public InArgument<Guid  >  CHANGE_PROCESS_TEAM_ID  { get; set; }
		public InArgument<string>  USER_ASSIGNMENT_METHOD  { get; set; }  // Current Process User, Record Owner, Supervisor, Static User, Round Robin Team, Round Robin Role, Self Service Team, Self Service Role
		public InArgument<Guid  >  STATIC_ASSIGNED_USER_ID { get; set; }
		public InArgument<Guid  >  DYNAMIC_PROCESS_TEAM_ID { get; set; }
		public InArgument<Guid  >  DYNAMIC_PROCESS_ROLE_ID { get; set; }
		public InArgument<string>  READ_ONLY_FIELDS        { get; set; }
		public InArgument<string>  REQUIRED_FIELDS         { get; set; }
		public InArgument<string>  DURATION_UNITS          { get; set; }
		public InArgument<int   >  DURATION_VALUE          { get; set; }
		public OutArgument<string> APPROVAL_RESPONSE       { get; set; }

		protected override bool CanInduceIdle
		{
			get { return true; }
		}

		protected static void spPROCESSES_UpdateApproval(Sql Sql, SqlProcs SqlProcs, Guid gID, Guid gUSER_ID, string sAPPROVAL_RESPONSE)
		{
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spPROCESSES_UpdateApproval(gID, gUSER_ID, sAPPROVAL_RESPONSE, trn);
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
			}
		}

		public static void Approve(Sql Sql, SqlProcs SqlProcs, SplendidCRM.Crm.Modules Modules, L10N L10n, Guid gID, Guid gUSER_ID)
		{
			ValidateRequiredFields(Modules, L10n, gID);
			spPROCESSES_UpdateApproval(Sql, SqlProcs, gID, gUSER_ID, "Approve");
		}

		public static void Reject(Sql Sql, SqlProcs SqlProcs, Guid gID, Guid gUSER_ID)
		{
			spPROCESSES_UpdateApproval(Sql, SqlProcs, gID, gUSER_ID, "Reject");
		}

		public static void Route(Sql Sql, SqlProcs SqlProcs, SplendidCRM.Crm.Modules Modules, L10N L10n, Guid gID, Guid gUSER_ID)
		{
			ValidateRequiredFields(Modules, L10n, gID);
			spPROCESSES_UpdateApproval(Sql, SqlProcs, gID, gUSER_ID, "Route");
		}

		public static void Claim(Sql Sql, SqlProcs SqlProcs, Guid gID, Guid gUSER_ID)
		{
			spPROCESSES_UpdateApproval(Sql, SqlProcs, gID, gUSER_ID, "Claim");
		}

		public static void Cancel(Sql Sql, SqlProcs SqlProcs, Guid gID, Guid gUSER_ID)
		{
			spPROCESSES_UpdateApproval(Sql, SqlProcs, gID, gUSER_ID, "Cancel");
		}

		public static void ChangeProcessUser(Sql Sql, SqlProcs SqlProcs, Guid gID, Guid gPROCESS_USER_ID, string sPROCESS_NOTES)
		{
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spPROCESSES_ChangeProcessUser(gID, gPROCESS_USER_ID, sPROCESS_NOTES, trn);
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
			}
		}

		public static void ChangeAssignedUser(Sql Sql, SqlProcs SqlProcs, Guid gID, Guid gASSIGNED_USER_ID, string sPROCESS_NOTES)
		{
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				{
					try
					{
						SqlProcs.spPROCESSES_ChangeAssignedUser(gID, gASSIGNED_USER_ID, sPROCESS_NOTES, trn);
						trn.Commit();
					}
					catch
					{
						trn.Rollback();
						throw;
					}
				}
			}
		}

		public static void Filter(Security Security, IDbCommand cmd, Guid gUSER_ID)
		{
			HttpApplicationState Application         = new HttpApplicationState();
			string sSQL = String.Empty;
			bool bEnableTeamHierarchy = Sql.ToBoolean(Application["CONFIG.enable_team_hierarchy"]);
			sSQL =  " where PROCESS_USER_ID = @PROCESS_USER_ID                 " + ControlChars.CrLf
			     +  "    or (     PROCESS_USER_ID is null                      " + ControlChars.CrLf
			     +  "         and USER_ASSIGNMENT_METHOD = N'Self-Service Team'" + ControlChars.CrLf;
			if ( !bEnableTeamHierarchy )
			{
				sSQL += "         and exists(select *                                           " + ControlChars.CrLf
				     +  "                      from vwTEAM_MEMBERSHIPS                          " + ControlChars.CrLf
				     +  "                     where MEMBERSHIP_TEAM_ID = DYNAMIC_PROCESS_TEAM_ID" + ControlChars.CrLf
				     +  "                       and MEMBERSHIP_USER_ID = @TEAM_USER_ID          " + ControlChars.CrLf
				     +  "                   )                                                   " + ControlChars.CrLf;
			}
			else if ( Sql.IsOracle(cmd) )
			{
				sSQL += "         and exists(select *                                                                   " + ControlChars.CrLf
				     +  "                      table(fnTEAM_HIERARCHY_USERS(DYNAMIC_PROCESS_TEAM_ID)) vwTEAM_MEMBERSHIPS" + ControlChars.CrLf
				     +  "                     where MEMBERSHIP_USER_ID = @TEAM_USER_ID                                  " + ControlChars.CrLf
				     +  "                   )                                                                           " + ControlChars.CrLf;
			}
			else
			{
				string fnPrefix = (Sql.IsSQLServer(cmd) ? "dbo." : String.Empty);
				sSQL += "         and exists(select *                                                                                       " + ControlChars.CrLf
				     +  "                      from " + fnPrefix + "fnTEAM_HIERARCHY_USERS(DYNAMIC_PROCESS_TEAM_ID) vwTEAM_MEMBERSHIPS" + ControlChars.CrLf
				     +  "                     where MEMBERSHIP_USER_ID = @TEAM_USER_ID                                                      " + ControlChars.CrLf
				     +  "                   )                                                                                               " + ControlChars.CrLf;
			}
			sSQL += "       )                                                                          " + ControlChars.CrLf
			     +  "    or (     PROCESS_USER_ID is null                                              " + ControlChars.CrLf
			     +  "         and USER_ASSIGNMENT_METHOD = N'Self-Service Role'                        " + ControlChars.CrLf
			     +  "         and exists(select *                                                      " + ControlChars.CrLf
			     +  "                      from vwUSERS_ACL_ROLES                                      " + ControlChars.CrLf
			     +  "                     inner join vwUSERS_ASSIGNED_TO                               " + ControlChars.CrLf
			     +  "                             on vwUSERS_ASSIGNED_TO.ID = vwUSERS_ACL_ROLES.USER_ID" + ControlChars.CrLf
			     +  "                     where vwUSERS_ACL_ROLES.ROLE_ID = DYNAMIC_PROCESS_ROLE_ID    " + ControlChars.CrLf
			     +  "                       and vwUSERS_ACL_ROLES.USER_ID = @ROLE_USER_ID              " + ControlChars.CrLf
			     +  "                   )                                                              " + ControlChars.CrLf
			     +  "       )                                                                          " + ControlChars.CrLf;
			cmd.CommandText += sSQL;
			Sql.AddParameter(cmd, "@PROCESS_USER_ID", Security.USER_ID);
			Sql.AddParameter(cmd, "@TEAM_USER_ID"   , Security.USER_ID);
			Sql.AddParameter(cmd, "@ROLE_USER_ID"   , Security.USER_ID);
		}

		public static bool GetProcessStatus(Security Security, L10N L10n, Guid gPENDING_PROCESS_ID, ref string sProcessStatus, ref bool bShowApprove, ref bool bShowReject, ref bool bShowRoute, ref bool bShowClaim, ref string sUSER_TASK_TYPE, ref Guid gPROCESS_USER_ID, ref Guid gASSIGNED_TEAM_ID, ref Guid gPROCESS_TEAM_ID)
		{
			HttpApplicationState Application         = new HttpApplicationState();
			bool bFound = false;
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL = String.Empty;
				sSQL = "select *                        " + ControlChars.CrLf
				     + "  from vwPROCESSES_PendingStatus" + ControlChars.CrLf
				     + " where ID = @ID                 " + ControlChars.CrLf;
				using ( DataTable dtProcess = new DataTable() )
				{
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@ID", gPENDING_PROCESS_ID);
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							da.Fill(dtProcess);
						}
					}
					if ( dtProcess.Rows.Count > 0 )
					{
						DataRow rdrProcess = dtProcess.Rows[0];
						int      nPROCESS_NUMBER               = Sql.ToInteger (rdrProcess["PROCESS_NUMBER"              ]);
						Guid     gBUSINESS_PROCESS_INSTANCE_ID = Sql.ToGuid    (rdrProcess["BUSINESS_PROCESS_INSTANCE_ID"]);
						string   sACTIVITY_INSTANCE            = Sql.ToString  (rdrProcess["ACTIVITY_INSTANCE"           ]);
						string   sACTIVITY_NAME                = Sql.ToString  (rdrProcess["ACTIVITY_NAME"               ]);
						Guid     gBUSINESS_PROCESS_ID          = Sql.ToGuid    (rdrProcess["BUSINESS_PROCESS_ID"         ]);
						string   sBUSINESS_PROCESS_NAME        = Sql.ToString  (rdrProcess["BUSINESS_PROCESS_NAME"       ]);
						// 08/06/2016 Paul.  We will return gPROCESS_USER_ID. 
						         gPROCESS_USER_ID              = Sql.ToGuid    (rdrProcess["PROCESS_USER_ID"             ]);
						string   sBOOKMARK_NAME                = Sql.ToString  (rdrProcess["BOOKMARK_NAME"               ]);
						string   sPARENT_TYPE                  = Sql.ToString  (rdrProcess["PARENT_TYPE"                 ]);
						Guid     gPARENT_ID                    = Sql.ToGuid    (rdrProcess["PARENT_ID"                   ]);
						// 08/06/2016 Paul.  We will return sUSER_TASK_TYPE. 
						         sUSER_TASK_TYPE               = Sql.ToString  (rdrProcess["USER_TASK_TYPE"              ]);
						bool     bCHANGE_ASSIGNED_USER         = Sql.ToBoolean (rdrProcess["CHANGE_ASSIGNED_USER"        ]);
						Guid     gCHANGE_ASSIGNED_TEAM_ID      = Sql.ToGuid    (rdrProcess["CHANGE_ASSIGNED_TEAM_ID"     ]);
						bool     bCHANGE_PROCESS_USER          = Sql.ToBoolean (rdrProcess["CHANGE_PROCESS_USER"         ]);
						Guid     gCHANGE_PROCESS_TEAM_ID       = Sql.ToGuid    (rdrProcess["CHANGE_PROCESS_TEAM_ID"      ]);
						string   sUSER_ASSIGNMENT_METHOD       = Sql.ToString  (rdrProcess["USER_ASSIGNMENT_METHOD"      ]);
						Guid     gSTATIC_ASSIGNED_USER_ID      = Sql.ToGuid    (rdrProcess["STATIC_ASSIGNED_USER_ID"     ]);
						Guid     gDYNAMIC_PROCESS_TEAM_ID      = Sql.ToGuid    (rdrProcess["DYNAMIC_PROCESS_TEAM_ID"     ]);
						Guid     gDYNAMIC_PROCESS_ROLE_ID      = Sql.ToGuid    (rdrProcess["DYNAMIC_PROCESS_ROLE_ID"     ]);
						string   sREAD_ONLY_FIELDS             = Sql.ToString  (rdrProcess["READ_ONLY_FIELDS"            ]);
						string   sREQUIRED_FIELDS              = Sql.ToString  (rdrProcess["REQUIRED_FIELDS"             ]);
						string   sDURATION_UNITS               = Sql.ToString  (rdrProcess["DURATION_UNITS"              ]);
						int      nDURATION_VALUE               = Sql.ToInteger (rdrProcess["DURATION_VALUE"              ]);
						string   sSTATUS                       = Sql.ToString  (rdrProcess["STATUS"                      ]);
						Guid     gAPPROVAL_USER_ID             = Sql.ToGuid    (rdrProcess["APPROVAL_USER_ID"            ]);
						string   sAPPROVAL_DATE                = Sql.ToString  (rdrProcess["APPROVAL_DATE"               ]);
						string   sAPPROVAL_RESPONSE            = Sql.ToString  (rdrProcess["APPROVAL_RESPONSE"           ]);
						DateTime dtDATE_ENTERED                = Sql.ToDateTime(rdrProcess["DATE_ENTERED"                ]);
						DateTime dtDATE_MODIFIED               = Sql.ToDateTime(rdrProcess["DATE_MODIFIED"               ]);
						
						bFound = true;
						sProcessStatus = sBUSINESS_PROCESS_NAME;
						if ( !Sql.IsEmptyString(sACTIVITY_NAME) )
						{
							sProcessStatus += " | " + sACTIVITY_NAME;
						}
						if ( !Sql.IsEmptyString(sDURATION_UNITS) && nDURATION_VALUE > 0 )
						{
							DateTime dtDUE_DATE = dtDATE_ENTERED;
							switch ( sDURATION_UNITS )
							{
								case "hour"   :  dtDUE_DATE = dtDUE_DATE.AddHours (    nDURATION_VALUE);  break;
								case "day"    :  dtDUE_DATE = dtDUE_DATE.AddDays  (    nDURATION_VALUE);  break;
								case "week"   :  dtDUE_DATE = dtDUE_DATE.AddDays  (7 * nDURATION_VALUE);  break;
								case "month"  :  dtDUE_DATE = dtDUE_DATE.AddMonths(    nDURATION_VALUE);  break;
								case "quarter":  dtDUE_DATE = dtDUE_DATE.AddMonths(3 * nDURATION_VALUE);  break;
								case "year"   :  dtDUE_DATE = dtDUE_DATE.AddYears (    nDURATION_VALUE);  break;
							}
							string sDUE_DATE = dtDUE_DATE.ToString();
							if ( dtDUE_DATE > DateTime.Now )
							{
								sProcessStatus += " [ " + String.Format(L10n.Term("Processes.LBL_DUE_DATE_FORMAT"), sDUE_DATE) + " ]";
							}
							else
							{
								sProcessStatus += " [ <span class=ProcessOverdue>" + String.Format(L10n.Term("Processes.LBL_OVERDUE_FORMAT"), sDUE_DATE) + "</span> ]";
							}
						}
						if ( bCHANGE_ASSIGNED_USER )
							gASSIGNED_TEAM_ID = gCHANGE_ASSIGNED_TEAM_ID;
						if ( bCHANGE_PROCESS_USER )
							gPROCESS_TEAM_ID = gCHANGE_PROCESS_TEAM_ID;
						// 08/02/2016 Paul.  Self-service only applies if Process User not set. 
						if ( !Sql.IsEmptyGuid(gPROCESS_USER_ID) )
						{
							if ( sUSER_TASK_TYPE == "Approve/Reject" )
							{
								bShowApprove = true;
								bShowReject  = true;
							}
							else // if ( sUSER_TASK_TYPE == "Route" )
							{
								bShowRoute = true;
							}
						}
						else if ( sUSER_ASSIGNMENT_METHOD == "Self-Service Team" )
						{
							bool bEnableTeamHierarchy = Sql.ToBoolean(Application["CONFIG.enable_team_hierarchy"]);
							if ( !bEnableTeamHierarchy )
							{
								sSQL = "select count(*)                     " + ControlChars.CrLf
								     + "  from vwTEAM_MEMBERSHIPS           " + ControlChars.CrLf
								     + " where MEMBERSHIP_TEAM_ID = @TEAM_ID" + ControlChars.CrLf
								     + "   and MEMBERSHIP_USER_ID = @USER_ID" + ControlChars.CrLf;
							}
							else
							{
								if ( Sql.IsOracle(con) )
								{
									sSQL = "select count(*)                     " + ControlChars.CrLf
									     + "  from table(fnTEAM_HIERARCHY_USERS(@TEAM_ID)) vwTEAM_MEMBERSHIPS" + ControlChars.CrLf
									     + " where MEMBERSHIP_USER_ID = @USER_ID" + ControlChars.CrLf;
								}
								else
								{
									string fnPrefix = (Sql.IsSQLServer(con) ? "dbo." : String.Empty);
									sSQL = "select count(*)                     " + ControlChars.CrLf
									     + "  from " + fnPrefix + "fnTEAM_HIERARCHY_USERS(@TEAM_ID) vwTEAM_MEMBERSHIPS" + ControlChars.CrLf
									     + " where MEMBERSHIP_USER_ID = @USER_ID" + ControlChars.CrLf;
								}
							}
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@TEAM_ID", gDYNAMIC_PROCESS_TEAM_ID);
								Sql.AddParameter(cmd, "@USER_ID", Security.USER_ID        );
								int nUserIncluded = Sql.ToInteger(cmd.ExecuteScalar());
								if ( nUserIncluded > 0 )
								{
									bShowClaim = true;
								}
							}
						}
						else if ( sUSER_ASSIGNMENT_METHOD == "Self-Service Role" )
						{
							sSQL = "select count(*)                                               " + ControlChars.CrLf
							     + "  from vwUSERS_ACL_ROLES                                      " + ControlChars.CrLf
							     + " inner join vwUSERS_ASSIGNED_TO                               " + ControlChars.CrLf
							     + "         on vwUSERS_ASSIGNED_TO.ID = vwUSERS_ACL_ROLES.USER_ID" + ControlChars.CrLf
							     + " where vwUSERS_ACL_ROLES.ROLE_ID = @ROLE_ID                   " + ControlChars.CrLf
							     + "   and vwUSERS_ACL_ROLES.USER_ID = @USER_ID                   " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ROLE_ID", gDYNAMIC_PROCESS_ROLE_ID);
								Sql.AddParameter(cmd, "@USER_ID", Security.USER_ID        );
								int nUserIncluded = Sql.ToInteger(cmd.ExecuteScalar());
								if ( nUserIncluded > 0 )
								{
									bShowClaim = true;
								}
							}
						}
					}
				}
			}
			return bFound;
		}

		/*
		public static bool IsProcessPending(System.Web.UI.WebControls.DataGridItem Container)
		{
			bool bIsProcessPending = false;
			if ( Container.DataItem != null )
			{
				DataRow row = null;
				if ( Container.DataItem is DataRow )
				{
					row = Container.DataItem as DataRow;
				}
				else if ( Container.DataItem is DataRowView )
				{
					row = (Container.DataItem as DataRowView).Row;
				}
				if ( row != null && row.Table.Columns.Contains("PENDING_PROCESS_ID") )
				{
					bIsProcessPending = !Sql.IsEmptyGuid(row["PENDING_PROCESS_ID"]);
				}
			}
			return bIsProcessPending;
		}

		public static void ApplyEditViewPostLoadEventRules(HttpApplicationState Application, L10N L10n, string sEDIT_NAME, SplendidControl parent, DataRow row)
		{
			if ( row != null && row.Table.Columns.Contains("PENDING_PROCESS_ID") )
			{
				Guid gPENDING_PROCESS_ID = Sql.ToGuid(row["PENDING_PROCESS_ID"]);
				DbProviderFactory dbf = DbProviderFactories.GetFactory(Application);
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL = String.Empty;
					sSQL = "select *                        " + ControlChars.CrLf
					     + "  from vwPROCESSES_PendingStatus" + ControlChars.CrLf
					     + " where ID = @ID                 " + ControlChars.CrLf;
					using ( DataTable dtProcess = new DataTable() )
					{
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID", gPENDING_PROCESS_ID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dtProcess);
							}
						}
						if ( dtProcess.Rows.Count > 0 )
						{
							DataRow rdrProcess = dtProcess.Rows[0];
							int      nPROCESS_NUMBER               = Sql.ToInteger (rdrProcess["PROCESS_NUMBER"              ]);
							Guid     gBUSINESS_PROCESS_INSTANCE_ID = Sql.ToGuid    (rdrProcess["BUSINESS_PROCESS_INSTANCE_ID"]);
							string   sACTIVITY_INSTANCE            = Sql.ToString  (rdrProcess["ACTIVITY_INSTANCE"           ]);
							string   sACTIVITY_NAME                = Sql.ToString  (rdrProcess["ACTIVITY_NAME"               ]);
							Guid     gBUSINESS_PROCESS_ID          = Sql.ToGuid    (rdrProcess["BUSINESS_PROCESS_ID"         ]);
							string   sBUSINESS_PROCESS_NAME        = Sql.ToString  (rdrProcess["BUSINESS_PROCESS_NAME"       ]);
							Guid     gPROCESS_USER_ID              = Sql.ToGuid    (rdrProcess["PROCESS_USER_ID"             ]);
							string   sBOOKMARK_NAME                = Sql.ToString  (rdrProcess["BOOKMARK_NAME"               ]);
							string   sPARENT_TYPE                  = Sql.ToString  (rdrProcess["PARENT_TYPE"                 ]);
							Guid     gPARENT_ID                    = Sql.ToGuid    (rdrProcess["PARENT_ID"                   ]);
							string   sUSER_TASK_TYPE               = Sql.ToString  (rdrProcess["USER_TASK_TYPE"              ]);
							string   sREAD_ONLY_FIELDS             = Sql.ToString  (rdrProcess["READ_ONLY_FIELDS"            ]);
							string   sREQUIRED_FIELDS              = Sql.ToString  (rdrProcess["REQUIRED_FIELDS"             ]);
							string   sDURATION_UNITS               = Sql.ToString  (rdrProcess["DURATION_UNITS"              ]);
							int      nDURATION_VALUE               = Sql.ToInteger (rdrProcess["DURATION_VALUE"              ]);
							string   sSTATUS                       = Sql.ToString  (rdrProcess["STATUS"                      ]);
							DateTime dtDATE_ENTERED                = Sql.ToDateTime(rdrProcess["DATE_ENTERED"                ]);
							
							sREAD_ONLY_FIELDS = sREAD_ONLY_FIELDS.Replace(" ", "");
							if ( !Sql.IsEmptyString(sREAD_ONLY_FIELDS) && (sSTATUS == "In Progress" || sSTATUS == "Unclaimed") )
							{
								foreach ( string sFIELD_NAME in sREAD_ONLY_FIELDS.Split(',') )
								{
									new DynamicControl(parent, sFIELD_NAME).Enabled = false;
								}
							}
							System.Web.UI.WebControls.Label txtProcessStatus = parent.Page.Master.FindControl("txtProcessStatus") as System.Web.UI.WebControls.Label;
							if ( txtProcessStatus != null )
							{
								string sProcessStatus = sBUSINESS_PROCESS_NAME;
								if ( !Sql.IsEmptyString(sACTIVITY_NAME) )
								{
									sProcessStatus += " | " + sACTIVITY_NAME;
								}
								if ( !Sql.IsEmptyString(sDURATION_UNITS) && nDURATION_VALUE > 0 )
								{
									DateTime dtDUE_DATE = dtDATE_ENTERED;
									switch ( sDURATION_UNITS )
									{
										case "hour"   :  dtDUE_DATE = dtDUE_DATE.AddHours (    nDURATION_VALUE);  break;
										case "day"    :  dtDUE_DATE = dtDUE_DATE.AddDays  (    nDURATION_VALUE);  break;
										case "week"   :  dtDUE_DATE = dtDUE_DATE.AddDays  (7 * nDURATION_VALUE);  break;
										case "month"  :  dtDUE_DATE = dtDUE_DATE.AddMonths(    nDURATION_VALUE);  break;
										case "quarter":  dtDUE_DATE = dtDUE_DATE.AddMonths(3 * nDURATION_VALUE);  break;
										case "year"   :  dtDUE_DATE = dtDUE_DATE.AddYears (    nDURATION_VALUE);  break;
									}
									string sDUE_DATE = dtDUE_DATE.ToString();
									if ( dtDUE_DATE > DateTime.Now )
									{
										sProcessStatus += " [ " + String.Format(L10n.Term("Processes.LBL_DUE_DATE_FORMAT"), sDUE_DATE) + " ]";
									}
									else
									{
										sProcessStatus += " [ <span class=ProcessOverdue>" + String.Format(L10n.Term("Processes.LBL_OVERDUE_FORMAT"), sDUE_DATE) + "</span> ]";
									}
								}
								txtProcessStatus.Visible = true;
								txtProcessStatus.Text    = sProcessStatus;
							}
						}
					}
				}
			}
		}

		public static void ApplyEditViewPreSaveEventRules(HttpApplicationState Application, L10N L10n, string sEDIT_NAME, SplendidControl parent, DataRow row)
		{
			if ( row != null && row.Table.Columns.Contains("PENDING_PROCESS_ID") )
			{
				Guid gPENDING_PROCESS_ID = Sql.ToGuid(row["PENDING_PROCESS_ID"]);
				if ( !Sql.IsEmptyGuid(gPENDING_PROCESS_ID) )
				{
					DbProviderFactory dbf = DbProviderFactories.GetFactory(Application);
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL = String.Empty;
						sSQL = "select *                        " + ControlChars.CrLf
						     + "  from vwPROCESSES_PendingStatus" + ControlChars.CrLf
						     + " where ID = @ID                 " + ControlChars.CrLf;
						using ( DataTable dtProcess = new DataTable() )
						{
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gPENDING_PROCESS_ID);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dtProcess);
								}
							}
							if ( dtProcess.Rows.Count > 0 )
							{
								DataRow rdrProcess = dtProcess.Rows[0];
								int      nPROCESS_NUMBER               = Sql.ToInteger (rdrProcess["PROCESS_NUMBER"              ]);
								Guid     gBUSINESS_PROCESS_INSTANCE_ID = Sql.ToGuid    (rdrProcess["BUSINESS_PROCESS_INSTANCE_ID"]);
								string   sACTIVITY_INSTANCE            = Sql.ToString  (rdrProcess["ACTIVITY_INSTANCE"           ]);
								string   sACTIVITY_NAME                = Sql.ToString  (rdrProcess["ACTIVITY_NAME"               ]);
								Guid     gBUSINESS_PROCESS_ID          = Sql.ToGuid    (rdrProcess["BUSINESS_PROCESS_ID"         ]);
								string   sBUSINESS_PROCESS_NAME        = Sql.ToString  (rdrProcess["BUSINESS_PROCESS_NAME"       ]);
								Guid     gPROCESS_USER_ID              = Sql.ToGuid    (rdrProcess["PROCESS_USER_ID"             ]);
								string   sBOOKMARK_NAME                = Sql.ToString  (rdrProcess["BOOKMARK_NAME"               ]);
								string   sPARENT_TYPE                  = Sql.ToString  (rdrProcess["PARENT_TYPE"                 ]);
								Guid     gPARENT_ID                    = Sql.ToGuid    (rdrProcess["PARENT_ID"                   ]);
								string   sUSER_TASK_TYPE               = Sql.ToString  (rdrProcess["USER_TASK_TYPE"              ]);
								string   sREAD_ONLY_FIELDS             = Sql.ToString  (rdrProcess["READ_ONLY_FIELDS"            ]);
								string   sREQUIRED_FIELDS              = Sql.ToString  (rdrProcess["REQUIRED_FIELDS"             ]);
								string   sSTATUS                       = Sql.ToString  (rdrProcess["STATUS"                      ]);
								
								sREQUIRED_FIELDS = sREQUIRED_FIELDS.Replace(" ", "");
								if ( !Sql.IsEmptyString(sREQUIRED_FIELDS) && (sSTATUS == "In Progress" || sSTATUS == "Unclaimed") )
								{
									DataTable dtFields = SplendidCache.EditViewFields(sEDIT_NAME, Security.PRIMARY_ROLE_NAME).Copy();
									DataView dvFields = new DataView(dtFields);
									foreach ( string sFIELD_NAME in sREQUIRED_FIELDS.Split(',') )
									{
										dvFields.RowFilter = "DATA_FIELD = '" + sFIELD_NAME + "'";
										if ( dvFields.Count > 0 )
										{
											dvFields[0]["UI_REQUIRED"] = 1;
										}
									}
									dtFields.AcceptChanges();
									SplendidDynamic.ValidateEditViewFields(dtFields, sEDIT_NAME, parent);
								}
							}
						}
					}
				}
			}
		}
		*/

		public static void ValidateRequiredFields(SplendidCRM.Crm.Modules Modules, L10N L10n, Guid gPENDING_PROCESS_ID)
		{
			if ( !Sql.IsEmptyGuid(gPENDING_PROCESS_ID) )
			{
				SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL = String.Empty;
					sSQL = "select *                        " + ControlChars.CrLf
					     + "  from vwPROCESSES_PendingStatus" + ControlChars.CrLf
					     + " where ID = @ID                 " + ControlChars.CrLf;
					using ( DataTable dtProcess = new DataTable() )
					{
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID", gPENDING_PROCESS_ID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dtProcess);
							}
						}
						if ( dtProcess.Rows.Count > 0 )
						{
							DataRow rdrProcess = dtProcess.Rows[0];
							int      nPROCESS_NUMBER               = Sql.ToInteger (rdrProcess["PROCESS_NUMBER"              ]);
							Guid     gBUSINESS_PROCESS_INSTANCE_ID = Sql.ToGuid    (rdrProcess["BUSINESS_PROCESS_INSTANCE_ID"]);
							string   sACTIVITY_INSTANCE            = Sql.ToString  (rdrProcess["ACTIVITY_INSTANCE"           ]);
							string   sACTIVITY_NAME                = Sql.ToString  (rdrProcess["ACTIVITY_NAME"               ]);
							Guid     gBUSINESS_PROCESS_ID          = Sql.ToGuid    (rdrProcess["BUSINESS_PROCESS_ID"         ]);
							string   sBUSINESS_PROCESS_NAME        = Sql.ToString  (rdrProcess["BUSINESS_PROCESS_NAME"       ]);
							Guid     gPROCESS_USER_ID              = Sql.ToGuid    (rdrProcess["PROCESS_USER_ID"             ]);
							string   sBOOKMARK_NAME                = Sql.ToString  (rdrProcess["BOOKMARK_NAME"               ]);
							string   sPARENT_TYPE                  = Sql.ToString  (rdrProcess["PARENT_TYPE"                 ]);
							Guid     gPARENT_ID                    = Sql.ToGuid    (rdrProcess["PARENT_ID"                   ]);
							string   sUSER_TASK_TYPE               = Sql.ToString  (rdrProcess["USER_TASK_TYPE"              ]);
							string   sREAD_ONLY_FIELDS             = Sql.ToString  (rdrProcess["READ_ONLY_FIELDS"            ]);
							string   sREQUIRED_FIELDS              = Sql.ToString  (rdrProcess["REQUIRED_FIELDS"             ]);
							string   sSTATUS                       = Sql.ToString  (rdrProcess["STATUS"                      ]);
							
							sREQUIRED_FIELDS = sREQUIRED_FIELDS.Replace(" ", "");
							if ( !Sql.IsEmptyString(sREQUIRED_FIELDS) && (sSTATUS == "In Progress" || sSTATUS == "Unclaimed") )
							{
								using ( DataTable dtCurrent = new DataTable() )
								{
									string sTABLE_NAME = Modules.TableName(sPARENT_TYPE);
									sSQL = "select *                         " + ControlChars.CrLf
									     + "  from vw" + sTABLE_NAME + "_Edit" + ControlChars.CrLf
									     + " where ID = @ID                  " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@ID", gPARENT_ID);
										using ( DbDataAdapter da = dbf.CreateDataAdapter() )
										{
											((IDbDataAdapter)da).SelectCommand = cmd;
											da.Fill(dtCurrent);
										}
									}
									if ( dtCurrent.Rows.Count > 0 )
									{
										StringBuilder sbErrors = new StringBuilder();
										DataRow row = dtCurrent.Rows[0];
										foreach ( string sFIELD_NAME in sREQUIRED_FIELDS.Split(',') )
										{
											if ( dtCurrent.Columns.Contains(sFIELD_NAME) )
											{
												DataColumn col = dtCurrent.Columns[sFIELD_NAME];
												if ( row[sFIELD_NAME] != DBNull.Value )
												{
													switch ( col.DataType.FullName )
													{
														case "System.Single"  :  if ( Sql.ToDouble  (row[sFIELD_NAME]) == 0.0d             ) sbErrors.Append(sFIELD_NAME);  break;
														case "System.Double"  :  if ( Sql.ToDouble  (row[sFIELD_NAME]) == 0.0d             ) sbErrors.Append(sFIELD_NAME);  break;
														case "System.Int16"   :  if ( Sql.ToInteger (row[sFIELD_NAME]) == 0                ) sbErrors.Append(sFIELD_NAME);  break;
														case "System.Int32"   :  if ( Sql.ToInteger (row[sFIELD_NAME]) == 0                ) sbErrors.Append(sFIELD_NAME);  break;
														case "System.Int64"   :  if ( Sql.ToInteger (row[sFIELD_NAME]) == 0                ) sbErrors.Append(sFIELD_NAME);  break;
														case "System.Decimal" :  if ( Sql.ToDecimal (row[sFIELD_NAME]) == Decimal.Zero     ) sbErrors.Append(sFIELD_NAME);  break;
														case "System.DateTime":  if ( Sql.ToDateTime(row[sFIELD_NAME]) == DateTime.MinValue) sbErrors.Append(sFIELD_NAME);  break;
														case "System.Guid"    :  if ( Sql.ToGuid    (row[sFIELD_NAME]) == Guid.Empty       ) sbErrors.Append(sFIELD_NAME);  break;
														case "System.String"  :  if ( Sql.ToString  (row[sFIELD_NAME]) == String.Empty     ) sbErrors.Append(sFIELD_NAME);  break;
													}
												}
												else
												{
													sbErrors.Append(sFIELD_NAME);
												}
											}
											else
											{
												// We are going to ignore the warning that the required field does not exist. 
											}
										}
										if ( sbErrors.Length > 0 )
											throw(new Exception(L10n.Term(".ERR_MISSING_REQUIRED_FIELDS") + " " + sbErrors.ToString()));
									}
								}
							}
						}
					}
				}
			}
		}

		protected override void Execute(NativeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			Sql                  Sql            = app.Sql          ;
			SqlProcs             SqlProcs       = app.SqlProcs     ;
			SplendidError        SplendidError  = app.SplendidError;

			try
			{
				Guid   gBUSINESS_PROCESS_ID     = Guid.Empty;
				Guid   gAUDIT_ID                = Guid.Empty;
				Guid   gPROCESS_USER_ID         = Guid.Empty;
				string sACTIVITY_NAME           = context.GetValue<string>(ACTIVITY_NAME          );
				string sBOOKMARK_NAME           = context.GetValue<string>(BOOKMARK_NAME          );
				string sPARENT_TYPE             = context.GetValue<string>(PARENT_TYPE            );
				Guid   gPARENT_ID               = context.GetValue<Guid  >(PARENT_ID              );
				string sUSER_TASK_TYPE          = context.GetValue<string>(USER_TASK_TYPE         );
				bool   bCHANGE_ASSIGNED_USER    = context.GetValue<bool  >(CHANGE_ASSIGNED_USER   );
				Guid   gCHANGE_ASSIGNED_TEAM_ID = context.GetValue<Guid  >(CHANGE_ASSIGNED_TEAM_ID);
				bool   bCHANGE_PROCESS_USER     = context.GetValue<bool  >(CHANGE_PROCESS_USER    );
				Guid   gCHANGE_PROCESS_TEAM_ID  = context.GetValue<Guid  >(CHANGE_PROCESS_TEAM_ID );
				string sUSER_ASSIGNMENT_METHOD  = context.GetValue<string>(USER_ASSIGNMENT_METHOD );
				Guid   gSTATIC_ASSIGNED_USER_ID = context.GetValue<Guid  >(STATIC_ASSIGNED_USER_ID);
				Guid   gDYNAMIC_PROCESS_TEAM_ID = context.GetValue<Guid  >(DYNAMIC_PROCESS_TEAM_ID);
				Guid   gDYNAMIC_PROCESS_ROLE_ID = context.GetValue<Guid  >(DYNAMIC_PROCESS_ROLE_ID);
				string sREAD_ONLY_FIELDS        = context.GetValue<string>(READ_ONLY_FIELDS       );
				string sREQUIRED_FIELDS         = context.GetValue<string>(REQUIRED_FIELDS        );
				string sDURATION_UNITS          = context.GetValue<string>(DURATION_UNITS         );
				int    nDURATION_VALUE          = context.GetValue<int   >(DURATION_VALUE         );
				
				WorkflowDataContext dc = context.DataContext;
				PropertyDescriptorCollection properties = dc.GetProperties();
				foreach ( PropertyDescriptor property in dc.GetProperties() )
				{
					if ( property.Name == "BUSINESS_PROCESS_ID" )
					{
						gBUSINESS_PROCESS_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "AUDIT_ID" )
					{
						gAUDIT_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "PROCESS_USER_ID" )
					{
						gPROCESS_USER_ID = Sql.ToGuid(property.GetValue(dc));
					}
				}
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					try
					{
						string sSQL                 = String.Empty;
						string sTABLE_NAME          = Sql.ToString(app.Application["Modules." + sPARENT_TYPE + ".TableName"]);
						bool   bEnableTeamHierarchy = Sql.ToBoolean(app.Application["CONFIG.enable_team_hierarchy"]);
						switch ( sUSER_ASSIGNMENT_METHOD )
						{
							case "Current Process User":
								// 08/13/2016 Paul.  If the process user is empty, then use the assigned user. 
								if ( Sql.IsEmptyGuid(gPROCESS_USER_ID) )
								{
									sSQL = "select ASSIGNED_USER_ID  " + ControlChars.CrLf
									     + "  from vw" + sTABLE_NAME   + ControlChars.CrLf
									     + " where ID = @ID          " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@ID", gPARENT_ID);
										gPROCESS_USER_ID = Sql.ToGuid(cmd.ExecuteScalar());
										if ( Sql.IsEmptyGuid(gPROCESS_USER_ID) )
											gPROCESS_USER_ID = new Guid("00000000-0000-0000-0000-000000000001");
									}
								}
								break;
							case "Record Owner":
								sSQL = "select ASSIGNED_USER_ID  " + ControlChars.CrLf
								     + "  from vw" + sTABLE_NAME   + ControlChars.CrLf
								     + " where ID = @ID          " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@ID", gPARENT_ID);
									Guid gASSIGNED_USER_ID = Sql.ToGuid(cmd.ExecuteScalar());
									if ( !Sql.IsEmptyGuid(gASSIGNED_USER_ID) )
										gPROCESS_USER_ID = gASSIGNED_USER_ID;
								}
								break;
							case "Supervisor":
								sSQL = "select (select REPORTS_TO_ID from vwUSERS where ID = ASSIGNED_USER_ID) as ASSIGNED_USER_ID" + ControlChars.CrLf
								     + "  from vw" + sTABLE_NAME   + ControlChars.CrLf
								     + " where ID = @ID          " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@ID", gPARENT_ID);
									Guid gASSIGNED_USER_ID = Sql.ToGuid(cmd.ExecuteScalar());
									if ( !Sql.IsEmptyGuid(gASSIGNED_USER_ID) )
										gPROCESS_USER_ID = gASSIGNED_USER_ID;
								}
								break;
							case "Static User":
								if ( !Sql.IsEmptyGuid(gSTATIC_ASSIGNED_USER_ID) )
									gPROCESS_USER_ID = gSTATIC_ASSIGNED_USER_ID;
								break;
							case "Self-Service Team":
								if ( !Sql.IsEmptyGuid(gDYNAMIC_PROCESS_TEAM_ID) )
									gPROCESS_USER_ID = Guid.Empty;
								break;
							case "Self-Service Role":
								if ( !Sql.IsEmptyGuid(gDYNAMIC_PROCESS_ROLE_ID) )
									gPROCESS_USER_ID = Guid.Empty;
								break;
							case "Round Robin Team":
								if ( !Sql.IsEmptyGuid(gDYNAMIC_PROCESS_TEAM_ID) )
									Workflow4Utils.NextDynamicTeam(Sql, SqlProcs, con, bEnableTeamHierarchy, gBUSINESS_PROCESS_ID, gDYNAMIC_PROCESS_TEAM_ID, ref gPROCESS_USER_ID);
								break;
							case "Round Robin Role":
								if ( !Sql.IsEmptyGuid(gDYNAMIC_PROCESS_ROLE_ID) )
									Workflow4Utils.NextDynamicRole(Sql, SqlProcs, con, gBUSINESS_PROCESS_ID, gDYNAMIC_PROCESS_ROLE_ID, ref gPROCESS_USER_ID);
								break;
						}
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spPROCESSES_InsertOnly
									( context.WorkflowInstanceId
									, context.ActivityInstanceId  // This is a string. 
									, sACTIVITY_NAME          
									, gBUSINESS_PROCESS_ID    
									, gPROCESS_USER_ID        
									, sBOOKMARK_NAME          
									, sPARENT_TYPE            
									, gPARENT_ID              
									, sUSER_TASK_TYPE         
									, bCHANGE_ASSIGNED_USER   
									, gCHANGE_ASSIGNED_TEAM_ID
									, bCHANGE_PROCESS_USER    
									, gCHANGE_PROCESS_TEAM_ID 
									, sUSER_ASSIGNMENT_METHOD 
									, gSTATIC_ASSIGNED_USER_ID
									, gDYNAMIC_PROCESS_TEAM_ID
									, gDYNAMIC_PROCESS_ROLE_ID
									, sREAD_ONLY_FIELDS       
									, sREQUIRED_FIELDS        
									, sDURATION_UNITS         
									, nDURATION_VALUE         
									, trn
									);
								trn.Commit();
							}
							catch
							{
								trn.Rollback();
								throw;
							}
						}
						Bookmark bm = context.CreateBookmark(sBOOKMARK_NAME, OnBookmarkContinue);
					}
					catch(Exception ex)
					{
						SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
						throw(new Exception("WF4ApprovalActivity failed: " + ex.Message, ex));
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WF4ApprovalActivity.Execute failed: " + ex.Message, ex));
			}
		}

		private void OnBookmarkContinue(NativeActivityContext context, Bookmark bookmark, object state)
		{
			WF4ApprovalResponse resp = state as WF4ApprovalResponse;
			if ( resp != null )
			{
				Guid   gAPPROVAL_USER_ID  = resp.USER_ID ;
				string sAPPROVAL_RESPONSE = resp.RESPONSE;
				context.SetValue<string>(APPROVAL_RESPONSE, sAPPROVAL_RESPONSE);
				if ( sAPPROVAL_RESPONSE == "Cancel" )
				{
					context.Abort(new Exception("User Cancelled"));
				}
			}
		}
	}

}
