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
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Caching.Memory;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for Currency.
	/// </summary>
	public class CampaignUtils
	{
		public class SendMail
		{
			private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
			private HttpApplicationState Application         = new HttpApplicationState();
			private HttpSessionState     Session            ;
			private Security             Security           ;
			private Sql                  Sql                ;
			private SqlProcs             SqlProcs           ;
			private SplendidError        SplendidError      ;
			private EmailUtils           EmailUtils         ;

			private Guid                 gID                ;
			private bool                 bTest              ;
			
			public SendMail(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, EmailUtils EmailUtils, Guid gID, bool bTest)
			{
				this.Session             = Session            ;
				this.Security            = Security           ;
				this.Sql                 = Sql                ;
				this.SqlProcs            = SqlProcs           ;
				this.SplendidError       = SplendidError      ;
				this.EmailUtils          = EmailUtils         ;
				this.gID                 = gID                ;
				this.bTest               = bTest              ;
			}
			
#pragma warning disable CS1998
			public async ValueTask QueueStart(CancellationToken token)
			{
				Start();
			}
#pragma warning restore CS1998

			// 06/16/2011 Paul.  Placing the emails in queue can take a long time, so place into a thread. 
			public void Start()
			{
				try
				{
					SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Campaign Start: " + gID.ToString() + " at " + DateTime.Now.ToString() );
					if ( !Sql.IsEmptyGuid(gID) )
					{
						Application["Campaigns." + gID.ToString() + ".Sending"] = true;
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 08/22/2011 Paul.  We need to use the command object so that we can increase the timeout. 
									//SqlProcs.spCAMPAIGNS_SendEmail(gID, false, trn);
									using ( IDbCommand cmdCAMPAIGNS_SendEmail = SqlProcs.cmdCAMPAIGNS_SendEmail(con) )
									{
										cmdCAMPAIGNS_SendEmail.Transaction    = trn;
										cmdCAMPAIGNS_SendEmail.CommandTimeout = 0;
										Sql.SetParameter(cmdCAMPAIGNS_SendEmail, "@ID"              , gID             );
										Sql.SetParameter(cmdCAMPAIGNS_SendEmail, "@MODIFIED_USER_ID", Security.USER_ID);
										Sql.SetParameter(cmdCAMPAIGNS_SendEmail, "@TEST"            , bTest           );
										cmdCAMPAIGNS_SendEmail.ExecuteNonQuery();
									}
									trn.Commit();
								}
								catch
								{
									trn.Rollback();
									throw;
								}
							}
						}
						// 12/22/2007 Paul.  Send all queued emails, but include the date so that only these will get sent. 
						// 07/30/2012 Paul.  HttpContext.Current is not valid in a thread.  Must use Context property. 
						if ( bTest )
							EmailUtils.SendQueued(Guid.Empty, gID, false);
					}
					else
					{
						SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Invalid Campaign ID.");
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				}
				finally
				{
					SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Campaign End: " + gID.ToString() + " at " + DateTime.Now.ToString() );
					Application.Remove("Campaigns." + gID.ToString() + ".Sending");
				}
			}
		}

		public class GenerateCalls
		{
			private DbProviderFactories  DbProviderFactories = new DbProviderFactories();
			private HttpApplicationState Application         = new HttpApplicationState();
			private HttpSessionState     Session            ;
			private Security             Security           ;
			private Sql                  Sql                ;
			private SqlProcs             SqlProcs           ;
			private SplendidError        SplendidError      ;
			private EmailUtils           EmailUtils         ;

			private Guid                 gID                ;
			private bool                 bTest              ;
			
			public GenerateCalls(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, EmailUtils EmailUtils, Guid gID, bool bTest)
			{
				this.Session             = Session            ;
				this.Security            = Security           ;
				this.Sql                 = Sql                ;
				this.SqlProcs            = SqlProcs           ;
				this.SplendidError       = SplendidError      ;
				this.EmailUtils          = EmailUtils         ;
				this.gID                 = gID                ;
				this.bTest               = bTest              ;
			}
			
#pragma warning disable CS1998
			public async ValueTask QueueStart(CancellationToken token)
			{
				Start();
			}
#pragma warning restore CS1998

			public void Start()
			{
				try
				{
					SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Campaign Start: " + gID.ToString() + " at " + DateTime.Now.ToString() );
					if ( !Sql.IsEmptyGuid(gID) )
					{
						Application["Campaigns." + gID.ToString() + ".Sending"] = true;
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							using ( IDbTransaction trn = Sql.BeginTransaction(con) )
							{
								try
								{
									// 08/22/2011 Paul.  We need to use the command object so that we can increase the timeout. 
									//SqlProcs.spCAMPAIGNS_GenerateCalls(gID, trn);
									using ( IDbCommand cmdCAMPAIGNS_GenerateCalls = SqlProcs.cmdCAMPAIGNS_GenerateCalls(con) )
									{
										cmdCAMPAIGNS_GenerateCalls.Transaction    = trn;
										cmdCAMPAIGNS_GenerateCalls.CommandTimeout = 0;
										Sql.SetParameter(cmdCAMPAIGNS_GenerateCalls, "@ID"              , gID             );
										Sql.SetParameter(cmdCAMPAIGNS_GenerateCalls, "@MODIFIED_USER_ID", Security.USER_ID);
										cmdCAMPAIGNS_GenerateCalls.ExecuteNonQuery();
									}
									trn.Commit();
								}
								catch
								{
									trn.Rollback();
									throw;
								}
							}
						}
						// 12/22/2007 Paul.  Send all queued emails, but include the date so that only these will get sent. 
						// 07/30/2012 Paul.  HttpContext.Current is not valid in a thread.  Must use Context property. 
						if ( bTest )
							EmailUtils.SendQueued(Guid.Empty, gID, false);
					}
					else
					{
						SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), "Invalid Campaign ID.");
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				}
				finally
				{
					SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "Campaign End: " + gID.ToString() + " at " + DateTime.Now.ToString() );
					Application.Remove("Campaigns." + gID.ToString() + ".Sending");
				}
			}
		}
	}
}

