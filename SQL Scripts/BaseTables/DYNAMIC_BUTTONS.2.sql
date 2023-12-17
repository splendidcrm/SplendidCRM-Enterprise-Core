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
-- drop table DYNAMIC_BUTTONS;
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
-- 07/28/2010 Paul.  We need a flag to exclude a button from a mobile device. 
-- 03/14/2014 Paul.  Allow hidden buttons to be created. 
-- 08/16/2017 Paul.  Increase the size of the ONCLICK_SCRIPT so that we can add a javascript info column. 
-- 08/16/2017 Paul.  Add ability to apply a business rule to a button. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'DYNAMIC_BUTTONS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.DYNAMIC_BUTTONS';
	Create Table dbo.DYNAMIC_BUTTONS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_DYNAMIC_BUTTONS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, VIEW_NAME                          nvarchar( 50) not null
		, CONTROL_INDEX                      int not null
		, CONTROL_TYPE                       nvarchar( 25) not null
		, DEFAULT_VIEW                       bit null default(0)

		, MODULE_NAME                        nvarchar( 25) null
		, MODULE_ACCESS_TYPE                 nvarchar(100) null
		, TARGET_NAME                        nvarchar( 25) null
		, TARGET_ACCESS_TYPE                 nvarchar(100) null
		, MOBILE_ONLY                        bit null default(0)
		, ADMIN_ONLY                         bit null default(0)
		, EXCLUDE_MOBILE                     bit null default(0)
		, HIDDEN                             bit null default(0)

		, CONTROL_TEXT                       nvarchar(150) null
		, CONTROL_TOOLTIP                    nvarchar(150) null
		, CONTROL_ACCESSKEY                  nvarchar(150) null
		, CONTROL_CSSCLASS                   nvarchar( 50) null

		, TEXT_FIELD                         nvarchar(200) null
		, ARGUMENT_FIELD                     nvarchar(200) null

		, COMMAND_NAME                       nvarchar( 50) null
		, URL_FORMAT                         nvarchar(255) null
		, URL_TARGET                         nvarchar( 20) null
		, ONCLICK_SCRIPT                     nvarchar(max) null

		, BUSINESS_RULE                      nvarchar(max) null
		, BUSINESS_SCRIPT                    nvarchar(max) null
		)

	create index IDX_DYNAMIC_BUTTONS_DETAIL_NAME on dbo.DYNAMIC_BUTTONS (VIEW_NAME, DELETED)
  end
GO


