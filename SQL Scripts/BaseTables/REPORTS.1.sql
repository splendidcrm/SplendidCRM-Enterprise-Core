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
-- 05/27/2006 Paul.  REPORT_TYPE is 'External' for imported reports. 
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 06/17/2010 Paul.  Add support for Team Management. 
-- 12/04/2010 Paul.  Add support for Business Rules Framework. 
-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'REPORTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.REPORTS';
	Create Table dbo.REPORTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_REPORTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar(150) null
		, MODULE_NAME                        nvarchar(25) null
		, REPORT_TYPE                        nvarchar(25) null
		, PUBLISHED                          bit null default(0)
		, RDL                                nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		, ASSIGNED_SET_ID                    uniqueidentifier null

		, PRE_LOAD_EVENT_ID                  uniqueidentifier null
		, POST_LOAD_EVENT_ID                 uniqueidentifier null
		)

	create index IDX_REPORTS_ID_DEL          on dbo.REPORTS (ID, DELETED)
	create index IDX_REPORTS_TEAM_ID         on dbo.REPORTS (TEAM_ID, ASSIGNED_USER_ID, ID, DELETED)
	create index IDX_REPORTS_TEAM_SET_ID     on dbo.REPORTS (TEAM_SET_ID, ASSIGNED_USER_ID, ID, DELETED)
	-- 11/29/2017 Paul.  Add ASSIGNED_SET_ID for Dynamic User Assignment. 
	create index IDX_REPORTS_ASSIGNED_SET_ID on dbo.REPORTS (ASSIGNED_SET_ID, ID, DELETED)
  end
GO


