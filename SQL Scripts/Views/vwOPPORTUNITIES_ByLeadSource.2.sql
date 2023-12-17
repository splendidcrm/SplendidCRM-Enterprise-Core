if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwOPPORTUNITIES_ByLeadSource')
	Drop View dbo.vwOPPORTUNITIES_ByLeadSource;
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
-- 09/20/2005 Paul.  Outer join to TERMINOLOGY just in case the data is missing. 
-- 02/01/2006 Paul.  DB2 does not like comments in the middle of the Create View statement. 
-- 11/27/2006 Paul.  Add TEAM_ID. 
-- 08/30/2009 Paul.  Dynamic teams required an ID and TEAM_SET_ID. 
-- 12/28/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwOPPORTUNITIES_ByLeadSource
as
select OPPORTUNITIES.ID
     , OPPORTUNITIES.SALES_STAGE
     , isnull(OPPORTUNITIES.LEAD_SOURCE, N'') as LEAD_SOURCE
     , OPPORTUNITIES.ASSIGNED_USER_ID
     , OPPORTUNITIES.AMOUNT_USDOLLAR
     , OPPORTUNITIES.TEAM_ID
     , OPPORTUNITIES.TEAM_SET_ID
     , TERMINOLOGY.LIST_ORDER
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
  from            OPPORTUNITIES
       inner join USERS
               on USERS.ID              = OPPORTUNITIES.ASSIGNED_USER_ID
              and USERS.DELETED         = 0
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID      = OPPORTUNITIES.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED = 0
  left outer join TERMINOLOGY
               on TERMINOLOGY.NAME      = OPPORTUNITIES.LEAD_SOURCE
              and TERMINOLOGY.LIST_NAME = N'lead_source_dom'
              and TERMINOLOGY.LANG      = N'en-US'
              and TERMINOLOGY.DELETED   = 0
 where OPPORTUNITIES.DELETED = 0

GO

Grant Select on dbo.vwOPPORTUNITIES_ByLeadSource to public;
GO

