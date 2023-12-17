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
using System.Globalization;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace SplendidCRM.Pages
{
	// 06/29/2023 Paul.  SystemCheck is not authorized. 
	[ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
	public class SystemCheckModel : PageModel
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpContext          Context            ;
		public  HttpApplicationState Application        = new HttpApplicationState();
		public  HttpSessionState     Session            ;
		public  Security             Security           ;

		public  CultureInfo          culture            { get; set; }
		public  string               MachineName        { get; set; }
		public  string               SqlVersion         { get; set; }
		public  string               LastError          { get; set; }
		public  string               AUTH_USER          { get; set; }

		public SystemCheckModel(IHttpContextAccessor httpContextAccessor, HttpSessionState Session, Security Security)
		{
			this.Context             = httpContextAccessor.HttpContext;
			this.Session             = Session            ;
			this.Security            = Security           ;
		}

		public void OnGet()
		{
			string m_sCULTURE     = SplendidCRM.Sql.ToString (Session["USER_SETTINGS/CULTURE"]);
			SplendidCRM.L10N L10n = new SplendidCRM.L10N(m_sCULTURE);
			culture = CultureInfo.CreateSpecificCulture(L10n.NAME);

			AUTH_USER = String.Empty;  //Sql.ToString(Context.Request.ServerVariables["AUTH_USER"]);
			if ( Context.User != null && Context.User.Identity != null )
			{
				AUTH_USER = Context.User.Identity.Name;
			}

			MachineName = System.Environment.MachineName;
			try
			{
				// 11/20/2005 Paul.  ASP.NET 2.0 has a namespace conflict, so we need the full name for the SplendidCRM factory. 
				SplendidCRM.DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					// 09/27/2009 Paul.  Show SQL version. 
					if ( Sql.IsSQLServer(con) )
					{
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = "select @@VERSION";
							SqlVersion = Sql.ToString(cmd.ExecuteScalar());
						}
					}
				}
			}
			catch(Exception ex)
			{
				LastError = ex.Message;
			}
		}
	}
}
