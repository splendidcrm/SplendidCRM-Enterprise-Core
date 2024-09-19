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
using System.Diagnostics;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Pages.Reports
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
	public class ExportRDLModel : PageModel
	{
		private IHttpContextAccessor httpContextAccessor;
		private IWebHostEnvironment  hostingEnvironment ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private XmlUtil              XmlUtil            ;

		public ExportRDLModel(IHttpContextAccessor httpContextAccessor, IWebHostEnvironment hostingEnvironment, HttpSessionState Session, Security Security, SplendidError SplendidError, SplendidCache SplendidCache, XmlUtil XmlUtil)
		{
			this.httpContextAccessor = httpContextAccessor;
			this.hostingEnvironment  = hostingEnvironment ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.XmlUtil             = XmlUtil            ;
		}

		public IActionResult OnGetAsync()
		{
			string sMessage = "Report not found.";
			Response.ContentType = "text/plain";
			try
			{
				Guid gID = Sql.ToGuid(Request.Query["ID"]);
				if ( Security.GetUserAccess("Reports", "export") >= 0 )
				{
					if ( !Sql.IsEmptyGuid(gID) )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL ;
							sSQL = "select *             " + ControlChars.CrLf
							     + "  from vwREPORTS_Edit" + ControlChars.CrLf
							     + " where ID = @ID      " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									if ( rdr.Read() )
									{
										string sFileName = Sql.ToString(rdr["NAME"]);
										string sRDL      = Sql.ToString(rdr["RDL" ]);
										// 02/12/2010 Paul.  Loading the RDL will remove the Name property from the Report tag, 
										// which causes an exception in Report Builder 2.0. 
										RdlDocument rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
										rdl.LoadRdl(sRDL);
										Response.ContentType = "text/xml";
										// 08/06/2008 yxy21969.  Make sure to encode all URLs.
										// 12/20/2009 Paul.  Use our own encoding so that a space does not get converted to a +. 
										Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(sFileName + ".rdl"));
										sMessage = rdl.OuterXml;
									}
								}
							}
						}
					}
				}
				else
				{
					sMessage = L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS");
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sMessage = ex.Message;
			}
			byte[] data = System.Text.Encoding.UTF8.GetBytes(sMessage);
			return File(data, Response.ContentType);
		}
	}
}
