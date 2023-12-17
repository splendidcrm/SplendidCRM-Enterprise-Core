if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_ARCHIVE_RULES_RunAll' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_ARCHIVE_RULES_RunAll;
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
Create Procedure dbo.spMODULES_ARCHIVE_RULES_RunAll
as
  begin
	set nocount on

	declare @ID uniqueidentifier;

-- #if SQL_Server /*
	declare ARCHIVE_RULES_CURSOR cursor for
	select ID
	  from MODULES_ARCHIVE_RULES
	 where DELETED = 0
	   and STATUS  = 1
	 order by LIST_ORDER_Y, MODULE_NAME, NAME;
-- #endif SQL_Server */

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	open ARCHIVE_RULES_CURSOR;
	fetch next from ARCHIVE_RULES_CURSOR into @ID;
	while @@FETCH_STATUS = 0 begin -- do
		exec dbo.spMODULES_ARCHIVE_RULES_Run @ID, null;
		fetch next from ARCHIVE_RULES_CURSOR into @ID;
	end -- while;
	close ARCHIVE_RULES_CURSOR;
	deallocate ARCHIVE_RULES_CURSOR;
  end
GO

Grant Execute on dbo.spMODULES_ARCHIVE_RULES_RunAll to public;
GO

