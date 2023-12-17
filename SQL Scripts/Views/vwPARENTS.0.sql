if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPARENTS')
	Drop View dbo.vwPARENTS;
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
-- 12/19/2006 Paul.  Include Prospects.  This is so that we can determine if an email is sent to a Contact, Lead or Prospect. 
-- 06/12/2007 Paul.  Include Contracts as contracts can contain notes. 
-- 06/12/2007 Paul.  Include Calls as calls can contain notes. 
-- 06/21/2007 Paul.  Include Products, Quotes, Orders and Invoices so that they can contain notes. 
-- 12/25/2007 Paul.  Include Users so that we can link from Campaign Status/Logs.
-- 08/28/2012 Paul.  Add PHONE_WORK so that it will be easy to display on the Calls detail view. 
-- 01/21/2014 Paul.  Use fnFullName() to build name for Contacts, Leads, Prospects. 
-- 11/05/2014 Paul.  Add ChatChannels module. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 05/07/2022 Paul.  React Client requires Payments. 
Create View dbo.vwPARENTS
as
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Accounts'      as PARENT_TYPE
     , N'Accounts'      as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , PHONE_OFFICE     as PHONE_WORK
  from ACCOUNTS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Bugs'          as PARENT_TYPE
     , N'Bugs'          as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from BUGS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Cases'         as PARENT_TYPE
     , N'Cases'         as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from CASES
 where DELETED = 0
union all
select ID               as PARENT_ID
     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as PARENT_NAME
     , N'Contacts'      as PARENT_TYPE
     , N'Contacts'      as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , PHONE_WORK
  from CONTACTS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Emails'        as PARENT_TYPE
     , N'Emails'        as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from EMAILS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as PARENT_NAME
     , N'Leads'         as PARENT_TYPE
     , N'Leads'         as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , PHONE_WORK
  from LEADS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Opportunities' as PARENT_TYPE
     , N'Opportunities' as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from OPPORTUNITIES
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Project'       as PARENT_TYPE
     , N'Projects'      as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from PROJECT
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'ProjectTask'   as PARENT_TYPE
     , N'ProjectTasks'  as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from PROJECT_TASK
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Campaigns'     as PARENT_TYPE
     , N'Campaigns'     as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from CAMPAIGNS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as PARENT_NAME
     , N'Prospects'     as PARENT_TYPE
     , N'Prospects'     as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , PHONE_WORK
  from PROSPECTS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Contracts'     as PARENT_TYPE
     , N'Contracts'     as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from CONTRACTS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Calls'         as PARENT_TYPE
     , N'Calls'         as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from CALLS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Products'      as PARENT_TYPE
     , N'Products'      as MODULE
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from PRODUCTS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Quotes'        as PARENT_TYPE
     , N'Quotes'        as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from QUOTES
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Orders'        as PARENT_TYPE
     , N'Orders'        as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from ORDERS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Invoices'      as PARENT_TYPE
     , N'Invoices'      as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from INVOICES
 where DELETED = 0
union all
select ID               as PARENT_ID
     , USER_NAME        as PARENT_NAME
     , N'Users'         as PARENT_TYPE
     , N'Users'         as MODULE
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_SET_ID
     , PHONE_WORK
  from USERS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'ChatMessages'  as PARENT_TYPE
     , N'ChatMessages'  as MODULE
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from CHAT_MESSAGES
 where DELETED = 0
union all
select ID               as PARENT_ID
     , PAYMENT_NUM      as PARENT_NAME
     , N'Payments'      as PARENT_TYPE
     , N'Payments'      as MODULE
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_SET_ID
     , cast(null as nvarchar(25)) as PHONE_WORK
  from PAYMENTS
 where DELETED = 0

GO

Grant Select on dbo.vwPARENTS to public;
GO

