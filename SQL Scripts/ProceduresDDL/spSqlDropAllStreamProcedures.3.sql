if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlDropAllStreamProcedures' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlDropAllStreamProcedures;
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
Create Procedure dbo.spSqlDropAllStreamProcedures
as
  begin
	set nocount on

	declare @Command        varchar(max);
	declare @AUDIT_TABLE    varchar(90);
	declare @TABLE_NAME     varchar(80);
	declare @PROCEDURE_NAME varchar(90);

	declare PROCEDURES_CURSOR cursor for
	select ROUTINE_NAME
	  from INFORMATION_SCHEMA.ROUTINES
	 where ROUTINE_NAME like 'sp%[_]STREAM[_]InsertPost'
	   and ROUTINE_TYPE = 'PROCEDURE'
	 order by ROUTINE_NAME;
	open PROCEDURES_CURSOR;
	fetch next from PROCEDURES_CURSOR into @PROCEDURE_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		set @Command = 'Drop Procedure dbo.' + @PROCEDURE_NAME;
		print @Command;
		exec(@Command);
		fetch next from PROCEDURES_CURSOR into @PROCEDURE_NAME;
	end -- while;
	close PROCEDURES_CURSOR;
	deallocate PROCEDURES_CURSOR;
  end
GO


Grant Execute on dbo.spSqlDropAllStreamProcedures to public;
GO

-- exec dbo.spSqlDropAllStreamProcedures;


