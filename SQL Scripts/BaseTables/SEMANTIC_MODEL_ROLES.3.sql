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
-- drop table SEMANTIC_MODEL_ROLES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SEMANTIC_MODEL_ROLES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SEMANTIC_MODEL_ROLES';
	Create Table dbo.SEMANTIC_MODEL_ROLES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SEMANTIC_MODEL_ROLES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, LHS_TABLE                          nvarchar(64) null
		, LHS_KEY                            nvarchar(64) null
		, RHS_TABLE                          nvarchar(64) null
		, RHS_KEY                            nvarchar(64) null
		, CARDINALITY                        nvarchar(25) null
		, NAME                               nvarchar(64) null
		)

  end
GO

