if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCAMPAIGNS_Activity')
	Drop View dbo.vwCAMPAIGNS_Activity;
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
-- 12/25/2007 Paul.  We need a union to capture all activities that are not defined in the list. 
-- 08/30/2009 Paul.  Dynamic teams required an ID and TEAM_SET_ID. 
Create View dbo.vwCAMPAIGNS_Activity
as
select CAMPAIGNS.ID
     , CAMPAIGNS.ASSIGNED_USER_ID
     , CAMPAIGNS.TEAM_ID
     , CAMPAIGNS.TEAM_SET_ID
     , CAMPAIGN_LOG.ID               as CAMPAIGN_LOG_ID
     , CAMPAIGN_LOG.ACTIVITY_TYPE
     , CAMPAIGN_LOG.TARGET_TYPE
     , TERMINOLOGY.LIST_ORDER
  from            CAMPAIGNS
       inner join CAMPAIGN_LOG
               on CAMPAIGN_LOG.CAMPAIGN_ID = CAMPAIGNS.ID
              and CAMPAIGN_LOG.ARCHIVED    = 0
              and CAMPAIGN_LOG.DELETED     = 0
       inner join TERMINOLOGY
               on TERMINOLOGY.NAME         = CAMPAIGN_LOG.ACTIVITY_TYPE
              and TERMINOLOGY.LIST_NAME    = N'campainglog_activity_type_dom'
              and TERMINOLOGY.LANG         = N'en-US'
              and TERMINOLOGY.DELETED      = 0
union all
select CAMPAIGNS.ID
     , CAMPAIGNS.ASSIGNED_USER_ID
     , CAMPAIGNS.TEAM_ID
     , CAMPAIGNS.TEAM_SET_ID
     , CAMPAIGN_LOG.ID               as CAMPAIGN_LOG_ID
     , CAMPAIGN_LOG.ACTIVITY_TYPE
     , CAMPAIGN_LOG.TARGET_TYPE
     , cast(0 as int)                as LIST_ORDER
  from            CAMPAIGNS
       inner join CAMPAIGN_LOG
               on CAMPAIGN_LOG.CAMPAIGN_ID = CAMPAIGNS.ID
              and CAMPAIGN_LOG.ARCHIVED    = 0
              and CAMPAIGN_LOG.DELETED     = 0
  left outer join TERMINOLOGY
               on TERMINOLOGY.NAME         = CAMPAIGN_LOG.ACTIVITY_TYPE
              and TERMINOLOGY.LIST_NAME    = N'campainglog_activity_type_dom'
              and TERMINOLOGY.LANG         = N'en-US'
              and TERMINOLOGY.DELETED      = 0
 where TERMINOLOGY.ID is null


GO

Grant Select on dbo.vwCAMPAIGNS_Activity to public;
GO


