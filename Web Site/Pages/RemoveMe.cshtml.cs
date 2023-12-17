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
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Pages
{
	// 01/25/2008 Paul.  This page must be accessible without authentication. 
	[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
	public class RemoveMeModel : PageModel
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private L10N                 L10n               ;

		public  string               litREMOVE_ME_HEADER { get; set; }
		public  string               lblError            { get; set; }
		public  string               lblWarning          { get; set; }
		public  string               litREMOVE_ME_FOOTER { get; set; }

		public RemoveMeModel(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
		}

		public void OnGetAsync()
		{
			SplendidError.SystemMessage("Log", new StackTrace(true).GetFrame(0), "Remove Me " + Request.Query["identifier"]);
			try
			{
				Guid gID = Sql.ToGuid(Request.Query["identifier"]);
				if ( !Sql.IsEmptyGuid(gID) )
				{
					Guid   gTARGET_ID   = Guid.Empty;
					string sTARGET_TYPE = string.Empty;
					SqlProcs.spCAMPAIGN_LOG_UpdateTracker(gID, "removed", Guid.Empty, ref gTARGET_ID, ref sTARGET_TYPE);
					if ( sTARGET_TYPE == "Users" )
					{
						lblError = L10n.Term("Campaigns.LBL_USERS_CANNOT_OPTOUT");
					}
					else
					{
						litREMOVE_ME_HEADER = L10n.Term("Campaigns.LBL_REMOVE_ME_HEADER_STEP1");
						litREMOVE_ME_FOOTER = L10n.Term("Campaigns.LBL_REMOVE_ME_FOOTER_STEP1");
						SqlProcs.spCAMPAIGNS_OptOut(gTARGET_ID, sTARGET_TYPE);
						//lblError.Text = L10n.Term("Campaigns.LBL_ELECTED_TO_OPTOUT");
					}
				}
				// 11/23/2012 Paul.  Skip during precompile. 
				else if ( !Sql.ToBoolean(Request.Query["PrecompileOnly"]) )
				{
					// 11/23/2012 Paul.  Don't use the standard error label as it will cause the precompile to stop. 
					lblWarning = L10n.Term("Campaigns.LBL_REMOVE_ME_INVALID_IDENTIFIER");
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
			}
		}
	}
}
