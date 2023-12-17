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
using System.Text;
using System.Data;
using System.Data.Common;
using System.Threading.Tasks;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

using Microsoft.Reporting.NETCore;

namespace SplendidCRM.Pages.Surveys
{
	[Authorize]
	[SplendidSessionAuthorize]
	[IgnoreAntiforgeryToken]
	[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
	public class StylesheetModel : PageModel
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private L10N                 L10n               ;
		private SplendidCRM.TimeZone T10n               = new SplendidCRM.TimeZone();
		private SplendidError        SplendidError      ;
		private SplendidCache        SplendidCache      ;
		private SplendidCRM.Crm.Modules          Modules              ;
		private SplendidCRM.Crm.NoteAttachments  NoteAttachments      ;
		private RdlUtil                          RdlUtil              ;
		private ReportsAttachmentView            ReportsAttachmentView;

		public StylesheetModel(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCache SplendidCache, SplendidCRM.Crm.Modules Modules, RdlUtil RdlUtil, SplendidCRM.Crm.NoteAttachments NoteAttachments, ReportsAttachmentView ReportsAttachmentView)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidCache       = SplendidCache      ;
			this.Modules             = Modules            ;
			this.RdlUtil             = RdlUtil            ;
			this.NoteAttachments     = NoteAttachments    ;
			this.ReportsAttachmentView = ReportsAttachmentView;
		}

