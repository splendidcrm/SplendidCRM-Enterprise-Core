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
using System.Text;
using System.Data;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Pages.Reports
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
	public class ExportSQLModel : PageModel
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;

		public ExportSQLModel(HttpSessionState Session, Security Security, SplendidError SplendidError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.SplendidError       = SplendidError      ;
		}

		public IActionResult OnGetAsync()
		{
			string sMessage = "Report not found.";
			try
			{
				Guid gID = Sql.ToGuid(Request.Query["ID"]);
				if ( Security.GetUserAccess("Reports", "export") >= 0 )
				{
					if ( !Sql.IsEmptyGuid(gID) )
					{
						string sFileName      = String.Empty;
						string sProcedureName = String.Empty;
						StringBuilder sb = new StringBuilder();
						
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL ;
							sSQL = "select *               " + ControlChars.CrLf
							     + "  from vwREPORTS_Edit  " + ControlChars.CrLf
							     + " where ID = @ID        " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									if ( rdr.Read() )
									{
										string sNAME             = Sql.ToString(rdr["NAME"            ]);
										string sMODULE_NAME      = Sql.ToString(rdr["MODULE_NAME"     ]);
										string sREPORT_TYPE      = Sql.ToString(rdr["REPORT_TYPE"     ]);
										string sRDL              = Sql.ToString(rdr["RDL"             ]);
										Guid   gTEAM_ID          = Sql.ToGuid  (rdr["TEAM_ID"         ]);
										string sTEAM_SET_LIST    = String.Empty;
										Guid   gASSIGNED_USER_ID = Guid.Empty;
										gTEAM_ID          = Guid.Empty;
										sTEAM_SET_LIST    = String.Empty;

										// 01/23/2012 Paul.  Remove some of the bulk of the XML. 
										int nRelatedModulesStart = sRDL.IndexOf("<CustomProperty><Name>crm:RelatedModules</Name>");
										if ( nRelatedModulesStart >= 0 )
										{
											int nRelatedModulesEnd = sRDL.IndexOf("</CustomProperty>", nRelatedModulesStart);
											sRDL = sRDL.Substring(0, nRelatedModulesStart) + sRDL.Substring(nRelatedModulesEnd + "</CustomProperty>".Length);
										}
										int nRelationshipsStart = sRDL.IndexOf("<CustomProperty><Name>crm:Relationships</Name>");
										if ( nRelationshipsStart >= 0 )
										{
											int nRelationshipsEnd = sRDL.IndexOf("</CustomProperty>", nRelationshipsStart);
											sRDL = sRDL.Substring(0, nRelationshipsStart) + sRDL.Substring(nRelationshipsEnd + "</CustomProperty>".Length);
										}

										sFileName = sNAME;
										sProcedureName = "spRULES_" + sNAME.Replace(" ", "_").Replace("\'", "").Replace(":", "").Replace("/", "");
										sb.AppendLine("/* -- #if IBM_DB2");
										sb.AppendLine("call dbo.spSqlDropProcedure('" + sProcedureName + "')");
										sb.AppendLine("/");
										sb.AppendLine("");
										sb.AppendLine("Create Procedure dbo." + sProcedureName + "()");
										sb.AppendLine("language sql");
										sb.AppendLine("  begin");
										sb.AppendLine("	declare in_USER_ID char(36);");
										sb.AppendLine("-- #endif IBM_DB2 */");
										sb.AppendLine("");
										sb.AppendLine("/* -- #if Oracle");
										sb.AppendLine("Declare");
										sb.AppendLine("	StoO_selcnt INTEGER := 0;");
										sb.AppendLine("	in_ID char(36);");
										sb.AppendLine("BEGIN");
										sb.AppendLine("	BEGIN");
										sb.AppendLine("-- #endif Oracle */");
										sb.AppendLine("");
										sb.AppendLine("print 'REPORTS " + Sql.EscapeSQL(sNAME) + "';");
										sb.AppendLine("GO");
										sb.AppendLine("");
										sb.AppendLine("set nocount on;");
										sb.AppendLine("GO");
										sb.AppendLine("");
										sb.AppendLine("exec dbo.spREPORTS_InsertOnly '" + gID.ToString() + "', "
														+ Sql.FormatSQL(sNAME                       , 0) + ", "
														+ Sql.FormatSQL(sMODULE_NAME                , 0) + ", "
														+ Sql.FormatSQL(sREPORT_TYPE                , 0) + ", "
														+ Sql.FormatSQL(sRDL                        , 0) + ", "
														+ Sql.FormatSQL(gTEAM_ID.ToString()         , 0) + ";");
										sb.AppendLine("");
									}
								}
							}
							
							sb.AppendLine("GO");
							sb.AppendLine("");
							sb.AppendLine("set nocount off;");
							sb.AppendLine("GO");
							sb.AppendLine("");
							sb.AppendLine("/* -- #if Oracle");
							sb.AppendLine("	EXCEPTION");
							sb.AppendLine("		WHEN NO_DATA_FOUND THEN");
							sb.AppendLine("			StoO_selcnt := 0;");
							sb.AppendLine("		WHEN OTHERS THEN");
							sb.AppendLine("			RAISE;");
							sb.AppendLine("	END;");
							sb.AppendLine("	COMMIT WORK;");
							sb.AppendLine("END;");
							sb.AppendLine("/");
							sb.AppendLine("-- #endif Oracle */");
							sb.AppendLine("");
							sb.AppendLine("/* -- #if IBM_DB2");
							sb.AppendLine("	commit;");
							sb.AppendLine("  end");
							sb.AppendLine("/");
							sb.AppendLine("");
							sb.AppendLine("call dbo." + sProcedureName + "()");
							sb.AppendLine("/");
							sb.AppendLine("");
							sb.AppendLine("call dbo.spSqlDropProcedure('" + sProcedureName + "')");
							sb.AppendLine("/");
							sb.AppendLine("");
							sb.AppendLine("-- #endif IBM_DB2 */");
							sb.AppendLine("");
						}
						
						Response.ContentType = "text/sql";
						// 02/12/2021 Paul.  Default to .1.sql. 
						Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(sFileName + ".1.sql"));
						sMessage = sb.ToString();
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
			Response.ContentType = "text/plain";
			return File(data, Response.ContentType);
		}
	}
}
