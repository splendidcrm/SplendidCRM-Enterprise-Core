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
using System.Activities;
using System.ComponentModel;
using System.Diagnostics;

namespace SplendidCRM
{
	public class WF4CustomActivity : CodeActivity
	{
		public InArgument <Guid  > ID           { get; set; }
		public OutArgument<String> CUSTOM_VALUE { get; set; }

		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidError        SplendidError  = app.SplendidError;

			try
			{
				Guid   gBUSINESS_PROCESS_ID = Guid.Empty;
				Guid   gAUDIT_ID            = Guid.Empty;
				Guid   gPROCESS_USER_ID     = Guid.Empty;
				Guid   gID                  = context.GetValue<Guid>(ID);
			
				WorkflowDataContext dc = context.DataContext;
				PropertyDescriptorCollection properties = dc.GetProperties();
				foreach ( PropertyDescriptor property in dc.GetProperties() )
				{
					if ( property.Name == "BUSINESS_PROCESS_ID" )
					{
						gBUSINESS_PROCESS_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "AUDIT_ID" )
					{
						gAUDIT_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "PROCESS_USER_ID" )
					{
						gPROCESS_USER_ID = Sql.ToGuid(property.GetValue(dc));
					}
				}
			
				Debug.WriteLine("WF4CustomActivity");
				context.SetValue<string>(CUSTOM_VALUE, "Approve");
				//DbProviderFactory dbf = DbProviderFactories.GetFactory();
				//using ( IDbConnection con = dbf.CreateConnection() )
				//{
				//	con.Open();
				//	using ( IDbTransaction trn = Sql.BeginTransaction(con) )
				//	{
				//		try
				//		{
				//			// 08/15/2016 Paul.  We do not know what tables will be updated, so we must pass the instance to the procedure and let it insert the log record. 
				//			SqlProcs.spWORKFLOW_TRANS_LOG_InsertOnly(sTABLE_NAME, gBUSINESS_PROCESS_ID, context.WorkflowInstanceId, trn);
				//			trn.Commit();
				//		}
				//		catch(Exception ex)
				//		{
				//			trn.Rollback();
				//			SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				//			throw;
				//		}
				//	}
				//}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("WF4CustomActivity.Execute failed: " + ex.Message, ex));
			}
		}
	}
}
