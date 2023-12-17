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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'DATA_PRIVACY' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.DATA_PRIVACY';
	Create Table dbo.DATA_PRIVACY
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_DATA_PRIVACY primary key
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
		, NAME                               nvarchar(255) null
		, DATA_PRIVACY_NUMBER                nvarchar( 30) null
		, TYPE                               nvarchar(100) null
		, STATUS                             nvarchar(100) null
		, PRIORITY                           nvarchar(100) null
		, DATE_OPENED                        datetime null
		, DATE_DUE                           datetime null
		, DATE_CLOSED                        datetime null
		, SOURCE                             nvarchar(255) null
		, REQUESTED_BY                       nvarchar(255) null
		, BUSINESS_PURPOSE                   nvarchar(max) null
		, DESCRIPTION                        nvarchar(max) null
		, RESOLUTION                         nvarchar(max) null
		, WORK_LOG                           nvarchar(max) null
		, FIELDS_TO_ERASE                    nvarchar(max) null
		)

	create index IDX_DATA_PRIVACY_NUMBER           on dbo.DATA_PRIVACY (DATA_PRIVACY_NUMBER, ID, DELETED)
	create index IDX_DATA_PRIVACY_NAME             on dbo.DATA_PRIVACY (NAME, ID, DELETED)
	create index IDX_DATA_PRIVACY_ASSIGNED_USER_ID on dbo.DATA_PRIVACY (ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_DATA_PRIVACY_TEAM_ID          on dbo.DATA_PRIVACY (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_DATA_PRIVACY_TEAM_SET_ID      on dbo.DATA_PRIVACY (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_DATA_PRIVACY_ASSIGNED_SET_ID  on dbo.DATA_PRIVACY (ASSIGNED_SET_ID, ID, DELETED)
	create index IDX_DATA_PRIVACY_DATE_ENTERED     on dbo.DATA_PRIVACY (DATE_ENTERED, ID, DELETED)
  end
GO

