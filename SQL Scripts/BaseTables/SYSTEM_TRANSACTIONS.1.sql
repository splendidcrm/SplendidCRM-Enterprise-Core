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
-- drop table SYSTEM_TRANSACTIONS;
-- 10/07/2009 Paul.  This table will be slightly different than all the rest.  
-- We want it to have the same core fields, but in this case the ID field will be generated in the client app. 
-- The goal will be to use the SQL Server 2008 MERGE statement. 
-- http://weblogs.sqlteam.com/mladenp/archive/2007/08/03/60277.aspx
-- 10/28/2009 Paul.  Add UTC date to allow this table to sync. 
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SYSTEM_TRANSACTIONS' and TABLE_TYPE = 'BASE TABLE')
  begin
	print 'Create Table dbo.SYSTEM_TRANSACTIONS';
	Create Table dbo.SYSTEM_TRANSACTIONS
		( ID                                 uniqueidentifier not null
		, DELETED                            bit not null default(0)
		, CREATED_BY                         uniqueidentifier null
		, DATE_ENTERED                       datetime not null default(getdate())
		, MODIFIED_USER_ID                   uniqueidentifier not null
		, DATE_MODIFIED                      datetime not null default(getdate())
		, DATE_MODIFIED_UTC                  datetime null default(getutcdate())

		, SESSION_SPID                       int not null constraint PK_SYSTEM_TRANSACTIONS primary key
		)
	
	create index IDX_SYSTEM_TRANSACTIONS on dbo.SYSTEM_TRANSACTIONS(SESSION_SPID) include (ID, MODIFIED_USER_ID);
  end
GO


