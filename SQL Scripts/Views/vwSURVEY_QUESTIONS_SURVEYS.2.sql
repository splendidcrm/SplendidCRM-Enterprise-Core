if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_QUESTIONS_SURVEYS')
	Drop View dbo.vwSURVEY_QUESTIONS_SURVEYS;
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
Create View dbo.vwSURVEY_QUESTIONS_SURVEYS
as
select SURVEY_QUESTIONS.ID               as SURVEY_QUESTION_ID
     , SURVEY_QUESTIONS.NAME             as SURVEY_QUESTION_NAME
     , SURVEY_QUESTIONS.ASSIGNED_USER_ID as SURVEY_QUESTION_ASSIGNED_USER
     , SURVEY_PAGES_QUESTIONS.QUESTION_NUMBER
     , SURVEY_PAGES.ID                   as SURVEY_PAGE_ID
     , SURVEY_PAGES.NAME                 as SURVEY_PAGE_NAME
     , vwSURVEYS.ID                      as SURVEY_ID
     , vwSURVEYS.NAME                    as SURVEY_NAME
     , vwSURVEYS.*
  from           SURVEY_QUESTIONS
      inner join SURVEY_PAGES_QUESTIONS
              on SURVEY_PAGES_QUESTIONS.SURVEY_QUESTION_ID = SURVEY_QUESTIONS.ID
             and SURVEY_PAGES_QUESTIONS.DELETED            = 0
      inner join SURVEY_PAGES
              on SURVEY_PAGES.ID                           = SURVEY_PAGES_QUESTIONS.SURVEY_PAGE_ID
             and SURVEY_PAGES.DELETED                      = 0
      inner join vwSURVEYS
              on vwSURVEYS.ID                              = SURVEY_PAGES.SURVEY_ID
 where SURVEY_QUESTIONS.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_QUESTIONS_SURVEYS to public;
GO


