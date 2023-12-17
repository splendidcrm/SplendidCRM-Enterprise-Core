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
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
-- 07/28/2018 Paul.  Add Kiosk mode fields. 
-- 09/30/2018 Paul.  Add survey record creation to survey. 
-- 01/04/2019 Paul.  Add SURVEY_TARGET_ASSIGNMENT. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SURVEYS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SURVEYS';
	Create Table dbo.SURVEYS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SURVEYS primary key
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
		, NAME                               nvarchar(150) not null
		, STATUS                             nvarchar(25) null
		, SURVEY_TARGET_MODULE               nvarchar(25) null
		, SURVEY_TARGET_ASSIGNMENT           nvarchar(50) null
		, SURVEY_STYLE                       nvarchar(25) null
		, PAGE_RANDOMIZATION                 nvarchar(25) null
		, SURVEY_THEME_ID                    uniqueidentifier null
		, LOOP_SURVEY                        bit null
		, EXIT_CODE                          nvarchar(25) null
		, TIMEOUT                            int null
		, DESCRIPTION                        nvarchar(max) null
		)

	create index IDX_SURVEYS_ASSIGNED_USER_ID on dbo.SURVEYS (ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_SURVEYS_TEAM_ID          on dbo.SURVEYS (TEAM_ID, ASSIGNED_USER_ID, DELETED, ID)
	create index IDX_SURVEYS_TEAM_SET_ID      on dbo.SURVEYS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_SURVEYS_ASSIGNED_SET_ID  on dbo.SURVEYS (ASSIGNED_SET_ID, DELETED, ID)
  end
GO


