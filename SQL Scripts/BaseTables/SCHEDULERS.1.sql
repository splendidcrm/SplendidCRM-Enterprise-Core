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
-- 12/30/2007 Paul.  Allow DATE_TIME_START to be null. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SCHEDULERS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SCHEDULERS';
	Create Table dbo.SCHEDULERS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SCHEDULERS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(255) not null
		, JOB                                nvarchar(255) not null
		, DATE_TIME_START                    datetime null
		, DATE_TIME_END                      datetime null
		, JOB_INTERVAL                       nvarchar(100) not null
		, TIME_FROM                          datetime null
		, TIME_TO                            datetime null
		, LAST_RUN                           datetime null
		, STATUS                             nvarchar(25) null
		, CATCH_UP                           bit null default(1)
		)

	create index IDX_SCHEDULERS_DATE_TIME_START on dbo.SCHEDULERS (DATE_TIME_START, DELETED)
  end
GO


