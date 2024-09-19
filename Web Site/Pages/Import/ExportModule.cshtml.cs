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
using System.Text.Json;
using System.Threading.Tasks;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Text;

namespace SplendidCRM.Pages.Import
{
	[Authorize]
	[SplendidSessionAuthorize]
	[IgnoreAntiforgeryToken(Order = 1001)]
	public class ExportModuleModel : PageModel
	{
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SplendidError        SplendidError      ;
		private RestUtil             RestUtil           ;
		private SplendidDynamic      SplendidDynamic    ;
		private SplendidExport       SplendidExport     ;

		public ExportModuleModel(HttpSessionState Session, Security Security, Sql Sql, SplendidError SplendidError, RestUtil RestUtil, SplendidDynamic SplendidDynamic, SplendidExport SplendidExport)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SplendidError       = SplendidError      ;
			this.RestUtil            = RestUtil           ;
			this.SplendidDynamic     = SplendidDynamic    ;
			this.SplendidExport      = SplendidExport     ;
		}

		public async Task<IActionResult> OnPostAsync()
		{
			string sMessage = String.Empty;
			try
			{
				Response.Headers.Add("Cache-Control", "no-cache");
				Response.Headers.Add("Pragma", "no-cache");
				L10N L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));

				Request.EnableBuffering();
				Request.Body.Position = 0;
				string sRequest = String.Empty;
				using ( StreamReader stmRequest = new StreamReader(Request.Body, System.Text.Encoding.UTF8) )
				{
					sRequest = await stmRequest.ReadToEndAsync();
				}
				// http://weblogs.asp.net/hajan/archive/2010/07/23/javascriptserializer-dictionary-to-json-serialization-and-deserialization.aspx
				Dictionary<string, object> dict = new Dictionary<string, object>();
				if ( !Sql.IsEmptyString(sRequest) )
					dict = JsonSerializer.Deserialize<Dictionary<string, object>>(sRequest);

				string ModuleName        = Sql.ToString (Request.Query["ModuleName"]);
				int    nSKIP             = Sql.ToInteger(Request.Query["$skip"     ]);
				int    nTOP              = Sql.ToInteger(Request.Query["$top"      ]);
				// 11/18/2019 Paul.  Move exclusively to SqlSearchClause. 
				// 08/11/2020 Paul.  Revert back to query string support. 
				string sFILTER           = Sql.ToString (Request.Query["$filter"   ]);
				string sORDER_BY         = Sql.ToString (Request.Query["$orderby"  ]);
				// 06/17/2013 Paul.  Add support for GROUP BY. 
				string sGROUP_BY         = Sql.ToString (Request.Query["$groupby"  ]);
				// 08/03/2011 Paul.  We need a way to filter the columns so that we can be efficient. 
				string sSELECT           = Sql.ToString (Request.Query["$select"   ]);
				// 09/09/2019 Paul.  Send duplicate filter info. 
				string sDUPLICATE_FIELDS = Sql.ToString (Request.Query["$duplicatefields"]);
				// 12/03/2019 Paul.  The React Client needs access to archive data. 
				bool   bArchiveView      = Sql.ToBoolean(Request.Query["$archiveView"]);
				// 08/11/2020 Paul.  Allow values in query string. 
				string jsonSEARCH_VALUES = Sql.ToString (Request.Query["$searchvalues"]);
				Dictionary<string, object> dictSearchValues = null;
				if ( !Sql.IsEmptyString(jsonSEARCH_VALUES) )
				{
					dictSearchValues = JsonSerializer.Deserialize<Dictionary<string, object>>(jsonSEARCH_VALUES);
				}
			
