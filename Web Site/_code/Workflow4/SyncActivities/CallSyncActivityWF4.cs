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
	public class CallSyncActivityWF4: CodeActivity
	{
		protected override void Execute(CodeActivityContext context)
		{
			SplendidApplicationService app = context.GetExtension<SplendidApplicationService>();
			SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			SplendidError       SplendidError    = app.SplendidError   ;
			SyncError           SyncError        = app.SyncError       ;
			ExchangeSync        ExchangeSync     = app.ExchangeSync    ;
			GoogleSync          GoogleSync       = app.GoogleSync      ;
			iCloudSync          iCloudSync       = app.iCloudSync      ;
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
				Debug.WriteLine("CallSyncActivityWF4.Execute " + gAUDIT_ID.ToString());

				using ( DataTable dt = new DataTable() )
				{
					DbProviderFactory dbf = DbProviderFactories.GetFactory(app.SplendidProvider, app.ConnectionString);
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL ;
						sSQL = "select *                       " + ControlChars.CrLf
						     + "  from vwCALLS_SYNC_ACTIVITY   " + ControlChars.CrLf
						     + " where ID in (select ID from vwCALLS_AUDIT where AUDIT_ID = @AUDIT_ID)" + ControlChars.CrLf;
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
					bool   bGoogleAppsEnabled = Sql.ToBoolean(app.Application["CONFIG.GoogleApps.Enabled"]);
					bool   bICLOUDEnabled     = Sql.ToBoolean(app.Application["CONFIG.iCloud.Enabled"    ]);
					string sExchangeServerURL = Sql.ToString (app.Application["CONFIG.Exchange.ServerURL"]);
					foreach ( DataRow row in dt.Rows )
					{
						Guid   gID                       = Sql.ToGuid   (row["ID"                      ]);
						Guid   gUSER_ID                  = Sql.ToGuid   (row["USER_ID"                 ]);
						bool   bGOOGLEAPPS_SYNC_CALENDAR = Sql.ToBoolean(row["GOOGLEAPPS_SYNC_CALENDAR"]);
						string sGOOGLEAPPS_USERNAME      = Sql.ToString (row["GOOGLEAPPS_USERNAME"     ]);
						bool   bICLOUD_SYNC_CALENDAR     = Sql.ToBoolean(row["ICLOUD_SYNC_CALENDAR"    ]);
						string sICLOUD_USERNAME          = Sql.ToString (row["ICLOUD_USERNAME"         ]);
						// 09/16/2015 Paul.  Google APIs use OAUTH and not username/password. 
						bool   bGOOGLEAPPS_USER_ENABLED  = Sql.ToBoolean(row["GOOGLEAPPS_USER_ENABLED" ]);
						if ( bGoogleAppsEnabled && bGOOGLEAPPS_SYNC_CALENDAR && bGOOGLEAPPS_USER_ENABLED )
						{
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "CallSyncActivity: GoogleSync, Call Changed " + gID.ToString() + " for User " + gUSER_ID.ToString());
							GoogleSync.SyncUser(gUSER_ID);
						}
						if ( bICLOUDEnabled && bICLOUD_SYNC_CALENDAR && !Sql.IsEmptyString(sICLOUD_USERNAME) )
						{
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "CallSyncActivity: iCloudSync, Call Changed " + gID.ToString() + " for User " + gUSER_ID.ToString());
							iCloudSync.SyncUser(gUSER_ID);
						}
						if ( !Sql.IsEmptyString(sExchangeServerURL) )
						{
							SyncError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "CallSyncActivity: ExchangeSync, Call Changed " + gID.ToString() + " for User " + gUSER_ID.ToString());
							ExchangeSync.SyncUser(gUSER_ID);
						}
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				throw(new Exception("CallSyncActivityWF4.Execute failed: " + ex.Message, ex));
			}
		}
	}
}
