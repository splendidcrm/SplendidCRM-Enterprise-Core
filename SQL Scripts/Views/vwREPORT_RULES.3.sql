if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwREPORT_RULES')
	Drop View dbo.vwREPORT_RULES;
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
-- 05/19/2021 Paul.  ReportRules is based off of RULES table, but does not apply team filter, nor is it assigned. 
Create View dbo.vwREPORT_RULES
as
select RULES.ID
     , RULES.NAME
     , RULES.MODULE_NAME
     , RULES.RULE_TYPE
     , RULES.DESCRIPTION
     , RULES.DATE_ENTERED
     , RULES.DATE_MODIFIED
     , RULES.DATE_MODIFIED_UTC
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
  from            RULES
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = RULES.CREATED_BY
  left outer join USERS USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = RULES.MODIFIED_USER_ID
 where RULES.DELETED = 0
   and RULE_TYPE = N'Report'

GO

Grant Select on dbo.vwREPORT_RULES to public;
GO

