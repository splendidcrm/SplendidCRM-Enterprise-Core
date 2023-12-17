if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_CONTACTS_Soap')
	Drop View dbo.vwACCOUNTS_CONTACTS_Soap;
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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
Create View dbo.vwACCOUNTS_CONTACTS_Soap
as
select ACCOUNTS_CONTACTS.ACCOUNT_ID as PRIMARY_ID
     , ACCOUNTS_CONTACTS.CONTACT_ID as RELATED_ID
     , ACCOUNTS_CONTACTS.DELETED
     , CONTACTS.DATE_MODIFIED
     , CONTACTS.DATE_MODIFIED_UTC
  from      ACCOUNTS_CONTACTS
 inner join ACCOUNTS
         on ACCOUNTS.ID      = ACCOUNTS_CONTACTS.ACCOUNT_ID
        and ACCOUNTS.DELETED = ACCOUNTS_CONTACTS.DELETED
 inner join CONTACTS
         on CONTACTS.ID      = ACCOUNTS_CONTACTS.CONTACT_ID
        and CONTACTS.DELETED = ACCOUNTS_CONTACTS.DELETED

GO

Grant Select on dbo.vwACCOUNTS_CONTACTS_Soap to public;
GO

