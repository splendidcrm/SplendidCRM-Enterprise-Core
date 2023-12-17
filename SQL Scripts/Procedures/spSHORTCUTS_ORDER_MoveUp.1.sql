if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spSHORTCUTS_ORDER_MoveUp' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spSHORTCUTS_ORDER_MoveUp;
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
Create Procedure dbo.spSHORTCUTS_ORDER_MoveUp
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @SWAP_ID            uniqueidentifier;
	declare @MODULE_NAME        nvarchar(50);
	declare @SHORTCUT_ORDER     int;
	if exists(select * from SHORTCUTS where ID = @ID and DELETED = 0) begin -- then
		-- BEGIN Oracle Exception
			select @MODULE_NAME        = MODULE_NAME
			     , @SHORTCUT_ORDER     = SHORTCUT_ORDER
			  from SHORTCUTS
			 where ID                  = @ID
			   and DELETED             = 0;
		-- END Oracle Exception

		-- 12/13/2007 Paul.  SHORTCUT_ORDER 0 is reserved.  Don't allow decrease below 1. 
		if @SHORTCUT_ORDER is not null begin -- then
			-- BEGIN Oracle Exception
				select @SWAP_ID           = ID
				  from SHORTCUTS
				 where MODULE_NAME        = @MODULE_NAME
				   and SHORTCUT_ORDER     = @SHORTCUT_ORDER - 1
				   and DELETED            = 0;
			-- END Oracle Exception

			-- Moving up actually means decrementing the order value. 
			if dbo.fnIsEmptyGuid(@SWAP_ID) = 0 begin -- then
				-- BEGIN Oracle Exception
					update SHORTCUTS
					   set SHORTCUT_ORDER     = SHORTCUT_ORDER - 1
					     , DATE_MODIFIED      = getdate()
					     , DATE_MODIFIED_UTC= getutcdate()
					     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
					 where ID                 = @ID;
				-- END Oracle Exception
				-- BEGIN Oracle Exception
					update SHORTCUTS
					   set SHORTCUT_ORDER     = SHORTCUT_ORDER + 1
					     , DATE_MODIFIED      = getdate()
					     , DATE_MODIFIED_UTC= getutcdate()
					     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
					 where ID                 = @SWAP_ID;
				-- END Oracle Exception
			end -- if;
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spSHORTCUTS_ORDER_MoveUp to public;
GO

