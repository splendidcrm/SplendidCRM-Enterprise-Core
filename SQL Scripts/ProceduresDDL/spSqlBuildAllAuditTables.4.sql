if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildAllAuditTables' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildAllAuditTables;
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
-- 11/17/2008 Paul.  Build audit views. 
Create Procedure dbo.spSqlBuildAllAuditTables
as
  begin
	set nocount on
	print N'spSqlBuildAllAuditTables';

	declare @TABLE_NAME varchar(80);
	declare TABLES_CURSOR cursor for
	select TABLE_NAME
	  from vwSqlTablesAudited
	order by TABLE_NAME;
	
	-- 07/25/2009 Paul.  We need to add a rowversion field to any sync'd table. 
	exec dbo.spSqlUpdateSyncdTables ;

	open TABLES_CURSOR;
	fetch next from TABLES_CURSOR into @TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		exec dbo.spSqlBuildAuditTable @TABLE_NAME;
		fetch next from TABLES_CURSOR into @TABLE_NAME;
	end -- while;
	close TABLES_CURSOR;
	deallocate TABLES_CURSOR;

	-- 09/14/2008 Paul.  A single space after the procedure simplifies the migration to DB2. 
	exec dbo.spSqlBuildAllAuditTriggers ;
	exec dbo.spSqlBuildAllAuditViews ;
  end
GO


Grant Execute on dbo.spSqlBuildAllAuditTables to public;
GO

-- exec dbo.spSqlBuildAllAuditTables;
-- exec dbo.spSqlDropAllAuditTables;

-- exec dbo.spSqlBuildAllStreamTables;
-- exec dbo.spSqlDropAllStreamTables;


