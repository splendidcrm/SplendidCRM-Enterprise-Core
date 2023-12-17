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

namespace Spring.Social.MailChimp
{
	public class MailChimpSync
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

		public MailChimpSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
		}

		public bool MailChimpEnabled()
		{
			bool bMailChimpEnabled = Sql.ToBoolean(Application["CONFIG.MailChimp.Enabled"]);
#if DEBUG
			//bMailChimpEnabled = true;
#endif
			if ( bMailChimpEnabled )
			{
				string sClientID         = Sql.ToString(Application["CONFIG.MailChimp.ClientID"        ]);
				string sOAuthAccessToken = Sql.ToString(Application["CONFIG.MailChimp.OAuthAccessToken"]);
				bMailChimpEnabled = !Sql.IsEmptyString(sOAuthAccessToken) && !Sql.IsEmptyString(sClientID);
			}
			return bMailChimpEnabled;
		}

		public Guid MailChimpUserID()
		{
			Guid gHUBSPOT_USER_ID = Sql.ToGuid(Application["CONFIG.MailChimp.UserID"]);
			if ( Sql.IsEmptyGuid(gHUBSPOT_USER_ID) )
				gHUBSPOT_USER_ID = new Guid("00000000-0000-0000-0000-00000000000C");  // Use special MailChimp user. 
			return gHUBSPOT_USER_ID;
		}

		public Spring.Social.MailChimp.Api.IMailChimp CreateApi()
		{
			Spring.Social.MailChimp.Api.IMailChimp mailChimp = null;
			string sMailChimpDataCenter   = Sql.ToString(Application["CONFIG.MailChimp.DataCenter"      ]);
			string sMailChimpClientID     = Sql.ToString(Application["CONFIG.MailChimp.ClientID"        ]);
			string sMailChimpClientSecret = Sql.ToString(Application["CONFIG.MailChimp.ClientSecret"    ]);
			string sOAuthAccessToken      = Sql.ToString(Application["CONFIG.MailChimp.OAuthAccessToken"]);
			
			Spring.Social.MailChimp.Connect.MailChimpServiceProvider mailChimpServiceProvider = new Spring.Social.MailChimp.Connect.MailChimpServiceProvider(sMailChimpClientID, sMailChimpClientSecret, sMailChimpDataCenter);
			mailChimp = mailChimpServiceProvider.GetApi(sOAuthAccessToken);
			return mailChimp;
		}

		public bool ValidateMailChimp(string sDataCenter, string sOAuthClientID, string sOAuthClientSecret, string sOAuthAccessToken, StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.MailChimp.Api.IMailChimp mailChimp = null;
				Spring.Social.MailChimp.Connect.MailChimpServiceProvider mailChimpServiceProvider = new Spring.Social.MailChimp.Connect.MailChimpServiceProvider(sOAuthClientID, sOAuthClientSecret, sDataCenter);
				mailChimp = mailChimpServiceProvider.GetApi(sOAuthAccessToken);
				mailChimp.ListOperations.GetAll();
			}
			catch(Exception ex)
			{
				sbErrors.AppendLine(ex.Message);
			}
			return bValidSource;
		}

		public bool ValidateMailChimp(StringBuilder sbErrors)
		{
			bool bValidSource = false;
			try
			{
				Spring.Social.MailChimp.Api.IMailChimp mailChimp = this.CreateApi();
				mailChimp.ListOperations.GetAll();
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
			bool bMailChimpEnabled = MailChimpEnabled();
			if ( !bInsideSyncAll && bMailChimpEnabled )
			{
				bInsideSyncAll = true;
				try
				{
					StringBuilder sbErrors = new StringBuilder();
					Guid gMailChimp_USER_ID = this.MailChimpUserID();
					MailChimp.UserSync User = new MailChimp.UserSync(Session, Security, SplendidError, ExchangeSecurity, SyncError, this, gMailChimp_USER_ID, bSyncAll);
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
			     + " where SYNC_SERVICE_NAME     = N'MailChimp'          " + ControlChars.CrLf
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

		// 05/29/2016 Paul.  Add merge fields. 
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
					// 03/27/2017 Paul.  vwPROSPECT_LISTS_RELATED_MailChimp is the view that is used for members, not vwLEADS_MailChimp. 
					Sql.AddParameter(cmd, "@ObjectName", "VWPROSPECT_LISTS_RELATED_MAILCHIMP");
					Sql.AppendParameter(cmd, arrMERGE_FIELDS, "ColumnName");
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						da.Fill(dt);
						dt.Columns.Add("DisplayName", typeof(System.String));
						dt.Columns.Add("Tag"        , typeof(System.String));
						string sLANG = Sql.ToString(Application["CONFIG.MailChimp.Language"]);
						if ( Sql.IsEmptyString(sLANG) )
							sLANG = "en-US";
						foreach ( DataRow row in dt.Rows )
						{
							string sColumnName  = Sql.ToString(row["ColumnName"]);
							string sDisplayName = L10N.Term(Application, sLANG, Utils.BuildTermName(sSYNC_MODULES, sColumnName)).Replace(":", "");
							row["DisplayName"] = sDisplayName;
							if ( dictMergeFields.ContainsKey(sColumnName) )
								row["Tag"] = dictMergeFields[sColumnName];
							else
								row["Tag"] = sColumnName;
						}
					}
				}
			}
			return dt;
		}

		public void Sync(MailChimp.UserSync User, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.MailChimp.VerboseStatus"]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "MailChimpSync.Sync Start.");
			
			Spring.Social.MailChimp.Api.IMailChimp mailChimp = this.CreateApi();
			if ( mailChimp != null )
			{
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					try
					{
						con.Open();
						string sSYNC_MODULES = Sql.ToString(Application["CONFIG.MailChimp.SyncModules"]);
						string sMERGE_FIELDS = Sql.ToString(Application["CONFIG.MailChimp.MergeFields"]).ToUpper();
						string from_name     = Sql.ToString(Application["CONFIG.fromname"   ]);
						string from_email    = Sql.ToString(Application["CONFIG.fromaddress"]);
						using ( DataTable dtMergeFields = this.MergeFields(dbf, con, sSYNC_MODULES, sMERGE_FIELDS) )
						{
							MailChimp.ProspectList prospectList = new MailChimp.ProspectList(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, from_name, from_email, dtMergeFields);
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
											// 05/29/2016 Paul.  Add merge fields. 
											if ( !Sql.IsEmptyString(sMERGE_FIELDS) )
											{
												string sLIST_MERGE_FIELDS = Sql.ToString(Application["CONFIG.MailChimp.List.MergeFields." + list_id]);
												if ( sLIST_MERGE_FIELDS != sMERGE_FIELDS )
												{
													prospectList.id = list_id;
													// 05/30/2016 Paul.  MailChimp seems to be having a problem returning all of the new fields.  So just log and ignore the error. 
													// Even the MailChimp playground fails to return the new fields, but the live site does show them. 
													try
													{
														prospectList.UpdateMergeFields();
													}
													catch(Exception ex)
													{
														SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
														SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
													}
													Application["CONFIG.MailChimp.List.MergeFields." + list_id] = sMERGE_FIELDS;
												}
											}
											if ( sSYNC_MODULES == "Contacts" )
											{
												MailChimp.Contact contact = new MailChimp.Contact(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, list_id, gPROSPECT_LIST_ID, dtMergeFields);
												Sync(dbf, con, User, contact, sbErrors);
											}
											else if ( sSYNC_MODULES == "Leads" )
											{
												MailChimp.Lead lead = new MailChimp.Lead(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, list_id, gPROSPECT_LIST_ID, dtMergeFields);
												Sync(dbf, con, User, lead, sbErrors);
											}
											else if ( sSYNC_MODULES == "Prospects" )
											{
												MailChimp.Prospect prospect = new MailChimp.Prospect(Session, Security, Sql, SqlProcs, ExchangeSecurity, SyncError, mailChimp, list_id, gPROSPECT_LIST_ID, dtMergeFields);
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
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "MailChimpSync.Sync Done.");
					}
				}
			}
		}

		public void Sync(SplendidCRM.DbProviderFactory dbf, IDbConnection con, MailChimp.UserSync User, MailChimp.HObject qo, StringBuilder sbErrors)
		{
			ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
			Guid gUSER_ID = User.USER_ID;
			bool bSyncAll = User.SyncAll;
			
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.MailChimp.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.MailChimp.ConflictResolution"]);
			string sDIRECTION           = Sql.ToString (Application["CONFIG.MailChimp.Direction"         ]);
			int    nMAX_RECORDS         = Sql.ToInteger(Application["CONFIG.MailChimp.MaxRecords"        ]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			if ( sDIRECTION.ToLower().StartsWith("bi") )
				sDIRECTION = "bi-directional";
			else if ( sDIRECTION.ToLower().StartsWith("to crm"  ) || sDIRECTION.ToLower().StartsWith("from MailChimp") )
				sDIRECTION = "to crm only";
			else if ( sDIRECTION.ToLower().StartsWith("from crm") || sDIRECTION.ToLower().StartsWith("to MailChimp"  ) )
				sDIRECTION = "from crm only";
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: " + sDIRECTION);
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
						     + " where SYNC_SERVICE_NAME     = N'MailChimp'          " + ControlChars.CrLf
						     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
							if ( qo.IsMember )
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
					IList<Spring.Social.MailChimp.Api.HBase> lst = qo.SelectModified(dtStartModifiedDate);
					if ( bVERBOSE_STATUS )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: Query took " + (DateTime.Now - dtStartSelect).Seconds.ToString() + " seconds. Using last modified " + dtStartModifiedDate.ToString());
					if ( lst.Count > 0 )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: " + lst.Count.ToString() + " " + qo.MailChimpTableName + " to import.");
					foreach ( Spring.Social.MailChimp.Api.HBase qb in lst )
					{
						qo.SetFromMailChimp(qb.id);
						bool bImported = qo.Import(Session, con, gUSER_ID, sDIRECTION, sbErrors);
					}
				}
				
				sSQL = "select vw" + qo.CRMTableName + ".*                                                                                                    " + ControlChars.CrLf
				     + "     , " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_ID                                                        " + ControlChars.CrLf
				     + "     , " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_REMOTE_KEY                                                " + ControlChars.CrLf
				     + "     , " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_LOCAL_DATE_MODIFIED_UTC                                   " + ControlChars.CrLf
				     + "     , " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_REMOTE_DATE_MODIFIED_UTC                                  " + ControlChars.CrLf
				     + "  from            " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_MailChimp") + "  vw" + qo.CRMTableName                           + ControlChars.CrLf
				     + "  left outer join " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC")                                                           + ControlChars.CrLf
				     + "               on " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_SERVICE_NAME     = N'MailChimp'                " + ControlChars.CrLf
				     + "              and " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID      " + ControlChars.CrLf
				     + "              and " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_LOCAL_ID         = vw" + qo.CRMTableName + ".ID" + ControlChars.CrLf;
				// 02/16/2017 Paul.  Need to include PROSPECT_LIST_ID in filter. 
				if ( qo.IsMember )
					sSQL += "              and " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".PROSPECT_LIST_ID      = vw" + qo.CRMTableName + ".PROSPECT_LIST_ID" + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
					// 04/16/2016 Paul.  We will not be using CRM security.  Instead, filter by list type and campaign type. 
					//ExchangeSecurity.Filter(Session, cmd, gUSER_ID, qo.CRMModuleName, "view");
					cmd.CommandText += " where 1 = 1" + ControlChars.CrLf;
					if ( qo.IsMember )
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
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to send.");
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
												if ( bVERBOSE_STATUS )
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: Sending new " + qo.MailChimpTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
												sSYNC_REMOTE_KEY = qo.Insert();
											}
											else
											{
												if ( bVERBOSE_STATUS )
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: Rebind " + qo.MailChimpTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
												sSYNC_REMOTE_KEY = qo.ID;
											}
										}
									}
									else
									{
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: Binding " + qo.MailChimpTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ".");
											
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
											string sError = "Error retrieving MailChimp " + qo.MailChimpTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
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
													SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: Sending " + qo.MailChimpTableName + " (" + i.ToString() + ") " + Sql.ToString(row["NAME"]) + ". " + sbChanges.ToString());
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
													Sql.SetParameter(spSyncUpdate, "@SERVICE_NAME"            , "MailChimp"               );
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
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: Deleting " + qo.CRMTableName + " " + Sql.ToString(row["NAME"]) + ".");
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
													Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "MailChimp"    );
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
									string sError = "Error creating MailChimp " + qo.MailChimpTableName + " (" + i.ToString() + ") " + Sql.ToString  (row["NAME"]) + "." + ControlChars.CrLf;
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
						cmd.CommandText += "select SYNC_ID                                                       " + ControlChars.CrLf;
						cmd.CommandText += "     , SYNC_LOCAL_ID                                                 " + ControlChars.CrLf;
						cmd.CommandText += "     , SYNC_REMOTE_KEY                                               " + ControlChars.CrLf;
						cmd.CommandText += "  from            " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ControlChars.CrLf;
						// 04/27/2017 Paul.  Must use a separate join to filter all member records (including deleted records). 
						if ( qo.IsMember )
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
						cmd.CommandText += "                     from " + Sql.MetadataName(cmd, "vw" + qo.CRMTableName + "_MailChimp") + "  vw" + qo.CRMTableName + ControlChars.CrLf;
						// 04/16/2016 Paul.  We will not be using CRM security.  Instead, filter by list type and campaign type. 
						//ExchangeSecurity.Filter(Session, cmd, gUSER_ID, qo.CRMModuleName, "view");
						if ( qo.IsMember )
						{
							cmd.CommandText += "                    where vw" + qo.CRMTableName + ".PROSPECT_LIST_ID = @PROSPECT_LIST_ID" + ControlChars.CrLf;
							cmd.CommandText += "                      and vw" + qo.CRMTableName + ".RELATED_TYPE     = @RELATED_TYPE    " + ControlChars.CrLf;
							Sql.AddParameter(cmd, "@PROSPECT_LIST_ID", qo.PARENT_ID    );
							Sql.AddParameter(cmd, "@RELATED_TYPE"    , qo.CRMModuleName);
						}
						cmd.CommandText += "                  ) vw" + qo.CRMTableName + "                                                " + ControlChars.CrLf;
						cmd.CommandText += "               on vw" + qo.CRMTableName + ".ID = " + Sql.MetadataName(con, "vw" + qo.CRMTableName + "_SYNC") + ".SYNC_LOCAL_ID" + ControlChars.CrLf;
						cmd.CommandText += " where SYNC_SERVICE_NAME     = N'MailChimp'                          " + ControlChars.CrLf;
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
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: " + dt.Rows.Count.ToString() + " " + qo.CRMModuleName + " to delete.");
								for ( int i = 0; i < dt.Rows.Count; i++ )
								{
									DataRow row = dt.Rows[i];
									Guid   gID              = Sql.ToGuid  (row["SYNC_LOCAL_ID"  ]);
									string sSYNC_REMOTE_KEY = Sql.ToString(row["SYNC_REMOTE_KEY"]);
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), qo.MailChimpTableName + ".Sync: Deleting MailChimp (" + sSYNC_REMOTE_KEY + "), CRM " + qo.CRMModuleName + "(" + gID.ToString() + ").");

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
										string sError = "Error deleting MailChimp " + qo.MailChimpTableName + " " + sSYNC_REMOTE_KEY + "." + ControlChars.CrLf;
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
											Sql.SetParameter(spSyncDelete, "@SERVICE_NAME"    , "MailChimp");
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
