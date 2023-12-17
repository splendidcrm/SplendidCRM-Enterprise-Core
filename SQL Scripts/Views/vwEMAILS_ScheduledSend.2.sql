if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_ScheduledSend')
	Drop View dbo.vwEMAILS_ScheduledSend;
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
-- 05/15/2008 Paul.  Delay 1 minute before sending the email so that manual send would not get sent by scheduler. 
-- 05/19/2008 Paul.  Decrease the delay to 30 seconds in case that the scheduler is run every minute. 
Create View dbo.vwEMAILS_ScheduledSend
as
select ID
     , DATE_MODIFIED
  from vwEMAILS_ReadyToSend
 where getdate() > dbo.fnDateAdd_Seconds(30, DATE_MODIFIED)

GO

Grant Select on dbo.vwEMAILS_ScheduledSend to public;
GO

 
