if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildAuditIndex' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildAuditIndex;
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
Create Procedure dbo.spSqlBuildAuditIndex(@TABLE_NAME varchar(80))
as
  begin
	set nocount on

	-- 04/25/2011 Paul.  We've stopped supporting SQL 2000, so we can use varchar(max). 
	declare @Command           varchar(max);
	declare @AUDIT_TABLE       varchar(90);
	declare @CRLF              char(2);
	declare @TEST              bit;
	
	set @TEST = 0;
	set @CRLF = char(13) + char(10);
	set @AUDIT_TABLE = @TABLE_NAME + '_AUDIT';
	if exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = @AUDIT_TABLE and TABLE_TYPE = 'BASE TABLE') begin -- then
		if exists (select * from sys.indexes where name = 'IDX_' + @AUDIT_TABLE) begin -- then
			set @Command = 'drop   index ' + @AUDIT_TABLE + '.IDX_' + @AUDIT_TABLE;
			if @TEST = 1 begin -- then
				print @Command;
			end else begin
				print @Command;
				exec(@Command);
			end -- if;
		end -- if;

		if right(@TABLE_NAME, 5) = '_CSTM' begin -- then
			-- 11/18/2008 Paul.  Include the audit action in the CSTM table as the workflow engine needs to get just the update action and not the insert. 
			set @Command = 'create index IDX_' + @AUDIT_TABLE + ' on dbo.' + @AUDIT_TABLE + '(ID_C, AUDIT_TOKEN, AUDIT_ACTION)';
			if @TEST = 1 begin -- then
				print @Command;
			end else begin
				print @Command;
				exec(@Command);
			end -- if;
		end -- if;
		-- 12/17/2009 Paul.  end if is the same as having a line break, so lets make it explicit. 
		if exists (select * from vwSqlColumns where ObjectName = @AUDIT_TABLE and ColumnName = 'ID') begin -- then
			set @Command = 'create index IDX_' + @AUDIT_TABLE + ' on dbo.' + @AUDIT_TABLE + '(ID, AUDIT_VERSION, AUDIT_TOKEN)';
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


Grant Execute on dbo.spSqlBuildAuditIndex to public;
GO

-- exec dbo.spSqlBuildAuditIndex 'CONTACTS';

