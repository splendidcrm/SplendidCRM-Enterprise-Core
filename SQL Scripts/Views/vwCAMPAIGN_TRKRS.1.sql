if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCAMPAIGN_TRKRS')
	Drop View dbo.vwCAMPAIGN_TRKRS;
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
-- 09/01/2009 Paul.  Add TEAM_SET_ID so that the team filter will not fail. 
-- 08/01/2010 Paul.  Add CREATED_BY_NAME and MODIFIED_BY_NAME so that we can display the full name in lists like Sugar. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 04/10/2021 Paul.  React client requires DATE_MODIFIED_UTC in all tables. 
Create View dbo.vwCAMPAIGN_TRKRS
as
select CAMPAIGN_TRKRS.ID
     , CAMPAIGN_TRKRS.TRACKER_NAME      as NAME
     , CAMPAIGN_TRKRS.TRACKER_NAME
     , CAMPAIGN_TRKRS.TRACKER_URL
     , CAMPAIGN_TRKRS.TRACKER_KEY
     , CAMPAIGN_TRKRS.IS_OPTOUT
     , CAMPAIGN_TRKRS.DATE_ENTERED
     , CAMPAIGN_TRKRS.DATE_MODIFIED
     , CAMPAIGN_TRKRS.DATE_MODIFIED_UTC
     , CAMPAIGNS.ID                     as CAMPAIGN_ID
     , CAMPAIGNS.NAME                   as CAMPAIGN_NAME
     , CAMPAIGNS.ASSIGNED_USER_ID       as CAMPAIGN_ASSIGNED_USER_ID
     , CAMPAIGNS.ASSIGNED_SET_ID        as CAMPAIGN_ASSIGNED_SET_ID
     , cast(null as uniqueidentifier)   as ASSIGNED_USER_ID
     , cast(null as uniqueidentifier)   as TEAM_ID
     , cast(null as nvarchar(128))      as TEAM_NAME
     , cast(null as uniqueidentifier)   as TEAM_SET_ID
     , cast(null as nvarchar(200))      as TEAM_SET_NAME
     , cast(null as uniqueidentifier)   as ASSIGNED_SET_ID
     , cast(null as nvarchar(200))      as ASSIGNED_SET_NAME
     , cast(null as varchar(851))       as ASSIGNED_SET_LIST
     , USERS_CREATED_BY.USER_NAME       as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME      as MODIFIED_BY
     , CAMPAIGN_TRKRS.CREATED_BY        as CREATED_BY_ID
     , CAMPAIGN_TRKRS.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , CAMPAIGN_TRKRS_CSTM.*
  from            CAMPAIGN_TRKRS
       inner join CAMPAIGNS
               on CAMPAIGNS.ID             = CAMPAIGN_TRKRS.CAMPAIGN_ID
              and CAMPAIGNS.DELETED        = 0
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = CAMPAIGN_TRKRS.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = CAMPAIGN_TRKRS.MODIFIED_USER_ID
  left outer join CAMPAIGN_TRKRS_CSTM
               on CAMPAIGN_TRKRS_CSTM.ID_C = CAMPAIGN_TRKRS.ID
 where CAMPAIGN_TRKRS.DELETED = 0

GO

Grant Select on dbo.vwCAMPAIGN_TRKRS to public;
GO

 
