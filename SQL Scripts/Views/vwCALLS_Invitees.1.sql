if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_Invitees')
	Drop View dbo.vwCALLS_Invitees;
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
-- 04/01/2012 Paul.  Add Calls/Leads relationship. 
Create View dbo.vwCALLS_Invitees
as
select CALL_ID
     , CONTACT_ID  as INVITEE_ID
     , N'Contacts' as INVITEE_TYPE
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as INVITEE_NAME
  from      CALLS_CONTACTS
 inner join CONTACTS
         on CONTACTS.ID       = CALLS_CONTACTS.CONTACT_ID
        and CONTACTS.DELETED  = 0
 where CALLS_CONTACTS.DELETED = 0
union all
select CALL_ID
     , USER_ID     as INVITEE_ID
     , N'Users'    as INVITEE_TYPE
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as INVITEE_NAME
  from      CALLS_USERS
 inner join USERS
         on USERS.ID          = CALLS_USERS.USER_ID
        and USERS.DELETED     = 0
 where CALLS_USERS.DELETED    = 0
union all
select CALL_ID
     , LEAD_ID  as INVITEE_ID
     , N'Leads' as INVITEE_TYPE
     , dbo.fnFullName(LEADS.FIRST_NAME, LEADS.LAST_NAME) as INVITEE_NAME
  from      CALLS_LEADS
 inner join LEADS
         on LEADS.ID       = CALLS_LEADS.LEAD_ID
        and LEADS.DELETED  = 0
 where CALLS_LEADS.DELETED = 0

GO

Grant Select on dbo.vwCALLS_Invitees to public;
GO

