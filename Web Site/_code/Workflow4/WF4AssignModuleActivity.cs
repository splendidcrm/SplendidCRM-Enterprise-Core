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
using System.Activities;
using System.ComponentModel;
using System.Diagnostics;

namespace SplendidCRM
{
	public class WF4AssignModuleActivity : CodeActivity
	{
		public InArgument<string>  MODULE_NAME             { get; set; }
		public InArgument<string>  OPERATION               { get; set; }
		public InArgument<Guid  >  ID                      { get; set; }
		public InArgument<string>  USER_ASSIGNMENT_METHOD  { get; set; }  // Round Robin Team, Round Robin Role, Static User, Supervisor, 
		public InArgument<Guid  >  STATIC_ASSIGNED_USER_ID { get; set; }
		public InArgument<Guid  >  STATIC_ASSIGNED_TEAM_ID { get; set; }
		public InArgument<Guid  >  DYNAMIC_PROCESS_TEAM_ID { get; set; }
		public InArgument<Guid  >  DYNAMIC_PROCESS_ROLE_ID { get; set; }

		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			Sql                  Sql             = app.Sql            ;
			SqlProcs             SqlProcs        = app.SqlProcs       ;
			SplendidError        SplendidError   = app.SplendidError  ;
			SplendidCache        SplendidCache   = app.SplendidCache  ;
			SplendidDynamic      SplendidDynamic = app.SplendidDynamic;
			try
			{
				Guid   gBUSINESS_PROCESS_ID     = Guid.Empty;
				Guid   gAUDIT_ID                = Guid.Empty;
				Guid   gPROCESS_USER_ID         = Guid.Empty;
				string sMODULE_NAME             = context.GetValue<string>(MODULE_NAME            );
				string sOPERATION               = context.GetValue<string>(OPERATION              );
				Guid   gID                      = context.GetValue<Guid  >(ID                     );
				string sUSER_ASSIGNMENT_METHOD  = context.GetValue<string>(USER_ASSIGNMENT_METHOD );
				Guid   gSTATIC_ASSIGNED_USER_ID = context.GetValue<Guid  >(STATIC_ASSIGNED_USER_ID);
				Guid   gSTATIC_ASSIGNED_TEAM_ID = context.GetValue<Guid  >(STATIC_ASSIGNED_TEAM_ID);
				Guid   gDYNAMIC_PROCESS_TEAM_ID = context.GetValue<Guid  >(DYNAMIC_PROCESS_TEAM_ID);
				Guid   gDYNAMIC_PROCESS_ROLE_ID = context.GetValue<Guid  >(DYNAMIC_PROCESS_ROLE_ID);
				
				string    sTABLE_NAME = Sql.ToString(app.Application["Modules." + sMODULE_NAME + ".TableName"]);
				DataTable dtUPDATE    = new DataTable(sTABLE_NAME);
				
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
				dtUPDATE.Columns.Add("ASSIGNED_USER_ID", typeof(System.Guid));
				
				DataRow row = dtUPDATE.NewRow();
				dtUPDATE.Rows.Add(row);
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL = String.Empty;
					bool   bEnableTeamHierarchy = Sql.ToBoolean(app.Application["CONFIG.enable_team_hierarchy"]);
					Guid   gASSIGNED_USER_ID = Guid.Empty;
					switch ( sUSER_ASSIGNMENT_METHOD )
					{
						case "Supervisor":
							sSQL = "select (select REPORTS_TO_ID from vwUSERS where ID = ASSIGNED_USER_ID) as ASSIGNED_USER_ID" + ControlChars.CrLf
							     + "  from vw" + sTABLE_NAME   + ControlChars.CrLf
							     + " where ID = @ID          " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								gASSIGNED_USER_ID = Sql.ToGuid(cmd.ExecuteScalar());
								if ( Sql.IsEmptyGuid(gASSIGNED_USER_ID) )
									throw(new Exception("User does not have a Supervisor"));
							}
							break;
						case "Static User":
							if ( !Sql.IsEmptyGuid(gSTATIC_ASSIGNED_USER_ID) )
								gASSIGNED_USER_ID = gSTATIC_ASSIGNED_USER_ID;
							else
								throw(new Exception("Static User is not defined"));
							break;
						case "Static Team":
							if ( !Sql.IsEmptyGuid(gSTATIC_ASSIGNED_TEAM_ID) )
							{
								dtUPDATE.Columns.Add("TEAM_ID"      , typeof(System.Guid  ));
								dtUPDATE.Columns.Add("TEAM_SET_LIST", typeof(System.String));
								row["TEAM_ID"      ] = gSTATIC_ASSIGNED_TEAM_ID;
								// 09/07/2016 Paul.  Clear the Team Set List, otherwise the assigned team gets added. 
								row["TEAM_SET_LIST"] = String.Empty;
							}
							else
								throw(new Exception("Static User is not defined"));
							break;
						case "Round Robin Team":
							if ( !Sql.IsEmptyGuid(gDYNAMIC_PROCESS_TEAM_ID) )
							{
								Workflow4Utils.NextDynamicTeam(Sql, SqlProcs, con, bEnableTeamHierarchy, gBUSINESS_PROCESS_ID, gDYNAMIC_PROCESS_TEAM_ID, ref gASSIGNED_USER_ID);
								if ( Sql.IsEmptyGuid(gASSIGNED_USER_ID) )
									throw(new Exception("Round Robin Team did not return a user"));
							}
							else
								throw(new Exception("Round Robin Team is not defined"));
							break;
						case "Round Robin Role":
							if ( !Sql.IsEmptyGuid(gDYNAMIC_PROCESS_ROLE_ID) )
							{
								Workflow4Utils.NextDynamicRole(Sql, SqlProcs, con, gBUSINESS_PROCESS_ID, gDYNAMIC_PROCESS_ROLE_ID, ref gASSIGNED_USER_ID);
								if ( Sql.IsEmptyGuid(gASSIGNED_USER_ID) )
									throw(new Exception("Round Robin Role did not return a user"));
							}
							else
								throw(new Exception("Round Robin Role is not defined"));
							break;
						default:
							throw(new Exception("USER_ASSIGNMENT_METHOD is not defined"));
					}
					row["ASSIGNED_USER_ID"] = gASSIGNED_USER_ID;
					
