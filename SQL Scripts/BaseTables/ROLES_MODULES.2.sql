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
-- 12/13/2005 Paul.  Bad decision to change the name in SplendidCRM.  Change back. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ROLES_MODULES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.ROLES_MODULES';
	Create Table dbo.ROLES_MODULES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_ROLES_MODULES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ROLE_ID                            uniqueidentifier not null
		, MODULE_ID                          varchar(36) not null
		, ALLOW                              bit null default(0)
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_ROLES_MODULES_ROLE_ID   on dbo.ROLES_MODULES (ROLE_ID  , DELETED, MODULE_ID)
	create index IDX_ROLES_MODULES_MODULE_ID on dbo.ROLES_MODULES (MODULE_ID, DELETED, ROLE_ID  )
	-- create index IDX_ROLES_MODULES_ROLE_ID_MODULE_ID  on dbo.ROLES_MODULES ( ROLE_ID, MODULE_ID )

	alter table dbo.ROLES_MODULES add constraint FK_ROLES_MODULES_ROLE_ID foreign key ( ROLE_ID ) references dbo.ROLES ( ID )
  end
GO


