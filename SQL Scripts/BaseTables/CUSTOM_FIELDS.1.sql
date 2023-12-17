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
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CUSTOM_FIELDS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CUSTOM_FIELDS';
	Create Table dbo.CUSTOM_FIELDS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CUSTOM_FIELDS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())
	
		, SET_NUM                            int null default(0)
		, FIELD0                             nvarchar(255) null
		, FIELD1                             nvarchar(255) null
		, FIELD2                             nvarchar(255) null
		, FIELD3                             nvarchar(255) null
		, FIELD4                             nvarchar(255) null
		, FIELD5                             nvarchar(255) null
		, FIELD6                             nvarchar(255) null
		, FIELD7                             nvarchar(255) null
		, FIELD8                             nvarchar(255) null
		, FIELD9                             nvarchar(255) null
		)

	create index IDX_CUSTOM_FIELDS_BEAN_ID_SET_NUM on dbo.CUSTOM_FIELDS (ID, SET_NUM)
  end
GO


