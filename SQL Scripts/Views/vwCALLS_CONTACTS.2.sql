if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_CONTACTS')
	Drop View dbo.vwCALLS_CONTACTS;
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
-- 10/25/2009 Paul.  The view needs to include the call if the contact is a parent. 
-- 07/27/2010 Paul.  Add ACCEPT_STATUS so that it can be references in the layout view. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwCALLS_CONTACTS
as
select CALLS.ID               as CALL_ID
     , CALLS.NAME             as CALL_NAME
     , CALLS.ASSIGNED_USER_ID as CALL_ASSIGNED_USER_ID
     , CALLS.ASSIGNED_SET_ID  as CALL_ASSIGNED_SET_ID
     , CALLS_CONTACTS.ACCEPT_STATUS
     , vwCONTACTS.ID          as CONTACT_ID
     , vwCONTACTS.NAME        as CONTACT_NAME
     , vwCONTACTS.*
  from            CALLS
       inner join CALLS_CONTACTS
               on CALLS_CONTACTS.CALL_ID = CALLS.ID
              and CALLS_CONTACTS.DELETED = 0
       inner join vwCONTACTS
               on vwCONTACTS.ID          = CALLS_CONTACTS.CONTACT_ID
 where CALLS.DELETED = 0
 union all
select CALLS.ID               as CALL_ID
     , CALLS.NAME             as CALL_NAME
     , CALLS.ASSIGNED_USER_ID as CALL_ASSIGNED_USER_ID
     , CALLS.ASSIGNED_SET_ID  as CALL_ASSIGNED_SET_ID
     , CALLS_CONTACTS.ACCEPT_STATUS
     , vwCONTACTS.ID          as CONTACT_ID
     , vwCONTACTS.NAME        as CONTACT_NAME
     , vwCONTACTS.*
  from            CALLS
       inner join vwCONTACTS
               on vwCONTACTS.ID             = CALLS.PARENT_ID
  left outer join CALLS_CONTACTS
               on CALLS_CONTACTS.CALL_ID    = CALLS.ID
              and CALLS_CONTACTS.CONTACT_ID = vwCONTACTS.ID
              and CALLS_CONTACTS.DELETED    = 0
 where CALLS.DELETED     = 0
   and CALLS.PARENT_TYPE = N'Contacts'
   and CALLS_CONTACTS.ID is null

GO

Grant Select on dbo.vwCALLS_CONTACTS to public;
GO

