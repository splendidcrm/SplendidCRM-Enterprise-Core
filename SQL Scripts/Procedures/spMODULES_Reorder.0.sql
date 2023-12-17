if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_Reorder' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_Reorder;
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
-- The intent is to call this procedure any time the tab order changes to ensure that there are not gaps or overlaps. 
Create Procedure dbo.spMODULES_Reorder
	( @MODIFIED_USER_ID  uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @ID             uniqueidentifier;
	declare @MODULE_NAME    nvarchar(25);
	declare @MODULE_ENABLED bit;
	declare @TAB_ENABLED    bit;
	declare @TAB_ORDER_OLD  int;
	declare @TAB_ORDER_NEW  int;

	declare module_cursor cursor for
	select ID
	     , MODULE_NAME
	     , MODULE_ENABLED
	     , TAB_ENABLED
	     , TAB_ORDER
	  from vwMODULES
	 order by TAB_ORDER, MODULE_NAME;

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	set @TAB_ORDER_NEW = 1;
	open module_cursor;
	fetch next from module_cursor into @ID, @MODULE_NAME, @MODULE_ENABLED, @TAB_ENABLED, @TAB_ORDER_OLD;
	while @@FETCH_STATUS = 0 begin -- do
		-- 08/24/2008 Paul.  In a single loop, we want to set the tab order 
		-- or clear it if the module is not visible or disabled. 
		if @MODULE_ENABLED = 1 and @TAB_ENABLED = 1 begin -- then
			if @TAB_ORDER_OLD != @TAB_ORDER_NEW begin -- then
				print N'Correcting tab order of ' + @MODULE_NAME + N' (' + cast(@TAB_ORDER_NEW as varchar(10)) + N')';
				update MODULES
				   set TAB_ORDER        = @TAB_ORDER_NEW
				     , MODIFIED_USER_ID = null
				     , DATE_MODIFIED    = getdate()
				     , DATE_MODIFIED_UTC= getutcdate()
				 where ID               = @ID;
			end -- if;
			set @TAB_ORDER_NEW = @TAB_ORDER_NEW + 1;
		end else begin
			if @TAB_ORDER_OLD != 0 begin -- then
				print N'Correcting tab order of ' + @MODULE_NAME + N' (0)';
				update MODULES
				   set TAB_ORDER        = 0
				     , MODIFIED_USER_ID = null
				     , DATE_MODIFIED    = getdate()
				     , DATE_MODIFIED_UTC= getutcdate()
				 where ID               = @ID;
			end -- if;
		end -- if;
		fetch next from module_cursor into @ID, @MODULE_NAME, @MODULE_ENABLED, @TAB_ENABLED, @TAB_ORDER_OLD;
	end -- while;
	close module_cursor;

	deallocate module_cursor;
  end
GO
 
-- exec dbo.spMODULES_Reorder null;

Grant Execute on dbo.spMODULES_Reorder to public;
GO
 
