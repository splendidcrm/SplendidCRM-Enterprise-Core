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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CONTRACT_TYPES_DOCUMENTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CONTRACT_TYPES_DOCUMENTS';
	Create Table dbo.CONTRACT_TYPES_DOCUMENTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CONTRACT_TYPES_DOCUMENTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CONTRACT_TYPE_ID                   uniqueidentifier not null
		, DOCUMENT_ID                        uniqueidentifier not null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_CONTRACT_TYPES_DOCUMENTS_CONTRACT_TYPE_ID    on dbo.CONTRACT_TYPES_DOCUMENTS (CONTRACT_TYPE_ID, DELETED, DOCUMENT_ID     )
	create index IDX_CONTRACT_TYPES_DOCUMENTS_DOCUMENT_ID         on dbo.CONTRACT_TYPES_DOCUMENTS (DOCUMENT_ID     , DELETED, CONTRACT_TYPE_ID)
	-- create index IDX_CONTRACT_TYPES_DOCUMENTS_DOCUMENT_ID_TYPE_ID on dbo.CONTRACT_TYPES_DOCUMENTS (DOCUMENT_ID, CONTRACT_TYPE_ID, DELETED)

	alter table dbo.CONTRACT_TYPES_DOCUMENTS add constraint FK_CONTRACT_TYPES_DOCUMENTS_TYPE_ID     foreign key ( CONTRACT_TYPE_ID ) references dbo.CONTRACT_TYPES ( ID )
	alter table dbo.CONTRACT_TYPES_DOCUMENTS add constraint FK_CONTRACT_TYPES_DOCUMENTS_DOCUMENT_ID foreign key ( DOCUMENT_ID      ) references dbo.DOCUMENTS      ( ID )
  end
GO


