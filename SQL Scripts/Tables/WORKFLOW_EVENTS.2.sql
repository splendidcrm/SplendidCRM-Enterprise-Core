
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
-- 03/06/2008 Paul.  All tables should have MODIFIED_USER_ID and DATE_MODIFIED.
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_EVENTS' and COLUMN_NAME = 'DATE_MODIFIED') begin -- then
	print 'Drop Table WORKFLOW_EVENTS';
	Drop Table dbo.WORKFLOW_EVENTS;

	print 'Create Table dbo.WORKFLOW_EVENTS';
	Create Table dbo.WORKFLOW_EVENTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WORKFLOW_EVENTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())

		, AUDIT_VERSION                      rowversion not null
		, AUDIT_ID                           uniqueidentifier not null
		, AUDIT_TABLE                        nvarchar(50) not null
		, AUDIT_TOKEN                        varchar(255) null
		, AUDIT_ACTION                       int null
		)
end -- if;
GO

-- 07/26/2008 Paul.  Add AUDIT_ACTION to speed workflow processing. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_EVENTS' and COLUMN_NAME = 'AUDIT_ACTION') begin -- then
	print 'alter table WORKFLOW_EVENTS add AUDIT_ACTION int null';
	alter table WORKFLOW_EVENTS add AUDIT_ACTION int null;
end -- if;
GO

-- 12/03/2008 Paul.  AUDIT_PARENT_ID is needed to roll-up events within a transaction. 
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'WORKFLOW_EVENTS' and COLUMN_NAME = 'AUDIT_PARENT_ID') begin -- then
	print 'alter table WORKFLOW_EVENTS add AUDIT_PARENT_ID uniqueidentifier null';
	alter table WORKFLOW_EVENTS add AUDIT_PARENT_ID uniqueidentifier null;
end -- if;
GO
