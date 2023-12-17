if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_RELATED_LEADS')
	Drop View dbo.vwCALLS_RELATED_LEADS;
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
Create View dbo.vwCALLS_RELATED_LEADS
as
select ID
     , PARENT_ID as LEAD_ID
  from CALLS
 where PARENT_ID   is not null
   and PARENT_TYPE = N'Leads'
   and DELETED     = 0
union
select CALLS.ID
     , PROSPECTS.LEAD_ID
  from      PROSPECTS
 inner join CALLS
         on CALLS.PARENT_ID   = PROSPECTS.ID
        and CALLS.PARENT_TYPE = N'Prospects'
        and CALLS.DELETED     = 0
 where PROSPECTS.DELETED = 0
   and PROSPECTS.LEAD_ID is not null
union
select CALL_ID
     , LEAD_ID
  from CALLS_LEADS
 where DELETED    = 0

GO

Grant Select on dbo.vwCALLS_RELATED_LEADS to public;
GO

