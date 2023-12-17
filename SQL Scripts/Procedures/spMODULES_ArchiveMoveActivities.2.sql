if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_ArchiveMoveActivities' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_ArchiveMoveActivities;
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
-- 05/02/2018 Paul.  List is not paginated. 
-- 02/08/2020 Paul.  Include Audit tables. 
Create Procedure dbo.spMODULES_ArchiveMoveActivities
	( @MODIFIED_USER_ID  uniqueidentifier
	, @MODULE_NAME       nvarchar(25)
	, @ID_LIST           varchar(max)
	)
as
  begin
	set nocount on

	declare @TABLE_NAME           nvarchar(80);
	declare @RELATED_TABLE_NAME   nvarchar(80);
	declare @RELATED_CUSTOM_NAME  nvarchar(80);
	declare @RELATED_FIELD_NAME   nvarchar(80);
	-- 02/08/2020 Paul.  Include Audit tables. 
	declare @AUDIT_RELATED_TABLE_NAME    nvarchar(80);
	declare @AUDIT_RELATED_CUSTOM_NAME   nvarchar(80);
	declare @EXISTS               bit;
	declare @RELATED_ARCHIVE      nvarchar(90);
	declare @ARCHIVE_DATABASE     nvarchar(50);
	set @ARCHIVE_DATABASE = dbo.fnCONFIG_String('Archive.Database');

	select @TABLE_NAME = TABLE_NAME
	  from MODULES
	 where MODULE_NAME    = @MODULE_NAME
	   and MODULE_ENABLED = 1
	   and DELETED        = 0;

	if len(@ID_LIST) = 0 begin -- then
		raiserror(N'List of IDs is empty.', 16, 1);
	end else if @TABLE_NAME is not null begin -- then
-- #if SQL_Server /*
		declare MODULES_ARCHIVE_ACTIVITIES_CURSOR cursor for
		select RELATED_TABLE
		  from vwMODULES_ARCHIVE_RELATED
		 where MODULE_NAME = 'Activities'
		 order by RELATED_ORDER;
-- #endif SQL_Server */
		
		open MODULES_ARCHIVE_ACTIVITIES_CURSOR;
		fetch next from MODULES_ARCHIVE_ACTIVITIES_CURSOR into @RELATED_TABLE_NAME;
		while @@FETCH_STATUS = 0 begin -- do
			set @RELATED_CUSTOM_NAME = @RELATED_TABLE_NAME + '_CSTM';
			set @RELATED_FIELD_NAME  = 'PARENT_ID';
			-- 11/18/2017 Paul.  Activities module may be disabled, so check if archive table exists first. 
			set @RELATED_ARCHIVE     = @RELATED_TABLE_NAME + '_ARCHIVE';
			exec dbo.spSqlTableExists @EXISTS out, @RELATED_ARCHIVE, @ARCHIVE_DATABASE;
			if @EXISTS = 1 begin -- then
				-- 09/26/2017 Paul.  Must move custom data first before the parent record is deleted. 
				exec dbo.spMODULES_ARCHIVE_LOG_InsertOnly @MODIFIED_USER_ID, @RELATED_TABLE_NAME, N'Move';
				exec dbo.spSqlMoveArchiveData @MODIFIED_USER_ID, @RELATED_CUSTOM_NAME, @ID_LIST, @RELATED_TABLE_NAME, @RELATED_FIELD_NAME, @TABLE_NAME, @ARCHIVE_DATABASE;
				exec dbo.spSqlMoveArchiveData @MODIFIED_USER_ID, @RELATED_TABLE_NAME , @ID_LIST, @RELATED_TABLE_NAME, @RELATED_FIELD_NAME, @TABLE_NAME, @ARCHIVE_DATABASE;
			end -- if;

			-- 02/08/2020 Paul.  Include Audit tables. 
			set @AUDIT_RELATED_TABLE_NAME  = @RELATED_TABLE_NAME + '_AUDIT';
			set @AUDIT_RELATED_CUSTOM_NAME = @RELATED_TABLE_NAME + '_CSTM_AUDIT';
			set @RELATED_ARCHIVE           = @RELATED_TABLE_NAME + '_AUDIT_ARCHIVE';
			exec dbo.spSqlTableExists @EXISTS out, @RELATED_ARCHIVE, @ARCHIVE_DATABASE;
			if @EXISTS = 1 begin -- then
				exec dbo.spMODULES_ARCHIVE_LOG_InsertOnly @MODIFIED_USER_ID, @RELATED_TABLE_NAME, N'Recover';
				exec dbo.spSqlMoveArchiveData @MODIFIED_USER_ID, @AUDIT_RELATED_CUSTOM_NAME, @ID_LIST, @AUDIT_RELATED_TABLE_NAME, @RELATED_FIELD_NAME, @TABLE_NAME, @ARCHIVE_DATABASE;
				exec dbo.spSqlMoveArchiveData @MODIFIED_USER_ID, @AUDIT_RELATED_TABLE_NAME , @ID_LIST, @AUDIT_RELATED_TABLE_NAME, @RELATED_FIELD_NAME, @TABLE_NAME, @ARCHIVE_DATABASE;
			end -- if;
			fetch next from MODULES_ARCHIVE_ACTIVITIES_CURSOR into @RELATED_TABLE_NAME;
		end -- while;
		close MODULES_ARCHIVE_ACTIVITIES_CURSOR;
		deallocate MODULES_ARCHIVE_ACTIVITIES_CURSOR;
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_ArchiveMoveActivities to public;
GO

