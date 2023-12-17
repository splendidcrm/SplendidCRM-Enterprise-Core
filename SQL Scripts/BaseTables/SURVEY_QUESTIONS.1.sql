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
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 09/30/2018 Paul.  Add survey record creation to survey. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEY_QUESTIONS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SURVEY_QUESTIONS';
	Create Table dbo.SURVEY_QUESTIONS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SURVEY_QUESTIONS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, TEAM_SET_ID                        uniqueidentifier null
		, NAME                               nvarchar(150) null
		, DESCRIPTION                        nvarchar(max) null

		, SURVEY_TARGET_MODULE               nvarchar(25) null
		, TARGET_FIELD_NAME                  nvarchar(50) null
		, QUESTION_TYPE                      nvarchar(25) null
		, DISPLAY_FORMAT                     nvarchar(25) null
		, ANSWER_CHOICES                     nvarchar(max) null
		, COLUMN_CHOICES                     nvarchar(max) null
		, FORCED_RANKING                     bit null
		, INVALID_DATE_MESSAGE               nvarchar(max) null
		, INVALID_NUMBER_MESSAGE             nvarchar(max) null

		-- Ranking and Ratings
		, NA_ENABLED                         bit null
		, NA_LABEL                           nvarchar(max) null

		-- Other
		, OTHER_ENABLED                      bit null
		, OTHER_LABEL                        nvarchar(200) null
		, OTHER_HEIGHT                       int null
		, OTHER_WIDTH                        int null
		, OTHER_AS_CHOICE                    bit null
		, OTHER_ONE_PER_ROW                  bit null
		, OTHER_REQUIRED_MESSAGE             nvarchar(max) null
		, OTHER_VALIDATION_TYPE              nvarchar(25) null
		, OTHER_VALIDATION_MIN               nvarchar(10) null
		, OTHER_VALIDATION_MAX               nvarchar(10) null
		, OTHER_VALIDATION_MESSAGE           nvarchar(max) null

		-- Required
		, REQUIRED                           bit null
		, REQUIRED_TYPE                      nvarchar(25) null
		, REQUIRED_RESPONSES_MIN             int null
		, REQUIRED_RESPONSES_MAX             int null
		, REQUIRED_MESSAGE                   nvarchar(max) null

		-- Validate Answer
		, VALIDATION_TYPE                    nvarchar(25) null
		, VALIDATION_MIN                     nvarchar(10) null
		, VALIDATION_MAX                     nvarchar(10) null
		, VALIDATION_MESSAGE                 nvarchar(max) null
		, VALIDATION_SUM_ENABLED             bit null
		, VALIDATION_NUMERIC_SUM             int null
		, VALIDATION_SUM_MESSAGE             nvarchar(max) null

		-- Randomize or flip
		, RANDOMIZE_TYPE                     nvarchar(25) null
		, RANDOMIZE_NOT_LAST                 bit null

		-- Question Size and Placement
		, SIZE_WIDTH                         nvarchar(10) null
		, SIZE_HEIGHT                        nvarchar(10) null
		, BOX_WIDTH                          nvarchar(10) null
		, BOX_HEIGHT                         nvarchar(10) null
		, COLUMN_WIDTH                       nvarchar(10) null
		, PLACEMENT                          nvarchar(25) null
		, SPACING_LEFT                       int null
		, SPACING_TOP                        int null
		, SPACING_RIGHT                      int null
		, SPACING_BOTTOM                     int null

		, IMAGE_URL                          nvarchar(1000) null
		, CATEGORIES                         nvarchar(max) null
		)

	create index IDX_SURVEY_QUESTIONS_ASSIGNED_USER_ID on dbo.SURVEY_QUESTIONS (ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_SURVEY_QUESTIONS_TEAM_ID          on dbo.SURVEY_QUESTIONS (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_SURVEY_QUESTIONS_TEAM_SET_ID      on dbo.SURVEY_QUESTIONS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_SURVEY_QUESTIONS_ASSIGNED_SET_ID  on dbo.SURVEY_QUESTIONS (ASSIGNED_SET_ID, DELETED, ID)
  end
GO

