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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 09/01/2010 Paul.  Store a copy of the DEFAULT_SEARCH_ID in the table so that we don't need to read the XML in order to get the value. 
-- 09/01/2010 Paul.  We also need a separate module-only field so that the query will get all records for the module. 
-- 09/02/1010 Paul.  Adding the default search caused lots of problems, so we are going to ignore the fields for now. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SAVED_SEARCH' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SAVED_SEARCH';
	Create Table dbo.SAVED_SEARCH
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SAVED_SEARCH primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier null
		, DEFAULT_SEARCH_ID                  uniqueidentifier null
		, NAME                               nvarchar(150) null
		, SEARCH_MODULE                      nvarchar(150) null
		, CONTENTS                           nvarchar(max) null
		, DESCRIPTION                        nvarchar(max) null
		)

	create index IDX_SAVED_SEARCH on dbo.SAVED_SEARCH (ASSIGNED_USER_ID, SEARCH_MODULE, NAME, DELETED, ID)
  end
GO


