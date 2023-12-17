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
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PRODUCT_PRODUCT' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.PRODUCT_PRODUCT';
	Create Table dbo.PRODUCT_PRODUCT
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_PRODUCT_PRODUCT primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, PARENT_ID                          uniqueidentifier not null
		, CHILD_ID                           uniqueidentifier not null
		)

	-- 09/10/2009 Paul.  The indexes should be fully covered. 
	create index IDX_PRODUCT_PRODUCT_PARENT_ID on dbo.PRODUCT_PRODUCT (PARENT_ID, DELETED, CHILD_ID )
	create index IDX_PRODUCT_PRODUCT_CHILD_ID  on dbo.PRODUCT_PRODUCT (CHILD_ID , DELETED, PARENT_ID)

	-- 07/10/2010 Paul.  We are now using the PRODUCT_PRODUCT for PRODUCT_TEMPLATES relationships. 
	-- alter table dbo.PRODUCT_PRODUCT add constraint FK_PRODUCT_PRODUCT_PARENT_ID foreign key ( PARENT_ID ) references dbo.PRODUCTS ( ID )
	-- alter table dbo.PRODUCT_PRODUCT add constraint FK_PRODUCT_PRODUCT_CHILD_ID  foreign key ( CHILD_ID  ) references dbo.PRODUCTS ( ID )
  end
GO


