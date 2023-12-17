if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlDropAllArchiveTables' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlDropAllArchiveTables;
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
Create Procedure dbo.spSqlDropAllArchiveTables
	( @ARCHIVE_DATABASE nvarchar(50) = null
	)
as
  begin
	set nocount on
	print 'spSqlDropAllArchiveTables';

	declare @COMMAND      nvarchar(max);
	declare @TABLE_NAME   nvarchar(80);
	declare @ARCHIVE_DATABASE_DOT nvarchar(50);
	if len(@ARCHIVE_DATABASE) > 0 begin -- then
		set @ARCHIVE_DATABASE_DOT = '[' + @ARCHIVE_DATABASE + '].';
	end else begin
		set @ARCHIVE_DATABASE_DOT = '';
	end -- if;

	set @COMMAND = 'declare ARCHIVE_TABLES_CURSOR cursor for
	select TABLE_NAME
	  from ' + @ARCHIVE_DATABASE_DOT + 'INFORMATION_SCHEMA.TABLES
	 where TABLE_NAME like ''%_ARCHIVE''
	   and TABLE_TYPE = ''BASE TABLE''
	order by TABLE_NAME';
print @COMMAND;
	exec sp_executesql @COMMAND;

	if exists(select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlDropAllArchiveViews' and ROUTINE_TYPE = 'PROCEDURE') begin -- then
		exec('dbo.spSqlDropAllArchiveViews');
	end -- if;
	if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'MODULES_ARCHIVE_LOG') begin -- then
		exec('delete from MODULES_ARCHIVE_LOG');
	end -- if;
	
	open ARCHIVE_TABLES_CURSOR;
	fetch next from ARCHIVE_TABLES_CURSOR into @TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		set @COMMAND = 'Drop Table ' + @ARCHIVE_DATABASE_DOT + 'dbo.' + @TABLE_NAME;
		print @COMMAND;
		exec(@COMMAND);
		fetch next from ARCHIVE_TABLES_CURSOR into @TABLE_NAME;
	end -- while;
	close ARCHIVE_TABLES_CURSOR;
	deallocate ARCHIVE_TABLES_CURSOR;
  end
GO


Grant Execute on dbo.spSqlDropAllArchiveTables to public;
GO

-- exec dbo.spSqlDropAllArchiveTables ;


