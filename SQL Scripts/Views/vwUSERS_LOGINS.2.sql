if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwUSERS_LOGINS')
	Drop View dbo.vwUSERS_LOGINS;
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
-- 07/08/2018 Paul.  The ID is needed for export. 
-- 03/27/2019 Paul.  Every searchable view should have a NAME field. 
-- 10/30/2020 Paul.  DATE_ENTERED for the React Client. 
Create View dbo.vwUSERS_LOGINS
as
select USERS_LOGINS.ID
     , USERS_LOGINS.USER_ID
     , USERS_LOGINS.USER_NAME
     , USERS_LOGINS.LOGIN_TYPE
     , USERS_LOGINS.LOGIN_DATE
     , USERS_LOGINS.LOGOUT_DATE
     , USERS_LOGINS.LOGIN_STATUS
     , USERS_LOGINS.ASPNET_SESSIONID
     , USERS_LOGINS.REMOTE_HOST
     , USERS_LOGINS.TARGET
     , USERS_LOGINS.USER_AGENT
     , USERS_LOGINS.DATE_MODIFIED
     , USERS_LOGINS.DATE_ENTERED
     , vwUSERS.FULL_NAME
     , vwUSERS.IS_ADMIN
     , vwUSERS.STATUS
     , USERS_LOGINS.USER_NAME        as NAME
  from            USERS_LOGINS
  left outer join vwUSERS
               on vwUSERS.ID = USERS_LOGINS.USER_ID

GO

Grant Select on dbo.vwUSERS_LOGINS to public;
GO

