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
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Net;
using System.Net.Security;
using System.Web;
using System.Xml;
using System.Diagnostics;

using Microsoft.Exchange.WebServices.Data;
using System.Security.Cryptography.X509Certificates;

using Spring.Social.Office365;
using Microsoft.AspNetCore.Http;

namespace SplendidCRM
{
	public class ExchangeSync
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private XmlUtil              XmlUtil            ;
		private SyncError            SyncError          ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private ExchangeUtils        ExchangeUtils      ;
		private Crm.Modules          Modules            ;
		private Crm.NoteAttachments  NoteAttachments    ;
		private Office365Sync        Office365Sync      ;

		public ExchangeSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache,  XmlUtil XmlUtil, SyncError SyncError, ExchangeSecurity ExchangeSecurity,ExchangeUtils ExchangeUtils, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, Office365Sync Office365Sync)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.XmlUtil             = XmlUtil            ;
			this.SyncError           = SyncError          ;
			this.Modules             = Modules            ;
			this.NoteAttachments     = NoteAttachments    ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.ExchangeUtils       = ExchangeUtils      ;
			this.Office365Sync       = Office365Sync      ;
		}

		// 06/23/2018 Paul.  The timeout is in minutes, so the pull subscription was previously only valid for 1 hour. 
		// https://msdn.microsoft.com/en-us/library/microsoft.exchange.webservices.data.exchangeservice.subscribetopullnotifications(v=exchg.80).aspx
		// 04/23/2010 Paul.  Make the inside flag public so that we can access from the SystemCheck. 
		public  static bool bInsideSyncAll = false;
		private static List<Guid>                         arrProcessing         = new List<Guid>();
		// 01/22/2012 Paul.  Keep track of the last time we synced to prevent it from being too frequent. 
		private static Dictionary<Guid, DateTime>         dictLastSync          = new Dictionary<Guid,DateTime>();
		// 07/07/2018 Paul.  Add the SplendidCRM category to the user's master list if it does not already exist. 
		private static Dictionary<Guid, string>           dictSplendidCategories = new Dictionary<Guid,string>();
		
		#region Subscription
		// 06/26/2018 Paul.  We need to make sure that we unsubscribe. 
		public class SafePullSubscription : Dictionary<Guid, SubscriptionBase>
		{
			~SafePullSubscription()
			{
				foreach ( Guid gUSER_ID in dictPullSubscriptions.Keys )
				{
					try
					{
						PullSubscription pull = this[gUSER_ID] as PullSubscription;
						Debug.WriteLine("ExchangeSync.~SafePullSubscription(): Unsubscribe " + gUSER_ID.ToString());
						pull.Unsubscribe();
					}
					catch
					{
					}
				}
			}
		}

		private static SafePullSubscription dictPullSubscriptions = new SafePullSubscription();
		private static Dictionary<Guid, SubscriptionBase> dictPushSubscriptions = new Dictionary<Guid, SubscriptionBase>();

		public void StopPullSubscription(Guid gUSER_ID)
		{
			if ( dictPullSubscriptions.ContainsKey(gUSER_ID) )
			{
				try
				{
					PullSubscription pull = dictPullSubscriptions[gUSER_ID] as PullSubscription;
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Stopping Pull subscription for " + gUSER_ID.ToString() + ", " + pull.Id);
					pull.Unsubscribe();
					// 04/26/2010 Paul.  The watermark value in the subscription object does not change, so it should not be saved. 
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
				finally
				{
					dictPullSubscriptions.Remove(gUSER_ID);
				}
			}
		}

		public void StopPushSubscription(Guid gUSER_ID)
		{
			if ( dictPushSubscriptions.ContainsKey(gUSER_ID) )
			{
				try
				{
					PushSubscription push = dictPushSubscriptions[gUSER_ID] as PushSubscription;
					// 11/04/2013 Paul.  Correct warning message to say Push. 
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Stopping Push subscription for " + gUSER_ID.ToString() + ", " + push.Id);
					// 04/07/2010 Paul.  Push Subscriptions are ended inside the ExchangeService2007.asmx callback. 
					// 04/26/2010 Paul.  The watermark value in the subscription object does not change, so it should not be saved. 
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
				finally
				{
					dictPushSubscriptions.Remove(gUSER_ID);
				}
			}
		}

		public void StopSubscriptions()
		{
			try
			{
				// 04/07/2010 Paul.  We cannot use foreach to remove items from a dictionary, so use a separate list. 
				List<Guid> arrPullUsers = new List<Guid>();
				List<Guid> arrPushUsers = new List<Guid>();
				foreach ( Guid gUSER_ID in dictPullSubscriptions.Keys )
					arrPullUsers.Add(gUSER_ID);
				foreach ( Guid gUSER_ID in dictPushSubscriptions.Keys )
					arrPushUsers.Add(gUSER_ID);
				// 09/20/2013 Paul.  Context might be null when shutting down. 
				//if ( Context != null )
				{
					foreach ( Guid gUSER_ID in arrPullUsers )
					{
						StopPullSubscription(gUSER_ID);
					}
					foreach ( Guid gUSER_ID in arrPushUsers )
					{
						StopPushSubscription(gUSER_ID);
					}
				}
			}
			catch(Exception ex)
			{
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
			}
		}

		public void GetPushSubscription(string sSubscriptionID, ref PushSubscription push, ref Guid gUSER_ID)
		{
			// 08/31/2010 Paul.  Make sure that the subscriptions have been initialized. 
			if ( dictPushSubscriptions != null )
			{
				foreach ( Guid gID in dictPushSubscriptions.Keys )
				{
					SubscriptionBase subscription = dictPushSubscriptions[gID];
					if ( subscription.Id == sSubscriptionID )
					{
						push = subscription as PushSubscription;
						gUSER_ID = gID;
						break;
					}
				}
			}
		}
		#endregion

		#region Sync Helpers
#pragma warning disable CS1998
		public async ValueTask SyncAllUsers(CancellationToken token)
		{
			SyncAllUsers();
		}
#pragma warning restore CS1998

		public void SyncAllUsers()
		{
			string sSERVER_URL = Sql.ToString(Application["CONFIG.Exchange.ServerURL"]);
			string sUSER_NAME  = Sql.ToString(Application["CONFIG.Exchange.UserName" ]);
			// 05/09/2018 Paul.  We need to also check for ClientID for Office 365. 
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			// 12/05/2020 Paul.  New code to sync Office 365 as exchange services have been deprecated. 
			if ( !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sOAUTH_CLIENT_ID) && !Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) )
			{
				Office365Sync.SyncAllUsers();
			}
			else if ( !bInsideSyncAll && !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sUSER_NAME) )
			{
				bInsideSyncAll = true;
				try
				{
					using ( DataTable dt = new DataTable() )
					{
						// 04/04/2010 Paul.  As much as we would like to cache the EXCHANGE_USERS table, 
						// the Watermark value is critical to the Pull Subscription. 
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
							// 01/17/2017 Paul.  Get all columns so that we do not get an error when including OFFICE365_OAUTH_ENABLED. 
							sSQL = "select *                 " + ControlChars.CrLf
							     + "  from vwEXCHANGE_USERS  " + ControlChars.CrLf
							     + " order by EXCHANGE_ALIAS " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dt);
								}
							}
							
							bool   bPushNotifications   = Sql.ToBoolean(Application["CONFIG.Exchange.PushNotifications"  ]);
							string sPushNotificationURL = Sql.ToString (Application["CONFIG.Exchange.PushNotificationURL"]);
							// 04/07/2010 Paul.  If the Push URL is empty, then Push will not be used. 
							if ( Sql.IsEmptyString(sPushNotificationURL) )
								bPushNotifications = false;
							if ( !bPushNotifications )
							{
								// 04/07/2010 Paul.  If we are doing Pull Subscriptions, then stop the Push Subscriptions. 
								// 04/07/2010 Paul.  We cannot use foreach to remove items from a dictionary, so use a separate list. 
								List<Guid> arrPushUsers = new List<Guid>();
								foreach ( Guid gUSER_ID in dictPushSubscriptions.Keys )
									arrPushUsers.Add(gUSER_ID);
								foreach ( Guid gUSER_ID in arrPushUsers )
								{
									StopPushSubscription(gUSER_ID);
								}
							}
							else
							{
								// 04/07/2010 Paul.  We cannot use foreach to remove items from a dictionary, so use a separate list. 
								List<Guid> arrPullUsers = new List<Guid>();
								foreach ( Guid gUSER_ID in dictPullSubscriptions.Keys )
									arrPullUsers.Add(gUSER_ID);
								// 04/07/2010 Paul.  If we are doing Push Subscriptions, then stop the Pull Subscriptions. 
								foreach ( Guid gUSER_ID in arrPullUsers )
								{
									StopPullSubscription(gUSER_ID);
								}
							}
						}
						// 03/29/2010 Paul.  Process the users outside the connection scope. 
						foreach ( DataRow row in dt.Rows )
						{
							string sEXCHANGE_ALIAS     = Sql.ToString(row["EXCHANGE_ALIAS"    ]);
							string sEXCHANGE_EMAIL     = Sql.ToString(row["EXCHANGE_EMAIL"    ]);
							Guid   gASSIGNED_USER_ID   = Sql.ToGuid  (row["ASSIGNED_USER_ID"  ]);
							string sEXCHANGE_WATERMARK = Sql.ToString(row["EXCHANGE_WATERMARK"]);
							string sMAIL_SMTPUSER      = Sql.ToString(row["MAIL_SMTPUSER"     ]);
							string sMAIL_SMTPPASS      = Sql.ToString(row["MAIL_SMTPPASS"     ]);
							// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
							bool bOFFICE365_OAUTH_ENABLED = false;
							try
							{
								bOFFICE365_OAUTH_ENABLED = Sql.ToBoolean(row["OFFICE365_OAUTH_ENABLED"]);
							}
							catch
							{
							}
							// 07/07/2018 Paul.  If OAuth is enabled but the user does not have an OAUTH token, then skip the user. 
							if ( !Sql.IsEmptyString(sOAUTH_CLIENT_ID) && !bOFFICE365_OAUTH_ENABLED )
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ExchangeSync.SyncAllUsers(" + sEXCHANGE_ALIAS + " " + sEXCHANGE_EMAIL + ")<br />" + "No OAuth record exists.  The user will need to re-authorize.");
								continue;
							}
							StringBuilder sbErrors = new StringBuilder();
							// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
							ExchangeSync.UserSync User = new ExchangeSync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, XmlUtil, SyncError, ExchangeSecurity, ExchangeUtils, this, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gASSIGNED_USER_ID, sEXCHANGE_WATERMARK, false, bOFFICE365_OAUTH_ENABLED);
							// 11/03/2013 Paul.  Capture the error and continue. 
							try
							{
								this.Sync(User, sbErrors);
							}
							catch(Exception ex)
							{
								// 06/22/2018 Paul.  Expand exception and include stack info. 
								string sError = "ExchangeSync.SyncAllUsers(" + sEXCHANGE_ALIAS + " " + sEXCHANGE_EMAIL + ")<br />" + ControlChars.CrLf 
									+ Utils.ExpandException(ex) + "<br />" + ControlChars.CrLf
									+ Sql.ToString(ex.StackTrace);
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								// 05/01/2018 Paul.  If the mailbox does not exist, then disable. 
								if ( ex.Message.StartsWith("The SMTP address has no mailbox associated with it.") )
								{
									using ( IDbConnection con = dbf.CreateConnection() )
									{
										con.Open();
										using ( IDbTransaction trn = Sql.BeginTransaction(con) )
										{
											try
											{
												SqlProcs.spEXCHANGE_USERS_DeleteByEmail(sEXCHANGE_EMAIL, trn);
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
								// 07/05/2018 Paul.  Stop subscriptions if there was a token error. 
								if ( ex.Message.StartsWith("The SMTP address has no mailbox associated with it.") 
								  || ex.Message.StartsWith("Office 365 Access Token")
								  || ex.Message.StartsWith("Office 365 Refresh Token")
								  )
								{
									StopPullSubscription(User.USER_ID);
									StopPushSubscription(User.USER_ID);
									SplendidCache.ClearExchangeFolders(User.USER_ID);
								}
							}
						}
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

		// 01/22/2012 Paul.  The workflow engine will fire user sync events when a record changes. 
		public void SyncUser(Guid gUSER_ID)
		{
			string sSERVER_URL = Sql.ToString(Application["CONFIG.Exchange.ServerURL"]);
			string sUSER_NAME  = Sql.ToString(Application["CONFIG.Exchange.UserName" ]);
			// 05/09/2018 Paul.  We need to also check for ClientID for Office 365. 
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
			// 12/05/2020 Paul.  New code to sync Office 365 as exchange services have been deprecated. 
			if ( !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sOAUTH_CLIENT_ID) && !Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) )
			{
				Office365Sync.SyncUser(gUSER_ID);
			}
			else if ( !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sUSER_NAME) )
			{
				try
				{
					using ( DataTable dt = new DataTable() )
					{
						// 04/04/2010 Paul.  As much as we would like to cache the EXCHANGE_USERS table, 
						// the Watermark value is critical to the Pull Subscription. 
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
							// 01/17/2017 Paul.  Get all columns so that we do not get an error when including OFFICE365_OAUTH_ENABLED. 
							sSQL = "select *                          " + ControlChars.CrLf
							     + "  from vwEXCHANGE_USERS           " + ControlChars.CrLf
							     + " where ASSIGNED_USER_ID = @USER_ID" + ControlChars.CrLf
							     + " order by EXCHANGE_ALIAS          " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dt);
								}
							}
						}
						// 03/29/2010 Paul.  Process the users outside the connection scope. 
						foreach ( DataRow row in dt.Rows )
						{
							string sEXCHANGE_ALIAS     = Sql.ToString(row["EXCHANGE_ALIAS"    ]);
							string sEXCHANGE_EMAIL     = Sql.ToString(row["EXCHANGE_EMAIL"    ]);
							Guid   gASSIGNED_USER_ID   = Sql.ToGuid  (row["ASSIGNED_USER_ID"  ]);
							string sEXCHANGE_WATERMARK = Sql.ToString(row["EXCHANGE_WATERMARK"]);
							string sMAIL_SMTPUSER      = Sql.ToString(row["MAIL_SMTPUSER"     ]);
							string sMAIL_SMTPPASS      = Sql.ToString(row["MAIL_SMTPPASS"     ]);
							// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
							bool bOFFICE365_OAUTH_ENABLED = false;
							try
							{
								bOFFICE365_OAUTH_ENABLED = Sql.ToBoolean(row["OFFICE365_OAUTH_ENABLED"]);
							}
							catch
							{
							}
							StringBuilder sbErrors = new StringBuilder();
							// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
							ExchangeSync.UserSync User = new ExchangeSync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, XmlUtil, SyncError, ExchangeSecurity, ExchangeUtils, this, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gASSIGNED_USER_ID, sEXCHANGE_WATERMARK, false, bOFFICE365_OAUTH_ENABLED);
							this.Sync(User, sbErrors);
						}
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}
		}

		public class UserSync
		{
			private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			private HttpApplicationState Application        = new HttpApplicationState();
			private HttpSessionState     Session            ;
			private Security             Security           ;
			private Sql                  Sql                ;
			private SqlProcs             SqlProcs           ;
			private SplendidError        SplendidError      ;
			private XmlUtil              XmlUtil            ;
			private SyncError            SyncError          ;
			private ExchangeSecurity     ExchangeSecurity   ;
			private ExchangeUtils        ExchangeUtils      ;
			private ExchangeSync         ExchangeSync       ;

			public string      EXCHANGE_ALIAS    ;
			public string      EXCHANGE_EMAIL    ;
			public string      MAIL_SMTPUSER     ;
			public string      MAIL_SMTPPASS     ;
			public Guid        USER_ID           ;
			public string      EXCHANGE_WATERMARK;
			public bool        SyncAll           ;
			// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
			public bool        OFFICE365_OAUTH_ENABLED;
			
			public UserSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, XmlUtil XmlUtil, SyncError SyncError, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, ExchangeSync ExchangeSync)
			{
				this.Session             = Session            ;
				this.Security            = Security           ;
				this.Sql                 = Sql                ;
				this.SqlProcs            = SqlProcs           ;
				this.SplendidError       = SplendidError      ;
				this.XmlUtil             = XmlUtil            ;
				this.SyncError           = SyncError          ;
				this.ExchangeSecurity    = ExchangeSecurity   ;
				this.ExchangeUtils       = ExchangeUtils      ;
				this.ExchangeSync        = ExchangeSync       ;

				this.EXCHANGE_ALIAS     = Security.EXCHANGE_ALIAS;
				this.EXCHANGE_EMAIL     = Security.EXCHANGE_EMAIL;
				this.MAIL_SMTPUSER      = Security.MAIL_SMTPUSER ;
				this.MAIL_SMTPPASS      = Security.MAIL_SMTPPASS ;
				this.USER_ID            = Security.USER_ID       ;
				this.EXCHANGE_WATERMARK = String.Empty           ;
				this.SyncAll            = false                  ;
				// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
				// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
				this.OFFICE365_OAUTH_ENABLED = Sql.ToBoolean(Session["OFFICE365_OAUTH_ENABLED"]);
			}
			
			public UserSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, XmlUtil XmlUtil, SyncError SyncError, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, ExchangeSync ExchangeSync, string sEXCHANGE_ALIAS, string sEXCHANGE_EMAIL, string sMAIL_SMTPUSER, string sMAIL_SMTPPASS, Guid gUSER_ID, string sEXCHANGE_WATERMARK, bool bSyncAll, bool bOFFICE365_OAUTH_ENABLED)
			{
				this.Session             = Session            ;
				this.Security            = Security           ;
				this.Sql                 = Sql                ;
				this.SqlProcs            = SqlProcs           ;
				this.SplendidError       = SplendidError      ;
				this.XmlUtil             = XmlUtil            ;
				this.SyncError           = SyncError          ;
				this.ExchangeSecurity    = ExchangeSecurity   ;
				this.ExchangeUtils       = ExchangeUtils      ;
				this.ExchangeSync        = ExchangeSync       ;

				this.EXCHANGE_ALIAS     = sEXCHANGE_ALIAS    ;
				this.EXCHANGE_EMAIL     = sEXCHANGE_EMAIL    ;
				this.MAIL_SMTPUSER      = sMAIL_SMTPUSER     ;
				this.MAIL_SMTPPASS      = sMAIL_SMTPPASS     ;
				this.USER_ID            = gUSER_ID           ;
				this.EXCHANGE_WATERMARK = sEXCHANGE_WATERMARK;
				this.SyncAll            = bSyncAll           ;
				// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
				this.OFFICE365_OAUTH_ENABLED = bOFFICE365_OAUTH_ENABLED;
			}
			
			public void Start()
			{
				// 04/25/2010 Paul.  Provide elapse time for SyncAll. 
				DateTime dtStart = DateTime.Now;
				bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  Begin " + EXCHANGE_ALIAS + ", " + USER_ID.ToString() + " at " + dtStart.ToString());
				StringBuilder sbErrors = new StringBuilder();
				// 11/27/2021 Paul.  We should be catching all errors. 
				try
				{
					// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
					ExchangeSync.Sync(this, sbErrors);
					DateTime dtEnd = DateTime.Now;
					TimeSpan ts = dtEnd - dtStart;
					if ( bVERBOSE_STATUS )
						SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  End "   + EXCHANGE_ALIAS + ", " + USER_ID.ToString() + " at " + dtEnd.ToString() + ". Elapse time " + ts.Minutes.ToString() + " minutes " + ts.Seconds.ToString() + " seconds.");
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}

			// 03/13/2012 Paul.  Move SyncSentItems into a thread as it can take a long time to work. 
			public void SyncSentItems()
			{
				StringBuilder sbErrors = new StringBuilder();
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(this.USER_ID);
				ExchangeService service = ExchangeUtils.CreateExchangeService(this);
				
				// 11/27/2021 Paul.  We should be catching all errors. 
				try
				{
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						ExchangeSync.SyncSentItems(Session, service, con, this.EXCHANGE_ALIAS, this.USER_ID, true, DateTime.MinValue, sbErrors);
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}

			// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
			public void SyncInbox()
			{
				StringBuilder sbErrors = new StringBuilder();
				ExchangeSession Session = ExchangeSecurity.LoadUserACL(this.USER_ID);
				ExchangeService service = ExchangeUtils.CreateExchangeService(this);
				
				// 11/27/2021 Paul.  We should be catching all errors. 
				try
				{
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						ExchangeSync.SyncInbox(Session, service, con, this.EXCHANGE_ALIAS, this.USER_ID, true, DateTime.MinValue, sbErrors);
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}

			public static UserSync Create(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, XmlUtil XmlUtil, SyncError SyncError, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, ExchangeSync ExchangeSync, Guid gUSER_ID, bool bSyncAll)
			{
				ExchangeSync.UserSync User = null;
				SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					// 01/17/2017 Paul.  Get all columns so that we do not get an error when including OFFICE365_OAUTH_ENABLED. 
					sSQL = "select *                 " + ControlChars.CrLf
					     + "  from vwEXCHANGE_USERS  " + ControlChars.CrLf
					     + " where ASSIGNED_USER_ID  = @USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
						using ( IDataReader row = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( row.Read() )
							{
								string sEXCHANGE_ALIAS     = Sql.ToString(row["EXCHANGE_ALIAS"    ]);
								string sEXCHANGE_EMAIL     = Sql.ToString(row["EXCHANGE_EMAIL"    ]);
								Guid   gASSIGNED_USER_ID   = Sql.ToGuid  (row["ASSIGNED_USER_ID"  ]);
								string sEXCHANGE_WATERMARK = Sql.ToString(row["EXCHANGE_WATERMARK"]);
								string sMAIL_SMTPUSER      = Sql.ToString(row["MAIL_SMTPUSER"     ]);
								string sMAIL_SMTPPASS      = Sql.ToString(row["MAIL_SMTPPASS"     ]);
								// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
								bool bOFFICE365_OAUTH_ENABLED = false;
								try
								{
									bOFFICE365_OAUTH_ENABLED = Sql.ToBoolean(row["OFFICE365_OAUTH_ENABLED"]);
								}
								catch
								{
								}
								User = new ExchangeSync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, XmlUtil, SyncError, ExchangeSecurity, ExchangeUtils, ExchangeSync, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gASSIGNED_USER_ID, sEXCHANGE_WATERMARK, bSyncAll, bOFFICE365_OAUTH_ENABLED);
							}
						}
					}
				}
				return User;
			}
		}

		#endregion

		#region Sync
		// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
		public void Sync(UserSync User, StringBuilder sbErrors)
		{
			// 01/22/2012 Paul.  If the last sync was less than 15 seconds ago, then skip this request. 
			lock ( dictLastSync )
			{
				if ( dictLastSync.ContainsKey(User.USER_ID) )
				{
					DateTime dtLastSync = dictLastSync[User.USER_ID];
					if ( dtLastSync.AddSeconds(15) > DateTime.Now )
						return;
				}
			}
			// 03/29/2010 Paul.  We need to make sure that we only have one processing operation at a time. 
			if ( !arrProcessing.Contains(User.USER_ID) )
			{
				lock ( arrProcessing )
				{
					arrProcessing.Add(User.USER_ID);
					// 01/22/2012 Paul.  Keep track of the last time we synced to prevent it from being too frequent. 
					dictLastSync[User.USER_ID] = DateTime.Now;
				}
				RemoteCertificateValidationCallback OriginalValidator = ServicePointManager.ServerCertificateValidationCallback;
				try
				{
					ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
					// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
					ExchangeService service = ExchangeUtils.CreateExchangeService(User);
#if DEBUG
					service.TraceEnabled = true;
#endif
					DataTable dtUserFolders = null;
					// 04/05/2010 Paul.  When the Watermark is empty, no events will be created for existing items. 
					if ( User.SyncAll )
					{
						User.EXCHANGE_WATERMARK = String.Empty;
						// 04/25/2010 Paul.  If this is a SyncAll, then we need to stop any existing subscriptions. 
						StopPullSubscription(User.USER_ID);
						StopPushSubscription(User.USER_ID);
					}
					bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
					
					// 04/04/2010 Paul.  For now, we are still going to poll the Contacts and Appointments separately. 
					// It may make sense to have separate subscriptions for Contacts or Appointments. 
					// 04/06/2010 Paul.  Contacts and Appointment folders are not part of the subscription, but we still need to send CRM changes. 
					// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
					// 02/12/2021 Paul.  Allow disable contacts. 
					bool bDisableContacts = Sql.ToBoolean(Application["CONFIG.Exchange.DisableContacts"]);
					if ( !bDisableContacts )
						this.SyncContacts    (Session, service, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
					// 08/14/2017 Paul.  A customer wanted to disable appointments because it was interferring with Skype for Business.  The created call is causing Skype to be set to busy. 
					bool bDisableAppointments = Sql.ToBoolean(Application["CONFIG.Exchange.DisableAppointments"]);
					if ( !bDisableAppointments )
						this.SyncAppointments(Session, service, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
					
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						
						string sSQL = String.Empty;
						// 06/03/2010 Paul.  View name is too long for Oracle.  Reduce using metadata function. 
						sSQL = "select ID                              " + ControlChars.CrLf
						     + "     , NAME                            " + ControlChars.CrLf
						     + "     , MODULE_NAME                     " + ControlChars.CrLf
						     + "     , NAME_CHANGED                    " + ControlChars.CrLf
						     + "     , NEW_FOLDER                      " + ControlChars.CrLf
						     + "     , REMOTE_KEY                      " + ControlChars.CrLf
						     + "  from " + Sql.MetadataName(con, "vwEXCHANGE_USERS_FOLDERS_Changed") + ControlChars.CrLf
						     + " where USER_ID = @USER_ID              " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@USER_ID", User.USER_ID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtChanges = new DataTable() )
								{
									da.Fill(dtChanges);
									if ( dtChanges.Rows.Count > 0 )
									{
										DataView vwChanges = new DataView(dtChanges);
										// 04/05/2010 Paul.  If there are new folders, then remove the existing subscription so that it can be created again. 
										vwChanges.RowFilter = "NEW_FOLDER = 1";
										if ( vwChanges.Count > 0 )
										{
											// 04/22/2010 Paul.  Log the folder status. 
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: " + vwChanges.Count.ToString() + " new folders for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString());
											StopPullSubscription(User.USER_ID);
											StopPushSubscription(User.USER_ID);
											// 04/07/2010 Paul.  If a new folder is added, we need to clear the folder and recompute the subscriptions. 
											SplendidCache.ClearExchangeFolders(User.USER_ID);
											
											// 04/22/2010 Paul.  We need to clear the module folders table any time the subscription changes. 
											DataTable dtSync = SplendidCache.ExchangeModulesSync();
											foreach ( DataRow rowModule in dtSync.Rows )
											{
												string sMODULE_NAME      = Sql.ToString (rowModule["MODULE_NAME"     ]);
												bool   bEXCHANGE_FOLDERS = Sql.ToBoolean(rowModule["EXCHANGE_FOLDERS"]);
												if ( bEXCHANGE_FOLDERS )
												{
													SplendidCache.ClearExchangeModulesFolders(sMODULE_NAME, User.USER_ID);
												}
											}
										}
										vwChanges.RowFilter = "NAME_CHANGED = 1";
										if ( vwChanges.Count > 0 )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: " + vwChanges.Count.ToString() + " changed folders for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString());
											foreach ( DataRowView row in vwChanges )
											{
												Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"         ]);
												string sPARENT_NAME = Sql.ToString(row["NAME"       ]);
												string sMODULE_NAME = Sql.ToString(row["MODULE_NAME"]);
												string sREMOTE_KEY  = Sql.ToString(row["REMOTE_KEY" ]);
												if ( !Sql.IsEmptyString(sPARENT_NAME) && !Sql.IsEmptyString(sREMOTE_KEY) )
												{
													try
													{
														Folder fld = Folder.Bind(service, sREMOTE_KEY);
														fld.DisplayName = sPARENT_NAME;
														fld.Update();
														using ( IDbTransaction trn = Sql.BeginTransaction(con) )
														{
															try
															{
																// 03/11/2012 Paul.  The well known flag should be false.  This is not really a bug as the folder record is not created here. 
																SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fld.Id.UniqueId, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, false, trn);
																trn.Commit();
															}
															catch
															{
																trn.Rollback();
																throw;
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
									}
								}
							}
						}
						bool   bInboxRoot           = Sql.ToBoolean(Application["CONFIG.Exchange.InboxRoot"          ]);
						bool   bSentItemsRoot       = Sql.ToBoolean(Application["CONFIG.Exchange.SentItemsRoot"      ]);
						// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
						bool   bSentItemsSync       = Sql.ToBoolean(Application["CONFIG.Exchange.SentItemsSync"      ]);
						// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
						bool   bInboxSync           = Sql.ToBoolean(Application["CONFIG.Exchange.InboxSync"          ]);
						bool   bPushNotifications   = Sql.ToBoolean(Application["CONFIG.Exchange.PushNotifications"  ]);
						int    nPushFrequency       = Sql.ToInteger(Application["CONFIG.Exchange.PushFrequency"      ]);
						string sPushNotificationURL = Sql.ToString (Application["CONFIG.Exchange.PushNotificationURL"]);
						// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
						string sCRM_FOLDER_NAME     = Sql.ToString (Application["CONFIG.Exchange.CrmFolderName"      ]);
						if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
							sCRM_FOLDER_NAME = "SplendidCRM";
						// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
						string sCALENDAR_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Calendar.Category"]);
						string sCONTACTS_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Contacts.Category"]);
						// 04/07/2010 Paul.  If the Push URL is empty, then Push will not be used. 
						if ( Sql.IsEmptyString(sPushNotificationURL) )
							bPushNotifications = false;
						if ( nPushFrequency <= 0 )
							nPushFrequency = 1;
						else if ( nPushFrequency > 1440 )
							nPushFrequency = 1440;
						// 06/25/2018 Paul.  We don't want the max of 1440 as it would take too long to wait for a reset. 
						// 07/05/2018 Paul.  Allow PullNotificationTimeout to be configurable. 
						int nPullNotificationTimeout = Sql.ToInteger(Application["CONFIG.Exchange.PullNotificationTimeout"]);
						if ( nPullNotificationTimeout <= 0 || nPullNotificationTimeout > 1440 )
							nPullNotificationTimeout = 4 * 60;
						
						SubscriptionBase subscription = null;
						Dictionary<Guid, SubscriptionBase> dictSubscriptions = null;
						if ( bPushNotifications )
							dictSubscriptions = dictPushSubscriptions;
						else
							dictSubscriptions = dictPullSubscriptions;

						// 07/07/2018 Paul.  Add the SplendidCRM category to the user's master list if it does not already exist. 
						// https://stackoverflow.com/questions/42679735/how-to-create-and-associate-a-category-to-a-contact-using-ews-managed-api-2-2
						// https://social.technet.microsoft.com/Forums/office/en-US/e5c5f072-0b5c-49ce-9db7-57f76f5e011e/edit-master-category-list-in-exchange-2010-via-ews?forum=exchangesvrdevelopment
						// https://social.msdn.microsoft.com/Forums/en-US/a3917500-2bbc-4def-98b4-696e49efed6f/adding-categories-to-a-users-master-category-list-in-exchange-2010-using-ews?forum=exchangesvrdevelopment
						if ( Sql.ToString(Application["CONFIG.Exchange.Version"]) != "Exchange2007_SP1" && !dictSplendidCategories.ContainsKey(User.USER_ID) )
						{
							dictSplendidCategories.Add(User.USER_ID, User.EXCHANGE_ALIAS);
							try
							{
								UserConfiguration config = UserConfiguration.Bind(service, "CategoryList", WellKnownFolderName.Calendar, UserConfigurationProperties.All);
								string sXmlData = Encoding.UTF8.GetString(config.XmlData);
								// 07/07/2018 Paul.  There seems to be a character set issue with the <?xml begin. 
								int nStart = sXmlData.IndexOf("<categories");
								if ( nStart > 0 )
								{
									sXmlData = sXmlData.Substring(nStart);
								}
								XmlDocument xml = new XmlDocument();
								xml.LoadXml(sXmlData);
								Debug.Write(sXmlData);
								XmlNode xSplendidCRM = xml.DocumentElement.SelectSingleNode("//*[@name=\'" + sCALENDAR_CATEGORY + "\']");
								if ( xSplendidCRM == null )
								{
									xSplendidCRM = xml.CreateElement("category");
									XmlUtil.SetSingleNodeAttribute(xml, xSplendidCRM, "name", sCALENDAR_CATEGORY);
									XmlUtil.SetSingleNodeAttribute(xml, xSplendidCRM, "color", "-1");
									XmlUtil.SetSingleNodeAttribute(xml, xSplendidCRM, "guid", Guid.NewGuid().ToString());
									xml.DocumentElement.AppendChild(xSplendidCRM);
									sXmlData = xml.OuterXml;
									Debug.Write(sXmlData);
									config.XmlData = Encoding.UTF8.GetBytes(sXmlData);
									config.Update();
								}
							}
							catch(Exception ex)
							{
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), ex);
								SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), ex);
							}
						}

						if ( !dictSubscriptions.ContainsKey(User.USER_ID) )
						{
							// 04/06/2010 Paul.  First check if there are any existing Exchange Folders. 
							// If not, then we want to perform a Sync All so that all folders are created. 
							dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
							if ( dtUserFolders.Rows.Count == 0 )
								User.SyncAll = true;
							
							if ( User.SyncAll )
							{
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										Folder fldContacts = Folder.Bind(service, WellKnownFolderName.Contacts);
										SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldContacts.Id.UniqueId, "Contacts", Guid.Empty, String.Empty, true, trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										throw;
									}
								}
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										Folder fldCalendar = Folder.Bind(service, WellKnownFolderName.Calendar);
										SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldCalendar.Id.UniqueId, "Calendar", Guid.Empty, String.Empty, true, trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										throw;
									}
								}
								// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
								if ( bSentItemsSync )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											Folder fldSentItems = Folder.Bind(service, WellKnownFolderName.SentItems);
											SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldSentItems.Id.UniqueId, "Sent Items", Guid.Empty, String.Empty, true, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
								if ( bInboxSync )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											Folder fldInbox = Folder.Bind(service, WellKnownFolderName.Inbox);
											SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldInbox.Id.UniqueId, "Inbox", Guid.Empty, String.Empty, true, trn);
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
							
							DataTable dtSync = SplendidCache.ExchangeModulesSync();
							
							WellKnownFolderName fldExchangeRoot = WellKnownFolderName.MsgFolderRoot;
							Folder fldSplendidRoot = null;
							Folder fldModuleFolder = null;
							if ( bInboxRoot )
								fldExchangeRoot = WellKnownFolderName.Inbox;
							// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
							this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, String.Empty, Guid.Empty, String.Empty, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
							
							foreach ( DataRow rowModule in dtSync.Rows )
							{
								fldModuleFolder = null;
								string sMODULE_NAME      = Sql.ToString (rowModule["MODULE_NAME"     ]);
								bool   bEXCHANGE_FOLDERS = Sql.ToBoolean(rowModule["EXCHANGE_FOLDERS"]);
								// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
								this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, Guid.Empty, String.Empty, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
								if ( bEXCHANGE_FOLDERS )
								{
									DataTable dtModuleFolders = SplendidCache.ExchangeModulesFolders(sMODULE_NAME, User.USER_ID);
									//04/04/2010 Paul.  ExchangeModulesFolders can return NULL if Exchange Folders is not supported. 
									// At this time, only Accounts, Bugs, Cases, Contacts, Leads, Opportunities and Projects are supported. 
									if ( dtModuleFolders != null )
									{
										foreach ( DataRow rowFolder in dtModuleFolders.Rows )
										{
											Guid   gPARENT_ID   = Sql.ToGuid   (rowFolder["ID"        ]);
											string sPARENT_NAME = Sql.ToString (rowFolder["NAME"      ]);
											// 05/14/2010 Paul.  We need the NEW_FOLDER flag to determine if we should perform a first SyncAll. 
											bool   bNEW_FOLDER  = Sql.ToBoolean(rowFolder["NEW_FOLDER"]);
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll || bNEW_FOLDER, sbErrors);
										}
									}
								}
							}
							if ( bSentItemsRoot )
							{
								fldExchangeRoot = WellKnownFolderName.SentItems;
								fldSplendidRoot = null;
								fldModuleFolder = null;
								// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
								this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, String.Empty, Guid.Empty, String.Empty, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
								
								foreach ( DataRow rowModule in dtSync.Rows )
								{
									fldModuleFolder = null;
									string sMODULE_NAME      = Sql.ToString (rowModule["MODULE_NAME"     ]);
									bool   bEXCHANGE_FOLDERS = Sql.ToBoolean(rowModule["EXCHANGE_FOLDERS"]);
									// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
									this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, Guid.Empty, String.Empty, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
									if ( bEXCHANGE_FOLDERS )
									{
										DataTable dtModuleFolders = SplendidCache.ExchangeModulesFolders(sMODULE_NAME, User.USER_ID);
										//04/04/2010 Paul.  ExchangeModulesFolders can return NULL if Exchange Folders is not supported. 
										// At this time, only Accounts, Bugs, Cases, Contacts, Leads, Opportunities and Projects are supported. 
										if ( dtModuleFolders != null )
										{
											foreach ( DataRow rowFolder in dtModuleFolders.Rows )
											{
												Guid   gPARENT_ID   = Sql.ToGuid  (rowFolder["ID"  ]);
												string sPARENT_NAME = Sql.ToString(rowFolder["NAME"]);
												// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
												this.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, User.EXCHANGE_ALIAS, User.USER_ID, User.SyncAll, sbErrors);
											}
										}
									}
								}
							}
							
							bool bFolderDeleted = false;
							StringBuilder sbUserFolders = new StringBuilder();
							List<FolderId> arrFolders = new List<FolderId>();
							SplendidCache.ClearExchangeFolders(User.USER_ID);
							dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
							// 03/11/2012 Paul.  The Sent Items Sync flag is new, so we need to check if an existing user needs to have the Sent Items included in the sync. 
							if ( bSentItemsSync )
							{
								DataView vwSentItems = new DataView(dtUserFolders);
								vwSentItems.RowFilter = "WELL_KNOWN_FOLDER = 1 and MODULE_NAME = 'Sent Items'";
								if ( vwSentItems.Count == 0 )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											Folder fldSentItems = Folder.Bind(service, WellKnownFolderName.SentItems);
											SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldSentItems.Id.UniqueId, "Sent Items", Guid.Empty, String.Empty, true, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
									SplendidCache.ClearExchangeFolders(User.USER_ID);
									dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
								}
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: SyncSentItems for " + User.EXCHANGE_ALIAS);
								// 03/11/2012 Paul.  The Sent Items folder can be very large, so only get the messages from the last 2 hours. 
								this.SyncSentItems(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, false, DateTime.UtcNow.AddHours(-2), sbErrors);
							}
							// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
							if ( bInboxSync )
							{
								DataView vwInbox = new DataView(dtUserFolders);
								vwInbox.RowFilter = "WELL_KNOWN_FOLDER = 1 and MODULE_NAME = 'Inbox'";
								if ( vwInbox.Count == 0 )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											Folder fldInbox = Folder.Bind(service, WellKnownFolderName.Inbox);
											SqlProcs.spEXCHANGE_FOLDERS_Update(User.USER_ID, fldInbox.Id.UniqueId, "Inbox", Guid.Empty, String.Empty, true, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
									SplendidCache.ClearExchangeFolders(User.USER_ID);
									dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
								}
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: SyncInbox for " + User.EXCHANGE_ALIAS);
								// 07/05/2017 Paul.  The Inbox folder can be very large, so only get the messages from the last 2 hours. 
								this.SyncInbox(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, false, DateTime.UtcNow.AddHours(-2), sbErrors);
							}
							foreach ( DataRow row in dtUserFolders.Rows )
							{
								string sREMOTE_KEY  = Sql.ToString(row["REMOTE_KEY" ]);
								string sMODULE_NAME = Sql.ToString(row["MODULE_NAME"]);
								string sPARENT_NAME = Sql.ToString(row["PARENT_NAME"]);
								// 05/14/2010 Paul.  The folder may have been deleted in Exchange.  The subscription will fail if any of the folders does not exist. 
								// So we need to validate each folder and remove it from the list if it does not exist. 
								try
								{
									Folder fld = Folder.Bind(service, sREMOTE_KEY);
									// 05/14/2010 Paul.  We expect a missing folder to throw an exception. 
									arrFolders.Add(sREMOTE_KEY);
								}
								catch
								{
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Deleting folder " + sPARENT_NAME + " in " + sMODULE_NAME);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEXCHANGE_FOLDERS_Delete(User.USER_ID, sREMOTE_KEY, trn);
											trn.Commit();
											bFolderDeleted = true;
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								// 04/25/2010 Paul.  Exclude the SplendidCRM Root folder. 
								if ( !Sql.IsEmptyString(sMODULE_NAME) )
								{
									if ( sbUserFolders.Length > 0 )
										sbUserFolders.Append(", ");
									sbUserFolders.AppendLine(sMODULE_NAME + (Sql.IsEmptyString(sPARENT_NAME) ? String.Empty : " - " + sPARENT_NAME));
								}
							}
							if ( bFolderDeleted )
							{
								SplendidCache.ClearExchangeFolders(User.USER_ID);
								dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
							}
							// 04/25/2010 Paul.  Include the folders getting sync'd in the status message. 
							// 06/30/2018 Paul.  Include the machine name to help debug. 
							string sMachineName = String.Empty;
							try
							{
								// 06/30/2018 Paul.  Azure does not support MachineName.  Just ignore the error. 
								// 07/06/2018 Paul.  ServerName and ApplicationPath may be more useful for those times when two apps are running on the same machine. 
								sMachineName = Sql.ToString(Application["ServerName"]) + Sql.ToString(Application["ApplicationPath"]);  // System.Environment.MachineName;
							}
							catch
							{
							}
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Adding " + (bPushNotifications ? "Push" : "Pull") + " subscription for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString() + " on " + sMachineName + "." + ControlChars.CrLf + "Folders: " + sbUserFolders.ToString());
							
							List<EventType> arrEvents  = new List<EventType>();
							// 04/22/2010 Paul.  Definitely need the Created event, otherwise we will not get Contact or Appointment creation events. 
							arrEvents.Add(EventType.Created );
							arrEvents.Add(EventType.Modified);
							arrEvents.Add(EventType.Moved   );
							arrEvents.Add(EventType.Copied  );
							// 04/05/2010 Paul.  Set the timeout to 60 minutes. We want the pull service to last as long as possible. 
							try
							{
								// 06/23/2018 Paul.  The timeout is in minutes, so the pull subscription was previously only valid for 1 hour. 
								if ( bPushNotifications )
									subscription = service.SubscribeToPushNotifications(arrFolders, new Uri(sPushNotificationURL), nPushFrequency, User.EXCHANGE_WATERMARK, arrEvents.ToArray());
								else
									subscription = service.SubscribeToPullNotifications(arrFolders, nPullNotificationTimeout, User.EXCHANGE_WATERMARK, arrEvents.ToArray());
								dictSubscriptions.Add(User.USER_ID, subscription);
								// 04/26/2010 Paul.  We should update with the latest watermark anytime we start a subscription. 
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										SqlProcs.spEXCHANGE_USERS_UpdateWatermark(User.USER_ID, subscription.Watermark, trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										throw;
									}
								}
							}
							catch(Exception ex)
							{
								// 04/22/2010 Paul.  Not sure if there is a better way to catch exception. 
								// 12/12/2017 Paul.  Alternate error message: The watermark is invalid.
								if ( ex.Message.StartsWith("The watermark used for creating this subscription was not found") 
								  || ex.Message.Contains("The watermark is invalid.") )
								{
									User.EXCHANGE_WATERMARK = String.Empty;
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEXCHANGE_USERS_UpdateWatermark(User.USER_ID, User.EXCHANGE_WATERMARK, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
									// 04/22/2010 Paul.  Now that we have reset the watermark, we can create a new subscription. 
									// 06/23/2018 Paul.  The timeout is in minutes, so the pull subscription was previously only valid for 1 hour. 
									if ( bPushNotifications )
										subscription = service.SubscribeToPushNotifications(arrFolders, new Uri(sPushNotificationURL), nPushFrequency, User.EXCHANGE_WATERMARK, arrEvents.ToArray());
									else
										subscription = service.SubscribeToPullNotifications(arrFolders, nPullNotificationTimeout, User.EXCHANGE_WATERMARK, arrEvents.ToArray());
									dictSubscriptions.Add(User.USER_ID, subscription);
									// 04/26/2010 Paul.  We should update with the latest watermark anytime we start a subscription. 
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEXCHANGE_USERS_UpdateWatermark(User.USER_ID, subscription.Watermark, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								else
								{
									string sError = "Sync: Error subscribing " + User.EXCHANGE_ALIAS + "." + ControlChars.CrLf;
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
						else
						{
							dtUserFolders = SplendidCache.ExchangeFolders(User.USER_ID);
							subscription = dictSubscriptions[User.USER_ID];
						}
						
						if ( subscription is PullSubscription )
						{
							PullSubscription pull = subscription as PullSubscription;
							DataView vwUserFolders = new DataView(dtUserFolders);
							do
							{
								bool bUpdateWatermark = false;
								// 04/26/2010 Paul.  The Pull.Watermark changes with each call to GetEvents. 
								// 05/20/2018 Paul.  Catch the error and remove the subscription.  It will be created again in the next scheduled event. 
								GetEventsResults results = null;
								try
								{
									results = pull.GetEvents();
								}
								catch(Exception ex)
								{
									// 06/22/2018 Paul.  Subscription timeout will be be detected with the Unauthorized error. 
									if ( ex.Message.StartsWith("The specified subscription was not found.") || ex.Message.Contains("(401) Unauthorized") )
									{
										// 06/23/2018 Paul.  Now that we know the problem was the expected timeout, no need to log the event. 
										//string sError = "Exchange.Sync: Error in pull.GetEvents() for " + User.EXCHANGE_ALIAS + ", pull subscription will be dropped and recreated.<br />" + ControlChars.CrLf;
										//sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										//SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										//StopPullSubscription(User.USER_ID);
										// 06/23/2018 Paul.  We don't need 2 errors in the log, so don't bother to call pull.Unsubscribe(). 
										// 06/25/2018 Paul.  We are getting the following error, so at least try to unsubscribe. 
										// You have exceeded the available subscriptions for your account. Remove unnecessary subscriptions and try your request again. 
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Sync: Stopping Pull" + " subscription for " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString() + ". " + ex.Message);
										try
										{
											pull.Unsubscribe();
										}
										catch
										{
										}
										dictPullSubscriptions.Remove(User.USER_ID);
									}
									// 06/22/2018 Paul.  Return instead of throw as we do not need to catch this higher up the stack. 
									return;
								}
								foreach ( ItemEvent evt in results.ItemEvents )
								{
									// evt.OldItemId;
									// evt.OldParentFolderId;
									// evt.EventType
									string sItemID         = evt.ItemId.UniqueId;
									string sParentFolderId = evt.ParentFolderId.UniqueId;
									vwUserFolders.RowFilter = "REMOTE_KEY = '" + sParentFolderId + "'";
									if ( vwUserFolders.Count > 0 )
									{
										DataRowView row = vwUserFolders[0];
										string sREMOTE_KEY        = Sql.ToString (row["REMOTE_KEY"       ]);
										string sMODULE_NAME       = Sql.ToString (row["MODULE_NAME"      ]);
										Guid   gPARENT_ID         = Sql.ToGuid   (row["PARENT_ID"        ]);
										string sPARENT_NAME       = Sql.ToString (row["PARENT_NAME"      ]);
										bool   bWELL_KNOWN_FOLDER = Sql.ToBoolean(row["WELL_KNOWN_FOLDER"]);
										try
										{
											if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Contacts" )
											{
												// 12/12/2017 Paul.  Capture and ignore error.  We are seeing Emails in the Contacts folder. 
												Contact contact = null;
												try
												{
													contact = Contact.Bind(service, sItemID);
												}
												catch
												{
												}
												// 04/07/2010 Paul.  The subscription means that we will get a change event for all items, 
												// so we need to make sure and filter only those that are marked as SplendidCRM. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												// 12/12/2017 Paul.  Capture and ignore error.  We are seeing Emails in the Contacts folder. 
												if ( contact != null && (Sql.IsEmptyString(sCONTACTS_CATEGORY) || contact.Categories.Contains(sCONTACTS_CATEGORY)) )
												{
													// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
													this.ImportContact(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, contact, sbErrors);
													bUpdateWatermark = true;
												}
											}
											else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Calendar" )
											{
												// 03/26/2013 Paul.  When an appointment is created using Outlook Web Access, it seems to create and delete multiple records. 
												// A few others have reported this problem and it only seems to happen with appointments. 
												Appointment appointment = null;
												try
												{
													appointment = Appointment.Bind(service, sItemID);
												}
												catch
												{
												}
												// 04/07/2010 Paul.  The subscription means that we will get a change event for all items, 
												// so we need to make sure and filter only those that are marked as SplendidCRM. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												if ( appointment != null && (Sql.IsEmptyString(sCALENDAR_CATEGORY) || appointment.Categories.Contains(sCALENDAR_CATEGORY)) )
												{
													// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
													this.ImportAppointment(Session, service, con, User.EXCHANGE_ALIAS, User.USER_ID, appointment, sbErrors);
													bUpdateWatermark = true;
												}
											}
											// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
											else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Sent Items" )
											{
												EmailMessage email = EmailMessage.Bind(service, sItemID);
												this.ImportSentItem(Session, con, User.EXCHANGE_ALIAS, User.USER_ID, email, sbErrors);
												bUpdateWatermark = true;
											}
											// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
											else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Inbox" )
											{
												EmailMessage email = EmailMessage.Bind(service, sItemID);
												string sItemClass  = email.ItemClass;
												if ( sItemClass == "IPM.Note" )
												{
													this.ImportInbox(Session, con, User.EXCHANGE_ALIAS, User.USER_ID, email, sbErrors);
													bUpdateWatermark = true;
												}
											}
											else
											{
												EmailMessage email = EmailMessage.Bind(service, sItemID);
												// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
												this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, User.EXCHANGE_ALIAS, User.USER_ID, email, sbErrors);
												bUpdateWatermark = true;
											}
										}
										catch(Exception ex)
										{
											string sError = "Sync: Error retrieving " + sREMOTE_KEY + " for " + User.EXCHANGE_ALIAS + "." + ControlChars.CrLf;
											sError += Utils.ExpandException(ex) + ControlChars.CrLf;
											SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
											sbErrors.AppendLine(sError);
										}
									}
								}
								// 04/26/2010 Paul.  The Pull.Watermark changes with each call to GetEvents. 
								// We need to make sure to update the database value any time we notice a change. 
								if ( bUpdateWatermark )
								{
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEXCHANGE_USERS_UpdateWatermark(User.USER_ID, pull.Watermark, trn);
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
							while ( pull.MoreEventsAvailable.Value );
						}
					}
				}
				finally
				{
					lock ( arrProcessing )
					{
						arrProcessing.Remove(User.USER_ID);
					}
					ServicePointManager.ServerCertificateValidationCallback = OriginalValidator;
				}
			}
			else
			{
				// 04/25/2010 Paul.  Lets log the busy status. 
				string sError = "Sync:  Already busy processing " + User.EXCHANGE_ALIAS + ", " + User.USER_ID.ToString();
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
				sbErrors.AppendLine(sError);
			}
		}
		#endregion

		#region Sync Contacts
		// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
		private bool SetExchangeContact(Contact contact, DataRow row, StringBuilder sbChanges, string sCONTACTS_CATEGORY)
		{
			bool bChanged = false;
			// 03/28/2010 Paul.  An empty FileAs will cause an exception when calling Contact.Bind(); 
			string sFILE_AS = Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]);
			sFILE_AS = sFILE_AS.Trim();
			if ( Sql.IsEmptyString(sFILE_AS) )
				sFILE_AS = "(no name)";
			if ( contact.IsNew )
			{
				// 03/28/2010 Paul.  You must load or assign this property before you can read its value. 
				// So set all the fields to empty values. 
				// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
				// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
				if ( !Sql.IsEmptyString(sCONTACTS_CATEGORY) )
					contact.Categories.Add(sCONTACTS_CATEGORY);
				contact.GivenName     = Sql.ToString  (row["FIRST_NAME"  ]);
				contact.Surname       = Sql.ToString  (row["LAST_NAME"   ]);
				contact.CompanyName   = Sql.ToString  (row["ACCOUNT_NAME"]);
				contact.JobTitle      = Sql.ToString  (row["TITLE"       ]);
				contact.Department    = Sql.ToString  (row["DEPARTMENT"  ]);
				contact.AssistantName = Sql.ToString  (row["ASSISTANT"   ]);
				contact.Birthday      = Sql.ToDateTime(row["BIRTHDATE"   ]);
				contact.Body          = Sql.ToString  (row["DESCRIPTION" ]);
				// 03/28/2010 Paul.  An empty FileAs will cause an exception when calling Contact.Bind(); 
				contact.FileAs        = sFILE_AS;
				// 03/28/2010 Paul.  An empty Email Address will cause an exception; 
				// We cannot even check for the existance of the email due to a bug in the API. 
				if ( !Sql.IsEmptyString(row["EMAIL1"]) )
					contact.EmailAddresses[EmailAddressKey.EmailAddress1] = new EmailAddress(Sql.ToString(row["EMAIL1"]));
				if ( !Sql.IsEmptyString(row["EMAIL2"]) )
					contact.EmailAddresses[EmailAddressKey.EmailAddress2] = new EmailAddress(Sql.ToString(row["EMAIL2"]));
				
				contact.PhoneNumbers[PhoneNumberKey.AssistantPhone] = Sql.ToString(row["ASSISTANT_PHONE"]);
				contact.PhoneNumbers[PhoneNumberKey.BusinessFax   ] = Sql.ToString(row["PHONE_FAX"      ]);
				contact.PhoneNumbers[PhoneNumberKey.BusinessPhone ] = Sql.ToString(row["PHONE_WORK"     ]);
				contact.PhoneNumbers[PhoneNumberKey.MobilePhone   ] = Sql.ToString(row["PHONE_MOBILE"   ]);
				contact.PhoneNumbers[PhoneNumberKey.OtherTelephone] = Sql.ToString(row["PHONE_OTHER"    ]);
				contact.PhoneNumbers[PhoneNumberKey.HomePhone     ] = Sql.ToString(row["PHONE_HOME"     ]);
				
				contact.PhysicalAddresses[PhysicalAddressKey.Business  ] = new PhysicalAddressEntry();
				contact.PhysicalAddresses[PhysicalAddressKey.Other     ] = new PhysicalAddressEntry();
				contact.PhysicalAddresses[PhysicalAddressKey.Business  ].Street          = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);
				contact.PhysicalAddresses[PhysicalAddressKey.Business  ].City            = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);
				contact.PhysicalAddresses[PhysicalAddressKey.Business  ].State           = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);
				contact.PhysicalAddresses[PhysicalAddressKey.Business  ].PostalCode      = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);
				contact.PhysicalAddresses[PhysicalAddressKey.Business  ].CountryOrRegion = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);
				contact.PhysicalAddresses[PhysicalAddressKey.Other     ].Street          = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);
				contact.PhysicalAddresses[PhysicalAddressKey.Other     ].City            = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);
				contact.PhysicalAddresses[PhysicalAddressKey.Other     ].State           = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);
				contact.PhysicalAddresses[PhysicalAddressKey.Other     ].PostalCode      = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);
				contact.PhysicalAddresses[PhysicalAddressKey.Other     ].CountryOrRegion = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);
				bChanged = true;
			}
			else
			{
				// 03/29/2010 Paul.  Lets not always add the SplendidCRM category, but only do it during creation. 
				// This should not be an issue as we currently do not lookup the Exchange user when creating a contact that originated from the CRM. 
				// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
				//if ( !contact.Categories.Contains(sCRM_FOLDER_NAME) )
				//{
				//	contact.Categories.Add(sCRM_FOLDER_NAME);
				//	bChanged = true;
				//}
				string   sBody          = String.Empty;
				DateTime dtBirthday     = DateTime.MinValue;
				string   sEmailAddress1 = String.Empty;
				string   sEmailAddress2 = String.Empty;
				string   sFileAs        = String.Empty;
				try
				{
					sFileAs = Sql.ToString(contact.FileAs);
					sBody   = Sql.ToString(contact.Body  );
				}
				catch
				{
				}
				try
				{
					dtBirthday = contact.Birthday.Value;
					// 03/28/2010 Paul.  Check for Exchange minimum date. 
					if ( dtBirthday.Year < 1753 )
						dtBirthday = DateTime.MinValue;
				}
				catch
				{
				}
				try
				{
					// 03/28/2010 Paul.  An empty Email Address will cause an exception.  
					// We cannot even check for the existance of the email due to a bug in the API. 
					if ( !contact.IsNew && contact.EmailAddresses.Contains(EmailAddressKey.EmailAddress1) )
						sEmailAddress1 = Sql.ToString(contact.EmailAddresses[EmailAddressKey.EmailAddress1].Address);
				}
				catch
				{
				}
				try
				{
					// 03/28/2010 Paul.  An empty Email Address will cause an exception.  
					// We cannot even check for the existance of the email due to a bug in the API. 
					if ( !contact.IsNew && contact.EmailAddresses.Contains(EmailAddressKey.EmailAddress2) )
						sEmailAddress2 = Sql.ToString(contact.EmailAddresses[EmailAddressKey.EmailAddress2].Address);
				}
				catch
				{
				}
				// 03/28/2010 Paul.  When updating the description, we need to maintain the HTML flag. 
				string   sDESCRIPTION  = Sql.ToString(row["DESCRIPTION"]);
				// 06/22/2018 Paul.  Might include namespaces. 
				BodyType btDESCRIPTION = sDESCRIPTION.StartsWith("<html") ? BodyType.HTML : BodyType.Text;
				// 03/28/2010 Paul.  An empty Email Address will cause an exception when calling Contact.Bind(); 
				if ( sFileAs        != sFILE_AS                           ) { contact.FileAs                                        = sFILE_AS                                     ;  bChanged = true; sbChanges.AppendLine("FileAs "     + " changed."); }
				if ( sBody          != sDESCRIPTION                       ) { contact.Body                                          = new MessageBody(btDESCRIPTION, sDESCRIPTION) ;  bChanged = true; sbChanges.AppendLine("DESCRIPTION" + " changed."); }
				if ( dtBirthday     != Sql.ToDateTime(row["BIRTHDATE"  ]) ) { contact.Birthday                                      = Sql.ToDateTime(row["BIRTHDATE"])             ;  bChanged = true; sbChanges.AppendLine("BIRTHDATE"   + " changed."); }
				if ( sEmailAddress1 != Sql.ToString  (row["EMAIL1"     ]) )
				{
					// 03/11/2012 Paul.  Deleting an email address is throwing an exception: An object within a change description must contain one and only one property to modify.
					// http://social.technet.microsoft.com/Forums/en-US/exchangesvrdevelopment/thread/b57736cf-b007-49f6-b8c6-c4ba00b5cc23/
					if ( Sql.IsEmptyString(row["EMAIL1"]) )
					{
						/*
						// http://msdn.microsoft.com/en-us/library/cc842050.aspx
						ExtendedPropertyDefinition dispidEmail1DisplayName         = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008080, MapiPropertyType.String);
						ExtendedPropertyDefinition dispidEmail1AddrType            = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008082, MapiPropertyType.String);
						ExtendedPropertyDefinition dispidEmail1EmailAddress        = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008083, MapiPropertyType.String);
						ExtendedPropertyDefinition dispidEmail1OriginalDisplayName = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008084, MapiPropertyType.String);
						ExtendedPropertyDefinition dispidEmail1OriginalEntryID     = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008085, MapiPropertyType.String);
						//contact.RemoveExtendedProperty(dispidEmail1DisplayName        );
						//contact.RemoveExtendedProperty(dispidEmail1AddrType           );
						//contact.RemoveExtendedProperty(dispidEmail1EmailAddress       );
						//contact.RemoveExtendedProperty(dispidEmail1OriginalDisplayName);
						//contact.RemoveExtendedProperty(dispidEmail1OriginalEntryID    );
						*/
						// 03/11/2012 Paul.  Still having a problem trying to delete an email address. 
						contact.EmailAddresses[EmailAddressKey.EmailAddress1] = new EmailAddress("@");
					}
					else
					{
						contact.EmailAddresses[EmailAddressKey.EmailAddress1] = new EmailAddress(Sql.ToString(row["EMAIL1"]));
					}
					bChanged = true;
					sbChanges.AppendLine("EMAIL1"      + " changed.");
				}
				if ( sEmailAddress2 != Sql.ToString  (row["EMAIL2"     ]) )
				{
					// 03/11/2012 Paul.  Deleting an email address is throwing an exception: An object within a change description must contain one and only one property to modify.
					if ( Sql.IsEmptyString(row["EMAIL2"]) )
					{
						/*
						// http://msdn.microsoft.com/en-us/library/cc842205.aspx
						ExtendedPropertyDefinition dispidEmail2DisplayName         = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008090, MapiPropertyType.String);
						ExtendedPropertyDefinition dispidEmail2AddrType            = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008092, MapiPropertyType.String);
						ExtendedPropertyDefinition dispidEmail2EmailAddress        = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008093, MapiPropertyType.String);
						ExtendedPropertyDefinition dispidEmail2OriginalDisplayName = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008094, MapiPropertyType.String);
						ExtendedPropertyDefinition dispidEmail2OriginalEntryID     = new ExtendedPropertyDefinition(DefaultExtendedPropertySet.Address, 0x00008095, MapiPropertyType.String);
						// The request failed schema validation: The element 'Updates' in namespace 'http://schemas.microsoft.com/exchange/services/2006/types' has incomplete content. List of possible elements expected: 'AppendToItemField, SetItemField, DeleteItemField' in namespace 'http://schemas.microsoft.com/exchange/services/2006/types'.
						//contact.RemoveExtendedProperty(dispidEmail2DisplayName        );
						//contact.RemoveExtendedProperty(dispidEmail2AddrType           );
						//contact.RemoveExtendedProperty(dispidEmail2EmailAddress       );
						//contact.RemoveExtendedProperty(dispidEmail2OriginalDisplayName);
						//contact.RemoveExtendedProperty(dispidEmail2OriginalEntryID    );
						*/
						// 03/11/2012 Paul.  Still having a problem trying to delete an email address. 
						contact.EmailAddresses[EmailAddressKey.EmailAddress2] = new EmailAddress("@");
					}
					else
					{
						contact.EmailAddresses[EmailAddressKey.EmailAddress2] = new EmailAddress(Sql.ToString(row["EMAIL2"]));
					}
					bChanged = true;
					sbChanges.AppendLine("EMAIL2"      + " changed.");
				}
				
				if ( Sql.ToString(contact.AssistantName                                                   ) != Sql.ToString(row["ASSISTANT"                 ]) ) { contact.AssistantName                                                    = Sql.ToString(row["ASSISTANT"                 ]);  bChanged = true; sbChanges.AppendLine("ASSISTANT"                  + " changed."); }
				if ( Sql.ToString(contact.CompanyName                                                     ) != Sql.ToString(row["ACCOUNT_NAME"              ]) ) { contact.CompanyName                                                      = Sql.ToString(row["ACCOUNT_NAME"              ]);  bChanged = true; sbChanges.AppendLine("ACCOUNT_NAME"               + " changed."); }
				if ( Sql.ToString(contact.Department                                                      ) != Sql.ToString(row["DEPARTMENT"                ]) ) { contact.Department                                                       = Sql.ToString(row["DEPARTMENT"                ]);  bChanged = true; sbChanges.AppendLine("DEPARTMENT"                 + " changed."); }
				if ( Sql.ToString(contact.GivenName                                                       ) != Sql.ToString(row["FIRST_NAME"                ]) ) { contact.GivenName                                                        = Sql.ToString(row["FIRST_NAME"                ]);  bChanged = true; sbChanges.AppendLine("FIRST_NAME"                 + " changed."); }
				if ( Sql.ToString(contact.JobTitle                                                        ) != Sql.ToString(row["TITLE"                     ]) ) { contact.JobTitle                                                         = Sql.ToString(row["TITLE"                     ]);  bChanged = true; sbChanges.AppendLine("TITLE"                      + " changed."); }
				if ( Sql.ToString(contact.Surname                                                         ) != Sql.ToString(row["LAST_NAME"                 ]) ) { contact.Surname                                                          = Sql.ToString(row["LAST_NAME"                 ]);  bChanged = true; sbChanges.AppendLine("LAST_NAME"                  + " changed."); }
				
				// 04/07/2010 Paul.  The BusinessFax is not a default field, so it might not exist. 
				// Due to a bug in the Managed API, we cannot set a blank value to an undefined field. 
				// An object within a change description must contain one and only one property to modify. 
				if ( !contact.PhoneNumbers.Contains(PhoneNumberKey.AssistantPhone) || Sql.ToString(contact.PhoneNumbers[PhoneNumberKey.AssistantPhone]) != Sql.ToString(row["ASSISTANT_PHONE"]) )
				{
					if ( !Sql.IsEmptyString(row["ASSISTANT_PHONE"]) || contact.PhoneNumbers.Contains(PhoneNumberKey.AssistantPhone) )
					{
						contact.PhoneNumbers[PhoneNumberKey.AssistantPhone] = Sql.ToString(row["ASSISTANT_PHONE"]);
						bChanged = true;
						sbChanges.AppendLine("ASSISTANT_PHONE"           + " changed.");
					}
				}
				if ( !contact.PhoneNumbers.Contains(PhoneNumberKey.BusinessFax   ) || Sql.ToString(contact.PhoneNumbers[PhoneNumberKey.BusinessFax   ]) != Sql.ToString(row["PHONE_FAX"      ]) )
				{
					if ( !Sql.IsEmptyString(row["PHONE_FAX"      ]) || contact.PhoneNumbers.Contains(PhoneNumberKey.BusinessFax   ) )
					{
						contact.PhoneNumbers[PhoneNumberKey.BusinessFax   ] = Sql.ToString(row["PHONE_FAX"      ]);
						bChanged = true;
						sbChanges.AppendLine("PHONE_FAX"                 + " changed.");
					}
				}
				if ( !contact.PhoneNumbers.Contains(PhoneNumberKey.BusinessPhone ) || Sql.ToString(contact.PhoneNumbers[PhoneNumberKey.BusinessPhone ]) != Sql.ToString(row["PHONE_WORK"     ]) )
				{
					if ( !Sql.IsEmptyString(row["PHONE_WORK"     ]) || contact.PhoneNumbers.Contains(PhoneNumberKey.BusinessPhone ) )
					{
						contact.PhoneNumbers[PhoneNumberKey.BusinessPhone ] = Sql.ToString(row["PHONE_WORK"     ]);
						bChanged = true;
						sbChanges.AppendLine("PHONE_WORK"                + " changed.");
					}
				}
				if ( !contact.PhoneNumbers.Contains(PhoneNumberKey.MobilePhone   ) || Sql.ToString(contact.PhoneNumbers[PhoneNumberKey.MobilePhone   ]) != Sql.ToString(row["PHONE_MOBILE"   ]) )
				{
					if ( !Sql.IsEmptyString(row["PHONE_MOBILE"   ]) || contact.PhoneNumbers.Contains(PhoneNumberKey.MobilePhone   ) )
					{
						contact.PhoneNumbers[PhoneNumberKey.MobilePhone   ] = Sql.ToString(row["PHONE_MOBILE"   ]);
						bChanged = true;
						sbChanges.AppendLine("PHONE_MOBILE"              + " changed.");
					}
				}
				if ( !contact.PhoneNumbers.Contains(PhoneNumberKey.OtherTelephone) || Sql.ToString(contact.PhoneNumbers[PhoneNumberKey.OtherTelephone]) != Sql.ToString(row["PHONE_OTHER"    ]) )
				{
					if ( !Sql.IsEmptyString(row["PHONE_OTHER"    ]) || contact.PhoneNumbers.Contains(PhoneNumberKey.OtherTelephone) )
					{
						contact.PhoneNumbers[PhoneNumberKey.OtherTelephone] = Sql.ToString(row["PHONE_OTHER"    ]);
						bChanged = true;
						sbChanges.AppendLine("PHONE_OTHER"               + " changed.");
					}
				}
				if ( !contact.PhoneNumbers.Contains(PhoneNumberKey.HomePhone     ) || Sql.ToString(contact.PhoneNumbers[PhoneNumberKey.HomePhone     ]) != Sql.ToString(row["PHONE_HOME"     ]) )
				{
					if ( !Sql.IsEmptyString(row["PHONE_HOME"     ]) && !contact.PhoneNumbers.Contains(PhoneNumberKey.HomePhone     ) )
					{
						contact.PhoneNumbers[PhoneNumberKey.HomePhone     ] = Sql.ToString(row["PHONE_HOME"     ]);
						bChanged = true;
						sbChanges.AppendLine("PHONE_HOME"                + " changed.");
					}
				}
				
				if ( !contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business) )
					contact.PhysicalAddresses[PhysicalAddressKey.Business] = new PhysicalAddressEntry();
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].Street         ) != Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Business  ].Street          = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_STREET"     + " changed."); }
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].City           ) != Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Business  ].City            = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_CITY"       + " changed."); }
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].State          ) != Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Business  ].State           = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_STATE"      + " changed."); }
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].PostalCode     ) != Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Business  ].PostalCode      = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_POSTALCODE" + " changed."); }
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].CountryOrRegion) != Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Business  ].CountryOrRegion = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_COUNTRY"    + " changed."); }
				
				if ( !contact.PhysicalAddresses.Contains(PhysicalAddressKey.Other) )
					contact.PhysicalAddresses[PhysicalAddressKey.Other] = new PhysicalAddressEntry();
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].Street         ) != Sql.ToString(row["ALT_ADDRESS_STREET"        ]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Other     ].Street          = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_STREET"         + " changed."); }
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].City           ) != Sql.ToString(row["ALT_ADDRESS_CITY"          ]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Other     ].City            = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_CITY"           + " changed."); }
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].State          ) != Sql.ToString(row["ALT_ADDRESS_STATE"         ]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Other     ].State           = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_STATE"          + " changed."); }
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].PostalCode     ) != Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Other     ].PostalCode      = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_POSTALCODE"     + " changed."); }
				if ( Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].CountryOrRegion) != Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]) ) { contact.PhysicalAddresses[PhysicalAddressKey.Other     ].CountryOrRegion = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_COUNTRY"        + " changed."); }
			}
			return bChanged;
		}

		public void SyncContacts(ExchangeSession Session, ExchangeService service, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + sEXCHANGE_ALIAS + " to " + gUSER_ID.ToString());
			
			string sCONFLICT_RESOLUTION = Sql.ToString(Application["CONFIG.Exchange.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
			//string sCRM_FOLDER_NAME     = Sql.ToString(Application["CONFIG.Exchange.CrmFolderName"     ]);
			//if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
			//	sCRM_FOLDER_NAME = "SplendidCRM";
			// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
			string sCONTACTS_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Contacts.Category"]);
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				
				try
				{
					string sSQL = String.Empty;
					// 04/05/2010 Paul.  When the Watermark is empty, no events will be created for existing items.  In that case, poll the folder 
					// 04/16/2018 Paul.  This condition makes no sense as it prevents normal processing of items unless SyncAll has been pressed on the admin page. 
					//if ( bSyncAll )
					{
						DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.MinValue;
						if ( !bSyncAll )
						{
							sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
							     + "  from vwCONTACTS_SYNC                               " + ControlChars.CrLf
							     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
							     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
								dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(cmd.ExecuteScalar());
							}
						}
						
						SearchFilter filter = null;
						List<SearchFilter> filters = new List<SearchFilter>();
						// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
						// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
						if ( !Sql.IsEmptyString(sCONTACTS_CATEGORY) )
						{
							// 06/23/2015 Paul.  Exchange 2010 does not allow the contains search, so use IsEqualTo instead. 
							filters.Add(new SearchFilter.IsEqualTo(ContactSchema.Categories, sCONTACTS_CATEGORY));
						}
						if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
						{
							// 03/28/2010 Paul.  The Greater Than filter does not appear to be working. 
							// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
							// 03/28/2010 Paul.  IsGreaterThan is being treated as IsGreaterThanOrEqualTo. 
							filters.Add(new SearchFilter.IsGreaterThan(ContactSchema.LastModifiedTime, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.AddSeconds(1)));
						}
						filter = new SearchFilter.SearchFilterCollection(LogicalOperator.And, filters.ToArray());
						
						int nPageOffset = 0;
						// 07/07/2015 Paul.  Allow the page size to be customized. 
						int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Contacts.PageSize"]);
						if ( nPageSize <= 0 )
							nPageSize = 100;
						FindItemsResults<Item> results = null;
						do
						{
							ItemView ivContacts = new ItemView(nPageSize, nPageOffset);
							// 03/26/2010 Paul.  Sort Ascending. 
							ivContacts.OrderBy.Add(ContactSchema.LastModifiedTime, SortDirection.Ascending);
							if ( filter != null )
								results = service.FindItems(WellKnownFolderName.Contacts, filter, ivContacts);
							else
								results = service.FindItems(WellKnownFolderName.Contacts, ivContacts);
							if ( results.Items.Count > 0 )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + results.Items.Count.ToString() + " contacts to retrieve from " + sEXCHANGE_ALIAS);
							foreach (Item itemContact in results.Items )
							{
								if ( itemContact is Contact )
								{
									Contact contact = itemContact as Contact;
									// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
									this.ImportContact(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, contact, sbErrors);
								}
							}
							nPageOffset += nPageSize;
						}
						while ( results.MoreAvailable );
					}
					
					// 03/26/2010 Paul.  Join to vwCONTACTS_USERS so that we only get contacts that are marked as Sync. 
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					// 09/18/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
					// 10/26/2015 Paul.  vwCONTACTS_USERS.SERVICE_NAME will be NULL when the user wants to Sync the contact record. 
					sSQL = "select vwCONTACTS.*                                                               " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_ID                                                    " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_REMOTE_KEY                                            " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                               " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                              " + ControlChars.CrLf
					     + "  from            vwCONTACTS                                                      " + ControlChars.CrLf
					     + "       inner join vwCONTACTS_USERS                                                " + ControlChars.CrLf
					     + "               on vwCONTACTS_USERS.CONTACT_ID           = vwCONTACTS.ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_USERS.USER_ID              = @SYNC_USER_ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_USERS.SERVICE_NAME is null                           " + ControlChars.CrLf
					     + "  left outer join vwCONTACTS_SYNC                                                 " + ControlChars.CrLf
					     + "               on vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'Exchange'             " + ControlChars.CrLf
					     + "              and vwCONTACTS_SYNC.SYNC_LOCAL_ID         = vwCONTACTS.ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_SYNC.SYNC_ASSIGNED_USER_ID = vwCONTACTS_USERS.USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SYNC_USER_ID", gUSER_ID);
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
						
						// 03/28/2010 Paul.  All that is important is that the current date is greater than the last sync date. 
						cmd.CommandText += "   and (vwCONTACTS_SYNC.ID is null or vwCONTACTS.DATE_MODIFIED_UTC > vwCONTACTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC)" + ControlChars.CrLf;
						cmd.CommandText += " order by vwCONTACTS.DATE_MODIFIED_UTC" + ControlChars.CrLf;
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + dt.Rows.Count.ToString() + " contacts to send to " + sEXCHANGE_ALIAS);
								foreach ( DataRow row in dt.Rows )
								{
									Guid     gID                             = Sql.ToGuid    (row["ID"                           ]);
									Guid     gASSIGNED_USER_ID               = Sql.ToGuid    (row["ASSIGNED_USER_ID"             ]);
									Guid     gSYNC_ID                        = Sql.ToGuid    (row["SYNC_ID"                      ]);
									string   sSYNC_REMOTE_KEY                = Sql.ToString  (row["SYNC_REMOTE_KEY"              ]);
									DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
									DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
									DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
									string   sSYNC_ACTION                    = Sql.IsEmptyGuid(gSYNC_ID) ? "local new" : "local changed";
									if ( SplendidInit.bEnableACLFieldSecurity )
									{
										bool bApplyACL = false;
										foreach ( DataColumn col in dt.Columns )
										{
											Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Contacts", col.ColumnName, gASSIGNED_USER_ID);
											if ( !acl.IsReadable() )
											{
												row[col.ColumnName] = DBNull.Value;
												bApplyACL = true;
											}
										}
										if ( bApplyACL )
											dt.AcceptChanges();
									}
									StringBuilder sbChanges = new StringBuilder();
									try
									{
										Contact contact = null;
										if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Sending new contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sEXCHANGE_ALIAS);
											contact = new Contact(service);
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
											// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
											this.SetExchangeContact(contact, row, sbChanges, sCONTACTS_CATEGORY);
											contact.Save();
											contact.Load();
											sSYNC_REMOTE_KEY = contact.Id.UniqueId;
										}
										else
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Binding contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sEXCHANGE_ALIAS);
											
											// 03/28/2010 Paul.  Instead of binding, use FindItems as the contact may have been deleted in Exchange. 
											// 03/28/2010 Paul.  FindItems is generating an exception: The specified value is invalid for property. 
											//ItemView ivContacts = new ItemView(1, 0);
											//filter = new SearchFilter.IsEqualTo(ContactSchema.Id, sSYNC_REMOTE_KEY);
											//results = service.FindItems(WellKnownFolderName.Contacts, filter, ivContacts);
											//if ( results.Items.Count > 0 )
											try
											{
												//contact = results.Items[0] as Contact;
												contact = Contact.Bind(service, sSYNC_REMOTE_KEY);
												// 03/28/2010 Paul.  We need to double-check for conflicts. 
												DateTime dtREMOTE_DATE_MODIFIED_UTC = contact.LastModifiedTime;
												if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
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
													else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "remote changed";
													}
													else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "local changed";
													}
													else
													{
														sSYNC_ACTION = "prompt change";
													}
												}
												// 03/29/2010 Paul.  If we find the contact, but the Categories no longer contains SplendidCRM, 
												// then the user must have stopped the syncing. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												if ( !Sql.IsEmptyString(sCONTACTS_CATEGORY) && !contact.Categories.Contains(sCONTACTS_CATEGORY) )
												{
													sSYNC_ACTION = "remote deleted";
												}
											}
											catch(Exception ex)
											{
												string sError = "Error retrieving Exchange contact " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + "." + ControlChars.CrLf;
												sError += Utils.ExpandException(ex) + ControlChars.CrLf;
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
												sbErrors.AppendLine(sError);
												sSYNC_ACTION = "remote deleted";
											}
											if ( sSYNC_ACTION == "local changed" )
											{
												// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
												// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												bool bChanged = this.SetExchangeContact(contact, row, sbChanges, sCONTACTS_CATEGORY);
												if ( bChanged )
												{
													if ( bVERBOSE_STATUS )
														SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Sending contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sEXCHANGE_ALIAS);
													contact.Update(ConflictResolutionMode.AlwaysOverwrite);
													contact.Load();
												}
											}
										}
										if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
										{
											if ( contact != null )
											{
												// 03/25/2010 Paul.  Update the modified date after the save. 
												// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
												DateTime dtREMOTE_DATE_MODIFIED_UTC = contact.LastModifiedTime;
												DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														// 03/26/2010 Paul.  Make sure to set the Sync flag. 
														// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
														// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
														SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sSYNC_REMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
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
										else if ( sSYNC_ACTION == "remote deleted" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Unsyncing contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " for " + sEXCHANGE_ALIAS);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gID, sSYNC_REMOTE_KEY, "Exchange", trn);
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
									catch(Exception ex)
									{
										// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
										string sError = "Error creating Exchange contact " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + " for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
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
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					sbErrors.AppendLine(Utils.ExpandException(ex));
				}
			}
		}

		// 12/12/2011 Paul.  Move population logic to a static method. 
		// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
		// 01/28/2012 Paul.  The transaction is necessary so that an account can be created. 
		public bool BuildCONTACTS_Update(ExchangeSession Session, IDbCommand spCONTACTS_Update, DataRow row, Contact contact, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID, bool bCreateAccount, IDbTransaction trn)
		{
			bool bChanged = false;
			// 03/25/2010 Paul.  We start with the existing record values so that we can apply ACL Field Security rules. 
			if ( row != null && row.Table != null )
			{
				foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					// 03/28/2010 Paul.  We must assign a value to all parameters. 
					string sParameterName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
					if ( row.Table.Columns.Contains(sParameterName) )
						par.Value = row[sParameterName];
					else
						par.Value = DBNull.Value;
				}
			}
			else
			{
				bChanged = true;
				foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					string sParameterName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
					if ( sParameterName == "TEAM_ID" )
						par.Value = gTEAM_ID;
					else if ( sParameterName == "ASSIGNED_USER_ID" )
						par.Value = gUSER_ID;
					// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
					else if ( sParameterName == "MODIFIED_USER_ID" )
						par.Value = gUSER_ID;
					else
						par.Value = DBNull.Value;
				}
			}
			foreach(IDbDataParameter par in spCONTACTS_Update.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spCONTACTS_Update, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Contacts", sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "DESCRIPTION"               :  oValue = Sql.ToDBString  (contact.Body.Text     );  break;
							case "ASSISTANT"                 :  oValue = Sql.ToDBString  (contact.AssistantName );  break;
							case "BIRTHDATE"                 :  oValue = Sql.ToDBDateTime(contact.Birthday.Value);  break;
							case "ACCOUNT_NAME"              :  oValue = Sql.ToDBString  (contact.CompanyName   );  break;
							case "DEPARTMENT"                :  oValue = Sql.ToDBString  (contact.Department    );  break;
							case "FIRST_NAME"                :  oValue = Sql.ToDBString  (contact.GivenName     );  break;
							case "TITLE"                     :  oValue = Sql.ToDBString  (contact.JobTitle      );  break;
							case "LAST_NAME"                 :  oValue = Sql.ToDBString  (contact.Surname       );  break;
							case "EMAIL1"                    :  if ( contact.EmailAddresses   .Contains(EmailAddressKey.EmailAddress1) ) oValue = Sql.ToDBString(contact.EmailAddresses   [EmailAddressKey.EmailAddress1].Address        );  break;
							case "EMAIL2"                    :  if ( contact.EmailAddresses   .Contains(EmailAddressKey.EmailAddress2) ) oValue = Sql.ToDBString(contact.EmailAddresses   [EmailAddressKey.EmailAddress2].Address        );  break;
							case "ASSISTANT_PHONE"           :  if ( contact.PhoneNumbers     .Contains(PhoneNumberKey.AssistantPhone) ) oValue = Sql.ToDBString(contact.PhoneNumbers     [PhoneNumberKey.AssistantPhone]                );  break;
							case "PHONE_FAX"                 :  if ( contact.PhoneNumbers     .Contains(PhoneNumberKey.BusinessFax   ) ) oValue = Sql.ToDBString(contact.PhoneNumbers     [PhoneNumberKey.BusinessFax   ]                );  break;
							case "PHONE_WORK"                :  if ( contact.PhoneNumbers     .Contains(PhoneNumberKey.BusinessPhone ) ) oValue = Sql.ToDBString(contact.PhoneNumbers     [PhoneNumberKey.BusinessPhone ]                );  break;
							case "PHONE_MOBILE"              :  if ( contact.PhoneNumbers     .Contains(PhoneNumberKey.MobilePhone   ) ) oValue = Sql.ToDBString(contact.PhoneNumbers     [PhoneNumberKey.MobilePhone   ]                );  break;
							case "PHONE_OTHER"               :  if ( contact.PhoneNumbers     .Contains(PhoneNumberKey.OtherTelephone) ) oValue = Sql.ToDBString(contact.PhoneNumbers     [PhoneNumberKey.OtherTelephone]                );  break;
							case "PHONE_HOME"                :  if ( contact.PhoneNumbers     .Contains(PhoneNumberKey.HomePhone     ) ) oValue = Sql.ToDBString(contact.PhoneNumbers     [PhoneNumberKey.HomePhone     ]                );  break;
							case "PRIMARY_ADDRESS_STREET"    :  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].Street         );  break;
							case "PRIMARY_ADDRESS_CITY"      :  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].City           );  break;
							case "PRIMARY_ADDRESS_STATE"     :  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].State          );  break;
							case "PRIMARY_ADDRESS_POSTALCODE":  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].PostalCode     );  break;
							case "PRIMARY_ADDRESS_COUNTRY"   :  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].CountryOrRegion);  break;
							case "ALT_ADDRESS_STREET"        :  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Other     ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].Street         );  break;
							case "ALT_ADDRESS_CITY"          :  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Other     ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].City           );  break;
							case "ALT_ADDRESS_STATE"         :  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Other     ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].State          );  break;
							case "ALT_ADDRESS_POSTALCODE"    :  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Other     ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].PostalCode     );  break;
							case "ALT_ADDRESS_COUNTRY"       :  if ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Other     ) ) oValue = Sql.ToDBString(contact.PhysicalAddresses[PhysicalAddressKey.Other     ].CountryOrRegion);  break;
							// 03/26/2010 Paul.  We need to make sure to set the Sync flag. 
							case "SYNC_CONTACT"              :  oValue = true;  break;
							// 03/27/2010 Paul.  We need to set the Modified User ID in order to set the SYNC_CONTACT flag. 
							case "MODIFIED_USER_ID"          :  oValue = gUSER_ID;  break;
						}
						// 01/28/2012 Paul.  ACCOUNT_NAME does not exist in the spCONTACTS_Update stored procedure.  It is a special case that requires a lookup. 
						if ( sColumnName == "ACCOUNT_ID" )
						{
							string sACCOUNT_NAME = String.Empty;
							Guid   gACCOUNT_ID   = Sql.ToGuid(par.Value);
							if ( !Sql.IsEmptyGuid(gACCOUNT_ID) )
								sACCOUNT_NAME = Modules.ItemName("Accounts", gACCOUNT_ID);
							if ( String.Compare(sACCOUNT_NAME, Sql.ToString(contact.CompanyName), true) != 0 )
							{
								gACCOUNT_ID   = Guid.Empty;
								sACCOUNT_NAME = Sql.ToString(contact.CompanyName);
								if ( !Sql.IsEmptyString(sACCOUNT_NAME) )
								{
									IDbConnection con = spCONTACTS_Update.Connection;
									string sSQL ;
									sSQL = "select ID                   " + ControlChars.CrLf
									     + "  from vwACCOUNTS           " + ControlChars.CrLf
									     + " where NAME = @NAME         " + ControlChars.CrLf
									     + " order by DATE_MODIFIED desc" + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										if ( trn != null )
											cmd.Transaction = trn;
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@NAME", sACCOUNT_NAME);
										gACCOUNT_ID = Sql.ToGuid(cmd.ExecuteScalar());
										if ( Sql.IsEmptyGuid(gACCOUNT_ID) && bCreateAccount )
										{
											// 01/28/2012 Paul.  If the account does not exist, then create it. 
											SqlProcs.spACCOUNTS_Update
												( ref gACCOUNT_ID
												, gUSER_ID      // ASSIGNED_USER_ID
												, sACCOUNT_NAME
												, String.Empty  // ACCOUNT_TYPE
												, Guid.Empty    // PARENT_ID
												, String.Empty  // INDUSTRY
												, String.Empty  // ANNUAL_REVENUE
												, ( contact.PhoneNumbers     .Contains(PhoneNumberKey.BusinessFax   ) ) ? Sql.ToString(contact.PhoneNumbers     [PhoneNumberKey.BusinessFax   ]                ) : String.Empty
												, ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) ? Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].Street         ) : String.Empty
												, ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) ? Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].City           ) : String.Empty
												, ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) ? Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].State          ) : String.Empty
												, ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) ? Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].PostalCode     ) : String.Empty
												, ( contact.PhysicalAddresses.Contains(PhysicalAddressKey.Business  ) ) ? Sql.ToString(contact.PhysicalAddresses[PhysicalAddressKey.Business  ].CountryOrRegion) : String.Empty
												, "Account created from Exchange contact " + (contact.FileAs != null ? Sql.ToString(contact.FileAs) : String.Empty)
												, String.Empty  // RATING
												, ( contact.PhoneNumbers     .Contains(PhoneNumberKey.BusinessPhone ) ) ? Sql.ToString(contact.PhoneNumbers     [PhoneNumberKey.BusinessPhone ]                ) : String.Empty  // PHONE_OFFICE
												, String.Empty  // PHONE_ALTERNATE
												, ( contact.EmailAddresses   .Contains(EmailAddressKey.EmailAddress1) ) ? Sql.ToString(contact.EmailAddresses   [EmailAddressKey.EmailAddress1].Address        ) : String.Empty
												, String.Empty  // EMAIL2
												, String.Empty  // WEBSITE
												, String.Empty  // OWNERSHIP
												, String.Empty  // EMPLOYEES
												, String.Empty  // SIC_CODE
												, String.Empty  // TICKER_SYMBOL
												, String.Empty  // SHIPPING_ADDRESS_STREET
												, String.Empty  // SHIPPING_ADDRESS_CITY
												, String.Empty  // SHIPPING_ADDRESS_STATE
												, String.Empty  // SHIPPING_ADDRESS_POSTALCODE
												, String.Empty  // SHIPPING_ADDRESS_COUNTRY
												, String.Empty  // ACCOUNT_NUMBER
												, gTEAM_ID      // TEAM_ID
												, String.Empty  // TEAM_SET_LIST
												, false         // EXCHANGE_FOLDER
												// 08/07/2015 Paul.  Add picture. 
												, String.Empty  // PICTURE
												// 05/12/2016 Paul.  Add Tags module. 
												, String.Empty  // TAG_SET_NAME
												// 06/07/2017 Paul.  Add NAICSCodes module. 
												, String.Empty  // NAICS_SET_NAME
												// 10/27/2017 Paul.  Add Accounts as email source. 
												, false         // DO_NOT_CALL
												, false         // EMAIL_OPT_OUT
												, false         // INVALID_EMAIL
												// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
												, String.Empty  // ASSIGNED_SET_LIST
												, trn
												);
										}
									}
								}
								par.Value = gACCOUNT_ID;
								bChanged = true;
							}
						}
						// 01/24/2012 Paul.  Only set the parameter value if the value is being set. 
						else if ( oValue != null )
						{
							if ( !bChanged )
							{
								switch ( par.DbType )
								{
									case DbType.Guid    :  if ( Sql.ToGuid    (par.Value) != Sql.ToGuid    (oValue) ) bChanged = true;  break;
									case DbType.Int16   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int32   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int64   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Double  :  if ( Sql.ToDouble  (par.Value) != Sql.ToDouble  (oValue) ) bChanged = true;  break;
									case DbType.Decimal :  if ( Sql.ToDecimal (par.Value) != Sql.ToDecimal (oValue) ) bChanged = true;  break;
									case DbType.Boolean :  if ( Sql.ToBoolean (par.Value) != Sql.ToBoolean (oValue) ) bChanged = true;  break;
									case DbType.DateTime:  if ( Sql.ToDateTime(par.Value) != Sql.ToDateTime(oValue) ) bChanged = true;  break;
									default             :  if ( Sql.ToString  (par.Value) != Sql.ToString  (oValue) ) bChanged = true;  break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
						// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}

		public void ImportContact(ExchangeSession Session, ExchangeService service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, Contact contact, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.Exchange.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid   (Session["TEAM_ID"]);
			// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
			//string sCRM_FOLDER_NAME     = Sql.ToString (Application["CONFIG.Exchange.CrmFolderName"     ]);
			//if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
			//	sCRM_FOLDER_NAME = "SplendidCRM";
			// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
			string sCONTACTS_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Contacts.Category"]);
			
			IDbCommand spCONTACTS_Update = SqlProcs.Factory(con, "spCONTACTS_Update");

			string   sREMOTE_KEY                = contact.Id.UniqueId;
			// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
			DateTime dtREMOTE_DATE_MODIFIED_UTC = contact.LastModifiedTime;
			DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);

			String sSQL = String.Empty;
			sSQL = "select SYNC_ID                                       " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_DATE_MODIFIED_UTC                  " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_DATE_MODIFIED_UTC                 " + ControlChars.CrLf
			     + "     , SYNC_CONTACT                                  " + ControlChars.CrLf
			     + "     , ID                                            " + ControlChars.CrLf
			     + "     , DATE_MODIFIED_UTC                             " + ControlChars.CrLf
			     + "  from vwCONTACTS_SYNC                               " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
			     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
			     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
				Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					string sSYNC_ACTION   = String.Empty;
					Guid   gID            = Guid.Empty;
					Guid   gSYNC_LOCAL_ID = Guid.Empty;
					using ( DataTable dt = new DataTable() )
					{
						da.Fill(dt);
						if ( dt.Rows.Count > 0 )
						{
							DataRow row = dt.Rows[0];
							gID                                      = Sql.ToGuid    (row["ID"                           ]);
							gSYNC_LOCAL_ID                           = Sql.ToGuid    (row["SYNC_LOCAL_ID"                ]);
							DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
							DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
							DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
							bool     bSYNC_CONTACT                   = Sql.ToBoolean (row["SYNC_CONTACT"                 ]);
							// 03/24/2010 Paul.  Exchange Record has already been mapped for this user. 
							// 03/28/2010 Paul.  If the ID is NULL and the LOCAL_ID is NOT NULL, then the local item must have been deleted. 
							// 03/29/2010 Paul.  If ID and LOCAL_ID are valid, but SYNC_CONTACT is not, then the user has stopped syncing the contact. 
							if ( (Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID)) || (!Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID) && !bSYNC_CONTACT) )
							{
								sSYNC_ACTION = "local deleted";
							}
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
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
								else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "remote changed";
								}
								else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "local changed";
								}
								else
								{
									sSYNC_ACTION = "prompt change";
								}
								
							}
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Remote Record has changed, but Local has not. 
								sSYNC_ACTION = "remote changed";
							}
							else if ( dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Local Record has changed, but Remote has not. 
								sSYNC_ACTION = "local changed";
							}
						}
						else
						{
							sSYNC_ACTION = "remote new";
							
							// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to Exchange. 
							// 03/28/2010 Paul.  We need to prevent duplicate Exchange entries from attaching to an existing mapped Contact ID. 
							cmd.Parameters.Clear();
							sSQL = "select vwCONTACTS.ID             " + ControlChars.CrLf
							     + "  from            vwCONTACTS     " + ControlChars.CrLf
							     + "  left outer join vwCONTACTS_SYNC" + ControlChars.CrLf
							     + "               on vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_LOCAL_ID         = vwCONTACTS.ID         " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
							if ( contact.EmailAddresses.Contains(EmailAddressKey.EmailAddress1) && !Sql.IsEmptyString(contact.EmailAddresses[EmailAddressKey.EmailAddress1].Address) )
							{
								Sql.AppendParameter(cmd, Sql.ToString(contact.EmailAddresses[EmailAddressKey.EmailAddress1].Address), "EMAIL1");
							}
							else
							{
								if ( Sql.IsEmptyString(contact.GivenName) && Sql.IsEmptyString(contact.Surname) )
								{
									Sql.AppendParameter(cmd, Sql.ToString(contact.DisplayName), "NAME");
								}
								else
								{
									Sql.AppendParameter(cmd, Sql.ToString(contact.GivenName), "FIRST_NAME");
									Sql.AppendParameter(cmd, Sql.ToString(contact.Surname  ), "LAST_NAME" );
								}
							}
							cmd.CommandText += "   and vwCONTACTS_SYNC.ID is null" + ControlChars.CrLf;
							gID = Sql.ToGuid(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyGuid(gID) )
							{
								// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to Exchange. 
								sSYNC_ACTION = "local new";
							}
						}
					}
					using ( DataTable dt = new DataTable() )
					{
						DataRow row = null;
						Guid gASSIGNED_USER_ID = Guid.Empty;
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" || sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new" )
						{
							if ( !Sql.IsEmptyGuid(gID) )
							{
								cmd.Parameters.Clear();
								sSQL = "select *         " + ControlChars.CrLf
								     + "  from vwCONTACTS" + ControlChars.CrLf
								     + " where ID = @ID  " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
								{
									row = dt.Rows[0];
									gASSIGNED_USER_ID = Sql.ToGuid(row["ASSIGNED_USER_ID"]);
								}
							}
						}
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" )
						{
							try
							{
								// 03/28/2010 Paul.  Reload the full contact so that it will include the Body. 
								// 03/28/2010 Paul.  The binding can fail if the contact does not define the FileAs field. 
								contact = Contact.Bind(service, sREMOTE_KEY);
							}
							catch(Exception ex)
							{
								string sError = "Error retrieving " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Retrieving contact " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " from " + sEXCHANGE_ALIAS);
									
									spCONTACTS_Update.Transaction = trn;
									// 12/12/2011 Paul.  Move population logic to a static method. 
									// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
									// 01/28/2012 Paul.  The transaction is necessary so that an account can be created. 
									bool bChanged = BuildCONTACTS_Update(Session, spCONTACTS_Update, row, contact, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID, true, trn);
									if ( bChanged )
									{
										Sql.Trace(spCONTACTS_Update);
										spCONTACTS_Update.ExecuteNonQuery();
										IDbDataParameter parID = Sql.FindParameter(spCONTACTS_Update, "@ID");
										gID = Sql.ToGuid(parID.Value);
									}
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									// 02/20/2013 Paul.  Log inner error. 
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
									throw;
								}
							}
						}
						else if ( (sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new") && !Sql.IsEmptyGuid(gID) )
						{
							// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to Exchange. 
							if ( dt.Rows.Count > 0 )
							{
								row = dt.Rows[0];
								if ( SplendidInit.bEnableACLFieldSecurity )
								{
									bool bApplyACL = false;
									foreach ( DataColumn col in dt.Columns )
									{
										Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Contacts", col.ColumnName, gASSIGNED_USER_ID);
										if ( !acl.IsReadable() )
										{
											row[col.ColumnName] = DBNull.Value;
											bApplyACL = true;
										}
									}
									if ( bApplyACL )
										dt.AcceptChanges();
								}
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Syncing contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + sEXCHANGE_ALIAS);
									// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
									// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
									// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
									// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
									bool bChanged = this.SetExchangeContact(contact, row, sbChanges, sCONTACTS_CATEGORY);
									if ( bChanged )
									{
										contact.Update(ConflictResolutionMode.AlwaysOverwrite);
										contact.Load();
										// 12/05/2020 Paul.  If local new, then we don't have a remote key. 
										if ( Sql.IsEmptyString(sREMOTE_KEY) )
											sREMOTE_KEY = contact.Id.UniqueId;
									}
									// 03/25/2010 Paul.  Update the modified date after the save. 
									// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
									dtREMOTE_DATE_MODIFIED_UTC = contact.LastModifiedTime;
									dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 03/26/2010 Paul.  Make sure to set the Sync flag. 
											// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
											// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
											SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								catch(Exception ex)
								{
									// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
									string sError = "Error saving " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + " to " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
									sError += sbChanges.ToString();
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
						else if ( sSYNC_ACTION == "local deleted" )
						{
							try
							{
								// 03/28/2010 Paul.  Load the full contact so that we can modify just the one field. 
								contact.Load();
								// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
								// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
								// 09/02/2018 Paul.  Provide an option to delete the created record. 
								if ( !Sql.IsEmptyString(sCONTACTS_CATEGORY) && !Sql.ToBoolean(Application["CONFIG.Exchange.Contacts.Delete"]) )
								{
									contact.Categories.Remove(sCONTACTS_CATEGORY);
									contact.Update(ConflictResolutionMode.AlwaysOverwrite);
								}
								else
								{
									// 09/02/2013 Paul.  If the category is empty, then delete the contact. 
									contact.Delete(DeleteMode.SoftDelete);
								}
							}
							catch(Exception ex)
							{
								string sError = "Error clearing Exchange categories for " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " from " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							try
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Deleting " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " from " + sEXCHANGE_ALIAS);
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
										SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sREMOTE_KEY, "Exchange", trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										throw;
									}
								}
							}
							catch(Exception ex)
							{
								string sError = "Error deleting " + Sql.ToString(contact.GivenName) + " " + Sql.ToString(contact.Surname) + " from " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
						}
					}
				}
			}
		}

		// 11/22/2023 Paul.  When unsyncing, we need to immediately clear the remote flag. 
		public void UnsyncContact(Guid gUSER_ID, Guid gCONTACT_ID)
		{
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			string sSERVER_URL          = Sql.ToString (Application["CONFIG.Exchange.ServerURL"    ]);
			string sUSER_NAME           = Sql.ToString (Application["CONFIG.Exchange.UserName"     ]);
			string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"     ]);
			string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret" ]);
			if ( !Sql.IsEmptyString(sSERVER_URL) && (!Sql.IsEmptyString(sUSER_NAME) || !Sql.IsEmptyString(sOAUTH_CLIENT_ID) && !Sql.IsEmptyString(sOAUTH_CLIENT_SECRET)))
			{
				string sEXCHANGE_ALIAS = String.Empty;
				try
				{
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						String sSQL = String.Empty;
						sSQL = "select EXCHANGE_ALIAS              " + ControlChars.CrLf
						     + "  from vwEXCHANGE_USERS            " + ControlChars.CrLf
						     + " where ASSIGNED_USER_ID  = @USER_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
							sEXCHANGE_ALIAS = Sql.ToString(cmd.ExecuteScalar());
						}
						
						sSQL = "select ID                                            " + ControlChars.CrLf
						     + "     , SYNC_REMOTE_KEY                               " + ControlChars.CrLf
						     + "  from vwCONTACTS_SYNC                               " + ControlChars.CrLf
						     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
						     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
						     + "   and SYNC_LOCAL_ID         = @SYNC_LOCAL_ID        " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@SYNC_LOCAL_ID"        , gCONTACT_ID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dt = new DataTable() )
								{
									da.Fill(dt);
									// 11/23/2023 Paul.  Noticed multiple sync records, so delete them all. 
									foreach ( DataRow row in dt.Rows )
									{
										Guid   gID         = Sql.ToGuid  (row["ID"             ]);
										string sREMOTE_KEY = Sql.ToString(row["SYNC_REMOTE_KEY"]);
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ExchangeSync.UnsyncContact: Unsyncing contact for " + sEXCHANGE_ALIAS + " to " + gCONTACT_ID.ToString());
										
										if ( !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sOAUTH_CLIENT_ID) && !Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) )
										{
											Office365Sync.UnsyncContact(gUSER_ID, sEXCHANGE_ALIAS, gCONTACT_ID, sREMOTE_KEY);
										}
										else if ( !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sUSER_NAME) )
										{
											UnsyncContact(gUSER_ID, sEXCHANGE_ALIAS, gCONTACT_ID, sREMOTE_KEY);
										}
									}
								}
							}
						}
					}
				}
				catch(Exception ex)
				{
					string sError = "ExchangeSync.UnsyncContact: for " + sEXCHANGE_ALIAS + " to " + gCONTACT_ID.ToString() + "." + ControlChars.CrLf;
					sError += Utils.ExpandException(ex) + ControlChars.CrLf;
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				}
			}
		}

		// 11/22/2023 Paul.  When unsyncing, we need to immediately clear the remote flag. 
		public void UnsyncContact(Guid gUSER_ID, string sEXCHANGE_ALIAS, Guid gCONTACT_ID, string sREMOTE_KEY)
		{
			try
			{
				ExchangeSync.UserSync User = ExchangeSync.UserSync.Create(Session, Security, Sql, SqlProcs, SplendidError, XmlUtil, SyncError, ExchangeSecurity, ExchangeUtils, this, gUSER_ID, false);
				if ( User != null )
				{
					string sCONTACTS_CATEGORY     = Sql.ToString(Application["CONFIG.Exchange.Contacts.Category"]);
					ExchangeSession       Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
					ExchangeService       service = ExchangeUtils.CreateExchangeService(User);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
						if ( bVERBOSE_STATUS )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ExchangeSync.UnsyncContact: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + ".");
					
						Contact contact = null;
						try
						{
							contact = Contact.Bind(service, sREMOTE_KEY);
						}
						catch
						{
						}
						if ( contact != null && contact.Categories.Contains(sCONTACTS_CATEGORY) )
						{
							if ( contact.Categories.Contains(sCONTACTS_CATEGORY) )
							{
								contact.Categories.Remove(sCONTACTS_CATEGORY);
							}
							contact.Update(ConflictResolutionMode.AlwaysOverwrite);
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gCONTACT_ID, sREMOTE_KEY, "Exchange", trn);
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
			}
			catch(Exception ex)
			{
				string sError = "ExchangeSync.UnsyncContact: for " + sEXCHANGE_ALIAS + " to " + sREMOTE_KEY + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
			}
		}
		#endregion

		#region Sync Appointments
		// 01/15/2012 Paul.  We need to check for added or removed participants. 
		private DataTable AppointmentEmails(IDbConnection con, Guid gID)
		{
			DataTable dtAppointmentEmails = new DataTable();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					string sSQL;
					// 01/15/2012 Paul.  An Exchange contact can be created without an email. 
					// 03/11/2012 Paul.  ExchangeSync needs the name in its check for added or removed attendees. 
					// 03/11/2012 Paul.  Exchange requires a valid Email address. 
					sSQL = "select EMAIL1               " + ControlChars.CrLf
					     + "     , NAME                 " + ControlChars.CrLf
					     + "     , REQUIRED             " + ControlChars.CrLf
					     + "     , ACCEPT_STATUS        " + ControlChars.CrLf
					     + "     , ASSIGNED_USER_ID     " + ControlChars.CrLf
					     + "  from vwAPPOINTMENTS_EMAIL1" + ControlChars.CrLf
					     + " where APPOINTMENT_ID = @ID " + ControlChars.CrLf
					     + "   and EMAIL1 is not null   " + ControlChars.CrLf;
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gID);
					
					((IDbDataAdapter)da).SelectCommand = cmd;
					da.Fill(dtAppointmentEmails);
				}
			}
			return dtAppointmentEmails;
		}

		// 01/15/2012 Paul.  We need to check for added or removed participants. 
		// 07/26/2012 James.  Add the ability to disable participants. 
		// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
		private bool SetExchangeAppointment(Appointment appointment, DataRow row, DataTable dtAppointmentEmails, StringBuilder sbChanges, bool bDISABLE_PARTICIPANTS, string sCALENDAR_CATEGORY)
		{
			bool bChanged = false;
			if ( appointment.IsNew )
			{
				// 03/28/2010 Paul.  You must load or assign this property before you can read its value. 
				// So set all the fields to empty values. 
				// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
				// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
				if ( !Sql.IsEmptyString(sCALENDAR_CATEGORY) )
					appointment.Categories.Add(sCALENDAR_CATEGORY);
				appointment.Subject                    = Sql.ToString  (row["NAME"         ]);
				appointment.Location                   = Sql.ToString  (row["LOCATION"     ]);
				// 07/26/2012 Paul.  We need to set the body type. 
				string   sDESCRIPTION = Sql.ToString  (row["DESCRIPTION"]);
				// 06/22/2018 Paul.  Might include namespaces. 
				BodyType btDESCRIPTION = sDESCRIPTION.StartsWith("<html") ? BodyType.HTML : BodyType.Text;
				appointment.Body                       = new MessageBody(btDESCRIPTION, sDESCRIPTION);
				// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  Exchange stores the reminder in minutes. 
				// 02/20/2013 Paul.  Don't set the reminder for old appointments, but include appointments for today. 
				// 03/19/2013 Paul.  Make sure to use the IsReminderSet flag to prevent reminder when not set in CRM. 
				// http://msdn.microsoft.com/en-us/library/ms528181(v=exchg.10).aspx
				if ( Sql.ToDateTime(row["DATE_START"]) >= DateTime.Now && (Sql.ToInteger(row["REMINDER_TIME"]) > 0) )
				{
					// 03/19/2013 Paul.  IsReminderSet is set to true by default. 
					appointment.ReminderMinutesBeforeStart = Sql.ToInteger(row["REMINDER_TIME"]) / 60;
				}
				else
				{
					appointment.IsReminderSet = false;
				}
				// 03/30/2010 Paul.  We still get TimeZone is Invalid if we specify a TimeZoneInfo.Utc. 
				// 03/30/2010 Paul.  We need to set the TimeZone to Local, otherwise we will get an exception "TimeZone is invalid". 
				appointment.StartTimeZone              = TimeZoneInfo.Local;
				// 08/31/2017 Paul.  We need to also set the EndTimeZone, otherwise we get "EndDate is earlier than StartDate" on some systems. 
				// 02/12/2018 Paul.  The property EndTimeZone is valid only for Exchange 2010 or later versions. 
				if ( appointment.Service.RequestedServerVersion != ExchangeVersion.Exchange2007_SP1 )
					appointment.EndTimeZone                = TimeZoneInfo.Local;
				appointment.Start                      = Sql.ToDateTime(row["DATE_START"   ]);
				appointment.End                        = Sql.ToDateTime(row["DATE_END"     ]);
				// 03/10/2013 Paul.  Add ALL_DAY_EVENT. 
				appointment.IsAllDayEvent              = Sql.ToBoolean (row["ALL_DAY_EVENT"]);
				appointment.Sensitivity                = Sensitivity.Normal;
				// 03/23/2013 Paul.  Add recurrence data. 
				string sREPEAT_TYPE = Sql.ToString(row["REPEAT_TYPE"]);
				if ( !Sql.IsEmptyString(sREPEAT_TYPE) )
				{
					int      nREPEAT_COUNT    = Sql.ToInteger (row["REPEAT_COUNT"   ]);
					int      nREPEAT_INTERVAL = Sql.ToInteger (row["REPEAT_INTERVAL"]);
					DateTime dtREPEAT_UNTIL   = Sql.ToDateTime(row["REPEAT_UNTIL"   ]);
					// http://msdn.microsoft.com/en-us/library/exchange/dd633694(v=exchg.80).aspx
					switch ( sREPEAT_TYPE )
					{
						case "Daily":
							appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern(appointment.Start, nREPEAT_INTERVAL);
							if ( dtREPEAT_UNTIL != DateTime.MinValue )
								appointment.Recurrence.EndDate = dtREPEAT_UNTIL;
							else
								appointment.Recurrence.EndDate = null;
							if ( nREPEAT_COUNT > 0 )
								appointment.Recurrence.NumberOfOccurrences = nREPEAT_COUNT;
							else
								appointment.Recurrence.NumberOfOccurrences = null;
							break;
						case "Weekly":
							string sREPEAT_DOW = Sql.ToString(row["REPEAT_DOW"]);
							if ( !Sql.IsEmptyString(sREPEAT_DOW) )
							{
								Microsoft.Exchange.WebServices.Data.DayOfTheWeek[] days = new Microsoft.Exchange.WebServices.Data.DayOfTheWeek[sREPEAT_DOW.Length];
								for ( int n = 0; n < sREPEAT_DOW.Length; n++ )
								{
									days[n] = (DayOfTheWeek) Sql.ToInteger(sREPEAT_DOW.Substring(n, 1));
								}
								appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern(appointment.Start, nREPEAT_INTERVAL, days);
								if ( dtREPEAT_UNTIL != DateTime.MinValue )
									appointment.Recurrence.EndDate = dtREPEAT_UNTIL;
								else
									appointment.Recurrence.EndDate = null;
								if ( nREPEAT_COUNT > 0 )
									appointment.Recurrence.NumberOfOccurrences = nREPEAT_COUNT;
								else
									appointment.Recurrence.NumberOfOccurrences = null;
							}
							break;
						case "Monthly":
							appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern(appointment.Start, nREPEAT_INTERVAL, appointment.Start.Day);
							if ( dtREPEAT_UNTIL != DateTime.MinValue )
								appointment.Recurrence.EndDate = dtREPEAT_UNTIL;
							else
								appointment.Recurrence.EndDate = null;
							if ( nREPEAT_COUNT > 0 )
								appointment.Recurrence.NumberOfOccurrences = nREPEAT_COUNT;
							else
								appointment.Recurrence.NumberOfOccurrences = null;
							break;
						case "Yearly":
							appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.YearlyPattern(appointment.Start, (Microsoft.Exchange.WebServices.Data.Month) appointment.Start.Month, appointment.Start.Day);
							// 03/27/2013 Paul.  Set EndDate first as it will reset NumberOfOccurrences. 
							// http://msdn.microsoft.com/en-us/library/exchange/dd633684(v=exchg.80).aspx
							if ( dtREPEAT_UNTIL != DateTime.MinValue )
								appointment.Recurrence.EndDate = dtREPEAT_UNTIL;
							else
								appointment.Recurrence.EndDate = null;
							if ( nREPEAT_COUNT > 0 )
								appointment.Recurrence.NumberOfOccurrences = nREPEAT_COUNT;
							else
								appointment.Recurrence.NumberOfOccurrences = null;
							break;
					}
				}
				
				// 01/15/2012 Paul.  We need to check for added or removed participants. 
				// 07/26/2012 James.  Add the ability to disable participants. 
				if ( !bDISABLE_PARTICIPANTS )
				{
					if ( dtAppointmentEmails.Rows.Count > 0 )
					{
						foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
						{
							string sNAME     = Sql.ToString (rowEmail["NAME"    ]);
							string sEMAIL1   = Sql.ToString (rowEmail["EMAIL1"  ]);
							bool   bREQUIRED = Sql.ToBoolean(rowEmail["REQUIRED"]);
							Attendee guest = new Attendee(sNAME, sEMAIL1);
							if ( bREQUIRED )
								appointment.RequiredAttendees.Add(guest);
							else
								appointment.OptionalAttendees.Add(guest);
						}
					}
				}
				bChanged = true;
			}
			else
			{
				// 03/29/2010 Paul.  Lets not always add the SplendidCRM category, but only do it during creation. 
				// This should not be an issue as we currently do not lookup the Exchange user when creating a appointment that originated from the CRM. 
				// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
				//if ( !appointment.Categories.Contains(sCRM_FOLDER_NAME) )
				//{
				//	appointment.Categories.Add(sCRM_FOLDER_NAME);
				//	bChanged = true;
				//}
				string sBody   = String.Empty;
				try
				{
					// 07/26/2012 Paul.  Get the body from the text property. 
					sBody = Sql.ToString(appointment.Body.Text);
				}
				catch
				{
				}

				// 03/28/2010 Paul.  When updating the description, we need to maintain the HTML flag. 
				string   sDESCRIPTION = Sql.ToString  (row["DESCRIPTION"]);
				// 03/29/2010 Paul.  Exchange will use UTC. 
				// 05/09/2018 Paul.  We still return dates as UTC, so still compare that way, but set using local time. 
				DateTime dtDATE_START = Sql.ToDateTime(row["DATE_START" ]).ToUniversalTime();
				DateTime dtDATE_END   = Sql.ToDateTime(row["DATE_END"   ]).ToUniversalTime();
				// 06/22/2018 Paul.  Might include namespaces. 
				BodyType btDESCRIPTION = sDESCRIPTION.StartsWith("<html") ? BodyType.HTML : BodyType.Text;
				// 03/28/2010 Paul.  An empty Email Address will cause an exception when calling Appointment.Bind(); 
				if ( sBody                                  != sDESCRIPTION                        ) { appointment.Body                       = new MessageBody(btDESCRIPTION, sDESCRIPTION);  bChanged = true; sbChanges.AppendLine("DESCRIPTION"   + " changed."); }
				if ( Sql.ToString  (appointment.Subject )   != Sql.ToString  (row["NAME"      ])   ) { appointment.Subject                    = Sql.ToString(row["NAME"    ])               ;  bChanged = true; sbChanges.AppendLine("NAME"          + " changed."); }
				if ( Sql.ToString  (appointment.Location)   != Sql.ToString  (row["LOCATION"  ])   ) { appointment.Location                   = Sql.ToString(row["LOCATION"])               ;  bChanged = true; sbChanges.AppendLine("LOCATION"      + " changed."); }
				if ( Sql.ToDateTime(appointment.Start   )   != dtDATE_START )
				{
					// 07/14/2014 Paul.  StartTimeZone required when setting the Start, End, IsAllDayEvent, or Recurrence properties. You must load or assign this property before attempting to update the appointment.
					// 05/09/2018 Paul.  We still return dates as UTC, so still compare that way, but set using local time. 
					appointment.StartTimeZone = TimeZoneInfo.Local;
					dtDATE_START = Sql.ToDateTime(row["DATE_START" ]);
					appointment.Start = dtDATE_START;
					bChanged = true;
					sbChanges.AppendLine("DATE_START"    + " changed. " + dtDATE_START.ToString());
				}
				if ( Sql.ToDateTime(appointment.End     )   != dtDATE_END )
				{
					// 08/31/2017 Paul.  We need to also set the EndTimeZone, otherwise we get "EndDate is earlier than StartDate" on some systems. 
					// 04/09/2018 Paul.  The property EndTimeZone is valid only for Exchange 2010 or later versions. 
					// 05/09/2018 Paul.  We still return dates as UTC, so still compare that way, but set using local time. 
					if ( appointment.Service.RequestedServerVersion != ExchangeVersion.Exchange2007_SP1 )
						appointment.EndTimeZone = TimeZoneInfo.Local;
					dtDATE_END   = Sql.ToDateTime(row["DATE_END"   ]);
					if ( dtDATE_END < dtDATE_START )
					{
						dtDATE_END = dtDATE_START;
						dtDATE_END = dtDATE_END.AddHours  (Sql.ToInteger(row["DURATION_HOURS"  ]));
						dtDATE_END = dtDATE_END.AddMinutes(Sql.ToInteger(row["DURATION_MINUTES"]));
					}
					appointment.End = dtDATE_END;
					bChanged = true;
					sbChanges.AppendLine("DATE_END"      + " changed. " + dtDATE_END.ToString());
				}
				// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  Exchange stores the reminder in minutes. 
				// 03/19/2013 Paul.  Make sure to use the IsReminderSet flag to prevent reminder when not set in CRM. 
				// http://msdn.microsoft.com/en-us/library/ms528181(v=exchg.10).aspx
				if ( appointment.ReminderMinutesBeforeStart != Sql.ToInteger(row["REMINDER_TIME"]) / 60 )
				{
					// 03/19/2013 Paul.  You should not attempt to access ReminderMinutesBeforeStart without first verifying that ReminderSet is True. If ReminderSet is False, reading or writing ReminderMinutesBeforeStart returns CdoE_NOT_FOUND. 
					appointment.IsReminderSet = (Sql.ToDateTime(row["DATE_START"]) >= DateTime.Now) && (Sql.ToInteger(row["REMINDER_TIME"]) > 0);
					if ( appointment.IsReminderSet )
						appointment.ReminderMinutesBeforeStart = Sql.ToInteger(row["REMINDER_TIME"]) / 60;
					bChanged = true;
					sbChanges.AppendLine("REMINDER_TIME" + " changed.");
				}
				// 03/23/2013 Paul.  Add recurrence data. 
				string sREPEAT_TYPE = Sql.ToString(row["REPEAT_TYPE"]);
				if ( !Sql.IsEmptyString(sREPEAT_TYPE) )
				{
					int      nREPEAT_COUNT    = Sql.ToInteger (row["REPEAT_COUNT"   ]);
					int      nREPEAT_INTERVAL = Sql.ToInteger (row["REPEAT_INTERVAL"]);
					DateTime dtREPEAT_UNTIL   = Sql.ToDateTime(row["REPEAT_UNTIL"   ]);
					// http://msdn.microsoft.com/en-us/library/exchange/dd633694(v=exchg.80).aspx
					switch ( sREPEAT_TYPE )
					{
						case "Daily":
							if ( appointment.Recurrence == null || !(appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern) )
							{
								appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern(appointment.Start, nREPEAT_INTERVAL);
								bChanged = true;
								sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
							}
							else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern )
							{
								Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern recurrence = appointment.Recurrence as Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern;
								if ( recurrence.StartDate != appointment.Start )
								{
									recurrence.StartDate = appointment.Start;
									bChanged = true;
								}
								if ( recurrence.Interval != nREPEAT_INTERVAL )
								{
									recurrence.Interval = nREPEAT_INTERVAL;
									bChanged = true;
									sbChanges.AppendLine("REPEAT_INTERVAL" + " changed.");
								}
							}
							break;
						case "Weekly":
							string sREPEAT_DOW = Sql.ToString(row["REPEAT_DOW"]);
							if ( !Sql.IsEmptyString(sREPEAT_DOW) )
							{
								Microsoft.Exchange.WebServices.Data.DayOfTheWeek[] days = new Microsoft.Exchange.WebServices.Data.DayOfTheWeek[sREPEAT_DOW.Length];
								for ( int n = 0; n < sREPEAT_DOW.Length; n++ )
								{
									days[n] = (DayOfTheWeek) Sql.ToInteger(sREPEAT_DOW.Substring(n, 1));
								}
								if ( appointment.Recurrence == null || !(appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern) )
								{
									appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern(appointment.Start, nREPEAT_INTERVAL, days);
									bChanged = true;
									sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
								}
								else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern )
								{
									Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern recurrence = appointment.Recurrence as Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern;
									if ( recurrence.StartDate != appointment.Start )
									{
										recurrence.StartDate = appointment.Start;
										bChanged = true;
									}
									if ( recurrence.Interval != nREPEAT_INTERVAL )
									{
										recurrence.Interval = nREPEAT_INTERVAL;
										bChanged = true;
										sbChanges.AppendLine("REPEAT_INTERVAL" + " changed.");
									}
									string sEXCHANGE_DOW = String.Empty;
									for ( int n = 0; n < recurrence.DaysOfTheWeek.Count; n++ )
									{
										sEXCHANGE_DOW += ((int) recurrence.DaysOfTheWeek[n]).ToString();
									}
									if ( sEXCHANGE_DOW != sREPEAT_DOW )
									{
										appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern(appointment.Start, nREPEAT_INTERVAL, days);
										bChanged = true;
										sbChanges.AppendLine("REPEAT_DOW" + " changed.");
									}
								}
							}
							break;
						case "Monthly":
							if ( appointment.Recurrence == null || !(appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern) )
							{
								appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern(appointment.Start, nREPEAT_INTERVAL, appointment.Start.Day);
								bChanged = true;
								sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
							}
							else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern )
							{
								Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern recurrence = appointment.Recurrence as Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern;
								if ( recurrence.StartDate != appointment.Start )
								{
									recurrence.StartDate = appointment.Start;
									bChanged = true;
								}
								if ( recurrence.Interval != nREPEAT_INTERVAL )
								{
									recurrence.Interval = nREPEAT_INTERVAL;
									bChanged = true;
									sbChanges.AppendLine("REPEAT_INTERVAL" + " changed.");
								}
								if ( recurrence.DayOfMonth != appointment.Start.Day )
								{
									recurrence.DayOfMonth = appointment.Start.Day;
									bChanged = true;
								}
							}
							break;
						case "Yearly":
							if ( appointment.Recurrence == null || !(appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.YearlyPattern) )
							{
								appointment.Recurrence = new Microsoft.Exchange.WebServices.Data.Recurrence.YearlyPattern(appointment.Start, (Microsoft.Exchange.WebServices.Data.Month) appointment.Start.Month, appointment.Start.Day);
								bChanged = true;
								sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
							}
							else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.YearlyPattern )
							{
								Microsoft.Exchange.WebServices.Data.Recurrence.YearlyPattern recurrence = appointment.Recurrence as Microsoft.Exchange.WebServices.Data.Recurrence.YearlyPattern;
								if ( recurrence.StartDate != appointment.Start )
								{
									recurrence.StartDate = appointment.Start;
									bChanged = true;
								}
								if ( recurrence.Month != (Microsoft.Exchange.WebServices.Data.Month) appointment.Start.Month )
								{
									recurrence.Month = (Microsoft.Exchange.WebServices.Data.Month) appointment.Start.Month;
									bChanged = true;
								}
								if ( recurrence.DayOfMonth != appointment.Start.Day )
								{
									recurrence.DayOfMonth = appointment.Start.Day;
									bChanged = true;
								}
							}
							break;
					}
					// 06/22/2018 Paul.  The Recurrence property might not be loaded. 
					try
					{
						if ( appointment.Recurrence != null )
						{
							// 03/27/2013 Paul.  Set EndDate first as it will reset NumberOfOccurrences. 
							// http://msdn.microsoft.com/en-us/library/exchange/dd633684(v=exchg.80).aspx
							DateTime dtEndDate = DateTime.MinValue;
							if ( appointment.Recurrence.EndDate.HasValue )
								dtEndDate = appointment.Recurrence.EndDate.Value;
							if ( dtEndDate != dtREPEAT_UNTIL )
							{
								try
								{
									if ( dtREPEAT_UNTIL != DateTime.MinValue )
										appointment.Recurrence.EndDate = dtREPEAT_UNTIL;
									else
										appointment.Recurrence.EndDate = null;
									bChanged = true;
									sbChanges.AppendLine("REPEAT_UNTIL" + " changed.");
								}
								catch
								{
								}
							}
							int nNumberOfOccurrences = 0;
							if ( appointment.Recurrence.NumberOfOccurrences.HasValue )
								nNumberOfOccurrences = appointment.Recurrence.NumberOfOccurrences.Value;
							if ( nNumberOfOccurrences != nREPEAT_COUNT )
							{
								try
								{
									if ( nREPEAT_COUNT > 0 )
										appointment.Recurrence.NumberOfOccurrences = nREPEAT_COUNT;
									else
										appointment.Recurrence.NumberOfOccurrences = null;
									bChanged = true;
									sbChanges.AppendLine("REPEAT_COUNT" + " changed.");
								}
								catch
								{
								}
							}
						}
					}
					catch
					{
					}
				}
				else
				{
					// 06/22/2018 Paul.  The Recurrence property might not be loaded. 
					try
					{
						if ( appointment.Recurrence != null )
						{
							appointment.Recurrence = null;
							bChanged = true;
							sbChanges.AppendLine("REPEAT_TYPE" + " changed.");
						}
					}
					catch
					{
					}
				}

				// 01/15/2012 Paul.  We need to check for added or removed participants. 
				// 07/26/2012 James.  Add the ability to disable participants. 
				if ( !bDISABLE_PARTICIPANTS )
				{
					if ( dtAppointmentEmails.Rows.Count > 0 )
					{
						bool bParticipantsChanged = false;
						List<Attendee> lstAllAttendees = new List<Attendee>();
						if ( appointment.OptionalAttendees != null )
						{
							foreach ( Attendee guest in appointment.OptionalAttendees )
							{
								lstAllAttendees.Add(guest);
							}
						}
						if ( appointment.RequiredAttendees != null )
						{
							foreach ( Attendee guest in appointment.RequiredAttendees )
							{
								lstAllAttendees.Add(guest);
							}
						}

						foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
						{
							bool bEmailFound = false;
							string sEMAIL1 = Sql.ToString(rowEmail["EMAIL1"]);
							foreach ( Attendee guest in lstAllAttendees )
							{
								if ( sEMAIL1 == guest.Address )
								{
									bEmailFound = true;
									bool bREQUIRED = false;
									if ( appointment.RequiredAttendees != null )
									{
										foreach ( Attendee req in appointment.RequiredAttendees )
										{
											if ( req == guest )
												bREQUIRED = true;
										}
									}
									if ( bREQUIRED != Sql.ToBoolean(rowEmail["REQUIRED"]) )
									{
										bParticipantsChanged = true;
										break;
									}
									break;
								}
							}
							if ( !bEmailFound )
							{
								bParticipantsChanged = true;
								break;
							}
						}
						foreach ( Attendee guest in lstAllAttendees )
						{
							bool bEmailFound = false;
							foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
							{
								string sEMAIL1 = Sql.ToString(rowEmail["EMAIL1"]);
								if ( sEMAIL1 == guest.Address )
								{
									bEmailFound = true;
									break;
								}
							}
							if ( !bEmailFound )
							{
								bParticipantsChanged = true;
								break;
							}
						}
						if ( bParticipantsChanged )
						{
							appointment.OptionalAttendees.Clear();
							appointment.RequiredAttendees.Clear();
							foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
							{
								string sNAME     = Sql.ToString (rowEmail["NAME"    ]);
								string sEMAIL1   = Sql.ToString (rowEmail["EMAIL1"  ]);
								bool   bREQUIRED = Sql.ToBoolean(rowEmail["REQUIRED"]);
								Attendee guest = new Attendee(sNAME, sEMAIL1);
								if ( bREQUIRED )
									appointment.RequiredAttendees.Add(guest);
								else
									appointment.OptionalAttendees.Add(guest);
							}
							sbChanges.AppendLine("PARTICIPANTS" + " changed.");
						}
					}
					else
					{
						if ( appointment.OptionalAttendees.Count > 0 )
						{
							appointment.OptionalAttendees.Clear();
							sbChanges.AppendLine("PARTICIPANTS" + " changed.");
						}
						if ( appointment.RequiredAttendees.Count > 0 )
						{
							appointment.RequiredAttendees.Clear();
							sbChanges.AppendLine("PARTICIPANTS" + " changed.");
						}
					}
				}
			}
			return bChanged;
		}

		public void SyncAppointments(ExchangeSession Session, ExchangeService service, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			// 07/26/2012 James.  Add the ability to disable participants. 
			bool bDISABLE_PARTICIPANTS = Sql.ToBoolean(Application["CONFIG.Exchange.DisableParticipants"]);
			bool bVERBOSE_STATUS       = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"      ]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + sEXCHANGE_ALIAS + " to " + gUSER_ID.ToString());
			// 02/20/2013 Paul.  Reduced the number of days to go back. 
			int  nAPPOINTMENT_AGE_DAYS = Sql.ToInteger(Application["CONFIG.Exchange.AppointmentAgeDays" ]);
			if ( nAPPOINTMENT_AGE_DAYS == 0 )
				nAPPOINTMENT_AGE_DAYS = 7;
			
			string sCONFLICT_RESOLUTION = Sql.ToString(Application["CONFIG.Exchange.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid  (Session["TEAM_ID"]);
			// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
			//string sCRM_FOLDER_NAME     = Sql.ToString(Application["CONFIG.Exchange.CrmFolderName"     ]);
			//if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
			//	sCRM_FOLDER_NAME = "SplendidCRM";
			// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
			string sCALENDAR_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Calendar.Category"]);
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				
				try
				{
					string sSQL = String.Empty;
					// 04/05/2010 Paul.  When the Watermark is empty, no events will be created for existing items.  In that case, poll the folder 
					// 04/16/2018 Paul.  This condition makes no sense as it prevents normal processing of items unless SyncAll has been pressed on the admin page. 
					//if ( bSyncAll )
					{
						DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.MinValue;
						if ( !bSyncAll )
						{
							// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
							// 06/26/2018 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. 
							sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
							     + "  from vwAPPOINTMENTS_SYNC                           " + ControlChars.CrLf
							     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf;
							//     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								//Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
								dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(cmd.ExecuteScalar());
							}
						}
						// 03/29/2010 Paul.  We do not want to sync with old appointments, so place a 3-month limit. 
						// 02/20/2013 Paul.  Reduced the number of days to go back. 
						if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC == DateTime.MinValue )
							dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.Now.AddDays(-nAPPOINTMENT_AGE_DAYS);
						
						SearchFilter filter = null;
						List<SearchFilter> filters = new List<SearchFilter>();
						// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
						// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
						if ( !Sql.IsEmptyString(sCALENDAR_CATEGORY) )
						{
							// 06/23/2015 Paul.  Exchange 2010 does not allow the contains search, so use IsEqualTo instead. 
							filters.Add(new SearchFilter.IsEqualTo(AppointmentSchema.Categories, sCALENDAR_CATEGORY));
						}
						if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
						{
							// 03/28/2010 Paul.  The Greater Than filter does not appear to be working. 
							// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
							// 03/28/2010 Paul.  IsGreaterThan is being treated as IsGreaterThanOrEqualTo. 
							filters.Add(new SearchFilter.IsGreaterThan(AppointmentSchema.LastModifiedTime, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.AddSeconds(1)));
						}
						filter = new SearchFilter.SearchFilterCollection(LogicalOperator.And, filters.ToArray());
						
						int nPageOffset = 0;
						// 07/07/2015 Paul.  Allow the page size to be customized. 
						int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Appointments.PageSize"]);
						if ( nPageSize <= 0 )
							nPageSize = 100;
						FindItemsResults<Item> results = null;
						do
						{
							ItemView ivAppointments = new ItemView(nPageSize, nPageOffset);
							// 03/26/2010 Paul.  Sort Ascending. 
							ivAppointments.OrderBy.Add(AppointmentSchema.LastModifiedTime, SortDirection.Ascending);
							if ( filter != null )
								results = service.FindItems(WellKnownFolderName.Calendar, filter, ivAppointments);
							else
								results = service.FindItems(WellKnownFolderName.Calendar, ivAppointments);
							if ( results.Items.Count > 0 )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + results.Items.Count.ToString() + " appointments to retrieve from " + sEXCHANGE_ALIAS);
							foreach (Item itemAppointment in results.Items )
							{
								if ( itemAppointment is Appointment )
								{
									Appointment appointment = itemAppointment as Appointment;
									// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
									this.ImportAppointment(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, appointment, sbErrors);
								}
							}
							nPageOffset += nPageSize;
						}
						while ( results.MoreAvailable );
					}
					
					// 03/26/2010 Paul.  Join to vwAPPOINTMENTS_USERS so that we only get appointments that are marked as Sync. 
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					// 06/22/2018 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. 
					sSQL = "select vwAPPOINTMENTS.*                                                                   " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_ID                                                        " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_REMOTE_KEY                                                " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC                                   " + ControlChars.CrLf
					     + "     , vwAPPOINTMENTS_SYNC.SYNC_REMOTE_DATE_MODIFIED_UTC                                  " + ControlChars.CrLf
					     + "  from            vwAPPOINTMENTS                                                          " + ControlChars.CrLf
					     + "       inner join vwAPPOINTMENTS_USERS                                                    " + ControlChars.CrLf
					     + "               on vwAPPOINTMENTS_USERS.APPOINTMENT_ID       = vwAPPOINTMENTS.ID           " + ControlChars.CrLf
					     + "              and vwAPPOINTMENTS_USERS.USER_ID              = @SYNC_USER_ID               " + ControlChars.CrLf
					     + "  left outer join vwAPPOINTMENTS_SYNC                                                     " + ControlChars.CrLf
					     + "               on vwAPPOINTMENTS_SYNC.SYNC_SERVICE_NAME     = N'Exchange'                 " + ControlChars.CrLf
					     + "              and vwAPPOINTMENTS_SYNC.SYNC_LOCAL_ID         = vwAPPOINTMENTS.ID           " + ControlChars.CrLf
					//     + "              and vwAPPOINTMENTS_SYNC.SYNC_ASSIGNED_USER_ID = vwAPPOINTMENTS_USERS.USER_ID" + ControlChars.CrLf
					;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 05/02/2018 Paul.  This could be very slow, so give it a few minutes. 
						cmd.CommandTimeout = 5 * 60;
						Sql.AddParameter(cmd, "@SYNC_USER_ID", gUSER_ID);
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Appointments", "view");
						
						// 03/28/2010 Paul.  All that is important is that the current date is greater than the last sync date. 
						// 03/29/2010 Paul.  We do not want to sync with old appointments, so place a 3-month limit. 
						// 05/09/2018 Paul.  System updates can modify the UTC date, so make sure that age is outside that filter. 
						cmd.CommandText += "   and (vwAPPOINTMENTS_SYNC.ID is null or vwAPPOINTMENTS.DATE_MODIFIED_UTC > vwAPPOINTMENTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC)" + ControlChars.CrLf;
						cmd.CommandText += "   and vwAPPOINTMENTS.DATE_MODIFIED > @DATE_MODIFIED" + ControlChars.CrLf;
						// 02/20/2013 Paul.  Reduced the number of days to go back. 
						Sql.AddParameter(cmd, "@DATE_MODIFIED", DateTime.Now.AddDays(-nAPPOINTMENT_AGE_DAYS));
						cmd.CommandText += " order by vwAPPOINTMENTS.DATE_MODIFIED_UTC" + ControlChars.CrLf;
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + dt.Rows.Count.ToString() + " appointments to send to " + sEXCHANGE_ALIAS);
								foreach ( DataRow row in dt.Rows )
								{
									Guid     gID                             = Sql.ToGuid    (row["ID"                           ]);
									Guid     gASSIGNED_USER_ID               = Sql.ToGuid    (row["ASSIGNED_USER_ID"             ]);
									Guid     gSYNC_ID                        = Sql.ToGuid    (row["SYNC_ID"                      ]);
									string   sSYNC_REMOTE_KEY                = Sql.ToString  (row["SYNC_REMOTE_KEY"              ]);
									DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
									DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
									DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
									string   sSYNC_ACTION                    = Sql.IsEmptyGuid(gSYNC_ID) ? "local new" : "local changed";
									if ( SplendidInit.bEnableACLFieldSecurity )
									{
										bool bApplyACL = false;
										foreach ( DataColumn col in dt.Columns )
										{
											Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Appointments", col.ColumnName, gASSIGNED_USER_ID);
											if ( !acl.IsReadable() )
											{
												row[col.ColumnName] = DBNull.Value;
												bApplyACL = true;
											}
										}
										if ( bApplyACL )
											dt.AcceptChanges();
									}
									StringBuilder sbChanges = new StringBuilder();
									try
									{
										Appointment appointment = null;
										if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Sending new appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS);
											appointment = new Appointment(service);
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											DataTable dtAppointmentEmails = AppointmentEmails(con, Sql.ToGuid(row["ID"]));
											// 07/26/2012 James.  Add the ability to disable participants. 
											// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
											// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
											this.SetExchangeAppointment(appointment, row, dtAppointmentEmails, sbChanges, bDISABLE_PARTICIPANTS, sCALENDAR_CATEGORY);
											// 03/17/2013 Paul.  We don't want Exchange sending meeting notices.  The CRM will do that if instructed by the user. 
											// 09/17/2017 Paul.  Provide a way to turn on Exchange notices for appointments. 
											bool bAPPOINTMENT_SENDTOALL = Sql.ToBoolean(Application["CONFIG.Exchange.AppointmentSendToAll"]);
											if ( bAPPOINTMENT_SENDTOALL )
												appointment.Save(SendInvitationsMode.SendToAllAndSaveCopy);
											else
												appointment.Save(SendInvitationsMode.SendToNone);
											appointment.Load();
											sSYNC_REMOTE_KEY = appointment.Id.UniqueId;
										}
										else
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Binding appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS);
											
											// 03/28/2010 Paul.  Instead of binding, use FindItems as the appointment may have been deleted in Exchange. 
											// 03/28/2010 Paul.  FindItems is generating an exception: The specified value is invalid for property. 
											//ItemView ivAppointments = new ItemView(1, 0);
											//filter = new SearchFilter.IsEqualTo(AppointmentSchema.Id, sSYNC_REMOTE_KEY);
											//results = service.FindItems(WellKnownFolderName.Appointments, filter, ivAppointments);
											//if ( results.Items.Count > 0 )
											try
											{
												//appointment = results.Items[0] as Appointment;
												appointment = Appointment.Bind(service, sSYNC_REMOTE_KEY);
												// 03/28/2010 Paul.  We need to double-check for conflicts. 
												DateTime dtREMOTE_DATE_MODIFIED_UTC = appointment.LastModifiedTime;
												if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
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
													else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "remote changed";
													}
													else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
													{
														// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
														sSYNC_ACTION = "local changed";
													}
													else
													{
														sSYNC_ACTION = "prompt change";
													}
												}
												// 03/29/2010 Paul.  If we find the appointment, but the Categories no longer contains SplendidCRM, 
												// then the user must have stopped the syncing. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												if ( !Sql.IsEmptyString(sCALENDAR_CATEGORY) && !appointment.Categories.Contains(sCALENDAR_CATEGORY) )
												{
													sSYNC_ACTION = "remote deleted";
												}
											}
											catch(Exception ex)
											{
												string sError = "Error retrieving Exchange appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
												sError += Utils.ExpandException(ex) + ControlChars.CrLf;
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
												sbErrors.AppendLine(sError);
												sSYNC_ACTION = "remote deleted";
											}
											if ( sSYNC_ACTION == "local changed" )
											{
												// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
												// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
												DataTable dtAppointmentEmails = AppointmentEmails(con, Sql.ToGuid(row["ID"]));
												// 07/26/2012 James.  Add the ability to disable participants. 
												// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
												// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
												bool bChanged = this.SetExchangeAppointment(appointment, row, dtAppointmentEmails, sbChanges, bDISABLE_PARTICIPANTS, sCALENDAR_CATEGORY);
												if ( bChanged )
												{
													if ( bVERBOSE_STATUS )
														SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Sending appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS);
													// 03/17/2013 Paul.  We don't want Exchange sending meeting notices.  The CRM will do that if instructed by the user. 
													appointment.Update(ConflictResolutionMode.AlwaysOverwrite, SendInvitationsOrCancellationsMode.SendToNone);
													appointment.Load();
												}
											}
										}
										if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
										{
											if ( appointment != null )
											{
												// 03/25/2010 Paul.  Update the modified date after the save. 
												// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
												DateTime dtREMOTE_DATE_MODIFIED_UTC = appointment.LastModifiedTime;
												DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														// 03/26/2010 Paul.  Make sure to set the Sync flag. 
														// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
														// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
														SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sSYNC_REMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
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
										else if ( sSYNC_ACTION == "remote deleted" )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Unsyncing appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " for " + sEXCHANGE_ALIAS);
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gID, sSYNC_REMOTE_KEY, "Exchange", trn);
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
									catch(Exception ex)
									{
										// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
										string sError = "Error creating Exchange appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
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
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					sbErrors.AppendLine(Utils.ExpandException(ex));
				}
			}
		}

		// 12/27/2011 Paul.  Move population logic to a static method. 
		// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
		public bool BuildAPPOINTMENTS_Update(ExchangeSession Session, IDbCommand spAPPOINTMENTS_Update, DataRow row, Appointment appointment, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID)
		{
			bool bChanged = false;
			// 03/25/2010 Paul.  We start with the existing record values so that we can apply ACL Field Security rules. 
			if ( row != null && row.Table != null )
			{
				foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					// 03/28/2010 Paul.  We must assign a value to all parameters. 
					string sParameterName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
					if ( row.Table.Columns.Contains(sParameterName) )
						par.Value = row[sParameterName];
					else
						par.Value = DBNull.Value;
				}
			}
			else
			{
				bChanged = true;
				foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
				{
					// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
					string sParameterName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
					if ( sParameterName == "TEAM_ID" )
						par.Value = gTEAM_ID;
					else if ( sParameterName == "ASSIGNED_USER_ID" )
						par.Value = gUSER_ID;
					// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
					else if ( sParameterName == "MODIFIED_USER_ID" )
						par.Value = gUSER_ID;
					else
						par.Value = DBNull.Value;
				}
			}
			TimeSpan tsDURATION = (appointment.End - appointment.Start);
			foreach(IDbDataParameter par in spAPPOINTMENTS_Update.Parameters)
			{
				Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
				// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
				string sColumnName = Sql.ExtractDbName(spAPPOINTMENTS_Update, par.ParameterName).ToUpper();
				if ( SplendidInit.bEnableACLFieldSecurity )
				{
					acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Appointments", sColumnName, gASSIGNED_USER_ID);
				}
				if ( acl.IsWriteable() )
				{
					try
					{
						// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
						object oValue = null;
						switch ( sColumnName )
						{
							case "DESCRIPTION"               :  oValue = Sql.ToDBString  (appointment.Body.Text          );  break;
							case "NAME"                      :  oValue = Sql.ToDBString  (appointment.Subject            );  break;
							case "LOCATION"                  :  oValue = Sql.ToDBString  (appointment.Location           );  break;
							case "DATE_TIME"                 :  oValue = Sql.ToDBDateTime(appointment.Start.ToLocalTime());  break;
							case "DURATION_HOURS"            :  oValue = tsDURATION.Hours                                 ;  break;
							case "DURATION_MINUTES"          :  oValue = tsDURATION.Minutes                               ;  break;
							// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  Exchange stores the reminder in minutes. 
							// 03/19/2013 Paul.  Use IsReminderSet from Exchange. 
							// http://msdn.microsoft.com/en-us/library/ms528181(v=exchg.10).aspx
							case "REMINDER_TIME"             :  oValue = appointment.IsReminderSet ? appointment.ReminderMinutesBeforeStart * 60 : 0;  break;
							case "MODIFIED_USER_ID"          :  oValue = gUSER_ID;  break;
							// 03/10/2013 Paul.  Add ALL_DAY_EVENT. 
							case "ALL_DAY_EVENT"             :  oValue = appointment.IsAllDayEvent                        ;  break;
							// 03/23/2013 Paul.  Add recurrence data. 
							case "REPEAT_TYPE"               :
								// 01/14/2021 Paul.  Default should be null and not empty string. 
								oValue = DBNull.Value;
								if ( appointment.Recurrence != null )
								{
									if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern )
										oValue = "Daily";
									else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern )
										oValue = "Weekly";
									else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern )
										oValue = "Monthly";
									else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.YearlyPattern )
										oValue = "Yearly";
								}
								break;
							case "REPEAT_INTERVAL"           :
								oValue = 0;
								if ( appointment.Recurrence != null )
								{
									if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern )
										oValue = (appointment.Recurrence as Microsoft.Exchange.WebServices.Data.Recurrence.DailyPattern).Interval;
									else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern )
										oValue = (appointment.Recurrence as Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern).Interval;
									else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern )
										oValue = (appointment.Recurrence as Microsoft.Exchange.WebServices.Data.Recurrence.MonthlyPattern).Interval;
									else if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.YearlyPattern )
										oValue = 1;
								}
								break;
							case "REPEAT_DOW"                :
								// 01/14/2021 Paul.  Default should be null and not empty string. 
								oValue = DBNull.Value;
								if ( appointment.Recurrence != null )
								{
									if ( appointment.Recurrence is Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern )
									{
										Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern recurrence = appointment.Recurrence as Microsoft.Exchange.WebServices.Data.Recurrence.WeeklyPattern;
										string sEXCHANGE_DOW = String.Empty;
										for ( int n = 0; n < recurrence.DaysOfTheWeek.Count; n++ )
										{
											sEXCHANGE_DOW += ((int) recurrence.DaysOfTheWeek[n]).ToString();
										}
										oValue = sEXCHANGE_DOW;
									}
								}
								break;
							case "REPEAT_UNTIL"              :
								oValue = DBNull.Value;
								if ( appointment.Recurrence != null )
								{
									if ( appointment.Recurrence.EndDate.HasValue )
										oValue = appointment.Recurrence.EndDate;
								}
								break;
							case "REPEAT_COUNT"              :
								oValue = 0;
								if ( appointment.Recurrence != null )
								{
									if ( appointment.Recurrence.NumberOfOccurrences.HasValue )
										oValue = appointment.Recurrence.NumberOfOccurrences;
								}
								break;
						}
						// 02/28/2012 Paul.  Only set the parameter value if the value is being set. 
						if ( oValue != null )
						{
							if ( !bChanged )
							{
								switch ( par.DbType )
								{
									case DbType.Guid    :  if ( Sql.ToGuid    (par.Value) != Sql.ToGuid    (oValue) ) bChanged = true;  break;
									case DbType.Int16   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int32   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Int64   :  if ( Sql.ToInteger (par.Value) != Sql.ToInteger (oValue) ) bChanged = true;  break;
									case DbType.Double  :  if ( Sql.ToDouble  (par.Value) != Sql.ToDouble  (oValue) ) bChanged = true;  break;
									case DbType.Decimal :  if ( Sql.ToDecimal (par.Value) != Sql.ToDecimal (oValue) ) bChanged = true;  break;
									case DbType.Boolean :  if ( Sql.ToBoolean (par.Value) != Sql.ToBoolean (oValue) ) bChanged = true;  break;
									case DbType.DateTime:  if ( Sql.ToDateTime(par.Value) != Sql.ToDateTime(oValue) ) bChanged = true;  break;
									default             :  if ( Sql.ToString  (par.Value) != Sql.ToString  (oValue) ) bChanged = true;  break;
								}
							}
							par.Value = oValue;
						}
					}
					catch
					{
						// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}

		public void ImportAppointment(ExchangeSession Session, ExchangeService service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, Appointment appointment, StringBuilder sbErrors)
		{
			// 07/26/2012 James.  Add the ability to disable participants. 
			bool   bDISABLE_PARTICIPANTS = Sql.ToBoolean(Application["CONFIG.Exchange.DisableParticipants"]);
			bool   bVERBOSE_STATUS       = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"      ]);
			string sCONFLICT_RESOLUTION  = Sql.ToString (Application["CONFIG.Exchange.ConflictResolution" ]);
			Guid   gTEAM_ID              = Sql.ToGuid   (Session["TEAM_ID"]);
			// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
			//string sCRM_FOLDER_NAME     = Sql.ToString  (Application["CONFIG.Exchange.CrmFolderName"      ]);
			//if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
			//	sCRM_FOLDER_NAME = "SplendidCRM";
			// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
			string sCALENDAR_CATEGORY = Sql.ToString(Application["CONFIG.Exchange.Calendar.Category"]);
			
			IDbCommand spAPPOINTMENTS_Update = SqlProcs.Factory(con, "spAPPOINTMENTS_Update");
			
			string   sREMOTE_KEY                = appointment.Id.UniqueId;
			// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
			DateTime dtREMOTE_DATE_MODIFIED_UTC = appointment.LastModifiedTime;
			DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);

			String sSQL = String.Empty;
			// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
			// 06/22/2018 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. 
			sSQL = "select SYNC_ID                                       " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_DATE_MODIFIED_UTC                  " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_DATE_MODIFIED_UTC                 " + ControlChars.CrLf
			     + "     , SYNC_APPOINTMENT                              " + ControlChars.CrLf
			     + "     , ID                                            " + ControlChars.CrLf
			     + "     , DATE_MODIFIED_UTC                             " + ControlChars.CrLf
			     + "  from vwAPPOINTMENTS_SYNC                           " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
			//     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
			     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
				Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;
					string sSYNC_ACTION   = String.Empty;
					Guid   gID            = Guid.Empty;
					Guid   gSYNC_LOCAL_ID = Guid.Empty;
					using ( DataTable dt = new DataTable() )
					{
						da.Fill(dt);
						if ( dt.Rows.Count > 0 )
						{
							DataRow row = dt.Rows[0];
							gID                                      = Sql.ToGuid    (row["ID"                           ]);
							gSYNC_LOCAL_ID                           = Sql.ToGuid    (row["SYNC_LOCAL_ID"                ]);
							DateTime dtSYNC_LOCAL_DATE_MODIFIED_UTC  = Sql.ToDateTime(row["SYNC_LOCAL_DATE_MODIFIED_UTC" ]);
							DateTime dtSYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(row["SYNC_REMOTE_DATE_MODIFIED_UTC"]);
							DateTime dtDATE_MODIFIED_UTC             = Sql.ToDateTime(row["DATE_MODIFIED_UTC"            ]);
							bool     bSYNC_APPOINTMENT               = Sql.ToBoolean (row["SYNC_APPOINTMENT"             ]);
							// 03/24/2010 Paul.  Exchange Record has already been mapped for this user. 
							// 03/28/2010 Paul.  If the ID is NULL and the LOCAL_ID is NOT NULL, then the local item must have been deleted. 
							// 03/29/2010 Paul.  If ID and LOCAL_ID are valid, but SYNC_APPOINTMENT is not, then the user has stopped syncing the contact. 
							if ( (Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID)) || (!Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID) && !bSYNC_APPOINTMENT) )
							{
								sSYNC_ACTION = "local deleted";
							}
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
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
								else if ( dtREMOTE_DATE_MODIFIED_UTC.AddHours(1) > dtDATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "remote changed";
								}
								else if ( dtDATE_MODIFIED_UTC.AddHours(1) > dtREMOTE_DATE_MODIFIED_UTC )
								{
									// 03/25/2010 Paul.  Attempt to allow the end-user to resolve by editing the local or remote item. 
									sSYNC_ACTION = "local changed";
								}
								else
								{
									sSYNC_ACTION = "prompt change";
								}
								
							}
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Remote Record has changed, but Local has not. 
								sSYNC_ACTION = "remote changed";
							}
							else if ( dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
							{
								// 03/24/2010 Paul.  Local Record has changed, but Remote has not. 
								sSYNC_ACTION = "local changed";
							}
						}
						else
						{
							sSYNC_ACTION = "remote new";
							
							// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to Exchange. 
							// 03/28/2010 Paul.  We need to prevent duplicate Exchange entries from attaching to an existing mapped Appointment ID. 
							// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
							// 06/22/2018 Paul.  There can only be one appointment sync record, otherwise all users would see multiple entries in Outlook. 
							cmd.Parameters.Clear();
							sSQL = "select vwAPPOINTMENTS.ID             " + ControlChars.CrLf
							     + "  from            vwAPPOINTMENTS     " + ControlChars.CrLf
							     + "  left outer join vwAPPOINTMENTS_SYNC" + ControlChars.CrLf
							     + "               on vwAPPOINTMENTS_SYNC.SYNC_SERVICE_NAME     = N'Exchange'           " + ControlChars.CrLf
							//     + "              and vwAPPOINTMENTS_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_LOCAL_ID         = vwAPPOINTMENTS.ID     " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Appointments", "view");
							
							Sql.AppendParameter(cmd, Sql.ToString(appointment.Subject), "NAME"      );
							Sql.AppendParameter(cmd, appointment.Start.ToLocalTime()  , "DATE_START");
							cmd.CommandText += "   and vwAPPOINTMENTS_SYNC.ID is null" + ControlChars.CrLf;
							gID = Sql.ToGuid(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyGuid(gID) )
							{
								// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to Exchange. 
								sSYNC_ACTION = "local new";
							}
						}
					}
					using ( DataTable dt = new DataTable() )
					{
						DataRow row = null;
						Guid gASSIGNED_USER_ID = Guid.Empty;
						// 01/15/2012 Paul.  Add the user to the meeting. 
						string sAPPOINTMENT_TYPE = String.Empty;
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" || sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new" )
						{
							if ( !Sql.IsEmptyGuid(gID) )
							{
								cmd.Parameters.Clear();
								sSQL = "select *             " + ControlChars.CrLf
								     + "  from vwAPPOINTMENTS" + ControlChars.CrLf
								     + " where ID = @ID      " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
								{
									row = dt.Rows[0];
									sAPPOINTMENT_TYPE = Sql.ToString(row["APPOINTMENT_TYPE"]);
									gASSIGNED_USER_ID = Sql.ToGuid  (row["ASSIGNED_USER_ID"]);
								}
							}
						}
						if ( sSYNC_ACTION == "remote new" || sSYNC_ACTION == "remote changed" )
						{
							try
							{
								// 03/28/2010 Paul.  Reload the full appointment so that it will include the Body. 
								// 03/28/2010 Paul.  The binding can fail if the appointment does not define the FileAs field. 
								appointment = Appointment.Bind(service, sREMOTE_KEY);
								// 11/18/2014 Paul.  Get body as plain text. 
								if ( Sql.ToBoolean(Application["CONFIG.Exchange.Appointment.PlainText"]) )
								{
									Microsoft.Exchange.WebServices.Data.PropertySet psPlainText = new Microsoft.Exchange.WebServices.Data.PropertySet(Microsoft.Exchange.WebServices.Data.BasePropertySet.FirstClassProperties, Microsoft.Exchange.WebServices.Data.AppointmentSchema.Body);
									psPlainText.RequestedBodyType = Microsoft.Exchange.WebServices.Data.BodyType.Text;
									// 11/18/2014 Paul.  We are not getting the full item here, so just grab the body. 
									try
									{
										Microsoft.Exchange.WebServices.Data.Appointment appointment1 = Microsoft.Exchange.WebServices.Data.Appointment.Bind(service, sREMOTE_KEY, psPlainText);
										appointment.Body.BodyType = appointment1.Body.BodyType;
										appointment.Body.Text     = appointment1.Body.Text    ;
										//SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sItemID + ControlChars.CrLf + "BodyText: " + appointment.Body.Text);
									}
									catch
									{
									}
								}
							}
							catch(Exception ex)
							{
								string sError = "Error retrieving " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToLocalTime().ToString()) + " for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							// 01/15/2012 Paul.  We need to check for added or removed participants. 
							// 04/02/2012 Paul.  Add Calls/Leads relationship. 
							Dictionary<string, Guid> dictLeads       = new Dictionary<string,Guid>();
							Dictionary<string, Guid> dictContacts    = new Dictionary<string,Guid>();
							Dictionary<string, Guid> dictUsers       = new Dictionary<string,Guid>();
							List<string>             lstParticipants = new List<string>();
							DataTable dtUSERS = new DataTable();
							// 07/26/2012 James.  Add the ability to disable participants. 
							if ( !bDISABLE_PARTICIPANTS )
							{
								if ( appointment.OptionalAttendees != null )
								{
									foreach ( Attendee guest in appointment.OptionalAttendees )
									{
										lstParticipants.Add(guest.Address.ToLower());
									}
								}
								if ( appointment.RequiredAttendees != null )
								{
									foreach ( Attendee guest in appointment.RequiredAttendees )
									{
										lstParticipants.Add(guest.Address.ToLower());
									}
								}
								
								cmd.Parameters.Clear();
								sSQL = "select APPOINTMENT_ID         " + ControlChars.CrLf
								     + "     , APPOINTMENT_TYPE       " + ControlChars.CrLf
								     + "     , CONTACT_ID             " + ControlChars.CrLf
								     + "     , CONTACT_NAME           " + ControlChars.CrLf
								     + "     , EMAIL1                 " + ControlChars.CrLf
								     + "  from vwAPPOINTMENTS_CONTACTS" + ControlChars.CrLf
								     + " where APPOINTMENT_ID = @ID   " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtCONTACTS = new DataTable() )
								{
									da.Fill(dtCONTACTS);
									foreach ( DataRow rowContact in dtCONTACTS.Rows )
									{
										Guid   gAPPOINTMENT_CONTACT_ID = Sql.ToGuid  (rowContact["CONTACT_ID"]);
										string sAPPOINTMENT_EMAIL1     = Sql.ToString(rowContact["EMAIL1"    ]).ToLower();
										if ( !Sql.IsEmptyString(sAPPOINTMENT_EMAIL1) && !dictContacts.ContainsKey(sAPPOINTMENT_EMAIL1) )
											dictContacts.Add(sAPPOINTMENT_EMAIL1, gAPPOINTMENT_CONTACT_ID);
									}
								}
								
								// 04/02/2012 Paul.  Add Calls/Leads relationship. 
								cmd.Parameters.Clear();
								sSQL = "select APPOINTMENT_ID         " + ControlChars.CrLf
								     + "     , APPOINTMENT_TYPE       " + ControlChars.CrLf
								     + "     , LEAD_ID                " + ControlChars.CrLf
								     + "     , LEAD_NAME              " + ControlChars.CrLf
								     + "     , EMAIL1                 " + ControlChars.CrLf
								     + "  from vwAPPOINTMENTS_LEADS   " + ControlChars.CrLf
								     + " where APPOINTMENT_ID = @ID   " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtLEADS = new DataTable() )
								{
									da.Fill(dtLEADS);
									foreach ( DataRow rowLead in dtLEADS.Rows )
									{
										Guid   gAPPOINTMENT_LEAD_ID = Sql.ToGuid  (rowLead["LEAD_ID"]);
										string sAPPOINTMENT_EMAIL1  = Sql.ToString(rowLead["EMAIL1" ]).ToLower();
										if ( !Sql.IsEmptyString(sAPPOINTMENT_EMAIL1) && !dictLeads.ContainsKey(sAPPOINTMENT_EMAIL1) )
											dictLeads.Add(sAPPOINTMENT_EMAIL1, gAPPOINTMENT_LEAD_ID);
									}
								}
								
								cmd.Parameters.Clear();
								// 02/20/2013 Paul.  Invalid column name 'USER_ID'.  Use ASSIGNED_USER_ID instead. 
								sSQL = "select vwAPPOINTMENTS_USERS.APPOINTMENT_ID      " + ControlChars.CrLf
								     + "     , vwAPPOINTMENTS_USERS.USER_ID             " + ControlChars.CrLf
								     + "     , vwEXCHANGE_USERS.EXCHANGE_ALIAS          " + ControlChars.CrLf
								     + "     , vwEXCHANGE_USERS.EXCHANGE_EMAIL          " + ControlChars.CrLf
								     + "  from      vwAPPOINTMENTS_USERS                " + ControlChars.CrLf
								     + " inner join vwEXCHANGE_USERS                    " + ControlChars.CrLf
								     + "         on vwEXCHANGE_USERS.ASSIGNED_USER_ID = vwAPPOINTMENTS_USERS.USER_ID" + ControlChars.CrLf
								     + " where vwAPPOINTMENTS_USERS.APPOINTMENT_ID = @ID" + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dtUSERS);
								foreach ( DataRow rowUser in dtUSERS.Rows )
								{
									Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"            ]);
									string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EXCHANGE_EMAIL"     ]).ToLower();
									string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["EXCHANGE_ALIAS"     ]).ToLower();
									if ( !Sql.IsEmptyString(sAPPOINTMENT_EMAIL1) && !dictUsers.ContainsKey(sAPPOINTMENT_EMAIL1) )
										dictUsers.Add(sAPPOINTMENT_EMAIL1, gAPPOINTMENT_USER_ID);
									if ( !Sql.IsEmptyString(sAPPOINTMENT_USERNAME) && !dictUsers.ContainsKey(sAPPOINTMENT_USERNAME) )
										dictUsers.Add(sAPPOINTMENT_USERNAME, gAPPOINTMENT_USER_ID);
								}
							}
							
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Retrieving appointment " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS);
									
									spAPPOINTMENTS_Update.Transaction = trn;
									// 12/27/2011 Paul.  Move population logic to a static method. 
									// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
									bool bChanged = BuildAPPOINTMENTS_Update(Session, spAPPOINTMENTS_Update, row, appointment, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID);
									if ( !bChanged )
									{
										// 07/26/2012 James.  Add the ability to disable participants. 
										if ( !bDISABLE_PARTICIPANTS )
										{
											foreach ( string sEmail in lstParticipants )
											{
												// 04/02/2012 Paul.  Add Calls/Leads relationship. 
												if ( !dictContacts.ContainsKey(sEmail) && !dictLeads.ContainsKey(sEmail) )
													bChanged = true;
											}
											foreach ( string sEmail in dictContacts.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
													bChanged = true;
											}
											// 04/02/2012 Paul.  Add Calls/Leads relationship. 
											foreach ( string sEmail in dictLeads.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
													bChanged = true;
											}
											foreach ( DataRow rowUser in dtUSERS.Rows )
											{
												Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"            ]);
												// 02/20/2013 Paul.  Correct field names for Exchange Sync.  Not Google Apps. 
												string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EXCHANGE_EMAIL"     ]).ToLower();
												string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["EXCHANGE_ALIAS"     ]).ToLower();
												if ( gAPPOINTMENT_USER_ID != gUSER_ID && !lstParticipants.Contains(sAPPOINTMENT_EMAIL1) && !lstParticipants.Contains(sAPPOINTMENT_USERNAME) )
												{
													bChanged = true;
												}
											}
										}
									}
									if ( bChanged )
									{
										Sql.Trace(spAPPOINTMENTS_Update);
										// 05/09/2018 Paul.  Noticing some timeouts. Just wait for up to 10 min. 
										spAPPOINTMENTS_Update.CommandTimeout = 10 * 60;
										spAPPOINTMENTS_Update.ExecuteNonQuery();
										IDbDataParameter parID = Sql.FindParameter(spAPPOINTMENTS_Update, "@ID");
										gID = Sql.ToGuid(parID.Value);
									
										// 07/26/2012 James.  Add the ability to disable participants. 
										if ( !bDISABLE_PARTICIPANTS )
										{
											// 01/15/2012 Paul.  We need to add the current user to the appointment so that the SYNC_APPOINTMENT will be true. 
											// If the end-user removes himself from the meeting, SYNC_APPOINTMENT will be false and the appointment will be treated as local deleted. 
											if ( sAPPOINTMENT_TYPE == "Meetings" || Sql.IsEmptyString(sAPPOINTMENT_TYPE) )
												SqlProcs.spMEETINGS_USERS_Update(gID, gUSER_ID, true, String.Empty, trn);
											else if ( sAPPOINTMENT_TYPE == "Calls" )
												SqlProcs.spCALLS_USERS_Update(gID, gUSER_ID, true, String.Empty, trn);
									
											// 01/15/2012 Paul.  We need to check for added or removed participants. 
											if ( appointment.RequiredAttendees != null )
											{
												foreach ( Attendee guest in appointment.RequiredAttendees )
												{
													string sEmail         = guest.Address.ToLower();
													bool   bREQUIRED      = false;
													string sACCEPT_STATUS = String.Empty;
													if ( guest.ResponseType != null )
													{
														switch ( guest.ResponseType )
														{
															case MeetingResponseType.Organizer         :  sACCEPT_STATUS = "accept"   ;  break;
															case MeetingResponseType.Accept            :  sACCEPT_STATUS = "accept"   ;  break;
															case MeetingResponseType.Decline           :  sACCEPT_STATUS = "decline"  ;  break;
															case MeetingResponseType.Tentative         :  sACCEPT_STATUS = "tentative";  break;
															case MeetingResponseType.NoResponseReceived:  sACCEPT_STATUS = "none"     ;  break;
														}
													}
													/*
													if ( guest.Attendee_Type != null )
													{
														if ( guest.Attendee_Type.Value == Who.AttendeeType.EVENT_REQUIRED )
															bREQUIRED = true;
													}
													*/
													// 01/10/2012 Paul.  iCloud can have contacts without an email. 
													Guid gCONTACT_ID = Guid.Empty;
													SqlProcs.spAPPOINTMENTS_RELATED_Update(gID, sEmail, bREQUIRED, sACCEPT_STATUS, String.Empty, ref gCONTACT_ID, trn);
												}
											}
											if ( appointment.OptionalAttendees != null )
											{
												foreach ( Attendee guest in appointment.OptionalAttendees )
												{
													string sEmail         = guest.Address.ToLower();
													bool   bREQUIRED      = false;
													string sACCEPT_STATUS = String.Empty;
													if ( guest.ResponseType != null )
													{
														switch ( guest.ResponseType )
														{
															case MeetingResponseType.Organizer         :  sACCEPT_STATUS = "accept"   ;  break;
															case MeetingResponseType.Accept            :  sACCEPT_STATUS = "accept"   ;  break;
															case MeetingResponseType.Decline           :  sACCEPT_STATUS = "decline"  ;  break;
															case MeetingResponseType.Tentative         :  sACCEPT_STATUS = "tentative";  break;
															case MeetingResponseType.NoResponseReceived:  sACCEPT_STATUS = "none"     ;  break;
														}
													}
													/*
													if ( guest.Attendee_Type != null )
													{
														if ( guest.Attendee_Type.Value == Who.AttendeeType.EVENT_REQUIRED )
															bREQUIRED = true;
													}
													*/
													// 01/10/2012 Paul.  iCloud can have contacts without an email. 
													Guid gCONTACT_ID = Guid.Empty;
													SqlProcs.spAPPOINTMENTS_RELATED_Update(gID, sEmail, bREQUIRED, sACCEPT_STATUS, String.Empty, ref gCONTACT_ID, trn);
												}
											}
											foreach ( string sEmail in dictContacts.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
												{
													Guid gAPPOINTMENT_CONTACT_ID = dictContacts[sEmail];
													SqlProcs.spAPPOINTMENTS_CONTACTS_Delete(gID, gAPPOINTMENT_CONTACT_ID, trn);
												}
											}
											// 04/02/2012 Paul.  Add Calls/Leads relationship. 
											foreach ( string sEmail in dictLeads.Keys )
											{
												if ( !lstParticipants.Contains(sEmail) )
												{
													Guid gAPPOINTMENT_LEAD_ID = dictLeads[sEmail];
													SqlProcs.spAPPOINTMENTS_LEADS_Delete(gID, gAPPOINTMENT_LEAD_ID, trn);
												}
											}
											foreach ( DataRow rowUser in dtUSERS.Rows )
											{
												Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"            ]);
												// 02/20/2013 Paul.  Correct field names for Exchange Sync.  Not Google Apps. 
												string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EXCHANGE_EMAIL"     ]).ToLower();
												string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["EXCHANGE_ALIAS"     ]).ToLower();
												// 01/14/2012 Paul.  Make sure not to remove this user. 
												if ( gAPPOINTMENT_USER_ID != gUSER_ID && !lstParticipants.Contains(sAPPOINTMENT_EMAIL1) && !lstParticipants.Contains(sAPPOINTMENT_USERNAME) )
												{
													SqlProcs.spAPPOINTMENTS_USERS_Delete(gID, gAPPOINTMENT_USER_ID, trn);
												}
											}
										}
									}
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									// 02/20/2013 Paul.  Log inner error. 
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
									throw;
								}
							}
						}
						else if ( (sSYNC_ACTION == "local changed" || sSYNC_ACTION == "local new") && !Sql.IsEmptyGuid(gID) )
						{
							// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to Exchange. 
							if ( dt.Rows.Count > 0 )
							{
								row = dt.Rows[0];
								if ( SplendidInit.bEnableACLFieldSecurity )
								{
									bool bApplyACL = false;
									foreach ( DataColumn col in dt.Columns )
									{
										Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Appointments", col.ColumnName, gASSIGNED_USER_ID);
										if ( !acl.IsReadable() )
										{
											row[col.ColumnName] = DBNull.Value;
											bApplyACL = true;
										}
									}
									if ( bApplyACL )
										dt.AcceptChanges();
								}
								StringBuilder sbChanges = new StringBuilder();
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Syncing appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS);
									// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
									// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
									DataTable dtAppointmentEmails = AppointmentEmails(con, Sql.ToGuid(row["ID"]));
									// 07/26/2012 James.  Add the ability to disable participants. 
									// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
									// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
									bool bChanged = this.SetExchangeAppointment(appointment, row, dtAppointmentEmails, sbChanges, bDISABLE_PARTICIPANTS, sCALENDAR_CATEGORY);
									if ( bChanged )
									{
										// 03/17/2013 Paul.  We don't want Exchange sending meeting notices.  The CRM will do that if instructed by the user. 
										appointment.Update(ConflictResolutionMode.AlwaysOverwrite, SendInvitationsOrCancellationsMode.SendToNone);
										appointment.Load();
									}
									// 03/25/2010 Paul.  Update the modified date after the save. 
									// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
									dtREMOTE_DATE_MODIFIED_UTC = appointment.LastModifiedTime;
									dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 03/26/2010 Paul.  Make sure to set the Sync flag. 
											// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
											// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
											SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Exchange", String.Empty, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
											throw;
										}
									}
								}
								catch(Exception ex)
								{
									// 03/25/2010 Paul.  Log the error, but don't exit the loop. 
									string sError = "Error saving " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
									sError += sbChanges.ToString();
									sError += Utils.ExpandException(ex) + ControlChars.CrLf;
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									//SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
									sbErrors.AppendLine(sError);
								}
							}
						}
						else if ( sSYNC_ACTION == "local deleted" )
						{
							try
							{
								// 03/28/2010 Paul.  Load the full appointment so that we can modify just the one field. 
								appointment.Load();
								// 03/12/2013 Paul.  Use sCRM_FOLDER_NAME as the category name. 
								// 09/02/2013 Paul.  Add separate category fields so that we can allow an empty category to mean all. 
								// 09/02/2018 Paul.  Provide an option to delete the created record. 
								if ( !Sql.IsEmptyString(sCALENDAR_CATEGORY) && !Sql.ToBoolean(Application["CONFIG.Exchange.Appointments.Delete"]) )
								{
									appointment.Categories.Remove(sCALENDAR_CATEGORY);
									// 03/17/2013 Paul.  We don't want Exchange sending meeting notices.  The CRM will do that if instructed by the user. 
									appointment.Update(ConflictResolutionMode.AlwaysOverwrite, SendInvitationsOrCancellationsMode.SendToNone);
								}
								else
								{
									// 09/02/2013 Paul.  If the category is empty, then delete the appointment. 
									appointment.Delete(DeleteMode.SoftDelete);
								}
							}
							catch(Exception ex)
							{
								string sError = "Error clearing Exchange categories for " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							try
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Deleting " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS);
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
										SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sREMOTE_KEY, "Exchange", trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										throw;
									}
								}
							}
							catch(Exception ex)
							{
								string sError = "Error deleting " + Sql.ToString(appointment.Subject) + " " + Sql.ToString(appointment.Start.ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
						}
					}
				}
			}
		}
		#endregion

		#region Sync Folders
		// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
		public void SyncSentItems(ExchangeSession Session, ExchangeService service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			
			try
			{
				Folder fldSentItems = Folder.Bind(service, WellKnownFolderName.SentItems);
				if ( bSyncAll || dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
				{
					SearchFilter filter = null;
					if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
					{
						// 03/28/2010 Paul.  The Greater Than filter does not appear to be working. 
						// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
						// 03/28/2010 Paul.  IsGreaterThan is being treated as IsGreaterThanOrEqualTo. 
						filter = new SearchFilter.IsGreaterThan(EmailMessageSchema.LastModifiedTime, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.AddSeconds(1));
					}
					int nImportCount = 0;
					int nPageOffset = 0;
					// 07/07/2015 Paul.  Allow the page size to be customized. 
					int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Messages.PageSize"]);
					if ( nPageSize <= 0 )
						nPageSize = 100;
					FindItemsResults<Item> results = null;
					do
					{
						ItemView ivMessages = new ItemView(nPageSize, nPageOffset);
						// 03/31/2010 Paul.  IdOnly is expected to be very fast. 
						ivMessages.PropertySet = PropertySet.IdOnly;
						// 03/13/2012 Paul.  There can be lots of records, so get the most recent first when getting all. 
						// Otherwise, get based on ascending date. 
						if ( filter != null )
						{
							ivMessages.OrderBy.Add(EmailMessageSchema.LastModifiedTime, SortDirection.Ascending);
							results = service.FindItems(fldSentItems.Id, filter, ivMessages);
						}
						else
						{
							ivMessages.OrderBy.Add(EmailMessageSchema.LastModifiedTime, SortDirection.Descending);
							results = service.FindItems(fldSentItems.Id, ivMessages);
						}
						if ( results.Items.Count > 0 )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncSentItems: " + results.Items.Count.ToString() + " Sent Items messages to retrieve for " + sEXCHANGE_ALIAS);
						
						foreach (Item itemMessage in results.Items )
						{
							if ( itemMessage is EmailMessage )
							{
								EmailMessage email = itemMessage as EmailMessage;
								this.ImportSentItem(Session, con, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								nImportCount++;
							}
						}
						nPageOffset += nPageSize;
					}
					while ( results.MoreAvailable );
					// 04/25/2010 Paul.  We need some status on the Sync page. 
					if ( nImportCount > 0 && bVERBOSE_STATUS )
					{
						sbErrors.AppendLine(nImportCount.ToString() + " messages received in Sent Items for " + sEXCHANGE_ALIAS + "<br />");
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

		// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
		public void SyncInbox(ExchangeSession Session, ExchangeService service, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			
			try
			{
				Folder fldInbox = Folder.Bind(service, WellKnownFolderName.Inbox);
				if ( bSyncAll || dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
				{
					SearchFilter filter = null;
					if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
					{
						// 03/28/2010 Paul.  The Greater Than filter does not appear to be working. 
						// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
						// 03/28/2010 Paul.  IsGreaterThan is being treated as IsGreaterThanOrEqualTo. 
						filter = new SearchFilter.IsGreaterThan(EmailMessageSchema.LastModifiedTime, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.AddSeconds(1));
					}
					int nImportCount = 0;
					int nPageOffset = 0;
					// 07/07/2015 Paul.  Allow the page size to be customized. 
					int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Messages.PageSize"]);
					if ( nPageSize <= 0 )
						nPageSize = 100;
					FindItemsResults<Item> results = null;
					do
					{
						ItemView ivMessages = new ItemView(nPageSize, nPageOffset);
						// 03/31/2010 Paul.  IdOnly is expected to be very fast. 
						ivMessages.PropertySet = PropertySet.IdOnly;
						// 03/13/2012 Paul.  There can be lots of records, so get the most recent first when getting all. 
						// Otherwise, get based on ascending date. 
						if ( filter != null )
						{
							ivMessages.OrderBy.Add(EmailMessageSchema.LastModifiedTime, SortDirection.Ascending);
							results = service.FindItems(fldInbox.Id, filter, ivMessages);
						}
						else
						{
							ivMessages.OrderBy.Add(EmailMessageSchema.LastModifiedTime, SortDirection.Descending);
							results = service.FindItems(fldInbox.Id, ivMessages);
						}
						if ( results.Items.Count > 0 )
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncInbox: " + results.Items.Count.ToString() + " Inbox messages to retrieve for " + sEXCHANGE_ALIAS);
						
						foreach (Item itemMessage in results.Items )
						{
							if ( itemMessage is EmailMessage )
							{
								EmailMessage email = itemMessage as EmailMessage;
								this.ImportInbox(Session, con, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								nImportCount++;
							}
						}
						nPageOffset += nPageSize;
					}
					while ( results.MoreAvailable );
					// 04/25/2010 Paul.  We need some status on the Sync page. 
					if ( nImportCount > 0 && bVERBOSE_STATUS )
					{
						sbErrors.AppendLine(nImportCount.ToString() + " messages received in Inbox for " + sEXCHANGE_ALIAS + "<br />");
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

		public void SyncModuleFolders(ExchangeSession Session, ExchangeService service, IDbConnection con, WellKnownFolderName fldExchangeRoot, ref Folder fldSplendidRoot, ref Folder fldModuleFolder, string sMODULE_NAME, Guid gPARENT_ID, string sPARENT_NAME, string sEXCHANGE_ALIAS, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS  = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			string sCRM_FOLDER_NAME = Sql.ToString (Application["CONFIG.Exchange.CrmFolderName"]);
			string sCULTURE         = L10N.NormalizeCulture(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			if ( Sql.IsEmptyString(sCRM_FOLDER_NAME) )
				sCRM_FOLDER_NAME = "SplendidCRM";
			
			try
			{
				SearchFilter filter = null;
				if ( fldSplendidRoot == null )
				{
					filter = new SearchFilter.IsEqualTo(FolderSchema.DisplayName, sCRM_FOLDER_NAME);
					// 04/01/2010 Paul.  The correct Mailbox folder is MsgFolderRoot. 
					FindFoldersResults fResults = service.FindFolders(fldExchangeRoot, filter, new FolderView(1, 0));
					// 03/31/2010 Paul.  If the SplendidRoot folder does not exist, then create it. 
					bool bSplendidRootCreated = false;
					if ( fResults.Folders.Count == 0 )
					{
						fldSplendidRoot = new Folder(service);
						fldSplendidRoot.DisplayName = sCRM_FOLDER_NAME;
						fldSplendidRoot.Save(fldExchangeRoot);
						bSplendidRootCreated = true;
					}
					else
					{
						fldSplendidRoot = fResults.Folders[0];
					}
					if ( bSyncAll || bSplendidRootCreated )
					{
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								SqlProcs.spEXCHANGE_FOLDERS_Update(gUSER_ID, fldSplendidRoot.Id.UniqueId, String.Empty, Guid.Empty, String.Empty, false, trn);
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
				
				if ( fldSplendidRoot != null && !Sql.IsEmptyString(sMODULE_NAME) )
				{
					if ( fldModuleFolder == null )
					{
						string sMODULE_DISPLAY_NAME = String.Empty;
						sMODULE_DISPLAY_NAME = L10N.Term(Application, sCULTURE, ".moduleList." + sMODULE_NAME);
						if ( Sql.IsEmptyString(sMODULE_DISPLAY_NAME) || sMODULE_DISPLAY_NAME.StartsWith(".") )
							sMODULE_DISPLAY_NAME = sMODULE_NAME;
						
						filter = new SearchFilter.IsEqualTo(FolderSchema.DisplayName, sMODULE_DISPLAY_NAME);
						FindFoldersResults fResults = service.FindFolders(fldSplendidRoot.Id, filter, new FolderView(1, 0));
						// 03/31/2010 Paul.  If the Module folder does not exist, then create it. 
						bool bModuleFolderCreated = false;
						if ( fResults.Folders.Count == 0 )
						{
							fldModuleFolder = new Folder(service);
							fldModuleFolder.DisplayName = sMODULE_DISPLAY_NAME;
							// 05/22/2010 Paul.  Also save the folder class, even though it is optional. 
							fldModuleFolder.FolderClass = "IPF.Note";
							fldModuleFolder.Save(fldSplendidRoot.Id);
							bModuleFolderCreated = true;
						}
						else
						{
							fldModuleFolder = fResults.Folders[0];
						}
						if ( bSyncAll || bModuleFolderCreated )
						{
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spEXCHANGE_FOLDERS_Update(gUSER_ID, fldModuleFolder.Id.UniqueId, sMODULE_NAME, Guid.Empty, String.Empty, false, trn);
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
					Folder fldRecordFolder = null;
					// 04/04/2010 Paul  Create the Record Folder, but make sure not do create at the root. 
					if ( fldModuleFolder != null )
					{
						// 07/08/2023 Paul.  We were not importing from module folder due to parent filter. 
						if ( !Sql.IsEmptyGuid(gPARENT_ID) && !Sql.IsEmptyString(sPARENT_NAME) )
						{
							filter = new SearchFilter.IsEqualTo(FolderSchema.DisplayName, sPARENT_NAME);
							FindFoldersResults fResults = service.FindFolders(fldModuleFolder.Id, filter, new FolderView(1, 0));
							// 03/31/2010 Paul.  If the Record folder does not exist, then create it. 
							bool bRecordFolderCreated = false;
							if ( fResults.Folders.Count == 0 )
							{
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncModuleFolders: Create folder " + sPARENT_NAME + " in " + sMODULE_NAME);
								fldRecordFolder = new Folder(service);
								fldRecordFolder.DisplayName = sPARENT_NAME;
								// 05/22/2010 Paul.  Also save the folder class, even though it is optional. 
								fldModuleFolder.FolderClass = "IPF.Note";
								fldRecordFolder.Save(fldModuleFolder.Id);
								bRecordFolderCreated = true;
							}
							else
							{
								fldRecordFolder = fResults.Folders[0];
							}
							if ( bSyncAll || bRecordFolderCreated )
							{
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										SqlProcs.spEXCHANGE_FOLDERS_Update(gUSER_ID, fldRecordFolder.Id.UniqueId, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, false, trn);
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
						// 04/05/2010 Paul.  When the Watermark is empty, no events will be created for existing items.  In that case, poll each folder 
						if ( bSyncAll )
						{
							string sSQL = String.Empty;
							// 04/01/2010 Paul.  Exchange will update the LastModifiedTime message field anytime the messages is moved. 
							// This means that we can rely upon the SYNC_REMOTE_DATE_MODIFIED_UTC, but would have to be folder specific. 
							DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.MinValue;
							// 04/25/2010 Paul.  This code is not used anymore.  When we subscribe, we do not want to also scan all folders. 
							// So, the only time we get to this part of the code is when SyncAll is specified.  
							// However, if we have selected SyncAll, then the modified date should not be included in the filter. 
							/*
							if ( !bSyncAll )
							{
								// 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
								sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
								     + "  from vwEMAIL_CLIENT_SYNC                           " + ControlChars.CrLf
								     + " where SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
									// 04/01/2010 Paul.  The Module Name is optional. 
									if ( !Sql.IsEmptyString(sMODULE_NAME) )
										Sql.AppendParameter(cmd, sMODULE_NAME, "SYNC_MODULE_NAME");
									else
										cmd.CommandText = "   and SYNC_MODULE_NAME is null" + ControlChars.CrLf;
									// 04/04/2010 Paul.  The Parent ID is optional. 
									if ( !Sql.IsEmptyGuid(gPARENT_ID) )
										Sql.AppendParameter(cmd, gPARENT_ID, "SYNC_PARENT_ID");
									else
										cmd.CommandText = "   and SYNC_PARENT_ID is null" + ControlChars.CrLf;
									dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(cmd.ExecuteScalar());
								}
							}
							*/
							
							filter = null;
							if ( dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC > DateTime.MinValue )
							{
								// 03/28/2010 Paul.  The Greater Than filter does not appear to be working. 
								// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
								// 03/28/2010 Paul.  IsGreaterThan is being treated as IsGreaterThanOrEqualTo. 
								filter = new SearchFilter.IsGreaterThan(EmailMessageSchema.LastModifiedTime, dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.AddSeconds(1));
							}
							
							int nImportCount = 0;
							int nPageOffset = 0;
							// 07/07/2015 Paul.  Allow the page size to be customized. 
							int nPageSize = Sql.ToInteger(Application["CONFIG.Exchange.Messages.PageSize"]);
							if ( nPageSize <= 0 )
								nPageSize = 100;
							FindItemsResults<Item> results = null;
							do
							{
								ItemView ivMessages = new ItemView(nPageSize, nPageOffset);
								// 03/31/2010 Paul.  IdOnly is expected to be very fast. 
								ivMessages.PropertySet = PropertySet.IdOnly;
								ivMessages.OrderBy.Add(EmailMessageSchema.LastModifiedTime, SortDirection.Ascending);
								// 07/08/2023 Paul.  We were not importing from module folder due to parent filter. 
								if ( fldRecordFolder != null )
								{
									if ( filter != null )
										results = service.FindItems(fldRecordFolder.Id, filter, ivMessages);
									else
										results = service.FindItems(fldRecordFolder.Id, ivMessages);
								}
								else
								{
									if ( filter != null )
										results = service.FindItems(fldModuleFolder.Id, filter, ivMessages);
									else
										results = service.FindItems(fldModuleFolder.Id, ivMessages);
								}
								// 04/25/2010 Paul.  Include parent name in status message. 
								if ( results.Items.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncModuleFolders: " + results.Items.Count.ToString() + " " + sMODULE_NAME + (Sql.IsEmptyString(sPARENT_NAME) ? String.Empty : " - " + sPARENT_NAME) + " messages to retrieve for " + sEXCHANGE_ALIAS);
								
								foreach (Item itemMessage in results.Items )
								{
									if ( itemMessage is EmailMessage )
									{
										EmailMessage email = itemMessage as EmailMessage;
										// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
										this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
										nImportCount++;
									}
								}
								nPageOffset += nPageSize;
							}
							while ( results.MoreAvailable );
							// 04/25/2010 Paul.  We need some status on the Sync page. 
							if ( nImportCount > 0 && bVERBOSE_STATUS )
							{
								sbErrors.AppendLine(nImportCount.ToString() + " messages received in " + sMODULE_NAME + (Sql.IsEmptyString(sPARENT_NAME) ? String.Empty : " - " + sPARENT_NAME) + " for " + sEXCHANGE_ALIAS + "<br />");
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

		// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
		public void ImportSentItem(ExchangeSession Session, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, EmailMessage email, StringBuilder sbErrors)
		{
			bool bLoadSuccessful = false;
			string sDESCRIPTION = String.Empty;
			try
			{
				email.Load();
				bLoadSuccessful = true;
			}
			catch(Exception ex)
			{
				string sError = "Error loading email for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				sbErrors.AppendLine(sError);
			}
			if ( bLoadSuccessful )
			{
				List<string> arrRecipients = new List<string>();
				if ( email.ToRecipients != null && email.ToRecipients.Count > 0 )
				{
					foreach ( EmailAddress addr in email.ToRecipients )
					{
						arrRecipients.Add(addr.Address);
					}
				}
				if ( email.CcRecipients != null && email.CcRecipients.Count > 0 )
				{
					foreach ( EmailAddress addr in email.CcRecipients )
					{
						arrRecipients.Add(addr.Address);
					}
				}
				// 04/26/2018 Paul.  As a failsafe, exit if no recipients found. 
				if ( arrRecipients.Count == 0 )
					return;
				
				string sSQL = String.Empty;
				//sSQL = "select PARENT_ID              " + ControlChars.CrLf
				//     + "     , MODULE                 " + ControlChars.CrLf
				//     + "     , EMAIL1                 " + ControlChars.CrLf
				//     + "  from vwPARENTS_EMAIL_ADDRESS" + ControlChars.CrLf
				//     + " where 1 = 0                  " + ControlChars.CrLf;
				
				// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
				// 04/26/2018 Paul.  We need to apply each module security rule separately. 
				string sMODULE_NAME = "Accounts";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, arrRecipients.ToArray(), "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 03/11/2012 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Contacts";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, arrRecipients.ToArray(), "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 03/11/2012 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Leads";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, arrRecipients.ToArray(), "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 03/11/2012 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Prospects";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, arrRecipients.ToArray(), "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 03/11/2012 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
			}
		}

		// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
		public void ImportInbox(ExchangeSession Session, IDbConnection con, string sEXCHANGE_ALIAS, Guid gUSER_ID, EmailMessage email, StringBuilder sbErrors)
		{
			bool bLoadSuccessful = false;
			string sDESCRIPTION = String.Empty;
			try
			{
				email.Load();
				bLoadSuccessful = true;
			}
			catch(Exception ex)
			{
				string sError = "Error loading email for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
				sError += Utils.ExpandException(ex) + ControlChars.CrLf;
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
				sbErrors.AppendLine(sError);
			}
			if ( bLoadSuccessful )
			{
				string sSQL = String.Empty;
				// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
				// 04/26/2018 Paul.  We need to apply each module security rule separately. 
				string sMODULE_NAME = "Accounts";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 07/05/2017 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Contacts";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 07/05/2017 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Leads";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 07/05/2017 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
				sMODULE_NAME = "Prospects";
				if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
				{
					string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
					sSQL = "select ID        " + ControlChars.CrLf
					     + "     , EMAIL1    " + ControlChars.CrLf
					     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
						Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
						using ( DataTable dt = new DataTable() )
						{
							DbProviderFactory dbf = DbProviderFactories.GetFactory();
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gPARENT_ID   = Sql.ToGuid  (row["ID"    ]);
									string sEMAIL1      = Sql.ToString(row["EMAIL1"]);
									// 07/05/2017 Paul.  Only import the message if the recipient is a Account, Contact, Lead, or Prospect. 
									this.ImportMessage(Session, con, sMODULE_NAME, gPARENT_ID, sEXCHANGE_ALIAS, gUSER_ID, email, sbErrors);
								}
							}
						}
					}
				}
			}
		}

		// 04/26/2018 Paul.  We need to apply each module security rule separately. 
		public Guid RecipientByEmail(ExchangeSession Session, IDbConnection con, Guid gUSER_ID, string sEMAIL)
		{
			Guid gRECIPIENT_ID = Guid.Empty;
			string sSQL = String.Empty;
			string sMODULE_NAME = "Contacts";
			if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) && Sql.IsEmptyGuid(gRECIPIENT_ID) )
			{
				string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
				sSQL = "select ID              " + ControlChars.CrLf
				     + "     , EMAIL1          " + ControlChars.CrLf
				     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
					ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
					Sql.AppendParameter(cmd, sEMAIL, "EMAIL1");
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							// 06/22/2018 Paul.  Correct field name. PARENT_ID was wrong. 
							gRECIPIENT_ID = Sql.ToGuid(rdr["ID"]);
						}
					}
				}
			}
			sMODULE_NAME = "Leads";
			if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) && Sql.IsEmptyGuid(gRECIPIENT_ID) )
			{
				string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
				sSQL = "select ID              " + ControlChars.CrLf
				     + "     , EMAIL1          " + ControlChars.CrLf
				     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
					ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
					Sql.AppendParameter(cmd, sEMAIL, "EMAIL1");
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							// 06/22/2018 Paul.  Correct field name. PARENT_ID was wrong. 
							gRECIPIENT_ID = Sql.ToGuid(rdr["ID"]);
						}
					}
				}
			}
			sMODULE_NAME = "Prospects";
			if ( Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) && Sql.IsEmptyGuid(gRECIPIENT_ID) )
			{
				string sTABLE_NAME = Sql.ToString(Application["Modules." + sMODULE_NAME + ".TableName"]);
				sSQL = "select ID              " + ControlChars.CrLf
				     + "     , EMAIL1          " + ControlChars.CrLf
				     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
					ExchangeSecurity.Filter(Session, cmd, gUSER_ID, sMODULE_NAME, "view");
					Sql.AppendParameter(cmd, sEMAIL, "EMAIL1");
					using ( IDataReader rdr = cmd.ExecuteReader() )
					{
						if ( rdr.Read() )
						{
							// 06/22/2018 Paul.  Correct field name. PARENT_ID was wrong. 
							gRECIPIENT_ID = Sql.ToGuid(rdr["ID"]);
						}
					}
				}
			}
			return gRECIPIENT_ID;
		}

		public void ImportMessage(ExchangeSession Session, IDbConnection con, string sMODULE_NAME, Guid gPARENT_ID, string sEXCHANGE_ALIAS, Guid gUSER_ID, EmailMessage email, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.Exchange.VerboseStatus"]);
			Guid   gTEAM_ID        = Sql.ToGuid(Session["TEAM_ID"]);
			long   lUploadMaxSize  = Sql.ToLong(Application["CONFIG.upload_maxsize"]);
			string sCULTURE        = L10N.NormalizeCulture(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			
			IDbCommand spEMAILS_Update = SqlProcs.Factory(con, "spEMAILS_Update");
			// 04/05/2010 Paul.  Need to be able to disable Account creation. This is because the email may come from a personal email address.
			IDbCommand spModule_Update = null;
			if ( !Sql.IsEmptyString(sMODULE_NAME) && Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".ExchangeCreateParent"]) )
			{
				string sMODULE_TABLE = Modules.TableName(sMODULE_NAME);
				if ( !Sql.IsEmptyString(sMODULE_TABLE) )
				{
					try
					{
						spModule_Update = SqlProcs.Factory(con, "sp" + sMODULE_TABLE + "_Update");
					}
					catch(Exception ex)
					{
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					}
				}
			}
			
			// 11/14/2017 Paul.  We started using InternetMessageId on 03/23/2016, but the property is not always available. 
			// You must load or assign this property before you can read its value at Microsoft.Exchange.WebServices.Data.EmailMessage.get_InternetMessageId()
			// 07/19/2018 Paul.  Send does not return an message ID, so we need to set an extended property, then retrieve it later. 
			Guid gX_SplendidCRM_ID = Guid.Empty;
			string sInternetMessageId = String.Empty;
			try
			{
				ExtendedPropertyDefinition splendidProperty = new ExtendedPropertyDefinition(ExchangeUtils.SPLENDIDCRM_PROPERTY_SET_ID, ExchangeUtils.SPLENDIDCRM_PROPERTY_NAME, MapiPropertyType.String);
				EmailMessage email1 = EmailMessage.Bind(email.Service, email.Id, new PropertySet(EmailMessageSchema.InternetMessageId, splendidProperty));
				sInternetMessageId = email1.InternetMessageId;
				foreach ( ExtendedProperty prop in email1.ExtendedProperties )
				{
					if ( prop.PropertyDefinition.Name == ExchangeUtils.SPLENDIDCRM_PROPERTY_NAME )
					{
						gX_SplendidCRM_ID = Sql.ToGuid(prop.Value);
						break;
					}
				}
			}
			catch
			{
			}

			string sREMOTE_KEY = email.Id.UniqueId;
			string sSQL = String.Empty;
			// 07/24/2010 Paul.  We have a problem in the the REMOTE_KEY is case-significant, but the query is not. 
			// This is the reason why some messages are not getting imported into the CRM. 
			// 07/24/2010 Paul.  Instead of managing collation in code, it is better to change the collation on the field in the database. 
			// 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
			sSQL = "select SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "  from vwEMAIL_CLIENT_SYNC                           " + ControlChars.CrLf
			     + " where SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
			     + "   and SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + /* Sql.CaseSensitiveCollation(con) + */ ControlChars.CrLf;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.CommandText = sSQL;
				Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
				Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
				Guid gEMAIL_ID = Sql.ToGuid(cmd.ExecuteScalar());
				// 03/23/2016 Paul.  Email may have already been imported using the OfficeAddin. 
				if ( Sql.IsEmptyGuid(gEMAIL_ID) )
				{
					cmd.Parameters.Clear();
					if ( !Sql.IsEmptyString(sInternetMessageId) )
					{
						// 07/19/2018 Paul.  Send does not return an message ID, so we need to set an extended property, then retrieve it later. 
						// 07/19/2018 Paul.  We will need to change vwEMAILS_Inbound to allow MESSAGE_ID to be null so we can find Sent Items. 
						sSQL = "select ID                      " + ControlChars.CrLf
						     + "  from vwEMAILS_Inbound        " + ControlChars.CrLf
						     + " where MESSAGE_ID = @MESSAGE_ID" + ControlChars.CrLf
						     + "    or ID         = @ID        " + ControlChars.CrLf;
						cmd.CommandText = sSQL;
						cmd.CommandTimeout = 0;
						// 11/14/2017 Paul.  email.InternetMessageId needs to be loaded in advance as it is not part of the FirstClassProperties. 
						Sql.AddParameter(cmd, "@MESSAGE_ID", sInternetMessageId);
						Sql.AddParameter(cmd, "@ID"        , gX_SplendidCRM_ID );
						gEMAIL_ID = Sql.ToGuid(cmd.ExecuteScalar());
						// 03/23/2016 Paul.  If email found in the system, then just add to the sync table. 
						if ( !Sql.IsEmptyGuid(gEMAIL_ID) )
						{
							DateTime dtREMOTE_DATE_MODIFIED_UTC = email.LastModifiedTime;
							DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spEMAIL_CLIENT_SYNC_Update(gUSER_ID, gEMAIL_ID, sREMOTE_KEY, sMODULE_NAME, gPARENT_ID, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, trn);
									SqlProcs.spEMAILS_InsertRelated(gEMAIL_ID, sMODULE_NAME, gPARENT_ID, trn);
									trn.Commit();
								}
								catch(Exception ex)
								{
									trn.Rollback();
									SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
									throw;
								}
							}
						}
					}
				}
				if ( Sql.IsEmptyGuid(gEMAIL_ID) )
				{
					bool bLoadSuccessful = false;
					string sDESCRIPTION = String.Empty;
					try
					{
						email.Load();
						// 06/04/2010 Paul.  First load the plain-text body, then load the reset of the properties. 
						PropertySet psBodyText = new PropertySet(BasePropertySet.IdOnly, EmailMessageSchema.Body);
						psBodyText.RequestedBodyType = BodyType.Text;
						// 06/04/2010 Paul.  Can't use the same object to load the text body. 
						EmailMessage email1 = EmailMessage.Bind(email.Service, email.Id, psBodyText);
						sDESCRIPTION = email1.Body.Text;
						bLoadSuccessful = true;
					}
					catch(Exception ex)
					{
						string sError = "Error loading email for " + sEXCHANGE_ALIAS + "." + ControlChars.CrLf;
						sError += Utils.ExpandException(ex) + ControlChars.CrLf;
						SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
						sbErrors.AppendLine(sError);
					}
					if ( bLoadSuccessful )
					{
						DateTime dtREMOTE_DATE_MODIFIED_UTC = email.LastModifiedTime;
						DateTime dtREMOTE_DATE_MODIFIED     = TimeZoneInfo.ConvertTimeFromUtc(dtREMOTE_DATE_MODIFIED_UTC, TimeZoneInfo.Local);
						
						Guid   gCONTACT_ID     = Guid.Empty;
						Guid   gSENDER_USER_ID = Guid.Empty;
						string sPARENT_TYPE    = String.Empty;
						string sACCOUNT_NAME   = email.From.Address;
						string sACCOUNT_DOMAIN = email.From.Address;
						if ( sACCOUNT_NAME.Contains("@") )
						{
							sACCOUNT_NAME   = sACCOUNT_NAME.Split('@')[1];
							sACCOUNT_DOMAIN = "%@" + sACCOUNT_NAME.ToLower();
							// 04/22/2010 Paul.  Don't match the company for popular free email systems. 
							// 04/25/2010 Paul.  Provide a way to add excluded domains. 
							string sEXCLUDED_ACCOUNT_DOMAINS = Sql.ToString(Application["CONFIG.Exchange.ExcludedAccountDomains"]);
							if ( Sql.IsEmptyString(sEXCLUDED_ACCOUNT_DOMAINS) )
								sEXCLUDED_ACCOUNT_DOMAINS = "@yahoo.com;@hotmail.com;@gmail.com";
							string[] arrEXCLUDED_ACCOUNT_DOMAINS = sEXCLUDED_ACCOUNT_DOMAINS.Split(';');
							foreach ( string sEXCLUDED_DOMAIN in arrEXCLUDED_ACCOUNT_DOMAINS )
							{
								if ( !Sql.IsEmptyString(sEXCLUDED_DOMAIN) && sACCOUNT_DOMAIN.EndsWith(sEXCLUDED_DOMAIN) )
								{
									sACCOUNT_DOMAIN = String.Empty;
									break;
								}
							}
						}
						// 04/07/2010 Paul.  A domain name may have multiple parts.  Use the second-to-last as the account name. 
						string[] arrACCOUNT_NAME = sACCOUNT_NAME.Split('.');
						if ( arrACCOUNT_NAME.Length >= 2 )
							sACCOUNT_NAME = sACCOUNT_NAME.Split('.')[arrACCOUNT_NAME.Length - 2];
						else
							sACCOUNT_NAME = sACCOUNT_NAME.Split('.')[0];
						if ( Sql.IsEmptyGuid(gPARENT_ID) )
						{
							// 03/31/2010 Paul.  Lookup the Account outside the transaction. 
							if ( sMODULE_NAME == "Accounts" && Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
							{
								// 03/31/2010 Paul.  First lookup the Contact for the Account, then the Account by email, then the Account by name. 
								// 04/22/2010 Paul.  Make sure not to get a hit on null fields. 
								// 04/26/2018 Paul.  We need to apply each module security rule separately. 
								if ( Sql.IsEmptyGuid(gPARENT_ID) )
								{
									// 01/10/2021 Paul.  If we are going to reuse cmd, then we need to clear parameters before each new query. 
									cmd.Parameters.Clear();
									sSQL = "select ACCOUNT_ID as ID           " + ControlChars.CrLf
									     + "  from vwCONTACTS                 " + ControlChars.CrLf;
									cmd.CommandText = sSQL;
									// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
									ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
									Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
									cmd.CommandText += "   and ACCOUNT_ID is not null" + ControlChars.CrLf;
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
								}
								if ( Sql.IsEmptyGuid(gPARENT_ID) )
								{
									// 01/10/2021 Paul.  If we are going to reuse cmd, then we need to clear parameters before each new query. 
									cmd.Parameters.Clear();
									sSQL = "select ID                         " + ControlChars.CrLf
									     + "  from vwACCOUNTS                 " + ControlChars.CrLf;
									cmd.CommandText = sSQL;
									// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
									ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Accounts", "view");
									Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
								}
								if ( Sql.IsEmptyGuid(gPARENT_ID) && !Sql.IsEmptyString(sACCOUNT_DOMAIN) )
								{
									// 01/10/2021 Paul.  If we are going to reuse cmd, then we need to clear parameters before each new query. 
									cmd.Parameters.Clear();
									sSQL = "select ID                         " + ControlChars.CrLf
									     + "  from vwACCOUNTS                 " + ControlChars.CrLf;
									cmd.CommandText = sSQL;
									// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
									ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Accounts", "view");
									cmd.CommandText += "   and EMAIL1 like @ACCOUNT_DOMAIN" + ControlChars.CrLf;
									cmd.CommandText += "   and EMAIL1 is not null         " + ControlChars.CrLf;
									Sql.AddParameter(cmd, "@ACCOUNT_DOMAIN", sACCOUNT_DOMAIN   );
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
								}
								if ( Sql.IsEmptyGuid(gPARENT_ID) )
								{
									// 01/10/2021 Paul.  If we are going to reuse cmd, then we need to clear parameters before each new query. 
									cmd.Parameters.Clear();
									sSQL = "select ID                         " + ControlChars.CrLf
									     + "  from vwACCOUNTS                 " + ControlChars.CrLf;
									cmd.CommandText = sSQL;
									// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
									ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Accounts", "view");
									Sql.AppendParameter(cmd, sACCOUNT_NAME, "NAME");
									cmd.CommandText += "   and NAME is not null" + ControlChars.CrLf;
									using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
									{
										if ( rdr.Read() )
										{
											sPARENT_TYPE = sMODULE_NAME;
											gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
										}
									}
								}
							}
							else if ( sMODULE_NAME == "Leads" && Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Valid"]) )
							{
								cmd.Parameters.Clear();
								sSQL = "select ID                      " + ControlChars.CrLf
								     + "  from vwLEADS                 " + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
								ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Leads", "view");
								Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									if ( rdr.Read() )
									{
										sPARENT_TYPE = sMODULE_NAME;
										gPARENT_ID   = Sql.ToGuid(rdr["ID"]);
									}
								}
							}
						}
						else
						{
							// 04/06/2010 Paul.  Make sure to set the parent type to the Module Name. 
							sPARENT_TYPE = sMODULE_NAME;
						}
						// 04/01/2010 Paul.  Always lookup and assign the contact. 
						// 04/06/2010 Paul.  The PARENT_ID is only set if the Module is Contacts. 
						// 04/22/2010 Paul.  Always lookup the Contact, even when dropping onto a specific parent folder. 
						cmd.Parameters.Clear();
						if ( Sql.ToBoolean(Application["Modules.Contacts.Valid"]) )
						{
							sSQL = "select ID                      " + ControlChars.CrLf
							     + "  from vwCONTACTS              " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
							Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
							using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
							{
								if ( rdr.Read() )
								{
									gCONTACT_ID = Sql.ToGuid(rdr["ID"]);
									if ( sMODULE_NAME == "Contacts" && Sql.IsEmptyGuid(gPARENT_ID) )
									{
										sPARENT_TYPE = sMODULE_NAME;
										gPARENT_ID   = gCONTACT_ID;
									}
								}
							}
						}
						
						// 04/01/2012 Paul.  Add Calls/Leads relationship, but only if the contact does not exist. 
						if ( Sql.IsEmptyGuid(gCONTACT_ID) && Sql.ToBoolean(Application["Modules.Leads.Valid"]) )
						{
							cmd.Parameters.Clear();
							sSQL = "select ID                      " + ControlChars.CrLf
							     + "  from vwLEADS                 " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Leads", "view");
							Sql.AppendParameter(cmd, email.From.Address, "EMAIL1");
							using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
							{
								if ( rdr.Read() )
								{
									Guid gLEAD_ID = Sql.ToGuid(rdr["ID"]);
									if ( sMODULE_NAME == "Leads" && Sql.IsEmptyGuid(gPARENT_ID) )
									{
										sPARENT_TYPE = sMODULE_NAME;
										gPARENT_ID   = gLEAD_ID;
									}
								}
							}
						}
						
						// 04/22/2010 Paul.  Make sure not to create a Contact if the Sender is a CRM User. 
						cmd.Parameters.Clear();
						sSQL = "select ID              " + ControlChars.CrLf
						     + "  from vwUSERS         " + ControlChars.CrLf
						     + " where EMAIL1 = @EMAIL1" + ControlChars.CrLf
						     + "    or EMAIL2 = @EMAIL2" + ControlChars.CrLf;
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@EMAIL1", email.From.Address);
						Sql.AddParameter(cmd, "@EMAIL2", email.From.Address);
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								gSENDER_USER_ID = Sql.ToGuid(rdr["ID"]);
							}
						}
						
						string sREPLY_TO_NAME = String.Empty;
						string sREPLY_TO_ADDR = String.Empty;
						if ( email.ReplyTo != null && email.ReplyTo.Count > 0 )
						{
							sREPLY_TO_NAME = email.ReplyTo[0].Name   ;
							sREPLY_TO_ADDR = email.ReplyTo[0].Address;
						}
						
						StringBuilder sbTO_ADDRS_IDS    = new StringBuilder();
						StringBuilder sbTO_ADDRS_NAMES  = new StringBuilder();
						StringBuilder sbTO_ADDRS_EMAILS = new StringBuilder();
						if ( email.ToRecipients != null && email.ToRecipients.Count > 0 )
						{
							foreach ( EmailAddress addr in email.ToRecipients )
							{
								if ( sbTO_ADDRS_NAMES .Length > 0 ) sbTO_ADDRS_NAMES .Append(';');
								if ( sbTO_ADDRS_EMAILS.Length > 0 ) sbTO_ADDRS_EMAILS.Append(';');
								sbTO_ADDRS_NAMES .Append(addr.Name   );
								sbTO_ADDRS_EMAILS.Append(addr.Address);
								// 07/18/2010 Paul.  Exchange, Imap and Pop3 utils will all use this method to lookup a contact by email. 
								// 08/30/2010 Paul.  The previous method only returned Contacts, where as this new method returns Contacts, Leads and Prospects. 
								// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
								Guid gRECIPIENT_ID = this.RecipientByEmail(Session, con, gUSER_ID, addr.Address);
								if ( !Sql.IsEmptyGuid(gRECIPIENT_ID) )
								{
									if ( sbTO_ADDRS_IDS.Length > 0 )
										sbTO_ADDRS_IDS.Append(';');
									sbTO_ADDRS_IDS.Append(gRECIPIENT_ID.ToString());
								}
							}
						}
						StringBuilder sbCC_ADDRS_IDS    = new StringBuilder();
						StringBuilder sbCC_ADDRS_NAMES  = new StringBuilder();
						StringBuilder sbCC_ADDRS_EMAILS = new StringBuilder();
						if ( email.CcRecipients != null && email.CcRecipients.Count > 0 )
						{
							foreach ( EmailAddress addr in email.CcRecipients )
							{
								if ( sbCC_ADDRS_NAMES .Length > 0 ) sbCC_ADDRS_NAMES .Append(';');
								if ( sbCC_ADDRS_EMAILS.Length > 0 ) sbCC_ADDRS_EMAILS.Append(';');
								sbCC_ADDRS_NAMES .Append(addr.Name   );
								sbCC_ADDRS_EMAILS.Append(addr.Address);
								// 07/18/2010 Paul.  Exchange, Imap and Pop3 utils will all use this method to lookup a contact by email. 
								// 08/30/2010 Paul.  The previous method only returned Contacts, where as this new method returns Contacts, Leads and Prospects. 
								// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
								Guid gRECIPIENT_ID = this.RecipientByEmail(Session, con, gUSER_ID, addr.Address);
								if ( !Sql.IsEmptyGuid(gRECIPIENT_ID) )
								{
									if ( sbCC_ADDRS_IDS.Length > 0 )
										sbCC_ADDRS_IDS.Append(';');
									sbCC_ADDRS_IDS.Append(gRECIPIENT_ID.ToString());
								}
							}
						}
						StringBuilder sbBCC_ADDRS_IDS    = new StringBuilder();
						StringBuilder sbBCC_ADDRS_NAMES  = new StringBuilder();
						StringBuilder sbBCC_ADDRS_EMAILS = new StringBuilder();
						if ( email.BccRecipients != null && email.BccRecipients.Count > 0 )
						{
							foreach ( EmailAddress addr in email.BccRecipients )
							{
								if ( sbBCC_ADDRS_NAMES .Length > 0 ) sbBCC_ADDRS_NAMES .Append(';');
								if ( sbBCC_ADDRS_EMAILS.Length > 0 ) sbBCC_ADDRS_EMAILS.Append(';');
								sbBCC_ADDRS_NAMES .Append(addr.Name   );
								sbBCC_ADDRS_EMAILS.Append(addr.Address);
								// 07/18/2010 Paul.  Exchange, Imap and Pop3 utils will all use this method to lookup a contact by email. 
								// 08/30/2010 Paul.  The previous method only returned Contacts, where as this new method returns Contacts, Leads and Prospects. 
								// 04/26/2018 Paul.  Exchange Sync needs to follow team hierarchy rules. 
								Guid gRECIPIENT_ID = this.RecipientByEmail(Session, con, gUSER_ID, addr.Address);
								if ( !Sql.IsEmptyGuid(gRECIPIENT_ID) )
								{
									if ( sbBCC_ADDRS_IDS.Length > 0 )
										sbBCC_ADDRS_IDS.Append(';');
									sbBCC_ADDRS_IDS.Append(gRECIPIENT_ID.ToString());
								}
							}
						}
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportMessage: Retrieving email " + Sql.ToString(email.Subject) + " " + Sql.ToString(email.DateTimeReceived.ToLocalTime().ToString()) + " from " + sEXCHANGE_ALIAS);
								
								if ( Sql.IsEmptyGuid(gPARENT_ID) && !Sql.IsEmptyString(sMODULE_NAME) && spModule_Update != null )
								{
									string sNAME       = email.From.Name;
									string sFIRST_NAME = String.Empty;
									string sLAST_NAME  = String.Empty;
									if ( sNAME.Contains("@") )
										sNAME = sNAME.Split('@')[0];
									sNAME = sNAME.Replace('.', ' ');
									sNAME = sNAME.Replace('_', ' ');
									string[] arrNAME = sNAME.Split(' ');
									if ( arrNAME.Length > 1 )
									{
										sFIRST_NAME = arrNAME[0];
										sLAST_NAME  = arrNAME[arrNAME.Length - 1];
									}
									else
									{
										sLAST_NAME = sNAME;
									}
									
									spModule_Update.Transaction = trn;
									foreach(IDbDataParameter par in spModule_Update.Parameters)
									{
										// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
										string sParameterName = Sql.ExtractDbName(spModule_Update, par.ParameterName).ToUpper();
										if ( sParameterName == "TEAM_ID" )
											par.Value = gTEAM_ID;
										else if ( sParameterName == "ASSIGNED_USER_ID" )
											par.Value = gUSER_ID;
										// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
										else if ( sParameterName == "MODIFIED_USER_ID" )
											par.Value = gUSER_ID;
										else
											par.Value = DBNull.Value;
										switch ( sParameterName )
										{
											case "NAME"      :  par.Value = (sMODULE_NAME == "Accounts") ? sACCOUNT_NAME : Sql.ToDBString(email.Subject);  break;
											case "FIRST_NAME":  par.Value = Sql.ToDBString(sFIRST_NAME       );  break;
											case "LAST_NAME" :  par.Value = Sql.ToDBString(sLAST_NAME        );  break;
											case "EMAIL1"    :  par.Value = Sql.ToDBString(email.From.Address);  break;
											// 03/06/2012 Paul.  The default Lead Source should be set to Email. 
											case "LEAD_SOURCE":
												if ( sMODULE_NAME == "Leads" )
													par.Value = "Email";
												break;
											// 03/06/2012 Paul.  The default Status should be set to In Process. 
											case "STATUS":
												if ( sMODULE_NAME == "Leads" )
													par.Value = "In Process";
												break;
										}
									}
									Sql.Trace(spModule_Update);
									spModule_Update.ExecuteNonQuery();
									IDbDataParameter parPARENT_ID = Sql.FindParameter(spModule_Update, "@ID");
									sPARENT_TYPE = sMODULE_NAME;
									gPARENT_ID   = Sql.ToGuid(parPARENT_ID.Value);
									// 04/01/2010 Paul.  When creating an account, also create a contact. 
									// 04/22/2010 Paul.  Make sure not to create a Contact if the Sender is a CRM User. 
									if ( sMODULE_NAME == "Accounts" && Sql.IsEmptyGuid(gCONTACT_ID) && Sql.IsEmptyGuid(gSENDER_USER_ID) )
									{
										// 01/16/2012 Paul.  Assigned User ID and Team ID are now parameters. 
										// 02/20/2013 Paul.  The context is not available, so use local variables. 
										SqlProcs.spCONTACTS_New
											( ref gCONTACT_ID
											, sFIRST_NAME
											, sLAST_NAME
											, String.Empty
											, email.From.Address
											, gUSER_ID
											, gTEAM_ID
											, String.Empty
											// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
											, String.Empty   // ASSIGNED_SET_LIST
											, trn
											);
									}
								}
								spEMAILS_Update.Transaction = trn;
								foreach(IDbDataParameter par in spEMAILS_Update.Parameters)
								{
									// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
									string sParameterName = Sql.ExtractDbName(spEMAILS_Update, par.ParameterName).ToUpper();
									if ( sParameterName == "TEAM_ID" )
										par.Value = gTEAM_ID;
									else if ( sParameterName == "ASSIGNED_USER_ID" )
										par.Value = gUSER_ID;
									// 02/20/2013 Paul.  We need to set the MODIFIED_USER_ID. 
									else if ( sParameterName == "MODIFIED_USER_ID" )
										par.Value = gUSER_ID;
									else
										par.Value = DBNull.Value;
								}
								
								foreach(IDbDataParameter par in spEMAILS_Update.Parameters)
								{
									Security.ACL_FIELD_ACCESS acl = new Security.ACL_FIELD_ACCESS(Security, Security.ACL_FIELD_ACCESS.FULL_ACCESS, Guid.Empty);
									// 03/27/2010 Paul.  The ParameterName will start with @, so we need to remove it. 
									string sColumnName = Sql.ExtractDbName(spEMAILS_Update, par.ParameterName).ToUpper();
									if ( SplendidInit.bEnableACLFieldSecurity )
									{
										acl = ExchangeSecurity.GetUserFieldSecurity(Session, "Emails", sColumnName, gUSER_ID);
									}
									if ( acl.IsWriteable() )
									{
										try
										{
											switch ( sColumnName )
											{
												case "MODIFIED_USER_ID"  :  par.Value = gUSER_ID;  break;
												case "DATE_TIME"         :  par.Value = email.IsFromMe ? Sql.ToDBDateTime(email.DateTimeSent.ToLocalTime()) : Sql.ToDBDateTime(email.DateTimeReceived.ToLocalTime());  break;
												case "TYPE"              :  par.Value = "archived"                                   ;  break;
												case "NAME"              :  par.Value = Sql.ToDBString(email.Subject                );  break;
												case "DESCRIPTION"       :  par.Value = Sql.ToDBString(sDESCRIPTION                 );  break;
												case "DESCRIPTION_HTML"  :  par.Value = Sql.ToDBString(email.Body.Text              );  break;
												case "PARENT_TYPE"       :  par.Value = Sql.ToDBString(sPARENT_TYPE                 );  break;
												case "PARENT_ID"         :  par.Value = Sql.ToDBGuid  (gPARENT_ID                   );  break;
												// 11/14/2017 Paul.  email.InternetMessageId needs to be loaded in advance as it is not part of the FirstClassProperties. 
												case "MESSAGE_ID"        :  par.Value = Sql.ToDBString(sInternetMessageId           );  break;
												case "FROM_NAME"         :  par.Value = Sql.ToDBString(email.From.Name              );  break;
												case "FROM_ADDR"         :  par.Value = Sql.ToDBString(email.From.Address           );  break;
												case "REPLY_TO_NAME"     :  par.Value = Sql.ToDBString(sREPLY_TO_NAME               );  break;
												case "REPLY_TO_ADDR"     :  par.Value = Sql.ToDBString(sREPLY_TO_ADDR               );  break;
												case "TO_ADDRS"          :  par.Value = Sql.ToDBString(email.DisplayTo              );  break;
												case "CC_ADDRS"          :  par.Value = Sql.ToDBString(email.DisplayCc              );  break;
												case "BCC_ADDRS"         :  par.Value = Sql.ToDBString(String.Empty                 );  break;
												case "TO_ADDRS_IDS"      :  par.Value = Sql.ToDBString(sbTO_ADDRS_IDS    .ToString());  break;
												case "TO_ADDRS_NAMES"    :  par.Value = Sql.ToDBString(sbTO_ADDRS_NAMES  .ToString());  break;
												case "TO_ADDRS_EMAILS"   :  par.Value = Sql.ToDBString(sbTO_ADDRS_EMAILS .ToString());  break;
												case "CC_ADDRS_IDS"      :  par.Value = Sql.ToDBString(sbCC_ADDRS_IDS    .ToString());  break;
												case "CC_ADDRS_NAMES"    :  par.Value = Sql.ToDBString(sbCC_ADDRS_NAMES  .ToString());  break;
												case "CC_ADDRS_EMAILS"   :  par.Value = Sql.ToDBString(sbCC_ADDRS_EMAILS .ToString());  break;
												case "BCC_ADDRS_IDS"     :  par.Value = Sql.ToDBString(sbBCC_ADDRS_IDS   .ToString());  break;
												case "BCC_ADDRS_NAMES"   :  par.Value = Sql.ToDBString(sbBCC_ADDRS_NAMES .ToString());  break;
												case "BCC_ADDRS_EMAILS"  :  par.Value = Sql.ToDBString(sbBCC_ADDRS_EMAILS.ToString());  break;
												//case "INTERNET_HEADERS"  :  par.Value = Sql.ToDBString(email.InternetMessageHeaders.ToString() );  break;
											}
										}
										catch
										{
											// 03/27/2010 Paul.  Some fields are not available.  Lets just ignore them. 
										}
									}
								}
								Sql.Trace(spEMAILS_Update);
								spEMAILS_Update.ExecuteNonQuery();
								IDbDataParameter parEMAIL_ID = Sql.FindParameter(spEMAILS_Update, "@ID");
								gEMAIL_ID = Sql.ToGuid(parEMAIL_ID.Value);
								// 04/01/2010 Paul.  Always add the current user to the email. 
								SqlProcs.spEMAILS_USERS_Update(gEMAIL_ID, gUSER_ID, trn);
								// 04/01/2010 Paul.  Always lookup and assign the contact. 
								if ( !Sql.IsEmptyGuid(gCONTACT_ID) )
								{
									SqlProcs.spEMAILS_CONTACTS_Update(gEMAIL_ID, gCONTACT_ID, trn);
								}
								if ( email.HasAttachments )
								{
									// 03/31/2010 Paul.  Web do not need to load the attachments separately. 
									// email.Load(new PropertySet(ItemSchema.Attachments));
									foreach ( Attachment attach in email.Attachments )
									{
										if ( attach is FileAttachment )
										{
											FileAttachment file = attach as FileAttachment;
											file.Load();
											if ( file.Content != null )
											{
												// 04/01/2010 Paul.  file.Size is only available on Exchange 2010. 
												long lFileSize = file.Content.Length;  // file.Size;
												if ( (lUploadMaxSize == 0) || (lFileSize <= lUploadMaxSize) )
												{
													string sFILENAME       = Path.GetFileName (file.FileName);
													if ( Sql.IsEmptyString(sFILENAME) )
														sFILENAME = file.Name;
													string sFILE_EXT       = Path.GetExtension(sFILENAME);
													string sFILE_MIME_TYPE = file.ContentType;
													
													Guid gNOTE_ID = Guid.Empty;
													// 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
													SqlProcs.spNOTES_Update
														( ref gNOTE_ID
														, L10N.Term(Application, sCULTURE, "Emails.LBL_EMAIL_ATTACHMENT") + ": " + sFILENAME
														, "Emails"   // Parent Type
														, gEMAIL_ID  // Parent ID
														, Guid.Empty
														, String.Empty
														, gTEAM_ID
														, String.Empty
														, gUSER_ID
														// 05/17/2017 Paul.  Add Tags module. 
														, String.Empty  // TAG_SET_NAME
														// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
														, false         // IS_PRIVATE
														// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
														, String.Empty  // ASSIGNED_SET_LIST
														, trn
														);
													
													Guid gNOTE_ATTACHMENT_ID = Guid.Empty;
													SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, file.FileName, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
													//SqlProcs.spNOTES_ATTACHMENT_Update(gNOTE_ATTACHMENT_ID, file.Content, trn);
													// 11/22/2014 Paul.  Use our method to chunk for Oracle. 
													NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, file.Content, trn);
												}
											}
										}
									}
								}
								// 08/31/2010 Paul.  The EMAILS_SYNC table was renamed to EMAIL_CLIENT_SYNC to prevent conflict with Offline Client sync tables. 
								SqlProcs.spEMAIL_CLIENT_SYNC_Update(gUSER_ID, gEMAIL_ID, sREMOTE_KEY, sMODULE_NAME, gPARENT_ID, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, trn);
								trn.Commit();
							}
							catch(Exception ex)
							{
								trn.Rollback();
								// 02/20/2013 Paul.  Log inner error. 
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
								throw;
							}
						}
					}
				}
			}
		}
		#endregion
	}
}
