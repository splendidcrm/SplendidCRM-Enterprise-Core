if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDATA_PRIVACY_EraseTableRecords' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDATA_PRIVACY_EraseTableRecords;
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
Create Procedure dbo.spDATA_PRIVACY_EraseTableRecords
	( @MODIFIED_USER_ID uniqueidentifier
	, @RECORD_ID        uniqueidentifier
	, @TABLE_NAME       nvarchar(80)
	, @PRIMARY_KEY      nvarchar(30)
	, @FIELDS_TO_ERASE  nvarchar(max)
	, @ARCHIVE_DATABASE nvarchar(50)
	)
as
  begin
	set nocount on
	
	declare @COMMAND              nvarchar(max);
	declare @EXISTS               bit;
	declare @DEBUG                bit;
	declare @TEST                 bit;
	declare @CRLF                 nchar(2);
	declare @ERASED_FIELD         nvarchar(50);
	declare @ARCHIVE_DATABASE_DOT nvarchar(50);
	declare @CurrentPosR          int;
	declare @NextPosR             int;

	--print 'spDATA_PRIVACY_EraseTableRecords: ' + cast(@RECORD_ID as char(36)) + ' ' + isnull(@ARCHIVE_DATABASE + '.dbo.', '') + @TABLE_NAME + '.' + @PRIMARY_KEY + ' - ' + @FIELDS_TO_ERASE;
	set @DEBUG = 1;
	set @TEST  = 0;
	set @CRLF  = char(13) + char(10);
	if len(@ARCHIVE_DATABASE) > 0 begin -- then
		set @ARCHIVE_DATABASE_DOT = '[' + @ARCHIVE_DATABASE + '].';
	end else begin
		set @ARCHIVE_DATABASE_DOT = '';
	end -- if;

	exec dbo.spSqlTableExists @EXISTS out, @TABLE_NAME, @ARCHIVE_DATABASE;
	if @EXISTS = 1 begin -- then
		exec spSqlTableRecordExists @EXISTS out, @TABLE_NAME, @PRIMARY_KEY, @RECORD_ID, @ARCHIVE_DATABASE;
		if @EXISTS = 1 begin -- then
			set @COMMAND = '';
			set @COMMAND = @COMMAND + 'update ' + @ARCHIVE_DATABASE_DOT + 'dbo.' + @TABLE_NAME + @CRLF;
	
			exec dbo.spSqlTableColumnExists @EXISTS out, @TABLE_NAME, 'DATE_MODIFIED_UTC', @ARCHIVE_DATABASE;
			if @EXISTS = 1 begin -- then
				set @COMMAND = @COMMAND + '   set DATE_MODIFIED_UTC              = getutcdate()' + @CRLF;
			end else begin
				set @COMMAND = @COMMAND + '   set ' + @PRIMARY_KEY + ' = ' + @PRIMARY_KEY + @CRLF;
			end -- if;
			exec dbo.spSqlTableColumnExists @EXISTS out, @TABLE_NAME, 'MODIFIED_USER_ID', @ARCHIVE_DATABASE;
			if @EXISTS = 1 begin -- then
				if charindex('_AUDIT', @TABLE_NAME) = 0 begin -- then
					set @COMMAND = @COMMAND + '     , MODIFIED_USER_ID               = ' + isnull('''' + cast(@MODIFIED_USER_ID as char(36)) + '''', 'null') + @CRLF;
				end -- if;
			end -- if;
			set @CurrentPosR = 1;
			while @CurrentPosR <= len(@FIELDS_TO_ERASE) begin -- do
				set @NextPosR = charindex(',', @FIELDS_TO_ERASE, @CurrentPosR);
				if @NextPosR = 0 or @NextPosR is null begin -- then
					set @NextPosR = len(@FIELDS_TO_ERASE) + 1;
				end -- if;
				set @ERASED_FIELD = rtrim(ltrim(substring(@FIELDS_TO_ERASE, @CurrentPosR, @NextPosR - @CurrentPosR)));
				exec dbo.spSqlTableColumnExists @EXISTS out, @TABLE_NAME, @ERASED_FIELD, @ARCHIVE_DATABASE;
				if @EXISTS = 1 begin -- then
					if len(@ERASED_FIELD) < 30 begin -- then
						set @COMMAND = @COMMAND + '     , ' + @ERASED_FIELD + space(30 - len(@ERASED_FIELD)) + ' = null' + @CRLF;
					end else begin
						set @COMMAND = @COMMAND + '     , ' + @ERASED_FIELD + ' = null' + @CRLF;
					end -- if;
				end -- if;
				set @CurrentPosR = @NextPosR + 1;
			end -- while;
			-- 06/27/2018 Paul.  One thought is to get the transaction token and exclude updating an audit record for the current transaction
			-- but that may significantly impact performance.  As there is little damage to updating an audit record just created, ignore the issue. 
			set @COMMAND = @COMMAND + ' where ' + @PRIMARY_KEY + ' = ''' + cast(@RECORD_ID as char(36)) + '''';
	
			if @TEST = 1 begin -- then
				print @COMMAND + ';';
			end else begin
				if @DEBUG = 1 begin -- then
					print @COMMAND + ';';
				end else begin
					print substring(@Command, 1, charindex(@CRLF, @Command));
				end -- if;
				exec(@COMMAND);
			end -- if;
		end -- if;
	end else begin
		print @ARCHIVE_DATABASE_DOT + @TABLE_NAME + ' does not exist';
	end -- if;
  end
GO

Grant Execute on dbo.spDATA_PRIVACY_EraseTableRecords to public;
GO

