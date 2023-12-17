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
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;
using SplendidCRM;

using Microsoft.AspNetCore.Http;

namespace Spring.Social.HubSpot
{
	public class HubSpotSync
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

		public HubSpotSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
		}

		public bool HubSpotEnabled()
		{
			bool bHubSpotEnabled = Sql.ToBoolean(Application["CONFIG.HubSpot.Enabled"]);
#if DEBUG
			//bHubSpotEnabled = true;
#endif
			if ( bHubSpotEnabled )
			{
				string sClientID         = Sql.ToString(Application["CONFIG.HubSpot.ClientID"        ]);
				string sOAuthAccessToken = Sql.ToString(Application["CONFIG.HubSpot.OAuthAccessToken"]);
				bHubSpotEnabled = !Sql.IsEmptyString(sOAuthAccessToken) && !Sql.IsEmptyString(sClientID);
			}
			return bHubSpotEnabled;
		}

		public Guid HubSpotUserID()
		{
			Guid gHUBSPOT_USER_ID = Sql.ToGuid(Application["CONFIG.HubSpot.UserID"]);
			if ( Sql.IsEmptyGuid(gHUBSPOT_USER_ID) )
				gHUBSPOT_USER_ID = new Guid("00000000-0000-0000-0000-000000000006");  // Use special HubSpot user. 
			return gHUBSPOT_USER_ID;
		}

		public Spring.Social.HubSpot.Api.IHubSpot CreateApi()
		{
			Spring.Social.HubSpot.Api.IHubSpot hubSpot = null;
			string sHubSpotClientID     = Sql.ToString(Application["CONFIG.HubSpot.ClientID"        ]);
			string sHubSpotClientSecret = Sql.ToString(Application["CONFIG.HubSpot.ClientSecret"    ]);
			string sOAuthAccessToken    = Sql.ToString(Application["CONFIG.HubSpot.OAuthAccessToken"]);
			
			Spring.Social.HubSpot.Connect.HubSpotServiceProvider hubSpotServiceProvider = new Spring.Social.HubSpot.Connect.HubSpotServiceProvider(sHubSpotClientID, sHubSpotClientSecret);
			hubSpot = hubSpotServiceProvider.GetApi(sOAuthAccessToken);
			return hubSpot;
		}

		public bool RefreshAccessToken(StringBuilder sbErrors)
		{
			bool bSuccess = false;
			string sHubSpotPortalID     = Sql.ToString(Application["CONFIG.HubSpot.PortalID"         ]);
			string sHubSpotClientID     = Sql.ToString(Application["CONFIG.HubSpot.ClientID"         ]);
			string sHubSpotClientSecret = Sql.ToString(Application["CONFIG.HubSpot.ClientSecret"     ]);
			string sOAuthAccessToken    = Sql.ToString(Application["CONFIG.HubSpot.OAuthAccessToken" ]);
			string sOAuthRefreshToken   = Sql.ToString(Application["CONFIG.HubSpot.OAuthRefreshToken"]);
			string sOAuthExpiresAt      = Sql.ToString(Application["CONFIG.HubSpot.OAuthExpiresAt"   ]);
			try
			{
				DateTime dtOAuthExpiresAt = Sql.ToDateTime(sOAuthExpiresAt);
				// 09/09/2015 Paul.  Need to make sure that a new token is retrieved even if values are null or date has expired. 
				if ( Sql.IsEmptyString(sOAuthAccessToken) || dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now.AddHours(1) > dtOAuthExpiresAt )
				{
					Spring.Social.HubSpot.Connect.HubSpotServiceProvider hubSpotServiceProvider = new Spring.Social.HubSpot.Connect.HubSpotServiceProvider(sHubSpotClientID, sHubSpotClientSecret);
					Spring.Social.OAuth2.OAuth2Parameters parameters = new Spring.Social.OAuth2.OAuth2Parameters();
					hubSpotServiceProvider.OAuthOperations.RefreshAccessAsync(sOAuthRefreshToken, parameters)
						.ContinueWith<Spring.Social.OAuth2.AccessGrant>(task =>
						{
							if ( task.Status == System.Threading.Tasks.TaskStatus.RanToCompletion && task.Result != null )
							{
								DateTime dtExpires = (task.Result.ExpireTime.HasValue ? task.Result.ExpireTime.Value.ToLocalTime() : DateTime.Now.AddHours(8));
								sOAuthAccessToken  = task.Result.AccessToken     ;
								sOAuthRefreshToken = task.Result.RefreshToken    ;
								sOAuthExpiresAt    = dtExpires.ToShortDateString() + " " + dtExpires.ToShortTimeString();
							}
							else
							{
								// 04/27/2015 Paul.  If there is an error, clear the in-memory value only. We want to allow a retry. 
								Application["CONFIG.HubSpot.OAuthAccessToken"] = String.Empty;
								throw(new Exception("Could not refresh HubSpot access token.", task.Exception));
							}
							return null;
						}).Wait();
					
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								Application["CONFIG.HubSpot.OAuthAccessToken"  ] = sOAuthAccessToken ;
								Application["CONFIG.HubSpot.OAuthRefreshToken" ] = sOAuthRefreshToken;
								Application["CONFIG.HubSpot.OAuthExpiresAt"    ] = sOAuthExpiresAt   ;
								SqlProcs.spCONFIG_Update("system", "HubSpot.OAuthAccessToken"  , Sql.ToString(Application["CONFIG.HubSpot.OAuthAccessToken"  ]), trn);
								SqlProcs.spCONFIG_Update("system", "HubSpot.OAuthRefreshToken" , Sql.ToString(Application["CONFIG.HubSpot.OAuthRefreshToken" ]), trn);
								SqlProcs.spCONFIG_Update("system", "HubSpot.OAuthExpiresAt"    , Sql.ToString(Application["CONFIG.HubSpot.OAuthExpiresAt"    ]), trn);
								trn.Commit();
								bSuccess = true;
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
				sbErrors.Append(Utils.ExpandException(ex));
			}
			return bSuccess;
		}

		public bool ValidateHubSpot(string sOAuthPortalID, string sOAuthClientID, string sOAuthClientSecret, string sOAuthAccessToken, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.HubSpot.Api.IHubSpot hubSpot = null;
				Spring.Social.HubSpot.Connect.HubSpotServiceProvider hubSpotServiceProvider = new Spring.Social.HubSpot.Connect.HubSpotServiceProvider(sOAuthClientID, sOAuthClientSecret);
				hubSpot = hubSpotServiceProvider.GetApi(sOAuthAccessToken);
				hubSpot.ContactOperations.GetModified(DateTime.MinValue);
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		public bool ValidateHubSpot(StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.HubSpot.Api.IHubSpot hubSpot = CreateApi();
				hubSpot.ContactOperations.GetAll(String.Empty);
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
			// 02/06/2014 Paul.  New HubSpot factory to allow Remote and Online. 
			bool bHubSpotEnabled = HubSpotEnabled();
			if ( !bInsideSyncAll && bHubSpotEnabled )
			{
				bInsideSyncAll = true;
				try
				{
					StringBuilder sbErrors = new StringBuilder();
					this.RefreshAccessToken(sbErrors);
					if ( sbErrors.Length == 0 )
					{
						Guid gHubSpot_USER_ID = this.HubSpotUserID();
						HubSpot.UserSync User = new HubSpot.UserSync(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, this, gHubSpot_USER_ID, bSyncAll);
						Sync(User, sbErrors);
					}
					else
					{
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Failed to refresh HubSpot Access Token: " + sbErrors.ToString());
					}
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

		private DateTime DefaultCacheExpiration()
		{
			return DateTime.Now.AddHours(12);
		}

		private DataTable ACCOUNTS_SYNC(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Guid gUSER_ID)
		{
			DataTable dt = new DataTable();
			string sSQL = String.Empty;
			// 09/28/2020 Paul.  HubSpot is not returning the associatedcompanyid.  So allow lookup by name. 
			sSQL = "select SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
			     + "     , vwACCOUNTS.NAME                               " + ControlChars.CrLf
			     + "  from            vwACCOUNTS_SYNC                    " + ControlChars.CrLf
			     + "  left outer join vwACCOUNTS                         " + ControlChars.CrLf
			     + "               on vwACCOUNTS.ID = SYNC_LOCAL_ID      " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'HubSpot'            " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dt);
				}
			}
			return dt;
		}

		public void Sync(HubSpot.UserSync User, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.HubSpot.VerboseStatus"]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "HubSpotSync.Sync Start.");
			
			Spring.Social.HubSpot.Api.IHubSpot hubSpot = this.CreateApi();
			if ( hubSpot != null )
			{
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					try
					{
						con.Open();
						
						// 04/28/2015 Paul.  Best practices suggest syncing HubSpot Contacts to CRM Leads.  We are going to make it configurable. 
						// http://lexnetcg.com/blog/inbound-marketing/hubspot-salesforce-integration-best-practices/
						string sSYNC_MODULES = Sql.ToString(Application["CONFIG.HubSpot.SyncModules"]);
						if ( sSYNC_MODULES == "Contacts" )
						{
							HubSpot.Company company = new HubSpot.Company(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, hubSpot);
							if ( !bInsideCompanies )
							{
								try
								{
									bInsideCompanies = true;
									Sync(dbf, con, User, company, sbErrors);
								}
								finally
								{
									bInsideCompanies = false;
								}
							}
							using ( DataTable dtCompanies = ACCOUNTS_SYNC(dbf, con, User.USER_ID) )
							{
								HubSpot.Contact contact = new HubSpot.Contact(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, hubSpot, dtCompanies);
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
						}
						else // if ( sSYNC_MODULES == "Leads" )
						{
							HubSpot.Lead lead = new HubSpot.Lead(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, hubSpot);
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
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "HubSpotSync.Sync Done.");
					}
				}
			}
		}

		public void Sync(SplendidCRM.DbProviderFactory dbf, IDbConnection con, HubSpot.UserSync User, HubSpot.HObject qo, StringBuilder sbErrors)
		{
			ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
			Guid gUSER_ID = User.USER_ID;
			bool bSyncAll = User.SyncAll;
			
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.HubSpot.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.HubSpot.ConflictResolution"]);
			string sDIRECTION           = Sql.ToString (Application["CONFIG.HubSpot.Direction"         ]);
			// 03/09/2015 Paul.  Establish maximum number of records to process at one time. 
			int    nMAX_RECORDS         = Sql.ToInteger(Application["CONFIG.HubSpot.MaxRecords"        ]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			if ( sDIRECTION.ToLower().StartsWith("bi") )
				sDIRECTION = "bi-directional";
			else if ( sDIRECTION.ToLower().StartsWith("to crm"  ) || sDIRECTION.ToLower().StartsWith("from HubSpot") )
				sDIRECTION = "to crm only";
			else if ( sDIRECTION.ToLower().StartsWith("from crm") || sDIRECTION.ToLower().StartsWith("to HubSpot"  ) )
				sDIRECTION = "from crm only";
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: " + sDIRECTION);
			try
			{
				string sSQL = String.Empty;
				DateTime dtStartModifiedDate = DateTime.MinValue;
				if ( !bSyncAll )
				{
					sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
					     + "  from vw" + qo.CRMTableName + "_SYNC                " + ControlChars.CrLf
					     + " where SYNC_SERVICE_NAME     = N'HubSpot'   " + ControlChars.CrLf
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
				IList<Spring.Social.HubSpot.Api.HBase> lst = qo.SelectModified(dtStartModifiedDate);
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: Query took " + (DateTime.Now - dtStartSelect).Seconds.ToString() + " seconds. Using last modified " + dtStartModifiedDate.ToString());
				if ( lst.Count > 0 )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: " + lst.Count.ToString() + " " + qo.HubSpotTableName + " to import.");
				// 05/31/2012 Paul.  Sorting should not be necessary as the order of the line items should match the display order. 
				foreach ( Spring.Social.HubSpot.Api.HBase qb in lst )
				{
					qo.SetFromHubSpot(qb.id.Value);
					bool bImported = qo.Import(Session, con, gUSER_ID, sDIRECTION, sbErrors);
				}
				
				// 07/03/2014 Paul.  Some of the views exceed 30 characters, so this will not support Oracle. 
				// 01/27/2015 Paul.  View name changed so as to support Oracle. 
				sSQL = "select vw" + qo.CRMTableName + ".*                                                                   " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_ID                                                        " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_REMOTE_KEY                                                " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                   " + ControlChars.CrLf
				     + "     , vw" + qo.CRMTableName + "_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                  " + ControlChars.CrLf
				     + "  from            " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_HubSpot") + "  vw" + qo.CRMTableName + ControlChars.CrLf
				     + "  left outer join vw" + qo.CRMTableName + "_SYNC                                                     " + ControlChars.CrLf
				     + "               on vw" + qo.CRMTableName + "_SYNC.SYNC_SERVICE_NAME     = N'HubSpot'         " + ControlChars.CrLf
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
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to send.");
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
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: Sending new " + qo.HubSpotTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											qo.SetFromCRM(String.Empty, row, sbChanges);
											sSYNC_REMOTE_KEY = qo.Insert();
										}
									}
									else
									{
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: Binding " + qo.HubSpotTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											
										try
										{
											qo.Get(sSYNC_REMOTE_KEY);
											// 03/28/2010 Paul.  We need to double-check for conflicts. 
											// 03/26/2011 Paul.  Updated is in local time. 
											DateTime dtREMOTE_DATE_MODIFIED     = qo.TimeModified;
											DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
											// 03/26/2011 Paul.  The HubSpot remote date can vary by 1 millisecond, so check for local change first. 
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
												// 03/26/2011 Paul.  The HubSpot remote date can vary by 1 millisecond, so check for local change first. 
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
											string sError = "Error retrieving HubSpot " + qo.HubSpotTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
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
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: Sending " + qo.HubSpotTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ". " + sbChanges.ToString());
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
													Sql.SetParameter(spSyncUpdate, "@SERVICE_NAME"            , "HubSpot"        );
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
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: Deleting " + qo.CRMTableName + " " + Sql.ToString(row["NAME"]) + ".");
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
													Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "HubSpot"    );
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
									string sError = "Error creating HubSpot " + qo.HubSpotTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
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
						cmd.CommandText += " where SYNC_SERVICE_NAME     = N'HubSpot'                   " + ControlChars.CrLf;
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
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to delete.");
								for ( int i = 0; i < dt.Rows.Count; i++ )
								{
									DataRow row = dt.Rows[i];
									Guid   gID              = Sql.ToGuid  (row["SYNC_LOCAL_ID"  ]);
									string sSYNC_REMOTE_KEY = Sql.ToString(row["SYNC_REMOTE_KEY"]);
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.HubSpotTableName + ".Sync: Deleting HubSpot (" + sSYNC_REMOTE_KEY + "), CRM " + qo.CRMModuleName + "(" + gID.ToString() + ").");

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
										string sError = "Error deleting HubSpot " + qo.HubSpotTableName + " " + sSYNC_REMOTE_KEY + "." + ControlChars.CrLf;
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
											Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "HubSpot");
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
