if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_ArchiveBuildView' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_ArchiveBuildView;
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
-- 02/08/2020 Paul.  Include Audit tables. 
Create Procedure dbo.spMODULES_ArchiveBuildView
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on

	declare @MODULE_NAME         nvarchar(25);
	declare @TABLE_NAME          nvarchar(80);
	declare @CUSTOM_NAME         nvarchar(80);
	-- 02/08/2020 Paul.  Include Audit tables. 
	declare @AUDIT_TABLE_NAME    nvarchar(80);
	declare @AUDIT_CUSTOM_NAME   nvarchar(80);
	declare @RELATED_MODULE_NAME nvarchar(80);
	declare @ACTIVITY_TABLE_NAME nvarchar(80);
	declare @ARCHIVE_NAME        nvarchar(80);
	declare @MODULE_CHANGED      bit;
	declare @EXISTS              bit;
	declare @MISSING_ACTIVITIES  int;
	declare @ARCHIVE_DATABASE    nvarchar(50);

	set @MODULE_CHANGED = 0;
	set @ARCHIVE_DATABASE = dbo.fnCONFIG_String('Archive.Database');
	if @ARCHIVE_DATABASE is not null begin -- then
		print 'Archive Database = ' + isnull(@ARCHIVE_DATABASE, '');
	end -- if;

	select @MODULE_NAME = MODULE_NAME
	     , @TABLE_NAME  = TABLE_NAME
	  from MODULES
	 where ID             = @ID
	   and MODULE_ENABLED = 1
	   and DELETED        = 0;
	if @TABLE_NAME is not null begin -- then
		set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
		if 1 = 1 begin -- then
			exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
			-- 02/08/2020 Paul.  Include Audit tables. 
			set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
			exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
			if @TABLE_NAME = 'QUOTES' begin -- then
				set @TABLE_NAME  = 'QUOTES_LINE_ITEMS';
				set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
				exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
				-- 02/08/2020 Paul.  Include Audit tables. 
				set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
				exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
			end else if @TABLE_NAME = 'ORDERS' begin -- then
				set @TABLE_NAME  = 'ORDERS_LINE_ITEMS';
				set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
				exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
				-- 02/08/2020 Paul.  Include Audit tables. 
				set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
				exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
			end else if @TABLE_NAME = 'INVOICES' begin -- then
				set @TABLE_NAME  = 'INVOICES_LINE_ITEMS';
				set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
				exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
				-- 02/08/2020 Paul.  Include Audit tables. 
				set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
				exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
			end else if @TABLE_NAME = 'OPPORTUNITIES' begin -- then
				set @TABLE_NAME  = 'REVENUE_LINE_ITEMS';
				set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
				exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
				-- 02/08/2020 Paul.  Include Audit tables. 
				set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
				exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
			end else if @TABLE_NAME = 'PROJECT' begin -- then
				set @TABLE_NAME  = 'PROJECT_TASK';
				set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
				exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
				-- 02/08/2020 Paul.  Include Audit tables. 
				set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
				exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
			end -- if;
			if exists(select * from vwMODULES_ARCHIVE_RELATED where MODULE_NAME = @MODULE_NAME and RELATED_NAME = 'Activities') begin -- then
				exec dbo.spSqlBuildArchiveActivitiesView  @MODULE_NAME, @ARCHIVE_DATABASE;
			end -- if;

-- #if SQL_Server /*
			declare MODULES_ARCHIVE_RELATED_CURSOR cursor for
			select RELATED_NAME
			     , RELATED_TABLE
			  from vwMODULES_ARCHIVE_RELATED
			 where MODULE_NAME = @MODULE_NAME
			 order by RELATED_ORDER;
-- #endif SQL_Server */
			
			open MODULES_ARCHIVE_RELATED_CURSOR;
			fetch next from MODULES_ARCHIVE_RELATED_CURSOR into @RELATED_MODULE_NAME, @TABLE_NAME;
			while @@FETCH_STATUS = 0 begin -- do
				if @TABLE_NAME is not null and @RELATED_MODULE_NAME <> @MODULE_NAME begin -- then
					set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
					exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
					-- 02/08/2020 Paul.  Include Audit tables. 
					set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
					exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
					if @TABLE_NAME = 'QUOTES' begin -- then
						set @TABLE_NAME  = 'QUOTES_LINE_ITEMS';
						set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
						exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
						-- 02/08/2020 Paul.  Include Audit tables. 
						set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
						exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
					end else if @TABLE_NAME = 'ORDERS' begin -- then
						set @TABLE_NAME  = 'ORDERS_LINE_ITEMS';
						set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
						exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
						-- 02/08/2020 Paul.  Include Audit tables. 
						set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
						exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
					end else if @TABLE_NAME = 'INVOICES' begin -- then
						set @TABLE_NAME  = 'INVOICES_LINE_ITEMS';
						set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
						exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
						-- 02/08/2020 Paul.  Include Audit tables. 
						set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
						exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
					end else if @TABLE_NAME = 'OPPORTUNITIES' begin -- then
						set @TABLE_NAME  = 'REVENUE_LINE_ITEMS';
						set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
						exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
						-- 02/08/2020 Paul.  Include Audit tables. 
						set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
						exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
					end else if @TABLE_NAME = 'PROJECT' begin -- then
						set @TABLE_NAME  = 'PROJECT_TASK';
						set @CUSTOM_NAME = @TABLE_NAME + '_CSTM';
						exec dbo.spSqlBuildArchiveView    @TABLE_NAME , @ARCHIVE_DATABASE;
						-- 02/08/2020 Paul.  Include Audit tables. 
						set @AUDIT_TABLE_NAME = @TABLE_NAME + '_AUDIT';
						exec dbo.spSqlBuildArchiveView    @AUDIT_TABLE_NAME , @ARCHIVE_DATABASE;
					end -- if;
					if exists(select * from vwMODULES_ARCHIVE_RELATED where MODULE_NAME = @RELATED_MODULE_NAME and RELATED_NAME = 'Activities') begin -- then
						exec dbo.spSqlBuildArchiveActivitiesView  @RELATED_MODULE_NAME, @ARCHIVE_DATABASE;
					end -- if;
				end else if @TABLE_NAME = 'Activities' begin -- then
					exec dbo.spSqlBuildArchiveActivitiesView @RELATED_MODULE_NAME, @ARCHIVE_DATABASE;
				end -- if;
				fetch next from MODULES_ARCHIVE_RELATED_CURSOR into @RELATED_MODULE_NAME, @TABLE_NAME;
			end -- while;
			close MODULES_ARCHIVE_RELATED_CURSOR;
			deallocate MODULES_ARCHIVE_RELATED_CURSOR;

			exec dbo.spSqlBuildArchiveRelatedView     @MODULE_NAME, @ARCHIVE_DATABASE;
		end -- if;
	end else if @MODULE_NAME = 'Activities' begin -- then
		exec dbo.spSqlBuildArchiveActivityView @ARCHIVE_DATABASE;
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_ArchiveBuildView to public;
GO

