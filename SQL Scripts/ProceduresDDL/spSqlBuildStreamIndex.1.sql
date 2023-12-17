if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildStreamIndex' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildStreamIndex;
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
-- 01/15/2018 Paul.  Include the AUDIT_ID so that the columns can be updated. 
Create Procedure dbo.spSqlBuildStreamIndex(@TABLE_NAME varchar(80))
as
  begin
	set nocount on

	declare @Command           varchar(max);
	declare @STREAM_TABLE      varchar(90);
	declare @STREAM_INDEX      varchar(90);
	declare @CRLF              char(2);
	declare @TEST              bit;
	
	set @TEST = 0;
	set @CRLF = char(13) + char(10);
	set @STREAM_TABLE = @TABLE_NAME + '_STREAM';
	if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = @STREAM_TABLE and TABLE_TYPE = 'BASE TABLE') begin -- then
		/*
		set @STREAM_INDEX = 'IDX_' + @STREAM_TABLE + '_SET';
		if exists (select * from sys.indexes where name = @STREAM_INDEX) begin -- then
			set @Command = 'drop   index ' + @STREAM_INDEX + ' on dbo.' + @STREAM_TABLE;
			if @TEST = 1 begin -- then
				print @Command;
			end else begin
				print @Command;
				exec(@Command);
			end -- if;
		end -- if;
		*/

		-- 06/03/2016 Paul.  Index when Dynamic Teams disabled. 
		set @STREAM_INDEX = 'IDX_' + @STREAM_TABLE + '_SET';
		if not exists (select * from sys.indexes where name = @STREAM_INDEX) begin -- then
			set @Command = 'create index ' + @STREAM_INDEX + ' on dbo.' + @STREAM_TABLE + '(TEAM_SET_ID, CREATED_BY, ASSIGNED_USER_ID, ID, AUDIT_ID, TEAM_ID)';
			if @TEST = 1 begin -- then
				print @Command;
			end else begin
				print @Command;
				exec(@Command);
			end -- if;
		end -- if;

		-- 06/03/2016 Paul.  Index when Teams enabled, Dynamic Teams disabled. 
		set @STREAM_INDEX = 'IDX_' + @STREAM_TABLE + '_TID';
		if not exists (select * from sys.indexes where name = @STREAM_INDEX) begin -- then
			set @Command = 'create index ' + @STREAM_INDEX + ' on dbo.' + @STREAM_TABLE + '(TEAM_ID, CREATED_BY, ASSIGNED_USER_ID, ID, AUDIT_ID)';
			if @TEST = 1 begin -- then
				print @Command;
			end else begin
				print @Command;
				exec(@Command);
			end -- if;
		end -- if;

		-- 06/03/2016 Paul.  Index when Teams disabled. 
		set @STREAM_INDEX = 'IDX_' + @STREAM_TABLE + '_CBY';
		if not exists (select * from sys.indexes where name = @STREAM_INDEX) begin -- then
			set @Command = 'create index ' + @STREAM_INDEX + ' on dbo.' + @STREAM_TABLE + '(CREATED_BY, ASSIGNED_USER_ID, ID, AUDIT_ID, TEAM_ID)';
			if @TEST = 1 begin -- then
				print @Command;
			end else begin
				print @Command;
				exec(@Command);
			end -- if;
		end -- if;

		-- 01/15/2018 Paul.  Include the AUDIT_ID so that the columns can be updated. 
		set @STREAM_INDEX = 'IDX_' + @STREAM_TABLE + '_AID';
		if not exists (select * from sys.indexes where name = @STREAM_INDEX) begin -- then
			set @Command = 'create index ' + @STREAM_INDEX + ' on dbo.' + @STREAM_TABLE + '(AUDIT_ID)';
			if @TEST = 1 begin -- then
				print @Command;
			end else begin
				print @Command;
				exec(@Command);
			end -- if;
		end -- if;
	end -- if;
  end
GO


Grant Execute on dbo.spSqlBuildStreamIndex to public;
GO

-- exec dbo.spSqlBuildStreamIndex 'ACCOUNTS';

