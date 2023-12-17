if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlDropAllStreamTriggers' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlDropAllStreamTriggers;
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
Create Procedure dbo.spSqlDropAllStreamTriggers
as
  begin
	set nocount on

	declare @Command      varchar(max);
	declare @AUDIT_TABLE  varchar(90);
	declare @TABLE_NAME   varchar(80);
	declare @TRIGGER_NAME varchar(90);

	declare TRIGGERS_CURSOR cursor for
	select name
	  from sys.triggers
	 where name like 'tr%_Ins_STREAM'
	 order by name;
	open TRIGGERS_CURSOR;
	fetch next from TRIGGERS_CURSOR into @TRIGGER_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		set @Command = 'Drop Trigger dbo.' + @TRIGGER_NAME;
		print @Command;
		exec(@Command);
		fetch next from TRIGGERS_CURSOR into @TRIGGER_NAME;
	end -- while;
	close TRIGGERS_CURSOR;
	deallocate TRIGGERS_CURSOR;
  end
GO


Grant Execute on dbo.spSqlDropAllStreamTriggers to public;
GO

-- exec dbo.spSqlDropAllStreamTriggers;


