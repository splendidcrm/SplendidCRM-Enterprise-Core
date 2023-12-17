
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
-- 12/19/2017 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ACCOUNTS_CASES') begin -- then
	-- 12/19/2017 Paul.  Just in case some customers have used this relationship table, only delete if empty. 
	if not exists(select * from ACCOUNTS_CASES) begin -- then
		print 'drop table ACCOUNTS_CASES';
		drop table ACCOUNTS_CASES;
	end -- if;
end -- if;
GO

-- 04/24/2018 Paul.  ACCOUNTS_CASES use was ended back in 2005. The table needs to be removed as it causes problems with archiving. 
if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ACCOUNTS_CASES_AUDIT') begin -- then
	-- 04/24/2018 Paul.  Just in case some customers have used this relationship table, only delete if empty. 
	if not exists(select * from ACCOUNTS_CASES_AUDIT) begin -- then
		print 'drop table ACCOUNTS_CASES_AUDIT';
		drop table ACCOUNTS_CASES_AUDIT;
	end -- if;
end -- if;
GO

-- 04/06/2020 Paul.  Delete related views. 
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_CASES')
	Drop View dbo.vwACCOUNTS_CASES;
GO

if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'vwACCOUNTS_CASES_ARCHIVE')
	Drop View dbo.vwACCOUNTS_CASES_ARCHIVE;
GO

