if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwBUSINESS_PROCESSES_RunTimed')
	Drop View dbo.vwBUSINESS_PROCESSES_RunTimed;
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
Create View dbo.vwBUSINESS_PROCESSES_RunTimed
as
select vwBUSINESS_PROCESSES.*
     , dbo.fnTimeRoundSeconds(getdate(), 60) as NEXT_RUN
  from vwBUSINESS_PROCESSES
 where STATUS = 1
   and TYPE   = N'time'
   and dbo.fnCronRun(JOB_INTERVAL, dbo.fnTimeRoundMinutes(getdate(), 1), 1) = 1
   and (LAST_RUN is null or dbo.fnTimeRoundSeconds(getdate(), 60) > dbo.fnTimeRoundSeconds(LAST_RUN, 60))
GO

Grant Select on dbo.vwBUSINESS_PROCESSES_RunTimed to public;
GO

