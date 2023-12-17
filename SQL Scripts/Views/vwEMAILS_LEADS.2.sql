if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_LEADS')
	Drop View dbo.vwEMAILS_LEADS;
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
-- 10/28/2007 Paul.  The include the email parent, but not union all so that duplicates will get filtered. 
-- 10/28/2007 Paul.  We will use a union all here because LEAD_SOURCE_DESCRIPTION is displayed in sub panels.  
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwEMAILS_LEADS
as
select EMAILS.ID               as EMAIL_ID
     , EMAILS.NAME             as EMAIL_NAME
     , EMAILS.ASSIGNED_USER_ID as EMAIL_ASSIGNED_USER_ID
     , EMAILS.ASSIGNED_SET_ID  as EMAIL_ASSIGNED_SET_ID
     , vwLEADS.ID              as LEAD_ID
     , vwLEADS.NAME            as LEAD_NAME
     , vwLEADS.*
  from            EMAILS
       inner join EMAILS_LEADS
               on EMAILS_LEADS.EMAIL_ID = EMAILS.ID
              and EMAILS_LEADS.DELETED  = 0
       inner join vwLEADS
               on vwLEADS.ID            = EMAILS_LEADS.LEAD_ID
 where EMAILS.DELETED = 0
union all
select EMAILS.ID               as EMAIL_ID
     , EMAILS.NAME             as EMAIL_NAME
     , EMAILS.ASSIGNED_USER_ID as EMAIL_ASSIGNED_USER_ID
     , EMAILS.ASSIGNED_SET_ID  as EMAIL_ASSIGNED_SET_ID
     , vwLEADS.ID              as LEAD_ID
     , vwLEADS.NAME            as LEAD_NAME
     , vwLEADS.*
  from            EMAILS
       inner join vwLEADS
               on vwLEADS.ID            = EMAILS.PARENT_ID
-- 10/28/2007 Paul.  Filter duplicates with an outer join. 
  left outer join EMAILS_LEADS
               on EMAILS_LEADS.EMAIL_ID = EMAILS.ID
              and EMAILS_LEADS.LEAD_ID  = vwLEADS.ID
              and EMAILS_LEADS.DELETED  = 0
 where EMAILS.DELETED     = 0
   and EMAILS.PARENT_TYPE = N'Leads'
   and EMAILS_LEADS.ID is null

GO

Grant Select on dbo.vwEMAILS_LEADS to public;
GO

