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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEY_THEMES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SURVEY_THEMES';
	Create Table dbo.SURVEY_THEMES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SURVEY_THEMES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(50) null
		, SURVEY_FONT_FAMILY                 nvarchar(50) null
		, LOGO_BACKGROUND                    nvarchar(25) null
		, SURVEY_BACKGROUND                  nvarchar(25) null

		, SURVEY_TITLE_TEXT_COLOR            nvarchar(25) null
		, SURVEY_TITLE_FONT_SIZE             nvarchar(25) null
		, SURVEY_TITLE_FONT_STYLE            nvarchar(25) null
		, SURVEY_TITLE_FONT_WEIGHT           nvarchar(25) null
		, SURVEY_TITLE_DECORATION            nvarchar(25) null
		, SURVEY_TITLE_BACKGROUND            nvarchar(25) null

		, PAGE_TITLE_TEXT_COLOR              nvarchar(25) null
		, PAGE_TITLE_FONT_SIZE               nvarchar(25) null
		, PAGE_TITLE_FONT_STYLE              nvarchar(25) null
		, PAGE_TITLE_FONT_WEIGHT             nvarchar(25) null
		, PAGE_TITLE_DECORATION              nvarchar(25) null
		, PAGE_TITLE_BACKGROUND              nvarchar(25) null

		, PAGE_DESCRIPTION_TEXT_COLOR        nvarchar(25) null
		, PAGE_DESCRIPTION_FONT_SIZE         nvarchar(25) null
		, PAGE_DESCRIPTION_FONT_STYLE        nvarchar(25) null
		, PAGE_DESCRIPTION_FONT_WEIGHT       nvarchar(25) null
		, PAGE_DESCRIPTION_DECORATION        nvarchar(25) null
		, PAGE_DESCRIPTION_BACKGROUND        nvarchar(25) null

		, PAGE_BACKGROUND_IMAGE              nvarchar(255) null
		, PAGE_BACKGROUND_POSITION           nvarchar(25) null
		, PAGE_BACKGROUND_REPEAT             nvarchar(25) null
		, PAGE_BACKGROUND_SIZE               nvarchar(25) null

		, QUESTION_HEADING_TEXT_COLOR        nvarchar(25) null
		, QUESTION_HEADING_FONT_SIZE         nvarchar(25) null
		, QUESTION_HEADING_FONT_STYLE        nvarchar(25) null
		, QUESTION_HEADING_FONT_WEIGHT       nvarchar(25) null
		, QUESTION_HEADING_DECORATION        nvarchar(25) null
		, QUESTION_HEADING_BACKGROUND        nvarchar(25) null

		, QUESTION_CHOICE_TEXT_COLOR         nvarchar(25) null
		, QUESTION_CHOICE_FONT_SIZE          nvarchar(25) null
		, QUESTION_CHOICE_FONT_STYLE         nvarchar(25) null
		, QUESTION_CHOICE_FONT_WEIGHT        nvarchar(25) null
		, QUESTION_CHOICE_DECORATION         nvarchar(25) null
		, QUESTION_CHOICE_BACKGROUND         nvarchar(25) null

		, PROGRESS_BAR_PAGE_WIDTH            nvarchar(25) null
		, PROGRESS_BAR_COLOR                 nvarchar(25) null
		, PROGRESS_BAR_BORDER_COLOR          nvarchar(25) null
		, PROGRESS_BAR_BORDER_WIDTH          nvarchar(25) null
		, PROGRESS_BAR_TEXT_COLOR            nvarchar(25) null
		, PROGRESS_BAR_FONT_SIZE             nvarchar(25) null
		, PROGRESS_BAR_FONT_STYLE            nvarchar(25) null
		, PROGRESS_BAR_FONT_WEIGHT           nvarchar(25) null
		, PROGRESS_BAR_DECORATION            nvarchar(25) null
		, PROGRESS_BAR_BACKGROUND            nvarchar(25) null

		, ERROR_TEXT_COLOR                   nvarchar(25) null
		, ERROR_FONT_SIZE                    nvarchar(25) null
		, ERROR_FONT_STYLE                   nvarchar(25) null
		, ERROR_FONT_WEIGHT                  nvarchar(25) null
		, ERROR_DECORATION                   nvarchar(25) null
		, ERROR_BACKGROUND                   nvarchar(25) null

		, EXIT_LINK_TEXT_COLOR               nvarchar(25) null
		, EXIT_LINK_FONT_SIZE                nvarchar(25) null
		, EXIT_LINK_FONT_STYLE               nvarchar(25) null
		, EXIT_LINK_FONT_WEIGHT              nvarchar(25) null
		, EXIT_LINK_DECORATION               nvarchar(25) null
		, EXIT_LINK_BACKGROUND               nvarchar(25) null

		, REQUIRED_TEXT_COLOR                nvarchar(25) null

		, CUSTOM_STYLES                      nvarchar(max) null
		, DESCRIPTION                        nvarchar(max) null
		)
  end
GO

