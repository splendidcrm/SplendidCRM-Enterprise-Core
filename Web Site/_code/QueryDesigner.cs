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
using System.Xml;
using System.Xml.Serialization;
using System.Text;
using System.Text.Json;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;

namespace SplendidCRM
{
	public class QueryDesigner
	{
/*
		#region Properties
		protected RdlDocument     rdl                = null ;
		protected string[]        arrModules                ;
		protected bool            bUserSpecific      = false;
		protected bool            bPrimaryKeyOnly    = true ;
		protected bool            bUseSQLParameters  = false;
		protected bool            bDesignChart       = false;
		protected string          sReportSQL         = String.Empty;
		protected int             nSelectedColumns   = 0    ;

		public string MODULE
		{
			get { return (rdl != null) ? rdl.GetCustomPropertyValue("Module") : String.Empty; }
		}

		public int SelectedColumns
		{
			get { return nSelectedColumns; }
		}

		public bool UserSpecific
		{
			get { return bUserSpecific; }
			set { bUserSpecific = value; }
		}

		public bool PrimaryKeyOnly
		{
			get { return bPrimaryKeyOnly; }
			set { bPrimaryKeyOnly = value; }
		}

		public string Modules
		{
			get { return (arrModules == null ? String.Empty : String.Join(",", arrModules)); }
			set { arrModules = value.Replace(" ", "").Split(','); }
		}

		public bool UseSQLParameters
		{
			get { return bUseSQLParameters; }
			set { bUseSQLParameters = value; }
		}

		public bool DesignChart
		{
			get { return bDesignChart; }
			set { bDesignChart = value; }
		}

		public string ReportSQL
		{
			get { return sReportSQL; }
		}

		public string ReportRDL
		{
			get { return (rdl != null) ? rdl.OuterXml : String.Empty; }
		}

		public RdlDocument RDL
		{
			get { return rdl; }
		}

		public void SetCustomProperty(string sName, string sValue)
		{
			rdl.SetCustomProperty(sName, sValue);
		}

		public string GetCustomPropertyValue(string sName)
		{
			return rdl.GetCustomPropertyValue(sName);
		}

		public void SetSingleNode(string sName, string sValue)
		{
			rdl.SetSingleNode(sName, sValue);
		}

		public string SelectNodeValue(string sName)
		{
			return rdl.SelectNodeValue(sName);
		}

		public string SelectNodeAttribute(string sNode, string sAttribute)
		{
			return rdl.SelectNodeAttribute(sNode, sAttribute);
		}

		public DateTimeFormatInfo DateTimeFormat
		{
			get { return System.Threading.Thread.CurrentThread.CurrentCulture.DateTimeFormat; }
		}
		#endregion
*/
		private IWebHostEnvironment  hostingEnvironment ;
		private IHttpContextAccessor httpContextAccessor;
		private HttpContext          Context            ;
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private XmlUtil              XmlUtil            ;
		private SplendidCRM.Crm.Modules          Modules          ;
		private SplendidCRM.Crm.Config           Config           = new SplendidCRM.Crm.Config();

		public QueryDesigner(IWebHostEnvironment hostingEnvironment, IHttpContextAccessor httpContextAccessor, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, XmlUtil XmlUtil, SplendidCRM.Crm.Modules Modules) : base()
		{
			this.httpContextAccessor = httpContextAccessor;
			this.Context             = httpContextAccessor.HttpContext;
			this.hostingEnvironment  = hostingEnvironment ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.Security            = Security           ;
			this.XmlUtil             = XmlUtil            ;
			this.Modules             = Modules            ;
		}

		// 05/09/2016 Paul.  Move AddScriptReference and AddStyleSheet to Sql object. 		

