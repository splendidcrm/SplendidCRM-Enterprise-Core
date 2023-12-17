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
-- Drop Table PROCESSES_NOTES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PROCESSES_NOTES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PROCESSES_NOTES';
	Create Table dbo.PROCESSES_NOTES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PROCESSES_NOTES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, PROCESS_ID                         uniqueidentifier not null
		, BUSINESS_PROCESS_INSTANCE_ID       uniqueidentifier not null
		, DESCRIPTION                        nvarchar(max) null
		)

	-- drop index IDX_PROCESSES_NOTES on PROCESSES_NOTES
	create index IDX_PROCESSES_NOTES             on PROCESSES_NOTES (PROCESS_ID, DELETED)
	create index IDX_PROCESSES_NOTES_INSTANCE_ID on PROCESSES_NOTES (BUSINESS_PROCESS_INSTANCE_ID, DELETED, DATE_ENTERED)
  end
GO

