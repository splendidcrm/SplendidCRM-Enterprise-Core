if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_MEETINGS_Soap')
	Drop View dbo.vwCONTACTS_MEETINGS_Soap;
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
-- 10/25/2009 Paul.  The view needs to include the meeting if the contact is a parent. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
Create View dbo.vwCONTACTS_MEETINGS_Soap
as
select MEETINGS_CONTACTS.CONTACT_ID as PRIMARY_ID
     , MEETINGS_CONTACTS.MEETING_ID as RELATED_ID
     , MEETINGS_CONTACTS.DELETED
     , MEETINGS.DATE_MODIFIED
     , MEETINGS.DATE_MODIFIED_UTC
     , dbo.fnViewDateTime(MEETINGS.DATE_START, MEETINGS.TIME_START) as DATE_START
  from      MEETINGS_CONTACTS
 inner join MEETINGS
         on MEETINGS.ID      = MEETINGS_CONTACTS.MEETING_ID
        and MEETINGS.DELETED = MEETINGS_CONTACTS.DELETED
 inner join CONTACTS
         on CONTACTS.ID      = MEETINGS_CONTACTS.CONTACT_ID
        and CONTACTS.DELETED = MEETINGS_CONTACTS.DELETED
 union
select CONTACTS.ID                  as PRIMARY_ID
     , MEETINGS.ID                  as RELATED_ID
     , CONTACTS.DELETED
     , MEETINGS.DATE_MODIFIED
     , MEETINGS.DATE_MODIFIED_UTC
     , dbo.fnViewDateTime(MEETINGS.DATE_START, MEETINGS.TIME_START) as DATE_START
  from      CONTACTS
 inner join MEETINGS
         on MEETINGS.PARENT_ID   = CONTACTS.ID
        and MEETINGS.DELETED     = CONTACTS.DELETED
        and MEETINGS.PARENT_TYPE = N'Contacts'

GO

Grant Select on dbo.vwCONTACTS_MEETINGS_Soap to public;
GO

