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
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.Common;
using System.Xml;
using System.Xml.Schema;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;

using Microsoft.Reporting.NETCore;

namespace SplendidCRM
{
	public class ReportViewer
	{
		public LocalReport LocalReport;

		public ReportViewer()
		{
			this.LocalReport = new Microsoft.Reporting.NETCore.LocalReport();
		}
	}

	/// <summary>
	/// Summary description for RdlUtil.
	/// </summary>
	public partial class RdlUtil
	{
		// 08/12/2023 Paul.  Don't need ReportParameterThis. 
		/*
		public class ReportParameterThis : SqlObj
		{
			private object   oValue   ;
			
			public ReportParameterThis(object oValue)
			{
				this.oValue = oValue;
			}

			public object Value
			{
				get { return oValue; }
				set { oValue = value; }
			}
		}
		*/
		
		// 01/19/2010 Paul.  The Module Name is needed in order to apply ACL Field Security. 
		// 01/24/2010 Paul.  Pass the context so that it can be used in the Validation call. 
		// 11/26/2010 Paul.  LocalLoadReportDefinition was moved to a separate file so that the Community Edition would not need to include the ReportViewer library. 
		// 12/04/2010 Paul.  L10n is needed by the Rules Engine to allow translation of list terms. 
		// 10/06/2012 Paul.  REPORT_ID is needed for sub-report caching. 
		// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
		// 07/02/2023 Paul.  LocalLoadReportDefinition needs to be async, so it cannot have an out parameter. 
		public async Task LocalLoadReportDefinition(Dictionary<string, string> dictParameters, object ctlParameterView, L10N L10n, TimeZone T10n, ReportViewer rdlViewer, Guid gREPORT_ID, string sRDL, string sMODULE_NAME, Guid gSCHEDULED_USER_ID, Dictionary<string, object> dictBody)
		{
			DataSet ds = new DataSet();
			// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
			RdlDocument rdl = await LocalLoadReportDefinition(dictParameters, ctlParameterView, L10n, T10n, ds, sRDL, sMODULE_NAME, gSCHEDULED_USER_ID, false, null, dictBody);

			// 10/06/2012 Paul.  Capture and log errors. 
			// 06/30/2023 Paul.  TODO.  Investigate report handler. 
			//rdlViewer.LocalReport.ReportError += new ReportErrorEventHandler(rdlViewer_ReportError);
			//rdlViewer.ProcessingMode = ProcessingMode.Local;
			// 06/25/2006 Paul.  The data sources need to be cleared, otherwise the report will not refresh. 
			rdlViewer.LocalReport.DataSources.Clear();
			// 04/25/2008 Paul.  Use the description as the display name. 
			rdlViewer.LocalReport.DisplayName = rdl.SelectNodeValue("Description");
			if ( Sql.IsEmptyString(rdlViewer.LocalReport.DisplayName) )
				rdlViewer.LocalReport.DisplayName = "Report";

			foreach ( DataTable dt in ds.Tables )
			{
				ReportDataSource rds = new ReportDataSource(dt.TableName, dt);
				rdlViewer.LocalReport.DataSources.Add(rds);
			}
			/*
			http://forums.microsoft.com/MSDN/ShowPost.aspx?PostID=444154&SiteID=1
			Brian Hartman - MSFT  06 Jun 2006, 10:22 PM UTC
			LocalReport has a limitation that the report definition can't be changed once the report has been processed.  
			In winforms, you can use the ReportViewer.Reset() method to force the viewer to create a new instance of 
			LocalReport and workaround this issue.  But this method is currently not on the webforms version of report viewer.  
			We hope to add it in an upcoming service pack, but for now, 
			you must workaround this issue by creating a new instance of the ReportViewer. 
			*/
			/*
			// 07/09/2006 Paul.  Creating a new viewer solves the reset problem, but breaks ReportViewer pagination. 
			rdlViewer = new ReportViewer();
			rdlViewer.ID                  = "rdlViewer";
			rdlViewer.Font.Names          = new string[] { "Verdana" };
			rdlViewer.Font.Size           = new FontUnit("8pt");
			rdlViewer.Height              = new Unit("100%");
			rdlViewer.Width               = new Unit("100%");
			rdlViewer.AsyncRendering      = false;
			rdlViewer.SizeToReportContent = true;
			divReportView.Controls.Clear();
			divReportView.Controls.Add(rdlViewer);
			*/

			// 07/13/2006 Paul.  The ReportViewer is having a problem interpreting the date functions. 
			// To solve the problem, we should go through all the parameters and replace the date functions with values. 
			rdl.ReportViewerFixups();
			StringReader sr = new StringReader(rdl.OuterXml);
			// 04/24/2008 Paul.  Allow reports to contain links to images.  This is to allow the logo to be defined in the database.
			rdlViewer.LocalReport.EnableExternalImages = true;
			// 06/18/2008 Paul.  Allow reports to contain hyperlinks. 
			rdlViewer.LocalReport.EnableHyperlinks = true;
			rdlViewer.LocalReport.LoadReportDefinition(sr);
			
			// 10/01/2012 Paul.  Add support for sub reports. 
			// http://www.w3schools.com/xpath/xpath_syntax.asp
			// Subreport/ReportName
			XmlNodeList nlSubreports = rdl.DocumentElement.SelectNodes("//defaultns:Subreport/defaultns:ReportName", rdl.NamespaceManager);
			foreach ( XmlNode xSubreport in nlSubreports )
			{
				string sSubReportName = xSubreport.InnerText;
				if ( sSubReportName.StartsWith("/") )
					sSubReportName = sSubReportName.Substring(1);
				Guid gSUBREPORT_ID = SplendidCache.ReportByName(sSubReportName);
				if ( !Sql.IsEmptyGuid(gSUBREPORT_ID) )
				{
					rdlViewer.LocalReport.ShowDetailedSubreportMessages = true;
					// 10/06/2012 Paul.  We do not want to cache the subreport Name using HttpCache, but we don't want to do the lookup with every SubreportProcessing event. 
					Application[gREPORT_ID.ToString() + ".Subreport." + sSubReportName] = gSUBREPORT_ID;
					DataTable dtReport = SplendidCache.Report(gSUBREPORT_ID);
					if ( dtReport != null && dtReport.Rows.Count > 0 )
					{
						DataRow rdr = dtReport.Rows[0];
						string sSUBREPORT_RDL         = Sql.ToString(rdr["RDL"        ]);
						string sSUBREPORT_MODULE_NAME = Sql.ToString(rdr["MODULE_NAME"]);
						
						DataSet dsSubreport = null;
						string sSubReportSQL = String.Empty;
						// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
						RdlDocument rdlSubreport = await LocalLoadReportDefinition(null, null, L10n, T10n, dsSubreport, sSUBREPORT_RDL, sSUBREPORT_MODULE_NAME, gSCHEDULED_USER_ID, false, null, dictBody);
						rdlSubreport.ReportViewerFixups();
						StringReader srSubreport = new StringReader(rdlSubreport.OuterXml);
						// 10/05/2012 Paul.  Make sure to use the original subreport name. 
						rdlViewer.LocalReport.LoadSubreportDefinition(xSubreport.InnerText, srSubreport);
					}
				}
			}
			if ( nlSubreports.Count > 0 )
			{
				// 10/06/2012 Paul.  We need to use a delegate so that we can pass the Context, L10n, T10n and other data to the SubreportProcessing method. 
				rdlViewer.LocalReport.SubreportProcessing += async delegate(object sender, SubreportProcessingEventArgs e)
				{
					string sSubReportName = e.ReportPath;
					if ( sSubReportName.StartsWith("/") )
						sSubReportName = sSubReportName.Substring(1);
					
					Guid gSUBREPORT_ID = Sql.ToGuid(Application[gREPORT_ID.ToString() + ".Subreport." + sSubReportName]);
					if ( !Sql.IsEmptyGuid(gSUBREPORT_ID) )
					{
						//e.DataSourceNames;
						e.DataSources.Clear();
						DataTable dtReport = SplendidCache.Report(gSUBREPORT_ID);
						if ( dtReport != null && dtReport.Rows.Count > 0 )
						{
							DataRow rdr = dtReport.Rows[0];
							string sSUBREPORT_RDL         = Sql.ToString(rdr["RDL"        ]);
							string sSUBREPORT_MODULE_NAME = Sql.ToString(rdr["MODULE_NAME"]);
						
							DataSet dsSubreport = new DataSet();
							string sSubReportSQL = String.Empty;
							// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
							RdlDocument rdlSubreport = await LocalLoadReportDefinition(null, null, L10n, T10n, dsSubreport, sSUBREPORT_RDL, sSUBREPORT_MODULE_NAME, gSCHEDULED_USER_ID, false, e, dictBody);
							foreach ( DataTable dt in dsSubreport.Tables )
							{
								ReportDataSource rds = new ReportDataSource(dt.TableName, dt);
								e.DataSources.Add(rds);
							}
						}
					}
				};
			}
		}