		#region Build
		// 04/17/2007 Paul.  We need to apply ACL rules a little different from the standard.
		// 07/09/2007 Paul.  Fixes from Version 1.2 on 04/17/2007 were not included in Version 1.4 tree.
		// 03/31/2020 Paul.  Separate out GetReportDesign so that it can be called from the React Client. 
		private void ACLFilter(StringBuilder sbJoin, StringBuilder sbWhere, string sMODULE_NAME, string sACCESS_TYPE, string sASSIGNED_USER_ID_Field, bool bIsCaseSignificantDB, bool bUseSQLParameters)
		{
			// 12/07/2006 Paul.  Not all views use ASSIGNED_USER_ID as the assigned field.  Allow an override. 
			// 11/25/2006 Paul.  Administrators should not be restricted from seeing items because of the team rights.
			// This is so that an administrator can fix any record with a bad team value. 
			// 11/27/2009 Paul.  We need a dynamic way to determine if the module record can be assigned or placed in a team. 
			// Teamed and Assigned flags are automatically determined based on the existence of TEAM_ID and ASSIGNED_USER_ID fields. 
			bool bModuleIsTeamed        = Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Teamed"  ]);
			bool bModuleIsAssigned      = Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Assigned"]);
			bool bEnableTeamManagement  = Config.enable_team_management ();
			bool bRequireTeamManagement = Config.require_team_management();
			bool bRequireUserAssignment = Config.require_user_assignment();
			// 11/27/2009 Paul.  Allow dynamic teams to be turned off. 
			bool bEnableDynamicTeams    = Config.enable_dynamic_teams();
			// 02/13/2018 Paul.  Allow team hierarchy. 
			bool bEnableTeamHierarchy   = Config.enable_team_hierarchy();
			bool bIsAdmin = Security.IS_ADMIN;
			// 11/27/2009 Paul.  Don't apply admin rules when debugging so that we can test the code. 
#if DEBUG
			bIsAdmin = false;
#endif
			if ( bModuleIsTeamed )
			{
				// 02/10/2008 Kerry.  Remove debug code to force non-admin. 
				if ( bIsAdmin )
					bRequireTeamManagement = false;

				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					if ( bEnableTeamManagement )
					{
						if ( bEnableDynamicTeams )
						{
							// 08/31/2009 Paul.  Dynamic Teams are handled just like regular teams except using a different view. 
							if ( bRequireTeamManagement )
								sbJoin.Append("       inner ");
							else
								sbJoin.Append("  left outer ");
							// 02/13/2018 Paul.  Allow team hierarchy. 
							if ( !bEnableTeamHierarchy )
							{
								// 11/27/2009 Paul.  Use Sql.MetadataName() so that the view name can exceed 30 characters, but still be truncated for Oracle. 
								// 11/27/2009 Paul.  vwTEAM_SET_MEMBERSHIPS_Security has a distinct clause to reduce duplicate rows. 
								// 12/07/2009 Paul.  Must include the module when referencing the TEAM_SET_ID. 
								// 03/08/2011 Paul.  We need to make sure not to exceed 30 characters in the alias name. 
								sbJoin.AppendLine("join " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_Security") + " " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_" + sMODULE_NAME) + ControlChars.CrLf);
								sbJoin.AppendLine("               on " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_TEAM_SET_ID = " + sMODULE_NAME + ".TEAM_SET_ID" + ControlChars.CrLf);
								// 05/05/2010 Paul.  We need to hard-code the value of the MEMBERSHIP_USER_ID as there is no practical way to use a runtime-value. 
								// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
								if ( bUseSQLParameters )
									sbJoin.AppendLine("              and " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_USER_ID     = @MEMBERSHIP_USER_ID" + ControlChars.CrLf);
								else
									sbJoin.AppendLine("              and " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_USER_ID     = '" + Security.USER_ID.ToString() + "'" + ControlChars.CrLf);
							}
							else
							{
								if ( Sql.IsOracle(con) )
								{
									sbJoin.AppendLine("join table(" + Sql.MetadataName(con, "fnTEAM_SET_HIERARCHY_MEMBERSHIPS") + "(@MEMBERSHIP_USER_ID))  " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_" + sMODULE_NAME));
									sbJoin.AppendLine("               on " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_TEAM_SET_ID = TEAM_SET_ID");
								}
								else
								{
									string fnPrefix = (Sql.IsSQLServer(con) ? "dbo." : String.Empty);
									sbJoin.AppendLine("join " + fnPrefix + Sql.MetadataName(con, "fnTEAM_SET_HIERARCHY_MEMBERSHIPS") + "(@MEMBERSHIP_USER_ID)  " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_" + sMODULE_NAME));
									sbJoin.AppendLine("               on " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_TEAM_SET_ID = TEAM_SET_ID");
								}
							}
						}
						else
						{
							if ( bRequireTeamManagement )
								sbJoin.Append("       inner ");
							else
								sbJoin.Append("  left outer ");
							// 02/13/2018 Paul.  Allow team hierarchy. 
							if ( !bEnableTeamHierarchy )
							{
								// 03/08/2011 Paul.  We need to make sure not to exceed 30 characters in the alias name. 
								sbJoin.AppendLine("join vwTEAM_MEMBERSHIPS  " + Sql.MetadataName(con, "vwTEAM_MEMBERSHIPS_" + sMODULE_NAME));
								sbJoin.AppendLine("               on " + Sql.MetadataName(con, "vwTEAM_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_TEAM_ID = " + sMODULE_NAME + ".TEAM_ID");
								// 05/05/2010 Paul.  We need to hard-code the value of the MEMBERSHIP_USER_ID as there is no practical way to use a runtime-value. 
								// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
								if ( bUseSQLParameters )
									sbJoin.AppendLine("              and " + Sql.MetadataName(con, "vwTEAM_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_USER_ID = @MEMBERSHIP_USER_ID");
								else
									sbJoin.AppendLine("              and " + Sql.MetadataName(con, "vwTEAM_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_USER_ID = '" + Security.USER_ID.ToString() + "'");
							}
							else
							{
								if ( Sql.IsOracle(con) )
								{
									sbJoin.AppendLine("join table(fnTEAM_HIERARCHY_MEMBERSHIPS(@MEMBERSHIP_USER_ID))  " + Sql.MetadataName(con, "vwTEAM_MEMBERSHIPS_" + sMODULE_NAME));
									sbJoin.AppendLine("               on " + Sql.MetadataName(con, "vwTEAM_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_TEAM_ID = TEAM_ID");
								}
								else
								{
									string fnPrefix = (Sql.IsSQLServer(con) ? "dbo." : String.Empty);
									sbJoin.AppendLine("join " + fnPrefix + "fnTEAM_HIERARCHY_MEMBERSHIPS(@MEMBERSHIP_USER_ID)  " + Sql.MetadataName(con, "vwTEAM_MEMBERSHIPS_" + sMODULE_NAME));
									sbJoin.AppendLine("               on " + Sql.MetadataName(con, "vwTEAM_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_TEAM_ID = TEAM_ID");
								}
							}
							//Sql.AddParameter(cmd, "@MEMBERSHIP_USER_ID", Security.USER_ID);
						}
					}

					if ( bEnableTeamManagement && !bRequireTeamManagement && !bIsAdmin )
					{
						// 11/27/2009 Paul.  Dynamic Teams are handled just like regular teams except using a different view. 
						// 03/08/2011 Paul.  We need to make sure not to exceed 30 characters in the alias name. 
						if ( bEnableDynamicTeams )
							sbWhere.AppendLine("   and (" + sMODULE_NAME + ".TEAM_SET_ID is null or " + Sql.MetadataName(con, "vwTEAM_SET_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_TEAM_SET_ID is not null)");
						else
							sbWhere.AppendLine("   and (" + sMODULE_NAME + ".TEAM_ID is null or " + Sql.MetadataName(con, "vwTEAM_MEMBERSHIPS_" + sMODULE_NAME) + ".MEMBERSHIP_ID is not null)");
					}
				}
			}
			if ( bModuleIsAssigned )
			{
				int nACLACCESS = Security.GetUserAccess(sMODULE_NAME, sACCESS_TYPE);
				// 11/27/2009 Paul.  Make sure owner rule does not apply to admins. 
				if ( nACLACCESS == ACL_ACCESS.OWNER || (bRequireUserAssignment && !bIsAdmin) )
				{
					sASSIGNED_USER_ID_Field = sMODULE_NAME + "." + sASSIGNED_USER_ID_Field;
					string sFieldPlaceholder = "MEMBERSHIP_USER_ID";  //Sql.NextPlaceholder(cmd, sASSIGNED_USER_ID_Field);
					// 01/22/2007 Paul.  If ASSIGNED_USER_ID is null, then let everybody see it. 
					// This was added to work around a bug whereby the ASSIGNED_USER_ID was not automatically assigned to the creating user. 
					bool bShowUnassigned = Config.show_unassigned();
					if ( bShowUnassigned )
					{
						if ( bIsCaseSignificantDB )
							sbWhere.AppendLine("   and (" + sASSIGNED_USER_ID_Field + " is null or upper(" + sASSIGNED_USER_ID_Field + ") = upper(@" + sFieldPlaceholder + "))");
						else
							sbWhere.AppendLine("   and (" + sASSIGNED_USER_ID_Field + " is null or "       + sASSIGNED_USER_ID_Field +  " = @"       + sFieldPlaceholder + ")" );
					}
					else
					{
						if ( bIsCaseSignificantDB )
							sbWhere.AppendLine("   and upper(" + sASSIGNED_USER_ID_Field + ") = upper(@" + sFieldPlaceholder + ")");
						else
							sbWhere.AppendLine("   and "       + sASSIGNED_USER_ID_Field +  " = @"       + sFieldPlaceholder      );
					}
					//Sql.AddParameter(cmd, "@" + sFieldPlaceholder, Security.USER_ID);
				}
			}
		}

		// 07/05/2016 Paul.  IsNumericField is used by BPMN. 
		public bool IsNumericField(DataView vwColumns, string sColumnName)
		{
			bool b = false;
			vwColumns.RowFilter = "ColumnName = '" + sColumnName + "'";
			if ( vwColumns.Count > 0 )
			{
				string sDataType = Sql.ToString(vwColumns[0]["CsType"]);
				switch ( sDataType )
				{
					case "ansistring":  b = false;  break;
					case "bool"      :  b = false;  break;
					case "byte[]"    :  b = false;  break;
					case "DateTime"  :  b = false;  break;
					case "decimal"   :  b = true ;  break;
					case "float"     :  b = true ;  break;
					case "Guid"      :  b = false;  break;
					case "Int16"     :  b = true ;  break;
					case "Int32"     :  b = true ;  break;
					case "Int64"     :  b = true ;  break;
					case "short"     :  b = true ;  break;
					case "string"    :  b = false;  break;
				}
			}
			return b;
		}

		public bool IsDateField(DataView vwColumns, string sColumnName)
		{
			bool b = false;
			vwColumns.RowFilter = "ColumnName = '" + sColumnName + "'";
			if ( vwColumns.Count > 0 )
			{
				string sDataType = Sql.ToString(vwColumns[0]["CsType"]);
				b = (sDataType == "DateTime");
			}
			return b;
		}

		public bool IsBooleanField(DataView vwColumns, string sColumnName)
		{
			bool b = false;
			vwColumns.RowFilter = "ColumnName = '" + sColumnName + "'";
			if ( vwColumns.Count > 0 )
			{
				string sDataType = Sql.ToString(vwColumns[0]["CsType"]);
				b = (sDataType == "bool");
			}
			return b;
		}

		private List<string> AvailableTables()
		{
			List<string> lstTables      = new List<string>();
			List<string> lstModules     = new List<string>();
			List<string> lstDetailViews = new List<string>();
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL;
				sSQL = "select MODULE_NAME  as ModuleName  " + ControlChars.CrLf
				     + "     , TABLE_NAME   as TableName   " + ControlChars.CrLf
				     + "  from vwMODULES_Reporting         " + ControlChars.CrLf
				     + " where USER_ID    = @USER_ID       " + ControlChars.CrLf
				     + "   and TABLE_NAME is not null      " + ControlChars.CrLf
				     + " order by TABLE_NAME               " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter( cmd, "@USER_ID", Security.USER_ID );
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						( (IDbDataAdapter) da ).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill( dt );
							foreach ( DataRow row in dt.Rows )
							{
								string sTableName  = Sql.ToString( row["TableName" ]);
								string sModuleName = Sql.ToString( row["ModuleName"]);
								lstTables .Add(sTableName );
								lstModules.Add(sModuleName);
								lstDetailViews.Add( sModuleName + ".DetailView" );
							}
						}
					}
				}
				
				sSQL = "select MODULE_NAME        as ModuleName  " + ControlChars.CrLf
				     + "     , ''                 as DisplayName " + ControlChars.CrLf
				     + "     , TABLE_NAME         as TableName   " + ControlChars.CrLf
				     + "     , PRIMARY_FIELD      as PrimaryField" + ControlChars.CrLf
				     + "     , 1                  as Relationship" + ControlChars.CrLf
				     + "     , DETAIL_NAME        as RelatedName " + ControlChars.CrLf
				     + "  from vwDETAILVIEWS_RELATIONSHIPS       " + ControlChars.CrLf
				     + " where TABLE_NAME is not null            " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AppendParameter(cmd, lstModules    .ToArray(), "MODULE_NAME");
					Sql.AppendParameter(cmd, lstDetailViews.ToArray(), "DETAIL_NAME");
					cmd.CommandText += " order by DETAIL_NAME, RELATIONSHIP_ORDER" + ControlChars.CrLf;
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);
							foreach ( DataRow row in dt.Rows )
							{
								string sTableName = Sql.ToString(row["TableName"]);
								if ( sTableName.StartsWith("vw") || sTableName.StartsWith("VW") )
									sTableName = sTableName.Substring(2);
								lstTables .Add(sTableName );
							}
						}
					}
				}
				
				// 04/17/2018 Paul.  Add CustomReportView to simplify reporting. 
				sSQL = "select MODULE_NAME        as ModuleName      " + ControlChars.CrLf
				     + "     , NAME               as DisplayName     " + ControlChars.CrLf
				     + "     , VIEW_NAME          as TableName       " + ControlChars.CrLf
				     + "     , PRIMARY_FIELD      as PrimaryField    " + ControlChars.CrLf
				     + "     , 0                  as Relationship    " + ControlChars.CrLf
				     + "     , 1                  as CustomReportView" + ControlChars.CrLf
				     + "  from vwMODULES_REPORT_VIEWS                " + ControlChars.CrLf
				     + " where 1 = 1                                 " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AppendParameter(cmd, lstModules.ToArray(), "MODULE_NAME");
					cmd.CommandText += " order by DisplayName" + ControlChars.CrLf;
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);
							foreach ( DataRow row in dt.Rows )
							{
								string sTableName = Sql.ToString(row["TableName"]);
								if ( sTableName.StartsWith("vw") || sTableName.StartsWith("VW") )
									sTableName = sTableName.Substring(2);
								lstTables .Add(sTableName );
							}
						}
					}
				}
			}
			return lstTables;
		}

