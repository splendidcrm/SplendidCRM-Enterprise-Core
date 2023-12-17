if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_PAGES_RESULTS_CONTENT')
	Drop View dbo.vwSURVEY_PAGES_RESULTS_CONTENT;
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
-- 01/04/2019 Paul.  Include EXIT_CODE. 
-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
Create View dbo.vwSURVEY_PAGES_RESULTS_CONTENT
as
select SURVEY_RESULTS.ID
     , SURVEYS.NAME                               as SURVEY_NAME
     , SURVEYS.EXIT_CODE                          as EXIT_CODE
     , SURVEYS.SURVEY_TARGET_MODULE               as SURVEY_TARGET_MODULE
     , SURVEYS.SURVEY_TARGET_ASSIGNMENT           as SURVEY_TARGET_ASSIGNMENT
     , SURVEYS.TEAM_ID                            as TEAM_ID
     , SURVEY_RESULTS.SURVEY_ID                   as SURVEY_ID
     , SURVEY_RESULTS.PARENT_ID                   as PARENT_ID
     , SURVEY_PAGES_QUESTIONS.SURVEY_PAGE_ID      as SURVEY_PAGE_ID
     , SURVEY_PAGES.PAGE_NUMBER                   as PAGE_NUMBER
     , SURVEY_PAGES_QUESTIONS.SURVEY_QUESTION_ID  as SURVEY_QUESTION_ID
     , SURVEY_PAGES_QUESTIONS.QUESTION_NUMBER     as QUESTION_NUMBER
     , SURVEY_QUESTIONS.DESCRIPTION               as SURVEY_QUESTION_NAME
     , SURVEY_QUESTIONS.QUESTION_TYPE             as QUESTION_TYPE
     , SURVEY_QUESTIONS.TARGET_FIELD_NAME         as TARGET_FIELD_NAME
     , SURVEY_PAGES_RESULTS.RAW_CONTENT           as RAW_CONTENT
  from      SURVEY_RESULTS
 inner join SURVEYS
         on SURVEYS.ID                            = SURVEY_RESULTS.SURVEY_ID
        and SURVEYS.DELETED                       = 0
        and SURVEYS.SURVEY_TARGET_MODULE          is not null
 inner join SURVEY_PAGES
         on SURVEY_PAGES.SURVEY_ID                = SURVEYS.ID
        and SURVEY_PAGES.DELETED                  = 0
 inner join SURVEY_PAGES_QUESTIONS
         on SURVEY_PAGES_QUESTIONS.SURVEY_PAGE_ID = SURVEY_PAGES.ID
        and SURVEY_PAGES_QUESTIONS.DELETED        = 0
 inner join SURVEY_QUESTIONS
         on SURVEY_QUESTIONS.ID                   = SURVEY_PAGES_QUESTIONS.SURVEY_QUESTION_ID
        and SURVEY_QUESTIONS.DELETED              = 0
        and (SURVEY_QUESTIONS.TARGET_FIELD_NAME   is not null or SURVEY_QUESTIONS.QUESTION_TYPE = 'Demographic')
 inner join SURVEY_PAGES_RESULTS
         on SURVEY_PAGES_RESULTS.SURVEY_RESULT_ID = SURVEY_RESULTS.ID
        and SURVEY_PAGES_RESULTS.SURVEY_ID        = SURVEYS.ID
        and SURVEY_PAGES_RESULTS.SURVEY_PAGE_ID   = SURVEY_PAGES.ID
        and SURVEY_PAGES_RESULTS.DELETED          = 0
        and SURVEY_PAGES_RESULTS.RAW_CONTENT      is not null
 where SURVEY_RESULTS.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_PAGES_RESULTS_CONTENT to public;
GO

/*
select *
  from vwSURVEY_PAGES_RESULTS_CONTENT
 where ID = '99B8A744-4D5C-40B4-9B81-F63ADB88372F'
 order by PAGE_NUMBER, QUESTION_NUMBER
*/

