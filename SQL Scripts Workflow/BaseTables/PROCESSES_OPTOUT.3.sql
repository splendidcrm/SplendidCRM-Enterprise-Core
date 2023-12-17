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
-- drop table PROCESSES_OPTOUT;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PROCESSES_OPTOUT' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PROCESSES_OPTOUT';
	Create Table dbo.PROCESSES_OPTOUT
		( ID                                 uniqueidentifier not null constraint PK_PROCESSES_OPTOUT primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, BUSINESS_PROCESS_INSTANCE_ID       uniqueidentifier null
		, PARENT_ID                          uniqueidentifier null
		, PARENT_TYPE                        nvarchar(50) null
		, REASON                             nvarchar(max) null
		)

	create index IDX_PROCESSES_OPTOUT on dbo.PROCESSES_OPTOUT (BUSINESS_PROCESS_INSTANCE_ID, PARENT_ID, DELETED)
  end
GO

