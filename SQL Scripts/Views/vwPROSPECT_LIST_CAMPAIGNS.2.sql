if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPROSPECT_LIST_CAMPAIGNS')
	Drop View dbo.vwPROSPECT_LIST_CAMPAIGNS;
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
Create View dbo.vwPROSPECT_LIST_CAMPAIGNS
as
select PROSPECT_LISTS.ID               as PROSPECT_LIST_ID
     , PROSPECT_LISTS.NAME             as PROSPECT_LIST_NAME
     , PROSPECT_LISTS.ASSIGNED_USER_ID as PROSPECT_ASSIGNED_USER_ID
     , PROSPECT_LISTS.ASSIGNED_SET_ID  as PROSPECT_ASSIGNED_SET_ID
     , vwCAMPAIGNS.ID                  as CAMPAIGN_ID
     , vwCAMPAIGNS.NAME                as CAMPAIGN_NAME
     , vwCAMPAIGNS.*
  from            PROSPECT_LISTS
       inner join PROSPECT_LIST_CAMPAIGNS
               on PROSPECT_LIST_CAMPAIGNS.PROSPECT_LIST_ID  = PROSPECT_LISTS.ID
              and PROSPECT_LIST_CAMPAIGNS.DELETED           = 0
       inner join vwCAMPAIGNS
               on vwCAMPAIGNS.ID                            = PROSPECT_LIST_CAMPAIGNS.CAMPAIGN_ID
 where PROSPECT_LISTS.DELETED = 0

GO

Grant Select on dbo.vwPROSPECT_LIST_CAMPAIGNS to public;
GO