		// 10/06/2012 Paul.  Capture and log errors. 
		private void rdlViewer_ReportError(object sender, ReportErrorEventArgs e)
		{
			try
			{
#if DEBUG
				Debug.WriteLine(Utils.ExpandException(e.Exception));
				Debug.WriteLine(e.Exception.StackTrace);
#endif
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), e.Exception);
			}
			catch
			{
			}
		}

		// 11/06/2011 Paul.  With charts, we modify the SQL to add grouping if it does not already exist. 
		// 04/06/2011 Paul.  We need a way to pull data from the Parameters form. 
		// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
		public async Task<RdlDocument> LocalLoadReportDefinition(Dictionary<string, string> dictParameters, object ctlParameterView, L10N L10n, TimeZone T10n, DataSet ds, string sRDL, string sMODULE_NAME, Guid gSCHEDULED_USER_ID, bool bChart, SubreportProcessingEventArgs eSubreportArgs, Dictionary<string, object> dictBody)
		{
			HttpRequest Request = Context.Request;
			ExchangeSession      Session     = null;
			string sReportSQL = String.Empty;
			RdlDocument rdl = new RdlDocument(hostingEnvironment, this.Session, Security, SplendidCache, XmlUtil);
			rdl.LoadRdl(sRDL);

			// 03/09/2012 Paul.  The new canned reports will contain Team logic that may need to be removed. 
			// 06/12/2012 Paul.  Can't use HttpContext.Current as this code is called in the background. 
			bool bEnableTeamManagement  = Sql.ToBoolean(Application["CONFIG.enable_team_management" ]);
			bool bRequireTeamManagement = Sql.ToBoolean(Application["CONFIG.require_team_management"]);
			bool bRequireUserAssignment = Sql.ToBoolean(Application["CONFIG.require_user_assignment"]);
			bool bEnableDynamicTeams    = Sql.ToBoolean(Application["CONFIG.enable_dynamic_teams"   ]);
			// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
			if ( !Sql.IsEmptyGuid(gSCHEDULED_USER_ID) )
			{
				Session = ExchangeSecurity.LoadUserACL(gSCHEDULED_USER_ID);
			}
			// 01/17/2013 Paul.  A customer wants to be able to change the assigned user as this was previously allowed in report prompts. 
			bool bShowAssignedUser = Sql.ToBoolean(Application["CONFIG.Reports.ShowAssignedUser"]);
			XmlNodeList nlReportParameters = rdl.SelectNodesNS("ReportParameters/ReportParameter");
			foreach ( XmlNode xReportParameter in nlReportParameters )
			{
				string sName = xReportParameter.Attributes.GetNamedItem("Name").Value;
				string sValue = String.Empty;
				// 04/06/2011 Paul.  We need a way to pull data from the Parameters form. 
				// 03/09/2012 Paul.  ASSIGNED_USER_ID is a special parameter that is not a prompt. 
				// 10/06/2012 Paul.  Subreport processing requires special parameter handling. 
				// 01/17/2013 Paul.  A customer wants to be able to change the assigned user as this was previously allowed in report prompts. 
				if ( eSubreportArgs != null && (bShowAssignedUser || (String.Compare(sName, "ASSIGNED_USER_ID", true) != 0 && String.Compare(sName, "TEAM_ID", true) != 0)) )
				{
					ReportParameterInfo param = eSubreportArgs.Parameters[sName];
					if ( param != null && param.Values != null && param.Values.Count > 0 )
					{
						rdl.SetSingleNode(xReportParameter, "DefaultValue/Values", String.Empty);
						XmlNode xDefaultValues = xReportParameter.SelectSingleNode("defaultns:DefaultValue/defaultns:Values", rdl.NamespaceManager);
						xDefaultValues.RemoveAll();
						foreach ( string item in param.Values )
						{
							XmlNode xDefaultValue = rdl.CreateElement("Value", rdl.sDefaultNamespace);
							xDefaultValues.AppendChild(xDefaultValue);
							xDefaultValue.InnerText = item;
						}
					}
					else if ( String.Compare(sName, "ASSIGNED_TO", true) == 0 )
					{
						if ( Context.Session != null )
							sValue = Security.USER_NAME;
						else if ( Session != null )
							sValue = Sql.ToString(Session["USER_NAME"]);
						rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
					}
					// 01/17/2013 Paul.  If ASSIGNED_USER_ID and TEAM_ID are not in the arguments, then use the current user values. 
					else if ( String.Compare(sName, "ASSIGNED_USER_ID", true) == 0 )
					{
						if ( Context.Session != null )
							sValue = Security.USER_ID.ToString();
						// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
						else if ( Session != null )
							sValue = Sql.ToString(Session["USER_ID"]);
						rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
					}
					else if ( String.Compare(sName, "TEAM_ID", true) == 0 )
					{
						if ( Context.Session != null )
							sValue = Security.TEAM_ID.ToString();
						// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
						else if ( Session != null )
							sValue = Sql.ToString(Session["TEAM_ID"]);
						rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
					}
				}
				// 01/15/2013 Paul.  A customer wants to be able to change the assigned user as this was previously allowed in report prompts. 
				// 06/30/2023 Paul.  TODO.  Add support for UI Parameters. 
				/*
				else if ( ctlParameterView != null && (bShowAssignedUser || (String.Compare(sName, "ASSIGNED_USER_ID", true) != 0 && String.Compare(sName, "TEAM_ID", true) != 0)) )
				{
					// 02/16/2018 Paul.  After calculating the value, also update the UI as it looks ugly to have formula in the field. 
					System.Web.UI.Control ctl = ctlParameterView.FindControl(sName);
					// 02/03/2021 Paul.  Might not find control in the layout. 
					if ( ctl != null && ctl.GetType().BaseType == typeof(_controls.DatePicker) )
					{
						_controls.DatePicker dt = ctl as _controls.DatePicker;
						sValue = dt.DateText;
						if ( !sValue.StartsWith("=") )
							sValue = new DynamicControl(ctlParameterView, sName).Text;
					}
					else
					{
						sValue = new DynamicControl(ctlParameterView, sName).Text;
					}
					bool bMultiValue = Sql.ToBoolean(rdl.SelectNodeValue(xReportParameter, "MultiValue"));
					if ( bMultiValue && sValue.StartsWith("<?xml") )
					{
						rdl.SetSingleNode(xReportParameter, "DefaultValue/Values", String.Empty);
						XmlNode xDefaultValues = xReportParameter.SelectSingleNode("defaultns:DefaultValue/defaultns:Values", rdl.NamespaceManager);
						xDefaultValues.RemoveAll();
						
						XmlDocument xml = new XmlDocument();
						// 01/20/2015 Paul.  Disable XmlResolver to prevent XML XXE. 
						// https://www.owasp.org/index.php/XML_External_Entity_(XXE)_Processing
						// http://stackoverflow.com/questions/14230988/how-to-prevent-xxe-attack-xmldocument-in-net
						xml.XmlResolver = null;
						xml.LoadXml(sValue);
						XmlNodeList nlValues = xml.DocumentElement.SelectNodes("Value");
						foreach ( XmlNode xValue in nlValues )
						{
							XmlNode xDefaultValue = rdl.CreateElement("Value", rdl.sDefaultNamespace);
							xDefaultValues.AppendChild(xDefaultValue);
							xDefaultValue.InnerText = xValue.InnerText;
						}
						if ( nlValues.Count == 0 )
						{
							// 03/09/2012 Paul.  ASSIGNED_TO is a special field. 
							if ( String.Compare(sName, "ASSIGNED_TO", true) == 0 )
							{
								if ( Context.Session != null )
									sValue = Security.USER_NAME;
								else if ( Session != null )
									sValue = Sql.ToString(Session["USER_NAME"]);
								rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
							}
							// 01/17/2013 Paul.  If ASSIGNED_USER_ID and TEAM_ID are not in the arguments, then use the current user values. 
							else if ( String.Compare(sName, "ASSIGNED_USER_ID", true) == 0 )
							{
								if ( Context.Session != null )
									sValue = Security.USER_ID.ToString();
								// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
								else if ( Session != null )
									sValue = Sql.ToString(Session["USER_ID"]);
								rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
							}
							else if ( String.Compare(sName, "TEAM_ID", true) == 0 )
							{
								if ( Context.Session != null )
									sValue = Security.TEAM_ID.ToString();
								// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
								else if ( Session != null )
									sValue = Sql.ToString(Session["TEAM_ID"]);
								rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
							}
							else
							{
								rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", String.Empty);
							}
						}
					}
					else
					{
						rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
					}
				}
				*/
				else if ( String.Compare(sName, "ASSIGNED_TO", true) == 0 )
				{
					if ( Context.Session != null )
						sValue = Security.USER_NAME;
					else if ( Session != null )
						sValue = Sql.ToString(Session["USER_NAME"]);
					rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
				}
				// 01/24/2010 Paul.  If ASSIGNED_USER_ID or TEAM_ID are specified, then use the values for the current user. 
				else if ( String.Compare(sName, "ASSIGNED_USER_ID", true) == 0 )
				{
					if ( Context.Session != null )
						sValue = Security.USER_ID.ToString();
					// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
					else if ( Session != null )
						sValue = Sql.ToString(Session["USER_ID"]);
					rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
				}
				else if ( String.Compare(sName, "TEAM_ID", true) == 0 )
				{
					if ( Context.Session != null )
						sValue = Security.TEAM_ID.ToString();
					// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
					else if ( Session != null )
						sValue = Sql.ToString(Session["TEAM_ID"]);
					rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
				}
				// 03/24/2016 Paul.  We need an alternate way to provide parameters to render a report with a signature. 
				else if ( dictParameters != null )
				{
					try
					{
						if ( dictParameters.ContainsKey(sName) )
						{
							rdl.SetSingleNode(xReportParameter, "DefaultValue/Values", String.Empty);
							XmlNode xDefaultValues = xReportParameter.SelectSingleNode("defaultns:DefaultValue/defaultns:Values", rdl.NamespaceManager);
							xDefaultValues.RemoveAll();
							sValue = dictParameters[sName];
							XmlNode xDefaultValue = rdl.CreateElement("Value", rdl.sDefaultNamespace);
							xDefaultValues.AppendChild(xDefaultValue);
							xDefaultValue.InnerText = sValue;
						}
					}
					catch
					{
					}
				}
				// 06/26/2010 Paul.  Request will be null when called from within a workflow. 
				else if ( Request != null )
				{
					// 08/30/2012 Paul.  Request is no longer null when called from within a workflow, but it does throw an exception. 
					// Request.Form and Request.QueryString do not throw exceptions, but the value may not exist and we do not want to override the default if it does not exist. 
					try
					{
						// 01/05/2016 Paul.  A report generated from mass update will have multiple values. 
						string[] arrVALUES = (Request.Query.ContainsKey(sName) ? Request.Query[sName].ToString().Split(",") : null);
						if ( arrVALUES == null )
						{
							if ( dictBody != null && dictBody.ContainsKey(sName) )
							{
								List<string> lst = dictBody[sName] as List<string>;
								arrVALUES = lst.ToArray();
							}
						}
						if ( arrVALUES != null )
						{
							//sValue = Sql.ToString(Request.QueryString[sName]);
							//rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
							rdl.SetSingleNode(xReportParameter, "DefaultValue/Values", String.Empty);
							XmlNode xDefaultValues = xReportParameter.SelectSingleNode("defaultns:DefaultValue/defaultns:Values", rdl.NamespaceManager);
							xDefaultValues.RemoveAll();
							foreach ( string item in arrVALUES )
							{
								XmlNode xDefaultValue = rdl.CreateElement("Value", rdl.sDefaultNamespace);
								xDefaultValues.AppendChild(xDefaultValue);
								if ( item.StartsWith( "\\/Date(" ) && item.EndsWith( ")\\/" ) )
									xDefaultValue.InnerText = RestUtil.FromJsonDate(item).ToString("yyyy/MM/dd HH:mm:ss");
								else
									xDefaultValue.InnerText = item;
							}
						}
					}
					catch
					{
					}
				}
				// 04/16/2011 Paul.  Lets use the rules engine to allow date math, such as =DateTime.Today.AddDays(1)
				// 04/17/2011 Paul.  Report Builder 3.0 can evaluate the same C# code, but the ReportViewer does not, likely because we must build the SQL statement. 
				if ( sValue.StartsWith("=") )
				{
					// 12/12/2012 Paul.  For security reasons, we want to restrict the data types available to the rules wizard. 
					// 07/02/2023 Paul.  Use Roslyn to compile https://github.com/dotnet/roslyn. 
					Microsoft.CodeAnalysis.Scripting.ScriptOptions options = Microsoft.CodeAnalysis.Scripting.ScriptOptions.Default.AddImports("System");
					var value = await Microsoft.CodeAnalysis.CSharp.Scripting.CSharpScript.EvaluateAsync(sValue.Substring(1), options);
					sValue = Sql.ToString(value);
					rdl.SetSingleNode(xReportParameter, "DefaultValue/Values/Value", sValue);
					// 02/16/2018 Paul.  After calculating the value, also update the UI as it looks ugly to have formula in the field. 
					// 07/02/203 Paul.  TODO.  Research if this code is needed.  Not likely since no UI. 
					/*
					if ( ctlParameterView != null )
						new DynamicControl(ctlParameterView, sName).Text = sValue;
					*/
				}
			}
			
			// 03/04/2012 Paul.  Fix the Hyperlinks to use the full URL. 
			XmlNodeList nlHyperLinks = rdl.SelectNodes("//defaultns:Hyperlink", rdl.NamespaceManager);
			foreach ( XmlNode xHyperLinks in nlHyperLinks )
			{
				string sInnerText = Sql.ToString(xHyperLinks.InnerText);
				if ( sInnerText.Contains("~/") )
				{
					xHyperLinks.InnerText = sInnerText.Replace("~/", Request.Scheme + "://" + Request.Host.Host + Sql.ToString(Application["rootURL"]));
				}
			}
			
			// 10/06/2012 Paul.  ds will be NULL when first initializing subreport.  When initializing a subreport, don't query the database. 
			if ( ds != null )
			{
				// 06/26/2010 Paul.  Need to pass the Application so that this method can be called from the workflow engine. 
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					StringCollection colDataSourceName = new StringCollection();
					XmlNodeList nlDataSets = rdl.SelectNodesNS("DataSets/DataSet");
					foreach ( XmlNode xDataSet in nlDataSets )
					{
						string sDataSetName = xDataSet.Attributes.GetNamedItem("Name").Value;
						DataTable dtReport = new DataTable(sDataSetName);
						// 01/14/2010 Paul.  For added security, wrap all Report queries in a transaction, and rollback the transaction when done. 
						// This is to protect against SQL injection coming from a Report. 
						// This is a concern because a report RDL can be imported and its SQL will be executed as-is. 
						// Using a transaction will affect performance, but this seems like a valid security trade-off. 
						using ( IDbTransaction trn = Sql.BeginTransaction(con) )
						{
							try
							{
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.Transaction = trn;
									// 02/02/2009 Paul.  Always wait forever for the data.  No sense in showing a timeout.
									// We did this a long time ago for all list views, so it makes sense to do it here as well. 
									cmd.CommandTimeout = 0;
									// 11/06/2011 Paul.  MS Charts do the grouping after the selected.  We will convert the select to do the grouping. 
									if ( bChart )
										rdl.BuildChartCommand(XmlUtil, xDataSet, cmd);
									else
										rdl.BuildCommand(XmlUtil, xDataSet, cmd);
									// 03/09/2012 Paul.  The new canned reports will contain Team logic that may need to be removed if team management has been disabled. 
									if ( !bEnableTeamManagement )
									{
										cmd.CommandText = cmd.CommandText.Replace(     " inner join vwTEAM_MEMBERSHIPS", String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(" left outer join vwTEAM_MEMBERSHIPS", String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(             " on vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID = TEAM_ID"                       , String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(            " and vwTEAM_MEMBERSHIPS.MEMBERSHIP_USER_ID = @ASSIGNED_USER_ID"             , String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(            " and (TEAM_ID is null or vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID is not null)", String.Empty);
										// 03/09/2012 Paul.  Just in case there were some custom reports that used dynamic teams, also remove them. 
										cmd.CommandText = cmd.CommandText.Replace(     " inner join " + Sql.MetadataName(cmd, "vwTEAM_SET_MEMBERSHIPS_Security") + " vwTEAM_SET_MEMBERSHIPS", String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(" left outer join " + Sql.MetadataName(cmd, "vwTEAM_SET_MEMBERSHIPS_Security") + " vwTEAM_SET_MEMBERSHIPS", String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(     " inner join vwTEAM_SET_MEMBERSHIPS_Security vwTEAM_SET_MEMBERSHIPS", String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(" left outer join vwTEAM_SET_MEMBERSHIPS_Security vwTEAM_SET_MEMBERSHIPS", String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(             " on vwTEAM_SET_MEMBERSHIPS.MEMBERSHIP_TEAM_SET_ID = TEAM_SET_ID"                       , String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(            " and vwTEAM_SET_MEMBERSHIPS.MEMBERSHIP_USER_ID     = @ASSIGNED_USER_ID"                 , String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(            " and (TEAM_SET_ID is null or vwTEAM_SET_MEMBERSHIPS.MEMBERSHIP_TEAM_SET_ID is not null)", String.Empty);
									}
									// 03/09/2012 Paul.  If Dynamic Teams is enabled, then replace the standard team management logic with dynamic teams logic. 
									else if ( bEnableDynamicTeams )
									{
										cmd.CommandText = cmd.CommandText.Replace(" join vwTEAM_MEMBERSHIPS"                                       , " join " + Sql.MetadataName(cmd, "vwTEAM_SET_MEMBERSHIPS_Security") + " vwTEAM_SET_MEMBERSHIPS");
										cmd.CommandText = cmd.CommandText.Replace(  " on vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID = TEAM_ID"          ,   " on vwTEAM_SET_MEMBERSHIPS.MEMBERSHIP_TEAM_SET_ID = TEAM_SET_ID");
										cmd.CommandText = cmd.CommandText.Replace( " and vwTEAM_MEMBERSHIPS.MEMBERSHIP_USER_ID = @ASSIGNED_USER_ID",  " and vwTEAM_SET_MEMBERSHIPS.MEMBERSHIP_USER_ID     = @ASSIGNED_USER_ID");
										cmd.CommandText = cmd.CommandText.Replace( " and (TEAM_ID is null or vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID is not null)",  " and (TEAM_SET_ID is null or vwTEAM_SET_MEMBERSHIPS.MEMBERSHIP_TEAM_SET_ID is not null)");
									}
									if ( bRequireTeamManagement )
									{
										cmd.CommandText = cmd.CommandText.Replace(" left outer join vwTEAM_MEMBERSHIPS", " inner join vwTEAM_MEMBERSHIPS");
										cmd.CommandText = cmd.CommandText.Replace(" left outer join " + Sql.MetadataName(cmd, "vwTEAM_SET_MEMBERSHIPS_Security"), " inner join " + Sql.MetadataName(cmd, "vwTEAM_SET_MEMBERSHIPS_Security"));
										cmd.CommandText = cmd.CommandText.Replace(" and (TEAM_ID is null or vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID is not null)", String.Empty);
										cmd.CommandText = cmd.CommandText.Replace(" and (TEAM_SET_ID is null or vwTEAM_SET_MEMBERSHIPS.MEMBERSHIP_TEAM_SET_ID is not null)", String.Empty);
									}
									if ( Sql.IsOracle(cmd) || Sql.IsDB2(cmd) || Sql.IsPostgreSQL(cmd) )
										cmd.CommandText = cmd.CommandText.Replace(" dbo.fn", "fn");
									// 01/20/2011 Paul.  Combine all SQL scripts. 
									sReportSQL += Sql.ExpandParameters(cmd) + ";" + ControlChars.CrLf;

									using ( DbDataAdapter da = dbf.CreateDataAdapter() )
									{
										( (IDbDataAdapter) da ).SelectCommand = cmd;
										{
											da.Fill(dtReport);

											// 01/19/2010 Paul.  Apply ACL Field Security. 
											bool bASSIGNED_USER_ID_Exists = dtReport.Columns.Contains("ASSIGNED_USER_ID");
											// 07/12/2006 Paul.  Every date cell needs to be localized. 
											foreach ( DataRow row in dtReport.Rows )
											{
												Guid gASSIGNED_USER_ID = Guid.Empty;
												if ( bASSIGNED_USER_ID_Exists )
													gASSIGNED_USER_ID = Sql.ToGuid(row["ASSIGNED_USER_ID"]);
												foreach ( DataColumn col in dtReport.Columns )
												{
													if ( SplendidInit.bEnableACLFieldSecurity )
													{
														string sCOLUMN_FIELD_NAME  = col.ColumnName;
														string sCOLUMN_MODULE_NAME = sMODULE_NAME;
														string[] arrCOLUMN_NAME = col.ColumnName.Split('.');
														// 01/19/2010 Paul.  Splenddid Reports will have field names as <table_name>.<field_name>. 
														if ( arrCOLUMN_NAME.Length == 2 )
														{
															sCOLUMN_MODULE_NAME = Sql.ToString(Application["Modules." + arrCOLUMN_NAME[0] + ".ModuleName"]);
															sCOLUMN_FIELD_NAME  = arrCOLUMN_NAME[1];
														}
														if ( !Sql.IsEmptyString(sCOLUMN_MODULE_NAME) )
														{
															// 04/13/2011 Paul.  GetUserFieldSecurity is only valid if there is a Session. 
															// A scheduled report does not have a session, so it will throw an exception. 
															if ( Context.Session != null )
															{
																Security.ACL_FIELD_ACCESS acl = Security.GetUserFieldSecurity(sCOLUMN_MODULE_NAME, sCOLUMN_FIELD_NAME, gASSIGNED_USER_ID);
																if ( !acl.IsReadable() )
																{
																	row[col.Ordinal] = DBNull.Value;
																}
															}
															// 04/13/2011 Paul.  A scheduled report does not have a Session, so we need to create a session using the same approach used for ExchangeSync. 
															else if ( Session != null )
															{
																Security.ACL_FIELD_ACCESS acl = ExchangeSecurity.GetUserFieldSecurity(Session, sCOLUMN_MODULE_NAME, sCOLUMN_FIELD_NAME, gASSIGNED_USER_ID);
																if ( !acl.IsReadable() )
																{
																	row[col.Ordinal] = DBNull.Value;
																}
															}
														}
													}
													if ( col.DataType == typeof(System.DateTime) )
													{
														// 07/13/2006 Paul.  Don't try and translate a NULL. 
														if ( row[col.Ordinal] != DBNull.Value )
															row[col.Ordinal] = T10n.FromServerTime(row[col.Ordinal]);
													}
												}
											}
											// 12/04/2010 Paul.  Add support for Business Rules Framework to Reports. 
											Guid gPRE_LOAD_EVENT_ID  = Sql.ToGuid(rdl.GetCustomPropertyValue("PRE_LOAD_EVENT_ID" ));
											Guid gPOST_LOAD_EVENT_ID = Sql.ToGuid(rdl.GetCustomPropertyValue("POST_LOAD_EVENT_ID"));
											SplendidDynamic.ApplyReportRules(L10n, gPRE_LOAD_EVENT_ID, gPOST_LOAD_EVENT_ID, dtReport);
										}
									}
									// 12/21/2009 Paul.  The new VS 2010 ReportViewer does not like the DataSourceReference.  
									// 10/06/2012 Paul.  Move the DataSourceReference fix to ReportViewerFixups.
									/*
									if ( !colDataSourceName.Contains(sDataSourceName) )
									{
										colDataSourceName.Add(sDataSourceName);
										ReportDataSource ds = new ReportDataSource(sDataSourceName, Guid.NewGuid().ToString());
										rdlViewer.LocalReport.DataSources.Add(ds);
									}
									*/
								}
							}
							finally
							{
								trn.Rollback();
							}
						}
					
						ds.Tables.Add(dtReport);
						// 06/30/2023 Paul.  TODO.  Add support for UI Parameters. 
						/*
						if ( ctlParameterView != null )
						{
							// 02/16/2012 Paul.  We need a separate list for report parameter lists. 
							string sReportID = rdl.SelectNodeValue("rd:ReportID");
							foreach ( XmlNode xReportParameter in nlReportParameters )
							{
								if ( sDataSetName == rdl.SelectNodeValue(xReportParameter, "ValidValues/DataSetReference/DataSetName") )
								{
									string sReportValueField = rdl.SelectNodeValue(xReportParameter, "ValidValues/DataSetReference/ValueField");
									string sReportTextField  = rdl.SelectNodeValue(xReportParameter, "ValidValues/DataSetReference/LabelField");
									// 04/28/2018 Paul.  We need to convert the report field to a data field. 
									string sDataValueField   = rdl.SelectNodeValue(xDataSet, "Fields/Field[@Name='" + sReportValueField + "']/DataField");
									string sDataTextField    = rdl.SelectNodeValue(xDataSet, "Fields/Field[@Name='" + sReportTextField  + "']/DataField");
									SplendidCache.AddReportSource(sReportID + "." + sDataSetName, sDataValueField, sDataTextField, dtReport);
									// 02/16/2012 Paul.  The ParameterView is populated before the data is retrieved, so we need to refresh the list controls. 
									string sName = XmlUtil.GetNamedItem(xReportParameter, "Name");
									ListControl lst = ctlParameterView.FindControl(sName) as ListControl;
									// 04/28/2018 Paul.  lst might not exist. 
									// 12/22/2020 Paul.  Compare counts to determine if list needs to be updated. 
									if ( lst != null && lst.Items.Count != dtReport.Rows.Count )
									{
										// 12/22/2020 Paul.  Must make sure the field names match. 
										if ( lst.DataValueField == sDataValueField && lst.DataTextField == sDataTextField )
											lst.DataSource = dtReport;
										lst.DataBind();
									}
								}
							}
						}
						*/
					}
					// 01/24/2010 Paul.  Validate the context to detect errors similar to the one caused by removing the DataSource Name attribute (above). 
					// 01/30/2012 Paul.  We no longer need to validate when debugging. 
	//#if DEBUG
	//				rdl.Validate(Context);
	//#endif
				}
			}
			return rdl;
		}
	}
}
