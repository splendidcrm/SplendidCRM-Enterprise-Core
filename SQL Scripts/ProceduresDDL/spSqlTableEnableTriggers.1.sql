if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSqlTableEnableTriggers' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSqlTableEnableTriggers;
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
Create Procedure dbo.spSqlTableEnableTriggers
	( @TABLE_NAME        varchar(255)
	)
as
  begin
	set nocount on

	declare @COMMAND       varchar(2000);
	declare @COLUMN_NAME   varchar(255);

	-- 04/27/2014 Paul.  Use simplified call to manage triggers. Both are valid. 
	set @COMMAND = 'alter table ' + upper(@TABLE_NAME) + ' enable trigger all';
	--set @COMMAND = 'enable trigger all on ' + upper(@TABLE_NAME);
	exec(@COMMAND);
	--declare TRIGGER_CURSOR cursor for
	--select TRIGGERS.name
	--  from      sys.objects        TRIGGERS
	-- inner join sys.objects        TABLES
	--         on TABLES.object_id = TRIGGERS.parent_object_id
	-- where TRIGGERS.type = 'TR'
	--   and TABLES.name = @TABLE_NAME;
	--open TRIGGER_CURSOR;
	--fetch next from TRIGGER_CURSOR into @COLUMN_NAME;
	--while @@FETCH_STATUS = 0 begin -- do
	--	set @COMMAND = 'alter table ' + upper(@TABLE_NAME) + ' enable trigger ' +  @COLUMN_NAME + ';';
	--	exec(@COMMAND);
	--	fetch next from TRIGGER_CURSOR into @COLUMN_NAME;
	--end -- while;
	--close TRIGGER_CURSOR;
	--deallocate TRIGGER_CURSOR;
  end
GO

Grant Execute on dbo.spSqlTableEnableTriggers to public;
GO


