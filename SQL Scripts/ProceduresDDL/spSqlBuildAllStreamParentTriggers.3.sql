if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildAllStreamParentTriggers' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildAllStreamParentTriggers;
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
-- 07/31/2017 Paul.  Exclude NAICS_CODE_SETS. 
-- 09/25/2017 Paul.  Archive tables are not audited. 
Create Procedure dbo.spSqlBuildAllStreamParentTriggers
as
  begin
	set nocount on
	print N'spSqlBuildAllStreamParentTriggers';

	-- 10/30/2015 Paul.  Exclude EMAILS table because there are separate relationship tables where the parent info is also stored. 
	-- If we include EMAILS Parent events then we would get 2 activity records for each email. 
	-- 01/15/2018 Paul.  Exclude NAICS and PROCESSES. 
	declare @TABLE_NAME varchar(80);
	declare TABLES_CURSOR cursor for
	select TABLE_NAME
	  from INFORMATION_SCHEMA.COLUMNS
	 where COLUMN_NAME = 'PARENT_ID'
	   and TABLE_NAME not like 'vw%'
	   and TABLE_NAME not like '%[_]AUDIT'
	   and TABLE_NAME not like '%[_]ARCHIVE'
	   and TABLE_NAME not like '%[_]SYNC'
	   and TABLE_NAME not like 'WORKFLOW[_]%'
	   and TABLE_NAME not in ('EMAILS', 'EMAIL_IMAGES', 'IMAGES', 'PHONE_NUMBERS', 'PROJECT_TASK', 'SUBSCRIPTIONS', 'CHAT_MESSAGES')
	   and TABLE_NAME not in ('EXCHANGE_FOLDERS', 'PRODUCT_PRODUCT', 'PRODUCT_CATEGORIES', 'LINKED_DOCUMENTS', 'SURVEY_RESULTS', 'TIME_PERIODS', 'WORKFLOW')
	   and TABLE_NAME not in ('NAICS_CODE_SETS', 'NAICS_CODES_RELATED', 'PROCESSES', 'PROCESSES_OPTOUT')
	 order by TABLE_NAME;
	
	open TABLES_CURSOR;
	fetch next from TABLES_CURSOR into @TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		exec dbo.spSqlBuildStreamParentTrigger @TABLE_NAME;
		fetch next from TABLES_CURSOR into @TABLE_NAME;
	end -- while;
	close TABLES_CURSOR;
	deallocate TABLES_CURSOR;
  end
GO


Grant Execute on dbo.spSqlBuildAllStreamParentTriggers to public;
GO

-- exec dbo.spSqlBuildAllStreamParentTriggers ;

