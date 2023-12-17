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
-- 07/24/2006 Paul.  Increase the MODULE_NAME to 25 to match the size in the MODULES table.
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 03/06/2012 Paul.  Increase size of the NAME field so that it can include a date formula. 
-- 02/11/2017 Paul.  New index based on missing indexes query. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TERMINOLOGY' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TERMINOLOGY';
	Create Table dbo.TERMINOLOGY
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TERMINOLOGY primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(150) null
		, LANG                               nvarchar(10) null
		, MODULE_NAME                        nvarchar(25) null
		, LIST_NAME                          nvarchar(50) null
		, LIST_ORDER                         int null
		, DISPLAY_NAME                       nvarchar(max) null
		)

	create index IX_TERMINOLOGY_DISPLAY_NAME on dbo.TERMINOLOGY(LANG, MODULE_NAME, NAME, LIST_NAME)
	-- 12/30/2010 Irantha.  Add index for list caching. 
	create index IX_TERMINOLOGY_LIST_NAME on dbo.TERMINOLOGY(DELETED, LANG, LIST_NAME)
	-- 02/11/2017 Paul.  New index based on missing indexes query. 
	create index IDX_TERMINOLOGY_DELETED_LIST on dbo.TERMINOLOGY (DELETED, LIST_NAME)
  end
GO


