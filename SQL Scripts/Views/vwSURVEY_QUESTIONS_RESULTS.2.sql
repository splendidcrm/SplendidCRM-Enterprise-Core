if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_QUESTIONS_RESULTS')
	Drop View dbo.vwSURVEY_QUESTIONS_RESULTS;
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
-- 02/02/106 Paul.  Need the ID for the workflow engine. 
Create View dbo.vwSURVEY_QUESTIONS_RESULTS
as
select SURVEY_QUESTIONS_RESULTS.ID
     , SURVEY_QUESTIONS_RESULTS.SURVEY_RESULT_ID
     , SURVEY_QUESTIONS.QUESTION_TYPE
     , SURVEY_QUESTIONS_RESULTS.SURVEY_ID
     , SURVEY_QUESTIONS_RESULTS.SURVEY_PAGE_ID
     , SURVEY_QUESTIONS_RESULTS.SURVEY_QUESTION_ID
     , SURVEY_QUESTIONS_RESULTS.ANSWER_ID
     , SURVEY_QUESTIONS_RESULTS.ANSWER_TEXT
     , SURVEY_QUESTIONS_RESULTS.COLUMN_ID
     , SURVEY_QUESTIONS_RESULTS.COLUMN_TEXT
     , SURVEY_QUESTIONS_RESULTS.MENU_ID
     , SURVEY_QUESTIONS_RESULTS.MENU_TEXT
     , SURVEY_QUESTIONS_RESULTS.WEIGHT
     , SURVEY_QUESTIONS_RESULTS.OTHER_TEXT
     , SURVEY_QUESTIONS_RESULTS.DATE_ENTERED
  from      SURVEY_QUESTIONS_RESULTS
 inner join SURVEY_QUESTIONS
         on SURVEY_QUESTIONS.ID = SURVEY_QUESTIONS_RESULTS.SURVEY_QUESTION_ID
 where SURVEY_QUESTIONS_RESULTS.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_QUESTIONS_RESULTS to public;
GO

