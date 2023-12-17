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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'EXCHANGE_ADDIN_LOGINS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.EXCHANGE_ADDIN_LOGINS';
	Create Table dbo.EXCHANGE_ADDIN_LOGINS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_EXCHANGE_ADDIN_LOGINS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, ASSIGNED_USER_ID                   uniqueidentifier not null
		, EXCHANGE_USER_ID                   uniqueidentifier null
		)

	create index IDX_EXCHANGE_ADDIN_LOGINS      on dbo.EXCHANGE_ADDIN_LOGINS (EXCHANGE_USER_ID, DELETED, ASSIGNED_USER_ID)
	create index IDX_EXCHANGE_ADDIN_LOGINS_USER on dbo.EXCHANGE_ADDIN_LOGINS (ASSIGNED_USER_ID, DELETED)
  end
GO

