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
using System.Data;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

using Microsoft.Reporting.NETCore;

namespace SplendidCRM.Pages.Reports
{
	[Authorize]
	[SplendidSessionAuthorize]
	[IgnoreAntiforgeryToken]
	[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
	public class AttachmentModel : PageModel
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone T10n               = new SplendidCRM.TimeZone();
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private SplendidCRM.Crm.Modules          Modules              ;
		private SplendidCRM.Crm.NoteAttachments  NoteAttachments      ;
		private RdlUtil                          RdlUtil              ;
		private ReportsAttachmentView            ReportsAttachmentView;

		public AttachmentModel(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SplendidCRM.Crm.Modules Modules, RdlUtil RdlUtil, SplendidCRM.Crm.NoteAttachments NoteAttachments, ReportsAttachmentView ReportsAttachmentView)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.Modules             = Modules            ;
			this.RdlUtil             = RdlUtil            ;
			this.NoteAttachments     = NoteAttachments    ;
			this.ReportsAttachmentView = ReportsAttachmentView;
		}

		public async Task<IActionResult> OnGetAsync()
		{
			string sMessage = String.Empty;
			try
			{
				{
					Guid gID = Sql.ToGuid(Request.Query["ID"]);
					Dictionary<string, object> dictBody = new Dictionary<string, object>();
					if ( !Sql.IsEmptyGuid(gID) )
					{
						// 04/06/2011 Paul.  Cache reports. 
						DataTable dtReport = SplendidCache.Report(gID);
						if ( dtReport.Rows.Count > 0 )
						{
							DataRow rdr = dtReport.Rows[0];
							string sRDL                     = Sql.ToString  (rdr["RDL"          ]);
							// 01/19/2010 Paul.  The Module Name is needed in order to apply ACL Field Security. 
							string   sMODULE_NAME           = Sql.ToString  (rdr["MODULE_NAME"  ]);
							// 02/05/2010 Paul.  We need the Report Name and Modified date to create a unique description. 
							string   sREPORT_NAME           = Sql.ToString  (rdr["NAME"         ]);
							DateTime dtREPORT_DATE_MODIFIED = Sql.ToDateTime(rdr["DATE_MODIFIED"]);
							
							if ( !Sql.IsEmptyString(sRDL) )
							{
								string sRENDER_FORMAT = Sql.ToString(Request.Query["RENDER_FORMAT"]);  // Excel, PDF, Image
								switch ( sRENDER_FORMAT.ToUpper() )
								{
									// 05/13/2014 Paul.  Word format is supported by ReportViewer 2012. 
									// http://msdn.microsoft.com/en-us/library/ms251671(v=vs.110).aspx
									// 09/13/2016 Paul.  Possible render formats "Excel" "EXCELOPENXML" "IMAGE" "PDF" "WORD" "WORDOPENXML". 
									// http://stackoverflow.com/questions/3494009/creating-a-custom-export-to-excel-for-reportviewer-rdlc
									// 05/07/2018 Paul.  Include all possible values. 
									case "WORD"        :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
									case "WORDOPENXML" :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
									case "EXCEL"       :  sRENDER_FORMAT = "EXCELOPENXML";  break;
									case "EXCELOPENXML":  sRENDER_FORMAT = "EXCELOPENXML";  break;
									case "IMAGE"       :  sRENDER_FORMAT = "Image"       ;  break;
									case "PDF"         :  sRENDER_FORMAT = "PDF"         ;  break;
									default            :  sRENDER_FORMAT = "PDF"         ;  break;
								}
								Guid gSOURCE_ID = Guid.Empty;
								if ( sMODULE_NAME == "Quotes" || sMODULE_NAME == "Orders" || sMODULE_NAME == "Invoices" || sMODULE_NAME == "Contracts" )
								{
									string sMODULE_FIELD_ID   = String.Empty;
									// 06/27/2010 Paul.  Use new TableName function. 
									string sMODULE_TABLE_NAME = Modules.TableName(sMODULE_NAME);
									if ( sMODULE_TABLE_NAME.EndsWith("IES") )
										sMODULE_FIELD_ID = sMODULE_TABLE_NAME.Substring(0, sMODULE_TABLE_NAME.Length - 3) + "Y_ID";
									else if ( sMODULE_TABLE_NAME.EndsWith("S") )
										sMODULE_FIELD_ID = sMODULE_TABLE_NAME.Substring(0, sMODULE_TABLE_NAME.Length - 1) + "_ID";
									else
										sMODULE_FIELD_ID = sMODULE_TABLE_NAME + "_ID";
									gSOURCE_ID = Sql.ToGuid(Request.Query[sMODULE_FIELD_ID]);
								}

								string sNOTE_NAME   = Request.QueryString.ToString().Replace("&", ",");
								// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
								// 02/05/2021 Paul.  Make static so that we can use in the React client. 
								Guid gNOTE_ID = await ReportsAttachmentView.RunReport(null, L10n, T10n, gID, sRDL, sRENDER_FORMAT, sMODULE_NAME, sREPORT_NAME, dtREPORT_DATE_MODIFIED, gSOURCE_ID, sNOTE_NAME, dictBody);
								Response.Redirect("~/Emails/edit.aspx?NOTE_ID=" + gNOTE_ID.ToString() + "&PARENT_ID=" + gSOURCE_ID.ToString() );
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				string sError = Utils.ExpandException(ex);
				sMessage = sError;
			}
			byte[] data = System.Text.Encoding.UTF8.GetBytes(sMessage);
			Response.ContentType = "text/plain";
			return File(data, Response.ContentType);
		}
	}
}
