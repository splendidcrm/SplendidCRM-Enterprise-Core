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
-- 06/13/2016 Paul.  Similar to DefinitionIdentityTable.
-- drop table WF4_DEFINITION_IDENTITY;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WF4_DEFINITION_IDENTITY' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WF4_DEFINITION_IDENTITY';
	Create Table dbo.WF4_DEFINITION_IDENTITY
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WF4_DEFINITION_IDENTITY primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())

		, SURROGATE_IDENTITY_ID              uniqueidentifier not null  -- SurrogateIdentityId
		, DEFINITION_IDENTITY_HASH           uniqueidentifier not null  -- DefinitionIdentityHash
		, NAME                               nvarchar(256) null         -- Name
		, PACKAGE                            nvarchar(256) null         -- Package
		, VERSION                            nvarchar(25) null          -- Version
		, XAML                               nvarchar(max) null
		)

	create index IDX_WF4_DEFINITION_IDENTITY on dbo.WF4_DEFINITION_IDENTITY (SURROGATE_IDENTITY_ID, DEFINITION_IDENTITY_HASH)
  end
GO

