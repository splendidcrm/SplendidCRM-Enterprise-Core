if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCAMPAIGNS_ExemptEmails')
	Drop View dbo.vwCAMPAIGNS_ExemptEmails;
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
-- 01/20/2008 Paul.  Only include active EMAIL_MARKETING records. 
-- 09/01/2009 Paul.  Add TEAM_SET_ID so that the team filter will not fail. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwCAMPAIGNS_ExemptEmails
as
select distinct
       EMAIL_MARKETING.CAMPAIGN_ID                  as CAMPAIGN_ID
     , vwCAMPAIGNS_PROSPECT_LIST_Send.TEST          as TEST
     , EMAIL_MARKETING.ID                           as EMAIL_MARKETING_ID
     , vwPROSPECT_LISTS_ExemptEmails.ID             as PROSPECT_LIST_ID
     , vwPROSPECT_LISTS_ExemptEmails.RELATED_ID     as RELATED_ID
     , vwPROSPECT_LISTS_ExemptEmails.RELATED_TYPE   as RELATED_TYPE
     , vwPROSPECT_LISTS_ExemptEmails.RELATED_NAME   as RELATED_NAME
     , vwPROSPECT_LISTS_ExemptEmails.EMAIL1         as EMAIL1
     , (case vwCAMPAIGNS_PROSPECT_LIST_Send.TEST
        when 1 then getdate() 
        else EMAIL_MARKETING.DATE_START end)        as SEND_DATE_TIME
     , cast(null as uniqueidentifier)               as ASSIGNED_USER_ID
     , cast(null as uniqueidentifier)               as TEAM_ID
     , cast(null as uniqueidentifier)               as TEAM_SET_ID
     , cast(null as nvarchar(200))                  as TEAM_SET_NAME
     , cast(null as uniqueidentifier)               as ASSIGNED_SET_ID
     , cast(null as nvarchar(200))                  as ASSIGNED_SET_NAME
     , cast(null as varchar(851))                   as ASSIGNED_SET_LIST
  from            EMAIL_MARKETING
       inner join PROSPECT_LIST_CAMPAIGNS
               on PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID                   = EMAIL_MARKETING.CAMPAIGN_ID
              and PROSPECT_LIST_CAMPAIGNS.DELETED                       = 0
       inner join vwPROSPECT_LISTS_ExemptEmails
               on vwPROSPECT_LISTS_ExemptEmails.ID                      = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
       inner join vwCAMPAIGNS_PROSPECT_LIST_Send
               on vwCAMPAIGNS_PROSPECT_LIST_Send.PROSPECT_LIST_ID       = vwPROSPECT_LISTS_ExemptEmails.ID
              and vwCAMPAIGNS_PROSPECT_LIST_Send.ALL_PROSPECT_LISTS     = isnull(EMAIL_MARKETING.ALL_PROSPECT_LISTS, 0)
              and (   vwCAMPAIGNS_PROSPECT_LIST_Send.CAMPAIGN_ID        = PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID
                   or vwCAMPAIGNS_PROSPECT_LIST_Send.EMAIL_MARKETING_ID = EMAIL_MARKETING.ID)
 where EMAIL_MARKETING.DELETED = 0
   and EMAIL_MARKETING.STATUS  = N'active'
GO

Grant Select on dbo.vwCAMPAIGNS_ExemptEmails to public;
GO


