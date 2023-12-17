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
-- 07/24/2006 Paul.  Increase the DATA_LABEL to 150 to allow a fully-qualified (NAME+MODULE_NAME+LIST_NAME) TERMINOLOGY name. 
-- 04/02/2008 Paul.  Add Validation fields. 
-- 05/17/2009 Paul.  Add support for a generic module popup. 
-- 06/12/2009 Paul.  Add TOOL_TIP for help hover.
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 01/19/2010 Paul.  We need to be able to format a Float field to prevent too many decimal places. 
-- 09/13/2010 Paul.  Add relationship fields. 
-- 10/09/2010 Paul.  Add PARENT_FIELD so that we can establish dependent listboxes. 
-- 09/16/2012 Paul.  Increase ONCLICK_SCRIPT to nvarchar(max). 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EDITVIEWS_FIELDS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EDITVIEWS_FIELDS';
	Create Table dbo.EDITVIEWS_FIELDS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EDITVIEWS_FIELDS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, EDIT_NAME                          nvarchar( 50) not null
		, FIELD_INDEX                        int not null
		, FIELD_TYPE                         nvarchar( 25) not null
		, DEFAULT_VIEW                       bit null default(0)

		, DATA_LABEL                         nvarchar(150) null
		, DATA_FIELD                         nvarchar(100) null
		, DATA_FORMAT                        nvarchar(100) null
		, DISPLAY_FIELD                      nvarchar(100) null
		, CACHE_NAME                         nvarchar( 50) null
		, DATA_REQUIRED                      bit null
		, UI_REQUIRED                        bit null
		, ONCLICK_SCRIPT                     nvarchar(max) null
		, FORMAT_SCRIPT                      nvarchar(255) null
		, FORMAT_TAB_INDEX                   int null
		, FORMAT_MAX_LENGTH                  int null
		, FORMAT_SIZE                        int null
		, FORMAT_ROWS                        int null
		, FORMAT_COLUMNS                     int null
		, COLSPAN                            int null
		, ROWSPAN                            int null
		, FIELD_VALIDATOR_ID                 uniqueidentifier null
		, FIELD_VALIDATOR_MESSAGE            nvarchar(150) null
		, MODULE_TYPE                        nvarchar(25) null
		, TOOL_TIP                           nvarchar(150) null

		, RELATED_SOURCE_MODULE_NAME         nvarchar(50) null
		, RELATED_SOURCE_VIEW_NAME           nvarchar(50) null
		, RELATED_SOURCE_ID_FIELD            nvarchar(30) null
		, RELATED_SOURCE_NAME_FIELD          nvarchar(100) null
		, RELATED_VIEW_NAME                  nvarchar(50) null
		, RELATED_ID_FIELD                   nvarchar(30) null
		, RELATED_NAME_FIELD                 nvarchar(100) null
		, RELATED_JOIN_FIELD                 nvarchar(30) null
		, PARENT_FIELD                       nvarchar(30) null
		)

	create index IDX_EDITVIEWS_FIELDS_EDIT_NAME on dbo.EDITVIEWS_FIELDS (EDIT_NAME, DELETED)
	-- 12/31/2010 Irantha.  Add index to improve caching. 
	create index IDX_EDITVIEWS_FIELDS_CACHE_NAME on dbo.EDITVIEWS_FIELDS (DATA_FIELD, DELETED, FIELD_TYPE, DEFAULT_VIEW, CACHE_NAME)
  end
GO

