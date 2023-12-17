/*
 * Copyright (C) 2019-2023 SplendidCRM Software, Inc. All Rights Reserved. 
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
using System.Net;
using System.Web;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Authorization;

using SplendidCRM;
using System.Xml;
using DocumentFormat.OpenXml.Presentation;
using System.Data.Common;
using SplendidCRM.Crm;

namespace SplendidCRM.Controllers.Administration.DataPrivacy
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/DataPrivacy/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "DataPrivacy";
		private IMemoryCache         memoryCache        ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private L10N                 L10n               ;
		private TimeZone             TimeZone           = new TimeZone();
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private Crm.Modules          Modules            ;

		public RestController(IMemoryCache memoryCache, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, Crm.Modules Modules)
		{
			this.memoryCache         = memoryCache        ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.Modules             = Modules            ;
		}

		// 02/05/2018 Paul.  Provide a way to convert ID to NAME for custom fields. 
		// 04/04/2021 Paul.  Make stack so that it can be used by React client. 
		private static DataTable BuildChangesTable(L10N L10n, string sModule, DataTable dtAudit, DataTable dtDATA_PRIVACY_FIELDS, List<string> lstMarkedFields)
		{
			DataTable dtChanges = new DataTable();
			DataColumn colFIELD_NAME   = new DataColumn("FIELD_NAME"  , typeof(System.String  ));
			DataColumn colFIELD_LABEL  = new DataColumn("FIELD_LABEL" , typeof(System.String  ));
			DataColumn colCHECKED      = new DataColumn("CHECKED"     , typeof(System.String  ));
			DataColumn colVALUE        = new DataColumn("VALUE"       , typeof(System.String  ));
			DataColumn colMODIFIED_BY  = new DataColumn("MODIFIED_BY" , typeof(System.String  ));
			DataColumn colLEAD_SOURCE  = new DataColumn("LEAD_SOURCE" , typeof(System.String  ));
			DataColumn colLAST_UPDATED = new DataColumn("LAST_UPDATED", typeof(System.DateTime));
			dtChanges.Columns.Add(colFIELD_NAME  );
			dtChanges.Columns.Add(colFIELD_LABEL );
			dtChanges.Columns.Add(colCHECKED     );
			dtChanges.Columns.Add(colVALUE       );
			dtChanges.Columns.Add(colMODIFIED_BY );
			dtChanges.Columns.Add(colLEAD_SOURCE );
			dtChanges.Columns.Add(colLAST_UPDATED);
			if ( dtAudit.Rows.Count > 0 )
			{
				foreach ( DataRow rowPrivacyField in dtDATA_PRIVACY_FIELDS.Rows )
				{
					string sPRIVACY_FIELD = Sql.ToString(rowPrivacyField["FIELD_NAME"]);
					if ( dtAudit.Columns.Contains(sPRIVACY_FIELD) )
					{
						DataRow rowChange = dtChanges.NewRow();
						dtChanges.Rows.Add(rowChange);
						rowChange["FIELD_NAME" ] = sPRIVACY_FIELD;
						rowChange["FIELD_LABEL"] = Utils.TableColumnName(L10n, sModule, sPRIVACY_FIELD);
						rowChange["CHECKED"    ] = (lstMarkedFields.Contains(sPRIVACY_FIELD) ? "checked" : String.Empty);
						DataRow row = dtAudit.Rows[0];
						rowChange["VALUE"       ] = Sql.ToString(row[sPRIVACY_FIELD]);
						rowChange["LAST_UPDATED"] = row["AUDIT_DATE"];
						rowChange["MODIFIED_BY"  ] = Sql.ToString(row["MODIFIED_BY"]);
						if ( dtAudit.Columns.Contains("LEAD_SOURCE") )
							rowChange["LEAD_SOURCE"] = Sql.ToString(row["LEAD_SOURCE"]);
						for ( int i = 1; i < dtAudit.Rows.Count; i++ )
						{
							row = dtAudit.Rows[i];
							if ( Sql.ToString(row[sPRIVACY_FIELD]) != Sql.ToString(rowChange["VALUE"]) )
								break;
							rowChange["LAST_UPDATED"] = row["AUDIT_DATE"];
							rowChange["MODIFIED_BY"  ] = Sql.ToString(row["MODIFIED_BY"]);
							if ( dtAudit.Columns.Contains("LEAD_SOURCE") )
								rowChange["LEAD_SOURCE"] = Sql.ToString(row["LEAD_SOURCE"]);
						}
					}
				}
			}
			return dtChanges;
		}

		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetModuleAudit(string ModuleName, Guid ID, bool ArchiveView)
		{
			if ( !Security.IsAuthenticated() || Security.GetUserAccess(MODULE_NAME, "view") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			if ( Sql.IsEmptyString(ModuleName) )
				throw(new Exception("The module name must be specified."));
			string sTABLE_NAME = Sql.ToString(Application["Modules." + ModuleName + ".TableName"]);
			if ( Sql.IsEmptyString(sTABLE_NAME) )
				throw(new Exception("Unknown module: " + ModuleName));
			// 08/22/2011 Paul.  Add admin control to REST API. 
			int nACLACCESS = Security.GetUserAccess(ModuleName, "view");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + ModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + Sql.ToString(ModuleName)));
			}
			
			// 05/21/2017 Paul.  HTML5 Dashboard requires aggregates. 
			// 08/01/2019 Paul.  We need a ListView and EditView flags for the Rest Client. 
			StringBuilder sbDumpSQL = new StringBuilder();
			Guid          gTIMEZONE = Sql.ToGuid(Session["USER_SETTINGS/TIMEZONE"]);
			TimeZone      T10n      = TimeZone.CreateTimeZone(gTIMEZONE);

			string sNAME = String.Empty;
			List<string> lstMarkedFields = new List<string>();
			DataTable dtChanges = new DataTable();
			string sVIEW_NAME = "vw" + sTABLE_NAME;
			if ( ArchiveView )
			{
				if ( SplendidCache.ArchiveViewExists(sVIEW_NAME) )
					sVIEW_NAME += "_ARCHIVE";
			}
			if ( !Sql.IsEmptyGuid(ID) && !Sql.IsEmptyString(ModuleName) && !Sql.IsEmptyString(sTABLE_NAME) )
			{
				// 12/30/2007 Paul.  The first query should be used just to determine if access is allowed. 
				bool bAccessAllowed = false;
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL ;
					sSQL = "select *"             + ControlChars.CrLf
					     + "  from " + sVIEW_NAME + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Security.Filter(cmd, ModuleName, "view");
						Sql.AppendParameter(cmd, ID, "ID", false);

						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								bAccessAllowed = true;
								try
								{
									sNAME = Sql.ToString(rdr["NAME"]);
								}
								catch
								{
								}
							}
						}
					}
					if ( bAccessAllowed )
					{
						sSQL = "select DATA              " + ControlChars.CrLf
						     + "  from vwERASED_FIELDS   " + ControlChars.CrLf
						     + " where BEAN_ID = @BEAN_ID" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@BEAN_ID", ID);
							sbDumpSQL.AppendLine(Sql.ClientScriptBlock(cmd) + ";");
							
							string sMARKED_FIELDS = Sql.ToString(cmd.ExecuteScalar());
							if ( !Sql.IsEmptyString(sMARKED_FIELDS) )
							{
								lstMarkedFields = new List<string>(sMARKED_FIELDS.Split(','));
							}
						}

						DataTable dtDATA_PRIVACY_FIELDS = new DataTable();
						sSQL = "select FIELD_NAME                " + ControlChars.CrLf
						     + "  from vwDATA_PRIVACY_FIELDS     " + ControlChars.CrLf
						     + " where MODULE_NAME = @MODULE_NAME" + ControlChars.CrLf
						     + " order by FIELD_NAME             " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@MODULE_NAME", ModuleName);
							sbDumpSQL.AppendLine(Sql.ClientScriptBlock(cmd) + ";");
						
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dtDATA_PRIVACY_FIELDS);
							}
						}
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							sSQL = "select *                    " + ControlChars.CrLf
							     + "  from vw" + sTABLE_NAME + "_AUDIT" + ControlChars.CrLf
							     + " where ID = @ID             " + ControlChars.CrLf
							     + " order by AUDIT_VERSION desc" + ControlChars.CrLf;
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID", ID);
							sbDumpSQL.AppendLine(Sql.ClientScriptBlock(cmd) + ";");
							
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dt = new DataTable() )
								{
									da.Fill(dt);
									dtChanges = BuildChangesTable(L10n, ModuleName, dt, dtDATA_PRIVACY_FIELDS, lstMarkedFields);
								}
							}
						}
					}
					else
					{
						throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
					}
				}
			}

			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			
			DataView vwMain = new DataView(dtChanges);
			// 04/01/2020 Paul.  Move json utils to RestUtil. 
			Dictionary<string, object> dict = RestUtil.ToJson(sBaseURI, ModuleName, vwMain, T10n);
			dict.Add("NAME", sNAME);
			dict.Add("MarkedFields", lstMarkedFields);
			// 03/11/2021 Paul.  Return the SQL to the React Client. 
			if ( Sql.ToBoolean(Application["CONFIG.show_sql"]) )
			{
				dict.Add("__sql", sbDumpSQL.ToString());
			}
			return dict;
		}

		[DotNetLegacyData]
		[HttpGet("[action]")]
		[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
		public int GetErasedCount(Guid ID)
		{
			if ( !Security.IsAuthenticated() || Security.GetUserAccess(MODULE_NAME, "view") < 0 )
			{
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
			}
			
			int nERASED_COUNT = 0;
			SqlProcs.spDATA_PRIVACY_GetErasedCount(ID, ref nERASED_COUNT);
			return nERASED_COUNT;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string MarkFields([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.GetUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				Guid   gRECORD_ID     = Guid.Empty;
				string sMODULE_NAME   = String.Empty;
				string sERASED_FIELDS = String.Empty;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "RECORD_ID"    :  gRECORD_ID     = Sql.ToGuid   (dict[sColumnName]);  break;
						case "MODULE_NAME"  :  sMODULE_NAME   = Sql.ToString (dict[sColumnName]);  break;
						case "ERASED_FIELDS":  sERASED_FIELDS = Sql.ToString (dict[sColumnName]);  break;
					}
				}
				string sTABLE_NAME    = Modules.TableName(sMODULE_NAME);
				SqlProcs.spERASED_FIELDS_Update(gRECORD_ID, sTABLE_NAME, sERASED_FIELDS);
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
		public void Complete([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.GetUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				Guid gDATA_PRIVACY_ID = Guid.Empty;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "ID":  gDATA_PRIVACY_ID = Sql.ToGuid(dict[sColumnName]);  break;
					}
				}
				SqlProcs.spDATA_PRIVACY_UpdateStatus(gDATA_PRIVACY_ID, "Completed");
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public void Reject([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.GetUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				Guid gDATA_PRIVACY_ID = Guid.Empty;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "ID":  gDATA_PRIVACY_ID = Sql.ToGuid(dict[sColumnName]);  break;
					}
				}
				SqlProcs.spDATA_PRIVACY_UpdateStatus(gDATA_PRIVACY_ID, "Rejected");
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public void Erase([FromBody] Dictionary<string, object> dict)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				if ( !Security.IsAuthenticated() || Security.GetUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				Guid gDATA_PRIVACY_ID = Guid.Empty;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "ID":  gDATA_PRIVACY_ID = Sql.ToGuid(dict[sColumnName]);  break;
					}
				}
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					using ( IDbTransaction trn = Sql.BeginTransaction(con) )
					{
						try
						{
							using ( IDbCommand cmdDATA_PRIVACY_Erase = SqlProcs.cmdDATA_PRIVACY_Erase(con) )
							{
								cmdDATA_PRIVACY_Erase.Transaction    = trn;
								cmdDATA_PRIVACY_Erase.CommandTimeout = 0;
								Sql.SetParameter(cmdDATA_PRIVACY_Erase, "@ID"              , gDATA_PRIVACY_ID);
								Sql.SetParameter(cmdDATA_PRIVACY_Erase, "@MODIFIED_USER_ID", Security.USER_ID);
								cmdDATA_PRIVACY_Erase.ExecuteNonQuery();
							}
							trn.Commit();
						}
						catch
						{
							trn.Rollback();
							throw;
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
		}

	}
}
