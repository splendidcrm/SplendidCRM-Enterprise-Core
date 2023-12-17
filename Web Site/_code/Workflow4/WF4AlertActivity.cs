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
using System.Text;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Activities;
using System.Xml;
using System.Net.Mail;
using System.ComponentModel;
using System.Diagnostics;

using Microsoft.AspNetCore.Hosting;
using System.Threading.Tasks;
using Microsoft.Extensions.Caching.Memory;
using Spring.Social.Office365;

namespace SplendidCRM
{
	public class WF4AlertActivity : CodeActivity
	{
		// 07/28/2016 Paul.  BUSINESS_PROCESS_ID is a workflow global, so skip the part where we manually assign in XAML. 
		//public InArgument<Guid  > BUSINESS_PROCESS_ID  { get; set; }
		// 07/28/2016 Paul.  AUDIT_ID is a workflow global, so skip the part where we manually assign in XAML. 
		//public InArgument<Guid  > AUDIT_ID             { get; set; }
		public InArgument<string> PARENT_TYPE          { get; set; }
		public InArgument<Guid  > PARENT_ID            { get; set; }
		public InArgument<string> FROM_NAME            { get; set; }
		public InArgument<string> FROM_ADDRESS         { get; set; }
		public InArgument<string> ALERT_TYPE           { get; set; }
		public InArgument<string> SOURCE_TYPE          { get; set; }
		public InArgument<string> ALERT_SUBJECT        { get; set; }
		public InArgument<string> ALERT_TEXT           { get; set; }
		public InArgument<Guid  > CUSTOM_TEMPLATE_ID   { get; set; }
		public InArgument<Guid  > ASSIGNED_USER_ID     { get; set; }
		public InArgument<Guid  > TEAM_ID              { get; set; }
		public InArgument<string> TEAM_SET_LIST        { get; set; }
		// 07/17/2016 Paul.  Cannot be InOutArgument. 
		public InArgument<ICollection<WF4Recipient>> RECIPIENTS { get; set; }
		public InArgument<ICollection<WF4Report   >> REPORTS    { get; set; }

		private void AddInsertionValues(SplendidApplicationService app, Hashtable hash, string sFieldName, object oValue, string sAge, string sModuleName, string sRelationshipName, DataView vwColumns, string sSiteURL)
		{
			SplendidCache        SplendidCache   = app.SplendidCache  ;

			if ( oValue.GetType() == typeof(System.DateTime) )
			{
				if ( Sql.ToDateTime(oValue) == DateTime.MinValue )
					oValue = String.Empty;
			}
			else if ( oValue.GetType() == typeof(System.String) )
			{
				// 10/11/2008 Paul.  Convert list values using the default culture. 
				vwColumns.RowFilter = "ColumnName = '" + sFieldName + "' and CsType = 'enum'";
				if ( vwColumns.Count > 0 )
				{
					string sListName = String.Empty;
					if ( Sql.IsEmptyString(sRelationshipName) )
						sListName = SplendidCache.ReportingFilterColumnsListName(sModuleName, sFieldName);
					else
						sListName = SplendidCache.ReportingFilterColumnsListName(sRelationshipName, sFieldName);
					// 04/23/2011 Paul.  A list name must have leading and trailing dots. 
					oValue = app.Term("." + sListName + ".", oValue);
				}
			}
			if ( Sql.IsEmptyString(sRelationshipName) )
			{
				string sInsertion = sAge + "::" + sModuleName + "::" + sFieldName.ToLower();
				if ( hash.ContainsKey(sInsertion) )
				{
					hash[sInsertion] = oValue;
				}
				if ( sAge == "future" )
				{
					if ( sFieldName.ToUpper() == "ID" )
					{
						sInsertion = "href_link::" + sModuleName + "::href_link";
						if ( hash.ContainsKey(sInsertion) )
						{
							string sViewURL = sSiteURL + sModuleName + "/view.aspx?ID=" + Sql.ToString(oValue);
							// 12/16/2009 Paul.  Project and ProjectTask require special handling as the folder names are plural. 
							if ( sModuleName == "Project" || sModuleName == "ProjectTask" )
							{
								sViewURL = sSiteURL + sModuleName + "s/view.aspx?ID=" + Sql.ToString(oValue);
							}
							hash[sInsertion] = "<a href=\"" + sViewURL + "\">" + sViewURL + "</a>";
						}
						// 08/19/2023 Paul.  Add support for React links. 
						sInsertion = "react_href_link::" + sModuleName + "::react_href_link";
						if ( hash.ContainsKey(sInsertion) )
						{
							string sViewURL = sSiteURL + "React/" + sModuleName + "/View/" + Sql.ToString(oValue);
							hash[sInsertion] = "<a href=\"" + sViewURL + "\">" + sViewURL + "</a>";
						}
					}
				}
			}
			else
			{
				string sInsertion = sAge + "::" + sModuleName + "::" + sRelationshipName + "::" + sFieldName.ToLower();
				if ( hash.ContainsKey(sInsertion) )
				{
					hash[sInsertion] = oValue;
				}
				if ( sAge == "future" )
				{
					if ( sFieldName.ToUpper() == "ID" )
					{
						sInsertion = "href_link::" + sModuleName + "::" + sRelationshipName + "::href_link";
						if ( hash.ContainsKey(sInsertion) )
						{
							string sViewURL = sSiteURL + sRelationshipName + "/view.aspx?ID=" + Sql.ToString(oValue);
							// 12/16/2009 Paul.  Project and ProjectTask require special handling as the folder names are plural. 
							if ( sRelationshipName == "Project" || sRelationshipName == "ProjectTask" )
							{
								sViewURL = sSiteURL + sRelationshipName + "s/view.aspx?ID=" + Sql.ToString(oValue);
							}
							hash[sInsertion] = "<a href=\"" + sViewURL + "\">" + sViewURL + "</a>";
						}
						// 08/19/2023 Paul.  Add support for React links. 
						sInsertion = "react_href_link::" + sModuleName + "::" + sRelationshipName + "::react_href_link";
						if ( hash.ContainsKey(sInsertion) )
						{
							string sViewURL = sSiteURL + "React/" + sRelationshipName + "/View/" + Sql.ToString(oValue);
							hash[sInsertion] = "<a href=\"" + sViewURL + "\">" + sViewURL + "</a>";
						}
					}
				}
			}
		}

