if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_USERS')
	Drop View dbo.vwCALLS_USERS;
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
-- 09/08/2015 Paul.  The primary ID is needed to enable Preview in the Seven theme. 
-- 06/14/2017 Paul.  DATE_MODIFIED_UTC is needed by HTML5 Client. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 05/05/2018 Paul.  ASSIGNED_SET_LIST can be used. 
Create View dbo.vwCALLS_USERS
as
select CALLS.ID               as CALL_ID
     , CALLS.NAME             as CALL_NAME
     , CALLS.ASSIGNED_USER_ID as CALL_ASSIGNED_USER_ID
     , CALLS.ASSIGNED_SET_ID  as CALL_ASSIGNED_SET_ID
     , USERS.ID                  as ID
     , USERS.ID               as USER_ID
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as FULL_NAME
     , USERS.USER_NAME
     , USERS.EMAIL1
     , USERS.PHONE_WORK
     , CALLS_USERS.DATE_ENTERED
     , CALLS_USERS.DATE_MODIFIED_UTC
     , CALLS.ASSIGNED_USER_ID
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
  from           CALLS
      inner join CALLS_USERS
              on CALLS_USERS.CALL_ID = CALLS.ID
             and CALLS_USERS.DELETED = 0
      inner join USERS
              on USERS.ID            = CALLS_USERS.USER_ID
             and USERS.DELETED       = 0
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID       = CALLS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED  = 0
 where CALLS.DELETED = 0

GO

Grant Select on dbo.vwCALLS_USERS to public;
GO

