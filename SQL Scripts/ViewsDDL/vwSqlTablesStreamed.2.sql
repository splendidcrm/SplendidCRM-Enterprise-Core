if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwSqlTablesStreamed')
	Drop View dbo.vwSqlTablesStreamed;
GO


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
-- 08/22/2017 Paul.  Manually specify default collation to ease migration to Azure
-- 06/25/2018 Paul.  Data Privacy is not streamed. 
-- 05/24/2020 Paul.  Exclude Azure tables. 
Create View dbo.vwSqlTablesStreamed
as
select TABLE_NAME
  from vwSqlTables
 where exists(select * from vwSqlTables AUDIT_TABLES where AUDIT_TABLES.TABLE_NAME = vwSqlTables.TABLE_NAME + N'_AUDIT')
   and exists(select * from vwSqlTables CSTM_TABLES  where CSTM_TABLES.TABLE_NAME  = vwSqlTables.TABLE_NAME + N'_CSTM')
   and exists(select * from INFORMATION_SCHEMA.COLUMNS vwSqlColumns  where vwSqlColumns.TABLE_NAME = vwSqlTables.TABLE_NAME collate database_default and vwSqlColumns.COLUMN_NAME = 'ASSIGNED_USER_ID')
   and TABLE_NAME not like 'AZURE[_]%'
   and TABLE_NAME not in
( N'CALLS'
, N'DATA_PRIVACY'
, N'MEETINGS'
, N'EMAILS'
, N'TASKS'
, N'NOTES'
, N'SMS_MESSAGES'
, N'TWITTER_MESSAGES'
, N'CALL_MARKETING'
, N'PROJECT'
, N'PROJECT_TASK'
, N'PRODUCT_TEMPLATES'
, N'INVOICES_LINE_ITEMS'
, N'ORDERS_LINE_ITEMS'
, N'QUOTES_LINE_ITEMS'
, N'REVENUE_LINE_ITEMS'
, N'PAYMENTS'
, N'CREDIT_CARDS'
, N'REGIONS'
, N'SURVEY_QUESTIONS'
, N'TEST_CASES'
, N'TEST_PLANS'
, N'THREADS'
, N'USERS'
)
GO


Grant Select on dbo.vwSqlTablesStreamed to public;
GO

-- select * from vwSqlTablesStreamed order by 1;

