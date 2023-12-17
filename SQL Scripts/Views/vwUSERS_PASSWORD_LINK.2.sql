if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSERS_PASSWORD_LINK')
	Drop View dbo.vwUSERS_PASSWORD_LINK;
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
Create View dbo.vwUSERS_PASSWORD_LINK
as
select USERS_PASSWORD_LINK.ID  as ID
     , vwUSERS_Login.ID        as USER_ID
     , vwUSERS_Login.USER_NAME as USER_NAME
  from      USERS_PASSWORD_LINK
 inner join vwUSERS_Login
         on vwUSERS_Login.USER_NAME = USERS_PASSWORD_LINK.USER_NAME
 where USERS_PASSWORD_LINK.DELETED = 0

GO

Grant Select on dbo.vwUSERS_PASSWORD_LINK to public;
GO

