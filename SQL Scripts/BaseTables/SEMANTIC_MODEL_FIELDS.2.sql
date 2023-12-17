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
-- drop table SEMANTIC_MODEL_FIELDS;
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SEMANTIC_MODEL_FIELDS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SEMANTIC_MODEL_FIELDS';
	Create Table dbo.SEMANTIC_MODEL_FIELDS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SEMANTIC_MODEL_FIELDS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, TABLE_NAME                         nvarchar(64) null
		, NAME                               nvarchar(64) null
		, COLUMN_INDEX                       int null
		, DATA_TYPE                          nvarchar(25) null
		, FORMAT                             nvarchar(10) null
		, WIDTH                              int null
		, NULLABLE                           bit null
		, IS_AGGREGATE                       bit null
		, SORT_DESCENDING                    bit null
		, IDENTIFYING_ATTRIBUTE              bit null
		, DETAIL_ATTRIBUTE                   bit null
		, VALUE_SELECTION                    nvarchar(25) null
		, CONTEXTUAL_NAME                    nvarchar(25) null
		, DISCOURAGE_GROUPING                bit null
		, AGGREGATE_ATTRIBUTE                bit null
		, AGGREGATE_FUNCTION_NAME            nvarchar(25) null
		, DEFAULT_AGGREGATE                  bit null
		, VARIATION_PARENT_ID                uniqueidentifier null
		)

  end
GO


