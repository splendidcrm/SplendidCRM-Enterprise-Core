/*
 * Copyright (C) 2013-2023 SplendidCRM Software, Inc. All Rights Reserved. 
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
using System.Xml;
using System.Data;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Charts
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Charts/Rest.svc")]
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
		private RestUtil             RestUtil           ;
		private XmlUtil              XmlUtil            ;
		private RdlUtil              RdlUtil            ;
		private QueryBuilder         QueryBuilder       ;
		private SplendidCRM.Crm.Modules          Modules          ;

		public RestController(IHttpContextAccessor httpContextAccessor, IWebHostEnvironment hostingEnvironment, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, RestUtil RestUtil, XmlUtil XmlUtil, RdlUtil RdlUtil, QueryBuilder QueryBuilder, SplendidCRM.Crm.Modules Modules)
		{
			this.httpContextAccessor = httpContextAccessor;
			this.hostingEnvironment  = hostingEnvironment ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.RestUtil            = RestUtil           ;
			this.XmlUtil             = XmlUtil            ;
			this.RdlUtil             = RdlUtil            ;
			this.QueryBuilder        = QueryBuilder       ;
			this.Modules             = Modules            ;
		}

		#region Import
		// 05/08/2021 Paul.  Charts import is not a normal module import. 
		[HttpGet("[action]")]
		public Dictionary<string, object> Import([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "Charts";
			L10N L10n       = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			string sTableName = Sql.ToString(Application["Modules." + sModuleName + ".TableName"]);
			if ( Sql.IsEmptyString(sTableName) )
				throw(new Exception("Unknown module: " + sModuleName));

			Guid   gID                = Guid.Empty  ;
			string sNAME              = String.Empty;
			string sMODULE            = String.Empty;
			Guid   gASSIGNED_USER_ID  = Security.USER_ID;
			string sASSIGNED_SET_LIST = String.Empty;
			Guid   gTEAM_ID           = Security.TEAM_ID;
			string sTEAM_SET_LIST     = String.Empty;
			string sTAG_SET_NAME      = String.Empty;
			// 05/08/2021 Paul.  File data. 
			string sDATA_FIELD        = String.Empty;
			string sFILENAME          = String.Empty;
			string sFILE_DATA         = String.Empty;
			string sFILE_EXT          = String.Empty;
			string sFILE_MIME_TYPE    = String.Empty;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "NAME"             :  sNAME              = Sql.ToString(dict["NAME"             ]);  break;
					case "MODULE"           :  sMODULE            = Sql.ToString(dict["MODULE"           ]);  break;
					case "ASSIGNED_USER_ID" :  gASSIGNED_USER_ID  = Sql.ToGuid  (dict["ASSIGNED_USER_ID" ]);  break;
					case "ASSIGNED_SET_LIST":  sASSIGNED_SET_LIST = Sql.ToString(dict["ASSIGNED_SET_LIST"]);  break;
					case "TEAM_ID"          :  gTEAM_ID           = Sql.ToGuid  (dict["TEAM_ID"          ]);  break;
					case "TEAM_SET_LIST"    :  sTEAM_SET_LIST     = Sql.ToString(dict["TEAM_SET_LIST"    ]);  break;
					case "TAG_SET_NAME"     :  sTAG_SET_NAME      = Sql.ToString(dict["TAG_SET_NAME"     ]);  break;
					case "Files"            :
					{
						System.Collections.ArrayList lst = dict[sColumnName] as System.Collections.ArrayList;
						foreach ( Dictionary<string, object> fileitem in lst )
						{
							foreach ( string sFileColumnName in fileitem.Keys )
							{
								switch ( sFileColumnName )
								{
									case "DATA_FIELD"    :  sDATA_FIELD     =  Sql.ToString(fileitem[sFileColumnName]);  break;
									case "FILENAME"      :  sFILENAME       =  Sql.ToString(fileitem[sFileColumnName]);  break;
									case "FILE_DATA"     :  sFILE_DATA      =  Sql.ToString(fileitem[sFileColumnName]);  break;
									case "FILE_EXT"      :  sFILE_EXT       =  Sql.ToString(fileitem[sFileColumnName]);  break;
									case "FILE_MIME_TYPE":  sFILE_MIME_TYPE =  Sql.ToString(fileitem[sFileColumnName]);  break;
								}
							}
							break;
						}
						break;
					}
				}
			}
			if ( Sql.IsEmptyString(sFILENAME) || Sql.IsEmptyString(sFILE_DATA) )
			{
				throw(new Exception("Missing File"));
			}
			if ( Sql.IsEmptyString(sMODULE) )
			{
				throw(new Exception("Missing Chart Module"));
			}
			if ( Sql.IsEmptyString(sNAME) )
			{
				sNAME = sFILENAME.Trim();
				if ( sNAME.ToLower().EndsWith(".rdl") )
					sNAME = sNAME.Substring(0, sNAME.Length - 4);
			}
			
			byte[] byFILE_DATA     = Convert.FromBase64String(sFILE_DATA);
			using ( MemoryStream stm = new MemoryStream(byFILE_DATA) )
			{
				RdlDocument rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
				rdl.Load(stm);
				rdl.SetSingleNodeAttribute(rdl.DocumentElement, "Name", sNAME);
				// 10/22/2007 Paul.  Use the Assigned User ID field when saving the record. 
				Guid gPRE_LOAD_EVENT_ID  = Guid.Empty;
				Guid gPOST_LOAD_EVENT_ID = Guid.Empty;
				// 05/06/2009 Paul.  Replace existing report by name. 
				// We need to make it easy to update an existing report. 
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					// 02/04/2011 Paul.  Needed to include the Load Event IDs in the select list. 
					sSQL = "select ID                " + ControlChars.CrLf
					     + "     , PRE_LOAD_EVENT_ID " + ControlChars.CrLf
					     + "     , POST_LOAD_EVENT_ID" + ControlChars.CrLf
					     + "  from vwCHARTS_List     " + ControlChars.CrLf
					     + " where NAME = @NAME      " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@NAME", sNAME);
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								gID                 = Sql.ToGuid  (rdr["ID"                ]);
								// 12/04/2010 Paul.  Add support for Business Rules Framework to Reports. 
								gPRE_LOAD_EVENT_ID  = Sql.ToGuid  (rdr["PRE_LOAD_EVENT_ID" ]);
								gPOST_LOAD_EVENT_ID = Sql.ToGuid  (rdr["POST_LOAD_EVENT_ID"]);
							}
						}
					}
				}
				SqlProcs.spCHARTS_Update
					( ref gID
					, gASSIGNED_USER_ID
					, sNAME
					, sMODULE
					, "Freeform"
					, rdl.OuterXml
					, gTEAM_ID
					, sTEAM_SET_LIST
					, gPRE_LOAD_EVENT_ID
					, gPOST_LOAD_EVENT_ID
					, sTAG_SET_NAME
					, sASSIGNED_SET_LIST
					);
				// 04/06/2011 Paul.  Cache reports. 
				SplendidCache.ClearChart(gID);
			}
			SplendidCache.ClearCharts();
			Dictionary<string, object> d = new Dictionary<string, object>();
			d.Add("d", gID);
			return d;
		}
		#endregion

		#region Update
		private string GetFieldTitle(L10N L10n, string sField)
		{
			string sTitle = String.Empty;
			string[] arrField = sField.Split('.');
			if ( arrField.Length >= 2 )
			{
				string sTableName = arrField[0];
				string sFieldName = arrField[1];
				sTitle = Utils.TableColumnName(L10n, Modules.ModuleName(sTableName), sFieldName);
			}
			return sTitle;
		}

		[HttpGet("[action]")]
		public Dictionary<string, object> UpdateModule([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "Charts";
			L10N L10n       = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			string sTableName = Sql.ToString(Application["Modules." + sModuleName + ".TableName"]);
			if ( Sql.IsEmptyString(sTableName) )
				throw(new Exception("Unknown module: " + sModuleName));
			
			string sNAME                 = String.Empty;
			string sCHART_TYPE           = String.Empty;
			string sMODULE               = String.Empty;
			string sRELATED              = String.Empty;
			Guid   gASSIGNED_USER_ID     = Security.USER_ID;
			string sASSIGNED_SET_LIST    = String.Empty;
			Guid   gTEAM_ID              = Security.TEAM_ID;
			string sTEAM_SET_LIST        = String.Empty;
			string sTAG_SET_NAME         = String.Empty;
			Guid   gPRE_LOAD_EVENT_ID    = Guid.Empty;
			Guid   gPOST_LOAD_EVENT_ID   = Guid.Empty;
			string sSERIES_COLUMN        = String.Empty;
			string sSERIES_OPERATOR      = String.Empty;
			string sCATEGORY_COLUMN      = String.Empty;
			string sCATEGORY_OPERATOR    = String.Empty;
			string sMODULE_COLUMN_SOURCE = String.Empty;
			Dictionary<string, object> dictFilterXml = null;
			Dictionary<string, object> dictRelatedModuleXml = null;
			Dictionary<string, object> dictRelationshipXml = null;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "NAME"                :  sNAME                 = Sql.ToString(dict[sColumnName]);  break;
					case "CHART_TYPE"          :  sCHART_TYPE           = Sql.ToString(dict[sColumnName]);  break;
					// 02/09/2022 Paul.  Keep using MODULE to match Reports. 
					case "MODULE"              :  sMODULE               = Sql.ToString(dict[sColumnName]);  break;
					case "RELATED"             :  sRELATED              = Sql.ToString(dict[sColumnName]);  break;
					case "ASSIGNED_USER_ID"    :  gASSIGNED_USER_ID     = Sql.ToGuid  (dict[sColumnName]);  break;
					case "ASSIGNED_SET_LIST"   :  sASSIGNED_SET_LIST    = Sql.ToString(dict[sColumnName]);  break;
					case "TEAM_ID"             :  gTEAM_ID              = Sql.ToGuid  (dict[sColumnName]);  break;
					case "TEAM_SET_LIST"       :  sTEAM_SET_LIST        = Sql.ToString(dict[sColumnName]);  break;
					case "TAG_SET_NAME"        :  sTAG_SET_NAME         = Sql.ToString(dict[sColumnName]);  break;
					case "PRE_LOAD_EVENT_ID"   :  gPRE_LOAD_EVENT_ID    = Sql.ToGuid  (dict[sColumnName]);  break;
					case "POST_LOAD_EVENT_ID"  :  gPOST_LOAD_EVENT_ID   = Sql.ToGuid  (dict[sColumnName]);  break;
					case "SERIES_COLUMN"       :  sSERIES_COLUMN        = Sql.ToString(dict[sColumnName]);  break;
					case "SERIES_OPERATOR"     :  sSERIES_OPERATOR      = Sql.ToString(dict[sColumnName]);  break;
					case "CATEGORY_COLUMN"     :  sCATEGORY_COLUMN      = Sql.ToString(dict[sColumnName]);  break;
					case "CATEGORY_OPERATOR"   :  sCATEGORY_OPERATOR    = Sql.ToString(dict[sColumnName]);  break;
					case "MODULE_COLUMN_SOURCE":  sMODULE_COLUMN_SOURCE = Sql.ToString(dict[sColumnName]);  break;
					case "filterXml"           :  dictFilterXml         = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relatedModuleXml"    :  dictRelatedModuleXml  = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relationshipXml"     :  dictRelationshipXml   = dict[sColumnName] as Dictionary<string, object>;  break;
				}
			}
			bool bDesignChart = true;
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, bDesignChart);
			rdl.SetCustomProperty             ("Module"        , sMODULE );
			rdl.SetCustomProperty             ("Related"       , sRELATED);
			// 06/02/2021 Paul.  React client needs to share code. 
			rdl.SetFiltersCustomProperty      (dictFilterXml       );
			rdl.SetRelatedModuleCustomProperty(dictRelatedModuleXml);
			rdl.SetRelationshipCustomProperty (dictRelationshipXml );
			rdl.SetCustomProperty             ("Charts"        , String.Empty);
			if ( !Sql.IsEmptyGuid(gPRE_LOAD_EVENT_ID ) ) rdl.SetCustomProperty("PRE_LOAD_EVENT_ID" , gPRE_LOAD_EVENT_ID .ToString());
			if ( !Sql.IsEmptyGuid(gPOST_LOAD_EVENT_ID) ) rdl.SetCustomProperty("POST_LOAD_EVENT_ID", gPOST_LOAD_EVENT_ID.ToString());
			// 11/08/2011 Paul.  Getting the chart name is a bit of a cludge, but it works and it is safe. 
			string sChartTitle       = sNAME;
			string sChartType        = sCHART_TYPE;
			string sSeriesColumn     = sSERIES_COLUMN;
			string sSeriesOperator   = sSERIES_OPERATOR;
			string sSeriesTitle      = GetFieldTitle(L10n, sSERIES_COLUMN);
			string sCategoryColumn   = sCATEGORY_COLUMN;
			string sCategoryOperator = sCATEGORY_OPERATOR;
			string sCategoryTitle    = GetFieldTitle(L10n, sCATEGORY_COLUMN);
			if ( sSeriesOperator == "count" )
			{
				string[] arrModule = sMODULE_COLUMN_SOURCE.Split(' ');
				string sModule     = arrModule[0];
				string sTableAlias = arrModule[1];
				sSeriesTitle = L10n.Term(".moduleList." + sModule);
			}
			//Thread.CurrentThread.CurrentCulture.DateTimeFormat.MonthNames
			//Thread.CurrentThread.CurrentCulture.DateTimeFormat.AbbreviatedMonthNames
			rdl.UpdateChart(sChartTitle, sChartType, sSeriesTitle, sSeriesColumn, sSeriesOperator, sCategoryTitle, sCategoryColumn, sCategoryOperator, Thread.CurrentThread.CurrentCulture.DateTimeFormat.ShortDatePattern);
			XmlDocument xmlDisplayColumns = new XmlDocument();
			xmlDisplayColumns.AppendChild(xmlDisplayColumns.CreateElement("DisplayColumns"));

			XmlNode xDisplayColumn = xmlDisplayColumns.CreateElement("DisplayColumn");
			xmlDisplayColumns.DocumentElement.AppendChild(xDisplayColumn);

			XmlNode xLabel = xmlDisplayColumns.CreateElement("Label");
			XmlNode xField = xmlDisplayColumns.CreateElement("Field");
			xDisplayColumn.AppendChild(xLabel);
			xDisplayColumn.AppendChild(xField);
			xLabel.InnerText = Utils.TableColumnName(L10n, sMODULE, sCATEGORY_COLUMN);
			xField.InnerText = sCATEGORY_COLUMN;

			xDisplayColumn = xmlDisplayColumns.CreateElement("DisplayColumn");
			xmlDisplayColumns.DocumentElement.AppendChild(xDisplayColumn);

			xLabel = xmlDisplayColumns.CreateElement("Label");
			xField = xmlDisplayColumns.CreateElement("Field");
			xDisplayColumn.AppendChild(xLabel);
			xDisplayColumn.AppendChild(xField);
			xLabel.InnerText = Utils.TableColumnName(L10n, sMODULE, sSERIES_COLUMN);
			xField.InnerText = sSERIES_COLUMN;
			rdl.SetCustomProperty("DisplayColumns", xmlDisplayColumns.OuterXml.Replace("</DisplayColumn>", "</DisplayColumn>" + ControlChars.CrLf));

			bool bPrimaryKeyOnly   = false;
			bool bUseSQLParameters = true ;
			bool bUserSpecific     = false;
			Hashtable hashAvailableModules = new Hashtable();
			StringBuilder sbErrors = new StringBuilder();
			string sReportSQL = String.Empty;
			sReportSQL = QueryBuilder.BuildReportSQL(Application, rdl, bPrimaryKeyOnly, bUseSQLParameters, bDesignChart, bUserSpecific, sMODULE, sRELATED, hashAvailableModules, sbErrors);
			if ( sbErrors.Length > 0 )
				throw(new Exception(sbErrors.ToString()));
			// 02/09/2022 Paul.  If MODULE_NAME not specified, then use the MODULE from the query builder data. 
			if ( !dict.ContainsKey("MODULE_NAME") || Sql.IsEmptyString(dict["MODULE_NAME"]) )
			{
				dict["MODULE_NAME"] = sMODULE;
			}

			dict["RDL"] = rdl.OuterXml;
			Guid gID = RestUtil.UpdateTable(sTableName, dict);
			SplendidCache.ClearCharts();

			// 04/28/2019 Paul.  Add tracker for React client. 
			string sName = Sql.ToString(dict["NAME"]);
			try
			{
				if ( !Sql.IsEmptyString(sName) )
					SqlProcs.spTRACKER_Update(Security.USER_ID, sModuleName, gID, sName, "save");
			}
			catch(Exception ex)
			{
				// 04/28/2019 Paul.  There is no compelling reason to send this error to the user. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
			}
			Dictionary<string, object> d = new Dictionary<string, object>();
			d.Add("d", gID);
			return d;
		}
		#endregion

		[HttpGet("[action]")]
		public async Task<Dictionary<string, object>> GetChartData([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "Charts";
			L10N L10n       = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			int  nACLACCESS = Security.GetUserAccess(sModuleName, "edit");
			if ( !Security.IsAuthenticated() || !Sql.ToBoolean(Application["Modules." + sModuleName + ".RestEnabled"]) || nACLACCESS < 0 )
			{
				// 09/06/2017 Paul.  Include module name in error. 
				throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + sModuleName));
			}
			
			string sTableName = Sql.ToString(Application["Modules." + sModuleName + ".TableName"]);
			if ( Sql.IsEmptyString(sTableName) )
				throw(new Exception("Unknown module: " + sModuleName));
			
			string sNAME                 = String.Empty;
			string sCHART_TYPE           = String.Empty;
			string sMODULE               = String.Empty;
			string sRELATED              = String.Empty;
			Guid   gPRE_LOAD_EVENT_ID    = Guid.Empty;
			Guid   gPOST_LOAD_EVENT_ID   = Guid.Empty;
			string sSERIES_COLUMN        = String.Empty;
			string sSERIES_OPERATOR      = String.Empty;
			string sCATEGORY_COLUMN      = String.Empty;
			string sCATEGORY_OPERATOR    = String.Empty;
			string sMODULE_COLUMN_SOURCE = String.Empty;
			Dictionary<string, object> dictFilterXml = null;
			Dictionary<string, object> dictRelatedModuleXml = null;
			Dictionary<string, object> dictRelationshipXml = null;
			foreach ( string sColumnName in dict.Keys )
			{
				switch ( sColumnName )
				{
					case "NAME"                :  sNAME                 = Sql.ToString(dict[sColumnName]);  break;
					case "CHART_TYPE"          :  sCHART_TYPE           = Sql.ToString(dict[sColumnName]);  break;
					// 02/09/2022 Paul.  Keep using MODULE to match Reports. 
					case "MODULE"              :  sMODULE               = Sql.ToString(dict[sColumnName]);  break;
					case "RELATED"             :  sRELATED              = Sql.ToString(dict[sColumnName]);  break;
					case "PRE_LOAD_EVENT_ID"   :  gPRE_LOAD_EVENT_ID    = Sql.ToGuid  (dict[sColumnName]);  break;
					case "POST_LOAD_EVENT_ID"  :  gPOST_LOAD_EVENT_ID   = Sql.ToGuid  (dict[sColumnName]);  break;
					case "SERIES_COLUMN"       :  sSERIES_COLUMN        = Sql.ToString(dict[sColumnName]);  break;
					case "SERIES_OPERATOR"     :  sSERIES_OPERATOR      = Sql.ToString(dict[sColumnName]);  break;
					case "CATEGORY_COLUMN"     :  sCATEGORY_COLUMN      = Sql.ToString(dict[sColumnName]);  break;
					case "CATEGORY_OPERATOR"   :  sCATEGORY_OPERATOR    = Sql.ToString(dict[sColumnName]);  break;
					case "MODULE_COLUMN_SOURCE":  sMODULE_COLUMN_SOURCE = Sql.ToString(dict[sColumnName]);  break;
					case "filterXml"           :  dictFilterXml         = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relatedModuleXml"    :  dictRelatedModuleXml  = dict[sColumnName] as Dictionary<string, object>;  break;
					case "relationshipXml"     :  dictRelationshipXml   = dict[sColumnName] as Dictionary<string, object>;  break;
				}
			}
			bool bDesignChart = true;
			RdlDocument rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, bDesignChart);
			rdl.SetCustomProperty             ("Module"        , sMODULE );
			rdl.SetCustomProperty             ("Related"       , sRELATED);
			// 06/02/2021 Paul.  React client needs to share code. 
			rdl.SetFiltersCustomProperty      (dictFilterXml       );
			rdl.SetRelatedModuleCustomProperty(dictRelatedModuleXml);
			rdl.SetRelationshipCustomProperty (dictRelationshipXml );
			rdl.SetCustomProperty             ("Charts"        , String.Empty);
			if ( !Sql.IsEmptyGuid(gPRE_LOAD_EVENT_ID ) ) rdl.SetCustomProperty("PRE_LOAD_EVENT_ID" , gPRE_LOAD_EVENT_ID .ToString());
			if ( !Sql.IsEmptyGuid(gPOST_LOAD_EVENT_ID) ) rdl.SetCustomProperty("POST_LOAD_EVENT_ID", gPOST_LOAD_EVENT_ID.ToString());
			// 11/08/2011 Paul.  Getting the chart name is a bit of a cludge, but it works and it is safe. 
			string sChartTitle       = sNAME;
			string sChartType        = sCHART_TYPE;
			string sSeriesColumn     = sSERIES_COLUMN;
			string sSeriesOperator   = sSERIES_OPERATOR;
			string sSeriesTitle      = GetFieldTitle(L10n, sSERIES_COLUMN);
			string sCategoryColumn   = sCATEGORY_COLUMN;
			string sCategoryOperator = sCATEGORY_OPERATOR;
			string sCategoryTitle    = GetFieldTitle(L10n, sCATEGORY_COLUMN);
			if ( sSeriesOperator == "count" )
			{
				string[] arrModule = sMODULE_COLUMN_SOURCE.Split(' ');
				string sModule     = arrModule[0];
				string sTableAlias = arrModule[1];
				sSeriesTitle = L10n.Term(".moduleList." + sModule);
			}
			//Thread.CurrentThread.CurrentCulture.DateTimeFormat.MonthNames
			//Thread.CurrentThread.CurrentCulture.DateTimeFormat.AbbreviatedMonthNames
			rdl.UpdateChart(sChartTitle, sChartType, sSeriesTitle, sSeriesColumn, sSeriesOperator, sCategoryTitle, sCategoryColumn, sCategoryOperator, Thread.CurrentThread.CurrentCulture.DateTimeFormat.ShortDatePattern);
			XmlDocument xmlDisplayColumns = new XmlDocument();
			xmlDisplayColumns.AppendChild(xmlDisplayColumns.CreateElement("DisplayColumns"));

			XmlNode xDisplayColumn = xmlDisplayColumns.CreateElement("DisplayColumn");
			xmlDisplayColumns.DocumentElement.AppendChild(xDisplayColumn);

			XmlNode xLabel = xmlDisplayColumns.CreateElement("Label");
			XmlNode xField = xmlDisplayColumns.CreateElement("Field");
			xDisplayColumn.AppendChild(xLabel);
			xDisplayColumn.AppendChild(xField);
			xLabel.InnerText = Utils.TableColumnName(L10n, sMODULE, sCATEGORY_COLUMN);
			xField.InnerText = sCATEGORY_COLUMN;

			xDisplayColumn = xmlDisplayColumns.CreateElement("DisplayColumn");
			xmlDisplayColumns.DocumentElement.AppendChild(xDisplayColumn);

			xLabel = xmlDisplayColumns.CreateElement("Label");
			xField = xmlDisplayColumns.CreateElement("Field");
			xDisplayColumn.AppendChild(xLabel);
			xDisplayColumn.AppendChild(xField);
			xLabel.InnerText = Utils.TableColumnName(L10n, sMODULE, sSERIES_COLUMN);
			xField.InnerText = sSERIES_COLUMN;
			rdl.SetCustomProperty("DisplayColumns", xmlDisplayColumns.OuterXml.Replace("</DisplayColumn>", "</DisplayColumn>" + ControlChars.CrLf));

			string   sReportSQL  = String.Empty;
			bool bPrimaryKeyOnly   = false;
			bool bUseSQLParameters = true ;
			bool bUserSpecific     = false;
			Hashtable hashAvailableModules = new Hashtable();
			StringBuilder sbErrors = new StringBuilder();
			// 05/29/2021 Paul.  We build the report sql first so that the DataSet Fields node gets populated. 
			sReportSQL = QueryBuilder.BuildReportSQL(Application, rdl, bPrimaryKeyOnly, bUseSQLParameters, bDesignChart, bUserSpecific, sMODULE, sRELATED, hashAvailableModules, sbErrors);
			if ( sbErrors.Length > 0 )
				throw(new Exception(sbErrors.ToString()));
			
			Guid     gTIMEZONE   = Sql.ToGuid  (Session["USER_SETTINGS/TIMEZONE"]);
			SplendidCRM.TimeZone T10n        = TimeZone.CreateTimeZone(gTIMEZONE);
			DataSet  ds          = new DataSet();
			
			string   sRDL        = rdl.OuterXml;
			ReportViewer rdlViewer = new ReportViewer();
			await RdlUtil.LocalLoadReportDefinition(null, null, L10n, T10n, ds, sRDL, sMODULE, Guid.Empty, true, null, null);

			DataTable dt          = ds.Tables[0];
			long      lTotalCount = dt.Rows.Count;
			string    sBaseURI    = String.Empty;
			Dictionary<string, object> dictResponse = RestUtil.ToJson(sBaseURI, sModuleName, dt, T10n);
			dictResponse.Add("__total", lTotalCount);
			dictResponse.Add("__sql"  , sReportSQL);
			return dictResponse;
		}
	}
}
