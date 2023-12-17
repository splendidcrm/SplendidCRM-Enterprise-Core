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
-- 04/27/2006 Paul.  Add URL_MODULE to support ACL.
-- 05/02/2006 Paul.  Add URL_ASSIGNED_FIELD to support ACL. 
-- 07/24/2006 Paul.  Increase the HEADER_TEXT to 150 to allow a fully-qualified (NAME+MODULE_NAME+LIST_NAME) TERMINOLOGY name. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 02/16/2010 Paul.  Add MODULE_TYPE so that we can lookup custom field IDs. 
-- 08/02/2010 Paul.  Increase the size of the URL_FIELD and URL_FORMAT so that we can add a javascript info column. 
-- 10/09/2010 Paul.  Add PARENT_FIELD so that we can establish dependent listboxes. 
-- 10/30/2013 Paul.  Increase size of URL_TARGET. 
-- 03/01/2014 Paul.  Increase size of DATA_FORMAT. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'GRIDVIEWS_COLUMNS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.GRIDVIEWS_COLUMNS';
	Create Table dbo.GRIDVIEWS_COLUMNS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_GRIDVIEWS_COLUMNS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, GRID_NAME                          nvarchar( 50) not null
		, COLUMN_INDEX                       int not null
		, COLUMN_TYPE                        nvarchar( 25) not null
		, DEFAULT_VIEW                       bit null default(0)

		, HEADER_TEXT                        nvarchar(150) null
		, SORT_EXPRESSION                    nvarchar( 50) null
		, ITEMSTYLE_WIDTH                    nvarchar( 10) null
		, ITEMSTYLE_CSSCLASS                 nvarchar( 50) null
		, ITEMSTYLE_HORIZONTAL_ALIGN         nvarchar( 10) null
		, ITEMSTYLE_VERTICAL_ALIGN           nvarchar( 10) null
		, ITEMSTYLE_WRAP                     bit null

		, DATA_FIELD                         nvarchar( 50) null
		, DATA_FORMAT                        nvarchar( 25) null
		, URL_FIELD                          nvarchar(max) null
		, URL_FORMAT                         nvarchar(max) null
		, URL_TARGET                         nvarchar( 60) null
		, LIST_NAME                          nvarchar( 50) null
		, URL_MODULE                         nvarchar( 25) null
		, URL_ASSIGNED_FIELD                 nvarchar( 30) null
		, MODULE_TYPE                        nvarchar( 25) null
		, PARENT_FIELD                       nvarchar( 30) null
		)

	create index IDX_GRIDVIEWS_COLUMNS_GRID_NAME on dbo.GRIDVIEWS_COLUMNS (GRID_NAME, DELETED)
  end
GO


