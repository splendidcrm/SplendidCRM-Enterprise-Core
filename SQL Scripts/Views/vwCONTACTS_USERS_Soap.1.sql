if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_USERS_Soap')
	Drop View dbo.vwCONTACTS_USERS_Soap;
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
-- 02/21/2006 Paul.  A valid relationship is one where all three records are valid. 
-- A deleted record is one where the user is valid but the contact and the relationship are deleted. 
-- 06/13/2007 Paul.  The date to return is that of the related object. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 09/18/2015 Paul.  Add SERVICE_NAME to separate Exchange Folders from Contacts Sync. 
Create View dbo.vwCONTACTS_USERS_Soap
as
select CONTACTS_USERS.CONTACT_ID as PRIMARY_ID
     , CONTACTS_USERS.USER_ID    as RELATED_ID
     , CONTACTS_USERS.DELETED
     , CONTACTS.DATE_MODIFIED
     , CONTACTS.DATE_MODIFIED_UTC
     , CONTACTS_USERS.SERVICE_NAME
  from      CONTACTS_USERS
 inner join CONTACTS
         on CONTACTS.ID      = CONTACTS_USERS.CONTACT_ID
        and CONTACTS.DELETED = CONTACTS_USERS.DELETED
 inner join USERS
         on USERS.ID         = CONTACTS_USERS.USER_ID
        and USERS.DELETED    = 0
 where CONTACTS_USERS.SERVICE_NAME is null

GO

Grant Select on dbo.vwCONTACTS_USERS_Soap to public;
GO

