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
using System.Text;
using System.IO;
using System.Diagnostics;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;

namespace SplendidCRM.Administration.DynamicLayout.GridViews
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
	public class ExportModel : PageModel
	{
		private IHttpContextAccessor httpContextAccessor;
		private IWebHostEnvironment  hostingEnvironment ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;

		public ExportModel(IHttpContextAccessor httpContextAccessor, IWebHostEnvironment hostingEnvironment, HttpSessionState Session, Security Security, SplendidError SplendidError)
		{
			this.httpContextAccessor = httpContextAccessor;
			this.hostingEnvironment  = hostingEnvironment ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.SplendidError       = SplendidError      ;
		}

		public IActionResult OnGetAsync()
		{
			string sMessage = "Layout not found.";
			Response.ContentType = "text/plain";
			try
			{
				string sNAME = Sql.ToString(Request.Query["NAME"]);
				if ( Security.GetUserAccess("DynamicLayout", "export") >= 0 )
				{
					if ( !Sql.IsEmptyString(sNAME) )
					{
						StringBuilder sb = new StringBuilder();
						// 03/15/2018 Paul.  Mark record as deleted instead of deleting. 
						//sb.AppendLine("delete from GRIDVIEWS_COLUMNS where GRID_NAME = '" + sNAME + "';");
						sb.AppendLine("update GRIDVIEWS_COLUMNS set DELETED = 1, DATE_MODIFIED_UTC = getutcdate(), MODIFIED_USER_ID = null where DELETED = 0 and GRID_NAME = '" + sNAME + "';");
				
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select *                     " + ControlChars.CrLf
								 + "  from vwGRIDVIEWS_COLUMNS   " + ControlChars.CrLf
								 + " where GRID_NAME = @GRID_NAME" + ControlChars.CrLf
								 + "   and DEFAULT_VIEW = 0      " + ControlChars.CrLf
								 + " order by COLUMN_INDEX       " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@GRID_NAME", sNAME);
					
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dtFields = new DataTable() )
									{
										da.Fill(dtFields);
										if ( dtFields.Rows.Count > 0 )
										{
											int nCOLUMN_INDEX_Length    = 2;
											int nHEADER_TEXT_Length     = 4;
											int nDATA_FIELD_Length      = 4;
											int nDATA_FORMAT_Length     = 4;
											int nURL_FIELD_Length       = 4;
											int nURL_FORMAT_Length      = 4;
											int nURL_TARGET_Length      = 4;
											int nLIST_NAME_Length       = 4;
											int nSORT_EXPRESSION_Length = 4;
											foreach(DataRow row in dtFields.Rows)
											{
												nCOLUMN_INDEX_Length    = Math.Max(nCOLUMN_INDEX_Length   , Sql.EscapeSQL(Sql.ToString(row["COLUMN_INDEX"   ])).Length);
												nHEADER_TEXT_Length     = Math.Max(nHEADER_TEXT_Length    , Sql.EscapeSQL(Sql.ToString(row["HEADER_TEXT"    ])).Length + 2);
												nDATA_FIELD_Length      = Math.Max(nDATA_FIELD_Length     , Sql.EscapeSQL(Sql.ToString(row["DATA_FIELD"     ])).Length + 2);
												nDATA_FORMAT_Length     = Math.Max(nDATA_FORMAT_Length    , Sql.EscapeSQL(Sql.ToString(row["DATA_FORMAT"    ])).Length + 2);
												nURL_FIELD_Length       = Math.Max(nURL_FIELD_Length      , Sql.EscapeSQL(Sql.ToString(row["URL_FIELD"      ])).Length + 2);
												nURL_FORMAT_Length      = Math.Max(nURL_FORMAT_Length     , Sql.EscapeSQL(Sql.ToString(row["URL_FORMAT"     ])).Length + 2);
												nURL_TARGET_Length      = Math.Max(nURL_TARGET_Length     , Sql.EscapeSQL(Sql.ToString(row["URL_TARGET"     ])).Length + 2);
												nLIST_NAME_Length       = Math.Max(nLIST_NAME_Length      , Sql.EscapeSQL(Sql.ToString(row["LIST_NAME"      ])).Length + 2);
												nSORT_EXPRESSION_Length = Math.Max(nSORT_EXPRESSION_Length, Sql.EscapeSQL(Sql.ToString(row["SORT_EXPRESSION"])).Length + 2);
											}

											sb.AppendLine("if not exists(select * from GRIDVIEWS_COLUMNS where GRID_NAME = '" + sNAME + "' and DELETED = 0) begin -- then");
											sb.AppendLine("	print 'GRIDVIEWS_COLUMNS " + sNAME + "';");

											string sVIEW_NAME    = Sql.ToString(dtFields.Rows[0]["VIEW_NAME"   ]);
											string sMODULE_NAME  = Sql.ToString(dtFields.Rows[0]["MODULE_NAME" ]);
											sb.AppendLine("	exec dbo.spGRIDVIEWS_InsertOnly           '" + sNAME + "', " + Sql.FormatSQL(sMODULE_NAME, 0) + ", " + Sql.FormatSQL(sVIEW_NAME, 0) + ";");
											foreach(DataRow row in dtFields.Rows)
											{
												string sGRID_NAME                  = Sql.ToString(row["GRID_NAME"                 ]);
												string sCOLUMN_INDEX               = Sql.ToString(row["COLUMN_INDEX"              ]);
												string sCOLUMN_TYPE                = Sql.ToString(row["COLUMN_TYPE"               ]);
												string sHEADER_TEXT                = Sql.ToString(row["HEADER_TEXT"               ]);
												string sSORT_EXPRESSION            = Sql.ToString(row["SORT_EXPRESSION"           ]);
												string sITEMSTYLE_WIDTH            = Sql.ToString(row["ITEMSTYLE_WIDTH"           ]);
												string sITEMSTYLE_CSSCLASS         = Sql.ToString(row["ITEMSTYLE_CSSCLASS"        ]);
												string sITEMSTYLE_HORIZONTAL_ALIGN = Sql.ToString(row["ITEMSTYLE_HORIZONTAL_ALIGN"]);
												string sITEMSTYLE_VERTICAL_ALIGN   = Sql.ToString(row["ITEMSTYLE_VERTICAL_ALIGN"  ]);
												string sITEMSTYLE_WRAP             = Sql.ToString(row["ITEMSTYLE_WRAP"            ]);
												string sDATA_FIELD                 = Sql.ToString(row["DATA_FIELD"                ]);
												string sDATA_FORMAT                = Sql.ToString(row["DATA_FORMAT"               ]);
												string sURL_FIELD                  = Sql.ToString(row["URL_FIELD"                 ]);
												string sURL_FORMAT                 = Sql.ToString(row["URL_FORMAT"                ]);
												string sURL_TARGET                 = Sql.ToString(row["URL_TARGET"                ]);
												string sLIST_NAME                  = Sql.ToString(row["LIST_NAME"                 ]);
												string sURL_MODULE                 = Sql.ToString(row["URL_MODULE"                ]);
												string sURL_ASSIGNED_FIELD         = Sql.ToString(row["URL_ASSIGNED_FIELD"        ]);
												// 04/05/2018 Paul.  Module Type is a separate field that requires a separate procedure. 
												string sMODULE_TYPE                = Sql.ToString(row["MODULE_TYPE"               ]);

												sCOLUMN_INDEX = Strings.Space(nCOLUMN_INDEX_Length - sCOLUMN_INDEX.Length) + sCOLUMN_INDEX;
												switch ( sCOLUMN_TYPE )
												{
													case "TemplateColumn":
														// 04/05/2018 Paul.  Module Type is a separate field that requires a separate procedure. 
														if ( sDATA_FORMAT == "HyperLink" && !Sql.IsEmptyString(sMODULE_TYPE) )
															sb.AppendLine("	exec dbo.spGRIDVIEWS_COLUMNS_InsModule    '" + sGRID_NAME + "', " + sCOLUMN_INDEX + ", " + Sql.FormatSQL(sHEADER_TEXT, nHEADER_TEXT_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sSORT_EXPRESSION, nSORT_EXPRESSION_Length) + ", " + Sql.FormatSQL(sITEMSTYLE_WIDTH, 0) +", " + Sql.FormatSQL(sITEMSTYLE_CSSCLASS, 0) + ", " + Sql.FormatSQL(sURL_FIELD, nURL_FIELD_Length) + ", " + Sql.FormatSQL(sURL_FORMAT, nURL_FORMAT_Length) + ", " + Sql.FormatSQL(sURL_TARGET, nURL_TARGET_Length) + ", " + Sql.FormatSQL(sURL_MODULE, 0) + ", " + Sql.FormatSQL(sURL_ASSIGNED_FIELD, 0) + ";");
														else if ( sDATA_FORMAT == "HyperLink" )
															sb.AppendLine("	exec dbo.spGRIDVIEWS_COLUMNS_InsHyperLink '" + sGRID_NAME + "', " + sCOLUMN_INDEX + ", " + Sql.FormatSQL(sHEADER_TEXT, nHEADER_TEXT_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sSORT_EXPRESSION, nSORT_EXPRESSION_Length) + ", " + Sql.FormatSQL(sITEMSTYLE_WIDTH, 0) +", " + Sql.FormatSQL(sITEMSTYLE_CSSCLASS, 0) + ", " + Sql.FormatSQL(sURL_FIELD, nURL_FIELD_Length) + ", " + Sql.FormatSQL(sURL_FORMAT, nURL_FORMAT_Length) + ", " + Sql.FormatSQL(sURL_TARGET, nURL_TARGET_Length) + ", " + Sql.FormatSQL(sURL_MODULE, 0) + ", " + Sql.FormatSQL(sURL_ASSIGNED_FIELD, 0) + ";");
														else
															sb.AppendLine("	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate '" + sGRID_NAME + "', " + sCOLUMN_INDEX + ", " + Sql.FormatSQL(sHEADER_TEXT, nHEADER_TEXT_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sSORT_EXPRESSION, nSORT_EXPRESSION_Length) + ", " + Sql.FormatSQL(sITEMSTYLE_WIDTH, 0) +", " + Sql.FormatSQL(sDATA_FORMAT, 0) + ";");
														break;
													case "BoundColumn"   :
														if ( !Sql.IsEmptyString(sLIST_NAME) )
															sb.AppendLine("	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundList '" + sGRID_NAME + "', " + sCOLUMN_INDEX + ", " + Sql.FormatSQL(sHEADER_TEXT, nHEADER_TEXT_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sSORT_EXPRESSION, nSORT_EXPRESSION_Length) + ", " + Sql.FormatSQL(sITEMSTYLE_WIDTH, 0) +", " + Sql.FormatSQL(sLIST_NAME, nLIST_NAME_Length) +";");
														// 01/11/2018 Paul.  Often the layout is configured as Bound / Date instead of Template / Date. 
														else if ( sDATA_FORMAT == "Date" || sDATA_FORMAT == "DateTime" )
															sb.AppendLine("	exec dbo.spGRIDVIEWS_COLUMNS_InsBoundDate '" + sGRID_NAME + "', " + sCOLUMN_INDEX + ", " + Sql.FormatSQL(sHEADER_TEXT, nHEADER_TEXT_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sSORT_EXPRESSION, nSORT_EXPRESSION_Length) + ", " + Sql.FormatSQL(sITEMSTYLE_WIDTH, 0) +", " + Sql.FormatSQL(sDATA_FORMAT, 0) + ";");
														else
															sb.AppendLine("	exec dbo.spGRIDVIEWS_COLUMNS_InsBound     '" + sGRID_NAME + "', " + sCOLUMN_INDEX + ", " + Sql.FormatSQL(sHEADER_TEXT, nHEADER_TEXT_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sSORT_EXPRESSION, nSORT_EXPRESSION_Length) + ", " + Sql.FormatSQL(sITEMSTYLE_WIDTH, 0) +";");
														break;
												}
											}
											foreach(DataRow row in dtFields.Rows)
											{
												string sGRID_NAME                  = Sql.ToString(row["GRID_NAME"                 ]);
												string sCOLUMN_INDEX               = Sql.ToString(row["COLUMN_INDEX"              ]);
												string sITEMSTYLE_WIDTH            = Sql.ToString(row["ITEMSTYLE_WIDTH"           ]);
												string sITEMSTYLE_CSSCLASS         = Sql.ToString(row["ITEMSTYLE_CSSCLASS"        ]);
												string sITEMSTYLE_HORIZONTAL_ALIGN = Sql.ToString(row["ITEMSTYLE_HORIZONTAL_ALIGN"]);
												string sITEMSTYLE_VERTICAL_ALIGN   = Sql.ToString(row["ITEMSTYLE_VERTICAL_ALIGN"  ]);
												string sITEMSTYLE_WRAP             = Sql.ToString(row["ITEMSTYLE_WRAP"            ]);
												sCOLUMN_INDEX = Strings.Space(nCOLUMN_INDEX_Length - sCOLUMN_INDEX.Length) + sCOLUMN_INDEX;
												if ( !Sql.IsEmptyString(sITEMSTYLE_HORIZONTAL_ALIGN) )
												{
													// 10/02/2013 Paul.  Need to format the SQL so that values get quoted. 
													sb.AppendLine("	exec dbo.spGRIDVIEWS_COLUMNS_UpdateStyle  null, '" + sGRID_NAME + "', " + sCOLUMN_INDEX + ", " + Sql.FormatSQL(sITEMSTYLE_WIDTH, 0) + ", " + Sql.FormatSQL(sITEMSTYLE_CSSCLASS, 0) + ", " + Sql.FormatSQL(sITEMSTYLE_HORIZONTAL_ALIGN, 0) + ", " + Sql.FormatSQL(sITEMSTYLE_VERTICAL_ALIGN, 0) + ", " + (Sql.ToBoolean(sITEMSTYLE_WRAP) ? "1" : "0") + ";");
												}
											}
											sb.AppendLine("end -- if;");
										}
									}
								}
							}
						}
						sb.AppendLine("GO");
						sb.AppendLine("");
						sMessage = sb.ToString();
						Response.ContentType = "text/plain";
						// 12/20/2009 Paul.  Use our own encoding so that a space does not get converted to a +. 
						// 02/16/2010 Paul.  Must include all parts of the name in the encoding. 
						Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode("GRIDVIEWS_COLUMNS " + sNAME + ".1.sql"));
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

