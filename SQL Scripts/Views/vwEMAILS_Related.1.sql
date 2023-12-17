if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEMAILS_Related')
	Drop View dbo.vwEMAILS_Related;
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
Create View dbo.vwEMAILS_Related
as
select ID           as EMAIL_ID
     , PARENT_TYPE
     , PARENT_ID
  from EMAILS
 where DELETED = 0
   and PARENT_ID is not null
union
select EMAIL_ID
     , N'Accounts'      as PARENT_TYPE
     , ACCOUNT_ID       as PARENT_ID
  from EMAILS_ACCOUNTS
 where DELETED = 0
union
select EMAIL_ID
     , N'Bugs'          as PARENT_TYPE
     , BUG_ID           as PARENT_ID
  from EMAILS_BUGS
 where DELETED = 0
union
select EMAIL_ID
     , N'Cases'         as PARENT_TYPE
     , CASE_ID          as PARENT_ID
  from EMAILS_CASES
 where DELETED = 0
union
select EMAIL_ID
     , N'Contacts'      as PARENT_TYPE
     , CONTACT_ID       as PARENT_ID
  from EMAILS_CONTACTS
 where DELETED = 0
union
select EMAIL_ID
     , N'Contracts'     as PARENT_TYPE
     , CONTRACT_ID      as PARENT_ID
  from EMAILS_CONTRACTS
 where DELETED = 0
union
select EMAIL_ID
     , N'Invoices'      as PARENT_TYPE
     , INVOICE_ID       as PARENT_ID
  from EMAILS_INVOICES
 where DELETED = 0
union
select EMAIL_ID
     , N'Leads'         as PARENT_TYPE
     , LEAD_ID          as PARENT_ID
  from EMAILS_LEADS
 where DELETED = 0
union
select EMAIL_ID
     , N'Opportunities' as PARENT_TYPE
     , OPPORTUNITY_ID   as PARENT_ID
  from EMAILS_OPPORTUNITIES
 where DELETED = 0
union
select EMAIL_ID
     , N'Orders'        as PARENT_TYPE
     , ORDER_ID         as PARENT_ID
  from EMAILS_ORDERS
 where DELETED = 0
union
select EMAIL_ID
     , N'ProjectTask'   as PARENT_TYPE
     , PROJECT_TASK_ID  as PARENT_ID
  from EMAILS_PROJECT_TASKS
 where DELETED = 0
union
select EMAIL_ID
     , N'Project'       as PARENT_TYPE
     , PROJECT_ID       as PARENT_ID
  from EMAILS_PROJECTS
 where DELETED = 0
union
select EMAIL_ID
     , N'Prospects'     as PARENT_TYPE
     , PROSPECT_ID      as PARENT_ID
  from EMAILS_PROSPECTS
 where DELETED = 0
union
select EMAIL_ID
     , N'Quotes'        as PARENT_TYPE
     , QUOTE_ID         as PARENT_ID
  from EMAILS_QUOTES
 where DELETED = 0
union
select EMAIL_ID
     , N'Tasks'         as PARENT_TYPE
     , TASK_ID          as PARENT_ID
  from EMAILS_TASKS
 where DELETED = 0
union
select EMAIL_ID
     , N'Users'         as PARENT_TYPE
     , USER_ID          as PARENT_ID
  from EMAILS_USERS
 where DELETED = 0

GO

Grant Select on dbo.vwEMAILS_Related to public;
GO

 
