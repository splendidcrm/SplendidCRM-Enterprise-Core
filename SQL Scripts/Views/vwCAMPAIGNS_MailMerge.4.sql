if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCAMPAIGNS_MailMerge')
	Drop View dbo.vwCAMPAIGNS_MailMerge;
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
Create View dbo.vwCAMPAIGNS_MailMerge
as
select distinct
       PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID
     , vwPROSPECT_LISTS_MailMerge.PROSPECT_LIST_ID
     , vwPROSPECT_LISTS_MailMerge.ID
     , vwPROSPECT_LISTS_MailMerge.MODULE_NAME
     , vwPROSPECT_LISTS_MailMerge.NAME
  from            PROSPECT_LIST_CAMPAIGNS
       inner join vwPROSPECT_LISTS_MailMerge
               on vwPROSPECT_LISTS_MailMerge.PROSPECT_LIST_ID = PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID
 where PROSPECT_LIST_CAMPAIGNS.DELETED = 0
GO

Grant Select on dbo.vwCAMPAIGNS_MailMerge to public;
GO