				Regex r = new Regex(@"[^A-Za-z0-9_]");
				// 10/19/2016 Paul.  We need to filter out quoted strings. 
				string sFILTER_KEYWORDS = Sql.SqlFilterLiterals(sFILTER);
				sFILTER_KEYWORDS = (" " + r.Replace(sFILTER_KEYWORDS, " ") + " ").ToLower();
				// 10/19/2016 Paul.  Add more rules to allow select keyword to be part of the contents. 
				// We do this to allow Full-Text Search, which is implemented as a sub-query. 
				int nSelectIndex     = sFILTER_KEYWORDS.IndexOf(" select "            );
				int nFromIndex       = sFILTER_KEYWORDS.IndexOf(" from "              );
				// 11/18/2019 Paul.  Remove all support for subqueries now that we support Post with search values. 
				//int nContainsIndex   = sFILTER_KEYWORDS.IndexOf(" contains "          );
				//int nConflictedIndex = sFILTER_KEYWORDS.IndexOf(" _remote_conflicted ");
				//// 07/26/2018 Paul.  Allow a normalized phone search that used the special phone tables. 
				//int nPhoneTableIndex = sFILTER_KEYWORDS.IndexOf(" vwphone_numbers_"   );
				//int nNormalizeIndex  = sFILTER_KEYWORDS.IndexOf(" normalized_number " );
				if ( nSelectIndex >= 0 && nFromIndex > nSelectIndex )
				{
					//if ( !(nContainsIndex > nFromIndex || nConflictedIndex > nFromIndex || (nPhoneTableIndex > nFromIndex && nNormalizeIndex > nPhoneTableIndex )) )
						throw(new Exception("Subqueries are not allowed."));
				}

				string     sExportFormat    = Sql.ToString(Request.Query["$exportformat" ]);
				string     sExportRange     = Sql.ToString(Request.Query["$exportrange"  ]);
				string     sSelecteditems   = Sql.ToString(Request.Query["$selecteditems"]);
				List<Guid> arrSelectedItems = new List<Guid>();
				if ( !Sql.IsEmptyString(sSelecteditems) )
				{
					string[] arr = sSelecteditems.Split(',');
					for ( int i = 0; i < arr.Length; i++ )
					{
						Guid g =Sql.ToGuid(arr[i]);
						if ( !Sql.IsEmptyGuid(g) )
						{
							arrSelectedItems.Add(g);
						}
					}
				}
				// 05/05/2013 Paul.  We need to convert the date to the user's timezone. 
				Guid     gTIMEZONE = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
				TimeZone T10n      = TimeZone.CreateTimeZone(gTIMEZONE);
				try
				{
					foreach ( string sName in dict.Keys )
					{
						switch ( sName )
						{
							case "ModuleName"      :  ModuleName        = Sql.ToString (dict[sName]);  break;
							case "$skip"           :  nSKIP             = Sql.ToInteger(dict[sName]);  break;
							case "$top"            :  nTOP              = Sql.ToInteger(dict[sName]);  break;
							case "$filter"         :  sFILTER           = Sql.ToString (dict[sName]);  break;
							case "$orderby"        :  sORDER_BY         = Sql.ToString (dict[sName]);  break;
							case "$groupby"        :  sGROUP_BY         = Sql.ToString (dict[sName]);  break;
							case "$select"         :  sSELECT           = Sql.ToString (dict[sName]);  break;
							case "$duplicatefields":  sDUPLICATE_FIELDS = Sql.ToString (dict[sName]);  break;
							case "$archiveView"    :  bArchiveView      = Sql.ToBoolean(dict[sName]);  break;
							case "$searchvalues"   :  dictSearchValues  = dict[sName] as Dictionary<string, object>;  break;
							case "$exportformat"   :  sExportFormat     = Sql.ToString (dict[sName]);  break;
							case "$exportrange"    :  sExportRange      = Sql.ToString (dict[sName]);  break;
							case "$selecteditems"  :
							{
								sSelecteditems = Sql.ToString (dict[sName]);
								if ( !Sql.IsEmptyString(sSelecteditems) )
								{
									string[] arr = sSelecteditems.Split(',');
									for ( int i = 0; i < arr.Length; i++ )
									{
										Guid g =Sql.ToGuid(arr[i]);
										if ( !Sql.IsEmptyGuid(g) )
										{
											arrSelectedItems.Add(g);
										}
									}
								}
								break;
							}
						}
					}
					if ( dictSearchValues != null )
					{
						string sSEARCH_VALUES = Sql.SqlSearchClause(dictSearchValues);
						// 11/18/2019 Paul.  We need to combine sFILTER with sSEARCH_VALUES. 
						if ( !Sql.IsEmptyString(sSEARCH_VALUES) )
						{
							// 11/18/2019 Paul.  The search clause will always start with an "and" if it exists. 
							if ( !Sql.IsEmptyString(sFILTER) )
							{
								sFILTER = sFILTER + sSEARCH_VALUES;
							}
							else
							{
								sFILTER = "1 = 1 " + sSEARCH_VALUES;
							}
						}
					}
				}
				catch(Exception ex)
				{
					Debug.WriteLine(ex.Message);
					throw;
				}
				if ( Sql.IsEmptyString(ModuleName) )
					throw(new Exception("The module name must be specified."));
				if ( Sql.IsEmptyString(sExportFormat) )
					throw(new Exception("The export format must be specified."));
				if ( Sql.IsEmptyString(sExportRange) )
					throw(new Exception("The export range must be specified."));
				if ( sExportRange == "All" )
				{
					nSKIP = 0;
					nTOP = -1;
				}
				else if ( sExportRange == "Page" )
				{
					arrSelectedItems.Clear();
				}
				else if ( sExportRange == "Selected" )
				{
					// 10/17/2006 Paul.  There must be one selected record to continue. 
					if ( arrSelectedItems.Count == 0 )
						throw(new Exception(L10n.Term(".LBL_LISTVIEW_NO_SELECTED")));
				}
				else
				{
					throw(new Exception("The valid export range must be specified."));
				}
				// 12/15/2019 Paul.  Export has a layout list. 
				UniqueStringCollection arrSelectFields = new UniqueStringCollection();
				sSELECT = SplendidDynamic.ExportGridColumns(ModuleName + ".Export", arrSelectFields);

