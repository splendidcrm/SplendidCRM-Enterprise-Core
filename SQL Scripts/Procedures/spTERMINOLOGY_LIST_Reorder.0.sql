if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spTERMINOLOGY_LIST_Reorder' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spTERMINOLOGY_LIST_Reorder;
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
Create Procedure dbo.spTERMINOLOGY_LIST_Reorder
	( @MODIFIED_USER_ID  uniqueidentifier
	, @LANG              nvarchar(10)
	, @LIST_NAME         nvarchar(50)
	)
as
  begin
	set nocount on
	
	declare @ID             uniqueidentifier;
	-- 08/24/2010 Paul.  Name can be 50 chars. 
	-- 03/06/2012 Paul.  Increase size of the NAME field so that it can include a date formula. 
	declare @NAME           nvarchar(150);
	declare @LIST_ORDER_OLD int;
	declare @LIST_ORDER_NEW int;

-- #if SQL_Server /*
	declare terminology_cursor cursor for
	select ID
	     , NAME
	     , LIST_ORDER
	  from vwTERMINOLOGY
	 where LANG      = @LANG
	   and LIST_NAME = @LIST_NAME
	 order by MODULE_NAME, LIST_ORDER, NAME;
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

	set @LIST_ORDER_NEW = 1;
	open terminology_cursor;
	fetch next from terminology_cursor into @ID, @NAME, @LIST_ORDER_OLD;
	while @@FETCH_STATUS = 0 begin -- do
		if @LIST_ORDER_OLD != @LIST_ORDER_NEW begin -- then
			print N'Correcting list order of ' + @LANG + N'.' + @LIST_NAME + N'.' + @NAME + N' (' + cast(@LIST_ORDER_NEW as varchar(10)) + N')';
			update TERMINOLOGY
			   set LIST_ORDER       = @LIST_ORDER_NEW
			     , MODIFIED_USER_ID = null
			     , DATE_MODIFIED    = getdate()
			     , DATE_MODIFIED_UTC= getutcdate()
			 where ID               = @ID;
		end -- if;
		set @LIST_ORDER_NEW = @LIST_ORDER_NEW + 1;
		fetch next from terminology_cursor into @ID, @NAME, @LIST_ORDER_OLD;
/* -- #if Oracle
		IF terminology_cursor%NOTFOUND THEN
			StoO_sqlstatus := 2;
			StoO_fetchstatus := -1;
		ELSE
			StoO_sqlstatus := 0;
			StoO_fetchstatus := 0;
		END IF;
-- #endif Oracle */
	end -- while;
	close terminology_cursor;

	deallocate terminology_cursor;
  end
GO
 
-- exec dbo.spTERMINOLOGY_LIST_Reorder null, 'en-US', 'moduleList';
/*
select ID
     , NAME
     , LIST_ORDER
  from vwTERMINOLOGY
 where LANG      = 'en-US'
   and LIST_NAME = 'moduleList'
 order by MODULE_NAME, LIST_ORDER, NAME;
*/

Grant Execute on dbo.spTERMINOLOGY_LIST_Reorder to public;
GO
 
