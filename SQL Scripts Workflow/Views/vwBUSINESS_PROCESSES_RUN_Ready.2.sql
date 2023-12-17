if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwBUSINESS_PROCESSES_RUN_Ready')
	Drop View dbo.vwBUSINESS_PROCESSES_RUN_Ready;
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
Create View dbo.vwBUSINESS_PROCESSES_RUN_Ready
as
select vwBUSINESS_PROCESSES_RUN.ID
     , vwBUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_VERSION
     , vwBUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_ID
     , vwBUSINESS_PROCESSES_RUN.AUDIT_ID
     , vwBUSINESS_PROCESSES_RUN.AUDIT_TABLE
     , BUSINESS_PROCESSES.TYPE
     , BUSINESS_PROCESSES.XAML
  from      vwBUSINESS_PROCESSES_RUN
 inner join BUSINESS_PROCESSES
         on BUSINESS_PROCESSES.ID      = vwBUSINESS_PROCESSES_RUN.BUSINESS_PROCESS_ID
        and BUSINESS_PROCESSES.DELETED = 0
        and BUSINESS_PROCESSES.STATUS  = 1
        and BUSINESS_PROCESSES.XAML is not null
 where vwBUSINESS_PROCESSES_RUN.STATUS = N'Ready'

GO

Grant Select on dbo.vwBUSINESS_PROCESSES_RUN_Ready to public;
GO

