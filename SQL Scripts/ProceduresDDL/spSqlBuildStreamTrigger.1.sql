if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildStreamTrigger' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildStreamTrigger;
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
-- 01/15/2018 Paul.  We need a trigger on the custom table to fire and correct the field changes. 
-- With just the base table trigger firing before custom field record updates, it always appears that all custom fields have changed. 
Create Procedure dbo.spSqlBuildStreamTrigger(@TABLE_NAME varchar(80))
as
  begin
	set nocount on
	
	declare @Command            varchar(max);
	declare @STREAM_TABLE       varchar(90);
	declare @AUDIT_TABLE        varchar(90);
	declare @CUSTOM_AUDIT_TABLE varchar(90);
	declare @TRIGGER_NAME       varchar(90);
	declare @TEST               bit;
	declare @CRLF               char(2);
	declare @SPLENDID_FIELDS    int;

	set @TEST               = 0;
	set @CRLF               = char(13) + char(10);
	set @SPLENDID_FIELDS    = 0;
	set @STREAM_TABLE       = @TABLE_NAME + '_STREAM';
	set @AUDIT_TABLE        = @TABLE_NAME + '_AUDIT';
	set @CUSTOM_AUDIT_TABLE = @TABLE_NAME + '_CSTM_AUDIT';

	-- 09/23/2015 Paul.  We need to prevent from adding streaming to non-SplendidCRM tables, so check for the base fields. 
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @AUDIT_TABLE and COLUMN_NAME = 'AUDIT_ID') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @AUDIT_TABLE and COLUMN_NAME = 'AUDIT_ACTION') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @AUDIT_TABLE and COLUMN_NAME = 'AUDIT_DATE') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @AUDIT_TABLE and COLUMN_NAME = 'AUDIT_VERSION') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @AUDIT_TABLE and COLUMN_NAME = 'AUDIT_COLUMNS') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;
	if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @AUDIT_TABLE and COLUMN_NAME = 'AUDIT_TOKEN') begin -- then
		set @SPLENDID_FIELDS = @SPLENDID_FIELDS + 1;
	end -- if;

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

	if @SPLENDID_FIELDS = 13 begin -- then
		set @TRIGGER_NAME = 'tr' + @TABLE_NAME + '_Ins_STREAM';
		if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = '' + @AUDIT_TABLE) begin -- then
			if exists (select * from sys.objects where name = @TRIGGER_NAME and type = 'TR') begin -- then
				set @Command = 'Drop   Trigger dbo.' + @TRIGGER_NAME;
				if @TEST = 0 begin -- then
					print @Command;
					exec(@Command);
				end -- if;
			end -- if;
			
			if not exists (select * from sys.objects where name = @TRIGGER_NAME and type = 'TR') begin -- then
				set @Command = '';
				set @Command = @Command + 'Create Trigger dbo.' + @TRIGGER_NAME + ' on dbo.' + @AUDIT_TABLE + @CRLF;
				set @Command = @Command + 'for insert' + @CRLF;
				set @Command = @Command + 'as' + @CRLF;
				set @Command = @Command + '  begin' + @CRLF;
				set @Command = @Command + '	insert into dbo.' + @STREAM_TABLE + @CRLF;
				set @Command = @Command + '	     ( STREAM_ID'        + @CRLF;
				set @Command = @Command + '	     , STREAM_DATE'      + @CRLF;
				set @Command = @Command + '	     , STREAM_ACTION'    + @CRLF;
				set @Command = @Command + '	     , STREAM_COLUMNS'   + @CRLF;
				set @Command = @Command + '	     , AUDIT_ID'         + @CRLF;
				set @Command = @Command + '	     , ID'               + @CRLF;
				set @Command = @Command + '	     , CREATED_BY'       + @CRLF;
				set @Command = @Command + '	     , ASSIGNED_USER_ID' + @CRLF;
				set @Command = @Command + '	     , TEAM_ID'          + @CRLF;
				set @Command = @Command + '	     , TEAM_SET_ID'      + @CRLF;
				set @Command = @Command + '	     , NAME'             + @CRLF;
				set @Command = @Command + '	     )' + @CRLF;
				set @Command = @Command + '	select newid()'          + @CRLF;
				set @Command = @Command + '	     , AUDIT_DATE'       + @CRLF;
				set @Command = @Command + '	     , (case AUDIT_ACTION when 0 then ''Created'' when 1 then ''Updated'' when -1 then ''Deleted'' end)' + @CRLF;
				set @Command = @Command + '	     , dbo.fn' + @AUDIT_TABLE + '_COLUMNS(AUDIT_ID, ID, AUDIT_VERSION, AUDIT_ACTION)' + @CRLF;
				set @Command = @Command + '	     , AUDIT_ID'         + @CRLF;
				set @Command = @Command + '	     , ID'               + @CRLF;
				-- 06/03/2016 Paul.  We should be using the MODIFIED_USER_ID as the person who made the change. 
				set @Command = @Command + '	     , MODIFIED_USER_ID' + @CRLF;
				set @Command = @Command + '	     , ASSIGNED_USER_ID' + @CRLF;
				set @Command = @Command + '	     , TEAM_ID'          + @CRLF;
				set @Command = @Command + '	     , TEAM_SET_ID'      + @CRLF;
				if @TABLE_NAME = 'CONTACTS' or @TABLE_NAME = 'LEADS' or @TABLE_NAME = 'PROSPECTS' or @TABLE_NAME = 'USERS' begin -- then
					set @Command = @Command + '	     , dbo.fnFullName(FIRST_NAME, LAST_NAME) as NAME' + @CRLF;
				end else if @TABLE_NAME = 'DOCUMENTS' begin -- then
					set @Command = @Command + '	     , DOCUMENT_NAME as NAME  ' + @CRLF;
				end else begin
					set @Command = @Command + '	     , NAME'             + @CRLF;
				end -- if;
				set @Command = @Command + '	  from inserted;' + @CRLF;
				set @Command = @Command + '  end' + @CRLF;
				if @TEST = 1 begin -- then
					print @Command + @CRLF;
				end else begin
					print substring(@Command, 1, charindex(@CRLF, @Command));
					exec(@Command);
				end -- if;
			end -- if;
		end -- if;
		-- 01/15/2018 Paul.  We need a trigger on the custom table to fire and correct the field changes. 
		if exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @CUSTOM_AUDIT_TABLE and COLUMN_NAME = 'ID_C') begin -- then
			set @TRIGGER_NAME = 'tr' + @TABLE_NAME + '_CSTM_Ins_STREAM';
			if exists (select * from sys.objects where name = @TRIGGER_NAME and type = 'TR') begin -- then
				set @Command = 'Drop   Trigger dbo.' + @TRIGGER_NAME;
				if @TEST = 0 begin -- then
					print @Command;
					exec(@Command);
				end -- if;
			end -- if;
			
			if not exists (select * from sys.objects where name = @TRIGGER_NAME and type = 'TR') begin -- then
				set @Command = '';
				set @Command = @Command + 'Create Trigger dbo.' + @TRIGGER_NAME + ' on dbo.' + @CUSTOM_AUDIT_TABLE + @CRLF;
				set @Command = @Command + 'for insert' + @CRLF;
				set @Command = @Command + 'as' + @CRLF;
				set @Command = @Command + '  begin' + @CRLF;
				set @Command = @Command + '	update dbo.' + @STREAM_TABLE + @CRLF;
				set @Command = @Command + '	   set STREAM_COLUMNS = dbo.fn' + @AUDIT_TABLE + '_COLUMNS(' + @AUDIT_TABLE + '.AUDIT_ID, ' + @AUDIT_TABLE + '.ID, ' + @AUDIT_TABLE + '.AUDIT_VERSION, ' + @AUDIT_TABLE + '.AUDIT_ACTION)' + @CRLF;
				set @Command = @Command + '	  from      inserted' + @CRLF;
				set @Command = @Command + '	 inner join dbo.' + @AUDIT_TABLE  + ' ' + @AUDIT_TABLE                     + @CRLF;
				set @Command = @Command + '	         on ' + @AUDIT_TABLE  + '.ID           = inserted.ID_C'        + @CRLF;
				set @Command = @Command + '	        and ' + @AUDIT_TABLE  + '.AUDIT_TOKEN  = inserted.AUDIT_TOKEN' + @CRLF;
				set @Command = @Command + '	 inner join dbo.' + @STREAM_TABLE + ' ' + @STREAM_TABLE                    + @CRLF;
				set @Command = @Command + '	         on ' + @STREAM_TABLE + '.AUDIT_ID     = ' + @AUDIT_TABLE  + '.AUDIT_ID' + @CRLF;
				set @Command = @Command + '	 where inserted.AUDIT_ACTION = 1;' + @CRLF;
				set @Command = @Command + '  end' + @CRLF;
				if @TEST = 1 begin -- then
					print @Command + @CRLF;
				end else begin
					print substring(@Command, 1, charindex(@CRLF, @Command));
					exec(@Command);
				end -- if;
			end -- if;
		end -- if;
	end -- if;
  end
GO


Grant Execute on dbo.spSqlBuildStreamTrigger to public;
GO

-- exec spSqlBuildStreamTrigger 'ACCOUNTS';

