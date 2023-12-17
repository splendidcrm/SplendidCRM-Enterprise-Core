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
using System.Activities;
using System.Diagnostics;

namespace SplendidCRM
{
	public class WF4EndEventGatewayActivity : CodeActivity
	{
		public InArgument<string> EVENT_NAMES { get; set; }
		
		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			Sql                  Sql            = app.Sql          ;
			SqlProcs             SqlProcs       = app.SqlProcs     ;
			SplendidError        SplendidError  = app.SplendidError;

			try
			{
				string sEVENT_NAMES = context.GetValue<string>(EVENT_NAMES);
				if ( !Sql.IsEmptyString(sEVENT_NAMES) )
				{
					string[] arrEVENT_NAMES = Sql.ToString(sEVENT_NAMES).Split(',');
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						try
						{
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									foreach ( string sBOOKMARK_NAME in arrEVENT_NAMES )
									{
										SqlProcs.spPROCESSES_EndEventGateway(context.WorkflowInstanceId, sBOOKMARK_NAME, trn);
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
						}
						catch(Exception ex)
						{
							SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
							throw(new Exception("WF4EndEventGatewayActivity failed: " + ex.Message, ex));
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WF4EndEventGatewayActivity.Execute failed: " + ex.Message, ex));
			}
		}
	}
}
