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

namespace SplendidCRM.Administration.DynamicLayout.DetailViews
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
						//sb.AppendLine("delete from DETAILVIEWS_FIELDS where DETAIL_NAME = '" + sNAME + "';");
						sb.AppendLine("update DETAILVIEWS_FIELDS set DELETED = 1, DATE_MODIFIED_UTC = getutcdate(), MODIFIED_USER_ID = null where DELETED = 0 and DETAIL_NAME = '" + sNAME + "';");
				
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select *                         " + ControlChars.CrLf
							     + "  from vwDETAILVIEWS_FIELDS      " + ControlChars.CrLf
							     + " where DETAIL_NAME = @DETAIL_NAME" + ControlChars.CrLf
							     + "   and DEFAULT_VIEW = 0          " + ControlChars.CrLf
							     + " order by FIELD_INDEX            " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@DETAIL_NAME", sNAME);
					
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									using ( DataTable dtFields = new DataTable() )
									{
										da.Fill(dtFields);
										if ( dtFields.Rows.Count > 0 )
										{
											int nFIELD_INDEX_Length = 2;
											int nDATA_LABEL_Length  = 4;
											int nDATA_FIELD_Length  = 4;
											int nDATA_FORMAT_Length = 4;
											int nLIST_NAME_Length   = 4;
											int nURL_FIELD_Length   = 4;
											int nURL_FORMAT_Length  = 4;
											int nURL_TARGET_Length  = 4;
											foreach(DataRow row in dtFields.Rows)
											{
												nFIELD_INDEX_Length = Math.Max(nFIELD_INDEX_Length, Sql.EscapeSQL(Sql.ToString(row["FIELD_INDEX"])).Length);
												nDATA_LABEL_Length  = Math.Max(nDATA_LABEL_Length , Sql.EscapeSQL(Sql.ToString(row["DATA_LABEL" ])).Length + 2);
												nDATA_FIELD_Length  = Math.Max(nDATA_FIELD_Length , Sql.EscapeSQL(Sql.ToString(row["DATA_FIELD" ])).Length + 2);
												nDATA_FORMAT_Length = Math.Max(nDATA_FORMAT_Length, Sql.EscapeSQL(Sql.ToString(row["DATA_FORMAT"])).Length + 2);
												nLIST_NAME_Length   = Math.Max(nLIST_NAME_Length  , Sql.EscapeSQL(Sql.ToString(row["LIST_NAME"  ])).Length + 2);
												nURL_FIELD_Length   = Math.Max(nURL_FIELD_Length  , Sql.EscapeSQL(Sql.ToString(row["URL_FIELD"  ])).Length + 2);
												nURL_FORMAT_Length  = Math.Max(nURL_FORMAT_Length , Sql.EscapeSQL(Sql.ToString(row["URL_FORMAT" ])).Length + 2);
												nURL_TARGET_Length  = Math.Max(nURL_TARGET_Length , Sql.EscapeSQL(Sql.ToString(row["URL_TARGET" ])).Length + 2);
											}

											sb.AppendLine("if not exists(select * from DETAILVIEWS_FIELDS where DETAIL_NAME = '" + sNAME + "' and DELETED = 0) begin -- then");
											sb.AppendLine("	print 'DETAILVIEWS_FIELDS " + sNAME + "';");

											string sLABEL_WIDTH  = Sql.ToString(dtFields.Rows[0]["LABEL_WIDTH" ]);
											string sFIELD_WIDTH  = Sql.ToString(dtFields.Rows[0]["FIELD_WIDTH" ]);
											string sDATA_COLUMNS = Sql.ToString(dtFields.Rows[0]["DATA_COLUMNS"]);
											string sVIEW_NAME    = Sql.ToString(dtFields.Rows[0]["VIEW_NAME"   ]);
											string sMODULE_NAME  = Sql.ToString(dtFields.Rows[0]["MODULE_NAME" ]);
											if ( Sql.IsEmptyString(sDATA_COLUMNS) ) sDATA_COLUMNS = "null";
											sb.AppendLine("	exec dbo.spDETAILVIEWS_InsertOnly          '" + sNAME + "', " + Sql.FormatSQL(sMODULE_NAME, 0) + ", " + Sql.FormatSQL(sVIEW_NAME, 0) + ", " + Sql.FormatSQL(sLABEL_WIDTH, 0) + ", " + Sql.FormatSQL(sFIELD_WIDTH, 0) + ", " + sDATA_COLUMNS + ";");
											foreach(DataRow row in dtFields.Rows)
											{
												string sDETAIL_NAME = Sql.ToString(row["DETAIL_NAME"]);
												string sFIELD_INDEX = Sql.ToString(row["FIELD_INDEX"]);
												string sFIELD_TYPE  = Sql.ToString(row["FIELD_TYPE" ]);
												string sDATA_LABEL  = Sql.ToString(row["DATA_LABEL" ]);
												string sDATA_FIELD  = Sql.ToString(row["DATA_FIELD" ]);
												string sDATA_FORMAT = Sql.ToString(row["DATA_FORMAT"]);
												string sURL_FIELD   = Sql.ToString(row["URL_FIELD"  ]);
												string sURL_FORMAT  = Sql.ToString(row["URL_FORMAT" ]);
												string sURL_TARGET  = Sql.ToString(row["URL_TARGET" ]);
												string sLIST_NAME   = Sql.ToString(row["LIST_NAME"  ]);
												string sCOLSPAN     = Sql.ToString(row["COLSPAN"    ]);
												// 06/12/2009 Paul.  Add TOOL_TIP for help hover.
												string sTOOL_TIP    = Sql.ToString(row["TOOL_TIP"   ]);
												// 02/16/2010 Paul.  Add MODULE_TYPE so that we can lookup custom field IDs. 
												string sMODULE_TYPE = Sql.ToString(row["MODULE_TYPE"]);
										
												sFIELD_INDEX = Strings.Space(nFIELD_INDEX_Length - sFIELD_INDEX.Length) + sFIELD_INDEX;
												if ( Sql.IsEmptyString(sCOLSPAN          ) || sCOLSPAN        == "0" ) sCOLSPAN           = "null";
												switch ( sFIELD_TYPE )
												{
													case "Blank"     :  sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_InsBlank      '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + sCOLSPAN + ";");  break;
													case "CheckBox"  :  sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_InsCheckBox   '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + Sql.FormatSQL(sDATA_LABEL, nDATA_LABEL_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + sCOLSPAN + ";");  break;
													// 02/16/2010 Paul.  Add MODULE_TYPE so that we can lookup custom field IDs. 
													// 09/21/2012 Paul.  Fix parameters to spDETAILVIEWS_FIELDS_InsModuleLink. 
													// 04/08/2018 Paul.  Single quote needed to be removed. 
													case "ModuleLink":  sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_InsModuleLink '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + Sql.FormatSQL(sDATA_LABEL, nDATA_LABEL_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sDATA_FORMAT, nDATA_FORMAT_Length) + ", " + Sql.FormatSQL(sURL_FIELD, nURL_FIELD_Length) + ", " + Sql.FormatSQL(sURL_TARGET, nURL_TARGET_Length) + ", " + Sql.FormatSQL(sMODULE_TYPE, 0) + ", " + sCOLSPAN + ";");  break;
													case "HyperLink" :
														if ( Sql.IsEmptyString(sMODULE_TYPE) )
															            sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_InsHyperLink  '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + Sql.FormatSQL(sDATA_LABEL, nDATA_LABEL_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sDATA_FORMAT, nDATA_FORMAT_Length) + ", " + Sql.FormatSQL(sURL_FIELD, nURL_FIELD_Length) + ", " + Sql.FormatSQL(sURL_FORMAT, nURL_FORMAT_Length) + ", " + Sql.FormatSQL(sURL_TARGET, nURL_TARGET_Length) + ", " + sCOLSPAN + ";");
														else
															            sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_InsModuleLink '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + Sql.FormatSQL(sDATA_LABEL, nDATA_LABEL_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sDATA_FORMAT, nDATA_FORMAT_Length) + ", " + Sql.FormatSQL(sURL_FIELD, nURL_FIELD_Length) + ", " + Sql.FormatSQL(sURL_TARGET, nURL_TARGET_Length) + ", " + Sql.FormatSQL(sMODULE_TYPE, 0) + ", " + sCOLSPAN + ";");
															break;
													case "String"    :
														if ( Sql.IsEmptyString(sLIST_NAME) )
														{
															if ( Sql.IsEmptyString(sMODULE_TYPE) )
															            sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_InsBound      '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + Sql.FormatSQL(sDATA_LABEL, nDATA_LABEL_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sDATA_FORMAT, nDATA_FORMAT_Length) + ", " + sCOLSPAN + ";");
															else
															            sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_InsModule     '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + Sql.FormatSQL(sDATA_LABEL, nDATA_LABEL_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sDATA_FORMAT, nDATA_FORMAT_Length) + ", '" + sMODULE_TYPE + "', " + sCOLSPAN + ";");
														}
														else
															            sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_InsBoundList  '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + Sql.FormatSQL(sDATA_LABEL, nDATA_LABEL_Length) + ", " + Sql.FormatSQL(sDATA_FIELD, nDATA_FIELD_Length) + ", " + Sql.FormatSQL(sDATA_FORMAT, nDATA_FORMAT_Length) + ", " + Sql.FormatSQL(sLIST_NAME  , nLIST_NAME_Length  ) + ", " + sCOLSPAN + ";");
														break;
													default          :  sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_InsertOnly    '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + Sql.FormatSQL(sFIELD_TYPE, 0) + ", " + Sql.FormatSQL(sDATA_LABEL, 0) + ", " + Sql.FormatSQL(sDATA_FIELD, 0) + ", " + Sql.FormatSQL(sDATA_FORMAT, 0) + ", " + Sql.FormatSQL(sURL_FIELD, 0) + ", " + Sql.FormatSQL(sURL_FORMAT, 0) + ", " + Sql.FormatSQL(sURL_TARGET, 0) + ", " + Sql.FormatSQL(sLIST_NAME, 0) + ", " + sCOLSPAN + ";");  break;
												}
												// 06/12/2009 Paul.  Add TOOL_TIP for help hover.
												if ( !Sql.IsEmptyString(sTOOL_TIP) )
												{
													// 09/20/2012 Paul.  Remove break at the end of the line. 
													sb.AppendLine("	exec dbo.spDETAILVIEWS_FIELDS_UpdateTip  null, '" + sDETAIL_NAME + "', " + sFIELD_INDEX + ", " + Sql.FormatSQL(sTOOL_TIP, 0) + ";");
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
						// 08/17/2024 Paul.  Use our own encoding so that a space does not get converted to a +. 
						// 08/17/2024 Paul.  Must include all parts of the name in the encoding. 
						Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode("DETAILVIEWS_FIELDS " + sNAME + ".1.sql"));
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

