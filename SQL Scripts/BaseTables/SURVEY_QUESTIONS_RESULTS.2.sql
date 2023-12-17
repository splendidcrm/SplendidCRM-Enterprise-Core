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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEY_QUESTIONS_RESULTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SURVEY_QUESTIONS_RESULTS';
	Create Table dbo.SURVEY_QUESTIONS_RESULTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SURVEY_QUESTIONS_RESULTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, SURVEY_RESULT_ID                   uniqueidentifier not null
		, SURVEY_ID                          uniqueidentifier not null
		, SURVEY_PAGE_ID                     uniqueidentifier not null
		, SURVEY_QUESTION_ID                 uniqueidentifier not null
		, ANSWER_ID                          uniqueidentifier null
		, ANSWER_TEXT                        nvarchar(max) null
		, COLUMN_ID                          uniqueidentifier null
		, COLUMN_TEXT                        nvarchar(max) null
		, MENU_ID                            uniqueidentifier null
		, MENU_TEXT                          nvarchar(max) null
		, WEIGHT                             int null
		, OTHER_TEXT                         nvarchar(max) null
		)

	create index IDX_SURVEY_QUESTIONS_RESULTS_RESULT_ID   on dbo.SURVEY_QUESTIONS_RESULTS (SURVEY_RESULT_ID, SURVEY_ID, SURVEY_PAGE_ID, SURVEY_QUESTION_ID, DELETED)
	create index IDX_SURVEY_QUESTIONS_RESULTS_SURVEY_ID   on dbo.SURVEY_QUESTIONS_RESULTS (SURVEY_ID, SURVEY_RESULT_ID, DELETED)
	create index IDX_SURVEY_QUESTIONS_RESULTS_QUESTION_ID on dbo.SURVEY_QUESTIONS_RESULTS (SURVEY_QUESTION_ID, SURVEY_ID, SURVEY_RESULT_ID, DELETED)
  end
GO

