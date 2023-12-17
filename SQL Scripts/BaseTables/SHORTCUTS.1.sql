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
-- 04/28/2006 Paul.  Added SHORTCUT_MODULE to help with ACL. 
-- 04/28/2006 Paul.  Added SHORTCUT_ACLTYPE to help with ACL. 
-- 07/24/2006 Paul.  Increase the DISPLAY_NAME to 150 to allow a fully-qualified (NAME+MODULE_NAME+LIST_NAME) TERMINOLOGY name. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SHORTCUTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SHORTCUTS';
	Create Table dbo.SHORTCUTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_SHORTCUTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, MODULE_NAME                        nvarchar( 25) not null
		, DISPLAY_NAME                       nvarchar(150) not null
		, RELATIVE_PATH                      nvarchar(255) not null
		, IMAGE_NAME                         nvarchar( 50) null
		, SHORTCUT_ENABLED                   bit null default(1)
		, SHORTCUT_ORDER                     int null
		, SHORTCUT_MODULE                    nvarchar( 25) null
		, SHORTCUT_ACLTYPE                   nvarchar(100) null
		)
	-- 12/30/2010 Irantha.  Add index for caching. 
	create index IX_SHORTCUTS_SHORTCUT_ORDER on dbo.SHORTCUTS(DELETED, SHORTCUT_ORDER, SHORTCUT_MODULE)
  end
GO


