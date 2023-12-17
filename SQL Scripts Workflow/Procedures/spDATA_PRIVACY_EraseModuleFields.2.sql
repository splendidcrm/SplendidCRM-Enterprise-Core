if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDATA_PRIVACY_EraseModuleFields' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDATA_PRIVACY_EraseModuleFields;
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
Create Procedure dbo.spDATA_PRIVACY_EraseModuleFields
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @MODULE_NAME      nvarchar(50)
	, @TABLE_NAME       nvarchar(80)
	)
as
  begin
	set nocount on
	
	declare @COMMAND              nvarchar(max);
	declare @PARAM_DEFINTION      nvarchar(200);
	declare @EXISTS               bit;
	declare @DEBUG                bit;
	declare @TEST                 bit;
	declare @CRLF                 nchar(2);
	declare @RELATED_TABLE        nvarchar(80);
	declare @SINGULAR_NAME        nvarchar(80);
	declare @ERASED_TABLE         nvarchar(80);
	declare @ERASED_FIELD         nvarchar(50);
	declare @RECORD_ID            uniqueidentifier;
	declare @ERASED_ID            uniqueidentifier;
	declare @CurrentPosR          int;
	declare @NextPosR             int;
	declare @DotSeparator         int;
	declare @ARCHIVE_DATABASE     nvarchar(50);
	declare @FIELDS_TO_ERASE      nvarchar(max);

	--print 'spDATA_PRIVACY_EraseModuleFields: ' + cast(@ID as char(36)) + ' ' + @MODULE_NAME + ' ' + @TABLE_NAME;
	set @DEBUG = 1;
	set @TEST  = 0;
	set @CRLF  = char(13) + char(10);
	set @SINGULAR_NAME = dbo.fnSqlSingularName(@TABLE_NAME);
	set @ARCHIVE_DATABASE = dbo.fnCONFIG_String('Archive.Database');
	
	if exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = @TABLE_NAME) begin -- then
		set @COMMAND = @CRLF;
		set @COMMAND = @COMMAND  + 'declare DATA_PRIVACY_ERASE_CURSOR cursor for'                + @CRLF;
		set @COMMAND = @COMMAND  + 'select ERASED_FIELDS.BEAN_ID'                                + @CRLF;
		set @COMMAND = @COMMAND  + '     , ERASED_FIELDS.DATA'                                   + @CRLF;
		set @COMMAND = @COMMAND  + '  from       ' + @TABLE_NAME + '_DATA_PRIVACY  DATA_PRIVACY' + @CRLF;
		set @COMMAND = @COMMAND  + '  inner join ERASED_FIELDS'                                  + @CRLF;
		set @COMMAND = @COMMAND  + '          on ERASED_FIELDS.BEAN_ID = DATA_PRIVACY.' + @SINGULAR_NAME + '_ID' + @CRLF;
		set @COMMAND = @COMMAND  + '         and ERASED_FIELDS.DELETED = 0'                      + @CRLF;
		set @COMMAND = @COMMAND  + ' where DATA_PRIVACY.DATA_PRIVACY_ID = ''' + cast(@ID as char(36)) + '''' + @CRLF;
		set @COMMAND = @COMMAND  + '   and DATA_PRIVACY.DELETED = 0';
		--set @PARAM_DEFINTION = N'@DATA_PRIVACY_ID uniqueidentifier';
		--exec sp_executesql @COMMAND, @PARAM_DEFINTION, @DATA_PRIVACY_ID = @ID;
		--if @DEBUG = 1 begin -- then
		--	print @COMMAND + ';';
		--end -- if;
		exec(@COMMAND);

		if @@ERROR = 0 begin -- then
			open DATA_PRIVACY_ERASE_CURSOR;
			fetch next from DATA_PRIVACY_ERASE_CURSOR into @RECORD_ID, @FIELDS_TO_ERASE;
			while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
				print @CRLF;
				print '-- Erase ' + @TABLE_NAME + ' ' + cast(@RECORD_ID as char(36)) + ' - ' + @FIELDS_TO_ERASE;
				-- 06/27/2018 Paul.  Some records will need to be deleted. 
				exec spSqlTableRecordExists @EXISTS out, 'SUGARFAVORITES', 'RECORD_ID', @RECORD_ID, null;
				if @EXISTS = 1 begin -- then
					set @COMMAND = '';
					set @COMMAND = @COMMAND  + 'delete from SUGARFAVORITES' + @CRLF;
					set @COMMAND = @COMMAND  + ' where RECORD_ID = ''' + cast(@RECORD_ID as char(36)) + '''';
					if @TEST = 1 begin -- then
						print @COMMAND + ';';
					end else begin
						if @DEBUG = 1 begin -- then
							print @COMMAND + ';';
						end -- if;
						exec(@COMMAND);
					end -- if;
				end -- if;
				-- 06/27/2018 Paul.  The Stream table can contain the name of the record. 
				if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TABLE_NAME + '_STREAM' and COLUMN_NAME = 'NAME') begin -- then
					set @ERASED_TABLE = @TABLE_NAME + '_STREAM';
					exec spSqlTableRecordExists @EXISTS out, @ERASED_TABLE, 'ID', @RECORD_ID, null;
					if @EXISTS = 1 begin -- then
						set @COMMAND = '';
						set @COMMAND = @COMMAND + 'update ' + @TABLE_NAME + '_STREAM' + @CRLF;
						set @COMMAND = @COMMAND + '   set NAME = ''{Erased}'''        + @CRLF;
						set @COMMAND = @COMMAND + ' where ID   = ''' + cast(@RECORD_ID as char(36)) + '''' + @CRLF;
						set @COMMAND = @COMMAND + '   and NAME is not null';
						if @TEST = 1 begin -- then
							print @COMMAND + ';';
						end else begin
							if @DEBUG = 1 begin -- then
								print @COMMAND + ';';
							end -- if;
							exec(@COMMAND);
						end -- if;
					end -- if;
				end -- if;
				-- 06/30/2018 Paul.  The streams table can include the name in the STREAM_RELATED_NAME field. 
				declare DATA_PRIVACY_RELATED_CURSOR cursor for
				select TABLE_NAME
				  from INFORMATION_SCHEMA.TABLES
				 where TABLE_NAME like '%[_]STREAM'
				 order by TABLE_NAME
				open DATA_PRIVACY_RELATED_CURSOR;
				fetch next from DATA_PRIVACY_RELATED_CURSOR into @RELATED_TABLE;
				while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
					exec spSqlTableRecordExists @EXISTS out, @RELATED_TABLE, 'STREAM_RELATED_ID', @RECORD_ID, null;
					if @EXISTS = 1 begin -- then
						set @COMMAND = '';
						set @COMMAND = @COMMAND + 'update ' + @RELATED_TABLE + @CRLF;
						set @COMMAND = @COMMAND + '   set STREAM_RELATED_NAME = ''{Erased}'''        + @CRLF;
						set @COMMAND = @COMMAND + ' where STREAM_RELATED_ID   = ''' + cast(@RECORD_ID as char(36)) + '''' + @CRLF;
						set @COMMAND = @COMMAND + '   and STREAM_RELATED_NAME is not null';
						if @TEST = 1 begin -- then
							print @COMMAND + ';';
						end else begin
							if @DEBUG = 1 begin -- then
								print @COMMAND + ';';
							end -- if;
							exec(@COMMAND);
						end -- if;
					end -- if;
					fetch next from DATA_PRIVACY_RELATED_CURSOR into @RELATED_TABLE;
				end -- while;
				close DATA_PRIVACY_RELATED_CURSOR;
				deallocate DATA_PRIVACY_RELATED_CURSOR;

				-- 06/27/2018 Paul.  The Sync table can include raw content with the name of the record. 
				if exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @TABLE_NAME + '_SYNC' and COLUMN_NAME = 'RAW_CONTENT') begin -- then
					set @ERASED_TABLE = @TABLE_NAME + '_SYNC';
					exec spSqlTableRecordExists @EXISTS out, @ERASED_TABLE, 'LOCAL_ID', @RECORD_ID, null;
					if @EXISTS = 1 begin -- then
						set @COMMAND = '';
						set @COMMAND = @COMMAND + 'update ' + @TABLE_NAME + '_SYNC'         + @CRLF;
						set @COMMAND = @COMMAND + '   set RAW_CONTENT       = null'         + @CRLF;
						set @COMMAND = @COMMAND + '     , DATE_MODIFIED_UTC = getutcdate()' + @CRLF;
						set @COMMAND = @COMMAND + '     , MODIFIED_USER_ID  = ''' + cast(@MODIFIED_USER_ID as char(36)) + '''' + @CRLF;
						set @COMMAND = @COMMAND + ' where LOCAL_ID          = ''' + cast(@RECORD_ID        as char(36)) + '''' + @CRLF;
						set @COMMAND = @COMMAND + '   and RAW_CONTENT       is not null';
						if @TEST = 1 begin -- then
							print @COMMAND + ';';
						end else begin
							if @DEBUG = 1 begin -- then
								print @COMMAND + ';';
							end -- if;
							exec(@COMMAND);
						end -- if;
					end -- if;
				end -- if;
	
				set @ERASED_TABLE = @TABLE_NAME;
				exec dbo.spDATA_PRIVACY_EraseTableRecords @MODIFIED_USER_ID, @RECORD_ID, @ERASED_TABLE, 'ID', @FIELDS_TO_ERASE, null;
	
				set @ERASED_TABLE = @TABLE_NAME + '_CSTM';
				exec dbo.spDATA_PRIVACY_EraseTableRecords @MODIFIED_USER_ID, @RECORD_ID, @ERASED_TABLE, 'ID_C', @FIELDS_TO_ERASE, null;
	
				set @ERASED_TABLE = @TABLE_NAME + '_AUDIT';
				exec dbo.spDATA_PRIVACY_EraseTableRecords @MODIFIED_USER_ID, @RECORD_ID, @ERASED_TABLE, 'ID', @FIELDS_TO_ERASE, null;
	
				set @ERASED_TABLE = @TABLE_NAME + '_CSTM_AUDIT';
				exec dbo.spDATA_PRIVACY_EraseTableRecords @MODIFIED_USER_ID, @RECORD_ID, @ERASED_TABLE, 'ID_C', @FIELDS_TO_ERASE, null;
	
				set @ERASED_TABLE = @TABLE_NAME + '_ARCHIVE';
				exec dbo.spDATA_PRIVACY_EraseTableRecords @MODIFIED_USER_ID, @RECORD_ID, @ERASED_TABLE, 'ID', @FIELDS_TO_ERASE, @ARCHIVE_DATABASE;
	
				set @ERASED_TABLE = @TABLE_NAME + '_CSTM_ARCHIVE';
				exec dbo.spDATA_PRIVACY_EraseTableRecords @MODIFIED_USER_ID, @RECORD_ID, @ERASED_TABLE, 'ID_C', @FIELDS_TO_ERASE, @ARCHIVE_DATABASE;
	
				fetch next from DATA_PRIVACY_ERASE_CURSOR into @RECORD_ID, @FIELDS_TO_ERASE;
			end -- while;
			close DATA_PRIVACY_ERASE_CURSOR;
			deallocate DATA_PRIVACY_ERASE_CURSOR;
		end else begin
			print 'Failed to create cursor: ' + @CRLF + @COMMAND;
		end -- if
	end -- if;
  end
GO

Grant Execute on dbo.spDATA_PRIVACY_EraseModuleFields to public;
GO

