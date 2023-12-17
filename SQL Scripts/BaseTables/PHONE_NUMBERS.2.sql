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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PHONE_NUMBERS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PHONE_NUMBERS';
	Create Table dbo.PHONE_NUMBERS
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PHONE_NUMBERS primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, PARENT_ID                          uniqueidentifier not null
		, PARENT_TYPE                        nvarchar(25) null
		, PHONE_TYPE                         nvarchar(25) null
		, NORMALIZED_NUMBER                  nvarchar(50) null
		)
	-- 07/05/2012 Paul.  PHONE_TYPE values include 'Work', 'Home', 'Mobile', 'Fax', 'Other', 'Assistant', 'Office', 'Alternate'

	-- 07/05/2012 Paul.  When searching by parent, it is because we are going to insert a phone by type. 
	create index IDX_PHONE_NUMBERS_PARENT_ID  on dbo.PHONE_NUMBERS (PARENT_ID        , PHONE_TYPE , DELETED, NORMALIZED_NUMBER)
	-- 07/05/2012 Paul.  When searching by normalized number, it is because we are searching by parent type. 
	create index IDX_PHONE_NUMBERS_NORMALIZED on dbo.PHONE_NUMBERS (NORMALIZED_NUMBER, PARENT_TYPE, DELETED, PARENT_ID)
  end
GO

