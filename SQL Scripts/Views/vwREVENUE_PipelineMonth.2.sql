if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwREVENUE_PipelineMonth')
	Drop View dbo.vwREVENUE_PipelineMonth;
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
Create View dbo.vwREVENUE_PipelineMonth
as
select OPPORTUNITIES.ID
     , OPPORTUNITIES.ASSIGNED_USER_ID
     , OPPORTUNITIES.TEAM_ID
     , OPPORTUNITIES.TEAM_SET_ID
     , (case REVENUE_LINE_ITEMS.SALES_STAGE
        when N'Closed Lost' then N'Closed Lost'
        when N'Closed Won'  then N'Closed Won'  
        else N'Other'
        end) as SALES_STAGE
     , REVENUE_LINE_ITEMS.EXTENDED_USDOLLAR - isnull(REVENUE_LINE_ITEMS.DISCOUNT_USDOLLAR, 0.0) as AMOUNT_USDOLLAR
     , REVENUE_LINE_ITEMS.DATE_CLOSED
     , month(REVENUE_LINE_ITEMS.DATE_CLOSED) as MONTH_CLOSED
  from            OPPORTUNITIES
       inner join REVENUE_LINE_ITEMS
               on REVENUE_LINE_ITEMS.OPPORTUNITY_ID = OPPORTUNITIES.ID
              and REVENUE_LINE_ITEMS.DELETED        = 0
       inner join USERS
               on USERS.ID                          = OPPORTUNITIES.ASSIGNED_USER_ID
              and USERS.DELETED                     = 0
 where OPPORTUNITIES.DELETED = 0

GO

Grant Select on dbo.vwREVENUE_PipelineMonth to public;
GO

