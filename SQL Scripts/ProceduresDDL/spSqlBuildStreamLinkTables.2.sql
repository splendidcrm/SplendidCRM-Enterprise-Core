if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildStreamLinkTables' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildStreamLinkTables;
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
-- 05/24/2020 Paul.  Exclude AZURE_APP_UPDATES_ORDERS_AUDIT. 
Create Procedure dbo.spSqlBuildStreamLinkTables(@TABLE_NAME varchar(80))
as
  begin
	set nocount on
	print N'spSqlBuildStreamLinkTables ' + @TABLE_NAME;

	declare @LINK_TABLE_NAME    varchar(80);
	declare @RELATED_TABLE_NAME varchar(80);
	declare LEFT_TABLES_CURSOR cursor for
	select TABLE_NAME
	  from vwSqlTables
	 where TABLE_NAME     like @TABLE_NAME + '[_]%[_]AUDIT'
	   and TABLE_NAME not like @TABLE_NAME + '[_]CSTM[_]AUDIT'
	   and TABLE_NAME not like '%[_]RELATED[_]AUDIT'
	   and TABLE_NAME not like '%[_]USERS[_]AUDIT'
	   and TABLE_NAME not like '%[_]TEAMS[_]AUDIT'
	   and TABLE_NAME not like '%[_]SQL[_]AUDIT'
	   and TABLE_NAME not like '%[_]KBTAGS[_]AUDIT'
	   and TABLE_NAME not like '%[_]THREADS[_]AUDIT'
	   and TABLE_NAME not like '%[_]LINE[_]ITEMS[_]AUDIT'
	   and TABLE_NAME not like '%[_]LINE[_]ITEMS[_]CSTM[_]AUDIT'
	order by TABLE_NAME;

	open LEFT_TABLES_CURSOR;
	fetch next from LEFT_TABLES_CURSOR into @LINK_TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		set @LINK_TABLE_NAME = substring(@LINK_TABLE_NAME, 1, len(@LINK_TABLE_NAME) - 6);
		set @RELATED_TABLE_NAME = substring(@LINK_TABLE_NAME, len(@TABLE_NAME) + 2, len(@LINK_TABLE_NAME));
		-- print '	' + @LINK_TABLE_NAME + ', ' + @TABLE_NAME + ', ' + @RELATED_TABLE_NAME;
		exec dbo.spSqlBuildStreamLinkTrigger @LINK_TABLE_NAME, @TABLE_NAME, @RELATED_TABLE_NAME
		fetch next from LEFT_TABLES_CURSOR into @LINK_TABLE_NAME;
	end -- while;
	close LEFT_TABLES_CURSOR;
	deallocate LEFT_TABLES_CURSOR;

	-- 09/29/2015 Paul.  Exclude CONTRACT_TYPES_DOCUMENTS as the information is not useful. 
	-- 11/01/2015 Paul.  Exclude AZURE_ORDERS as there is no AZURE table. 
	-- 05/24/2020 Paul.  Exclude AZURE_APP_UPDATES_ORDERS_AUDIT. 
	declare RIGHT_TABLES_CURSOR cursor for
	select TABLE_NAME
	  from vwSqlTables
	 where TABLE_NAME     like '%[_]' + @TABLE_NAME + '[_]AUDIT'
	   and TABLE_NAME not like '%[_]USERS[_]AUDIT'
	   and TABLE_NAME not like '%[_]TEAMS[_]AUDIT'
	   and TABLE_NAME not like '%[_]SQL[_]AUDIT'
	   and TABLE_NAME not like '%[_]KBTAGS[_]AUDIT'
	   and TABLE_NAME not like '%[_]THREADS[_]AUDIT'
	   and TABLE_NAME not like '%[_]LINE[_]ITEMS[_]AUDIT'
	   and TABLE_NAME not like '%[_]LINE[_]ITEMS[_]CSTM[_]AUDIT'
	   and TABLE_NAME not in ('CONTRACT_TYPES_DOCUMENTS_AUDIT', 'AZURE_ORDERS_AUDIT', 'AZURE_APP_UPDATES_ORDERS_AUDIT')
	order by TABLE_NAME;

	open RIGHT_TABLES_CURSOR;
	fetch next from RIGHT_TABLES_CURSOR into @LINK_TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		set @LINK_TABLE_NAME = substring(@LINK_TABLE_NAME, 1, len(@LINK_TABLE_NAME) - 6);
		set @RELATED_TABLE_NAME = substring(@LINK_TABLE_NAME, 1, len(@LINK_TABLE_NAME) - len(@TABLE_NAME) - 1);
		-- print '	' + @LINK_TABLE_NAME + ', ' + @RELATED_TABLE_NAME + ', ' + @TABLE_NAME;
		exec dbo.spSqlBuildStreamLinkTrigger @LINK_TABLE_NAME, @TABLE_NAME, @RELATED_TABLE_NAME
		fetch next from RIGHT_TABLES_CURSOR into @LINK_TABLE_NAME;
	end -- while;
	close RIGHT_TABLES_CURSOR;
	deallocate RIGHT_TABLES_CURSOR;
  end
GO


Grant Execute on dbo.spSqlBuildStreamLinkTables to public;
GO

