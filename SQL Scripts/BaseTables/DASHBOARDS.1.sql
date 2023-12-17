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
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 05/18/2017 Paul.  Add TEAM_SET_ID for team management. 
-- 06/14/2017 Paul.  Add CATEGORY for separate home/dashboard pages. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'DASHBOARDS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.DASHBOARDS';
	Create Table dbo.DASHBOARDS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_DASHBOARDS primary key
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
		, NAME                               nvarchar(100) null
		, CATEGORY                           nvarchar( 50) null
		, DESCRIPTION                        nvarchar(max) null
		, CONTENT                            nvarchar(max) null
		)

	create index IDX_DASHBOARDS_NAME            on dbo.DASHBOARDS (NAME, DELETED, ID)
	create index IDX_DASHBOARDS_TEAM_ID         on dbo.DASHBOARDS (TEAM_ID, DELETED, ID)
	create index IDX_DASHBOARDS_TEAM_SET_ID     on dbo.DASHBOARDS (TEAM_SET_ID, ASSIGNED_USER_ID, DELETED, ID)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_DASHBOARDS_ASSIGNED_SET_ID on dbo.DASHBOARDS (ASSIGNED_SET_ID, DELETED, ID)
	create index IDX_DASHBOARDS_ASSIGNED_USER   on dbo.DASHBOARDS (ASSIGNED_USER_ID, CATEGORY, DELETED, ID)
  end
GO


