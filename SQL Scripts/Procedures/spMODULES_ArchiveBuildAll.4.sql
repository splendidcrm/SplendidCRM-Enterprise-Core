if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_ArchiveBuildAll' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_ArchiveBuildAll;
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
Create Procedure dbo.spMODULES_ArchiveBuildAll
as
  begin
	set nocount on

	declare @MODULE_ID   uniqueidentifier;
	declare @MODULE_NAME nvarchar(25);

	declare MODULES_ARCHIVE_BUILD_ALL_CURSOR cursor for
	select distinct MODULES.ID
	     , MODULES.MODULE_NAME
	  from      MODULES_ARCHIVE_RELATED
	 inner join MODULES
	         on MODULES.MODULE_NAME    = MODULES_ARCHIVE_RELATED.MODULE_NAME
	        and MODULES.MODULE_ENABLED = 1
	        and MODULES.DELETED        = 0
	 where MODULES_ARCHIVE_RELATED.DELETED = 0
	 order by MODULES.MODULE_NAME;
	
	open MODULES_ARCHIVE_BUILD_ALL_CURSOR;
	fetch next from MODULES_ARCHIVE_BUILD_ALL_CURSOR into @MODULE_ID, @MODULE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		print 'Build Archive: ' + @MODULE_NAME;
		exec dbo.spMODULES_ArchiveBuild @MODULE_ID, null;
		fetch next from MODULES_ARCHIVE_BUILD_ALL_CURSOR into @MODULE_ID, @MODULE_NAME;
	end -- while;
	close MODULES_ARCHIVE_BUILD_ALL_CURSOR;
	deallocate MODULES_ARCHIVE_BUILD_ALL_CURSOR;
  end
GO

Grant Execute on dbo.spMODULES_ArchiveBuildAll to public;
GO

/*
-- 12/18/2017 Paul.  Took 4 minutes. 
-- 02/08/2020 Paul.  Took 1:20 on faster server, but including audit tables. 
begin try
	begin tran;
	declare @ARCHIVE_DATABASE    nvarchar(50);
	set @ARCHIVE_DATABASE = dbo.fnCONFIG_String('Archive.Database');
	exec dbo.spSqlDropAllArchiveTables @ARCHIVE_DATABASE;
	--exec dbo.spMODULES_ArchiveBuildAll ;
	commit tran;
end try
begin catch
	rollback tran;
	print ERROR_MESSAGE();
end catch
*/

