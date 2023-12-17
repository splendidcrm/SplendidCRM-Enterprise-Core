if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spDYNAMIC_BUTTONS_ORDER_MoveDown' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spDYNAMIC_BUTTONS_ORDER_MoveDown;
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
Create Procedure dbo.spDYNAMIC_BUTTONS_ORDER_MoveDown
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @SWAP_ID            uniqueidentifier;
	declare @VIEW_NAME          nvarchar(50);
	declare @CONTROL_INDEX      int;
	if exists(select * from DYNAMIC_BUTTONS where ID = @ID and DELETED = 0) begin -- then
		-- BEGIN Oracle Exception
			select @VIEW_NAME          = VIEW_NAME
			     , @CONTROL_INDEX      = CONTROL_INDEX
			  from DYNAMIC_BUTTONS
			 where ID                  = @ID
			   and DELETED             = 0;
		-- END Oracle Exception
		
		-- Moving down actually means incrementing the order value. 
		-- BEGIN Oracle Exception
			select @SWAP_ID           = ID
			  from DYNAMIC_BUTTONS
			 where VIEW_NAME          = @VIEW_NAME
			   and CONTROL_INDEX     = @CONTROL_INDEX + 1
			   and DELETED            = 0;
		-- END Oracle Exception
		if dbo.fnIsEmptyGuid(@SWAP_ID) = 0 begin -- then
			-- BEGIN Oracle Exception
				update DYNAMIC_BUTTONS
				   set CONTROL_INDEX      = CONTROL_INDEX + 1
				     , DATE_MODIFIED      = getdate()
				     , DATE_MODIFIED_UTC= getutcdate()
				     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
				 where ID                 = @ID;
			-- END Oracle Exception
			-- BEGIN Oracle Exception
				update DYNAMIC_BUTTONS
				   set CONTROL_INDEX      = CONTROL_INDEX - 1
				     , DATE_MODIFIED      = getdate()
				     , DATE_MODIFIED_UTC= getutcdate()
				     , MODIFIED_USER_ID   = @MODIFIED_USER_ID
				 where ID                 = @SWAP_ID;
			-- END Oracle Exception
		end -- if;
	end -- if;
  end
GO

Grant Execute on dbo.spDYNAMIC_BUTTONS_ORDER_MoveDown to public;
GO

