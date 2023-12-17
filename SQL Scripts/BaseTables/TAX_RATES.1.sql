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
-- 06/02/2012 Paul.  Tax Vendor is required to create a QuickBooks tax rate. 
-- 02/24/2015 Paul.  Add state for lookup. 
-- 04/07/2016 Paul.  Tax rates per team. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'TAX_RATES' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.TAX_RATES';
	Create Table dbo.TAX_RATES
		( ID                                 uniqueidentifier not null default(newid()) constraint PK_TAX_RATES primary key
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, TEAM_ID                            uniqueidentifier null
		, NAME                               nvarchar(50) not null
		, STATUS                             nvarchar(25) null
		, ADDRESS_STATE                      nvarchar(100) null
		, VALUE                              money null
		, LIST_ORDER                         int null
		, QUICKBOOKS_TAX_VENDOR              nvarchar(50) null
		, DESCRIPTION                        nvarchar(max) null
		, TEAM_SET_ID                        uniqueidentifier null
		)
  end
GO