					DataRow   rowCurrent    = null;
					DataTable dtCurrent     = new DataTable();
					sSQL = "select *                 " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME   + ControlChars.CrLf
					     + " where ID       = @ID    " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@ID", gID);
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							// 11/27/2009 Paul.  It may be useful to log the SQL during errors at this location. 
							try
							{
								da.Fill(dtCurrent);
								if ( dtCurrent.Rows.Count > 0 )
								{
									rowCurrent = dtCurrent.Rows[0];
								}
							}
							catch
							{
								SplendidError.SystemError(new StackTrace(true).GetFrame(0), Sql.ExpandParameters(cmd));
								throw;
							}
						}
						DataTable dtMetadata = SplendidCache.SqlColumns(sTABLE_NAME);
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly(sTABLE_NAME, gBUSINESS_PROCESS_ID, context.WorkflowInstanceId, trn);
								IDbCommand cmdUpdate = null;
								// 11/23/2014 Paul.  NOTE_ATTACHMENTS does not have an _Update procedure.  Fallback to _Insert. 
								try
								{
									if ( sTABLE_NAME.StartsWith("vw") || sTABLE_NAME.StartsWith("VW") )
										cmdUpdate = SqlProcs.Factory(con, "sp" + sTABLE_NAME.Substring(2) + "_Update");
									else
										cmdUpdate = SqlProcs.Factory(con, "sp" + sTABLE_NAME + "_Update");
								}
								catch
								{
									if ( sTABLE_NAME.StartsWith("vw") || sTABLE_NAME.StartsWith("VW") )
										cmdUpdate = SqlProcs.Factory(con, "sp" + sTABLE_NAME.Substring(2) + "_Insert");
									else
										cmdUpdate = SqlProcs.Factory(con, "sp" + sTABLE_NAME + "_Insert");
								}
								cmdUpdate.Transaction = trn;
								foreach ( IDbDataParameter par in cmdUpdate.Parameters )
								{
									string sParameterName = Sql.ExtractDbName(cmdUpdate, par.ParameterName).ToUpper();
									par.Value = DBNull.Value;
								}
								if ( rowCurrent != null )
								{
									// 11/11/2009 Paul.  If the record already exists, then the current values are treated as default values. 
									foreach ( DataColumn col in rowCurrent.Table.Columns )
									{
										IDbDataParameter par = Sql.FindParameter(cmdUpdate, col.ColumnName);
										if ( par != null && String.Compare(col.ColumnName, "DATE_MODIFIED_UTC", true) != 0 )
											par.Value = rowCurrent[col.ColumnName];
									}
								}
								// 09/03/2016 Paul.  The process user is the modified user. 
								if ( !Sql.IsEmptyGuid(gPROCESS_USER_ID) )
								{
									IDbDataParameter par = Sql.FindParameter(cmdUpdate, "MODIFIED_USER_ID");
									if ( par != null )
										par.Value = gPROCESS_USER_ID;
								}
								foreach ( DataColumn col in row.Table.Columns )
								{
									IDbDataParameter par = Sql.FindParameter(cmdUpdate, col.ColumnName);
									if ( par != null )
									{
										switch ( par.DbType )
										{
											case DbType.Date                 :  par.Value = Sql.ToDBDateTime(row[col.ColumnName]);  break;
											case DbType.DateTime             :  par.Value = Sql.ToDBDateTime(row[col.ColumnName]);  break;
											case DbType.Int16                :  par.Value = Sql.ToDBInteger (row[col.ColumnName]);  break;
											case DbType.Int32                :  par.Value = Sql.ToDBInteger (row[col.ColumnName]);  break;
											case DbType.Int64                :  par.Value = Sql.ToDBInteger (row[col.ColumnName]);  break;
											case DbType.UInt16               :  par.Value = Sql.ToDBInteger (row[col.ColumnName]);  break;
											case DbType.UInt32               :  par.Value = Sql.ToDBInteger (row[col.ColumnName]);  break;
											case DbType.UInt64               :  par.Value = Sql.ToDBInteger (row[col.ColumnName]);  break;
											case DbType.Single               :  par.Value = Sql.ToDBFloat   (row[col.ColumnName]);  break;
											case DbType.Double               :  par.Value = Sql.ToDBFloat   (row[col.ColumnName]);  break;
											case DbType.Decimal              :  par.Value = Sql.ToDBDecimal (row[col.ColumnName]);  break;
											case DbType.Currency             :  par.Value = Sql.ToDBDecimal (row[col.ColumnName]);  break;
											case DbType.Boolean              :  par.Value = Sql.ToDBBoolean (row[col.ColumnName]);  break;
											case DbType.Guid                 :  par.Value = Sql.ToDBGuid    (row[col.ColumnName]);  break;
											case DbType.String               :  par.Value = Sql.ToDBString  (row[col.ColumnName]);  break;
											case DbType.StringFixedLength    :  par.Value = Sql.ToDBString  (row[col.ColumnName]);  break;
											case DbType.AnsiString           :  par.Value = Sql.ToDBString  (row[col.ColumnName]);  break;
											case DbType.AnsiStringFixedLength:  par.Value = Sql.ToDBString  (row[col.ColumnName]);  break;
										}
									}
								}
								cmdUpdate.ExecuteScalar();
								IDbDataParameter parID = Sql.FindParameter(cmdUpdate, "@ID");
								if ( parID != null )
								{
									gID = Sql.ToGuid(parID.Value);
									// 08/30/2016 Paul.  The Business Process Engine needs to be able to get the list of custom fields in a background thread. 
									DataTable dtCustomFields = SplendidCache.FieldsMetaData_Validated(sTABLE_NAME);
									SplendidDynamic.UpdateCustomFields(row, trn, gID, sTABLE_NAME, dtCustomFields);
								}
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
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WF4AssignModuleActivity.Execute failed: " + ex.Message, ex));
			}
		}
	}

}
