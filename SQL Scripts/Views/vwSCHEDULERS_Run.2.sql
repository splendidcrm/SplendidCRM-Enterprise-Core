if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSCHEDULERS_Run')
	Drop View dbo.vwSCHEDULERS_Run;
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
-- 12/31/2007 Paul.  When comparing against the CRON pattern, round the time down to the nearest 5 minute interval. 
-- 01/18/2008 Paul.  Lets make sure that the CheckVersion occurs shortly after application install. 
-- The trick is to skip the CRON filter if the CheckVersion job has never run. 
-- 01/18/2008 Paul.  Simplify code to handle LAST_RUN to match the Oracle implementation. 
Create View dbo.vwSCHEDULERS_Run
as
select vwSCHEDULERS.*
     , dbo.fnTimeRoundMinutes(getdate(), 5) as NEXT_RUN
  from vwSCHEDULERS
 where STATUS = N'Active'
   and (DATE_TIME_START is null or getdate() > DATE_TIME_START)
   and (DATE_TIME_END   is null or getdate() < DATE_TIME_END  )
   and (TIME_FROM       is null or getdate() > (dbo.fnDateAdd_Time(TIME_FROM, dbo.fnDateOnly(getdate()))))
   and (TIME_TO         is null or getdate() < (dbo.fnDateAdd_Time(TIME_TO  , dbo.fnDateOnly(getdate()))))
   and (   (JOB = N'function::CheckVersion' and LAST_RUN is null)
        or dbo.fnCronRun(JOB_INTERVAL, dbo.fnTimeRoundMinutes(getdate(), 5), 5) = 1
       )
   and (LAST_RUN is null or dbo.fnTimeRoundMinutes(getdate(), 5) > dbo.fnTimeRoundMinutes(LAST_RUN, 5))
GO

Grant Select on dbo.vwSCHEDULERS_Run to public;
GO

