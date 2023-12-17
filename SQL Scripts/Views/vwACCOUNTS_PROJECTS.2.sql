if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_PROJECTS')
	Drop View dbo.vwACCOUNTS_PROJECTS;
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
-- 10/27/2012 Paul.  Project Relations data for Accounts moved to PROJECTS_ACCOUNTS. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwACCOUNTS_PROJECTS
as
select ACCOUNTS.ID                 as ACCOUNT_ID
     , ACCOUNTS.NAME               as ACCOUNT_NAME
     , ACCOUNTS.ASSIGNED_USER_ID   as ACCOUNT_ASSIGNED_USER_ID
     , ACCOUNTS.ASSIGNED_SET_ID    as ACCOUNT_ASSIGNED_SET_ID
     , vwPROJECTS.ID               as PROJECT_ID
     , vwPROJECTS.NAME             as PROJECT_NAME
     , vwPROJECTS.*
  from           ACCOUNTS
      inner join PROJECTS_ACCOUNTS
              on PROJECTS_ACCOUNTS.ACCOUNT_ID   = ACCOUNTS.ID
             and PROJECTS_ACCOUNTS.DELETED      = 0
      inner join vwPROJECTS
              on vwPROJECTS.ID                  = PROJECTS_ACCOUNTS.PROJECT_ID
 left outer join USERS
              on USERS.ID                       = vwPROJECTS.ASSIGNED_USER_ID
             and USERS.DELETED                  = 0
 where ACCOUNTS.DELETED = 0

GO

Grant Select on dbo.vwACCOUNTS_PROJECTS to public;
GO


