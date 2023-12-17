/*
 * Copyright (C) 2019-2021 SplendidCRM Software, Inc. All Rights Reserved. 
 *
 * Any use of the contents of this file are subject to the SplendidCRM Professional Source Code License 
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
 */
using System;
using System.IO;
using System.Web;
using System.Data;
using System.Data.Common;
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;
using Microsoft.Exchange.WebServices.Data;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Authorization;

using Spring.Social.Office365;

namespace SplendidCRM.Controllers.Administration.Exchange
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/Exchange/Rest.svc")]
	public class ExchangeRestController : ControllerBase
	{
		public const string MODULE_NAME = "Exchange";
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SqlProcs             SqlProcs           ;
		private SplendidCache        SplendidCache      ;
		private SplendidError        SplendidError      ;
		private XmlUtil              XmlUtil            ;
		private SyncError            SyncError          ;
		private Crm.Modules          Modules            ;
		private Crm.NoteAttachments  NoteAttachments    ;
		private Office365Sync        Office365Sync      ;
		private ExchangeSecurity     ExchangeSecurity   ;
		private ExchangeUtils        ExchangeUtils      ;
		private ExchangeSync         ExchangeSync       ;

		public ExchangeRestController(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidCache SplendidCache, SplendidError SplendidError, XmlUtil XmlUtil, SyncError SyncError, SplendidCRM.Crm.Modules Modules, SplendidCRM.Crm.NoteAttachments NoteAttachments, Office365Sync Office365Sync, ExchangeSecurity ExchangeSecurity, ExchangeUtils ExchangeUtils, ExchangeSync ExchangeSync)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidCache       = SplendidCache      ;
			this.SplendidError       = SplendidError      ;
			this.XmlUtil             = XmlUtil            ;
			this.SyncError           = SyncError          ;
			this.Modules             = Modules            ;
			this.NoteAttachments     = NoteAttachments    ;
			this.Office365Sync       = Office365Sync      ;
			this.ExchangeSecurity    = ExchangeSecurity   ;
			this.ExchangeUtils       = ExchangeUtils      ;
			this.ExchangeSync        = ExchangeSync       ;
		}

		private DataRow GetExchangeUser(Guid gUSER_ID)
		{
			DataRow row = null;
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				string sSQL;
				sSQL = "select *               " + ControlChars.CrLf
				     + "  from vwUSERS_EXCHANGE" + ControlChars.CrLf
				     + " where 1 = 1           " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AppendParameter(cmd, gUSER_ID, "USER_ID");
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);
							if ( dt.Rows.Count > 0 )
							{
								row = dt.Rows[0];
							}
						}
					}
				}
			}
			return row;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Test([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				// 03/09/2019 Paul.  Allow admin delegate to access admin api. 
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				string sAUTHENTICATION_METHOD = String.Empty;
				string sSERVER_URL            = String.Empty;
				string sOAUTH_CLIENT_ID       = String.Empty;
				string sOAUTH_CLIENT_SECRET   = String.Empty;
				string sUSER_NAME             = String.Empty;
				string sPASSWORD              = String.Empty;
				bool   bIGNORE_CERTIFICATE    = false;
				string sIMPERSONATED_TYPE     = String.Empty;
				string sEXCHANGE_VERSION      = String.Empty;
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = String.Empty;
				foreach ( string sKey in dict.Keys )
				{
					switch ( sKey )
					{
						case "Exchange.AuthenticationMethod":  sAUTHENTICATION_METHOD = Sql.ToString (dict[sKey]);  break;
						case "Exchange.ServerURL"           :  sSERVER_URL            = Sql.ToString (dict[sKey]);  break;
						case "Exchange.ClientID"            :  sOAUTH_CLIENT_ID       = Sql.ToString (dict[sKey]);  break;
						case "Exchange.ClientSecret"        :  sOAUTH_CLIENT_SECRET   = Sql.ToString (dict[sKey]);  break;
						case "Exchange.UserName"            :  sUSER_NAME             = Sql.ToString (dict[sKey]);  break;
						case "Exchange.Password"            :  sPASSWORD              = Sql.ToString (dict[sKey]);  break;
						case "Exchange.IgnoreCertificate"   :  bIGNORE_CERTIFICATE    = Sql.ToBoolean(dict[sKey]);  break;
						case "Exchange.ImpersonatedType"    :  sIMPERSONATED_TYPE     = Sql.ToString (dict[sKey]);  break;
						case "Exchange.Version"             :  sEXCHANGE_VERSION      = Sql.ToString (dict[sKey]);  break;
						case "Exchange.DirectoryTenantID"   :  sOAuthDirectoryTenatID = Sql.ToString (dict[sKey]);  break;
					}
				}
				if ( sAUTHENTICATION_METHOD == "oauth" )
				{
					Office365Sync.Office365TestAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, ExchangeUtils.EXCHANGE_ID, sbErrors);
				}
				else
				{
					// 03/10/2021 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
					if ( Sql.IsEmptyString(sPASSWORD) || sPASSWORD == Sql.sEMPTY_PASSWORD )
					{
						sPASSWORD = Sql.ToString(Application["CONFIG.Exchange.Password"]);
					}
					else
					{
						Guid gINBOUND_EMAIL_KEY = Sql.ToGuid(Application["CONFIG.InboundEmailKey"]);
						Guid gINBOUND_EMAIL_IV  = Sql.ToGuid(Application["CONFIG.InboundEmailIV" ]);
						sPASSWORD = Security.EncryptPassword(sPASSWORD, gINBOUND_EMAIL_KEY, gINBOUND_EMAIL_IV);
					}
					// 07/08/2023 Paul.  Sensitive fields will not be sent to React client, so check for empty string. 
					if ( Sql.IsEmptyString(sUSER_NAME) || sUSER_NAME == Sql.sEMPTY_PASSWORD )
					{
						sUSER_NAME = Sql.ToString(Application["CONFIG.Exchange.UserName"]);
					}
					ExchangeUtils.ValidateExchange(sSERVER_URL, sUSER_NAME, sPASSWORD, bIGNORE_CERTIFICATE, sIMPERSONATED_TYPE, sEXCHANGE_VERSION, sbErrors);
				}
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Sync([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				Guid gUSER_ID = Guid.Empty;
				bool bSyncAll = false;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "USER_ID":  gUSER_ID = Sql.ToGuid   (dict[sColumnName]);  break;
						case "SyncAll":  bSyncAll = Sql.ToBoolean(dict[sColumnName]);  break;
					}
				}
				DataRow row = GetExchangeUser(gUSER_ID);
				if ( row != null )
				{
					Guid   gID                      = Sql.ToGuid  (row["ID"                      ]);
					string sEXCHANGE_ALIAS          = Sql.ToString(row["USER_NAME"               ]);
					string sEXCHANGE_EMAIL          = Sql.ToString(row["EMAIL1"                  ]);
					string sEXCHANGE_WATERMARK      = Sql.ToString(row["EXCHANGE_WATERMARK"      ]);
					// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
					string sMAIL_SMTPUSER           = Sql.ToString(row["MAIL_SMTPUSER"           ]);
					string sMAIL_SMTPPASS           = Sql.ToString(row["MAIL_SMTPPASS"           ]);
					// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
					bool   bOFFICE365_OAUTH_ENABLED = Sql.ToBoolean(row["OFFICE365_OAUTH_ENABLED"]);
				
					// 05/09/2018 Paul.  We need to also check for ClientID for Office 365. 
					string sSERVER_URL          = Sql.ToString (Application["CONFIG.Exchange.ServerURL"   ]);
					string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
					string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
					if ( !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sOAUTH_CLIENT_ID) && !Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) )
					{
						Spring.Social.Office365.Office365Sync.UserSync User = new Spring.Social.Office365.Office365Sync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, ExchangeSecurity, SyncError, Modules, NoteAttachments, Office365Sync, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gUSER_ID, bSyncAll, bOFFICE365_OAUTH_ENABLED);
						if ( bSyncAll )
						{
							sbErrors.Append(L10n.Term("Users.LBL_SYNC_BACKGROUND"));
							// 04/25/2010 Paul.  A SyncAll operation can take a long time, so create inside a thread. 
							// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
							System.Threading.Thread t = new System.Threading.Thread(User.Start);
							t.Start();
						}
						else
						{
							// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
							Office365Sync.Sync(User, sbErrors);
							//if ( sbErrors.Length == 0 )
							//	sbErrors.Append(L10n.Term("Exchange.LBL_OPERATION_COMPLETE"));
						}
					}
					else
					{
						// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
						ExchangeSync.UserSync User = new ExchangeSync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, XmlUtil, SyncError, ExchangeSecurity, ExchangeUtils, ExchangeSync, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gUSER_ID, sEXCHANGE_WATERMARK, bSyncAll, bOFFICE365_OAUTH_ENABLED);
						if ( bSyncAll )
						{
							sbErrors.Append(L10n.Term("Users.LBL_SYNC_BACKGROUND"));
							// 04/25/2010 Paul.  A SyncAll operation can take a long time, so create inside a thread. 
							// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
							System.Threading.Thread t = new System.Threading.Thread(User.Start);
							t.Start();
						}
						else
						{
							// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
							ExchangeSync.Sync(User, sbErrors);
							//if ( sbErrors.Length == 0 )
							//	sbErrors.Append(L10n.Term("Exchange.LBL_OPERATION_COMPLETE"));
						}
					}
				}
				else
				{
					throw(new Exception("User not found."));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string SyncFolder([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				Guid gUSER_ID   = Guid.Empty;
				Guid gFOLDER_ID = Guid.Empty;
				bool bSyncAll   = false;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "USER_ID"  :  gUSER_ID   = Sql.ToGuid   (dict[sColumnName]);  break;
						case "FOLDER_ID":  gFOLDER_ID = Sql.ToGuid   (dict[sColumnName]);  break;
					}
				}
				DataRow row = GetExchangeUser(gUSER_ID);
				if ( row != null )
				{
					Guid   gID                      = Sql.ToGuid  (row["ID"                      ]);
					string sEXCHANGE_ALIAS          = Sql.ToString(row["USER_NAME"               ]);
					string sEXCHANGE_EMAIL          = Sql.ToString(row["EMAIL1"                  ]);
					string sEXCHANGE_WATERMARK      = Sql.ToString(row["EXCHANGE_WATERMARK"      ]);
					// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
					string sMAIL_SMTPUSER           = Sql.ToString(row["MAIL_SMTPUSER"           ]);
					string sMAIL_SMTPPASS           = Sql.ToString(row["MAIL_SMTPPASS"           ]);
					// 01/17/2017 Paul.  The gEXCHANGE_ID is to lookup the OAuth credentials. 
					bool   bOFFICE365_OAUTH_ENABLED = Sql.ToBoolean(row["OFFICE365_OAUTH_ENABLED"]);
				
					// 05/09/2018 Paul.  We need to also check for ClientID for Office 365. 
					string sSERVER_URL          = Sql.ToString (Application["CONFIG.Exchange.ServerURL"   ]);
					string sOAUTH_CLIENT_ID     = Sql.ToString (Application["CONFIG.Exchange.ClientID"    ]);
					string sOAUTH_CLIENT_SECRET = Sql.ToString (Application["CONFIG.Exchange.ClientSecret"]);
					// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
					string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
					if ( !Sql.IsEmptyString(sSERVER_URL) && !Sql.IsEmptyString(sOAUTH_CLIENT_ID) && !Sql.IsEmptyString(sOAUTH_CLIENT_SECRET) )
					{
						Spring.Social.Office365.Office365Sync.UserSync User = new Spring.Social.Office365.Office365Sync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, SplendidCache, ExchangeSecurity, SyncError, Modules, NoteAttachments, Office365Sync, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gUSER_ID, bSyncAll, bOFFICE365_OAUTH_ENABLED);
						DataTable dtUserFolders = SplendidCache.ExchangeFolders(gUSER_ID);
						DataView vwMain = new DataView(dtUserFolders);
						vwMain.RowFilter = "ID = '" + gFOLDER_ID.ToString() + "'";
						if ( vwMain.Count > 0 )
						{
							DataRowView rowUserFolders = vwMain[0];
							string sREMOTE_KEY        = Sql.ToString (rowUserFolders["REMOTE_KEY"       ]);
							string sMODULE_NAME       = Sql.ToString (rowUserFolders["MODULE_NAME"      ]);
							Guid   gPARENT_ID         = Sql.ToGuid   (rowUserFolders["PARENT_ID"        ]);
							string sPARENT_NAME       = Sql.ToString (rowUserFolders["PARENT_NAME"      ]);
							bool   bWELL_KNOWN_FOLDER = Sql.ToBoolean(rowUserFolders["WELL_KNOWN_FOLDER"]);
						
							ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
							Office365AccessToken token = Office365Sync.Office365RefreshAccessToken(sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, gUSER_ID, false);
							Spring.Social.Office365.Api.IOffice365 service = Office365Sync.CreateApi(token.access_token);
						
							if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Contacts" )
							{
								// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
								// 02/12/2021 Paul.  Allow disable contacts. 
								bool bDisableContacts = Sql.ToBoolean(Application["CONFIG.Exchange.DisableContacts"]);
								if ( !bDisableContacts )
									Office365Sync.SyncContacts    (Session, service, sEXCHANGE_ALIAS, gUSER_ID, false, sbErrors);
							}
							else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Calendar" )
							{
								// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
								bool bDisableAppointments = Sql.ToBoolean(Application["CONFIG.Exchange.DisableAppointments"]);
								if ( !bDisableAppointments )
									Office365Sync.SyncAppointments(Session, service, sEXCHANGE_ALIAS, gUSER_ID, false, sbErrors);
							}
							// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
							else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Sent Items" )
							{
								bool bSentItemsSync = Sql.ToBoolean(Application["CONFIG.Exchange.SentItemsSync"]);
								if ( bSentItemsSync )
								{
									// 03/13/2012 Paul.  Move SyncSentItems into a thread as it can take a long time to work. 
									//ExchangeSync.SyncSentItems(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, true, DateTime.MinValue, sbErrors);
									sbErrors.Append(L10n.Term("Users.LBL_SYNC_BACKGROUND"));
									System.Threading.Thread t = new System.Threading.Thread(User.SyncSentItems);
									t.Start();
								}
							}
							// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
							else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Inbox" )
							{
								bool bSentItemsSync = Sql.ToBoolean(Application["CONFIG.Exchange.InboxSync"]);
								if ( bSentItemsSync )
								{
									sbErrors.Append(L10n.Term("Users.LBL_SYNC_BACKGROUND"));
									System.Threading.Thread t = new System.Threading.Thread(User.SyncInbox);
									t.Start();
								}
							}
							else
							{
								SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
								using ( IDbConnection con = dbf.CreateConnection() )
								{
									con.Open();
								
									bool bInboxRoot     = Sql.ToBoolean(Application["CONFIG.Exchange.InboxRoot"    ]);
									bool bSentItemsRoot = Sql.ToBoolean(Application["CONFIG.Exchange.SentItemsRoot"]);
									Spring.Social.Office365.Api.MailFolder fldExchangeRoot = service.FolderOperations.GetWellKnownFolder("msgfolderroot");
									Spring.Social.Office365.Api.MailFolder fldSplendidRoot = null;
									Spring.Social.Office365.Api.MailFolder fldModuleFolder = null;
									if ( bInboxRoot )
										fldExchangeRoot = service.FolderOperations.GetWellKnownFolder("inbox");
									if ( Sql.IsEmptyString(sMODULE_NAME) )
									{
										// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
										Office365Sync.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, String.Empty, Guid.Empty, String.Empty, sEXCHANGE_ALIAS, gUSER_ID, true, sbErrors);
									}
									else
									{
										// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
										Office365Sync.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, sEXCHANGE_ALIAS, gUSER_ID, true, sbErrors);
										if ( bSentItemsRoot )
										{
											fldExchangeRoot = service.FolderOperations.GetWellKnownFolder("sentitems");
											fldSplendidRoot = null;
											fldModuleFolder = null;
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											Office365Sync.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, sEXCHANGE_ALIAS, gUSER_ID, true, sbErrors);
										}
									}
								}
							}
						}
						else
						{
							throw(new Exception("Folder not found."));
						}
					}
					else
					{
						// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
						ExchangeSync.UserSync User = new ExchangeSync.UserSync(Session, Security, Sql, SqlProcs, SplendidError, XmlUtil, SyncError, ExchangeSecurity, ExchangeUtils, ExchangeSync, sEXCHANGE_ALIAS, sEXCHANGE_EMAIL, sMAIL_SMTPUSER, sMAIL_SMTPPASS, gUSER_ID, sEXCHANGE_WATERMARK, bSyncAll, bOFFICE365_OAUTH_ENABLED);
						DataTable dtUserFolders = SplendidCache.ExchangeFolders(gUSER_ID);
						DataView vwMain = new DataView(dtUserFolders);
						vwMain.RowFilter = "ID = '" + gFOLDER_ID.ToString() + "'";
						if ( vwMain.Count > 0 )
						{
							DataRowView rowUserFolders = vwMain[0];
							string sREMOTE_KEY        = Sql.ToString (rowUserFolders["REMOTE_KEY"       ]);
							string sMODULE_NAME       = Sql.ToString (rowUserFolders["MODULE_NAME"      ]);
							Guid   gPARENT_ID         = Sql.ToGuid   (rowUserFolders["PARENT_ID"        ]);
							string sPARENT_NAME       = Sql.ToString (rowUserFolders["PARENT_NAME"      ]);
							bool   bWELL_KNOWN_FOLDER = Sql.ToBoolean(rowUserFolders["WELL_KNOWN_FOLDER"]);
						
							ExchangeSession Session = ExchangeSecurity.LoadUserACL(gUSER_ID);
							// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
							ExchangeService service = ExchangeUtils.CreateExchangeService(User);
						
							if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Contacts" )
							{
								// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
								// 02/12/2021 Paul.  Allow disable contacts. 
								bool bDisableContacts = Sql.ToBoolean(Application["CONFIG.Exchange.DisableContacts"]);
								if ( !bDisableContacts )
									ExchangeSync.SyncContacts    (Session, service, sEXCHANGE_ALIAS, gUSER_ID, false, sbErrors);
							}
							else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Calendar" )
							{
								// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
								// 02/12/2021 Paul.  Should have been disabled here long ago. 
								bool bDisableAppointments = Sql.ToBoolean(Application["CONFIG.Exchange.DisableAppointments"]);
								if ( !bDisableAppointments )
									ExchangeSync.SyncAppointments(Session, service, sEXCHANGE_ALIAS, gUSER_ID, false, sbErrors);
							}
							// 03/11/2012 Paul.  Import messages from Sent Items if the TO email exists in the CRM. 
							else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Sent Items" )
							{
								bool bSentItemsSync = Sql.ToBoolean(Application["CONFIG.Exchange.SentItemsSync"]);
								if ( bSentItemsSync )
								{
									// 03/13/2012 Paul.  Move SyncSentItems into a thread as it can take a long time to work. 
									//ExchangeSync.SyncSentItems(Session, service, con, sEXCHANGE_ALIAS, gUSER_ID, true, DateTime.MinValue, sbErrors);
									sbErrors.Append(L10n.Term("Users.LBL_SYNC_BACKGROUND"));
									System.Threading.Thread t = new System.Threading.Thread(User.SyncSentItems);
									t.Start();
								}
							}
							// 07/05/2017 Paul.  Import messages from Inbox if the FROM email exists in the CRM. 
							else if ( bWELL_KNOWN_FOLDER && sMODULE_NAME == "Inbox" )
							{
								bool bSentItemsSync = Sql.ToBoolean(Application["CONFIG.Exchange.InboxSync"]);
								if ( bSentItemsSync )
								{
									sbErrors.Append(L10n.Term("Users.LBL_SYNC_BACKGROUND"));
									System.Threading.Thread t = new System.Threading.Thread(User.SyncInbox);
									t.Start();
								}
							}
							else
							{
								SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
								using ( IDbConnection con = dbf.CreateConnection() )
								{
									con.Open();
								
									bool bInboxRoot     = Sql.ToBoolean(Application["CONFIG.Exchange.InboxRoot"    ]);
									bool bSentItemsRoot = Sql.ToBoolean(Application["CONFIG.Exchange.SentItemsRoot"]);
									WellKnownFolderName fldExchangeRoot = WellKnownFolderName.MsgFolderRoot;
									Folder fldSplendidRoot = null;
									Folder fldModuleFolder = null;
									if ( bInboxRoot )
										fldExchangeRoot = WellKnownFolderName.Inbox;
									if ( Sql.IsEmptyString(sMODULE_NAME) )
									{
										// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
										ExchangeSync.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, String.Empty, Guid.Empty, String.Empty, sEXCHANGE_ALIAS, gUSER_ID, true, sbErrors);
									}
									else
									{
										// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
										ExchangeSync.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, sEXCHANGE_ALIAS, gUSER_ID, true, sbErrors);
										if ( bSentItemsRoot )
										{
											fldExchangeRoot = WellKnownFolderName.SentItems;
											fldSplendidRoot = null;
											fldModuleFolder = null;
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											ExchangeSync.SyncModuleFolders(Session, service, con, fldExchangeRoot, ref fldSplendidRoot, ref fldModuleFolder, sMODULE_NAME, gPARENT_ID, sPARENT_NAME, sEXCHANGE_ALIAS, gUSER_ID, true, sbErrors);
										}
									}
								}
							}
						}
						else
						{
							throw(new Exception("Folder not found."));
						}
					}
				}
				else
				{
					throw(new Exception("User not found."));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Authorize([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				string sCode          = String.Empty;
				string sRedirectURL   = String.Empty;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "code"         :  sCode         = Sql.ToString (dict[sColumnName]);  break;
						case "redirect_url" :  sRedirectURL  = Sql.ToString (dict[sColumnName]);  break;
					}
				}
				
				string sOAUTH_CLIENT_ID       = Sql.ToString(Application["CONFIG.Exchange.ClientID"    ]);
				string sOAUTH_CLIENT_SECRET   = Sql.ToString(Application["CONFIG.Exchange.ClientSecret"]);
				// 02/04/2023 Paul.  Directory Tenant is now required for single tenant app registrations. 
				string sOAuthDirectoryTenatID = Sql.ToString(Application["CONFIG.Exchange.DirectoryTenantID"]);
				Office365Sync.Office365AcquireAccessToken(Request, sOAuthDirectoryTenatID, sOAUTH_CLIENT_ID, sOAUTH_CLIENT_SECRET, ExchangeUtils.EXCHANGE_ID, sCode, sRedirectURL);
				sbErrors.Append(L10n.Term("OAuth.LBL_TEST_SUCCESSFUL"));
			}
			catch(Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw( new Exception(ex.Message));
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Enable([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				Guid gUSER_ID = Guid.Empty;
				bool bENABLE  = false;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "USER_ID":  gUSER_ID = Sql.ToGuid   (dict[sColumnName]);  break;
						case "ENABLE" :  bENABLE  = Sql.ToBoolean(dict[sColumnName]);  break;
					}
				}
				if ( !Sql.IsEmptyGuid(gUSER_ID) )
				{
					string sIMPERSONATED_TYPE = Sql.ToString(Application["CONFIG.Exchange.ImpersonatedType"]);
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						string sSQL;
						sSQL = "select *               " + ControlChars.CrLf
						     + "  from vwUSERS_EXCHANGE" + ControlChars.CrLf
						     + " where 1 = 1           " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AppendParameter(cmd, gUSER_ID, "USER_ID");
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dt = new DataTable() )
								{
									da.Fill(dt);
									if ( dt.Rows.Count > 0 )
									{
										DataRow row = dt.Rows[0];
										Guid   gID             = Sql.ToGuid  (row["ID"       ]);
										string sEXCHANGE_ALIAS = Sql.ToString(row["USER_NAME"]);
										string sEXCHANGE_EMAIL = Sql.ToString(row["EMAIL1"   ]);
										if ( bENABLE )
										{
											try
											{
												// 03/29/2010 Paul.  ValidateImpersonation will throw an exception if it cannot access the Contacts folder. 
												// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
												if ( sIMPERSONATED_TYPE != "NoImpersonation" )
													ExchangeUtils.ValidateImpersonation(sEXCHANGE_ALIAS, sEXCHANGE_EMAIL);
												gID = Guid.Empty;
												SqlProcs.spEXCHANGE_USERS_Update
													( ref gID
													, sEXCHANGE_ALIAS
													, sEXCHANGE_EMAIL
													, sIMPERSONATED_TYPE
													, Guid.Empty
													);
											}
											catch
											{
											}
										}
										else
										{
											// 04/26/2010 Paul.  We need to stop any subscriptions when disabled. 
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											ExchangeSync.StopPullSubscription(gUSER_ID);
											ExchangeSync.StopPushSubscription(gUSER_ID);
											SqlProcs.spEXCHANGE_USERS_Delete(gID);
										}
									}
								}
							}
						}
					}
				}
				else
				{
					throw(new Exception("Missing USER_ID"));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string MassEnable([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				List<Guid> arrID_LIST = new List<Guid>();
				bool bENABLE           = false;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "ENABLE":
						{
							bENABLE = Sql.ToBoolean(dict[sColumnName]);
							break;
							}
						case "ID_LIST":
						{
							if ( dict[sColumnName] is System.Collections.ArrayList )
							{
								System.Collections.ArrayList lst = dict[sColumnName] as System.Collections.ArrayList;
								if ( lst.Count > 0 )
								{
									foreach ( string item in lst )
									{
										arrID_LIST.Add(new Guid(item));
									}
								}
							}
							break;
						}
					}
				}
				if ( arrID_LIST.Count > 0 )
				{
					string sIMPERSONATED_TYPE = Sql.ToString(Application["CONFIG.Exchange.ImpersonatedType"]);
					SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						string sSQL;
						sSQL = "select *               " + ControlChars.CrLf
						     + "  from vwUSERS_EXCHANGE" + ControlChars.CrLf
						     + " where 1 = 1           " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AppendParameter(cmd, arrID_LIST.ToArray(), "USER_ID");
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dt = new DataTable() )
								{
									da.Fill(dt);
									foreach ( DataRow row in dt.Rows )
									{
										Guid   gID             = Sql.ToGuid  (row["ID"       ]);
										Guid   gUSER_ID        = Sql.ToGuid  (row["USER_ID"  ]);
										string sEXCHANGE_ALIAS = Sql.ToString(row["USER_NAME"]);
										string sEXCHANGE_EMAIL = Sql.ToString(row["EMAIL1"   ]);
										if ( bENABLE )
										{
											try
											{
												// 03/29/2010 Paul.  ValidateImpersonation will throw an exception if it cannot access the Contacts folder. 
												// 11/23/2011 Paul.  Add MAIL_SMTPUSER and MAIL_SMTPPASS so that we can avoid impersonation. 
												if ( sIMPERSONATED_TYPE != "NoImpersonation" )
													ExchangeUtils.ValidateImpersonation(sEXCHANGE_ALIAS, sEXCHANGE_EMAIL);
												gID = Guid.Empty;
												SqlProcs.spEXCHANGE_USERS_Update
													( ref gID
													, sEXCHANGE_ALIAS
													, sEXCHANGE_EMAIL
													, sIMPERSONATED_TYPE
													, Guid.Empty
													);
											}
											catch
											{
											}
										}
										else
										{
											// 04/26/2010 Paul.  We need to stop any subscriptions when disabled. 
											// 07/18/2010 Paul.  Move Exchange Sync functions to a separate class. 
											ExchangeSync.StopPullSubscription(gUSER_ID);
											ExchangeSync.StopPushSubscription(gUSER_ID);
											SqlProcs.spEXCHANGE_USERS_Delete(gID);
										}
									}
								}
							}
						}
					}
				}
				else
				{
					throw(new Exception("Missing ID_LIST"));
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}

		[HttpGet("[action]")]
		public Dictionary<string, object> GetExchangeFolders(Guid ID)
		{
			if ( !Security.IsAuthenticated() || Security.AdminUserAccess(MODULE_NAME, "edit") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			if ( !Sql.ToBoolean(Application["CONFIG.AuthorizeNet.Enabled"]) ||  Sql.IsEmptyString(Application["CONFIG.AuthorizeNet.UserName"]) )
			{
				throw(new Exception(MODULE_NAME + " is not enabled or configured."));
			}
			Guid      gTIMEZONE   = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone  T10n        = TimeZone.CreateTimeZone(gTIMEZONE);
			DataTable dtUserFolders = new DataTable();
			long      lTotalCount = 0;
			try
			{
				dtUserFolders = SplendidCache.ExchangeFolders(ID);
				if ( dtUserFolders != null )
				{
					lTotalCount = dtUserFolders.Rows.Count;
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
			
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			// 04/01/2020 Paul.  Move json utils to RestUtil. 
			Dictionary<string, object> dictResponse = RestUtil.ToJson(sBaseURI, String.Empty, dtUserFolders, T10n);
			dictResponse.Add("__total", lTotalCount);
			return dictResponse;
		}

	}
}
