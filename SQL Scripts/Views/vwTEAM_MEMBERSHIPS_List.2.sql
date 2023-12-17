if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTEAM_MEMBERSHIPS_List')
	Drop View dbo.vwTEAM_MEMBERSHIPS_List;
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
Create View dbo.vwTEAM_MEMBERSHIPS_List
as
select TEAMS.ID   as TEAM_ID
     , TEAMS.NAME as TEAM_NAME
     , USERS.ID   as USER_ID
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as FULL_NAME
     , USERS.USER_NAME
     , USERS.EMAIL1
     , USERS.PHONE_WORK
     , TEAM_MEMBERSHIPS.DATE_ENTERED
     , TEAM_MEMBERSHIPS.EXPLICIT_ASSIGN
     , TEAM_MEMBERSHIPS.IMPLICIT_ASSIGN
  from           TEAMS
      inner join TEAM_MEMBERSHIPS
              on TEAM_MEMBERSHIPS.TEAM_ID = TEAMS.ID
             and TEAM_MEMBERSHIPS.DELETED = 0
      inner join USERS
              on USERS.ID                 = TEAM_MEMBERSHIPS.USER_ID
             and USERS.DELETED            = 0
 where TEAMS.DELETED = 0

GO

Grant Select on dbo.vwTEAM_MEMBERSHIPS_List to public;
GO

