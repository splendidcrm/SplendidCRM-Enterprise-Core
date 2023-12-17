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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CONTACTS_DATA_PRIVACY' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CONTACTS_DATA_PRIVACY';
	Create Table dbo.CONTACTS_DATA_PRIVACY
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CONTACTS_DATA_PRIVACY primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, CONTACT_ID                         uniqueidentifier not null
		, DATA_PRIVACY_ID                    uniqueidentifier not null
		)

	create index IDX_CONTACTS_PRIVACY_CONTACT on dbo.CONTACTS_DATA_PRIVACY (CONTACT_ID     , DELETED, DATA_PRIVACY_ID)
	create index IDX_CONTACTS_DATA_PRIVACY_ID on dbo.CONTACTS_DATA_PRIVACY (DATA_PRIVACY_ID, DELETED, CONTACT_ID     )

	alter table dbo.CONTACTS_DATA_PRIVACY add constraint FK_CONTACTS_PRIVACY_CONTACT  foreign key ( CONTACT_ID      ) references dbo.CONTACTS     ( ID )
	alter table dbo.CONTACTS_DATA_PRIVACY add constraint FK_CONTACTS_DATA_PRIVACY_ID  foreign key ( DATA_PRIVACY_ID ) references dbo.DATA_PRIVACY ( ID )
  end
GO


