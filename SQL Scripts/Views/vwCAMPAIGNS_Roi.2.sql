if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCAMPAIGNS_Roi')
	Drop View dbo.vwCAMPAIGNS_Roi;
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
Create View dbo.vwCAMPAIGNS_Roi
as
select vwCAMPAIGNS.*
     , (select count(*)
          from OPPORTUNITIES
         where CAMPAIGN_ID = vwCAMPAIGNS.ID
           and SALES_STAGE = N'Closed Won'
           and DELETED     = 0
       )                                    as OPPORTUNITIES_WON
     , ACTUAL_COST_USDOLLAR / nullif(IMPRESSIONS, 0) as COST_PER_IMPRESSION
     , (select vwCAMPAIGNS.ACTUAL_COST_USDOLLAR / nullif(count(*), 0)
         from CAMPAIGN_LOG
        where CAMPAIGN_ID = vwCAMPAIGNS.ID
          and ACTIVITY_TYPE = N'link'
       )                                    as COST_PER_CLICK_THROUGH
     , (select sum(AMOUNT_USDOLLAR)
          from OPPORTUNITIES
         where CAMPAIGN_ID = vwCAMPAIGNS.ID
           and SALES_STAGE = N'Closed Won'
           and DELETED     = 0
       )                   as REVENUE
  from vwCAMPAIGNS

GO

Grant Select on dbo.vwCAMPAIGNS_Roi to public;
GO

