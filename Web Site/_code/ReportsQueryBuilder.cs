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
using System.Xml;
using System.Data;
using System.Text;
using System.Collections;
using System.Threading;

namespace SplendidCRM
{
	public class QueryBuilder
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private Security             Security           ;
		private XmlUtil              XmlUtil            ;
		private SplendidCRM.Crm.Config           Config           = new SplendidCRM.Crm.Config();

		public QueryBuilder(Security Security, XmlUtil XmlUtil)
		{
			this.Security            = Security           ;
			this.XmlUtil             = XmlUtil            ;
		}

		// 04/17/2007 Paul.  We need to apply ACL rules a little different from the standard.
		// 07/09/2007 Paul.  Fixes from Version 1.2 on 04/17/2007 were not included in Version 1.4 tree.
		// 05/14/2021 Paul.  Convert to static method so that we can use in the React client. 
		private void ACLFilter(HttpApplicationState Application, bool bUseSQLParameters, StringBuilder sbJoin, StringBuilder sbWhere, string sMODULE_NAME, string sACCESS_TYPE, string sASSIGNED_USER_ID_Field, bool bIsCaseSignificantDB)
		{
			// 12/07/2006 Paul.  Not all views use ASSIGNED_USER_ID as the assigned field.  Allow an override. 
			// 11/25/2006 Paul.  Administrators should not be restricted from seeing items because of the team rights.
			// This is so that an administrator can fix any record with a bad team value. 
			// 11/27/2009 Paul.  We need a dynamic way to determine if the module record can be assigned or placed in a team. 
			// Teamed and Assigned flags are automatically determined based on the existence of TEAM_ID and ASSIGNED_USER_ID fields. 
			bool bModuleIsTeamed        = Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Teamed"  ]);
			bool bModuleIsAssigned      = Sql.ToBoolean(Application["Modules." + sMODULE_NAME + ".Assigned"]);
			bool bEnableTeamManagement  = Config.enable_team_management();
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

		// 05/14/2021 Paul.  Convert to static method so that we can use in the React client. 
		public string BuildReportSQL(HttpApplicationState Application, RdlDocument rdl, bool bPrimaryKeyOnly, bool bUseSQLParameters, bool bDesignChart, bool bUserSpecific, string sBASE_MODULE, string sBASE_RELATED, Hashtable hashAvailableModules, StringBuilder sbErrors)
		{
			bool bIsOracle     = false;
			bool bIsDB2        = false;
			bool bIsMySQL      = false;
			bool bIsPostgreSQL = false;
			string sSplendidProvider = Sql.ToString(Application["SplendidProvider"]);
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
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
			
			StringBuilder sb = new StringBuilder();
			StringBuilder sbACLWhere = new StringBuilder();
			if ( rdl.DocumentElement != null )
			{
				string sMODULE_TABLE = Sql.ToString(Application["Modules." + sBASE_MODULE + ".TableName"]);
				int nMaxLen = Math.Max(sMODULE_TABLE.Length, 15);
				Hashtable hashRequiredModules  = new Hashtable();
				// 02/05/2012 Paul.  Prevent duplicate columns. 
				Hashtable hashSelectColumns    = new Hashtable();
				sb.Append("select ");
				
				bool bSelectAll = true;
				// 05/29/2006 Paul.  If the module is used in a filter, then it is required. 
				XmlDocument xmlDisplayColumns = rdl.GetCustomProperty("DisplayColumns");
				XmlNodeList nlFields = xmlDisplayColumns.DocumentElement.SelectNodes("DisplayColumn/Field");
				foreach ( XmlNode xField in nlFields )
					nMaxLen = Math.Max(nMaxLen, xField.InnerText.Length);
				
				// 01/10/2010 Paul.  The ProspectList Dynamic SQL must only return an ID. 
				if ( bPrimaryKeyOnly && !bUseSQLParameters )
				{
					sb.AppendLine(sMODULE_TABLE + ".ID");
				}
				else
				{
					string sFieldSeparator = "";
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						foreach ( XmlNode xField in nlFields )
						{
							bSelectAll = false;
							string sMODULE_ALIAS = xField.InnerText.Split('.')[0];
							if ( !hashRequiredModules.ContainsKey(sMODULE_ALIAS) )
							{
								hashRequiredModules.Add(sMODULE_ALIAS, null);
								// 02/05/2012 Paul.  Don't add the ID if this is a chart. 
								if ( !bDesignChart )
								{
									// 01/18/2012 Paul.  When a new module is encountered, take this opportunity to add a reference to the ID. 
									// 01/18/2012 Paul.  ReportViewer is not able to convert a Guid to a text string, so do it manually. 
									if ( Sql.IsSQLServer(con) || Sql.IsSybase(con) || Sql.IsSqlAnywhere(con) || Sql.IsEffiProz(con) )
									{
										string sIDField = "cast(" + sMODULE_ALIAS + ".ID as char(36))";
										sb.Append(sFieldSeparator + sIDField);
										if ( nMaxLen - sIDField.Length > 0 )
											sb.Append(Strings.Space(nMaxLen - sIDField.Length));
									}
									else
									{
										sb.Append(sFieldSeparator + sMODULE_ALIAS + ".ID");
										sb.Append(Strings.Space(nMaxLen - (sMODULE_ALIAS + ".ID").Length));
									}
									sb.Append(" as \"" + Sql.MetadataName(con, sMODULE_ALIAS + ".ID") + "\"");
									sb.AppendLine();
									sFieldSeparator = "     , ";
								}
							}
							// 02/05/2012 Paul.  Prevent duplicate columns. 
							if ( !hashSelectColumns.ContainsKey(xField.InnerText) )
							{
								sb.Append(sFieldSeparator + xField.InnerText);
								sb.Append(Strings.Space(nMaxLen - xField.InnerText.Length));
								// 03/08/2011 Paul.  We need to make sure not to exceed 30 characters in the alias name. 
								sb.Append(" as \"" + Sql.MetadataName(con, xField.InnerText) + "\"");
								sb.AppendLine();
								sFieldSeparator = "     , ";
								hashSelectColumns.Add(xField.InnerText, null);
							}
						}
						if ( bSelectAll )
						{
							sb.AppendLine("*");
						}
					}
				}
				
				// 05/29/2006 Paul.  If the module is used in a filter, then it is required. 
				XmlDocument xmlFilters = rdl.GetCustomProperty("Filters");
				XmlNodeList nlFilters = xmlFilters.DocumentElement.SelectNodes("Filter");
				foreach ( XmlNode xFilter in nlFilters )
				{
					string sDATA_FIELD = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD");
					string sMODULE_ALIAS = sDATA_FIELD.Split('.')[0];
					if ( !hashRequiredModules.ContainsKey(sMODULE_ALIAS) )
						hashRequiredModules.Add(sMODULE_ALIAS, null);
				}

				if ( hashRequiredModules.ContainsKey(sMODULE_TABLE) )
					hashRequiredModules.Remove(sMODULE_TABLE);
				
				sb.AppendLine("  from            vw" + sMODULE_TABLE + " " + Strings.Space(nMaxLen - sMODULE_TABLE.Length) + sMODULE_TABLE);
				// 01/10/2010 Paul.  The Compaigns module will not need user-specific filtering. 
				if ( bUserSpecific || bUseSQLParameters )
				{
					// 04/17/2007 Paul.  Apply ACL rules. 
					if ( sMODULE_TABLE != "USERS" )
						ACLFilter(Application, bUseSQLParameters, sb, sbACLWhere, sMODULE_TABLE, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2);
				}
				hashAvailableModules.Add(sMODULE_TABLE, sMODULE_TABLE);
				if ( !Sql.IsEmptyString(sBASE_RELATED) )
				{
					XmlDocument xmlRelatedModules = rdl.GetCustomProperty("RelatedModules");
					string sRELATED           = sBASE_RELATED.Split(' ')[0];
					string sRELATED_ALIAS     = sBASE_RELATED.Split(' ')[1];
					// 10/26/2011 Paul.  Add the relationship so that we can have a unique lookup. 
					string sRELATIONSHIP_NAME = sBASE_RELATED.Split(' ')[2];
					
					if ( hashRequiredModules.ContainsKey(sRELATED_ALIAS) )
						hashRequiredModules.Remove(sRELATED_ALIAS);

					// 10/26/2011 Paul.  Add the relationship so that we can have a unique lookup. 
					XmlNode xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RELATIONSHIP_NAME=\'" + sRELATIONSHIP_NAME + "\']");
					if ( xRelationship != null )
					{
						sRELATIONSHIP_NAME                     = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_NAME"             );
						//string sLHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "LHS_MODULE"                    );
						string sLHS_TABLE                      = XmlUtil.SelectSingleNode(xRelationship, "LHS_TABLE"                     );
						string sLHS_KEY                        = XmlUtil.SelectSingleNode(xRelationship, "LHS_KEY"                       );
						//string sRHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "RHS_MODULE"                    );
						string sRHS_TABLE                      = XmlUtil.SelectSingleNode(xRelationship, "RHS_TABLE"                     );
						string sRHS_KEY                        = XmlUtil.SelectSingleNode(xRelationship, "RHS_KEY"                       );
						string sJOIN_TABLE                     = XmlUtil.SelectSingleNode(xRelationship, "JOIN_TABLE"                    );
						string sJOIN_KEY_LHS                   = XmlUtil.SelectSingleNode(xRelationship, "JOIN_KEY_LHS"                  );
						string sJOIN_KEY_RHS                   = XmlUtil.SelectSingleNode(xRelationship, "JOIN_KEY_RHS"                  );
						// 11/20/2008 Paul.  Quotes, Orders and Invoices have a relationship column. 
						string sRELATIONSHIP_ROLE_COLUMN       = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_ROLE_COLUMN"      );
						string sRELATIONSHIP_ROLE_COLUMN_VALUE = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_ROLE_COLUMN_VALUE");
						if ( Sql.IsEmptyString(sJOIN_TABLE) )
						{
							nMaxLen = Math.Max(nMaxLen, sRHS_TABLE.Length + sRHS_KEY.Length + 1);
							sb.AppendLine("       inner join vw" + sRHS_TABLE + " "            + Strings.Space(nMaxLen - sRHS_TABLE.Length                      ) + sRHS_TABLE);
							sb.AppendLine("               on "   + sRHS_TABLE + "." + sRHS_KEY + Strings.Space(nMaxLen - sRHS_TABLE.Length - sRHS_KEY.Length - 1) + " = " + sLHS_TABLE + "." + sLHS_KEY);
							// 05/05/2010 Paul.  The Compaigns module will not need user-specific filtering. 
							if ( bUserSpecific || bUseSQLParameters )
							{
								// 04/17/2007 Paul.  Apply ACL rules. 
								if ( sRHS_TABLE != "USERS" )
									ACLFilter(Application, bUseSQLParameters, sb, sbACLWhere, sRHS_TABLE, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2);
							}
						}
						else
						{
							nMaxLen = Math.Max(nMaxLen, sJOIN_TABLE.Length + sJOIN_KEY_LHS.Length + 1);
							nMaxLen = Math.Max(nMaxLen, sRHS_TABLE.Length + sRHS_KEY.Length      + 1);
							sb.AppendLine("       inner join vw" + sJOIN_TABLE + " "                 + Strings.Space(nMaxLen - sJOIN_TABLE.Length                           ) + sJOIN_TABLE);
							sb.AppendLine("               on "   + sJOIN_TABLE + "." + sJOIN_KEY_LHS + Strings.Space(nMaxLen - sJOIN_TABLE.Length - sJOIN_KEY_LHS.Length - 1) + " = " + sLHS_TABLE  + "." + sLHS_KEY     );
							// 10/31/2009 Paul.  The value should be escaped. 
							if ( !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN) && !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN_VALUE) )
								sb.AppendLine("              and "   + sJOIN_TABLE + "." + sRELATIONSHIP_ROLE_COLUMN + " = N'" + Sql.EscapeSQL(sRELATIONSHIP_ROLE_COLUMN_VALUE) + "'");
							sb.AppendLine("       inner join vw" + sRHS_TABLE + " "                  + Strings.Space(nMaxLen - sRHS_TABLE.Length                            ) + sRHS_TABLE);
							sb.AppendLine("               on "   + sRHS_TABLE + "." + sRHS_KEY       + Strings.Space(nMaxLen - sRHS_TABLE.Length - sRHS_KEY.Length - 1      ) + " = " + sJOIN_TABLE + "." + sJOIN_KEY_RHS);
							// 05/05/2010 Paul.  The Compaigns module will not need user-specific filtering. 
							if ( bUserSpecific || bUseSQLParameters )
							{
								// 04/17/2007 Paul.  Apply ACL rules. 
								if ( sRHS_TABLE != "USERS" )
									ACLFilter(Application, bUseSQLParameters, sb, sbACLWhere, sRHS_TABLE, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2);
							}
						}
						if ( !hashAvailableModules.ContainsKey(sRHS_TABLE) )
							hashAvailableModules.Add(sRHS_TABLE, sRHS_TABLE);
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
							//string sLHS_MODULE        = XmlUtil.SelectSingleNode(xRelationship, "LHS_MODULE"       );
							string sLHS_TABLE         = XmlUtil.SelectSingleNode(xRelationship, "LHS_TABLE"        );
							string sLHS_KEY           = XmlUtil.SelectSingleNode(xRelationship, "LHS_KEY"          );
							//string sRHS_MODULE        = XmlUtil.SelectSingleNode(xRelationship, "RHS_MODULE"       );
							string sRHS_TABLE         = XmlUtil.SelectSingleNode(xRelationship, "RHS_TABLE"        );
							string sRHS_KEY           = XmlUtil.SelectSingleNode(xRelationship, "RHS_KEY"          );
							nMaxLen = Math.Max(nMaxLen, sLHS_TABLE.Length );
							nMaxLen = Math.Max(nMaxLen, sMODULE_ALIAS.Length + sLHS_KEY.Length + 1);
							sb.AppendLine("  left outer join vw" + sLHS_TABLE + " "               + Strings.Space(nMaxLen - sLHS_TABLE.Length                        ) + sMODULE_ALIAS);
							sb.AppendLine("               on "   + sMODULE_ALIAS + "." + sLHS_KEY + Strings.Space(nMaxLen - sMODULE_ALIAS.Length - sLHS_KEY.Length - 1) + " = " + sRHS_TABLE + "." + sRHS_KEY);
							// 05/05/2010 Paul.  The Compaigns module will not need user-specific filtering. 
							if ( bUserSpecific || bUseSQLParameters )
							{
								// 04/17/2007 Paul.  Apply ACL rules. 
								if ( sLHS_TABLE != "USERS" )
									ACLFilter(Application, bUseSQLParameters, sb, sbACLWhere, sMODULE_ALIAS, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2);
							}
							// 07/13/2006 Paul.  The key needs to be the alias, and the value is the main table. 
							// This is because the same table may be referenced more than once, 
							// such as the Users table to display the last modified user and the assigned to user. 
							if ( !hashAvailableModules.ContainsKey(sMODULE_ALIAS) )
								hashAvailableModules.Add(sMODULE_ALIAS, sLHS_TABLE);
						}
					}
				}
				sb.AppendLine(" where 1 = 1");
				sb.Append(sbACLWhere.ToString());
				try
				{
					rdl.SetSingleNode("DataSets/DataSet/Query/QueryParameters", String.Empty);
					XmlNode xQueryParameters = rdl.SelectNode("DataSets/DataSet/Query/QueryParameters");
					xQueryParameters.RemoveAll();
					if ( xmlFilters.DocumentElement != null )
					{
						int nParameterIndex = 0;
						// 10/25/2014 Paul.  Filters that use NOT should protect against NULL values. 
						// 10/25/2014 Paul.  Coalesce works across all database platforms, so use instead of isnull. 
						string sISNULL = "coalesce";
						//if ( bIsOracle )
						//	sISNULL = "nvl";
						//else if ( bIsMySQL || bIsDB2 )
						//	sISNULL = "ifnull";
						//else if ( bIsPostgreSQL )
						//	sISNULL = "coalesce";
						foreach ( XmlNode xFilter in xmlFilters.DocumentElement )
						{
							string sMODULE_NAME    = XmlUtil.SelectSingleNode(xFilter, "MODULE_NAME");
							string sDATA_FIELD     = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD" );
							string sDATA_TYPE      = XmlUtil.SelectSingleNode(xFilter, "DATA_TYPE"  );
							string sOPERATOR       = XmlUtil.SelectSingleNode(xFilter, "OPERATOR"   );
							// 07/04/2006 Paul.  We need to use the parameter index in the parameter name 
							// because a parameter can be used more than once and we need a unique name. 
							string sPARAMETER_NAME = RdlDocument.RdlParameterName(sDATA_FIELD, nParameterIndex, false);
							string sSECONDARY_NAME = RdlDocument.RdlParameterName(sDATA_FIELD, nParameterIndex, true );
							string sSEARCH_TEXT1   = String.Empty;
							string sSEARCH_TEXT2   = String.Empty;
							// 03/14/2011 Paul.  Oracle does not like parameter names longer than 30 characters. 
							if ( bIsOracle && (sPARAMETER_NAME.Length > 30 || sSECONDARY_NAME.Length > 30) )
							{
								sPARAMETER_NAME = "@PARAMETER__" + nParameterIndex.ToString("00") + "A";
								sSECONDARY_NAME = "@PARAMETER__" + nParameterIndex.ToString("00") + "B";
							}
							
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

							string sSQL = string.Empty;
							// 07/09/2007 Paul.  ansistring is treated the same as string. 
							string sCOMMON_DATA_TYPE = sDATA_TYPE;
							if ( sCOMMON_DATA_TYPE == "ansistring" )
								sCOMMON_DATA_TYPE = "string";
							switch ( sCOMMON_DATA_TYPE )
							{
								case "string":
								{
									// 07/16/2006 Paul.  Oracle and DB2 are case-significant.  Keep SQL Server code fast by not converting to uppercase. 
									if ( bIsOracle || bIsDB2 )
									{
										sSEARCH_TEXT1 = sSEARCH_TEXT1.ToUpper();
										sSEARCH_TEXT2 = sSEARCH_TEXT2.ToUpper();
										sDATA_FIELD   = "upper(" + sDATA_FIELD + ")";
									}
									// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
									// 07/23/2013 Paul.  Allow leading equals to indicate direct SQL statement, but limit to column name for now. 
									if ( sSEARCH_TEXT1.StartsWith("=") )
									{
										// 07/23/2013 Paul.  Use RdlUtil.ReportColumnName() to restrict the SQL to a column name. 
										var sCAT_SEP = (bIsOracle ? " || " : " + ");
										sSEARCH_TEXT1 = RdlUtil.ReportColumnName(sSEARCH_TEXT1.Substring(1));
										switch ( sOPERATOR )
										{
											case "equals"         :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "less"           :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sSEARCH_TEXT1);  break;
											case "less_equal"     :  sb.AppendLine("   and " + sDATA_FIELD + " <= "   + sSEARCH_TEXT1);  break;
											case "greater"        :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sSEARCH_TEXT1);  break;
											case "greater_equal"  :  sb.AppendLine("   and " + sDATA_FIELD + " >= "   + sSEARCH_TEXT1);  break;
											case "contains"       :  sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
											case "starts_with"    :  sb.AppendLine("   and " + sDATA_FIELD + " like " +                     sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
											case "ends_with"      :  sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1);  break;
											case "like"           :  sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
											case "empty"          :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"      :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 10/25/2014 Paul.  Filters that use NOT should protect against NULL values. 
											case "not_equals_str" :  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " <> "   + sSEARCH_TEXT1);  break;
											case "not_contains"   :  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
											case "not_starts_with":  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " +                     sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
											case "not_ends_with"  :  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1);  break;
											case "not_like"       :  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
										}
									}
									else if ( bUseSQLParameters )
									{
										switch ( sOPERATOR )
										{
											case "equals"        :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											// 07/23/2013 Paul.  Add greater and less than conditions. 
											case "less"          :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "less_equal"    :  sb.AppendLine("   and " + sDATA_FIELD + " <= "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "greater"       :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "greater_equal" :  sb.AppendLine("   and " + sDATA_FIELD + " >= "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "contains"      :  sb.AppendLine("   and " + sDATA_FIELD + " like " + sPARAMETER_NAME + (bIsMySQL || bIsPostgreSQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 09/02/2008 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											case "starts_with"   :  sb.AppendLine("   and " + sDATA_FIELD + " like " + sPARAMETER_NAME + (bIsMySQL || bIsPostgreSQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL =       Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 09/02/2008 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											case "ends_with"     :  sb.AppendLine("   and " + sDATA_FIELD + " like " + sPARAMETER_NAME + (bIsMySQL || bIsPostgreSQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1)      ;
												// 09/02/2008 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											// 02/14/2013 Paul.  A customer wants to use like in string filters. 
											case "like"          :  sb.AppendLine("   and " + sDATA_FIELD + " like " + sPARAMETER_NAME + (bIsMySQL || bIsPostgreSQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL = sSEARCH_TEXT1;
												// 09/02/2008 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											case "empty"         :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 08/25/2011 Paul.  A customer wants more use of NOT in string filters. 
												// 10/25/2014 Paul.  Filters that use NOT should protect against NULL values. 
											case "not_equals_str"    :  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " <> "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "not_contains"      :  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + sPARAMETER_NAME + (bIsMySQL || bIsPostgreSQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 09/02/2008 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											case "not_starts_with"   :  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + sPARAMETER_NAME + (bIsMySQL || bIsPostgreSQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL =       Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 09/02/2008 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											case "not_ends_with"     :  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + sPARAMETER_NAME + (bIsMySQL || bIsPostgreSQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1)      ;
												// 09/02/2008 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											case "not_like"          :  sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + sPARAMETER_NAME + (bIsMySQL || bIsPostgreSQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL = sSEARCH_TEXT1;
												// 09/02/2008 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
										}
									}
									else
									{
										switch ( sOPERATOR )
										{
											case "equals"        :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + "N'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											// 07/23/2013 Paul.  Add greater and less than conditions. 
											case "less"          :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + "N'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "less_equal"    :  sb.AppendLine("   and " + sDATA_FIELD + " <= "   + "N'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "greater"       :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + "N'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "greater_equal" :  sb.AppendLine("   and " + sDATA_FIELD + " >= "   + "N'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "contains"      :
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "starts_with"   :
												sSQL =       Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "ends_with"     :
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1)      ;
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											// 02/14/2013 Paul.  A customer wants to use like in string filters. 
											case "like"          :
												sSQL = sSEARCH_TEXT1;
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "empty"         :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											case "not_equals_str":
												sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " <> "   + "N'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");
												break;
											// 08/25/2011 Paul.  A customer wants more use of NOT in string filters. 
											case "not_contains"      :
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "not_starts_with"   :
												sSQL =       Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "not_ends_with"     :
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1)      ;
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "not_like"      :
												sSQL = sSEARCH_TEXT1;
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " not like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
										}
									}
									break;
								}
								case "datetime":
								{
									string fnPrefix = "dbo.";
									if ( bIsOracle || bIsDB2 || bIsMySQL || bIsPostgreSQL )
									{
										fnPrefix = "";
									}
									// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
									// 07/23/2013 Paul.  Allow leading equals to indicate direct SQL statement, but limit to column name for now. 
									if ( sSEARCH_TEXT1.StartsWith("=") )
									{
										// 07/23/2013 Paul.  Use RdlUtil.ReportColumnName() to restrict the SQL to a column name. 
										var sCAT_SEP = (bIsOracle ? " || " : " + ");
										sSEARCH_TEXT1 = RdlUtil.ReportColumnName(sSEARCH_TEXT1.Substring(1));
										if ( sSEARCH_TEXT2.StartsWith("=") )
											sSEARCH_TEXT2 = RdlUtil.ReportColumnName(sSEARCH_TEXT2.Substring(1));
										switch ( sOPERATOR )
										{
											case "on"               :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") = "  + sSEARCH_TEXT1);  break;
											case "before"           :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") < "  + sSEARCH_TEXT1);  break;
											case "after"            :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") > "  + sSEARCH_TEXT1);  break;
											case "not_equals_str"   :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") <> " + sSEARCH_TEXT1);  break;
											case "between_dates"    :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + sSEARCH_TEXT1 + " and " + sSEARCH_TEXT2);  break;
											case "tp_days_after"    :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('day', "    +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
											case "tp_weeks_after"   :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('week', "   +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
											case "tp_months_after"  :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('month', "  +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
											case "tp_years_after"   :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('year', "   +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
											case "tp_days_before"   :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('day', "    + "-" + sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  break;
											case "tp_weeks_before"  :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('week', "   + "-" + sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  break;
											case "tp_months_before" :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('month', "  + "-" + sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  break;
											case "tp_years_before"  :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('year', "   + "-" + sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  break;
											case "tp_minutes_after" :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('minute', " +       sSEARCH_TEXT1        + ", " + sDATA_FIELD                             + ") and " + fnPrefix + "fnDateAdd('minute', " + "1+" + sSEARCH_TEXT1 + ", " + sDATA_FIELD + ")");  break;
											case "tp_hours_after"   :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('hour', "   +       sSEARCH_TEXT1        + ", " + sDATA_FIELD                             + ") and " + fnPrefix + "fnDateAdd('hour', "   + "1+" + sSEARCH_TEXT1 + ", " + sDATA_FIELD + ")");  break;
											case "tp_minutes_before":  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('minute', " + "-" + sSEARCH_TEXT1 + "-1" + ", " + sDATA_FIELD                             + ") and " + fnPrefix + "fnDateAdd('minute', " + "-"  + sSEARCH_TEXT1 + ", " + sDATA_FIELD + ")");  break;
											case "tp_hours_before"  :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('hour', "   + "-" + sSEARCH_TEXT1 + "-1" + ", " + sDATA_FIELD                             + ") and " + fnPrefix + "fnDateAdd('hour', "   + "-"  + sSEARCH_TEXT1 + ", " + sDATA_FIELD + ")");  break;
											case "tp_days_old"      :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('day', "    +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
											case "tp_weeks_old"     :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('week', "   +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
											case "tp_months_old"    :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('month', "  +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
											case "tp_years_old"     :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('year', "   +       sSEARCH_TEXT1        + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
										}
									}
									else if ( bUseSQLParameters )
									{
										if ( arrSEARCH_TEXT.Length > 0 )
										{
											//CalendarControl.SqlDateTimeFormat, ciEnglish.DateTimeFormat
											DateTime dtSEARCH_TEXT1 = DateTime.MinValue;
											DateTime dtSEARCH_TEXT2 = DateTime.MinValue;
											int nINTERVAL = 0;
											// 11/16/2008 Paul.  Days old. 
											if ( !(sOPERATOR.EndsWith("_after") || sOPERATOR.EndsWith("_before") || sOPERATOR.EndsWith("_old")) )
											{
												dtSEARCH_TEXT1 = DateTime.ParseExact(sSEARCH_TEXT1, "yyyy/MM/dd", Thread.CurrentThread.CurrentCulture.DateTimeFormat);
												dtSEARCH_TEXT2 = DateTime.MinValue;
												if ( arrSEARCH_TEXT.Length > 1 )
													dtSEARCH_TEXT2 = DateTime.ParseExact(sSEARCH_TEXT2, "yyyy/MM/dd", Thread.CurrentThread.CurrentCulture.DateTimeFormat);
											}
											else
											{
												nINTERVAL = Sql.ToInteger(sSEARCH_TEXT1);
											}
											switch ( sOPERATOR )
											{
												case "on"               :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") = "  + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSEARCH_TEXT1);  break;
												case "before"           :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") < "  + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSEARCH_TEXT1);  break;
												case "after"            :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") > "  + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSEARCH_TEXT1);  break;
												case "not_equals_str"   :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") <> " + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSEARCH_TEXT1);  break;
												case "between_dates"    :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + sPARAMETER_NAME + " and " + sSECONDARY_NAME);
													rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, dtSEARCH_TEXT1.ToShortDateString());
													rdl.AddQueryParameter(xQueryParameters, sSECONDARY_NAME, sDATA_TYPE, dtSEARCH_TEXT2.ToShortDateString());
													break;
												// 11/16/2008 Paul.  Days old. 
												case "tp_days_after"    :  sb.AppendLine("   and " + sPARAMETER_NAME + " > "       + fnPrefix + "fnDateAdd('day', "    +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_weeks_after"   :  sb.AppendLine("   and " + sPARAMETER_NAME + " > "       + fnPrefix + "fnDateAdd('week', "   +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_months_after"  :  sb.AppendLine("   and " + sPARAMETER_NAME + " > "       + fnPrefix + "fnDateAdd('month', "  +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_years_after"   :  sb.AppendLine("   and " + sPARAMETER_NAME + " > "       + fnPrefix + "fnDateAdd('year', "   +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_days_before"   :  sb.AppendLine("   and " + sPARAMETER_NAME + " between " + fnPrefix + "fnDateAdd('day', "    + (-nINTERVAL)  .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_weeks_before"  :  sb.AppendLine("   and " + sPARAMETER_NAME + " between " + fnPrefix + "fnDateAdd('week', "   + (-nINTERVAL)  .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_months_before" :  sb.AppendLine("   and " + sPARAMETER_NAME + " between " + fnPrefix + "fnDateAdd('month', "  + (-nINTERVAL)  .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_years_before"  :  sb.AppendLine("   and " + sPARAMETER_NAME + " between " + fnPrefix + "fnDateAdd('year', "   + (-nINTERVAL)  .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_minutes_after" :  sb.AppendLine("   and " + sPARAMETER_NAME + " between " + fnPrefix + "fnDateAdd('minute', " +   nINTERVAL   .ToString() + ", " + sDATA_FIELD + "                            ) and " + fnPrefix + "fnDateAdd('minute', " + (1+nINTERVAL).ToString() + ", " + sDATA_FIELD + ")");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "GETDATE()");  break;
												case "tp_hours_after"   :  sb.AppendLine("   and " + sPARAMETER_NAME + " between " + fnPrefix + "fnDateAdd('hour', "   +   nINTERVAL   .ToString() + ", " + sDATA_FIELD + "                            ) and " + fnPrefix + "fnDateAdd('hour', "   + (1+nINTERVAL).ToString() + ", " + sDATA_FIELD + ")");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "GETDATE()");  break;
												case "tp_minutes_before":  sb.AppendLine("   and " + sPARAMETER_NAME + " between " + fnPrefix + "fnDateAdd('minute', " + (-nINTERVAL-1).ToString() + ", " + sDATA_FIELD + "                            ) and " + fnPrefix + "fnDateAdd('minute', " +  (-nINTERVAL).ToString() + ", " + sDATA_FIELD + ")");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "GETDATE()");  break;
												case "tp_hours_before"  :  sb.AppendLine("   and " + sPARAMETER_NAME + " between " + fnPrefix + "fnDateAdd('hour', "   + (-nINTERVAL-1).ToString() + ", " + sDATA_FIELD + "                            ) and " + fnPrefix + "fnDateAdd('hour', "   +  (-nINTERVAL).ToString() + ", " + sDATA_FIELD + ")");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "GETDATE()");  break;
												// 12/04/2008 Paul.  We need to be able to do an an equals. 
												case "tp_days_old"      :  sb.AppendLine("   and " + sPARAMETER_NAME + " = "       + fnPrefix + "fnDateAdd('day', "    +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_weeks_old"     :  sb.AppendLine("   and " + sPARAMETER_NAME + " = "       + fnPrefix + "fnDateAdd('week', "   +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_months_old"    :  sb.AppendLine("   and " + sPARAMETER_NAME + " = "       + fnPrefix + "fnDateAdd('month', "  +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_years_old"     :  sb.AppendLine("   and " + sPARAMETER_NAME + " = "       + fnPrefix + "fnDateAdd('year', "   +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
											}
										}
										else
										{
											switch ( sOPERATOR )
											{
												case "empty"          :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
												case "not_empty"      :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
												case "is_before"      :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") < " + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "is_after"       :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") > " + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_yesterday"   :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") = " + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "DATEADD(DAY, -1, TODAY())");  break;
												case "tp_today"       :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") = " + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");  break;
												case "tp_tomorrow"    :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") = " + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "DATEADD(DAY, 1, TODAY())");  break;
												case "tp_last_7_days" :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + sPARAMETER_NAME + " and " + sSECONDARY_NAME);
													rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "DATEADD(DAY, -7, TODAY())");
													rdl.AddQueryParameter(xQueryParameters, sSECONDARY_NAME, sDATA_TYPE, "TODAY()");
													break;
												case "tp_next_7_days" :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + sPARAMETER_NAME + " and " + sSECONDARY_NAME);
													rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");
													rdl.AddQueryParameter(xQueryParameters, sSECONDARY_NAME, sDATA_TYPE, "DATEADD(DAY, 7, TODAY())");
													break;
												// 07/05/2006 Paul.  Month math must also include the year. 
												case "tp_last_month"  :  sb.AppendLine("   and month(" + sDATA_FIELD + ") = " + sPARAMETER_NAME);
													                     sb.AppendLine("   and year("  + sDATA_FIELD + ") = " + sSECONDARY_NAME);
													rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "MONTH(DATEADD(MONTH, -1, TODAY()))");
													rdl.AddQueryParameter(xQueryParameters, sSECONDARY_NAME, sDATA_TYPE, "YEAR(DATEADD(MONTH, -1, TODAY()))");
													break;
												case "tp_this_month"  :  sb.AppendLine("   and month(" + sDATA_FIELD + ") = " + sPARAMETER_NAME);
													                     sb.AppendLine("   and year("  + sDATA_FIELD + ") = " + sSECONDARY_NAME);
													rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "MONTH(TODAY())");
													rdl.AddQueryParameter(xQueryParameters, sSECONDARY_NAME, sDATA_TYPE, "YEAR(TODAY())");
													break;
												case "tp_next_month"  :  sb.AppendLine("   and month(" + sDATA_FIELD + ") = " + sPARAMETER_NAME);
													                     sb.AppendLine("   and year("  + sDATA_FIELD + ") = " + sSECONDARY_NAME);
													rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "MONTH(DATEADD(MONTH, 1, TODAY()))");
													rdl.AddQueryParameter(xQueryParameters, sSECONDARY_NAME, sDATA_TYPE, "YEAR(DATEADD(MONTH, 1, TODAY()))");
													break;
												case "tp_last_30_days":  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + sPARAMETER_NAME + " and " + sSECONDARY_NAME);
													rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "DATEADD(DAY, -30, TODAY())");
													rdl.AddQueryParameter(xQueryParameters, sSECONDARY_NAME, sDATA_TYPE, "TODAY()");
													break;
												case "tp_next_30_days":  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + sPARAMETER_NAME + " and " + sSECONDARY_NAME);
													rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "TODAY()");
													rdl.AddQueryParameter(xQueryParameters, sSECONDARY_NAME, sDATA_TYPE, "DATEADD(DAY, 30, TODAY())");
													break;
												case "tp_last_year"   :  sb.AppendLine("   and year(" + sDATA_FIELD + ") = " + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "YEAR(DATEADD(YEAR, -1, TODAY()))");  break;
												case "tp_this_year"   :  sb.AppendLine("   and year(" + sDATA_FIELD + ") = " + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "YEAR(TODAY())");  break;
												case "tp_next_year"   :  sb.AppendLine("   and year(" + sDATA_FIELD + ") = " + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, "YEAR(DATEADD(YEAR, 1, TODAY()))");  break;
											}
										}
									}
									else
									{
										if ( arrSEARCH_TEXT.Length > 0 )
										{
											//CalendarControl.SqlDateTimeFormat, ciEnglish.DateTimeFormat
											DateTime dtSEARCH_TEXT1 = DateTime.MinValue;
											DateTime dtSEARCH_TEXT2 = DateTime.MinValue;
											int nINTERVAL = 0;
											// 11/16/2008 Paul.  Days old. 
											if ( !(sOPERATOR.EndsWith("_after") || sOPERATOR.EndsWith("_before") || sOPERATOR.EndsWith("_old")) )
											{
												dtSEARCH_TEXT1 = DateTime.ParseExact(sSEARCH_TEXT1, "yyyy/MM/dd", Thread.CurrentThread.CurrentCulture.DateTimeFormat);
												dtSEARCH_TEXT2 = DateTime.MinValue;
												if ( arrSEARCH_TEXT.Length > 1 )
												{
													dtSEARCH_TEXT2 = DateTime.ParseExact(sSEARCH_TEXT2, "yyyy/MM/dd", Thread.CurrentThread.CurrentCulture.DateTimeFormat);
													if ( bIsOracle )
														sSEARCH_TEXT2 = "to_date('" + dtSEARCH_TEXT2.ToString("yyyy-MM-dd") + "','YYYY-MM-DD')";
													else
														sSEARCH_TEXT2 = "'" + dtSEARCH_TEXT2.ToString("yyyy/MM/dd") + "'";
												}
												if ( bIsOracle )
													sSEARCH_TEXT1 = "to_date('" + dtSEARCH_TEXT1.ToString("yyyy-MM-dd") + "','YYYY-MM-DD')";
												else
													sSEARCH_TEXT1 = "'" + dtSEARCH_TEXT1.ToString("yyyy/MM/dd") + "'";
											}
											else
											{
												nINTERVAL = Sql.ToInteger(sSEARCH_TEXT1);
											}
											switch ( sOPERATOR )
											{
												case "on"               :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") = "  + sSEARCH_TEXT1);  break;
												case "before"           :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") < "  + sSEARCH_TEXT1);  break;
												case "after"            :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") > "  + sSEARCH_TEXT1);  break;
												case "not_equals_str"   :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") <> " + sSEARCH_TEXT1);  break;
												case "between_dates"    :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + sSEARCH_TEXT1 + " and " + sSEARCH_TEXT2);  break;
												// 11/16/2008 Paul.  Days old. 
												case "tp_days_after"    :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('day', "    +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
												case "tp_weeks_after"   :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('week', "   +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
												case "tp_months_after"  :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('month', "  +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
												case "tp_years_after"   :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " > "       + fnPrefix + "fnDateAdd('year', "   +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
												case "tp_days_before"   :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('day', "    + (-nINTERVAL)  .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  break;
												case "tp_weeks_before"  :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('week', "   + (-nINTERVAL)  .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  break;
												case "tp_months_before" :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('month', "  + (-nINTERVAL)  .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  break;
												case "tp_years_before"  :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " between " + fnPrefix + "fnDateAdd('year', "   + (-nINTERVAL)  .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")) and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ")");  break;
												case "tp_minutes_after" :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('minute', " +   nINTERVAL   .ToString() + ", " + sDATA_FIELD                             + ") and " + fnPrefix + "fnDateAdd('minute', " + (1+nINTERVAL).ToString() + ", " + sDATA_FIELD + ")");  break;
												case "tp_hours_after"   :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('hour', "   +   nINTERVAL   .ToString() + ", " + sDATA_FIELD                             + ") and " + fnPrefix + "fnDateAdd('hour', "   + (1+nINTERVAL).ToString() + ", " + sDATA_FIELD + ")");  break;
												case "tp_minutes_before":  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('minute', " + (-nINTERVAL-1).ToString() + ", " + sDATA_FIELD                             + ") and " + fnPrefix + "fnDateAdd('minute', " +  (-nINTERVAL).ToString() + ", " + sDATA_FIELD + ")");  break;
												case "tp_hours_before"  :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " between " + fnPrefix + "fnDateAdd('hour', "   + (-nINTERVAL-1).ToString() + ", " + sDATA_FIELD                             + ") and " + fnPrefix + "fnDateAdd('hour', "   +  (-nINTERVAL).ToString() + ", " + sDATA_FIELD + ")");  break;
												// 12/04/2008 Paul.  We need to be able to do an an equals. 
												case "tp_days_old"      :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('day', "    +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
												case "tp_weeks_old"     :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('week', "   +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
												case "tp_months_old"    :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('month', "  +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
												case "tp_years_old"     :  sb.AppendLine("   and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"  ) + " = "       + fnPrefix + "fnDateAdd('year', "   +   nINTERVAL   .ToString() + ", " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + "))");  break;
											}
										}
										else
										{
											switch ( sOPERATOR )
											{
												case "empty"            :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
												case "not_empty"        :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
												case "is_before"        :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") < " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"                  ));  break;
												case "is_after"         :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") > " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"                  ));  break;
												case "tp_yesterday"     :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "DATEADD(DAY, -1, TODAY())"));  break;
												case "tp_today"         :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"                  ));  break;
												case "tp_tomorrow"      :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "DATEADD(DAY, 1, TODAY())" ));  break;
												case "tp_last_7_days"   :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + RdlDocument.DbSpecificDate(sSplendidProvider, "DATEADD(DAY, -7, TODAY())") + " and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"));
													break;
												case "tp_next_7_days"   :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()" ) + " and " + RdlDocument.DbSpecificDate(sSplendidProvider, "DATEADD(DAY, 7, TODAY())"));
													break;
												// 07/05/2006 Paul.  Month math must also include the year. 
												case "tp_last_month"    :  sb.AppendLine("   and month(" + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "MONTH(DATEADD(MONTH, -1, TODAY()))"));
													                       sb.AppendLine("   and year("  + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "YEAR(DATEADD(MONTH, -1, TODAY()))" ));
													break;
												case "tp_this_month"    :  sb.AppendLine("   and month(" + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "MONTH(TODAY())"));
													                       sb.AppendLine("   and year("  + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "YEAR(TODAY())" ));
													break;
												case "tp_next_month"    :  sb.AppendLine("   and month(" + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "MONTH(DATEADD(MONTH, 1, TODAY()))"));
													                       sb.AppendLine("   and year("  + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "YEAR(DATEADD(MONTH, 1, TODAY()))" ));
													break;
												case "tp_last_30_days"  :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + RdlDocument.DbSpecificDate(sSplendidProvider, "DATEADD(DAY, -30, TODAY())") + " and " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()"));
													break;
												case "tp_next_30_days"  :  sb.AppendLine("   and " + fnPrefix + "fnDateOnly(" + sDATA_FIELD + ") between " + RdlDocument.DbSpecificDate(sSplendidProvider, "TODAY()") + " and " + RdlDocument.DbSpecificDate(sSplendidProvider, "DATEADD(DAY, 30, TODAY())"));
													break;
												case "tp_last_year"     :  sb.AppendLine("   and year(" + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "YEAR(DATEADD(YEAR, -1, TODAY()))"));  break;
												case "tp_this_year"     :  sb.AppendLine("   and year(" + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "YEAR(TODAY())"                   ));  break;
												case "tp_next_year"     :  sb.AppendLine("   and year(" + sDATA_FIELD + ") = " + RdlDocument.DbSpecificDate(sSplendidProvider, "YEAR(DATEADD(YEAR, 1, TODAY()))" ));  break;
											}
										}
									}
									break;
								}
								case "int32":
								{
									// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
									// 07/23/2013 Paul.  Allow leading equals to indicate direct SQL statement, but limit to column name for now. 
									if ( sSEARCH_TEXT1.StartsWith("=") )
									{
										// 07/23/2013 Paul.  Use RdlUtil.ReportColumnName() to restrict the SQL to a column name. 
										var sCAT_SEP = (bIsOracle ? " || " : " + ");
										sSEARCH_TEXT1 = RdlUtil.ReportColumnName(sSEARCH_TEXT1.Substring(1));
										if ( sSEARCH_TEXT2.StartsWith("=") )
											sSEARCH_TEXT2 = RdlUtil.ReportColumnName(sSEARCH_TEXT2.Substring(1));
										switch ( sOPERATOR )
										{
											case "equals"       :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "less"         :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sSEARCH_TEXT1);  break;
											case "greater"      :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sSEARCH_TEXT1);  break;
											case "not_equals"   :  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sSEARCH_TEXT1);  break;
											case "between"      :  sb.AppendLine("   and " + sDATA_FIELD + " between "   + sSEARCH_TEXT1 + " and " + sSEARCH_TEXT2);  break;
											case "empty"        :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"    :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "    + sSEARCH_TEXT1);  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "    + sSEARCH_TEXT1);  break;
										}
									}
									else if ( bUseSQLParameters )
									{
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "less"      :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "greater"   :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "not_equals":  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "between"   :  sb.AppendLine("   and " + sDATA_FIELD + " between "   + sPARAMETER_NAME + "1 and " + sPARAMETER_NAME + "2");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSEARCH_TEXT1, sSEARCH_TEXT2);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 07/23/2013 Paul.  Add greater and less than conditions. 
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
										}
									}
									else
									{
										sSEARCH_TEXT1 = Sql.ToInteger(sSEARCH_TEXT1).ToString();
										sSEARCH_TEXT2 = Sql.ToInteger(sSEARCH_TEXT2).ToString();
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "less"      :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sSEARCH_TEXT1);  break;
											case "greater"   :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sSEARCH_TEXT1);  break;
											case "not_equals":  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sSEARCH_TEXT1);  break;
											case "between"   :  sb.AppendLine("   and " + sDATA_FIELD + " between "   + sSEARCH_TEXT1 + " and " + sSEARCH_TEXT2);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 07/23/2013 Paul.  Add greater and less than conditions. 
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "   + sSEARCH_TEXT1);  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "   + sSEARCH_TEXT1);  break;
										}
									}
									break;
								}
								case "decimal":
								{
									// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
									// 07/23/2013 Paul.  Allow leading equals to indicate direct SQL statement, but limit to column name for now. 
									if ( sSEARCH_TEXT1.StartsWith("=") )
									{
										// 07/23/2013 Paul.  Use RdlUtil.ReportColumnName() to restrict the SQL to a column name. 
										var sCAT_SEP = (bIsOracle ? " || " : " + ");
										sSEARCH_TEXT1 = RdlUtil.ReportColumnName(sSEARCH_TEXT1.Substring(1));
										if ( sSEARCH_TEXT2.StartsWith("=") )
											sSEARCH_TEXT2 = RdlUtil.ReportColumnName(sSEARCH_TEXT2.Substring(1));
										switch ( sOPERATOR )
										{
											case "equals"       :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "less"         :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sSEARCH_TEXT1);  break;
											case "greater"      :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sSEARCH_TEXT1);  break;
											case "not_equals"   :  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sSEARCH_TEXT1);  break;
											case "between"      :  sb.AppendLine("   and " + sDATA_FIELD + " between "   + sSEARCH_TEXT1 + " and " + sSEARCH_TEXT2);  break;
											case "empty"        :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"    :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "    + sSEARCH_TEXT1);  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "    + sSEARCH_TEXT1);  break;
										}
									}
									else if ( bUseSQLParameters )
									{
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "less"      :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "greater"   :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "not_equals":  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "between"   :  sb.AppendLine("   and " + sDATA_FIELD + " between "   + sPARAMETER_NAME + "1 and " + sPARAMETER_NAME + "2");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSEARCH_TEXT1, sSEARCH_TEXT2);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 07/23/2013 Paul.  Add greater and less than conditions. 
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
										}
									}
									else
									{
										sSEARCH_TEXT1 = Sql.ToDecimal(sSEARCH_TEXT1).ToString();
										sSEARCH_TEXT2 = Sql.ToDecimal(sSEARCH_TEXT2).ToString();
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "less"      :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sSEARCH_TEXT1);  break;
											case "greater"   :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sSEARCH_TEXT1);  break;
											case "not_equals":  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sSEARCH_TEXT1);  break;
											case "between"   :  sb.AppendLine("   and " + sDATA_FIELD + " between "   + sSEARCH_TEXT1 + " and " + sSEARCH_TEXT2);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 07/23/2013 Paul.  Add greater and less than conditions. 
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "   + sSEARCH_TEXT1);  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "   + sSEARCH_TEXT1);  break;
										}
									}
									break;
								}
								case "float":
								{
									// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
									// 07/23/2013 Paul.  Allow leading equals to indicate direct SQL statement, but limit to column name for now. 
									if ( sSEARCH_TEXT1.StartsWith("=") )
									{
										// 07/23/2013 Paul.  Use RdlUtil.ReportColumnName() to restrict the SQL to a column name. 
										var sCAT_SEP = (bIsOracle ? " || " : " + ");
										sSEARCH_TEXT1 = RdlUtil.ReportColumnName(sSEARCH_TEXT1.Substring(1));
										if ( sSEARCH_TEXT2.StartsWith("=") )
											sSEARCH_TEXT2 = RdlUtil.ReportColumnName(sSEARCH_TEXT2.Substring(1));
										switch ( sOPERATOR )
										{
											case "equals"       :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "less"         :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sSEARCH_TEXT1);  break;
											case "greater"      :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sSEARCH_TEXT1);  break;
											case "not_equals"   :  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sSEARCH_TEXT1);  break;
											case "between"      :  sb.AppendLine("   and " + sDATA_FIELD + " between "   + sSEARCH_TEXT1 + " and " + sSEARCH_TEXT2);  break;
											case "empty"        :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"    :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "    + sSEARCH_TEXT1);  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "    + sSEARCH_TEXT1);  break;
										}
									}
									else if ( bUseSQLParameters )
									{
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "less"      :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "greater"   :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "not_equals":  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "between"   :  sb.AppendLine("   and " + sDATA_FIELD + " between "   + sPARAMETER_NAME + "1 and " + sPARAMETER_NAME + "2");  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSEARCH_TEXT1, sSEARCH_TEXT2);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 07/23/2013 Paul.  Add greater and less than conditions. 
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
										}
									}
									else
									{
										sSEARCH_TEXT1 = Sql.ToFloat(sSEARCH_TEXT1).ToString();
										sSEARCH_TEXT2 = Sql.ToFloat(sSEARCH_TEXT2).ToString();
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "less"      :  sb.AppendLine("   and " + sDATA_FIELD + " < "    + sSEARCH_TEXT1);  break;
											case "greater"   :  sb.AppendLine("   and " + sDATA_FIELD + " > "    + sSEARCH_TEXT1);  break;
											case "not_equals":  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sSEARCH_TEXT1);  break;
											case "between"   :  sb.AppendLine("   and " + sDATA_FIELD + " between "   + sSEARCH_TEXT1 + " and " + sSEARCH_TEXT2);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 07/23/2013 Paul.  Add greater and less than conditions. 
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "   + sSEARCH_TEXT1);  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "   + sSEARCH_TEXT1);  break;
										}
									}
									break;
								}
								case "bool":
								{
									// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
									// 07/23/2013 Paul.  Allow leading equals to indicate direct SQL statement, but limit to column name for now. 
									if ( sSEARCH_TEXT1.StartsWith("=") )
									{
										// 07/23/2013 Paul.  Use RdlUtil.ReportColumnName() to restrict the SQL to a column name. 
										var sCAT_SEP = (bIsOracle ? " || " : " + ");
										sSEARCH_TEXT1 = RdlUtil.ReportColumnName(sSEARCH_TEXT1.Substring(1));
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
										}
									}
									else if ( bUseSQLParameters )
									{
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
										}
									}
									else
									{
										sSEARCH_TEXT1 = Sql.ToBoolean(sSEARCH_TEXT1) ? "1" : "0";
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
										}
									}
									break;
								}
								case "guid":
								{
									// 07/16/2006 Paul.  Oracle and DB2 are case-significant.  Keep SQL Server code fast by not converting to uppercase. 
									if ( bIsOracle || bIsDB2 )
									{
										sSEARCH_TEXT1 = sSEARCH_TEXT1.ToUpper();
										sSEARCH_TEXT2 = sSEARCH_TEXT2.ToUpper();
										sDATA_FIELD   = "upper(" + sDATA_FIELD + ")";
									}
									// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
									// 07/23/2013 Paul.  Allow leading equals to indicate direct SQL statement, but limit to column name for now. 
									if ( sSEARCH_TEXT1.StartsWith("=") )
									{
										// 07/23/2013 Paul.  Use RdlUtil.ReportColumnName() to restrict the SQL to a column name. 
										var sCAT_SEP = (bIsOracle ? " || " : " + ");
										sSEARCH_TEXT1 = RdlUtil.ReportColumnName(sSEARCH_TEXT1.Substring(1));
										if ( sSEARCH_TEXT2.StartsWith("=") )
											sSEARCH_TEXT2 = RdlUtil.ReportColumnName(sSEARCH_TEXT2.Substring(1));
										switch ( sOPERATOR )
										{
											case "is"             :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "equals"         :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "contains"       :  sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
											case "starts_with"    :  sb.AppendLine("   and " + sDATA_FIELD + " like " +                     sSEARCH_TEXT1 + sCAT_SEP + "N'%'");  break;
											case "ends_with"      :  sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'%'" + sCAT_SEP + sSEARCH_TEXT1);  break;
											case "not_equals_str" :  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sSEARCH_TEXT1);  break;
											case "empty"          :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"      :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											case "one_of":
											{
												// 12/03/2008 Paul.  arrSEARCH_TEXT should already be populated.  Do not pull from lstFILTER_SEARCH_LISTBOX. 
												if ( arrSEARCH_TEXT != null && arrSEARCH_TEXT.Length > 0 )
												{
													sb.Append("   and " + sDATA_FIELD + " in (");
													for ( int j = 0; j < arrSEARCH_TEXT.Length; j++ )
													{
														if ( j > 0 )
															sb.Append(", ");
														sb.Append("N'" + Sql.EscapeSQL(arrSEARCH_TEXT[j]) + "'");
													}
													sb.AppendLine(")");
												}
												break;
											}
										}
									}
									else if ( bUseSQLParameters )
									{
										switch ( sOPERATOR )
										{
											case "is"            :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "equals"        :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "contains"      :  sb.AppendLine("   and " + sDATA_FIELD + " like " + sPARAMETER_NAME + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												if ( bIsMySQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											case "starts_with"   :  sb.AppendLine("   and " + sDATA_FIELD + " like " + sPARAMETER_NAME + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL =       Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												if ( bIsMySQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											case "ends_with"     :  sb.AppendLine("   and " + sDATA_FIELD + " like " + sPARAMETER_NAME + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1)      ;
												if ( bIsMySQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE, sSQL);
												break;
											case "not_equals_str":  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "empty"         :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 05/05/2010 Paul.  one_of was available in the UI, but was not generating the SQL. 
											case "one_of":
											{
												// 12/03/2008 Paul.  arrSEARCH_TEXT should already be populated.  Do not pull from lstFILTER_SEARCH_LISTBOX. 
												if ( arrSEARCH_TEXT != null && arrSEARCH_TEXT.Length > 0 )
												{
													sb.Append("   and " + sDATA_FIELD + " in (");
													for ( int j = 0; j < arrSEARCH_TEXT.Length; j++ )
													{
														if ( j > 0 )
															sb.Append(", ");
														sb.Append("N'" + Sql.EscapeSQL(arrSEARCH_TEXT[j]) + "'");
													}
													sb.AppendLine(")");
												}
												break;
											}
										}
									}
									else
									{
										switch ( sOPERATOR )
										{
											case "is"            :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + "'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "equals"        :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + "'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "contains"      :
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "starts_with"   :
												sSQL =       Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "ends_with"     :
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1)      ;
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "not_equals_str":  sb.AppendLine("   and " + sDATA_FIELD + " <> "   + "'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "empty"         :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 05/05/2010 Paul.  one_of was available in the UI, but was not generating the SQL. 
											case "one_of":
											{
												// 12/03/2008 Paul.  arrSEARCH_TEXT should already be populated.  Do not pull from lstFILTER_SEARCH_LISTBOX. 
												if ( arrSEARCH_TEXT != null && arrSEARCH_TEXT.Length > 0 )
												{
													sb.Append("   and " + sDATA_FIELD + " in (");
													for ( int j = 0; j < arrSEARCH_TEXT.Length; j++ )
													{
														if ( j > 0 )
															sb.Append(", ");
														sb.Append("N'" + Sql.EscapeSQL(arrSEARCH_TEXT[j]) + "'");
													}
													sb.AppendLine(")");
												}
												break;
											}
										}
									}
									break;
								}
								case "enum":
								{
									// 07/16/2006 Paul.  Oracle and DB2 are case-significant.  Keep SQL Server code fast by not converting to uppercase. 
									if ( bIsOracle || bIsDB2 )
									{
										sSEARCH_TEXT1 = sSEARCH_TEXT1.ToUpper();
										sSEARCH_TEXT2 = sSEARCH_TEXT2.ToUpper();
										sDATA_FIELD   = "upper(" + sDATA_FIELD + ")";
									}
									// 10/28/2011 Paul.  QueryBuilder is now being used in the report builder. 
									// 07/23/2013 Paul.  Allow leading equals to indicate direct SQL statement, but limit to column name for now. 
									if ( sSEARCH_TEXT1.StartsWith("=") )
									{
										// 07/23/2013 Paul.  Use RdlUtil.ReportColumnName() to restrict the SQL to a column name. 
										var sCAT_SEP = (bIsOracle ? " || " : " + ");
										sSEARCH_TEXT1 = RdlUtil.ReportColumnName(sSEARCH_TEXT1.Substring(1));
										switch ( sOPERATOR )
										{
											// 02/09/2007 Paul.  enum uses is instead of equals operator. 
											case "is"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "   + sSEARCH_TEXT1);  break;
											case "one_of":
											{
												// 12/03/2008 Paul.  arrSEARCH_TEXT should already be populated.  Do not pull from lstFILTER_SEARCH_LISTBOX. 
												if ( arrSEARCH_TEXT != null && arrSEARCH_TEXT.Length > 0 )
												{
													sb.Append("   and " + sDATA_FIELD + " in (");
													for ( int j = 0; j < arrSEARCH_TEXT.Length; j++ )
													{
														if ( j > 0 )
															sb.Append(", ");
														sb.Append("'" + Sql.EscapeSQL(arrSEARCH_TEXT[j]) + "'");
													}
													sb.AppendLine(")");
												}
												break;
											}
											case "empty"         :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
										}
									}
									else if ( bUseSQLParameters )
									{
										switch ( sOPERATOR )
										{
											// 02/09/2007 Paul.  enum uses is instead of equals operator. 
											case "is"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "   + sPARAMETER_NAME);  rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME, sDATA_TYPE,       sSEARCH_TEXT1      );  break;
											case "one_of":
											{
												// 12/03/2008 Paul.  arrSEARCH_TEXT should already be populated.  Do not pull from lstFILTER_SEARCH_LISTBOX. 
												if ( arrSEARCH_TEXT != null && arrSEARCH_TEXT.Length > 0 )
												{
													sb.Append("   and " + sDATA_FIELD + " in (");
													for ( int j = 0; j < arrSEARCH_TEXT.Length; j++ )
													{
														if ( j > 0 )
															sb.Append(", ");
														sb.Append(sPARAMETER_NAME + "_" + j.ToString("000"));
														rdl.AddQueryParameter(xQueryParameters, sPARAMETER_NAME + "_" + j.ToString("000"), "string", Sql.ToString(arrSEARCH_TEXT[j]));
													}
													sb.AppendLine(")");
												}
												break;
											}
											case "empty"         :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
										}
									}
									else
									{
										switch ( sOPERATOR )
										{
											// 02/09/2007 Paul.  enum uses is instead of equals operator. 
											case "is"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "   + "N'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "one_of":
											{
												// 12/03/2008 Paul.  arrSEARCH_TEXT should already be populated.  Do not pull from lstFILTER_SEARCH_LISTBOX. 
												if ( arrSEARCH_TEXT != null && arrSEARCH_TEXT.Length > 0 )
												{
													sb.Append("   and " + sDATA_FIELD + " in (");
													for ( int j = 0; j < arrSEARCH_TEXT.Length; j++ )
													{
														if ( j > 0 )
															sb.Append(", ");
														sb.Append("N'" + Sql.EscapeSQL(arrSEARCH_TEXT[j]) + "'");
													}
													sb.AppendLine(")");
												}
												break;
											}
											case "empty"         :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
										}
									}
									break;
								}
							}
							nParameterIndex++;
						}
					}
					// 06/18/2006 Paul.  The element 'QueryParameters' in namespace 'http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition' has incomplete content. List of possible elements expected: 'http://schemas.microsoft.com/sqlserver/reporting/2005/01/reportdefinition:QueryParameter'. 
					if ( xQueryParameters.ChildNodes.Count == 0 )
					{
						xQueryParameters.ParentNode.RemoveChild(xQueryParameters);
					}
				}
				catch(Exception ex)
				{
					sbErrors.Append(ex.Message);
				}
				// 06/02/2021 Paul.  React client needs to share code. 
				rdl.SetDataSetFields(hashAvailableModules);
			}
			string sReportSQL = sb.ToString();
			rdl.SetSingleNode("DataSets/DataSet/Query/CommandText", sReportSQL);
			return sReportSQL;
		}

	}
}
