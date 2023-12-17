if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAIL_MARKETING_PROSPECT_LST')
	Drop View dbo.vwEMAIL_MARKETING_PROSPECT_LST;
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
-- 12/15/2007 Paul.  ALL_PROSPECT_LISTS is used to determine if we join to the EMAIL_MARKETING_PROSPECT_LISTS table. 
-- 09/01/2009 Paul.  Alow the display of email marketing even if campaign record has been deleted. 
-- 09/01/2009 Paul.  The join to EMAIL_MARKETING_PROSPECT_LISTS should not have included PROSPECT_LIST_CAMPAIGNS. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwEMAIL_MARKETING_PROSPECT_LST
as
select cast(null as uniqueidentifier)    as LIST_ID
     , EMAIL_MARKETING.ID                as EMAIL_MARKETING_ID
     , EMAIL_MARKETING.NAME              as EMAIL_MARKETING_NAME
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
  from            EMAIL_MARKETING
  left outer join CAMPAIGNS
               on CAMPAIGNS.ID                        = EMAIL_MARKETING.CAMPAIGN_ID
              and CAMPAIGNS.DELETED                   = 0
  left outer join PROSPECT_LIST_CAMPAIGNS
               on PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID = CAMPAIGNS.ID
              and PROSPECT_LIST_CAMPAIGNS.DELETED     = 0
  left outer join vwPROSPECT_LISTS
               on vwPROSPECT_LISTS.ID                 = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
 where EMAIL_MARKETING.DELETED = 0
   and EMAIL_MARKETING.ALL_PROSPECT_LISTS = 1
union all
select EMAIL_MARKETING_PROSPECT_LISTS.ID as LIST_ID
     , EMAIL_MARKETING.ID                as EMAIL_MARKETING_ID
     , EMAIL_MARKETING.NAME              as EMAIL_MARKETING_NAME
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
  from            EMAIL_MARKETING
  left outer join EMAIL_MARKETING_PROSPECT_LISTS
               on EMAIL_MARKETING_PROSPECT_LISTS.EMAIL_MARKETING_ID = EMAIL_MARKETING.ID
              and EMAIL_MARKETING_PROSPECT_LISTS.DELETED            = 0
  left outer join CAMPAIGNS
               on CAMPAIGNS.ID                        = EMAIL_MARKETING.CAMPAIGN_ID
              and CAMPAIGNS.DELETED                   = 0
  left outer join vwPROSPECT_LISTS
               on vwPROSPECT_LISTS.ID                 = EMAIL_MARKETING_PROSPECT_LISTS.PROSPECT_LIST_ID
 where EMAIL_MARKETING.DELETED = 0
   and isnull(EMAIL_MARKETING.ALL_PROSPECT_LISTS, 0) = 0

GO

Grant Select on dbo.vwEMAIL_MARKETING_PROSPECT_LST to public;
GO

