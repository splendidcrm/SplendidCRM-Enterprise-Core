/*
 * Copyright (C) 2019-2023 SplendidCRM Software, Inc. All Rights Reserved. 
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
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

using SplendidCRM.MachineLearning;

namespace SplendidCRM.Controllers.Administration.MachineLearningModels
{
	[Authorize]
	[SplendidSessionAuthorize]
	[ApiController]
	[Route("Administration/MachineLearningModels/Rest.svc")]
	public class RestController : ControllerBase
	{
		public const string MODULE_NAME = "MachineLearningModels";
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private L10N                 L10n               ;
		private SplendidError        SplendidError      ;
		private MachineLearningUtils MachineLearningUtils;
		private IBackgroundTaskQueue taskQueue          ;

		public RestController(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, MachineLearningUtils MachineLearningUtils, IBackgroundTaskQueue taskQueue)
		{
			this.Session              = Session             ;
			this.Security             = Security            ;
			this.L10n                 = new L10N(Sql.ToString(Session["USER_SETTINGS/CULTURE"]));
			this.Sql                  = Sql                 ;
			this.SqlProcs             = SqlProcs            ;
			this.SplendidError        = SplendidError       ;
			this.MachineLearningUtils = MachineLearningUtils;
			this.taskQueue            = taskQueue           ;
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public async Task Train([FromBody] Dictionary<string, object> dict)
		{
			try
			{
				if ( !Security.IsAuthenticated() || Security.GetUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				Guid gID = Guid.Empty;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "ID":  gID = Sql.ToGuid(dict[sColumnName]);  break;
					}
				}
				MachineLearningUtils.MachineLearningThread ml = new MachineLearningUtils.MachineLearningThread(Session, Security, Sql, SqlProcs, SplendidError, gID);
				await taskQueue.QueueBackgroundWorkItemAsync(ml.Train);
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public async Task Evaluate([FromBody] Dictionary<string, object> dict)
		{
			try
			{
				if ( !Security.IsAuthenticated() || Security.GetUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				Guid gID = Guid.Empty;
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "ID":  gID = Sql.ToGuid(dict[sColumnName]);  break;
					}
				}
				MachineLearningUtils.MachineLearningThread ml = new MachineLearningUtils.MachineLearningThread(Session, Security, Sql, SqlProcs, SplendidError, gID);
				await taskQueue.QueueBackgroundWorkItemAsync(ml.Evaluate);
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
		}

		[DotNetLegacyData]
		[HttpPost("[action]")]
		public void Predict([FromBody] Dictionary<string, object> dict)
		{
			try
			{
				if ( !Security.IsAuthenticated() || Security.GetUserAccess(MODULE_NAME, "edit") < 0 )
				{
					throw(new Exception(L10n.Term("ACL.LBL_INSUFFICIENT_ACCESS")));
				}
				
				Guid gID = Guid.Empty;
				List<string> arrRECORD_LIST = new List<string>();
				foreach ( string sColumnName in dict.Keys )
				{
					switch ( sColumnName )
					{
						case "ID":  gID = Sql.ToGuid(dict[sColumnName]);  break;
						case "RECORD_LIST":
						{
							if ( dict[sColumnName] is System.Collections.ArrayList )
							{
								System.Collections.ArrayList lst = dict[sColumnName] as System.Collections.ArrayList;
								if ( lst.Count > 0 )
								{
									foreach ( string item in lst )
									{
										arrRECORD_LIST.Add(item);
									}
								}
							}
							break;
						}
					}
				}
				MachineLearningUtils.Predict(gID, arrRECORD_LIST.ToArray());
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				throw;
			}
		}

	}
}
