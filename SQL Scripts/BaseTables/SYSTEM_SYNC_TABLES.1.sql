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
-- drop table SYSTEM_SYNC_TABLES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SYSTEM_SYNC_TABLES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SYSTEM_SYNC_TABLES';
	Create Table dbo.SYSTEM_SYNC_TABLES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SYSTEM_SYNC_TABLES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, TABLE_NAME                         nvarchar(50) not null
		, VIEW_NAME                          nvarchar(60) not null
		, MODULE_NAME                        nvarchar(25) null
		, MODULE_NAME_RELATED                nvarchar(25) null
		, MODULE_SPECIFIC                    int null default(0)
		, MODULE_FIELD_NAME                  nvarchar(50) null
		, IS_SYSTEM                          bit null default(0)
		, IS_ASSIGNED                        bit null default(0)
		, ASSIGNED_FIELD_NAME                nvarchar(50) null
		, IS_RELATIONSHIP                    bit null default(0)
		, HAS_CUSTOM                         bit null default(0)
		, DEPENDENT_LEVEL                    int null default(0) -- fnSqlDependentLevel()
		)
	
  end
GO


