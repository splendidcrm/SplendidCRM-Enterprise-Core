if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlUpdateIndex' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlUpdateIndex;
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
-- 09/15/2009 Paul.  Azure does not support sysindexes view. 
-- 08/17/2010 Paul.  If the index is not found, then the value will be NULL. 
-- 04/25/2011 Paul.  We've stopped supporting SQL 2000, so we can use varchar(max). 
-- This also fixes a problem for a customer with 100 custom fields. 
Create Procedure dbo.spSqlUpdateIndex
	( @INDEX_NAME  varchar(80)
	, @TABLE_NAME  varchar(80)
	, @FIELD1      varchar(40)
	, @FIELD2      varchar(40) = null
	, @FIELD3      varchar(40) = null
	, @FIELD4      varchar(40) = null
	, @FIELD5      varchar(40) = null
	, @FIELD6      varchar(40) = null
	)
as
  begin
	set nocount on

	-- 04/25/2011 Paul.  We've stopped supporting SQL 2000, so we can use varchar(max). 
	declare @Command           varchar(max);
	declare @CRLF              char(2);
	declare @TEST              bit;
	declare @REBUILD_INDEX     bit;
	declare @INDEX_ID          int;
	declare @EXISTING_FIELD1   varchar(40);
	declare @EXISTING_FIELD2   varchar(40);
	declare @EXISTING_FIELD3   varchar(40);
	declare @EXISTING_FIELD4   varchar(40);
	declare @EXISTING_FIELD5   varchar(40);
	declare @EXISTING_FIELD6   varchar(40);
	
	set @TEST = 0
	set @CRLF = char(13) + char(10);
	select @INDEX_ID = index_id
	  from sys.indexes
	 where name = @INDEX_NAME;

	if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = @TABLE_NAME) begin -- then
		if @INDEX_ID is not null begin -- then
			set @EXISTING_FIELD1 = index_col(@TABLE_NAME, @INDEX_ID, 1);
			set @EXISTING_FIELD2 = index_col(@TABLE_NAME, @INDEX_ID, 2);
			set @EXISTING_FIELD3 = index_col(@TABLE_NAME, @INDEX_ID, 3);
			set @EXISTING_FIELD4 = index_col(@TABLE_NAME, @INDEX_ID, 4);
			set @EXISTING_FIELD5 = index_col(@TABLE_NAME, @INDEX_ID, 5);
			set @EXISTING_FIELD6 = index_col(@TABLE_NAME, @INDEX_ID, 6);
	
			set @REBUILD_INDEX = 0;
			if          isnull(@FIELD1, '') <> isnull(@EXISTING_FIELD1, '') begin -- then
				set @REBUILD_INDEX = 1;
			end else if isnull(@FIELD2, '') <> isnull(@EXISTING_FIELD2, '') begin -- then
				set @REBUILD_INDEX = 1;
			end else if isnull(@FIELD3, '') <> isnull(@EXISTING_FIELD3, '') begin -- then
				set @REBUILD_INDEX = 1;
			end else if isnull(@FIELD4, '') <> isnull(@EXISTING_FIELD4, '') begin -- then
				set @REBUILD_INDEX = 1;
			end else if isnull(@FIELD5, '') <> isnull(@EXISTING_FIELD5, '') begin -- then
				set @REBUILD_INDEX = 1;
			end else if isnull(@FIELD6, '') <> isnull(@EXISTING_FIELD6, '') begin -- then
				set @REBUILD_INDEX = 1;
			end -- if;
	
			if @REBUILD_INDEX = 1 begin -- then
				-- 09/15/2009 Paul.  Use new syntax to drop an index. 
				-- Deprecated feature 'DROP INDEX with two-part name' is not supported in this version of SQL Server.
				set @Command = 'drop   index ' + @INDEX_NAME + ' on ' + @TABLE_NAME;
				if @TEST = 1 begin -- then
					print @Command + ';';
				end else begin
					print @Command + ';';
					exec(@Command);
				end -- if;
				-- 08/17/2010 Paul.  Use NULL instead of zero as the indicator. 
				set @INDEX_ID = null;
			end -- if;
		end -- if;
	
		-- 08/17/2010 Paul.  If the index is not found, then the value will be NULL. 
		if @INDEX_ID is null begin -- then
			set @Command = 'create index ' + @INDEX_NAME + ' on dbo.' + @TABLE_NAME + ' (' + @FIELD1;
			if @FIELD2 is not null begin -- then
				set @Command = @Command + ', ' + @FIELD2;
			end -- if;
			if @FIELD3 is not null begin -- then
				set @Command = @Command + ', ' + @FIELD3;
			end -- if;
			if @FIELD4 is not null begin -- then
				set @Command = @Command + ', ' + @FIELD4;
			end -- if;
			if @FIELD5 is not null begin -- then
				set @Command = @Command + ', ' + @FIELD5;
			end -- if;
			if @FIELD6 is not null begin -- then
				set @Command = @Command + ', ' + @FIELD6;
			end -- if;
	
			set @Command = @Command + ')';
			if @TEST = 1 begin -- then
				print @Command + ';';
			end else begin
				print @Command + ';';
				exec(@Command);
			end -- if;
		end -- if;
	end -- if;
  end
GO


Grant Execute on dbo.spSqlUpdateIndex to public;
GO

