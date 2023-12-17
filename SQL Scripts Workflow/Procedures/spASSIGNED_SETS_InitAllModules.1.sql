if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spASSIGNED_SETS_InitAllModules' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spASSIGNED_SETS_InitAllModules;
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
Create Procedure dbo.spASSIGNED_SETS_InitAllModules
as
  begin
	set nocount on
	
	declare @Command            nvarchar(max);
	declare @CRLF               char(2);
	declare @ASSIGNED_USER_ID   uniqueidentifier;
	declare @ASSIGNED_SET_ID    uniqueidentifier;
	declare @ASSIGNED_SET_LIST  varchar(8000);
	declare @TABLE_NAME         nvarchar(50);
	declare @CUSTOM_NAME        nvarchar(50);
	declare @TEST               bit;
	
	set @CRLF = char(13) + char(10);
	set @TEST = 0;

	-- 12/02/2017 Paul.  First create a ASSIGNED_SET_ID for each user. 
	declare INIT_SETS_USERS_CURSOR cursor for
	select ID
	  from USERS
	 order by USER_NAME;
	open INIT_SETS_USERS_CURSOR;
	fetch next from INIT_SETS_USERS_CURSOR into @ASSIGNED_USER_ID;
	while @@FETCH_STATUS = 0 begin -- while
		set @ASSIGNED_SET_ID = null;
		if @TEST = 0 begin -- then
			exec dbo.spASSIGNED_SETS_NormalizeSet @ASSIGNED_SET_ID out, null, @ASSIGNED_USER_ID, @ASSIGNED_SET_LIST;
		end -- if;
		fetch next from INIT_SETS_USERS_CURSOR into @ASSIGNED_USER_ID;
	end -- while;
	close INIT_SETS_USERS_CURSOR;
	deallocate INIT_SETS_USERS_CURSOR;
	
	declare INIT_SETS_MODULES_CURSOR cursor for
	select TABLE_NAME
	  from vwSqlTables
	 where TABLE_NAME in (select ObjectName from vwSqlColumns where ColumnName = 'ASSIGNED_USER_ID')
	   and TABLE_NAME in (select ObjectName from vwSqlColumns where ColumnName = 'ASSIGNED_SET_ID')
	   and TABLE_NAME not like '%_AUDIT'
	 order by TABLE_NAME;
	open INIT_SETS_MODULES_CURSOR;
	fetch next from INIT_SETS_MODULES_CURSOR into @TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- while
		set @Command = '';
		set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
		if exists(select * from vwSqlTables where TABLE_NAME = @CUSTOM_NAME) begin -- then
			-- 12/02/2017 Paul.  Make sure to create an auditing record for the Custom field table. 
			set @Command = @Command + 'update ' + @CUSTOM_NAME                             + @CRLF;
			set @Command = @Command + '   set ID_C = ID_C'                                 + @CRLF;
			set @Command = @Command + '  from      ' + @CUSTOM_NAME                        + @CRLF;
			set @Command = @Command + ' inner join ' + @TABLE_NAME                         + @CRLF;
			set @Command = @Command + '         on ' + @TABLE_NAME + '.ID = ' + @CUSTOM_NAME + '.ID_C' + @CRLF;
			set @Command = @Command + ' inner join ASSIGNED_SETS'                          + @CRLF;
			set @Command = @Command + '         on ASSIGNED_SETS.ASSIGNED_SET_LIST = cast(' + @TABLE_NAME + '.ASSIGNED_USER_ID as char(36))' + @CRLF;
			set @Command = @Command + '        and ASSIGNED_SETS.DELETED           = 0'    + @CRLF;
			set @Command = @Command + ' where ' + @TABLE_NAME + '.ASSIGNED_SET_ID is null' + @CRLF;
			set @Command = @Command + '   and ' + @TABLE_NAME + '.DELETED         = 0;'    + @CRLF;
		end -- if;
		set @Command = @Command + 'update ' + @TABLE_NAME                              + @CRLF;
		set @Command = @Command + '   set ASSIGNED_SET_ID   = ASSIGNED_SETS.ID'        + @CRLF;
		set @Command = @Command + '     , DATE_MODIFIED_UTC = getutcdate()'            + @CRLF;
		set @Command = @Command + '  from      ' + @TABLE_NAME                         + @CRLF;
		set @Command = @Command + ' inner join ASSIGNED_SETS'                          + @CRLF;
		set @Command = @Command + '         on ASSIGNED_SETS.ASSIGNED_SET_LIST = cast(' + @TABLE_NAME + '.ASSIGNED_USER_ID as char(36))' + @CRLF;
		set @Command = @Command + '        and ASSIGNED_SETS.DELETED           = 0'    + @CRLF;
		set @Command = @Command + ' where ' + @TABLE_NAME + '.ASSIGNED_SET_ID is null' + @CRLF;
		set @Command = @Command + '   and ' + @TABLE_NAME + '.DELETED         = 0;'    + @CRLF;
		if @TEST = 1 begin -- then
			print @Command + @CRLF;
		end else begin
			print(@Command + ';');
			exec(@Command);
		end -- if;
		fetch next from INIT_SETS_MODULES_CURSOR into @TABLE_NAME;
	end -- while;
	close INIT_SETS_MODULES_CURSOR;
	deallocate INIT_SETS_MODULES_CURSOR;
  end
GO
 
Grant Execute on dbo.spASSIGNED_SETS_InitAllModules to public;
GO

-- select * from ASSIGNED_SETS 
/*
begin tran;
exec dbo.spASSIGNED_SETS_InitAllModules ;
commit tran;
*/

