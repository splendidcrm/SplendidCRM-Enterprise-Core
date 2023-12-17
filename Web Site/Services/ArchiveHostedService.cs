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
using System.Diagnostics;

using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;

namespace SplendidCRM
{
	// https://learn.microsoft.com/en-us/aspnet/core/fundamentals/host/hosted-services?view=aspnetcore-5.0&tabs=visual-studio#consuming-a-scoped-service-in-a-background-task
	public class ArchiveHostedService : IHostedService, IDisposable
	{
		private readonly   IServiceProvider                  _serviceProvider;
		private readonly   ILogger<ArchiveHostedService> _logger         ;
		private            Timer                             _timer          ;

		public ArchiveHostedService(IServiceProvider serviceProvider, ILogger<ArchiveHostedService> logger)
		{
			_serviceProvider = serviceProvider;
			_logger          =  logger        ;
		}

		public Task StartAsync(CancellationToken stoppingToken)
		{
			using ( IServiceScope scope = _serviceProvider.CreateScope() )
			{
				SplendidError SplendidError = scope.ServiceProvider.GetRequiredService<SplendidError>();
				SplendidError.SystemWarning(new StackTrace(true).GetFrame(0), "The Archive Manager timer has been activated.");
			}
			_timer = new Timer(DoWork, null, new TimeSpan(0, 1, 0), TimeSpan.FromMinutes(5));
			return Task.CompletedTask;
		}

		public Task StopAsync(CancellationToken stoppingToken)
		{
			using ( IServiceScope scope = _serviceProvider.CreateScope() )
			{
				SplendidError SplendidError = scope.ServiceProvider.GetRequiredService<SplendidError>();
				SplendidError.SystemWarning(new StackTrace(true).GetFrame(0), "The Archive Manager timer is stopping.");
			}
			_timer?.Change(Timeout.Infinite, 0);
			return Task.CompletedTask;
		}

		public void Dispose()
		{
			_timer?.Dispose();
		}

		private void DoWork(object state)
		{
			using ( IServiceScope scope = _serviceProvider.CreateScope() )
			{
				SplendidError SplendidError = scope.ServiceProvider.GetRequiredService<SplendidError>();
				try
				{
					_logger.LogDebug($"ArchiveHostedService.DoWork " + DateTime.Now.ToString());
					Debug.WriteLine ($"ArchiveHostedService.DoWork " + DateTime.Now.ToString());
					SchedulerUtils schedulerUtils = scope.ServiceProvider.GetRequiredService<SchedulerUtils>();
					schedulerUtils.OnArchiveTimer();
				}
				catch (Exception ex)
				{
					_logger.LogError($"Failure while processing ArchiveHostedService: {ex.Message}");
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				}
			}
		}

	}
}
