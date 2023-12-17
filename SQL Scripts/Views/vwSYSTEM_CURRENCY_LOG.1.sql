if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSYSTEM_CURRENCY_LOG')
	Drop View dbo.vwSYSTEM_CURRENCY_LOG;
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
-- 03/18/2021 Paul.  Join to currencies table so that the React client can include subpanel data automatically. 
Create View dbo.vwSYSTEM_CURRENCY_LOG
as
select SYSTEM_CURRENCY_LOG.ID
     , SYSTEM_CURRENCY_LOG.SERVICE_NAME
     , SYSTEM_CURRENCY_LOG.SOURCE_ISO4217
     , SYSTEM_CURRENCY_LOG.DESTINATION_ISO4217
     , SYSTEM_CURRENCY_LOG.CONVERSION_RATE
     , SYSTEM_CURRENCY_LOG.DATE_ENTERED
     , SYSTEM_CURRENCY_LOG.DATE_MODIFIED
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , CURRENCIES.ID         as CURRENCY_ID
  from            SYSTEM_CURRENCY_LOG
  left outer join CURRENCIES
               on CURRENCIES.ISO4217 = SYSTEM_CURRENCY_LOG.DESTINATION_ISO4217
              and CURRENCIES.DELETED = 0
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = SYSTEM_CURRENCY_LOG.CREATED_BY
  left outer join USERS USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = SYSTEM_CURRENCY_LOG.MODIFIED_USER_ID
 where SYSTEM_CURRENCY_LOG.DELETED = 0

GO

Grant Select on dbo.vwSYSTEM_CURRENCY_LOG to public;
GO


