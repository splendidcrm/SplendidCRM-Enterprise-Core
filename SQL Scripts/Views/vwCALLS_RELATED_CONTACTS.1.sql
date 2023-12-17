if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_RELATED_CONTACTS')
	Drop View dbo.vwCALLS_RELATED_CONTACTS;
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
Create View dbo.vwCALLS_RELATED_CONTACTS
as
select ID
     , PARENT_ID as CONTACT_ID
  from CALLS
 where PARENT_ID   is not null
   and PARENT_TYPE = N'Contacts'
   and DELETED     = 0
union
select CALLS.ID
     , LEADS.CONTACT_ID
  from      LEADS
 inner join CALLS
         on CALLS.PARENT_ID   = LEADS.ID
        and CALLS.PARENT_TYPE = N'Leads'
        and CALLS.DELETED     = 0
 where LEADS.DELETED = 0
   and LEADS.CONTACT_ID is not null
union
select CALL_ID
     , CONTACT_ID
  from CALLS_CONTACTS
 where DELETED    = 0
union
select CALL_ID
     , LEADS.CONTACT_ID
  from      LEADS
 inner join CALLS_LEADS
         on CALLS_LEADS.LEAD_ID = LEADS.ID
        and CALLS_LEADS.DELETED = 0
 where LEADS.DELETED     = 0
union
select CALLS.ID
     , LEADS_CONTACTS.CONTACT_ID
  from      LEADS_CONTACTS
 inner join CALLS
         on CALLS.PARENT_ID   = LEADS_CONTACTS.LEAD_ID
        and CALLS.PARENT_TYPE = N'Leads'
        and CALLS.DELETED     = 0
 where LEADS_CONTACTS.DELETED = 0
union
select CALLS.ID
     , LEADS.CONTACT_ID
  from      LEADS
 inner join PROSPECTS
         on PROSPECTS.LEAD_ID = LEADS.ID
        and PROSPECTS.DELETED = 0
 inner join CALLS
         on CALLS.PARENT_ID   = PROSPECTS.ID
        and CALLS.PARENT_TYPE = N'Prospects'
        and CALLS.DELETED     = 0
 where LEADS.DELETED = 0
   and LEADS.CONTACT_ID is not null
union
select CALLS.ID
     , LEADS_CONTACTS.CONTACT_ID
  from      LEADS_CONTACTS
 inner join PROSPECTS
         on PROSPECTS.LEAD_ID = LEADS_CONTACTS.LEAD_ID
        and PROSPECTS.DELETED = 0
 inner join CALLS
         on CALLS.PARENT_ID   = PROSPECTS.ID
        and CALLS.PARENT_TYPE = N'Prospects'
        and CALLS.DELETED     = 0
 where LEADS_CONTACTS.DELETED = 0

GO

Grant Select on dbo.vwCALLS_RELATED_CONTACTS to public;
GO

