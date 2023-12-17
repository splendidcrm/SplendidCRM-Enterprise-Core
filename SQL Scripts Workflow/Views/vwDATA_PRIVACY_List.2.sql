if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwDATA_PRIVACY_List')
	Drop View dbo.vwDATA_PRIVACY_List;
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
Create View dbo.vwDATA_PRIVACY_List
as
select vwDATA_PRIVACY.*
     , CONTACTS.ID               as CONTACT_ID
     , CONTACTS.ASSIGNED_USER_ID as CONTACT_ASSIGNED_USER_ID
     , CONTACTS.ASSIGNED_SET_ID  as CONTACT_ASSIGNED_SET_ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as CONTACT_NAME
     , CONTACTS.EMAIL1           as CONTACT_EMAIL1
     , CONTACTS.EMAIL2           as CONTACT_EMAIL2
  from            vwDATA_PRIVACY
  left outer join CONTACTS_DATA_PRIVACY
               on CONTACTS_DATA_PRIVACY.DATA_PRIVACY_ID = vwDATA_PRIVACY.ID
              and CONTACTS_DATA_PRIVACY.DELETED         = 0
              and CONTACTS_DATA_PRIVACY.CONTACT_ID      = dbo.fnCONTACTS_DATA_PRIVACY_Primary(vwDATA_PRIVACY.ID)
  left outer join CONTACTS
               on CONTACTS.ID                           = CONTACTS_DATA_PRIVACY.CONTACT_ID
              and CONTACTS.DELETED                       = 0

GO

Grant Select on dbo.vwDATA_PRIVACY_List to public;
GO

