if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCHAT_MESSAGES_RELATED_ACCOUNTS')
	Drop View dbo.vwCHAT_MESSAGES_RELATED_ACCOUNTS;
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
Create View dbo.vwCHAT_MESSAGES_RELATED_ACCOUNTS
as
select ID
     , PARENT_ID as ACCOUNT_ID
  from CHAT_MESSAGES
 where PARENT_ID   is not null
   and PARENT_TYPE = N'Accounts'
   and DELETED     = 0
union
select CHAT_MESSAGES.ID
     , CHAT_CHANNELS.PARENT_ID as ACCOUNT_ID
  from      CHAT_CHANNELS
 inner join CHAT_MESSAGES
         on CHAT_MESSAGES.CHAT_CHANNEL_ID = CHAT_CHANNELS.ID
        and CHAT_MESSAGES.DELETED         = 0
 where CHAT_CHANNELS.PARENT_ID   is not null
   and CHAT_CHANNELS.PARENT_TYPE = N'Accounts'
   and CHAT_CHANNELS.DELETED     = 0
union
select CHAT_MESSAGES.ID
     , ACCOUNTS_CONTACTS.ACCOUNT_ID
  from      ACCOUNTS_CONTACTS
 inner join CHAT_MESSAGES
         on CHAT_MESSAGES.PARENT_ID   = ACCOUNTS_CONTACTS.CONTACT_ID
        and CHAT_MESSAGES.PARENT_TYPE = N'Contacts'
        and CHAT_MESSAGES.DELETED     = 0
 where ACCOUNTS_CONTACTS.DELETED = 0
union
select CHAT_MESSAGES.ID
     , ACCOUNTS_OPPORTUNITIES.ACCOUNT_ID
  from      ACCOUNTS_OPPORTUNITIES
 inner join CHAT_MESSAGES
         on CHAT_MESSAGES.PARENT_ID   = ACCOUNTS_OPPORTUNITIES.OPPORTUNITY_ID
        and CHAT_MESSAGES.PARENT_TYPE = N'Opportunities'
        and CHAT_MESSAGES.DELETED     = 0
 where ACCOUNTS_OPPORTUNITIES.DELETED = 0
union
select CHAT_MESSAGES.ID
     , ACCOUNTS_CONTACTS.ACCOUNT_ID
  from      ACCOUNTS_CONTACTS
 inner join CHAT_CHANNELS
         on CHAT_CHANNELS.PARENT_ID       = ACCOUNTS_CONTACTS.CONTACT_ID
        and CHAT_CHANNELS.PARENT_TYPE     = N'Contacts'
        and CHAT_CHANNELS.DELETED         = 0
 inner join CHAT_MESSAGES
         on CHAT_MESSAGES.CHAT_CHANNEL_ID = CHAT_CHANNELS.ID
        and CHAT_MESSAGES.DELETED         = 0
 where ACCOUNTS_CONTACTS.DELETED = 0
union
select CHAT_MESSAGES.ID
     , LEADS.ACCOUNT_ID
  from      LEADS
 inner join CHAT_MESSAGES
         on CHAT_MESSAGES.PARENT_ID   = LEADS.ID
        and CHAT_MESSAGES.PARENT_TYPE = N'Leads'
        and CHAT_MESSAGES.DELETED     = 0
 where LEADS.DELETED = 0
union
select CHAT_MESSAGES.ID
     , LEADS.ACCOUNT_ID
  from      LEADS
 inner join CHAT_CHANNELS
         on CHAT_CHANNELS.PARENT_ID       = LEADS.ID
        and CHAT_CHANNELS.PARENT_TYPE     = N'Leads'
        and CHAT_CHANNELS.DELETED         = 0
 inner join CHAT_MESSAGES
         on CHAT_MESSAGES.CHAT_CHANNEL_ID = CHAT_CHANNELS.ID
        and CHAT_MESSAGES.DELETED         = 0
 where LEADS.DELETED = 0

GO

Grant Select on dbo.vwCHAT_MESSAGES_RELATED_ACCOUNTS to public;
GO

