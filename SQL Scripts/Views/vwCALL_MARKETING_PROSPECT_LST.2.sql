if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALL_MARKETING_PROSPECT_LST')
	Drop View dbo.vwCALL_MARKETING_PROSPECT_LST;
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
Create View dbo.vwCALL_MARKETING_PROSPECT_LST
as
select cast(null as uniqueidentifier)    as LIST_ID
     , CALL_MARKETING.ID                 as CALL_MARKETING_ID
     , CALL_MARKETING.NAME               as CALL_MARKETING_NAME
     , CAMPAIGNS.ID                      as CAMPAIGN_ID
     , CAMPAIGNS.ASSIGNED_USER_ID        as CAMPAIGN_ASSIGNED_USER_ID
     , CAMPAIGNS.ASSIGNED_SET_ID         as CAMPAIGN_ASSIGNED_SET_ID
     , vwPROSPECT_LISTS.ID               as PROSPECT_LIST_ID
     , vwPROSPECT_LISTS.NAME             as PROSPECT_LIST_NAME
     , vwPROSPECT_LISTS.*
     , (select count(*)
          from PROSPECT_LISTS_PROSPECTS
         where PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID = vwPROSPECT_LISTS.ID
           and PROSPECT_LISTS_PROSPECTS.DELETED          = 0
       ) as ENTRIES
  from            CALL_MARKETING
  left outer join CAMPAIGNS
               on CAMPAIGNS.ID                        = CALL_MARKETING.CAMPAIGN_ID
              and CAMPAIGNS.DELETED                   = 0
  left outer join PROSPECT_LIST_CAMPAIGNS
               on PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID = CAMPAIGNS.ID
              and PROSPECT_LIST_CAMPAIGNS.DELETED     = 0
  left outer join vwPROSPECT_LISTS
               on vwPROSPECT_LISTS.ID                 = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
 where CALL_MARKETING.DELETED = 0
   and CALL_MARKETING.ALL_PROSPECT_LISTS = 1
union all
select CALL_MARKETING_PROSPECT_LISTS.ID  as LIST_ID
     , CALL_MARKETING.ID                 as CALL_MARKETING_ID
     , CALL_MARKETING.NAME               as CALL_MARKETING_NAME
     , CAMPAIGNS.ID                      as CAMPAIGN_ID
     , CAMPAIGNS.ASSIGNED_USER_ID        as CAMPAIGN_ASSIGNED_USER_ID
     , CAMPAIGNS.ASSIGNED_SET_ID         as CAMPAIGN_ASSIGNED_SET_ID
     , vwPROSPECT_LISTS.ID               as PROSPECT_LIST_ID
     , vwPROSPECT_LISTS.NAME             as PROSPECT_LIST_NAME
     , vwPROSPECT_LISTS.*
     , (select count(*)
          from PROSPECT_LISTS_PROSPECTS
         where PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID = vwPROSPECT_LISTS.ID
           and PROSPECT_LISTS_PROSPECTS.DELETED          = 0
       ) as ENTRIES
  from            CALL_MARKETING
  left outer join CALL_MARKETING_PROSPECT_LISTS
               on CALL_MARKETING_PROSPECT_LISTS.CALL_MARKETING_ID = CALL_MARKETING.ID
              and CALL_MARKETING_PROSPECT_LISTS.DELETED            = 0
  left outer join CAMPAIGNS
               on CAMPAIGNS.ID                        = CALL_MARKETING.CAMPAIGN_ID
              and CAMPAIGNS.DELETED                   = 0
  left outer join vwPROSPECT_LISTS
               on vwPROSPECT_LISTS.ID                 = CALL_MARKETING_PROSPECT_LISTS.PROSPECT_LIST_ID
 where CALL_MARKETING.DELETED = 0
   and isnull(CALL_MARKETING.ALL_PROSPECT_LISTS, 0) = 0

GO

Grant Select on dbo.vwCALL_MARKETING_PROSPECT_LST to public;
GO

