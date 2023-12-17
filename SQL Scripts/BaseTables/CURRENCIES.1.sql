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
-- 04/30/2016 Paul.  Add reference to log entry that modified the record. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'CURRENCIES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.CURRENCIES';
	Create Table dbo.CURRENCIES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_CURRENCIES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, NAME                               nvarchar(36) not null
		, SYMBOL                             nvarchar(36) not null
		, ISO4217                            nvarchar(3) not null
		, CONVERSION_RATE                    float not null default(0.0)
		, STATUS                             nvarchar(25) null
		, SYSTEM_CURRENCY_LOG_ID             uniqueidentifier null
		)

	create index IDX_CURRENCIES_NAME on dbo.CURRENCIES (NAME, DELETED)
  end
GO


