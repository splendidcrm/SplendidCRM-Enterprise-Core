if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildStreamProcedure' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildStreamProcedure;
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
Create Procedure dbo.spSqlBuildStreamProcedure(@TABLE_NAME varchar(80))
as
  begin
	set nocount on
	
	declare @Command           varchar(max);
	declare @STREAM_TABLE      varchar(90);
	declare @PROCEDURE_NAME    varchar(90);
	declare @TEST              bit;
	declare @CRLF              char(2);
	declare @SPLENDID_FIELDS   int;
	declare @JOIN_TEAMS        bit;

	set @TEST            = 0;
	set @CRLF            = char(13) + char(10);
	set @SPLENDID_FIELDS = 0;
	set @STREAM_TABLE    = @TABLE_NAME + '_STREAM';

	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @STREAM_TABLE and COLUMN_NAME = 'STREAM_ID') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @STREAM_TABLE and COLUMN_NAME = 'STREAM_DATE') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @STREAM_TABLE and COLUMN_NAME = 'STREAM_VERSION') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @STREAM_TABLE and COLUMN_NAME = 'STREAM_ACTION') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @STREAM_TABLE and COLUMN_NAME = 'STREAM_COLUMNS') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @STREAM_TABLE and COLUMN_NAME = 'AUDIT_ID') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @STREAM_TABLE and COLUMN_NAME = 'ID') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;

	if @SPLENDID_FIELDS = 7 begin -- then
		if exists (select * from vwSqlTables where TABLE_NAME = @STREAM_TABLE) begin -- then
			set @PROCEDURE_NAME = 'sp' + @STREAM_TABLE + '_InsertPost';
			if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = @PROCEDURE_NAME and ROUTINE_TYPE = 'PROCEDURE') begin -- then
				set @Command = 'Drop Procedure dbo.' + @PROCEDURE_NAME;
				print @Command;
				exec(@Command);
			end -- if;
			
			set @JOIN_TEAMS    = 0;
			if not exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = @PROCEDURE_NAME) begin -- then
				set @Command = '';
				set @Command = @Command + 'Create Procedure dbo.' + @PROCEDURE_NAME + @CRLF;
				set @Command = @Command + '	( @MODIFIED_USER_ID  uniqueidentifier' + @CRLF;
				set @Command = @Command + '	, @ASSIGNED_USER_ID  uniqueidentifier' + @CRLF;
				set @Command = @Command + '	, @TEAM_ID           uniqueidentifier' + @CRLF;
				set @Command = @Command + '	, @NAME              nvarchar(max)   ' + @CRLF;
				set @Command = @Command + '	, @RELATED_ID        uniqueidentifier' + @CRLF;
				set @Command = @Command + '	, @RELATED_MODULE    nvarchar(25)    ' + @CRLF;
				set @Command = @Command + '	, @RELATED_NAME      nvarchar(255)   ' + @CRLF;
				set @Command = @Command + '	, @ID                uniqueidentifier' + @CRLF;
				set @Command = @Command + '	)' + @CRLF;
				set @Command = @Command + 'as' + @CRLF;
				set @Command = @Command + '  begin' + @CRLF;
				set @Command = @Command + '	declare @TEAM_SET_ID uniqueidentifier;' + @CRLF;
				set @Command = @Command + '	exec dbo.spTEAM_SETS_NormalizeSet @TEAM_SET_ID out, @MODIFIED_USER_ID, @TEAM_ID, null;' + @CRLF;
				set @Command = @Command + '	' + @CRLF;
				set @Command = @Command + '	insert into dbo.' + @STREAM_TABLE + @CRLF;
				set @Command = @Command + '		( STREAM_ID            ' + @CRLF;
				set @Command = @Command + '		, STREAM_DATE          ' + @CRLF;
				set @Command = @Command + '		, STREAM_ACTION        ' + @CRLF;
				set @Command = @Command + '		, CREATED_BY           ' + @CRLF;
				set @Command = @Command + '		, ASSIGNED_USER_ID     ' + @CRLF;
				set @Command = @Command + '		, TEAM_ID              ' + @CRLF;
				set @Command = @Command + '		, TEAM_SET_ID          ' + @CRLF;
				set @Command = @Command + '		, NAME                 ' + @CRLF;
				set @Command = @Command + '		, STREAM_RELATED_ID    ' + @CRLF;
				set @Command = @Command + '		, STREAM_RELATED_MODULE' + @CRLF;
				set @Command = @Command + '		, STREAM_RELATED_NAME  ' + @CRLF;
				set @Command = @Command + '		, ID                   ' + @CRLF;
				set @Command = @Command + '		)' + @CRLF;
				set @Command = @Command + '	values' + @CRLF;
				set @Command = @Command + '		(  newid()              ' + @CRLF;
				set @Command = @Command + '		,  getdate()            ' + @CRLF;
				set @Command = @Command + '		,  N''Post''            ' + @CRLF;
				set @Command = @Command + '		, @MODIFIED_USER_ID     ' + @CRLF;
				set @Command = @Command + '		, @ASSIGNED_USER_ID     ' + @CRLF;
				set @Command = @Command + '		, @TEAM_ID              ' + @CRLF;
				set @Command = @Command + '		, @TEAM_SET_ID          ' + @CRLF;
				set @Command = @Command + '		, @NAME                 ' + @CRLF;
				set @Command = @Command + '		, @RELATED_ID           ' + @CRLF;
				set @Command = @Command + '		, @RELATED_MODULE       ' + @CRLF;
				set @Command = @Command + '		, @RELATED_NAME         ' + @CRLF;
				set @Command = @Command + '		, @ID                   ' + @CRLF;
				set @Command = @Command + '		)' + @CRLF;
				set @Command = @Command + '  end' + @CRLF;
	
				if @TEST = 1 begin -- then
					print @Command + @CRLF;
				end else begin
					print substring(@Command, 1, charindex(@CRLF, @Command));
					exec(@Command);
				end -- if;
	
				set @Command = 'Grant Execute on dbo.' + @PROCEDURE_NAME + ' to public' + @CRLF;
				if @TEST = 1 begin -- then
					print @Command + @CRLF;
				end else begin
					--print @Command + @CRLF;
					exec(@Command);
				end -- if;
			end -- if;
		end -- if;
	end -- if;
  end
GO


Grant Execute on dbo.spSqlBuildStreamProcedure to public;
GO

