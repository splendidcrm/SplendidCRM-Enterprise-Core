if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_QUESTIONS')
	Drop View dbo.vwSURVEY_QUESTIONS;
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
-- 01/01/2016 Paul.  Add categories. 
-- 11/30/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 09/30/2018 Paul.  Add survey record creation to survey. 
Create View dbo.vwSURVEY_QUESTIONS
as
select SURVEY_QUESTIONS.ID
     , SURVEY_QUESTIONS.NAME
     , SURVEY_QUESTIONS.DESCRIPTION
     , SURVEY_QUESTIONS.SURVEY_TARGET_MODULE
     , SURVEY_QUESTIONS.TARGET_FIELD_NAME
     , SURVEY_QUESTIONS.QUESTION_TYPE
     , SURVEY_QUESTIONS.DISPLAY_FORMAT
     , SURVEY_QUESTIONS.ANSWER_CHOICES
     , SURVEY_QUESTIONS.COLUMN_CHOICES
     , SURVEY_QUESTIONS.FORCED_RANKING
     , SURVEY_QUESTIONS.INVALID_DATE_MESSAGE
     , SURVEY_QUESTIONS.INVALID_NUMBER_MESSAGE
     , SURVEY_QUESTIONS.NA_ENABLED
     , SURVEY_QUESTIONS.NA_LABEL
     , SURVEY_QUESTIONS.OTHER_ENABLED
     , SURVEY_QUESTIONS.OTHER_LABEL
     , SURVEY_QUESTIONS.OTHER_HEIGHT
     , SURVEY_QUESTIONS.OTHER_WIDTH
     , SURVEY_QUESTIONS.OTHER_AS_CHOICE
     , SURVEY_QUESTIONS.OTHER_ONE_PER_ROW
     , SURVEY_QUESTIONS.OTHER_REQUIRED_MESSAGE
     , SURVEY_QUESTIONS.OTHER_VALIDATION_TYPE
     , SURVEY_QUESTIONS.OTHER_VALIDATION_MIN
     , SURVEY_QUESTIONS.OTHER_VALIDATION_MAX
     , SURVEY_QUESTIONS.OTHER_VALIDATION_MESSAGE
     , SURVEY_QUESTIONS.REQUIRED
     , SURVEY_QUESTIONS.REQUIRED_TYPE
     , SURVEY_QUESTIONS.REQUIRED_RESPONSES_MIN
     , SURVEY_QUESTIONS.REQUIRED_RESPONSES_MAX
     , SURVEY_QUESTIONS.REQUIRED_MESSAGE
     , SURVEY_QUESTIONS.VALIDATION_TYPE
     , SURVEY_QUESTIONS.VALIDATION_MIN
     , SURVEY_QUESTIONS.VALIDATION_MAX
     , SURVEY_QUESTIONS.VALIDATION_MESSAGE
     , SURVEY_QUESTIONS.VALIDATION_SUM_ENABLED
     , SURVEY_QUESTIONS.VALIDATION_NUMERIC_SUM
     , SURVEY_QUESTIONS.VALIDATION_SUM_MESSAGE
     , SURVEY_QUESTIONS.RANDOMIZE_TYPE
     , SURVEY_QUESTIONS.RANDOMIZE_NOT_LAST
     , SURVEY_QUESTIONS.SIZE_WIDTH
     , SURVEY_QUESTIONS.SIZE_HEIGHT
     , SURVEY_QUESTIONS.BOX_WIDTH
     , SURVEY_QUESTIONS.BOX_HEIGHT
     , SURVEY_QUESTIONS.COLUMN_WIDTH
     , SURVEY_QUESTIONS.PLACEMENT
     , SURVEY_QUESTIONS.SPACING_LEFT
     , SURVEY_QUESTIONS.SPACING_TOP
     , SURVEY_QUESTIONS.SPACING_RIGHT
     , SURVEY_QUESTIONS.SPACING_BOTTOM
     , SURVEY_QUESTIONS.IMAGE_URL
     , SURVEY_QUESTIONS.CATEGORIES
     , SURVEY_QUESTIONS.ASSIGNED_USER_ID
     , SURVEY_QUESTIONS.DATE_ENTERED
     , SURVEY_QUESTIONS.DATE_MODIFIED
     , SURVEY_QUESTIONS.DATE_MODIFIED_UTC
     , TEAMS.ID                    as TEAM_ID
     , TEAMS.NAME                  as TEAM_NAME
     , USERS_ASSIGNED.USER_NAME    as ASSIGNED_TO
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , SURVEY_QUESTIONS.CREATED_BY as CREATED_BY_ID
     , SURVEY_QUESTIONS.MODIFIED_USER_ID
     , TEAM_SETS.ID                as TEAM_SET_ID
     , TEAM_SETS.TEAM_SET_NAME     as TEAM_SET_NAME
     , TEAM_SETS.TEAM_SET_LIST     as TEAM_SET_LIST
     , dbo.fnFullName(USERS_ASSIGNED.FIRST_NAME   , USERS_ASSIGNED.LAST_NAME   ) as ASSIGNED_TO_NAME
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
     , ASSIGNED_SETS.ID                as ASSIGNED_SET_ID
     , ASSIGNED_SETS.ASSIGNED_SET_NAME as ASSIGNED_SET_NAME
     , ASSIGNED_SETS.ASSIGNED_SET_LIST as ASSIGNED_SET_LIST
     , SURVEY_QUESTIONS_CSTM.*
  from            SURVEY_QUESTIONS
  left outer join TEAMS
               on TEAMS.ID             = SURVEY_QUESTIONS.TEAM_ID
              and TEAMS.DELETED        = 0
  left outer join TEAM_SETS
               on TEAM_SETS.ID         = SURVEY_QUESTIONS.TEAM_SET_ID
              and TEAM_SETS.DELETED    = 0
  left outer join USERS                  USERS_ASSIGNED
               on USERS_ASSIGNED.ID    = SURVEY_QUESTIONS.ASSIGNED_USER_ID
  left outer join USERS                  USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = SURVEY_QUESTIONS.CREATED_BY
  left outer join USERS                  USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = SURVEY_QUESTIONS.MODIFIED_USER_ID
  left outer join ASSIGNED_SETS
               on ASSIGNED_SETS.ID     = SURVEY_QUESTIONS.ASSIGNED_SET_ID
              and ASSIGNED_SETS.DELETED= 0
  left outer join SURVEY_QUESTIONS_CSTM
               on SURVEY_QUESTIONS_CSTM.ID_C  = SURVEY_QUESTIONS.ID
 where SURVEY_QUESTIONS.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_QUESTIONS to public;
GO