				string sTABLE_NAME = Sql.ToString(Application["Modules." + ModuleName + ".TableName"]);
				// 02/29/2016 Paul.  Product Catalog is different than Product Templates. 
				if ( ModuleName == "ProductCatalog" )
					sTABLE_NAME = "PRODUCT_CATALOG";
				// 09/09/2019 Paul.  The Activities module collies with the Calendar list, so we have to make an exception. 
				if ( ModuleName == "Activities" )
					sTABLE_NAME = "vwACTIVITIES";
				// 09/09/2019 Paul.  The Employees module refers to the USERS table, so correct. 
				if ( ModuleName == "Employees" )
					sTABLE_NAME = "vwEMPLOYEES_Sync";
				if ( Sql.IsEmptyString(sTABLE_NAME) )
					throw(new Exception("Unknown module: " + ModuleName));
				// 08/22/2011 Paul.  Add admin control to REST API. 
				int nACLACCESS = Security.GetUserAccess(ModuleName, "export");
				if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + ModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
				{
					// 09/06/2017 Paul.  Include module name in error. 
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + Sql.ToString(ModuleName)));
				}
				UniqueStringCollection arrSELECT = new UniqueStringCollection();
				// 08/11/2020 Paul.  We don't need to remove spaces as the string comes from SplendidDynamic.ExportGridColumns(). 
				//sSELECT = sSELECT.Replace(" ", "");
				if ( !Sql.IsEmptyString(sSELECT) )
				{
					foreach ( string s in sSELECT.Split(',') )
					{
						//string sColumnName = r.Replace(s, "");
						if ( !Sql.IsEmptyString(s) )
							arrSELECT.Add(s);
					}
				}
			
				// 06/17/2013 Paul.  Add support for GROUP BY. 
				// 04/21/2017 Paul.  We need to return the total when using nTOP. 
				long lTotalCount = 0;
				// 05/21/2017 Paul.  HTML5 Dashboard requires aggregates. 
				// 08/01/2019 Paul.  We need a ListView and EditView flags for the Rest Client. 
				// 09/09/2019 Paul.  Send duplicate filter info. 
				// 10/26/2019 Paul.  Return the SQL to the React Client. 
				StringBuilder sbDumpSQL = new StringBuilder();
				// 12/03/2019 Paul.  The React Client needs access to archive data. 
				// 12/16/2019 Paul.  Moved GetTable to ~/_code/RestUtil.cs
				DataTable dt = new DataTable();
				bool bIsAdmin = Sql.ToBoolean(Application["Modules." + ModuleName + ".IsAdmin"]);
				if ( bIsAdmin )
				{
					if ( !Sql.IsEmptyString(ModuleName) && !sTABLE_NAME.StartsWith("OAUTH") && !sTABLE_NAME.StartsWith("USERS_PASSWORD") && !sTABLE_NAME.EndsWith("_AUDIT") && !sTABLE_NAME.EndsWith("_STREAM") )
					{
						if ( Security.AdminUserAccess(ModuleName, "access") >= 0 )
						{
							// 10/26/2019 Paul.  Return the SQL to the React Client. 
							// 12/16/2019 Paul.  Moved GetTable to ~/_code/RestUtil.cs
							// 10/16/2020 Paul.  Use AccessMode.list so that we use the _List view if available. 
							dt = RestUtil.GetAdminTable(sTABLE_NAME, nSKIP, nTOP, sFILTER, sORDER_BY, sGROUP_BY, arrSELECT, arrSelectedItems.ToArray(), ref lTotalCount, null, AccessMode.list, sbDumpSQL);
						}
						else
						{
							throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
						}
					}
					else
					{
						throw(new Exception("Unsupported module: " + ModuleName));
					}
				}
				else
				{
					dt = RestUtil.GetTable(sTABLE_NAME, nSKIP, nTOP, sFILTER, sORDER_BY, sGROUP_BY, arrSELECT, arrSelectedItems.ToArray(), ref lTotalCount, null, AccessMode.list, bArchiveView, sDUPLICATE_FIELDS, sbDumpSQL);
				}
				DataView vwMain = new DataView(dt);
				// 12/14/2019 Paul.  I'm not sure why this was necessary in the ListView code, but we are going to rely upon the Security.Filter() to manage. 
				//if ( nACLACCESS == ACL_ACCESS.OWNER )
				//	vwMain.RowFilter = "ASSIGNED_USER_ID = '" + Security.USER_ID.ToString() + "'";

				//SplendidExport.Export(vwMain, ModuleName, sExportFormat, sExportRange, 0, nTOP, null, true);
				int    nStartRecord        = 0;
				int    nEndRecord          = vwMain.Count;

				MemoryStream OutputStream = new MemoryStream();
				switch ( sExportFormat )
				{
					case "csv"  :
					{
						Response.ContentType = "text/csv";
						// 08/06/2008 yxy21969.  Make sure to encode all URLs. 
						// 12/20/2009 Paul.  Use our own encoding so that a space does not get converted to a +. 
						Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(ModuleName + ".csv"));
						SplendidExport.ExportDelimited(OutputStream, vwMain, ModuleName, nStartRecord, nEndRecord, ',' );
						OutputStream.Seek(0, SeekOrigin.Begin);
						return File(OutputStream, Response.ContentType);
					}
					case "tab"  :
					{
						// 08/17/2024 Paul.  The correct MIME type is text/plain. 
						Response.ContentType = "text/plain";
						// 08/06/2008 yxy21969.  Make sure to encode all URLs. 
						// 12/20/2009 Paul.  Use our own encoding so that a space does not get converted to a +. 
						Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(ModuleName + ".txt"));
						SplendidExport.ExportDelimited(OutputStream, vwMain, ModuleName, nStartRecord, nEndRecord, '\t');
						OutputStream.Seek(0, SeekOrigin.Begin);
						return File(OutputStream, Response.ContentType);
					}
					case "xml"  :
					{
						Response.ContentType = "text/xml";
						// 08/06/2008 yxy21969.  Make sure to encode all URLs. 
						// 12/20/2009 Paul.  Use our own encoding so that a space does not get converted to a +. 
						Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(ModuleName + ".xml"));
						SplendidExport.ExportXml(OutputStream, vwMain, ModuleName, nStartRecord, nEndRecord);
						OutputStream.Seek(0, SeekOrigin.Begin);
						return File(OutputStream, Response.ContentType);
					}
					//case "Excel":
					default     :
					{
						// 08/25/2012 Paul.  Change Excel export type to use Open XML as the previous format is not supported on Office 2010. 
						Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";  //"application/vnd.ms-excel";
						// 08/25/2012 Paul.  Change Excel export type to use Open XML as the previous format is not supported on Office 2010. 
						// 12/20/2009 Paul.  Use our own encoding so that a space does not get converted to a +. 
						Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(ModuleName + ".xlsx"));
						SplendidExport.ExportExcelOpenXML(OutputStream, vwMain, ModuleName, nStartRecord, nEndRecord);
						// 08/11/2020 Paul.  Flush is critical, otherwise we get extra bytes and Excel reports the file as corrupt. 
						//Response.Flush();
						OutputStream.Seek(0, SeekOrigin.Begin);
						return File(OutputStream, Response.ContentType);
					}
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
