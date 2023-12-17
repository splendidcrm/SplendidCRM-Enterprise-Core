if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlTableAlterColumn' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlTableAlterColumn;
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
-- 09/15/2009 Paul.  Convert data type to nvarchar(max) to support Azure. 
Create Procedure dbo.spSqlTableAlterColumn
	( @TABLE_NAME        varchar(255)
	, @COLUMN_NAME       varchar(255)
	, @DATA_TYPE         varchar(255)
	, @MAX_SIZE          int
	, @REQUIRED          bit
	, @DEFAULT_VALUE     varchar(255)
	)
as
  begin
	set nocount on
	
	declare @Command     varchar(2000);
	declare @NullStmt    varchar(  10);
	declare @DefaultStmt varchar( 300);
	-- 08/02/2008 Paul.  We can only enforce the not null attribute if a default value is specified. 
	-- This is because we create the custom field record before we assign the values.
	if @REQUIRED = 1 and @DefaultStmt is not null begin -- then
		set @NullStmt = ' not null';
	end else begin
		set @NullStmt = ' null';
	end -- if;
	-- 02/09/2007 Paul.  We should always create unicode fields.  Use nvarchar and not varchar. 
	if @DATA_TYPE = 'varchar' begin -- then
		set @Command = 'alter table ' + @TABLE_NAME + ' alter column ' + @COLUMN_NAME + ' nvarchar(' + cast(@MAX_SIZE as char(10)) + ')';
	end else if @DATA_TYPE = 'enum'    begin -- then
		set @Command = 'alter table ' + @TABLE_NAME + ' alter column ' + @COLUMN_NAME + ' nvarchar(' + cast(@MAX_SIZE as char(10)) + ')';
	end else if @DATA_TYPE = 'text'    begin -- then
		set @Command = 'alter table ' + @TABLE_NAME + ' alter column ' + @COLUMN_NAME + ' nvarchar(max)';
	end else if @DATA_TYPE = 'bool'    begin -- then
		set @Command = 'alter table ' + @TABLE_NAME + ' alter column ' + @COLUMN_NAME + ' bit';
	end else if @DATA_TYPE = 'int'     begin -- then
		set @Command = 'alter table ' + @TABLE_NAME + ' alter column ' + @COLUMN_NAME + ' int';
	end else if @DATA_TYPE = 'float'   begin -- then
		set @Command = 'alter table ' + @TABLE_NAME + ' alter column ' + @COLUMN_NAME + ' float';
	end else if @DATA_TYPE = 'date'    begin -- then
		set @Command = 'alter table ' + @TABLE_NAME + ' alter column ' + @COLUMN_NAME + ' datetime';
	end else if @DATA_TYPE = 'guid'    begin -- then
		set @Command = 'alter table ' + @TABLE_NAME + ' alter column ' + @COLUMN_NAME + ' uniqueidentifier';
	end else begin
		raiserror(N'spSqlTableAlterColumn: %s is not a supported DATA_TYPE. ', 16, 1, @DATA_TYPE);
	end -- if;
	-- 01/06/2006 Paul.  Alter Column cannot modify the default constraint. 
	if @Command is not null and @@ERROR = 0 begin -- then
		set @Command = @Command + @NullStmt;
		if @DefaultStmt is not null begin -- then
			set @Command = @Command + @DefaultStmt;
		end -- if;
		exec (@Command);
		-- 07/15/2009 Jamie.  If we alter the column, we must also alter the audit column. 
		if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TABLE_NAME + '_AUDIT' and COLUMN_NAME = @COLUMN_NAME) begin -- then
			set @Command = replace(@Command, ' table ' + @TABLE_NAME + ' ', ' table ' + @TABLE_NAME + '_AUDIT ');
			exec (@Command);
		end -- if;
	end -- if;

	-- 01/06/2006 Paul.  The default constraint needs to be dropped and created again. 
	if @@ERROR = 0 begin -- then
		exec dbo.spSqlTableDropColumnConstraint @TABLE_NAME, @COLUMN_NAME;
	end -- if;

	if @DEFAULT_VALUE is not null begin -- then
		-- 01/06/2006 Paul. Example: alter table ACCOUNTS_CSTM add constraint DF_ACCOUNTS_CSTM_CUSTOM1111 default('000') for CUSTOM1111;
		set @DefaultStmt = 'alter table ' + @TABLE_NAME + ' add constraint DF_' + @TABLE_NAME + '_' + @COLUMN_NAME;
		if @DATA_TYPE = 'bool'    begin -- then
			set @DefaultStmt = @DefaultStmt + ' default(' + cast(cast(@DEFAULT_VALUE as int          ) as char(10)) + ')';
		end else if @DATA_TYPE = 'int' begin -- then
			set @DefaultStmt = @DefaultStmt + ' default(' + cast(cast(@DEFAULT_VALUE as int          ) as char(10)) + ')';
		end else if @DATA_TYPE = 'float' begin -- then
			set @DefaultStmt = @DefaultStmt + ' default(' + cast(cast(@DEFAULT_VALUE as decimal(19,4)) as char(20)) + ')';
		end else if @DATA_TYPE = 'guid' begin -- then
			if @DEFAULT_VALUE = 'newid()' begin -- then
				set @DefaultStmt = @DefaultStmt + ' default(newid())';
			end else begin
				set @DefaultStmt = @DefaultStmt + ' default(''' + replace(@DEFAULT_VALUE, '''', '''''') + ''')';
			end -- if;
		end else begin
			-- 01/06/2006 Paul.  Most default values need to be quoted. 
			set @DefaultStmt = @DefaultStmt + ' default(''' + replace(@DEFAULT_VALUE, '''', '''''') + ''')';
		end -- if;
		set @Command = @DefaultStmt + ' for ' + @COLUMN_NAME;
		if @Command is not null and @@ERROR = 0 begin -- then
			exec (@Command);
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spSqlTableAlterColumn to public;
GO

