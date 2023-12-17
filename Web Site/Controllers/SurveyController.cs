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
using System.Text;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Controllers.Surveys
{
	[ApiController]
	[Route("[controller].svc")]
	public class SurveyController : ControllerBase
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpContext          Context            ;
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone TimeZone           = new SplendidCRM.TimeZone();
		private SqlProcs             SqlProcs           ;
		private Utils                Utils              ;
		private XmlUtil              XmlUtil            ;
		private SplendidError        SplendidError      ;
		private SplendidCRM.Crm.Modules          Modules            ;
		private IBackgroundTaskQueue taskQueue          ;

		public SurveyController(IHttpContextAccessor httpContextAccessor, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, Utils Utils, XmlUtil XmlUtil, SplendidError SplendidError, SplendidCRM.Crm.Modules Modules, IBackgroundTaskQueue taskQueue)
		{
			this.Context             = httpContextAccessor.HttpContext;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.Utils               = Utils              ;
			this.XmlUtil             = XmlUtil            ;
			this.SplendidError       = SplendidError      ;
			this.Modules             = Modules            ;
			this.taskQueue           = taskQueue          ;
		}

		#region Get
		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		public Dictionary<string, object> GetSurveyQuestion(Guid ID)
		{
			string sBaseURI = Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			
			Guid     gTIMEZONE         = Sql.ToGuid  (Application["CONFIG.default_timezone"]);
			SplendidCRM.TimeZone  T10n        = TimeZone.CreateTimeZone(gTIMEZONE);
			Dictionary<string, object> dict = null;
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				string sSQL ;
				sSQL = "select *                 " + ControlChars.CrLf
				     + "  from vwSURVEY_QUESTIONS" + ControlChars.CrLf
				     + " where ID = @ID          " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", ID);
					con.Open();
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);
							if ( dt.Rows.Count == 0 )
								throw(new Exception("Survey Question not found: " + ID.ToString()));
							
							dt.Columns.Add("RANDOMIZE_COUNT", typeof(int));
							DataRow row = dt.Rows[0];
							int nRANDOMIZE_COUNT = Sql.ToInteger(Application["SurveyQuestion_Randomize_Count_" + Sql.ToString(row["ID"])]);
							row["RANDOMIZE_COUNT"] = nRANDOMIZE_COUNT;
							nRANDOMIZE_COUNT++;
							Application["SurveyQuestion_Randomize_Count_" + Sql.ToString(row["ID"])] = nRANDOMIZE_COUNT;
							// 04/01/2020 Paul.  Move json utils to RestUtil. 
							dict = RestUtil.ToJson(sBaseURI, "SurveyQuestions", dt.Rows[0], T10n);
						}
					}
				}
			}
			
			
			/*
			string sEXPAND = Sql.ToString (Request.QueryString["$expand"]);
			if ( sEXPAND == "*" )
			{
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					Dictionary<string, object> d       = dict["d"] as Dictionary<string, object>;
					Dictionary<string, object> results = d["results"] as Dictionary<string, object>;
					DataTable dtRelationships = SplendidCache.DetailViewRelationships(ModuleName + ".DetailView");
					foreach ( DataRow row in dtRelationships.Rows )
					{
						try
						{
							string sRELATED_MODULE     = Sql.ToString(row["MODULE_NAME"]);
							string sRELATED_TABLE      = Sql.ToString(Application["Modules." + sRELATED_MODULE + ".TableName"]);
							string sRELATED_FIELD_NAME = Crm.Modules.SingularTableName(sRELATED_TABLE) + "_ID";
							if ( !d.ContainsKey(sRELATED_MODULE) && SplendidCRM.Security.GetUserAccess(sRELATED_MODULE, "list") >= 0 )
							{
								using ( DataTable dtSYNC_TABLES = SplendidCache.RestTables(sRELATED_TABLE, true) )
								{
									string sSQL;
									if ( dtSYNC_TABLES != null && dtSYNC_TABLES.Rows.Count > 0 )
									{
										UniqueStringCollection arrSearchFields = new UniqueStringCollection();
										SplendidDynamic.SearchGridColumns(ModuleName + "." + sRELATED_MODULE, arrSearchFields);
										
										sSQL = "select " + Sql.FormatSelectFields(arrSearchFields)
										     + "  from vw" + sTABLE_NAME + "_" + sRELATED_TABLE + ControlChars.CrLf;
										using ( IDbCommand cmd = con.CreateCommand() )
										{
											cmd.CommandText = sSQL;
											Security.Filter(cmd, sRELATED_MODULE, "list");
											Sql.AppendParameter(cmd, ID, sRELATED_FIELD_NAME);
											using ( DbDataAdapter da = dbf.CreateDataAdapter() )
											{
												((IDbDataAdapter)da).SelectCommand = cmd;
												using ( DataTable dtSubPanel = new DataTable() )
												{
													da.Fill(dtSubPanel);
													results.Add(sRELATED_MODULE, RowsToDictionary(sBaseURI, sRELATED_MODULE, dtSubPanel, T10n));
												}
											}
										}
									}
								}
							}
						}
						catch(Exception ex)
						{
							SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
						}
					}
				}
			}
			*/
			
			return dict;
		}

		[HttpGet("[action]")]
		[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
		// 11/12/2018 Paul.  Flag to include the image content. 
		public Dictionary<string, object> GetSurvey(Guid ID, bool IMAGE_CONTENT)
		{
			string sBaseURI = String.Empty;  //Request.Scheme + "://" + Request.Host.Host + Request.Path.Value;
			
			Guid     gTIMEZONE         = Sql.ToGuid  (Application["CONFIG.default_timezone"]);
			SplendidCRM.TimeZone  T10n        = TimeZone.CreateTimeZone(gTIMEZONE);
			Dictionary<string, object> dict = null;
			
			DbProviderFactory dbf = DbProviderFactories.GetFactory();
			using ( IDbConnection con = dbf.CreateConnection() )
			{
				con.Open();
				string sSQL ;
				Guid gSURVEY_THEME_ID = Guid.Empty;
				// 10/01/2018 Paul.  Include SURVEY_TARGET_MODULE. 
				// 11/29/2018 Paul.  Include LOOP_SURVEY, EXIT_CODE, TIMEOUT. 
				sSQL = "select ID                  " + ControlChars.CrLf
				     + "     , NAME                " + ControlChars.CrLf
				     + "     , STATUS              " + ControlChars.CrLf
				     + "     , SURVEY_TARGET_MODULE" + ControlChars.CrLf
				     + "     , SURVEY_STYLE        " + ControlChars.CrLf
				     + "     , SURVEY_THEME_ID     " + ControlChars.CrLf
				     + "     , PAGE_RANDOMIZATION  " + ControlChars.CrLf
				     + "     , DESCRIPTION         " + ControlChars.CrLf
				     + "     , LOOP_SURVEY         " + ControlChars.CrLf
				     + "     , EXIT_CODE           " + ControlChars.CrLf
				     + "     , TIMEOUT             " + ControlChars.CrLf
					 + "  from vwSURVEYS           " + ControlChars.CrLf
				     + " where ID = @ID            " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", ID);
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dt = new DataTable() )
						{
							da.Fill(dt);
							if ( dt.Rows.Count == 0 )
								throw(new Exception("Survey not found: " + ID.ToString()));
							
							dt.Columns.Add("RANDOMIZE_COUNT", typeof(int));
							DataRow row = dt.Rows[0];
							gSURVEY_THEME_ID = Sql.ToGuid(row["SURVEY_THEME_ID"]);
							int nRANDOMIZE_COUNT = Sql.ToInteger(Application["Survey_Randomize_Count_" + Sql.ToString(row["ID"])]);
							row["RANDOMIZE_COUNT"] = nRANDOMIZE_COUNT;
							nRANDOMIZE_COUNT++;
							Application["Survey_Randomize_Count_" + Sql.ToString(row["ID"])] = nRANDOMIZE_COUNT;
							// 04/01/2020 Paul.  Move json utils to RestUtil. 
							dict = RestUtil.ToJson(sBaseURI, "Surveys", dt.Rows[0], T10n);
						}
					}
				}
				
				Dictionary<string, object> d       = dict["d"] as Dictionary<string, object>;
				Dictionary<string, object> results = d["results"] as Dictionary<string, object>;
				// 08/29/2018 Paul.  Include the theme with the survey for the app. 
				sSQL = "select *                     " + ControlChars.CrLf
				     + "  from vwSURVEY_THEMES       " + ControlChars.CrLf
				     + " where ID = @ID              " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@ID", gSURVEY_THEME_ID);
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dtTheme = new DataTable() )
						{
							da.Fill(dtTheme);
							Dictionary<string, object> drow = new Dictionary<string, object>();
							if ( dtTheme.Rows.Count > 0 )
							{
								DataRow dr = dtTheme.Rows[0];
								// 04/09/2019 Paul.  Add Survey Theme Page Background. 
								StringBuilder sbPAGE_BACKGROUND = new StringBuilder();
								try
								{
									// 04/10/2019 Paul.  If the database is old, just log and ignore the missing fields. 
									string sPAGE_BACKGROUND_IMAGE    = Sql.ToString(dr["PAGE_BACKGROUND_IMAGE"   ]);
									string sPAGE_BACKGROUND_POSITION = Sql.ToString(dr["PAGE_BACKGROUND_POSITION"]);
									string sPAGE_BACKGROUND_REPEAT   = Sql.ToString(dr["PAGE_BACKGROUND_REPEAT"  ]);
									string sPAGE_BACKGROUND_SIZE     = Sql.ToString(dr["PAGE_BACKGROUND_SIZE"    ]);
									if ( !Sql.IsEmptyString(sPAGE_BACKGROUND_IMAGE) )
									{
										sbPAGE_BACKGROUND.AppendLine("#divSurveyPages");
										sbPAGE_BACKGROUND.AppendLine("{");
										sbPAGE_BACKGROUND.AppendLine("	background-image: url(" + sPAGE_BACKGROUND_IMAGE + ");");
										if ( !Sql.IsEmptyString(sPAGE_BACKGROUND_REPEAT  ) ) sbPAGE_BACKGROUND.AppendLine("	background-repeat: "   + sPAGE_BACKGROUND_REPEAT   + ";");
										if ( !Sql.IsEmptyString(sPAGE_BACKGROUND_POSITION) ) sbPAGE_BACKGROUND.AppendLine("	background-position: " + sPAGE_BACKGROUND_POSITION + ";");
										if ( !Sql.IsEmptyString(sPAGE_BACKGROUND_SIZE    ) ) sbPAGE_BACKGROUND.AppendLine("	background-size: "     + sPAGE_BACKGROUND_SIZE     + ";");
										sbPAGE_BACKGROUND.AppendLine("}");
									}
								}
								catch(Exception ex)
								{
									SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
								}
								for (int i = 0; i < dtTheme.Columns.Count; i++)
								{
									if ( dtTheme.Columns[i].DataType.FullName != "System.DateTime" && !dtTheme.Columns[i].ColumnName.StartsWith("CREATED_BY") && !dtTheme.Columns[i].ColumnName.StartsWith("MODIFIED_BY"))
									{
										// 03/11/2019 Paul.  Convert url to base64. 
										string sName = dtTheme.Columns[i].ColumnName;
										object oValue = dr[i];
										if ( sName == "CUSTOM_STYLES" && IMAGE_CONTENT )
										{
											// 04/09/2019 Paul.  Add Survey Theme Page Background. 
											string sValue = sbPAGE_BACKGROUND.ToString() + Sql.ToString(oValue);
											for ( int nStart = sValue.IndexOf("url("); nStart >= 0 && nStart < sValue.Length; )
											{
												nStart += 4;
												int nEnd = sValue.IndexOf(")", nStart);
												if ( nEnd > nStart )
												{
													string sIMAGE_URL = sValue.Substring(nStart, nEnd - nStart);
													// background-image: url(../Images/EmailImage.aspx?ID=0fd6e6e4-bb17-4e3b-97b2-80b01e9c36ed);
													if ( sIMAGE_URL.Contains("Images/EmailImage.aspx?ID=") )
													{
														sIMAGE_URL = sIMAGE_URL.Split('=')[1];
														Guid gIMAGE_ID = Sql.ToGuid(sIMAGE_URL);
														string sIMAGE_MIME_TYPE = String.Empty;
														string sIMAGE_CONTENT   = String.Empty;
														GetImageContent(con, gIMAGE_ID, ref sIMAGE_MIME_TYPE, ref sIMAGE_CONTENT);
														string sContentData = "data:" + sIMAGE_MIME_TYPE + ";base64," + sIMAGE_CONTENT;
														sValue = sValue.Substring(0, nStart) + sContentData + sValue.Substring(nEnd);
														// 04/02/2019 Paul.  Need to save back to the base variable. 
														oValue = sValue;
													}
												}
												nStart = sValue.IndexOf("url(", nStart + 1);
											}
										}
										drow.Add(sName, oValue);
									}
								}
							}
							results.Add("SURVEY_THEME", drow);
						}
					}
				}
				sSQL = "select ID                    " + ControlChars.CrLf
				     + "     , SURVEY_ID             " + ControlChars.CrLf
				     + "     , NAME                  " + ControlChars.CrLf
				     + "     , PAGE_NUMBER           " + ControlChars.CrLf
				     + "     , QUESTION_RANDOMIZATION" + ControlChars.CrLf
				     + "     , DESCRIPTION           " + ControlChars.CrLf
				     + "  from vwSURVEY_PAGES        " + ControlChars.CrLf
				     + " where SURVEY_ID = @SURVEY_ID" + ControlChars.CrLf
				     + " order by PAGE_NUMBER        " + ControlChars.CrLf;
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = sSQL;
					Sql.AddParameter(cmd, "@SURVEY_ID", ID);
					using ( DbDataAdapter da = dbf.CreateDataAdapter() )
					{
						((IDbDataAdapter)da).SelectCommand = cmd;
						using ( DataTable dtPages = new DataTable() )
						{
							da.Fill(dtPages);
							dtPages.Columns.Add("RANDOMIZE_COUNT", typeof(int));
							foreach ( DataRow row in dtPages.Rows )
							{
								int nRANDOMIZE_COUNT = Sql.ToInteger(Application["SurveyPage_Randomize_Count_" + Sql.ToString(row["ID"])]);
								row["RANDOMIZE_COUNT"] = nRANDOMIZE_COUNT;
								nRANDOMIZE_COUNT++;
								Application["SurveyPage_Randomize_Count_" + Sql.ToString(row["ID"])] = nRANDOMIZE_COUNT;
							}
							// 04/01/2020 Paul.  Move json utils to RestUtil. 
							results.Add("SURVEY_PAGES", RestUtil.RowsToDictionary(sBaseURI, "SURVEY_PAGES", dtPages, T10n));
						}
					}
				}
				List<Dictionary<string, object>> SURVEY_PAGES = results["SURVEY_PAGES"] as List<Dictionary<string, object>>;
				for ( int i = 0; i < SURVEY_PAGES.Count; i++ )
				{
					Guid gSURVEY_PAGE_ID = Sql.ToGuid(SURVEY_PAGES[i]["ID"]);
					sSQL = "select ID                              " + ControlChars.CrLf
					     + "     , SURVEY_ID                       " + ControlChars.CrLf
					     + "     , SURVEY_PAGE_ID                  " + ControlChars.CrLf
					     + "     , NAME                            " + ControlChars.CrLf
					     + "     , QUESTION_NUMBER                 " + ControlChars.CrLf
					     + "     , DESCRIPTION                     " + ControlChars.CrLf
					     + "     , QUESTION_TYPE                   " + ControlChars.CrLf
					     + "     , DISPLAY_FORMAT                  " + ControlChars.CrLf
					     + "     , ANSWER_CHOICES                  " + ControlChars.CrLf
					     + "     , COLUMN_CHOICES                  " + ControlChars.CrLf
					     + "     , FORCED_RANKING                  " + ControlChars.CrLf
					     + "     , INVALID_DATE_MESSAGE            " + ControlChars.CrLf
					     + "     , INVALID_NUMBER_MESSAGE          " + ControlChars.CrLf
					     + "     , NA_ENABLED                      " + ControlChars.CrLf
					     + "     , NA_LABEL                        " + ControlChars.CrLf
					     + "     , OTHER_ENABLED                   " + ControlChars.CrLf
					     + "     , OTHER_LABEL                     " + ControlChars.CrLf
					     + "     , OTHER_HEIGHT                    " + ControlChars.CrLf
					     + "     , OTHER_WIDTH                     " + ControlChars.CrLf
					     + "     , OTHER_AS_CHOICE                 " + ControlChars.CrLf
					     + "     , OTHER_ONE_PER_ROW               " + ControlChars.CrLf
					     + "     , OTHER_REQUIRED_MESSAGE          " + ControlChars.CrLf
					     + "     , OTHER_VALIDATION_TYPE           " + ControlChars.CrLf
					     + "     , OTHER_VALIDATION_MIN            " + ControlChars.CrLf
					     + "     , OTHER_VALIDATION_MAX            " + ControlChars.CrLf
					     + "     , OTHER_VALIDATION_MESSAGE        " + ControlChars.CrLf
					     + "     , REQUIRED                        " + ControlChars.CrLf
					     + "     , REQUIRED_TYPE                   " + ControlChars.CrLf
					     + "     , REQUIRED_RESPONSES_MIN          " + ControlChars.CrLf
					     + "     , REQUIRED_RESPONSES_MAX          " + ControlChars.CrLf
					     + "     , REQUIRED_MESSAGE                " + ControlChars.CrLf
					     + "     , VALIDATION_TYPE                 " + ControlChars.CrLf
					     + "     , VALIDATION_MIN                  " + ControlChars.CrLf
					     + "     , VALIDATION_MAX                  " + ControlChars.CrLf
					     + "     , VALIDATION_MESSAGE              " + ControlChars.CrLf
					     + "     , VALIDATION_SUM_ENABLED          " + ControlChars.CrLf
					     + "     , VALIDATION_NUMERIC_SUM          " + ControlChars.CrLf
					     + "     , VALIDATION_SUM_MESSAGE          " + ControlChars.CrLf
					     + "     , RANDOMIZE_TYPE                  " + ControlChars.CrLf
					     + "     , RANDOMIZE_NOT_LAST              " + ControlChars.CrLf
					     + "     , SIZE_WIDTH                      " + ControlChars.CrLf
					     + "     , SIZE_HEIGHT                     " + ControlChars.CrLf
					     + "     , BOX_WIDTH                       " + ControlChars.CrLf
					     + "     , BOX_HEIGHT                      " + ControlChars.CrLf
					     + "     , COLUMN_WIDTH                    " + ControlChars.CrLf
					     + "     , PLACEMENT                       " + ControlChars.CrLf
					     + "     , SPACING_LEFT                    " + ControlChars.CrLf
					     + "     , SPACING_TOP                     " + ControlChars.CrLf
					     + "     , SPACING_RIGHT                   " + ControlChars.CrLf
					     + "     , SPACING_BOTTOM                  " + ControlChars.CrLf
					     + "     , IMAGE_URL                       " + ControlChars.CrLf
					     + "  from vwSURVEY_PAGES_QUESTIONS        " + ControlChars.CrLf
					     + " where SURVEY_PAGE_ID = @SURVEY_PAGE_ID" + ControlChars.CrLf
					     + " order by QUESTION_NUMBER              " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@SURVEY_PAGE_ID", gSURVEY_PAGE_ID);
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dtQuestions = new DataTable() )
							{
								da.Fill(dtQuestions);
								dtQuestions.Columns.Add("RANDOMIZE_COUNT", typeof(int));
								dtQuestions.Columns.Add("IMAGE_MIME_TYPE", typeof(string));
								dtQuestions.Columns.Add("IMAGE_CONTENT"  , typeof(string));
								foreach ( DataRow row in dtQuestions.Rows )
								{
									int nRANDOMIZE_COUNT = Sql.ToInteger(Application["SurveyQuestion_Randomize_Count_" + Sql.ToString(row["ID"])]);
									row["RANDOMIZE_COUNT"] = nRANDOMIZE_COUNT;
									nRANDOMIZE_COUNT++;
									Application["SurveyQuestion_Randomize_Count_" + Sql.ToString(row["ID"])] = nRANDOMIZE_COUNT;
								}
								// 11/12/2018 Paul.  Flag to include the image content. 
								if ( IMAGE_CONTENT )
								{
									foreach ( DataRow row in dtQuestions.Rows )
									{
										string sIMAGE_URL = Sql.ToString(row["IMAGE_URL"]);
										if ( sIMAGE_URL.StartsWith("~/Images/EmailImage.aspx?ID=") )
										{
											sIMAGE_URL = sIMAGE_URL.Replace("~/Images/EmailImage.aspx?ID=", String.Empty);
											try
											{
												Guid gIMAGE_ID = Sql.ToGuid(sIMAGE_URL);
												// 03/11/2019 Paul.  create get image function. 
												string sIMAGE_MIME_TYPE = String.Empty;
												string sIMAGE_CONTENT   = String.Empty;
												GetImageContent(con, gIMAGE_ID, ref sIMAGE_MIME_TYPE, ref sIMAGE_CONTENT);
												row["IMAGE_MIME_TYPE"] = sIMAGE_MIME_TYPE;
												row["IMAGE_CONTENT"  ] = sIMAGE_CONTENT  ;
											}
											catch(Exception ex)
											{
												SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
											}
										}
									}
								}
								// 04/01/2020 Paul.  Move json utils to RestUtil. 
								SURVEY_PAGES[i].Add("SURVEY_QUESTIONS", RestUtil.RowsToDictionary(sBaseURI, "SURVEY_QUESTIONS", dtQuestions, T10n));
							}
						}
					}
				}
			}
			return dict;
		}

		private static void GetImageContent(IDbConnection con, Guid gIMAGE_ID, ref string sIMAGE_MIME_TYPE, ref string sIMAGE_CONTENT)
		{
			using ( IDbCommand cmdImage = con.CreateCommand() )
			{
				string sSQL;
				sSQL = "select FILE_MIME_TYPE" + ControlChars.CrLf
				     + "     , (select CONTENT from vwEMAIL_IMAGES_CONTENT where vwEMAIL_IMAGES_CONTENT.ID = vwEMAIL_IMAGES.ID) as CONTENT" + ControlChars.CrLf
				     + "  from vwEMAIL_IMAGES" + ControlChars.CrLf
				     + " where ID = @ID      " + ControlChars.CrLf;
				Sql.AddParameter(cmdImage, "@ID", gIMAGE_ID);
				cmdImage.CommandText = sSQL;
				using ( IDataReader rdr = cmdImage.ExecuteReader(CommandBehavior.SingleRow) )
				{
					if ( rdr.Read() )
					{
						byte[] byIMAGE_CONTENT = Sql.ToByteArray(rdr["CONTENT"       ]);
						sIMAGE_MIME_TYPE       = Sql.ToString   (rdr["FILE_MIME_TYPE"]);
						sIMAGE_CONTENT         = Convert.ToBase64String(byIMAGE_CONTENT);
					}
				}
			}
		}

		#endregion

		public static string md5(string sValue)
		{
			UTF8Encoding utf8 = new UTF8Encoding();
			byte[] aby = utf8.GetBytes(sValue);
			
			using ( MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider() )
			{
				byte[] binMD5 = md5.ComputeHash(aby);
				return Sql.HexEncode(binMD5);
			}
		}

		public static Guid ConvertAnswerID(string sANSWER_ID)
		{
			sANSWER_ID = sANSWER_ID.Substring(0, 8) + "-" + sANSWER_ID.Substring(8, 4) + "-" + sANSWER_ID.Substring(12, 4) + "-" + sANSWER_ID.Substring(16, 4) + "-" + sANSWER_ID.Substring(20, 12);
			Guid gANSWER_ID = Sql.ToGuid(sANSWER_ID);
#if DEBUG
			if ( sANSWER_ID.ToLower() != gANSWER_ID.ToString().ToLower() )
			{
				throw(new Exception(sANSWER_ID + " != " + gANSWER_ID.ToString()));
			}
#endif
			return gANSWER_ID;
		}

		private static void SplitAnswer(string sQUESTION_TYPE, string sVALUE, bool bOTHER_AS_CHOICE, ref Guid gANSWER_ID, ref string sANSWER_TEXT, ref Guid gCOLUMN_ID, ref string sCOLUMN_TEXT, ref Guid gMENU_ID, ref string sMENU_TEXT, ref int nWEIGHT, ref string sOTHER_TEXT)
		{
			if ( !Sql.IsEmptyString(sVALUE) )
			{
				string[] arrANSWER = sVALUE.Split(',');
				if ( arrANSWER.Length >= 2 )
				{
					if ( arrANSWER[0].Length == 32 )
					{
						string sANSWER_ID = arrANSWER[0];
						if ( sANSWER_ID == md5("Other") )
						{
							sOTHER_TEXT = sVALUE.Substring(33);
							if ( bOTHER_AS_CHOICE )
							{
								gANSWER_ID = ConvertAnswerID(sANSWER_ID);
							}
						}
						else
						{
							gANSWER_ID = ConvertAnswerID(sANSWER_ID);
						}
						sANSWER_TEXT = arrANSWER[1];
						if ( sQUESTION_TYPE == "Ranking" && arrANSWER.Length == 3 )
						{
							nWEIGHT = Sql.ToInteger(arrANSWER[2]);
						}
					}
					else if ( arrANSWER[0].Length == 32+1+32 )
					{
						string[] arrCOLUMN = arrANSWER[0].Split('_');
						if ( arrCOLUMN.Length == 2 )
						{
							string sANSWER_ID = arrCOLUMN[0];
							string sCOLUMN_ID = arrCOLUMN[1];
							gANSWER_ID = ConvertAnswerID(sANSWER_ID);
							gCOLUMN_ID = ConvertAnswerID(sCOLUMN_ID);
							if ( sCOLUMN_ID == md5("Other") )
							{
								sANSWER_TEXT = arrANSWER[1];
							}
							else
							{
								sANSWER_TEXT = arrANSWER[1];
								if ( arrANSWER.Length > 2 )
									sCOLUMN_TEXT = arrANSWER[2];
								if ( arrANSWER.Length > 3 )
									nWEIGHT = Sql.ToInteger(arrANSWER[3]);
							}
						}
					}
					else if ( arrANSWER[0].Length == 32+1+32+1+32 )
					{
						string[] arrCOLUMN = arrANSWER[0].Split('_');
						if ( arrCOLUMN.Length == 3 )
						{
							string sANSWER_ID = arrCOLUMN[0];
							string sCOLUMN_ID = arrCOLUMN[1];
							string sMENU_ID   = arrCOLUMN[2];
							gANSWER_ID = ConvertAnswerID(sANSWER_ID);
							gCOLUMN_ID = ConvertAnswerID(sCOLUMN_ID);
							gMENU_ID   = ConvertAnswerID(sMENU_ID  );
							sANSWER_TEXT = arrANSWER[1];
							if ( arrANSWER.Length > 2 )
								sCOLUMN_TEXT = arrANSWER[2];
							if ( arrANSWER.Length > 3 )
								sMENU_TEXT = arrANSWER[3];
						}
					}
				}
			}
		}

		#region Update
		[DotNetLegacyData]
		[HttpPost("[action]")]
		public async Task<Guid> UpdateSurvey([FromBody] Dictionary<string, object> dict)
		{
			Guid gID = Guid.Empty;
			try
			{
				         gID              = (dict.ContainsKey("SURVEY_RESULT_ID") ?              Sql.ToGuid   (dict["SURVEY_RESULT_ID"])  : Guid.Empty       );
				Guid     gSURVEY_ID       = (dict.ContainsKey("ID"              ) ?              Sql.ToGuid   (dict["ID"              ])  : Guid.Empty       );
				Guid     gPARENT_ID       = (dict.ContainsKey("PARENT_ID"       ) ?              Sql.ToGuid   (dict["PARENT_ID"       ])  : Guid.Empty       );
				bool     bIS_COMPLETE     = (dict.ContainsKey("IS_COMPLETE"     ) ?              Sql.ToBoolean(dict["IS_COMPLETE"     ])  : false            );
				// 04/01/2020 Paul.  Move json utils to RestUtil. 
				DateTime dtSTART_DATE     = (dict.ContainsKey("START_DATE"      ) ? RestUtil.FromJsonDate (Sql.ToString(dict["START_DATE"      ])) : DateTime.MinValue);
				DateTime dtSUBMIT_DATE    = (dict.ContainsKey("SUBMIT_DATE"     ) ? RestUtil.FromJsonDate (Sql.ToString(dict["SUBMIT_DATE"     ])) : DateTime.MinValue);
				// 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
				Guid     gCURRENT_USER_ID = (dict.ContainsKey("CURRENT_USER_ID" ) ?              Sql.ToGuid   (dict["CURRENT_USER_ID" ])  : Guid.Empty       );
				Guid     gCURRENT_TEAM_ID = (dict.ContainsKey("CURRENT_TEAM_ID" ) ?              Sql.ToGuid   (dict["CURRENT_TEAM_ID" ])  : Guid.Empty       );
				string   sIP_ADDRESS      = Request.Headers["User-Address"].ToString();
				string   sUSER_AGENT      = @Request.Headers["User-Agent" ].ToString();
				// 08/14/2018 Paul.  New flag implemented on server to not assign current user to PARENT_ID. 
				bool     bKIOSK_MODE           = (dict.ContainsKey("KIOSK_MODE"          ) ? Sql.ToBoolean(dict["KIOSK_MODE"         ])  : false       );
				// 10/01/2018 Paul.  Include SURVEY_TARGET_MODULE. 
				string   sSURVEY_TARGET_MODULE = (dict.ContainsKey("SURVEY_TARGET_MODULE") ? Sql.ToString(dict["SURVEY_TARGET_MODULE"])  : String.Empty);
				if ( Sql.IsEmptyGuid(gPARENT_ID) && Security.IsAuthenticated() && !bKIOSK_MODE && Sql.IsEmptyString(sSURVEY_TARGET_MODULE) )
					gPARENT_ID = Security.USER_ID;
				
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					SqlProcs.spSURVEY_RESULTS_Update(ref gID, gSURVEY_ID, gPARENT_ID, dtSTART_DATE, dtSUBMIT_DATE, bIS_COMPLETE, sIP_ADDRESS, sUSER_AGENT);
					ArrayList arrSURVEY_PAGES = (dict.ContainsKey("SURVEY_PAGES") ? dict["SURVEY_PAGES"] as ArrayList : new ArrayList());
					if ( arrSURVEY_PAGES.Count > 0 )
					{
						for ( int nPageIndex = 0; nPageIndex < arrSURVEY_PAGES.Count; nPageIndex++ )
						{
							Dictionary<string, object> dictPage = arrSURVEY_PAGES[nPageIndex] as Dictionary<string, object>;
							Guid      gSURVEY_RESULT_ID    = gID;
							Guid      gSURVEY_PAGE_ID      = (dictPage.ContainsKey("ID"              ) ? Sql.ToGuid(dictPage["ID"])                : Guid.Empty     );
							ArrayList arrSURVEY_QUESTIONS  = (dictPage.ContainsKey("SURVEY_QUESTIONS") ? dictPage["SURVEY_QUESTIONS"] as ArrayList : new ArrayList());

							// 06/15/2013 Paul.  Use a transaction for each question so that a single question failure will not rollback any previous valid questions. 
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 10/01/2018 Paul.  Save raw survey page data for lead generation. 
									Guid gSURVEY_PAGES_RESULT_ID = Guid.Empty;
									string sRAW_CONTENT = String.Empty;
									string sSQL ;
									sSQL = "select ID                                    " + ControlChars.CrLf
									     + "     , RAW_CONTENT                           " + ControlChars.CrLf
									     + "  from vwSURVEY_PAGES_RESULTS                " + ControlChars.CrLf
									     + " where SURVEY_RESULT_ID   = @SURVEY_RESULT_ID" + ControlChars.CrLf
									     + "   and SURVEY_ID          = @SURVEY_ID       " + ControlChars.CrLf
									     + "   and SURVEY_PAGE_ID     = @SURVEY_PAGE_ID  " + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										cmd.Transaction = trn;
										Sql.AddParameter(cmd, "@SURVEY_RESULT_ID", gSURVEY_RESULT_ID);
										Sql.AddParameter(cmd, "@SURVEY_ID"       , gSURVEY_ID       );
										Sql.AddParameter(cmd, "@SURVEY_PAGE_ID"  , gSURVEY_PAGE_ID  );
										using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
										{
											if ( rdr.Read() )
											{
												gSURVEY_PAGES_RESULT_ID = Sql.ToGuid  (rdr["ID"         ]);
												sRAW_CONTENT            = Sql.ToString(rdr["RAW_CONTENT"]);
											}
										}
									}
									XmlDocument xml = null;
									if ( !Sql.IsEmptyString(sRAW_CONTENT) )
									{
										try
										{
											xml = new XmlDocument();
											xml.LoadXml(sRAW_CONTENT);
										}
										catch
										{
											xml = null;
										}
									}
									if ( xml == null )
									{
										xml = new XmlDocument();
										xml.AppendChild(xml.CreateProcessingInstruction("xml" , "version=\"1.0\" encoding=\"UTF-8\""));
										xml.AppendChild(xml.CreateElement("SurveyPage"));
										XmlUtil.SetSingleNodeAttribute(xml, xml.DocumentElement, "ID", gSURVEY_PAGE_ID.ToString());
									}
									if ( arrSURVEY_QUESTIONS.Count > 0 )
									{
										for ( int nQuestionIndex = 0; nQuestionIndex < arrSURVEY_QUESTIONS.Count; nQuestionIndex++ )
										{
											Dictionary<string, object> dictQuestion = arrSURVEY_QUESTIONS[nQuestionIndex] as Dictionary<string, object>;
											Guid   gSURVEY_QUESTION_ID = (dictQuestion.ContainsKey("ID"             ) ? Sql.ToGuid   (dictQuestion["ID"             ]) : Guid.Empty  );
											string sQUESTION_TYPE      = (dictQuestion.ContainsKey("QUESTION_TYPE"  ) ? Sql.ToString (dictQuestion["QUESTION_TYPE"  ]) : String.Empty);
											string sANSWER_CHOICES     = (dictQuestion.ContainsKey("ANSWER_CHOICES" ) ? Sql.ToString (dictQuestion["ANSWER_CHOICES" ]) : String.Empty);
											string sCOLUMN_CHOICES     = (dictQuestion.ContainsKey("COLUMN_CHOICES" ) ? Sql.ToString (dictQuestion["COLUMN_CHOICES" ]) : String.Empty);
											bool   bOTHER_AS_CHOICE    = (dictQuestion.ContainsKey("OTHER_AS_CHOICE") ? Sql.ToBoolean(dictQuestion["OTHER_AS_CHOICE"]) : false       );
											string sDISPLAY_FORMAT     = (dictQuestion.ContainsKey("DISPLAY_FORMAT" ) ? Sql.ToString (dictQuestion["DISPLAY_FORMAT" ]) : String.Empty);
											// 10/01/2018 Paul.  Save raw survey page data for lead generation. 
											XmlNode xSurveyQuestion = xml.DocumentElement.SelectSingleNode("SurveyQuestion[@ID=" + XmlUtil.EncaseXpathString(gSURVEY_QUESTION_ID.ToString()) + "]");
											if ( xSurveyQuestion == null )
											{
												xSurveyQuestion = xml.CreateElement("SurveyQuestion");
												xml.DocumentElement.AppendChild(xSurveyQuestion);
											}
											XmlUtil.SetSingleNodeAttribute(xml, xSurveyQuestion, "ID"           , gSURVEY_QUESTION_ID.ToString());
											XmlUtil.SetSingleNodeAttribute(xml, xSurveyQuestion, "QUESTION_TYPE", sQUESTION_TYPE                );
											if ( dictQuestion.ContainsKey("OTHER_AS_CHOICE") )
											{
												XmlUtil.SetSingleNodeAttribute(xml, xSurveyQuestion, "OTHER_AS_CHOICE", bOTHER_AS_CHOICE.ToString());
											}
											if ( !Sql.IsEmptyString(sDISPLAY_FORMAT) )
											{
												XmlUtil.SetSingleNodeAttribute(xml, xSurveyQuestion, "DISPLAY_FORMAT" , sDISPLAY_FORMAT);
											}
											
											XmlNode xANSWER_CHOICES = xSurveyQuestion.SelectSingleNode("ANSWER_CHOICES");
											if ( !Sql.IsEmptyString(sANSWER_CHOICES) )
											{
												string[] arrANSWER_CHOICES = sANSWER_CHOICES.Split(new String[] { ControlChars.CrLf }, StringSplitOptions.None);
												if ( xANSWER_CHOICES == null )
												{
													xANSWER_CHOICES = xml.CreateElement("ANSWER_CHOICES");
													xSurveyQuestion.AppendChild(xANSWER_CHOICES);
												}
												xANSWER_CHOICES.RemoveAll();
												for ( int i = 0; i < arrANSWER_CHOICES.Length; i++ )
												{
													XmlNode xValue = xml.CreateElement("Value");
													xANSWER_CHOICES.AppendChild(xValue);
													xValue.InnerText = arrANSWER_CHOICES[i];
													XmlUtil.SetSingleNodeAttribute(xml, xValue, "md5", ConvertAnswerID(md5(xValue.InnerText)).ToString());
												}
											}
											else if ( xANSWER_CHOICES != null )
											{
												xSurveyQuestion.RemoveChild(xANSWER_CHOICES);
											}
											
											XmlNode xCOLUMN_CHOICES = xSurveyQuestion.SelectSingleNode("COLUMN_CHOICES");
											if ( !Sql.IsEmptyString(sCOLUMN_CHOICES) )
											{
												string[] arrCOLUMN_CHOICES = sCOLUMN_CHOICES.Split(new String[] { ControlChars.CrLf }, StringSplitOptions.None);
												if ( xCOLUMN_CHOICES == null )
												{
													xCOLUMN_CHOICES = xml.CreateElement("COLUMN_CHOICES");
													xSurveyQuestion.AppendChild(xCOLUMN_CHOICES);
												}
												xCOLUMN_CHOICES.RemoveAll();
												for ( int i = 0; i < arrCOLUMN_CHOICES.Length; i++ )
												{
													XmlNode xValue = xml.CreateElement("Value");
													xCOLUMN_CHOICES.AppendChild(xValue);
													xValue.InnerText = arrCOLUMN_CHOICES[i];
													XmlUtil.SetSingleNodeAttribute(xml, xValue, "md5", ConvertAnswerID(md5(xValue.InnerText)).ToString());
												}
											}
											else if ( xCOLUMN_CHOICES != null )
											{
												xSurveyQuestion.RemoveChild(xCOLUMN_CHOICES);
											}
											
											XmlNode xVALUES = xSurveyQuestion.SelectSingleNode("VALUES");
											if ( xVALUES == null )
											{
												xVALUES = xml.CreateElement("VALUES");
												xSurveyQuestion.AppendChild(xVALUES);
											}
											// 06/15/2013 Paul.  Even if no values, log that the user saw the question. 
											if ( !dictQuestion.ContainsKey("VALUES") )
											{
												Guid gQUESTIONS_RESULT_ID = Guid.Empty;
												xSurveyQuestion.RemoveChild(xVALUES);
												SqlProcs.spSURVEY_QUESTIONS_RESULTS_Update(ref gQUESTIONS_RESULT_ID, gSURVEY_RESULT_ID, gSURVEY_ID, gSURVEY_PAGE_ID, gSURVEY_QUESTION_ID, Guid.Empty, String.Empty, Guid.Empty, String.Empty, Guid.Empty, String.Empty, 0, String.Empty, trn);
											}
											// 06/15/2013 Paul.  Single value questions are still returned in an array. 
											else if ( dictQuestion["VALUES"] is ArrayList )
											{
												ArrayList arrVALUES = dictQuestion["VALUES"] as ArrayList;
												xVALUES.RemoveAll();
												switch ( sQUESTION_TYPE )
												{
													case "Text Area"        :
													case "Textbox"          :
													// 12/26/2015 Paul.  Range not officially supported until now.  Was not saving the data. 
													case "Range"            :
													// 11/07/2018 Paul.  Provide a way to get a single numerical value for lead population.  Just like textbox but with numeric validation. 
													case "Single Numerical" :
													// 11/07/2018 Paul.  Provide a way to get a single numerical value for lead population.  Just like textbox but with numeric validation. 
													case "Single Date"      :
													// 11/10/2018 Paul.  Provide a way to get a single checkbox for lead population. 
													case "Single Checkbox"  :
													// 04/18/2018 Paul.  Hidden values need to be saved in the results table. 
													case "Hidden"           :
													{
														if ( arrVALUES.Count > 0 )
														{
															Guid   gANSWER_ID   = Guid.Empty  ;
															string sANSWER_TEXT = Sql.ToString(arrVALUES[0]);
															Guid   gCOLUMN_ID   = Guid.Empty  ;
															string sCOLUMN_TEXT = String.Empty;
															Guid   gMENU_ID     = Guid.Empty  ;
															string sMENU_TEXT   = String.Empty;
															int    nWEIGHT      = 0           ;
															string sOTHER_TEXT  = String.Empty;
															Guid gQUESTIONS_RESULT_ID = Guid.Empty;
															// 03/12/2019 Paul.  We need to convert the date from Json. 
															if ( sQUESTION_TYPE == "Single Date" )
															{
																// 03/12/2019 Paul.  Don't save 01/01/0001 if nothing is provided. 
																if ( !Sql.IsEmptyString(sANSWER_TEXT) )
																{
																	switch ( sDISPLAY_FORMAT )
																	{
																		// 04/01/2020 Paul.  Move json utils to RestUtil. 
																		case "Date"    :  sANSWER_TEXT = RestUtil.FromJsonDate(sANSWER_TEXT).ToShortDateString();  break;
																		case "Time"    :  sANSWER_TEXT = RestUtil.FromJsonDate(sANSWER_TEXT).ToShortTimeString();  break;
																		case "DateTime":  sANSWER_TEXT = RestUtil.FromJsonDate(sANSWER_TEXT).ToString()         ;  break;
																		// 03/12/2019 Paul.  If no format specified, then use full date time. 
																		default        :  sANSWER_TEXT = RestUtil.FromJsonDate(sANSWER_TEXT).ToString()         ;  break;
																	}
																}
															}
															SqlProcs.spSURVEY_QUESTIONS_RESULTS_Update(ref gQUESTIONS_RESULT_ID, gSURVEY_RESULT_ID, gSURVEY_ID, gSURVEY_PAGE_ID, gSURVEY_QUESTION_ID, gANSWER_ID, sANSWER_TEXT, gCOLUMN_ID, sCOLUMN_TEXT, gMENU_ID, sMENU_TEXT, nWEIGHT, sOTHER_TEXT, trn);
															// 10/01/2018 Paul.  Save raw survey page data for lead generation. 
															XmlNode xValue = xml.CreateElement("Value");
															xVALUES.AppendChild(xValue);
															xValue.InnerText = sANSWER_TEXT;
														}
														break;
													}
													case "Radio"            :
													case "Dropdown"         :
													case "Checkbox"         :
													case "Ranking"          :
													case "Rating Scale"     :
													case "Radio Matrix"     :
													case "Checkbox Matrix"  :
													case "Dropdown Matrix"  :
													case "Textbox Multiple" :
													case "Textbox Numerical":
													case "Date"             :
													case "Demographic"      :
													{
														// 6311ae17c1ee52b36e68aaf4ad066387,aaaa
														// 6311ae17c1ee52b36e68aaf4ad066387,bbbb
														// 6311ae17c1ee52b36e68aaf4ad066387,cccc
														foreach ( string sVALUE in arrVALUES )
														{
															Guid   gANSWER_ID   = Guid.Empty  ;
															string sANSWER_TEXT = String.Empty;
															Guid   gCOLUMN_ID   = Guid.Empty  ;
															string sCOLUMN_TEXT = String.Empty;
															Guid   gMENU_ID     = Guid.Empty  ;
															string sMENU_TEXT   = String.Empty;
															int    nWEIGHT      = 0           ;
															string sOTHER_TEXT  = String.Empty;
															if ( !Sql.IsEmptyString(sVALUE) )
															{
																SplitAnswer(sQUESTION_TYPE, sVALUE, bOTHER_AS_CHOICE, ref gANSWER_ID, ref sANSWER_TEXT, ref gCOLUMN_ID, ref sCOLUMN_TEXT, ref gMENU_ID, ref sMENU_TEXT, ref nWEIGHT, ref sOTHER_TEXT);
																if ( sQUESTION_TYPE == "Date" )
																{
																	// 08/22/2018 Paul.  Don't save 01/01/0001 if nothing is provided. 
																	if ( !Sql.IsEmptyString(sANSWER_TEXT) )
																	{
																		switch ( sDISPLAY_FORMAT )
																		{
																			// 04/01/2020 Paul.  Move json utils to RestUtil. 
																			case "Date"    :  sANSWER_TEXT = RestUtil.FromJsonDate(sANSWER_TEXT).ToShortDateString();  break;
																			case "Time"    :  sANSWER_TEXT = RestUtil.FromJsonDate(sANSWER_TEXT).ToShortTimeString();  break;
																			case "DateTime":  sANSWER_TEXT = RestUtil.FromJsonDate(sANSWER_TEXT).ToString()         ;  break;
																			// 03/12/2019 Paul.  If no format specified, then use full date time. 
																			default        :  sANSWER_TEXT = RestUtil.FromJsonDate(sANSWER_TEXT).ToString()         ;  break;
																		}
																	}
																}
																Guid gQUESTIONS_RESULT_ID = Guid.Empty;
																SqlProcs.spSURVEY_QUESTIONS_RESULTS_Update(ref gQUESTIONS_RESULT_ID, gSURVEY_RESULT_ID, gSURVEY_ID, gSURVEY_PAGE_ID, gSURVEY_QUESTION_ID, gANSWER_ID, sANSWER_TEXT, gCOLUMN_ID, sCOLUMN_TEXT, gMENU_ID, sMENU_TEXT, nWEIGHT, sOTHER_TEXT, trn);
																// 10/01/2018 Paul.  Save raw survey page data for lead generation. 
																string[] arrANSWER = sVALUE.Split(',');
																XmlNode xValue = xml.CreateElement("Value");
																xVALUES.AppendChild(xValue);
																xValue.InnerText = sANSWER_TEXT;
																XmlUtil.SetSingleNodeAttribute(xml, xValue, "raw", sVALUE);
																XmlUtil.SetSingleNodeAttribute(xml, xValue, "ANSWER_ID"  , gANSWER_ID.ToString());
																XmlUtil.SetSingleNodeAttribute(xml, xValue, "ANSWER_TEXT", sANSWER_TEXT);
																if ( !Sql.IsEmptyGuid(gCOLUMN_ID) )
																{
																	XmlUtil.SetSingleNodeAttribute(xml, xValue, "COLUMN_ID"  , gCOLUMN_ID.ToString());
																	XmlUtil.SetSingleNodeAttribute(xml, xValue, "COLUMN_TEXT", sCOLUMN_TEXT);
																	xValue.InnerText += "," + sCOLUMN_TEXT;
																}
																if ( !Sql.IsEmptyGuid(gMENU_ID) )
																{
																	XmlUtil.SetSingleNodeAttribute(xml, xValue, "MENU_ID"  , gMENU_ID.ToString());
																	XmlUtil.SetSingleNodeAttribute(xml, xValue, "MENU_TEXT", sMENU_TEXT);
																	xValue.InnerText += "," + sMENU_TEXT;
																}
																if ( !Sql.IsEmptyString(sOTHER_TEXT) )
																{
																	XmlUtil.SetSingleNodeAttribute(xml, xValue, "OTHER_TEXT", sOTHER_TEXT);
																}
															}
														}
														break;
													}
													case "Plain Text"       :
													case "Image"            :
														break;
												}
											}
										}
									}
									// 10/01/2018 Paul.  Save raw survey page data for lead generation. 
									sRAW_CONTENT = xml.OuterXml;
									SqlProcs.spSURVEY_PAGES_RESULTS_Update(ref gSURVEY_PAGES_RESULT_ID, gSURVEY_RESULT_ID, gSURVEY_ID, gSURVEY_PAGE_ID, sRAW_CONTENT, trn);
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
				}
				// 10/09/2018 Paul.  When the survey is complete, create the lead in a thread so that the customer is not delayed. 
				if ( !Sql.IsEmptyString(sSURVEY_TARGET_MODULE) && bIS_COMPLETE )
				{
					SurveyCreateLead build = new SurveyCreateLead(Sql, SqlProcs, XmlUtil, SplendidError, Modules, gID, gCURRENT_USER_ID, gCURRENT_TEAM_ID);
					await taskQueue.QueueBackgroundWorkItemAsync(build.Start);
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
			return gID;
		}
		#endregion

		public class SurveyCreateLead
		{
			private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			private HttpApplicationState Application        = new HttpApplicationState();
			private Sql                  Sql                ;
			private SqlProcs             SqlProcs           ;
			private XmlUtil              XmlUtil            ;
			private SplendidError        SplendidError      ;
			private SplendidCRM.Crm.Modules          Modules            ;
			
			private Guid gSURVEY_RESULT_ID;
			private Guid gCURRENT_USER_ID;
			private Guid gCURRENT_TEAM_ID;
			
			public SurveyCreateLead(Sql Sql, SqlProcs SqlProcs, XmlUtil XmlUtil, SplendidError SplendidError, SplendidCRM.Crm.Modules Modules, Guid gSURVEY_RESULT_ID, Guid gCURRENT_USER_ID, Guid gCURRENT_TEAM_ID)
			{
				this.Sql                 = Sql                ;
				this.SqlProcs            = SqlProcs           ;
				this.XmlUtil             = XmlUtil            ;
				this.SplendidError       = SplendidError      ;
				this.Modules             = Modules            ;

				this.gSURVEY_RESULT_ID   = gSURVEY_RESULT_ID  ;
				this.gCURRENT_USER_ID    = gCURRENT_USER_ID   ;
				this.gCURRENT_TEAM_ID    = gCURRENT_TEAM_ID   ;
			}
			
#pragma warning disable CS1998
			public async ValueTask Start(CancellationToken token)
		{
			Start();
		}
#pragma warning restore CS1998

			public void Start()
			{
				try
				{
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						using ( DataTable dt = new DataTable() )
						{
							string sSQL ;
							sSQL = "select *                              " + ControlChars.CrLf
							     + "  from vwSURVEY_PAGES_RESULTS_CONTENT " + ControlChars.CrLf
							     + " where ID = @SURVEY_RESULT_ID         " + ControlChars.CrLf
							     + " order by PAGE_NUMBER, QUESTION_NUMBER" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@SURVEY_RESULT_ID", gSURVEY_RESULT_ID);
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dt);
								}
							}
							if ( dt.Rows.Count > 0 )
							{
								string sSURVEY_NAME              = Sql.ToString(dt.Rows[0]["SURVEY_NAME"             ]);
								// 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
								string sSURVEY_TARGET_MODULE     = Sql.ToString(dt.Rows[0]["SURVEY_TARGET_MODULE"    ]);
								string sSURVEY_TARGET_ASSIGNMENT = Sql.ToString(dt.Rows[0]["SURVEY_TARGET_ASSIGNMENT"]);
								Guid   gSURVEY_ID                = Sql.ToGuid  (dt.Rows[0]["SURVEY_ID"               ]);
								Guid   gTEAM_ID                  = Sql.ToGuid  (dt.Rows[0]["TEAM_ID"                 ]);
								Guid   gASSIGNED_USER_ID         = Guid.Empty;
								Guid   gPARENT_ID                = Sql.ToGuid  (dt.Rows[0]["PARENT_ID"               ]);
								bool   bEnableTeamManagement     = Sql.ToBoolean(Application["CONFIG.enable_team_management"]) || Sql.ToBoolean(Application["CONFIG.enable_multi_tenant_teams"]);
								string sTABLE_NAME               = Modules.TableName(sSURVEY_TARGET_MODULE);
								// 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
								if ( sSURVEY_TARGET_ASSIGNMENT == "Current User" )
								{
									gASSIGNED_USER_ID = this.gCURRENT_USER_ID;
									gTEAM_ID          = this.gCURRENT_TEAM_ID;
								}
								
								IDbCommand cmdImport = null;
								cmdImport = SqlProcs.Factory(con, "sp" + sTABLE_NAME + "_Update");
								DataTable dtColumns = new DataTable();
								dtColumns.Columns.Add("ColumnName"  , Type.GetType("System.String"));
								dtColumns.Columns.Add("NAME"        , Type.GetType("System.String"));
								dtColumns.Columns.Add("DISPLAY_NAME", Type.GetType("System.String"));
								dtColumns.Columns.Add("ColumnType"  , Type.GetType("System.String"));
								dtColumns.Columns.Add("Size"        , Type.GetType("System.Int32" ));
								dtColumns.Columns.Add("Scale"       , Type.GetType("System.Int32" ));
								dtColumns.Columns.Add("Precision"   , Type.GetType("System.Int32" ));
								dtColumns.Columns.Add("colid"       , Type.GetType("System.Int32" ));
								dtColumns.Columns.Add("CustomField" , Type.GetType("System.Boolean"));
								for ( int i =0; i < cmdImport.Parameters.Count; i++ )
								{
									IDbDataParameter par = cmdImport.Parameters[i] as IDbDataParameter;
									DataRow row = dtColumns.NewRow();
									dtColumns.Rows.Add(row);
									row["ColumnName"  ] = par.ParameterName;
									row["NAME"        ] = Sql.ExtractDbName(cmdImport, par.ParameterName);
									row["DISPLAY_NAME"] = Sql.ToString(row["NAME"]);
									row["ColumnType"  ] = par.DbType.ToString();
									row["Size"        ] = par.Size         ;
									row["Scale"       ] = par.Scale        ;
									row["Precision"   ] = par.Precision    ;
									row["colid"       ] = i                ;
									row["CustomField" ] = false            ;
									
									string sParameterName = Sql.ExtractDbName(cmdImport, par.ParameterName).ToUpper();
									if ( sParameterName == "TEAM_ID" && bEnableTeamManagement )
										par.Value = Sql.ToDBGuid(gTEAM_ID);
									// 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
									else if ( sParameterName == "ASSIGNED_USER_ID" )
										par.Value = gASSIGNED_USER_ID;
									else if ( sParameterName == "MODIFIED_USER_ID" )
										par.Value = gASSIGNED_USER_ID;
									else
										par.Value = DBNull.Value;
								}
								sSQL = "select *                       " + ControlChars.CrLf
								     + "  from vwSqlColumns            " + ControlChars.CrLf
								     + " where ObjectName = @OBJECTNAME" + ControlChars.CrLf
								     + "   and ColumnName <> 'ID_C'    " + ControlChars.CrLf
								     + " order by colid                " + ControlChars.CrLf;
								using ( IDbCommand cmd = con.CreateCommand() )
								{
									cmd.CommandText = sSQL;
									Sql.AddParameter(cmd, "@OBJECTNAME", Sql.MetadataName(cmd, sTABLE_NAME + "_CSTM"));
									using ( DbDataAdapter da = dbf.CreateDataAdapter() )
									{
										((IDbDataAdapter)da).SelectCommand = cmd;
										DataTable dtCSTM = new DataTable();
										da.Fill(dtCSTM);
										foreach ( DataRow rowCSTM in dtCSTM.Rows )
										{
											DataRow row = dtColumns.NewRow();
											row["ColumnName"  ] = Sql.ToString (rowCSTM["ColumnName"]);
											row["NAME"        ] = Sql.ToString (rowCSTM["ColumnName"]);
											row["DISPLAY_NAME"] = Sql.ToString (rowCSTM["ColumnName"]);
											row["ColumnType"  ] = Sql.ToString (rowCSTM["CsType"    ]);
											row["Size"        ] = Sql.ToInteger(rowCSTM["length"    ]);
											row["colid"       ] = dtColumns.Rows.Count;
											row["CustomField" ] = true;
											dtColumns.Rows.Add(row);
										}
									}
								}
								DataView vwColumns = new DataView(dtColumns);
								IDbCommand cmdImportCSTM = null;
								vwColumns.RowFilter = "CustomField = 1";
								if ( vwColumns.Count > 0 )
								{
									vwColumns.Sort = "colid";
									cmdImportCSTM = con.CreateCommand();
									cmdImportCSTM.CommandType = CommandType.Text;
									cmdImportCSTM.CommandText = "update " + sTABLE_NAME + "_CSTM" + ControlChars.CrLf;
									int nFieldIndex = 0;
									foreach ( DataRowView row in vwColumns )
									{
										string sNAME   = Sql.ToString(row["ColumnName"]).ToUpper();
										string sCsType = Sql.ToString(row["ColumnType"]);
										int    nMAX_SIZE = Sql.ToInteger(row["Size"]);
										if ( nFieldIndex == 0 )
											cmdImportCSTM.CommandText += "   set ";
										else
											cmdImportCSTM.CommandText += "     , ";
										cmdImportCSTM.CommandText += sNAME + " = @" + sNAME + ControlChars.CrLf;
										
										IDbDataParameter par = null;
										switch ( sCsType )
										{
											case "Guid"    :  par = Sql.AddParameter(cmdImportCSTM, "@" + sNAME, Guid.Empty             );  break;
											case "short"   :  par = Sql.AddParameter(cmdImportCSTM, "@" + sNAME, 0                      );  break;
											case "Int32"   :  par = Sql.AddParameter(cmdImportCSTM, "@" + sNAME, 0                      );  break;
											case "Int64"   :  par = Sql.AddParameter(cmdImportCSTM, "@" + sNAME, 0                      );  break;
											case "float"   :  par = Sql.AddParameter(cmdImportCSTM, "@" + sNAME, 0.0f                   );  break;
											case "decimal" :  par = Sql.AddParameter(cmdImportCSTM, "@" + sNAME, new Decimal()          );  break;
											case "bool"    :  par = Sql.AddParameter(cmdImportCSTM, "@" + sNAME, false                  );  break;
											case "DateTime":  par = Sql.AddParameter(cmdImportCSTM, "@" + sNAME, DateTime.MinValue      );  break;
											default        :  par = Sql.AddParameter(cmdImportCSTM, "@" + sNAME, String.Empty, nMAX_SIZE);  break;
										}
										nFieldIndex++;
									}
									cmdImportCSTM.CommandText += " where ID_C = @ID_C" + ControlChars.CrLf;
									Sql.AddParameter(cmdImportCSTM, "@ID_C", Guid.Empty);
								}
								vwColumns.RowFilter = "";
								
								using ( IDbTransaction trn = Sql.BeginTransaction(con) )
								{
									cmdImport.Transaction = trn;
									if ( cmdImportCSTM != null )
										cmdImportCSTM.Transaction = trn;
									try
									{
										foreach ( DataRow row in dt.Rows )
										{
											Guid   gSURVEY_PAGE_ID       = Sql.ToGuid  (row["SURVEY_PAGE_ID"      ]);
											Guid   gSURVEY_QUESTION_ID   = Sql.ToGuid  (row["SURVEY_QUESTION_ID"  ]);
											string sSURVEY_QUESTION_NAME = Sql.ToString(row["SURVEY_QUESTION_NAME"]);
											string sQUESTION_TYPE        = Sql.ToString(row["QUESTION_TYPE"       ]);
											string sTARGET_FIELD_NAME    = Sql.ToString(row["TARGET_FIELD_NAME"   ]);
											string sRAW_CONTENT          = Sql.ToString(row["RAW_CONTENT"         ]);
											if ( sQUESTION_TYPE == "Demographic" )
											{
												XmlDocument xml = new XmlDocument();
												xml.LoadXml(sRAW_CONTENT);
												
												XmlNode xSurveyQuestion = xml.DocumentElement.SelectSingleNode("SurveyQuestion[@ID=" + XmlUtil.EncaseXpathString(gSURVEY_QUESTION_ID.ToString()) + "]");
												if ( xSurveyQuestion != null )
												{
													string sCOLUMN_CHOICES = XmlUtil.SelectSingleNode(xSurveyQuestion, "COLUMN_CHOICES/Value");
													XmlDocument xmlDemo = new XmlDocument();
													xmlDemo.LoadXml(sCOLUMN_CHOICES);
													
													XmlNode xVALUES = xSurveyQuestion.SelectSingleNode("VALUES");
													if ( xVALUES != null )
													{
														XmlNodeList nlFields = xmlDemo.DocumentElement.SelectNodes("Field");
														foreach ( XmlNode xField in nlFields )
														{
															string sDemoFieldName = XmlUtil.SelectAttribute(xField, "Name"       );
															sTARGET_FIELD_NAME    = XmlUtil.SelectAttribute(xField, "TargetField");
															if ( !Sql.IsEmptyString(sTARGET_FIELD_NAME) )
															{
																IDbDataParameter par = Sql.FindParameter(cmdImport, sTARGET_FIELD_NAME);
																if ( par == null && cmdImportCSTM != null )
																{
																	par = Sql.FindParameter(cmdImportCSTM, sTARGET_FIELD_NAME);
																}
																if ( par != null )
																{
																	Guid gANSWER_ID = ConvertAnswerID(md5(sDemoFieldName));
																	XmlNode xValue = xVALUES.SelectSingleNode("Value[@ANSWER_ID=" + XmlUtil.EncaseXpathString(gANSWER_ID.ToString()) + "]");
																	if ( xValue != null )
																	{
																		Sql.SetParameter(par, xValue.InnerText);
																	}
																}
															}
														}
													}
												}
											}
											else
											{
												IDbDataParameter par = Sql.FindParameter(cmdImport, sTARGET_FIELD_NAME);
												if ( par == null && cmdImportCSTM != null )
												{
													par = Sql.FindParameter(cmdImportCSTM, sTARGET_FIELD_NAME);
												}
												if ( par != null )
												{
													XmlDocument xml = new XmlDocument();
													xml.LoadXml(sRAW_CONTENT);
													XmlNode xSurveyQuestion = xml.DocumentElement.SelectSingleNode("SurveyQuestion[@ID=" + XmlUtil.EncaseXpathString(gSURVEY_QUESTION_ID.ToString()) + "]");
													if ( xSurveyQuestion != null )
													{
														XmlNode xVALUES = xSurveyQuestion.SelectSingleNode("VALUES");
														if ( xVALUES != null )
														{
															XmlNode xValue = xVALUES.SelectSingleNode("Value");
															if ( xValue != null )
															{
																Sql.SetParameter(par, xValue.InnerText);
															}
														}
													}
												}
											}
										}
										cmdImport.ExecuteNonQuery();
										if ( cmdImportCSTM != null )
										{
											IDbDataParameter parID = Sql.FindParameter(cmdImport, "ID");
											if ( parID != null )
											{
												Guid gNewID = Sql.ToGuid(parID.Value);
												SqlProcs.spSURVEY_RESULTS_UpdateParent(gSURVEY_RESULT_ID, gNewID, trn);
												
												IDbDataParameter parID_C = Sql.FindParameter(cmdImportCSTM, "ID_C");
												if ( parID_C != null )
												{
													Sql.SetParameter(parID_C, gNewID);
													cmdImportCSTM.ExecuteNonQuery();
												}
											}
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
					}
				}
				catch(Exception ex)
				{
					string sMessage = "Failed to create lead from survey for " + gSURVEY_RESULT_ID.ToString() + ControlChars.CrLf + Utils.ExpandException(ex);
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), sMessage);
				}
			}
		}
	}
}
