if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSURVEY_THEMES')
	Drop View dbo.vwSURVEY_THEMES;
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
-- 11/12/2018 Paul.  Add custom styles field to allow any style change. 
-- 04/09/2019 Paul.  Add Survey Theme Page Background. 
Create View dbo.vwSURVEY_THEMES
as
select SURVEY_THEMES.ID
     , SURVEY_THEMES.NAME
     , SURVEY_THEMES.SURVEY_FONT_FAMILY
     , SURVEY_THEMES.LOGO_BACKGROUND
     , SURVEY_THEMES.SURVEY_BACKGROUND
     , SURVEY_THEMES.SURVEY_TITLE_TEXT_COLOR
     , SURVEY_THEMES.SURVEY_TITLE_FONT_SIZE
     , SURVEY_THEMES.SURVEY_TITLE_FONT_STYLE
     , SURVEY_THEMES.SURVEY_TITLE_FONT_WEIGHT
     , SURVEY_THEMES.SURVEY_TITLE_DECORATION
     , SURVEY_THEMES.SURVEY_TITLE_BACKGROUND
     , SURVEY_THEMES.PAGE_TITLE_TEXT_COLOR
     , SURVEY_THEMES.PAGE_TITLE_FONT_SIZE
     , SURVEY_THEMES.PAGE_TITLE_FONT_STYLE
     , SURVEY_THEMES.PAGE_TITLE_FONT_WEIGHT
     , SURVEY_THEMES.PAGE_TITLE_DECORATION
     , SURVEY_THEMES.PAGE_TITLE_BACKGROUND
     , SURVEY_THEMES.PAGE_DESCRIPTION_TEXT_COLOR
     , SURVEY_THEMES.PAGE_DESCRIPTION_FONT_SIZE
     , SURVEY_THEMES.PAGE_DESCRIPTION_FONT_STYLE
     , SURVEY_THEMES.PAGE_DESCRIPTION_FONT_WEIGHT
     , SURVEY_THEMES.PAGE_DESCRIPTION_DECORATION
     , SURVEY_THEMES.PAGE_DESCRIPTION_BACKGROUND
     , SURVEY_THEMES.QUESTION_HEADING_TEXT_COLOR
     , SURVEY_THEMES.QUESTION_HEADING_FONT_SIZE
     , SURVEY_THEMES.QUESTION_HEADING_FONT_STYLE
     , SURVEY_THEMES.QUESTION_HEADING_FONT_WEIGHT
     , SURVEY_THEMES.QUESTION_HEADING_DECORATION
     , SURVEY_THEMES.QUESTION_HEADING_BACKGROUND
     , SURVEY_THEMES.QUESTION_CHOICE_TEXT_COLOR
     , SURVEY_THEMES.QUESTION_CHOICE_FONT_SIZE
     , SURVEY_THEMES.QUESTION_CHOICE_FONT_STYLE
     , SURVEY_THEMES.QUESTION_CHOICE_FONT_WEIGHT
     , SURVEY_THEMES.QUESTION_CHOICE_DECORATION
     , SURVEY_THEMES.QUESTION_CHOICE_BACKGROUND
     , SURVEY_THEMES.PROGRESS_BAR_PAGE_WIDTH
     , SURVEY_THEMES.PROGRESS_BAR_COLOR
     , SURVEY_THEMES.PROGRESS_BAR_BORDER_COLOR
     , SURVEY_THEMES.PROGRESS_BAR_BORDER_WIDTH
     , SURVEY_THEMES.PROGRESS_BAR_TEXT_COLOR
     , SURVEY_THEMES.PROGRESS_BAR_FONT_SIZE
     , SURVEY_THEMES.PROGRESS_BAR_FONT_STYLE
     , SURVEY_THEMES.PROGRESS_BAR_FONT_WEIGHT
     , SURVEY_THEMES.PROGRESS_BAR_DECORATION
     , SURVEY_THEMES.PROGRESS_BAR_BACKGROUND
     , SURVEY_THEMES.ERROR_TEXT_COLOR
     , SURVEY_THEMES.ERROR_FONT_SIZE
     , SURVEY_THEMES.ERROR_FONT_STYLE
     , SURVEY_THEMES.ERROR_FONT_WEIGHT
     , SURVEY_THEMES.ERROR_DECORATION
     , SURVEY_THEMES.ERROR_BACKGROUND
     , SURVEY_THEMES.EXIT_LINK_TEXT_COLOR
     , SURVEY_THEMES.EXIT_LINK_FONT_SIZE
     , SURVEY_THEMES.EXIT_LINK_FONT_STYLE
     , SURVEY_THEMES.EXIT_LINK_FONT_WEIGHT
     , SURVEY_THEMES.EXIT_LINK_DECORATION
     , SURVEY_THEMES.EXIT_LINK_BACKGROUND
     , SURVEY_THEMES.REQUIRED_TEXT_COLOR
     , SURVEY_THEMES.CUSTOM_STYLES
     , SURVEY_THEMES.DESCRIPTION
     , SURVEY_THEMES.PAGE_BACKGROUND_IMAGE
     , SURVEY_THEMES.PAGE_BACKGROUND_POSITION
     , SURVEY_THEMES.PAGE_BACKGROUND_REPEAT
     , SURVEY_THEMES.PAGE_BACKGROUND_SIZE
     , SURVEY_THEMES.DATE_ENTERED
     , SURVEY_THEMES.DATE_MODIFIED
     , USERS_CREATED_BY.USER_NAME  as CREATED_BY
     , USERS_MODIFIED_BY.USER_NAME as MODIFIED_BY
     , dbo.fnFullName(USERS_CREATED_BY.FIRST_NAME , USERS_CREATED_BY.LAST_NAME ) as CREATED_BY_NAME
     , dbo.fnFullName(USERS_MODIFIED_BY.FIRST_NAME, USERS_MODIFIED_BY.LAST_NAME) as MODIFIED_BY_NAME
  from            SURVEY_THEMES
  left outer join USERS USERS_CREATED_BY
               on USERS_CREATED_BY.ID  = SURVEY_THEMES.CREATED_BY
  left outer join USERS USERS_MODIFIED_BY
               on USERS_MODIFIED_BY.ID = SURVEY_THEMES.MODIFIED_USER_ID
 where SURVEY_THEMES.DELETED = 0

GO

Grant Select on dbo.vwSURVEY_THEMES to public;
GO


