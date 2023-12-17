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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CONTRACTS_DOCUMENTS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CONTRACTS_DOCUMENTS';
	Create Table dbo.CONTRACTS_DOCUMENTS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CONTRACTS_DOCUMENTS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CONTRACT_ID                        uniqueidentifier not null
		, DOCUMENT_ID                        uniqueidentifier not null
		, DOCUMENT_REVISION_ID               uniqueidentifier not null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_CONTRACTS_DOCUMENTS_CONTRACT_ID on dbo.CONTRACTS_DOCUMENTS (CONTRACT_ID, DELETED, DOCUMENT_ID, DOCUMENT_REVISION_ID)
	create index IDX_CONTRACTS_DOCUMENTS_DOCUMENT_ID on dbo.CONTRACTS_DOCUMENTS (DOCUMENT_ID, DELETED, CONTRACT_ID)

	alter table dbo.CONTRACTS_DOCUMENTS add constraint FK_CONTRACTS_DOCUMENTS_CONTRACT_ID          foreign key ( CONTRACT_ID          ) references dbo.CONTRACTS          ( ID )
	alter table dbo.CONTRACTS_DOCUMENTS add constraint FK_CONTRACTS_DOCUMENTS_DOCUMENT_ID          foreign key ( DOCUMENT_ID          ) references dbo.DOCUMENTS          ( ID )
	alter table dbo.CONTRACTS_DOCUMENTS add constraint FK_CONTRACTS_DOCUMENTS_DOCUMENT_REVISION_ID foreign key ( DOCUMENT_REVISION_ID ) references dbo.DOCUMENT_REVISIONS ( ID )
  end
GO

