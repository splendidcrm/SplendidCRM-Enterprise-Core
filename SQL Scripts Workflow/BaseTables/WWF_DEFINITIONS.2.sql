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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 06/13/2016 Paul.  Add schema. 
-- 06/21/2017 Paul.  Index DATE_ENTERED for Cleanup. 
-- drop table WWF_DEFINITIONS;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WWF_DEFINITIONS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WWF_DEFINITIONS';
	Create Table dbo.WWF_DEFINITIONS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WWF_DEFINITIONS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())

		, WORKFLOW_TYPE_ID                   uniqueidentifier not null
		, WORKFLOW_DEFINITION                nvarchar(max) null
		)

	create index IDX_WWF_DEFINITIONS_TYPE_ID on dbo.WWF_DEFINITIONS (WORKFLOW_TYPE_ID)
	create index IDX_WWF_DEFINITIONS_DATE    on dbo.WWF_DEFINITIONS (DATE_ENTERED)

	alter table dbo.WWF_DEFINITIONS add constraint FK_WWF_DEFINITIONS_TYPE_ID foreign key ( WORKFLOW_TYPE_ID ) references dbo.WWF_TYPES (ID)
  end
GO

