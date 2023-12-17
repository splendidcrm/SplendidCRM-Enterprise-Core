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
using System.Data;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Text;

namespace SplendidCRM
{
	public class UsersProcessHistoryView
	{
		// 03/20/2020 Paul.  Move code to static function so that it can be called from Rest API for the React Client. 
		public static DataTable GetTable(L10N L10n, Guid gPROCESS_ID, ref string sPROCESS_NUMBER, ref string sPARENT_NAME, StringBuilder sbDumpSQL)
		{
			DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			DataTable dt = new DataTable();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				Guid gBUSINESS_PROCESS_INSTANCE_ID = Guid.Empty;
				sSQL = "select *          " + ControlChars.CrLf
				     + "  from vwPROCESSES" + ControlChars.CrLf
				     + " where ID = @ID   " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gPROCESS_ID);
					sbDumpSQL.Append(Sql.ExpandParameters(cmd));
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							sPROCESS_NUMBER = Sql.ToString(rdr["PROCESS_NUMBER"]);
							sPARENT_NAME    = Sql.ToString(rdr["PARENT_NAME"   ]);
							gBUSINESS_PROCESS_INSTANCE_ID = Sql.ToGuid(rdr["BUSINESS_PROCESS_INSTANCE_ID"]);
						}
					}
				}
				sSQL = "select *                          " + ControlChars.CrLf
					    + "  from vwPROCESSES_HISTORY     " + ControlChars.CrLf
					    + " where BUSINESS_PROCESS_INSTANCE_ID = @BUSINESS_PROCESS_INSTANCE_ID" + ControlChars.CrLf
					    + " order by DATE_ENTERED         " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@BUSINESS_PROCESS_INSTANCE_ID", gBUSINESS_PROCESS_INSTANCE_ID);

					sbDumpSQL.Append(Sql.ExpandParameters(cmd));
					
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						da.Fill(dt);
						dt.Columns.Add("DESCRIPTION"  , typeof(System.String));
						dt.Columns.Add("TIME_FROM_NOW", typeof(System.String));
						if ( dt.Rows.Count > 0 )
						{
							DataRow row = dt.Rows[0];
							sPROCESS_NUMBER = Sql.ToString(row["PROCESS_NUMBER"]);
							sPARENT_NAME    = Sql.ToString(row["PARENT_NAME"   ]);
						}
						foreach ( DataRow row in dt.Rows )
						{
							string sPROCESS_ACTION     = Sql.ToString(row["PROCESS_ACTION"    ]);
							string sCREATED_BY_NAME    = Sql.ToString(row["CREATED_BY_NAME"   ]);
							string sACTIVITY_NAME      = Sql.ToString(row["ACTIVITY_NAME"     ]);
							string sASSIGNED_USER_NAME = Sql.ToString(row["ASSIGNED_USER_NAME"]);
							string sPROCESS_USER_NAME  = Sql.ToString(row["PROCESS_USER_NAME" ]);
							if ( Sql.IsEmptyString(sCREATED_BY_NAME) )
								sCREATED_BY_NAME = "Process Manager";
							// 03/20/2020 Paul.  Create TIME_FROM_NOW as column so that it is easier to render on React Client. 
							TimeSpan ts = DateTime.Now - Sql.ToDateTime(row["DATE_ENTERED"]);
							row["TIME_FROM_NOW"] = Sql.FormatTimeSpan(ts, L10n);
							switch ( sPROCESS_ACTION )
							{
								case "Assign":
									// <b>{0}</b> has been assigned to activity "{1}".
									row["DESCRIPTION"] = String.Format(L10n.Term("Processes.LBL_HISTORY_ASSIGNED_FORMAT"), sCREATED_BY_NAME, sACTIVITY_NAME);
									break;
								case "Approve":
									// <b>{0}</b> has approved activity "{1}".
									row["DESCRIPTION"] = String.Format(L10n.Term("Processes.LBL_HISTORY_APPROVE_FORMAT"), sCREATED_BY_NAME, sACTIVITY_NAME);
									break;
								case "Reject":
									// <b>{0}</b> has rejected activity "{1}".
									row["DESCRIPTION"] = String.Format(L10n.Term("Processes.LBL_HISTORY_REJECT_FORMAT"), sCREATED_BY_NAME, sACTIVITY_NAME);
									break;
								case "Claim":
									// <b>{0}</b> has claimed activity "{1}".
									row["DESCRIPTION"] = String.Format(L10n.Term("Processes.LBL_HISTORY_CLAIM_FORMAT"), sCREATED_BY_NAME, sACTIVITY_NAME);
									break;
								case "Route":
									// <b>{0}</b> has routed activity "{1}".
									row["DESCRIPTION"] = String.Format(L10n.Term("Processes.LBL_HISTORY_ROUTE_FORMAT"), sCREATED_BY_NAME, sACTIVITY_NAME);
									break;
								case "ChangeAssignedUser":
									// <b>{0}</b> has changed the assigned user to <b>{1}</b>.
									row["DESCRIPTION"] = String.Format(L10n.Term("Processes.LBL_HISTORY_CHANGE_ASSIGNED_USER_FORMAT"), sCREATED_BY_NAME, sASSIGNED_USER_NAME);
									break;
								case "ChangeProcessUser":
									// <b>{0}</b> has changed the process user to <b>{1}</b>.
									row["DESCRIPTION"] = String.Format(L10n.Term("Processes.LBL_HISTORY_CHANGE_PROCESS_USER_FORMAT"), sCREATED_BY_NAME, sPROCESS_USER_NAME);
									break;
							}
						}
					}
				}
			}
			return dt;
		}
	}

	public class UsersProcessNotesView
	{
		// 03/20/2020 Paul.  Move code to static function so that it can be called from Rest API for the React Client. 
		public static DataTable GetTable(L10N L10n, Guid gPROCESS_ID, ref string sPROCESS_NUMBER, ref string sPARENT_NAME, StringBuilder sbDumpSQL)
		{
			DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			DataTable dt = new DataTable();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				Guid gBUSINESS_PROCESS_INSTANCE_ID = Guid.Empty;
				sSQL = "select *          " + ControlChars.CrLf
				     + "  from vwPROCESSES" + ControlChars.CrLf
				     + " where ID = @ID   " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gPROCESS_ID);
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							sPROCESS_NUMBER = Sql.ToString(rdr["PROCESS_NUMBER"]);
							sPARENT_NAME    = Sql.ToString(rdr["PARENT_NAME"   ]);
							gBUSINESS_PROCESS_INSTANCE_ID = Sql.ToGuid(rdr["BUSINESS_PROCESS_INSTANCE_ID"]);
						}
					}
				}
				sSQL = "select *                       " + ControlChars.CrLf
				     + "  from vwPROCESSES_NOTES       " + ControlChars.CrLf
				     + " where BUSINESS_PROCESS_INSTANCE_ID = @BUSINESS_PROCESS_INSTANCE_ID" + ControlChars.CrLf
				     + " order by DATE_ENTERED         " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@BUSINESS_PROCESS_INSTANCE_ID", gBUSINESS_PROCESS_INSTANCE_ID);
					
					sbDumpSQL.Append(Sql.ExpandParameters(cmd));
					
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						da.Fill(dt);
						dt.Columns.Add("TIME_FROM_NOW", typeof(System.String));
						foreach ( DataRow row in dt.Rows )
						{
							// 03/20/2020 Paul.  Create TIME_FROM_NOW as column so that it is easier to render on React Client. 
							TimeSpan ts = DateTime.Now - Sql.ToDateTime(row["DATE_ENTERED"]);
							row["TIME_FROM_NOW"] = Sql.FormatTimeSpan(ts, L10n);
						}
					}
				}
			}
			return dt;
		}
	}
}
