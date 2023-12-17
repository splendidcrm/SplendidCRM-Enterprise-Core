if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_CASES')
	Drop View dbo.vwCONTACTS_CASES;
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
-- 11/11/2013 Paul.  Use a union so that his view can also be used when in B2C mode. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwCONTACTS_CASES
as
select CONTACTS.ID               as CONTACT_ID
     , CONTACTS.ASSIGNED_USER_ID as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID  as CONTACT_ASSIGNED_SET_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
     , vwCASES.ID                as CASE_ID
     , vwCASES.NAME              as CASE_NAME
     , vwCASES.*
  from           CONTACTS
      inner join CONTACTS_CASES
              on CONTACTS_CASES.CONTACT_ID = CONTACTS.ID
             and CONTACTS_CASES.DELETED    = 0
      inner join vwCASES
              on vwCASES.ID                = CONTACTS_CASES.CASE_ID
 where CONTACTS.DELETED = 0
union
select CONTACTS.ID               as CONTACT_ID
     , CONTACTS.ASSIGNED_USER_ID as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID  as CONTACT_ASSIGNED_SET_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
     , vwCASES.ID                as CASE_ID
     , vwCASES.NAME              as CASE_NAME
     , vwCASES.*
  from           CONTACTS
      inner join vwCASES
              on vwCASES.B2C_CONTACT_ID = CONTACTS.ID
 where CONTACTS.DELETED = 0

GO

Grant Select on dbo.vwCONTACTS_CASES to public;
GO


