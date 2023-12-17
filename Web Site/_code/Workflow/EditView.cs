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
using System.Xml;
using System.Text;
using System.Collections;
using System.Threading;

namespace SplendidCRM.Administration.Workflows
{
	public class EditView
	{
		// 04/17/2007 Paul.  We need to apply ACL rules a little different from the standard.
		// 07/09/2007 Paul.  Fixes from Version 1.2 on 04/17/2007 were not included in Version 1.4 tree.
		public static void ACLFilter(Security Security, StringBuilder sbJoin, StringBuilder sbWhere, string sMODULE_NAME, string sACCESS_TYPE, string sASSIGNED_USER_ID_Field, bool bIsCaseSignificantDB)
		{
			Crm.Config Config = new Crm.Config();
			// 12/07/2006 Paul.  Not all views use ASSIGNED_USER_ID as the assigned field.  Allow an override. 
			// 11/25/2006 Paul.  Administrators should not be restricted from seeing items because of the team rights.
			// This is so that an administrator can fix any record with a bad team value. 

			// 07/23/2008 Paul.  Team management is not appropriate in workflow as there is no current user. 
			/*
			bool bEnableTeamManagement  = Crm.Config.enable_team_management();
			bool bRequireTeamManagement = Crm.Config.require_team_management();
			bool bIsAdmin = Security.IS_ADMIN;
			// 02/10/2008 Kerry.  Remove debug code to force non-admin. 
			if ( bIsAdmin )
				bRequireTeamManagement = false;
			if ( bEnableTeamManagement )
			{
				if ( bRequireTeamManagement )
					sbJoin.AppendLine("       inner join vwTEAM_MEMBERSHIPS  vwTEAM_MEMBERSHIPS_" + sMODULE_NAME);
				else
					sbJoin.AppendLine("  left outer join vwTEAM_MEMBERSHIPS  vwTEAM_MEMBERSHIPS_" + sMODULE_NAME);
				sbJoin.AppendLine("               on vwTEAM_MEMBERSHIPS_" + sMODULE_NAME + ".MEMBERSHIP_TEAM_ID = " + sMODULE_NAME + ".TEAM_ID");
				sbJoin.AppendLine("              and vwTEAM_MEMBERSHIPS_" + sMODULE_NAME + ".MEMBERSHIP_USER_ID = @MEMBERSHIP_USER_ID");
				//Sql.AddParameter(cmd, "@MEMBERSHIP_USER_ID", Security.USER_ID);
			}

			if ( bEnableTeamManagement && !bRequireTeamManagement && !bIsAdmin )
				sbWhere.AppendLine("   and (" + sMODULE_NAME + ".TEAM_ID is null or vwTEAM_MEMBERSHIPS_" + sMODULE_NAME + ".MEMBERSHIP_ID is not null)");
			*/
			int nACLACCESS = Security.GetUserAccess(sMODULE_NAME, sACCESS_TYPE);
			if ( nACLACCESS == ACL_ACCESS.OWNER )
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

		// 06/03/2021 Paul.  Make BuildReportSQL static so that it can be called from React client. 
		public static string BuildReportSQL(Security Security, XmlUtil XmlUtil, RdlDocument rdl, string BaseModule, string sRELATED_VALUE, string sTYPE, string sFREQUENCY_INTERVAL, string sFREQUENCY_VALUE, StringBuilder sbErrors)
		{
			DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			HttpApplicationState Application         = new HttpApplicationState();

			string sReportSQL  = String.Empty;
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
			
			StringBuilder sb = new StringBuilder();
			StringBuilder sbACLWhere = new StringBuilder();
			if ( rdl.DocumentElement != null )
			{
				string sMODULE_TABLE = Sql.ToString(Application["Modules." + BaseModule + ".TableName"]);
				int nMaxLen = Math.Max(sMODULE_TABLE.Length, 15);
				Hashtable hashRequiredModules  = new Hashtable();
				Hashtable hashAvailableModules = new Hashtable();
				sb.Append("select ");
				
				// 11/16/2008 Paul.  Time-based workflows reference the base module, not the audit table. 
				if ( sTYPE.ToLower() == "time" )
				{
					sb.AppendLine(sMODULE_TABLE + ".ID");
				}
				else
				{
					bool bSelectAll = true;
					// 05/29/2006 Paul.  If the module is used in a filter, then it is required. 
					XmlDocument xmlDisplayColumns = rdl.GetCustomProperty("DisplayColumns");
					XmlNodeList nlFields = xmlDisplayColumns.DocumentElement.SelectNodes("DisplayColumn/Field");
					foreach ( XmlNode xField in nlFields )
						nMaxLen = Math.Max(nMaxLen, xField.InnerText.Length);
					
					string sFieldSeparator = "";
					foreach ( XmlNode xField in nlFields )
					{
						bSelectAll = false;
						sb.Append(sFieldSeparator);
						string sMODULE_ALIAS = xField.InnerText.Split('.')[0];
						if ( !hashRequiredModules.ContainsKey(sMODULE_ALIAS) )
							hashRequiredModules.Add(sMODULE_ALIAS, null);
						sb.Append(xField.InnerText);
						sb.Append(Strings.Space(nMaxLen - xField.InnerText.Length));
						sb.Append(" as \"" + xField.InnerText + "\"");
						sb.AppendLine();
						sFieldSeparator = "     , ";
					}
					if ( bSelectAll )
					{
						sb.AppendLine("*");
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
				
				if ( sTYPE.ToLower() == "time" )
				{
					// 11/16/2008 Paul.  Time-based workflows reference the base module, not the audit table. 
					// 03/15/2012 Paul.  We need to add a space after the module table as Orders Line Items can exceed the max length and fail to add the space. 
					sb.Append("  from            vw" + sMODULE_TABLE + " " + Strings.Space(nMaxLen - sMODULE_TABLE.Length) + sMODULE_TABLE +                ControlChars.CrLf);
				}
				else
				{
					// 11/17/2008 Paul.  Use new audit views so that custom fields will be included. 
					sb.Append("  from            vw" + sMODULE_TABLE + "_AUDIT " + Strings.Space(nMaxLen - sMODULE_TABLE.Length) + sMODULE_TABLE +                ControlChars.CrLf);
				}

				// 04/17/2007 Paul.  Apply ACL rules. 
				if ( sMODULE_TABLE != "USERS" )
					ACLFilter(Security, sb, sbACLWhere, sMODULE_TABLE, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2);
				hashAvailableModules.Add(sMODULE_TABLE, sMODULE_TABLE);
				if ( !Sql.IsEmptyString(sRELATED_VALUE) )
				{
					XmlDocument xmlRelatedModules = rdl.GetCustomProperty("RelatedModules");
					string sRELATED           = sRELATED_VALUE.Split(' ')[0];
					string sRELATED_ALIAS     = sRELATED_VALUE.Split(' ')[1];
					// 10/26/2011 Paul.  Add the relationship so that we can have a unique lookup. 
					string sRELATIONSHIP_NAME = sRELATED_VALUE.Split(' ')[2];
					
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
							// 04/17/2007 Paul.  Apply ACL rules. 
							if ( sRHS_TABLE != "USERS" )
								ACLFilter(Security, sb, sbACLWhere, sRHS_TABLE, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2);
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
							// 04/17/2007 Paul.  Apply ACL rules. 
							if ( sRHS_TABLE != "USERS" )
								ACLFilter(Security, sb, sbACLWhere, sRHS_TABLE, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2);
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
							// 07/22/2008 Paul.  Audit tables need a special join to get to the old data. 
							// 07/31/2008 Paul.  Use the relationship name to detect the audit old table. 
							if ( sRELATIONSHIP_NAME.EndsWith("_audit_old") )
							{
								sb.AppendLine("  left outer join " + sLHS_TABLE + " "               + Strings.Space(nMaxLen - sLHS_TABLE.Length                        ) + sMODULE_ALIAS);
								sb.AppendLine("               on " + sMODULE_ALIAS + "." + sLHS_KEY + Strings.Space(nMaxLen - sMODULE_ALIAS.Length - sLHS_KEY.Length - 1) + " = " + sRHS_TABLE + "." + sRHS_KEY);
								sb.AppendLine("              and " + sMODULE_ALIAS + ".AUDIT_VERSION = (select max(" + sLHS_TABLE + ".AUDIT_VERSION)");
								sb.AppendLine("                                                  from " + sLHS_TABLE);
								sb.AppendLine("                                                 where " + sLHS_TABLE + ".ID            =  " + sRHS_TABLE + ".ID");
								sb.AppendLine("                                                   and " + sLHS_TABLE + ".AUDIT_VERSION <  " + sRHS_TABLE + ".AUDIT_VERSION");
								sb.AppendLine("                                                   and " + sLHS_TABLE + ".AUDIT_TOKEN   <> " + sRHS_TABLE + ".AUDIT_TOKEN");
								sb.AppendLine("                                               )");
								
								// 04/17/2007 Paul.  Apply ACL rules. 
								// 07/22/2008 Paul.  ACL rules do not need to be applied to the AUDIT_OLD table. 
								//if ( sLHS_TABLE != "USERS" )
								//	ACLFilter(sb, sbACLWhere, sMODULE_ALIAS, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2);
								// 07/13/2006 Paul.  The key needs to be the alias, and the value is the main table. 
								// This is because the same table may be referenced more than once, 
								// such as the Users table to display the last modified user and the assigned to user. 
								if ( !hashAvailableModules.ContainsKey(sMODULE_ALIAS) )
									hashAvailableModules.Add(sMODULE_ALIAS, sLHS_TABLE);
							}
							else
							{
								sb.AppendLine("  left outer join vw" + sLHS_TABLE + " "               + Strings.Space(nMaxLen - sLHS_TABLE.Length                        ) + sMODULE_ALIAS);
								sb.AppendLine("               on "   + sMODULE_ALIAS + "." + sLHS_KEY + Strings.Space(nMaxLen - sMODULE_ALIAS.Length - sLHS_KEY.Length - 1) + " = " + sRHS_TABLE + "." + sRHS_KEY);
								// 04/17/2007 Paul.  Apply ACL rules. 
								if ( sLHS_TABLE != "USERS" )
									ACLFilter(Security, sb, sbACLWhere, sMODULE_ALIAS, "list", "ASSIGNED_USER_ID", bIsOracle || bIsDB2);
								// 07/13/2006 Paul.  The key needs to be the alias, and the value is the main table. 
								// This is because the same table may be referenced more than once, 
								// such as the Users table to display the last modified user and the assigned to user. 
								if ( !hashAvailableModules.ContainsKey(sMODULE_ALIAS) )
									hashAvailableModules.Add(sMODULE_ALIAS, sLHS_TABLE);
							}
						}
					}
				}
				if ( sTYPE.ToLower() == "time" )
				{
					// 11/16/2008 Paul.  A time-based workflow does not have an AUDIT_ID to key off of.
					int nFREQUENCY_VALUE = Sql.ToInteger(sFREQUENCY_VALUE);
					if ( nFREQUENCY_VALUE > 0 )
					{
						// 11/19/2008 Paul.  Allow the frequency limit to be a count of records.
						if ( sFREQUENCY_INTERVAL.ToLower() == "records" )
						{
							// 12/04/2008 Paul.  Correct value comparison. 
							sb.AppendLine(" where " + nFREQUENCY_VALUE.ToString() + " > (select count(*)                  ");
							sb.AppendLine("               from WORKFLOW_RUN              ");
							sb.AppendLine("              where WORKFLOW_ID = @WORKFLOW_ID");
							// 11/16/2008 Paul.  Use the AUDIT_ID field even though this is a timed workflow. 
							sb.AppendLine("                and AUDIT_ID    = " + sMODULE_TABLE + ".ID");
							sb.AppendLine("            )");
						}
						else
						{
							//rdl.SetCustomProperty("FrequencyValue"   , FREQUENCY_VALUE.Text            );
							//rdl.SetCustomProperty("FrequencyInterval", FREQUENCY_INTERVAL.SelectedValue);
							string fnPrefix = "dbo.";
							if ( bIsOracle || bIsDB2 || bIsMySQL || bIsPostgreSQL )
							{
								fnPrefix = "";
							}
							sb.AppendLine(" where not exists(select *                         ");
							sb.AppendLine("                    from WORKFLOW_RUN              ");
							sb.AppendLine("                   where WORKFLOW_ID = @WORKFLOW_ID");
							// 11/16/2008 Paul.  Use the AUDIT_ID field even though this is a timed workflow. 
							sb.AppendLine("                     and AUDIT_ID    = " + sMODULE_TABLE + ".ID");
							// 12/04/2008 Paul.  Correct date comparison. 
							sb.AppendLine("                     and " + RdlDocument.DbSpecificDate(sSplendidProvider, "GETDATE()") + " < " + fnPrefix + "fnDateAdd('" + sFREQUENCY_INTERVAL + "', " + nFREQUENCY_VALUE.ToString() + ", WORKFLOW_RUN.DATE_ENTERED)");
							sb.AppendLine("                 )");
						}
					}
					else
					{
						sb.AppendLine(" where 1 = 1");
					}
				}
				else
				{
					sb.AppendLine(" where " + sMODULE_TABLE + ".AUDIT_ID = @AUDIT_ID");
					// 07/30/2008 Paul.  We are not going to allow a workflow to fire on a delete event. 
					// This is because we use the vw????_Edit view to retrieve the data in workflow engine. 
					sb.AppendLine("   and " + sMODULE_TABLE + ".DELETED  = 0");
				}
				sb.Append(sbACLWhere.ToString());
				try
				{
					rdl.SetSingleNode("DataSets/DataSet/Query/QueryParameters", String.Empty);
					XmlNode xQueryParameters = rdl.SelectNode("DataSets/DataSet/Query/QueryParameters");
					xQueryParameters.RemoveAll();
					if ( xmlFilters.DocumentElement != null )
					{
						int nParameterIndex = 0;
						int nMaxColumnLength = 0;
						foreach ( XmlNode xFilter in xmlFilters.DocumentElement )
						{
							string sDATA_FIELD = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD" );
							if ( nMaxColumnLength < sDATA_FIELD.Length )
								nMaxColumnLength = sDATA_FIELD.Length;
						}
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
							string sTABLE_NAME     = XmlUtil.SelectSingleNode(xFilter, "TABLE_NAME" );
							string sDATA_FIELD     = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD" );
							string sFIELD_NAME     = XmlUtil.SelectSingleNode(xFilter, "FIELD_NAME" );
							string sDATA_TYPE      = XmlUtil.SelectSingleNode(xFilter, "DATA_TYPE"  );
							string sOPERATOR       = XmlUtil.SelectSingleNode(xFilter, "OPERATOR"   );
							string sSEARCH_TEXT1   = String.Empty;
							string sSEARCH_TEXT2   = String.Empty;
							string sDATA_FIELD_PADDING = String.Empty;
							if ( nMaxColumnLength > sDATA_FIELD.Length )
								sDATA_FIELD_PADDING = Strings.Space(nMaxColumnLength - sDATA_FIELD.Length);
							
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
							// 07/23/2008 Paul.  The workflow operators are common across all data types. 
							if ( sOPERATOR == "changed" || sOPERATOR == "unchanged" || sOPERATOR == "increased" || sOPERATOR == "decreased" )
							{
								// 07/24/2008 Paul.  If this is a new record, then all fields automatically are changed. 
								switch ( sOPERATOR )
								{
									case "changed"       :  sb.AppendLine("   and (" + sTABLE_NAME + ".AUDIT_ID is null      or (not(" + sDATA_FIELD.Replace("_AUDIT_OLD", "") + sDATA_FIELD_PADDING + " is null     and " + sDATA_FIELD + sDATA_FIELD_PADDING + " is null    ) and (" + sDATA_FIELD.Replace("_AUDIT_OLD", "") + sDATA_FIELD_PADDING + " <> " + sDATA_FIELD + sDATA_FIELD_PADDING + " or " + sDATA_FIELD.Replace("_AUDIT_OLD", "") + " is null or " + sDATA_FIELD + " is null)))");  break;
									case "unchanged"     :  sb.AppendLine("   and (" + sTABLE_NAME + ".AUDIT_ID is not null and (   (" + sDATA_FIELD.Replace("_AUDIT_OLD", "") + sDATA_FIELD_PADDING + " is null     and " + sDATA_FIELD + sDATA_FIELD_PADDING + " is null    )  or  " + sDATA_FIELD.Replace("_AUDIT_OLD", "") + sDATA_FIELD_PADDING + " =  " + sDATA_FIELD + sDATA_FIELD_PADDING + "))");  break;
									case "increased"     :  sb.AppendLine("   and (" + sTABLE_NAME + ".AUDIT_ID is not null and (   (" + sDATA_FIELD.Replace("_AUDIT_OLD", "") + sDATA_FIELD_PADDING + " is not null and " + sDATA_FIELD + sDATA_FIELD_PADDING + " is not null) and  " + sDATA_FIELD.Replace("_AUDIT_OLD", "") + sDATA_FIELD_PADDING + " >  " + sDATA_FIELD + sDATA_FIELD_PADDING + "))");  break;
									case "decreased"     :  sb.AppendLine("   and (" + sTABLE_NAME + ".AUDIT_ID is not null and (   (" + sDATA_FIELD.Replace("_AUDIT_OLD", "") + sDATA_FIELD_PADDING + " is not null and " + sDATA_FIELD + sDATA_FIELD_PADDING + " is not null) and  " + sDATA_FIELD.Replace("_AUDIT_OLD", "") + sDATA_FIELD_PADDING + " <  " + sDATA_FIELD + sDATA_FIELD_PADDING + "))");  break;
								}
							}
							// 07/23/2013 Paul.  Allow leading equals to indicate direct SQL statement, but limit to column name for now. 
							else if ( sSEARCH_TEXT1.StartsWith("=") )
							{
								// 07/23/2013 Paul.  Use RdlUtil.ReportColumnName() to restrict the SQL to a column name. 
								var sCAT_SEP = (bIsOracle ? " || " : " + ");
								sSEARCH_TEXT1 = RdlUtil.ReportColumnName(sSEARCH_TEXT1.Substring(1));
								if ( sSEARCH_TEXT2.StartsWith("=") )
									sSEARCH_TEXT2 = RdlUtil.ReportColumnName(sSEARCH_TEXT2.Substring(1));
								switch ( sCOMMON_DATA_TYPE )
								{
									case "string":
									{
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
										break;
									}
									case "datetime":
									{
										string fnPrefix = "dbo.";
										if ( bIsOracle || bIsDB2 || bIsMySQL || bIsPostgreSQL )
										{
											fnPrefix = "";
										}
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
										break;
									}
									case "int32":
									{
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
										break;
									}
									case "decimal":
									{
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
										break;
									}
									case "float":
									{
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
										break;
									}
									case "bool":
									{
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
										}
										break;
									}
									case "guid":
									{
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
										break;
									}
									case "enum":
									{
										if ( bIsOracle || bIsDB2 )
										{
											sSEARCH_TEXT1 = sSEARCH_TEXT1.ToUpper();
											sSEARCH_TEXT2 = sSEARCH_TEXT2.ToUpper();
											sDATA_FIELD   = "upper(" + sDATA_FIELD + ")";
										}
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
										break;
									}
								}
							}
							else
							{
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
											case "like"      :
												sSQL = sSEARCH_TEXT1;
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "N'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "empty"         :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
											// 08/25/2011 Paul.  A customer wants more use of NOT in string filters. 
											// 10/25/2014 Paul.  Filters that use NOT should protect against NULL values. 
											case "not_equals_str"    :
												sb.AppendLine("   and " + sISNULL + "(" + sDATA_FIELD + ", N'')" + " <> "   + "N'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");
												break;
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
										break;
									}
									case "datetime":
									{
										string fnPrefix = "dbo.";
										if ( bIsOracle || bIsDB2 || bIsMySQL || bIsPostgreSQL )
										{
											fnPrefix = "";
										}
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
										break;
									}
									case "int32":
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
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "    + sSEARCH_TEXT1);  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "    + sSEARCH_TEXT1);  break;
										}
										break;
									}
									case "decimal":
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
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "    + sSEARCH_TEXT1);  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "    + sSEARCH_TEXT1);  break;
										}
										break;
									}
									case "float":
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
											case "less_equal"   :  sb.AppendLine("   and " + sDATA_FIELD + " <= "    + sSEARCH_TEXT1);  break;
											case "greater_equal":  sb.AppendLine("   and " + sDATA_FIELD + " >= "    + sSEARCH_TEXT1);  break;
										}
										break;
									}
									case "bool":
									{
										sSEARCH_TEXT1 = Sql.ToBoolean(sSEARCH_TEXT1) ? "1" : "0";
										switch ( sOPERATOR )
										{
											case "equals"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + sSEARCH_TEXT1);  break;
											case "empty"     :  sb.AppendLine("   and " + sDATA_FIELD + " is null"    );  break;
											case "not_empty" :  sb.AppendLine("   and " + sDATA_FIELD + " is not null");  break;
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
										switch ( sOPERATOR )
										{
											case "is"            :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + "'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "equals"        :  sb.AppendLine("   and " + sDATA_FIELD + " = "    + "'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
											case "contains"      :
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "starts_with"   :
												sSQL =       Sql.EscapeSQLLike(sSEARCH_TEXT1) + '%';
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
												break;
											case "ends_with"     :
												sSQL = '%' + Sql.EscapeSQLLike(sSEARCH_TEXT1)      ;
												// 01/10/2010 Paul.  PostgreSQL requires two slashes. 
												if ( bIsMySQL || bIsPostgreSQL )
													sSQL = sSQL.Replace("\\", "\\\\");  // 07/16/2006 Paul.  MySQL requires that slashes be escaped, even in the escape clause. 
												sb.AppendLine("   and " + sDATA_FIELD + " like " + "'" + Sql.EscapeSQL(sSQL) + "'" + (bIsMySQL ? " escape '\\\\'" : " escape '\\'"));
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
										switch ( sOPERATOR )
										{
											// 02/09/2007 Paul.  enum uses is instead of equals operator. 
											case "is"    :  sb.AppendLine("   and " + sDATA_FIELD + " = "   + "'" + Sql.EscapeSQL(sSEARCH_TEXT1) + "'");  break;
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
										break;
									}
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
				// 06/15/2006 Paul.  Completely rebuild the Fields list based on the available modules. 
				rdl.SetSingleNode("DataSets/DataSet/Fields", String.Empty);
				XmlNode xFields = rdl.SelectNode("DataSets/DataSet/Fields");
				xFields.RemoveAll();
				/*
				// 07/13/2006 Paul.  The key is the alias and the value is the module. 
				// This is so that the same module can be referenced many times with many aliases. 
				foreach ( string sTableAlias in hashAvailableModules.Keys )
				{
					string sTABLE_NAME = Sql.ToString(hashAvailableModules[sTableAlias]);
					DataTable dtColumns = SplendidCache.WorkflowFilterColumns(sTABLE_NAME).Copy();
					foreach(DataRow row in dtColumns.Rows)
					{
						string sFieldName = sTableAlias + "." + Sql.ToString(row["NAME"]);
						string sCsType = Sql.ToString(row["CsType"]);
						string sFieldType = String.Empty;
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
						rdl.CreateField(xFields, sFieldName, sFieldType);
					}
				}
				*/
			}
			sReportSQL = sb.ToString();
			rdl.SetSingleNode("DataSets/DataSet/Query/CommandText", sReportSQL);
			return sReportSQL;
		}

		// 06/06/2021 Paul.  Make method static so that it can be used by React client. 
		public static void BuildTriggers(SqlProcs SqlProcs, XmlUtil XmlUtil, RdlDocument rdl, string BaseModule, Guid gPARENT_ID, StringBuilder sbErrors, IDbTransaction trn)
		{
			HttpApplicationState Application        = new HttpApplicationState();
			Guid gID = Guid.Empty;
			if ( rdl.DocumentElement != null )
			{
				StringBuilder sb = new StringBuilder();
				string sMODULE_TABLE = Sql.ToString(Application["Modules." + BaseModule + ".TableName"]);
				try
				{
					XmlDocument xmlFilters = rdl.GetCustomProperty("Filters");
					if ( xmlFilters.DocumentElement != null )
					{
						XmlNodeList nlFilters = xmlFilters.DocumentElement.SelectNodes("Filter");
						if ( nlFilters.Count == 0 )
						{
							gID = Guid.Empty;
							SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, String.Empty, "trigger_record_change", "Primary", String.Empty, false, String.Empty, String.Empty, String.Empty, trn);
						}
						foreach ( XmlNode xFilter in xmlFilters.DocumentElement )
						{
							string sMODULE         = XmlUtil.SelectSingleNode(xFilter, "MODULE"     );
							string sMODULE_NAME    = XmlUtil.SelectSingleNode(xFilter, "MODULE_NAME");
							string sTABLE_NAME     = XmlUtil.SelectSingleNode(xFilter, "TABLE_NAME" );
							string sDATA_FIELD     = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD" );
							string sFIELD_NAME     = XmlUtil.SelectSingleNode(xFilter, "FIELD_NAME" );
							string sDATA_TYPE      = XmlUtil.SelectSingleNode(xFilter, "DATA_TYPE"  );
							string sOPERATOR       = XmlUtil.SelectSingleNode(xFilter, "OPERATOR"   );
							string sSEARCH_TEXT1   = String.Empty;
							string sSEARCH_TEXT2   = String.Empty;
							string sREL_MODULE     = sMODULE;
							string sREL_MODULE_TYPE= String.Empty;
							
							StringBuilder sbPARAMETERS = new StringBuilder();
							XmlNodeList nlValues = xFilter.SelectNodes("SEARCH_TEXT_VALUES");
							string[] arrSEARCH_TEXT = new string[nlValues.Count];
							int i = 0;
							foreach ( XmlNode xValue in nlValues )
							{
								arrSEARCH_TEXT[i++] = xValue.InnerText;
								if ( sbPARAMETERS.Length > 0 )
									sbPARAMETERS.Append(", ");
								sbPARAMETERS.Append(xValue.InnerText);
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
							// 07/23/2008 Paul.  The workflow operators are common across all data types. 
							if ( sOPERATOR == "changed" || sOPERATOR == "unchanged" || sOPERATOR == "increased" || sOPERATOR == "decreased" )
							{
								gID = Guid.Empty;
								SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_change", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, String.Empty, trn);
							}
							else
							{
								switch ( sCOMMON_DATA_TYPE )
								{
									case "string":
									{
										gID = Guid.Empty;
										SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_specific", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, sbPARAMETERS.ToString(), trn);
										break;
									}
									case "datetime":
									{
										if ( arrSEARCH_TEXT.Length > 0 )
										{
											sbPARAMETERS = new StringBuilder();
											DateTime dtSEARCH_TEXT1 = DateTime.ParseExact(sSEARCH_TEXT1, "yyyy/MM/dd", Thread.CurrentThread.CurrentCulture.DateTimeFormat);
											DateTime dtSEARCH_TEXT2 = DateTime.MinValue;
											sbPARAMETERS.Append("'" + dtSEARCH_TEXT1.ToString("yyyy/MM/dd") + "'");
											if ( arrSEARCH_TEXT.Length > 1 )
											{
												dtSEARCH_TEXT2 = DateTime.ParseExact(sSEARCH_TEXT2, "yyyy/MM/dd", Thread.CurrentThread.CurrentCulture.DateTimeFormat);
												sbPARAMETERS.Append(", '" + dtSEARCH_TEXT2.ToString("yyyy/MM/dd") + "'");
											}
											gID = Guid.Empty;
											SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_specific", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, sbPARAMETERS.ToString(), trn);
										}
										else
										{
											gID = Guid.Empty;
											SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_specific", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, sbPARAMETERS.ToString(), trn);
										}
										break;
									}
									case "int32":
									{
										gID = Guid.Empty;
										SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_specific", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, sbPARAMETERS.ToString(), trn);
										break;
									}
									case "decimal":
									{
										gID = Guid.Empty;
										SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_specific", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, sbPARAMETERS.ToString(), trn);
										break;
									}
									case "float":
									{
										gID = Guid.Empty;
										SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_specific", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, sbPARAMETERS.ToString(), trn);
										break;
									}
									case "bool":
									{
										gID = Guid.Empty;
										SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_specific", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, sbPARAMETERS.ToString(), trn);
										break;
									}
									case "guid":
									{
										gID = Guid.Empty;
										SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_specific", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, sbPARAMETERS.ToString(), trn);
										break;
									}
									case "enum":
									{
										gID = Guid.Empty;
										SqlProcs.spWORKFLOW_TRIGGER_SHELLS_Update(ref gID, gPARENT_ID, sFIELD_NAME, "compare_specific", "Primary", sOPERATOR, false, sREL_MODULE, sREL_MODULE_TYPE, sbPARAMETERS.ToString(), trn);
										break;
									}
								}
							}
						}
					}
				}
				catch(Exception ex)
				{
					sbErrors.Append(ex.Message);
				}
			}
		}
	}
}
