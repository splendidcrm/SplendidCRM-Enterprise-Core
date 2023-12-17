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

namespace Spring.Social.Watson
{
	public class WatsonSync
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

		public  static bool bInsideSyncAll       = false;
		public  static bool bInsideProspectLists = false;
		public  static bool bInsideProspects     = false;

		public WatsonSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
		}

		public bool WatsonEnabled()
		{
			bool bWatsonEnabled = Sql.ToBoolean(Application["CONFIG.Watson.Enabled"]);
#if DEBUG
			//bWatsonEnabled = true;
#endif
			if ( bWatsonEnabled )
			{
				string sClientID         = Sql.ToString(Application["CONFIG.Watson.ClientID"        ]);
				string sOAuthAccessToken = Sql.ToString(Application["CONFIG.Watson.OAuthAccessToken"]);
				bWatsonEnabled = !Sql.IsEmptyString(sOAuthAccessToken) && !Sql.IsEmptyString(sClientID);
			}
			return bWatsonEnabled;
		}

		public Guid WatsonUserID()
		{
			Guid gWATSON_USER_ID = Sql.ToGuid(Application["CONFIG.Watson.UserID"]);
			if ( Sql.IsEmptyGuid(gWATSON_USER_ID) )
				gWATSON_USER_ID = new Guid("00000000-0000-0000-0000-000000000010");  // Use special Watson user. 
			return gWATSON_USER_ID;
		}

		public Spring.Social.Watson.Api.IWatson CreateApi()
		{
			Spring.Social.Watson.Api.IWatson Watson = null;
			// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
			// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
			string sWatsonRegion       = Sql.ToString(Application["CONFIG.Watson.Region"          ]);
			string sWatsonPodNumber    = Sql.ToString(Application["CONFIG.Watson.PodNumber"       ]);
			string sWatsonClientID     = Sql.ToString(Application["CONFIG.Watson.ClientID"        ]);
			string sWatsonClientSecret = Sql.ToString(Application["CONFIG.Watson.ClientSecret"    ]);
			string sOAuthAccessToken   = Sql.ToString(Application["CONFIG.Watson.OAuthAccessToken"]);
			
			// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
			// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
			Spring.Social.Watson.Connect.WatsonServiceProvider WatsonServiceProvider = new Spring.Social.Watson.Connect.WatsonServiceProvider(sWatsonClientID, sWatsonClientSecret, sWatsonRegion, sWatsonPodNumber);
			Watson = WatsonServiceProvider.GetApi(sOAuthAccessToken);
			return Watson;
		}

		public bool RefreshAccessToken(StringBuilder sbErrors)
		{
			bool bSuccess = false;
			// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
			// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
			string sWatsonRegion       = Sql.ToString(Application["CONFIG.Watson.Region"           ]);
			string sWatsonPodNumber    = Sql.ToString(Application["CONFIG.Watson.PodNumber"        ]);
			string sWatsonPortalID     = Sql.ToString(Application["CONFIG.Watson.PortalID"         ]);
			string sWatsonClientID     = Sql.ToString(Application["CONFIG.Watson.ClientID"         ]);
			string sWatsonClientSecret = Sql.ToString(Application["CONFIG.Watson.ClientSecret"     ]);
			string sOAuthAccessToken   = Sql.ToString(Application["CONFIG.Watson.OAuthAccessToken" ]);
			string sOAuthRefreshToken  = Sql.ToString(Application["CONFIG.Watson.OAuthRefreshToken"]);
			string sOAuthExpiresAt     = Sql.ToString(Application["CONFIG.Watson.OAuthExpiresAt"   ]);
			try
			{
				DateTime dtOAuthExpiresAt = Sql.ToDateTime(sOAuthExpiresAt);
				// 09/09/2015 Paul.  Need to make sure that a new token is retrieved even if values are null or date has expired. 
				if ( Sql.IsEmptyString(sOAuthAccessToken) || dtOAuthExpiresAt == DateTime.MinValue ||  DateTime.Now.AddHours(1) > dtOAuthExpiresAt )
				{
					// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
					// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
					Spring.Social.Watson.Connect.WatsonServiceProvider watsonServiceProvider = new Spring.Social.Watson.Connect.WatsonServiceProvider(sWatsonClientID, sWatsonClientSecret, sWatsonRegion, sWatsonPodNumber);
					Spring.Social.OAuth2.OAuth2Parameters parameters = new Spring.Social.OAuth2.OAuth2Parameters();
					watsonServiceProvider.OAuthOperations.RefreshAccessAsync(sOAuthRefreshToken, parameters)
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
								Application["CONFIG.Watson.OAuthAccessToken"] = String.Empty;
								throw(new Exception("Could not refresh Watson access token.", task.Exception));
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
								Application["CONFIG.Watson.OAuthAccessToken"  ] = sOAuthAccessToken ;
								Application["CONFIG.Watson.OAuthRefreshToken" ] = sOAuthRefreshToken;
								Application["CONFIG.Watson.OAuthExpiresAt"    ] = sOAuthExpiresAt   ;
								SqlProcs.spCONFIG_Update("system", "Watson.OAuthAccessToken"  , Sql.ToString(Application["CONFIG.Watson.OAuthAccessToken"  ]), trn);
								SqlProcs.spCONFIG_Update("system", "Watson.OAuthRefreshToken" , Sql.ToString(Application["CONFIG.Watson.OAuthRefreshToken" ]), trn);
								SqlProcs.spCONFIG_Update("system", "Watson.OAuthExpiresAt"    , Sql.ToString(Application["CONFIG.Watson.OAuthExpiresAt"    ]), trn);
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

		// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
		// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
		public bool ValidateWatson(string sRegion, string sPodNumber, string sOAuthClientID, string sOAuthClientSecret, string sOAuthAccessToken, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.Watson.Api.IWatson watson = null;
				// 10/02/2020 Paul.  New urls for Acoustic. Region parameter is new. 
				// https://developer.goacoustic.com/acoustic-campaign/reference/overview#getting-started-with-oauth
				Spring.Social.Watson.Connect.WatsonServiceProvider WatsonServiceProvider = new Spring.Social.Watson.Connect.WatsonServiceProvider(sOAuthClientID, sOAuthClientSecret, sRegion, sPodNumber);
				watson = WatsonServiceProvider.GetApi(sOAuthAccessToken);
				watson.ProspectListOperations.GetAll();
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		public bool ValidateWatson(StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.Watson.Api.IWatson watson = CreateApi();
				watson.ProspectListOperations.GetAll();
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
			bool bWatsonEnabled = WatsonEnabled();
			if ( !bInsideSyncAll && bWatsonEnabled )
			{
				bInsideSyncAll = true;
				try
				{
					StringBuilder sbErrors = new StringBuilder();
					this.RefreshAccessToken(sbErrors);
					if ( sbErrors.Length == 0 )
					{
						Guid gWatson_USER_ID = this.WatsonUserID();
						Watson.UserSync User = new Watson.UserSync(Session, Security, SplendidError, ExchangeSecurity, SyncError, this, gWatson_USER_ID, bSyncAll);
						Sync(User, sbErrors);
					}
					else
					{
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Failed to refresh Watson Access Token: " + sbErrors.ToString());
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

		private DataTable PROSPECT_LISTS_SYNC(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Guid gUSER_ID)
		{
			DataTable dt = new DataTable();
			string sSQL = String.Empty;
			sSQL = "select SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
			     + "  from vwPROSPECT_LISTS_SYNC                         " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'Watson'             " + ControlChars.CrLf
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

		private DataTable MergeFields(SplendidCRM.DbProviderFactory dbf, IDbConnection con, string sSYNC_MODULES, string sMERGE_FIELDS)
		{
			DataTable dt = null;
			if ( !Sql.IsEmptyString(sMERGE_FIELDS) )
			{
				string[] arrMERGE_FIELDS = sMERGE_FIELDS.Replace(" ", String.Empty).Split(',');
				Dictionary<string, string> dictMergeFields = new Dictionary<string,string>();
				for ( int i = 0; i < arrMERGE_FIELDS.Length; i++ )
				{
					string[] arrFieldTag = arrMERGE_FIELDS[i].Split(':');
					if ( !dictMergeFields.ContainsKey(arrFieldTag[0]) )
					{
						if ( arrFieldTag.Length > 1 )
							dictMergeFields.Add(arrFieldTag[0], arrFieldTag[1]);
						else
							dictMergeFields.Add(arrFieldTag[0], arrFieldTag[0]);
					}
					arrMERGE_FIELDS[i] = arrFieldTag[0];
				}
				
				dt = new DataTable();
				string sSQL = String.Empty;
				sSQL = "select ColumnName              " + ControlChars.CrLf
				     + "     , CsType                  " + ControlChars.CrLf
				     + "  from vwSqlColumns            " + ControlChars.CrLf
				     + " where ObjectName = @ObjectName" + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 01/31/2018 Paul.  vwPROSPECT_LISTS_RELATED_Watson is the view that is used for contacts, not vwLEADS_Watson. 
					Sql.AddParameter(cmd, "@ObjectName", "VWPROSPECT_LISTS_RELATED_WATSON");
					Sql.AppendParameter(cmd, arrMERGE_FIELDS, "ColumnName");
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						da.Fill(dt);
						dt.Columns.Add("WatsonField", typeof(System.String));
						foreach ( DataRow row in dt.Rows )
						{
							string sColumnName  = Sql.ToString(row["ColumnName"]);
							if ( dictMergeFields.ContainsKey(sColumnName) )
								row["WatsonField"] = dictMergeFields[sColumnName];
							else
								row["WatsonField"] = sColumnName;
						}
					}
				}
			}
			return dt;
		}

		public void Sync(Watson.UserSync User, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Watson.VerboseStatus"]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "WatsonSync.Sync Start.");
			
			Spring.Social.Watson.Api.IWatson watson = this.CreateApi();
			if ( watson != null )
			{
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					try
					{
						con.Open();
						string sSYNC_MODULES = Sql.ToString(Application["CONFIG.Watson.SyncModules"      ]);
						// 02/19/2018 Paul.  Fields are case sensitive in Watson, so we cannot make them upper. 
						string sMERGE_FIELDS = Sql.ToString(Application["CONFIG.Watson.MergeFields"      ]);
						string database_id   = Sql.ToString(Application["CONFIG.Watson.DefaultDatabaseID"]);
						using ( DataTable dtMergeFields = this.MergeFields(dbf, con, sSYNC_MODULES, sMERGE_FIELDS) )
						{
							Watson.ProspectList prospectList = new Watson.ProspectList(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, watson, database_id, dtMergeFields);
							if ( !bInsideProspectLists )
							{
								try
								{
									bInsideProspectLists = true;
									Sync(dbf, con, User, prospectList, sbErrors);
								}
								finally
								{
									bInsideProspectLists = false;
								}
							}
							using ( DataTable dtProspectLists = PROSPECT_LISTS_SYNC(dbf, con, User.USER_ID) )
							{
								if ( !bInsideProspects )
								{
									try
									{
										bInsideProspects = true;
										foreach ( DataRow row in dtProspectLists.Rows )
										{
											string list_id           = Sql.ToString(row["SYNC_REMOTE_KEY"]);
											Guid   gPROSPECT_LIST_ID = Sql.ToGuid  (row["SYNC_LOCAL_ID"  ]);
											List<string> lstWatsonFields = Application["CONFIG.Watson.List.MergeFields." + list_id] as List<string> ;
											if ( lstWatsonFields == null )
											{
												prospectList.id = list_id;
												Spring.Social.Watson.Api.ProspectList obj = watson.ProspectListOperations.GetById(list_id);
												lstWatsonFields = obj.COLUMNS;
												/*
												try
												{
													prospectList.UpdateMergeFields();
												}
												catch(Exception ex)
												{
													SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
													SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
												}
												*/
												Application["CONFIG.Watson.List.MergeFields." + list_id] = lstWatsonFields;
											}
											if ( sSYNC_MODULES == "Contacts" )
											{
												Watson.Contact contact = new Watson.Contact(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, watson, database_id, list_id, gPROSPECT_LIST_ID, dtMergeFields, lstWatsonFields);
												Sync(dbf, con, User, contact, sbErrors);
											}
											else if ( sSYNC_MODULES == "Leads" )
											{
												Watson.Lead lead = new Watson.Lead(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, watson, database_id, list_id, gPROSPECT_LIST_ID, dtMergeFields, lstWatsonFields);
												Sync(dbf, con, User, lead, sbErrors);
											}
											else if ( sSYNC_MODULES == "Prospects" )
											{
												Watson.Prospect prospect = new Watson.Prospect(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, watson, database_id, list_id, gPROSPECT_LIST_ID, dtMergeFields, lstWatsonFields);
												Sync(dbf, con, User, prospect, sbErrors);
											}
										}
									}
									finally
									{
										bInsideProspects = false;
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
					finally
					{
						if ( bVERBOSE_STATUS )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "WatsonSync.Sync Done.");
					}
				}
			}
		}

		public void Sync(SplendidCRM.DbProviderFactory dbf, IDbConnection con, Watson.UserSync User, Watson.HObject qo, StringBuilder sbErrors)
		{
			ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
			Guid gUSER_ID = User.USER_ID;
			bool bSyncAll = User.SyncAll;
			
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Watson.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.Watson.ConflictResolution"]);
			string sDIRECTION           = Sql.ToString (Application["CONFIG.Watson.Direction"         ]);
			int    nMAX_RECORDS         = Sql.ToInteger(Application["CONFIG.Watson.MaxRecords"        ]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			// 02/01/2018 Paul.  Watson does not support bi-directional. 
			//if ( sDIRECTION.ToLower().StartsWith("bi") )
			//	sDIRECTION = "bi-directional";
			//else if ( sDIRECTION.ToLower().StartsWith("to crm"  ) || sDIRECTION.ToLower().StartsWith("from Watson") )
			//	sDIRECTION = "to crm only";
			//else if ( sDIRECTION.ToLower().StartsWith("from crm") || sDIRECTION.ToLower().StartsWith("to Watson"  ) )
				sDIRECTION = "from crm only";
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: " + sDIRECTION);
			try
			{
				string sSQL = String.Empty;
				// 02/16/2017 Paul.  Don't import unless bi-directional or to crm only. 
				if ( sDIRECTION == "bi-directional" || sDIRECTION == "to crm only" )
				{
					DateTime dtStartModifiedDate = DateTime.MinValue;
					if ( !bSyncAll )
					{
						sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
						     + "  from vw" + qo.CRMTableName + "_SYNC                " + ControlChars.CrLf
						     + " where SYNC_SERVICE_NAME     = N'Watson'             " + ControlChars.CrLf
						     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
							if ( qo.IsContact )
							{
								cmd.CommandText += "   and PROSPECT_LIST_ID  = @PROSPECT_LIST_ID" + ControlChars.CrLf;
								Sql.AddParameter(cmd, "@PROSPECT_LIST_ID", qo.PARENT_ID);
								cmd.CommandText += "   and RELATED_TYPE  = @RELATED_TYPE" + ControlChars.CrLf;
								Sql.AddParameter(cmd, "@RELATED_TYPE", qo.CRMModuleName);
							}
							DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(cmd.ExecuteScalar());
							if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
								dtStartModifiedDate = dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.ToLocalTime().AddSeconds(1);
						}
					}
					
					DateTime dtStartSelect = DateTime.Now;
					IList<Spring.Social.Watson.Api.HBase> lst = qo.SelectModified(dtStartModifiedDate);
					if ( bVERBOSE_STATUS )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: Query took " + (DateTime.Now - dtStartSelect).Seconds.ToString() + " seconds. Using last modified " + dtStartModifiedDate.ToString());
					if ( lst.Count > 0 )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: " + lst.Count.ToString() + " " + qo.WatsonTableName + " to import.");
					foreach ( Spring.Social.Watson.Api.HBase qb in lst )
					{
						qo.SetFromWatson(qb.ID);
						bool bImported = qo.Import(Session, con, gUSER_ID, sDIRECTION, sbErrors);
					}
				}

				sSQL = "select vw" + qo.CRMTableName + ".*                                                                                                    " + ControlChars.CrLf
				     + "     , " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_ID                                                        " + ControlChars.CrLf
				     + "     , " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_REMOTE_KEY                                                " + ControlChars.CrLf
				     + "     , " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_LOCAL_DATE_MODIFIED_UTC                                   " + ControlChars.CrLf
				     + "     , " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_REMOTE_DATE_MODIFIED_UTC                                  " + ControlChars.CrLf
				     + "  from            " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_Watson") + "  vw" + qo.CRMTableName                              + ControlChars.CrLf
				     + "  left outer join " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC")                                                           + ControlChars.CrLf
				     + "               on " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_SERVICE_NAME     = N'Watson'                   " + ControlChars.CrLf
				     + "              and " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID      " + ControlChars.CrLf
				     + "              and " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_LOCAL_ID         = vw" + qo.CRMTableName + ".ID" + ControlChars.CrLf;
				// 02/16/2017 Paul.  Need to include PROSPECT_LIST_ID in filter. 
				if ( qo.IsContact )
					sSQL += "              and " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".PROSPECT_LIST_ID      = vw" + qo.CRMTableName + ".PROSPECT_LIST_ID" + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
					// 04/16/2016 Paul.  We will not be using CRM security.  Instead, filter by list type and campaign type. 
					//ExchangeSecurity.Filter(Session, cmd, gUSER_ID, qo.CRMModuleName, "view");
					cmd.CommandText += " where 1 = 1" + ControlChars.CrLf;
					if ( qo.IsContact )
					{
						cmd.CommandText += "   and vw" + qo.CRMTableName + ".PROSPECT_LIST_ID  = @PROSPECT_LIST_ID" + ControlChars.CrLf;
						Sql.AddParameter(cmd, "@PROSPECT_LIST_ID", qo.PARENT_ID);
						cmd.CommandText += "   and vw" + qo.CRMTableName + ".RELATED_TYPE  = @RELATED_TYPE" + ControlChars.CrLf;
						Sql.AddParameter(cmd, "@RELATED_TYPE", qo.CRMModuleName);
					}
					
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
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to send.");
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
								// 04/15/2016 Paul.  Not syncing enough data to justify field security. 
								/*
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
								*/
								qo.Reset();
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
									{
										if (sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
										{
											qo.SetFromCRM(String.Empty, row, sbChanges);
											// 02/16/2017 Paul.  Make sure that member does not exist. 
											if ( !qo.Search() )
											{
												if ( qo.IsContact )
												{
													Guid gRELATED_ID = Sql.ToGuid(row["RELATED_ID"]);
													sSQL = "select SYNC_REMOTE_KEY"                                            + ControlChars.CrLf
													     + "  from " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ControlChars.CrLf
													     + " where SYNC_SERVICE_NAME     = N'Watson'"                          + ControlChars.CrLf
													     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID"             + ControlChars.CrLf
													     + "   and RELATED_ID            = @RELATED_ID"                        + ControlChars.CrLf
													     + " order by SYNC_REMOTE_DATE_MODIFIED"                               + ControlChars.CrLf;
													using ( IDbCommand cmd2 = con.CreateCommand() )
													{
														cmd2.CommandText = sSQL;
														Sql.AddParameter(cmd2, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
														Sql.AddParameter(cmd2, "@RELATED_ID"           , gRELATED_ID);
														Sql.LimitResults(cmd2, 1);
														sSYNC_REMOTE_KEY = Sql.ToString(cmd2.ExecuteScalar());
													}
													if ( Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
													{
														if ( bVERBOSE_STATUS )
															SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: Sending new " + qo.WatsonTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
														sSYNC_REMOTE_KEY = qo.Insert();
													}
													else
													{
														if ( bVERBOSE_STATUS )
															SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: Adding " + qo.WatsonTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + " to " + qo.PARENT_ID.ToString() + ".");
														qo.AddToProspectList(sSYNC_REMOTE_KEY);
													}
												}
												else
												{
													if ( bVERBOSE_STATUS )
														SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: Sending new " + qo.WatsonTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
													sSYNC_REMOTE_KEY = qo.Insert();
												}
											}
											else
											{
												if ( bVERBOSE_STATUS )
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: Rebind " + qo.WatsonTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
												sSYNC_REMOTE_KEY = qo.ID;
											}
										}
									}
									else
									{
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: Binding " + qo.WatsonTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											
										try
										{
											qo.Get(sSYNC_REMOTE_KEY);
											DateTime dtREMOTE_DATE_MODIFIED     = qo.TimeModified;
											DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
											if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
											{
												if ( sCONFLICT_RESOLUTION == "remote" )
												{
													sSYNC_ACTION = "remote changed";
												}
												else if ( sCONFLICT_RESOLUTION == "local" )
												{
													sSYNC_ACTION = "local changed";
												}
												else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
												{
													sSYNC_ACTION = "local changed";
												}
												else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
												{
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
											string sError = "Error retrieving Watson " + qo.WatsonTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
											sError += Utils.ExpandException(ex) + ControlChars.CrLf;
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											sbErrors.AppendLine(sError);
											sSYNC_ACTION = "remote unsync";
										}
										if ( sSYNC_ACTION == "local changed" )
										{
											if (sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
											{
												qo.SetFromCRM(sSYNC_REMOTE_KEY, row, sbChanges);
												if ( bVERBOSE_STATUS )
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: Sending " + qo.WatsonTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ". " + sbChanges.ToString());
												qo.Update();
											}
										}
									}
									if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
									{
										if ( !Sql.IsEmptyString(qo.ID) )
										{
											DateTime dtREMOTE_DATE_MODIFIED     = qo.TimeModified;
											DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													IDbCommand spSyncUpdate = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_SYNC_Update");
													spSyncUpdate.Transaction = trn;
													Sql.SetParameter(spSyncUpdate, "@MODIFIED_USER_ID"        , gUSER_ID                  );
													Sql.SetParameter(spSyncUpdate, "@ASSIGNED_USER_ID"        , gUSER_ID                  );
													Sql.SetParameter(spSyncUpdate, "@LOCAL_ID"                , gID                       );
													Sql.SetParameter(spSyncUpdate, "@REMOTE_KEY"              , sSYNC_REMOTE_KEY          );
													Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED"    , dtREMOTE_DATE_MODIFIED    );
													Sql.SetParameter(spSyncUpdate, "@REMOTE_DATE_MODIFIED_UTC", dtREMOTE_DATE_MODIFIED_UTC);
													Sql.SetParameter(spSyncUpdate, "@SERVICE_NAME"            , "Watson"               );
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
									else if ( sSYNC_ACTION == "remote deleted" || sSYNC_ACTION == "remote unsync" )
									{
										if (sDIRECTION == "bi-directional" || sDIRECTION == "to crm only" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: Deleting " + qo.CRMTableName + " " + Sql.ToString(row["NAME"]) + ".");
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													IDbCommand spSyncDelete = SqlProcs.Factory(con, "sp" + qo.CRMTableName + "_SYNC_Delete");
													spSyncDelete.Transaction = trn;
													Sql.SetParameter(spSyncDelete, "@MODIFIED_USER_ID", gUSER_ID        );
													Sql.SetParameter(spSyncDelete, "@ASSIGNED_USER_ID", gUSER_ID        );
													Sql.SetParameter(spSyncDelete, "@LOCAL_ID"        , gID             );
													Sql.SetParameter(spSyncDelete, "@REMOTE_KEY"      , sSYNC_REMOTE_KEY);
													Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "Watson"    );
													spSyncDelete.ExecuteNonQuery();
													
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
									string sError = "Error creating Watson " + qo.WatsonTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
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
				
				if ( !qo.IsReadOnly )
				{
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = String.Empty;
						cmd.CommandTimeout = 0;
						cmd.CommandText += "select SYNC_ID        " + ControlChars.CrLf;
						cmd.CommandText += "     , SYNC_LOCAL_ID  " + ControlChars.CrLf;
						cmd.CommandText += "     , SYNC_REMOTE_KEY" + ControlChars.CrLf;
						// 02/04/2018 Paul.  To remove from list, we need the email, not the key. 
						cmd.CommandText += "     , vw" + qo.CRMTableName + "." + qo.CRMTableSort + ControlChars.CrLf;
						cmd.CommandText += "  from            " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ControlChars.CrLf;
						// 04/27/2017 Paul.  Must use a separate join to filter all member records (including deleted records). 
						if ( qo.IsContact )
						{
							cmd.CommandText += "       inner join " + qo.CRMTableName.Replace("PROSPECT_LISTS_RELATED", "PROSPECT_LISTS_PROSPECTS") + ControlChars.CrLf;
							cmd.CommandText += "               on " + qo.CRMTableName.Replace("PROSPECT_LISTS_RELATED", "PROSPECT_LISTS_PROSPECTS") + ".ID               = " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_LOCAL_ID" + ControlChars.CrLf;
							cmd.CommandText += "              and " + qo.CRMTableName.Replace("PROSPECT_LISTS_RELATED", "PROSPECT_LISTS_PROSPECTS") + ".PROSPECT_LIST_ID = @PROSPECT_LIST_ID1" + ControlChars.CrLf;
							cmd.CommandText += "              and " + qo.CRMTableName.Replace("PROSPECT_LISTS_RELATED", "PROSPECT_LISTS_PROSPECTS") + ".RELATED_TYPE     = @RELATED_TYPE1    " + ControlChars.CrLf;

							Sql.AddParameter(cmd, "@PROSPECT_LIST_ID1", qo.PARENT_ID    );
							Sql.AddParameter(cmd, "@RELATED_TYPE1"    , qo.CRMModuleName);
						}
						cmd.CommandText += "  left outer join (select vw" + qo.CRMTableName + ".ID               " + ControlChars.CrLf;
						cmd.CommandText += "                        , vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC" + ControlChars.CrLf;
						cmd.CommandText += "                        , vw" + qo.CRMTableName + "." + qo.CRMTableSort + ControlChars.CrLf;
						cmd.CommandText += "                     from " + Sql.MetadataName(cmd, "vw" + qo.CRMTableName + "_Watson") + "  vw" + qo.CRMTableName + ControlChars.CrLf;
						// 04/16/2016 Paul.  We will not be using CRM security.  Instead, filter by list type and campaign type. 
						//ExchangeSecurity.Filter(Session, cmd, gUSER_ID, qo.CRMModuleName, "view");
						if ( qo.IsContact )
						{
							cmd.CommandText += "                    where vw" + qo.CRMTableName + ".PROSPECT_LIST_ID = @PROSPECT_LIST_ID" + ControlChars.CrLf;
							cmd.CommandText += "                      and vw" + qo.CRMTableName + ".RELATED_TYPE     = @RELATED_TYPE    " + ControlChars.CrLf;
							Sql.AddParameter(cmd, "@PROSPECT_LIST_ID", qo.PARENT_ID    );
							Sql.AddParameter(cmd, "@RELATED_TYPE"    , qo.CRMModuleName);
						}
						cmd.CommandText += "                  ) vw" + qo.CRMTableName + "                                                " + ControlChars.CrLf;
						cmd.CommandText += "               on vw" + qo.CRMTableName + ".ID = " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_LOCAL_ID" + ControlChars.CrLf;
						cmd.CommandText += " where SYNC_SERVICE_NAME     = N'Watson'                             " + ControlChars.CrLf;
						cmd.CommandText += "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID                " + ControlChars.CrLf;
						cmd.CommandText += "   and vw" + qo.CRMTableName + ".ID is null                          " + ControlChars.CrLf;
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
							// 02/16/2017 Paul.  Need to filter list by parent. 
							// 04/27/2017 Paul.  Cannot filter by parent at this point as deleted records would return NULL parent. 
							//if ( qo.IsMember )
							//{
							//	cmd.CommandText += "   and PROSPECT_LIST_ID = @PARENT_ID" + ControlChars.CrLf;
							//	Sql.AddParameter(cmd, "@PARENT_ID", qo.PARENT_ID);
							//}
							cmd.CommandText += " order by vw" + qo.CRMTableName + ".DATE_MODIFIED_UTC" + ControlChars.CrLf;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to delete.");
								for ( int i = 0; i < dt.Rows.Count; i++ )
								{
									DataRow row = dt.Rows[i];
									Guid   gID              = Sql.ToGuid  (row["SYNC_LOCAL_ID"  ]);
									string sSYNC_REMOTE_KEY = Sql.ToString(row["SYNC_REMOTE_KEY"]);
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.WatsonTableName + ".Sync: Deleting Watson (" + sSYNC_REMOTE_KEY + "), CRM " + qo.CRMModuleName + "(" + gID.ToString() + ").");

									try
									{
										if ( sDIRECTION == "bi-directional" || sDIRECTION == "from crm only" )
										{
											qo.Reset();
											qo.ID = sSYNC_REMOTE_KEY;
											if ( qo.IsContact )
											{
												string sEMAIL1 = Sql.ToString(row[qo.CRMTableSort]);
												(qo as Prospect).email_address = sEMAIL1;
											}
											qo.Delete();
										}
									}
									catch(Exception ex)
									{
										string sError = "Error deleting Watson " + qo.WatsonTableName + " " + sSYNC_REMOTE_KEY + "." + ControlChars.CrLf;
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
											Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "Watson");
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
