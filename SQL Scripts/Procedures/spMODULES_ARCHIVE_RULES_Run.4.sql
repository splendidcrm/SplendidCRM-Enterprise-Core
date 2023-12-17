if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_ARCHIVE_RULES_Run' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_ARCHIVE_RULES_Run;
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
Create Procedure dbo.spMODULES_ARCHIVE_RULES_Run
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	declare @MODULE_NAME    nvarchar(25);
	declare @TABLE_NAME     nvarchar(50);
	declare @FILTER_SQL     nvarchar(max);
	declare @ID_LIST        varchar(8000);

-- #if SQL_Server /*
	declare @ID_LIST_TABLE TABLE
		( ID uniqueidentifier not null
		);
	declare @ID_LIST_PAGED TABLE
		( ID uniqueidentifier not null
		);
-- #endif SQL_Server */

	if exists(select * from MODULES_ARCHIVE_RULES where ID = @ID and STATUS = 1 and DELETED = 0) begin -- then
		select @MODULE_NAME = MODULES_ARCHIVE_RULES.MODULE_NAME
		     , @TABLE_NAME  = MODULES.TABLE_NAME
		     , @FILTER_SQL  = MODULES_ARCHIVE_RULES.FILTER_SQL
		  from            MODULES_ARCHIVE_RULES
		  left outer join MODULES
		               on MODULES.MODULE_NAME = MODULES_ARCHIVE_RULES.MODULE_NAME
		 where MODULES_ARCHIVE_RULES.ID     = @ID
		  and MODULES_ARCHIVE_RULES.DELETED = 0;
	
		exec spMODULES_ARCHIVE_LOG_InsertRule @MODIFIED_USER_ID, @ID, @MODULE_NAME, @TABLE_NAME;

		if @FILTER_SQL is not null begin -- then
			-- 02/17/2018 Paul.  To prevent SQL Injection from the Filter SQL, wrap the execute in a transaction and always roll the transaction back. 
			begin transaction DynamicArchiveRule;
			save transaction DynamicArchiveRule;

			-- 02/17/2018 Paul.  We don't need to use the temp table. 
			--insert into #TEMP_ARCHIVE
			insert into @ID_LIST_TABLE (ID)
			exec sp_executesql @FILTER_SQL;

			rollback transaction DynamicArchiveRule;
			commit transaction DynamicArchiveRule;

			delete from @ID_LIST_TABLE
			 where ID in (select ARCHIVE_RECORD_ID from MODULES_ARCHIVE_LOG where ARCHIVE_ACTION = 'Recover' and MODULE_NAME = @MODULE_NAME);
			
			-- 02/17/2018 Paul.  spMODULES_ArchiveMoveData is limited by 8000 chars, so paginate the list. 
			while exists (select * from @ID_LIST_TABLE) begin -- do
				delete from @ID_LIST_PAGED;
				insert into @ID_LIST_PAGED (ID)
				select top 200 *
				  from @ID_LIST_TABLE;

				set @ID_LIST = '';
				select @ID_LIST = @ID_LIST + (case when len(@ID_LIST) > 0 then ',' else '' end) + cast(ID as char(36)) from @ID_LIST_PAGED;
				exec dbo.spMODULES_ArchiveMoveData @MODIFIED_USER_ID, @MODULE_NAME, @ID_LIST, @ID;

				delete from @ID_LIST_TABLE
				 where ID in (select ID from @ID_LIST_PAGED);
			end -- while;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_ARCHIVE_RULES_Run to public;
GO

