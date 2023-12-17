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
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Users
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Users/ReassignRest.svc")]
	public class ReassignRestController : ControllerBase
	{
		public const string MODULE_NAME = "Users";
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;

		public ReassignRestController(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
		}

		[HttpPost("[action]")]
		public Dictionary<string, object> PreviewRecordAssignments([FromBody] Dictionary<string, object> dict)
		{
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			
			Guid      gTIMEZONE   = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone  T10n        = TimeZone.CreateTimeZone(gTIMEZONE);
			Dictionary<string, object> dictResponse = new Dictionary<string, object>();
			try
			{
				Guid         gUSER_FROM_ID       = Sql.ToGuid(Request.Query["USER_FROM_ID"]);
				Guid         gUSER_TO_ID         = Sql.ToGuid(Request.Query["USER_TO_ID"  ]);
				Guid         gTEAM_ID            = Sql.ToGuid(Request.Query["TEAM_ID"     ]);
				List<string> arrSELECTED_MODULES = new List<string>();
				Dictionary<string, object> dictFilters = new Dictionary<string, object>();
				try
				{
					foreach ( string sName in dict.Keys )
					{
						switch ( sName )
						{
							case "USER_FROM_ID"    :  gUSER_FROM_ID     = Sql.ToGuid   (dict[sName]);  break;
							case "USER_TO_ID"      :  gUSER_TO_ID       = Sql.ToGuid   (dict[sName]);  break;
							case "TEAM_ID"         :  gTEAM_ID          = Sql.ToGuid   (dict[sName]);  break;
							case "filters"         :  dictFilters = dict[sName] as Dictionary<string, object>;  break;
							case "SELECTED_MODULES":
							{
								System.Collections.ArrayList arr = dict[sName] as System.Collections.ArrayList;
								if ( arr != null )
								{
									for ( int i = 0; i < arr.Count; i++ )
									{
										string s =Sql.ToString(arr[i]);
										if ( !Sql.IsEmptyString(s) )
										{
											arrSELECTED_MODULES.Add(s);
										}
									}
									}
								break;
							}
						}
					}
				}
				catch(Exception ex)
				{
					Debug.WriteLine(ex.Message);
					throw;
				}
				if ( arrSELECTED_MODULES.Count == 0 )
				{
					throw(new Exception(L10n.Term("Users.ERR_REASS_SELECT_MODULE")));
				}
				if ( gUSER_FROM_ID == gUSER_TO_ID )
				{
					throw(new Exception(L10n.Term("Users.ERR_REASS_DIFF_USERS")));
				}
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					foreach ( string sMODULE in arrSELECTED_MODULES )
					{
						Dictionary<string, object> dictModule = new Dictionary<string, object>();
						dictResponse.Add(sMODULE, dictModule);
						int nUpdatedRecords = 0;
						string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE + ".TableName"]);
						sSQL = "select count(*)        " + ControlChars.CrLf
						     + "  from vw" + sTABLE_NAME + ControlChars.CrLf
						     + " where ASSIGNED_USER_ID = @ASSIGNED_USER_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ASSIGNED_USER_ID", gUSER_FROM_ID);
							if ( dictFilters.ContainsKey(sMODULE) )
							{
								Dictionary<string, object> dictSearchValues = dictFilters[sMODULE] as Dictionary<string, object>;
								string sSEARCH_VALUES = Sql.SqlSearchClause(dictSearchValues);
								if ( !Sql.IsEmptyString(sSEARCH_VALUES) )
								{
									cmd.CommandText += sSEARCH_VALUES;
								}
							}
							dictModule.Add("__sql", Sql.ExpandParameters(cmd));
							nUpdatedRecords = Sql.ToInteger(cmd.ExecuteScalar());
							try
							{
								// 03/04/2009 Paul.  Perform a check to see if the stored procedure exists. 
								SqlProcs.Factory(con, "sp" + sTABLE_NAME + "_MassAssign");
								string sDISPLAY_NAME = Sql.ToString(L10n.Term(".moduleList.", sMODULE));
								dictModule.Add("Updated", String.Format(L10n.Term("Users.LBL_REASS_WILL_BE_UPDATED"), nUpdatedRecords.ToString(), sDISPLAY_NAME));
							}
							catch ( Exception ex )
							{
								dictModule.Add("Error", ex.Message);
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
			return dictResponse;
		}

		[HttpPost("[action]")]
		public Dictionary<string, object> ApplyRecordAssignments([FromBody] Dictionary<string, object> dict)
		{
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			Guid      gTIMEZONE   = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone  T10n        = TimeZone.CreateTimeZone(gTIMEZONE);
			Dictionary<string, object> dictResponse = new Dictionary<string, object>();
			try
			{
				Guid         gUSER_FROM_ID       = Sql.ToGuid(Request.Query["USER_FROM_ID"]);
				Guid         gUSER_TO_ID         = Sql.ToGuid(Request.Query["USER_TO_ID"  ]);
				Guid         gTEAM_ID            = Sql.ToGuid(Request.Query["TEAM_ID"     ]);
				List<string> arrSELECTED_MODULES = new List<string>();
				Dictionary<string, object> dictFilters = new Dictionary<string, object>();
				try
				{
					foreach ( string sName in dict.Keys )
					{
						switch ( sName )
						{
							case "USER_FROM_ID"    :  gUSER_FROM_ID     = Sql.ToGuid   (dict[sName]);  break;
							case "USER_TO_ID"      :  gUSER_TO_ID       = Sql.ToGuid   (dict[sName]);  break;
							case "TEAM_ID"         :  gTEAM_ID          = Sql.ToGuid   (dict[sName]);  break;
							case "filters"         :  dictFilters = dict[sName] as Dictionary<string, object>;  break;
							case "SELECTED_MODULES":
							{
								System.Collections.ArrayList arr = dict[sName] as System.Collections.ArrayList;
								if ( arr != null )
								{
									for ( int i = 0; i < arr.Count; i++ )
									{
										string s =Sql.ToString(arr[i]);
										if ( !Sql.IsEmptyString(s) )
										{
											arrSELECTED_MODULES.Add(s);
										}
									}
									}
								break;
							}
						}
					}
				}
				catch(Exception ex)
				{
					Debug.WriteLine(ex.Message);
					throw;
				}
				if ( arrSELECTED_MODULES.Count == 0 )
				{
					throw(new Exception(L10n.Term("Users.ERR_REASS_SELECT_MODULE")));
				}
				if ( gUSER_FROM_ID == gUSER_TO_ID )
				{
					throw(new Exception(L10n.Term("Users.ERR_REASS_DIFF_USERS")));
				}
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							foreach ( string sMODULE in arrSELECTED_MODULES )
							{
								Dictionary<string, object> dictModule = new Dictionary<string, object>();
								dictResponse.Add(sMODULE, dictModule);
								int nUpdatedRecords = 0;
								string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE + ".TableName"]);
								sSQL = "select ID              " + ControlChars.CrLf
								     + "  from vw" + sTABLE_NAME + ControlChars.CrLf
								     + " where ASSIGNED_USER_ID = @ASSIGNED_USER_ID" + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									// 01/10/2011 Paul.  Must include the command in the transaction. 
									cmd.Transaction = trn;
									Sql.AddParameter(cmd, "@ASSIGNED_USER_ID", gUSER_FROM_ID);
									if ( dictFilters.ContainsKey(sMODULE) )
									{
										Dictionary<string, object> dictSearchValues = dictFilters[sMODULE] as Dictionary<string, object>;
										string sSEARCH_VALUES = Sql.SqlSearchClause(dictSearchValues);
										if ( !Sql.IsEmptyString(sSEARCH_VALUES) )
										{
											cmd.CommandText += sSEARCH_VALUES;
										}
									}
									dictModule.Add("__sql", Sql.ExpandParameters(cmd));
									try
									{
										System.Collections.Stack stk = new System.Collections.Stack();
										using ( DbDataAdapter da = dbf.CreateDataAdapter() )
										{
											((IDbDataAdapter)da).SelectCommand = cmd;
											using ( DataTable dt = new DataTable() )
											{
												da.Fill(dt);
												nUpdatedRecords = dt.Rows.Count;
												foreach ( DataRow row in dt.Rows )
												{
													stk.Push(Sql.ToString(row["ID"]));
												}
											}
										}
										IDbCommand cmdMassAssign = SqlProcs.Factory(con, "sp" + sTABLE_NAME + "_MassAssign");
										cmdMassAssign.Transaction = trn;
										Sql.SetParameter(cmdMassAssign, "@MODIFIED_USER_ID",  Security.USER_ID);
										Sql.SetParameter(cmdMassAssign, "@ASSIGNED_USER_ID",  gUSER_TO_ID     );
										Sql.SetParameter(cmdMassAssign, "@TEAM_ID"         ,  gTEAM_ID        );
										while ( stk.Count > 0 )
										{
											string sIDs = Utils.BuildMassIDs(stk);
											Sql.SetParameter(cmdMassAssign, "@ID_LIST", sIDs);
											cmdMassAssign.ExecuteNonQuery();
										}
										string sDISPLAY_NAME = Sql.ToString(L10n.Term(".moduleList.", sMODULE));
										dictModule.Add("Updated", String.Format(L10n.Term("Users.LBL_REASS_SUCCESSFUL"), nUpdatedRecords.ToString(), sDISPLAY_NAME));
									}
									catch ( Exception ex )
									{
										dictModule.Add("Error", ex.Message);
									}
								}
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
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
			return dictResponse;
		}
	}
}
