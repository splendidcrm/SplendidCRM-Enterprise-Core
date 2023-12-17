if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSERS_TEAM_MEMBERSHIPS')
	Drop View dbo.vwUSERS_TEAM_MEMBERSHIPS;
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
Create View dbo.vwUSERS_TEAM_MEMBERSHIPS
as
select TEAM_MEMBERSHIPS.TEAM_ID
     , TEAM_MEMBERSHIPS.USER_ID
     , TEAM_MEMBERSHIPS.EXPLICIT_ASSIGN
     , TEAM_MEMBERSHIPS.IMPLICIT_ASSIGN
     , TEAMS.NAME         as TEAM_NAME
     , TEAMS.DESCRIPTION
  from           TEAM_MEMBERSHIPS
      inner join TEAMS
              on TEAMS.ID      = TEAM_MEMBERSHIPS.TEAM_ID
             and TEAMS.DELETED = 0
 where TEAM_MEMBERSHIPS.DELETED = 0

GO

Grant Select on dbo.vwUSERS_TEAM_MEMBERSHIPS to public;
GO

