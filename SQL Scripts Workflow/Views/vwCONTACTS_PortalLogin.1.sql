if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_PortalLogin')
	Drop View dbo.vwCONTACTS_PortalLogin;
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
-- 06/29/2010 Paul.  Add EMAIL1 to help with Forgot Password. 
-- 06/29/2010 Paul.  Add PORTAL_ACTIVE to help with Forgot Password. 
Create View dbo.vwCONTACTS_PortalLogin
as
select CONTACTS.ID
     , dbo.fnFullName(CONTACTS.FIRST_NAME, CONTACTS.LAST_NAME) as FULL_NAME
     , CONTACTS.PORTAL_NAME
     , CONTACTS.PORTAL_PASSWORD
     , CONTACTS.PORTAL_ACTIVE
     , CONTACTS.FIRST_NAME
     , CONTACTS.LAST_NAME
     , CONTACTS.EMAIL1
     , TEAMS.ID            as TEAM_ID
     , TEAMS.NAME          as TEAM_NAME
  from            CONTACTS
       inner join USERS
               on USERS.ID                 = CONTACTS.ID
              and USERS.DELETED            = 0
  left outer join TEAM_MEMBERSHIPS
               on TEAM_MEMBERSHIPS.USER_ID = USERS.ID
              and TEAM_MEMBERSHIPS.PRIVATE = 1
              and TEAM_MEMBERSHIPS.DELETED = 0
  left outer join TEAMS
               on TEAMS.ID                 = TEAM_MEMBERSHIPS.TEAM_ID
              and TEAMS.DELETED            = 0
 where CONTACTS.DELETED = 0
   and (USERS.STATUS is null or USERS.STATUS = N'Active')
   and CONTACTS.PORTAL_ACTIVE = 1


GO

Grant Select on dbo.vwCONTACTS_PortalLogin to public;
GO


