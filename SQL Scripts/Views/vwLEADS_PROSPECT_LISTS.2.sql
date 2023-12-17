if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwLEADS_PROSPECT_LISTS')
	Drop View dbo.vwLEADS_PROSPECT_LISTS;
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
Create View dbo.vwLEADS_PROSPECT_LISTS
as
select LEADS.ID                   as LEAD_ID
     , dbo.fnFullName(LEADS.FIRST_NAME, LEADS.LAST_NAME) as LEAD_NAME
     , LEADS.ASSIGNED_USER_ID     as LEAD_ASSIGNED_USER_ID
     , LEADS.ASSIGNED_SET_ID      as LEAD_ASSIGNED_SET_ID
     , vwPROSPECT_LISTS.ID        as PROSPECT_LIST_ID
     , vwPROSPECT_LISTS.NAME      as PROSPECT_LIST_NAME
     , vwPROSPECT_LISTS.*
     , (select count(*)
          from PROSPECT_LISTS_PROSPECTS
         where PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID = vwPROSPECT_LISTS.ID
           and PROSPECT_LISTS_PROSPECTS.DELETED          = 0
       ) as ENTRIES
  from            LEADS
       inner join PROSPECT_LISTS_PROSPECTS
               on PROSPECT_LISTS_PROSPECTS.RELATED_ID   = LEADS.ID
              and PROSPECT_LISTS_PROSPECTS.RELATED_TYPE = N'Leads'
              and PROSPECT_LISTS_PROSPECTS.DELETED      = 0
       inner join vwPROSPECT_LISTS
               on vwPROSPECT_LISTS.ID                   = PROSPECT_LISTS_PROSPECTS.PROSPECT_LIST_ID
 where LEADS.DELETED = 0

GO

Grant Select on dbo.vwLEADS_PROSPECT_LISTS to public;
GO

