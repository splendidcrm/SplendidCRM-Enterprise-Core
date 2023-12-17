if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlTableColumnsChanged' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlTableColumnsChanged;
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
Create Procedure dbo.spSqlTableColumnsChanged
	( @EXISTS           bit output
	, @TABLE_NAME       nvarchar(80)
	, @ARCHIVE_DATABASE nvarchar(50)
	)
as
  begin
	set nocount on

	declare @COLUMNS_CHANGED      int;
	declare @COMMAND              nvarchar(max);
	declare @PARAM_DEFINTION      nvarchar(100);
	declare @ARCHIVE_DATABASE_DOT nvarchar(50);
	set @PARAM_DEFINTION = N'@CONFIG_VALUE nvarchar(50) OUTPUT';
	set @EXISTS   = 0;
	
	if len(@ARCHIVE_DATABASE) > 0 begin -- then
		set @ARCHIVE_DATABASE_DOT = '[' + @ARCHIVE_DATABASE + '].';
	end else begin
		set @ARCHIVE_DATABASE_DOT = '';
	end -- if;

	set @COMMAND = N'select @CONFIG_VALUE = count(*)
	  from            INFORMATION_SCHEMA.COLUMNS   vwSqlColumns
	  left outer join ' + @ARCHIVE_DATABASE_DOT + 'INFORMATION_SCHEMA.COLUMNS   vwSqlColumnsArchive
	               on vwSqlColumnsArchive.TABLE_NAME  = vwSqlColumns.TABLE_NAME + ''_ARCHIVE''
	              and vwSqlColumnsArchive.COLUMN_NAME = vwSqlColumns.COLUMN_NAME
	 where vwSqlColumnsArchive.TABLE_NAME is null
	   and vwSqlColumns.TABLE_NAME = ''' + @TABLE_NAME + '''';

	exec sp_executesql @COMMAND, @PARAM_DEFINTION, @CONFIG_VALUE = @COLUMNS_CHANGED output;
	if @COLUMNS_CHANGED > 0 begin -- then
		set @EXISTS = 1;
	end -- if;
  end
GO


Grant Execute on dbo.spSqlTableColumnsChanged to public;
GO

/*
declare @EXISTS bit;
exec spSqlTableColumnsChanged @EXISTS out, 'OPPORTUNITIES', null;
print @EXISTS
exec spSqlTableColumnsChanged @EXISTS out, 'OPPORTUNITIES', '';
print @EXISTS
exec spSqlTableColumnsChanged @EXISTS out, 'OPPORTUNITIES', 'SplendidCRM_Archive';
print @EXISTS
*/

