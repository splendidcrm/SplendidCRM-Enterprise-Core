if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwWORKFLOWS_RunTimed')
	Drop View dbo.vwWORKFLOWS_RunTimed;
GO


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
 *********************************************************************************************************************/
-- 11/16/2008 Paul.  When comparing against the CRON pattern, round the time down to the nearest 30 second interval. 
-- 11/16/2008 Paul.  The CRON code can only go down to the minute level, so just round to a minute for that. 
-- 06/26/2010 Paul.  Even though this view is called every 30 seconds, we only want to run the workflow once a minute. 
-- We were getting two workflow events when a single was expected. 
Create View dbo.vwWORKFLOWS_RunTimed
as
select vwWORKFLOWS.*
     , dbo.fnTimeRoundSeconds(getdate(), 60) as NEXT_RUN
  from vwWORKFLOWS
 where STATUS = 1
   and TYPE   = N'time'
   and dbo.fnCronRun(JOB_INTERVAL, dbo.fnTimeRoundMinutes(getdate(), 1), 1) = 1
   and (LAST_RUN is null or dbo.fnTimeRoundSeconds(getdate(), 60) > dbo.fnTimeRoundSeconds(LAST_RUN, 60))
GO

Grant Select on dbo.vwWORKFLOWS_RunTimed to public;
GO