		public List<AlertRecipient> BuildRecipients(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			EmailUtils           EmailUtils     = app.EmailUtils   ;

			List<AlertRecipient> lstRECIPIENTS = new List<AlertRecipient>();
			foreach ( WF4Recipient wf4Recipient in context.GetValue<ICollection<WF4Recipient>>(RECIPIENTS) )
			{
				Guid   gRECIPIENT_ID    = wf4Recipient.RECIPIENT_ID   ;
				string sRECIPIENT_NAME  = wf4Recipient.RECIPIENT_NAME ;
				string sRECIPIENT_TYPE  = wf4Recipient.RECIPIENT_TYPE ;
				string sSEND_TYPE       = wf4Recipient.SEND_TYPE      ;
				string sRECIPIENT_TABLE = wf4Recipient.RECIPIENT_TABLE;
				string sRECIPIENT_FIELD = wf4Recipient.RECIPIENT_FIELD;
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL ;
					// 11/12/2016 Paul.  Recipient Type can be Teams, Roles, Users, [ModuleName], [ModuleName]_AUDIT. 
					switch ( sRECIPIENT_TYPE )
					{
						case "Teams":
						{
							sSQL = "select USER_ID                " + ControlChars.CrLf
							     + "     , FULL_NAME              " + ControlChars.CrLf
							     + "     , EMAIL1                 " + ControlChars.CrLf
							     + "  from vwTEAM_MEMBERSHIPS_List" + ControlChars.CrLf
							     + " where TEAM_ID = @TEAM_ID     " + ControlChars.CrLf
							     + "   and EMAIL1 is not null     " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@TEAM_ID", gRECIPIENT_ID);
								// 07/08/2010 Paul.  We also need to return all rows.  Not just a single row. 
								using ( IDataReader rdr = cmd.ExecuteReader() )
								{
									// 01/19/2010 Paul.  We need to use a while loop to send to all team members. 
									bool bRecipientAdded = false;
									while ( rdr.Read() )
									{
										Guid   gPARENT_ID = Sql.ToGuid  (rdr["USER_ID"  ]);
										string sFULL_NAME = Sql.ToString(rdr["FULL_NAME"]);
										string sEMAIL1    = Sql.ToString(rdr["EMAIL1"   ]);
										// 10/11/2008 Paul.  Reduce send errors by only sending to valid email addresses. 
										if ( EmailUtils.IsValidEmail(sEMAIL1) )
										{
											AlertRecipient r = new AlertRecipient(gPARENT_ID, "Users", sFULL_NAME, sEMAIL1, sSEND_TYPE);
											lstRECIPIENTS.Add(r);
											bRecipientAdded = true;
										}
									}
									// 10/29/2023 Paul.  Generate exception if no recipients found. 
									if ( !bRecipientAdded )
									{
										throw(new Exception("WF4AlertActivity: " + sRECIPIENT_TYPE + " " + gRECIPIENT_ID.ToString() + " does not have any users with valid EMAIL1"));
									}
								}
							}
							break;
						}
						case "Roles":
						{
							// 10/30/2009 Paul.  We should be using ACL Roles, not the old deprecated ROLES_USERS table. 
							sSQL = "select USER_ID           " + ControlChars.CrLf
							     + "     , FULL_NAME         " + ControlChars.CrLf
							     + "     , EMAIL1            " + ControlChars.CrLf
							     + "  from vwACL_ROLES_USERS " + ControlChars.CrLf
							     + " where ROLE_ID = @ROLE_ID" + ControlChars.CrLf
							     + "   and EMAIL1 is not null" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ROLE_ID", gRECIPIENT_ID);
								// 07/08/2010 Paul.  We also need to return all rows.  Not just a single row. 
								using ( IDataReader rdr = cmd.ExecuteReader() )
								{
									// 01/19/2010 Paul.  We need to use a while loop to send to all role members. 
									bool bRecipientAdded = false;
									while ( rdr.Read() )
									{
										Guid   gPARENT_ID = Sql.ToGuid  (rdr["USER_ID"  ]);
										string sFULL_NAME = Sql.ToString(rdr["FULL_NAME"]);
										string sEMAIL1    = Sql.ToString(rdr["EMAIL1"   ]);
										// 10/11/2008 Paul.  Reduce send errors by only sending to valid email addresses. 
										if ( EmailUtils.IsValidEmail(sEMAIL1) )
										{
											AlertRecipient r = new AlertRecipient(gPARENT_ID, "Users", sFULL_NAME, sEMAIL1, sSEND_TYPE);
											lstRECIPIENTS.Add(r);
											bRecipientAdded = true;
										}
									}
									// 10/29/2023 Paul.  Generate exception if no recipients found. 
									if ( !bRecipientAdded )
									{
										throw(new Exception("WF4AlertActivity: " + sRECIPIENT_TYPE + " " + gRECIPIENT_ID.ToString() + " does not have any users with valid EMAIL1"));
									}
								}
							}
							break;
						}
						case "Users":
						{
							sSQL = "select ID                " + ControlChars.CrLf
							     + "     , FULL_NAME         " + ControlChars.CrLf
							     + "     , EMAIL1            " + ControlChars.CrLf
							     + "  from vwUSERS           " + ControlChars.CrLf
							     + " where ID = @ID          " + ControlChars.CrLf
							     + "   and EMAIL1 is not null" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gRECIPIENT_ID);
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									bool bRecipientAdded = false;
									if ( rdr.Read() )
									{
										Guid   gPARENT_ID = Sql.ToGuid  (rdr["ID"       ]);
										string sFULL_NAME = Sql.ToString(rdr["FULL_NAME"]);
										string sEMAIL1    = Sql.ToString(rdr["EMAIL1"   ]);
										// 10/11/2008 Paul.  Reduce send errors by only sending to valid email addresses. 
										if ( EmailUtils.IsValidEmail(sEMAIL1) )
										{
											AlertRecipient r = new AlertRecipient(gPARENT_ID, "Users", sFULL_NAME, sEMAIL1, sSEND_TYPE);
											lstRECIPIENTS.Add(r);
										}
									}
									// 10/29/2023 Paul.  Generate exception if no recipients found. 
									if ( !bRecipientAdded )
									{
										throw(new Exception("WF4AlertActivity: " + sRECIPIENT_TYPE + " " + gRECIPIENT_ID.ToString() + " does not have a valid EMAIL1"));
									}
								}
							}
							break;
						}
						default:
						{
							if ( !Sql.IsEmptyString(sRECIPIENT_TABLE) && !Sql.IsEmptyString(sRECIPIENT_FIELD) )
							{
								Guid   gID                  = Guid.Empty;
								Guid   gAUDIT_ID            = Guid.Empty;
								Guid   gPARENT_ID           = Guid.Empty;
								Guid   gACCOUNT_ID          = Guid.Empty;
								Guid   gCONTACT_ID          = Guid.Empty;
								// 06/08/2017 Paul.  Add BPMN support for Quotes, Orders and Invoices. 
								Guid   gBILLING_ACCOUNT_ID  = Guid.Empty;
								Guid   gBILLING_CONTACT_ID  = Guid.Empty;
								Guid   gSHIPPING_ACCOUNT_ID = Guid.Empty;
								Guid   gSHIPPING_CONTACT_ID = Guid.Empty;
								Guid   gLEAD_ID             = Guid.Empty;
								Guid   gASSIGNED_USER_ID    = Guid.Empty;
								Guid   gCREATED_BY_ID       = Guid.Empty;
								// 04/19/2018 Paul.  MODIFIED_BY_ID is not the correct name, use MODIFIED_USER_ID instead. 
								Guid   gMODIFIED_USER_ID    = Guid.Empty;
								Guid   gTEAM_ID             = Guid.Empty;
								string sFULL_NAME           = String.Empty;
								string sEMAIL1              = String.Empty;
								string sEMAIL2              = String.Empty;
								
								System.Text.RegularExpressions.Regex reg = new System.Text.RegularExpressions.Regex(@"[^A-Za-z0-9_]");
								sRECIPIENT_TABLE = reg.Replace(sRECIPIENT_TABLE, "");
								sRECIPIENT_FIELD = reg.Replace(sRECIPIENT_FIELD, "");
								string sRecipientType = sRECIPIENT_TABLE;
								if ( sRECIPIENT_TABLE.EndsWith("_AUDIT") )
									sRecipientType = sRECIPIENT_TABLE.Substring(sRECIPIENT_TABLE.Length - 6);
								
								// 11/12/2016 Paul.  We can't use the static values because they may change. 
								WorkflowDataContext dc = context.DataContext;
								PropertyDescriptorCollection properties = dc.GetProperties();
								foreach ( PropertyDescriptor property in dc.GetProperties() )
								{
									switch ( property.Name )
									{
										case "ID"      :  gID       = Sql.ToGuid(property.GetValue(dc));  break;
										case "AUDIT_ID":  gAUDIT_ID = Sql.ToGuid(property.GetValue(dc));  break;
									}
								}
								// 11/12/2016 Paul.  sRECIPIENT_TABLE will already be set to the module table or the audit table. 
								if ( sRECIPIENT_TABLE.EndsWith("_AUDIT") )
								{
									sSQL = "select *       " + ControlChars.CrLf
									     + "  from vw" + sRECIPIENT_TABLE + ControlChars.CrLf
									     + " where AUDIT_ID = @ID" + ControlChars.CrLf;
								}
								else
								{
									sSQL = "select *       " + ControlChars.CrLf
									     + "  from vw" + sRECIPIENT_TABLE + ControlChars.CrLf
									     + " where ID = @ID" + ControlChars.CrLf;
								}
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									if ( sRECIPIENT_TABLE.EndsWith("_AUDIT") )
										Sql.AddParameter(cmd, "@ID", gAUDIT_ID);
									else
										Sql.AddParameter(cmd, "@ID", gID);
									using ( DbDataAdapter da = dbf.CreateDataAdapter() )
									{
										((IDbDataAdapter)da).SelectCommand = cmd;
										using ( DataTable dt = new DataTable() )
										{
											da.Fill(dt);
											if ( dt.Rows.Count > 0 )
											{
												DataRow row = dt.Rows[0];
												foreach ( DataColumn col in dt.Columns )
												{
													switch ( col.ColumnName )
													{
														case "PARENT_ID"          :  gPARENT_ID           = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "ACCOUNT_ID"         :  gACCOUNT_ID          = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "CONTACT_ID"         :  gCONTACT_ID          = Sql.ToGuid  (row[col.ColumnName]);  break;
														// 06/08/2017 Paul.  Add BPMN support for Quotes, Orders and Invoices. 
														case "BILLING_ACCOUNT_ID" :  gBILLING_ACCOUNT_ID  = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "BILLING_CONTACT_ID" :  gBILLING_CONTACT_ID  = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "SHIPPING_ACCOUNT_ID":  gSHIPPING_ACCOUNT_ID = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "SHIPPING_CONTACT_ID":  gSHIPPING_CONTACT_ID = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "LEAD_ID"            :  gLEAD_ID             = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "ASSIGNED_USER_ID"   :  gASSIGNED_USER_ID    = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "CREATED_BY_ID"      :  gCREATED_BY_ID       = Sql.ToGuid  (row[col.ColumnName]);  break;
														// 04/19/2018 Paul.  MODIFIED_BY_ID is not the correct name, use MODIFIED_USER_ID instead. 
														case "MODIFIED_USER_ID"   :  gMODIFIED_USER_ID    = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "TEAM_ID"            :  gTEAM_ID             = Sql.ToGuid  (row[col.ColumnName]);  break;
														case "NAME"               :  sFULL_NAME           = Sql.ToString(row[col.ColumnName]);  break;
														case "EMAIL1"             :  sEMAIL1              = Sql.ToString(row[col.ColumnName]);  break;
														case "EMAIL2"             :  sEMAIL2              = Sql.ToString(row[col.ColumnName]);  break;
													}
												}
											}
										}
									}
								}
								
								if ( sRECIPIENT_FIELD == "TEAM_ID" )
								{
									sSQL = "select USER_ID                " + ControlChars.CrLf
									     + "     , FULL_NAME              " + ControlChars.CrLf
									     + "     , EMAIL1                 " + ControlChars.CrLf
									     + "  from vwTEAM_MEMBERSHIPS_List" + ControlChars.CrLf
									     + " where TEAM_ID = @TEAM_ID     " + ControlChars.CrLf
									     + "   and EMAIL1 is not null     " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@TEAM_ID", gRECIPIENT_ID);
										using ( IDataReader rdr = cmd.ExecuteReader() )
										{
											// 01/19/2010 Paul.  We need to use a while loop to send to all team members. 
											while ( rdr.Read() )
											{
												gPARENT_ID = Sql.ToGuid  (rdr["USER_ID"  ]);
												sFULL_NAME = Sql.ToString(rdr["FULL_NAME"]);
												sEMAIL1    = Sql.ToString(rdr["EMAIL1"   ]);
												if ( EmailUtils.IsValidEmail(sEMAIL1) )
												{
													AlertRecipient r = new AlertRecipient(gPARENT_ID, "Users", sFULL_NAME, sEMAIL1, sSEND_TYPE);
													lstRECIPIENTS.Add(r);
												}
											}
										}
									}
								}
								// 12/26/2017 Paul.  Add ASSIGNED_SET_ID and TEAM_SET_ID. 
								else if ( !Sql.IsEmptyGuid(gRECIPIENT_ID) && sRECIPIENT_FIELD == "TEAM_SET_ID" )
								{
									sSQL = "select vwTEAM_MEMBERSHIPS_List.USER_ID                " + ControlChars.CrLf
									     + "     , vwTEAM_MEMBERSHIPS_List.FULL_NAME              " + ControlChars.CrLf
									     + "     , vwTEAM_MEMBERSHIPS_List.EMAIL1                 " + ControlChars.CrLf
									     + "  from      vwTEAM_SETS_TEAMS                         " + ControlChars.CrLf
									     + " inner join vwTEAM_MEMBERSHIPS_List                   " + ControlChars.CrLf
									     + "         on vwTEAM_MEMBERSHIPS_List.TEAM_ID = vwTEAM_SETS_TEAMS.TEAM_ID" + ControlChars.CrLf
									     + "        and vwTEAM_MEMBERSHIPS_List.EMAIL1 is not null" + ControlChars.CrLf
									     + " where vwTEAM_SETS_TEAMS.ID = @TEAM_SET_ID            " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@TEAM_SET_ID", gRECIPIENT_ID);
										using ( IDataReader rdr = cmd.ExecuteReader() )
										{
											while ( rdr.Read() )
											{
												gPARENT_ID = Sql.ToGuid  (rdr["USER_ID"  ]);
												sFULL_NAME = Sql.ToString(rdr["FULL_NAME"]);
												sEMAIL1    = Sql.ToString(rdr["EMAIL1"   ]);
												if ( EmailUtils.IsValidEmail(sEMAIL1) )
												{
													AlertRecipient r = new AlertRecipient(gPARENT_ID, "Users", sFULL_NAME, sEMAIL1, sSEND_TYPE);
													lstRECIPIENTS.Add(r);
												}
											}
										}
									}
								}
								// 04/19/2018 Paul.  MODIFIED_BY_ID is not the correct name, use MODIFIED_USER_ID instead. 
								else if ( sRECIPIENT_FIELD == "ASSIGNED_USER_ID" || sRECIPIENT_FIELD == "CREATED_BY_ID" || sRECIPIENT_FIELD == "MODIFIED_USER_ID" )
								{
									sSQL = "select ID                " + ControlChars.CrLf
									     + "     , FULL_NAME         " + ControlChars.CrLf
									     + "     , EMAIL1            " + ControlChars.CrLf
									     + "  from vwUSERS           " + ControlChars.CrLf
									     + " where ID = @ID          " + ControlChars.CrLf
									     + "   and EMAIL1 is not null" + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										switch ( sRECIPIENT_FIELD )
										{
											case "ASSIGNED_USER_ID":  Sql.AddParameter(cmd, "@ID", gASSIGNED_USER_ID);  break;
											case "CREATED_BY_ID"   :  Sql.AddParameter(cmd, "@ID", gCREATED_BY_ID   );  break;
											// 04/19/2018 Paul.  MODIFIED_BY_ID is not the correct name, use MODIFIED_USER_ID instead. 
											case "MODIFIED_USER_ID":  Sql.AddParameter(cmd, "@ID", gMODIFIED_USER_ID);  break;
										}
										using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
										{
											if ( rdr.Read() )
											{
												gPARENT_ID = Sql.ToGuid  (rdr["ID"       ]);
												sFULL_NAME = Sql.ToString(rdr["FULL_NAME"]);
												sEMAIL1    = Sql.ToString(rdr["EMAIL1"   ]);
												if ( EmailUtils.IsValidEmail(sEMAIL1) )
												{
													AlertRecipient r = new AlertRecipient(gPARENT_ID, "Users", sFULL_NAME, sEMAIL1, sSEND_TYPE);
													lstRECIPIENTS.Add(r);
												}
											}
										}
									}
								}
								// 12/26/2017 Paul.  Add ASSIGNED_SET_ID and TEAM_SET_ID. 
								else if ( !Sql.IsEmptyGuid(gRECIPIENT_ID) && sRECIPIENT_FIELD == "ASSIGNED_SET_ID" )
								{
									sSQL = "select vwUSERS.ID                                     " + ControlChars.CrLf
									     + "     , vwUSERS.FULL_NAME                              " + ControlChars.CrLf
									     + "     , vwUSERS.EMAIL1                                 " + ControlChars.CrLf
									     + "  from      vwASSIGNED_SETS_USERS                     " + ControlChars.CrLf
									     + " inner join vwUSERS                                   " + ControlChars.CrLf
									     + "         on vwUSERS.ID = vwASSIGNED_SETS_USERS.USER_ID" + ControlChars.CrLf
									     + "        and vwUSERS.EMAIL1 is not null                " + ControlChars.CrLf
									     + " where vwASSIGNED_SETS_USERS.ID = @ASSIGNED_SET_ID    " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@ASSIGNED_SET_ID", gRECIPIENT_ID);
										using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
										{
											if ( rdr.Read() )
											{
												gPARENT_ID = Sql.ToGuid  (rdr["ID"       ]);
												sFULL_NAME = Sql.ToString(rdr["FULL_NAME"]);
												sEMAIL1    = Sql.ToString(rdr["EMAIL1"   ]);
												if ( EmailUtils.IsValidEmail(sEMAIL1) )
												{
													AlertRecipient r = new AlertRecipient(gPARENT_ID, "Users", sFULL_NAME, sEMAIL1, sSEND_TYPE);
													lstRECIPIENTS.Add(r);
												}
											}
										}
									}
								}
								// 06/08/2017 Paul.  Add BPMN support for Quotes, Orders and Invoices. 
								else if ( sRECIPIENT_FIELD == "PARENT_ID" 
								       || sRECIPIENT_FIELD == "ACCOUNT_ID" 
								       || sRECIPIENT_FIELD == "CONTACT_ID" 
								       || sRECIPIENT_FIELD == "BILLING_ACCOUNT_ID" 
								       || sRECIPIENT_FIELD == "BILLING_CONTACT_ID" 
								       || sRECIPIENT_FIELD == "SHIPPING_ACCOUNT_ID" 
								       || sRECIPIENT_FIELD == "SHIPPING_CONTACT_ID" 
								       || sRECIPIENT_FIELD == "LEAD_ID" 
								       )
								{
									sSQL = "select PARENT_ID              " + ControlChars.CrLf
									     + "     , PARENT_TYPE            " + ControlChars.CrLf
									     + "     , PARENT_NAME            " + ControlChars.CrLf
									     + "     , EMAIL1                 " + ControlChars.CrLf
									     + "  from vwPARENTS_EMAIL_ADDRESS" + ControlChars.CrLf
									     + " where PARENT_ID = @PARENT_ID " + ControlChars.CrLf
									     + "   and EMAIL1 is not null     " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										switch ( sRECIPIENT_FIELD )
										{
											case "PARENT_ID"          :  Sql.AddParameter(cmd, "@PARENT_ID", gPARENT_ID          );  break;
											case "ACCOUNT_ID"         :  Sql.AddParameter(cmd, "@PARENT_ID", gACCOUNT_ID         );  break;
											case "CONTACT_ID"         :  Sql.AddParameter(cmd, "@PARENT_ID", gCONTACT_ID         );  break;
											// 06/08/2017 Paul.  Add BPMN support for Quotes, Orders and Invoices. 
											case "BILLING_ACCOUNT_ID" :  Sql.AddParameter(cmd, "@PARENT_ID", gBILLING_ACCOUNT_ID );  break;
											case "BILLING_CONTACT_ID" :  Sql.AddParameter(cmd, "@PARENT_ID", gBILLING_CONTACT_ID );  break;
											case "SHIPPING_ACCOUNT_ID":  Sql.AddParameter(cmd, "@PARENT_ID", gSHIPPING_ACCOUNT_ID);  break;
											case "SHIPPING_CONTACT_ID":  Sql.AddParameter(cmd, "@PARENT_ID", gSHIPPING_CONTACT_ID);  break;
											case "LEAD_ID"            :  Sql.AddParameter(cmd, "@PARENT_ID", gLEAD_ID            );  break;
										}
										using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
										{
											if ( rdr.Read() )
											{
												sRecipientType = Sql.ToString(rdr["PARENT_TYPE"]);
												sFULL_NAME     = Sql.ToString(rdr["PARENT_NAME"]);
												sEMAIL1        = Sql.ToString(rdr["EMAIL1"     ]);
												if ( EmailUtils.IsValidEmail(sEMAIL1) )
												{
													AlertRecipient r = new AlertRecipient(gPARENT_ID, sRecipientType, sFULL_NAME, sEMAIL1, sSEND_TYPE);
													lstRECIPIENTS.Add(r);
												}
											}
										}
									}
								}
								else if ( sRECIPIENT_FIELD == "ID" || sRECIPIENT_FIELD == "EMAIL1" )
								{
									if ( EmailUtils.IsValidEmail(sEMAIL1) )
									{
										AlertRecipient r = new AlertRecipient(gID, sRecipientType, sFULL_NAME, sEMAIL1, sSEND_TYPE);
										lstRECIPIENTS.Add(r);
									}
								}
								else if ( sRECIPIENT_FIELD == "EMAIL2" )
								{
									if ( EmailUtils.IsValidEmail(sEMAIL2) )
									{
										AlertRecipient r = new AlertRecipient(gID, sRecipientType, sFULL_NAME, sEMAIL2, sSEND_TYPE);
										lstRECIPIENTS.Add(r);
									}
								}
							}
							break;
						}
					}
				}
			}
			return lstRECIPIENTS;
		}

		public List<AlertAttachment> BuildReportAttachments(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			SplendidCRM.TimeZone  TimeZone              = new SplendidCRM.TimeZone();
			SplendidDefaults      SplendidDefaults      = new SplendidDefaults();
			IWebHostEnvironment   hostingEnvironment    = app.hostingEnvironment;
			HttpSessionState      Session               = app.Session              ;
			Security              Security              = app.Security             ;
			SplendidError         SplendidError         = app.SplendidError        ;
			SplendidCache         SplendidCache         = app.SplendidCache        ;
			XmlUtil               XmlUtil               = app.XmlUtil              ;
			ReportsAttachmentView ReportsAttachmentView = app.ReportsAttachmentView;

			List<AlertAttachment> lstATTACHMENTS = new List<AlertAttachment>();
			SplendidCRM.TimeZone T10n = TimeZone.CreateTimeZone(Guid.Empty);
			// 12/04/2010 Paul.  L10n is needed by the Rules Engine to allow translation of list terms. 
			L10N L10n = new L10N(SplendidDefaults.Culture());
			foreach ( WF4Report wf4Report in context.GetValue<ICollection<WF4Report>>(REPORTS) )
			{
				Guid   gREPORT_ID                      = wf4Report.REPORT_ID        ;
				string sREPORT_NAME                    = wf4Report.REPORT_NAME      ;
				string sRENDER_FORMAT                  = wf4Report.RENDER_FORMAT    ;
				Guid   gSCHEDULED_USER_ID              = wf4Report.SCHEDULED_USER_ID;
				List<WF4ReportParameter> lstPARAMETERS = wf4Report.PARAMETERS       ;
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL ;
					sSQL = "select *             " + ControlChars.CrLf
					     + "  from vwREPORTS_Edit" + ControlChars.CrLf
					     + " where ID = @ID      " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@ID", gREPORT_ID);
						// 11/19/2023 Paul.  Connection already open. 
						//con.Open();
						
						using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
						{
							if ( rdr.Read() )
							{
								string sRDL         = Sql.ToString(rdr["RDL"        ]);
								string sMODULE_NAME = Sql.ToString(rdr["MODULE_NAME"]);
								string sFILENAME    = Sql.ToString(rdr["NAME"       ]);
								if ( !Sql.IsEmptyString(sRDL) )
								{
									switch ( sRENDER_FORMAT.ToUpper() )
									{
										// 05/13/2014 Paul.  Word format is supported by ReportViewer 2012. 
										// http://msdn.microsoft.com/en-us/library/ms251671(v=vs.110).aspx
										// 09/13/2016 Paul.  Possible render formats "Excel" "EXCELOPENXML" "IMAGE" "PDF" "WORD" "WORDOPENXML". 
										// http://stackoverflow.com/questions/3494009/creating-a-custom-export-to-excel-for-reportviewer-rdlc
										// 05/07/2018 Paul.  Include all possible values. 
										case "WORD"        :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
										case "WORDOPENXML" :  sRENDER_FORMAT = "WORDOPENXML" ;  break;
										case "EXCEL"       :  sRENDER_FORMAT = "EXCELOPENXML";  break;
										case "EXCELOPENXML":  sRENDER_FORMAT = "EXCELOPENXML";  break;
										case "IMAGE"       :  sRENDER_FORMAT = "Image"       ;  break;
										case "PDF"         :  sRENDER_FORMAT = "PDF"         ;  break;
										default            :  sRENDER_FORMAT = "PDF"         ;  break;
									}

									// 07/13/2010 Paul.  If the paramters exist, then insert them directly into the RDL. 
									// Since the parameters use the URL syntax, it is important that any bindings get escaped. 
									if ( lstPARAMETERS.Count > 0 )
									{
										RdlDocument rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
										rdl.LoadRdl(sRDL);
										
										Hashtable hashParameters = new Hashtable();
										foreach ( WF4ReportParameter parameter in lstPARAMETERS )
										{
											string sParameterName  = parameter.NAME.ToUpper();
											string sParameterValue = parameter.VALUE;
											// 07/13/2010 Paul.  We only need to set the value if there is a value and if it does not already exist. 
											if ( !Sql.IsEmptyString(sParameterValue) && !hashParameters.ContainsKey(sParameterName) )
												hashParameters.Add(sParameterName, sParameterValue);
										}
										XmlNodeList nlReportParameters = rdl.SelectNodesNS("ReportParameters/ReportParameter");
										foreach ( XmlNode xReportParameter in nlReportParameters )
										{
											string sName  = xReportParameter.Attributes.GetNamedItem("Name").Value.ToUpper();
											string sValue = String.Empty;
											if ( hashParameters.ContainsKey(sName) )
											{
												sValue = Sql.ToString(hashParameters[sName]);
											}
											rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
										}
										sRDL = rdl.OuterXml;
									}
									// 12/04/2010 Paul.  L10n is needed by the Rules Engine to allow translation of list terms. 
									// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
									// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
									
									Task<AttachmentData> task = Task.Run(async () =>
									{
										return await ReportsAttachmentView.Render(L10n, T10n, gREPORT_ID, sRDL, sRENDER_FORMAT, sMODULE_NAME, gSCHEDULED_USER_ID);
									});
									AttachmentData data = task.Result;
									byte[] byContent       = data.byContent      ;
									string sFILE_MIME_TYPE = data.sFILE_MIME_TYPE;
									string sFILE_EXT       = data.sFILE_EXT      ;
									// 05/11/2010 Paul.  Include the extension in the file name so that it will appear in emails.
									sFILENAME += "." + sFILE_EXT;
									AlertAttachment a = new AlertAttachment(sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, byContent);
									lstATTACHMENTS.Add(a);
								}
							}
						}
					}
				}
			}
			return lstATTACHMENTS;
		}

		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			HttpApplicationState Application         = new HttpApplicationState();
			Crm.Config           Config              = new SplendidCRM.Crm.Config();
			IMemoryCache         memoryCache         = app.memoryCache    ;
			Security             Security            = app.Security       ;
			Sql                  Sql                 = app.Sql            ;
			SqlProcs             SqlProcs            = app.SqlProcs       ;
			SplendidError        SplendidError       = app.SplendidError  ;
			SplendidCache        SplendidCache       = app.SplendidCache  ;
			EmailUtils           EmailUtils          = app.EmailUtils     ;
			Crm.NoteAttachments  NoteAttachments     = app.NoteAttachments;
			Office365Sync        Office365Sync       = app.Office365Sync  ;
			ExchangeUtils        ExchangeUtils       = app.ExchangeUtils  ;
			GoogleApps           GoogleApps          = app.GoogleApps     ;

			try
			{
				Guid   gWORKFLOW_ID          = Guid.Empty;
				Guid   gBUSINESS_PROCESS_ID  = Guid.Empty;
				Guid   gAUDIT_ID             = Guid.Empty;
				string sPARENT_TYPE          = context.GetValue<string>(PARENT_TYPE         );
				Guid   gPARENT_ID            = context.GetValue<Guid  >(PARENT_ID           );
				string sFROM_NAME            = context.GetValue<string>(FROM_NAME           );
				string sFROM_ADDRESS         = context.GetValue<string>(FROM_ADDRESS        );
				string sALERT_TYPE           = context.GetValue<string>(ALERT_TYPE          );
				string sSOURCE_TYPE          = context.GetValue<string>(SOURCE_TYPE         );
				string sALERT_SUBJECT        = context.GetValue<string>(ALERT_SUBJECT       );
				string sALERT_TEXT           = context.GetValue<string>(ALERT_TEXT          );
				Guid   gCUSTOM_TEMPLATE_ID   = context.GetValue<Guid  >(CUSTOM_TEMPLATE_ID  );
				Guid   gASSIGNED_USER_ID     = context.GetValue<Guid  >(ASSIGNED_USER_ID    );
				Guid   gTEAM_ID              = context.GetValue<Guid  >(TEAM_ID             );
				string sTEAM_SET_LIST        = context.GetValue<string>(TEAM_SET_LIST       );
				
				// 09/28/2016 Paul.  We need to escape curly brackets as they are a XAML primative. 
				// Character ':' was unexpected in string '::future::Orders::name::'. Invalid XAML type name. 
				// https://msdn.microsoft.com/en-us/library/ms744986.aspx
				// 09/28/2016 Paul.  We do not need to manually remove as WF4 will remove it for us. 
				//if ( sALERT_SUBJECT.StartsWith("{}") )
				//	sALERT_SUBJECT = sALERT_SUBJECT.Substring(2);
				//if ( sALERT_TEXT.StartsWith("{}") )
				//	sALERT_TEXT = "{}" + sALERT_TEXT.Substring(2);
				
				WorkflowDataContext dc = context.DataContext;
				PropertyDescriptorCollection properties = dc.GetProperties();
				foreach ( PropertyDescriptor property in dc.GetProperties() )
				{
					// 11/19/2023 Paul.  WF3 to WF4 will have WORKFLOW_ID instead of BUSINESS_PROCESS_ID. 
					if ( property.Name == "WORKFLOW_ID" )
					{
						gWORKFLOW_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "BUSINESS_PROCESS_ID" )
					{
						gBUSINESS_PROCESS_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "AUDIT_ID" )
					{
						gAUDIT_ID = Sql.ToGuid(property.GetValue(dc));
					}
				}
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				List<AlertRecipient>  lstRECIPIENTS  = BuildRecipients(context);
				List<AlertAttachment> lstREPORT_ATTACHMENTS = BuildReportAttachments(context);
				if ( lstRECIPIENTS.Count > 0 )
				{
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						// 11/25/2008 Paul.  Before loading past and future values, first determine if they are necessary. 
						// 08/13/2016 Paul.  Values from WF4 Activity might be NULL. 
						string sFromName     = Sql.ToString(sFROM_NAME    );
						string sFromAddress  = Sql.ToString(sFROM_ADDRESS );
						string sSubject      = Sql.ToString(sALERT_SUBJECT);
						string sBodyHtml     = Sql.ToString(sALERT_TEXT   );
						sBodyHtml = sBodyHtml.Replace(ControlChars.CrLf, "<br />" + ControlChars.CrLf);
						sBodyHtml = sBodyHtml.Replace("\n", "<br />" + ControlChars.CrLf);
						DataTable dtTemplateAttachments = null;
						if ( sSOURCE_TYPE == "custom template" && !Sql.IsEmptyGuid(gCUSTOM_TEMPLATE_ID) )
						{
							string sSQL = String.Empty;
							sSQL = "select FROM_ADDR                 " + ControlChars.CrLf
							     + "     , FROM_NAME                 " + ControlChars.CrLf
							     + "     , SUBJECT                   " + ControlChars.CrLf
							     + "     , BODY_HTML                 " + ControlChars.CrLf
							     + "  from vwWORKFLOW_ALERT_TEMPLATES" + ControlChars.CrLf
							     + " where ID = @ID                  " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gCUSTOM_TEMPLATE_ID);
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									if ( rdr.Read() )
									{
										// 11/25/2008 Paul.  The template from address can over-ride the workflow values. 
										sFromName    = Sql.ToString(rdr["FROM_NAME"]);
										sFromAddress = Sql.ToString(rdr["FROM_ADDR"]);
										sSubject     = Sql.ToString(rdr["SUBJECT"  ]);
										sBodyHtml    = Sql.ToString(rdr["BODY_HTML"]);
									}
								}
							}
							// 06/16/2010 Paul.  Add support for Workflow Alert Template Attachments. 
							// 06/16/2010 Paul.  Use the same EmailTemplates parent type. 
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								sSQL = "select *                                     " + ControlChars.CrLf
								     + "  from vwEMAIL_TEMPLATES_Attachments         " + ControlChars.CrLf
								     + " where EMAIL_TEMPLATE_ID = @EMAIL_TEMPLATE_ID" + ControlChars.CrLf;
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@EMAIL_TEMPLATE_ID", gCUSTOM_TEMPLATE_ID);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									dtTemplateAttachments = new DataTable();
									da.Fill(dtTemplateAttachments);
								}
							}
						}
						// 12/04/2008 Paul.  Only use config settings if not provided in XOML and not provided in alert template. 
						if ( Sql.IsEmptyString(sFromAddress) )
						{
							sFromName    = Sql.ToString(app.Application["CONFIG.fromname"    ]);
							sFromAddress = Sql.ToString(app.Application["CONFIG.fromaddress" ]);
						}

						string sSiteURL = Config.SiteURL();
						//string sViewURL = sSiteURL + PARENT_TYPE + "/view.aspx?ID=";
						//string sEditURL = sSiteURL + PARENT_TYPE + "/edit.aspx?ID=";
						//string sListURL = sSiteURL + PARENT_TYPE + "/default.aspx" ;

						bool bLoadPastValues      = false;
						bool bLoadFutureValues    = false;
						bool bLoadPastRelValues   = false;
						bool bLoadFutureRelValues = false;
						StringCollection arrRelationships  = new StringCollection();
						Hashtable hashInsertionStrings     = new Hashtable();
						Hashtable hashRelationshipsStrings = new Hashtable();
						int nInsertionStart = sSubject.IndexOf("{::");
						while ( nInsertionStart >= 0 && nInsertionStart < sSubject.Length )
						{
							nInsertionStart += 3;
							int nInsertionEnd = sSubject.IndexOf("::}", nInsertionStart);
							if ( nInsertionEnd > nInsertionStart )
							{
								string sInsertion = sSubject.Substring(nInsertionStart, nInsertionEnd - nInsertionStart);
								if ( !Sql.IsEmptyString(sInsertion) )
								{
									if ( !hashInsertionStrings.ContainsKey(sInsertion) )
									{
										string[] arrInsertionParts = Strings.Split(sInsertion, "::", -1, CompareMethod.Text);
										if ( arrInsertionParts.Length == 3 )
										{
											// 11/25/2008 Paul.  Regular insertions will have 3 parts. 
											// {::href_link::Accounts::href_link::}
											// {::past::Accounts::id::}
											// {::future::Accounts::id::}
											hashInsertionStrings.Add(sInsertion, null);
											if ( String.Compare(arrInsertionParts[0], "href_link", true) == 0 )
												bLoadFutureValues = true;
											else if ( String.Compare(arrInsertionParts[0], "past", true) == 0 )
												bLoadPastValues = true;
											else if ( String.Compare(arrInsertionParts[0], "future", true) == 0 )
												bLoadFutureValues = true;
										}
										else if ( arrInsertionParts.Length == 4 )
										{
											// 11/25/2008 Paul.  Relationships will have 4 parts. 
											// {::href_link::Accounts::Bugs::href_link::}
											// {::past::Accounts::Bugs::id::}
											// {::future::Accounts::Bugs::id::}
											hashRelationshipsStrings.Add(sInsertion, null);
											if ( !arrRelationships.Contains(arrInsertionParts[2]) )
											{
												arrRelationships.Add(arrInsertionParts[2]);
											}
											if ( String.Compare(arrInsertionParts[0], "href_link", true) == 0 )
												bLoadFutureRelValues = true;
											else if ( String.Compare(arrInsertionParts[0], "past", true) == 0 )
												bLoadPastRelValues = true;
											else if ( String.Compare(arrInsertionParts[0], "future", true) == 0 )
												bLoadFutureRelValues = true;
										}
									}
								}
								nInsertionStart = nInsertionEnd + 3;
							}
							nInsertionStart = sSubject.IndexOf("{::", nInsertionStart);
						}
						nInsertionStart =  sBodyHtml.IndexOf("{::");
						while ( nInsertionStart >= 0 && nInsertionStart < sBodyHtml.Length )
						{
							nInsertionStart += 3;
							int nInsertionEnd = sBodyHtml.IndexOf("::}", nInsertionStart);
							if ( nInsertionEnd > nInsertionStart )
							{
								string sInsertion = sBodyHtml.Substring(nInsertionStart, nInsertionEnd - nInsertionStart);
								if ( !Sql.IsEmptyString(sInsertion) )
								{
									if ( !hashInsertionStrings.ContainsKey(sInsertion) )
									{
										string[] arrInsertionParts = Strings.Split(sInsertion, "::", -1, CompareMethod.Text);
										if ( arrInsertionParts.Length == 3 )
										{
											// 11/25/2008 Paul.  Regular insertions will have 3 parts. 
											// {::href_link::Accounts::href_link::}
											// {::past::Accounts::id::}
											// {::future::Accounts::id::}
											hashInsertionStrings.Add(sInsertion, null);
											if ( String.Compare(arrInsertionParts[0], "href_link", true) == 0 )
												bLoadFutureValues = true;
											else if ( String.Compare(arrInsertionParts[0], "past", true) == 0 )
												bLoadPastValues = true;
											else if ( String.Compare(arrInsertionParts[0], "future", true) == 0 )
												bLoadFutureValues = true;
										}
										else if ( arrInsertionParts.Length == 4 )
										{
											// 11/25/2008 Paul.  Relationships will have 4 parts. 
											// {::href_link::Accounts::Bugs::href_link::}
											// {::past::Accounts::Bugs::id::}
											// {::future::Accounts::Bugs::id::}
											hashRelationshipsStrings.Add(sInsertion, null);
											if ( !arrRelationships.Contains(arrInsertionParts[2]) )
											{
												arrRelationships.Add(arrInsertionParts[2]);
											}
											if ( String.Compare(arrInsertionParts[0], "href_link", true) == 0 )
												bLoadFutureRelValues = true;
											else if ( String.Compare(arrInsertionParts[0], "past", true) == 0 )
												bLoadPastRelValues = true;
											else if ( String.Compare(arrInsertionParts[0], "future", true) == 0 )
												bLoadFutureRelValues = true;
										}
									}
								}
								nInsertionStart = nInsertionEnd + 3;
							}
							nInsertionStart = sBodyHtml.IndexOf("{::", nInsertionStart);
						}

						string sMODULE_NAME  = sPARENT_TYPE;
						string sMODULE_TABLE = Sql.ToString(app.Application["Modules." + sPARENT_TYPE + ".TableName"]);
						if ( !Sql.IsEmptyString(sMODULE_TABLE) )
						{
							DataView vwColumns = new DataView(SplendidCache.WorkflowFilterColumns( sMODULE_TABLE));
							// 11/25/2008 Paul.  First try and load the values from the current audit record. 
							if ( !Sql.IsEmptyGuid(gPARENT_ID) && !Sql.IsEmptyGuid(gAUDIT_ID) )
							{
								if ( bLoadFutureValues )
								{
									string sSQL = String.Empty;
									// 06/09/2009 Paul.  The base view has relationship fields that we may need to access, such as Shipper Account Name. 
									// While it may make sense not to use the audit table at all, we will continue to do so as the audit record is the most accurate. 
									// It is possible that the main record has changed before the workflow runs. 
									sSQL = "select *                            " + ControlChars.CrLf
									     + "  from vw" + sMODULE_TABLE            + ControlChars.CrLf
									     + " where ID       = @ID               " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@ID"      , gPARENT_ID);
										using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
										{
											if ( rdr.Read() )
											{
												for ( int i = 0; i < rdr.FieldCount; i++ )
												{
													string sFieldName = rdr.GetName(i);
													object oValue = !rdr.IsDBNull(i) ? rdr.GetValue(i) : String.Empty;
													AddInsertionValues(app, hashInsertionStrings, sFieldName, oValue, "future", sMODULE_NAME, String.Empty, vwColumns, sSiteURL);
												}
											}
										}
									}

									sSQL = "select *                            " + ControlChars.CrLf
									     + "  from vw" + sMODULE_TABLE + "_AUDIT" + ControlChars.CrLf
									     + " where ID       = @ID               " + ControlChars.CrLf
									     + "   and AUDIT_ID = @AUDIT_ID         " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@ID"      , gPARENT_ID);
										Sql.AddParameter(cmd, "@AUDIT_ID", gAUDIT_ID );
										using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
										{
											if ( rdr.Read() )
											{
												for ( int i = 0; i < rdr.FieldCount; i++ )
												{
													string sFieldName = rdr.GetName(i);
													object oValue = !rdr.IsDBNull(i) ? rdr.GetValue(i) : String.Empty;
													AddInsertionValues(app, hashInsertionStrings, sFieldName, oValue, "future", sMODULE_NAME, String.Empty, vwColumns, sSiteURL);
												}
											}
										}
									}
								}
							}
							/*
							else if ( !Sql.IsEmptyString(PARENT_ACTIVITY) )
							{
								// 10/04/2008 Paul.  Use reflection to get the parent values as the Workflow engine does not appear to provide a solution. 
								// 11/25/2008 Paul.  If we do not have an audit ID, then use the parent activity. 
								// It may not make sense to conitnue to load values from the activity, but lets keep the code anyway. 
								Activity act = this.Parent.GetActivityByName(PARENT_ACTIVITY);
								if ( act != null )
								{
									PropertyInfo[] pis = act.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.GetProperty);
									foreach ( PropertyInfo pi in pis )
									{
										// 10/06/2008 Paul.  Table fields will be in all upper case. 
										if ( pi.Name == pi.Name.ToUpper() )
										{
											// 11/09/2010 Paul.  Should convert to GetValue, but then we would need to retest.
											// object oValue = pi.GetValue(act, null);
											object oValue = pi.GetGetMethod().Invoke(act, null);
											// 11/16/2008 Paul.  The field might not be found, possibly a custom field. 
											if ( oValue != null )
											{
												string sFieldName = pi.Name;
												AddInsertionValues(app, hashInsertionStrings, sFieldName, oValue, "future", sMODULE_NAME, String.Empty, vwColumns, sSiteURL);
												// 11/19/2008 Paul.  Just in case the parent ID has not been set, grab it from the parent activity. 
												if ( pi.Name.ToUpper() == "ID" && Sql.IsEmptyGuid(gPARENT_ID) )
													PARENT_ID = Sql.ToGuid(oValue);
												if ( pi.Name.ToUpper() == "AUDIT_ID" && Sql.IsEmptyGuid(gAUDIT_ID) )
													AUDIT_ID = Sql.ToGuid(oValue);
											}
										}
									}
								}
							}
							*/
							// 11/25/2008 Paul.  Now try and load the past values. 
							if ( !Sql.IsEmptyGuid(gPARENT_ID) && !Sql.IsEmptyGuid(gAUDIT_ID) )
							{
								if ( bLoadPastValues )
								{
									// 12/03/2008 Paul.  When loading past values, make sure that the AUDIT_TOKEN does not match. 
									string sSQL = String.Empty;
									sSQL = "select *                                                  " + ControlChars.CrLf
									     + "  from vw" + sMODULE_TABLE + "_AUDIT                      " + ControlChars.CrLf
									     + " where ID            = @ID                                " + ControlChars.CrLf
									     + "   and AUDIT_VERSION = (select max(AUDIT_VERSION)         " + ControlChars.CrLf
									     + "                          from " + sMODULE_TABLE + "_AUDIT" + ControlChars.CrLf
									     + "                         where ID            = @ID        " + ControlChars.CrLf
									     + "                           and AUDIT_VERSION < (select AUDIT_VERSION              " + ControlChars.CrLf
									     + "                                                  from " + sMODULE_TABLE + "_AUDIT" + ControlChars.CrLf
									     + "                                                 where AUDIT_ID = @AUDIT_ID       " + ControlChars.CrLf
									     + "                                               )                                  " + ControlChars.CrLf
									     + "                           and AUDIT_TOKEN  <> (select AUDIT_TOKEN                " + ControlChars.CrLf
									     + "                                                  from " + sMODULE_TABLE + "_AUDIT" + ControlChars.CrLf
									     + "                                                 where AUDIT_ID = @AUDIT_ID       " + ControlChars.CrLf
									     + "                                               )                                  " + ControlChars.CrLf
									     + "                       )                                  " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										Sql.AddParameter(cmd, "@ID"      , gPARENT_ID);
										Sql.AddParameter(cmd, "@AUDIT_ID", gAUDIT_ID );
										using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
										{
											if ( rdr.Read() )
											{
												for ( int i = 0; i < rdr.FieldCount; i++ )
												{
													string sFieldName = rdr.GetName(i);
													object oValue = !rdr.IsDBNull(i) ? rdr.GetValue(i) : String.Empty;
													AddInsertionValues(app, hashInsertionStrings, sFieldName, oValue, "past", sMODULE_NAME, String.Empty, vwColumns, sSiteURL);
												}
											}
										}
									}
								}
							}
							if ( !Sql.IsEmptyGuid(gPARENT_ID) && hashRelationshipsStrings.Count > 0 )
							{
								DataView vwRelationships = new DataView(SplendidCache.ReportingRelationships());
								vwRelationships.RowFilter = "RELATIONSHIP_TYPE = \'one-to-many\' and (LHS_MODULE = \'" + sMODULE_NAME + "\' or RHS_MODULE = \'" + sMODULE_NAME + "\')";

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
									// 11/25/2008 Paul.  Be careful to only switch when necessary.  Parent accounts should not be switched. 
									if ( sLHS_MODULE != sMODULE_NAME && sRHS_MODULE == sMODULE_NAME )
									{
										sLHS_MODULE        = Sql.ToString(row["RHS_MODULE"       ]);
										sLHS_TABLE         = Sql.ToString(row["RHS_TABLE"        ]).ToUpper();
										sLHS_KEY           = Sql.ToString(row["RHS_KEY"          ]).ToUpper();
										sRHS_MODULE        = Sql.ToString(row["LHS_MODULE"       ]);
										sRHS_TABLE         = Sql.ToString(row["LHS_TABLE"        ]).ToUpper();
										sRHS_KEY           = Sql.ToString(row["LHS_KEY"          ]).ToUpper();
										sJOIN_TABLE        = Sql.ToString(row["JOIN_TABLE"       ]).ToUpper();
										sJOIN_KEY_LHS      = Sql.ToString(row["JOIN_KEY_RHS"     ]).ToUpper();
										sJOIN_KEY_RHS      = Sql.ToString(row["JOIN_KEY_LHS"     ]).ToUpper();
									}
									if ( arrRelationships.Contains(sRHS_MODULE) )
									{
										vwColumns = new DataView(SplendidCache.WorkflowFilterColumns(sRHS_TABLE));
										if ( bLoadFutureRelValues )
										{
											StringBuilder sb = new StringBuilder();
											sb.AppendLine("select " + sRHS_TABLE + ".*");
											sb.AppendLine("  from            vw" + sLHS_TABLE + " " + sLHS_TABLE);
											if ( Sql.IsEmptyString(sJOIN_TABLE) )
											{
												sb.AppendLine("       inner join vw" + sRHS_TABLE + " " + sRHS_TABLE);
												sb.AppendLine("               on "   + sRHS_TABLE + "." + sRHS_KEY  + " = " + sLHS_TABLE + "." + sLHS_KEY);
											}
											else
											{
												sb.AppendLine("       inner join vw" + sJOIN_TABLE + " " + sJOIN_TABLE);
												sb.AppendLine("               on "   + sJOIN_TABLE + "." + sJOIN_KEY_LHS + " = " + sLHS_TABLE  + "." + sLHS_KEY);
												// 10/31/2009 Paul.  The value should be escaped. 
												if ( !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN) && !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN_VALUE) )
													sb.AppendLine("              and "   + sJOIN_TABLE + "." + sRELATIONSHIP_ROLE_COLUMN + " = N'" + Sql.EscapeSQL(sRELATIONSHIP_ROLE_COLUMN_VALUE) + "'");
												sb.AppendLine("       inner join vw" + sRHS_TABLE + " " + sRHS_TABLE);
												sb.AppendLine("               on "   + sRHS_TABLE + "." + sRHS_KEY   + " = " + sJOIN_TABLE + "." + sJOIN_KEY_RHS);
											}
											// 07/13/2009 Paul.  The PARENT_ID is the primary key of the LHS table, not the LHS_KEY. 
											sb.AppendLine(" where " + sLHS_TABLE + ".ID = @ID");
											using ( IDbCommand cmd = con.CreateCommand() )
											{
												// 06/03/2009 Paul.  We switched to using a StringBuilder, but we did not stop using sSQL. 
												cmd.CommandText = sb.ToString();
												Sql.AddParameter(cmd, "@ID", gPARENT_ID);
												using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
												{
													if ( rdr.Read() )
													{
														for ( int i = 0; i < rdr.FieldCount; i++ )
														{
															string sFieldName = rdr.GetName(i);
															object oValue = !rdr.IsDBNull(i) ? rdr.GetValue(i) : String.Empty;
															AddInsertionValues(app, hashRelationshipsStrings, sFieldName, oValue, "future", sMODULE_NAME, sRHS_MODULE, vwColumns, sSiteURL);
														}
													}
												}
											}
										}
										else if ( bLoadPastRelValues && !Sql.IsEmptyGuid(gAUDIT_ID) )
										{
											// 11/26/2008 Paul.  Loading past relationship values is a bit more complicated 
											// in that we have to get the past values for the current module, then we join to get the relationship. 
											StringBuilder sb = new StringBuilder();
											sb.AppendLine("select " + sRHS_TABLE + ".*");
											sb.AppendLine("  from            vw" + sLHS_TABLE + "_AUDIT " + sLHS_TABLE);
											if ( Sql.IsEmptyString(sJOIN_TABLE) )
											{
												sb.AppendLine("       inner join vw" + sRHS_TABLE + " " + sRHS_TABLE);
												sb.AppendLine("               on "   + sRHS_TABLE + "." + sRHS_KEY   + " = " + sLHS_TABLE + "." + sLHS_KEY);
											}
											else
											{
												sb.AppendLine("       inner join vw" + sJOIN_TABLE + " " + sJOIN_TABLE  );
												sb.AppendLine("               on "   + sJOIN_TABLE + "." + sJOIN_KEY_LHS + " = " + sLHS_TABLE  + "." + sLHS_KEY);
												// 10/31/2009 Paul.  The value should be escaped. 
												if ( !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN) && !Sql.IsEmptyString(sRELATIONSHIP_ROLE_COLUMN_VALUE) )
													sb.AppendLine("              and "   + sJOIN_TABLE + "." + sRELATIONSHIP_ROLE_COLUMN + " = N'" + Sql.EscapeSQL(sRELATIONSHIP_ROLE_COLUMN_VALUE) + "'");
												sb.AppendLine("       inner join vw" + sRHS_TABLE + " " + sRHS_TABLE);
												sb.AppendLine("               on "   + sRHS_TABLE + "." + sRHS_KEY   + " = " + sJOIN_TABLE + "." + sJOIN_KEY_RHS);
											}
											// 07/13/2009 Paul.  The PARENT_ID is the primary key of the LHS table, not the LHS_KEY. 
											sb.AppendLine(" where " + sLHS_TABLE + ".ID = @ID"                                             );
											sb.AppendLine("   and AUDIT_VERSION = (select max(AUDIT_VERSION)"                              );
											sb.AppendLine("                          from " + sLHS_TABLE + "_AUDIT"                        );
											sb.AppendLine("                         where ID = @ID"                                        );
											sb.AppendLine("                           and AUDIT_VERSION < (select AUDIT_VERSION"           );
											sb.AppendLine("                                                  from " + sLHS_TABLE + "_AUDIT");
											sb.AppendLine("                                                 where AUDIT_ID = @AUDIT_ID"    );
											sb.AppendLine("                                               )"                               );
											// 12/03/2008 Paul.  When loading past values, make sure that the AUDIT_TOKEN does not match. 
											sb.AppendLine("                           and AUDIT_TOKEN  <> (select AUDIT_TOKEN"             );
											sb.AppendLine("                                                  from " + sLHS_TABLE + "_AUDIT");
											sb.AppendLine("                                                 where AUDIT_ID = @AUDIT_ID"    );
											sb.AppendLine("                                               )"                               );
											sb.AppendLine("                       )"                                                       );
											using ( IDbCommand cmd = con.CreateCommand() )
											{
												// 06/03/2009 Paul.  We switched to using a StringBuilder, but we did not stop using sSQL. 
												cmd.CommandText = sb.ToString();
												Sql.AddParameter(cmd, "@ID"      , gPARENT_ID);
												Sql.AddParameter(cmd, "@AUDIT_ID", gAUDIT_ID );
												using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
												{
													if ( rdr.Read() )
													{
														for ( int i = 0; i < rdr.FieldCount; i++ )
														{
															string sFieldName = rdr.GetName(i);
															object oValue = !rdr.IsDBNull(i) ? rdr.GetValue(i) : String.Empty;
															AddInsertionValues(app, hashRelationshipsStrings, sFieldName, oValue, "past", sMODULE_NAME, sRHS_MODULE, vwColumns, sSiteURL);
														}
													}
												}
											}
										}
									}
								}
							}
						}
						foreach ( string sInsertion in hashInsertionStrings.Keys )
						{
							if ( sSubject.IndexOf(sInsertion) >= 0 )
								sSubject = sSubject.Replace("{::" + sInsertion + "::}", Sql.ToString(hashInsertionStrings[sInsertion]));
							if ( sBodyHtml.IndexOf(sInsertion) >= 0 )
								sBodyHtml = sBodyHtml.Replace("{::" + sInsertion + "::}", Sql.ToString(hashInsertionStrings[sInsertion]));
						}
						foreach ( string sInsertion in hashRelationshipsStrings.Keys )
						{
							if ( sSubject.IndexOf(sInsertion) >= 0 )
								sSubject = sSubject.Replace("{::" + sInsertion + "::}", Sql.ToString(hashRelationshipsStrings[sInsertion]));
							if ( sBodyHtml.IndexOf(sInsertion) >= 0 )
								sBodyHtml = sBodyHtml.Replace("{::" + sInsertion + "::}", Sql.ToString(hashRelationshipsStrings[sInsertion]));
						}
						
						// 08/19/2023 Paul.  Add support for React links. 
						string sReactViewURL    = sSiteURL + "React/" + PARENT_TYPE + "/View/" + PARENT_ID.ToString();
						string sReactEditURL    = sSiteURL + "React/" + PARENT_TYPE + "/Edit/" + PARENT_ID.ToString();
						sBodyHtml = sBodyHtml.Replace("$react_view_url", sReactViewURL);
						sBodyHtml = sBodyHtml.Replace("$react_edit_url", sReactEditURL);

						// 11/19/2009 Paul.  View URL and Edit URL should be available to both an Email and a Notification. 
						string sViewURL    = sSiteURL + sPARENT_TYPE + "/view.aspx?ID=" + gPARENT_ID.ToString();
						string sEditURL    = sSiteURL + sPARENT_TYPE + "/edit.aspx?ID=" + gPARENT_ID.ToString();
						// 12/16/2009 Paul.  Project and ProjectTask require special handling as the folder names are plural. 
						if ( sPARENT_TYPE == "Project" || sPARENT_TYPE == "ProjectTask" )
						{
							sViewURL = sSiteURL + sPARENT_TYPE + "s/view.aspx?ID=" + gPARENT_ID.ToString();
							sEditURL = sSiteURL + sPARENT_TYPE + "s/edit.aspx?ID=" + gPARENT_ID.ToString();
						}
						sBodyHtml = sBodyHtml.Replace("$view_url", sViewURL);
						sBodyHtml = sBodyHtml.Replace("$edit_url", sEditURL);
						// 12/21/2012 Paul.  We need a way to generate a Site URL so that a link can be constructed. 
						sBodyHtml = sBodyHtml.Replace("href=\"~/", "href=\"" + sSiteURL);
						sBodyHtml = sBodyHtml.Replace("href=\'~/", "href=\'" + sSiteURL);
						// 09/03/2016 Paul.  We need to provide an insertion point for the business process ID. 
						sBodyHtml = sBodyHtml.Replace("$bp_id", context.WorkflowInstanceId.ToString());
						// 11/10/2016 Paul.  Provide an easier way to create the termination URL. 
						// 06/18/2017 Paul.  The Site URL already has the trailing slash. 
						string sTerminateURL = sSiteURL + "TerminateProcess.aspx?identifier=" + context.WorkflowInstanceId.ToString();
						sBodyHtml = sBodyHtml.Replace("$terminate_url", sTerminateURL);
						if ( sALERT_TYPE == "Notification" )
						{
							// 06/03/2009 Paul.  We are using simple insertions in our default module notifications. 
							// 07/05/2011 Paul.  A timed workflow will not have an AUDIT_ID.  Use the base view as the source of the data. 
							if ( !Sql.IsEmptyGuid(gPARENT_ID) )
							{
								string sSQL = String.Empty;
								if ( !Sql.IsEmptyGuid(gAUDIT_ID) )
								{
									sSQL = "select *                            " + ControlChars.CrLf
									     + "  from vw" + sMODULE_TABLE + "_AUDIT" + ControlChars.CrLf
									     + " where ID       = @ID               " + ControlChars.CrLf
									     + "   and AUDIT_ID = @AUDIT_ID         " + ControlChars.CrLf;
								}
								else
								{
									sSQL = "select *                            " + ControlChars.CrLf
									     + "  from vw" + sMODULE_TABLE            + ControlChars.CrLf
									     + " where ID       = @ID               " + ControlChars.CrLf;
								}
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@ID"      , gPARENT_ID);
									if ( !Sql.IsEmptyGuid(gAUDIT_ID) )
										Sql.AddParameter(cmd, "@AUDIT_ID", gAUDIT_ID );
									using ( DataTable dtParent = new DataTable() )
									{
										using ( DbDataAdapter da = dbf.CreateDataAdapter() )
										{
											((IDbDataAdapter)da).SelectCommand = cmd;
											da.Fill(dtParent);
											// 11/19/2009 Paul.  Contacts, Prospects and Leads do not have a NAME field.  We need to manually add a NAME field. 
											if ( dtParent.Columns.Contains("FIRST_NAME") && dtParent.Columns.Contains("LAST_NAME") && !dtParent.Columns.Contains("NAME") )
											{
												dtParent.Columns.Add("NAME", typeof(System.String));
												foreach ( DataRow row in dtParent.Rows )
												{
													string sNAME = Sql.ToString(row["FIRST_NAME"]) + " " + Sql.ToString(row["LAST_NAME"]);
													row["NAME"] = sNAME.Trim();
												}
											}
											DataView  vwParentColumns     = EmailUtils.SortedTableColumns(dtParent);
											Hashtable hashCurrencyColumns = EmailUtils.CurrencyColumns(vwParentColumns);
											if ( dtParent.Rows.Count > 0 )
											{
												string sFillPrefix = String.Empty;

												Hashtable hashEnumsColumns = EmailUtils.EnumColumns(sMODULE_NAME);
												switch ( sPARENT_TYPE )
												{
													case "Leads"    :
														sFillPrefix = "lead";
														sSubject  = EmailUtils.FillEmail(sSubject , sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														sBodyHtml = EmailUtils.FillEmail(sBodyHtml, sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														sFillPrefix = "contact";
														sSubject  = EmailUtils.FillEmail(sSubject , sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														sBodyHtml = EmailUtils.FillEmail(sBodyHtml, sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														break;
													case "Prospects":
														sFillPrefix = "prospect";
														sSubject  = EmailUtils.FillEmail(sSubject , sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														sBodyHtml = EmailUtils.FillEmail(sBodyHtml, sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														sFillPrefix = "contact";
														sSubject  = EmailUtils.FillEmail(sSubject , sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														sBodyHtml = EmailUtils.FillEmail(sBodyHtml, sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														break;
													default:
														sFillPrefix = sPARENT_TYPE.ToLower();
														if ( sFillPrefix.EndsWith("ies") )
															sFillPrefix = sFillPrefix.Substring(0, sFillPrefix.Length-3) + "y";
														else if ( sFillPrefix.EndsWith("s") )
															sFillPrefix = sFillPrefix.Substring(0, sFillPrefix.Length-1);
														sSubject  = EmailUtils.FillEmail(sSubject , sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														sBodyHtml = EmailUtils.FillEmail(sBodyHtml, sFillPrefix, dtParent.Rows[0], vwParentColumns, hashCurrencyColumns, hashEnumsColumns);
														break;
												}
											}
										}
									}
								}
							}

							MailMessage mail = new MailMessage();
							if ( !Sql.IsEmptyString(sFromAddress) && !Sql.IsEmptyString(sFromName) )
								mail.From = new MailAddress(sFromAddress, sFromName);
							else
								mail.From = new MailAddress(sFromAddress);
							foreach ( AlertRecipient r in lstRECIPIENTS )
							{
								// 08/28/2016 Paul.  Use the OptOut table to allow a recipient to stop the emails. 
								string sSQL = String.Empty;
								sSQL = "select count(*)                                                    " + ControlChars.CrLf
								     + "  from vwPROCESSES_OPTOUT                                          " + ControlChars.CrLf
								     + " where BUSINESS_PROCESS_INSTANCE_ID = @BUSINESS_PROCESS_INSTANCE_ID" + ControlChars.CrLf
								     + "   and PARENT_ID                    = @PARENT_ID                   " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@BUSINESS_PROCESS_INSTANCE_ID", context.WorkflowInstanceId);
									Sql.AddParameter(cmd, "@PARENT_ID"                   , gPARENT_ID                );
									int nOptOut = Sql.ToInteger(cmd.ExecuteScalar());
									if ( nOptOut > 0 )
										continue;
								}
								if ( !Sql.IsEmptyString(r.Address) )
								{
									MailAddress addr = null;
									if ( !Sql.IsEmptyString(r.DisplayName) )
										addr = new MailAddress(r.Address, r.DisplayName);
									else
										addr = new MailAddress(r.Address);
									switch ( r.SendType.ToLower() )
									{
										case "cc" :  mail.CC .Add(addr);  break;
										case "bcc":  mail.Bcc.Add(addr);  break;
										default   :  mail.To .Add(addr);  break;
									}
								}
							}
							// 10/05/2008 Paul.  If there are no recipients, then exit early. 
							if ( mail.To.Count == 0 && mail.CC.Count == 0 && mail.Bcc.Count == 0 )
								return;
							
							mail.Subject      = sSubject ;
							mail.Body         = sBodyHtml;
							mail.IsBodyHtml   = true;
							mail.BodyEncoding = System.Text.Encoding.UTF8;
							mail.Headers.Add("X-SplendidCRM-ID", gBUSINESS_PROCESS_ID.ToString());
							// 06/16/2010 Paul.  Add support for Workflow Alert Template Attachments. 
							if ( dtTemplateAttachments != null )
							{
								foreach ( DataRow row in dtTemplateAttachments.Rows )
								{
									string sFILENAME           = Sql.ToString(row["FILENAME"          ]);
									string sFILE_MIME_TYPE     = Sql.ToString(row["FILE_MIME_TYPE"    ]);
									Guid   gNOTE_ATTACHMENT_ID = Sql.ToGuid  (row["NOTE_ATTACHMENT_ID"]);

									// 07/30/2006 Paul.  We cannot close the streams until the message is sent. 
									MemoryStream mem = new MemoryStream();
									BinaryWriter writer = new BinaryWriter(mem);
									// 10/30/2021 Paul.  Move WriteStream to ModuleUtils. 
									ModuleUtils.Notes.Attachment.WriteStream(gNOTE_ATTACHMENT_ID, con, writer);
									writer.Flush();
									mem.Seek(0, SeekOrigin.Begin);
									Attachment att = new Attachment(mem, sFILENAME, sFILE_MIME_TYPE);
									// 06/02/2014 Tomi.  Make sure to use UTF8 encoding for the name. 
									att.NameEncoding = System.Text.Encoding.UTF8;
									mail.Attachments.Add(att);
								}
							}
							// 06/26/2010 Paul.  Now attach files generated within the workflow. 
							foreach ( AlertAttachment a in lstREPORT_ATTACHMENTS )
							{
								if ( a.Content != null && a.Content.Length > 0 )
								{
									string sFILENAME       = a.FileName;
									string sFILE_MIME_TYPE = a.FileMimeType;
									MemoryStream mem = new MemoryStream(a.Content);
									Attachment att = new Attachment(mem, sFILENAME, sFILE_MIME_TYPE);
									// 06/02/2014 Tomi.  Make sure to use UTF8 encoding for the name. 
									att.NameEncoding = System.Text.Encoding.UTF8;
									mail.Attachments.Add(att);
								}
							}

							// 10/04/2008 Paul.  Move SmtpClient code to a shared function. 
							// 01/17/2017 Paul.  New SplendidMailClient object to encapsulate SMTP, Exchange and Google mail. 
							SplendidMailClient client = SplendidMailClient.CreateMailClient(Application, memoryCache, Security, SplendidError, GoogleApps, Office365Sync);
							client.Send(mail);
						}
						else if ( sALERT_TYPE == "Email" )
						{
							StringBuilder sbTO_ADDRS         = new StringBuilder();
							StringBuilder sbCC_ADDRS         = new StringBuilder();
							StringBuilder sbBCC_ADDRS        = new StringBuilder();
							StringBuilder sbTO_ADDRS_IDS     = new StringBuilder();
							StringBuilder sbTO_ADDRS_NAMES   = new StringBuilder();
							StringBuilder sbTO_ADDRS_EMAILS  = new StringBuilder();
							StringBuilder sbCC_ADDRS_IDS     = new StringBuilder();
							StringBuilder sbCC_ADDRS_NAMES   = new StringBuilder();
							StringBuilder sbCC_ADDRS_EMAILS  = new StringBuilder();
							StringBuilder sbBCC_ADDRS_IDS    = new StringBuilder();
							StringBuilder sbBCC_ADDRS_NAMES  = new StringBuilder();
							StringBuilder sbBCC_ADDRS_EMAILS = new StringBuilder();
							foreach ( AlertRecipient r in lstRECIPIENTS )
							{
								if ( r.SendType.ToLower() == "cc" )
								{
									if ( !Sql.IsEmptyGuid(r.RecipientID) )
									{
										if ( sbCC_ADDRS_IDS.Length > 0 )
											sbCC_ADDRS_IDS.Append(";");
										sbCC_ADDRS_IDS.Append(r.RecipientID.ToString());
									}
									if ( !Sql.IsEmptyString(r.Address) )
									{
										if ( sbCC_ADDRS_EMAILS.Length > 0 )
											sbCC_ADDRS_EMAILS.Append(";");
										sbCC_ADDRS_EMAILS.Append(r.Address);
										if ( !Sql.IsEmptyString(r.DisplayName) )
										{
											if ( sbCC_ADDRS_NAMES.Length > 0 )
												sbCC_ADDRS_NAMES.Append(";");
											sbCC_ADDRS_NAMES.Append(r.DisplayName);
											if ( sbCC_ADDRS.Length > 0 )
												sbCC_ADDRS.Append(";");
											sbCC_ADDRS.Append(r.DisplayName + " <" + r.Address + ">");
										}
										else
										{
											if ( sbCC_ADDRS.Length > 0 )
												sbCC_ADDRS.Append(";");
											sbCC_ADDRS.Append("<" + r.Address + ">");
										}
									}
								}
								else if ( r.SendType.ToLower() == "bcc" )
								{
									if ( !Sql.IsEmptyGuid(r.RecipientID) )
									{
										if ( sbBCC_ADDRS_IDS.Length > 0 )
											sbBCC_ADDRS_IDS.Append(";");
										sbBCC_ADDRS_IDS.Append(r.RecipientID.ToString());
									}
									if ( !Sql.IsEmptyString(r.Address) )
									{
										if ( sbBCC_ADDRS_EMAILS.Length > 0 )
											sbBCC_ADDRS_EMAILS.Append(";");
										sbBCC_ADDRS_EMAILS.Append(r.Address);
										if ( !Sql.IsEmptyString(r.DisplayName) )
										{
											if ( sbBCC_ADDRS_NAMES.Length > 0 )
												sbBCC_ADDRS_NAMES.Append(";");
											sbBCC_ADDRS_NAMES.Append(r.DisplayName);
											if ( sbBCC_ADDRS.Length > 0 )
												sbBCC_ADDRS.Append(";");
											sbBCC_ADDRS.Append(r.DisplayName + " <" + r.Address + ">");
										}
										else
										{
											if ( sbBCC_ADDRS.Length > 0 )
												sbBCC_ADDRS.Append(";");
											sbBCC_ADDRS.Append("<" + r.Address + ">");
										}
									}
								}
								else
								{
									if ( !Sql.IsEmptyGuid(r.RecipientID) )
									{
										if ( sbTO_ADDRS_IDS.Length > 0 )
											sbTO_ADDRS_IDS.Append(";");
										sbTO_ADDRS_IDS.Append(r.RecipientID.ToString());
									}
									if ( !Sql.IsEmptyString(r.Address) )
									{
										if ( sbTO_ADDRS_EMAILS.Length > 0 )
											sbTO_ADDRS_EMAILS.Append(";");
										sbTO_ADDRS_EMAILS.Append(r.Address);
										if ( !Sql.IsEmptyString(r.DisplayName) )
										{
											if ( sbTO_ADDRS_NAMES.Length > 0 )
												sbTO_ADDRS_NAMES.Append(";");
											sbTO_ADDRS_NAMES.Append(r.DisplayName);
											if ( sbTO_ADDRS.Length > 0 )
												sbTO_ADDRS.Append(";");
											sbTO_ADDRS.Append(r.DisplayName + " <" + r.Address + ">");
										}
										else
										{
											if ( sbTO_ADDRS.Length > 0 )
												sbTO_ADDRS.Append(";");
											sbTO_ADDRS.Append("<" + r.Address + ">");
										}
									}
								}
							}
							try
							{
								Guid gEMAIL_ID = Guid.Empty;
								// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									try
									{
										// 08/09/2008 Paul.  Log the workflow instance so that it can be used to block circular/recursive workflows. 
										// 12/03/2008 Paul.  Since the Plug-in saves body in DESCRIPTION, we need to continue to use it as the primary source of data. 
										// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
										// 11/19/2023 Paul.  WF3 to WF4 will have WORKFLOW_ID instead of BUSINESS_PROCESS_ID. 
										if ( !Sql.IsEmptyGuid(gWORKFLOW_ID) )
											SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly("EMAILS", gWORKFLOW_ID, context.WorkflowInstanceId, trn);
										if ( !Sql.IsEmptyGuid(gBUSINESS_PROCESS_ID) )
											SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly("EMAILS", gBUSINESS_PROCESS_ID, context.WorkflowInstanceId, trn);
										SqlProcs.spEMAILS_Update
											( ref gEMAIL_ID
											, gASSIGNED_USER_ID
											, sSubject
											, DateTime.Now
											, sPARENT_TYPE
											, gPARENT_ID
											, sBodyHtml     // DESCRIPTION
											, sBodyHtml     // DESCRIPTION_HTML
											, sFromAddress
											, sFromName   
											, sbTO_ADDRS        .ToString()
											, sbCC_ADDRS        .ToString()
											, sbBCC_ADDRS       .ToString()
											, sbTO_ADDRS_IDS    .ToString()
											, sbTO_ADDRS_NAMES  .ToString()
											, sbTO_ADDRS_EMAILS .ToString()
											, sbCC_ADDRS_IDS    .ToString()
											, sbCC_ADDRS_NAMES  .ToString()
											, sbCC_ADDRS_EMAILS .ToString()
											, sbBCC_ADDRS_IDS   .ToString()
											, sbBCC_ADDRS_NAMES .ToString()
											, sbBCC_ADDRS_EMAILS.ToString()
											, "out"         // TYPE
											, String.Empty  // MESSAGE_ID
											, String.Empty  // REPLY_TO_NAME
											, String.Empty  // REPLY_TO_ADDR
											, String.Empty  // INTENT
											, Guid.Empty    // MAILBOX_ID
											, gTEAM_ID
											, sTEAM_SET_LIST
											// 05/17/2017 Paul.  Add Tags module. 
											, String.Empty  // TAG_SET_NAME
											// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
											, false         // IS_PRIVATE
											// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
											, String.Empty  // ASSIGNED_SET_LIST
											, trn
											);

										foreach ( AlertRecipient r in lstRECIPIENTS )
										{
											Guid   gRECIPIENT_ID   = r.RecipientID  ;
											string sRECIPIENT_TYPE = r.RecipientType;
											// 11/19/2008 Paul.  No need to add the relationship if the recipient is also the parent. 
											if ( !Sql.IsEmptyGuid(gRECIPIENT_ID) && gRECIPIENT_ID != gPARENT_ID )
											{
												// 06/26/2010 Paul.  Use stored procedure to assign relationships. 
												SqlProcs.spEMAILS_RELATED_Update(gEMAIL_ID, sRECIPIENT_TYPE, gRECIPIENT_ID, trn);
											}
										}
										// 06/16/2010 Paul.  Add support for Workflow Alert Template Attachments. 
										if ( dtTemplateAttachments != null )
										{
											foreach ( DataRow row in dtTemplateAttachments.Rows )
											{
												Guid gNOTE_ID = Guid.Empty;
												Guid gCOPY_ID = Sql.ToGuid(row["ID"]);
												SqlProcs.spNOTES_Copy(ref gNOTE_ID, gCOPY_ID, "Emails", gEMAIL_ID, trn);
											}
										}
										// 06/26/2010 Paul.  Now attach files generated within the workflow. 
										foreach ( AlertAttachment a in lstREPORT_ATTACHMENTS )
										{
											if ( a.Content != null && a.Content.Length > 0 )
											{
												string sFILENAME       = a.FileName    ;
												string sFILE_EXT       = a.Extension   ;
												string sFILE_MIME_TYPE = a.FileMimeType;
												
												Guid gNOTE_ID = Guid.Empty;
												// 04/02/2012 Paul.  Add ASSIGNED_USER_ID. 
												// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
												SqlProcs.spNOTES_Update
													( ref gNOTE_ID
													, app.Term("Emails.LBL_EMAIL_ATTACHMENT") + ": " + sFILENAME
													, "Emails"      // PARENT_TYPE
													, gEMAIL_ID     // PARENT_ID
													, Guid.Empty    // CONTACT_ID
													, String.Empty  // DESCRIPTION
													, gTEAM_ID
													, sTEAM_SET_LIST
													, gASSIGNED_USER_ID
													// 05/17/2017 Paul.  Add Tags module. 
													, String.Empty  // TAG_SET_NAME
													// 11/07/2017 Paul.  Add IS_PRIVATE for use by a large customer. 
													, false         // IS_PRIVATE
													// 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
													, String.Empty  // ASSIGNED_SET_LIST
													, trn
													);
												
												Guid gNOTE_ATTACHMENT_ID = Guid.Empty;
												SqlProcs.spNOTE_ATTACHMENTS_Insert(ref gNOTE_ATTACHMENT_ID, gNOTE_ID, sFILENAME, sFILENAME, sFILE_EXT, sFILE_MIME_TYPE, trn);
												//SqlProcs.spNOTES_ATTACHMENT_Update(gNOTE_ATTACHMENT_ID, a.Content, trn);
												// 11/06/2010 Paul.  Use our streamable function. 
												// 11/06/2010 Paul.  Move LoadFile() to Crm.NoteAttachments. 
												NoteAttachments.LoadFile(gNOTE_ATTACHMENT_ID, a.Content, trn);
											}
										}
										trn.Commit();
									}
									catch
									{
										trn.Rollback();
										// 12/25/2008 Paul.  Re-throw the original exception so as to retain the call stack. 
										throw;
									}
								}
								// 11/20/2008 Paul.  Send the email immediately after the record was created to decrease response time. 
								// Otherwise, the delay for the outbound email scheduler could be 5 minutes. 
								try
								{
									int nEmailsSent = 0;
									EmailUtils.SendEmail(gEMAIL_ID, String.Empty, String.Empty, ref nEmailsSent);
									// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											// 11/19/2023 Paul.  WF3 to WF4 will have WORKFLOW_ID instead of BUSINESS_PROCESS_ID. 
											if ( !Sql.IsEmptyGuid(gWORKFLOW_ID) )
												SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly("EMAILS", gWORKFLOW_ID, context.WorkflowInstanceId, trn);
											if ( !Sql.IsEmptyGuid(gBUSINESS_PROCESS_ID) )
												SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly("EMAILS", gBUSINESS_PROCESS_ID, context.WorkflowInstanceId, trn);
											SqlProcs.spEMAILS_UpdateStatus(gEMAIL_ID, "sent", trn);
											trn.Commit();
										}
										catch(Exception ex1)
										{
											trn.Rollback();
											throw(new Exception(ex1.Message, ex1.InnerException));
										}
									}
								}
								catch(Exception ex)
								{
									// 10/07/2009 Paul.  We need to create our own global transaction ID to support auditing and workflow on SQL Azure, PostgreSQL, Oracle, DB2 and MySQL. 
									using ( IDbTransaction trn = Sql.BeginTransaction(con) )
									{
										try
										{
											SqlProcs.spEMAILS_UpdateStatus(gEMAIL_ID, "send_error", trn);
											// 11/19/2023 Paul.  WF3 to WF4 will have WORKFLOW_ID instead of BUSINESS_PROCESS_ID. 
											if ( !Sql.IsEmptyGuid(gWORKFLOW_ID) )
											{
												SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly("EMAILS", gWORKFLOW_ID, context.WorkflowInstanceId, trn);
												Guid gTRACKING_ID = Guid.Empty;
												SqlProcs.spWWF_INSTANCE_EVENTS_Insert(ref gTRACKING_ID, context.WorkflowInstanceId, "Faulted", 0, DateTime.UtcNow, "WF4AlertActivity", "SplendidCRM.WF4AlertActivity", null, Utils.ExpandException(ex), trn);
											}
											if ( !Sql.IsEmptyGuid(gBUSINESS_PROCESS_ID) )
											{
												SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly("EMAILS", gBUSINESS_PROCESS_ID, context.WorkflowInstanceId, trn);
												SqlProcs.spWF4_TRACKING_FAULT_PROPAGATION_Insert
													(  context.WorkflowInstanceId   
													,  DateTime.UtcNow
													, -1                              // RECORD_NUMBER          
													, "<items />"                     // ANNOTATIONS            
													, Utils.ExpandException(ex)       // FAULT                  
													, ex.StackTrace                   // STACK_TRACE            
													, true                            // IS_FAULT_SOURCE        
													, null                            // FAULT_HANDLER          
													, null                            // FAULT_HANDLER_INSTANCE 
													, null                            // FAULT_HANDLER_NAME     
													, null                            // FAULT_HANDLER_TYPE_NAME
													, null                            // FAULT_SOURCE           
													, null                            // FAULT_SOURCE_INSTANCE  
													, "WF4AlertActivity"              // FAULT_SOURCE_NAME      
													, "SplendidCRM.WF4AlertActivity"  // FAULT_SOURCE_TYPE_NAME 
													, trn
													);
											}
											trn.Commit();
										}
										catch(Exception ex1)
										{
											trn.Rollback();
											throw(new Exception(ex1.Message, ex1.InnerException));
										}
									}
									// 11/20/2008 Paul.  If the message fails, don't abort the workflow. 
									SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
								}
							}
							catch(Exception ex)
							{
								SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
								throw(new Exception("WF4AlertActivity failed: " + ex.Message, ex));
							}
						}
					}
				}
				else
				{
					SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "WF4AlertActivity: No recipients for WorkflowInstanceId " + context.WorkflowInstanceId.ToString());
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								// 11/19/2023 Paul.  WF3 to WF4 will have WORKFLOW_ID instead of BUSINESS_PROCESS_ID. 
								if ( !Sql.IsEmptyGuid(gWORKFLOW_ID) )
								{
									SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly("EMAILS", gWORKFLOW_ID, context.WorkflowInstanceId, trn);
									Guid gTRACKING_ID = Guid.Empty;
									SqlProcs.spWWF_INSTANCE_EVENTS_Insert(ref gTRACKING_ID, context.WorkflowInstanceId, "Faulted", 0, DateTime.UtcNow, "WF4AlertActivity", "SplendidCRM.WF4AlertActivity", null, "No recipients", trn);
								}
								if ( !Sql.IsEmptyGuid(gBUSINESS_PROCESS_ID) )
								{
									SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly("EMAILS", gBUSINESS_PROCESS_ID, context.WorkflowInstanceId, trn);
									SqlProcs.spWF4_TRACKING_FAULT_PROPAGATION_Insert
										(  context.WorkflowInstanceId   
										,  DateTime.UtcNow
										, -1                                 // RECORD_NUMBER          
										, "<items />"                        // ANNOTATIONS            
										, "No recipients"                    // FAULT                  
										, (new StackTrace(true)).ToString()  // STACK_TRACE            
										, true                               // IS_FAULT_SOURCE        
										, null                               // FAULT_HANDLER          
										, null                               // FAULT_HANDLER_INSTANCE 
										, null                               // FAULT_HANDLER_NAME     
										, null                               // FAULT_HANDLER_TYPE_NAME
										, null                               // FAULT_SOURCE           
										, null                               // FAULT_SOURCE_INSTANCE  
										, "WF4AlertActivity"                 // FAULT_SOURCE_NAME      
										, "SplendidCRM.WF4AlertActivity"     // FAULT_SOURCE_TYPE_NAME 
										, trn
										);
								}
								trn.Commit();
							}
							catch(Exception ex1)
							{
								trn.Rollback();
								throw(new Exception(ex1.Message, ex1.InnerException));
							}
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WF4AlertActivity.Execute failed: " + ex.Message, ex));
			}
		}
	}

}
