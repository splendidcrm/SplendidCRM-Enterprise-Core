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
using System.Web;
using System.Globalization;
using System.Diagnostics;

using Google.Apis.Calendar.v3;
using Google.Apis.Calendar.v3.Data;
using Google.Apis.Contacts.v3;
using Google.Apis.Contacts.v3.Data;

namespace SplendidCRM
{
	public class GoogleSync
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
		private SplendidCRM.Crm.Modules          Modules          ;
		private GoogleApps           GoogleApps         ;

		public GoogleSync(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, SplendidCRM.Crm.Modules Modules, GoogleApps GoogleApps)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.SyncError           = SyncError          ;
			this.Modules             = Modules            ;
			this.GoogleApps          = GoogleApps         ;
		}

		// 04/23/2010 Paul.  Make the inside flag public so that we can access from the SystemCheck. 
		public  static bool bInsideSyncAll       = false;
		public  static bool bUnauthorizedWebHook = false;
		private static List<Guid>                 arrProcessing = new List<Guid>();
		// 01/22/2012 Paul.  Keep track of the last time we synced to prevent it from being too frequent. 
		private static Dictionary<Guid, DateTime> dictLastSync  = new Dictionary<Guid,DateTime>();
		private static Queue<GoogleWebhook>       queueWebhooks = new Queue<GoogleWebhook>();

		#region GoogleWebhook
		public class GoogleWebhook
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
			private GoogleApps           GoogleApps         ;
			private GoogleSync           GoogleSync         ;

			public string ChannelID         { get; set; }
			public string ChannelExpiration { get; set; }
			public string ResourceState     { get; set; }
			public string MessageNumber     { get; set; }
			public string ResourceID        { get; set; }
			public string ResourceURI       { get; set; }
			public string ChannelToken      { get; set; }

			public GoogleWebhook(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, GoogleApps GoogleApps, GoogleSync GoogleSync)
			{
				this.Session             = Session            ;
				this.Security            = Security           ;
				this.Sql                 = Sql                ;
				this.SqlProcs            = SqlProcs           ;
				this.SplendidError       = SplendidError      ;
				this.ExchangeSecurity    = ExchangeSecurity   ;
				this.SyncError           = SyncError          ;
				this.GoogleApps          = GoogleApps         ;
				this.GoogleSync          = GoogleSync         ;
			}

			public GoogleWebhook(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, GoogleApps GoogleApps, GoogleSync GoogleSync, string sChannelID, string sChannelExpiration, string sResourceState, string sMessageNumber, string sResourceID, string sResourceURI, string sChannelToken)
			{
				this.Session             = Session            ;
				this.Security            = Security           ;
				this.Sql                 = Sql                ;
				this.SqlProcs            = SqlProcs           ;
				this.SplendidError       = SplendidError      ;
				this.ExchangeSecurity    = ExchangeSecurity   ;
				this.SyncError           = SyncError          ;
				this.GoogleApps          = GoogleApps         ;
				this.GoogleSync          = GoogleSync         ;

				this.ChannelID         = sChannelID        ;
				this.ChannelExpiration = sChannelExpiration;
				this.ResourceState     = sResourceState    ;
				this.MessageNumber     = sMessageNumber    ;
				this.ResourceID        = sResourceID       ;
				this.ResourceURI       = sResourceURI      ;
				this.ChannelToken      = sChannelToken     ;
			}

			public static void AddWebhook(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, GoogleApps GoogleApps, GoogleSync GoogleSync, string sChannelId, string sChannelExpiration, string sResourceState, string sMessageNumber, string sResourceId, string sResourceURI, string sChannelToken)
			{
				try
				{
					Guid     gUSER_ID            = Sql.ToGuid(sChannelToken);
					Guid     gCHANNEL_ID         = Sql.ToGuid(sChannelId   );
					string   sRESOURCE_ID        = String.Empty;
					SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL = String.Empty;
						sSQL = "select SYNC_TOKEN                          " + ControlChars.CrLf
						     + "  from vwOAUTH_SYNC_TOKENS                 " + ControlChars.CrLf
						     + " where ID               = @ID              " + ControlChars.CrLf
						     + "   and ASSIGNED_USER_ID = @ASSIGNED_USER_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID"              , gCHANNEL_ID);
							Sql.AddParameter(cmd, "@ASSIGNED_USER_ID", gUSER_ID   );
							sRESOURCE_ID  = Sql.ToString(cmd.ExecuteScalar());
						}
						if ( Sql.IsEmptyString(sRESOURCE_ID) )
						{
							Debug.WriteLine("GoogleSync.AddWebhook: Stopping " + sChannelToken + ", " + sResourceId);
							// 09/14/2015 Paul.  If the user is not found, then all channels will be orphaned. 
							Google.Apis.Services.BaseClientService.Initializer initializer = GoogleApps.GetUserCredentialInitializer(gUSER_ID, CalendarService.Scope.Calendar);
							CalendarService service = new CalendarService(initializer);
							GoogleSync.GoogleWebhook GoogleWebhook = new GoogleSync.GoogleWebhook(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, GoogleApps, GoogleSync, sChannelId, sChannelExpiration, sResourceState, sMessageNumber, sResourceId, sResourceURI, sChannelToken);
							GoogleWebhook.StopChannel(service, sChannelId, sResourceId, gUSER_ID);
							throw(new Exception("Could not find channel " + gCHANNEL_ID.ToString()));
						}
						else
						{
							GoogleSync.GoogleWebhook GoogleWebhook = new GoogleSync.GoogleWebhook(Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, GoogleApps, GoogleSync, sChannelId, sChannelExpiration, sResourceState, sMessageNumber, sResourceId, sResourceURI, sChannelToken);
							lock ( queueWebhooks )
							{
								queueWebhooks.Enqueue(GoogleWebhook);
							}
						}
					}
				}
				catch(Exception ex)
				{
					string sMESSAGE = "GoogleSync.AddWebhook: " + sChannelToken + ", " + sResourceId + ", " + sResourceURI + ": " + Utils.ExpandException(ex);
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
					throw(new Exception(sMESSAGE));
				}
			}

			// https://developers.google.com/google-apps/calendar/v3/push
			public void CreateChannel(CalendarService service, Guid gUSER_ID, string sNAME, string sResourceId, string sCALENDAR_ID)
			{
				// 09/15/2015 Paul.  If Unauthorized, then exit early.  Reset the flag by saving Google settings. 
				if ( GoogleSync.bUnauthorizedWebHook )
					return;
				try
				{
					Debug.WriteLine("GoogleSync.CreateChannel: " + gUSER_ID + ", " + sResourceId);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL = String.Empty;
						Guid     gCHANNEL_ID        = Guid.Empty;
						DateTime dtTOKEN_EXPIRES_AT = DateTime.MinValue;
						sSQL = "select ID                                  " + ControlChars.CrLf
						     + "     , TOKEN_EXPIRES_AT                    " + ControlChars.CrLf
						     + "  from vwOAUTH_SYNC_TOKENS                 " + ControlChars.CrLf
						     + " where ASSIGNED_USER_ID = @ASSIGNED_USER_ID" + ControlChars.CrLf
						     + "   and NAME             = @NAME            " + ControlChars.CrLf
						     + "   and SYNC_TOKEN       = @SYNC_TOKEN      " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@NAME"            , sNAME      );
							Sql.AddParameter(cmd, "@SYNC_TOKEN"      , sResourceId);
							using (IDataReader rdr = cmd.ExecuteReader() )
							{
								if ( rdr.Read() )
								{
									gCHANNEL_ID        = Sql.ToGuid    (rdr["ID"              ]);
									dtTOKEN_EXPIRES_AT = Sql.ToDateTime(rdr["TOKEN_EXPIRES_AT"]);
								}
							}
						}
						
						// 09/14/2015 Paul.  If the channel expires in the next 6 hours, then stop and recreate. 
						if ( !Sql.IsEmptyGuid(gCHANNEL_ID) && dtTOKEN_EXPIRES_AT != DateTime.MinValue && DateTime.Now.AddHours(6) > dtTOKEN_EXPIRES_AT )
						{
							Debug.WriteLine("GoogleSync.CreateChannel: " + gCHANNEL_ID + " aready exists for " + sResourceId + " but has expired.");
							this.StopChannel(service, gCHANNEL_ID.ToString(), sResourceId, gUSER_ID);
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									SqlProcs.spOAUTH_SYNC_TOKENS_Delete(gCHANNEL_ID, gUSER_ID, trn);
									trn.Commit();
								}
								catch
								{
									trn.Rollback();
								}
							}
							gCHANNEL_ID        = Guid.Empty;
							dtTOKEN_EXPIRES_AT = DateTime.MinValue;
						}
						if ( Sql.IsEmptyGuid(gCHANNEL_ID) )
						{
							Debug.WriteLine("GoogleSync.CreateChannel: Channel does not exist for " + sResourceId);
							Google.Apis.Calendar.v3.Data.Channel body = new Google.Apis.Calendar.v3.Data.Channel();
							// 09/14/2015 Paul.  The randomly generated ID will prevent hackers from injecting data. 
							gCHANNEL_ID      = Guid.NewGuid();
							body.Id          = gCHANNEL_ID.ToString();
							//body.Address     = Crm.Config.SiteURL() + "GoogleOAuth/Google_Webhook.aspx";
							body.Address     = Sql.ToString(Application["CONFIG.GoogleApps.PushNotificationURL"]);
							body.Type        = "web_hook";
							body.Token       = gUSER_ID.ToString();
							body.ResourceId  = sResourceId;
							try
							{
								// 09/15/2015 Paul.  The first callback event can occur before the watch execute returns, so create the record first. 
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										SqlProcs.spOAUTH_SYNC_TOKENS_Update(ref gCHANNEL_ID, gUSER_ID, sNAME, sResourceId, dtTOKEN_EXPIRES_AT, trn);
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
									}
								}
								EventsResource.WatchRequest watch = service.Events.Watch(body, sCALENDAR_ID);
								body = watch.Execute();
								if ( body.Expiration.HasValue )
								{
									DateTime dtUnixEpoch = new DateTime(1970, 1, 1);
									dtTOKEN_EXPIRES_AT = dtUnixEpoch.AddMilliseconds(body.Expiration.Value);
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spOAUTH_SYNC_TOKENS_Update(ref gCHANNEL_ID, gUSER_ID, sNAME, sResourceId, dtTOKEN_EXPIRES_AT, trn);
											trn.Commit();
										}
										catch
										{
											trn.Rollback();
										}
									}
								}
							}
							catch(Exception ex)
							{
								if ( ex.Message.Contains("Unauthorized WebHook callback channel:") || ex.Message.Contains("WebHook callback must be HTTPS:") )
									GoogleSync.bUnauthorizedWebHook = true;
								string sMESSAGE = "GoogleSync.CreateChannel: " + gUSER_ID.ToString() + ": " + Utils.ExpandException(ex);
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
								SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
							}
						}
						else
						{
							Debug.WriteLine("GoogleSync.CreateChannel: " + gCHANNEL_ID + " aready exists for " + sResourceId);
						}
					}
				}
				catch(Exception ex)
				{
					string sMESSAGE = "GoogleSync.CreateChannel: " + gUSER_ID.ToString() + ", " + sResourceId + ": " + Utils.ExpandException(ex);
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
				}
			}

			public void StopChannel(CalendarService service, string sChannelId, string sResourceId, Guid gUSER_ID)
			{
				try
				{
					Debug.WriteLine("GoogleSync.StopChannel: " + sChannelId + "  " + sResourceId);
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								Guid gCHANNEL_ID = Sql.ToGuid(sChannelId);
								SqlProcs.spOAUTH_SYNC_TOKENS_Delete(gCHANNEL_ID, gUSER_ID, trn);
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
					string sMESSAGE = "GoogleSync.StopChannel: " + gUSER_ID.ToString() + ", " + sChannelId + ", " + sResourceId + ": " + Utils.ExpandException(ex);
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
				}
				try
				{
					// 09/14/2015 Paul.  If the channel is not found, then it must have been orphaned, so we can stop it. 
					Google.Apis.Calendar.v3.Data.Channel body = new Google.Apis.Calendar.v3.Data.Channel();
					body.Id         = sChannelId;
					body.ResourceId = sResourceId;
					ChannelsResource.StopRequest stop = service.Channels.Stop(body);
					stop.Execute();
				}
				catch(Exception ex)
				{
					string sMESSAGE = "GoogleSync.StopChannel: " + gUSER_ID.ToString() + ", " + sChannelId + ", " + sResourceId + ": " + Utils.ExpandException(ex);
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
				}
			}
	
			// https://developers.google.com/google-apps/calendar/v3/push
			public void ProcessNotification(string sChannelId, string sChannelExpiration, string sResourceState, string sMessageNumber, string sResourceId, string sResourceURI, string sChannelToken)
			{
				// User-Agent: APIs-Google; (+https://developers.google.com/webmasters/APIs-Google.html)
				// X-Goog-Channel-ID: 735ad244-5132-4f5d-8fb6-9aa883697c77
				// X-Goog-Channel-Expiration: Tue, 22 Sep 2015 09:51:46 GMT
				// X-Goog-Resource-State: exists
				// X-Goog-Message-Number: 165139
				// X-Goog-Resource-ID: M9-5cvkI1ybZzvVLAyMHMHMa_VI
				// X-Goog-Resource-URI: https://www.googleapis.com/calendar/v3/calendars/g0hr9n0oa09eikbm4rakh9huq0@group.calendar.google.com/events?alt=json
				// X-Goog-Channel-Token: 4836884c-5d8a-4d6b-8689-bfbeb33e902e
				
				StringBuilder sbErrors = new StringBuilder();
				try
				{
					Guid     gUSER_ID            = Sql.ToGuid(sChannelToken);
					Guid     gCHANNEL_ID         = Sql.ToGuid(sChannelId   );
					string   sRESOURCE_ID        = sResourceId ;
					DateTime dtChannelExpiration = DateTime.MinValue;
					DateTime.TryParseExact(sChannelExpiration, CultureInfo.CurrentCulture.DateTimeFormat.RFC1123Pattern, CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out dtChannelExpiration);
					
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL = String.Empty;
						sSQL = "select SYNC_TOKEN                          " + ControlChars.CrLf
						     + "  from vwOAUTH_SYNC_TOKENS                 " + ControlChars.CrLf
						     + " where ID               = @ID              " + ControlChars.CrLf
						     + "   and ASSIGNED_USER_ID = @ASSIGNED_USER_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID"              , gCHANNEL_ID);
							Sql.AddParameter(cmd, "@ASSIGNED_USER_ID", gUSER_ID   );
							sRESOURCE_ID  = Sql.ToString(cmd.ExecuteScalar());
						}
						
						Google.Apis.Services.BaseClientService.Initializer initializer = GoogleApps.GetUserCredentialInitializer(gUSER_ID, CalendarService.Scope.Calendar);
						CalendarService service = new CalendarService(initializer);
						if ( !Sql.IsEmptyString(sRESOURCE_ID) )
						{
							Debug.WriteLine("GoogleSync.ProcessNotification: Found " + sRESOURCE_ID);
							if ( sResourceURI.StartsWith("https://www.googleapis.com/calendar/v3") )
							{
								string sCALENDAR_ID = sResourceURI;
								if ( sResourceURI.StartsWith("https://www.googleapis.com/calendar/v3/calendars/") )
									sCALENDAR_ID = sResourceURI.Replace("https://www.googleapis.com/calendar/v3/calendars/", String.Empty).Replace("/events?alt=json", String.Empty);
								
								ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
								EventsResource.GetRequest reqGet = service.Events.Get(sCALENDAR_ID, sRESOURCE_ID);
								Event appointment = reqGet.Execute();
								
								GoogleSync.ImportAppointment(Session, service, con, gUSER_ID, appointment, sCALENDAR_ID, sbErrors);
							}
						}
						else
						{
							Debug.WriteLine("GoogleSync.ProcessNotification: Stopping " + sChannelToken + ", " + sResourceId);
							// 09/14/2015 Paul.  If the user is not found, then all channels will be orphaned. 
							StopChannel(service, sChannelId, sResourceId, gUSER_ID);
							// 09/16/2015 Paul.  Now that we process the queue in the back-end, we cannot throw an exception. 
							//throw(new Exception("Could not find channel " + gCHANNEL_ID.ToString()));
						}
					}
				}
				catch(Exception ex)
				{
					string sMESSAGE = "GoogleSync.ProcessNotification: " + sChannelToken + ", " + sResourceId + ", " + sResourceURI + ": " + Utils.ExpandException(ex);
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
					sbErrors.AppendLine(sMESSAGE);
					Debug.WriteLine(sbErrors);
					// 09/16/2015 Paul.  Now that we process the queue in the back-end, we cannot throw an exception. 
					//throw(new Exception(sbErrors.ToString()));
				}
			}

			// 09/16/2015 Paul.  Google notifications will also be processed in the email timer. 
			public static void ProcessAllNotifications(SplendidError SplendidError, SyncError SyncError)
			{
				try
				{
					while ( queueWebhooks.Count > 0 )
					{
						GoogleSync.GoogleWebhook evt = null;
						lock ( queueWebhooks )
						{
							evt = queueWebhooks.Dequeue();
						}
						evt.ProcessNotification(evt.ChannelID, evt.ChannelExpiration, evt.ResourceState, evt.MessageNumber, evt.ResourceID, evt.ResourceURI, evt.ChannelToken);
					}
				}
				catch(Exception ex)
				{
					SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), ex);
				}
			}
		}
		#endregion

#pragma warning disable CS1998
		public async ValueTask SyncAllUsers(CancellationToken token)
		{
			SyncAllUsers();
		}
