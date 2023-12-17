if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCALLS_CONTACTS_Soap')
	Drop View dbo.vwCALLS_CONTACTS_Soap;
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
-- 06/13/2007 Paul.  The date to return is that of the related object. 
-- 10/25/2009 Paul.  The view needs to include the call if the contact is a parent. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
Create View dbo.vwCALLS_CONTACTS_Soap
as
select CALLS_CONTACTS.CALL_ID    as PRIMARY_ID
     , CALLS_CONTACTS.CONTACT_ID as RELATED_ID
     , CALLS_CONTACTS.DELETED
     , CALLS.DATE_MODIFIED
     , CALLS.DATE_MODIFIED_UTC
     , dbo.fnViewDateTime(CALLS.DATE_START, CALLS.TIME_START) as DATE_START
  from      CALLS_CONTACTS
 inner join CALLS
         on CALLS.ID         = CALLS_CONTACTS.CALL_ID
        and CALLS.DELETED    = CALLS_CONTACTS.DELETED
 inner join CONTACTS
         on CONTACTS.ID      = CALLS_CONTACTS.CONTACT_ID
        and CONTACTS.DELETED = CALLS_CONTACTS.DELETED
 union
select CALLS.ID                  as PRIMARY_ID
     , CONTACTS.ID               as RELATED_ID
     , CALLS.DELETED
     , CALLS.DATE_MODIFIED
     , CALLS.DATE_MODIFIED_UTC
     , dbo.fnViewDateTime(CALLS.DATE_START, CALLS.TIME_START) as DATE_START
  from      CALLS
 inner join CONTACTS
         on CONTACTS.ID      = CALLS.PARENT_ID
        and CONTACTS.DELETED = CALLS.DELETED
 where CALLS.PARENT_TYPE = N'Contacts'

GO

Grant Select on dbo.vwCALLS_CONTACTS_Soap to public;
GO

