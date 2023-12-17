if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCAMPAIGNS_PROSPECT_LIST_Send')
	Drop View dbo.vwCAMPAIGNS_PROSPECT_LIST_Send;
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
Create View dbo.vwCAMPAIGNS_PROSPECT_LIST_Send
as
select PROSPECT_LISTS.ID                                 as PROSPECT_LIST_ID
     , PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID               as CAMPAIGN_ID
     , cast(null as uniqueidentifier)                    as EMAIL_MARKETING_ID
     , cast(1 as bit)                                    as ALL_PROSPECT_LISTS
     , (case PROSPECT_LISTS.LIST_TYPE
        when N'test' then cast(1 as bit)
        else              cast(0 as bit)
        end)                                             as TEST
  from      PROSPECT_LIST_CAMPAIGNS
 inner join PROSPECT_LISTS
         on PROSPECT_LISTS.ID         = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
        and PROSPECT_LISTS.DELETED    = 0
        and PROSPECT_LISTS.LIST_TYPE in (N'test', N'default', N'seed')
 where PROSPECT_LIST_CAMPAIGNS.DELETED = 0
union all
select PROSPECT_LISTS.ID                                 as PROSPECT_LIST_ID
     , cast(null as uniqueidentifier)                    as CAMPAIGN_ID
     , EMAIL_MARKETING_PROSPECT_LISTS.EMAIL_MARKETING_ID as EMAIL_MARKETING_ID
     , cast(0 as bit)                                    as ALL_PROSPECT_LISTS
     , (case PROSPECT_LISTS.LIST_TYPE
        when N'test' then cast(1 as bit)
        else              cast(0 as bit)
        end)                                             as TEST
  from      EMAIL_MARKETING_PROSPECT_LISTS
 inner join PROSPECT_LISTS
         on PROSPECT_LISTS.ID         = EMAIL_MARKETING_PROSPECT_LISTS.PROSPECT_LIST_ID
        and PROSPECT_LISTS.DELETED    = 0
        and PROSPECT_LISTS.LIST_TYPE in (N'test', N'default', N'seed')
 where EMAIL_MARKETING_PROSPECT_LISTS.DELETED = 0
GO

Grant Select on dbo.vwCAMPAIGNS_PROSPECT_LIST_Send to public;
GO


