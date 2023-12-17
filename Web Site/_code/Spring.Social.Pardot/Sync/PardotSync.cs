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
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Web;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;
using SplendidCRM;

namespace Spring.Social.Pardot
{
	public class PardotSync
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private SyncError            SyncError          ;

		public  static bool bInsideSyncAll      = false;
		public  static bool bInsideCompanies    = false;
		public  static bool bInsideContacts     = false;

		public PardotSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
		}

		public bool PardotEnabled()
		{
			bool bPardotEnabled = Sql.ToBoolean(Application["CONFIG.Pardot.Enabled"]);
			if ( bPardotEnabled )
			{
				string sApiAppId    = Sql.ToString(Application["CONFIG.Pardot.ApiUserKey"            ]);
				string sApiUsername = Sql.ToString(Application["CONFIG.Pardot.ApiUsername"           ]);
				string sApiPassword = Sql.ToString(Application["CONFIG.Pardot.ApiPassword"           ]);
				bPardotEnabled = !Sql.IsEmptyString(sApiAppId) && !Sql.IsEmptyString(sApiUsername) && !Sql.IsEmptyString(sApiPassword);
			}
			return bPardotEnabled;
		}

		public Guid PardotUserID()
		{
			Guid gPardot_USER_ID = Sql.ToGuid(Application["CONFIG.Pardot.UserID"]);
			if ( Sql.IsEmptyGuid(gPardot_USER_ID) )
				gPardot_USER_ID = new Guid("00000000-0000-0000-0000-00000000000F");  // Use special Pardot user. 
			return gPardot_USER_ID;
		}

		public Spring.Social.Pardot.Api.IPardot CreateApi()
		{
			Guid   gCREDIT_CARD_KEY = Sql.ToGuid  (Application["CONFIG.CreditCardKey"     ]);
			Guid   gCREDIT_CARD_IV  = Sql.ToGuid  (Application["CONFIG.CreditCardIV"      ]);
			string sApiUserKey      = Sql.ToString(Application["CONFIG.Pardot.ApiUserKey" ]);
			string sApiUsername     = Sql.ToString(Application["CONFIG.Pardot.ApiUsername"]);
			string sApiPassword     = Sql.ToString(Application["CONFIG.Pardot.ApiPassword"]);
			sApiPassword = Security.DecryptPassword(sApiPassword, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
			
			Spring.Social.Pardot.Connect.PardotServiceProvider pardotServiceProvider = new Spring.Social.Pardot.Connect.PardotServiceProvider(sApiUserKey);
			string sAccessToken = pardotServiceProvider.GetAccessToken(sApiUsername, sApiPassword);
			Spring.Social.Pardot.Api.IPardot pardot = pardotServiceProvider.GetApi(sAccessToken);
			return pardot;
		}

		public bool ValidatePardot(string sApiUserKey, string sApiUsername, string sApiPassword, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Guid   gCREDIT_CARD_KEY = Sql.ToGuid  (Application["CONFIG.CreditCardKey"       ]);
				Guid   gCREDIT_CARD_IV  = Sql.ToGuid  (Application["CONFIG.CreditCardIV"        ]);
				sApiPassword = Security.DecryptPassword(sApiPassword, gCREDIT_CARD_KEY, gCREDIT_CARD_IV);
				
				Spring.Social.Pardot.Connect.PardotServiceProvider pardotServiceProvider = new Spring.Social.Pardot.Connect.PardotServiceProvider(sApiUserKey);
				string sAccessToken = pardotServiceProvider.GetAccessToken(sApiUsername, sApiPassword);
				Spring.Social.Pardot.Api.IPardot pardot = pardotServiceProvider.GetApi(sAccessToken);
				pardot.ProspectOperations.Validate();
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		public bool ValidatePardot(StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.Pardot.Api.IPardot pardot = this.CreateApi();
				pardot.ProspectOperations.Validate();
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

#pragma warning disable CS1998
		public async ValueTask Sync(CancellationToken token)
		{
			Sync();
		}
#pragma warning restore CS1998

		public void Sync()
		{
			Sync(false);
		}

#pragma warning disable CS1998
		public async ValueTask SyncAll(CancellationToken token)
		{
			SyncAll();
		}
#pragma warning restore CS1998

		public void SyncAll()
		{
			Sync(true);
		}

		public void Sync(bool bSyncAll)
		{
			bool bPardotEnabled = PardotEnabled();
			if ( !bInsideSyncAll && bPardotEnabled )
			{
				bInsideSyncAll = true;
				try
				{
					StringBuilder sbErrors = new StringBuilder();
					Guid gPardot_USER_ID = this.PardotUserID();
					Pardot.UserSync User = new Pardot.UserSync(Session, Security, SplendidError, ExchangeSecurity, SyncError, this, gPardot_USER_ID, bSyncAll);
					Sync(User, sbErrors);
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
				finally
				{
					bInsideSyncAll = false;
				}
			}
		}

		public void Sync(Pardot.UserSync User, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Pardot.VerboseStatus"]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "PardotSync.Sync Start.");
			
			Spring.Social.Pardot.Api.IPardot pardot = this.CreateApi();
			if ( pardot != null )
			{
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					try
					{
						con.Open();
						
						string sSYNC_MODULES = Sql.ToString(Application["CONFIG.Pardot.SyncModules"]);
						if ( sSYNC_MODULES == "Contacts" )
						{
							Pardot.Contact contact = new Pardot.Contact(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, pardot);
							if ( !bInsideContacts )
							{
								try
								{
									bInsideContacts = true;
									Sync(dbf, con, User, contact, sbErrors);
								}
								finally
								{
									bInsideContacts = false;
								}
							}
						}
						else if ( sSYNC_MODULES == "Leads" )
						{
							Pardot.Lead lead = new Pardot.Lead(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, pardot);
							if ( !bInsideContacts )
							{
								try
								{
									bInsideContacts = true;
									Sync(dbf, con, User, lead, sbErrors);
								}
								finally
								{
									bInsideContacts = false;
								}
							}
						}
						else if ( sSYNC_MODULES == "Prospects" )
						{
							Pardot.Prospect prospect = new Pardot.Prospect(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, pardot);
							if ( !bInsideContacts )
							{
								try
								{
									bInsideContacts = true;
									Sync(dbf, con, User, prospect, sbErrors);
								}
								finally
								{
									bInsideContacts = false;
								}
							}
						}
					}
					catch(Exception ex)
					{
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
						SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
						sbErrors.AppendLine(Utils.ExpandException(ex));
					}
					finally
					{
						if ( bVERBOSE_STATUS )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "PardotSync.Sync Done.");
					}
				}
			}
		}

		public void Sync(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Pardot.UserSync User, Pardot.HObject qo, StringBuilder sbErrors)
		{
			ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
			Guid gUSER_ID = User.USER_ID;
			bool bSyncAll = User.SyncAll;
			
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Pardot.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.Pardot.ConflictResolution"]);
			string sDIRECTION           = Sql.ToString (Application["CONFIG.Pardot.Direction"         ]);
			// 03/09/2015 Paul.  Establish maximum number of records to process at one time. 
			int    nMAX_RECORDS         = Sql.ToInteger(Application["CONFIG.Pardot.MaxRecords"        ]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			if ( sDIRECTION.ToLower().StartsWith("bi") )
				sDIRECTION = "bi-directional";
			else if ( sDIRECTION.ToLower().StartsWith("to crm"  ) || sDIRECTION.ToLower().StartsWith("from Pardot") )
				sDIRECTION = "to crm only";
			else if ( sDIRECTION.ToLower().StartsWith("from crm") || sDIRECTION.ToLower().StartsWith("to Pardot"  ) )
				sDIRECTION = "from crm only";
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: " + sDIRECTION);
			try
			{
				string sSQL = String.Empty;
				DateTime dtStartModifiedDate = DateTime.MinValue;
				if ( !bSyncAll )
				{
					sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
					     + "  from vw" + qo.CRMTableName + "_SYNC                " + ControlChars.CrLf
					     + " where SYNC_SERVICE_NAME     = N'Pardot'             " + ControlChars.CrLf
					     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
						DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(cmd.ExecuteScalar());
						if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
							dtStartModifiedDate = dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.ToLocalTime().AddSeconds(1);
					}
				}
				
				DateTime dtStartSelect = DateTime.Now;
				IList<Spring.Social.Pardot.Api.Prospect> lst = qo.SelectModified(dtStartModifiedDate);
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: Query took " + (DateTime.Now - dtStartSelect).Seconds.ToString() + " seconds. Using last modified " + dtStartModifiedDate.ToString());
				if ( lst.Count > 0 )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: " + lst.Count.ToString() + " " + qo.PardotTableName + " to import.");
				// 05/31/2012 Paul.  Sorting should not be necessary as the order of the line items should match the display order. 
				foreach ( Spring.Social.Pardot.Api.Prospect qb in lst )
				{
					qo.SetFromPardot(qb.id.ToString());
					bool bImported = qo.Import(Session, con, gUSER_ID, sDIRECTION, sbErrors);
				}
				// 07/23/2017 Paul.  Deleted requires a separate query. 
				IList<Spring.Social.Pardot.Api.Prospect> lstDeleted = qo.SelectDeleted(dtStartModifiedDate);
				if ( lstDeleted.Count > 0 )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: " + lstDeleted.Count.ToString() + " " + qo.PardotTableName + " to delete.");
				foreach ( Spring.Social.Pardot.Api.Prospect qb in lstDeleted )
				{
					qo.SetFromPardot(qb.id.ToString());
					qo.Deleted = true;
					bool bImported = qo.Import(Session, con, gUSER_ID, sDIRECTION, sbErrors);
				}
				
				// 07/03/2014 Paul.  Some of the views exceed 30 characters, so this will not support Oracle. 
				// 01/27/2015 Paul.  View name changed so as to support Oracle. 
				sSQL = "select vw" + qo.CRMTableName + ".*                                                                   " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_ID                                                        " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_REMOTE_KEY                                                " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                   " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                  " + ControlChars.CrLf
				     + "  from            " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_Pardot") + "  vw" + qo.CRMTableName + ControlChars.CrLf
				     + "  left outer join vw" + qo.CRMTableName + "_SYNC                                                     " + ControlChars.CrLf
				     + "               on vw" + qo.CRMTableName + "_SYNC.SYNC_SERVICE_NAME     = N'Pardot'                   " + ControlChars.CrLf
				     + "              and vw" + qo.CRMTableName + "_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID      " + ControlChars.CrLf
				     + "              and vw" + qo.CRMTableName + "_SYNC.SYNC_LOCAL_ID         = vw" + qo.CRMTableName + ".ID" + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
					ExchangeSecurity.Filter(Session, cmd, gUSER_ID, qo.CRMModuleName, "view");
						
					// 03/28/2010 Paul.  All that is important is that the current date is greater than the last sync date. 
					cmd.CommandText += "   and (    vw" + qo.CRMTableName + "_SYNC.ID is null" + ControlChars.CrLf;
					cmd.CommandText += "         or vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC > vw" + qo.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC" + ControlChars.CrLf;
					cmd.CommandText += "       )" + ControlChars.CrLf;
					if ( !Sql.IsEmptyString(qo.CRMTableSort) )
						cmd.CommandText += " order by vw" + qo.CRMTableName + "." + qo.CRMTableSort + ControlChars.CrLf;
					else
						cmd.CommandText += " order by vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC" + ControlChars.CrLf;
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							if ( nMAX_RECORDS > 0 )
								Sql.LimitResults(cmd, nMAX_RECORDS);
							da.Fill(dt);
							if ( dt.Rows.Count > 0 && !qo.IsReadOnly )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to send.");
							// 02/02/2015 Paul.  TaxRates are read only. 
							for ( int i = 0; i < dt.Rows.Count && !qo.IsReadOnly; i++ )
							{
								DataRow row = dt.Rows[i];
								Guid     gID                             = Sql.ToGuid    (row["ID"                           ]);
								Guid     gASSIGNED_USER_ID               = (qo.CRMAssignedUser ? Sql.ToGuid(row["ASSIGNED_USER_ID"]) : Guid.Empty);
								Guid     gSYNC_ID                        = Sql.ToGuid    (row["SYNC_ID"                      ]);
								string   sSYNC_REMOTE_KEY                = Sql.ToString  (row["SYNC_REMOTE_KEY"              ]);
								DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
								DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
								DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
								string   sSYNC_ACTION                    = Sql.IsEmptyGuid(gSYNC_ID) ? "local new" : "local changed";
#if !DEBUG
								if ( SplendidInit.bEnableACLFieldSecurity )
								{
									bool bApplyACL = false;
									foreach ( DataColumn col in dt.Columns )
									{
										Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, qo.CRMModuleName, col.ColumnName, gASSIGNED_USER_ID);
										if ( !acl.IsReadable() )
										{
											row[col.ColumnName] = DBNull.Value;
											bApplyACL = true;
										}
									}
									if ( bApplyACL )
										dt.AcceptChanges();
								}
#endif
								// 02/01/2014 Paul.  Reset in Sync() not in SetFromCRM. 
								qo.Reset();
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
									{
										// 05/18/2012 Paul.  Allow control of sync direction. 
										if (sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: Sending new " + qo.PardotTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											qo.SetFromCRM(String.Empty, row, sbChanges);
											sSYNC_REMOTE_KEY = qo.Insert();
										}
									}
									else
									{
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: Binding " + qo.PardotTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											
										try
										{
											qo.Get(sSYNC_REMOTE_KEY);
											// 03/28/2010 Paul.  We need to double-check for conflicts. 
											// 03/26/2011 Paul.  Updated is in local time. 
											DateTime dtREMOTE_DATE_MODIFIED     = qo.TimeModified;
											DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
											// 03/26/2011 Paul.  The Pardot remote date can vary by 1 millisecond, so check for local change first. 
											if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
											{
												if ( sCONFLICT_RESOLUTION == "remote" )
												{
													// 03/24/2010 Paul.  Remote is the winner of conflicts. 
													sSYNC_ACTION = "remote changed";
												}
												else if ( sCONFLICT_RESOLUTION == "local" )
												{
													// 03/24/2010 Paul.  Local is the winner of conflicts. 
													sSYNC_ACTION = "local changed";
												}
												// 03/26/2011 Paul.  The Pardot remote date can vary by 1 millisecond, so check for local change first. 
												else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
												{
													// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
													sSYNC_ACTION = "local changed";
												}
												else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
												{
													// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
													sSYNC_ACTION = "remote changed";
												}
												else
												{
													sSYNC_ACTION = "prompt change";
												}
											}
											if ( qo.Deleted )
											{
												sSYNC_ACTION = "remote deleted";
											}
										}
										catch(Exception ex)
										{
											string sError = "Error retrieving Pardot " + qo.PardotTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
											sError += Utils.ExpandException(ex) + ControlChars.CrLf;
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											sbErrors.AppendLine(sError);
											// 02/04/2015 Paul.  If there is an error, don't treat as remote delete, treat as unsync. 
											sSYNC_ACTION = "remote unsync";
										}
										if ( sSYNC_ACTION == "local changed" )
										{
											// 05/18/2012 Paul.  Allow control of sync direction. 
											if (sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
											{
												qo.SetFromCRM(sSYNC_REMOTE_KEY, row, sbChanges);
												if ( bVERBOSE_STATUS )
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: Sending " + qo.PardotTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ". " + sbChanges.ToString());
												qo.Update();
											}
										}
									}
									if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
									{
										if ( !Sql.IsEmptyString(qo.ID) )
										{
											// 03/25/2010 Paul.  Update the modified date after the save. 
											// 03/26/2011 Paul.  Updated is in local time. 
											DateTime dtREMOTE_DATE_MODIFIED     = qo.TimeModified;
											DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to set the Sync flag. 
													// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													// 02/19/2015 Paul. Item has not changed, no need to call update procedure. 
													// qo.ProcedureUpdated(gID, sSYNC_REMOTE_KEY, trn, gUSER_ID);
													
													IDbCommand spSyncUpdate = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_SYNC_Update");
													spSyncUpdate.Transaction = trn;
													Sql.SetParameter(spSyncUpdate, "@MODIFIED_USER_ID"        , gUSER_ID                  );
													Sql.SetParameter(spSyncUpdate, "@ASSIGNED_USER_ID"        , gUSER_ID                  );
													Sql.SetParameter(spSyncUpdate, "@LOCAL_ID"                , gID                       );
													Sql.SetParameter(spSyncUpdate, "@REMOTE_KEY"              , sSYNC_REMOTE_KEY          );
													Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED"    , dtREMOTE_DATE_MODIFIED    );
													Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED_UTC", dtREMOTE_DATE_MODIFIED_UTC);
													Sql.SetParameter(spSyncUpdate, "@SERVICE_NAME"            , "Pardot"        );
													Sql.SetParameter(spSyncUpdate, "@RAW_CONTENT"             , qo.RawContent             );
													spSyncUpdate.ExecuteNonQuery();
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
									// 02/04/2015 Paul.  If there is an error, don't treat as remote delete, treat as unsync. 
									else if ( sSYNC_ACTION == "remote deleted" || sSYNC_ACTION == "remote unsync" )
									{
										// 08/05/2014 Paul.  Deletes should follow the same direction rules. 
										if (sDIRECTION == "bi-directional" || sDIRECTION == "to crm only" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: Deleting " + qo.CRMTableName + " " + Sql.ToString(row["NAME"]) + ".");
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													IDbCommand spSyncDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_SYNC_Delete");
													spSyncDelete.Transaction = trn;
													Sql.SetParameter(spSyncDelete, "@MODIFIED_USER_ID", gUSER_ID        );
													Sql.SetParameter(spSyncDelete, "@ASSIGNED_USER_ID", gUSER_ID        );
													Sql.SetParameter(spSyncDelete, "@LOCAL_ID"        , gID             );
													Sql.SetParameter(spSyncDelete, "@REMOTE_KEY"      , sSYNC_REMOTE_KEY);
													Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "Pardot"    );
													spSyncDelete.ExecuteNonQuery();
													
													// 02/04/2015 Paul.  If there is an error, don't treat as remote delete, treat as unsync. 
													if ( sSYNC_ACTION == "remote deleted" )
													{
														IDbCommand spDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_Delete");
														spDelete.Transaction = trn;
														Sql.SetParameter(spDelete, "@ID"              , gID           );
														Sql.SetParameter(spDelete, "@MODIFIED_USER_ID", gUSER_ID      );
														spDelete.ExecuteNonQuery();
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
									// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
									string sError = "Error creating Pardot " + qo.PardotTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
									sError += sbChanges.ToString();
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
					}
				}
				
				// 02/06/2015 Paul.  Deleted records will not be returned by the standard query, so we need a special query to look for sync'd records that are no longer availab.e 
				if ( !qo.IsReadOnly )
				{
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = String.Empty;
						cmd.CommandTimeout = 0;
						cmd.CommandText += "select SYNC_ID                                                       " + ControlChars.CrLf;
						cmd.CommandText += "     , SYNC_LOCAL_ID                                                 " + ControlChars.CrLf;
						cmd.CommandText += "     , SYNC_REMOTE_KEY                                               " + ControlChars.CrLf;
						cmd.CommandText += "  from            vw" + qo.CRMTableName + "_SYNC                     " + ControlChars.CrLf;
						cmd.CommandText += "  left outer join (select vw" + qo.CRMTableName + ".ID               " + ControlChars.CrLf;
						cmd.CommandText += "                        , vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC" + ControlChars.CrLf;
						cmd.CommandText += "                     from      vw" + qo.CRMTableName                   + ControlChars.CrLf;
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, qo.CRMModuleName, "view");
						cmd.CommandText += "                  ) vw" + qo.CRMTableName + "                                                " + ControlChars.CrLf;
						cmd.CommandText += "               on vw" + qo.CRMTableName + ".ID = vw" + qo.CRMTableName + "_SYNC.SYNC_LOCAL_ID" + ControlChars.CrLf;
						cmd.CommandText += " where SYNC_SERVICE_NAME     = N'Pardot'                   " + ControlChars.CrLf;
						cmd.CommandText += "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID                " + ControlChars.CrLf;
						cmd.CommandText += "   and vw" + qo.CRMTableName + ".ID is null                          " + ControlChars.CrLf;
						cmd.CommandText += " order by vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC                " + ControlChars.CrLf;
						Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to delete.");
								for ( int i = 0; i < dt.Rows.Count; i++ )
								{
									DataRow row = dt.Rows[i];
									Guid   gID              = Sql.ToGuid  (row["SYNC_LOCAL_ID"  ]);
									string sSYNC_REMOTE_KEY = Sql.ToString(row["SYNC_REMOTE_KEY"]);
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.PardotTableName + ".Sync: Deleting Pardot (" + sSYNC_REMOTE_KEY + "), CRM " + qo.CRMModuleName + "(" + gID.ToString() + ").");

									try
									{
										if ( sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
										{
											qo.Reset();
											qo.ID = sSYNC_REMOTE_KEY;
											qo.Delete();
										}
									}
									catch(Exception ex)
									{
										string sError = "Error deleting Pardot " + qo.PardotTableName + " " + sSYNC_REMOTE_KEY + "." + ControlChars.CrLf;
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
									}
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											IDbCommand spSyncDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_SYNC_Delete");
											spSyncDelete.Transaction = trn;
											Sql.SetParameter(spSyncDelete, "@MODIFIED_USER_ID", gUSER_ID          );
											Sql.SetParameter(spSyncDelete, "@ASSIGNED_USER_ID", gUSER_ID          );
											Sql.SetParameter(spSyncDelete, "@LOCAL_ID"        , gID               );
											Sql.SetParameter(spSyncDelete, "@REMOTE_KEY"      , sSYNC_REMOTE_KEY  );
											Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "Pardot");
											spSyncDelete.ExecuteNonQuery();
											trn.Commit();
										}
										catch(Exception ex)
										{
											trn.Rollback();
											string sError = "Error deleting SYNC record " + qo.CRMTableName + " " + gID.ToString() + "." + ControlChars.CrLf;
											sError += Utils.ExpandException(ex) + ControlChars.CrLf;
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											sbErrors.AppendLine(sError);
										}
									}
								}
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				sbErrors.AppendLine(Utils.ExpandException(ex));
			}
		}
	}
}
