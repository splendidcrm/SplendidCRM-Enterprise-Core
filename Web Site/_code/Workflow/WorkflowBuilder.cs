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
using System.Data.Common;
using System.Threading;
using System.Collections;
using System.Collections.Generic;
using Microsoft.AspNetCore.Hosting;

namespace SplendidCRM
{
	public class WorkflowBuilder
	{
		private IWebHostEnvironment  hostingEnvironment ;
		private DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private SqlProcs             SqlProcs           ;
		private SplendidCache        SplendidCache      ;
		private XmlUtil              XmlUtil            ;
		private Workflow4BuildXaml   Workflow4BuildXaml ;

		public WorkflowBuilder(IWebHostEnvironment  hostingEnvironment, HttpSessionState Session, Security Security, SqlProcs SqlProcs, SplendidCache SplendidCache, XmlUtil XmlUtil, Workflow4BuildXaml Workflow4BuildXaml)
		{
			this.hostingEnvironment  = hostingEnvironment ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidCache       = SplendidCache      ;
			this.XmlUtil             = XmlUtil            ;
			this.Workflow4BuildXaml  = Workflow4BuildXaml ;
		}

		private string ActivityFromModuleName(string sModuleName)
		{
			string sActivityName = String.Empty;
			if ( sModuleName.EndsWith("ies") )
				sActivityName = sModuleName.Substring(0, sModuleName.Length - 3) + "yActivity";
			else if ( sModuleName.EndsWith("s") )
				sActivityName = sModuleName.Substring(0, sModuleName.Length - 1) + "Activity";
			else
				// 08/13/2009 Paul.  Project and ProjectTask don't end in "s", so just append Activity. 
				sActivityName = sModuleName + "Activity";
			return sActivityName;
		}

		// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
		public void BuildAlertXOML(XomlDocument xoml, XmlNode parent, RdlDocument rdl, string sWORKFLOW_TYPE, string sBaseModule, string sMODULE_TABLE, string sALERT_NAME, string sALERT_TYPE, string sALERT_TEXT, string sSOURCE_TYPE, Guid gCUSTOM_TEMPLATE_ID, int nIndex, Guid gASSIGNED_USER_ID, Guid gTEAM_ID, string sTEAM_SET_LIST)
		{
			string sIndex = nIndex.ToString();
			if ( xoml.DocumentElement != null )
			{
				if ( parent == null )
					parent = xoml.DocumentElement;

				// 05/29/2006 Paul.  If the module is used in a filter, then it is required. 
				XmlDocument xmlFilters = rdl.GetCustomProperty("Filters");
				XmlNodeList nlFilters  = xmlFilters.DocumentElement.SelectNodes("Filter");
				string sActivityName = ActivityFromModuleName(sBaseModule);

				// 08/14/2008 Paul.  The Workflow design image will be easier to read if the names are in camel case. 
				string sBaseName = sBaseModule + sIndex;
				XmlNode xModuleActivity = xoml.CreateActivity(parent, sActivityName);
				xoml.SetNameAttribute(xModuleActivity, sBaseName);
				xoml.SetAttribute(xModuleActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
				// 11/16/2008 Paul.  Time-based workflows reference the base module, not the audit table. 
				if ( String.Compare(sWORKFLOW_TYPE, "time", true) == 0 )
					xoml.SetAttribute(xModuleActivity, "ID"      , "{ActivityBind Workflow1,Path=ID}");
				else
					xoml.SetAttribute(xModuleActivity, "AUDIT_ID", "{ActivityBind Workflow1,Path=AUDIT_ID}");
				
				xModuleActivity.AppendChild(xoml.CreateWhitespace("\n\t"));
				XmlNode xLogActivity = xoml.CreateActivity(xModuleActivity, "WorkflowLogActivity");
				xoml.SetNameAttribute(xLogActivity, sBaseName + "_Log");
				xoml.SetAttribute(xLogActivity, "MODULE_TABLE", sMODULE_TABLE);
				xoml.SetAttribute(xLogActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
				if ( String.Compare(sWORKFLOW_TYPE, "time", true) == 0 )
					xoml.CreateCodeActivity(xModuleActivity, sBaseName, "LoadByID");
				else
					xoml.CreateCodeActivity(xModuleActivity, sBaseName, "LoadByAUDIT_ID");

				if ( xmlFilters.DocumentElement != null )
				{
					foreach ( XmlNode xFilter in xmlFilters.DocumentElement )
					{
						string sRELATED_MODULE = XmlUtil.SelectSingleNode(xFilter, "RELATIONSHIP_NAME");
						string sMODULE_NAME    = XmlUtil.SelectSingleNode(xFilter, "MODULE_NAME"      );
						string sTABLE_NAME     = XmlUtil.SelectSingleNode(xFilter, "TABLE_NAME"       );
						string sDATA_FIELD     = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD"       );
						string sFIELD_NAME     = XmlUtil.SelectSingleNode(xFilter, "FIELD_NAME"       );
						string sDATA_TYPE      = XmlUtil.SelectSingleNode(xFilter, "DATA_TYPE"        );
						string sOPERATOR       = XmlUtil.SelectSingleNode(xFilter, "OPERATOR"         );
						string sRECIPIENT_NAME = XmlUtil.SelectSingleNode(xFilter, "RECIPIENT_NAME"   );
						string sSEARCH_TEXT    = XmlUtil.SelectSingleNode(xFilter, "SEARCH_TEXT"      );
						
						string sFilterActivity = XomlDocument.CamelCase(sMODULE_NAME.Split(' ')[1] + sIndex);
						XmlNode xAlias = xoml.SelectActivityName(xoml.DocumentElement, sFilterActivity);
						if ( xAlias == null )
						{
							if ( !Sql.IsEmptyString(sRELATED_MODULE) )
							{
								XmlDocument xmlRelatedModules = rdl.GetCustomProperty("RelatedModules");
								string sRELATED       = sRELATED_MODULE.Split(' ')[0];
								string sRELATED_ALIAS = sRELATED_MODULE.Split(' ')[1];
								// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
								// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
								string[] arrRELATED_MODULE = sRELATED_MODULE.Split(' ');
								string sRELATIONSHIP_NAME = String.Empty;
								if ( arrRELATED_MODULE.Length >= 3 )
									sRELATIONSHIP_NAME = arrRELATED_MODULE[2];
								
								// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
								// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
								XmlNode xRelationship = null;
								if ( !Sql.IsEmptyString(sRELATIONSHIP_NAME) )
									xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RELATIONSHIP_NAME=\'" + sRELATIONSHIP_NAME + "\']");
								else
									xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RHS_MODULE=\'" + sRELATED + "\']");
								if ( xRelationship != null )
								{
									//string sRELATIONSHIP_NAME              = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_NAME"             );
									//string sLHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "LHS_MODULE"                    );
									string sLHS_TABLE                      = XmlUtil.SelectSingleNode(xRelationship, "LHS_TABLE"                     );
									string sLHS_KEY                        = XmlUtil.SelectSingleNode(xRelationship, "LHS_KEY"                       );
									string sRHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "RHS_MODULE"                    );
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
										sActivityName = ActivityFromModuleName(sRHS_MODULE);
										// 02/21/2009 Paul.  Make sure to only create the related activity once. 
										XmlNode xRelatedActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
										if ( xRelatedActivity == null )
										{
											xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
											xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
											xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
											xoml.SetAttribute(xRelatedActivity, sRHS_KEY, "{ActivityBind " + sBaseName + ",Path=" + sLHS_KEY + "}");
											xoml.CreateCodeActivity(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex), "LoadByID");
										}
									}
									else
									{
										sActivityName = "RelationshipActivity";
										// 02/21/2009 Paul.  Make sure to only create the related activity once. 
										XmlNode xRelationshipActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sJOIN_TABLE + sIndex));
										if ( xRelationshipActivity == null )
										{
											xRelationshipActivity = xoml.CreateActivity(parent, sActivityName);
											xoml.SetNameAttribute(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex));
											xoml.SetAttribute(xRelationshipActivity, "WORKFLOW_ID"                   , "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
											xoml.SetAttribute(xRelationshipActivity, "LHS_TABLE"                     , sLHS_TABLE                     );
											xoml.SetAttribute(xRelationshipActivity, "LHS_KEY"                       , sLHS_KEY                       );
											xoml.SetAttribute(xRelationshipActivity, "RHS_MODULE"                    , sRHS_MODULE                    );
											xoml.SetAttribute(xRelationshipActivity, "RHS_TABLE"                     , sRHS_TABLE                     );
											xoml.SetAttribute(xRelationshipActivity, "RHS_KEY"                       , sRHS_KEY                       );
											xoml.SetAttribute(xRelationshipActivity, "JOIN_TABLE"                    , sJOIN_TABLE                    );
											xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_LHS"                  , sJOIN_KEY_LHS                  );
											xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_RHS"                  , sJOIN_KEY_RHS                  );
											xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN"      , sRELATIONSHIP_ROLE_COLUMN      );
											xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN_VALUE", sRELATIONSHIP_ROLE_COLUMN_VALUE);
											xRelationshipActivity.AppendChild(xoml.CreateWhitespace("\n"));
											xoml.CreateSetValueActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "LHS_VALUE", "{ActivityBind " + sBaseName + ",Path=" + sLHS_KEY + "}", "equals");
											xoml.CreateCodeActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "LoadByLHS");
										}

										sActivityName = ActivityFromModuleName(sRHS_MODULE);
										// 02/21/2009 Paul.  Make sure to only create the related activity once. 
										XmlNode xRelatedActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
										if ( xRelatedActivity == null )
										{
											xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
											xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
											xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
											xRelatedActivity.AppendChild(xoml.CreateWhitespace("\n"));
											xoml.CreateSetValueActivity(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex), "ID", "{ActivityBind " + XomlDocument.CamelCase(sJOIN_TABLE + sIndex) + ",Path=RHS_VALUE}", "equals");
											xoml.CreateCodeActivity(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex), "LoadByID");
										}
									}
								}
							}
							// 02/20/2010 Paul.  Audit Old data was not previously created.  We need to create this activity in order to reference the data in an alert. 
							else if ( sTABLE_NAME.EndsWith("_AUDIT_OLD") )
							{
								sActivityName = ActivityFromModuleName(sBaseModule);
								// 02/21/2009 Paul.  Make sure to only create the related activity once. 
								XmlNode xRelationshipActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sTABLE_NAME + sIndex));
								if ( xRelationshipActivity == null )
								{
									xRelationshipActivity = xoml.CreateActivity(parent, sActivityName);
									xoml.SetNameAttribute(xRelationshipActivity, XomlDocument.CamelCase(sTABLE_NAME + sIndex));
									xoml.SetAttribute(xRelationshipActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
									// 02/23/2010 Paul.  Must also set the AUDIT_ID. 
									xoml.SetAttribute(xRelationshipActivity, "AUDIT_ID"   , "{ActivityBind Workflow1,Path=AUDIT_ID}");
									xRelationshipActivity.AppendChild(xoml.CreateWhitespace("\n"));
									xoml.CreateCodeActivity(xRelationshipActivity, XomlDocument.CamelCase(sTABLE_NAME + sIndex), "LoadPastByAUDIT_ID");
								}
							}
						}
					}
				}

				string sAlertName = "Alert" + sIndex;
				XmlNode xAlertActivity = xoml.CreateActivity(parent, "AlertActivity");
				xoml.SetNameAttribute(xAlertActivity, sAlertName);
				xoml.SetAttribute(xAlertActivity, "SUBJECT"           , sALERT_NAME  );
				xoml.SetAttribute(xAlertActivity, "ALERT_TYPE"        , sALERT_TYPE  );
				xoml.SetAttribute(xAlertActivity, "SOURCE_TYPE"       , sSOURCE_TYPE );
				xoml.SetAttribute(xAlertActivity, "CUSTOM_TEMPLATE_ID", gCUSTOM_TEMPLATE_ID.ToString());
				// 11/19/2008 Paul.  When sending an Alert Email, we need to set the PARENT_ID of the email. 
				// 11/22/2008 Paul.  Also set the AUDIT_ID so that we can get the history. 
				xoml.SetAttribute(xAlertActivity, "AUDIT_ID"          , "{ActivityBind " + sBaseName + ",Path=AUDIT_ID}");
				xoml.SetAttribute(xAlertActivity, "PARENT_ID"         , "{ActivityBind " + sBaseName + ",Path=ID}");
				xoml.SetAttribute(xAlertActivity, "PARENT_TYPE"       , sBaseModule  );
				xoml.SetAttribute(xAlertActivity, "PARENT_ACTIVITY"   , sBaseName    );
				// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
				if ( !Sql.IsEmptyGuid(gASSIGNED_USER_ID) )
					xoml.SetAttribute(xAlertActivity, "ASSIGNED_USER_ID"  , gASSIGNED_USER_ID.ToString());
				if ( !Sql.IsEmptyGuid(gTEAM_ID) )
					xoml.SetAttribute(xAlertActivity, "TEAM_ID"           , gTEAM_ID         .ToString());
				if ( !Sql.IsEmptyString(sTEAM_SET_LIST) )
					xoml.SetAttribute(xAlertActivity, "TEAM_SET_LIST"     , sTEAM_SET_LIST   );
				xoml.SetAttribute(xAlertActivity, "WORKFLOW_ID"       , "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
				// 11/24/2008 Paul.  Move alert text to-the-end so that the other fields are easier to read. 
				xoml.SetAttribute(xAlertActivity, "ALERT_TEXT"        , sALERT_TEXT  );
				xAlertActivity.AppendChild(xoml.CreateWhitespace("\n\t"));

				xLogActivity = xoml.CreateActivity(xAlertActivity, "WorkflowLogActivity");
				xoml.SetNameAttribute(xLogActivity, sAlertName + "_Log");
				xoml.SetAttribute(xLogActivity, "MODULE_TABLE", (sALERT_TYPE == "Email") ? "EMAILS" : "MEETINGS");
				xoml.SetAttribute(xLogActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
				if ( xmlFilters.DocumentElement != null )
				{
					// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
					List<string> arrIncludedColumns = new List<string>(new string[] {"ID", "CREATED_BY_ID", "MODIFIED_USER_ID", "ASSIGNED_USER_ID", "TEAM_ID", "PARENT_ID", "ACCOUNT_ID", "CONTACT_ID"});
					foreach ( XmlNode xFilter in xmlFilters.DocumentElement )
					{
						// 11/17/2008 Paul.  Use the ACTION_TYPE field to determine the recipient type. 
						string sACTION_TYPE    = XmlUtil.SelectSingleNode(xFilter, "ACTION_TYPE"      );
						string sRELATED_MODULE = XmlUtil.SelectSingleNode(xFilter, "RELATIONSHIP_NAME");
						string sMODULE_NAME    = XmlUtil.SelectSingleNode(xFilter, "MODULE_NAME"      );
						string sTABLE_NAME     = XmlUtil.SelectSingleNode(xFilter, "TABLE_NAME"       );
						string sDATA_FIELD     = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD"       );
						string sFIELD_NAME     = XmlUtil.SelectSingleNode(xFilter, "FIELD_NAME"       );
						string sDATA_TYPE      = XmlUtil.SelectSingleNode(xFilter, "DATA_TYPE"        );
						string sOPERATOR       = XmlUtil.SelectSingleNode(xFilter, "OPERATOR"         );
						string sRECIPIENT_NAME = XmlUtil.SelectSingleNode(xFilter, "RECIPIENT_NAME"   );
						string sSEARCH_TEXT    = XmlUtil.SelectSingleNode(xFilter, "SEARCH_TEXT"      );
						
						string sFilterActivity = XomlDocument.CamelCase(sMODULE_NAME.Split(' ')[1] + sIndex);
						string[] arrModule   = sMODULE_NAME.Split(' ');
						string sModule       = arrModule[0];
						string sTableAlias   = arrModule[1];
						if ( sTableAlias == "USERS_ALL" || sACTION_TYPE == "specific_user" )
						{
							sDATA_TYPE = "User";
							// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
							xoml.CreateAddRecipientActivity(xAlertActivity, sAlertName, sRECIPIENT_NAME, sSEARCH_TEXT, sDATA_TYPE, sOPERATOR, String.Empty, String.Empty);
						}
						else if ( sTableAlias == "TEAMS" || sACTION_TYPE == "specific_team" )
						{
							sDATA_TYPE = "Team";
							// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
							xoml.CreateAddRecipientActivity(xAlertActivity, sAlertName, sRECIPIENT_NAME, sSEARCH_TEXT, sDATA_TYPE, sOPERATOR, String.Empty, String.Empty);
						}
						else if ( sTableAlias == "ACL_ROLES" || sACTION_TYPE == "specific_role" )
						{
							sDATA_TYPE = "Role";
							// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
							xoml.CreateAddRecipientActivity(xAlertActivity, sAlertName, sRECIPIENT_NAME, sSEARCH_TEXT, sDATA_TYPE, sOPERATOR, String.Empty, String.Empty);
						}
						else
						{
							if ( sACTION_TYPE == "record" )
								sDATA_TYPE = "Record";
							else if ( sACTION_TYPE == "custom_field" )
								sDATA_TYPE = "Record_Custom";
							else
								sDATA_TYPE = "User";
							if ( sFIELD_NAME == "TEAM_ID" )
								sDATA_TYPE = "Team";
							// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
							string sRECIPIENT_TABLE = String.Empty;
							string sRECIPIENT_FIELD = String.Empty;
							if ( !arrIncludedColumns.Contains(sFIELD_NAME) )
							{
								sRECIPIENT_TABLE = sTABLE_NAME;
								sRECIPIENT_FIELD = sFIELD_NAME;
								sFIELD_NAME      = "ID";
							}
							xoml.CreateAddRecipientActivity(xAlertActivity, sAlertName, sFilterActivity, sRECIPIENT_NAME, sFIELD_NAME, sDATA_TYPE, sOPERATOR, sRECIPIENT_TABLE, sRECIPIENT_FIELD);
						}
					}
				}
				// 07/13/2010 Paul.  An Alert can now have a Report Attachment in addition to it the Alert Template Attachments.
				XmlDocument xmlReportAttachments = rdl.GetCustomProperty("ReportAttachments");
				if ( xmlReportAttachments.DocumentElement != null )
				{
					XmlNodeList nlReportAttachments = xmlReportAttachments.DocumentElement.SelectNodes("Report");
					if ( nlReportAttachments.Count > 0 )
						xAlertActivity.AppendChild(xoml.CreateWhitespace("\n"));
					// 07/13/2010 Paul.  The AttachReportActivity does not require a ReportActivity. 
					for ( int i = 0; i < nlReportAttachments.Count; i++ )
					{
						XmlNode xAttachment = nlReportAttachments[i];
						string sReportAttachName  = sBaseName + "_AttachReport" + sIndex + "_Attach" + i.ToString();
						string sREPORT_ID         = XmlUtil.SelectSingleNode(xAttachment, "REPORT_ID"        );
						// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
						string sSCHEDULED_USER_ID = XmlUtil.SelectSingleNode(xAttachment, "SCHEDULED_USER_ID");
						string sREPORT_PARAMETERS = XmlUtil.SelectSingleNode(xAttachment, "REPORT_PARAMETERS");
						// 05/13/2014 Paul.  Allow report render format to be specified. 
						string sRENDER_FORMAT     = XmlUtil.SelectSingleNode(xAttachment, "RENDER_FORMAT"    );
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
						XmlAttribute xAlertName        = xoml.CreateAttribute("ALERT_NAME"       );
						XmlAttribute xReportID         = xoml.CreateAttribute("REPORT_ID"        );
						XmlAttribute xScheduledUserID  = xoml.CreateAttribute("SCHEDULED_USER_ID");
						XmlAttribute xRenderFormat     = xoml.CreateAttribute("RENDER_FORMAT"    );
						XmlAttribute xReportParameters = xoml.CreateAttribute("REPORT_PARAMETERS");

						xAlertName       .Value = sAlertName  ;
						// 07/13/2010 Paul.  The Report ID is not embedded in the RDL, so we don't need to bind to get it. 
						xReportID        .Value = sREPORT_ID  ;  //"{ActivityBind " + sBaseName + ",Path=ID}";
						xScheduledUserID .Value = sSCHEDULED_USER_ID;
						xRenderFormat    .Value = sRENDER_FORMAT;
						xReportParameters.Value = String.Empty;

						// 07/13/2010 Paul.  The parameters need to be built using workflow activities so that they can contain dynamic items. 
						if ( sREPORT_PARAMETERS.Length > 0 )
						{
							//xReportParameters.Value = sREPORT_PARAMETERS;
							// 12/19/2012 Paul.  Add support for the rules engine to report parameters. 
							if ( sREPORT_PARAMETERS.StartsWith("=") )
								xoml.CreateSetRuleActivity(xAlertActivity, sReportAttachName, "REPORT_PARAMETERS", sREPORT_PARAMETERS);
							else
								xoml.CreateSetValueActivity(xAlertActivity, sReportAttachName, "REPORT_PARAMETERS", sREPORT_PARAMETERS, "equalsURL");
						}
						xAlertActivity.AppendChild(xoml.CreateWhitespace("\t"));

						XmlNode xAttachReport = xoml.CreateActivity(xAlertActivity, "AttachReportActivity");
						xoml.SetNameAttribute(xAttachReport, sReportAttachName);
						xAttachReport.Attributes.Append(xAlertName       );
						xAttachReport.Attributes.Append(xReportID        );
						// 08/02/2011 Paul.  We can't set SCHEDULED_USER_ID value to an empty string. 
						// error 347: Could not deserialize member 'SCHEDULED_USER_ID'. 
						// Could not set value '' on member 'SCHEDULED_USER_ID' of type 'SplendidCRM.AttachReportActivity'. 
						// Guid should contain 32 digits with 4 dashes (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx).
						if ( !Sql.IsEmptyString(sSCHEDULED_USER_ID) )
							xAttachReport.Attributes.Append(xScheduledUserID );
						xAttachReport.Attributes.Append(xRenderFormat    );
						xAttachReport.Attributes.Append(xReportParameters);
					}
					if ( nlReportAttachments.Count > 0 )
						xAlertActivity.AppendChild(xoml.CreateWhitespace("\t"));
				}

				xoml.CreateCodeActivity(xAlertActivity, sAlertName, "Send");
			}
		}

		public void BuildActionXOML(XomlDocument xoml, XmlNode parent, RdlDocument rdl, string sWORKFLOW_TYPE, string sBaseModule, string sMODULE_TABLE, int nIndex)
		{
			string sIndex = nIndex.ToString();
			if ( xoml.DocumentElement != null )
			{
				if ( parent == null )
					parent = xoml.DocumentElement;

				XmlDocument xmlFilters = rdl.GetCustomProperty("Filters");
				XmlNodeList nlFilters  = xmlFilters.DocumentElement.SelectNodes("Filter");
				string sActivityName = ActivityFromModuleName(sBaseModule);

				// 08/14/2008 Paul.  The Workflow design image will be easier to read if the names are in camel case. 
				string sBaseName = sBaseModule + sIndex;
				XmlNode xModuleActivity = xoml.CreateActivity(parent, sActivityName);
				xoml.SetNameAttribute(xModuleActivity, sBaseName);
				xoml.SetAttribute(xModuleActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
				// 11/16/2008 Paul.  Time-based workflows reference the base module, not the audit table. 
				if ( String.Compare(sWORKFLOW_TYPE, "time", true) == 0 )
					xoml.SetAttribute(xModuleActivity, "ID"      , "{ActivityBind Workflow1,Path=ID}");
				else
					xoml.SetAttribute(xModuleActivity, "AUDIT_ID", "{ActivityBind Workflow1,Path=AUDIT_ID}");
				
				xModuleActivity.AppendChild(xoml.CreateWhitespace("\n\t"));
				XmlNode xLogActivity = xoml.CreateActivity(xModuleActivity, "WorkflowLogActivity");
				xoml.SetNameAttribute(xLogActivity, sBaseName + "_Log");
				xoml.SetAttribute(xLogActivity, "MODULE_TABLE", sMODULE_TABLE);
				xoml.SetAttribute(xLogActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
				// 11/16/2008 Paul.  Time-based workflows reference the base module, not the audit table. 
				if ( String.Compare(sWORKFLOW_TYPE, "time", true) == 0 )
					xoml.CreateCodeActivity(xModuleActivity, sBaseName, "LoadByID");
				else
					xoml.CreateCodeActivity(xModuleActivity, sBaseName, "LoadByAUDIT_ID");

				Hashtable hashCustomFilters = new Hashtable();
				if ( xmlFilters.DocumentElement != null )
				{
					foreach ( XmlNode xFilter in xmlFilters.DocumentElement )
					{
						string sACTION_TYPE    = XmlUtil.SelectSingleNode(xFilter, "ACTION_TYPE"      );
						string sRELATED_MODULE = XmlUtil.SelectSingleNode(xFilter, "RELATIONSHIP_NAME");
						string sMODULE_NAME    = XmlUtil.SelectSingleNode(xFilter, "MODULE_NAME"      );
						string sTABLE_NAME     = XmlUtil.SelectSingleNode(xFilter, "TABLE_NAME"       );
						string sDATA_FIELD     = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD"       );
						string sFIELD_NAME     = XmlUtil.SelectSingleNode(xFilter, "FIELD_NAME"       );
						string sDATA_TYPE      = XmlUtil.SelectSingleNode(xFilter, "DATA_TYPE"        );
						string sOPERATOR       = XmlUtil.SelectSingleNode(xFilter, "OPERATOR"         );
						string sSEARCH_TEXT1   = String.Empty;

						if ( sACTION_TYPE == "update_rel" )
						{
							if ( !Sql.IsEmptyString(sRELATED_MODULE) )
							{
								XmlDocument xmlRelatedModules = rdl.GetCustomProperty("RelatedModules");
								string sRELATED       = sRELATED_MODULE.Split(' ')[0];
								string sRELATED_ALIAS = sRELATED_MODULE.Split(' ')[1];
								// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
								// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
								// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
								string[] arrRELATED_MODULE = sRELATED_MODULE.Split(' ');
								string sRELATIONSHIP_NAME = String.Empty;
								if ( arrRELATED_MODULE.Length >= 3 )
									sRELATIONSHIP_NAME = arrRELATED_MODULE[2];
								
								// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
								// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
								XmlNode xRelationship = null;
								if ( !Sql.IsEmptyString(sRELATIONSHIP_NAME) )
									xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RELATIONSHIP_NAME=\'" + sRELATIONSHIP_NAME + "\']");
								else
									xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RHS_MODULE=\'" + sRELATED + "\']");
								if ( xRelationship != null )
								{
									//string sRELATIONSHIP_NAME              = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_NAME"             );
									//string sLHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "LHS_MODULE"                    );
									string sLHS_TABLE                      = XmlUtil.SelectSingleNode(xRelationship, "LHS_TABLE"                     );
									string sLHS_KEY                        = XmlUtil.SelectSingleNode(xRelationship, "LHS_KEY"                       );
									string sRHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "RHS_MODULE"                    );
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
										sActivityName = ActivityFromModuleName(sRHS_MODULE);
										// 02/21/2009 Paul.  Make sure to only create the related activity once. 
										XmlNode xRelatedActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
										if ( xRelatedActivity == null )
										{
											xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
											xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
											xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
											xoml.SetAttribute(xRelatedActivity, sRHS_KEY, "{ActivityBind " + sBaseName + ",Path=" + sLHS_KEY + "}");
											xoml.CreateCodeActivity(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex), "LoadByID");
										}
									}
									else
									{
										sActivityName = "RelationshipActivity";
										// 02/21/2009 Paul.  Make sure to only create the related activity once. 
										XmlNode xRelationshipActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sJOIN_TABLE + sIndex));
										if ( xRelationshipActivity == null )
										{
											xRelationshipActivity = xoml.CreateActivity(parent, sActivityName);
											xoml.SetNameAttribute(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex));
											xoml.SetAttribute(xRelationshipActivity, "WORKFLOW_ID"                   , "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
											xoml.SetAttribute(xRelationshipActivity, "LHS_TABLE"                     , sLHS_TABLE                     );
											xoml.SetAttribute(xRelationshipActivity, "LHS_KEY"                       , sLHS_KEY                       );
											xoml.SetAttribute(xRelationshipActivity, "RHS_MODULE"                    , sRHS_MODULE                    );
											xoml.SetAttribute(xRelationshipActivity, "RHS_TABLE"                     , sRHS_TABLE                     );
											xoml.SetAttribute(xRelationshipActivity, "RHS_KEY"                       , sRHS_KEY                       );
											xoml.SetAttribute(xRelationshipActivity, "JOIN_TABLE"                    , sJOIN_TABLE                    );
											xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_LHS"                  , sJOIN_KEY_LHS                  );
											xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_RHS"                  , sJOIN_KEY_RHS                  );
											xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN"      , sRELATIONSHIP_ROLE_COLUMN      );
											xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN_VALUE", sRELATIONSHIP_ROLE_COLUMN_VALUE);
											xRelationshipActivity.AppendChild(xoml.CreateWhitespace("\n"));
											xoml.CreateSetValueActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "LHS_VALUE", "{ActivityBind " + sBaseName + ",Path=" + sLHS_KEY + "}", "equals");
											xoml.CreateCodeActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "LoadByLHS");
										}

										sActivityName = ActivityFromModuleName(sRHS_MODULE);
										// 02/21/2009 Paul.  Make sure to only create the related activity once. 
										XmlNode xRelatedActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
										if ( xRelatedActivity == null )
										{
											xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
											xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
											xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
											xRelatedActivity.AppendChild(xoml.CreateWhitespace("\n"));
											xoml.CreateSetValueActivity(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex), "ID", "{ActivityBind " + XomlDocument.CamelCase(sJOIN_TABLE + sIndex) + ",Path=RHS_VALUE}", "equals");
											xoml.CreateCodeActivity(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex), "LoadByID");
										}
									}
								}
							}
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

						string sCOMMON_DATA_TYPE = sDATA_TYPE;
						if ( sCOMMON_DATA_TYPE == "ansistring" )
							sCOMMON_DATA_TYPE = "string";

						// 11/01/2010 Paul.  Add Custom Activity Action Type. 
						// 11/07/2010 Paul.  Add Custom Method and Custom Property. 
						// 08/03/2012 Paul.  Add Custom Stored Procedure. 
						string sFilterActivity = String.Empty;
						if ( sACTION_TYPE == "custom_procedure" )
							sFilterActivity = "StoredProcedureActivity" + sIndex;
						else if ( sACTION_TYPE.StartsWith("custom") )
							sFilterActivity = sRELATED_MODULE + sIndex;
						else
							sFilterActivity = XomlDocument.CamelCase(sMODULE_NAME.Split(' ')[1] + sIndex);
						XmlNode xAlias = xoml.SelectActivityName(xoml.DocumentElement, sFilterActivity);
						if ( xAlias == null )
						{
							// 11/01/2010 Paul.  Add Custom Activity Action Type. 
							// 11/07/2010 Paul.  Add Custom Method and Custom Property. 
							// 08/03/2012 Paul.  Add Custom Stored Procedure. 
							if ( sACTION_TYPE == "custom_procedure" )
							{
								XmlNode xCustomActivity = xoml.CreateActivity(parent, "StoredProcedureActivity");
								xoml.SetNameAttribute(xCustomActivity, sFilterActivity);
								xoml.SetAttribute(xCustomActivity, "WORKFLOW_ID"   , "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
								xoml.SetAttribute(xCustomActivity, "AUDIT_ID"      , "{ActivityBind Workflow1,Path=AUDIT_ID}"   );
								xoml.SetAttribute(xCustomActivity, "ID"            , "{ActivityBind Workflow1,Path=ID}"         );
								xoml.SetAttribute(xCustomActivity, "MODULE_NAME"   , sBaseModule                                );
								xoml.SetAttribute(xCustomActivity, "PROCEDURE_NAME", sDATA_FIELD                                );
								xCustomActivity.AppendChild(xoml.CreateWhitespace("\n"));
								hashCustomFilters.Add(sFilterActivity, null);
							}
							else if ( sACTION_TYPE.StartsWith("custom") )
							{
								XmlNode xCustomActivity = xoml.CreateActivity(parent, sRELATED_MODULE);
								xoml.SetNameAttribute(xCustomActivity, sFilterActivity);
								xoml.SetAttribute(xCustomActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
								xCustomActivity.AppendChild(xoml.CreateWhitespace("\n"));
								hashCustomFilters.Add(sFilterActivity, null);
							}
							else if ( sACTION_TYPE == "new" )
							{
								if ( !Sql.IsEmptyString(sRELATED_MODULE) )
								{
									XmlDocument xmlRelatedModules = rdl.GetCustomProperty("RelatedModules");
									string sRELATED       = sRELATED_MODULE.Split(' ')[0];
									string sRELATED_ALIAS = sRELATED_MODULE.Split(' ')[1];
									// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
									// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
									// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
									string[] arrRELATED_MODULE = sRELATED_MODULE.Split(' ');
									string sRELATIONSHIP_NAME = String.Empty;
									if ( arrRELATED_MODULE.Length >= 3 )
										sRELATIONSHIP_NAME = arrRELATED_MODULE[2];
								
									// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
									// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
									XmlNode xRelationship = null;
									if ( !Sql.IsEmptyString(sRELATIONSHIP_NAME) )
										xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RELATIONSHIP_NAME=\'" + sRELATIONSHIP_NAME + "\']");
									else
										xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RHS_MODULE=\'" + sRELATED + "\']");
									if ( xRelationship != null )
									{
										//string sRELATIONSHIP_NAME              = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_NAME"             );
										//string sLHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "LHS_MODULE"                    );
										string sLHS_TABLE                      = XmlUtil.SelectSingleNode(xRelationship, "LHS_TABLE"                     );
										string sLHS_KEY                        = XmlUtil.SelectSingleNode(xRelationship, "LHS_KEY"                       );
										string sRHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "RHS_MODULE"                    );
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
											sActivityName = ActivityFromModuleName(sRHS_MODULE);
											XmlNode xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
											xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
											xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
											// 10/22/2008 Paul.  We have switched the modules in the edit page, so we have to switch back here. 
											// Instead of attempting to use the module do determine the key, just use the first key that is not ID. 
											if ( sLHS_KEY != "ID" )
												xoml.SetAttribute(xRelatedActivity, sLHS_KEY, "{ActivityBind " + sBaseName + ",Path=ID}");
											else if ( sRHS_KEY != "ID" )
												xoml.SetAttribute(xRelatedActivity, sRHS_KEY, "{ActivityBind " + sBaseName + ",Path=ID}");
											xRelatedActivity.AppendChild(xoml.CreateWhitespace("\n"));
										}
										else
										{
											sActivityName = ActivityFromModuleName(sRHS_MODULE);
											XmlNode xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
											xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
											xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
											xRelatedActivity.AppendChild(xoml.CreateWhitespace("\n"));

											sActivityName = "RelationshipActivity";
											XmlNode xRelationshipActivity = xoml.CreateActivity(parent, sActivityName);
											xoml.SetNameAttribute(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex));
											xoml.SetAttribute(xRelationshipActivity, "WORKFLOW_ID"                   , "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
											xoml.SetAttribute(xRelationshipActivity, "LHS_TABLE"                     , sLHS_TABLE                     );
											xoml.SetAttribute(xRelationshipActivity, "LHS_KEY"                       , sLHS_KEY                       );
											xoml.SetAttribute(xRelationshipActivity, "RHS_MODULE"                    , sRHS_MODULE                    );
											xoml.SetAttribute(xRelationshipActivity, "RHS_TABLE"                     , sRHS_TABLE                     );
											xoml.SetAttribute(xRelationshipActivity, "RHS_KEY"                       , sRHS_KEY                       );
											xoml.SetAttribute(xRelationshipActivity, "JOIN_TABLE"                    , sJOIN_TABLE                    );
											xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_LHS"                  , sJOIN_KEY_LHS                  );
											xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_RHS"                  , sJOIN_KEY_RHS                  );
											xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN"      , sRELATIONSHIP_ROLE_COLUMN      );
											xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN_VALUE", sRELATIONSHIP_ROLE_COLUMN_VALUE);
											xRelationshipActivity.AppendChild(xoml.CreateWhitespace("\n"));
											xoml.CreateSetValueActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "LHS_VALUE", "{ActivityBind " + sBaseName + ",Path=" + sLHS_KEY + "}", "equals");
											xoml.CreateSetValueActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "RHS_VALUE", "{ActivityBind " + XomlDocument.CamelCase(sRELATED_ALIAS + sIndex) + ",Path=ID}", "equals");
											xoml.CreateCodeActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "Save");
										}
									}
								}
							}
							xAlias = xoml.SelectActivityName(xoml.DocumentElement, sFilterActivity);
						}
						if ( xAlias != null )
						{
							// 11/07/2010 Paul.  Add Custom Method and Custom Property. 
							// 08/03/2012 Paul.  Add Custom Stored Procedure. 
							if ( sACTION_TYPE == "custom_procedure" )
							{
								xoml.CreateCodeActivity(xAlias, "StoredProcedureActivity" + sIndex, "ExecuteStoredProcedure");
							}
							else if ( sACTION_TYPE == "custom_method" )
							{
								xoml.CreateCodeActivity(xAlias, sRELATED_MODULE + sIndex, sFIELD_NAME);
							}
							else
							{
								// 11/09/2010 Paul.  Instead of just allowing Today() in a date field, use the rules engine to allow anything. 
								if ( sSEARCH_TEXT1.StartsWith("=") )
								{
									xoml.CreateSetRuleActivity(xAlias, sFilterActivity, sFIELD_NAME, sSEARCH_TEXT1);
								}
								else
								{
									switch ( sCOMMON_DATA_TYPE )
									{
										case "string":
										case "int32":
										case "decimal":
										case "float":
										case "bool":
										case "guid":
										case "enum":
										{
											xoml.CreateSetValueActivity(xAlias, sFilterActivity, sFIELD_NAME, sSEARCH_TEXT1, "equals");
											break;
										}
										case "datetime":
										{
											// 05/04/2009 Paul.  We need to allow the date to be an activity binding. 
											if ( sSEARCH_TEXT1.ToUpper().Contains("DATEADD(") || sSEARCH_TEXT1.StartsWith("{ActivityBind ") )
											{
												xoml.CreateSetValueActivity(xAlias, sFilterActivity, sFIELD_NAME, sSEARCH_TEXT1, "equals");
											}
											else if ( arrSEARCH_TEXT.Length > 0 )
											{
												// 11/09/2010 Paul.  Default to yyyy/MM/dd, but also allow other date formats. 
												DateTime dtSEARCH_TEXT1 = DateTime.MinValue;
												try
												{
													dtSEARCH_TEXT1 = DateTime.ParseExact(sSEARCH_TEXT1, "yyyy/MM/dd", Thread.CurrentThread.CurrentCulture.DateTimeFormat);
												}
												catch
												{
													dtSEARCH_TEXT1 = DateTime.Parse(sSEARCH_TEXT1);
												}
												// 12/08/2009 Amit.  The quotes were causing the date parsing to fail.  
												// The quotes are not necessary as the value is expected to be properly escaped by the XML generator. 
												sSEARCH_TEXT1 = dtSEARCH_TEXT1.ToString("yyyy/MM/dd");
												xoml.CreateSetValueActivity(xAlias, sFilterActivity, sFIELD_NAME, sSEARCH_TEXT1, "equals");
											}
											break;
										}
									}
								}
							}
						}
					}
				}
				// 08/01/2008 Paul.  Nodes that have a SetValueActivity should have a Save activity appended. 
				foreach ( XmlNode node in parent.ChildNodes )
				{
					XmlNode xSetValue = xoml.SelectNode(node, "crm:SetValueActivity");
					XmlNode xSetRule  = xoml.SelectNode(node, "crm:SetRuleActivity" );
					// 11/09/2010 Paul.  We need to save after a SetRuleActivity. 
					if ( (xSetValue != null || xSetRule != null) && node.Name != "crm:RelationshipActivity" )
					{
						sActivityName = String.Empty;
						foreach ( XmlAttribute att in node.Attributes )
						{
							if ( att.Name == "x:Name" )
								sActivityName = att.Value;
						}
						// 11/01/2010 Paul.  A Custom Activity will not have a Save method. 
						if ( !hashCustomFilters.ContainsKey(sActivityName) )
							xoml.CreateCodeActivity(node, sActivityName, "Save");
					}
				}
			}
		}

		public void UpdateMasterWorkflowXoml(Guid gPARENT_ID, IDbTransaction trn)
		{
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			IDbConnection con = trn.Connection;
			using ( IDbCommand cmd = con.CreateCommand() )
			{
				cmd.Transaction = trn;
				string sSQL;
				// 07/12/2010 Paul.  We need the Parent to the Workflow so that we can detect if this is a Scheduled Report workflow. 
				sSQL = "select BASE_MODULE            " + ControlChars.CrLf
				     + "     , TYPE                   " + ControlChars.CrLf
				     + "     , FIRE_ORDER             " + ControlChars.CrLf
				     + "     , CUSTOM_XOML            " + ControlChars.CrLf
				     + "     , PARENT_ID              " + ControlChars.CrLf
				     + "  from vwWORKFLOWS            " + ControlChars.CrLf
				     + " where ID = @ID               " + ControlChars.CrLf;
				cmd.CommandText = sSQL;
				// 08/30/2009 Paul.  @ was missing. 
				Sql.AddParameter(cmd, "@ID", gPARENT_ID);

				string sBASE_MODULE   = String.Empty;
				string sMODULE_TABLE  = String.Empty;
				string sFIRE_ORDER    = String.Empty;
				string sWORKFLOW_TYPE = String.Empty;
				using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
				{
					if ( rdr.Read() )
					{
						sBASE_MODULE   = Sql.ToString (rdr["BASE_MODULE"]);
						sFIRE_ORDER    = Sql.ToString (rdr["FIRE_ORDER" ]);
						sWORKFLOW_TYPE = Sql.ToString (rdr["TYPE"       ]);
						sMODULE_TABLE  = Sql.ToString(Application["Modules." + sBASE_MODULE + ".TableName"]);
						// 08/22/2008 Paul.  If a custom workflow has been applied, then exit early. 
						bool bCUSTOM_XOML  = Sql.ToBoolean(rdr["CUSTOM_XOML"]);
						if ( bCUSTOM_XOML )
							return;
					}
					else
					{
						// 08/22/2008 Paul.  If the master workflow record does not exist, then exit early. 
						return;
					}
				}

				XomlDocument xoml = new XomlDocument(XmlUtil);
				xoml = new XomlDocument(XmlUtil, "Workflow1", gPARENT_ID);
				using ( DbDataAdapter da = dbf.CreateDataAdapter() )
				{
					((IDbDataAdapter)da).SelectCommand = cmd;

					int i = 1;
					XmlNode xParallelActivity = null;
					if ( sFIRE_ORDER == "alerts_actions" || sFIRE_ORDER == "alerts_actions_sequential" )
					{
						// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
						sSQL = "select NAME                         " + ControlChars.CrLf
						     + "     , ALERT_TYPE                   " + ControlChars.CrLf
						     + "     , ALERT_TEXT                   " + ControlChars.CrLf
						     + "     , SOURCE_TYPE                  " + ControlChars.CrLf
						     + "     , CUSTOM_TEMPLATE_ID           " + ControlChars.CrLf
						     + "     , DATE_ENTERED                 " + ControlChars.CrLf
						     + "     , CUSTOM_XOML                  " + ControlChars.CrLf
						     + "     , RDL                          " + ControlChars.CrLf
						     + "     , XOML                         " + ControlChars.CrLf
						     + "     , ASSIGNED_USER_ID             " + ControlChars.CrLf
						     + "     , TEAM_ID                      " + ControlChars.CrLf
						     + "     , TEAM_SET_LIST                " + ControlChars.CrLf
						     + "  from vwWORKFLOW_ALERT_SHELLS_Edit " + ControlChars.CrLf
						     + " where PARENT_ID = @PARENT_ID       " + ControlChars.CrLf
						     + " order by DATE_ENTERED              " + ControlChars.CrLf;
						cmd.Parameters.Clear();
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "PARENT_ID", gPARENT_ID);
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);

							// 10/22/2008 Paul.  The order of the alerts is not important, but the order of the actions may be important. 
							if ( dt.Rows.Count > 1 && sFIRE_ORDER == "alerts_actions" )
								xParallelActivity = xoml.CreateParallelActivity(xoml.DocumentElement, "ParallelAlerts1");
							else
								xParallelActivity = xoml.DocumentElement;
							foreach ( DataRow row in dt.Rows )
							{
								bool bCUSTOM_XOML = Sql.ToBoolean(row["CUSTOM_XOML"]);
								if ( !bCUSTOM_XOML )
								{
									string sALERT_NAME         = Sql.ToString(row["NAME"              ]);
									string sALERT_TYPE         = Sql.ToString(row["ALERT_TYPE"        ]);
									string sALERT_TEXT         = Sql.ToString(row["ALERT_TEXT"        ]);
									string sSOURCE_TYPE        = Sql.ToString(row["SOURCE_TYPE"       ]);
									Guid   gCUSTOM_TEMPLATE_ID = Sql.ToGuid  (row["CUSTOM_TEMPLATE_ID"]);
									string sRDL                = Sql.ToString(row["RDL"               ]);
									// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
									Guid   gASSIGNED_USER_ID   = Sql.ToGuid  (row["ASSIGNED_USER_ID"  ]);
									Guid   gTEAM_ID            = Sql.ToGuid  (row["TEAM_ID"           ]);
									string sTEAM_SET_LIST      = Sql.ToString(row["TEAM_SET_LIST"     ]);
									RdlDocument rdl = new RdlDocument(hostingEnvironment, this.Session, Security, SplendidCache, XmlUtil);
									if ( !Sql.IsEmptyString(sRDL) )
									{
										rdl.LoadRdl(sRDL);
										// 08/22/2008 Paul.  All children must be Sequence, so wrap them all in an outer sequence. 
										// Activity 'Alerts1' validation failed: All children must be of type Sequence
										// We also need the outer sequence so that we can make sure to apply the Send or Save actions only within the appropriate scope. 
										XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
										// 07/12/2010 Paul.  We need the Parent to the Workflow so that we can detect if this is a Scheduled Report workflow. 
										// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
										this.BuildAlertXOML(xoml, xSequenceActivity, rdl, sWORKFLOW_TYPE, sBASE_MODULE, sMODULE_TABLE, sALERT_NAME, sALERT_TYPE, sALERT_TEXT, sSOURCE_TYPE, gCUSTOM_TEMPLATE_ID, i, gASSIGNED_USER_ID, gTEAM_ID, sTEAM_SET_LIST);
									}
								}
								else
								{
									string sXOML = Sql.ToString(row["XOML"]);
									XomlDocument xomlCustom = new XomlDocument(XmlUtil);
									if ( !Sql.IsEmptyString(sXOML) )
									{
										xomlCustom.LoadXoml(sXOML);
										XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
										foreach ( XmlNode node in xomlCustom.DocumentElement.ChildNodes )
										{
											XmlNode xImport = xoml.ImportNode(node, true);
											xSequenceActivity.AppendChild(xImport);
										}
									}
								}
								i++;
							}
						}
						sSQL = "select DATE_ENTERED                 " + ControlChars.CrLf
						     + "     , CUSTOM_XOML                  " + ControlChars.CrLf
						     + "     , RDL                          " + ControlChars.CrLf
						     + "     , XOML                         " + ControlChars.CrLf
						     + "  from vwWORKFLOW_ACTION_SHELLS_Edit" + ControlChars.CrLf
						     + " where PARENT_ID = @PARENT_ID       " + ControlChars.CrLf
						     + " order by DATE_ENTERED              " + ControlChars.CrLf;
						cmd.Parameters.Clear();
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "PARENT_ID", gPARENT_ID);
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);

							if ( dt.Rows.Count > 1 )
								xParallelActivity = xoml.CreateParallelActivity(xoml.DocumentElement, "ParallelActions1");
							else
								xParallelActivity = xoml.DocumentElement;
							foreach ( DataRow row in dt.Rows )
							{
								bool bCUSTOM_XOML = Sql.ToBoolean(row["CUSTOM_XOML"]);
								if ( !bCUSTOM_XOML )
								{
									string sRDL = Sql.ToString(row["RDL"]);
									RdlDocument rdl = new RdlDocument(hostingEnvironment, this.Session, Security, SplendidCache, XmlUtil);
									if ( !Sql.IsEmptyString(sRDL) )
									{
										rdl.LoadRdl(sRDL);
										// 08/22/2008 Paul.  All children must be Sequence, so wrap them all in an outer sequence. 
										// Activity 'Alerts1' validation failed: All children must be of type Sequence
										// We also need the outer sequence so that we can make sure to apply the Send or Save actions only within the appropriate scope. 
										XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
										this.BuildActionXOML(xoml, xSequenceActivity, rdl, sWORKFLOW_TYPE, sBASE_MODULE, sMODULE_TABLE, i);
									}
								}
								else
								{
									string sXOML = Sql.ToString(row["XOML"]);
									XomlDocument xomlCustom = new XomlDocument(XmlUtil);
									if ( !Sql.IsEmptyString(sXOML) )
									{
										xomlCustom.LoadXoml(sXOML);
										XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
										foreach ( XmlNode node in xomlCustom.DocumentElement.ChildNodes )
										{
											XmlNode xImport = xoml.ImportNode(node, true);
											xSequenceActivity.AppendChild(xImport);
										}
									}
								}
								i++;
							}
						}
					}
					else if ( sFIRE_ORDER == "actions_alerts" || sFIRE_ORDER == "actions_sequential_alerts" )
					{
						sSQL = "select DATE_ENTERED                 " + ControlChars.CrLf
						     + "     , CUSTOM_XOML                  " + ControlChars.CrLf
						     + "     , RDL                          " + ControlChars.CrLf
						     + "     , XOML                         " + ControlChars.CrLf
						     + "  from vwWORKFLOW_ACTION_SHELLS_Edit" + ControlChars.CrLf
						     + " where PARENT_ID = @PARENT_ID       " + ControlChars.CrLf
						     + " order by DATE_ENTERED              " + ControlChars.CrLf;
						cmd.Parameters.Clear();
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "PARENT_ID", gPARENT_ID);
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);

							// 10/22/2008 Paul.  The order of the alerts is not important, but the order of the actions may be important. 
							if ( dt.Rows.Count > 1 && sFIRE_ORDER == "actions_alerts" )
								xParallelActivity = xoml.CreateParallelActivity(xoml.DocumentElement, "ParallelActions1");
							else
								xParallelActivity = xoml.DocumentElement;
							foreach ( DataRow row in dt.Rows )
							{
								bool bCUSTOM_XOML = Sql.ToBoolean(row["CUSTOM_XOML"]);
								if ( !bCUSTOM_XOML )
								{
									string sRDL = Sql.ToString(row["RDL"]);
									RdlDocument rdl = new RdlDocument(hostingEnvironment, this.Session, Security, SplendidCache, XmlUtil);
									if ( !Sql.IsEmptyString(sRDL) )
									{
										rdl.LoadRdl(sRDL);
										// 08/22/2008 Paul.  All children must be Sequence, so wrap them all in an outer sequence. 
										// Activity 'Alerts1' validation failed: All children must be of type Sequence
										// We also need the outer sequence so that we can make sure to apply the Send or Save actions only within the appropriate scope. 
										XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
										this.BuildActionXOML(xoml, xSequenceActivity, rdl, sWORKFLOW_TYPE, sBASE_MODULE, sMODULE_TABLE, i);
									}
								}
								else
								{
									string sXOML = Sql.ToString(row["XOML"]);
									XomlDocument xomlCustom = new XomlDocument(XmlUtil);
									if ( !Sql.IsEmptyString(sXOML) )
									{
										xomlCustom.LoadXoml(sXOML);
										XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
										foreach ( XmlNode node in xomlCustom.DocumentElement.ChildNodes )
										{
											XmlNode xImport = xoml.ImportNode(node, true);
											xSequenceActivity.AppendChild(xImport);
										}
									}
								}
								i++;
							}
						}
						// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
						sSQL = "select NAME                         " + ControlChars.CrLf
						     + "     , ALERT_TYPE                   " + ControlChars.CrLf
						     + "     , ALERT_TEXT                   " + ControlChars.CrLf
						     + "     , SOURCE_TYPE                  " + ControlChars.CrLf
						     + "     , CUSTOM_TEMPLATE_ID           " + ControlChars.CrLf
						     + "     , DATE_ENTERED                 " + ControlChars.CrLf
						     + "     , CUSTOM_XOML                  " + ControlChars.CrLf
						     + "     , RDL                          " + ControlChars.CrLf
						     + "     , XOML                         " + ControlChars.CrLf
						     + "     , ASSIGNED_USER_ID             " + ControlChars.CrLf
						     + "     , TEAM_ID                      " + ControlChars.CrLf
						     + "     , TEAM_SET_LIST                " + ControlChars.CrLf
						     + "  from vwWORKFLOW_ALERT_SHELLS_Edit " + ControlChars.CrLf
						     + " where PARENT_ID = @PARENT_ID       " + ControlChars.CrLf
						     + " order by DATE_ENTERED              " + ControlChars.CrLf;
						cmd.Parameters.Clear();
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "PARENT_ID", gPARENT_ID);
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);

							if ( dt.Rows.Count > 1 )
								xParallelActivity = xoml.CreateParallelActivity(xoml.DocumentElement, "ParallelAlerts1");
							else
								xParallelActivity = xoml.DocumentElement;
							foreach ( DataRow row in dt.Rows )
							{
								bool bCUSTOM_XOML = Sql.ToBoolean(row["CUSTOM_XOML"]);
								if ( !bCUSTOM_XOML )
								{
									string sALERT_NAME         = Sql.ToString(row["NAME"              ]);
									string sALERT_TYPE         = Sql.ToString(row["ALERT_TYPE"        ]);
									string sALERT_TEXT         = Sql.ToString(row["ALERT_TEXT"        ]);
									string sSOURCE_TYPE        = Sql.ToString(row["SOURCE_TYPE"       ]);
									Guid   gCUSTOM_TEMPLATE_ID = Sql.ToGuid  (row["CUSTOM_TEMPLATE_ID"]);
									string sRDL                = Sql.ToString(row["RDL"               ]);
									// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
									Guid   gASSIGNED_USER_ID   = Sql.ToGuid  (row["ASSIGNED_USER_ID"  ]);
									Guid   gTEAM_ID            = Sql.ToGuid  (row["TEAM_ID"           ]);
									string sTEAM_SET_LIST      = Sql.ToString(row["TEAM_SET_LIST"     ]);
									RdlDocument rdl = new RdlDocument(hostingEnvironment, this.Session, Security, SplendidCache, XmlUtil);
									if ( !Sql.IsEmptyString(sRDL) )
									{
										rdl.LoadRdl(sRDL);
										// 08/22/2008 Paul.  All children must be Sequence, so wrap them all in an outer sequence. 
										// Activity 'Alerts1' validation failed: All children must be of type Sequence
										// We also need the outer sequence so that we can make sure to apply the Send or Save actions only within the appropriate scope. 
										XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
										// 07/12/2010 Paul.  We need the Parent to the Workflow so that we can detect if this is a Scheduled Report workflow. 
										// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
										this.BuildAlertXOML(xoml, xSequenceActivity, rdl, sWORKFLOW_TYPE, sBASE_MODULE, sMODULE_TABLE, sALERT_NAME, sALERT_TYPE, sALERT_TEXT, sSOURCE_TYPE, gCUSTOM_TEMPLATE_ID, i, gASSIGNED_USER_ID, gTEAM_ID, sTEAM_SET_LIST);
									}
								}
								else
								{
									string sXOML = Sql.ToString(row["XOML"]);
									XomlDocument xomlCustom = new XomlDocument(XmlUtil);
									if ( !Sql.IsEmptyString(sXOML) )
									{
										xomlCustom.LoadXoml(sXOML);
										XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
										foreach ( XmlNode node in xomlCustom.DocumentElement.ChildNodes )
										{
											XmlNode xImport = xoml.ImportNode(node, true);
											xSequenceActivity.AppendChild(xImport);
										}
									}
								}
								i++;
							}
						}
					}
				}
				SqlProcs.spWORKFLOWS_UpdateXOML(gPARENT_ID, false, xoml.OuterXml, trn);
			}
		}
		// 10/08/2023 Paul.  Convert WF3 XOML to WF4 XAML. 
		public string BuildWF4Xaml(Guid gID)
		{
			XamlDocument xaml = new XamlDocument(XmlUtil);
			XmlElement xActivity = xaml.CreateRootActivity();

			string sBASE_MODULE   = String.Empty;
			string sMODULE_TABLE  = String.Empty;
			string sFIRE_ORDER    = String.Empty;
			string sWORKFLOW_TYPE = String.Empty;
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				string sSQL ;
				sSQL = "select *               " + ControlChars.CrLf
				     + "  from vwWORKFLOWS_Edit" + ControlChars.CrLf
				     + " where ID = @ID        " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gID);
					con.Open();
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dtCurrent = new DataTable() )
						{
							da.Fill(dtCurrent);
							if ( dtCurrent.Rows.Count > 0 )
							{
								DataRow rdr = dtCurrent.Rows[0];
								sBASE_MODULE   = Sql.ToString (rdr["BASE_MODULE"]);
								sFIRE_ORDER    = Sql.ToString (rdr["FIRE_ORDER" ]);
								sWORKFLOW_TYPE = Sql.ToString (rdr["TYPE"       ]);
								sMODULE_TABLE  = Sql.ToString (Application["Modules." + sBASE_MODULE + ".TableName"]);
							}
						}
					}
				}

				XmlElement xMembers = xaml.CreateMembers(xActivity);
				//xaml.CreateProperty(xMembers, "BUSINESS_PROCESS_ID", "InArgument(s:Guid)"  );
				xaml.CreateProperty(xMembers, "WORKFLOW_ID"        , "InArgument(s:Guid)"  );
				xaml.CreateProperty(xMembers, "AUDIT_ID"           , "InArgument(s:Guid)"  );
				xaml.CreateProperty(xMembers, "ID"                 , "InArgument(s:Guid)"  );
				xaml.CreateProperty(xMembers, "BASE_MODULE"        , "InArgument(x:String)");
				DataTable dtFields = SplendidCache.WorkflowFilterColumns(sBASE_MODULE);
				foreach ( DataRow row in dtFields.Rows )
				{
					string sNAME   = Sql.ToString(row["NAME"  ]);
					string sCsType = Sql.ToString(row["CsType"]);
					string sTYPE   = Workflow4BuildXaml.CsTypeToXamlType(sCsType);
					if ( sNAME == "WORKFLOW_ID" ||sNAME == "AUDIT_ID" || sNAME == "ID" || sNAME == "BASE_MODULE" )
						continue;
					xaml.CreateProperty(xMembers, sNAME, "InArgument(" + sTYPE + ")");
				}
				Guid gPROCESS_USER_ID  = Guid.Empty;
				string sBpmnID = "StartEvent_1";

				XmlElement xParallel = xaml.CreateParallel(xActivity);
				XmlElement xFlowchart = xaml.CreateFlowchart(xParallel, sBpmnID);
				XmlElement xFlowchartVariables = xaml.CreateFlowchartVariables(xFlowchart);

				xaml.CreateVariable(xFlowchartVariables, "PROCESS_USER_ID", "s:Guid", gPROCESS_USER_ID.ToString());

				int i = 1;
				string sStartStepID    = String.Empty;
				string sBpmnLastStepID = String.Empty;
				XmlElement xFlowStep = null;
				XmlElement xSequence = null;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						if ( sFIRE_ORDER == "alerts_actions" || sFIRE_ORDER == "alerts_actions_sequential" )
						{
							#region Alerts
							// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
							sSQL = "select ID                           " + ControlChars.CrLf
							     + "     , NAME                         " + ControlChars.CrLf
							     + "     , ALERT_TYPE                   " + ControlChars.CrLf
							     + "     , ALERT_TEXT                   " + ControlChars.CrLf
							     + "     , SOURCE_TYPE                  " + ControlChars.CrLf
							     + "     , CUSTOM_TEMPLATE_ID           " + ControlChars.CrLf
							     + "     , CUSTOM_TEMPLATE_NAME         " + ControlChars.CrLf
							     + "     , DATE_ENTERED                 " + ControlChars.CrLf
							     + "     , CUSTOM_XOML                  " + ControlChars.CrLf
							     + "     , RDL                          " + ControlChars.CrLf
							     + "     , XOML                         " + ControlChars.CrLf
							     + "     , ASSIGNED_USER_ID             " + ControlChars.CrLf
							     + "     , ASSIGNED_TO                  " + ControlChars.CrLf
							     + "     , TEAM_ID                      " + ControlChars.CrLf
							     + "     , TEAM_NAME                    " + ControlChars.CrLf
							     + "     , TEAM_SET_LIST                " + ControlChars.CrLf
							     + "     , TEAM_SET_NAME                " + ControlChars.CrLf
							     + "  from vwWORKFLOW_ALERT_SHELLS_Edit " + ControlChars.CrLf
							     + " where PARENT_ID = @PARENT_ID       " + ControlChars.CrLf
							     + " order by DATE_ENTERED              " + ControlChars.CrLf;
							cmd.Parameters.Clear();
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "PARENT_ID", gID);
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									string sBpmnStepID = "EndEvent_" + Sql.ToString(row["ID"]).Replace("-", "");
									if ( String.IsNullOrEmpty(sStartStepID) )
									{
										sStartStepID = sBpmnStepID;
										xaml.CreateFlowchartStartNode(xFlowchart, sStartStepID);
									}
									if ( xFlowStep != null && !String.IsNullOrEmpty(sBpmnLastStepID) )
									{
										xaml.CreateFlowStepNext(xFlowStep, sBpmnLastStepID);
									}
									sBpmnLastStepID = sBpmnStepID;
									bool bCUSTOM_XOML = Sql.ToBoolean(row["CUSTOM_XOML"]);
									if ( !bCUSTOM_XOML )
									{
										string sALERT_SUBJECT        = Sql.ToString(row["NAME"                ]);
										string sALERT_TYPE           = Sql.ToString(row["ALERT_TYPE"          ]);
										string sALERT_TEXT           = Sql.ToString(row["ALERT_TEXT"          ]);
										string sSOURCE_TYPE          = Sql.ToString(row["SOURCE_TYPE"         ]);
										Guid   gCUSTOM_TEMPLATE_ID   = Sql.ToGuid  (row["CUSTOM_TEMPLATE_ID"  ]);
										string sCUSTOM_TEMPLATE_NAME = Sql.ToString(row["CUSTOM_TEMPLATE_NAME"]);
										string sRDL                  = Sql.ToString(row["RDL"                 ]);
										// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
										Guid   gASSIGNED_USER_ID     = Sql.ToGuid  (row["ASSIGNED_USER_ID"    ]);
										string sASSIGNED_USER_NAME   = Sql.ToString(row["ASSIGNED_TO"         ]);
										Guid   gTEAM_ID              = Sql.ToGuid  (row["TEAM_ID"             ]);
										string sTEAM_NAME            = Sql.ToString(row["TEAM_NAME"           ]);
										string sTEAM_SET_LIST        = Sql.ToString(row["TEAM_SET_LIST"       ]);
										string sTEAM_SET_NAME        = Sql.ToString(row["TEAM_SET_NAME"       ]);

										RdlDocument rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
										if ( !Sql.IsEmptyString(sRDL) )
										{
											rdl.LoadRdl(sRDL);
											// 08/22/2008 Paul.  All children must be Sequence, so wrap them all in an outer sequence. 
											// Activity 'Alerts1' validation failed: All children must be of type Sequence
											// We also need the outer sequence so that we can make sure to apply the Send or Save actions only within the appropriate scope. 
											//XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
											// 07/12/2010 Paul.  We need the Parent to the Workflow so that we can detect if this is a Scheduled Report workflow. 
											// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
											//WorkflowBuilder.BuildAlertXOML(xoml, xSequenceActivity, rdl, sWORKFLOW_TYPE, sBASE_MODULE, sMODULE_TABLE, sALERT_NAME, sALERT_TYPE, sALERT_TEXT, sSOURCE_TYPE, gCUSTOM_TEMPLATE_ID, i, gASSIGNED_USER_ID, gTEAM_ID, sTEAM_SET_LIST);

											xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
											xSequence = xaml.CreateSequence(xFlowStep , sBpmnStepID);
											BuildAlertXAML(Application, xaml, xFlowchart, xSequence, sBpmnStepID, i, rdl, sALERT_SUBJECT, sALERT_TYPE, sALERT_TEXT, sSOURCE_TYPE, gCUSTOM_TEMPLATE_ID, sCUSTOM_TEMPLATE_NAME, sRDL, gASSIGNED_USER_ID, sASSIGNED_USER_NAME, gTEAM_ID, sTEAM_NAME, sTEAM_SET_LIST, sTEAM_SET_NAME);
										}
									}
									else
									{
										/*
										string sXOML = Sql.ToString(row["XOML"]);
										XomlDocument xomlCustom = new XomlDocument();
										if ( !Sql.IsEmptyString(sXOML) )
										{
											xomlCustom.LoadXoml(sXOML);
											XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
											foreach ( XmlNode node in xomlCustom.DocumentElement.ChildNodes )
											{
												XmlNode xImport = xoml.ImportNode(node, true);
												xSequenceActivity.AppendChild(xImport);
											}
										}
										*/
									}
									i++;
								}
							}
							#endregion
							#region Actions
							sSQL = "select ID                           " + ControlChars.CrLf
							     + "     , DATE_ENTERED                 " + ControlChars.CrLf
							     + "     , CUSTOM_XOML                  " + ControlChars.CrLf
							     + "     , RDL                          " + ControlChars.CrLf
							     + "     , XOML                         " + ControlChars.CrLf
							     + "  from vwWORKFLOW_ACTION_SHELLS_Edit" + ControlChars.CrLf
							     + " where PARENT_ID = @PARENT_ID       " + ControlChars.CrLf
							     + " order by DATE_ENTERED              " + ControlChars.CrLf;
							cmd.Parameters.Clear();
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "PARENT_ID", gID);
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									string sBpmnStepID = "BusinessRuleTask_" + Sql.ToString(row["ID"]).Replace("-", "");
									if ( String.IsNullOrEmpty(sStartStepID) )
									{
										sStartStepID = sBpmnStepID;
										xaml.CreateFlowchartStartNode(xFlowchart, sStartStepID);
									}
									if ( xFlowStep != null && !String.IsNullOrEmpty(sBpmnLastStepID) )
									{
										xaml.CreateFlowStepNext(xFlowStep, sBpmnLastStepID);
									}
									bool bCUSTOM_XOML = Sql.ToBoolean(row["CUSTOM_XOML"]);
									if ( !bCUSTOM_XOML )
									{
										string sRDL = Sql.ToString(row["RDL"]);
										RdlDocument rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
										if ( !Sql.IsEmptyString(sRDL) )
										{
											rdl.LoadRdl(sRDL);
											// 08/22/2008 Paul.  All children must be Sequence, so wrap them all in an outer sequence. 
											// Activity 'Alerts1' validation failed: All children must be of type Sequence
											// We also need the outer sequence so that we can make sure to apply the Send or Save actions only within the appropriate scope. 
											//XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
											//WorkflowBuilder.BuildActionXOML(xoml, xSequenceActivity, rdl, sWORKFLOW_TYPE, sBASE_MODULE, sMODULE_TABLE, i);

											xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
											xSequence = xaml.CreateSequence(xFlowStep , sBpmnStepID);
											BuildActionXAML(Application, xaml, xFlowchart, xSequence, sBpmnStepID, i, rdl);
										}
									}
									else
									{
										/*
										string sXOML = Sql.ToString(row["XOML"]);
										XomlDocument xomlCustom = new XomlDocument();
										if ( !Sql.IsEmptyString(sXOML) )
										{
											xomlCustom.LoadXoml(sXOML);
											XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
											foreach ( XmlNode node in xomlCustom.DocumentElement.ChildNodes )
											{
												XmlNode xImport = xoml.ImportNode(node, true);
												xSequenceActivity.AppendChild(xImport);
											}
										}
										*/
									}
									i++;
								}
							}
							#endregion
						}
						else if ( sFIRE_ORDER == "actions_alerts" || sFIRE_ORDER == "actions_sequential_alerts" )
						{
							#region Actions
							sSQL = "select ID                           " + ControlChars.CrLf
							     + "     , DATE_ENTERED                 " + ControlChars.CrLf
							     + "     , CUSTOM_XOML                  " + ControlChars.CrLf
							     + "     , RDL                          " + ControlChars.CrLf
							     + "     , XOML                         " + ControlChars.CrLf
							     + "  from vwWORKFLOW_ACTION_SHELLS_Edit" + ControlChars.CrLf
							     + " where PARENT_ID = @PARENT_ID       " + ControlChars.CrLf
							     + " order by DATE_ENTERED              " + ControlChars.CrLf;
							cmd.Parameters.Clear();
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "PARENT_ID", gID);
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									string sBpmnStepID = "BusinessRuleTask_" + Sql.ToString(row["ID"]).Replace("-", "");
									if ( String.IsNullOrEmpty(sStartStepID) )
									{
										sStartStepID = sBpmnStepID;
										xaml.CreateFlowchartStartNode(xFlowchart, sStartStepID);
									}
									if ( xFlowStep != null && !String.IsNullOrEmpty(sBpmnLastStepID) )
									{
										xaml.CreateFlowStepNext(xFlowStep, sBpmnLastStepID);
									}
									bool bCUSTOM_XOML = Sql.ToBoolean(row["CUSTOM_XOML"]);
									if ( !bCUSTOM_XOML )
									{
										string sRDL = Sql.ToString(row["RDL"]);
										RdlDocument rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
										if ( !Sql.IsEmptyString(sRDL) )
										{
											rdl.LoadRdl(sRDL);
											// 08/22/2008 Paul.  All children must be Sequence, so wrap them all in an outer sequence. 
											// Activity 'Alerts1' validation failed: All children must be of type Sequence
											// We also need the outer sequence so that we can make sure to apply the Send or Save actions only within the appropriate scope. 
											//XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
											//WorkflowBuilder.BuildActionXOML(xoml, xSequenceActivity, rdl, sWORKFLOW_TYPE, sBASE_MODULE, sMODULE_TABLE, i);
											
											xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
											xSequence = xaml.CreateSequence(xFlowStep , sBpmnStepID);
											BuildActionXAML(Application, xaml, xFlowchart, xSequence, sBpmnStepID, i, rdl);
										}
									}
									else
									{
										/*
										string sXOML = Sql.ToString(row["XOML"]);
										XomlDocument xomlCustom = new XomlDocument();
										if ( !Sql.IsEmptyString(sXOML) )
										{
											xomlCustom.LoadXoml(sXOML);
											XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
											foreach ( XmlNode node in xomlCustom.DocumentElement.ChildNodes )
											{
												XmlNode xImport = xoml.ImportNode(node, true);
												xSequenceActivity.AppendChild(xImport);
											}
										}
										*/
									}
									i++;
								}
							}
							#endregion
							#region Alerts
							// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
							sSQL = "select ID                           " + ControlChars.CrLf
							     + "     , NAME                         " + ControlChars.CrLf
							     + "     , ALERT_TYPE                   " + ControlChars.CrLf
							     + "     , ALERT_TEXT                   " + ControlChars.CrLf
							     + "     , SOURCE_TYPE                  " + ControlChars.CrLf
							     + "     , CUSTOM_TEMPLATE_ID           " + ControlChars.CrLf
							     + "     , DATE_ENTERED                 " + ControlChars.CrLf
							     + "     , CUSTOM_XOML                  " + ControlChars.CrLf
							     + "     , RDL                          " + ControlChars.CrLf
							     + "     , XOML                         " + ControlChars.CrLf
							     + "     , ASSIGNED_USER_ID             " + ControlChars.CrLf
							     + "     , ASSIGNED_TO                  " + ControlChars.CrLf
							     + "     , TEAM_ID                      " + ControlChars.CrLf
							     + "     , TEAM_NAME                    " + ControlChars.CrLf
							     + "     , TEAM_SET_LIST                " + ControlChars.CrLf
							     + "     , TEAM_SET_NAME                " + ControlChars.CrLf
							     + "  from vwWORKFLOW_ALERT_SHELLS_Edit " + ControlChars.CrLf
							     + " where PARENT_ID = @PARENT_ID       " + ControlChars.CrLf
							     + " order by DATE_ENTERED              " + ControlChars.CrLf;
							cmd.Parameters.Clear();
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "PARENT_ID", gID);
							using ( DataTable dt = new DataTable() )
							{
								da.Fill(dt);
								foreach ( DataRow row in dt.Rows )
								{
									string sBpmnStepID = "EndEvent_" + Sql.ToString(row["ID"]).Replace("-", "");
									if ( String.IsNullOrEmpty(sStartStepID) )
									{
										sStartStepID = sBpmnStepID;
										xaml.CreateFlowchartStartNode(xFlowchart, sStartStepID);
									}
									if ( xFlowStep != null && !String.IsNullOrEmpty(sBpmnLastStepID) )
									{
										xaml.CreateFlowStepNext(xFlowStep, sBpmnLastStepID);
									}
									bool bCUSTOM_XOML = Sql.ToBoolean(row["CUSTOM_XOML"]);
									if ( !bCUSTOM_XOML )
									{
										string sALERT_SUBJECT        = Sql.ToString(row["NAME"                ]);
										string sALERT_TYPE           = Sql.ToString(row["ALERT_TYPE"          ]);
										string sALERT_TEXT           = Sql.ToString(row["ALERT_TEXT"          ]);
										string sSOURCE_TYPE          = Sql.ToString(row["SOURCE_TYPE"         ]);
										Guid   gCUSTOM_TEMPLATE_ID   = Sql.ToGuid  (row["CUSTOM_TEMPLATE_ID"  ]);
										string sCUSTOM_TEMPLATE_NAME = Sql.ToString(row["CUSTOM_TEMPLATE_NAME"]);
										string sRDL                  = Sql.ToString(row["RDL"                 ]);
										// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
										Guid   gASSIGNED_USER_ID     = Sql.ToGuid  (row["ASSIGNED_USER_ID"    ]);
										string sASSIGNED_USER_NAME   = Sql.ToString(row["ASSIGNED_TO"         ]);
										Guid   gTEAM_ID              = Sql.ToGuid  (row["TEAM_ID"             ]);
										string sTEAM_NAME            = Sql.ToString(row["TEAM_NAME"           ]);
										string sTEAM_SET_LIST        = Sql.ToString(row["TEAM_SET_LIST"       ]);
										string sTEAM_SET_NAME        = Sql.ToString(row["TEAM_SET_NAME"       ]);
										RdlDocument rdl = new RdlDocument(hostingEnvironment, Session, Security, SplendidCache, XmlUtil);
										if ( !Sql.IsEmptyString(sRDL) )
										{
											rdl.LoadRdl(sRDL);
											// 08/22/2008 Paul.  All children must be Sequence, so wrap them all in an outer sequence. 
											// Activity 'Alerts1' validation failed: All children must be of type Sequence
											// We also need the outer sequence so that we can make sure to apply the Send or Save actions only within the appropriate scope. 
											//XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
											// 07/12/2010 Paul.  We need the Parent to the Workflow so that we can detect if this is a Scheduled Report workflow. 
											// 03/15/2013 Paul.  Allow the user to specify an ASSIGNED_USER_ID or TEAM_ID. 
											//WorkflowBuilder.BuildAlertXOML(xoml, xSequenceActivity, rdl, sWORKFLOW_TYPE, sBASE_MODULE, sMODULE_TABLE, sALERT_NAME, sALERT_TYPE, sALERT_TEXT, sSOURCE_TYPE, gCUSTOM_TEMPLATE_ID, i, gASSIGNED_USER_ID, gTEAM_ID, sTEAM_SET_LIST);

											xFlowStep = xaml.CreateFlowStep(xFlowchart, sBpmnStepID);
											xSequence = xaml.CreateSequence(xFlowStep , sBpmnStepID);
											BuildAlertXAML(Application, xaml, xFlowchart, xSequence, sBpmnStepID, i, rdl, sALERT_SUBJECT, sALERT_TYPE, sALERT_TEXT, sSOURCE_TYPE, gCUSTOM_TEMPLATE_ID, sCUSTOM_TEMPLATE_NAME, sRDL, gASSIGNED_USER_ID, sASSIGNED_USER_NAME, gTEAM_ID, sTEAM_NAME, sTEAM_SET_LIST, sTEAM_SET_NAME);
										}
									}
									else
									{
										/*
										string sXOML = Sql.ToString(row["XOML"]);
										XomlDocument xomlCustom = new XomlDocument();
										if ( !Sql.IsEmptyString(sXOML) )
										{
											xomlCustom.LoadXoml(sXOML);
											XmlNode xSequenceActivity = xoml.CreateSequenceActivity(xParallelActivity, "Sequence" + i.ToString());
											foreach ( XmlNode node in xomlCustom.DocumentElement.ChildNodes )
											{
												XmlNode xImport = xoml.ImportNode(node, true);
												xSequenceActivity.AppendChild(xImport);
											}
										}
										*/
									}
									i++;
								}
							}
							#endregion
						}
					}
				}
				sBpmnLastStepID = "SplendidCRM_EndStep";
				// 10/27/2023 Paul.  A poorly constructed workflow without any alerts or actions will not have a flow step. 
				if ( xFlowStep != null )
					xaml.CreateFlowStepNext(xFlowStep, sBpmnLastStepID);
				else
					xaml.CreateFlowchartStartNode(xFlowchart, sBpmnLastStepID);

				XmlElement xEndStep = xaml.CreateFlowStep(xFlowchart, "SplendidCRM_EndStep");
				xaml.CreateEndActivity(xEndStep);
			}
			return xaml.OutputFormatted();
		}

		public void BuildAlertXAML(HttpApplicationState Application, XamlDocument xaml, XmlElement xFlowchart, XmlElement xSequence, string sBpmnStepID, int iSequence, RdlDocument rdl, string sALERT_SUBJECT, string sALERT_TYPE, string sALERT_TEXT, string sSOURCE_TYPE, Guid   gCUSTOM_TEMPLATE_ID, string sCUSTOM_TEMPLATE_NAME, string sRDL, Guid gASSIGNED_USER_ID, string sASSIGNED_USER_NAME, Guid gTEAM_ID, string sTEAM_NAME, string sTEAM_SET_LIST, string sTEAM_SET_NAME)
		{
			XmlElement xSequenceVariables = xaml.CreateSequenceVariables(xSequence);
			// 09/28/2016 Paul.  We need to escape curly brackets as they are a XAML primative. 
			// Character ':' was unexpected in string '::future::Orders::name::'. Invalid XAML type name. 
			// https://msdn.microsoft.com/en-us/library/ms744986.aspx
			// 09/29/22016 Paul.  Expression is fine. 
			if ( sALERT_SUBJECT.Contains("{") && !sALERT_SUBJECT.StartsWith("=") )
				sALERT_SUBJECT = "{}" + sALERT_SUBJECT;
			if ( sALERT_TEXT.Contains("{") && !sALERT_TEXT.StartsWith("=") )
				sALERT_TEXT = "{}" + sALERT_TEXT;
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ALERT_TYPE"          , "x:String"                  , Sql.ToString(sALERT_TYPE          ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "SOURCE_TYPE"         , "x:String"                  , Sql.ToString(sSOURCE_TYPE         ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ALERT_SUBJECT"       , "x:String"                  , Sql.ToString(sALERT_SUBJECT       ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ALERT_TEXT"          , "x:String"                  , Sql.ToString(sALERT_TEXT          ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "CUSTOM_TEMPLATE_ID"  , "s:Guid"                    , Sql.ToString(gCUSTOM_TEMPLATE_ID  ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "CUSTOM_TEMPLATE_NAME", "x:String"                  , Sql.ToString(sCUSTOM_TEMPLATE_NAME));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ASSIGNED_USER_ID"    , "s:Guid"                    , Sql.ToString(gASSIGNED_USER_ID    ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ASSIGNED_USER_NAME"  , "x:String"                  , Sql.ToString(sASSIGNED_USER_NAME  ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "TEAM_ID"             , "s:Guid"                    , Sql.ToString(gTEAM_ID             ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "TEAM_NAME"           , "x:String"                  , Sql.ToString(sTEAM_NAME           ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "TEAM_SET_LIST"       , "x:String"                  , Sql.ToString(sTEAM_SET_LIST       ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "TEAM_SET_NAME"       , "x:String"                  , Sql.ToString(sTEAM_SET_NAME       ));
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "RECIPIENTS"          , "scg:List(crm:WF4Recipient)", "[New List(Of WF4Recipient)]"      );
			xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "REPORTS"             , "scg:List(crm:WF4Report)"   , "[New List(Of WF4Report)]"         );

			XmlDocument xmlFilters = rdl.GetCustomProperty("Filters");
			XmlNodeList nlRecipients  = xmlFilters.DocumentElement.SelectNodes("Filter");
			foreach ( XmlNode xRecipient in nlRecipients )
			{
				string sACTION_TYPE    = XmlUtil.SelectSingleNode(xRecipient, "ACTION_TYPE"      );  // current_user
				string sRELATED_MODULE = XmlUtil.SelectSingleNode(xRecipient, "RELATIONSHIP_NAME");
				string sMODULE_NAME    = XmlUtil.SelectSingleNode(xRecipient, "MODULE_NAME"      );  // Calls
				string sTABLE_NAME     = XmlUtil.SelectSingleNode(xRecipient, "TABLE_NAME"       );  // CALLS
				string sDATA_FIELD     = XmlUtil.SelectSingleNode(xRecipient, "DATA_FIELD"       );  // CALLS.ASSIGNED_USER_ID
				string sFIELD_NAME     = XmlUtil.SelectSingleNode(xRecipient, "FIELD_NAME"       );  // ASSIGNED_USER_ID
				string sDATA_TYPE      = XmlUtil.SelectSingleNode(xRecipient, "DATA_TYPE"        );
				string sOPERATOR       = XmlUtil.SelectSingleNode(xRecipient, "OPERATOR"         );  // to
				string sRECIPIENT_NAME = XmlUtil.SelectSingleNode(xRecipient, "RECIPIENT_NAME"   );
				string sSEARCH_TEXT    = XmlUtil.SelectSingleNode(xRecipient, "SEARCH_TEXT"      );

				string sFilterActivity = XomlDocument.CamelCase(sMODULE_NAME.Split(' ')[1] + iSequence.ToString());
				string[] arrModule   = sMODULE_NAME.Split(' ');
				string sModule       = arrModule[0];
				string sTableAlias   = arrModule[1];
				if ( sTableAlias == "USERS_ALL" || sACTION_TYPE == "specific_user" )
				{
					sDATA_TYPE = "Users";
					// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
					//xoml.CreateAddRecipientActivity(xAlertActivity, sAlertName, sRECIPIENT_NAME, sSEARCH_TEXT, sDATA_TYPE, sOPERATOR, String.Empty, String.Empty);
				}
				else if ( sTableAlias == "TEAMS" || sACTION_TYPE == "specific_team" )
				{
					sDATA_TYPE = "Teams";
					// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
					//xoml.CreateAddRecipientActivity(xAlertActivity, sAlertName, sRECIPIENT_NAME, sSEARCH_TEXT, sDATA_TYPE, sOPERATOR, String.Empty, String.Empty);
				}
				else if ( sTableAlias == "ACL_ROLES" || sACTION_TYPE == "specific_role" )
				{
					sDATA_TYPE = "Roles";
					// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
					//xoml.CreateAddRecipientActivity(xAlertActivity, sAlertName, sRECIPIENT_NAME, sSEARCH_TEXT, sDATA_TYPE, sOPERATOR, String.Empty, String.Empty);
				}
				else
				{
					if ( sACTION_TYPE == "record" )
						sDATA_TYPE = "Record";
					else if ( sACTION_TYPE == "custom_field" )
						sDATA_TYPE = "Record_Custom";
					else
						sDATA_TYPE = "Users";
					if ( sFIELD_NAME == "TEAM_ID" )
						sDATA_TYPE = "Teams";
					// 06/20/2014 Paul.  Allow text columns to be added to the list of recipients. 
					//string sRECIPIENT_TABLE = String.Empty;
					//string sRECIPIENT_FIELD = String.Empty;
					//if ( !arrIncludedColumns.Contains(sFIELD_NAME) )
					//{
					//	sRECIPIENT_TABLE = sTABLE_NAME;
					//	sRECIPIENT_FIELD = sFIELD_NAME;
					//	sFIELD_NAME      = "ID";
					//}
					//xoml.CreateAddRecipientActivity(xAlertActivity, sAlertName, sFilterActivity, sRECIPIENT_NAME, sFIELD_NAME, sDATA_TYPE, sOPERATOR, sRECIPIENT_TABLE, sRECIPIENT_FIELD);
				}
				string sSEND_TYPE       =            sOPERATOR      ;
				string sRECIPIENT_TYPE  =            sDATA_TYPE     ;
				Guid   gRECIPIENT_ID    = Sql.ToGuid(sSEARCH_TEXT  );
				string sRECIPIENT_FIELD =            sFIELD_NAME    ;
				string sRECIPIENT_TABLE =            sTABLE_NAME    ;
				if ( !(sRECIPIENT_TYPE == "Roles" || sRECIPIENT_TYPE == "Users" || sRECIPIENT_TYPE == "Teams") )
				{
					string sRECIPIENT_MODULE = sRECIPIENT_TYPE.Replace("_AUDIT", String.Empty);
					sRECIPIENT_TABLE = Sql.ToString(Application["Modules." + sRECIPIENT_MODULE + ".TableName"]);
					if ( sRECIPIENT_TYPE.EndsWith("_AUDIT") )
					{
						sRECIPIENT_TABLE += "_AUDIT";
					}
				}
				xaml.CreateRecipientActivity(xSequence, sBpmnStepID, sSEND_TYPE, sRECIPIENT_TYPE, gRECIPIENT_ID, sRECIPIENT_NAME, sRECIPIENT_TABLE, sRECIPIENT_FIELD);
			}
			XmlDocument xmlReports = rdl.GetCustomProperty("ReportAttachments");
			XmlNodeList nlReports  = xmlReports.DocumentElement.SelectNodes("Report");
			foreach ( XmlNode xReport in nlReports )
			{
				string sID                =            XmlUtil.SelectSingleNode(xReport, "ID"               );
				Guid   gREPORT_ID         = Sql.ToGuid(XmlUtil.SelectSingleNode(xReport, "REPORT_ID"        ));
				string sREPORT_NAME       =            XmlUtil.SelectSingleNode(xReport, "REPORT_NAME"      );
				string sRENDER_FORMAT     =            XmlUtil.SelectSingleNode(xReport, "RENDER_FORMAT"    );
				Guid   gSCHEDULED_USER_ID = Sql.ToGuid(XmlUtil.SelectSingleNode(xReport, "SCHEDULED_USER_ID"));
				string sREPORT_PARAMETERS =            XmlUtil.SelectSingleNode(xReport, "REPORT_PARAMETERS");
				
				string sBpmnReportID = "Report_" + Sql.ToString(sID).Replace("-", "");;
				// 07/16/2016 Paul.  We need to create a parameters variable for each report. 
				string sREPORT_PARAMETERS_VARIABLE = "REPORT_PARAMETERS_" + sBpmnReportID;
				// 12/09/2017 Paul.  Correct the name of the parameters variable. 
				xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + sREPORT_PARAMETERS_VARIABLE, "scg:List(crm:WF4ReportParameter)", "[New List(Of WF4ReportParameter)]");
				if ( !Sql.IsEmptyString(sREPORT_PARAMETERS) )
				{
					string[] arrReportParameters = sREPORT_PARAMETERS.Split('&');
					if ( arrReportParameters.Length > 0 )
					{
						foreach ( string sParameter in arrReportParameters )
						{
							// 11/19/2023 Paul.  parameter may have multiple equals, so can't use split. 
							int nEquals = sParameter.IndexOf('=');
							string sNAME  = String.Empty;
							string sVALUE = String.Empty;
							if ( nEquals > 0 )
							{
								sNAME = sParameter.Substring(0, nEquals);
								sVALUE = sParameter.Substring(nEquals + 1);
								// 11/19/2023 Paul.  /Parent is used to refer to <crm:AlertActivity />, so We don't use PARENT_ID of base module, it is the ID. 
								// {ActivityBind /Parent,Path=PARENT_ID}
								if ( sVALUE == "{ActivityBind /Parent,Path=PARENT_ID}" )
								{
									sVALUE = "[Sql.ToString(ID)]";
								}
								else if ( sVALUE.StartsWith("{ActivityBind ") )
								{
									nEquals = sVALUE.IndexOf('=');
									if ( nEquals > 0 )
										sVALUE = "[" + sVALUE.Substring(nEquals + 1).Replace("}", "") + "].ToString()";
								}
							}
							if ( !Sql.IsEmptyString(sNAME) )
							{
								xaml.CreateReportParameterActivity(xSequence, sBpmnStepID, sNAME, sVALUE, sREPORT_PARAMETERS_VARIABLE);
							}
						}
					}
				}
				xaml.CreateReportActivity(xSequence, sBpmnStepID, gREPORT_ID, sREPORT_NAME, sRENDER_FORMAT, gSCHEDULED_USER_ID, sREPORT_PARAMETERS_VARIABLE);
			}
			xaml.CreateAlertActivity(xSequence, sBpmnStepID);
		}

		public string XamlDataType(string sDATA_TYPE)
		{
			string xDataType = "x:String";
			switch ( sDATA_TYPE )
			{
				case "string" :  xDataType = "x:String" ;  break;
				case "guid"   :  xDataType = "s:Guid"   ;  break;
				case "int32"  :  xDataType = "x:String" ;  break;
				case "decimal":  xDataType = "x:Decimal";  break;
				case "float"  :  xDataType = "x:float"  ;  break;
				case "bool"   :  xDataType = "x:Boolean";  break;
				case "int"    :  xDataType = "x:int"    ;  break;
				case "enum"   :  xDataType = "x:int"    ;  break;
				default       :  xDataType = "x:String" ;  break;
			}
			return xDataType;
		}

		public void BuildActionXAML(HttpApplicationState Application, XamlDocument xaml, XmlElement xFlowchart, XmlElement xSequence, string sBpmnStepID, int iSequence, RdlDocument rdl)
		{
			XmlElement xSequenceVariables = xaml.CreateSequenceVariables(xSequence);

			string sUpdateActivityModule = String.Empty;
			Dictionary<string, XmlElement> dictSequenceVariables = new Dictionary<string,XmlElement>();
			XmlDocument xmlFilters = rdl.GetCustomProperty("Filters");
			XmlNodeList nlFilters  = xmlFilters.DocumentElement.SelectNodes("Filter");
			List<string> lstCustomProps = new List<string>();
			foreach ( XmlNode xFilter in nlFilters )
			{
				string sACTION_TYPE    = XmlUtil.SelectSingleNode(xFilter, "ACTION_TYPE"      );
				string sRELATED_MODULE = XmlUtil.SelectSingleNode(xFilter, "RELATIONSHIP_NAME");
				string sMODULE_NAME    = XmlUtil.SelectSingleNode(xFilter, "MODULE_NAME"      );
				string sTABLE_NAME     = XmlUtil.SelectSingleNode(xFilter, "TABLE_NAME"       );
				string sDATA_FIELD     = XmlUtil.SelectSingleNode(xFilter, "DATA_FIELD"       );
				string sFIELD_NAME     = XmlUtil.SelectSingleNode(xFilter, "FIELD_NAME"       );
				string sDATA_TYPE      = XmlUtil.SelectSingleNode(xFilter, "DATA_TYPE"        );
				string sOPERATOR       = XmlUtil.SelectSingleNode(xFilter, "OPERATOR"         );
				string sSEARCH_TEXT1   = String.Empty;

				#region sACTION_TYPE custom_procedure
				if ( sACTION_TYPE == "custom_procedure" )
				{
					XmlElement xVariableID = xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "ID", "s:Guid", String.Empty);
					dictSequenceVariables.Add("ID", xVariableID);
					xaml.CreateAssignActivity(xSequence, "s:Guid", sBpmnStepID + "_" + "ID", "[ID]");
					
					XmlElement xVariableMODULE_NAME = xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + "MODULE_NAME", "x:String", String.Empty);
					dictSequenceVariables.Add("MODULE_NAME", xVariableMODULE_NAME);
					xaml.CreateAssignActivity(xSequence, "x:String", sBpmnStepID + "_" + "MODULE_NAME", "[BASE_MODULE]");
					
					XmlElement xSqlProcedure = xaml.CreateElement("crm", "WF4SqlProcedureActivity", xaml.CrmNamespace);
					xSequence.AppendChild(xSqlProcedure);
					xaml.CreateAttributeValue(xSqlProcedure, "PROCEDURE_NAME", sDATA_FIELD);
					xaml.CreateAttributeValue(xSqlProcedure, "FIELD_PREFIX"  , sBpmnStepID + "_");
				}
				#endregion
				#region sACTION_TYPE custom_prop and custom_method
				else if ( sACTION_TYPE == "custom_prop" )
				{
					// 10/14/2023 Paul.  WORKFLOW_ID is a workflow global, so skip the part where we manually assign in XAML. 
					// 10/14/2023 Paul.  AUDIT_ID is a workflow global, so skip the part where we manually assign in XAML. 
					if ( sDATA_FIELD != "AUDIT_ID" && sDATA_FIELD != "WORKFLOW_ID" )
					{
						XmlNodeList nlValues = xFilter.SelectNodes("SEARCH_TEXT_VALUES");
						string[] arrSEARCH_TEXT = new string[nlValues.Count];
						int i = 0;
						foreach ( XmlNode xValue in nlValues )
						{
							arrSEARCH_TEXT[i++] = xValue.InnerText;
						}
						if ( arrSEARCH_TEXT.Length > 0 )
						{
							sSEARCH_TEXT1 = arrSEARCH_TEXT[0];
							if ( sSEARCH_TEXT1.StartsWith("{ActivityBind") && sSEARCH_TEXT1.Contains("Path=") )
							{
								sSEARCH_TEXT1 = sSEARCH_TEXT1.Split('=')[1].Replace("}", "");
							}
						}
						if ( !dictSequenceVariables.ContainsKey(sDATA_FIELD) )
						{
							string xDataType = XamlDataType(sDATA_TYPE);
							XmlElement xVariable = xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + sDATA_FIELD, xDataType, String.Empty);
							dictSequenceVariables.Add(sDATA_FIELD, xVariable);
						}
						if ( !Sql.IsEmptyString(sSEARCH_TEXT1) )
							xaml.CreateAssignActivity(xSequence, "s:Guid", sBpmnStepID + "_" + sDATA_FIELD, "[" + sSEARCH_TEXT1 + "]");
						lstCustomProps.Add(sDATA_FIELD);
					}
				}
				else if ( sACTION_TYPE == "custom_method" )
				{
					if ( sRELATED_MODULE.EndsWith("SyncActivity") )
						sRELATED_MODULE += "WF4";
					XmlElement xCustomActivity = xaml.CreateElement("crm", sRELATED_MODULE, xaml.CrmNamespace);
					xSequence.AppendChild(xCustomActivity);
					foreach ( string sNAME in lstCustomProps )
					{
						xaml.CreateAttributeValueReference(xCustomActivity, sNAME, sBpmnStepID + "_" + sNAME);
					}
				}
				#endregion
				#region sACTION_TYPE custom_prop and custom_method
				else if ( sACTION_TYPE == "update" )
				{
					if ( Sql.IsEmptyString(sUpdateActivityModule) )
					{
						sUpdateActivityModule = sMODULE_NAME.Split(' ')[0];
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
					string xDataType = XamlDataType(sDATA_TYPE);
					// 11/08/2023 Paul.  Assign values through Sequence Variables.  
					if ( !dictSequenceVariables.ContainsKey(sFIELD_NAME) )
					{
						XmlElement xVariable = xaml.CreateVariable(xSequenceVariables, sBpmnStepID + "_" + sFIELD_NAME, xDataType, String.Empty);
						dictSequenceVariables.Add(sFIELD_NAME, xVariable);
					}
					xaml.CreateAssignActivity(xSequence, xDataType, sBpmnStepID + "_" + sFIELD_NAME, sSEARCH_TEXT1);
				}
				#endregion
				#region Old unused code
				else
				{
					/*
					#region sACTION_TYPE update_rel
					if ( sACTION_TYPE == "update_rel" )
					{
						if ( !Sql.IsEmptyString(sRELATED_MODULE) )
						{
							XmlDocument xmlRelatedModules = rdl.GetCustomProperty("RelatedModules");
							string sRELATED       = sRELATED_MODULE.Split(' ')[0];
							string sRELATED_ALIAS = sRELATED_MODULE.Split(' ')[1];
							// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
							// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
							// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
							string[] arrRELATED_MODULE = sRELATED_MODULE.Split(' ');
							string sRELATIONSHIP_NAME = String.Empty;
							if ( arrRELATED_MODULE.Length >= 3 )
								sRELATIONSHIP_NAME = arrRELATED_MODULE[2];
								
							// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
							// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
							XmlNode xRelationship = null;
							if ( !Sql.IsEmptyString(sRELATIONSHIP_NAME) )
								xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RELATIONSHIP_NAME=\'" + sRELATIONSHIP_NAME + "\']");
							else
								xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RHS_MODULE=\'" + sRELATED + "\']");
							if ( xRelationship != null )
							{
								//string sRELATIONSHIP_NAME              = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_NAME"             );
								//string sLHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "LHS_MODULE"                    );
								string sLHS_TABLE                      = XmlUtil.SelectSingleNode(xRelationship, "LHS_TABLE"                     );
								string sLHS_KEY                        = XmlUtil.SelectSingleNode(xRelationship, "LHS_KEY"                       );
								string sRHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "RHS_MODULE"                    );
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
									sActivityName = ActivityFromModuleName(sRHS_MODULE);
									// 02/21/2009 Paul.  Make sure to only create the related activity once. 
									XmlNode xRelatedActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
									if ( xRelatedActivity == null )
									{
										xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
										xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
										xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
										xoml.SetAttribute(xRelatedActivity, sRHS_KEY, "{ActivityBind " + sBaseName + ",Path=" + sLHS_KEY + "}");
										xoml.CreateCodeActivity(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex), "LoadByID");
									}
								}
								else
								{
									sActivityName = "RelationshipActivity";
									// 02/21/2009 Paul.  Make sure to only create the related activity once. 
									XmlNode xRelationshipActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sJOIN_TABLE + sIndex));
									if ( xRelationshipActivity == null )
									{
										xRelationshipActivity = xoml.CreateActivity(parent, sActivityName);
										xoml.SetNameAttribute(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex));
										xoml.SetAttribute(xRelationshipActivity, "WORKFLOW_ID"                   , "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
										xoml.SetAttribute(xRelationshipActivity, "LHS_TABLE"                     , sLHS_TABLE                     );
										xoml.SetAttribute(xRelationshipActivity, "LHS_KEY"                       , sLHS_KEY                       );
										xoml.SetAttribute(xRelationshipActivity, "RHS_MODULE"                    , sRHS_MODULE                    );
										xoml.SetAttribute(xRelationshipActivity, "RHS_TABLE"                     , sRHS_TABLE                     );
										xoml.SetAttribute(xRelationshipActivity, "RHS_KEY"                       , sRHS_KEY                       );
										xoml.SetAttribute(xRelationshipActivity, "JOIN_TABLE"                    , sJOIN_TABLE                    );
										xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_LHS"                  , sJOIN_KEY_LHS                  );
										xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_RHS"                  , sJOIN_KEY_RHS                  );
										xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN"      , sRELATIONSHIP_ROLE_COLUMN      );
										xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN_VALUE", sRELATIONSHIP_ROLE_COLUMN_VALUE);
										xRelationshipActivity.AppendChild(xoml.CreateWhitespace("\n"));
										xoml.CreateSetValueActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "LHS_VALUE", "{ActivityBind " + sBaseName + ",Path=" + sLHS_KEY + "}", "equals");
										xoml.CreateCodeActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "LoadByLHS");
									}

									sActivityName = ActivityFromModuleName(sRHS_MODULE);
									// 02/21/2009 Paul.  Make sure to only create the related activity once. 
									XmlNode xRelatedActivity = xoml.SelectActivityName(xoml.DocumentElement, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
									if ( xRelatedActivity == null )
									{
										xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
										xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
										xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
										xRelatedActivity.AppendChild(xoml.CreateWhitespace("\n"));
										xoml.CreateSetValueActivity(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex), "ID", "{ActivityBind " + XomlDocument.CamelCase(sJOIN_TABLE + sIndex) + ",Path=RHS_VALUE}", "equals");
										xoml.CreateCodeActivity(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex), "LoadByID");
									}
								}
							}
						}
					}
					#endregion

					XmlNodeList nlValues = xFilter.SelectNodes("SEARCH_TEXT_VALUES");
					string[] arrSEARCH_TEXT = new string[nlValues.Count];
					int i = 0;
					foreach ( XmlNode xValue in nlValues )
					{
						arrSEARCH_TEXT[i++] = xValue.InnerText;
					}
					if ( arrSEARCH_TEXT.Length > 0 )
						sSEARCH_TEXT1 = arrSEARCH_TEXT[0];

					string sCOMMON_DATA_TYPE = sDATA_TYPE;
					if ( sCOMMON_DATA_TYPE == "ansistring" )
						sCOMMON_DATA_TYPE = "string";

					// 11/01/2010 Paul.  Add Custom Activity Action Type. 
					// 11/07/2010 Paul.  Add Custom Method and Custom Property. 
					// 08/03/2012 Paul.  Add Custom Stored Procedure. 
					string sFilterActivity = String.Empty;
					if ( sACTION_TYPE == "custom_procedure" )
						sFilterActivity = "StoredProcedureActivity" + sIndex;
					else if ( sACTION_TYPE.StartsWith("custom") )
						sFilterActivity = sRELATED_MODULE + sIndex;
					else
						sFilterActivity = XomlDocument.CamelCase(sMODULE_NAME.Split(' ')[1] + sIndex);
					XmlNode xAlias = xoml.SelectActivityName(xoml.DocumentElement, sFilterActivity);
					if ( xAlias == null )
					{
						// 11/01/2010 Paul.  Add Custom Activity Action Type. 
						// 11/07/2010 Paul.  Add Custom Method and Custom Property. 
						// 08/03/2012 Paul.  Add Custom Stored Procedure. 
						#region sACTION_TYPE custom_procedure
						if ( sACTION_TYPE == "custom_procedure" )
						{
							XmlNode xCustomActivity = xoml.CreateActivity(parent, "StoredProcedureActivity");
							xoml.SetNameAttribute(xCustomActivity, sFilterActivity);
							xoml.SetAttribute(xCustomActivity, "WORKFLOW_ID"   , "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
							xoml.SetAttribute(xCustomActivity, "AUDIT_ID"      , "{ActivityBind Workflow1,Path=AUDIT_ID}"   );
							xoml.SetAttribute(xCustomActivity, "ID"            , "{ActivityBind Workflow1,Path=ID}"         );
							xoml.SetAttribute(xCustomActivity, "MODULE_NAME"   , sBaseModule                                );
							xoml.SetAttribute(xCustomActivity, "PROCEDURE_NAME", sDATA_FIELD                                );
							xCustomActivity.AppendChild(xoml.CreateWhitespace("\n"));
							hashCustomFilters.Add(sFilterActivity, null);
						}
						#endregion
						#region sACTION_TYPE custom
						else if ( sACTION_TYPE.StartsWith("custom") )
						{
							XmlNode xCustomActivity = xoml.CreateActivity(parent, sRELATED_MODULE);
							xoml.SetNameAttribute(xCustomActivity, sFilterActivity);
							xoml.SetAttribute(xCustomActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
							xCustomActivity.AppendChild(xoml.CreateWhitespace("\n"));
							hashCustomFilters.Add(sFilterActivity, null);
						}
						#endregion
						#region sACTION_TYPE new
						else if ( sACTION_TYPE == "new" )
						{
							if ( !Sql.IsEmptyString(sRELATED_MODULE) )
							{
								XmlDocument xmlRelatedModules = rdl.GetCustomProperty("RelatedModules");
								string sRELATED       = sRELATED_MODULE.Split(' ')[0];
								string sRELATED_ALIAS = sRELATED_MODULE.Split(' ')[1];
								// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
								// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
								// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
								string[] arrRELATED_MODULE = sRELATED_MODULE.Split(' ');
								string sRELATIONSHIP_NAME = String.Empty;
								if ( arrRELATED_MODULE.Length >= 3 )
									sRELATIONSHIP_NAME = arrRELATED_MODULE[2];
								
								// 12/11/2014 Paul.  Add the relationship so that we can have a unique lookup. 
								// 01/08/2015 Paul.  Older workflows will not have the relationship name, so fallback to old logic. 
								XmlNode xRelationship = null;
								if ( !Sql.IsEmptyString(sRELATIONSHIP_NAME) )
									xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RELATIONSHIP_NAME=\'" + sRELATIONSHIP_NAME + "\']");
								else
									xRelationship = xmlRelatedModules.DocumentElement.SelectSingleNode("Relationship[RHS_MODULE=\'" + sRELATED + "\']");
								if ( xRelationship != null )
								{
									//string sRELATIONSHIP_NAME              = XmlUtil.SelectSingleNode(xRelationship, "RELATIONSHIP_NAME"             );
									//string sLHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "LHS_MODULE"                    );
									string sLHS_TABLE                      = XmlUtil.SelectSingleNode(xRelationship, "LHS_TABLE"                     );
									string sLHS_KEY                        = XmlUtil.SelectSingleNode(xRelationship, "LHS_KEY"                       );
									string sRHS_MODULE                     = XmlUtil.SelectSingleNode(xRelationship, "RHS_MODULE"                    );
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
										sActivityName = ActivityFromModuleName(sRHS_MODULE);
										XmlNode xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
										xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
										xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
										// 10/22/2008 Paul.  We have switched the modules in the edit page, so we have to switch back here. 
										// Instead of attempting to use the module do determine the key, just use the first key that is not ID. 
										if ( sLHS_KEY != "ID" )
											xoml.SetAttribute(xRelatedActivity, sLHS_KEY, "{ActivityBind " + sBaseName + ",Path=ID}");
										else if ( sRHS_KEY != "ID" )
											xoml.SetAttribute(xRelatedActivity, sRHS_KEY, "{ActivityBind " + sBaseName + ",Path=ID}");
										xRelatedActivity.AppendChild(xoml.CreateWhitespace("\n"));
									}
									else
									{
										sActivityName = ActivityFromModuleName(sRHS_MODULE);
										XmlNode xRelatedActivity = xoml.CreateActivity(parent, sActivityName);
										xoml.SetNameAttribute(xRelatedActivity, XomlDocument.CamelCase(sRELATED_ALIAS + sIndex));
										xoml.SetAttribute(xRelatedActivity, "WORKFLOW_ID", "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
										xRelatedActivity.AppendChild(xoml.CreateWhitespace("\n"));

										sActivityName = "RelationshipActivity";
										XmlNode xRelationshipActivity = xoml.CreateActivity(parent, sActivityName);
										xoml.SetNameAttribute(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex));
										xoml.SetAttribute(xRelationshipActivity, "WORKFLOW_ID"                   , "{ActivityBind Workflow1,Path=WORKFLOW_ID}");
										xoml.SetAttribute(xRelationshipActivity, "LHS_TABLE"                     , sLHS_TABLE                     );
										xoml.SetAttribute(xRelationshipActivity, "LHS_KEY"                       , sLHS_KEY                       );
										xoml.SetAttribute(xRelationshipActivity, "RHS_MODULE"                    , sRHS_MODULE                    );
										xoml.SetAttribute(xRelationshipActivity, "RHS_TABLE"                     , sRHS_TABLE                     );
										xoml.SetAttribute(xRelationshipActivity, "RHS_KEY"                       , sRHS_KEY                       );
										xoml.SetAttribute(xRelationshipActivity, "JOIN_TABLE"                    , sJOIN_TABLE                    );
										xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_LHS"                  , sJOIN_KEY_LHS                  );
										xoml.SetAttribute(xRelationshipActivity, "JOIN_KEY_RHS"                  , sJOIN_KEY_RHS                  );
										xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN"      , sRELATIONSHIP_ROLE_COLUMN      );
										xoml.SetAttribute(xRelationshipActivity, "RELATIONSHIP_ROLE_COLUMN_VALUE", sRELATIONSHIP_ROLE_COLUMN_VALUE);
										xRelationshipActivity.AppendChild(xoml.CreateWhitespace("\n"));
										xoml.CreateSetValueActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "LHS_VALUE", "{ActivityBind " + sBaseName + ",Path=" + sLHS_KEY + "}", "equals");
										xoml.CreateSetValueActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "RHS_VALUE", "{ActivityBind " + XomlDocument.CamelCase(sRELATED_ALIAS + sIndex) + ",Path=ID}", "equals");
										xoml.CreateCodeActivity(xRelationshipActivity, XomlDocument.CamelCase(sJOIN_TABLE + sIndex), "Save");
									}
								}
							}
						}
						#endregion
						xAlias = xoml.SelectActivityName(xoml.DocumentElement, sFilterActivity);
					}
					if ( xAlias != null )
					{
						// 11/07/2010 Paul.  Add Custom Method and Custom Property. 
						// 08/03/2012 Paul.  Add Custom Stored Procedure. 
						if ( sACTION_TYPE == "custom_procedure" )
						{
							xoml.CreateCodeActivity(xAlias, "StoredProcedureActivity" + sIndex, "ExecuteStoredProcedure");
						}
						else if ( sACTION_TYPE == "custom_method" )
						{
							xoml.CreateCodeActivity(xAlias, sRELATED_MODULE + sIndex, sFIELD_NAME);
						}
						else
						{
							// 11/09/2010 Paul.  Instead of just allowing Today() in a date field, use the rules engine to allow anything. 
							if ( sSEARCH_TEXT1.StartsWith("=") )
							{
								xoml.CreateSetRuleActivity(xAlias, sFilterActivity, sFIELD_NAME, sSEARCH_TEXT1);
							}
							else
							{
								switch ( sCOMMON_DATA_TYPE )
								{
									case "string":
									case "int32":
									case "decimal":
									case "float":
									case "bool":
									case "guid":
									case "enum":
									{
										xoml.CreateSetValueActivity(xAlias, sFilterActivity, sFIELD_NAME, sSEARCH_TEXT1, "equals");
										break;
									}
									case "datetime":
									{
										// 05/04/2009 Paul.  We need to allow the date to be an activity binding. 
										if ( sSEARCH_TEXT1.ToUpper().Contains("DATEADD(") || sSEARCH_TEXT1.StartsWith("{ActivityBind ") )
										{
											xoml.CreateSetValueActivity(xAlias, sFilterActivity, sFIELD_NAME, sSEARCH_TEXT1, "equals");
										}
										else if ( arrSEARCH_TEXT.Length > 0 )
										{
											// 11/09/2010 Paul.  Default to yyyy/MM/dd, but also allow other date formats. 
											DateTime dtSEARCH_TEXT1 = DateTime.MinValue;
											try
											{
												dtSEARCH_TEXT1 = DateTime.ParseExact(sSEARCH_TEXT1, "yyyy/MM/dd", Thread.CurrentThread.CurrentCulture.DateTimeFormat);
											}
											catch
											{
												dtSEARCH_TEXT1 = DateTime.Parse(sSEARCH_TEXT1);
											}
											// 12/08/2009 Amit.  The quotes were causing the date parsing to fail.  
											// The quotes are not necessary as the value is expected to be properly escaped by the XML generator. 
											sSEARCH_TEXT1 = dtSEARCH_TEXT1.ToString("yyyy/MM/dd");
											xoml.CreateSetValueActivity(xAlias, sFilterActivity, sFIELD_NAME, sSEARCH_TEXT1, "equals");
										}
										break;
									}
								}
							}
						}
					}
				*/
				}
				#endregion
			}
			if ( !Sql.IsEmptyString(sUpdateActivityModule) )
			{
				// 11/08/2023 Paul.  FIELD_PREFIX should not be empty. 
				xaml.CreateSaveModuleActivity(xSequence, "[BASE_MODULE]", String.Empty, sBpmnStepID + "_", "[ID]");
			}
		}
	}
}
