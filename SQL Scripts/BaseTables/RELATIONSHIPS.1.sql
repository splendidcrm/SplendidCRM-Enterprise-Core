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
-- 04/21/2006 Paul.  RELATIONSHIP_ROLE_COLUMN_VALUE was increased to nvarchar(50) in SugarCRM 4.0.
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'RELATIONSHIPS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.RELATIONSHIPS';
	Create Table dbo.RELATIONSHIPS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_RELATIONSHIPS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, RELATIONSHIP_NAME                  nvarchar(150) null
		, LHS_MODULE                         nvarchar(100) null
		, LHS_TABLE                          nvarchar( 64) null
		, LHS_KEY                            nvarchar( 64) null
		, RHS_MODULE                         nvarchar(100) null
		, RHS_TABLE                          nvarchar( 64) null
		, RHS_KEY                            nvarchar( 64) null
		, JOIN_TABLE                         nvarchar( 64) null
		, JOIN_KEY_LHS                       nvarchar( 64) null
		, JOIN_KEY_RHS                       nvarchar( 64) null
		, RELATIONSHIP_TYPE                  nvarchar( 64) null
		, RELATIONSHIP_ROLE_COLUMN           nvarchar( 64) null
		, RELATIONSHIP_ROLE_COLUMN_VALUE     nvarchar( 50) null
		, REVERSE                            bit null default(0)
		)

	create index IDX_RELATIONSHIPS_NAME on dbo.RELATIONSHIPS (RELATIONSHIP_NAME)
  end
GO


