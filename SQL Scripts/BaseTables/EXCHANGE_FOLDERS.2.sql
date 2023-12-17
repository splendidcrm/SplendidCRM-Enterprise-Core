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
-- 04/05/2010 Paul.  We need the WELL_KNOWN_FOLDER flag to detect the difference between well known Contacts and SplendidCRM Contacts. 
-- 04/05/2010 Paul.  We need to keep the PARENT_ID and the PARENT_NAME so that we can detect a name change. 
-- 07/09/2015 Paul.  The Exchange Folder ID is case-significant. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
-- 12/19/2020 Paul.  Office365 uses a DELTA_TOKEN for each folder. 
-- drop table EXCHANGE_FOLDERS;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EXCHANGE_FOLDERS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EXCHANGE_FOLDERS';
	Create Table dbo.EXCHANGE_FOLDERS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EXCHANGE_FOLDERS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier not null
		, REMOTE_KEY                         varchar(800) collate SQL_Latin1_General_CP1_CS_AS not null
		, MODULE_NAME                        nvarchar(25) null
		, PARENT_ID                          uniqueidentifier null
		, PARENT_NAME                        nvarchar(255) null
		, WELL_KNOWN_FOLDER                  bit null default(0)
		, DELTA_TOKEN                        varchar(800) collate SQL_Latin1_General_CP1_CS_AS null
		)

	create index IDX_EXCHANGE_FOLDERS_REMOTE_KEY on dbo.EXCHANGE_FOLDERS (ASSIGNED_USER_ID, DELETED, REMOTE_KEY)
	-- 02/11/2017 Paul.  New index based on missing indexes query. 
	create index IDX_EXCHANGE_FOLDERS_DELETED    on dbo.EXCHANGE_FOLDERS (DELETED, ASSIGNED_USER_ID, MODULE_NAME, PARENT_ID)
  end
GO


