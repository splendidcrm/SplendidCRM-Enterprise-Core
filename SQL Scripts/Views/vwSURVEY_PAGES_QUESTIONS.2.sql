if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_PAGES_QUESTIONS')
	Drop View dbo.vwSURVEY_PAGES_QUESTIONS;
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
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
Create View dbo.vwSURVEY_PAGES_QUESTIONS
as
select SURVEY_PAGES.ID               as SURVEY_PAGE_ID
     , SURVEY_PAGES.NAME             as SURVEY_PAGE_NAME
     , SURVEY_PAGES.PAGE_NUMBER      as PAGE_NUMBER
     , SURVEYS.ID                    as SURVEY_ID
     , SURVEYS.NAME                  as SURVEY_NAME
     , SURVEYS.ASSIGNED_USER_ID      as SURVEY_ASSIGNED_USER_ID
     , SURVEYS.ASSIGNED_SET_ID       as SURVEY_ASSIGNED_SET_ID
     , SURVEY_PAGES_QUESTIONS.QUESTION_NUMBER
     , vwSURVEY_QUESTIONS.ID         as SURVEY_QUESTION_ID
     , vwSURVEY_QUESTIONS.NAME       as SURVEY_QUESTION_NAME
     , vwSURVEY_QUESTIONS.*
  from           SURVEY_PAGES
      inner join SURVEYS
              on SURVEYS.ID                            = SURVEY_PAGES.SURVEY_ID
             and SURVEYS.DELETED                       = 0
      inner join SURVEY_PAGES_QUESTIONS
              on SURVEY_PAGES_QUESTIONS.SURVEY_PAGE_ID = SURVEY_PAGES.ID
             and SURVEY_PAGES_QUESTIONS.DELETED        = 0
      inner join vwSURVEY_QUESTIONS
              on vwSURVEY_QUESTIONS.ID                 = SURVEY_PAGES_QUESTIONS.SURVEY_QUESTION_ID
 where SURVEY_PAGES.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_PAGES_QUESTIONS to public;
GO


