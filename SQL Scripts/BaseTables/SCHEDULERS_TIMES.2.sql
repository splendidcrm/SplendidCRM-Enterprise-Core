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
-- 04/21/2006 Paul.  Added in SugarCRM 4.0.
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SCHEDULERS_TIMES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SCHEDULERS_TIMES';
	Create Table dbo.SCHEDULERS_TIMES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SCHEDULERS_TIMES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, SCHEDULE_ID                        uniqueidentifier not null
		, EXECUTE_TIME                       datetime not null
		, STATUS                             nvarchar(25) not null default('ready')
		)

	create index IDX_SCHEDULERS_TIMES_SCHEDULE_ID on dbo.SCHEDULERS_TIMES (SCHEDULE_ID, EXECUTE_TIME)

	alter table dbo.SCHEDULERS_TIMES add constraint FK_SCHEDULERS_TIMES_SCHEDULE_ID foreign key ( SCHEDULE_ID ) references dbo.SCHEDULERS ( ID )
  end
GO


