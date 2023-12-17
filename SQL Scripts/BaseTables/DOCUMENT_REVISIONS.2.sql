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
-- 09/15/2009 Paul.  Convert data type to varbinary(max) to support Azure. 
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'DOCUMENT_REVISIONS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.DOCUMENT_REVISIONS';
	Create Table dbo.DOCUMENT_REVISIONS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_DOCUMENT_REVISIONS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CHANGE_LOG                         nvarchar(255) null
		, DOCUMENT_ID                        uniqueidentifier null
		, FILENAME                           nvarchar(255) null
		, FILE_EXT                           nvarchar(25) null
		, FILE_MIME_TYPE                     nvarchar(100) null
		, REVISION                           nvarchar(25) null
		, CONTENT                            varbinary(max) null
		)

	alter table dbo.DOCUMENT_REVISIONS add constraint FK_DOCUMENT_REVISIONS_DOCUMENT_ID foreign key ( DOCUMENT_ID ) references dbo.DOCUMENTS ( ID )
  end
GO


