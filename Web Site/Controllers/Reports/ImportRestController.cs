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
using System.Web;
using System.Data;
using System.Data.Common;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Reports
{
	public partial class RestController : ControllerBase
	{
		#region Import
		// 05/08/2021 Paul.  Reports import is not a normal module import. 
		[HttpPost("[action]")]
		public Guid Import([FromBody] Dictionary<string, object> dict)
		{
			string sModuleName = "Reports";
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
				throw(new Exception("Missing Report Module"));
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
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL;
					// 02/04/2011 Paul.  Needed to include the Load Event IDs in the select list. 
					sSQL = "select ID                " + ControlChars.CrLf
					     + "     , PRE_LOAD_EVENT_ID " + ControlChars.CrLf
					     + "     , POST_LOAD_EVENT_ID" + ControlChars.CrLf
					     + "  from vwREPORTS_List    " + ControlChars.CrLf
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
				SqlProcs.spREPORTS_Update
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
				SplendidCache.ClearReport(gID);
			}
			SplendidCache.ClearReports();
			return gID;
		}
		#endregion
	}
}
