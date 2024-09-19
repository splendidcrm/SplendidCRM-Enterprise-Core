/*
 * Copyright (C) 2021-2024 SplendidCRM Software, Inc. All Rights Reserved. 
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
using System.Xml;
using System.Data;
using System.Text;
using System.Linq;
using System.Threading.Tasks;
using System.Collections;
using System.Collections.Generic;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Authorization;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Diagnostics;
using System.IO;
using SplendidCRM.Pages.Documents;

namespace SplendidCRM.Controllers.MailMerge
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("MailMerge/Rest.svc")]
	public partial class RestController : ControllerBase
	{
		private IHttpContextAccessor httpContextAccessor;
		private IWebHostEnvironment  hostingEnvironment ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private XmlUtil              XmlUtil            ;
		private QueryBuilder         QueryBuilder       ;
		private SplendidCRM.Crm.Modules Modules          ;

		public RestController(IHttpContextAccessor httpContextAccessor, IWebHostEnvironment hostingEnvironment, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, XmlUtil XmlUtil, QueryBuilder QueryBuilder, SplendidCRM.Crm.Modules Modules)
		{
			this.httpContextAccessor = httpContextAccessor;
			this.hostingEnvironment  = hostingEnvironment ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.XmlUtil             = XmlUtil            ;
			this.QueryBuilder        = QueryBuilder       ;
			this.Modules             = Modules            ;
		}

		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetTemplateProperties(Guid DOCUMENT_ID)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));

			string sMODULE_NAME = "Documents";
			int  nACLACCESS = Security.GetUserAccess(sMODULE_NAME, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sMODULE_NAME));
			}
			
			Dictionary<string, object> d       = new Dictionary<string, object>();
			Dictionary<string, object> results = new Dictionary<string, object>();
			d.Add("d", results);

			string sPRIMARY_MODULE   = String.Empty;
			string sSECONDARY_MODULE = String.Empty;
			string sFILENAME         = String.Empty;
			Guid gDOCUMENT_ID = DOCUMENT_ID;
			try
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL ;
					Guid   gDOCUMENT_REVISION_ID = Guid.Empty;
					//string sFILE_MIME_TYPE       = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
					//string sFILENAME             = String.Empty;
					sSQL = "select DOCUMENT_REVISION_ID" + ControlChars.CrLf
					     + "     , FILE_MIME_TYPE      " + ControlChars.CrLf
					     + "     , FILENAME            " + ControlChars.CrLf
					     + "  from vwDOCUMENTS         " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Security.Filter(cmd, "Documents", "view");
						Sql.AppendParameter(cmd, gDOCUMENT_ID, "ID", false);
						cmd.CommandText += "   and IS_TEMPLATE = 1" + ControlChars.CrLf;
						cmd.CommandText += "   and (FILENAME like '%.docx' or FILE_MIME_TYPE = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')" + ControlChars.CrLf;
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								gDOCUMENT_REVISION_ID = Sql.ToGuid  (rdr["DOCUMENT_REVISION_ID"]);
								sFILENAME             = Sql.ToString(rdr["FILENAME"            ]);
							}
						}
					}
					if ( !Sql.IsEmptyGuid(gDOCUMENT_REVISION_ID) )
					{
						byte[] byDocTemplate = null;
						using ( MemoryStream stm = new MemoryStream() )
						{
							using ( BinaryWriter writer = new BinaryWriter(stm) )
							{
								DocumentModel.WriteStream(gDOCUMENT_REVISION_ID, con, writer);
								// 05/12/2011 Paul.  ToArray is easier than GetBuffer as it will return the correct size. 
								stm.Seek(0, SeekOrigin.Begin);
								byDocTemplate = stm.ToArray();
							}
						}
						using ( MemoryStream stm = new MemoryStream() )
						{
							stm.Write(byDocTemplate, 0, byDocTemplate.Length);
							using ( WordprocessingDocument docx = WordprocessingDocument.Open(stm, true) )
							{
								if ( docx.MainDocumentPart != null && docx.MainDocumentPart.DocumentSettingsPart != null && docx.MainDocumentPart.DocumentSettingsPart.Settings != null )
								{
									List<DocumentVariable> docVars = docx.MainDocumentPart.DocumentSettingsPart.Settings.Descendants<DocumentVariable>().ToList();
									foreach ( DocumentVariable v in docVars )
									{
										if ( v.Name == "MasterModule" )
										{
											sPRIMARY_MODULE = v.Val;
										}
										else if ( v.Name == "SecondaryModule" )
										{
											sSECONDARY_MODULE = v.Val;
										}
									}
								}
							}
						}
					}
					else
					{
						throw(new Exception("Document Template not found."));
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
			results.Add("PRIMARY_MODULE"  , sPRIMARY_MODULE  );
			results.Add("SECONDARY_MODULE", sSECONDARY_MODULE);
			results.Add("FILENAME"        , sFILENAME        );
			return d;
		}

		[HttpPost("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public IActionResult Generate(Dictionary<string, object> dict)
		{
			L10N     L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			if ( !Security.IsAuthenticated() )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}

			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone( Sql.ToGuid( Application["CONFIG.default_timezone"] ) );
			string   sPRIMARY_MODULE   = String.Empty;
			string   sSECONDARY_MODULE = String.Empty;
			Guid     gDOCUMENT_ID      = Guid.Empty;
			DataTable dtMain           = new DataTable();
			dtMain.Columns.Add("ID"            , Type.GetType("System.Guid"  ));
			dtMain.Columns.Add("NAME"          , Type.GetType("System.String"));
			dtMain.Columns.Add("MODULE_NAME"   , Type.GetType("System.String"));
			dtMain.Columns.Add("SECONDARY_ID"  , Type.GetType("System.Guid"  ));
			dtMain.Columns.Add("SECONDARY_NAME", Type.GetType("System.String"));
			try
			{
				foreach ( string sName in dict.Keys )
				{
					switch ( sName )
					{
						case "PRIMARY_MODULE"      :  sPRIMARY_MODULE   = Sql.ToString(dict[sName]);  break;
						case "SECONDARY_MODULE"    :  sSECONDARY_MODULE = Sql.ToString(dict[sName]);  break;
						case "DOCUMENT_TEMPLATE_ID":  gDOCUMENT_ID      = Sql.ToGuid  (dict[sName]);  break;
						case "data"                :
						{
							System.Collections.ArrayList arr = dict[sName] as System.Collections.ArrayList;
							if ( arr != null )
							{
								for ( int i = 0; i < arr.Count; i++ )
								{
									Dictionary<string, object> data = arr[i] as Dictionary<string, object>;
									if ( data != null )
									{
										DataRow row = dtMain.NewRow();
										foreach ( string sDataName in data.Keys )
										{
											switch ( sDataName )
											{
												case "ID"            :  row["ID"            ] = Sql.ToGuid  (data[sDataName]);  break;
												case "NAME"          :  row["NAME"          ] = Sql.ToString(data[sDataName]);  break;
												case "MODULE_NAME"   :  row["MODULE_NAME"   ] = Sql.ToString(data[sDataName]);  break;
												case "SECONDARY_ID"  :  row["SECONDARY_ID"  ] = Sql.ToGuid  (data[sDataName]);  break;
												case "SECONDARY_NAME":  row["SECONDARY_NAME"] = Sql.ToString(data[sDataName]);  break;
											}
										}
										if ( Sql.IsEmptyString(row["MODULE_NAME"]) )
										{
											throw(new Exception("Missing MODULE_NAME for record " + Sql.ToString(row["ID"]) + " - " + Sql.ToString(row["NAME"])));
										}
										dtMain.Rows.Add(row);
									}
								}
							}
							break;
						}
					}
				}
			}
			catch(Exception ex)
			{
				Debug.WriteLine(ex.Message);
				throw;
			}
			int nACLACCESS = Security.GetUserAccess(sPRIMARY_MODULE, "list");
			if ( !Sql.ToBoolean(Application["Modules." + sPRIMARY_MODULE + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sPRIMARY_MODULE));
			}
			if ( !Sql.IsEmptyString(sSECONDARY_MODULE) )
			{
				nACLACCESS = Security.GetUserAccess(sSECONDARY_MODULE, "list");
				if ( !Sql.ToBoolean(Application["Modules." + sSECONDARY_MODULE + ".RestEnabled"]) || nACLACCESS < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sSECONDARY_MODULE));
				}
			}
			
			byte[] byResponse = null;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL ;
				Guid   gDOCUMENT_REVISION_ID = Guid.Empty;
				string sFILE_MIME_TYPE       = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
				string sFILENAME             = String.Empty;
				sSQL = "select DOCUMENT_REVISION_ID" + ControlChars.CrLf
				     + "     , FILE_MIME_TYPE      " + ControlChars.CrLf
				     + "     , FILENAME            " + ControlChars.CrLf
				     + "  from vwDOCUMENTS         " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Security.Filter(cmd, "Documents", "view");
					Sql.AppendParameter(cmd, gDOCUMENT_ID, "ID", false);
					cmd.CommandText += "   and IS_TEMPLATE = 1" + ControlChars.CrLf;
					cmd.CommandText += "   and (FILENAME like '%.docx' or FILE_MIME_TYPE = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')" + ControlChars.CrLf;
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							gDOCUMENT_REVISION_ID = Sql.ToGuid  (rdr["DOCUMENT_REVISION_ID"]);
							sFILENAME             = Sql.ToString(rdr["FILENAME"            ]);
						}
					}
				}
				if ( !Sql.IsEmptyGuid(gDOCUMENT_REVISION_ID) )
				{
					byte[] byDocTemplate = null;
					using ( MemoryStream stm = new MemoryStream() )
					{
						using ( BinaryWriter writer = new BinaryWriter(stm) )
						{
							DocumentModel.WriteStream(gDOCUMENT_REVISION_ID, con, writer);
							// 05/12/2011 Paul.  ToArray is easier than GetBuffer as it will return the correct size. 
							stm.Seek(0, SeekOrigin.Begin);
							byDocTemplate = stm.ToArray();
						}
					}
					List<byte[]> lstParts = new List<byte[]>();
					foreach ( DataRow row in dtMain.Rows )
					{
						Guid   gID           = Sql.ToGuid  (row["ID"          ]);
						string sMODULE_NAME  = Sql.ToString(row["MODULE_NAME" ]);
						Guid   gSECONDARY_ID = Sql.ToGuid  (row["SECONDARY_ID"]);
						// 05/17/2011 Paul.  For Campaigns and ProspectLists, the primary record could vary modules. 
						string sTABLE_NAME  = Modules.TableName(sMODULE_NAME);
						Dictionary<string, string> dictValues = new Dictionary<string, string>();
						sSQL = "select * " + ControlChars.CrLf
						     + "  from vw" + sTABLE_NAME + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Security.Filter(cmd, sMODULE_NAME, "view");
							Sql.AppendParameter(cmd, gID, "ID", false);
							using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
							{
								if ( rdr.Read() )
								{
									for ( int nFieldIndex = 0; nFieldIndex < rdr.FieldCount; nFieldIndex++ )
									{
										string sNAME  = rdr.GetName(nFieldIndex).ToLower();
										string sVALUE = Sql.ToString(rdr.GetValue(nFieldIndex));
										// 05/17/2011 Paul.  We will allow the use of templates for either Contacts, Leads or Prospects. 
										if ( sPRIMARY_MODULE == "Campaigns" || sPRIMARY_MODULE == "ProspectLists" )
										{
											dictValues.Add("Contacts_"  + sNAME, sVALUE);
											dictValues.Add("Leads_"     + sNAME, sVALUE);
											dictValues.Add("Prospects_" + sNAME, sVALUE);
										}
										else
										{
											dictValues.Add(sMODULE_NAME + "_" + sNAME, sVALUE);
										}
									}
								}
							}
						}
						if ( !Sql.IsEmptyString(sSECONDARY_MODULE) && !Sql.IsEmptyGuid(gSECONDARY_ID) )
						{
							string sSECONDARY_TABLE = Modules.TableName(sSECONDARY_MODULE);
							sSQL = "select * " + ControlChars.CrLf
							     + "  from vw" + sSECONDARY_TABLE + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Security.Filter(cmd, sSECONDARY_MODULE, "view");
								Sql.AppendParameter(cmd, gSECONDARY_ID, "ID", false);
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									if ( rdr.Read() )
									{
										for ( int nFieldIndex = 0; nFieldIndex < rdr.FieldCount; nFieldIndex++ )
										{
											string sNAME  = sSECONDARY_MODULE + "_" + rdr.GetName(nFieldIndex).ToLower();
											string sVALUE = Sql.ToString(rdr.GetValue(nFieldIndex));
											dictValues.Add(sNAME, sVALUE);
										}
									}
								}
							}
						}
						byte[] byMergedDoc = TRIS.FormFill.Lib.FormFiller.GetWordReport(byDocTemplate, null, dictValues);
						lstParts.Add(byMergedDoc);
					}
					if ( lstParts.Count == 1 )
					{
						Response.Clear();
						Response.ContentType = sFILE_MIME_TYPE;
						Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(sFILENAME));
						byResponse = lstParts[0];
					}
					else
					{
						List<OpenXml.PowerTools.Source> sources = new List<OpenXml.PowerTools.Source>();
						foreach ( byte[] byMergedDoc in lstParts )
						{
							MemoryStream stream = new MemoryStream();
							stream.Write(byMergedDoc, 0, byMergedDoc.Length);
							WordprocessingDocument docx = WordprocessingDocument.Open(stream, true);
							sources.Add(new OpenXml.PowerTools.Source(docx, true));
						}
						// 05/12/2011 Paul.  Using DocumentBuilder has the advantage of adding section breaks between the merged documents. 
						using ( MemoryStream stm = new MemoryStream() )
						{
							using ( WordprocessingDocument docx = OpenXml.PowerTools.DocumentBuilder.BuildOpenDocument(sources, stm) )
							{
								//docx.Close();
							}
							
							Response.Clear();
							Response.ContentType = sFILE_MIME_TYPE;
							Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(sFILENAME));
							// 05/12/2011 Paul.  We need to use stm.ToArray() as stm.GetBuffer() causes an error: "There was an error opening the file."
							stm.Seek(0, SeekOrigin.Begin);
							byResponse = stm.ToArray();
						}
					}
				}
				else
				{
					throw(new Exception("Document Template not found."));
				}
			}
			return File(byResponse, Response.ContentType);
		}
	}
}
