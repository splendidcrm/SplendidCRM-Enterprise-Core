/*
 * Copyright (C) 2025 SplendidCRM Software, Inc. All Rights Reserved. 
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
using System.Text;
using System.Collections.Generic;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;

namespace SplendidCRM.Controllers.Administration
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/Impersonation.svc")]
	public class ImpersonationController : ControllerBase
	{
		private IWebHostEnvironment  hostingEnvironment ;
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private SplendidInit         SplendidInit       ;

		public ImpersonationController(IWebHostEnvironment hostingEnvironment, HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidInit SplendidInit)
		{
			this.hostingEnvironment  = hostingEnvironment ;
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.L10n                = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.SplendidInit        = SplendidInit       ;
		}

		public class ImpersonateModel
		{
			public Guid ID { get; set; }
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public string Impersonate([FromBody] ImpersonateModel model)
		{
			StringBuilder sbErrors = new StringBuilder();
			try
			{
				L10N L10n = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
				if ( !Security.IsAuthenticated() || !Security.IS_ADMIN )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				if ( !System.IO.File.Exists("~/Administration/Impersonation.svc".Replace("~", hostingEnvironment.ContentRootPath)) )
				{
					throw(new Exception(L10n.Term("Users.ERR_IMPERSONATION_DISABLED")));
				}

				SplendidInit.LoginUser(model.ID, "Impersonate");
				Session["USER_IMPERSONATION"] = true;

			}
			catch (Exception ex)
			{
				// 03/20/2019 Paul.  Catch and log all failures, including insufficient access. 
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				sbErrors.Append(ex.Message);
			}
			return sbErrors.ToString();
		}
	}
}
