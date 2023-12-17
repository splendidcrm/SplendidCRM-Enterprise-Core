if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwMODULES_ARCHIVE_RULES')
	Drop View dbo.vwMODULES_ARCHIVE_RULES;
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
Create View dbo.vwMODULES_ARCHIVE_RULES
as
select MODULES_ARCHIVE_RULES.ID
     , MODULES_ARCHIVE_RULES.NAME
     , MODULES_ARCHIVE_RULES.MODULE_NAME
     , MODULES_ARCHIVE_RULES.STATUS
     , MODULES_ARCHIVE_RULES.LIST_ORDER_Y
     , MODULES_ARCHIVE_RULES.DESCRIPTION
     , MODULES_ARCHIVE_RULES.DATE_ENTERED
     , MODULES_ARCHIVE_RULES.DATE_MODIFIED
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , MODULES_ARCHIVE_RULES.FILTER_SQL
     , MODULES_ARCHIVE_RULES.FILTER_XML
  from            MODULES_ARCHIVE_RULES
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = MODULES_ARCHIVE_RULES.CREATED_BY
  left outer join USERS USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = MODULES_ARCHIVE_RULES.MODIFIED_USER_ID
 where MODULES_ARCHIVE_RULES.DELETED = 0

GO

Grant Select on dbo.vwMODULES_ARCHIVE_RULES to public;
GO

