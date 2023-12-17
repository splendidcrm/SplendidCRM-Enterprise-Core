if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildSystemTrigger' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildSystemTrigger;
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
-- 04/25/2011 Paul.  We've stopped supporting SQL 2000, so we can use varchar(max). 
-- This also fixes a problem for a customer with 100 custom fields. 
Create Procedure dbo.spSqlBuildSystemTrigger(@TABLE_NAME varchar(80))
as
  begin
	set nocount on
	
	-- 04/25/2011 Paul.  We've stopped supporting SQL 2000, so we can use varchar(max). 
	declare @Command           varchar(max);
	declare @CRLF         char(2);
	declare @TRIGGER_NAME varchar(90);
	declare @COLUMN_NAME  varchar(80);
	declare @COLUMN_TYPE  varchar(20);
	declare @PRIMARY_KEY  varchar(10);
	declare @TEST         bit;

	set @TEST = 0;
	set @PRIMARY_KEY = 'ID';
	if exists (select * from vwSqlTables where TABLE_NAME = @TABLE_NAME) begin -- then
		set @CRLF = char(13) + char(10);

		set @TRIGGER_NAME = 'tr' + @TABLE_NAME + '_System';
		if exists (select * from sys.objects where name = @TRIGGER_NAME and type = 'TR') begin -- then
			set @Command = 'Drop   Trigger dbo.' + @TRIGGER_NAME;
			if @TEST = 0 begin -- then
				print @Command;
				exec(@Command);
			end -- if;
		end -- if;

		if not exists (select * from sys.objects where name = @TRIGGER_NAME and type = 'TR') begin -- then
			-- 07/26/2008 Paul.  Add AUDIT_ACTION to speed workflow processing. 
			set @Command = '';
			set @Command = @Command + 'Create Trigger dbo.' + @TRIGGER_NAME + ' on dbo.' + @TABLE_NAME + @CRLF;
			set @Command = @Command + 'for insert, update' + @CRLF;
			set @Command = @Command + 'as' + @CRLF;
			set @Command = @Command + '  begin' + @CRLF;
			set @Command = @Command + '	declare @BIND_TOKEN varchar(255);' + @CRLF;
			set @Command = @Command + '	exec spSqlGetTransactionToken @BIND_TOKEN out;' + @CRLF;
			set @Command = @Command + '	insert into dbo.SYSTEM_EVENTS' + @CRLF;
			set @Command = @Command + '	     ( ID'            + @CRLF;
			set @Command = @Command + '	     , DATE_ENTERED'  + @CRLF;
			set @Command = @Command + '	     , TABLE_ID'      + @CRLF;
			set @Command = @Command + '	     , TABLE_NAME'    + @CRLF;
			set @Command = @Command + '	     , TABLE_COLUMNS' + @CRLF;
			set @Command = @Command + '	     , TABLE_TOKEN'   + @CRLF;
			set @Command = @Command + '	     , TABLE_ACTION'  + @CRLF;
			set @Command = @Command + '	     )' + @CRLF;
			set @Command = @Command + '	select newid()'       + @CRLF;
			set @Command = @Command + '	     , getdate()'     + @CRLF;
			set @Command = @Command + '	     , inserted.ID'   + @CRLF;
			set @Command = @Command + '	     , ''' + @TABLE_NAME  + '''' + @CRLF;
			set @Command = @Command + '	     , columns_updated()'   + @CRLF;
			set @Command = @Command + '	     , @BIND_TOKEN'         + @CRLF;
			set @Command = @Command + '	     , (case when deleted.ID is null then 0 else 1 end)' + @CRLF;
			set @Command = @Command + '	  from            inserted' + @CRLF;
			set @Command = @Command + '	  left outer join deleted'  + @CRLF;
			set @Command = @Command + '	               on deleted.ID = inserted.ID;' + @CRLF;
			set @Command = @Command + '  end' + @CRLF;
			if @TEST = 1 begin -- then
				print @Command + @CRLF;
			end else begin
				print substring(@Command, 1, charindex(@CRLF, @Command));
				exec(@Command);
			end -- if;
		end -- if;
	end -- if;
  end
GO


Grant Execute on dbo.spSqlBuildSystemTrigger to public;
GO


