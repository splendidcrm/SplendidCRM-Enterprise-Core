if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlDropAllArchiveViews' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlDropAllArchiveViews;
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
Create Procedure dbo.spSqlDropAllArchiveViews
as
  begin
	set nocount on
	print 'spSqlDropAllArchiveViews';

	declare @COMMAND      nvarchar(max);
	declare @VIEW_NAME    nvarchar(90);
	declare ARCHIVE_VIEWS_CURSOR cursor for
	select TABLE_NAME
	  from INFORMATION_SCHEMA.VIEWS
	 where TABLE_NAME like 'vw%[_]ARCHIVE'
	order by TABLE_NAME;

	open ARCHIVE_VIEWS_CURSOR;
	fetch next from ARCHIVE_VIEWS_CURSOR into @VIEW_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = @VIEW_NAME) begin -- then
			set @COMMAND = 'Drop View dbo.' + @VIEW_NAME;
			print @COMMAND;
			exec(@COMMAND);
		end -- if;

		fetch next from ARCHIVE_VIEWS_CURSOR into @VIEW_NAME;
	end -- while;
	close ARCHIVE_VIEWS_CURSOR;
	deallocate ARCHIVE_VIEWS_CURSOR;
  end
GO


Grant Execute on dbo.spSqlDropAllArchiveViews to public;
GO

-- exec dbo.spSqlDropAllArchiveViews ;