#pragma warning restore CS1998

		#region UserSync
		public void SyncAllUsers()
		{
			bool bGoogleAppsEnabled = Sql.ToBoolean(Application["CONFIG.GoogleApps.Enabled"]);
			if ( !GoogleSync.bInsideSyncAll && bGoogleAppsEnabled )
			{
				GoogleSync.bInsideSyncAll = true;
				try
				{
					// 09/16/2015 Paul.  Google notifications will also be processed in the email timer, but also process here, before dealing with internal changes. 
					GoogleWebhook.ProcessAllNotifications(SplendidError, SyncError);
					using ( DataTable dt = new DataTable() )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL = String.Empty;
							sSQL = "select GOOGLEAPPS_SYNC_CONTACTS" + ControlChars.CrLf
							     + "     , GOOGLEAPPS_SYNC_CALENDAR" + ControlChars.CrLf
							     + "     , USER_ID                 " + ControlChars.CrLf
							     + "  from vwGOOGLEAPPS_USERS      " + ControlChars.CrLf
							     + " order by USER_ID              " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
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
							bool   bGOOGLEAPPS_SYNC_CONTACTS = Sql.ToBoolean(row["GOOGLEAPPS_SYNC_CONTACTS"]);
							bool   bGOOGLEAPPS_SYNC_CALENDAR = Sql.ToBoolean(row["GOOGLEAPPS_SYNC_CALENDAR"]);
							Guid   gUSER_ID                  = Sql.ToGuid   (row["USER_ID"                 ]);
							StringBuilder sbErrors = new StringBuilder();
							GoogleSync.UserSync User = new GoogleSync.UserSync(Session, Security, SplendidError, ExchangeSecurity, SyncError, this, bGOOGLEAPPS_SYNC_CONTACTS, bGOOGLEAPPS_SYNC_CALENDAR, gUSER_ID, false);
							Sync(User, sbErrors);
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
					GoogleSync.bInsideSyncAll = false;
				}
			}
		}

		// 01/22/2012 Paul.  The workflow engine will fire user sync events when a record changes. 
		public void SyncUser(Guid gUSER_ID)
		{
			bool bGoogleAppsEnabled = Sql.ToBoolean(Application["CONFIG.GoogleApps.Enabled"]);
			if ( bGoogleAppsEnabled )
			{
				try
				{
					using ( DataTable dt = new DataTable() )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select GOOGLEAPPS_SYNC_CONTACTS" + ControlChars.CrLf
							     + "     , GOOGLEAPPS_SYNC_CALENDAR" + ControlChars.CrLf
							     + "     , USER_ID                 " + ControlChars.CrLf
							     + "  from vwGOOGLEAPPS_USERS      " + ControlChars.CrLf
							     + " where USER_ID = @USER_ID      " + ControlChars.CrLf
							     + " order by USER_ID              " + ControlChars.CrLf;
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
							bool   bGOOGLEAPPS_SYNC_CONTACTS = Sql.ToBoolean(row["GOOGLEAPPS_SYNC_CONTACTS"]);
							bool   bGOOGLEAPPS_SYNC_CALENDAR = Sql.ToBoolean(row["GOOGLEAPPS_SYNC_CALENDAR"]);
							StringBuilder sbErrors = new StringBuilder();
							GoogleSync.UserSync User = new GoogleSync.UserSync(Session, Security, SplendidError, ExchangeSecurity, SyncError, this, bGOOGLEAPPS_SYNC_CONTACTS, bGOOGLEAPPS_SYNC_CALENDAR, gUSER_ID, false);
							Sync(User, sbErrors);
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
			private SplendidError        SplendidError      ;
			private ExchangeSecurity     ExchangeSecurity   ;
			private SyncError            SyncError          ;
			private GoogleSync           GoogleSync         ;

			public bool        GOOGLEAPPS_SYNC_CONTACTS;
			public bool        GOOGLEAPPS_SYNC_CALENDAR;
			public Guid        USER_ID                 ;
			public bool        SyncAll                 ;

			public UserSync(HttpSessionState Session, Security Security, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, GoogleSync GoogleSync, bool bGOOGLEAPPS_SYNC_CONTACTS, bool bGOOGLEAPPS_SYNC_CALENDAR, Guid gUSER_ID, bool bSyncAll)
			{
				this.Session             = Session            ;
				this.Security            = Security           ;
				this.SplendidError       = SplendidError      ;
				this.ExchangeSecurity    = ExchangeSecurity   ;
				this.SyncError           = SyncError          ;
				this.GoogleSync          = GoogleSync         ;

				this.GOOGLEAPPS_SYNC_CONTACTS = bGOOGLEAPPS_SYNC_CONTACTS;
				this.GOOGLEAPPS_SYNC_CALENDAR = bGOOGLEAPPS_SYNC_CALENDAR;
				this.USER_ID                  = gUSER_ID                 ;
				this.SyncAll                  = bSyncAll                 ;
			}
			
			public void Start()
			{
				// 04/25/2010 Paul.  Provide elapse time for SyncAll. 
				DateTime dtStart = DateTime.Now;
				bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.GoogleApps.VerboseStatus"]);
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  Begin " + USER_ID.ToString() + " at " + dtStart.ToString());
				StringBuilder sbErrors = new StringBuilder();
				
				// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
				GoogleSync.Sync(this, sbErrors);
				DateTime dtEnd = DateTime.Now;
				TimeSpan ts = dtEnd - dtStart;
				if ( bVERBOSE_STATUS )
					SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "UserSync:  End "   + USER_ID.ToString() + " at " + dtEnd.ToString() + ". Elapse time " + ts.Minutes.ToString() + " minutes " + ts.Seconds.ToString() + " seconds.");
			}

			public static UserSync Create(HttpSessionState Session, Security Security, SplendidError SplendidError, ExchangeSecurity ExchangeSecurity, SyncError SyncError, GoogleSync GoogleSync, Guid gUSER_ID, bool bSyncAll)
			{
				GoogleSync.UserSync User = null;
				SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					sSQL = "select GOOGLEAPPS_SYNC_CONTACTS" + ControlChars.CrLf
					     + "     , GOOGLEAPPS_SYNC_CALENDAR" + ControlChars.CrLf
					     + "     , USER_ID                 " + ControlChars.CrLf
					     + "  from vwGOOGLEAPPS_USERS      " + ControlChars.CrLf
					     + " where USER_ID  = @USER_ID     " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@USER_ID", gUSER_ID);
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								bool   bGOOGLEAPPS_SYNC_CONTACTS = Sql.ToBoolean(rdr["GOOGLEAPPS_SYNC_CONTACTS"]);
								bool   bGOOGLEAPPS_SYNC_CALENDAR = Sql.ToBoolean(rdr["GOOGLEAPPS_SYNC_CALENDAR"]);
								User = new GoogleSync.UserSync(Session, Security, SplendidError, ExchangeSecurity, SyncError, GoogleSync, bGOOGLEAPPS_SYNC_CONTACTS, bGOOGLEAPPS_SYNC_CALENDAR, gUSER_ID, bSyncAll);
							}
						}
					}
				}
				return User;
			}
		}

		public void Sync(GoogleSync.UserSync User, StringBuilder sbErrors)
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
				try
				{
					ExchangeSession Session = ExchangeSecurity.LoadUserACL(User.USER_ID);
					
					// 09/13/3015 Paul.  Google now uses OAuth 2.0, so Username and Password are not used. 
					//Guid gINBOUND_EMAIL_KEY = Sql.ToGuid(Application["CONFIG.InboundEmailKey"]);
					//Guid gINBOUND_EMAIL_IV  = Sql.ToGuid(Application["CONFIG.InboundEmailIV" ]);
					//if ( !Sql.IsEmptyString(User.GOOGLEAPPS_PASSWORD) )
					//	User.GOOGLEAPPS_PASSWORD = Security.DecryptPassword(User.GOOGLEAPPS_PASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
					
					if ( User.GOOGLEAPPS_SYNC_CONTACTS )
					{
						Google.Apis.Services.BaseClientService.Initializer initializer = GoogleApps.GetUserCredentialInitializer(User.USER_ID, ContactsService.Scope.Contacts);
						ContactsService service = new ContactsService(initializer);
						
						this.SyncContacts(Session, service, User.USER_ID, User.SyncAll, sbErrors);
					}
					if ( User.GOOGLEAPPS_SYNC_CALENDAR )
					{
						Google.Apis.Services.BaseClientService.Initializer initializer = GoogleApps.GetUserCredentialInitializer(User.USER_ID, CalendarService.Scope.Calendar);
						CalendarService service = new CalendarService(initializer);
						this.SyncAppointments(Session, service, User.USER_ID, User.SyncAll, sbErrors);
					}
				}
				finally
				{
					lock ( arrProcessing )
					{
						arrProcessing.Remove(User.USER_ID);
					}
				}
			}
			else
			{
				string sError = "Sync:  Already busy processing " + User.USER_ID.ToString();
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), sError);
				sbErrors.AppendLine(sError);
			}
		}
		#endregion

		#region Sync Contacts
		private bool SetGoogleContact(Contact contact, DataRow row, StringBuilder sbChanges)
		{
			bool bChanged = false;
			string sFILE_AS = Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]);
			sFILE_AS = sFILE_AS.Trim();
			if ( Sql.IsEmptyString(sFILE_AS) )
				sFILE_AS = "(no name)";
			if ( contact.Name == null && Sql.IsEmptyString(contact.Title) && contact.Emails == null )
			{
				// 03/28/2010 Paul.  You must load or assign this property before you can read its value. 
				// So set all the fields to empty values. 
				contact.Name            = new StructuredName();
				contact.Name.FirstName  = Sql.ToString(row["FIRST_NAME"]);
				contact.Name.LastName   = Sql.ToString(row["LAST_NAME" ]);
				contact.Name.FullName   = sFILE_AS;
				contact.Title           = sFILE_AS;
				
				if ( Sql.ToDateTime(row["BIRTHDATE"]) != DateTime.MinValue )
					contact.Birthday = Sql.ToDateTime(row["BIRTHDATE"]);
				contact.Notes = Sql.ToString(row["DESCRIPTION"]);
				
				if ( !Sql.IsEmptyString(row["EMAIL1"]) )
				{
					if ( contact.Emails == null )
						contact.Emails = new List<EmailValue>();
					EmailValue email = new EmailValue();
					email.Address = Sql.ToString(row["EMAIL1"]);
					email.Rel     = "http://schemas.google.com/g/2005#work";
					email.Primary = true;
					contact.Emails.Add(email);
				}
				if ( !Sql.IsEmptyString(row["EMAIL2"]) )
				{
					if ( contact.Emails == null )
						contact.Emails = new List<EmailValue>();
					EmailValue email = new EmailValue();
					email.Address = Sql.ToString(row["EMAIL2"]);
					email.Rel     = "http://schemas.google.com/g/2005#other";
				}
				
				if ( !Sql.IsEmptyString(row["ACCOUNT_NAME"])
				  || !Sql.IsEmptyString(row["DEPARTMENT"  ])
				  || !Sql.IsEmptyString(row["TITLE"       ])
				   )
				{
					if ( contact.Organizations == null )
						contact.Organizations = new List<OrganizationValue>();
					OrganizationValue org = new OrganizationValue();
					org.Primary    = true;
					org.Rel        = "http://schemas.google.com/g/2005#work";
					org.Name       = Sql.ToString(row["ACCOUNT_NAME"]);
					org.Department = Sql.ToString(row["DEPARTMENT"  ]);
					org.Title      = Sql.ToString(row["TITLE"       ]);
					contact.Organizations.Add(org);
				}
				
				//f ( !Sql.IsEmptyString(row["ASSISTANT"]) )
				//
				//	Relation relASSISTANT = new Relation();
				//	// 04/16/2011 Paul.  Google is not setting the relationship type properly.  It is just using the name, not the namespace. 
				//	//relASSISTANT.Rel   = "http://schemas.google.com/g/2005#assistant";
				//	relASSISTANT.Rel   = "assistant";
				//	relASSISTANT.Value = Sql.ToString(row["ASSISTANT"]);
				//	contact.Relations.Add(relASSISTANT);
				//if ( !Sql.IsEmptyString(row["ASSISTANT_PHONE"]) )
				//{
				//	PhoneNumber phASSISTANT_PHONE = new PhoneNumber(Sql.ToString(row["ASSISTANT_PHONE"]));
				//	phASSISTANT_PHONE.Rel = "http://schemas.google.com/g/2005#assistant";
				//	contact.Phonenumbers.Add(phASSISTANT_PHONE);
				//}
				if ( !Sql.IsEmptyString(row["PHONE_FAX"]) )
				{
					if ( contact.PhoneNumbers == null )
						contact.PhoneNumbers = new List<PhoneNumberValue>();
					PhoneNumberValue phPHONE_FAX = new PhoneNumberValue();
					// 04/16/2011 Paul.  We are going to use WorkFax instead of just Fax. 
					phPHONE_FAX.Value = Sql.ToString(row["PHONE_FAX"]);
					phPHONE_FAX.Rel   = "http://schemas.google.com/g/2005#work_fax";
					contact.PhoneNumbers.Add(phPHONE_FAX);
				}
				if ( !Sql.IsEmptyString(row["PHONE_WORK"]) )
				{
					if ( contact.PhoneNumbers == null )
						contact.PhoneNumbers = new List<PhoneNumberValue>();
					PhoneNumberValue phPHONE_WORK = new PhoneNumberValue();
					phPHONE_WORK.Value   = Sql.ToString(row["PHONE_WORK"]);
					phPHONE_WORK.Primary = true;
					phPHONE_WORK.Rel     = "http://schemas.google.com/g/2005#work";
					contact.PhoneNumbers.Add(phPHONE_WORK);
				}
				if ( !Sql.IsEmptyString(row["PHONE_MOBILE"]) )
				{
					if ( contact.PhoneNumbers == null )
						contact.PhoneNumbers = new List<PhoneNumberValue>();
					PhoneNumberValue phPHONE_MOBILE = new PhoneNumberValue();
					phPHONE_MOBILE.Value = Sql.ToString(row["PHONE_MOBILE"]);
					phPHONE_MOBILE.Rel   = "http://schemas.google.com/g/2005#mobile";
					contact.PhoneNumbers.Add(phPHONE_MOBILE);
				}
				if ( !Sql.IsEmptyString(row["PHONE_OTHER"]) )
				{
					if ( contact.PhoneNumbers == null )
						contact.PhoneNumbers = new List<PhoneNumberValue>();
					PhoneNumberValue phPHONE_OTHER = new PhoneNumberValue();
					phPHONE_OTHER.Value = Sql.ToString(row["PHONE_OTHER"]);
					phPHONE_OTHER.Rel   = "http://schemas.google.com/g/2005#other";
					contact.PhoneNumbers.Add(phPHONE_OTHER);
				}
				if ( !Sql.IsEmptyString(row["PHONE_HOME"]) )
				{
					if ( contact.PhoneNumbers == null )
						contact.PhoneNumbers = new List<PhoneNumberValue>();
					PhoneNumberValue phPHONE_HOME = new PhoneNumberValue();
					phPHONE_HOME.Value = Sql.ToString(row["PHONE_HOME"]);
					phPHONE_HOME.Rel   = "http://schemas.google.com/g/2005#home";
					contact.PhoneNumbers.Add(phPHONE_HOME);
				}
				
				if ( !Sql.IsEmptyString(row["PRIMARY_ADDRESS_STREET"    ])
				  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_CITY"      ])
				  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_STATE"     ])
				  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_POSTALCODE"])
				  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_COUNTRY"   ])
				   )
				{
					if ( contact.StructuredPostalAddresses == null )
						contact.StructuredPostalAddresses = new List<StructuredPostalAddress>();
					StructuredPostalAddress adrPRIMARY_ADDRESS = new StructuredPostalAddress();
					//adrPRIMARY_ADDRESS.Primary    = true;
					adrPRIMARY_ADDRESS.Rel        = "http://schemas.google.com/g/2005#work" ;
					adrPRIMARY_ADDRESS.Street     = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);
					adrPRIMARY_ADDRESS.City       = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);
					adrPRIMARY_ADDRESS.State      = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);
					adrPRIMARY_ADDRESS.PostalCode = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);
					adrPRIMARY_ADDRESS.Country    = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);
					// 03/26/2011 Paul.  Google is ignoring the parts and just using the formatted address. 
					adrPRIMARY_ADDRESS.FormattedAddress = GoogleUtils.BuildFormattedAddress(adrPRIMARY_ADDRESS);
					contact.StructuredPostalAddresses.Add(adrPRIMARY_ADDRESS);
				}
				
				if ( !Sql.IsEmptyString(row["ALT_ADDRESS_STREET"        ])
				  || !Sql.IsEmptyString(row["ALT_ADDRESS_CITY"          ])
				  || !Sql.IsEmptyString(row["ALT_ADDRESS_STATE"         ])
				  || !Sql.IsEmptyString(row["ALT_ADDRESS_POSTALCODE"    ])
				  || !Sql.IsEmptyString(row["ALT_ADDRESS_COUNTRY"       ])
				   )
				{
					if ( contact.StructuredPostalAddresses == null )
						contact.StructuredPostalAddresses = new List<StructuredPostalAddress>();
					StructuredPostalAddress adrALT_ADDRESS = new StructuredPostalAddress();
					adrALT_ADDRESS.Rel        = "http://schemas.google.com/g/2005#other";
					adrALT_ADDRESS.Street     = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);
					adrALT_ADDRESS.City       = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);
					adrALT_ADDRESS.State      = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);
					adrALT_ADDRESS.PostalCode = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);
					adrALT_ADDRESS.Country    = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);
					// 03/26/2011 Paul.  Google is ignoring the parts and just using the formatted address. 
					adrALT_ADDRESS.FormattedAddress = GoogleUtils.BuildFormattedAddress(adrALT_ADDRESS);
					contact.StructuredPostalAddresses.Add(adrALT_ADDRESS);
				}
				bChanged = true;
			}
			else
			{
				if ( contact.Name != null )
				{
					if ( contact.Name.FullName != sFILE_AS )
					{
						if ( contact.Name.FirstName != null && contact.Name.FirstName != Sql.ToString(row["FIRST_NAME"]) )
							sbChanges.AppendLine("FIRST_NAME changed.");
						if ( contact.Name.LastName != null && contact.Name.LastName != Sql.ToString(row["LAST_NAME"]) )
							sbChanges.AppendLine("LAST_NAME changed.");
						
						contact.Name            = new StructuredName();
						contact.Name.FirstName  = Sql.ToString(row["FIRST_NAME"]);
						contact.Name.LastName   = Sql.ToString(row["LAST_NAME" ]);
						contact.Name.FullName   = sFILE_AS;
						contact.Title           = sFILE_AS;
						bChanged = true;
					}
				}
				else
				{
					if ( contact.Title != sFILE_AS )
					{
						sbChanges.AppendLine("FIRST_NAME changed.");
						sbChanges.AppendLine("LAST_NAME changed.");
						contact.Title           = null;
						contact.Name            = new StructuredName();
						contact.Name.FirstName  = Sql.ToString(row["FIRST_NAME"]);
						contact.Name.LastName   = Sql.ToString(row["LAST_NAME" ]);
						contact.Name.FullName   = sFILE_AS;
						contact.Title           = sFILE_AS;
						bChanged = true;
					}
				}
				if ( contact.Birthday == null || contact.Birthday != Sql.ToDateTime(row["BIRTHDATE"]) )
				{
					if ( contact.Birthday != null || !Sql.IsEmptyString(row["BIRTHDATE"]) )
					{
						if ( Sql.ToDateTime(row["BIRTHDATE"]) == DateTime.MinValue )
							contact.Birthday = null;
						else
							contact.Birthday = Sql.ToDateTime(row["BIRTHDATE"]);
						bChanged = true;
						sbChanges.AppendLine("BIRTHDATE changed.");
					}
				}
				
				if ( contact.Notes != Sql.ToString(row["DESCRIPTION"]) )
				{
					contact.Notes = Sql.ToString(row["DESCRIPTION"]);
					bChanged = true;
					sbChanges.AppendLine("DESCRIPTION changed.");
				}
				
				EmailValue eEMAIL1 = null;
				EmailValue eEMAIL2 = null;
				foreach ( EmailValue e in contact.Emails )
				{
					if      ( e.Rel == "http://schemas.google.com/g/2005#work"  && eEMAIL1 == null ) eEMAIL1 = e;
					else if ( e.Rel == "http://schemas.google.com/g/2005#other" && eEMAIL2 == null ) eEMAIL2 = e;
				}
				if ( eEMAIL1 == null || Sql.ToString(eEMAIL1.Address) != Sql.ToString(row["EMAIL1"]) )
				{
					if ( eEMAIL1 != null || !Sql.IsEmptyString(row["EMAIL1"]) )
					{
						if ( eEMAIL1 == null )
						{
							eEMAIL1         = new EmailValue();
							eEMAIL1.Primary = true;
							eEMAIL1.Rel     = "http://schemas.google.com/g/2005#work";
							contact.Emails.Add(eEMAIL1);
						}
						eEMAIL1.Address = Sql.ToString(row["EMAIL1"]);
						if ( Sql.IsEmptyString(eEMAIL1.Address) )
						{
							contact.Emails.Remove(eEMAIL1);
						}
						bChanged = true;
						sbChanges.AppendLine("EMAIL1 changed.");
					}
				}
				if ( eEMAIL2 == null || Sql.ToString(eEMAIL2.Address) != Sql.ToString(row["EMAIL2"]) )
				{
					if ( eEMAIL2 != null || !Sql.IsEmptyString(row["EMAIL2"]) )
					{
						if ( eEMAIL2 == null )
						{
							eEMAIL2     = new EmailValue();
							eEMAIL2.Rel = "http://schemas.google.com/g/2005#other";
							contact.Emails.Add(eEMAIL2);
						}
						eEMAIL2.Address = Sql.ToString(row["EMAIL2"]);
						if ( Sql.IsEmptyString(eEMAIL2.Address) )
						{
							contact.Emails.Remove(eEMAIL2);
						}
						bChanged = true;
						sbChanges.AppendLine("EMAIL2 changed.");
					}
				}
				
				OrganizationValue orgACCOUNT_NAME = null;
				if ( contact.Organizations != null )
				{
					foreach ( OrganizationValue org in contact.Organizations )
					{
						// 03/26/2011 Paul.  If we don't find the primary organization, then try the work organization. 
						if ( (org.Primary.HasValue && org.Primary.Value) || org.Rel == "http://schemas.google.com/g/2005#work" )
						{
							orgACCOUNT_NAME = org;
							break;
						}
					}
				}
				if ( orgACCOUNT_NAME == null 
				  || Sql.ToString(orgACCOUNT_NAME.Name      ) != Sql.ToString(row["ACCOUNT_NAME"])
				  || Sql.ToString(orgACCOUNT_NAME.Department) != Sql.ToString(row["DEPARTMENT"  ])
				  || Sql.ToString(orgACCOUNT_NAME.Title     ) != Sql.ToString(row["TITLE"       ])
				   )
				{
					if ( orgACCOUNT_NAME != null 
					  || !Sql.IsEmptyString(row["ACCOUNT_NAME"])
					  || !Sql.IsEmptyString(row["DEPARTMENT"  ])
					  || !Sql.IsEmptyString(row["TITLE"       ])
					   )
					{
						if ( orgACCOUNT_NAME == null )
						{
							if ( contact.Organizations == null )
								contact.Organizations = new List<OrganizationValue>();
							orgACCOUNT_NAME = new OrganizationValue();
							orgACCOUNT_NAME.Primary = true;
							orgACCOUNT_NAME.Rel     = "http://schemas.google.com/g/2005#work";
							contact.Organizations.Add(orgACCOUNT_NAME);
						}
						if ( Sql.ToString(orgACCOUNT_NAME.Name      ) != Sql.ToString(row["ACCOUNT_NAME"]) ) { orgACCOUNT_NAME.Name       = Sql.ToString(row["ACCOUNT_NAME"]);  bChanged = true; sbChanges.AppendLine("ACCOUNT_NAME" + " changed."); }
						if ( Sql.ToString(orgACCOUNT_NAME.Department) != Sql.ToString(row["DEPARTMENT"  ]) ) { orgACCOUNT_NAME.Department = Sql.ToString(row["DEPARTMENT"  ]);  bChanged = true; sbChanges.AppendLine("DEPARTMENT"   + " changed."); }
						if ( Sql.ToString(orgACCOUNT_NAME.Title     ) != Sql.ToString(row["TITLE"       ]) ) { orgACCOUNT_NAME.Title      = Sql.ToString(row["TITLE"       ]);  bChanged = true; sbChanges.AppendLine("TITLE"        + " changed."); }
						
						if ( Sql.IsEmptyString(orgACCOUNT_NAME.Name      ) 
						  && Sql.IsEmptyString(orgACCOUNT_NAME.Department) 
						  && Sql.IsEmptyString(orgACCOUNT_NAME.Title     ) 
						   )
						{
							contact.Organizations.Remove(orgACCOUNT_NAME);
						}
					}
				}
				
				//Relation relASSISTANT = null;
				//foreach ( Relation rel in contact.Relations )
				//{
				//	// 04/16/2011 Paul.  Google is not setting the relationship type properly.  It is just using the name, not the namespace. 
				//	if ( rel.Rel == "http://schemas.google.com/g/2005#assistant" || rel.Rel == "assistant" )
				//	{
				//		relASSISTANT = rel;
				//		break;
				//	}
				//}
				//if ( relASSISTANT == null || Sql.ToString(relASSISTANT.Value) != Sql.ToString(row["ASSISTANT"]) )
				//{
				//	if ( relASSISTANT != null || !Sql.IsEmptyString(row["ASSISTANT"]) )
				//	{
				//		if ( relASSISTANT == null )
				//		{
				//			relASSISTANT = new Relation();
				//			// 04/16/2011 Paul.  Google is not setting the relationship type properly.  It is just using the name, not the namespace. 
				//			//relASSISTANT.Rel = "http://schemas.google.com/g/2005#assistant";
				//			relASSISTANT.Rel = "assistant";
				//			contact.Relations.Add(relASSISTANT);
				//		}
				//		relASSISTANT.Value = Sql.ToString(row["ASSISTANT"]);
				//		if ( Sql.IsEmptyString(relASSISTANT.Value) )
				//		{
				//			contact.Relations.Remove(relASSISTANT);
				//		}
				//		bChanged = true;
				//		sbChanges.AppendLine("ASSISTANT changed.");
				//	}
				//}
				
				// https://developers.google.com/gdata/docs/2.0/elements?hl=en
				PhoneNumberValue phASSISTANT_PHONE = null;
				PhoneNumberValue phPHONE_FAX       = null;
				PhoneNumberValue phPHONE_WORK      = null;
				PhoneNumberValue phPHONE_MOBILE    = null;
				PhoneNumberValue phPHONE_OTHER     = null;
				PhoneNumberValue phPHONE_HOME      = null;
				foreach ( PhoneNumberValue phone in contact.PhoneNumbers )
				{
					if      ( phone.Rel == "http://schemas.google.com/g/2005#assistant" && phASSISTANT_PHONE == null ) phASSISTANT_PHONE = phone;
					// 04/16/2011 Paul.  We are going to use WorkFax instead of just Fax. 
					else if ( phone.Rel == "http://schemas.google.com/g/2005#work_fax"  && phPHONE_FAX       == null ) phPHONE_FAX       = phone;
					else if ( phone.Rel == "http://schemas.google.com/g/2005#work"      && phPHONE_WORK      == null ) phPHONE_WORK      = phone;
					else if ( phone.Rel == "http://schemas.google.com/g/2005#mobile"    && phPHONE_MOBILE    == null ) phPHONE_MOBILE    = phone;
					else if ( phone.Rel == "http://schemas.google.com/g/2005#other"     && phPHONE_OTHER     == null ) phPHONE_OTHER     = phone;
					else if ( phone.Rel == "http://schemas.google.com/g/2005#home"      && phPHONE_HOME      == null ) phPHONE_HOME      = phone;
				}
				
				if ( phASSISTANT_PHONE == null || Sql.ToString(phASSISTANT_PHONE.Value) != Sql.ToString(row["ASSISTANT_PHONE"]) )
				{
					if ( phASSISTANT_PHONE != null || !Sql.IsEmptyString(row["ASSISTANT_PHONE"]) )
					{
						if ( phASSISTANT_PHONE == null )
						{
							if ( contact.PhoneNumbers == null )
								contact.PhoneNumbers = new List<PhoneNumberValue>();
							phASSISTANT_PHONE = new PhoneNumberValue();
							phASSISTANT_PHONE.Rel = "http://schemas.google.com/g/2005#assistant";
							contact.PhoneNumbers.Add(phASSISTANT_PHONE);
						}
						phASSISTANT_PHONE.Value = Sql.ToString(row["ASSISTANT_PHONE"]);
						if ( Sql.IsEmptyString(phASSISTANT_PHONE.Value) )
						{
							contact.PhoneNumbers.Remove(phASSISTANT_PHONE);
						}
						bChanged = true;
						sbChanges.AppendLine("ASSISTANT_PHONE changed.");
					}
				}
				if ( phPHONE_FAX == null || Sql.ToString(phPHONE_FAX.Value) != Sql.ToString(row["PHONE_FAX"]) )
				{
					if ( phPHONE_FAX != null || !Sql.IsEmptyString(row["PHONE_FAX"]) )
					{
						if ( phPHONE_FAX == null )
						{
							if ( contact.PhoneNumbers == null )
								contact.PhoneNumbers = new List<PhoneNumberValue>();
							phPHONE_FAX = new PhoneNumberValue();
							// 04/16/2011 Paul.  We are going to use WorkFax instead of just Fax. 
							phPHONE_FAX.Rel = "http://schemas.google.com/g/2005#work_fax";
							contact.PhoneNumbers.Add(phPHONE_FAX);
						}
						phPHONE_FAX.Value = Sql.ToString(row["PHONE_FAX"]);
						if ( Sql.IsEmptyString(phPHONE_FAX.Value) )
						{
							contact.PhoneNumbers.Remove(phPHONE_FAX);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_FAX changed.");
					}
				}
				if ( phPHONE_WORK == null || Sql.ToString(phPHONE_WORK.Value) != Sql.ToString(row["PHONE_WORK"]) )
				{
					if ( phPHONE_WORK != null || !Sql.IsEmptyString(row["PHONE_WORK"]) )
					{
						if ( phPHONE_WORK == null )
						{
							if ( contact.PhoneNumbers == null )
								contact.PhoneNumbers = new List<PhoneNumberValue>();
							phPHONE_WORK = new PhoneNumberValue();
							phPHONE_WORK.Rel = "http://schemas.google.com/g/2005#work";
							phPHONE_WORK.Primary = true;
							contact.PhoneNumbers.Add(phPHONE_WORK);
						}
						phPHONE_WORK.Value = Sql.ToString(row["PHONE_WORK"]);
						if ( Sql.IsEmptyString(phPHONE_WORK.Value) )
						{
							contact.PhoneNumbers.Remove(phPHONE_WORK);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_WORK changed.");
					}
				}
				if ( phPHONE_MOBILE == null || Sql.ToString(phPHONE_MOBILE.Value) != Sql.ToString(row["PHONE_MOBILE"]) )
				{
					if ( phPHONE_MOBILE != null || !Sql.IsEmptyString(row["PHONE_MOBILE"]) )
					{
						if ( phPHONE_MOBILE == null )
						{
							if ( contact.PhoneNumbers == null )
								contact.PhoneNumbers = new List<PhoneNumberValue>();
							phPHONE_MOBILE = new PhoneNumberValue();
							phPHONE_MOBILE.Rel = "http://schemas.google.com/g/2005#mobile";
							contact.PhoneNumbers.Add(phPHONE_MOBILE);
						}
						phPHONE_MOBILE.Value = Sql.ToString(row["PHONE_MOBILE"]);
						if ( Sql.IsEmptyString(phPHONE_MOBILE.Value) )
						{
							contact.PhoneNumbers.Remove(phPHONE_MOBILE);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_MOBILE changed.");
					}
				}
				if ( phPHONE_OTHER == null || Sql.ToString(phPHONE_OTHER.Value) != Sql.ToString(row["PHONE_OTHER"]) )
				{
					if ( phPHONE_OTHER != null || !Sql.IsEmptyString(row["PHONE_OTHER"]) )
					{
						if ( phPHONE_OTHER == null )
						{
							if ( contact.PhoneNumbers == null )
								contact.PhoneNumbers = new List<PhoneNumberValue>();
							phPHONE_OTHER = new PhoneNumberValue();
							phPHONE_OTHER.Rel = "http://schemas.google.com/g/2005#other";
							contact.PhoneNumbers.Add(phPHONE_OTHER);
						}
						phPHONE_OTHER.Value = Sql.ToString(row["PHONE_OTHER"]);
						if ( Sql.IsEmptyString(phPHONE_OTHER.Value) )
						{
							contact.PhoneNumbers.Remove(phPHONE_OTHER);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_OTHER changed.");
					}
				}
				if ( phPHONE_HOME == null || Sql.ToString(phPHONE_HOME.Value) != Sql.ToString(row["PHONE_HOME"]) )
				{
					if ( phPHONE_HOME != null || !Sql.IsEmptyString(row["PHONE_HOME"]) )
					{
						if ( phPHONE_HOME == null )
						{
							if ( contact.PhoneNumbers == null )
								contact.PhoneNumbers = new List<PhoneNumberValue>();
							phPHONE_HOME = new PhoneNumberValue();
							phPHONE_HOME.Rel = "http://schemas.google.com/g/2005#home";
							contact.PhoneNumbers.Add(phPHONE_HOME);
						}
						phPHONE_HOME.Value = Sql.ToString(row["PHONE_HOME"]);
						if ( Sql.IsEmptyString(phPHONE_HOME.Value) )
						{
							contact.PhoneNumbers.Remove(phPHONE_HOME);
						}
						bChanged = true;
						sbChanges.AppendLine("PHONE_HOME changed.");
					}
				}
				
				StructuredPostalAddress adrPRIMARY_ADDRESS = null;
				StructuredPostalAddress adrALT_ADDRESS     = null;
				if ( contact.StructuredPostalAddresses != null )
				{
					foreach ( StructuredPostalAddress adr in contact.StructuredPostalAddresses )
					{
						if      ( adr.Rel == "http://schemas.google.com/g/2005#work"  && adrPRIMARY_ADDRESS == null ) adrPRIMARY_ADDRESS = adr;
						else if ( adr.Rel == "http://schemas.google.com/g/2005#other" && adrALT_ADDRESS     == null ) adrALT_ADDRESS     = adr;
					}
				}
				
				if ( adrPRIMARY_ADDRESS == null 
				  || Sql.ToString(adrPRIMARY_ADDRESS.Street      ) != Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ])
				  || Sql.ToString(adrPRIMARY_ADDRESS.City        ) != Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ])
				  || Sql.ToString(adrPRIMARY_ADDRESS.State       ) != Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ])
				  || Sql.ToString(adrPRIMARY_ADDRESS.PostalCode  ) != Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"])
				  || Sql.ToString(adrPRIMARY_ADDRESS.Country     ) != Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ])
				   )
				{
					if ( adrPRIMARY_ADDRESS != null 
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_STREET"    ])
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_CITY"      ])
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_STATE"     ])
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_POSTALCODE"])
					  || !Sql.IsEmptyString(row["PRIMARY_ADDRESS_COUNTRY"   ])
					   )
					{
						if ( adrPRIMARY_ADDRESS == null )
						{
							if ( contact.StructuredPostalAddresses != null )
								contact.StructuredPostalAddresses = new List<StructuredPostalAddress>();
							adrPRIMARY_ADDRESS = new StructuredPostalAddress();
							adrPRIMARY_ADDRESS.Rel     = "http://schemas.google.com/g/2005#other";
							contact.StructuredPostalAddresses.Add(adrPRIMARY_ADDRESS);
						}
						if ( Sql.ToString(adrPRIMARY_ADDRESS.Street    ) != Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]) ) { adrPRIMARY_ADDRESS.Street     = Sql.ToString(row["PRIMARY_ADDRESS_STREET"    ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_STREET"     + " changed."); }
						if ( Sql.ToString(adrPRIMARY_ADDRESS.City      ) != Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]) ) { adrPRIMARY_ADDRESS.City       = Sql.ToString(row["PRIMARY_ADDRESS_CITY"      ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_CITY"       + " changed."); }
						if ( Sql.ToString(adrPRIMARY_ADDRESS.State     ) != Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]) ) { adrPRIMARY_ADDRESS.State      = Sql.ToString(row["PRIMARY_ADDRESS_STATE"     ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_STATE"      + " changed."); }
						if ( Sql.ToString(adrPRIMARY_ADDRESS.PostalCode) != Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]) ) { adrPRIMARY_ADDRESS.PostalCode = Sql.ToString(row["PRIMARY_ADDRESS_POSTALCODE"]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_POSTALCODE" + " changed."); }
						if ( Sql.ToString(adrPRIMARY_ADDRESS.Country   ) != Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]) ) { adrPRIMARY_ADDRESS.Country    = Sql.ToString(row["PRIMARY_ADDRESS_COUNTRY"   ]);  bChanged = true; sbChanges.AppendLine("PRIMARY_ADDRESS_COUNTRY"    + " changed."); }
						
						if ( Sql.IsEmptyString(adrPRIMARY_ADDRESS.Street      ) 
						  && Sql.IsEmptyString(adrPRIMARY_ADDRESS.City        ) 
						  && Sql.IsEmptyString(adrPRIMARY_ADDRESS.State       ) 
						  && Sql.IsEmptyString(adrPRIMARY_ADDRESS.PostalCode  ) 
						  && Sql.IsEmptyString(adrPRIMARY_ADDRESS.Country     ) 
						   )
						{
							contact.StructuredPostalAddresses.Remove(adrPRIMARY_ADDRESS);
						}
						else
						{
							// 03/26/2011 Paul.  Google is ignoring the parts and just using the formatted address. 
							adrPRIMARY_ADDRESS.FormattedAddress = GoogleUtils.BuildFormattedAddress(adrPRIMARY_ADDRESS);
						}
					}
				}
				
				if ( adrALT_ADDRESS == null 
				  || Sql.ToString(adrALT_ADDRESS.Street      ) != Sql.ToString(row["ALT_ADDRESS_STREET"        ])
				  || Sql.ToString(adrALT_ADDRESS.City        ) != Sql.ToString(row["ALT_ADDRESS_CITY"          ])
				  || Sql.ToString(adrALT_ADDRESS.State       ) != Sql.ToString(row["ALT_ADDRESS_STATE"         ])
				  || Sql.ToString(adrALT_ADDRESS.PostalCode  ) != Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ])
				  || Sql.ToString(adrALT_ADDRESS.Country     ) != Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ])
				   )
				{
					if ( adrALT_ADDRESS != null 
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_STREET"        ])
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_CITY"          ])
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_STATE"         ])
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_POSTALCODE"    ])
					  || !Sql.IsEmptyString(row["ALT_ADDRESS_COUNTRY"       ])
					   )
					{
						if ( adrALT_ADDRESS == null )
						{
							if ( contact.StructuredPostalAddresses != null )
								contact.StructuredPostalAddresses = new List<StructuredPostalAddress>();
							adrALT_ADDRESS = new StructuredPostalAddress();
							adrALT_ADDRESS.Rel     = "http://schemas.google.com/g/2005#other";
							contact.StructuredPostalAddresses.Add(adrALT_ADDRESS);
						}
						if ( Sql.ToString(adrALT_ADDRESS.Street      ) != Sql.ToString(row["ALT_ADDRESS_STREET"        ]) ) { adrALT_ADDRESS.Street       = Sql.ToString(row["ALT_ADDRESS_STREET"        ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_STREET"         + " changed."); }
						if ( Sql.ToString(adrALT_ADDRESS.City        ) != Sql.ToString(row["ALT_ADDRESS_CITY"          ]) ) { adrALT_ADDRESS.City         = Sql.ToString(row["ALT_ADDRESS_CITY"          ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_CITY"           + " changed."); }
						if ( Sql.ToString(adrALT_ADDRESS.State       ) != Sql.ToString(row["ALT_ADDRESS_STATE"         ]) ) { adrALT_ADDRESS.State        = Sql.ToString(row["ALT_ADDRESS_STATE"         ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_STATE"          + " changed."); }
						if ( Sql.ToString(adrALT_ADDRESS.PostalCode  ) != Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]) ) { adrALT_ADDRESS.PostalCode   = Sql.ToString(row["ALT_ADDRESS_POSTALCODE"    ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_POSTALCODE"     + " changed."); }
						if ( Sql.ToString(adrALT_ADDRESS.Country     ) != Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]) ) { adrALT_ADDRESS.Country      = Sql.ToString(row["ALT_ADDRESS_COUNTRY"       ]);  bChanged = true; sbChanges.AppendLine("ALT_ADDRESS_COUNTRY"        + " changed."); }
						
						if ( Sql.IsEmptyString(adrALT_ADDRESS.Street      ) 
						  && Sql.IsEmptyString(adrALT_ADDRESS.City        ) 
						  && Sql.IsEmptyString(adrALT_ADDRESS.State       ) 
						  && Sql.IsEmptyString(adrALT_ADDRESS.PostalCode  ) 
						  && Sql.IsEmptyString(adrALT_ADDRESS.Country     ) 
						   )
						{
							contact.StructuredPostalAddresses.Remove(adrALT_ADDRESS);
						}
						else
						{
							// 03/26/2011 Paul.  Google is ignoring the parts and just using the formatted address. 
							adrALT_ADDRESS.FormattedAddress = GoogleUtils.BuildFormattedAddress(adrALT_ADDRESS);
						}
					}
				}
			}
			return bChanged;
		}

		public void SyncContacts(ExchangeSession Session, ContactsService service, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.GoogleApps.VerboseStatus"]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + gUSER_ID.ToString());
			
			string sSPLENDIDCRM_GROUP_NAME = Sql.ToString(Application["CONFIG.GoogleApps.GroupName"]).Trim();
			string sCONFLICT_RESOLUTION    = Sql.ToString(Application["CONFIG.GoogleApps.ConflictResolution"]);
			Guid   gTEAM_ID                = Sql.ToGuid  (Session["TEAM_ID"]);
			if ( Sql.IsEmptyString(sSPLENDIDCRM_GROUP_NAME) )
			{
				sSPLENDIDCRM_GROUP_NAME = "SplendidCRM";
			}
			
			try
			{
				string sSplendidGroupURI = Sql.ToString(Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".GroupURI"]);
				if ( Sql.IsEmptyString(sSplendidGroupURI) )
				{
					try
					{
						GroupsResource.ListRequest reqGroups = service.Groups.List();
						reqGroups.MaxResults = 10000;
						Google.Apis.Contacts.v3.Data.Groups groups = reqGroups.Execute();
						if ( groups.Feed.Items != null && groups.Feed.Items.Count > 0 )
						{
							foreach ( Google.Apis.Contacts.v3.Data.Group group in groups.Feed.Items )
							{
								if ( group.Title.Value == sSPLENDIDCRM_GROUP_NAME )
								{
									sSplendidGroupURI = group.Id.Value;
									break;
								}
							}
						}
					}
					catch(Exception ex)
					{
						throw(new Exception("Could not find group " + sSPLENDIDCRM_GROUP_NAME, ex));
					}
					if ( Sql.IsEmptyString(sSplendidGroupURI) )
					{
						try
						{
							Google.Apis.Contacts.v3.Data.GroupEntry grpEntry = new Google.Apis.Contacts.v3.Data.GroupEntry();
							grpEntry.CreateNew(sSPLENDIDCRM_GROUP_NAME);
							GroupsResource.InsertRequest reqInsert = service.Groups.Insert(grpEntry);
							GroupEntry group = reqInsert.Execute();
							sSplendidGroupURI = group.Entry.Id.Value;
						}
						catch(Exception ex)
						{
							throw(new Exception("Could not create group " + sSPLENDIDCRM_GROUP_NAME, ex));
						}
					}
					Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".GroupURI"] = sSplendidGroupURI;
				}
				if ( Sql.IsEmptyString(sSplendidGroupURI) )
				{
					throw(new Exception("Could not get or create group " + sSPLENDIDCRM_GROUP_NAME));
				}
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					
					string sSQL = String.Empty;
					DateTime dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = DateTime.MinValue;
					if ( !bSyncAll )
					{
						sSQL = "select max(SYNC_REMOTE_DATE_MODIFIED_UTC)            " + ControlChars.CrLf
						     + "  from vwCONTACTS_SYNC                               " + ControlChars.CrLf
						     + " where SYNC_SERVICE_NAME     = N'Google'             " + ControlChars.CrLf
						     + "   and SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID);
							dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC = Sql.ToDateTime(cmd.ExecuteScalar());
						}
					}
					
					ContactsResource.ListRequest request = service.Contacts.List();
					// 09/13/2015 Paul.  The K is time-zone information.  For UTC, it becomes Z. 
					// https://msdn.microsoft.com/en-us/library/8kb3ddd4(v=vs.110).aspx
					request.UpdatedMin   = dtMAX_SYNC_REMOTE_DATE_MODIFIED_UTC.AddSeconds(1).ToString("yyyy-MM-dd'T'HH:mm:ss.fffK", System.Globalization.DateTimeFormatInfo.InvariantInfo);
					request.ShowDeleted  = true ;
					request.StartIndex   = 1    ;
					request.MaxResults   = 100  ;
#if DEBUG
					request.MaxResults   = 10   ;
#endif
					
					Google.Apis.Contacts.v3.Data.Contacts contacts = null;
					do
					{
						contacts = request.Execute();
						if ( contacts.Feed.Items != null && contacts.Feed.Items.Count > 0 )
						{
							if ( contacts.Feed.Items.Count > 0 )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + contacts.Feed.Items.Count.ToString() + " contacts to retrieve from " + gUSER_ID.ToString());
							foreach ( Contact contact in contacts.Feed.Items )
							{
								bool bGroupFound = false;
								if ( contact.GroupMemberships != null )
								{
									foreach ( GroupMembership group in contact.GroupMemberships )
									{
										if ( group.Href == sSplendidGroupURI )
										{
											bGroupFound = true;
											if ( group.Deleted.HasValue && group.Deleted.Value )
												contact.Deleted = true;
											break;
										}
									}
								}
								if ( bGroupFound )
									this.ImportContact(Session, service, con, gUSER_ID, sSplendidGroupURI, contact, sbErrors);
							}
						}
						request.StartIndex = contacts.Feed.StartIndex + contacts.Feed.ItemsPerPage;
					}
					while ( request.StartIndex < contacts.Feed.TotalResults );
					
					// 03/26/2010 Paul.  Join to vwCONTACTS_USERS so that we only get contacts that are marked as Sync. 
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					// 09/18/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
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
					     + "               on vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'Google'               " + ControlChars.CrLf
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
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + dt.Rows.Count.ToString() + " contacts to send to " + gUSER_ID.ToString());
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
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Sending new contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + gUSER_ID.ToString());
											ContactEntry entry = new ContactEntry();
											this.SetGoogleContact(entry.Entry, row, sbChanges);
											
											// 03/28/2011 Paul.  Assign the new contact to the SplendidCRM group. 
											GroupMembership group = new GroupMembership();
											group.Href = sSplendidGroupURI;
											entry.Entry.GroupMemberships = new List<GroupMembership>();
											entry.Entry.GroupMemberships.Add(group);
											
											ContactsResource.InsertRequest reqInsert = service.Contacts.Insert(entry);
											entry = reqInsert.Execute();
											contact = entry.Entry;
											sSYNC_REMOTE_KEY = contact.IdOnly;
											if ( Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
												throw(new Exception("Contact creation did not return a contact Id."));
										}
										else
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Binding contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + gUSER_ID.ToString());
											
											try
											{
												ContactsResource.GetRequest reqGet = service.Contacts.Get(sSYNC_REMOTE_KEY);
												ContactEntry entry = reqGet.Execute();
												contact = entry.Entry;
												// 03/28/2010 Paul.  We need to double-check for conflicts. 
												// 03/26/2011 Paul.  Updated is in local time. 
												DateTime dtREMOTE_DATE_MODIFIED     = contact.Updated.Value;
												DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
												// 03/26/2011 Paul.  The Google remote date can vary by 1 millisecond, so check for local change first. 
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
													// 03/26/2011 Paul.  The Google remote date can vary by 1 millisecond, so check for local change first. 
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
												if ( contact.Deleted )
												{
													sSYNC_ACTION = "remote deleted";
												}
											}
											catch(Exception ex)
											{
												string sError = "Error retrieving Google contact " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + "." + ControlChars.CrLf;
												sError += Utils.ExpandException(ex) + ControlChars.CrLf;
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
												sbErrors.AppendLine(sError);
												// 09/18/2015 Paul.  If there was an error loading, don't mark as deleted. 
												sSYNC_ACTION = "";//sSYNC_ACTION = "remote deleted";
											}
											if ( sSYNC_ACTION == "local changed" )
											{
												bool bChanged = this.SetGoogleContact(contact, row, sbChanges);
												if ( bChanged )
												{
													if ( bVERBOSE_STATUS )
														SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Sending contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + gUSER_ID.ToString());
													ContactEntry entry = new ContactEntry();
													entry.Entry = contact;
													ContactsResource.UpdateRequest reqUpdate = service.Contacts.Update(entry, contact.IdOnly);
													entry = reqUpdate.Execute();
													contact = entry.Entry;
												}
												// 03/28/2011 Paul.  The Sync flag may have been re-checked, so we need to add the group back. 
												// 03/28/2011 Paul.  Re-adding the group throws an exception.  This seems like a Google bug, so just expect the user to delete the existing contact. 
												/*
												bool bGroupFound = false;
												foreach ( GroupMembership group in contact.GroupMembership )
												{
													if ( group.HRef == sSplendidGroupURI )
													{
														bGroupFound = true;
														break;
													}
												}
												if ( !bGroupFound )
												{
													contact = service.Get(sSYNC_REMOTE_KEY) as ContactEntry;
													GroupMembership group = new GroupMembership();
													group.HRef = sSplendidGroupURI;
													contact.GroupMembership.Add(group);
													bChanged = true;
													ContactsResource.UpdateRequest reqUpdate = service.Contacts.Update(contact, contact.IdOnly);
													contact = reqUpdate.Execute();
												}
												*/
											}
										}
										if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
										{
											if ( contact != null )
											{
												// 03/25/2010 Paul.  Update the modified date after the save. 
												// 03/26/2011 Paul.  Updated is in local time. 
												DateTime dtREMOTE_DATE_MODIFIED     = contact.Updated.Value;
												DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														// 03/26/2010 Paul.  Make sure to set the Sync flag. 
														// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
														// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
														SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sSYNC_REMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Google", String.Empty, trn);
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
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Unsyncing contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " for " + gUSER_ID.ToString());
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gID, sSYNC_REMOTE_KEY, "Google", trn);
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
										string sError = "Error creating Google contact " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + " for " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
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
					
					// 03/28/2011 Paul.  Contacts that have been unsync'd need to be removed from the SplendidCRM group. 
					// 03/28/2011 Paul.  Don't need this logic. 
					/*
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
					sSQL = "select vwCONTACTS.ID                                                              " + ControlChars.CrLf
					     + "     , vwCONTACTS.FIRST_NAME                                                      " + ControlChars.CrLf
					     + "     , vwCONTACTS.LAST_NAME                                                       " + ControlChars.CrLf
					     + "     , vwCONTACTS_SYNC.SYNC_REMOTE_KEY                                            " + ControlChars.CrLf
					     + "  from            vwCONTACTS                                                      " + ControlChars.CrLf
					     + "       inner join CONTACTS_USERS                                                  " + ControlChars.CrLf
					     + "               on CONTACTS_USERS.CONTACT_ID             = vwCONTACTS.ID           " + ControlChars.CrLf
					     + "              and CONTACTS_USERS.USER_ID                = @SYNC_USER_ID           " + ControlChars.CrLf
					     + "              and CONTACTS_USERS.DELETED                = 1                       " + ControlChars.CrLf
					     + "       inner join vwCONTACTS_SYNC                                                 " + ControlChars.CrLf
					     + "               on vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'Google'               " + ControlChars.CrLf
					     + "              and vwCONTACTS_SYNC.SYNC_LOCAL_ID         = vwCONTACTS.ID           " + ControlChars.CrLf
					     + "              and vwCONTACTS_SYNC.SYNC_ASSIGNED_USER_ID = CONTACTS_USERS.USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SYNC_USER_ID", gUSER_ID);
						ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
						
						// 03/28/2011 Paul.  In this case, we are looking for relationship records that were modified after the sync date. 
						// We don't want to use the Contact date because the contact will likely be edited many times after being unsync'd. 
						cmd.CommandText += "   and CONTACTS_USERS.DATE_MODIFIED_UTC > vwCONTACTS_SYNC.SYNC_LOCAL_DATE_MODIFIED_UTC" + ControlChars.CrLf;
						cmd.CommandText += " order by vwCONTACTS.DATE_MODIFIED_UTC" + ControlChars.CrLf;
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								if ( dt.Rows.Count > 0 )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: " + dt.Rows.Count.ToString() + " contacts to remove from group " + gUSER_ID.ToString());
								foreach ( DataRow row in dt.Rows )
								{
									Guid   gSYNC_LOCAL_ID   = Sql.ToGuid  (row["ID"             ]);
									string sSYNC_REMOTE_KEY = Sql.ToString(row["SYNC_REMOTE_KEY"]);
									try
									{
										ContactEntry contact = service.Get(sSYNC_REMOTE_KEY) as ContactEntry;
										foreach ( GroupMembership group in contact.GroupMembership )
										{
											if ( group.HRef == sSplendidGroupURI )
											{
												contact.GroupMembership.Remove(group);
												break;
											}
										}
										ContactsResource.UpdateRequest reqUpdate = service.Contacts.Update(contact, contact.IdOnly);
										contact = reqUpdate.Execute();
									}
									catch(Exception ex)
									{
										string sError = "Error clearing Google groups for contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " from " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
									}
									try
									{
										if ( bVERBOSE_STATUS )
											SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncContacts: Deleting sync contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " from " + gUSER_ID.ToString());
										using ( IDbTransaction trn = Sql.BeginTransaction(con) )
										{
											try
											{
												// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
												SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sSYNC_REMOTE_KEY, "Google", trn);
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
										string sError = "Error deleting sync contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " from " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
										sError += Utils.ExpandException(ex) + ControlChars.CrLf;
										SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
										sbErrors.AppendLine(sError);
									}
								}
							}
						}
					}
					*/
				}
			}
			catch(Exception ex)
			{
				string sMESSAGE = "SyncContacts: " + gUSER_ID.ToString() + ": " + Utils.ExpandException(ex);
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
				sbErrors.AppendLine(sMESSAGE);
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
			
			EmailValue eEMAIL1 = null;
			EmailValue eEMAIL2 = null;
			foreach ( EmailValue email in contact.Emails )
			{
				if ( ((email.Primary.HasValue && email.Primary.Value) || email.Rel == "http://schemas.google.com/g/2005#work" || contact.Emails.Count == 1) && eEMAIL1 == null )
					eEMAIL1 = email;
				else if ( email.Rel == "http://schemas.google.com/g/2005#other" && eEMAIL2 == null )
					eEMAIL2 = email;
			}
			
			OrganizationValue orgACCOUNT_NAME = null;
			if ( contact.Organizations != null )
			{
				foreach ( OrganizationValue org in contact.Organizations )
				{
					// 04/16/2011 Paul.  Google does not set the default company/title fields to Primary. 
					// 09/18/2015 Paul.  If there is only one organization, then it is the primary. 
					if ( (org.Primary.HasValue && org.Primary.Value) || org.Rel == "http://schemas.google.com/g/2005#work" || contact.Organizations.Count == 1 )
					{
						orgACCOUNT_NAME = org;
						break;
					}
				}
			}
			//Relation relASSISTANT = null;
			//foreach ( Relation rel in contact.Relations )
			//{
			//	// 04/16/2011 Paul.  Google is not setting the relationship type properly.  It is just using the name, not the namespace. 
			//	if ( rel.Rel == "http://schemas.google.com/g/2005#assistant" || rel.Rel == "assistant" )
			//	{
			//		relASSISTANT = rel;
			//		break;
			//	}
			//}
			
			PhoneNumberValue phASSISTANT_PHONE = null;
			PhoneNumberValue phPHONE_FAX       = null;
			PhoneNumberValue phPHONE_WORK      = null;
			PhoneNumberValue phPHONE_MOBILE    = null;
			PhoneNumberValue phPHONE_OTHER     = null;
			PhoneNumberValue phPHONE_HOME      = null;
			if ( contact.PhoneNumbers != null )
			{
				foreach ( PhoneNumberValue phone in contact.PhoneNumbers )
				{
					if      ( phone.Rel == "http://schemas.google.com/g/2005#assistant" && phASSISTANT_PHONE == null ) phASSISTANT_PHONE = phone;
					// 04/16/2011 Paul.  We are going to use WorkFax instead of just Fax. 
					else if ( phone.Rel == "http://schemas.google.com/g/2005#work_fax"  && phPHONE_FAX       == null ) phPHONE_FAX       = phone;
					else if ( phone.Rel == "http://schemas.google.com/g/2005#work"      && phPHONE_WORK      == null ) phPHONE_WORK      = phone;
					else if ( phone.Rel == "http://schemas.google.com/g/2005#mobile"    && phPHONE_MOBILE    == null ) phPHONE_MOBILE    = phone;
					else if ( phone.Rel == "http://schemas.google.com/g/2005#other"     && phPHONE_OTHER     == null ) phPHONE_OTHER     = phone;
					else if ( phone.Rel == "http://schemas.google.com/g/2005#home"      && phPHONE_HOME      == null ) phPHONE_HOME      = phone;
				}
			}
			
			// 08/26/2011 Paul.  Geocoding API V3 allows us to select long or short names. 
			bool bShortStateName   = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortStateName"  ]);
			bool bShortCountryName = Sql.ToBoolean(Application["CONFIG.GoogleMaps.ShortCountryName"]);
			StructuredPostalAddress adrPRIMARY_ADDRESS = null;
			StructuredPostalAddress adrALT_ADDRESS     = null;
			if ( contact.StructuredPostalAddresses != null )
			{
				foreach ( StructuredPostalAddress adr in contact.StructuredPostalAddresses )
				{
					if ( !Sql.IsEmptyString(adr.FormattedAddress) )
					{
						if ( Sql.IsEmptyString(adr.Street    )
						  && Sql.IsEmptyString(adr.City      )
						  && Sql.IsEmptyString(adr.State     )
						  && Sql.IsEmptyString(adr.PostalCode)
						  && Sql.IsEmptyString(adr.Country   )
						   )
						{
							// 08/26/2011 Paul.  Geocoding API V3 does not require a key. 
							//string sGoogleMapsKey = Sql.ToString(Application["CONFIG.GoogleMaps.Key"]);
							//if ( !Sql.IsEmptyString(sGoogleMapsKey) )
							{
								AddressDetails info = new AddressDetails();
								// 04/16/2011 Paul.  We should consider caching the address with the FormattedAddress as the key. 
								// It may not be an issue as a change in the CRM would update Google andd it should split-out the addresses. 
								GoogleUtils.ConvertAddressV3(adr.FormattedAddress, bShortStateName, bShortCountryName, ref info);
								adr.Street     = info.ADDRESS_STREET    ;
								adr.City       = info.ADDRESS_CITY      ;
								adr.State      = info.ADDRESS_STATE     ;
								adr.PostalCode = info.ADDRESS_POSTALCODE;
								adr.Country    = info.ADDRESS_COUNTRY   ;
								// 04/16/2011 Paul.  We have noticed that GoogleMaps is not returning a valid address and city for a completely valid VA address. 
								// The Accuracy is being returned as 6, but the Street and City are blank.  In that case, store everything in the Street field. 
								// 08/26/2011 Paul.  The solution is to use the Geocoding API V3. 
								//if ( info.Accuracy >= 6 && Sql.IsEmptyString(info.ADDRESS_STREET) && Sql.IsEmptyString(info.ADDRESS_CITY) )
								//	adr.Street = adr.FormattedAddress;
							}
							//else
							//{
							//	// 04/16/2011 Paul.  If we are unable to use GoogleMaps, then place the formatted address in the Address field. 
							//	adr.Street = adr.FormattedAddress;
							//}
						}
					}
					if      ( adr.Rel == "http://schemas.google.com/g/2005#work"  && adrPRIMARY_ADDRESS == null ) adrPRIMARY_ADDRESS = adr;
					else if ( adr.Rel == "http://schemas.google.com/g/2005#other" && adrALT_ADDRESS     == null ) adrALT_ADDRESS     = adr;
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
							//case "BIRTHDATE"                 :  oValue = Sql.ToDBDateTime(contact.Birthday);  break;
							case "FIRST_NAME"                :  if ( contact.Name       != null ) oValue = Sql.ToDBString(contact.Name.FirstName    );  break;
							case "LAST_NAME"                 :  if ( contact.Name       != null ) oValue = Sql.ToDBString(contact.Name.LastName     );  else if ( contact.Title != null ) oValue = Sql.ToDBString(contact.Title);  break;
							case "DESCRIPTION"               :  oValue = (contact.Notes      != null) ? Sql.ToDBString(contact.Notes                ) : String.Empty;  break;
							//case "ASSISTANT"                 :  oValue = (relASSISTANT       != null) ? Sql.ToDBString(relASSISTANT    .Value      ) : String.Empty;  break;
								// 01/28/2012 Paul.  ACCOUNT_NAME does not exist in the spCONTACTS_Update stored procedure.  It is a special case that requires a lookup. 
							//case "ACCOUNT_NAME"              :  oValue = (orgACCOUNT_NAME    != null) ? Sql.ToDBString(orgACCOUNT_NAME.Name        ) : String.Empty;  break;
							case "DEPARTMENT"                :  oValue = (orgACCOUNT_NAME    != null) ? Sql.ToDBString(orgACCOUNT_NAME.Department   ) : String.Empty;  break;
							case "TITLE"                     :  oValue = (orgACCOUNT_NAME    != null) ? Sql.ToDBString(orgACCOUNT_NAME.Title        ) : String.Empty;  break;
							case "EMAIL1"                    :  oValue = (eEMAIL1            != null) ? Sql.ToDBString(eEMAIL1           .Address   ) : String.Empty;  break;
							case "EMAIL2"                    :  oValue = (eEMAIL2            != null) ? Sql.ToDBString(eEMAIL2           .Address   ) : String.Empty;  break;
							case "ASSISTANT_PHONE"           :  oValue = (phASSISTANT_PHONE  != null) ? Sql.ToDBString(phASSISTANT_PHONE .Value     ) : String.Empty;  break;
							case "PHONE_FAX"                 :  oValue = (phPHONE_FAX        != null) ? Sql.ToDBString(phPHONE_FAX       .Value     ) : String.Empty;  break;
							case "PHONE_WORK"                :  oValue = (phPHONE_WORK       != null) ? Sql.ToDBString(phPHONE_WORK      .Value     ) : String.Empty;  break;
							case "PHONE_MOBILE"              :  oValue = (phPHONE_MOBILE     != null) ? Sql.ToDBString(phPHONE_MOBILE    .Value     ) : String.Empty;  break;
							case "PHONE_OTHER"               :  oValue = (phPHONE_OTHER      != null) ? Sql.ToDBString(phPHONE_OTHER     .Value     ) : String.Empty;  break;
							case "PHONE_HOME"                :  oValue = (phPHONE_HOME       != null) ? Sql.ToDBString(phPHONE_HOME      .Value     ) : String.Empty;  break;
							case "PRIMARY_ADDRESS_STREET"    :  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.Street    ) : String.Empty;  break;
							case "PRIMARY_ADDRESS_CITY"      :  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.City      ) : String.Empty;  break;
							case "PRIMARY_ADDRESS_STATE"     :  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.State     ) : String.Empty;  break;
							case "PRIMARY_ADDRESS_POSTALCODE":  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.PostalCode) : String.Empty;  break;
							case "PRIMARY_ADDRESS_COUNTRY"   :  oValue = (adrPRIMARY_ADDRESS != null) ? Sql.ToDBString(adrPRIMARY_ADDRESS.Country   ) : String.Empty;  break;
							case "ALT_ADDRESS_STREET"        :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .Street    ) : String.Empty;  break;
							case "ALT_ADDRESS_CITY"          :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .City      ) : String.Empty;  break;
							case "ALT_ADDRESS_STATE"         :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .State     ) : String.Empty;  break;
							case "ALT_ADDRESS_POSTALCODE"    :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .PostalCode) : String.Empty;  break;
							case "ALT_ADDRESS_COUNTRY"       :  oValue = (adrALT_ADDRESS     != null) ? Sql.ToDBString(adrALT_ADDRESS    .Country   ) : String.Empty;  break;
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
							string sGOOGLE_ACCOUNT_NAME = (orgACCOUNT_NAME != null) ? orgACCOUNT_NAME.Name : String.Empty;
							if ( String.Compare(sACCOUNT_NAME, sGOOGLE_ACCOUNT_NAME, true) != 0 )
							{
								gACCOUNT_ID   = Guid.Empty;
								sACCOUNT_NAME = sGOOGLE_ACCOUNT_NAME;
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
												, (phPHONE_FAX        != null) ? Sql.ToString(phPHONE_FAX       .Value     ) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.Street    ) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.City      ) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.State     ) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.PostalCode) : String.Empty
												, (adrPRIMARY_ADDRESS != null) ? Sql.ToString(adrPRIMARY_ADDRESS.Country   ) : String.Empty
												, "Account created from Google Apps contact " + (contact.Name != null ? Sql.ToString(contact.Name.FullName) : String.Empty)
												, String.Empty  // RATING
												, (phPHONE_WORK       != null) ? Sql.ToString(phPHONE_WORK      .Value     ) : String.Empty  // PHONE_OFFICE
												, String.Empty  // PHONE_ALTERNATE
												, (eEMAIL1            != null) ? Sql.ToString(eEMAIL1           .Address   ) : String.Empty
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

		public void ImportContact(ExchangeSession Session, ContactsService service, IDbConnection con, Guid gUSER_ID, string sSplendidGroupURI, Contact contact, StringBuilder sbErrors)
		{
			bool   bVERBOSE_STATUS      = Sql.ToBoolean(Application["CONFIG.GoogleApps.VerboseStatus"     ]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.GoogleApps.ConflictResolution"]);
			Guid   gTEAM_ID             = Sql.ToGuid   (Session["TEAM_ID"]);
			
			IDbCommand spCONTACTS_Update = SqlProcs.Factory(con, "spCONTACTS_Update");

			// 03/26/2011 Paul.  contact.Name is not always available, so use the AbsoluteUri instead. 
			string   sREMOTE_KEY  = contact.IdOnly;
			string   sContactName = sREMOTE_KEY;
			if ( contact.Name != null && !Sql.IsEmptyString(contact.Name.FullName) )
			{
				sContactName = contact.Name.FullName;
			}
			else if ( contact.Title != null )
			{
				sContactName = contact.Title;
			}
			// 03/26/2011 Paul.  Updated is in local time. 
			DateTime dtREMOTE_DATE_MODIFIED     = contact.Updated.Value;
			DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();

			String sSQL = String.Empty;
			sSQL = "select SYNC_ID                                       " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_DATE_MODIFIED_UTC                  " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_DATE_MODIFIED_UTC                 " + ControlChars.CrLf
			     + "     , SYNC_CONTACT                                  " + ControlChars.CrLf
			     + "     , ID                                            " + ControlChars.CrLf
			     + "     , DATE_MODIFIED_UTC                             " + ControlChars.CrLf
			     + "  from vwCONTACTS_SYNC                               " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'Google'             " + ControlChars.CrLf
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
							// 03/28/2010 Paul.  If the ID is NULL and the LOCAL_ID is NOT NULL, then the local item must have been deleted. 
							// 03/29/2010 Paul.  If ID and LOCAL_ID are valid, but SYNC_CONTACT is not, then the user has stopped syncing the contact. 
							if ( (Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID)) || (!Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID) && !bSYNC_CONTACT) )
							{
								sSYNC_ACTION = "local deleted";
							}
							// 03/26/2011 Paul.  The Google remote date can vary by 1 millisecond, so check for local change first. 
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
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
								// 03/26/2011 Paul.  The Google remote date can vary by 1 millisecond, so check for local change first. 
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
								if ( contact.Deleted )
								{
									sSYNC_ACTION = "remote deleted";
								}
							}
							// 03/26/2011 Paul.  The Google remote date can vary by 1 millisecond, so check for local change first. 
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) )
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
						else if ( contact.Deleted )
						{
							sSYNC_ACTION = "remote deleted";
						}
						else
						{
							sSYNC_ACTION = "remote new";
							
							// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to Google. 
							// 03/28/2010 Paul.  We need to prevent duplicate Google entries from attaching to an existing mapped Contact ID. 
							// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
							cmd.Parameters.Clear();
							sSQL = "select vwCONTACTS.ID             " + ControlChars.CrLf
							     + "  from            vwCONTACTS     " + ControlChars.CrLf
							     + "  left outer join vwCONTACTS_SYNC" + ControlChars.CrLf
							     + "               on vwCONTACTS_SYNC.SYNC_SERVICE_NAME     = N'Google'             " + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf
							     + "              and vwCONTACTS_SYNC.SYNC_LOCAL_ID         = vwCONTACTS.ID         " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Contacts", "view");
							if ( contact.Emails != null )
							{
								foreach ( EmailValue email in contact.Emails )
								{
									if ( (email.Primary.HasValue && email.Primary.Value) || email.Rel == "http://schemas.google.com/g/2005#work" || contact.Emails.Count == 1 )
									{
										Sql.AppendParameter(cmd, Sql.ToString(email.Address), "EMAIL1");
										break;
									}
								}
							}
							else if ( contact.Name != null )
							{
								if ( Sql.IsEmptyString(contact.Name.FirstName) && Sql.IsEmptyString(contact.Name.LastName) )
								{
									Sql.AppendParameter(cmd, Sql.ToString(contact.Name.FullName), "NAME");
								}
								else
								{
									Sql.AppendParameter(cmd, Sql.ToString(contact.Name.FirstName), "FIRST_NAME");
									Sql.AppendParameter(cmd, Sql.ToString(contact.Name.LastName ), "LAST_NAME" );
								}
							}
							else if ( contact.Title != null )
							{
								Sql.AppendParameter(cmd, Sql.ToString(contact.Title), "NAME");
							}
							cmd.CommandText += "   and vwCONTACTS_SYNC.ID is null" + ControlChars.CrLf;
							gID = Sql.ToGuid(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyGuid(gID) )
							{
								// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to Google. 
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
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									if ( bVERBOSE_STATUS )
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Retrieving contact " + sContactName + " from " + gUSER_ID.ToString());
									
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
									SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Google", String.Empty, trn);
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
							// 03/25/2010 Paul.  If we find a contact, then treat the CRM record as the master and send latest version over to Google. 
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
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Syncing contact " + Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]) + " to " + gUSER_ID.ToString());
									bool bChanged = this.SetGoogleContact(contact, row, sbChanges);
									if ( bChanged )
									{
										ContactEntry entry = new ContactEntry();
										entry.Entry = contact;
										ContactsResource.UpdateRequest reqUpdate = service.Contacts.Update(entry, contact.IdOnly);
										entry = reqUpdate.Execute();
										contact = entry.Entry;
										//contact = service.Get(contact.Id.AbsoluteUri) as ContactEntry;
									}
									// 03/25/2010 Paul.  Update the modified date after the save. 
									// 03/26/2011 Paul.  Updated is in local time. 
									dtREMOTE_DATE_MODIFIED     = contact.Updated.Value;
									dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED_UTC.ToUniversalTime();
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 03/26/2010 Paul.  Make sure to set the Sync flag. 
											// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
											// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
											SqlProcs.spCONTACTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Google", String.Empty, trn);
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
									string sError = "Error saving " + Sql.ToString  (row["FIRST_NAME"]) + " " + Sql.ToString  (row["LAST_NAME"]) + " " + Sql.ToString  (row["EMAIL1"]) + " to " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
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
								if ( contact.GroupMemberships != null )
								{
									foreach ( GroupMembership group in contact.GroupMemberships )
									{
										if ( group.Href == sSplendidGroupURI )
										{
											contact.GroupMemberships.Remove(group);
											break;
										}
									}
								}
								ContactEntry entry = new ContactEntry();
								entry.Entry = contact;
								ContactsResource.UpdateRequest reqUpdate = service.Contacts.Update(entry, contact.IdOnly);
								entry = reqUpdate.Execute();
								contact = entry.Entry;
							}
							catch(Exception ex)
							{
								string sError = "Error clearing Google groups for " + sContactName + " from " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							try
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Deleting " + sContactName + " from " + gUSER_ID.ToString());
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
										SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sREMOTE_KEY, "Google", trn);
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
								string sError = "Error deleting " + sContactName + " from " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
						}
						else if ( sSYNC_ACTION == "remote deleted" && !Sql.IsEmptyGuid(gID) )
						{
							if ( bVERBOSE_STATUS )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "ImportContact: Unsyncing contact " + sContactName + " for " + gUSER_ID.ToString());
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spCONTACTS_SYNC_Delete(gUSER_ID, gID, sREMOTE_KEY, "Google", trn);
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
		}
		#endregion

		#region Sync Appointments
		private DataTable AppointmentEmails(IDbConnection con, Guid gID)
		{
			DataTable dtAppointmentEmails = new DataTable();
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					string sSQL;
					// 01/14/2012 Paul.  vwAPPOINTMENTS_EMAIL1 was modified to allow contacts without email addresses.  Google does not. 
					// 03/11/2012 Paul.  ExchangeSync needs the name in its check for added or removed attendees. 
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

		private bool SetGoogleAppointment(Event appointment, DataRow row, DataTable dtAppointmentEmails, StringBuilder sbChanges, bool bDISABLE_PARTICIPANTS, Guid gUSER_ID)
		{
			bool bChanged = false;
			// 09/14/2015 Paul. Google requires the timezone. 
			string sTIME_ZONE = "America/New_York";
			Guid gTIMEZONE = Sql.ToGuid(Application["CONFIG.default_timezone"]);
			TimeZone T10z = Application["TIMEZONE." + gTIMEZONE.ToString()] as SplendidCRM.TimeZone;
			if ( T10z != null && !Sql.IsEmptyString(T10z.TZID) )
				sTIME_ZONE = T10z.TZID;
			if ( Sql.IsEmptyString(appointment.Summary) )
			{
				// 03/28/2010 Paul.  You must load or assign this property before you can read its value. 
				// So set all the fields to empty values. 
				//appointment.Categories.Add("SplendidCRM");
				appointment.Summary     = Sql.ToString(row["NAME"       ]);
				appointment.Location    = Sql.ToString(row["LOCATION"   ]);
				appointment.Description = Sql.ToString(row["DESCRIPTION"]);
				
				// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  Google stores the reminder in minutes. 
				// 02/20/2013 Paul.  Don't set the reminder for old appointments, but include appointments for today. 
				int      nREMINDER_TIME       = Sql.ToInteger (row["REMINDER_TIME"      ]) / 60;
				int      nEMAIL_REMINDER_TIME = Sql.ToInteger (row["EMAIL_REMINDER_TIME"]) / 60;
				DateTime dtDATE_START         = Sql.ToDateTime(row["DATE_START"         ]);
				DateTime dtDATE_END           = Sql.ToDateTime(row["DATE_END"           ]);
				string   sSTATUS              = Sql.ToString  (row["STATUS"             ]);
				if ( (nREMINDER_TIME > 0 || nEMAIL_REMINDER_TIME > 0) && Sql.ToDateTime(row["DATE_START"]).AddHours(-12) >= DateTime.Now )
				{
					appointment.Reminders = new Event.RemindersData();
					if ( nREMINDER_TIME == 30 && nEMAIL_REMINDER_TIME == 10 )
					{
						appointment.Reminders.UseDefault = true;
					}
					else
					{
						appointment.Reminders.Overrides = new List<EventReminder>();
						if ( nREMINDER_TIME       > 0 ) appointment.Reminders.Overrides.Add(new EventReminder { Method = "popup", Minutes = nREMINDER_TIME       });
						if ( nEMAIL_REMINDER_TIME > 0 ) appointment.Reminders.Overrides.Add(new EventReminder { Method = "email", Minutes = nEMAIL_REMINDER_TIME });
						
					}
				}
				else
				{
					// 04/16/2011 Paul.  Setting the Reminder to NULL is throwing an error "Object reference not set to an instance of an object". 
					// The exception is thrown even if Reminder is already NULL.  
					appointment.Reminders = null;
				}
				
				appointment.Start = new EventDateTime();
				appointment.End   = new EventDateTime();
				// 03/10/2013 Paul.  Add ALL_DAY_EVENT. 
				if ( Sql.ToBoolean(row["ALL_DAY_EVENT"]) )
				{
					appointment.Start.Date     = dtDATE_START.ToString("yyyy-MM-dd");
					appointment.End.Date       = dtDATE_END  .ToString("yyyy-MM-dd");
					appointment.Start.DateTime = null;
					appointment.End.DateTime   = null;
				}
				else
				{
					appointment.Start.TimeZone = sTIME_ZONE  ;
					appointment.Start.DateTime = dtDATE_START;
					appointment.End.TimeZone   = sTIME_ZONE  ;
					appointment.End.DateTime   = dtDATE_END  ;
				}
				switch ( sSTATUS )
				{
					case "Not held" :  appointment.Status = GoogleApps.EventStatus.CANCELLED;  break;
					case "Confirmed":  appointment.Status = GoogleApps.EventStatus.CONFIRMED;  break;
					case "Planned"  :  appointment.Status = GoogleApps.EventStatus.TENTATIVE;  break;
					default         :  appointment.Status = GoogleApps.EventStatus.CONFIRMED;  break;
				}
				
				// 03/23/2013 Paul.  Add recurrence data. 
				appointment.Recurrence = null;
				if ( !Sql.IsEmptyString(row["REPEAT_TYPE"]) )
				{
					// http://www.ietf.org/rfc/rfc2445.txt
					//String recurData = "DTSTART;VALUE=DATE:20070501\r\n"
					//	+ "DTEND;VALUE=DATE:20070502\r\n"
					//	+ "RRULE:FREQ=WEEKLY;BYDAY=Tu;UNTIL=20070904\r\n";
					string sRRULE = String.Empty;
					// 03/25/2013 Paul.  The time is placed here because it is removed from the Times array. 
					// 09/14/2015 Paul.  Google Calendar API v3 does not use DTSTART and DTEND. 
					//if ( Sql.ToBoolean(row["ALL_DAY_EVENT"]) )
					//{
					//	sRRULE += "DTSTART:" + dtDATE_START.ToString("yyyyMMdd") + "\r\n";
					//	sRRULE += "DTEND:"   + dtDATE_END  .ToString("yyyyMMdd") + "\r\n";
					//}
					//else
					//{
					//	sRRULE += "DTSTART:" + dtDATE_START.ToUniversalTime().ToString("yyyyMMddTHHmmss") + "Z" + "\r\n";
					//	sRRULE += "DTEND:"   + dtDATE_END  .ToUniversalTime().ToString("yyyyMMddTHHmmss") + "Z" + "\r\n";
					//}
					sRRULE += SplendidCRM.Utils.CalDAV_BuildRule(Sql.ToString(row["REPEAT_TYPE"]), Sql.ToInteger(row["REPEAT_INTERVAL"]), Sql.ToString(row["REPEAT_DOW"]), Sql.ToDateTime(row["REPEAT_UNTIL"]), Sql.ToInteger(row["REPEAT_COUNT"]));
					if ( sRRULE.Contains("RRULE") )
					{
						appointment.Recurrence = new List<string>();
						appointment.Recurrence.Add(sRRULE);
					}
				}
				
				// 03/23/2013 Paul.  Add the ability to disable participants. 
				if ( !bDISABLE_PARTICIPANTS )
				{
					appointment.Attendees = null;
					if ( dtAppointmentEmails.Rows.Count > 0 )
					{
						appointment.Attendees = new List<EventAttendee>();
						foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
						{
							EventAttendee guest = new EventAttendee();
							guest.Email       = Sql.ToString  (rowEmail["EMAIL1"  ]);
							guest.DisplayName = Sql.ToString  (rowEmail["NAME"    ]);
							guest.Optional    = !Sql.ToBoolean(rowEmail["REQUIRED"]);
							switch ( Sql.ToString(rowEmail["ACCEPT_STATUS"]) )
							{
								case "accept"   :  guest.ResponseStatus = "accepted"   ;  break;
								case "decline"  :  guest.ResponseStatus = "declined"   ;  break;
								case "tentative":  guest.ResponseStatus = "tentative"  ;  break;
								case "none"     :  guest.ResponseStatus = "needsAction";  break;
								default         :  guest.ResponseStatus = "needsAction";  break;
							}
							guest.Organizer = (gUSER_ID == Sql.ToGuid(rowEmail["ASSIGNED_USER_ID"]));
							appointment.Attendees.Add(guest);
						}
					}
				}
				bChanged = true;
			}
			else
			{
				// 03/25/2013 Paul.  For a recurring appointment, the times array is empty. 
				// We will fix this immediately after the appointment is retrieved. 
				//GoogleUitls.FixAppointmentTimes(appointment);

				// 03/29/2010 Paul.  Lets not always add the SplendidCRM category, but only do it during creation. 
				// This should not be an issue as we currently do not lookup the Exchange user when creating a appointment that originated from the CRM. 
				//if ( !appointment.Categories.Contains("SplendidCRM") )
				//{
				//	appointment.Categories.Add("SplendidCRM");
				//	bChanged = true;
				//}

				if ( Sql.ToString(appointment.Description) != Sql.ToString(row["DESCRIPTION"]) )
				{
					appointment.Description = Sql.ToString(row["DESCRIPTION"]);
					bChanged = true;
					sbChanges.AppendLine("DESCRIPTION changed.");
				}
				if ( Sql.ToString(appointment.Summary ) != Sql.ToString(row["NAME"]) )
				{
					appointment.Summary = Sql.ToString(row["NAME"]);
					bChanged = true;
					sbChanges.AppendLine("NAME changed.");
				}
				
				if ( Sql.ToString(appointment.Location) != Sql.ToString(row["LOCATION"]) )
				{
					appointment.Location = Sql.ToString(row["LOCATION"]);
					bChanged = true;
					sbChanges.AppendLine("LOCATION changed.");
				}
				// 03/29/2010 Paul.  Google will use UTC. 
				int      nREMINDER_TIME       = Sql.ToInteger (row["REMINDER_TIME"      ]) / 60;
				int      nEMAIL_REMINDER_TIME = Sql.ToInteger (row["EMAIL_REMINDER_TIME"]) / 60;
				DateTime dtDATE_START         = Sql.ToDateTime(row["DATE_START"         ]);
				DateTime dtDATE_END           = Sql.ToDateTime(row["DATE_END"           ]);
				if ( Sql.ToBoolean(row["ALL_DAY_EVENT"]) )
				{
					if ( appointment.Start.Date != dtDATE_START.ToString("yyyy-MM-dd") )
						sbChanges.AppendLine("DATE_START changed.");
					if ( appointment.End.Date != dtDATE_END.ToString("yyyy-MM-dd") )
						sbChanges.AppendLine("DATE_END changed.");
					appointment.Start = new EventDateTime();
					appointment.End   = new EventDateTime();
					appointment.Start.Date = dtDATE_START.ToString("yyyy-MM-dd");
					appointment.End.Date   = dtDATE_END  .ToString("yyyy-MM-dd");
				}
				else
				{
					if ( !appointment.Start.DateTime.HasValue )
					{
						bChanged = true;
						sbChanges.AppendLine("ALL_DAY_EVENT changed.");
					}
					if ( !appointment.Start.DateTime.HasValue || appointment.Start.Date != dtDATE_START.ToString("yyyy-MM-dd") )
						sbChanges.AppendLine("DATE_START changed.");
					if ( !appointment.End.DateTime.HasValue || appointment.End.Date != dtDATE_END.ToString("yyyy-MM-dd") )
						sbChanges.AppendLine("DATE_END changed.");
					appointment.Start = new EventDateTime();
					appointment.End   = new EventDateTime();
					appointment.Start.TimeZone = sTIME_ZONE  ;
					appointment.Start.DateTime = dtDATE_START;
					appointment.End.TimeZone   = sTIME_ZONE  ;
					appointment.End.DateTime   = dtDATE_END  ;
				}
				
				int nEXISTING_REMINDER_TIME       = 0;
				int nEXISTING_EMAIL_REMINDER_TIME = 0;
				if ( appointment.Reminders != null )
				{
					if ( appointment.Reminders.Overrides != null )
					{
						foreach ( EventReminder reminder in appointment.Reminders.Overrides )
						{
							if      ( reminder.Method == "popup" && reminder.Minutes.HasValue ) nEXISTING_REMINDER_TIME       = reminder.Minutes.Value;
							else if ( reminder.Method == "email" && reminder.Minutes.HasValue ) nEXISTING_EMAIL_REMINDER_TIME = reminder.Minutes.Value;
						}
					}
					else if ( appointment.Reminders.UseDefault.HasValue && appointment.Reminders.UseDefault.Value )
					{
						nEXISTING_REMINDER_TIME       = 30;
						nEXISTING_EMAIL_REMINDER_TIME = 10;
					}
				}
				if ( nEXISTING_REMINDER_TIME != nREMINDER_TIME )
				{
					bChanged = true;
					sbChanges.AppendLine("REMINDER_TIME changed.");
				}
				if ( nEXISTING_EMAIL_REMINDER_TIME != nEMAIL_REMINDER_TIME )
				{
					bChanged = true;
					sbChanges.AppendLine("EMAIL_REMINDER_TIME changed.");
				}
				// 04/23/2010 Paul.  REMINDER_TIME is in seconds.  Google stores the reminder in minutes. 
				if ( (nREMINDER_TIME > 0 || nEMAIL_REMINDER_TIME > 0) && Sql.ToDateTime(row["DATE_START"]).AddHours(-12) >= DateTime.Now )
				{
					appointment.Reminders = new Event.RemindersData();
					if ( nREMINDER_TIME == 30 && nEMAIL_REMINDER_TIME == 10 )
					{
						appointment.Reminders.UseDefault = true;
					}
					else
					{
						appointment.Reminders.Overrides = new List<EventReminder>();
						if ( nREMINDER_TIME       > 0 ) appointment.Reminders.Overrides.Add(new EventReminder { Method = "popup", Minutes = nREMINDER_TIME       });
						if ( nEMAIL_REMINDER_TIME > 0 ) appointment.Reminders.Overrides.Add(new EventReminder { Method = "email", Minutes = nEMAIL_REMINDER_TIME });
						
					}
				}
				else
				{
					// 04/16/2011 Paul.  Setting the Reminder to NULL is throwing an error "Object reference not set to an instance of an object". 
					// The exception is thrown even if Reminder is already NULL.  
					appointment.Reminders = null;
				}
				// 03/23/2013 Paul.  Add recurrence data. 
				if ( !Sql.IsEmptyString(row["REPEAT_TYPE"]) )
				{
					// http://www.ietf.org/rfc/rfc2445.txt
					//String recurData = "DTSTART;VALUE=DATE:20070501\r\n"
					//	+ "DTEND;VALUE=DATE:20070502\r\n"
					//	+ "RRULE:FREQ=WEEKLY;BYDAY=Tu;UNTIL=20070904\r\n";
					string sRRULE = String.Empty;
					// 03/25/2013 Paul.  The time is placed here because it is removed from the Times array. 
					// 09/14/2015 Paul.  Google Calendar API v3 does not use DTSTART and DTEND. 
					//if ( Sql.ToBoolean(row["ALL_DAY_EVENT"]) )
					//{
					//	sRRULE += "DTSTART:" + appointment.Start.Date.Replace("-", "") + "\r\n";
					//	sRRULE += "DTEND:"   + appointment.End.Date  .Replace("-", "") + "\r\n";
					//}
					//else
					//{
					//	sRRULE += "DTSTART:" + appointment.Start.DateTime.Value.ToUniversalTime().ToString("yyyyMMddTHHmmss") + "Z" + "\r\n";
					//	sRRULE += "DTEND:"   + appointment.End.DateTime  .Value.ToUniversalTime().ToString("yyyyMMddTHHmmss") + "Z" + "\r\n";
					//}
					sRRULE += SplendidCRM.Utils.CalDAV_BuildRule(Sql.ToString(row["REPEAT_TYPE"]), Sql.ToInteger(row["REPEAT_INTERVAL"]), Sql.ToString(row["REPEAT_DOW"]), Sql.ToDateTime(row["REPEAT_UNTIL"]), Sql.ToInteger(row["REPEAT_COUNT"]));
					if ( sRRULE.Contains("RRULE") )
					{
						if ( appointment.Recurrence != null && appointment.Recurrence.Count > 0 )
						{
							if ( sRRULE != appointment.Recurrence[0] )
							{
								bChanged = true;
								sbChanges.AppendLine("RRULE changed.");
							}
						}
						else if ( appointment.Recurrence == null )
						{
							bChanged = true;
							sbChanges.AppendLine("RRULE changed.");
						}
						appointment.Recurrence = new List<string>();
						appointment.Recurrence.Add(sRRULE);
					}
				}
				else
				{
					appointment.Recurrence = null;
				}
				
				// 03/23/2013 Paul.  Add the ability to disable participants. 
				if ( !bDISABLE_PARTICIPANTS )
				{
					if ( dtAppointmentEmails.Rows.Count > 0 )
					{
						bool bParticipantsChanged = false;
						foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
						{
							bool bEmailFound = false;
							string sEmail = Sql.ToString(rowEmail["EMAIL1"]);
							if ( appointment.Attendees != null )
							{
								foreach ( EventAttendee guest in appointment.Attendees )
								{
									if ( sEmail == guest.Email )
									{
										bEmailFound = true;
										if ( !guest.Optional != Sql.ToBoolean(rowEmail["REQUIRED"]) )
										{
											bParticipantsChanged = true;
											break;
										}
										string sACCEPT_STATUS = String.Empty;
										switch ( guest.ResponseStatus )
										{
											case "accepted"   :  sACCEPT_STATUS = "accept"   ;  break;
											case "declined"   :  sACCEPT_STATUS = "decline"  ;  break;
											case "tentative"  :  sACCEPT_STATUS = "tentative";  break;
											case "needsAction":  sACCEPT_STATUS = "none"     ;  break;
										}
										if ( sACCEPT_STATUS != Sql.ToString(rowEmail["ACCEPT_STATUS"]) )
										{
											bParticipantsChanged = true;
											break;
										}
										break;
									}
								}
							}
							if ( !bEmailFound )
							{
								bParticipantsChanged = true;
								break;
							}
						}
						if ( appointment.Attendees != null )
						{
							foreach ( EventAttendee guest in appointment.Attendees )
							{
								// 09/16/2015 Paul.  Exclude creator email as that email may not be in the CRM. 
								if ( appointment.Creator.Email != guest.Email )
								{
									bool bEmailFound = false;
									foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
									{
										string sEmail = Sql.ToString(rowEmail["EMAIL1"]);
										if ( sEmail == guest.Email )
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
							}
						}
						if ( bParticipantsChanged )
						{
							appointment.Attendees = null;
							if ( dtAppointmentEmails.Rows.Count > 0 )
							{
								appointment.Attendees = new List<EventAttendee>();
								foreach ( DataRow rowEmail in dtAppointmentEmails.Rows )
								{
									EventAttendee guest = new EventAttendee();
									guest.Email       = Sql.ToString  (rowEmail["EMAIL1"  ]);
									guest.DisplayName = Sql.ToString  (rowEmail["NAME"    ]);
									guest.Optional    = !Sql.ToBoolean(rowEmail["REQUIRED"]);
									switch ( Sql.ToString(rowEmail["ACCEPT_STATUS"]) )
									{
										case "accept"   :  guest.ResponseStatus = "accepted"   ;  break;
										case "decline"  :  guest.ResponseStatus = "declined"   ;  break;
										case "tentative":  guest.ResponseStatus = "tentative"  ;  break;
										case "none"     :  guest.ResponseStatus = "needsAction";  break;
										default         :  guest.ResponseStatus = "needsAction";  break;
									}
									guest.Organizer = (gUSER_ID == Sql.ToGuid(rowEmail["ASSIGNED_USER_ID"]));
									appointment.Attendees.Add(guest);
								}
							}
							sbChanges.AppendLine("PARTICIPANTS changed.");
						}
					}
					else
					{
						if ( appointment.Attendees.Count > 0 )
						{
							appointment.Attendees = null;
							sbChanges.AppendLine("PARTICIPANTS changed.");
						}
					}
				}
			}
			return bChanged;
		}

		public void SyncAppointments(ExchangeSession Session, CalendarService service, Guid gUSER_ID, bool bSyncAll, StringBuilder sbErrors)
		{
			// 03/23/2013 Paul.  Add the ability to disable participants. 
			bool bDISABLE_PARTICIPANTS = Sql.ToBoolean(Application["CONFIG.GoogleApps.DisableParticipants"]);
			bool bVERBOSE_STATUS       = Sql.ToBoolean(Application["CONFIG.GoogleApps.VerboseStatus"      ]);
			if ( bVERBOSE_STATUS )
				SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + gUSER_ID.ToString());
			// 02/20/2013 Paul.  Reduced the number of days to go back. 
			int  nAPPOINTMENT_AGE_DAYS = Sql.ToInteger(Application["CONFIG.GoogleApps.AppointmentAgeDays"]);
			if ( nAPPOINTMENT_AGE_DAYS == 0 )
				nAPPOINTMENT_AGE_DAYS = 7;
			
			Guid   gTEAM_ID             = Sql.ToGuid   (Session["TEAM_ID"]);
			string sCONFLICT_RESOLUTION = Sql.ToString (Application["CONFIG.GoogleApps.ConflictResolution"]);
			try
			{
				// 09/12/2015 Paul.  Google Calendar API v3 requires a Calendar ID.  We can use Primary or a SplendidCRM-specific calendar. 
				string sCALENDAR_ID = "primary";
				string sGROUP_NAME  = Sql.ToString(Application["CONFIG.GoogleApps.GroupName"]).Trim();
				if ( Sql.IsEmptyString(sGROUP_NAME) )
					sGROUP_NAME = "SplendidCRM";
				if ( sGROUP_NAME.ToLower() != "primary" )
				{
					sCALENDAR_ID = Sql.ToString(Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".CalendarID"]);
					if ( Sql.IsEmptyString(sCALENDAR_ID) )
					{
						try
						{
							CalendarListResource.ListRequest reqCalendars = service.CalendarList.List();
							CalendarList calendars = reqCalendars.Execute();
							if ( calendars.Items != null && calendars.Items.Count > 0 )
							{
								foreach ( CalendarListEntry calendar in calendars.Items )
								{
									//Debug.WriteLine(calendar.Id + " " + calendar.Summary);
									if ( calendar.Summary == sGROUP_NAME )
									{
										sCALENDAR_ID = calendar.Id;
										break;
									}
								}
							}
						}
						catch(Exception ex)
						{
							throw(new Exception("Could not find calendar " + sGROUP_NAME, ex));
						}
						if ( Sql.IsEmptyString(sCALENDAR_ID) )
						{
							try
							{
								Google.Apis.Calendar.v3.Data.Calendar calSplendidCRM = new Google.Apis.Calendar.v3.Data.Calendar();
								calSplendidCRM.Summary = sGROUP_NAME;
								CalendarsResource.InsertRequest reqInsert = service.Calendars.Insert(calSplendidCRM);
								Google.Apis.Calendar.v3.Data.Calendar entSplendidCRM = reqInsert.Execute();
								sCALENDAR_ID = entSplendidCRM.Id;
							}
							catch(Exception ex)
							{
								throw(new Exception("Could not create calendar " + sGROUP_NAME, ex));
							}
						}
						Application["CONFIG.GoogleApps." + gUSER_ID.ToString() + ".CalendarID"] = sCALENDAR_ID;
					}
				}
				if ( Sql.IsEmptyString(sCALENDAR_ID) )
				{
					throw(new Exception("Could not get or create calendar " + sGROUP_NAME));
				}
				
				bool   bPushNotifications   = Sql.ToBoolean(Application["CONFIG.GoogleApps.PushNotifications"  ]);
				string sPushNotificationURL = Sql.ToString (Application["CONFIG.GoogleApps.PushNotificationURL"]);
				// 09/14/2015 Paul.  If the Push URL is empty, then Push will not be used. 
				// 09/14/2015 Paul.  Google only allows secure connections that must be registered. 
				// https://developers.google.com/google-apps/calendar/v3/push
				if ( Sql.IsEmptyString(sPushNotificationURL) || !sPushNotificationURL.StartsWith("https://") )
					bPushNotifications = false;
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL = String.Empty;
					string sSYNC_TOKEN = String.Empty;
					if ( !bSyncAll )
					{
						// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
						// https://developers.google.com/google-apps/calendar/v3/sync
						sSQL = "select SYNC_TOKEN                          " + ControlChars.CrLf
						     + "  from vwOAUTH_SYNC_TOKENS                 " + ControlChars.CrLf
						     + " where ASSIGNED_USER_ID = @ASSIGNED_USER_ID" + ControlChars.CrLf
						     + "   and NAME             = @NAME            " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ASSIGNED_USER_ID", gUSER_ID         );
							Sql.AddParameter(cmd, "@NAME"            , "Google.Calendar");
							sSYNC_TOKEN = Sql.ToString(cmd.ExecuteScalar());
						}
					}
					
					EventsResource.ListRequest request = service.Events.List(sCALENDAR_ID);
					if ( !Sql.IsEmptyString(sSYNC_TOKEN) )
					{
						request.SyncToken = sSYNC_TOKEN;
					}
					else
					{
						request.TimeMin = DateTime.UtcNow.AddDays(-nAPPOINTMENT_AGE_DAYS);
						// 09/14/2015 Paul.  The expired sync token can be tested by setting a very old UpdatedMin value. 
						//request.UpdatedMin = DateTime.Now.ToUniversalTime().AddYears(-1);
					}
					request.ShowDeleted  = true ;
					request.SingleEvents = false;
					request.MaxResults   = 100  ;
					
					// https://developers.google.com/google-apps/calendar/v3/pagination
					Events events = null;
					do
					{
						try
						{
							events = request.Execute();
						}
						catch(Exception ex)
						{
							// 09/14/2015 Paul.  If we get a 410 error, then the SyncToken is invalid and we need to start the search from the beginning. 
							if ( ex.Message.Contains("The requested minimum modification time lies too far in the past. [410]") && !Sql.IsEmptyString(sSYNC_TOKEN) )
							{
								request.SyncToken = String.Empty;
								request.TimeMin   = DateTime.UtcNow.AddDays(-nAPPOINTMENT_AGE_DAYS);
								events = request.Execute();
							}
							else
							{
								throw;
							}
						}
						if ( events.Items != null && events.Items.Count > 0 )
						{
							if ( events.Items.Count > 0 )
								SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + events.Items.Count.ToString() + " appointments to retrieve from " + gUSER_ID.ToString());
							foreach ( Event appointment in events.Items )
							{
								// 07/18/2010 Paul.  Move Google Sync functions to a separate class. 
								this.ImportAppointment(Session, service, con, gUSER_ID, appointment, sCALENDAR_ID, sbErrors);
								if ( bPushNotifications )
								{
									GoogleSync.GoogleWebhook GoogleWebhook = new GoogleSync.GoogleWebhook(this.Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, GoogleApps, this);
									GoogleWebhook.CreateChannel(service, gUSER_ID, "Google.Channel", appointment.Id, sCALENDAR_ID);
								}
							}
							request.PageToken = events.NextPageToken;
						}
					}
					while ( !Sql.IsEmptyString(events.NextPageToken) );
					// 09/14/2015 Paul.  Update the sync token when done processing the batch. 
					// https://developers.google.com/google-apps/calendar/v3/sync
					if ( sSYNC_TOKEN != events.NextSyncToken )
					{
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								sSYNC_TOKEN = events.NextSyncToken;
								Guid gSYNC_ID = Guid.Empty;
								SqlProcs.spOAUTH_SYNC_TOKENS_Update(ref gSYNC_ID, gUSER_ID, "Google.Calendar", sSYNC_TOKEN, DateTime.MinValue, trn);
								trn.Commit();
							}
							catch
							{
								trn.Rollback();
								throw;
							}
						}
					}
					
					// 03/26/2010 Paul.  Join to vwAPPOINTMENTS_USERS so that we only get appointments that are marked as Sync. 
					// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
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
					     + "               on vwAPPOINTMENTS_SYNC.SYNC_SERVICE_NAME     = N'Google'                   " + ControlChars.CrLf
					     + "              and vwAPPOINTMENTS_SYNC.SYNC_LOCAL_ID         = vwAPPOINTMENTS.ID           " + ControlChars.CrLf
					     + "              and vwAPPOINTMENTS_SYNC.SYNC_ASSIGNED_USER_ID = vwAPPOINTMENTS_USERS.USER_ID" + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
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
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: " + dt.Rows.Count.ToString() + " appointments to send to " + gUSER_ID.ToString());
								GoogleSync.GoogleWebhook GoogleWebhook = new GoogleSync.GoogleWebhook(this.Session, Security, Sql, SqlProcs, SplendidError, ExchangeSecurity, SyncError, GoogleApps, this);
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
										Event appointment = null;
										if ( sSYNC_ACTION == "local new" || Sql.IsEmptyString(sSYNC_REMOTE_KEY) )
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Sending new appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + gUSER_ID.ToString());
											appointment = new Event();
											DataTable dtAppointmentEmails = AppointmentEmails(con, Sql.ToGuid(row["ID"]));
											// 03/23/2013 Paul.  Add the ability to disable participants. 
											this.SetGoogleAppointment(appointment, row, dtAppointmentEmails, sbChanges, bDISABLE_PARTICIPANTS, gUSER_ID);
											
											EventsResource.InsertRequest reqInsert = service.Events.Insert(appointment, sCALENDAR_ID);
											appointment = reqInsert.Execute();
											sSYNC_REMOTE_KEY = appointment.Id;
											if ( bPushNotifications )
											{
												GoogleWebhook.CreateChannel(service, gUSER_ID, "Google.Channel", appointment.Id, sCALENDAR_ID);
											}
										}
										else
										{
											if ( bVERBOSE_STATUS )
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Binding appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + gUSER_ID.ToString());
											
											try
											{
												EventsResource.GetRequest reqGet = service.Events.Get(sCALENDAR_ID, sSYNC_REMOTE_KEY);
												appointment = reqGet.Execute();
												// 03/28/2010 Paul.  We need to double-check for conflicts. 
												// 03/26/2011 Paul.  Updated is in local time. 
												DateTime dtREMOTE_DATE_MODIFIED     = appointment.Updated.Value;
												DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
												// 03/26/2011 Paul.  The Google remote date can vary by 1 millisecond, so check for local change first. 
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
														// 03/26/2011 Paul.  The Google remote date can vary by 1 millisecond, so check for local change first. 
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
											}
											catch(Exception ex)
											{
												string sError = "Error retrieving Google appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
												sError += Utils.ExpandException(ex) + ControlChars.CrLf;
												SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
												sbErrors.AppendLine(sError);
												sSYNC_ACTION = "remote deleted";
											}
											if ( sSYNC_ACTION == "local changed" )
											{
												// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
												// 07/18/2010 Paul.  Move Google Sync functions to a separate class. 
												DataTable dtAppointmentEmails = this.AppointmentEmails(con, Sql.ToGuid(row["ID"]));
												// 03/23/2013 Paul.  Add the ability to disable participants. 
												bool bChanged = this.SetGoogleAppointment(appointment, row, dtAppointmentEmails, sbChanges, bDISABLE_PARTICIPANTS, gUSER_ID);
												if ( bChanged )
												{
													if ( bVERBOSE_STATUS )
														SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Sending appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + gUSER_ID.ToString());
													EventsResource.UpdateRequest reqUpdate = service.Events.Update(appointment, sCALENDAR_ID, appointment.Id);
													appointment = reqUpdate.Execute();
												}
											}
										}
										if ( sSYNC_ACTION == "local new" || sSYNC_ACTION == "local changed" )
										{
											if ( appointment != null )
											{
												// 03/25/2010 Paul.  Update the modified date after the save. 
												// 03/26/2011 Paul.  Updated is in local time. 
												DateTime dtREMOTE_DATE_MODIFIED     = appointment.Updated.Value;
												DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
												using ( IDbTransaction trn = Sql.BeginTransaction(con) )
												{
													try
													{
														// 03/26/2010 Paul.  Make sure to set the Sync flag. 
														// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
														// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
														SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sSYNC_REMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Google", String.Empty, trn);
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
												SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Unsyncing appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " for " + gUSER_ID.ToString());
											using ( IDbTransaction trn = Sql.BeginTransaction(con) )
											{
												try
												{
													// 03/26/2010 Paul.  Make sure to clear the Sync flag. 
													// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
													SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gID, sSYNC_REMOTE_KEY, "Google", trn);
													SqlProcs.spOAUTH_SYNC_TOKENS_DeleteByToken(gUSER_ID, "Google.Channel", sSYNC_REMOTE_KEY, trn);
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
										string sError = "Error creating Google appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " for " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
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
			}
			catch(Exception ex)
			{
				string sMESSAGE = "SyncAppointments: " + gUSER_ID.ToString() + ": " + Utils.ExpandException(ex);
				SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMESSAGE);
				sbErrors.AppendLine(sMESSAGE);
			}
		}

		// 12/27/2011 Paul.  Move population logic to a static method. 
		// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
		public bool BuildAPPOINTMENTS_Update(ExchangeSession Session, IDbCommand spAPPOINTMENTS_Update, DataRow row, Event appointment, Guid gUSER_ID, Guid gTEAM_ID, Guid gASSIGNED_USER_ID)
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
			// 03/10/2013 Paul.  Add ALL_DAY_EVENT. 
			DateTime dtDATE_TIME          = DateTime.MinValue      ;
			bool     bALL_DAY_EVENT       = false                  ;
			int      nDURATION_MINUTES    = 0                      ;
			int      nDURATION_HOURS      = 0                      ;
			int      nREMINDER_TIME       = 0                      ;
			int      nEMAIL_REMINDER_TIME = 0                      ;
			string   sRRULE               = String.Empty           ;
			string   sREPEAT_TYPE         = String.Empty           ;
			int      nREPEAT_INTERVAL     = 0                      ;
			string   sREPEAT_DOW          = String.Empty           ;
			DateTime dtREPEAT_UNTIL       = DateTime.MinValue      ;
			int      nREPEAT_COUNT        = 0                      ;
			string   sSTATUS              = String.Empty           ;
			string   sNAME                = appointment.Summary    ;
			string   sDESCRIPTION         = appointment.Description;
			string   sLOCATION            = appointment.Location   ;
			if ( !appointment.Start.DateTime.HasValue )
			{
				bALL_DAY_EVENT      = true;
				dtDATE_TIME         = Sql.ToDateTime(appointment.Start.Date);
				TimeSpan tsDURATION = Sql.ToDateTime(appointment.End.Date) - Sql.ToDateTime(appointment.Start.Date);
				nDURATION_MINUTES = 0;
				nDURATION_HOURS   = Convert.ToInt32(tsDURATION.TotalHours);
			}
			else
			{
				bALL_DAY_EVENT = false;
				dtDATE_TIME    = (appointment.Start.DateTime.HasValue ? appointment.Start.DateTime.Value : DateTime.MinValue);
				if ( !appointment.End.DateTime.HasValue )
					appointment.End.DateTime = appointment.Start.DateTime;
				TimeSpan tsDURATION = appointment.End.DateTime.Value - appointment.Start.DateTime.Value;
				nDURATION_MINUTES = tsDURATION.Minutes;
				nDURATION_HOURS   = tsDURATION.Hours  ;
			}
			if ( appointment.Reminders != null )
			{
				// 04/01/2011 Paul.  REMINDER_TIME is in seconds.  Google stores the reminder in minutes. 
				if ( appointment.Reminders.Overrides != null )
				{
					foreach ( EventReminder reminder in appointment.Reminders.Overrides )
					{
						if      ( reminder.Method == "popup" && reminder.Minutes.HasValue ) nREMINDER_TIME       = reminder.Minutes.Value * 60;
						else if ( reminder.Method == "email" && reminder.Minutes.HasValue ) nEMAIL_REMINDER_TIME = reminder.Minutes.Value * 60;
					}
				}
				else if ( appointment.Reminders.UseDefault.HasValue && appointment.Reminders.UseDefault.Value )
				{
					nREMINDER_TIME       = 30 * 60;
					nEMAIL_REMINDER_TIME = 10 * 60;
				}
			}
			// 03/23/2013 Paul.  Add recurrence data. 
			if ( appointment.Recurrence != null && appointment.Recurrence.Count > 0 )
			{
				sRRULE = appointment.Recurrence[0];
				try
				{
					Utils.CalDAV_ParseRule(sRRULE, ref sREPEAT_TYPE, ref nREPEAT_INTERVAL, ref sREPEAT_DOW, ref dtREPEAT_UNTIL, ref nREPEAT_COUNT);
				}
				catch(Exception ex)
				{
					Debug.WriteLine(ex.Message);
					//SplendidError.SystemError(new StackTrace(true).GetFrame(0), "Failed to parse Google Calendar event rule " + sRRULE + ". " + ex.Message);
				}
			}
			// 01/14/2012 Paul.  Set the status for the event. 
			// Planned
			// Held
			// Not held
			if ( appointment.Status == GoogleApps.EventStatus.CANCELLED )
				sSTATUS = "Not held";
			else if ( appointment.Status == GoogleApps.EventStatus.CONFIRMED )
				sSTATUS = "Confirmed";
			else if ( appointment.Status == GoogleApps.EventStatus.TENTATIVE )
				sSTATUS = "Planned";
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
							case "NAME"                      :  oValue = Sql.ToDBString  (sNAME         );  break;
							case "DATE_TIME"                 :  oValue = Sql.ToDBDateTime(dtDATE_TIME   );  break;
							case "DURATION_MINUTES"          :  oValue = nDURATION_MINUTES               ;  break;
							case "DURATION_HOURS"            :  oValue = nDURATION_HOURS                 ;  break;
							case "ALL_DAY_EVENT"             :  oValue = bALL_DAY_EVENT                  ;  break;
							case "DESCRIPTION"               :  oValue = Sql.ToDBString  (sDESCRIPTION  );  break;
							case "LOCATION"                  :  oValue = Sql.ToDBString  (sLOCATION     );  break;
							case "REMINDER_TIME"             :  oValue = nREMINDER_TIME                  ;  break;
							case "EMAIL_REMINDER_TIME"       :  oValue = nEMAIL_REMINDER_TIME            ;  break;
							case "MODIFIED_USER_ID"          :  oValue = gUSER_ID                        ;  break;
							case "STATUS"                    :  oValue = Sql.ToDBString  (sSTATUS       );  break;
							case "REPEAT_TYPE"               :  oValue = Sql.ToDBString  (sREPEAT_TYPE  );  break;
							case "REPEAT_INTERVAL"           :  oValue = nREPEAT_INTERVAL                ;  break;
							case "REPEAT_DOW"                :  oValue = Sql.ToDBString  (sREPEAT_DOW   );  break;
							case "REPEAT_UNTIL"              :  oValue = Sql.ToDBDateTime(dtREPEAT_UNTIL);  break;
							case "REPEAT_COUNT"              :  oValue = nREPEAT_COUNT                   ;  break;
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
						// 04/01/2011 Paul.  Some fields are not available.  Lets just ignore them. 
					}
				}
			}
			return bChanged;
		}

		public void ImportAppointment(ExchangeSession Session, CalendarService service, IDbConnection con, Guid gUSER_ID, Event appointment, string sCALENDAR_ID, StringBuilder sbErrors)
		{
			// 07/26/2012 James.  Add the ability to disable participants. 
			bool   bDISABLE_PARTICIPANTS = Sql.ToBoolean(Application["CONFIG.GoogleApps.DisableParticipants"]);
			bool   bVERBOSE_STATUS       = Sql.ToBoolean(Application["CONFIG.GoogleApps.VerboseStatus"      ]);
			string sCONFLICT_RESOLUTION  = Sql.ToString (Application["CONFIG.GoogleApps.ConflictResolution" ]);
			Guid   gTEAM_ID              = Sql.ToGuid   (Session["TEAM_ID"]);
			
			IDbCommand spAPPOINTMENTS_Update = SqlProcs.Factory(con, "spAPPOINTMENTS_Update");
			
			string   sREMOTE_KEY                = appointment.Id;
			// 03/26/2011 Paul.  Updated is in local time. 
			DateTime dtREMOTE_DATE_MODIFIED     = appointment.Updated.Value;
			DateTime dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();

			// 03/25/2013 Paul.  For a recurring appointment, the times array is empty. 
			// We will fix this immediately after the appointment is retrieved. 
			//GoogleUitls.FixAppointmentTimes(appointment);
			DateTime dtDATE_START = DateTime.MinValue;
			if ( appointment.Start.DateTime.HasValue )
				dtDATE_START = appointment.Start.DateTime.Value;
			else
				dtDATE_START = Sql.ToDateTime(appointment.Start.Date);

			String sSQL = String.Empty;
			// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
			sSQL = "select SYNC_ID                                       " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_ID                                 " + ControlChars.CrLf
			     + "     , SYNC_LOCAL_DATE_MODIFIED_UTC                  " + ControlChars.CrLf
			     + "     , SYNC_REMOTE_DATE_MODIFIED_UTC                 " + ControlChars.CrLf
			     + "     , SYNC_APPOINTMENT                              " + ControlChars.CrLf
			     + "     , ID                                            " + ControlChars.CrLf
			     + "     , DATE_MODIFIED_UTC                             " + ControlChars.CrLf
			     + "  from vwAPPOINTMENTS_SYNC                           " + ControlChars.CrLf
			     + " where SYNC_SERVICE_NAME     = N'Google'             " + ControlChars.CrLf
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
							bool     bSYNC_APPOINTMENT               = Sql.ToBoolean (row["SYNC_APPOINTMENT"             ]);
							// 03/24/2010 Paul.  Google Record has already been mapped for this user. 
							// 03/28/2010 Paul.  If the ID is NULL and the LOCAL_ID is NOT NULL, then the local item must have been deleted. 
							// 03/29/2010 Paul.  If ID and LOCAL_ID are valid, but SYNC_APPOINTMENT is not, then the user has stopped syncing the contact. 
							if ( (Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID)) || (!Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gSYNC_LOCAL_ID) && !bSYNC_APPOINTMENT) )
							{
								sSYNC_ACTION = "local deleted";
							}
								// 03/26/2011 Paul.  The Google remote date can vary by 1 millisecond, so check for local change first. 
							else if ( dtREMOTE_DATE_MODIFIED_UTC > dtSYNC_REMOTE_DATE_MODIFIED_UTC.AddMilliseconds(10) && dtDATE_MODIFIED_UTC > dtSYNC_LOCAL_DATE_MODIFIED_UTC )
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
								// 03/26/2011 Paul.  The Google remote date can vary by 1 millisecond, so check for local change first. 
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
								// 09/14/2015 Paul.  Appointments do not have a deleted flag.  They have cancelled and not many other fields. 
								if ( appointment.Status == "cancelled" && !appointment.Created.HasValue )
								{
									sSYNC_ACTION = "remote deleted";
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
						// 09/14/2015 Paul.  Appointments do not have a deleted flag.  They have cancelled and not many other fields. 
						else if ( appointment.Status == "cancelled" && !appointment.Created.HasValue )
						{
							sSYNC_ACTION = "remote deleted";
						}
						else
						{
							sSYNC_ACTION = "remote new";
							
							// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to Google. 
							// 03/28/2010 Paul.  We need to prevent duplicate Google entries from attaching to an existing mapped Appointment ID. 
							// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
							cmd.Parameters.Clear();
							sSQL = "select vwAPPOINTMENTS.ID             " + ControlChars.CrLf
							     + "  from            vwAPPOINTMENTS     " + ControlChars.CrLf
							     + "  left outer join vwAPPOINTMENTS_SYNC" + ControlChars.CrLf
							     + "               on vwAPPOINTMENTS_SYNC.SYNC_SERVICE_NAME     = N'Google'             " + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_ASSIGNED_USER_ID = @SYNC_ASSIGNED_USER_ID" + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_REMOTE_KEY       = @SYNC_REMOTE_KEY      " + ControlChars.CrLf
							     + "              and vwAPPOINTMENTS_SYNC.SYNC_LOCAL_ID         = vwAPPOINTMENTS.ID     " + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@SYNC_ASSIGNED_USER_ID", gUSER_ID   );
							Sql.AddParameter(cmd, "@SYNC_REMOTE_KEY"      , sREMOTE_KEY);
							ExchangeSecurity.Filter(Session, cmd, gUSER_ID, "Appointments", "view");
							
							Sql.AppendParameter(cmd, Sql.ToString(appointment.Summary), "NAME"      );
							// 03/25/2013 Paul.  For a recurring appointment, the times array is empty. 
							// We will fix this immediately after the appointment is retrieved. 
							Sql.AppendParameter(cmd, dtDATE_START      , "DATE_START");
							cmd.CommandText += "   and vwAPPOINTMENTS_SYNC.ID is null" + ControlChars.CrLf;
							gID = Sql.ToGuid(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyGuid(gID) )
							{
								// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to Google. 
								sSYNC_ACTION = "local new";
							}
						}
					}
					using ( DataTable dt = new DataTable() )
					{
						DataRow row = null;
						Guid   gASSIGNED_USER_ID = Guid.Empty;
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
							// 03/30/2011 Paul.  We need to check for added or removed participants. 
							// 04/02/2012 Paul.  Add Calls/Leads relationship. 
							Dictionary<string, Guid> dictLeads       = new Dictionary<string,Guid>();
							Dictionary<string, Guid> dictContacts    = new Dictionary<string,Guid>();
							Dictionary<string, Guid> dictUsers       = new Dictionary<string,Guid>();
							List<string>             lstParticipants = new List<string>();
							DataTable dtUSERS = new DataTable();
							// 03/23/2013 Paul.  Add the ability to disable participants. 
							if ( !bDISABLE_PARTICIPANTS )
							{
								if ( appointment.Attendees != null )
								{
									foreach ( EventAttendee guest in appointment.Attendees )
									{
										// 09/16/2015 Paul.  Exclude creator email as that email may not be in the CRM. 
										if ( appointment.Creator.Email != guest.Email )
											lstParticipants.Add(guest.Email.ToLower());
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
								sSQL = "select vwAPPOINTMENTS_USERS.APPOINTMENT_ID      " + ControlChars.CrLf
								     + "     , vwAPPOINTMENTS_USERS.USER_ID             " + ControlChars.CrLf
								     + "     , vwGOOGLEAPPS_USERS.EMAIL1                " + ControlChars.CrLf
								     + "     , vwGOOGLEAPPS_USERS.GOOGLEAPPS_USERNAME   " + ControlChars.CrLf
								     + "  from      vwAPPOINTMENTS_USERS                " + ControlChars.CrLf
								     + " inner join vwGOOGLEAPPS_USERS                  " + ControlChars.CrLf
								     + "         on vwGOOGLEAPPS_USERS.USER_ID = vwAPPOINTMENTS_USERS.USER_ID" + ControlChars.CrLf
								     + " where vwAPPOINTMENTS_USERS.APPOINTMENT_ID = @ID" + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dtUSERS);
								foreach ( DataRow rowUser in dtUSERS.Rows )
								{
									Guid   gAPPOINTMENT_USER_ID  = Sql.ToGuid  (rowUser["USER_ID"            ]);
									string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EMAIL1"             ]).ToLower();
									string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["GOOGLEAPPS_USERNAME"]).ToLower();
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
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Retrieving appointment " + Sql.ToString(appointment.Summary) + " " + Sql.ToString(dtDATE_START) + " from " + gUSER_ID.ToString());
									
									spAPPOINTMENTS_Update.Transaction = trn;
									// 12/27/2011 Paul.  Move population logic to a static method. 
									// 01/24/2012 Paul.  Only update the record if it has changed.  This is to prevent an endless loop caused by sync operations. 
									bool bChanged = BuildAPPOINTMENTS_Update(Session, spAPPOINTMENTS_Update, row, appointment, gUSER_ID, gTEAM_ID, gASSIGNED_USER_ID);
									if ( !bChanged )
									{
										// 03/23/2013 Paul.  Add the ability to disable participants. 
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
												string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EMAIL1"             ]).ToLower();
												string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["GOOGLEAPPS_USERNAME"]).ToLower();
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
										spAPPOINTMENTS_Update.ExecuteNonQuery();
										IDbDataParameter parID = Sql.FindParameter(spAPPOINTMENTS_Update, "@ID");
										gID = Sql.ToGuid(parID.Value);
									
										// 03/23/2013 Paul.  Add the ability to disable participants. 
										if ( !bDISABLE_PARTICIPANTS )
										{
											// 01/14/2012 Paul.  We need to add the current user to the appointment so that the SYNC_APPOINTMENT will be true. 
											// If the end-user removes himself from the meeting, SYNC_APPOINTMENT will be false and the appointment will be treated as local deleted. 
											if ( sAPPOINTMENT_TYPE == "Meetings" || Sql.IsEmptyString(sAPPOINTMENT_TYPE) )
												SqlProcs.spMEETINGS_USERS_Update(gID, gUSER_ID, true, String.Empty, trn);
											else if ( sAPPOINTMENT_TYPE == "Calls" )
												SqlProcs.spCALLS_USERS_Update(gID, gUSER_ID, true, String.Empty, trn);
									
											if ( appointment.Attendees != null )
											{
												foreach ( EventAttendee guest in appointment.Attendees )
												{
													// 09/16/2015 Paul.  Exclude creator email as that email may not be in the CRM. 
													if ( appointment.Creator.Email != guest.Email )
													{
														string sEmail         = guest.Email.ToLower();
														bool   bREQUIRED      = false;
														string sACCEPT_STATUS = String.Empty;
														switch ( guest.ResponseStatus )
														{
															case "accepted"   :  sACCEPT_STATUS = "accept"   ;  break;
															case "declined"   :  sACCEPT_STATUS = "decline"  ;  break;
															case "tentative"  :  sACCEPT_STATUS = "tentative";  break;
															case "needsAction":  sACCEPT_STATUS = "none"     ;  break;
														}
														bREQUIRED = !(guest.Optional.HasValue && guest.Optional.Value);
														// 01/10/2012 Paul.  iCloud can have contacts without an email. 
														Guid gCONTACT_ID = Guid.Empty;
														SqlProcs.spAPPOINTMENTS_RELATED_Update(gID, sEmail, bREQUIRED, sACCEPT_STATUS, String.Empty, ref gCONTACT_ID, trn);
													}
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
												string sAPPOINTMENT_EMAIL1   = Sql.ToString(rowUser["EMAIL1"             ]).ToLower();
												string sAPPOINTMENT_USERNAME = Sql.ToString(rowUser["GOOGLEAPPS_USERNAME"]).ToLower();
												// 01/14/2012 Paul.  Make sure not to remove this user. 
												if ( gAPPOINTMENT_USER_ID != gUSER_ID && !lstParticipants.Contains(sAPPOINTMENT_EMAIL1) && !lstParticipants.Contains(sAPPOINTMENT_USERNAME) )
												{
													SqlProcs.spAPPOINTMENTS_USERS_Delete(gID, gAPPOINTMENT_USER_ID, trn);
												}
											}
										}
									}
									else
									{
										Debug.WriteLine("SyncAppointments: Appointment unchanged " + appointment.Id);
									}
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Google", String.Empty, trn);
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
							// 03/25/2010 Paul.  If we find a appointment, then treat the CRM record as the master and send latest version over to Google. 
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
										SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Syncing appointment " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + gUSER_ID.ToString());
									// 03/28/2010 Paul.  The EWS Managed API requires one field to change in order to update the record. 
									// 07/18/2010 Paul.  Move Google Sync functions to a separate class. 
									DataTable dtAppointmentEmails = AppointmentEmails(con, Sql.ToGuid(row["ID"]));
									// 03/23/2013 Paul.  Add the ability to disable participants. 
									bool bChanged = this.SetGoogleAppointment(appointment, row, dtAppointmentEmails, sbChanges, bDISABLE_PARTICIPANTS, gUSER_ID);
									if ( bChanged )
									{
										EventsResource.UpdateRequest reqUpdate = service.Events.Update(appointment, sCALENDAR_ID, appointment.Id);
										appointment = reqUpdate.Execute();
									}
									// 03/25/2010 Paul.  Update the modified date after the save. 
									// 03/28/2010 Paul.  The EWS has been forced to use UTC. 
									dtREMOTE_DATE_MODIFIED     = appointment.Updated.Value;
									dtREMOTE_DATE_MODIFIED_UTC = dtREMOTE_DATE_MODIFIED.ToUniversalTime();
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 03/26/2010 Paul.  Make sure to set the Sync flag. 
											// 03/29/2010 Paul.  The Sync flag will be updated in the procedure. 
											// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
											SqlProcs.spAPPOINTMENTS_SYNC_Update(gUSER_ID, gID, sREMOTE_KEY, dtREMOTE_DATE_MODIFIED, dtREMOTE_DATE_MODIFIED_UTC, "Google", String.Empty, trn);
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
									string sError = "Error saving " + Sql.ToString(row["NAME"]) + " " + Sql.ToString(row["DATE_START"]) + " to " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
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
								EventsResource.DeleteRequest reqDelete = service.Events.Delete(sCALENDAR_ID, appointment.Id);
								reqDelete.Execute();
							}
							catch(Exception ex)
							{
								// 03/24/2013 Paul.  row object might be null, so don't use it. 
								string sError = "Error deleting " + Sql.ToString(appointment.Summary) + " " + Sql.ToString(dtDATE_START) + " from " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
							try
							{
								if ( bVERBOSE_STATUS )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Deleting " + Sql.ToString(appointment.Summary) + " " + Sql.ToString(dtDATE_START) + " from " + gUSER_ID.ToString());
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
										SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gSYNC_LOCAL_ID, sREMOTE_KEY, "Google", trn);
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
								string sError = "Error deleting " + Sql.ToString(appointment.Summary) + " " + Sql.ToString(dtDATE_START) + " from " + gUSER_ID.ToString() + "." + ControlChars.CrLf;
								sError += Utils.ExpandException(ex) + ControlChars.CrLf;
								SyncError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sError);
								sbErrors.AppendLine(sError);
							}
						}
						else if ( sSYNC_ACTION == "remote deleted" && !Sql.IsEmptyGuid(gID) )
						{
							if ( bVERBOSE_STATUS )
							{
								if ( appointment.OriginalStartTime.DateTime.HasValue )
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Unsyncing appointment " + Sql.ToString(appointment.OriginalStartTime.DateTime.Value) + " for " + gUSER_ID.ToString());
								else
									SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "SyncAppointments: Unsyncing appointment " + Sql.ToString(appointment.OriginalStartTime.Date) + " for " + gUSER_ID.ToString());
							}
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 12/19/2011 Paul.  Add SERVICE_NAME to allow multiple sync targets. 
									SqlProcs.spAPPOINTMENTS_SYNC_Delete(gUSER_ID, gID, sREMOTE_KEY, "Google", trn);
									SqlProcs.spOAUTH_SYNC_TOKENS_DeleteByToken(gUSER_ID, "Google.Channel", sREMOTE_KEY, trn);
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
		}
		#endregion
	}
}
