if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_RELATED_CONTACTS')
	Drop View dbo.vwEMAILS_RELATED_CONTACTS;
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
Create View dbo.vwEMAILS_RELATED_CONTACTS
as
select ID
     , PARENT_ID as CONTACT_ID
  from EMAILS
 where PARENT_ID   is not null
   and PARENT_TYPE = N'Contacts'
   and DELETED     = 0
union
select EMAILS.ID
     , LEADS.CONTACT_ID
  from      LEADS
 inner join EMAILS
         on EMAILS.PARENT_ID   = LEADS.ID
        and EMAILS.PARENT_TYPE = N'Leads'
        and EMAILS.DELETED     = 0
 where LEADS.DELETED = 0
   and LEADS.CONTACT_ID is not null
union
select EMAIL_ID
     , CONTACT_ID
  from EMAILS_CONTACTS
 where DELETED    = 0
union
select EMAIL_ID
     , LEADS.CONTACT_ID
  from      LEADS
 inner join EMAILS_LEADS
         on EMAILS_LEADS.LEAD_ID = LEADS.ID
        and EMAILS_LEADS.DELETED = 0
 where LEADS.DELETED     = 0
union
select EMAILS.ID
     , LEADS_CONTACTS.CONTACT_ID
  from      LEADS_CONTACTS
 inner join EMAILS
         on EMAILS.PARENT_ID   = LEADS_CONTACTS.LEAD_ID
        and EMAILS.PARENT_TYPE = N'Leads'
        and EMAILS.DELETED     = 0
 where LEADS_CONTACTS.DELETED = 0
union
select EMAILS.ID
     , LEADS.CONTACT_ID
  from      LEADS
 inner join PROSPECTS
         on PROSPECTS.LEAD_ID = LEADS.ID
        and PROSPECTS.DELETED = 0
 inner join EMAILS
         on EMAILS.PARENT_ID   = PROSPECTS.ID
        and EMAILS.PARENT_TYPE = N'Prospects'
        and EMAILS.DELETED     = 0
 where LEADS.DELETED = 0
   and LEADS.CONTACT_ID is not null
union
select EMAILS.ID
     , LEADS_CONTACTS.CONTACT_ID
  from      LEADS_CONTACTS
 inner join PROSPECTS
         on PROSPECTS.LEAD_ID = LEADS_CONTACTS.LEAD_ID
        and PROSPECTS.DELETED = 0
 inner join EMAILS
         on EMAILS.PARENT_ID   = PROSPECTS.ID
        and EMAILS.PARENT_TYPE = N'Prospects'
        and EMAILS.DELETED     = 0
 where LEADS_CONTACTS.DELETED = 0
union
select EMAIL_ID
     , LEADS.CONTACT_ID
  from      LEADS
 inner join PROSPECTS
         on PROSPECTS.LEAD_ID = LEADS.ID
        and PROSPECTS.DELETED = 0
 inner join EMAILS_PROSPECTS
         on EMAILS_PROSPECTS.PROSPECT_ID = PROSPECTS.ID
        and EMAILS_PROSPECTS.DELETED     = 0
 where LEADS.DELETED     = 0

GO

Grant Select on dbo.vwEMAILS_RELATED_CONTACTS to public;
GO

