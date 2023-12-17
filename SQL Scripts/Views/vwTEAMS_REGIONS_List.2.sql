if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwTEAMS_REGIONS_List')
	Drop View dbo.vwTEAMS_REGIONS_List;
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
Create View dbo.vwTEAMS_REGIONS_List
as
select TEAMS.ID
     , TEAMS.NAME
     , TEAMS.DESCRIPTION
     , REGIONS.ID                 as REGION_ID
     , REGIONS.NAME               as REGION
     , TEAMS_CSTM.*
  from            TEAMS
  left outer join TEAMS_REGIONS
               on TEAMS_REGIONS.TEAM_ID = TEAMS.ID
              and TEAMS_REGIONS.DELETED = 0
  left outer join REGIONS
               on REGIONS.ID            = TEAMS_REGIONS.REGION_ID
              and REGIONS.DELETED       = 0
  left outer join TEAMS_CSTM
               on TEAMS_CSTM.ID_C        = TEAMS.ID
 where TEAMS.DELETED = 0

GO

Grant Select on dbo.vwTEAMS_REGIONS_List to public;
GO

