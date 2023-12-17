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
-- 09/06/2005 Paul.  Version 3.5.0 renamed the NUMBER column to BUG_NUMBER (likely to support Oracle)
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 07/25/2009 Paul.  BUG_NUMBER is now a string. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'BUGS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.BUGS';
	Create Table dbo.BUGS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_BUGS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, BUG_NUMBER                         nvarchar( 30) null
		, NAME                               nvarchar(255) null
		, STATUS                             nvarchar(25) null
		, PRIORITY                           nvarchar(25) null
		, DESCRIPTION                        nvarchar(max) null
		, RESOLUTION                         nvarchar(255) null
		, FOUND_IN_RELEASE                   nvarchar(255) null
		, TYPE                               nvarchar(255) null
		, FIXED_IN_RELEASE                   nvarchar(255) null
		, WORK_LOG                           nvarchar(max) null
		, SOURCE                             nvarchar(255) null
		, PRODUCT_CATEGORY                   nvarchar(255) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		)

	create index IDX_BUGS_NUMBER           on dbo.BUGS (BUG_NUMBER, ID, DELETED)
	create index IDX_BUGS_NAME             on dbo.BUGS (NAME, ID, DELETED)
	create index IDX_BUGS_ASSIGNED_USER_ID on dbo.BUGS (ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_BUGS_TEAM_ID          on dbo.BUGS (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_BUGS_TEAM_SET_ID      on dbo.BUGS (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_BUGS_ASSIGNED_SET_ID  on dbo.BUGS (ASSIGNED_SET_ID, ID, DELETED)
  end
GO


