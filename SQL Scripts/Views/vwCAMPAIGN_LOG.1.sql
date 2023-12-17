if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCAMPAIGN_LOG')
	Drop View dbo.vwCAMPAIGN_LOG;
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
Create View dbo.vwCAMPAIGN_LOG
as
select CAMPAIGN_LOG.ID
     , CAMPAIGN_LOG.TARGET_TRACKER_KEY
     , CAMPAIGN_LOG.TARGET_ID
     , CAMPAIGN_LOG.TARGET_TYPE             -- Contacts, Leads, Prospects, Users. 
     , CAMPAIGN_LOG.ACTIVITY_TYPE
     , CAMPAIGN_LOG.ACTIVITY_DATE
     , CAMPAIGN_LOG.RELATED_ID
     , CAMPAIGN_LOG.RELATED_TYPE            -- Emails. 
     , CAMPAIGN_LOG.ARCHIVED
     , CAMPAIGN_LOG.HITS
     , CAMPAIGN_LOG.MORE_INFORMATION
     , CAMPAIGNS.ID                as CAMPAIGN_ID
     , CAMPAIGNS.NAME              as CAMPAIGN_NAME
     , EMAIL_MARKETING.ID          as EMAIL_MARKETING_ID
     , EMAIL_MARKETING.NAME        as EMAIL_MARKETING_NAME
     , PROSPECT_LISTS.ID           as PROSPECT_LIST_ID
     , PROSPECT_LISTS.NAME         as PROSPECT_LIST_NAME
     , EMAILS.NAME                 as RELATED_NAME
  from            CAMPAIGN_LOG
  left outer join CAMPAIGNS
               on CAMPAIGNS.ID            = CAMPAIGN_LOG.CAMPAIGN_ID
              and CAMPAIGNS.DELETED       = 0
  left outer join EMAIL_MARKETING
               on EMAIL_MARKETING.ID      = CAMPAIGN_LOG.MARKETING_ID
              and EMAIL_MARKETING.DELETED = 0
  left outer join PROSPECT_LISTS
               on PROSPECT_LISTS.ID       = CAMPAIGN_LOG.LIST_ID
              and PROSPECT_LISTS.DELETED  = 0
  left outer join EMAILS
               on EMAILS.ID               = CAMPAIGN_LOG.RELATED_ID
              and EMAILS.DELETED          = 0
 where CAMPAIGN_LOG.DELETED = 0

GO

Grant Select on dbo.vwCAMPAIGN_LOG to public;
GO

