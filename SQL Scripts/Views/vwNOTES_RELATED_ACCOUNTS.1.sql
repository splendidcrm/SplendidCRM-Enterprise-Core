if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwNOTES_RELATED_ACCOUNTS')
	Drop View dbo.vwNOTES_RELATED_ACCOUNTS;
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
-- 12/05/2017 Paul.  Include Opportunities activities under account. 
Create View dbo.vwNOTES_RELATED_ACCOUNTS
as
select ID
     , PARENT_ID as ACCOUNT_ID
  from NOTES
 where PARENT_ID   is not null
   and PARENT_TYPE = N'Accounts'
   and DELETED     = 0
union
select NOTES.ID
     , ACCOUNTS_CONTACTS.ACCOUNT_ID
  from      ACCOUNTS_CONTACTS
 inner join NOTES
         on NOTES.PARENT_ID   = ACCOUNTS_CONTACTS.CONTACT_ID
        and NOTES.PARENT_TYPE = N'Contacts'
        and NOTES.DELETED     = 0
 where ACCOUNTS_CONTACTS.DELETED = 0
union
select NOTES.ID
     , ACCOUNTS_OPPORTUNITIES.ACCOUNT_ID
  from      ACCOUNTS_OPPORTUNITIES
 inner join NOTES
         on NOTES.PARENT_ID   = ACCOUNTS_OPPORTUNITIES.OPPORTUNITY_ID
        and NOTES.PARENT_TYPE = N'Opportunities'
        and NOTES.DELETED     = 0
 where ACCOUNTS_OPPORTUNITIES.DELETED = 0
union
select NOTES.ID
     , LEADS.ACCOUNT_ID
  from      LEADS
 inner join NOTES
         on NOTES.PARENT_ID   = LEADS.ID
        and NOTES.PARENT_TYPE = N'Leads'
        and NOTES.DELETED     = 0
 where LEADS.DELETED = 0
union
select NOTES.ID
     , ACCOUNTS_CONTACTS.ACCOUNT_ID
  from      ACCOUNTS_CONTACTS
 inner join LEADS_CONTACTS
         on LEADS_CONTACTS.CONTACT_ID = ACCOUNTS_CONTACTS.CONTACT_ID
        and LEADS_CONTACTS.DELETED    = 0
 inner join NOTES
         on NOTES.PARENT_ID   = LEADS_CONTACTS.LEAD_ID
        and NOTES.PARENT_TYPE = N'Leads'
        and NOTES.DELETED     = 0
 where ACCOUNTS_CONTACTS.DELETED = 0

GO

Grant Select on dbo.vwNOTES_RELATED_ACCOUNTS to public;
GO

