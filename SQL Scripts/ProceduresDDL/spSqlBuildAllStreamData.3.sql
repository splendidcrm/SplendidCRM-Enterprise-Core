if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildAllStreamData' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildAllStreamData;
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
-- 04/23/2017 Paul. Don't populate stream tables if streaming has been disabled. 
-- 09/25/2017 Paul.  Archive tables are not audited. 
Create Procedure dbo.spSqlBuildAllStreamData
as
  begin
	set nocount on
	print N'spSqlBuildAllStreamData';

	declare @ENABLE_ACTIVITY_STREAMS bit;
	declare @TABLE_NAME varchar(80);
	declare TABLES_CURSOR cursor for
	select vwSqlTablesStreamed.TABLE_NAME
	  from      vwSqlTablesStreamed
	 inner join vwSqlTables
	         on vwSqlTables.TABLE_NAME = vwSqlTablesStreamed.TABLE_NAME + '_STREAM'
	order by vwSqlTablesStreamed.TABLE_NAME;
	
	-- 10/30/2015 Paul.  Exclude EMAILS table because there are separate relationship tables where the parent info is also stored. 
	-- If we include EMAILS Parent events then we would get 2 activity records for each email. 
	-- 01/15/2018 Paul.  Exclude NAICS and PROCESSES. 
	declare PARENT_TABLES_CURSOR cursor for
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

	-- 04/23/2017 Paul. Don't populate stream tables if streaming has been disabled. 
	select top 1 @ENABLE_ACTIVITY_STREAMS = (case lower(convert(nvarchar(20), VALUE)) when '1' then 1 when 'true' then 1 else 0 end)
	  from CONFIG
	 where NAME = 'enable_activity_streams'
	   and DELETED = 0;

	if @ENABLE_ACTIVITY_STREAMS = 1 begin -- then
		open TABLES_CURSOR;
		fetch next from TABLES_CURSOR into @TABLE_NAME;
		while @@FETCH_STATUS = 0 begin -- do
			exec dbo.spSqlBuildStreamData           @TABLE_NAME;
			exec dbo.spSqlBuildStreamLinkDataTables @TABLE_NAME;
			fetch next from TABLES_CURSOR into @TABLE_NAME;
		end -- while;
		close TABLES_CURSOR;
	
		open PARENT_TABLES_CURSOR;
		fetch next from PARENT_TABLES_CURSOR into @TABLE_NAME;
		while @@FETCH_STATUS = 0 begin -- do
			exec dbo.spSqlBuildStreamParentData @TABLE_NAME;
			fetch next from PARENT_TABLES_CURSOR into @TABLE_NAME;
		end -- while;
		close PARENT_TABLES_CURSOR;
	end -- if;
	-- 06/23/2017 Paul.  Deallocate must be outside the if clause. 
	deallocate TABLES_CURSOR;
	deallocate PARENT_TABLES_CURSOR;
  end
GO


Grant Execute on dbo.spSqlBuildAllStreamData to public;
GO

-- exec dbo.spSqlBuildAllStreamData ;

