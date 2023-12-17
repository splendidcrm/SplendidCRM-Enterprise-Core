if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwCONTACTS_PASSWORD_LINK')
	Drop View dbo.vwCONTACTS_PASSWORD_LINK;
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
Create View dbo.vwCONTACTS_PASSWORD_LINK
as
select USERS_PASSWORD_LINK.ID           as ID
     , vwCONTACTS_PortalLogin.ID        as CONTACT_ID
     , vwCONTACTS_PortalLogin.PORTAL_NAME
     , vwCONTACTS_PortalLogin.PORTAL_ACTIVE
     , vwCONTACTS_PortalLogin.EMAIL1
  from      USERS_PASSWORD_LINK
 inner join vwCONTACTS_PortalLogin
         on vwCONTACTS_PortalLogin.EMAIL1 = USERS_PASSWORD_LINK.USER_NAME
 where USERS_PASSWORD_LINK.DELETED = 0

GO

Grant Select on dbo.vwCONTACTS_PASSWORD_LINK to public;
GO

