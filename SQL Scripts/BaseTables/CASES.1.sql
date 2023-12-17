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
-- 09/06/2005 Paul.  Version 3.5.0 renamed the NUMBER column to CASE_NUMBER (likely to support Oracle)
-- 11/22/2006 Paul.  Add TEAM_ID for team management. 
-- 07/25/2009 Paul.  CASE_NUMBER is now a string. 
-- 08/21/2009 Paul.  Add support for dynamic teams. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 04/02/2012 Paul.  Add TYPE and WORK_LOG. 
-- 05/01/2013 Paul.  Add Contacts field to support B2C. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CASES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CASES';
	Create Table dbo.CASES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CASES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, CASE_NUMBER                        nvarchar( 30) null
		, NAME                               nvarchar(255) null
		, ACCOUNT_NAME                       nvarchar(100) null
		, ACCOUNT_ID                         uniqueidentifier null
		, B2C_CONTACT_ID                     uniqueidentifier null
		, STATUS                             nvarchar(25) null
		, PRIORITY                           nvarchar(25) null
		, TYPE                               nvarchar(25) null
		, DESCRIPTION                        nvarchar(max) null
		, RESOLUTION                         nvarchar(max) null
		, WORK_LOG                           nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null
		)

	create index IDX_CASES_NUMBER           on dbo.CASES (CASE_NUMBER, ID, DELETED)
	create index IDX_CASES_NAME             on dbo.CASES (NAME, ID, DELETED)
	create index IDX_CASES_ASSIGNED_USER_ID on dbo.CASES (ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_CASES_TEAM_ID          on dbo.CASES (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 08/31/2009 Paul.  Add index for TEAM_SET_ID as we will soon filter on it.
	create index IDX_CASES_TEAM_SET_ID      on dbo.CASES (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_CASES_ASSIGNED_SET_ID  on dbo.CASES (ASSIGNED_SET_ID, ID, DELETED)
  end
GO


