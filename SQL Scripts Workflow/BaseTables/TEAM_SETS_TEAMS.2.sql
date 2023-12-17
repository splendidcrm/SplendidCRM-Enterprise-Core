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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TEAM_SETS_TEAMS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TEAM_SETS_TEAMS';
	Create Table dbo.TEAM_SETS_TEAMS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TEAM_SETS_TEAMS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, TEAM_SET_ID                        uniqueidentifier not null
		, TEAM_ID                            uniqueidentifier not null
		, PRIMARY_TEAM                       bit not null default(0)
		)

	-- 08/23/2009 Paul.  No need to index the deleted flag as we will never delete rows in this table. 
	create index IDX_TEAM_SETS_TEAMS_TEAM_SET_ID on dbo.TEAM_SETS_TEAMS (TEAM_SET_ID, TEAM_ID    )
	create index IDX_TEAM_SETS_TEAMS_TEAM_ID     on dbo.TEAM_SETS_TEAMS (TEAM_ID    , TEAM_SET_ID)

	alter table dbo.TEAM_SETS_TEAMS add constraint FK_TEAM_SETS_TEAMS_TEAM_SET_ID foreign key ( TEAM_SET_ID ) references dbo.TEAM_SETS ( ID )
	alter table dbo.TEAM_SETS_TEAMS add constraint FK_TEAM_SETS_TEAMS_TEAM_ID     foreign key ( TEAM_ID     ) references dbo.TEAMS     ( ID )
  end
GO


