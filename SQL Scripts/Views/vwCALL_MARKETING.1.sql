if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALL_MARKETING')
	Drop View dbo.vwCALL_MARKETING;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 04/10/2021 Paul.  React client requires DATE_MODIFIED_UTC in all tables. 
Create View dbo.vwCALL_MARKETING
as
select CALL_MARKETING.ID
     , CALL_MARKETING.ASSIGNED_USER_ID
     , CALL_MARKETING.NAME
     , CALL_MARKETING.STATUS
     , CALL_MARKETING.DISTRIBUTION
     , CALL_MARKETING.ALL_PROSPECT_LISTS
     , CALL_MARKETING.SUBJECT
     , CALL_MARKETING.DURATION_HOURS
     , CALL_MARKETING.DURATION_MINUTES
     , CALL_MARKETING.DATE_START
     , CALL_MARKETING.TIME_START
     , CALL_MARKETING.DATE_END
     , CALL_MARKETING.TIME_END
     , CALL_MARKETING.REMINDER_TIME
     , CALL_MARKETING.DESCRIPTION
     , CALL_MARKETING.DATE_ENTERED
     , CALL_MARKETING.DATE_MODIFIED
     , CALL_MARKETING.DATE_MODIFIED_UTC
     , CAMPAIGNS.ID                     as CAMPAIGN_ID
     , CAMPAIGNS.NAME                   as CAMPAIGN_NAME
     , CAMPAIGNS.CAMPAIGN_TYPE          as CAMPAIGN_TYPE
     , CAMPAIGNS.ASSIGNED_USER_ID       as CAMPAIGN_ASSIGNED_USER_ID
     , CAMPAIGNS.ASSIGNED_SET_ID        as CAMPAIGN_ASSIGNED_SET_ID
     , TEAMS.ID                         as TEAM_ID
     , TEAMS.NAME                       as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME         as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME       as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME      as MODIFIED_BY
     , CALL_MARKETING.CREATED_BY        as CREATED_BY_ID
     , CALL_MARKETING.MODIFIED_USER_ID
     , TEAM_SETS.ID                     as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME          as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST          as TEAM_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , CALL_MARKETING_CSTM.*
  from            CALL_MARKETING
  left outer join CAMPAIGNS
               on CAMPAIGNS.ID             = CALL_MARKETING.CAMPAIGN_ID
              and CAMPAIGNS.DELETED        = 0
  left outer join TEAMS
               on TEAMS.ID                 = CALL_MARKETING.TEAM_ID
              and TEAMS.DELETED            = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID             = CALL_MARKETING.TEAM_SET_ID
              and TEAM_SETS.DELETED        = 0
  left outer join USERS                      USERS_ASSIGNED
               on USERS_ASSIGNED.ID        = CALL_MARKETING.ASSIGNED_USER_ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = CALL_MARKETING.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = CALL_MARKETING.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID         = CALL_MARKETING.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED    = 0
  left outer join CALL_MARKETING_CSTM
               on CALL_MARKETING_CSTM.ID_C = CALL_MARKETING.ID
 where CALL_MARKETING.DELETED = 0

GO

Grant Select on dbo.vwCALL_MARKETING to public;
GO

 
