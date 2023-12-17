if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCAMPAIGNS_Call')
	Drop View dbo.vwCAMPAIGNS_Call;
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
Create View dbo.vwCAMPAIGNS_Call
as
select distinct
       CALL_MARKETING.CAMPAIGN_ID
     , CALL_MARKETING.ID                     as CALL_MARKETING_ID
     , vwPROSPECT_LISTS_Phones.ID            as PROSPECT_LIST_ID
     , vwPROSPECT_LISTS_Phones.RELATED_ID
     , vwPROSPECT_LISTS_Phones.RELATED_TYPE
     , vwPROSPECT_LISTS_Phones.RELATED_NAME
     , vwPROSPECT_LISTS_Phones.PHONE_WORK
  from            CALL_MARKETING
       inner join PROSPECT_LIST_CAMPAIGNS
               on PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID                  = CALL_MARKETING.CAMPAIGN_ID
              and PROSPECT_LIST_CAMPAIGNS.DELETED                      = 0
       inner join vwPROSPECT_LISTS_Phones
               on vwPROSPECT_LISTS_Phones.ID                           = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
       inner join vwCAMPAIGNS_PROSPECT_LIST_Call
               on vwCAMPAIGNS_PROSPECT_LIST_Call.PROSPECT_LIST_ID      = vwPROSPECT_LISTS_Phones.ID
              and vwCAMPAIGNS_PROSPECT_LIST_Call.ALL_PROSPECT_LISTS    = isnull(CALL_MARKETING.ALL_PROSPECT_LISTS, 0)
              and (   vwCAMPAIGNS_PROSPECT_LIST_Call.CAMPAIGN_ID       = PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID
                   or vwCAMPAIGNS_PROSPECT_LIST_Call.CALL_MARKETING_ID = CALL_MARKETING.ID)
  left outer join vwPROSPECT_LISTS_ExemptPhones
               on vwPROSPECT_LISTS_ExemptPhones.RELATED_ID             = vwPROSPECT_LISTS_Phones.RELATED_ID
              and vwPROSPECT_LISTS_ExemptPhones.CAMPAIGN_ID            = PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID
 where CALL_MARKETING.DELETED = 0
   and CALL_MARKETING.STATUS  = N'active'
   and vwPROSPECT_LISTS_ExemptPhones.RELATED_ID is null
GO

Grant Select on dbo.vwCAMPAIGNS_Call to public;
GO


