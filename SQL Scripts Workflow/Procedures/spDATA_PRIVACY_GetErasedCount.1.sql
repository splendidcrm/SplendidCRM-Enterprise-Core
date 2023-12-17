if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDATA_PRIVACY_GetErasedCount' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDATA_PRIVACY_GetErasedCount;
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
Create Procedure dbo.spDATA_PRIVACY_GetErasedCount
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	, @ERASED_COUNT     int output
	)
as
  begin
	set nocount on
	
	declare @COMMAND              nvarchar(max);
	declare @PARAM_DEFINTION      nvarchar(200);
	declare @CRLF                 nchar(2);
	declare @MODULE_NAME          nvarchar(50);
	declare @TABLE_NAME           nvarchar(80);
	declare @SINGULAR_NAME        nvarchar(80);
	declare @FIELDS_TO_ERASE      nvarchar(max);
	declare @ERASED_FIELD         nvarchar(50);
	declare @RECORD_ID            uniqueidentifier;
	declare @CurrentPosR          int;
	declare @NextPosR             int;

	set @ERASED_COUNT = 0;
	set @CRLF = char(13) + char(10);
	print 'spDATA_PRIVACY_GetErasedCount: ' + cast(@ID as char(36));

	if exists(select * from DATA_PRIVACY where ID = @ID and STATUS = N'Open' and DELETED = 0) begin -- then
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
			set @SINGULAR_NAME = dbo.fnSqlSingularName(@TABLE_NAME);
			set @COMMAND = '';
			set @COMMAND = @COMMAND  + 'declare DATA_PRIVACY_ERASE_CURSOR cursor for'                       + @CRLF;
			set @COMMAND = @COMMAND  + 'select DATA'                                                        + @CRLF;
			set @COMMAND = @COMMAND  + '     , ' + @SINGULAR_NAME + '_ID'                                   + @CRLF;
			set @COMMAND = @COMMAND  + '  from           ' + @TABLE_NAME + '_DATA_PRIVACY DATA_PRIVACY'     + @CRLF;
			set @COMMAND = @COMMAND  + ' left outer join ERASED_FIELDS'                                     + @CRLF;
			set @COMMAND = @COMMAND  + '              on ERASED_FIELDS.BEAN_ID = ' + @SINGULAR_NAME + '_ID' + @CRLF;
			set @COMMAND = @COMMAND  + '             and ERASED_FIELDS.DELETED = 0'                         + @CRLF;
			set @COMMAND = @COMMAND  + ' where DATA_PRIVACY.DATA_PRIVACY_ID = @DATA_PRIVACY_ID'             + @CRLF;
			set @COMMAND = @COMMAND  + '   and DATA_PRIVACY.DELETED = 0'                                    + @CRLF;
			set @PARAM_DEFINTION = N'@DATA_PRIVACY_ID uniqueidentifier';
			-- print @COMMAND
			exec sp_executesql @COMMAND, @PARAM_DEFINTION, @DATA_PRIVACY_ID = @ID;
		
			open DATA_PRIVACY_ERASE_CURSOR;
			fetch next from DATA_PRIVACY_ERASE_CURSOR into @FIELDS_TO_ERASE, @RECORD_ID;
			while @@FETCH_STATUS = 0 and @@ERROR = 0 begin -- do
				print '	' + @TABLE_NAME + ' ' + cast(@RECORD_ID as char(36)) + ' - ' + isnull(@FIELDS_TO_ERASE, '');
				if @FIELDS_TO_ERASE is not null and len(@FIELDS_TO_ERASE) > 0 begin -- then
					set @CurrentPosR = 1;
					while @CurrentPosR <= len(@FIELDS_TO_ERASE) begin -- do
						set @NextPosR = charindex(',', @FIELDS_TO_ERASE, @CurrentPosR);
						if @NextPosR = 0 or @NextPosR is null begin -- then
							set @NextPosR = len(@FIELDS_TO_ERASE) + 1;
						end -- if;
						set @ERASED_FIELD = rtrim(ltrim(substring(@FIELDS_TO_ERASE, @CurrentPosR, @NextPosR - @CurrentPosR)));
						-- print @ERASED_FIELD;
						if len(@ERASED_FIELD) > 0 begin -- then
							set @ERASED_COUNT = @ERASED_COUNT + 1;
						end -- if;
						set @CurrentPosR = @NextPosR + 1;
					end -- while;
				end -- if;
				fetch next from DATA_PRIVACY_ERASE_CURSOR into @FIELDS_TO_ERASE, @RECORD_ID;
			end -- while;
			close DATA_PRIVACY_ERASE_CURSOR;
			deallocate DATA_PRIVACY_ERASE_CURSOR;
	
			fetch next from DATA_PRIVACY_MODULE_CURSOR into @MODULE_NAME, @TABLE_NAME;
		end -- while;
		close DATA_PRIVACY_MODULE_CURSOR;
		deallocate DATA_PRIVACY_MODULE_CURSOR;
	end -- if;
  end
GO

Grant Execute on dbo.spDATA_PRIVACY_GetErasedCount to public;
GO

/*
declare @ERASED_COUNT int;
exec dbo.spDATA_PRIVACY_GetErasedCount '4E305DBF-1A83-4B0B-B46E-E8B9848346EC', '00000000-0000-0000-0000-000000000002', @ERASED_COUNT output;
print @ERASED_COUNT;
*/

