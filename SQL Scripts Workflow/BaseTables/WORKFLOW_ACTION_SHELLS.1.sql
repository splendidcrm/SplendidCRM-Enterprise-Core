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
-- Drop Table dbo.WORKFLOW_ACTION_SHELLS;
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
/*
1. Select Action Type (action_type)
	update    : Update fields in the target module 
	update_rel: Update fields in a related module 
	new       : Create a record in a module associated with target module 
	new_rel   : Create a record associated with a module related to the target module 

*/
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WORKFLOW_ACTION_SHELLS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WORKFLOW_ACTION_SHELLS';
	Create Table dbo.WORKFLOW_ACTION_SHELLS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WORKFLOW_ACTION_SHELLS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, PARENT_ID                          uniqueidentifier not null
		, NAME                               nvarchar(100) not null
		, ACTION_TYPE                        nvarchar(25) null
		, PARAMETERS                         nvarchar(100) null
		, REL_MODULE                         nvarchar(100) null
		, REL_MODULE_TYPE                    nvarchar(25) null
		, ACTION_MODULE                      nvarchar(100) null
		, CUSTOM_XOML                        bit null default(0)
		, RDL                                nvarchar(max) null
		, XOML                               nvarchar(max) null
		)

	create index IDX_WORKFLOW_ACTION_SHELLS_PARENT_ID on dbo.WORKFLOW_ACTION_SHELLS (PARENT_ID, DELETED, ID)
  end
GO

