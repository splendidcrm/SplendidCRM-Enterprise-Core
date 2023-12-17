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
-- 09/02/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TEAM_NOTICES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TEAM_NOTICES';
	Create Table dbo.TEAM_NOTICES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TEAM_NOTICES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar( 50) not null
		, STATUS                             nvarchar( 25) null
		, DATE_START                         datetime null
		, DATE_END                           datetime null
		, URL                                nvarchar(255) null
		, URL_TITLE                          nvarchar(255) null
		, DESCRIPTION                        nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		)

	create index IDX_TEAM_NOTICES_DATE        on dbo.TEAM_NOTICES (DELETED, DATE_START, DATE_END)
	-- 09/02/2009 Paul.  Add indexes for team filtering.
	create index IDX_TEAM_NOTICES_TEAM_ID     on dbo.TEAM_NOTICES (TEAM_ID    , DELETED, DATE_START, DATE_END)
	create index IDX_TEAM_NOTICES_TEAM_SET_ID on dbo.TEAM_NOTICES (TEAM_SET_ID, DELETED, DATE_START, DATE_END)
  end
GO

