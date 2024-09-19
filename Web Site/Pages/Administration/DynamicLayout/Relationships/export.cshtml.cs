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
using DocumentFormat.OpenXml.Wordprocessing;

namespace SplendidCRM.Administration.DynamicLayout.Relationships
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
						// 08/17/2024 Paul.  Mark record as deleted instead of deleting. 
						//sb.AppendLine("delete from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = '" + sNAME + "';");
						sb.AppendLine("update DETAILVIEWS_RELATIONSHIPS set DELETED = 1, DATE_MODIFIED_UTC = getutcdate(), MODIFIED_USER_ID = null where DELETED = 0 and DETAIL_NAME = '" + sNAME + "';");
				
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL;
							sSQL = "select *                          " + ControlChars.CrLf
							     + "  from vwDETAILVIEWS_RELATIONSHIPS" + ControlChars.CrLf
							     + " where DETAIL_NAME  = @DETAIL_NAME" + ControlChars.CrLf
							     + " order by RELATIONSHIP_ORDER      " + ControlChars.CrLf;
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
											int nRELATIONSHIP_ORDER_Length = 2;
											int nDETAIL_NAME_Length        = 4;
											int nMODULE_NAME_Length        = 4;
											int nCONTROL_NAME_Length       = 4;
											int nTITLE_Length              = 4;
											int nTABLE_NAME_Length         = 4;
											int nPRIMARY_FIELD_Length      = 4;
											int nSORT_FIELD_Length         = 4;
											int nSORT_DIRECTION_Length     = 4;
											foreach(DataRow row in dtFields.Rows)
											{
												nRELATIONSHIP_ORDER_Length = Math.Max(nRELATIONSHIP_ORDER_Length, Sql.EscapeSQL(Sql.ToString(row["RELATIONSHIP_ORDER"])).Length);
												nDETAIL_NAME_Length        = Math.Max(nDETAIL_NAME_Length       , Sql.EscapeSQL(Sql.ToString(row["DETAIL_NAME"       ])).Length + 2);
												nMODULE_NAME_Length        = Math.Max(nMODULE_NAME_Length       , Sql.EscapeSQL(Sql.ToString(row["MODULE_NAME"       ])).Length + 2);
												nCONTROL_NAME_Length       = Math.Max(nCONTROL_NAME_Length      , Sql.EscapeSQL(Sql.ToString(row["CONTROL_NAME"      ])).Length + 2);
												nTITLE_Length              = Math.Max(nTITLE_Length             , Sql.EscapeSQL(Sql.ToString(row["TITLE"             ])).Length + 2);
												nTABLE_NAME_Length         = Math.Max(nTABLE_NAME_Length        , Sql.EscapeSQL(Sql.ToString(row["TABLE_NAME"        ])).Length + 2);
												nPRIMARY_FIELD_Length      = Math.Max(nPRIMARY_FIELD_Length     , Sql.EscapeSQL(Sql.ToString(row["PRIMARY_FIELD"     ])).Length + 2);
												nSORT_FIELD_Length         = Math.Max(nSORT_FIELD_Length        , Sql.EscapeSQL(Sql.ToString(row["SORT_FIELD"        ])).Length + 2);
												nSORT_DIRECTION_Length     = Math.Max(nSORT_DIRECTION_Length    , Sql.EscapeSQL(Sql.ToString(row["SORT_DIRECTION"    ])).Length + 2);
											}

											sb.AppendLine("if not exists(select * from DETAILVIEWS_RELATIONSHIPS where DETAIL_NAME = '" + sNAME + "' and DELETED = 0) begin -- then");
											sb.AppendLine("	print 'DETAILVIEWS_RELATIONSHIPS " + sNAME + "';");

											for ( int nRELATIONSHIP_ORDER = 0; nRELATIONSHIP_ORDER < dtFields.Rows.Count; nRELATIONSHIP_ORDER++ )
											{
												DataRow row = dtFields.Rows[nRELATIONSHIP_ORDER];
												string sDETAIL_NAME         = Sql.ToString(row["DETAIL_NAME"       ]);
												string sMODULE_NAME         = Sql.ToString(row["MODULE_NAME"       ]);
												string sCONTROL_NAME        = Sql.ToString(row["CONTROL_NAME"      ]);
												string sRELATIONSHIP_ORDER  = Sql.ToString(row["RELATIONSHIP_ORDER"]);
												string sTITLE               = Sql.ToString(row["TITLE"             ]);
												string sTABLE_NAME          = Sql.ToString(row["TABLE_NAME"        ]);
												string sPRIMARY_FIELD       = Sql.ToString(row["PRIMARY_FIELD"     ]);
												string sSORT_FIELD          = Sql.ToString(row["SORT_FIELD"        ]);
												string sSORT_DIRECTION      = Sql.ToString(row["SORT_DIRECTION"    ]);

												// 08/17/2024 Paul.  Renumber to prevent gaps. 
												sRELATIONSHIP_ORDER = nRELATIONSHIP_ORDER.ToString();
												sRELATIONSHIP_ORDER = Strings.Space(nRELATIONSHIP_ORDER_Length - sRELATIONSHIP_ORDER.Length) + sRELATIONSHIP_ORDER;
												sb.AppendLine("	exec dbo.spDETAILVIEWS_RELATIONSHIPS_InsertOnly "
													+ Sql.FormatSQL(sDETAIL_NAME       , nDETAIL_NAME_Length    ) + ", "
													+ Sql.FormatSQL(sMODULE_NAME       , nMODULE_NAME_Length    ) + ", "
													+ Sql.FormatSQL(sCONTROL_NAME      , nCONTROL_NAME_Length   ) + ", "
													+               sRELATIONSHIP_ORDER                           + ", "
													+ Sql.FormatSQL(sTITLE             , nTITLE_Length          ) + ", "
													+ Sql.FormatSQL(sTABLE_NAME        , nTABLE_NAME_Length     ) + ", "
													+ Sql.FormatSQL(sPRIMARY_FIELD     , nPRIMARY_FIELD_Length  ) + ", "
													+ Sql.FormatSQL(sSORT_FIELD        , nSORT_FIELD_Length     ) + ", "
													+ Sql.FormatSQL(sSORT_DIRECTION    , nSORT_DIRECTION_Length )
													+ ";");
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
						Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode("DETAILVIEWS_RELATIONSHIPS " + sNAME + ".1.sql"));
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

