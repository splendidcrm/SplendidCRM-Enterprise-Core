if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_MyList')
	Drop View dbo.vwCALLS_MyList;
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
-- 08/16/2005 Paul.  Only return the date. 
-- 10/23/2005 Paul.  Always return full date as it will need to be converted to the correct timezone.
-- 08/02/2005 Paul.  Although the SugarCRM 3.0 code suggests that declined would not be shown, it actually is shown. 
--        and MEETINGS_USERS.ACCEPT_STATUS <> N'Decline'
--        and CALLS_USERS.ACCEPT_STATUS <> N'Decline'
-- 02/01/2006 Paul.  DB2 does not like comments in the middle of the Create View statement. 
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 08/30/2009 Paul.  All module views must have a TEAM_SET_ID. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 05/30/2019 Paul.  The React client needs a process ID. 
Create View dbo.vwCALLS_MyList
as
select vwCALLS_List.ID
     , vwCALLS_List.NAME
     , vwCALLS_List.DURATION_HOURS
     , vwCALLS_List.DURATION_MINUTES
     , vwCALLS_List.DATE_START
     , isnull(CALLS_USERS.ACCEPT_STATUS, N'none') as ACCEPT_STATUS
     , CALLS_USERS.USER_ID    as ASSIGNED_USER_ID
     , vwCALLS_List.TEAM_ID
     , vwCALLS_List.TEAM_NAME
     , vwCALLS_List.TEAM_SET_ID
     , vwCALLS_List.TEAM_SET_NAME
     , vwCALLS_List.ASSIGNED_SET_ID
     , vwCALLS_List.ASSIGNED_SET_NAME
     , vwCALLS_List.ASSIGNED_SET_LIST
     , vwPROCESSES_Pending.ID      as PENDING_PROCESS_ID
  from            vwCALLS_List
       inner join CALLS_USERS
               on CALLS_USERS.CALL_ID       = vwCALLS_List.ID
              and CALLS_USERS.DELETED       = 0
  left outer join vwPROCESSES_Pending
               on vwPROCESSES_Pending.PARENT_ID = vwCALLS_List.ID
 where vwCALLS_List.STATUS in (N'Planned')

GO

Grant Select on dbo.vwCALLS_MyList to public;
GO

