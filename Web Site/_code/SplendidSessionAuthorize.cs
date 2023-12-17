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
using System.Linq;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM
{
	// 07/09/2023 Paul.  Instead of using Security.IsAuthenticated(), use attribute. 
	public class SplendidSessionAuthorizeAttribute: Attribute, IAuthorizationFilter
	{
		private HttpApplicationState Application = new HttpApplicationState();

		public SplendidSessionAuthorizeAttribute()
		{
		}

		public void OnAuthorization(AuthorizationFilterContext context)
		{
			var allowAnonymous = context.ActionDescriptor.EndpointMetadata.OfType<AllowAnonymousAttribute>().Any();
			if ( allowAnonymous )
				return;
			
			if ( context != null )
			{
				bool bIsAuthenticated = false;
				if ( context.HttpContext != null )
				{
					if ( context.HttpContext.Session != null )
					{
						string sUSER_ID = context.HttpContext.Session.GetString("USER_ID");
						if ( !Sql.IsEmptyString(sUSER_ID) )
						{
							bIsAuthenticated = true;
						}
					}
				}
				if ( !bIsAuthenticated )
				{
					L10N L10n = new L10N(Sql.ToString(Application["CONFIG.default_language"]));
					context.Result = new UnauthorizedObjectResult("SplendidSessionAuthorize: " + L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS"));
				}
			}
		}
	}
}
