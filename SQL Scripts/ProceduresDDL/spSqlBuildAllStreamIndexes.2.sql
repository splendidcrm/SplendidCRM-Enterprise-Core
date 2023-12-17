if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlBuildAllStreamIndexes' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlBuildAllStreamIndexes;
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
-- 07/31/2017 Paul.  Use unique name for cursor to help catch errors. 
Create Procedure dbo.spSqlBuildAllStreamIndexes
as
  begin
	set nocount on
	print N'spSqlBuildAllStreamIndexes';

	declare @TABLE_NAME varchar(80);
	declare STREAM_INDEX_TABLES_CURSOR cursor for
	select TABLE_NAME
	  from vwSqlTablesStreamed
	order by TABLE_NAME;
	
	open STREAM_INDEX_TABLES_CURSOR;
	fetch next from STREAM_INDEX_TABLES_CURSOR into @TABLE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		exec dbo.spSqlBuildStreamIndex @TABLE_NAME;
		fetch next from STREAM_INDEX_TABLES_CURSOR into @TABLE_NAME;
	end -- while;
	close STREAM_INDEX_TABLES_CURSOR;
	deallocate STREAM_INDEX_TABLES_CURSOR;
  end
GO


Grant Execute on dbo.spSqlBuildAllStreamIndexes to public;
GO

-- exec dbo.spSqlBuildAllStreamIndexes;




