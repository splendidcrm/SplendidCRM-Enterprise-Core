if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTEAM_NOTICES')
	Drop View dbo.vwTEAM_NOTICES;
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
-- 09/02/2009 Paul.  Add support for dynamic teams. 
-- 10/25/2010 Paul.  TEAM_SET_LIST is needed by the RulesWizard. 
-- 04/11/2021 Paul.  DATE_MODIFIED is required by the React client. 
Create View dbo.vwTEAM_NOTICES
as
select TEAM_NOTICES.ID
     , TEAM_NOTICES.NAME
     , TEAM_NOTICES.STATUS
     , TEAM_NOTICES.DATE_START
     , TEAM_NOTICES.DATE_END
     , TEAM_NOTICES.URL
     , TEAM_NOTICES.URL_TITLE
     , TEAM_NOTICES.DESCRIPTION
     , TEAM_NOTICES.DATE_MODIFIED
     , TEAM_NOTICES.DATE_MODIFIED_UTC
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , TEAM_SETS.ID                as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME     as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST     as TEAM_SET_LIST
  from            TEAM_NOTICES
  left outer join TEAMS
               on TEAMS.ID          = TEAM_NOTICES.TEAM_ID
              and TEAMS.DELETED     = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID      = TEAM_NOTICES.TEAM_SET_ID
              and TEAM_SETS.DELETED = 0
 where TEAM_NOTICES.DELETED = 0

GO

Grant Select on dbo.vwTEAM_NOTICES to public;
GO

 
