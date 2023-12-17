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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ACL_ROLES_ACTIONS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.ACL_ROLES_ACTIONS';
	Create Table dbo.ACL_ROLES_ACTIONS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_ACL_ROLES_ACTIONS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ROLE_ID                            uniqueidentifier not null
		, ACTION_ID                          uniqueidentifier not null
		, ACCESS_OVERRIDE                    int null
		)

	create index IDX_ACL_ROLES_ACTIONS_ROLE_ID   on dbo.ACL_ROLES_ACTIONS (ROLE_ID  )
	create index IDX_ACL_ROLES_ACTIONS_ACTION_ID on dbo.ACL_ROLES_ACTIONS (ACTION_ID)

	alter table dbo.ACL_ROLES_ACTIONS add constraint FK_ACL_ROLES_ACTIONS_ROLE_ID   foreign key ( ROLE_ID   ) references dbo.ACL_ROLES   ( ID )
	alter table dbo.ACL_ROLES_ACTIONS add constraint FK_ACL_ROLES_ACTIONS_ACTION_ID foreign key ( ACTION_ID ) references dbo.ACL_ACTIONS ( ID )
  end
GO


