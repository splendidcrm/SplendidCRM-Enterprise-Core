if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'spMODULES_TAB_HideMobile' and ROUTINE_TYPE = 'PROCEDURE')
	Drop Procedure dbo.spMODULES_TAB_HideMobile;
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
-- 04/21/2009 Paul.  Correct any ordering problems. 
-- 09/13/2010 Paul.  If the data is bad, then the there may be more than one record with the tab order 
-- so make sure to only return one record. 
Create Procedure dbo.spMODULES_TAB_HideMobile
	( @ID               uniqueidentifier
	, @MODIFIED_USER_ID uniqueidentifier
	)
as
  begin
	set nocount on
	
	declare @SWAP_ID    uniqueidentifier;
	declare @TAB_ORDER  int;
	if exists(select * from MODULES where ID = @ID and DELETED = 0) begin -- then
		-- 11/17/2007 Paul.  First disable, then only reset the tab order if not visible on mobile. 
		-- BEGIN Oracle Exception
			update MODULES
			   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
			     , DATE_MODIFIED     =  getdate()        
			     , DATE_MODIFIED_UTC =  getutcdate()     
			     , MOBILE_ENABLED    = 0
			 where ID                = @ID
			   and DELETED           = 0;
		-- END Oracle Exception

		if exists(select * from MODULES where ID = @ID and TAB_ENABLED = 0 and MOBILE_ENABLED = 0 and DELETED = 0) begin -- then
			-- BEGIN Oracle Exception
				select @TAB_ORDER = TAB_ORDER
				  from MODULES
				 where ID          = @ID
				   and DELETED     = 0;
			-- END Oracle Exception
			
			-- 01/04/2006 Paul.  Hidden modules get an order of 0. 
			-- BEGIN Oracle Exception
				update MODULES
				   set MODIFIED_USER_ID  = @MODIFIED_USER_ID 
				     , DATE_MODIFIED     =  getdate()        
				     , DATE_MODIFIED_UTC =  getutcdate()     
				     , TAB_ORDER         = 0
				 where ID                = @ID
				   and DELETED           = 0;
			-- END Oracle Exception
			
			-- BEGIN Oracle Exception
				-- 09/13/2010 Paul.  If the data is bad, then the there may be more than one record with the tab order 
				-- so make sure to only return one record. 
				select top 1 @SWAP_ID   = ID
				  from MODULES
				 where TAB_ORDER  = @TAB_ORDER
				   and DELETED    = 0
				 order by TAB_ORDER;
			-- END Oracle Exception
	
			-- 01/04/2006 Paul.  Shift all modules down, but only if there is no duplicate order value. 
			if dbo.fnIsEmptyGuid(@SWAP_ID) = 1 begin -- then
				-- BEGIN Oracle Exception
					update MODULES
					   set TAB_ORDER = TAB_ORDER - 1
					 where TAB_ORDER > @TAB_ORDER
					   and DELETED = 0;
				-- END Oracle Exception
			end -- if;
		end -- if;

		-- 04/21/2009 Paul.  Correct any ordering problems. 
		exec dbo.spMODULES_TAB_ORDER_Reorder @MODIFIED_USER_ID;
	end -- if;
  end
GO

Grant Execute on dbo.spMODULES_TAB_HideMobile to public;
GO

