if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_RESULTS_List')
	Drop View dbo.vwSURVEY_RESULTS_List;
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
-- 12/30/2015 Paul.  Change to vwSURVEY_RESULTS_List as vwSURVEY_RESULTS is needed for Query Builder. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 04/10/2021 Paul.  React client requires NAME in all modules. 
Create View dbo.vwSURVEY_RESULTS_List
as
select SURVEYS.ID                  as SURVEY_ID
     , SURVEYS.NAME                as SURVEY_NAME
     , SURVEYS.NAME                as NAME
     , SURVEYS.ASSIGNED_USER_ID    as SURVEY_ASSIGNED_USER_ID
     , SURVEYS.ASSIGNED_SET_ID     as SURVEY_ASSIGNED_SET_ID
     , vwPARENTS_EMAIL_ADDRESS.PARENT_ID
     , vwPARENTS_EMAIL_ADDRESS.PARENT_NAME
     , vwPARENTS_EMAIL_ADDRESS.PARENT_TYPE
     , SURVEY_RESULTS.ID
     , SURVEY_RESULTS.DATE_MODIFIED
     , SURVEY_RESULTS.START_DATE
     , SURVEY_RESULTS.SUBMIT_DATE
     , SURVEY_RESULTS.IS_COMPLETE
     , SURVEY_RESULTS.IP_ADDRESS
     , SURVEY_RESULTS.USER_AGENT
     , SURVEY_QUESTIONS_RESULTS.SURVEY_RESULT_ID
     , SURVEY_QUESTIONS.QUESTION_TYPE
     , SURVEY_QUESTIONS.ASSIGNED_USER_ID               as QUESTION_ASSIGNED_USER_ID
     , SURVEY_QUESTIONS.ASSIGNED_SET_ID                as QUESTION_ASSIGNED_SET_ID
     , SURVEY_QUESTIONS.DESCRIPTION                    as SURVEY_QUESTION_NAME
     , SURVEY_QUESTIONS_RESULTS.ID                     as SURVEY_QUESTIONS_RESULT_ID
     , SURVEY_QUESTIONS_RESULTS.DATE_ENTERED
     , SURVEY_QUESTIONS_RESULTS.SURVEY_QUESTION_ID
     , SURVEY_QUESTIONS_RESULTS.ANSWER_ID
     , SURVEY_QUESTIONS_RESULTS.ANSWER_TEXT
     , SURVEY_QUESTIONS_RESULTS.COLUMN_ID
     , SURVEY_QUESTIONS_RESULTS.COLUMN_TEXT
     , SURVEY_QUESTIONS_RESULTS.MENU_ID
     , SURVEY_QUESTIONS_RESULTS.MENU_TEXT
     , SURVEY_QUESTIONS_RESULTS.WEIGHT
     , SURVEY_QUESTIONS_RESULTS.OTHER_TEXT
     , (case when SURVEY_QUESTIONS_RESULTS.ANSWER_TEXT is not null then 1 end) as IS_ANSWERED
  from            SURVEY_RESULTS
       inner join SURVEYS
               on SURVEYS.ID                                = SURVEY_RESULTS.SURVEY_ID
              and SURVEYS.DELETED                           = 0
       inner join SURVEY_QUESTIONS_RESULTS
               on SURVEY_QUESTIONS_RESULTS.SURVEY_RESULT_ID = SURVEY_RESULTS.ID
              and SURVEY_QUESTIONS_RESULTS.DELETED          = 0
       inner join SURVEY_QUESTIONS
               on SURVEY_QUESTIONS.ID                       = SURVEY_QUESTIONS_RESULTS.SURVEY_QUESTION_ID
              and SURVEY_QUESTIONS.DELETED                  = 0
  left outer join vwPARENTS_EMAIL_ADDRESS
               on vwPARENTS_EMAIL_ADDRESS.PARENT_ID         = SURVEY_RESULTS.PARENT_ID
 where SURVEY_RESULTS.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_RESULTS_List to public;
GO


