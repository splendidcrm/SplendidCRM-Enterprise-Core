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
-- 06/13/2016 Paul.  Add schema. 
-- 06/21/2017 Paul.  Index DATE_ENTERED for Cleanup. 
-- drop table WWF_TYPES;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'WWF_TYPES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.WWF_TYPES';
	Create Table dbo.WWF_TYPES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_WWF_TYPES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())

		, TYPE_FULL_NAME                     nvarchar(128) not null
		, ASSEMBLY_FULL_NAME                 nvarchar(256) not null
		, IS_INSTANCE_TYPE                   bit not null
		)

	create index IDX_WWF_TYPES      on dbo.WWF_TYPES (DELETED, TYPE_FULL_NAME, ASSEMBLY_FULL_NAME, ID)
	create index IDX_WWF_TYPES_DATE on dbo.WWF_TYPES (DATE_ENTERED)
  end
GO

