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
-- drop table dbo.MACHINE_LEARNING_MODELS;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'MACHINE_LEARNING_MODELS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.MACHINE_LEARNING_MODELS';
	Create Table dbo.MACHINE_LEARNING_MODELS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_MACHINE_LEARNING_MODELS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(255) not null
		, BASE_MODULE                        nvarchar(100) not null
		, STATUS                             nvarchar(50) null
		, SCENARIO                           nvarchar(50) null
		, TRAIN_SQL_VIEW                     nvarchar(100) not null
		, EVALUATE_SQL_VIEW                  nvarchar(100) null
		, GOOD_FIELD_NAME                    nvarchar(30) not null
		, USE_CROSS_VALIDATION               bit null
		, DESCRIPTION                        nvarchar(max) null
		, LAST_TRAINING_DATE                 datetime null
		, LAST_TRAINING_COUNT                int null
		, LAST_TRAINING_STATUS               nvarchar(max) null
		, EVALUATION_DATA                    nvarchar(max) null
		, EVALUATION_STATUS                  nvarchar(max) null
		, CONTENT                            varbinary(max) null
		)

	create index IDX_MACHINE_LEARNING_MODELS_NAME on dbo.MACHINE_LEARNING_MODELS (NAME, ID, DELETED)
  end
GO


