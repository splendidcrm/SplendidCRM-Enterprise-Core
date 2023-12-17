if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlDropAllStreamFunctions' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlDropAllStreamFunctions;
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
Create Procedure dbo.spSqlDropAllStreamFunctions
as
  begin
	set nocount on

	declare @Command      varchar(max);
	declare @AUDIT_TABLE  varchar(90);
	declare @TABLE_NAME   varchar(80);
	declare @FUNCTION_NAME varchar(90);

	declare FUNCTIONS_CURSOR cursor for
	select ROUTINE_NAME
	  from INFORMATION_SCHEMA.ROUTINES
	 where ROUTINE_NAME like 'fn%[_]AUDIT[_]COLUMNS'
	   and ROUTINE_TYPE = 'FUNCTION'
	 order by ROUTINE_NAME;
	open FUNCTIONS_CURSOR;
	fetch next from FUNCTIONS_CURSOR into @FUNCTION_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		set @Command = 'Drop Function dbo.' + @FUNCTION_NAME;
		print @Command;
		exec(@Command);
		fetch next from FUNCTIONS_CURSOR into @FUNCTION_NAME;
	end -- while;
	close FUNCTIONS_CURSOR;
	deallocate FUNCTIONS_CURSOR;
  end
GO


Grant Execute on dbo.spSqlDropAllStreamFunctions to public;
GO

-- exec dbo.spSqlDropAllStreamFunctions;


