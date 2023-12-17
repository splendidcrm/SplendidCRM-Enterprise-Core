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
using System.Data.Common;
using System.ComponentModel;
using System.Activities;
using System.Diagnostics;

using Spring.Social.Office365;

namespace SplendidCRM
{
	public class OpportunitySyncActivityWF4: CodeActivity
	{
		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			SplendidError       SplendidError    = app.SplendidError   ;
			SyncError           SyncError        = app.SyncError       ;
			ExchangeSync        ExchangeSync     = app.ExchangeSync    ;
			try
			{
				Guid   gWORKFLOW_ID          = Guid.Empty;
				Guid   gAUDIT_ID             = Guid.Empty;

				WorkflowDataContext dc = context.DataContext;
				PropertyDescriptorCollection properties = dc.GetProperties();
				foreach ( PropertyDescriptor property in dc.GetProperties() )
				{
					if ( property.Name == "WORKFLOW_ID" )
					{
						gWORKFLOW_ID = Sql.ToGuid(property.GetValue(dc));
					}
					else if ( property.Name == "AUDIT_ID" )
					{
						gAUDIT_ID = Sql.ToGuid(property.GetValue(dc));
					}
				}
				Debug.WriteLine("OpportunitySyncActivityWF4.Execute " + gAUDIT_ID.ToString());

				using ( DataTable dt = new DataTable() )
				{
					DbProviderFactory dbf = DbProviderFactories.GetFactory(app.SplendidProvider, app.ConnectionString);
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL ;
						sSQL = "select *                            " + ControlChars.CrLf
						     + "  from vwOPPORTUNITIES_SYNC_ACTIVITY" + ControlChars.CrLf
						     + " where ID in (select ID from vwOPPORTUNITIES_AUDIT where AUDIT_ID = @AUDIT_ID)" + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@AUDIT_ID", gAUDIT_ID);
							
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dt);
							}
						}
					}
					string sExchangeServerURL = Sql.ToString (app.Application["CONFIG.Exchange.ServerURL"]);
					foreach ( DataRow row in dt.Rows )
					{
						Guid gID      = Sql.ToGuid(row["ID"     ]);
						Guid gUSER_ID = Sql.ToGuid(row["USER_ID"]);
						if ( !Sql.IsEmptyString(sExchangeServerURL) )
						{
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "OpportunitySyncActivity: ExchangeSync, Opportunity Changed " + gID.ToString() + " for User " + gUSER_ID.ToString());
							ExchangeSync.SyncUser(gUSER_ID);
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("OpportunitySyncActivityWF4.Execute failed: " + ex.Message, ex));
			}
		}
	}
}
