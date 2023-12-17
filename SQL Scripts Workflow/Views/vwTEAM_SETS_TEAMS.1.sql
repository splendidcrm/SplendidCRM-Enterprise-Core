if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTEAM_SETS_TEAMS')
	Drop View dbo.vwTEAM_SETS_TEAMS;
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
-- 09/02/2009 Paul.  We need to use the module-naming convention. 
Create View dbo.vwTEAM_SETS_TEAMS
as
select TEAM_SETS.ID
     , TEAM_SETS_TEAMS.TEAM_ID
     , TEAM_SETS_TEAMS.PRIMARY_TEAM
     , TEAMS.NAME   as TEAM_NAME
     , TEAM_SETS.DATE_MODIFIED_UTC
  from      TEAM_SETS
 inner join TEAM_SETS_TEAMS
         on TEAM_SETS_TEAMS.TEAM_SET_ID = TEAM_SETS.ID
 inner join TEAMS
         on TEAMS.ID                    = TEAM_SETS_TEAMS.TEAM_ID
        and TEAMS.DELETED               = 0
 where TEAM_SETS.DELETED = 0

GO

Grant Select on dbo.vwTEAM_SETS_TEAMS to public;
GO

 