		// 03/31/2020 Paul.  Separate out GetReportDesign so that it can be called from the React Client. 
		public string BuildReportSQL(HttpApplicationState Application, L10N L10n, RdlDocument rdl, ReportDesign rd, bool bPrimaryKeyOnly, bool bUseSQLParameters, bool bUserSpecific, ref int nSelectedColumns)
		{
			bool bIsOracle     = false;
			bool bIsDB2        = false;
			bool bIsMySQL      = false;
			bool bIsPostgreSQL = false;
			string sSplendidProvider = Sql.ToString(Application["SplendidProvider"]);
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					bIsOracle     = Sql.IsOracle    (cmd);
					bIsDB2        = Sql.IsDB2       (cmd);
					bIsMySQL      = Sql.IsMySQL     (cmd);
					bIsPostgreSQL = Sql.IsPostgreSQL(cmd);
				}
			}
			
			StringBuilder sb         = new StringBuilder();
			StringBuilder sbACLWhere = new StringBuilder();
			StringBuilder sbErrors   = new StringBuilder();
			if ( rd != null && rd.Tables != null )
			{
				rdl.SetSingleNode("DataSets/DataSet/Fields", String.Empty);
				XmlNode xFields = rdl.SelectNode("DataSets/DataSet/Fields");
				xFields.RemoveAll();
				
				string sMODULE_TABLE = String.Empty;
				List<string> lstAvailableTables = AvailableTables();
				Dictionary<string, int> oUsedTables  = new Dictionary<string, int>();
				for ( int i = 0; i < rd.Tables.Length; i++ )
				{
					if ( Sql.IsEmptyString(sMODULE_TABLE) )
						sMODULE_TABLE = rd.Tables[i].TableName;
					oUsedTables[rd.Tables[i].TableName] = 0;
					if ( !lstAvailableTables.Contains(rd.Tables[i].TableName) )
					{
						throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS") + ": " + rd.Tables[i].TableName));
					}
				}
				if ( bPrimaryKeyOnly && !bUseSQLParameters )
				{
					sb.AppendLine("select " + sMODULE_TABLE + ".ID");
				}
				else if ( rd.SelectedFields != null && rd.SelectedFields.Length == 0 )
				{
					sb.AppendLine("select *");
				}
				else if ( rd.SelectedFields != null )
				{
					int nMaxLen = 0;
					Dictionary<string, DataView> dictTableColumns = new Dictionary<string, DataView>();
					nSelectedColumns = rd.SelectedFields.Length;
					for ( int i = 0; i < rd.SelectedFields.Length; i++ )
					{
						ReportDesign.ReportField oReportField = rd.SelectedFields[i];
						nMaxLen = Math.Max(nMaxLen, oReportField.FieldName.Length);
						if ( !dictTableColumns.ContainsKey(oReportField.TableName) )
						{
							DataView vwColumns = new DataView(SplendidCache.SqlColumns("vw" + oReportField.TableName));
							dictTableColumns.Add(oReportField.TableName, vwColumns);
						}
					}
					for ( int i = 0; i < rd.SelectedFields.Length; i++ )
					{
						ReportDesign.ReportField oReportField = rd.SelectedFields[i];
						string sFieldType = "System.String";
						if ( dictTableColumns.ContainsKey(oReportField.TableName) )
						{
							DataView vwColumns = dictTableColumns[oReportField.TableName];
							vwColumns.RowFilter = "ColumnName = '" + oReportField.ColumnName + "'";
							if ( vwColumns.Count > 0 )
							{
								string sCsType = Sql.ToString(vwColumns[0]["CsType"]);
								switch ( sCsType )
								{
									case "Guid"      :  sFieldType = "System.Guid"    ;  break;
									case "string"    :  sFieldType = "System.String"  ;  break;
									case "ansistring":  sFieldType = "System.String"  ;  break;
									case "DateTime"  :  sFieldType = "System.DateTime";  break;
									case "bool"      :  sFieldType = "System.Boolean" ;  break;
									case "float"     :  sFieldType = "System.Double"  ;  break;
									case "decimal"   :  sFieldType = "System.Decimal" ;  break;
									case "short"     :  sFieldType = "System.Int16"   ;  break;
									case "Int32"     :  sFieldType = "System.Int32"   ;  break;
									case "Int64"     :  sFieldType = "System.Int64"   ;  break;
									default          :  sFieldType = "System.String"  ;  break;
								}
							}
						}
						sb.Append(i == 0 ? "select " : "     , ");
						if ( !Sql.IsEmptyString(oReportField.AggregateType) )
						{
							switch ( oReportField.AggregateType )
							{
								case "group by"        :  sb.Append(oReportField.FieldName + Strings.Space(nMaxLen - oReportField.FieldName.Length));  break;
								case "avg"             :  sb.Append("avg"    + "("          + oReportField.FieldName + ")");  break;
								case "count"           :  sb.Append("count"  + "("          + oReportField.FieldName + ")");  sFieldType = "System.Int64";  break;
								case "min"             :  sb.Append("min"    + "("          + oReportField.FieldName + ")");  break;
								case "max"             :  sb.Append("max"    + "("          + oReportField.FieldName + ")");  break;
								case "stdev"           :  sb.Append("stdev"  + "("          + oReportField.FieldName + ")");  break;
								case "stdevp"          :  sb.Append("stdevp" + "("          + oReportField.FieldName + ")");  break;
								case "sum"             :  sb.Append("sum"    + "("          + oReportField.FieldName + ")");  break;
								case "var"             :  sb.Append("var"    + "("          + oReportField.FieldName + ")");  break;
								case "varp"            :  sb.Append("varp"   + "("          + oReportField.FieldName + ")");  break;
								case "avg distinct"    :  sb.Append("avg"    + "(distinct " + oReportField.FieldName + ")");  break;
								case "count distinct"  :  sb.Append("count"  + "(distinct " + oReportField.FieldName + ")");  sFieldType = "System.Int64";  break;
								case "stdev distinct"  :  sb.Append("stdev"  + "(distinct " + oReportField.FieldName + ")");  break;
								case "stdevp distinct" :  sb.Append("stdevp" + "(distinct " + oReportField.FieldName + ")");  break;
								case "sum distinct"    :  sb.Append("sum"    + "(distinct " + oReportField.FieldName + ")");  break;
								case "var distinct"    :  sb.Append("var"    + "(distinct " + oReportField.FieldName + ")");  break;
								case "varp distinct"   :  sb.Append("varp"   + "(distinct " + oReportField.FieldName + ")");  break;
								default                :  sb.Append("\'Unknown AggregateType\'");  break;
							}
						}
						else
						{
							sb.Append(oReportField.FieldName + Strings.Space(nMaxLen - oReportField.FieldName.Length));
						}
						sb.Append(" as \"" + oReportField.FieldName + "\"");
						sb.AppendLine();
						rdl.CreateField(xFields, oReportField.FieldName, sFieldType);
					}
				}
				if ( rd.Relationships != null && rd.Relationships.Length == 0 && rd.Tables != null && rd.Tables.Length > 0 )
				{
					sb.AppendLine("  from vw" + rd.Tables[0].TableName + " " + rd.Tables[0].TableName);
					oUsedTables[rd.Tables[0].TableName] += 1;
				}
				else if ( rd.Relationships != null )
				{
					for ( int i = 0; i < rd.Relationships.Length; i++ )
					{
						string sJoinType       = String.Empty;
						string sJoinTypeSpacer = String.Empty;
						ReportDesign.ReportRelationship oReportRelationship = rd.Relationships[i];
						switch ( oReportRelationship.JoinType )
						{
							case "inner"      :  sJoinType = " inner join "      ;  sJoinTypeSpacer = "        "      ;  break;
							case "left outer" :  sJoinType = "  left outer join ";  sJoinTypeSpacer = "              ";  break;
							case "right outer":  sJoinType = " right outer join ";  sJoinTypeSpacer = "              ";  break;
							case "full outer" :  sJoinType = "  full outer join ";  sJoinTypeSpacer = "              ";  break;
						}
						if ( i == 0 )
						{
							if ( !Sql.IsEmptyString(oReportRelationship.LeftTableName) && !Sql.IsEmptyString(oReportRelationship.RightTableName) )
							{
								sb.AppendLine("  from vw" + oReportRelationship.LeftTableName + " " + oReportRelationship.LeftTableName);
								// 02/24/2015 Paul.  Need to prime the object list before incrementing. 
								if ( !oUsedTables.ContainsKey(oReportRelationship.LeftTableName) )
									oUsedTables[oReportRelationship.LeftTableName] = 0;
								oUsedTables[oReportRelationship.LeftTableName] += 1;
								sb.AppendLine(sJoinType + "vw" + oReportRelationship.RightTableName + " " + oReportRelationship.RightTableName);
								// 02/24/2015 Paul.  Need to prime the object list before incrementing. 
								if ( !oUsedTables.ContainsKey(oReportRelationship.RightTableName) )
									oUsedTables[oReportRelationship.RightTableName] = 0;
								oUsedTables[oReportRelationship.RightTableName] += 1;
								if ( oReportRelationship.JoinFields == null || oReportRelationship.JoinFields.Length == 0 )
								{
									sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_JOIN_FIELDS").Replace("{0}", oReportRelationship.LeftTableName).Replace("{1}", oReportRelationship.RightTableName) + "<br />");
								}
								else
								{
									for ( int j = 0; j < oReportRelationship.JoinFields.Length; j++ )
									{
										ReportDesign.ReportJoinField oJoinField = oReportRelationship.JoinFields[j];
										sb.AppendLine(sJoinTypeSpacer + (j == 0 ? " on " : "and ") + oJoinField.RightFieldName + " " + oJoinField.OperatorType + " " + oJoinField.LeftFieldName);
									}
								}
								if ( bUserSpecific || bUseSQLParameters )
								{
									if ( oReportRelationship.RightTableName != "vwUSERS" )
										this.ACLFilter(sb, sbACLWhere, oReportRelationship.RightTableName, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2, bUseSQLParameters);
								}
							}
						}
						else if ( oUsedTables[oReportRelationship.LeftTableName] > 0 && oUsedTables[oReportRelationship.RightTableName] > 0 )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_COMBINE_RELATIONSHIPS").Replace("{0}", oReportRelationship.LeftTableName).Replace("{1}", oReportRelationship.RightTableName) + "<br />");
						}
						else if ( oUsedTables[oReportRelationship.LeftTableName] > 0 )
						{
							sb.AppendLine(sJoinType + "vw" + oReportRelationship.RightTableName + " " + oReportRelationship.RightTableName);
							// 02/24/2015 Paul.  Need to prime the object list before incrementing. 
							if ( !oUsedTables.ContainsKey(oReportRelationship.RightTableName) )
								oUsedTables[oReportRelationship.RightTableName] = 0;
							oUsedTables[oReportRelationship.RightTableName] += 1;
							if ( oReportRelationship.JoinFields == null || oReportRelationship.JoinFields.Length == 0 )
							{
								sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_JOIN_FIELDS").Replace("{0}", oReportRelationship.LeftTableName).Replace("{1}", oReportRelationship.RightTableName) + "<br />");
							}
							else
							{
								for ( int j = 0; j < oReportRelationship.JoinFields.Length; j++ )
								{
									ReportDesign.ReportJoinField oJoinField = oReportRelationship.JoinFields[j];
									sb.AppendLine(sJoinTypeSpacer + (j == 0 ? " on " : "and ") + oJoinField.RightFieldName + " " + oJoinField.OperatorType + " " + oJoinField.LeftFieldName);
								}
							}
							if ( bUserSpecific || bUseSQLParameters )
							{
								if ( oReportRelationship.RightTableName != "vwUSERS" )
									this.ACLFilter(sb, sbACLWhere, oReportRelationship.RightTableName, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2, bUseSQLParameters);
							}
						}
						else if ( oUsedTables[oReportRelationship.RightTableName] > 0 )
						{
							// 01/06/2014 Paul.  If left table does not exist in query, then switch the join type. 
							switch ( oReportRelationship.JoinType )
							{
								case "left outer" :  sJoinType = " right outer join ";  break;
								case "right outer":  sJoinType = "  left outer join ";  break;
							}
							sb.AppendLine(sJoinType + "vw" + oReportRelationship.LeftTableName + ' ' + oReportRelationship.LeftTableName);
							// 02/24/2015 Paul.  Need to prime the object list before incrementing. 
							if ( !oUsedTables.ContainsKey(oReportRelationship.LeftTableName) )
								oUsedTables[oReportRelationship.LeftTableName] = 0;
							oUsedTables[oReportRelationship.LeftTableName] += 1;
							if ( oReportRelationship.JoinFields == null || oReportRelationship.JoinFields.Length == 0 )
							{
								sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_JOIN_FIELDS").Replace("{0}", oReportRelationship.LeftTableName).Replace("{1}", oReportRelationship.RightTableName) + "<br />");
							}
							else
							{
								for ( int j = 0; j < oReportRelationship.JoinFields.Length; j++ )
								{
									ReportDesign.ReportJoinField oJoinField = oReportRelationship.JoinFields[j];
									sb.AppendLine(sJoinTypeSpacer + (j == 0 ? " on " : "and ") + oJoinField.RightFieldName + " " + oJoinField.OperatorType + " " + oJoinField.LeftFieldName);
								}
							}
							if ( bUserSpecific || bUseSQLParameters )
							{
								if ( oReportRelationship.LeftTableName != "vwUSERS" )
									this.ACLFilter(sb, sbACLWhere, oReportRelationship.LeftTableName, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2, bUseSQLParameters);
							}
						}
					}
				}
				
				// 01/10/2010 Paul.  The Compaigns module will not need user-specific filtering. 
				if ( bUserSpecific || bUseSQLParameters )
				{
					// 04/17/2007 Paul.  Apply ACL rules. 
					if ( sMODULE_TABLE != "USERS" )
						this.ACLFilter(sb, sbACLWhere, sMODULE_TABLE, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2, bUseSQLParameters);
				}
				
				// 08/09/2014 Paul.  First clear the existing query parameters. 
				rdl.SetSingleNode("DataSets/DataSet/Query/QueryParameters", String.Empty);
				rdl.SetSingleNode("ReportParameters", String.Empty);
				XmlNode xQueryParameters  = rdl.SelectNode("DataSets/DataSet/Query/QueryParameters");
				XmlNode xReportParameters = rdl.SelectNode("ReportParameters");
				// 08/09/2014 Paul.  We need to remove the text nodes created above so that we can properly count the child nodes. 
				xQueryParameters.RemoveAll();
				xReportParameters.RemoveAll();
				if ( rd.AppliedFilters != null && rd.AppliedFilters.Length > 0 )
				{
					for ( int i = 0; i < rd.AppliedFilters.Length; i++ )
					{
						ReportDesign.ReportFilter oReportFilter = rd.AppliedFilters[i];
						
						// 04/22/2018 Paul.  We need to use the view and not the base table so as to include custom fields. 
						DataView vwColumns = SplendidCache.SqlColumns("vw" + oReportFilter.TableName).DefaultView;
						if ( Sql.IsEmptyString(oReportFilter.ColumnName) )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_FIELD").Replace("{0}", i.ToString()) + "<br />");
						}
						else if ( oReportFilter.Operator == null || oReportFilter.Operator == String.Empty )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_OPERATOR").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName) + "<br />");
						}
						else if ( oReportFilter.Value == null && (oReportFilter.Operator != "is null" && oReportFilter.Operator != "is not null") && !oReportFilter.Parameter )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName) + "<br />");
						}
						else if ( Sql.IsEmptyString(oReportFilter.Value) && (IsNumericField(vwColumns, oReportFilter.ColumnName) || IsDateField(vwColumns, oReportFilter.ColumnName) || IsBooleanField(vwColumns, oReportFilter.ColumnName)) && !oReportFilter.Parameter )
						{
							sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName) + "<br />");
						}
						else
						{
							// 04/22/2018 Paul.  We need to use the view and not the base table so as to include custom fields. 
							vwColumns.RowFilter = "ColumnName = '" + oReportFilter.ColumnName + "'";
							if ( vwColumns.Count == 0 )
							{
								sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_FIELD").Replace("{0}", i.ToString()) + " " + oReportFilter.ColumnName + "<br />");
								continue;
							}
							if ( i == 0 )
								sb.Append(" where ");
							else
								sb.Append("   and ");
							if ( oReportFilter.Operator == "is null" || oReportFilter.Operator == "is not null" )
							{
								sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
								sb.Append(oReportFilter.Operator);
							}
							else if ( bUseSQLParameters && oReportFilter.Parameter )
							{
								string sDATA_TYPE = "string";
								vwColumns.RowFilter = "ColumnName = '" + oReportFilter.ColumnName + "'";
								if ( vwColumns.Count > 0 )
								{
									DataRowView row = vwColumns[0];
									sDATA_TYPE = Sql.ToString(row["CsType"]);
								}
								if ( oReportFilter.Operator == "in" )
								{
									sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
									sb.Append(oReportFilter.Operator + " (@" + oReportFilter.ColumnName + ")");
								}
								else if ( oReportFilter.Operator == "not in" )
								{
									// 02/25/2015 Paul.  Filters that use NOT should protect against NULL values. 
									sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N\'\') ");
									sb.Append(oReportFilter.Operator + " (@" + oReportFilter.ColumnName + ")");
								}
								else if ( oReportFilter.Operator == "<>" )
								{
									// 02/25/2015 Paul.  Filters that use NOT should protect against NULL values. 
									sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N\'\') ");
									sb.Append(oReportFilter.Operator + " @" + oReportFilter.ColumnName);
								}
								// 04/11/2016 Paul.  Special support for between clause as a parameter. Needed to be separated into 2 report parameters. 
								else if ( oReportFilter.Operator == "between" )
								{
									sb.Append(oReportFilter.TableName + '.' + oReportFilter.ColumnName + " ");
									sb.Append(oReportFilter.Operator);
									// 02/24/2018 Paul.  Wrap inputs in isnull to allow before and after searching. 
									if ( sDATA_TYPE == "DateTime" )
										sb.Append(" isnull(@" + oReportFilter.ColumnName + "_AFTER, '1900/01/01')" + " and isnull(@" + oReportFilter.ColumnName + "_BEFORE, '2100/01/01')");
									else
										sb.Append(" @" + oReportFilter.ColumnName + "_AFTER" + " and " + "@" + oReportFilter.ColumnName + "_BEFORE");
								}
								else
								{
									sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
									sb.Append(oReportFilter.Operator + " @" + oReportFilter.ColumnName);
								}
								// 04/11/2016 Paul.  Special support for between clause as a parameter. Needed to be separated into 2 report parameters. 
								if ( oReportFilter.Operator == "between" )
								{
									rdl.AddQueryParameter (xQueryParameters , "@" + oReportFilter.ColumnName + "_AFTER" , "Parameter", "Parameters!" + oReportFilter.ColumnName + "_AFTER"  + ".Value");
									rdl.AddQueryParameter (xQueryParameters , "@" + oReportFilter.ColumnName + "_BEFORE", "Parameter", "Parameters!" + oReportFilter.ColumnName + "_BEFORE" + ".Value");
									// 04/11/2016 Paul.  Blank is not a valid default value, so use string instead. 
									sDATA_TYPE = "string";
									object oVALUE_AFTER  = null;
									object oVALUE_BEFORE = null;
									// 02/24/2018 Paul.  Make sure that there are values first. 
									if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray )
									{
										object[] arrValue = oReportFilter.Value as object[];
										if ( arrValue.Length >= 1 ) oVALUE_AFTER  = arrValue[0];
										// 02/16/2018 Paul.  Second value is the Before value. 
										if ( arrValue.Length >= 2 ) oVALUE_BEFORE = arrValue[1];
									}
									// 04/11/2016 Paul.  Use BuildTermName. 
									rdl.AddReportParameter(xReportParameters, oReportFilter.ColumnName + "_AFTER" , sDATA_TYPE, true, L10n.Term(Utils.BuildTermName(sMODULE_TABLE, oReportFilter.ColumnName)) + " " + L10n.Term("SavedSearch.LBL_SEARCH_AFTER" ), oVALUE_AFTER );
									rdl.AddReportParameter(xReportParameters, oReportFilter.ColumnName + "_BEFORE", sDATA_TYPE, true, L10n.Term(Utils.BuildTermName(sMODULE_TABLE, oReportFilter.ColumnName)) + " " + L10n.Term("SavedSearch.LBL_SEARCH_BEFORE"), oVALUE_BEFORE);
								}
								else
								{
									rdl.AddQueryParameter (xQueryParameters , "@" + oReportFilter.ColumnName, "Parameter", "Parameters!" + oReportFilter.ColumnName + ".Value");
									// 04/11/2016 Paul.  Use BuildTermName. 
									rdl.AddReportParameter(xReportParameters, oReportFilter.ColumnName, sDATA_TYPE, true, L10n.Term(Utils.BuildTermName(sMODULE_TABLE, oReportFilter.ColumnName)), oReportFilter.Value);
								}
							}
							else if ( oReportFilter.Operator == "in" )
							{
								if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray )
								{
									sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
									sb.Append(oReportFilter.Operator + " (");
									object[] arrValue = oReportFilter.Value as object[];
									for ( int j = 0; j < arrValue.Length; j++ )
									{
										if ( j > 0 )
											sb.Append(", ");
										sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[j])) + "\'");
									}
									sb.Append(")");
								}
								else
								{
									sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_INVALID_ARRAY_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName).Replace("{1}", Sql.ToString(L10n.Term("report_filter_operator_dom", oReportFilter.Operator))) + "<br />");
								}
							}
							else if ( oReportFilter.Operator == "not in" )
							{
								if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray )
								{
									// 02/25/2015 Paul.  Filters that use NOT should protect against NULL values. 
									sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N\'\') ");
									sb.Append(oReportFilter.Operator + " (");
									object[] arrValue = oReportFilter.Value as object[];
									for ( int j = 0; j < arrValue.Length; j++ )
									{
										if ( j > 0 )
											sb.Append(", ");
										sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[j])) + "\'");
									}
									sb.Append(")");
								}
								else
								{
									sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_INVALID_ARRAY_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName).Replace("{1}", Sql.ToString(L10n.Term("report_filter_operator_dom", oReportFilter.Operator))) + "<br />");
								}
							}
							// 02/24/2015 Paul.  Add support for between filter clause. 
							else if ( oReportFilter.Operator == "between" )
							{
								if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray && (oReportFilter.Value as object[]).Length >= 2 )
								{
									object[] arrValue = oReportFilter.Value as object[];
									sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
									sb.Append(oReportFilter.Operator + " ");
									sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[0])) + "\'");
									sb.Append(" and ");
									sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(arrValue[1])) + "\'");
								}
								else
								{
									sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName).Replace("{1}", Sql.ToString(L10n.Term("report_filter_operator_dom", oReportFilter.Operator))) + "<br />");
								}
							}
							else if ( oReportFilter.Value == null )
							{
								sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_MISSING_FILTER_VALUE").Replace("{0}", oReportFilter.TableName + "." + oReportFilter.ColumnName) + "<br />");
							}
							else if ( oReportFilter.Operator == "like" )
							{
								sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
								sb.Append(oReportFilter.Operator);
								sb.Append(" ");
								// 06/14/2015 Paul.  We want to allow the original like syntax which uses % for any chars and _ for any single char. 
								sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(oReportFilter.Value)) + "\'");
							}
							else if ( oReportFilter.Operator == "not like" )
							{
								// 02/25/2015 Paul.  Filters that use NOT should protect against NULL values. 
								sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N\'\') ");
								sb.Append(oReportFilter.Operator);
								sb.Append(" ");
								// 06/14/2015 Paul.  We want to allow the original like syntax which uses % for any chars and _ for any single char. 
								sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(oReportFilter.Value)) + "\'");
							}
							else if ( oReportFilter.Operator == "<>" )
							{
								// 02/25/2015 Paul.  Filters that use NOT should protect against NULL values. 
								sb.Append("coalesce(" + oReportFilter.TableName + "." + oReportFilter.ColumnName + ", N\'\') ");
								sb.Append(oReportFilter.Operator);
								sb.Append(" ");
								sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(oReportFilter.Value)) + "\'");
							}
							else
							{
								sb.Append(oReportFilter.TableName + "." + oReportFilter.ColumnName + " ");
								sb.Append(oReportFilter.Operator);
								sb.Append(" ");
								sb.Append("\'" + Sql.EscapeSQL(Sql.ToString(oReportFilter.Value)) + "\'");
							}
							sb.AppendLine();
						}
					}
				}
				// 08/09/2014 Paul.  If there were no parameters, we need to remove the empty nodes, otherwise the schema will fail validiation. 
				if ( xQueryParameters.ChildNodes.Count == 0 )
					xQueryParameters.ParentNode.RemoveChild(xQueryParameters);
				if ( xReportParameters.ChildNodes.Count == 0 )
					xReportParameters.ParentNode.RemoveChild(xReportParameters);
				
				if ( rd.SelectedFields != null )
				{
					int nGroupBy = 0;
					for ( int i = 0; i < rd.SelectedFields.Length; i++ )
					{
						ReportDesign.ReportField oReportField = rd.SelectedFields[i];
						if ( !Sql.IsEmptyString(oReportField.AggregateType) )
						{
							if ( oReportField.AggregateType == "group by" )
							{
								sb.Append((nGroupBy == 0 ? " group by " : ", "));
								sb.Append(oReportField.FieldName);
								nGroupBy++;
							}
						}
					}
					if ( nGroupBy > 0 )
						sb.AppendLine();
		
					int nOrderBy = 0;
					for ( int i = 0; i < rd.SelectedFields.Length; i++ )
					{
						ReportDesign.ReportField oReportField = rd.SelectedFields[i];
						if ( !Sql.IsEmptyString(oReportField.SortDirection) )
						{
							sb.Append(nOrderBy == 0 ? " order by " : ", ");
							if ( !Sql.IsEmptyString(oReportField.AggregateType) )
							{
								switch ( oReportField.AggregateType )
								{
									case "group by"        :  sb.Append(                          oReportField.FieldName       + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "avg"             :  sb.Append("avg"    + "("          + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "count"           :  sb.Append("count"  + "("          + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "min"             :  sb.Append("min"    + "("          + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "max"             :  sb.Append("max"    + "("          + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "stdev"           :  sb.Append("stdev"  + "("          + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "stdevp"          :  sb.Append("stdevp" + "("          + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "sum"             :  sb.Append("sum"    + "("          + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "var"             :  sb.Append("var"    + "("          + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "varp"            :  sb.Append("varp"   + "("          + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "avg distinct"    :  sb.Append("avg"    + "(distinct " + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "count distinct"  :  sb.Append("count"  + "(distinct " + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "stdev distinct"  :  sb.Append("stdev"  + "(distinct " + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "stdevp distinct" :  sb.Append("stdevp" + "(distinct " + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "sum distinct"    :  sb.Append("sum"    + "(distinct " + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "var distinct"    :  sb.Append("var"    + "(distinct " + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
									case "varp distinct"   :  sb.Append("varp"   + "(distinct " + oReportField.FieldName + ")" + " " + oReportField.SortDirection);  nOrderBy++;  break;
								}
							}
							else
							{
								sb.Append(oReportField.FieldName + ' ' + oReportField.SortDirection);
								nOrderBy++;
							}
						}
					}
					if ( nOrderBy > 0 )
						sb.AppendLine();
				}
				
				string sUnusedTables = String.Empty;
				foreach ( string sTableName in oUsedTables.Keys )
				{
					if ( oUsedTables[sTableName] == 0 )
					{
						if ( sUnusedTables.Length > 0 )
							sUnusedTables += ", ";
						sUnusedTables += sTableName;
					}
				}
				if ( sUnusedTables.Length > 0 )
				{
					sbErrors.AppendLine(L10n.Term("ReportDesigner.LBL_UNRELATED_ERROR").Replace("{0}", sUnusedTables));
				}
			}
			string sReportSQL = sb.ToString();
			rdl.SetSingleNode("DataSets/DataSet/Query/CommandText", sReportSQL);

			// 04/22/2018 Paul.  Alert when error is found.  Otherwise error is ignored. 
			if ( sbErrors.Length > 0 )
			{
				throw(new Exception(sbErrors.ToString()));
			}
			return sReportSQL;
		}

		private DataTable ReportFilters(RdlDocument rdl)
		{
			DataTable dtFilters = new DataTable();
			XmlDocument xmlFilters = rdl.GetCustomProperty("Filters");
			dtFilters = XmlUtil.CreateDataTable(xmlFilters.DocumentElement, "Filter", new string[] {"ID", "MODULE_NAME", "DATA_FIELD", "DATA_TYPE", "OPERATOR", "SEARCH_TEXT"});
			return dtFilters;
		}

		private DataTable ReportRelationships(RdlDocument rdl)
		{
			DataTable dtColumnSource = new DataTable();
			XmlDocument xmlRelationships = rdl.GetCustomProperty("Relationships");
			dtColumnSource = XmlUtil.CreateDataTable(xmlRelationships.DocumentElement, "Relationship", new string[] {"MODULE_NAME", "DISPLAY_NAME"});
			return dtColumnSource;
		}

		private DataTable ReportDisplayColumns(RdlDocument rdl)
		{
			DataTable dtDisplayColumns = new DataTable();
			XmlDocument xmlDisplayColumns = rdl.GetCustomProperty("DisplayColumns");
			dtDisplayColumns = XmlUtil.CreateDataTable(xmlDisplayColumns.DocumentElement, "DisplayColumn", new string[] {"Label", "Field", "AggregateType", "DisplayWidth", "SortDirection"});
			return dtDisplayColumns;
		}

		private XmlDocument ReplatedModulesXML(RdlDocument rdl, string sMODULE, L10N L10n, bool bDebug)
		{
			DataView vwRelationships = new DataView(SplendidCache.ReportingRelationships());
			vwRelationships.RowFilter = "       RELATIONSHIP_TYPE = 'many-to-many' " + ControlChars.CrLf
			                          + "   and LHS_MODULE        = \'" + sMODULE + "\'" + ControlChars.CrLf;
			// 06/10/2006 Paul.  Filter by the modules that the user has access to. 
			Sql.AppendParameter(vwRelationships, SplendidCache.ReportingModulesList(), "RHS_MODULE", false);

			XmlDocument xmlRelationships = new XmlDocument();
			xmlRelationships.AppendChild(xmlRelationships.CreateElement("Relationships"));
			
			XmlNode xRelationship = null;
			foreach(DataRowView row in vwRelationships)
			{
				string sRELATIONSHIP_NAME              = Sql.ToString(row["RELATIONSHIP_NAME"             ]);
				string sLHS_MODULE                     = Sql.ToString(row["LHS_MODULE"                    ]);
				string sLHS_TABLE                      = Sql.ToString(row["LHS_TABLE"                     ]).ToUpper();
				string sLHS_KEY                        = Sql.ToString(row["LHS_KEY"                       ]).ToUpper();
				string sRHS_MODULE                     = Sql.ToString(row["RHS_MODULE"                    ]);
				string sRHS_TABLE                      = Sql.ToString(row["RHS_TABLE"                     ]).ToUpper();
				string sRHS_KEY                        = Sql.ToString(row["RHS_KEY"                       ]).ToUpper();
				string sJOIN_TABLE                     = Sql.ToString(row["JOIN_TABLE"                    ]).ToUpper();
				string sJOIN_KEY_LHS                   = Sql.ToString(row["JOIN_KEY_LHS"                  ]).ToUpper();
				string sJOIN_KEY_RHS                   = Sql.ToString(row["JOIN_KEY_RHS"                  ]).ToUpper();
				// 11/20/2008 Paul.  Quotes, Orders and Invoices have a relationship column. 
				string sRELATIONSHIP_ROLE_COLUMN       = Sql.ToString(row["RELATIONSHIP_ROLE_COLUMN"      ]).ToUpper();
				string sRELATIONSHIP_ROLE_COLUMN_VALUE = Sql.ToString(row["RELATIONSHIP_ROLE_COLUMN_VALUE"]);
				string sMODULE_NAME       = sRHS_MODULE + " " + sRHS_TABLE;
				string sDISPLAY_NAME      = L10n.Term(".moduleList." + sRHS_MODULE);
				// 10/26/2011 Paul.  Use the join table so that the display is more descriptive. 
				if ( !Sql.IsEmptyString(sJOIN_TABLE) )
					sDISPLAY_NAME = Sql.CamelCaseModules(L10n, sJOIN_TABLE);
				if ( bDebug )
				{
					sDISPLAY_NAME = "[" + sMODULE_NAME + "] " + sDISPLAY_NAME;
				}
				// 02/18/2009 Paul.  Include the relationship column if provided. 
				// 10/26/2011 Paul.  Include the role. 
				if ( !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN) && !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN_VALUE) && sRELATIONSHIP_ROLE_COLUMN_VALUE != sMODULE )
					sDISPLAY_NAME += " " + sRELATIONSHIP_ROLE_COLUMN_VALUE;
				// 10/26/2011 Paul.  Add the relationship so that we can have a unique lookup. 
				sMODULE_NAME += " " + sRELATIONSHIP_NAME;
				
				xRelationship = xmlRelationships.CreateElement("Relationship");
				xmlRelationships.DocumentElement.AppendChild(xRelationship);
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_NAME"             , sRELATIONSHIP_NAME             );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_MODULE"                    , sLHS_MODULE                    );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_TABLE"                     , sLHS_TABLE                     );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "LHS_KEY"                       , sLHS_KEY                       );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_MODULE"                    , sRHS_MODULE                    );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_TABLE"                     , sRHS_TABLE                     );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RHS_KEY"                       , sRHS_KEY                       );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "JOIN_TABLE"                    , sJOIN_TABLE                    );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "JOIN_KEY_LHS"                  , sJOIN_KEY_LHS                  );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "JOIN_KEY_RHS"                  , sJOIN_KEY_RHS                  );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_TYPE"             , "many-to-many"                 );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "MODULE_NAME"                   , sMODULE_NAME                   );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "DISPLAY_NAME"                  , sDISPLAY_NAME                  );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_ROLE_COLUMN"      , sRELATIONSHIP_ROLE_COLUMN      );
				XmlUtil.SetSingleNode(xmlRelationships, xRelationship, "RELATIONSHIP_ROLE_COLUMN_VALUE", sRELATIONSHIP_ROLE_COLUMN_VALUE);
			}
			return xmlRelationships;
		}

		// 04/01/2020 Paul.  Make DisplayColumnsUpdate static so that we cann call from Rest API. 
		public void DisplayColumnsUpdate(RdlDocument rdl, ReportDesign rd)
		{
			// 06/15/2006 Paul.  There is no need to load the existing Fields data as we are going to completely replace it. 
			//string sFields = rdl.GetCustomProperty("DisplayColumns");
			// 08/09/2014 Paul.  There seems to be a problem serializing an object array. 
			if ( rd != null && rd.AppliedFilters != null )
			{
				for ( int i = 0; i < rd.AppliedFilters.Length; i++ )
				{
					ReportDesign.ReportFilter oReportFilter = rd.AppliedFilters[i];
					if ( oReportFilter.Value != null && oReportFilter.Value.GetType().IsArray )
					{
						List<string> lstValues = new List<string>();
						object[] arrValue = oReportFilter.Value as object[];
						for ( int j = 0; j < arrValue.Length; j++ )
						{
							lstValues.Add(Sql.ToString(arrValue[j]));
						}
						oReportFilter.Value = lstValues.ToArray();
					}
				}
			}
			XmlSerializer x = new XmlSerializer(typeof(ReportDesign));
			using ( MemoryStream mem = new MemoryStream() )
			{
				using ( TextWriter stm = new StreamWriter(mem) )
				{
					x.Serialize(stm, rd);
					stm.Flush();
				}
				string sReportDesign = Encoding.UTF8.GetString(mem.ToArray());
				rdl.SetCustomProperty("ReportDesign", sReportDesign);
			}
				
			XmlDocument xmlDisplayColumns = new XmlDocument();
			xmlDisplayColumns.AppendChild(xmlDisplayColumns.CreateElement("DisplayColumns"));
				
			//if ( bDesignChart )
			//{
			//	XmlNode xDisplayColumn = xmlDisplayColumns.CreateElement("DisplayColumn");
			//	xmlDisplayColumns.DocumentElement.AppendChild(xDisplayColumn);
			//
			//	XmlNode xLabel = xmlDisplayColumns.CreateElement("Label");
			//	XmlNode xField = xmlDisplayColumns.CreateElement("Field");
			//	xDisplayColumn.AppendChild(xLabel);
			//	xDisplayColumn.AppendChild(xField);
			//	xLabel.InnerText = lstCATEGORY_COLUMN.SelectedItem.Text;
			//	xField.InnerText = lstCATEGORY_COLUMN.SelectedValue;
			//
			//	xDisplayColumn = xmlDisplayColumns.CreateElement("DisplayColumn");
			//	xmlDisplayColumns.DocumentElement.AppendChild(xDisplayColumn);
			//
			//	xLabel = xmlDisplayColumns.CreateElement("Label");
			//	xField = xmlDisplayColumns.CreateElement("Field");
			//	xDisplayColumn.AppendChild(xLabel);
			//	xDisplayColumn.AppendChild(xField);
			//	xLabel.InnerText = lstSERIES_COLUMN.SelectedItem.Text;
			//	xField.InnerText = lstSERIES_COLUMN.SelectedValue;
			//}
			//else
			{
				if ( rd != null && rd.Tables != null )
				{
					if ( rd.Tables.Length > 0 )
					{
						rdl.SetCustomProperty("Module", rd.Tables[0].ModuleName);
					}
					for ( int i = 0; i < rd.SelectedFields.Length; i++ )
					{
						ReportDesign.ReportField oReportField = rd.SelectedFields[i];
						// 07/15/2006 Paul.  Store  both the header and the field. 
						// The previous method of relying upon the RDL Header notes has a greater potential for errors. 
						XmlNode xDisplayColumn = xmlDisplayColumns.CreateElement("DisplayColumn");
						xmlDisplayColumns.DocumentElement.AppendChild(xDisplayColumn);

						XmlNode xLabel = xmlDisplayColumns.CreateElement("Label");
						XmlNode xField = xmlDisplayColumns.CreateElement("Field");
						XmlNode xWidth = xmlDisplayColumns.CreateElement("Width");
						xDisplayColumn.AppendChild(xLabel);
						xDisplayColumn.AppendChild(xField);
						xDisplayColumn.AppendChild(xWidth);
						xLabel.InnerText = oReportField.DisplayName ;
						xField.InnerText = oReportField.FieldName   ;
						xWidth.InnerText = oReportField.DisplayWidth;
					}
				}
			}
			rdl.SetCustomProperty("DisplayColumns", xmlDisplayColumns.OuterXml.Replace("</DisplayColumn>", "</DisplayColumn>" + ControlChars.CrLf));
		}

		// 04/12/2020 Paul.  Make static so that it can be used by Rest.svc and view_embedded.aspx. 
		public void UpdateDataTable(RdlDocument rdl)
		{
			XmlDocument xmlDisplayColumns = rdl.GetCustomProperty("DisplayColumns");
			DataTable dtDisplayColumns = XmlUtil.CreateDataTable(xmlDisplayColumns.DocumentElement, "DisplayColumn", new string[] { "Label", "Field", "Width"});
			rdl.UpdateDataTable(dtDisplayColumns);
		}
		#endregion

		// 03/31/2020 Paul.  Separate out GetReportDesign so that it can be called from the React Client. 
		public string GetReportDesign(RdlDocument rdl, string[] arrModules, string sRDL, L10N L10n, bool bDebug)
		{
			string sJSON = String.Empty;
			if ( !Sql.IsEmptyString(sRDL) )
			{
				DataView vwModules = new DataView(SplendidCache.ReportingModules());
				if ( arrModules != null && arrModules.Length > 0 )
				{
					vwModules.RowFilter = "MODULE_NAME in ('" + String.Join("', '", arrModules) + "')";
				}
				rdl.LoadRdl(sRDL);
				string sReportDesign = rdl.GetCustomPropertyValue("ReportDesign");
				if ( Sql.IsEmptyString(sReportDesign) )
				{
					string sMODULE_NAME  = rdl.GetCustomPropertyValue("Module" );
					string sRELATED_NAME = rdl.GetCustomPropertyValue("Related");
					if ( Sql.IsEmptyString(sMODULE_NAME) )
					{
						string sCommandText = rdl.CommandText();
						foreach ( DataRowView row in vwModules )
						{
							string sTABLE_NAME = Sql.ToString(row["TABLE_NAME"]);
							// 10/30/2014 Paul.  Make sure that there is some sort of end to the view to prevent a hit on a relationship table. 
							if ( sCommandText.Contains("from vw" + sTABLE_NAME + " ") || sCommandText.Contains("from vw" + sTABLE_NAME + "\r\n") )
							{
								sMODULE_NAME = Sql.ToString(row["MODULE_NAME"]);
								break;
							}
						}
					}
						
					Hashtable hashRequiredModules  = new Hashtable();
					XmlDocument xmlDisplayColumns = rdl.GetCustomProperty("DisplayColumns");
					XmlNodeList nlFields = xmlDisplayColumns.DocumentElement.SelectNodes("DisplayColumn/Field");
					foreach ( XmlNode xField in nlFields )
					{
						string sMODULE_ALIAS = xField.InnerText.Split('.')[0];
						if ( !hashRequiredModules.ContainsKey(sMODULE_ALIAS) )
						{
							hashRequiredModules.Add(sMODULE_ALIAS, null);
						}
					}
					XmlDocument xmlFilters = rdl.GetCustomProperty("Filters");
					XmlNodeList nlFilters = xmlFilters.DocumentElement.SelectNodes("Filter");
					foreach ( XmlNode xFilter in nlFilters )
					{
						string sDATA_FIELD = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD");
						string sMODULE_ALIAS = sDATA_FIELD.Split('.')[0];
						if ( !hashRequiredModules.ContainsKey(sMODULE_ALIAS) )
							hashRequiredModules.Add(sMODULE_ALIAS, null);
					}

					string sMODULE_TABLE = Modules.TableName(sMODULE_NAME);
					if ( hashRequiredModules.ContainsKey(sMODULE_TABLE) )
						hashRequiredModules.Remove(sMODULE_TABLE);
						
					ReportDesign rd = new ReportDesign();
					List<ReportDesign.ReportTable       > lstTables         = new List<ReportDesign.ReportTable       >();
					List<ReportDesign.ReportField       > lstSelectedFields = new List<ReportDesign.ReportField       >();
					List<ReportDesign.ReportRelationship> lstRelationships  = new List<ReportDesign.ReportRelationship>();
					List<ReportDesign.ReportFilter      > lstAppliedFilters = new List<ReportDesign.ReportFilter      >();
						
					ReportDesign.ReportTable rdTable = new ReportDesign.ReportTable();
					rdTable.ModuleName = sMODULE_NAME;
					rdTable.TableName  = sMODULE_TABLE;
					lstTables.Add(rdTable);
					if ( !Sql.IsEmptyString(sRELATED_NAME) )
					{
						// 02/24/2015 Paul.  Needed to extract the related module from the parts. 
						string[] arrRELATED_NAME = sRELATED_NAME.Split(' ');
						string sRELATED          = arrRELATED_NAME[0];
						// 02/24/2015 Paul.  Needed to create a new object so as not to add the same object twice. 
						rdTable = new ReportDesign.ReportTable();
						rdTable.ModuleName = sRELATED;
						rdTable.TableName  = Modules.TableName(sRELATED);
						lstTables.Add(rdTable);
					}
						
					DataTable dtDisplayColumns = ReportDisplayColumns(rdl);
					foreach ( DataRow row in dtDisplayColumns.Rows )
					{
						ReportDesign.ReportField rdField = new ReportDesign.ReportField();
						rdField.DisplayName   = Sql.ToString(row["Label"        ]);
						rdField.FieldName     = Sql.ToString(row["Field"        ]);
						rdField.AggregateType = Sql.ToString(row["AggregateType"]);
						rdField.DisplayWidth  = Sql.ToString(row["DisplayWidth" ]);
						rdField.SortDirection = Sql.ToString(row["SortDirection"]);
						string[] arrFieldName = rdField.FieldName.Split('.');
						if ( arrFieldName.Length >= 2 )
						{
							rdField.TableName  = arrFieldName[0];
							rdField.ColumnName = arrFieldName[1];
						}
						else
						{
							rdField.TableName  = Modules.TableName(sMODULE_NAME);
							rdField.ColumnName = rdField.FieldName;
						}
						lstSelectedFields.Add(rdField);
					}
					// 10/30/2014 Paul.  If there is no SplendidCRM embedded design, build from data set. 
					if ( dtDisplayColumns.Rows.Count == 0 )
					{
						XmlNodeList nlDataSets = rdl.SelectNodesNS("DataSets/DataSet");
						if ( nlDataSets != null && nlDataSets.Count > 0 )
						{
							// 10/30/2014 Paul.  There may be multiple data sets, but only get the first. 
							XmlNodeList xFields = rdl.SelectNodesNS(nlDataSets[0], "Fields/Field");
							foreach ( XmlNode xField in xFields )
							{
								string sDataField = rdl.SelectNodeValue(xField, "DataField");
								if ( !Sql.IsEmptyString(sDataField) )
								{
									ReportDesign.ReportField rdField = new ReportDesign.ReportField();
									rdField.DisplayName   = sDataField;
									rdField.FieldName     = sDataField;
									rdField.AggregateType = String.Empty;  //Sql.ToString(row["AggregateType"]);
									rdField.DisplayWidth  = String.Empty;  //Sql.ToString(row["DisplayWidth" ]);
									rdField.SortDirection = String.Empty;  //Sql.ToString(row["SortDirection"]);
									string[] arrFieldName = rdField.FieldName.Split('.');
									if ( arrFieldName.Length >= 2 )
									{
										rdField.TableName  = arrFieldName[0];
										rdField.ColumnName = arrFieldName[1];
									}
									else
									{
										rdField.TableName  = Modules.TableName(sMODULE_NAME);
										rdField.ColumnName = rdField.FieldName;
									}
									lstSelectedFields.Add(rdField);
								}
							}
						}
					}
					XmlDocument xmlRelatedModules = ReplatedModulesXML(rdl, sMODULE_NAME, L10n, bDebug);
					if ( !Sql.IsEmptyString(sRELATED_NAME) )
					{
						string[] arrRELATED_NAME = sRELATED_NAME.Split(' ');
						if ( arrRELATED_NAME.Length == 3 )
						{
							string sRELATED           = arrRELATED_NAME[0];
							string sRELATED_ALIAS     = arrRELATED_NAME[1];
							string sRELATIONSHIP_NAME = arrRELATED_NAME[2];
							if ( hashRequiredModules.ContainsKey(sRELATED_ALIAS) )
								hashRequiredModules.Remove(sRELATED_ALIAS);
								
							XmlNode xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RELATIONSHIP_NAME=\'" + sRELATIONSHIP_NAME + "\']");
							if ( xRelationship != null )
							{
								sRELATIONSHIP_NAME                     = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_NAME"             );
								string sLHS_TABLE                      = XmlUtil.SelectSingleNode(xRelationship, "LHS_TABLE"                     );
								string sLHS_KEY                        = XmlUtil.SelectSingleNode(xRelationship, "LHS_KEY"                       );
								string sRHS_TABLE                      = XmlUtil.SelectSingleNode(xRelationship, "RHS_TABLE"                     );
								string sRHS_KEY                        = XmlUtil.SelectSingleNode(xRelationship, "RHS_KEY"                       );
								string sJOIN_TABLE                     = XmlUtil.SelectSingleNode(xRelationship, "JOIN_TABLE"                    );
								string sJOIN_KEY_LHS                   = XmlUtil.SelectSingleNode(xRelationship, "JOIN_KEY_LHS"                  );
								string sJOIN_KEY_RHS                   = XmlUtil.SelectSingleNode(xRelationship, "JOIN_KEY_RHS"                  );
								string sRELATIONSHIP_ROLE_COLUMN       = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_ROLE_COLUMN"      );
								string sRELATIONSHIP_ROLE_COLUMN_VALUE = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_ROLE_COLUMN_VALUE");
								if ( Sql.IsEmptyString(sJOIN_TABLE) )
								{
									ReportDesign.ReportRelationship rdRelationship = new ReportDesign.ReportRelationship();
									rdRelationship.RightTableName = sRHS_TABLE    ;
									// 02/24/2015 Paul.  JoinType should just be "inner". 
									rdRelationship.JoinType       = "inner"       ;
									rdRelationship.LeftTableName  = sLHS_TABLE    ;
									ReportDesign.ReportJoinField rdJoinField = new ReportDesign.ReportJoinField();
									rdJoinField.LeftTableName     = sLHS_TABLE    ;
									rdJoinField.LeftColumnName    = sLHS_KEY      ;
									rdJoinField.OperatorType      = "="           ;
									rdJoinField.RightTableName    = sRHS_TABLE    ;
									rdJoinField.RightColumnName   = sRHS_KEY      ;
									List<ReportDesign.ReportJoinField> lstJoinFields = new List<ReportDesign.ReportJoinField>();
									lstJoinFields.Add(rdJoinField);
									rdRelationship.JoinFields = lstJoinFields.ToArray();
									lstRelationships.Add(rdRelationship);
								}
								else
								{
									ReportDesign.ReportRelationship rdRelationship = new ReportDesign.ReportRelationship();
									List<ReportDesign.ReportJoinField> lstJoinFields = new List<ReportDesign.ReportJoinField>();
									rdRelationship.RightTableName = sJOIN_TABLE   ;
									// 02/24/2015 Paul.  JoinType should just be "inner". 
									rdRelationship.JoinType       = "inner"       ;
									rdRelationship.LeftTableName  = sLHS_TABLE    ;
									ReportDesign.ReportJoinField rdJoinField = new ReportDesign.ReportJoinField();
									rdJoinField.LeftTableName     = sLHS_TABLE    ;
									rdJoinField.LeftColumnName    = sLHS_KEY      ;
									rdJoinField.OperatorType      = "="           ;
									rdJoinField.RightTableName    = sJOIN_TABLE   ;
									rdJoinField.RightColumnName   = sJOIN_KEY_LHS ;
									lstJoinFields.Add(rdJoinField);
									rdRelationship.JoinFields = lstJoinFields.ToArray();
									lstRelationships.Add(rdRelationship);
									if ( !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN) && !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN_VALUE) )
									{
										rdJoinField = new ReportDesign.ReportJoinField();
										rdJoinField.LeftTableName     = "";
										rdJoinField.LeftColumnName    = "";
										rdJoinField.OperatorType      = "= N'" + sRELATIONSHIP_ROLE_COLUMN_VALUE + "'";
										rdJoinField.RightTableName    = sJOIN_TABLE   ;
										rdJoinField.RightColumnName   = sRELATIONSHIP_ROLE_COLUMN ;
										lstJoinFields.Add(rdJoinField);
										rdRelationship.JoinFields = lstJoinFields.ToArray();
									}
										
									rdRelationship = new ReportDesign.ReportRelationship();
									// 02/24/2015 Paul.  Needed to reset the join fields for the new relationship. 
									lstJoinFields = new List<ReportDesign.ReportJoinField>();
									rdRelationship.RightTableName = sRHS_TABLE    ;
									// 02/24/2015 Paul.  JoinType should just be "inner". 
									rdRelationship.JoinType       = "inner"       ;
									rdRelationship.LeftTableName  = sJOIN_TABLE   ;
									rdJoinField = new ReportDesign.ReportJoinField();
									rdJoinField.LeftTableName     = sJOIN_TABLE   ;
									rdJoinField.LeftColumnName    = sJOIN_KEY_RHS ;
									rdJoinField.OperatorType      = "="           ;
									rdJoinField.RightTableName    = sRHS_TABLE    ;
									rdJoinField.RightColumnName   = sRHS_KEY      ;
									lstJoinFields.Add(rdJoinField);
									rdRelationship.JoinFields = lstJoinFields.ToArray();
									lstRelationships.Add(rdRelationship);
								}
							}
						}
					}
					if ( hashRequiredModules.Count > 0 )
					{
						XmlDocument xmlRelationships = rdl.GetCustomProperty("Relationships");
						foreach ( string sMODULE_ALIAS in hashRequiredModules.Keys )
						{
							XmlNode xRelationship = xmlRelationships.DocumentElement.SelectSingleNode("Relationship[MODULE_ALIAS=\'" + sMODULE_ALIAS + "\']");
							if ( xRelationship != null )
							{
								string sRELATIONSHIP_NAME = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_NAME");
								string sLHS_TABLE         = XmlUtil.SelectSingleNode(xRelationship, "LHS_TABLE"        );
								string sLHS_KEY           = XmlUtil.SelectSingleNode(xRelationship, "LHS_KEY"          );
								string sRHS_TABLE         = XmlUtil.SelectSingleNode(xRelationship, "RHS_TABLE"        );
								string sRHS_KEY           = XmlUtil.SelectSingleNode(xRelationship, "RHS_KEY"          );
									
								ReportDesign.ReportRelationship rdRelationship = new ReportDesign.ReportRelationship();
								rdRelationship.RightTableName = sLHS_TABLE    ;
								// 02/24/2015 Paul.  JoinType should just be "inner". 
								rdRelationship.JoinType       = "inner"       ;
								rdRelationship.LeftTableName  = sRHS_TABLE    ;
								ReportDesign.ReportJoinField rdJoinField = new ReportDesign.ReportJoinField();
								rdJoinField.LeftTableName     = sRHS_TABLE    ;
								rdJoinField.LeftColumnName    = sRHS_KEY      ;
								rdJoinField.OperatorType      = "="           ;
								rdJoinField.RightTableName    = sLHS_TABLE    ;
								rdJoinField.RightColumnName   = sLHS_KEY      ;
								List<ReportDesign.ReportJoinField> lstJoinFields = new List<ReportDesign.ReportJoinField>();
								lstJoinFields.Add(rdJoinField);
								rdRelationship.JoinFields = lstJoinFields.ToArray();
								lstRelationships.Add(rdRelationship);
							}
						}
					}
					if ( xmlFilters.DocumentElement != null )
					{
						foreach ( XmlNode xFilter in xmlFilters.DocumentElement )
						{
							string sMODULE_NAME2   = XmlUtil.SelectSingleNode(xFilter, "MODULE_NAME");
							string sDATA_FIELD     = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD" );
							string sDATA_TYPE      = XmlUtil.SelectSingleNode(xFilter, "DATA_TYPE"  );
							string sOPERATOR       = XmlUtil.SelectSingleNode(xFilter, "OPERATOR"   );
							string sSEARCH_TEXT1   = String.Empty;
							string sSEARCH_TEXT2   = String.Empty;
								
							XmlNodeList nlValues = xFilter.SelectNodes("SEARCH_TEXT_VALUES");
							string[] arrSEARCH_TEXT = new string[nlValues.Count];
							int i = 0;
							foreach ( XmlNode xValue in nlValues )
							{
								arrSEARCH_TEXT[i++] = xValue.InnerText;
							}
							if ( arrSEARCH_TEXT.Length > 0 )
								sSEARCH_TEXT1 = arrSEARCH_TEXT[0];
							if ( arrSEARCH_TEXT.Length > 1 )
								sSEARCH_TEXT2 = arrSEARCH_TEXT[1];
									
							// 02/24/2015 Paul.  Data field split using dot separator, not space separator.
							string[] arrDATA_FIELD = sDATA_FIELD.Split('.');
							ReportDesign.ReportFilter rdFilter = new ReportDesign.ReportFilter();
							rdFilter.TableName  = arrDATA_FIELD[0];
							rdFilter.ColumnName = arrDATA_FIELD[1];
							rdFilter.Operator   = "=";
								
							rdFilter.Parameter  = false;
							switch ( sOPERATOR )
							{
								case "equals"         :  rdFilter.Operator = "="          ;  rdFilter.Value = sSEARCH_TEXT1;  break;
								case "less"           :  rdFilter.Operator = "<"          ;  rdFilter.Value = sSEARCH_TEXT1;  break;
								case "less_equal"     :  rdFilter.Operator = "<="         ;  rdFilter.Value = sSEARCH_TEXT1;  break;
								case "greater"        :  rdFilter.Operator = ">"          ;  rdFilter.Value = sSEARCH_TEXT1;  break;
								case "greater_equal"  :  rdFilter.Operator = ">="         ;  rdFilter.Value = sSEARCH_TEXT1;  break;
								case "contains"       :  rdFilter.Operator = "like"       ;  rdFilter.Value = "%" + sSEARCH_TEXT1 + "%";  break;
								case "starts_with"    :  rdFilter.Operator = "like"       ;  rdFilter.Value = sSEARCH_TEXT1 + "%";  break;
								case "ends_with"      :  rdFilter.Operator = "like"       ;  rdFilter.Value = "%" + sSEARCH_TEXT1;  break;
								case "not_equals_str" :  rdFilter.Operator = "<>"         ;  rdFilter.Value = sSEARCH_TEXT1;  break;
								case "empty"          :  rdFilter.Operator = "is null"    ;  rdFilter.Value = sSEARCH_TEXT1;  break;
								case "not_empty"      :  rdFilter.Operator = "is not null";  rdFilter.Value = sSEARCH_TEXT1;  break;
								case "not_contains"   :  rdFilter.Operator = "not like"   ;  rdFilter.Value = "%" + sSEARCH_TEXT1 + "%";  break;
								case "not_starts_with":  rdFilter.Operator = "not like"   ;  rdFilter.Value = sSEARCH_TEXT1 + "%";  break;
								case "not_ends_with"  :  rdFilter.Operator = "not like"   ;  rdFilter.Value = "%" + sSEARCH_TEXT1;  break;
								case "like"           :  rdFilter.Operator = "like"       ;  rdFilter.Value = sSEARCH_TEXT1 ;  break;
								case "not_like"       :  rdFilter.Operator = "not like"   ;  rdFilter.Value = sSEARCH_TEXT1 ;  break;
								case "is"             :  rdFilter.Operator = "="          ;  rdFilter.Value = sSEARCH_TEXT1 ;  break;
								case "one_of"         :  rdFilter.Operator = "in"         ;  rdFilter.Value = arrSEARCH_TEXT;  break;
								// 02/24/2015 Paul.  Add support for between filter clause. 
								case "between"        :  rdFilter.Operator = "between"    ;  rdFilter.Value = arrSEARCH_TEXT;  break;
								case "between_dates"  :  rdFilter.Operator = "between"    ;  rdFilter.Value = arrSEARCH_TEXT;  break;
							}
							lstAppliedFilters.Add(rdFilter);
						}
					}
						
					rd.Tables         = lstTables        .ToArray();
					rd.SelectedFields = lstSelectedFields.ToArray();
					rd.Relationships  = lstRelationships .ToArray();
					rd.AppliedFilters = lstAppliedFilters.ToArray();
					sJSON = JsonSerializer.Serialize(rd);
				}
				else
				{
					XmlSerializer x = new XmlSerializer(typeof(ReportDesign));
					using ( TextReader reader = new StringReader(sReportDesign) )
					{
						ReportDesign rd = (ReportDesign) x.Deserialize(reader);
						sJSON = JsonSerializer.Serialize(rd);
					}
				}
			}
			return sJSON;
		}

		/*
		public RdlDocument CreateRdl(string sNAME, string sAUTHOR, string sASSIGNED_USER_ID)
		{
			RdlDocument rdl = LoadRdl(String.Empty);
			rdl.SetCustomProperty("ReportName"    , sNAME            );
			rdl.SetSingleNode    ("Author"        , sAUTHOR          );
			rdl.SetCustomProperty("AssignedUserID", sASSIGNED_USER_ID);
			return rdl;
		}

		public RdlDocument LoadRdl(string sRDL)
		{
			RdlDocument rdl = null;
			rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
			try
			{
				hidDESIGNER_JSON.Value = GetReportDesign(rdl, arrModules, sRDL, L10n, false);
			}
			catch(Exception ex)
			{
				Debug.WriteLine(ex.Message);
			}
			// 05/27/2006 Paul.  This is a catch-all statement to create a new report if all else fails. 
			if ( rdl.DocumentElement == null )
			{
				rdl = new RdlDocument(hostingEnvironment, httpContextAccessor, Session, SplendidCache, XmlUtil, String.Empty, String.Empty, bDesignChart);
				//rdl.SetCustomProperty("Module"        , lstMODULE.SelectedValue  );
				//rdl.SetCustomProperty("Related"       , lstRELATED.SelectedValue );
			}
			// 03/31/2020 Paul.  Separate out GetReportDesign so that it can be called from the React Client. 
			ReportDesign rd = JsonSerializer.Deserialize<ReportDesign>(hidDESIGNER_JSON.Value);
			sReportSQL = BuildReportSQL(Application, L10n, rdl, rd, bPrimaryKeyOnly, bUseSQLParameters, bUserSpecific, ref nSelectedColumns);
			return rdl;
		}
		*/
	}
}
