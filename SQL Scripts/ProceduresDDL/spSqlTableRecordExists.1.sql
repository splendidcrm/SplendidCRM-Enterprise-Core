if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlTableRecordExists' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlTableRecordExists;
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
Create Procedure dbo.spSqlTableRecordExists
	( @EXISTS           bit output
	, @TABLE_NAME       nvarchar(80)
	, @PRIMARY_KEY      nvarchar(50)
	, @RECORD_ID        uniqueidentifier
	, @ARCHIVE_DATABASE nvarchar(50)
	)
as
  begin
	set nocount on

	declare @COMMAND              nvarchar(max);
	declare @PARAM_DEFINTION      nvarchar(100);
	declare @ARCHIVE_DATABASE_DOT nvarchar(50);
	set @PARAM_DEFINTION = N'@COUNT_VALUE int output, @RECORD_ID uniqueidentifier';
	set @EXISTS   = 0;
	
	if len(@ARCHIVE_DATABASE) > 0 begin -- then
		if charindex('.', @ARCHIVE_DATABASE) > 0 begin -- then
			set @ARCHIVE_DATABASE_DOT = @ARCHIVE_DATABASE;
		end else begin
			set @ARCHIVE_DATABASE_DOT = '[' + @ARCHIVE_DATABASE + '].';
		end -- if;
	end else begin
		set @ARCHIVE_DATABASE_DOT = '';
	end -- if;


	exec dbo.spSqlTableExists @EXISTS output, @TABLE_NAME, @ARCHIVE_DATABASE;
	if @EXISTS = 1 begin -- then
		set @EXISTS   = 0;
		set @COMMAND = N'select @COUNT_VALUE = count(*) from ' + @ARCHIVE_DATABASE_DOT + 'dbo.' + @TABLE_NAME + ' where ' + @PRIMARY_KEY + ' = @RECORD_ID';
		exec sp_executesql @COMMAND, @PARAM_DEFINTION, @COUNT_VALUE = @EXISTS output, @RECORD_ID = @RECORD_ID;
	end -- if;
  end
GO


Grant Execute on dbo.spSqlTableRecordExists to public;
GO

/*
declare @EXISTS bit;
exec spSqlTableRecordExists @EXISTS out, 'CONTACTS', 'ID', 'D996B72A-29B1-410A-96DB-DE78C2075D9A', 'SplendidCRM_Archive';
print @EXISTS
*/

