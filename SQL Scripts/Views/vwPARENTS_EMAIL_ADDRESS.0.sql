if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwPARENTS_EMAIL_ADDRESS')
	Drop View dbo.vwPARENTS_EMAIL_ADDRESS;
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
-- 12/19/2006 Paul.  For performance, create a parent view with just Contacts, Leads and Prospects. 
-- 05/17/2008 Paul.  Include Accounts and Users so that this view can be used in spEMAILS_QueueEmailTemplate. 
-- 05/17/2008 Paul.  Also include EMAIL1. 
-- 10/15/2012 Paul.  Portal users need to be excluded as it is overlapping the Contacts record and causing a problem with Email Templates. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwPARENTS_EMAIL_ADDRESS
as
select ID               as PARENT_ID
     , NAME             as PARENT_NAME
     , N'Accounts'      as PARENT_TYPE
     , N'Accounts'      as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , EMAIL1           as EMAIL1
  from ACCOUNTS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as PARENT_NAME
     , N'Contacts'      as PARENT_TYPE
     , N'Contacts'      as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , EMAIL1           as EMAIL1
  from CONTACTS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as PARENT_NAME
     , N'Leads'         as PARENT_TYPE
     , N'Leads'         as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , EMAIL1           as EMAIL1
  from LEADS
 where DELETED = 0
union all
select ID               as PARENT_ID
     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as PARENT_NAME
     , N'Prospects'     as PARENT_TYPE
     , N'Prospects'     as MODULE
     , ASSIGNED_USER_ID as PARENT_ASSIGNED_USER_ID
     , ASSIGNED_SET_ID  as PARENT_ASSIGNED_SET_ID
     , EMAIL1           as EMAIL1
  from PROSPECTS
union all
select ID               as PARENT_ID
     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as PARENT_NAME
     , N'Users'         as PARENT_TYPE
     , N'Users'         as MODULE
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_USER_ID
     , cast(null as uniqueidentifier) as PARENT_ASSIGNED_SET_ID
     , EMAIL1           as EMAIL1
  from USERS
 where (PORTAL_ONLY is null or PORTAL_ONLY = 0)
   and DELETED = 0

GO

Grant Select on dbo.vwPARENTS_EMAIL_ADDRESS to public;
GO

