if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECT_LISTS_ExemptEmails')
	Drop View dbo.vwPROSPECT_LISTS_ExemptEmails;
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
Create View dbo.vwPROSPECT_LISTS_ExemptEmails
as
select PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID
     , vwPROSPECT_LISTS_Emails.ID
     , vwPROSPECT_LISTS_Emails.NAME
     , vwPROSPECT_LISTS_Emails.RELATED_TYPE
     , vwPROSPECT_LISTS_Emails.RELATED_ID
     , vwPROSPECT_LISTS_Emails.RELATED_NAME
     , vwPROSPECT_LISTS_Emails.EMAIL1
  from      PROSPECT_LIST_CAMPAIGNS
 inner join vwPROSPECT_LISTS_Emails
         on vwPROSPECT_LISTS_Emails.ID             = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
        and vwPROSPECT_LISTS_Emails.LIST_TYPE      = N'exempt'
 where PROSPECT_LIST_CAMPAIGNS.DELETED = 0
union
select PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID
     , vwPROSPECT_LISTS_Emails.ID
     , vwPROSPECT_LISTS_Emails.NAME
     , PROSPECT_LISTS_Default.RELATED_TYPE
     , PROSPECT_LISTS_Default.RELATED_ID
     , PROSPECT_LISTS_Default.RELATED_NAME
     , PROSPECT_LISTS_Default.EMAIL1
  from      PROSPECT_LIST_CAMPAIGNS
 inner join vwPROSPECT_LISTS_Emails
         on vwPROSPECT_LISTS_Emails.ID             = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
        and vwPROSPECT_LISTS_Emails.LIST_TYPE      = N'exempt_address'
 inner join vwPROSPECT_LISTS_Emails                  PROSPECT_LISTS_Default
         on lower(PROSPECT_LISTS_Default.EMAIL1) = lower(vwPROSPECT_LISTS_Emails.EMAIL1)
        and PROSPECT_LISTS_Default.LIST_TYPE    in (N'default', N'seed')
 where PROSPECT_LIST_CAMPAIGNS.DELETED = 0
union
select PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID
     , vwPROSPECT_LISTS.ID
     , vwPROSPECT_LISTS.NAME
     , PROSPECT_LISTS_Default.RELATED_TYPE
     , PROSPECT_LISTS_Default.RELATED_ID
     , PROSPECT_LISTS_Default.RELATED_NAME
     , PROSPECT_LISTS_Default.EMAIL1
  from      PROSPECT_LIST_CAMPAIGNS
 inner join vwPROSPECT_LISTS
         on vwPROSPECT_LISTS.ID                    = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
        and vwPROSPECT_LISTS.LIST_TYPE             = N'exempt_domain'
        and vwPROSPECT_LISTS.DOMAIN_NAME is not null
 inner join vwPROSPECT_LISTS_Emails                  PROSPECT_LISTS_Default
         on lower(PROSPECT_LISTS_Default.EMAIL1) like '%' + lower(vwPROSPECT_LISTS.DOMAIN_NAME)
        and PROSPECT_LISTS_Default.LIST_TYPE    in (N'default', N'seed')
 where PROSPECT_LIST_CAMPAIGNS.DELETED = 0
GO

Grant Select on dbo.vwPROSPECT_LISTS_ExemptEmails to public;
GO


