if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwEXCHANGE_ADDIN_LOGINS')
	Drop View dbo.vwEXCHANGE_ADDIN_LOGINS;
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
Create View dbo.vwEXCHANGE_ADDIN_LOGINS
as
select EXCHANGE_ADDIN_LOGINS.ID
     , EXCHANGE_ADDIN_LOGINS.ASSIGNED_USER_ID
     , EXCHANGE_ADDIN_LOGINS.EXCHANGE_USER_ID
     , dbo.fnFullName(USERS.FIRST_NAME, USERS.LAST_NAME) as NAME
     , USERS.USER_NAME                                   as USER_NAME
     , USERS.EMAIL1                                      as EMAIL1
     , USERS.ID                                          as USER_ID
  from      EXCHANGE_ADDIN_LOGINS
 inner join USERS
         on USERS.ID      = EXCHANGE_ADDIN_LOGINS.ASSIGNED_USER_ID
        and USERS.DELETED = 0
 where EXCHANGE_ADDIN_LOGINS.DELETED = 0
   and USERS.STATUS = N'Active'

GO

Grant Select on dbo.vwEXCHANGE_ADDIN_LOGINS to public;
GO


