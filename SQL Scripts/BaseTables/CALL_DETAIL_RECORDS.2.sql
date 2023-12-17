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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CALL_DETAIL_RECORDS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CALL_DETAIL_RECORDS';
	Create Table dbo.CALL_DETAIL_RECORDS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CALL_DETAIL_RECORDS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, UNIQUEID                           nvarchar( 32) null
		, ACCOUNT_CODE_ID                    uniqueidentifier null
		, START_TIME                         datetime null
		, ANSWER_TIME                        datetime null
		, END_TIME                           datetime null
		, DURATION                           int null
		, BILLABLE_SECONDS                   int null
		, SOURCE                             nvarchar( 80) null
		, DESTINATION                        nvarchar( 80) null
		, DESTINATION_CONTEXT                nvarchar( 80) null
		, CALLERID                           nvarchar( 80) null
		, SOURCE_CHANNEL                     nvarchar( 80) null
		, DESTINATION_CHANNEL                nvarchar( 80) null
		, DISPOSITION                        nvarchar( 45) null
		, AMA_FLAGS                          nvarchar( 80) null
		, LAST_APPLICATION                   nvarchar( 80) null
		, LAST_DATA                          nvarchar( 80) null
		, USER_FIELD                         nvarchar(255) null
		)

	create index IDX_CALL_DETAIL_START_TIME   on dbo.CALL_DETAIL_RECORDS (START_TIME)
	create index IDX_CALL_DETAIL_ACCOUNT_CODE on dbo.CALL_DETAIL_RECORDS (ACCOUNT_CODE_ID)
  end
GO

