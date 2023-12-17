if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDATA_PRIVACY_Erase' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDATA_PRIVACY_Erase;
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
Create Procedure dbo.spDATA_PRIVACY_Erase
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @COMMAND              nvarchar(max);
	declare @DEBUG                bit;
	declare @CRLF                 nchar(2);
	declare @MODULE_NAME          nvarchar(50);
	declare @TABLE_NAME           nvarchar(80);
	declare @CurrentPosR          int;
	declare @NextPosR             int;
	declare @DotSeparator         int;

	print '-- spDATA_PRIVACY_Erase: ' + cast(@ID as char(36));
	set @DEBUG = 1;
	set @CRLF  = char(13) + char(10);
	if exists(select * from DATA_PRIVACY where ID = @ID and STATUS = N'Open' and DELETED = 0) begin -- then
		set @COMMAND = '';
		set @COMMAND = @COMMAND  + 'update DATA_PRIVACY'                       + @CRLF;
		set @COMMAND = @COMMAND  + '   set STATUS            = N''Completed''' + @CRLF;
		set @COMMAND = @COMMAND  + '     , DATE_CLOSED       = getdate()'      + @CRLF;
		set @COMMAND = @COMMAND  + '     , DATE_MODIFIED     = getdate()'      + @CRLF;
		set @COMMAND = @COMMAND  + '     , DATE_MODIFIED_UTC = getutcdate()'                + @CRLF;
		set @COMMAND = @COMMAND  + '     , MODIFIED_USER_ID  = ''' + cast(@MODIFIED_USER_ID as char(36)) + '''' + @CRLF;
		set @COMMAND = @COMMAND  + ' where ID                = ''' + cast(@ID               as char(36)) + '''' + @CRLF;
		set @COMMAND = @COMMAND  + '   and DELETED           = 0';
		if @DEBUG = 1 begin -- then
			print @COMMAND + ';';
		end -- if;
		exec(@COMMAND);

		declare DATA_PRIVACY_MODULE_CURSOR cursor for
		select vwMODULES.MODULE_NAME
		     , vwMODULES.TABLE_NAME
		  from      vwMODULES
		 inner join vwSqlTables
		         on vwSqlTables.TABLE_NAME = vwMODULES.TABLE_NAME + '_DATA_PRIVACY'
		 order by MODULE_NAME;
		open DATA_PRIVACY_MODULE_CURSOR;
		fetch next from DATA_PRIVACY_MODULE_CURSOR into @MODULE_NAME, @TABLE_NAME;
		while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
			exec dbo.spDATA_PRIVACY_EraseModuleFields @ID, @MODIFIED_USER_ID, @MODULE_NAME, @TABLE_NAME;
			fetch next from DATA_PRIVACY_MODULE_CURSOR into @MODULE_NAME, @TABLE_NAME;
		end -- while;
		close DATA_PRIVACY_MODULE_CURSOR;
		deallocate DATA_PRIVACY_MODULE_CURSOR;
	end -- if;
  end
GO

Grant Execute on dbo.spDATA_PRIVACY_Erase to public;
GO

/*
begin tran;
exec dbo.spDATA_PRIVACY_Erase '625bb8fa-ec34-437a-8cbb-09481600ec6e', '00000000-0000-0000-0000-000000000002';
rollback tran;
*/



