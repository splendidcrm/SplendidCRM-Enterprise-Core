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
-- drop table SYSTEM_SYNC_LOG;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SYSTEM_SYNC_LOG' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SYSTEM_SYNC_LOG';
	Create Table dbo.SYSTEM_SYNC_LOG
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SYSTEM_SYNC_LOG primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, USER_ID                            uniqueidentifier null
		, MACHINE                            nvarchar(60) null
		, REMOTE_URL                         nvarchar(255) null

		, ERROR_TYPE                         nvarchar(25) null
		, FILE_NAME                          nvarchar(255) null
		, METHOD                             nvarchar(450) null
		, LINE_NUMBER                        int null
		, MESSAGE                            nvarchar(max) null
		)

	create index IDX_SYSTEM_SYNC_LOG        on dbo.SYSTEM_SYNC_LOG (DATE_ENTERED, ID)
  end
GO

