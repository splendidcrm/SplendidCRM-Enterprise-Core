if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDASHLETS_USERS_Reorder' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDASHLETS_USERS_Reorder;
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
Create Procedure dbo.spDASHLETS_USERS_Reorder
	( @MODIFIED_USER_ID uniqueidentifier
	, @ASSIGNED_USER_ID uniqueidentifier
	, @DETAIL_NAME      nvarchar(50)
	)
as
  begin
	set nocount on
	
	declare @ID                 uniqueidentifier;
	declare @DASHLET_ENABLED    bit;
	declare @DASHLET_ORDER_OLD  int;
	declare @DASHLET_ORDER_NEW  int;

	declare module_cursor cursor for
	select ID
	     , DASHLET_ENABLED
	     , DASHLET_ORDER
	  from vwDASHLETS_USERS
	 where ASSIGNED_USER_ID = @ASSIGNED_USER_ID
	   and DETAIL_NAME      = @DETAIL_NAME
	 order by DASHLET_ORDER;

/* -- #if IBM_DB2
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
-- #endif IBM_DB2 */
/* -- #if MySQL
	declare continue handler for not found
		set in_FETCH_STATUS = 1;
	set in_FETCH_STATUS = 0;
-- #endif MySQL */

	set @DASHLET_ORDER_NEW = 0;
	open module_cursor;
	fetch next from module_cursor into @ID, @DASHLET_ENABLED, @DASHLET_ORDER_OLD;
	while @@FETCH_STATUS = 0 begin -- do
		if @DASHLET_ENABLED = 1 begin -- then
			if @DASHLET_ORDER_OLD != @DASHLET_ORDER_NEW begin -- then
				update DASHLETS_USERS
				   set DASHLET_ORDER    = @DASHLET_ORDER_NEW
				     , MODIFIED_USER_ID = null
				     , DATE_MODIFIED    = getdate()
				     , DATE_MODIFIED_UTC= getutcdate()
				 where ID               = @ID;
			end -- if;
			set @DASHLET_ORDER_NEW = @DASHLET_ORDER_NEW + 1;
		end else begin
			if @DASHLET_ORDER_OLD != 0 begin -- then
				update DASHLETS_USERS
				   set DASHLET_ORDER    = 0
				     , MODIFIED_USER_ID = null
				     , DATE_MODIFIED    = getdate()
				     , DATE_MODIFIED_UTC= getutcdate()
				 where ID               = @ID;
			end -- if;
		end -- if;
		fetch next from module_cursor into @ID, @DASHLET_ENABLED, @DASHLET_ORDER_OLD;
	end -- while;
	close module_cursor;

	deallocate module_cursor;
  end
GO

Grant Execute on dbo.spDASHLETS_USERS_Reorder to public;
GO

