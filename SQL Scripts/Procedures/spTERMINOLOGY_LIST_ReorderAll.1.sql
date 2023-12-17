if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTERMINOLOGY_LIST_ReorderAll' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTERMINOLOGY_LIST_ReorderAll;
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
-- 08/24/2008 Paul.  The extension of this procedure is zero so that we do not have to rename any other procedures. 
-- The intent is to call this procedure any time the list order changes to ensure that there are not gaps or overlaps. 
Create Procedure dbo.spTERMINOLOGY_LIST_ReorderAll
	( @MODIFIED_USER_ID  uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID             uniqueidentifier;
	declare @LANG           nvarchar(10);
	declare @LIST_NAME      nvarchar(50);

-- #if SQL_Server /*
	declare list_cursor cursor for
	select vwTERMINOLOGY.LANG
	     , vwTERMINOLOGY.LIST_NAME
	  from      vwTERMINOLOGY
	 inner join vwLANGUAGES
	         on vwLANGUAGES.NAME   = vwTERMINOLOGY.LANG
	        and vwLANGUAGES.ACTIVE = 1
	 where vwTERMINOLOGY.LIST_NAME is not null
	 group by vwTERMINOLOGY.LANG, vwTERMINOLOGY.LIST_NAME
	 order by vwTERMINOLOGY.LANG, vwTERMINOLOGY.LIST_NAME;
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

	open list_cursor;
	fetch next from list_cursor into @LANG, @LIST_NAME;
	while @@FETCH_STATUS = 0 begin -- do
		--print @LANG + N'.' + @LIST_NAME;
		exec dbo.spTERMINOLOGY_LIST_Reorder @MODIFIED_USER_ID, @LANG, @LIST_NAME;
		fetch next from list_cursor into @LANG, @LIST_NAME;
/* -- #if Oracle
		IF list_cursor%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close list_cursor;

	deallocate list_cursor;
  end
GO
 
-- exec dbo.spTERMINOLOGY_LIST_ReorderAll null;

Grant Execute on dbo.spTERMINOLOGY_LIST_ReorderAll to public;
GO
 
