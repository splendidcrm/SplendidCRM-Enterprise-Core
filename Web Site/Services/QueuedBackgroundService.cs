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
using System.Threading;
using System.Threading.Tasks;

using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;
using System.Diagnostics;

namespace SplendidCRM
{
	// https://learn.microsoft.com/en-us/aspnet/core/fundamentals/host/hosted-services?view=aspnetcore-7.0&tabs=visual-studio
	public class QueuedBackgroundService : BackgroundService
	{
		private HttpApplicationState Application             = new HttpApplicationState();
		private readonly   IServiceProvider                  _serviceProvider;
		private readonly   ILogger<QueuedBackgroundService>  _logger         ;
		public             IBackgroundTaskQueue              TaskQueue { get; }

		public QueuedBackgroundService(IServiceProvider serviceProvider, ILogger<QueuedBackgroundService> logger, IBackgroundTaskQueue taskQueue)
		{
			_serviceProvider = serviceProvider;
			_logger          =  logger        ;
			TaskQueue        = taskQueue      ;
		}

		public override async Task StartAsync(CancellationToken stoppingToken)
		{
			using ( IServiceScope scope = _serviceProvider.CreateScope() )
			{
				SplendidError SplendidError = scope.ServiceProvider.GetRequiredService<SplendidError>();
				SplendidError.SystemWarning(new StackTrace(true).GetFrame(0), "The Queued Hosted Service has been activated.");
			}
			await base.StartAsync(stoppingToken);
		}

		public override async Task StopAsync(CancellationToken stoppingToken)
		{
			using ( IServiceScope scope = _serviceProvider.CreateScope() )
			{
				SplendidError SplendidError = scope.ServiceProvider.GetRequiredService<SplendidError>();
				SplendidError.SystemWarning(new StackTrace(true).GetFrame(0), "The Queued Hosted Service is stopping.");
			}
			await base.StopAsync(stoppingToken);
		}

		protected override async Task ExecuteAsync(CancellationToken stoppingToken)
		{
			while ( !stoppingToken.IsCancellationRequested )
			{
				// 12/20/203 Paul.  Service can start before database initialized. 
				if ( Sql.ToBoolean(Application["SplendidInit.InitApp"]) )
				{
					using ( IServiceScope scope = _serviceProvider.CreateScope() )
					{
						SplendidError SplendidError = scope.ServiceProvider.GetRequiredService<SplendidError>();
						var workItem = await TaskQueue.DequeueAsync(stoppingToken);
						try
						{
							string sName = nameof(workItem);
							Debug.WriteLine($"Queued Hosted Service Processing {sName}.");
							SplendidError.SystemWarning(new StackTrace(true).GetFrame(0), $"Queued Hosted Service Processing {sName}.");
#pragma warning disable CS4014
							// 05/16/2023 Paul.  We don't want to block other work items, so don't await. 
							workItem(stoppingToken);
#pragma warning restore CS4014
						}
						catch (Exception ex)
						{
							_logger.LogError(ex, "Error occurred executing {WorkItem}.", nameof(workItem));
							SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
						}
					}
				}
				// 05/23/2023 Paul.  Without delay, loop consumes 100% of resources. 
				await Task.Delay(TimeSpan.FromSeconds(1), stoppingToken);
			}
		}

	}
}
