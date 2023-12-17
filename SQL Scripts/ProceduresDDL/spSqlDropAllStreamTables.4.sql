if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlDropAllStreamTables' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlDropAllStreamTables;
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
Create Procedure dbo.spSqlDropAllStreamTables
as
  begin
	set nocount on

	declare @Command      varchar(max);
	declare @TABLE_NAME   varchar(80);
	declare @TRIGGER_NAME varchar(90);
	declare AUDIT_TABLES_CURSOR cursor for
	select TABLE_NAME
	  from vwSqlTables
	 where TABLE_NAME like '%_STREAM'
	order by TABLE_NAME;

	exec dbo.spSqlDropAllStreamProcedures ;
	exec dbo.spSqlDropAllStreamTriggers ;
	exec dbo.spSqlDropAllStreamFunctions ;
	exec dbo.spSqlDropAllStreamViews ;
	
	open AUDIT_TABLES_CURSOR;
	fetch next from AUDIT_TABLES_CURSOR into @TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = @TABLE_NAME and TABLE_TYPE = 'BASE TABLE') begin -- then
			set @Command = 'Drop Table dbo.' + @TABLE_NAME;
			print @Command;
			exec(@Command);
		end -- if;
		fetch next from AUDIT_TABLES_CURSOR into @TABLE_NAME;
	end -- while;
	close AUDIT_TABLES_CURSOR;
	deallocate AUDIT_TABLES_CURSOR;
  end
GO


Grant Execute on dbo.spSqlDropAllStreamTables to public;
GO

-- exec dbo.spSqlBuildAllStreamTables;
-- exec dbo.spSqlDropAllStreamTables;


