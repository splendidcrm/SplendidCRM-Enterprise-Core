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
using System.Collections;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;

namespace SplendidCRM.Pages
{
	// 01/25/2008 Paul.  This page must be accessible without authentication. 
	[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
	public class AcceptDeclineModel : PageModel
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private EmailUtils           EmailUtils         ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SplendidCRM.Crm.Config           Config           = new SplendidCRM.Crm.Config();

		public  string               lblError            { get; set; }
		public  string               litReminder         { get; set; }

		public AcceptDeclineModel(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, EmailUtils EmailUtils)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.EmailUtils          = EmailUtils         ;
		}

		public void OnGetAsync()
		{
			try
			{
				Guid   gID            = Sql.ToGuid  (Request.Query["ID"           ]);
				Guid   gINVITEE_ID    = Sql.ToGuid  (Request.Query["INVITEE_ID"   ]);
				string sACCEPT_STATUS = Sql.ToString(Request.Query["ACCEPT_STATUS"]).ToLower();
				if ( sACCEPT_STATUS != "accept" && sACCEPT_STATUS != "tentative" && sACCEPT_STATUS != "decline" )
					sACCEPT_STATUS = String.Empty;
				if ( !Sql.IsEmptyGuid(gID) && !Sql.IsEmptyGuid(gINVITEE_ID) && !Sql.IsEmptyString(sACCEPT_STATUS) )
				{
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL;
						sSQL = "select *                          " + ControlChars.CrLf
						     + "  from vwACTIVITIES_Invitees      " + ControlChars.CrLf
						     + " where ID            = @ID        " + ControlChars.CrLf
						     + "   and INVITEE_ID    = @INVITEE_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID"        , gID        );
							Sql.AddParameter(cmd, "@INVITEE_ID", gINVITEE_ID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dt = new DataTable() )
								{
									da.Fill(dt);
									if ( dt.Rows.Count > 0 )
									{
										DataRow row = dt.Rows[0];
										string sACTIVITY_TYPE = Sql.ToString(row["ACTIVITY_TYPE"]);
										string sINVITEE_TYPE  = Sql.ToString(row["INVITEE_TYPE" ]);
										string sINVITEE_LANG  = Sql.ToString(row["LANG"         ]);
										Guid   gTIMEZONE_ID   = Sql.ToGuid  (row["TIMEZONE_ID"  ]);
										
										if ( sACTIVITY_TYPE == "Calls" )
											SqlProcs.spCALLS_UpdateAcceptStatus(gID, sINVITEE_TYPE, gINVITEE_ID, sACCEPT_STATUS);
										else if ( sACTIVITY_TYPE == "Meetings" )
											SqlProcs.spMEETINGS_UpdateAcceptStatus(gID, sINVITEE_TYPE, gINVITEE_ID, sACCEPT_STATUS);
										
										// 12/26/2012 Paul.  If this is a user, then view the record. 
										if ( sINVITEE_TYPE == "Users" )
											Response.Redirect("~/" + sACTIVITY_TYPE + "/view.aspx?ID=" + gID.ToString());
										
										// 12/26/2012 Paul.  If this is not a user, then display the Reminder message. 
										string     sSiteURL         = Config.SiteURL();
										Guid       gDefaultTimezone = Sql.ToGuid  (Application["CONFIG.default_timezone"]);
										string     sDefaultLanguage = Sql.ToString(Application["CONFIG.default_language"]);
										L10N       L10nEN           = new L10N("en-US");
										DataView   vwColumns        = EmailUtils.SortedTableColumns(dt);
										Hashtable  hashEnumsColumns = EmailUtils.EnumColumns( "Calls");
										
										if ( !Sql.IsEmptyGuid(gTIMEZONE_ID) )
											gTIMEZONE_ID = gDefaultTimezone;
										if ( !Sql.IsEmptyString(sINVITEE_LANG) )
											sINVITEE_LANG = sDefaultLanguage;
										// 04/20/2018 Paul.  Alternate language mapping to convert en-CA to en_US. 
										sINVITEE_LANG = L10N.AlternateLanguage(Application, sINVITEE_LANG);
										
										L10N     L10n = new L10N(sINVITEE_LANG);
										TimeZone T10n = TimeZone.CreateTimeZone(gTIMEZONE_ID);
										row["DATE_START"] = T10n.FromServerTime(Sql.ToDateTime(row["DATE_START"]));
										row["DATE_END"  ] = T10n.FromServerTime(Sql.ToDateTime(row["DATE_END"  ]));
										
										// 12/25/2012 Paul.  The reminder mssages are pulled from the terminology table so that they can be localized. 
										string sSubjectMsg = "MSG_CONTACT_REMINDER_SUBJECT";
										string sBodyMsg    = "MSG_CONTACT_REMINDER_BODY"   ;
										string sSubject    = L10n.Term(sACTIVITY_TYPE + "." + sSubjectMsg);
										string sBodyHtml   = L10n.Term(sACTIVITY_TYPE + "." + sBodyMsg   );
										// 12/25/2012 Paul.  First fallback is English. 
										if ( Sql.IsEmptyString(sSubject) )
											sSubject    = L10nEN.Term(sACTIVITY_TYPE + "." + sSubjectMsg);
										if ( Sql.IsEmptyString(sBodyHtml) )
											sBodyHtml   = L10nEN.Term(sACTIVITY_TYPE + "." + sBodyMsg   );
										// 12/25/2012 Paul.  Second fallback is embedded string. 
										if ( Sql.IsEmptyString(sSubject) )
											sSubject = sACTIVITY_TYPE + " Reminder - $activity_name";
										if ( Sql.IsEmptyString(sBodyHtml) )
											sBodyHtml = "$activity_name\n$activity_date_start\n";
										
										// 12/26/2012 Paul.  Remove the URLs as the remaining page is for a non-user. 
										string sViewURL    = String.Empty;
										string sEditURL    = String.Empty;
										string sAcceptURL  = String.Empty;
										sBodyHtml = sBodyHtml.Replace("$view_url"  , sViewURL  );
										sBodyHtml = sBodyHtml.Replace("$edit_url"  , sEditURL  );
										sBodyHtml = sBodyHtml.Replace("$accept_url", sAcceptURL);
										// 08/19/2023 Paul.  Support React urls. 
										sBodyHtml = sBodyHtml.Replace("$react_view_url"  , sViewURL  );
										sBodyHtml = sBodyHtml.Replace("$react_edit_url"  , sEditURL  );
										sBodyHtml = sBodyHtml.Replace("$react_accept_url", sAcceptURL);
										sBodyHtml = sBodyHtml.Replace("href=\"~/", "\"" + sSiteURL);
										sBodyHtml = sBodyHtml.Replace("href=\'~/", "\'" + sSiteURL);  // 12/25/2012 Paul.  Also watch for single quote. 
										
										string sFillPrefix = sACTIVITY_TYPE;
										if ( sFillPrefix.EndsWith("s") )
											sFillPrefix = sFillPrefix.Substring(0, sFillPrefix.Length-1);
										sSubject  = EmailUtils.FillEmail(sSubject , sFillPrefix, row, vwColumns, null, hashEnumsColumns);
										sBodyHtml = EmailUtils.FillEmail(sBodyHtml, sFillPrefix, row, vwColumns, null, hashEnumsColumns);
										if ( sBodyHtml.Contains("$activity_") )
										{
											sFillPrefix = "activity";
											sSubject  = EmailUtils.FillEmail(sSubject , sFillPrefix, row, vwColumns, null, hashEnumsColumns);
											sBodyHtml = EmailUtils.FillEmail(sBodyHtml, sFillPrefix, row, vwColumns, null, hashEnumsColumns);
										}
										litReminder = sBodyHtml.Replace("\n", "<br />\n");
									}
									else
									{
										lblError = L10n.Term(".LBL_EMAIL_SEARCH_NO_RESULTS");
									}
								}
							}
						}
					}
				}
				else
				{
					lblError = L10n.Term(".ERR_MISSING_REQUIRED_FIELDS");
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				lblError = ex.Message;
			}
		}
	}
}