		public IActionResult OnGet()
		{
			string sMessage = String.Empty;
			try
			{
				Guid gID = Sql.ToGuid(Request.Query["ID"]);
				if ( Sql.IsEmptyGuid(gID) )
					gID = Sql.ToGuid(Application["CONFIG.Surveys.DefaultTheme"]);
				if ( !Sql.IsEmptyGuid(gID) )
				{
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						string sSQL = String.Empty;
						sSQL = "select *              " + ControlChars.CrLf
						     + "  from vwSURVEY_THEMES" + ControlChars.CrLf
						     + " where ID = @ID       " + ControlChars.CrLf;
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
										StringBuilder sb = new StringBuilder();
										DataRow row = dtCurrent.Rows[0];
										string sSURVEY_FONT_FAMILY            = Sql.ToString(row["SURVEY_FONT_FAMILY"           ]);
										string sLOGO_BACKGROUND               = Sql.ToString(row["LOGO_BACKGROUND"              ]);
										string sSURVEY_BACKGROUND             = Sql.ToString(row["SURVEY_BACKGROUND"            ]);
										
										string sSURVEY_TITLE_TEXT_COLOR       = Sql.ToString(row["SURVEY_TITLE_TEXT_COLOR"      ]);
										string sSURVEY_TITLE_FONT_SIZE        = Sql.ToString(row["SURVEY_TITLE_FONT_SIZE"       ]);
										string sSURVEY_TITLE_FONT_STYLE       = Sql.ToString(row["SURVEY_TITLE_FONT_STYLE"      ]);
										string sSURVEY_TITLE_FONT_WEIGHT      = Sql.ToString(row["SURVEY_TITLE_FONT_WEIGHT"     ]);
										string sSURVEY_TITLE_DECORATION       = Sql.ToString(row["SURVEY_TITLE_DECORATION"      ]);
										string sSURVEY_TITLE_BACKGROUND       = Sql.ToString(row["SURVEY_TITLE_BACKGROUND"      ]);
										
										string sPAGE_TITLE_TEXT_COLOR         = Sql.ToString(row["PAGE_TITLE_TEXT_COLOR"        ]);
										string sPAGE_TITLE_FONT_SIZE          = Sql.ToString(row["PAGE_TITLE_FONT_SIZE"         ]);
										string sPAGE_TITLE_FONT_STYLE         = Sql.ToString(row["PAGE_TITLE_FONT_STYLE"        ]);
										string sPAGE_TITLE_FONT_WEIGHT        = Sql.ToString(row["PAGE_TITLE_FONT_WEIGHT"       ]);
										string sPAGE_TITLE_DECORATION         = Sql.ToString(row["PAGE_TITLE_DECORATION"        ]);
										string sPAGE_TITLE_BACKGROUND         = Sql.ToString(row["PAGE_TITLE_BACKGROUND"        ]);
										
										string sPAGE_DESCRIPTION_TEXT_COLOR   = Sql.ToString(row["PAGE_DESCRIPTION_TEXT_COLOR"  ]);
										string sPAGE_DESCRIPTION_FONT_SIZE    = Sql.ToString(row["PAGE_DESCRIPTION_FONT_SIZE"   ]);
										string sPAGE_DESCRIPTION_FONT_STYLE   = Sql.ToString(row["PAGE_DESCRIPTION_FONT_STYLE"  ]);
										string sPAGE_DESCRIPTION_FONT_WEIGHT  = Sql.ToString(row["PAGE_DESCRIPTION_FONT_WEIGHT" ]);
										string sPAGE_DESCRIPTION_DECORATION   = Sql.ToString(row["PAGE_DESCRIPTION_DECORATION"  ]);
										string sPAGE_DESCRIPTION_BACKGROUND   = Sql.ToString(row["PAGE_DESCRIPTION_BACKGROUND"  ]);
										
										string sQUESTION_HEADING_TEXT_COLOR   = Sql.ToString(row["QUESTION_HEADING_TEXT_COLOR"  ]);
										string sQUESTION_HEADING_FONT_SIZE    = Sql.ToString(row["QUESTION_HEADING_FONT_SIZE"   ]);
										string sQUESTION_HEADING_FONT_STYLE   = Sql.ToString(row["QUESTION_HEADING_FONT_STYLE"  ]);
										string sQUESTION_HEADING_FONT_WEIGHT  = Sql.ToString(row["QUESTION_HEADING_FONT_WEIGHT" ]);
										string sQUESTION_HEADING_DECORATION   = Sql.ToString(row["QUESTION_HEADING_DECORATION"  ]);
										string sQUESTION_HEADING_BACKGROUND   = Sql.ToString(row["QUESTION_HEADING_BACKGROUND"  ]);
										
										string sQUESTION_CHOICE_TEXT_COLOR    = Sql.ToString(row["QUESTION_CHOICE_TEXT_COLOR"   ]);
										string sQUESTION_CHOICE_FONT_SIZE     = Sql.ToString(row["QUESTION_CHOICE_FONT_SIZE"    ]);
										string sQUESTION_CHOICE_FONT_STYLE    = Sql.ToString(row["QUESTION_CHOICE_FONT_STYLE"   ]);
										string sQUESTION_CHOICE_FONT_WEIGHT   = Sql.ToString(row["QUESTION_CHOICE_FONT_WEIGHT"  ]);
										string sQUESTION_CHOICE_DECORATION    = Sql.ToString(row["QUESTION_CHOICE_DECORATION"   ]);
										string sQUESTION_CHOICE_BACKGROUND    = Sql.ToString(row["QUESTION_CHOICE_BACKGROUND"   ]);
										
										string sPROGRESS_BAR_PAGE_WIDTH       = Sql.ToString(row["PROGRESS_BAR_PAGE_WIDTH"      ]);
										string sPROGRESS_BAR_COLOR            = Sql.ToString(row["PROGRESS_BAR_COLOR"           ]);
										string sPROGRESS_BAR_BORDER_COLOR     = Sql.ToString(row["PROGRESS_BAR_BORDER_COLOR"    ]);
										string sPROGRESS_BAR_BORDER_WIDTH     = Sql.ToString(row["PROGRESS_BAR_BORDER_WIDTH"    ]);
										string sPROGRESS_BAR_TEXT_COLOR       = Sql.ToString(row["PROGRESS_BAR_TEXT_COLOR"      ]);
										string sPROGRESS_BAR_FONT_SIZE        = Sql.ToString(row["PROGRESS_BAR_FONT_SIZE"       ]);
										string sPROGRESS_BAR_FONT_STYLE       = Sql.ToString(row["PROGRESS_BAR_FONT_STYLE"      ]);
										string sPROGRESS_BAR_FONT_WEIGHT      = Sql.ToString(row["PROGRESS_BAR_FONT_WEIGHT"     ]);
										string sPROGRESS_BAR_DECORATION       = Sql.ToString(row["PROGRESS_BAR_DECORATION"      ]);
										string sPROGRESS_BAR_BACKGROUND       = Sql.ToString(row["PROGRESS_BAR_BACKGROUND"      ]);
										
										string sERROR_TEXT_COLOR              = Sql.ToString(row["ERROR_TEXT_COLOR"             ]);
										string sERROR_FONT_SIZE               = Sql.ToString(row["ERROR_FONT_SIZE"              ]);
										string sERROR_FONT_STYLE              = Sql.ToString(row["ERROR_FONT_STYLE"             ]);
										string sERROR_FONT_WEIGHT             = Sql.ToString(row["ERROR_FONT_WEIGHT"            ]);
										string sERROR_DECORATION              = Sql.ToString(row["ERROR_DECORATION"             ]);
										string sERROR_BACKGROUND              = Sql.ToString(row["ERROR_BACKGROUND"             ]);
										
										string sEXIT_LINK_TEXT_COLOR          = Sql.ToString(row["EXIT_LINK_TEXT_COLOR"         ]);
										string sEXIT_LINK_FONT_SIZE           = Sql.ToString(row["EXIT_LINK_FONT_SIZE"          ]);
										string sEXIT_LINK_FONT_STYLE          = Sql.ToString(row["EXIT_LINK_FONT_STYLE"         ]);
										string sEXIT_LINK_FONT_WEIGHT         = Sql.ToString(row["EXIT_LINK_FONT_WEIGHT"        ]);
										string sEXIT_LINK_DECORATION          = Sql.ToString(row["EXIT_LINK_DECORATION"         ]);
										string sEXIT_LINK_BACKGROUND          = Sql.ToString(row["EXIT_LINK_BACKGROUND"         ]);
										
										string sREQUIRED_TEXT_COLOR           = Sql.ToString(row["REQUIRED_TEXT_COLOR"          ]);
										
										sb.AppendLine("body");
										sb.AppendLine("{");
										sb.AppendLine("	margin: 0px 0px 0px 0px;");
										if ( !Sql.IsEmptyString(sSURVEY_FONT_FAMILY          ) ) sb.AppendLine("	font-family: "      + sSURVEY_FONT_FAMILY          + ";");
										if ( !Sql.IsEmptyString(sSURVEY_BACKGROUND           ) ) sb.AppendLine("	background-color: " + sSURVEY_BACKGROUND           + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".copyRight");
										sb.AppendLine("{");
										sb.AppendLine("	font-size: 12px;");
										sb.AppendLine("	font-weight: normal;");
										sb.AppendLine("}");
										
										// 06/16/2013 Paul.  The calendar does not need to be 10% larger. 
										sb.AppendLine(".ui-widget");
										sb.AppendLine("{");
										sb.AppendLine("	font-size: 12px;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyBody");
										sb.AppendLine("{");
										if ( !Sql.IsEmptyString(sSURVEY_FONT_FAMILY          ) ) sb.AppendLine("	font-family: "      + sSURVEY_FONT_FAMILY          + ";");
										if ( !Sql.IsEmptyString(sSURVEY_BACKGROUND           ) ) sb.AppendLine("	background-color: " + sSURVEY_BACKGROUND           + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyHeader");
										sb.AppendLine("{");
										if ( !Sql.IsEmptyString(sLOGO_BACKGROUND             ) ) sb.AppendLine("	background-color: " + sLOGO_BACKGROUND             + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyTitle");
										sb.AppendLine("{");
										sb.AppendLine("	padding: 4px 10px 4px 10px;");
										if ( !Sql.IsEmptyString(sSURVEY_TITLE_TEXT_COLOR     ) ) sb.AppendLine("	color: "            + sSURVEY_TITLE_TEXT_COLOR     + ";");
										if ( !Sql.IsEmptyString(sSURVEY_TITLE_FONT_SIZE      ) ) sb.AppendLine("	font-size: "        + sSURVEY_TITLE_FONT_SIZE      + ";");
										if ( !Sql.IsEmptyString(sSURVEY_TITLE_FONT_STYLE     ) ) sb.AppendLine("	font-style: "       + sSURVEY_TITLE_FONT_STYLE     + ";");
										if ( !Sql.IsEmptyString(sSURVEY_TITLE_FONT_WEIGHT    ) ) sb.AppendLine("	font-weight: "      + sSURVEY_TITLE_FONT_WEIGHT    + ";");
										if ( !Sql.IsEmptyString(sSURVEY_TITLE_DECORATION     ) ) sb.AppendLine("	text-decoration: "  + sSURVEY_TITLE_DECORATION     + ";");
										if ( !Sql.IsEmptyString(sSURVEY_TITLE_BACKGROUND     ) ) sb.AppendLine("	background-color: " + sSURVEY_TITLE_BACKGROUND     + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyPageTitle");
										sb.AppendLine("{");
										sb.AppendLine("	padding: 4px 10px 4px 10px;");
										sb.AppendLine("	margin-bottom: 10px;");
										if ( !Sql.IsEmptyString(sPAGE_TITLE_TEXT_COLOR       ) ) sb.AppendLine("	color: "            + sPAGE_TITLE_TEXT_COLOR       + ";");
										if ( !Sql.IsEmptyString(sPAGE_TITLE_FONT_SIZE        ) ) sb.AppendLine("	font-size: "        + sPAGE_TITLE_FONT_SIZE        + ";");
										if ( !Sql.IsEmptyString(sPAGE_TITLE_FONT_STYLE       ) ) sb.AppendLine("	font-style: "       + sPAGE_TITLE_FONT_STYLE       + ";");
										if ( !Sql.IsEmptyString(sPAGE_TITLE_FONT_WEIGHT      ) ) sb.AppendLine("	font-weight: "      + sPAGE_TITLE_FONT_WEIGHT      + ";");
										if ( !Sql.IsEmptyString(sPAGE_TITLE_DECORATION       ) ) sb.AppendLine("	text-decoration: "  + sPAGE_TITLE_DECORATION       + ";");
										if ( !Sql.IsEmptyString(sPAGE_TITLE_BACKGROUND       ) ) sb.AppendLine("	background-color: " + sPAGE_TITLE_BACKGROUND       + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyPageDescription");
										sb.AppendLine("{");
										sb.AppendLine("	padding: 10px 10px 10px 10px;");
										if ( !Sql.IsEmptyString(sPAGE_DESCRIPTION_TEXT_COLOR ) ) sb.AppendLine("	color: "            + sPAGE_DESCRIPTION_TEXT_COLOR + ";");
										if ( !Sql.IsEmptyString(sPAGE_DESCRIPTION_FONT_SIZE  ) ) sb.AppendLine("	font-size: "        + sPAGE_DESCRIPTION_FONT_SIZE  + ";");
										if ( !Sql.IsEmptyString(sPAGE_DESCRIPTION_FONT_STYLE ) ) sb.AppendLine("	font-style: "       + sPAGE_DESCRIPTION_FONT_STYLE + ";");
										if ( !Sql.IsEmptyString(sPAGE_DESCRIPTION_FONT_WEIGHT) ) sb.AppendLine("	font-weight: "      + sPAGE_DESCRIPTION_FONT_WEIGHT+ ";");
										if ( !Sql.IsEmptyString(sPAGE_DESCRIPTION_DECORATION ) ) sb.AppendLine("	text-decoration: "  + sPAGE_DESCRIPTION_DECORATION + ";");
										if ( !Sql.IsEmptyString(sPAGE_DESCRIPTION_BACKGROUND ) ) sb.AppendLine("	background-color: " + sPAGE_DESCRIPTION_BACKGROUND + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyPageBody");
										sb.AppendLine("{");
										sb.AppendLine("	width: 100%;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyPage");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyQuestionFrame");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyQuestionDesignFrame");
										sb.AppendLine("{");
										sb.AppendLine("	border-style: dashed;");
										sb.AppendLine("	border-width: 1px;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyQuestionContent");
										sb.AppendLine("{");
										sb.AppendLine("	padding: 5px 20px 5px 20px;");
										sb.AppendLine("}");
										
										// 11/12/2018 Paul.  Add stub for SurveyQuestionNumber. 
										sb.AppendLine(".SurveyQuestionNumber");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyQuestionError");
										sb.AppendLine("{");
										if ( !Sql.IsEmptyString(sERROR_TEXT_COLOR            ) ) sb.AppendLine("	color: "            + sERROR_TEXT_COLOR            + ";");
										if ( !Sql.IsEmptyString(sERROR_FONT_SIZE             ) ) sb.AppendLine("	font-size: "        + sERROR_FONT_SIZE             + ";");
										if ( !Sql.IsEmptyString(sERROR_FONT_STYLE            ) ) sb.AppendLine("	font-style: "       + sERROR_FONT_STYLE            + ";");
										if ( !Sql.IsEmptyString(sERROR_FONT_WEIGHT           ) ) sb.AppendLine("	font-weight: "      + sERROR_FONT_WEIGHT           + ";");
										if ( !Sql.IsEmptyString(sERROR_DECORATION            ) ) sb.AppendLine("	text-decoration: "  + sERROR_DECORATION            + ";");
										if ( !Sql.IsEmptyString(sERROR_BACKGROUND            ) ) sb.AppendLine("	background-color: " + sERROR_BACKGROUND            + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyQuestionRequiredAsterisk");
										sb.AppendLine("{");
										sb.AppendLine("	font-size: 150%;");
										sb.AppendLine("	position: relative;");
										sb.AppendLine("	bottom: -0.3em;");
										sb.AppendLine("	padding-right: 4px;");
										if ( !Sql.IsEmptyString(sQUESTION_HEADING_FONT_SIZE  ) ) sb.AppendLine("	line-height: "      + sQUESTION_HEADING_FONT_SIZE  + ";");
										if ( !Sql.IsEmptyString(sREQUIRED_TEXT_COLOR         ) ) sb.AppendLine("	color: "            + sREQUIRED_TEXT_COLOR         + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyQuestionHeading");
										sb.AppendLine("{");
										sb.AppendLine("	padding: 2px 0px 2px 0px;");
										if ( !Sql.IsEmptyString(sQUESTION_HEADING_TEXT_COLOR ) ) sb.AppendLine("	color: "            + sQUESTION_HEADING_TEXT_COLOR + ";");
										if ( !Sql.IsEmptyString(sQUESTION_HEADING_FONT_SIZE  ) ) sb.AppendLine("	font-size: "        + sQUESTION_HEADING_FONT_SIZE  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_HEADING_FONT_STYLE ) ) sb.AppendLine("	font-style: "       + sQUESTION_HEADING_FONT_STYLE + ";");
										if ( !Sql.IsEmptyString(sQUESTION_HEADING_FONT_WEIGHT) ) sb.AppendLine("	font-weight: "      + sQUESTION_HEADING_FONT_WEIGHT+ ";");
										if ( !Sql.IsEmptyString(sQUESTION_HEADING_DECORATION ) ) sb.AppendLine("	text-decoration: "  + sQUESTION_HEADING_DECORATION + ";");
										if ( !Sql.IsEmptyString(sQUESTION_HEADING_BACKGROUND ) ) sb.AppendLine("	background-color: " + sQUESTION_HEADING_BACKGROUND + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyQuestionBody");
										sb.AppendLine("{");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_TEXT_COLOR  ) ) sb.AppendLine("	color: "            + sQUESTION_CHOICE_TEXT_COLOR  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_SIZE   ) ) sb.AppendLine("	font-size: "        + sQUESTION_CHOICE_FONT_SIZE   + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_STYLE  ) ) sb.AppendLine("	font-style: "       + sQUESTION_CHOICE_FONT_STYLE  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_WEIGHT ) ) sb.AppendLine("	font-weight: "      + sQUESTION_CHOICE_FONT_WEIGHT + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_DECORATION  ) ) sb.AppendLine("	text-decoration: "  + sQUESTION_CHOICE_DECORATION  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_BACKGROUND  ) ) sb.AppendLine("	background-color: " + sQUESTION_CHOICE_BACKGROUND  + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerChoice");
										sb.AppendLine("{");
										sb.AppendLine("	padding: 2px 0px 2px 0px;");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_TEXT_COLOR  ) ) sb.AppendLine("	color: "            + sQUESTION_CHOICE_TEXT_COLOR  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_SIZE   ) ) sb.AppendLine("	font-size: "        + sQUESTION_CHOICE_FONT_SIZE   + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_STYLE  ) ) sb.AppendLine("	font-style: "       + sQUESTION_CHOICE_FONT_STYLE  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_WEIGHT ) ) sb.AppendLine("	font-weight: "      + sQUESTION_CHOICE_FONT_WEIGHT + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_DECORATION  ) ) sb.AppendLine("	text-decoration: "  + sQUESTION_CHOICE_DECORATION  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_BACKGROUND  ) ) sb.AppendLine("	background-color: " + sQUESTION_CHOICE_BACKGROUND  + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerChoiceRadio");
										sb.AppendLine("{");
										sb.AppendLine("	border: none;");
										sb.AppendLine("	background-color: inherit;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerChoiceCheckbox");
										sb.AppendLine("{");
										sb.AppendLine("	border: none;");
										sb.AppendLine("	background-color: inherit;");
										sb.AppendLine("}");
										
										// 06/09/2013 Paul.  Replace SplendidCRM style to allow odd row shading. 
										sb.AppendLine("input:focus");
										sb.AppendLine("{");
										sb.AppendLine("	background-color: inherit;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerChoiceDropdown");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerChoiceRanking");
										sb.AppendLine("{");
										sb.AppendLine("	margin: 2px 4px 2px 4px;");
										// 06/09/2013 Paul.  Clear the unordered list bullets. 
										sb.AppendLine("	list-style-type: none;");
										sb.AppendLine("	padding: 0;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerChoiceRankingHighlight");
										sb.AppendLine("{");
										sb.AppendLine("	margin: 2px 4px 2px 4px;");
										sb.AppendLine("	height: 1.9em;");
										sb.AppendLine("	line-height: 1.2em;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerChoiceRatingScale");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerTextArea");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerTextbox");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										// 10/08/2014 Paul.  Add Range question type. 
										sb.AppendLine(".SurveyAnswerRange");
										sb.AppendLine("{");
										sb.AppendLine("}");
										sb.AppendLine(".SurveyAnswerRangeVertical");
										sb.AppendLine("{");
										sb.AppendLine("	-webkit-appearance: slider-vertical;");
										sb.AppendLine("	writing-mode: bt-lr;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerPlainText");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerImage");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerChoiceDate");
										sb.AppendLine("{");
										sb.AppendLine("	width: 120px;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyAnswerOther");
										sb.AppendLine("{");
										sb.AppendLine("	margin: 2px 0px 2px 0px;");
										sb.AppendLine("	display: block;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyColumnOther");
										sb.AppendLine("{");
										sb.AppendLine("	margin: 0px 4px 6px 4px;");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_TEXT_COLOR  ) ) sb.AppendLine("	color: "            + sQUESTION_CHOICE_TEXT_COLOR  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_SIZE   ) ) sb.AppendLine("	font-size: "        + sQUESTION_CHOICE_FONT_SIZE   + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_STYLE  ) ) sb.AppendLine("	font-style: "       + sQUESTION_CHOICE_FONT_STYLE  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_WEIGHT ) ) sb.AppendLine("	font-weight: "      + sQUESTION_CHOICE_FONT_WEIGHT + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_DECORATION  ) ) sb.AppendLine("	text-decoration: "  + sQUESTION_CHOICE_DECORATION  + ";");
										// 06/09/2013 Paul.  Don't want label and textbox on separate lines. 
										//sb.AppendLine("	display: block;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyColumnChoice");
										sb.AppendLine("{");
										sb.AppendLine("	padding: 6px 4px 2px 6px;");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_TEXT_COLOR  ) ) sb.AppendLine("	color: "            + sQUESTION_CHOICE_TEXT_COLOR  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_SIZE   ) ) sb.AppendLine("	font-size: "        + sQUESTION_CHOICE_FONT_SIZE   + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_STYLE  ) ) sb.AppendLine("	font-style: "       + sQUESTION_CHOICE_FONT_STYLE  + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_FONT_WEIGHT ) ) sb.AppendLine("	font-weight: "      + sQUESTION_CHOICE_FONT_WEIGHT + ";");
										if ( !Sql.IsEmptyString(sQUESTION_CHOICE_DECORATION  ) ) sb.AppendLine("	text-decoration: "  + sQUESTION_CHOICE_DECORATION  + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyColumnEvenRow");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyColumnOddRow");
										sb.AppendLine("{");
										sb.AppendLine("	background-color: #eeeeee;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyColumnChoiceRadio");
										sb.AppendLine("{");
										sb.AppendLine("	border: none;");
										sb.AppendLine("	background-color: inherit;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyColumnChoiceCheckbox");
										sb.AppendLine("{");
										sb.AppendLine("	border: none;");
										sb.AppendLine("	background-color: inherit;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyColumnChoiceDropdown");
										sb.AppendLine("{");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyProgressBarFrame");
										sb.AppendLine("{");
										sb.AppendLine("	padding: 2px;");
										if ( Sql.IsEmptyString(sPROGRESS_BAR_BORDER_COLOR    ) ) sPROGRESS_BAR_BORDER_COLOR = "#cccccc";
										if ( Sql.IsEmptyString(sPROGRESS_BAR_BORDER_WIDTH    ) ) sPROGRESS_BAR_BORDER_WIDTH = "1px";
										sb.AppendLine("	border: " + sPROGRESS_BAR_BORDER_WIDTH + " solid " + sPROGRESS_BAR_BORDER_COLOR + ";");
										if ( !Sql.IsEmptyString(sPROGRESS_BAR_PAGE_WIDTH     ) ) sb.AppendLine("	width: "            + sPROGRESS_BAR_PAGE_WIDTH     + ";");
										if ( !Sql.IsEmptyString(sPROGRESS_BAR_BACKGROUND     ) ) sb.AppendLine("	background-color: " + sPROGRESS_BAR_BACKGROUND     + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyProgressBar");
										sb.AppendLine("{");
										if ( !Sql.IsEmptyString(sPROGRESS_BAR_COLOR          ) ) sb.AppendLine("	background-color: " + sPROGRESS_BAR_COLOR          + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyProgressBar td");
										sb.AppendLine("{");
										if ( !Sql.IsEmptyString(sPROGRESS_BAR_TEXT_COLOR     ) ) sb.AppendLine("	color: "            + sPROGRESS_BAR_TEXT_COLOR     + ";");
										if ( !Sql.IsEmptyString(sPROGRESS_BAR_FONT_SIZE      ) ) sb.AppendLine("	font-size: "        + sPROGRESS_BAR_FONT_SIZE      + ";");
										if ( !Sql.IsEmptyString(sPROGRESS_BAR_FONT_STYLE     ) ) sb.AppendLine("	font-style: "       + sPROGRESS_BAR_FONT_STYLE     + ";");
										if ( !Sql.IsEmptyString(sPROGRESS_BAR_FONT_WEIGHT    ) ) sb.AppendLine("	font-weight: "      + sPROGRESS_BAR_FONT_WEIGHT    + ";");
										if ( !Sql.IsEmptyString(sPROGRESS_BAR_DECORATION     ) ) sb.AppendLine("	text-decoration: "  + sPROGRESS_BAR_DECORATION     + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyExitLink");
										sb.AppendLine("{");
										sb.AppendLine("	border-radius: 3px;");
										sb.AppendLine("	margin: 6px;");
										sb.AppendLine("	padding: 6px;");
										sb.AppendLine("	white-space: nowrap;");
										sb.AppendLine("	cursor: hand;");
										if ( !Sql.IsEmptyString(sEXIT_LINK_TEXT_COLOR        ) ) sb.AppendLine("	color: "            + sEXIT_LINK_TEXT_COLOR        + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_FONT_SIZE         ) ) sb.AppendLine("	font-size: "        + sEXIT_LINK_FONT_SIZE         + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_FONT_STYLE        ) ) sb.AppendLine("	font-style: "       + sEXIT_LINK_FONT_STYLE        + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_FONT_WEIGHT       ) ) sb.AppendLine("	font-weight: "      + sEXIT_LINK_FONT_WEIGHT       + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_DECORATION        ) ) sb.AppendLine("	text-decoration: "  + sEXIT_LINK_DECORATION        + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_BACKGROUND        ) ) sb.AppendLine("	background-color: " + sEXIT_LINK_BACKGROUND        + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyPageNavigation");
										sb.AppendLine("{");
										sb.AppendLine("	text-align: center;");
										sb.AppendLine("	padding: 20px 20px 5px 20px;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyNavigationButton");
										sb.AppendLine("{");
										sb.AppendLine("	border-radius: 3px;");
										sb.AppendLine("	margin: 6px;");
										sb.AppendLine("	padding: 6px;");
										sb.AppendLine("	white-space: nowrap;");
										sb.AppendLine("	border: solid 1px #bbbbbb;");
										sb.AppendLine("	cursor: hand;");
										if ( !Sql.IsEmptyString(sEXIT_LINK_TEXT_COLOR        ) ) sb.AppendLine("	color: "            + sEXIT_LINK_TEXT_COLOR        + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_FONT_SIZE         ) ) sb.AppendLine("	font-size: "        + sEXIT_LINK_FONT_SIZE         + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_FONT_STYLE        ) ) sb.AppendLine("	font-style: "       + sEXIT_LINK_FONT_STYLE        + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_FONT_WEIGHT       ) ) sb.AppendLine("	font-weight: "      + sEXIT_LINK_FONT_WEIGHT       + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_DECORATION        ) ) sb.AppendLine("	text-decoration: "  + sEXIT_LINK_DECORATION        + ";");
										if ( !Sql.IsEmptyString(sEXIT_LINK_BACKGROUND        ) ) sb.AppendLine("	background-color: " + sEXIT_LINK_BACKGROUND        + ";");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyComplete");
										sb.AppendLine("{");
										sb.AppendLine("	font-size: 24px;");
										sb.AppendLine("	font-weight: normal;");
										sb.AppendLine("	padding: 140px 40px 40px 40px;");
										sb.AppendLine("}");
										
										sb.AppendLine(".SurveyQuestionSummaryFrame");
										sb.AppendLine("{");
										sb.AppendLine("	margin: 1px;");
										sb.AppendLine("	border-radius: 3px;");
										sb.AppendLine("	border: solid 2px #bbbbbb;");
										sb.AppendLine("}");
										
										// 04/09/2019 Paul.  Add Survey Theme Page Background. 
										string sPAGE_BACKGROUND_IMAGE    = Sql.ToString(row["PAGE_BACKGROUND_IMAGE"   ]);
										string sPAGE_BACKGROUND_POSITION = Sql.ToString(row["PAGE_BACKGROUND_POSITION"]);
										string sPAGE_BACKGROUND_REPEAT   = Sql.ToString(row["PAGE_BACKGROUND_REPEAT"  ]);
										string sPAGE_BACKGROUND_SIZE     = Sql.ToString(row["PAGE_BACKGROUND_SIZE"    ]);
										if ( !Sql.IsEmptyString(sPAGE_BACKGROUND_IMAGE) )
										{
											sb.AppendLine("#divSurveyPages");
											sb.AppendLine("{");
											sb.AppendLine("	background-image: url(" + sPAGE_BACKGROUND_IMAGE + ");");
											if ( !Sql.IsEmptyString(sPAGE_BACKGROUND_REPEAT  ) ) sb.AppendLine("	background-repeat: "   + sPAGE_BACKGROUND_REPEAT   + ";");
											if ( !Sql.IsEmptyString(sPAGE_BACKGROUND_POSITION) ) sb.AppendLine("	background-position: " + sPAGE_BACKGROUND_POSITION + ";");
											if ( !Sql.IsEmptyString(sPAGE_BACKGROUND_SIZE    ) ) sb.AppendLine("	background-size: "     + sPAGE_BACKGROUND_SIZE     + ";");
											sb.AppendLine("}");
										}
										// 11/12/2018 Paul.  Add custom styles field to allow any style change. 
										string sCUSTOM_STYLES = Sql.ToString(row["CUSTOM_STYLES"]);
										if ( !Sql.IsEmptyString(sCUSTOM_STYLES) )
										{
											sb.AppendLine("/* Begin custom styles */");
											sb.AppendLine(sCUSTOM_STYLES);
											sb.AppendLine("/* End custom styles */");
										}
										sMessage = sb.ToString();
										Response.ContentType = "text/css";
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
				string sError = Utils.ExpandException(ex);
				Response.ContentType = "text/plain";
				sMessage = sError;
			}
			byte[] data = System.Text.Encoding.UTF8.GetBytes(sMessage);
			return File(data, Response.ContentType);
		}
	}
}
