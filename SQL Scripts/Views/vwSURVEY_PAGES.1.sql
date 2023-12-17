if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_PAGES')
	Drop View dbo.vwSURVEY_PAGES;
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
Create View dbo.vwSURVEY_PAGES
as
select SURVEY_PAGES.ID
     , SURVEY_PAGES.NAME
     , SURVEY_PAGES.PAGE_NUMBER
     , SURVEY_PAGES.QUESTION_RANDOMIZATION
     , SURVEY_PAGES.DESCRIPTION
     , SURVEY_PAGES.DATE_ENTERED
     , SURVEY_PAGES.DATE_MODIFIED
     , SURVEY_PAGES.DATE_MODIFIED_UTC
     , SURVEYS.ID                  as SURVEY_ID
     , SURVEYS.NAME                as SURVEY_NAME
     , SURVEYS.ASSIGNED_USER_ID    as ASSIGNED_USER_ID
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , SURVEY_PAGES.CREATED_BY     as CREATED_BY_ID
     , SURVEY_PAGES.MODIFIED_USER_ID
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
  from            SURVEY_PAGES
  left outer join SURVEYS
               on SURVEYS.ID               = SURVEY_PAGES.SURVEY_ID
  left outer join USERS                      USERS_CREATED_BY
               on USERS_CREATED_BY.ID      = SURVEY_PAGES.CREATED_BY
  left outer join USERS                      USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID     = SURVEY_PAGES.MODIFIED_USER_ID
 where SURVEY_PAGES.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_PAGES to public;
GO


